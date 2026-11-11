// Schema Zod do formulário de serviço (zod 3.x).
// Regras espelham CarvaInventory::ServiceForm do backend.

import { z } from 'zod'

/** Duração em minutos: inteiro > 0, opcional (backend usa default 30).
 *  Campo vazio (string vazia ou NaN de valueAsNumber) → undefined. */
const durationField = z.preprocess(
  (val) => (val === '' || val === null || Number.isNaN(val) ? undefined : val),
  z
    .number({ invalid_type_error: 'Duração deve ser um número' })
    .int('Duração deve ser um número inteiro')
    .positive('Duração deve ser maior que zero'),
)

export const serviceSchema = z.object({
  name: z.string()
    .min(1, 'Nome é obrigatório')
    .max(255, 'Nome deve ter no máximo 255 caracteres'),
  slug: z.string()
    .max(255, 'Slug deve ter no máximo 255 caracteres')
    .optional(),
  description: z.string()
    .max(2000, 'Descrição deve ter no máximo 2000 caracteres')
    .optional(),
  duration_minutes: durationField.optional(),
  price_reais: z.string()
    .max(20, 'Preço deve ter no máximo 20 caracteres')
    .optional(),
  category: z.string()
    .max(100, 'Categoria deve ter no máximo 100 caracteres')
    .optional(),
  active: z.boolean().optional(),
})

export type ServiceFormValues = z.infer<typeof serviceSchema>

export interface ServiceSubmitInput {
  name: string
  slug?: string
  description?: string
  duration_minutes?: number
  price_cents?: number
  category?: string
  active?: boolean
}

/** Converte "1.234,56" (pt-BR) em cents. Vazio → omitir o campo.
 *  inválido → invalid: true. */
export function parseReais(raw: string | undefined): { cents: number | undefined; invalid: boolean } {
  const trimmed = raw?.trim()
  if (!trimmed) return { cents: undefined, invalid: false }
  const normalized = trimmed.replace(/\./g, '').replace(',', '.')
  const n = Number(normalized)
  if (!Number.isFinite(n) || n < 0) return { cents: undefined, invalid: true }
  return { cents: Math.round(n * 100), invalid: false }
}

/** Converte values do formulário para o corpo da API (price_reais → price_cents). */
export function formValuesToInput(values: ServiceFormValues, priceCents: number | undefined): ServiceSubmitInput {
  return {
    name: values.name,
    slug: values.slug,
    description: values.description,
    duration_minutes: values.duration_minutes,
    price_cents: priceCents,
    category: values.category,
    active: values.active,
  }
}
