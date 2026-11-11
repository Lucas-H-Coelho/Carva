// ServiceDetail — detalhe de um serviço: key-values, editar, toggle, excluir.

import { useEffect, useRef, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { formatBRL, getService, type Service } from '../../api/services'
import { useServicesStore } from '../../stores/servicesStore'
import { ApiError } from '../../api/client'

export function ServiceDetail() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const toggleActive = useServicesStore((s) => s.toggleActive)
  const removeService = useServicesStore((s) => s.removeService)

  const [service, setService] = useState<Service | null>(null)
  const [loading, setLoading] = useState(true)
  const [fetchError, setFetchError] = useState<string | null>(null)
  const [actionError, setActionError] = useState<string | null>(null)
  const [confirmDelete, setConfirmDelete] = useState(false)
  const dialogRef = useRef<HTMLDialogElement>(null)

  useEffect(() => {
    if (!id) return
    setLoading(true)
    getService(id)
      .then((s) => {
        setService(s)
        setLoading(false)
      })
      .catch((err: unknown) => {
        setFetchError(err instanceof ApiError ? err.message : 'Não foi possível carregar o serviço.')
        setLoading(false)
      })
  }, [id])

  useEffect(() => {
    const dialog = dialogRef.current
    if (!dialog) return
    if (confirmDelete) {
      if (!dialog.open) dialog.showModal()
    } else if (dialog.open) {
      dialog.close()
    }
  }, [confirmDelete])

  if (!id) {
    return (
      <div className="error-block" role="alert">
        <p className="error-block-title">Serviço não encontrado.</p>
        <Link to="/services" className="btn btn-ghost">
          Voltar para a lista
        </Link>
      </div>
    )
  }

  if (loading) {
    return (
      <div className="card" aria-busy="true" aria-label="Carregando serviço">
        <div className="skeleton-list">
          {Array.from({ length: 6 }).map((_, i) => (
            <span key={i} className="skeleton skeleton--field" />
          ))}
        </div>
      </div>
    )
  }

  if (fetchError || !service) {
    return (
      <>
        <nav className="breadcrumb" aria-label="Breadcrumb">
          <Link to="/services" className="breadcrumb-link">
            Serviços
          </Link>
          <span className="breadcrumb-sep" aria-hidden="true">
            /
          </span>
          <span className="breadcrumb-current">Detalhe</span>
        </nav>
        <h1 className="page-title">Detalhe do serviço</h1>
        <div className="error-block" role="alert">
          <p className="error-block-title">Não foi possível carregar o serviço.</p>
          <p className="error-block-detail">{fetchError ?? 'O serviço pode ter sido excluído.'}</p>
          <Link to="/services" className="btn btn-ghost">
            Voltar para a lista
          </Link>
        </div>
      </>
    )
  }

  const handleToggle = () => {
    setActionError(null)
    toggleActive(service.id).catch((err: unknown) => {
      setActionError(err instanceof ApiError ? err.message : 'Não foi possível atualizar o serviço.')
    })
  }

  const handleDelete = () => {
    setActionError(null)
    removeService(service.id)
      .then(() => navigate('/services'))
      .catch((err: unknown) => {
        setActionError(err instanceof ApiError ? err.message : 'Não foi possível excluir o serviço.')
        setConfirmDelete(false)
      })
  }

  return (
    <>
      <nav className="breadcrumb" aria-label="Breadcrumb">
        <Link to="/services" className="breadcrumb-link">
          Serviços
        </Link>
        <span className="breadcrumb-sep" aria-hidden="true">
          /
        </span>
        <span className="breadcrumb-current">{service.name}</span>
      </nav>
      <div className="title-row">
        <div>
          <h1 className="page-title">{service.name}</h1>
          <p className="page-sub">
            {service.duration_minutes} min · {formatBRL(service.price_cents)}
          </p>
        </div>
        <div className="title-actions">
          <Link to={`/services/${service.id}/edit`} className="btn btn-ghost">
            Editar
          </Link>
          <button
            type="button"
            className="btn btn-ghost"
            onClick={handleToggle}
            aria-pressed={service.active}
            aria-label={`${service.active ? 'Desativar' : 'Ativar'} ${service.name}`}
          >
            {service.active ? 'Desativar' : 'Ativar'}
          </button>
          <button
            type="button"
            className="btn btn-danger-outline"
            onClick={() => setConfirmDelete(true)}
            aria-label={`Excluir ${service.name}`}
          >
            Excluir
          </button>
        </div>
      </div>

      {actionError && (
        <div className="form-banner" role="alert" aria-live="polite">
          <p className="form-banner-title">{actionError}</p>
        </div>
      )}

      <div className="card">
        <dl className="kv-list">
          <div className="kv-row">
            <dt className="kv-label">Status</dt>
            <dd className="kv-value">
              {service.active ? (
                <span className="pill pill-active">Ativo</span>
              ) : (
                <span className="pill pill-inactive">Inativo</span>
              )}
            </dd>
          </div>
          <div className="kv-row">
            <dt className="kv-label">Slug</dt>
            <dd className="kv-value">{service.slug}</dd>
          </div>
          <div className="kv-row">
            <dt className="kv-label">Duração</dt>
            <dd className="kv-value num">{service.duration_minutes} min</dd>
          </div>
          <div className="kv-row">
            <dt className="kv-label">Preço</dt>
            <dd className="kv-value num">{formatBRL(service.price_cents)}</dd>
          </div>
          <div className="kv-row">
            <dt className="kv-label">Categoria</dt>
            <dd className="kv-value">{service.category ? service.category : '—'}</dd>
          </div>
        </dl>
      </div>

      <div className="card">
        <h2 className="card-title">Descrição</h2>
        {service.description ? (
          <p className="description-text">{service.description}</p>
        ) : (
          <p className="secondary">Sem descrição.</p>
        )}
      </div>

      <dialog
        ref={dialogRef}
        className="confirm-dialog"
        aria-labelledby="detail-confirm-title"
        onClose={() => setConfirmDelete(false)}
      >
        <h2 id="detail-confirm-title" className="confirm-title">
          Excluir serviço
        </h2>
        <p className="confirm-detail">
          Esta ação é permanente. O serviço <strong>{service.name}</strong> será excluído do catálogo.
        </p>
        <div className="confirm-actions">
          <button
            type="button"
            className="btn btn-ghost"
            onClick={() => setConfirmDelete(false)}
          >
            Cancelar
          </button>
          <button
            type="button"
            className="btn btn-danger"
            onClick={handleDelete}
          >
            Excluir
          </button>
        </div>
      </dialog>
    </>
  )
}
