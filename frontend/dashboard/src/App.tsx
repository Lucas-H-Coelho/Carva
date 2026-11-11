// App — shell do dashboard (sidebar + canvas) e rotas de serviços.

import { Link, NavLink, Navigate, Outlet, Route, Routes } from 'react-router-dom'
import { ServicesPage } from './pages/services/ServicesPage'
import { ServiceForm } from './components/services/ServiceForm'
import { ServiceDetail } from './components/services/ServiceDetail'
import './App.css'

function Sidebar() {
  return (
    <aside className="sidebar">
      <div className="brand">
        <span className="brand-mark" aria-hidden="true" />
        <span className="brand-name">Carva</span>
      </div>
      <nav aria-label="Seções do painel">
        <ul className="nav-list">
          <li>
            <NavLink
              to="/services"
              className={({ isActive }) => (isActive ? 'nav-link nav-link-active' : 'nav-link')}
            >
              Serviços
            </NavLink>
          </li>
        </ul>
      </nav>
      <div className="sidebar-footer">
        <span className="scope-label">Painel do lava-carro</span>
      </div>
    </aside>
  )
}

function Shell() {
  return (
    <div className="shell">
      <a href="#main-canvas" className="skip-link">
        Ir para o conteúdo
      </a>
      <Sidebar />
      <main id="main-canvas" className="canvas">
        <Outlet />
      </main>
    </div>
  )
}

function NotFound() {
  return (
    <>
      <h1 className="page-title">Página não encontrada</h1>
      <p className="secondary">O endereço acessado não existe neste painel.</p>
      <Link to="/services" className="btn btn-ghost">
        Voltar para Serviços
      </Link>
    </>
  )
}

export function App() {
  return (
    <Routes>
      <Route element={<Shell />}>
        <Route path="/" element={<Navigate to="/services" replace />} />
        <Route path="/services" element={<ServicesPage />} />
        <Route path="/services/new" element={<ServiceForm mode="create" />} />
        <Route path="/services/:id" element={<ServiceDetail />} />
        <Route path="/services/:id/edit" element={<ServiceForm mode="edit" />} />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  )
}

export default App
