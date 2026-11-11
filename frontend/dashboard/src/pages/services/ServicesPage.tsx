// ServicesPage — container da rota /services: título, ação primária, lista.

import { useEffect } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { ServicesList } from '../../components/services/ServicesList'
import { useServicesStore } from '../../stores/servicesStore'

export function ServicesPage() {
  const navigate = useNavigate()
  const { services, loading, error, page, hasNext, fetchServices, toggleActive, removeService } =
    useServicesStore()

  useEffect(() => {
    fetchServices(1)
  }, [fetchServices])

  const subline = loading
    ? 'Carregando serviços…'
    : `Exibindo ${String(services.length)} serviços${page > 1 ? ` · página ${String(page)}` : ''}`

  return (
    <>
      <div className="title-row">
        <div>
          <h1 className="page-title">Serviços</h1>
          <p className="page-sub">{subline}</p>
        </div>
        <div className="title-actions">
          <Link to="/services/new" className="btn btn-primary">
            Novo serviço
          </Link>
        </div>
      </div>

      <ServicesList
        services={services}
        loading={loading}
        error={error}
        page={page}
        hasNext={hasNext}
        onRetry={() => fetchServices(page)}
        onPrev={() => fetchServices(Math.max(1, page - 1))}
        onNext={() => fetchServices(page + 1)}
        onToggle={(s) => {
          toggleActive(s.id).catch(() => {
            /* store já registrou o erro; a lista o exibe */
          })
        }}
        onDelete={(s) => {
          removeService(s.id).catch(() => {
            /* store já registrou o erro; a lista o exibe */
          })
        }}
        onCreate={() => navigate('/services/new')}
      />
    </>
  )
}

export default ServicesPage
