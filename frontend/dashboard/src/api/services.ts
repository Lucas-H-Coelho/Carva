// Cliente da API admin de serviços (JSON:API).
// Endpoints: /api/v1/admin/services (+ :id, :id/toggle_active).

import { apiGet, apiPost, apiPatch, apiDelete, type JsonApiResource, type JsonApiMeta } from './client'

export interface Service {
  id: string
  name: string
  slug: string
  description: string | null
  duration_minutes: number
  price_cents: number
  category: string | null
  active: boolean
}

export interface ServiceInput {
  name: string
  slug?: string
  description?: string
  duration_minutes?: number
  price_cents?: number
  category?: string
  active?: boolean
}

interface ServiceAttributes {
  name: string
  slug: string
  description: string | null
  duration_minutes: number
  price_cents: number
  category: string | null
  active: boolean
}

function toService(resource: JsonApiResource<ServiceAttributes>): Service {
  const a = resource.attributes
  return {
    id: String(resource.id),
    name: a.name,
    slug: a.slug,
    description: a.description ?? null,
    duration_minutes: a.duration_minutes ?? 30,
    price_cents: a.price_cents ?? 0,
    category: a.category ?? null,
    active: a.active ?? true,
  }
}

/** Remove chaves undefined/vazias para o corpo da requisição. */
function toBody(input: ServiceInput): Record<string, string | number | boolean> {
  const body: Record<string, string | number | boolean> = { name: input.name }
  if (input.slug !== undefined && input.slug !== '') body.slug = input.slug
  if (input.description !== undefined && input.description !== '') body.description = input.description
  if (input.duration_minutes !== undefined) body.duration_minutes = input.duration_minutes
  if (input.price_cents !== undefined) body.price_cents = input.price_cents
  if (input.category !== undefined && input.category !== '') body.category = input.category
  if (input.active !== undefined) body.active = input.active
  return body
}

export interface ServiceListResult {
  services: Service[]
  meta?: JsonApiMeta
}

export async function listServices(page: number, perPage: number): Promise<ServiceListResult> {
  const res = await apiGet<JsonApiResource<ServiceAttributes>[]>(
    `/admin/services?page=${String(page)}&per_page=${String(perPage)}`,
  )
  const items = Array.isArray(res.data) ? res.data : []
  return { services: items.map(toService), meta: res.meta }
}

export async function getService(id: string): Promise<Service> {
  const res = await apiGet<JsonApiResource<ServiceAttributes>>(`/admin/services/${id}`)
  return toService(res.data)
}

export async function createService(input: ServiceInput): Promise<Service> {
  const res = await apiPost<JsonApiResource<ServiceAttributes>>('/admin/services', toBody(input))
  return toService(res.data)
}

export async function updateService(id: string, input: ServiceInput): Promise<Service> {
  const res = await apiPatch<JsonApiResource<ServiceAttributes>>(`/admin/services/${id}`, toBody(input))
  return toService(res.data)
}

export async function deleteService(id: string): Promise<void> {
  await apiDelete(`/admin/services/${id}`)
}

export async function toggleActive(id: string): Promise<Service> {
  const res = await apiPost<JsonApiResource<ServiceAttributes>>(`/admin/services/${id}/toggle_active`, {})
  return toService(res.data)
}

const brlFormatter = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' })

/** Cents → "R$ 1.234,56" (pt-BR). */
export function formatBRL(cents: number): string {
  return brlFormatter.format(cents / 100)
}

/** Cents → string decinal pt-BR para o campo de preço do formulário ("1234,56"). */
export function centsToReais(cents: number): string {
  return (cents / 100).toFixed(2).replace('.', ',')
}
