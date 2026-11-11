// ServicesList — tabela de serviços com paginação, toggle, exclusão confirmada.
// Presentational: recebe dados e callbacks; a confirmação de exclusão usa <dialog>.

import { useEffect, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { formatBRL, type Service } from '../../api/services'

export interface ServicesListProps {
  services: Service[]
  loading: boolean
  error: string | null
  page: number
  hasNext: boolean
  onRetry: () => void
  onPrev: () => void
  onNext: () => void
  onToggle: (service: Service) => void
  onDelete: (service: Service) => void
  onCreate: () => void
}

function SkeletonRows() {
  return (
    <div className="skeleton-list" aria-hidden="true">
      {Array.from({ length: 6 }).map((_, i) => (
        <div key={i} className="skeleton-row">
          <span className="skeleton skeleton--name" />
          <span className="skeleton skeleton--cell" />
          <span className="skeleton skeleton--cell" />
          <span className="skeleton skeleton--cell" />
        </div>
      ))}
    </div>
  )
}

export function ServicesList(props: ServicesListProps) {
  const { services, loading, error, page, hasNext, onRetry, onPrev, onNext, onToggle, onDelete, onCreate } = props

  const [pendingDelete, setPendingDelete] = useState<Service | null>(null)
  const dialogRef = useRef<HTMLDialogElement>(null)

  useEffect(() => {
    const dialog = dialogRef.current
    if (!dialog) return
    if (pendingDelete) {
      if (!dialog.open) dialog.showModal()
    } else if (dialog.open) {
      dialog.close()
    }
  }, [pendingDelete])

  if (error) {
    return (
      <div className="error-block" role="alert">
        <p className="error-block-title">Não foi possível carregar os serviços.</p>
        <p className="error-block-detail">{error}</p>
        <button type="button" className="btn btn-ghost" onClick={onRetry}>
          Tentar novamente
        </button>
      </div>
    )
  }

  if (loading) {
    return (
      <div className="card card--table" aria-busy="true" aria-label="Carregando serviços">
        <SkeletonRows />
      </div>
    )
  }

  if (services.length === 0) {
    return (
      <div className="empty-block" role="status">
        <p className="empty-title">Nenhum serviço cadastrado.</p>
        <p className="empty-detail">Crie o primeiro serviço para que os clientes possam agendar pelo site.</p>
        <button type="button" className="btn btn-primary" onClick={onCreate}>
          Novo serviço
        </button>
      </div>
    )
  }

  return (
    <>
      <div className="card card--table">
        <table className="svc-table" aria-label="Lista de serviços">
          <thead>
            <tr>
              <th scope="col">Serviço</th>
              <th scope="col" className="num">Duração</th>
              <th scope="col" className="num">Preço</th>
              <th scope="col">Categoria</th>
              <th scope="col">Status</th>
              <th scope="col" className="actions-col">Ações</th>
            </tr>
          </thead>
          <tbody>
            {services.map((s) => (
              <tr key={s.id}>
                <td data-label="Serviço">
                  <Link to={`/services/${s.id}`} className="link-name">
                    {s.name}
                  </Link>
                </td>
                <td data-label="Duração" className="num">
                  {s.duration_minutes} min
                </td>
                <td data-label="Preço" className="num">
                  {formatBRL(s.price_cents)}
                </td>
                <td data-label="Categoria" className="secondary">
                  {s.category ? s.category : '—'}
                </td>
                <td data-label="Status">
                  {s.active ? (
                    <span className="pill pill-active">Ativo</span>
                  ) : (
                    <span className="pill pill-inactive">Inativo</span>
                  )}
                </td>
                <td data-label="Ações" className="actions-col">
                  <Link to={`/services/${s.id}/edit`} className="btn-text" aria-label={`Editar ${s.name}`}>
                    Editar
                  </Link>
                  <button
                    type="button"
                    className="btn-text"
                    onClick={() => onToggle(s)}
                    aria-label={`${s.active ? 'Desativar' : 'Ativar'} ${s.name}`}
                  >
                    {s.active ? 'Desativar' : 'Ativar'}
                  </button>
                  <button
                    type="button"
                    className="btn-text btn-text-danger"
                    onClick={() => setPendingDelete(s)}
                    aria-label={`Excluir ${s.name}`}
                  >
                    Excluir
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <nav className="pagination" aria-label="Paginação de serviços">
        <button
          type="button"
          className="btn btn-ghost"
          onClick={onPrev}
          disabled={page <= 1}
          aria-label="Página anterior"
        >
          Anterior
        </button>
        <span className="pagination-info">
          Página {page} · {services.length} serviços
        </span>
        <button
          type="button"
          className="btn btn-ghost"
          onClick={onNext}
          disabled={!hasNext}
          aria-label="Próxima página"
        >
          Próxima
        </button>
      </nav>

      <dialog
        ref={dialogRef}
        className="confirm-dialog"
        aria-labelledby="confirm-delete-title"
        onClose={() => setPendingDelete(null)}
      >
        <h2 id="confirm-delete-title" className="confirm-title">
          Excluir serviço
        </h2>
        <p className="confirm-detail">
          Esta ação é permanente. O serviço <strong>{pendingDelete?.name}</strong> será excluído do catálogo.
        </p>
        <div className="confirm-actions">
          <button
            type="button"
            className="btn btn-ghost"
            onClick={() => setPendingDelete(null)}
          >
            Cancelar
          </button>
          <button
            type="button"
            className="btn btn-danger"
            onClick={() => {
              if (pendingDelete) {
                onDelete(pendingDelete)
                setPendingDelete(null)
              }
            }}
          >
            Excluir
          </button>
        </div>
      </dialog>
    </>
  )
}
