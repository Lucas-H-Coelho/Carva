// ServiceForm — formulário de criação e edição de serviço.
// React Hook Form + zodResolver; erros 422 do backend inline + banner.

import { useEffect, useState, type ReactNode } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import {
  serviceSchema,
  formValuesToInput,
  parseReais,
  type ServiceFormValues,
} from '../../schemas/service'
import { useServicesStore } from '../../stores/servicesStore'
import { getService, centsToReais, type Service } from '../../api/services'
import { ApiError } from '../../api/client'

export interface ServiceFormProps {
  mode: 'create' | 'edit'
}

type FieldName = 'name' | 'slug' | 'description' | 'duration_minutes' | 'price_reais' | 'category'

/** Mapeia a primeira palavra da mensagem ActiveModel ("Name is too long…") para o campo. */
function fieldForTitle(title: string): FieldName | null {
  const first = title.split(' ')[0]?.toLowerCase()
  switch (first) {
    case 'name':
      return 'name'
    case 'slug':
      return 'slug'
    case 'duration':
      return 'duration_minutes'
    case 'price':
      return 'price_reais'
    case 'category':
      return 'category'
    default:
      return null
  }
}

const createDefaults: ServiceFormValues = {
  name: '',
  slug: '',
  description: '',
  category: '',
  active: true,
}

function PageHead(props: { isEdit: boolean; current: string }): ReactNode {
  return (
    <>
      <nav className="breadcrumb" aria-label="Breadcrumb">
        <Link to="/services" className="breadcrumb-link">
          Serviços
        </Link>
        <span className="breadcrumb-sep" aria-hidden="true">
          /
        </span>
        <span className="breadcrumb-current">{props.current}</span>
      </nav>
      <h1 className="page-title">{props.isEdit ? 'Editar serviço' : 'Novo serviço'}</h1>
    </>
  )
}

