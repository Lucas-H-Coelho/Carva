// Zustand store — CRUD de serviços do tenant.
// Estado: lista, paginação, loading, error. Actions chamam api/services.ts.

import { create } from 'zustand'
import {
  listServices,
  createService,
  updateService,
  deleteService,
  toggleActive,
  type Service,
  type ServiceInput,
} from '../api/services'
import { ApiError } from '../api/client'

const PER_PAGE = 25

interface ServicesState {
  services: Service[]
  page: number
  perPage: number
  hasNext: boolean
  loading: boolean
  error: string | null
  fetchServices: (page?: number) => Promise<void>
  createService: (input: ServiceInput) => Promise<Service>
  updateService: (id: string, input: ServiceInput) => Promise<Service>
  removeService: (id: string) => Promise<void>
  toggleActive: (id: string) => Promise<void>
  clearError: () => void
}

function errorMessage(err: unknown): string {
  if (err instanceof ApiError) return err.message
  return 'Algo deu errado. Tente novamente.'
}

export const useServicesStore = create<ServicesState>((set, get) => ({
  services: [],
  page: 1,
  perPage: PER_PAGE,
  hasNext: false,
  loading: false,
  error: null,

  async fetchServices(page = get().page) {
    set({ loading: true, error: null })
    try {
      const { services } = await listServices(page, get().perPage)
      set({ services, page, hasNext: services.length === get().perPage, loading: false })
    } catch (err) {
      set({ loading: false, error: errorMessage(err) })
    }
  },

  async createService(input) {
    const service = await createService(input)
    set((s) => ({ services: [service, ...s.services] }))
    return service
  },

  async updateService(id, input) {
    const service = await updateService(id, input)
    set((s) => ({ services: s.services.map((x) => (x.id === id ? service : x)) }))
    return service
  },

  async removeService(id) {
    const previous = get().services
    set((s) => ({ services: s.services.filter((x) => x.id !== id), error: null }))
    try {
      await deleteService(id)
    } catch (err) {
      set({ services: previous, error: errorMessage(err) })
      throw err
    }
  },

  async toggleActive(id) {
    const previous = get().services
    const target = previous.find((x) => x.id === id)
    if (target) {
      set((s) => ({
        services: s.services.map((x) => (x.id === id ? { ...x, active: !x.active } : x)),
        error: null,
      }))
    }
    try {
      const service = await toggleActive(id)
      set((s) => ({ services: s.services.map((x) => (x.id === id ? service : x)) }))
    } catch (err) {
      set({ services: previous, error: errorMessage(err) })
      throw err
    }
  },

  clearError() {
    set({ error: null })
  },
}))
