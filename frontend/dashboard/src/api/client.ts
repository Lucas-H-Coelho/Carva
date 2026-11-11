// Fetch wrapper para a API Carva (JSON:API + JWT Bearer).
//
// Base URL: padrão `/api/v1` (mesma origem — produção). Em dev, a vite
// config atual (frontend/dashboard/vite.config.js) NÃO tem proxy, então
// defina VITE_API_BASE_URL no .env local, por exemplo:
//   VITE_API_BASE_URL=http://localhost:3000/api/v1
// Token JWT: lido de `localStorage['carva_token'] (sessão de login).

const API_BASE: string = (import.meta.env.VITE_API_BASE_URL as string | undefined) ?? '/api/v1'

export interface ApiErrorEntry {
  status: number
  title: string
  detail: string
  pointer?: string
}

export interface JsonApiResource<TAttributes = Record<string, unknown>> {
  id: string | number
  type: string
  attributes: TAttributes
}

export interface JsonApiPageMeta {
  current: number
  total: number
  per_page: number
}

export interface JsonApiMeta {
  version: string
  page?: JsonApiPageMeta
}

export interface ApiResult<TData> {
  data: TData
  meta?: JsonApiMeta
}

/** Erro tipado: status HTTP + entradas JSON:API `errors[]`. */
export class ApiError extends Error {
  readonly status: number
  readonly errors: ApiErrorEntry[]

  constructor(status: number, errors: ApiErrorEntry[]) {
    const first = errors[0]
    super(first ? (first.detail && first.detail !== first.title ? `${first.title} — ${first.detail}` : first.title) : 'Erro de requisição')
    this.name = 'ApiError'
    this.status = status
    this.errors = errors
  }
}

function defaultMessageFor(status: number): string {
  switch (status) {
    case 400:
      return 'Requisição inválida'
    case 401:
      return 'Não autorizado — faça login novamente'
    case 403:
      return 'Acesso proibido'
    case 404:
      return 'Não encontrado'
    case 422:
      return 'Dados inválidos'
    default:
      return `Erro do servidor (${String(status)})`
  }
}

function normalizeErrors(doc: unknown, status: number): ApiErrorEntry[] {
  if (doc && typeof doc === 'object' && Array.isArray((doc as { errors?: unknown }).errors)) {
    const list = (doc as { errors: Array<Record<string, unknown>> }).errors
    if (list.length > 0) {
      return list.map((entry) => {
        const title = typeof entry.title === 'string' ? entry.title : defaultMessageFor(status)
        const source = entry.source
        const pointer = source && typeof source === 'object' && typeof (source as { pointer?: unknown }).pointer === 'string'
          ? (source as { pointer: string }).pointer
          : undefined
        return {
          status: Number(entry.status ?? status),
          title,
          detail: typeof entry.detail === 'string' ? entry.detail : title,
          pointer,
        }
      })
    }
  }
  const fallback = defaultMessageFor(status)
  return [{ status, title: fallback, detail: fallback }]
}

async function request<TData>(path: string, init: { method: string; body?: string }): Promise<ApiResult<TData>> {
  const token = localStorage.getItem('carva_token')
  const headers: Record<string, string> = { Accept: 'application/json' }
  if (token) headers.Authorization = `Bearer ${token}`
  if (init.body !== undefined) headers['Content-Type'] = 'application/json'

  let response: Response
  try {
    response = await fetch(`${API_BASE}${path}`, { method: init.method, headers, body: init.body })
  } catch {
    const detail = 'Não foi possível conectar ao servidor. Verifique se a API está em execução.'
    throw new ApiError(0, [{ status: 0, title: 'Falha de conexão', detail }])
  }

  if (response.status === 204) {
    return { data: null as TData }
  }

  let doc: unknown = null
  try {
    doc = await response.json()
  } catch {
    doc = null
  }

  if (!response.ok) {
    throw new ApiError(response.status, normalizeErrors(doc, response.status))
  }

  const envelope = doc as { data?: TData; meta?: JsonApiMeta } | null
  return { data: envelope?.data as TData, meta: envelope?.meta }
}

export function apiGet<TData>(path: string): Promise<ApiResult<TData>> {
  return request<TData>(path, { method: 'GET' })
}

export function apiPost<TData>(path: string, body: Record<string, string | number | boolean>): Promise<ApiResult<TData>> {
  return request<TData>(path, { method: 'POST', body: JSON.stringify(body) })
}

export function apiPatch<TData>(path: string, body: Record<string, string | number | boolean>): Promise<ApiResult<TData>> {
  return request<TData>(path, { method: 'PATCH', body: JSON.stringify(body) })
}

export function apiDelete(path: string): Promise<void> {
  return request<null>(path, { method: 'DELETE' }).then(() => undefined)
}