export function ServiceForm({ mode }: ServiceFormProps) {
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()
  const createService = useServicesStore((s) => s.createService)
  const updateService = useServicesStore((s) => s.updateService)

  const [service, setService] = useState<Service | null>(null)
  const [fetchError, setFetchError] = useState<string | null>(null)
  const [serverErrors, setServerErrors] = useState<string[]>([])

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
    setError,
  } = useForm<ServiceFormValues>({
    resolver: zodResolver(serviceSchema),
    defaultValues: createDefaults,
  })

  useEffect(() => {
    if (mode !== 'edit' || !id) return
    getService(id)
      .then((s) => {
        setService(s)
        reset({
          name: s.name,
          slug: s.slug,
          description: s.description ?? '',
          duration_minutes: s.duration_minutes,
          price_reais: centsToReais(s.price_cents),
          category: s.category ?? '',
          active: s.active,
        })
      })
      .catch((err: unknown) => {
        setFetchError(err instanceof ApiError ? err.message : 'Não foi possível carregar o serviço.')
      })
  }, [mode, id, reset])

  const onSubmit = async (values: ServiceFormValues) => {
    setServerErrors([])
    const price = parseReais(values.price_reais)
    if (price.invalid) {
      setError('price_reais', { type: 'server', message: 'Preço deve ser um número (ex.: 100,00)' })
      return
    }
    const input = formValuesToInput(values, price.cents)
    try {
      if (mode === 'create') {
        const created = await createService(input)
        navigate(`/services/${created.id}`)
      } else {
        if (!id) return
        const updated = await updateService(id, input)
        navigate(`/services/${updated.id}`)
      }
    } catch (err) {
      if (err instanceof ApiError) {
        const titles = err.errors.map((e) => e.title)
        setServerErrors(titles)
        for (const title of titles) {
          const field = fieldForTitle(title)
          if (field) {
            setError(field, { type: 'server', message: title })
          }
        }
      } else {
        setServerErrors(['Não foi possível salvar. Tente novamente.'])
      }
    }
  }

  const isEdit = mode === 'edit'

  if (mode === 'edit' && fetchError) {
    return (
      <>
        <PageHead isEdit current="Editar" />
        <div className="error-block" role="alert">
          <p className="error-block-title">Não foi possível carregar o serviço.</p>
          <p className="error-block-detail">{fetchError}</p>
          <Link to="/services" className="btn btn-ghost">
            Voltar para a lista
          </Link>
        </div>
      </>
    )
  }

  if (mode === 'edit' && !service) {
    return (
      <>
        <PageHead isEdit current="Editar" />
        <div className="card" aria-busy="true" aria-label="Carregando formulário">
          <div className="skeleton-list">
            {Array.from({ length: 5 }).map((_, i) => (
              <span key={i} className="skeleton skeleton--field" />
            ))}
          </div>
        </div>
      </>
    )
  }

  return (
    <>
      <PageHead isEdit={isEdit} current={isEdit ? (service?.name ?? 'Editar') : 'Novo'} />
      <form className="card form-card" onSubmit={handleSubmit(onSubmit)} noValidate>
        {serverErrors.length > 0 && (
          <div className="form-banner" role="alert" aria-live="polite">
            <p className="form-banner-title">O servidor recusou o salvamento:</p>
            <ul className="form-banner-list">
              {serverErrors.map((t) => (
                <li key={t}>{t}</li>
              ))}
            </ul>
          </div>
        )}

        <div className="field">
          <label className="field-label" htmlFor="svc-name">
            Nome
          </label>
          <input
            id="svc-name"
            className="field-input"
            aria-invalid={errors.name ? true : undefined}
            aria-describedby={errors.name ? 'svc-name-error' : undefined}
            {...register('name')}
          />
          {errors.name && (
            <p id="svc-name-error" className="field-error">
              {errors.name.message}
            </p>
          )}
        </div>

        <div className="field">
          <label className="field-label" htmlFor="svc-slug">
            Slug
          </label>
          <input
            id="svc-slug"
            className="field-input"
            aria-invalid={errors.slug ? true : undefined}
            aria-describedby="svc-slug-help"
            {...register('slug')}
          />
          <p id="svc-slug-help" className="field-help">
            Deixe em branco para gerar automaticamente a partir do nome.
          </p>
          {errors.slug && (
            <p className="field-error" aria-live="polite">
              {errors.slug.message}
            </p>
          )}
        </div>

        <div className="field-row">
          <div className="field">
            <label className="field-label" htmlFor="svc-duration">
              Duração (minutos)
            </label>
            <input
              id="svc-duration"
              className="field-input"
              inputMode="numeric"
              placeholder="30"
              aria-invalid={errors.duration_minutes ? true : undefined}
              aria-describedby="svc-duration-help"
              {...register('duration_minutes', { valueAsNumber: true })}
            />
            <p id="svc-duration-help" className="field-help">
              Inteiro maior que zero. Vazio usa 30 minutos.
            </p>
            {errors.duration_minutes && (
              <p className="field-error" aria-live="polite">
                {String(errors.duration_minutes.message)}
              </p>
            )}
          </div>

          <div className="field">
            <label className="field-label" htmlFor="svc-price">
              Preço (R$)
            </label>
            <input
              id="svc-price"
              className="field-input"
              inputMode="decimal"
              placeholder="100,00"
              aria-invalid={errors.price_reais ? true : undefined}
              aria-describedby="svc-price-help"
              {...register('price_reais')}
            />
            <p id="svc-price-help" className="field-help">
              Use vírgula para centavos. Vazio usa R$ 0,00.
            </p>
            {errors.price_reais && (
              <p className="field-error" aria-live="polite">
                {String(errors.price_reais.message)}
              </p>
            )}
          </div>
        </div>

        <div className="field">
          <label className="field-label" htmlFor="svc-category">
            Categoria
          </label>
          <input
            id="svc-category"
            className="field-input"
            aria-invalid={errors.category ? true : undefined}
            aria-describedby="svc-category-help"
            {...register('category')}
          />
          <p id="svc-category-help" className="field-help">
            Exemplo: Lavagem, Polimento, Higienização.
          </p>
          {errors.category && (
            <p className="field-error" aria-live="polite">
              {errors.category.message}
            </p>
          )}
        </div>

        <div className="field">
          <label className="field-label" htmlFor="svc-description">
            Descrição
          </label>
          <textarea
            id="svc-description"
            className="field-input field-textarea"
            rows={4}
            aria-invalid={errors.description ? true : undefined}
            aria-describedby={errors.description ? 'svc-description-error' : undefined}
            {...register('description')}
          />
          {errors.description && (
            <p id="svc-description-error" className="field-error">
              {errors.description.message}
            </p>
          )}
        </div>

        <div className="field field-toggle">
          <input id="svc-active" className="switch" type="checkbox" {...register('active')} />
          <label className="field-label-toggle" htmlFor="svc-active">
            Ativo
          </label>
          <p className="field-help">
            Serviços ativos aparecem na loja virtual e no agendamento.
          </p>
        </div>

        <div className="form-actions">
          <button type="submit" className="btn btn-primary" disabled={isSubmitting}>
            {isSubmitting ? 'Salvando…' : isEdit ? 'Salvar alterações' : 'Criar serviço'}
          </button>
          <Link to="/services" className="btn btn-ghost">
            Cancelar
          </Link>
        </div>
      </form>
    </>
  )
}
