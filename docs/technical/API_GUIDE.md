# Carva — API Guide

> **Guia da API REST do Carva.** Todas as interações com o sistema devem usar a API versionada.

---

## 1. Visão Geral

| Item | Valor |
|------|-------|
| **Base URL** | `https://api.carva.com/api/v1` (sandbox: `https://api-sandbox.carva.com/api/v1`) |
| **Formato** | JSON (JSON:API compliant) |
| **Autenticação** | API Key via header `X-Carva-API-Key` |
| **Rate Limit** | 1000 req/min por tenant |
| **HTTPS** | Obrigatório |
| **Charset** | UTF-8 |

### 1.1 Estrutura de Namespaces

```
/api/v1/
├── storefront/           # API pública (sem auth)
├── admin/                # API administrativa (auth requerido)
└── webhooks/             # Webhooks do sistema
```

---

## 2. Autenticação

### 2.1 API Key

```bash
curl -X GET https://api.carva.com/api/v1/storefront/products \
  -H "X-Carva-API-Key: sk_live_abc123def456" \
  -H "Content-Type: application/json"
```

### 2.2 Scopes

| Scope | Descrição |
|-------|-----------|
| `read_products` | Ler produtos e serviços |
| `write_products` | Criar/atualizar/excluir produtos |
| `read_bookings` | Ler agendamentos |
| `write_bookings` | Criar/atualizar agendamentos |
| `read_customers` | Ler clientes |
| `write_customers` | Criar/atualizar clientes |
| `read_inventory` | Ler estoque |
| `write_inventory` | Gerenciar estoque |
| `read_reports` | Acessar relatórios |
| `manage_theme` | Gerenciar temas |
| `manage_settings` | Configurar tenant |

### 2.3 Rate Limiting

```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 998
X-RateLimit-Reset: 1700000000
```

---

## 3. Storefront API (Pública)

### 3.1 Produtos / Serviços

```
GET    /api/v1/storefront/products          # Listar produtos
GET    /api/v1/storefront/products/:id      # Ver produto
POST   /api/v1/storefront/products          # Criar produto (admin)
PUT    /api/v1/storefront/products/:id      # Atualizar produto (admin)
DELETE /api/v1/storefront/products/:id      # Excluir produto (admin)
```

#### Listar Produtos

```bash
curl -X GET "https://api.carva.com/api/v1/storefront/products?category=external&page=1" \
  -H "X-Carva-API-Key: sk_live_abc123def456"
```

**Response:**

```json
{
  "data": [
    {
      "type": "product",
      "id": "123",
      "attributes": {
        "name": "Lavagem Completa",
        "description": "Lavagem externa e interna completa",
        "price": 4500,
        "currency": "BRL",
        "duration_minutes": 45,
        "category": "external",
        "available": true,
        "images": [
          {
            "url": "https://cdn.carva.com/tenant123/images/lavagem.jpg",
            "alt": "Lavagem completa"
          }
        ]
      },
      "links": {
        "self": "/api/v1/storefront/products/123"
      }
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

#### Query Parameters

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `category` | string | No | `external`, `internal`, `complete`, `premium` |
| `available` | boolean | No | Filtrar por disponibilidade |
| `sort` | string | No | `price_asc`, `price_desc`, `name_asc`, `name_desc` |
| `page` | integer | No | Página (default: 1) |
| `per_page` | integer | No | Itens por página (default: 20, max: 50) |

### 3.2 Agendamentos

```
GET    /api/v1/storefront/bookings           # Listar agendamentos
POST   /api/v1/storefront/bookings           # Criar agendamento
GET    /api/v1/storefront/bookings/:id       # Ver agendamento
PUT    /api/v1/storefront/bookings/:id       # Atualizar agendamento
DELETE /api/v1/storefront/bookings/:id       # Cancelar agendamento
```

#### Criar Agendamento

```bash
curl -X POST https://api.carva.com/api/v1/storefront/bookings \
  -H "Content-Type: application/json" \
  -H "X-Carva-API-Key: sk_live_abc123def456" \
  -d '{
    "customer_name": "João Silva",
    "customer_email": "joao@email.com",
    "customer_phone": "+5511999999999",
    "service_id": "123",
    "booking_date": "2026-01-15",
    "booking_time": "10:00",
    "vehicle_type": "sedan",
    "vehicle_plate": "ABC-1234"
  }'
```

**Response:**

```json
{
  "data": {
    "type": "booking",
    "id": "456",
    "attributes": {
      "status": "confirmed",
      "customer_name": "João Silva",
      "customer_email": "joao@email.com",
      "customer_phone": "+5511999999999",
      "service_id": "123",
      "service_name": "Lavagem Completa",
      "booking_date": "2026-01-15",
      "booking_time": "10:00",
      "vehicle_type": "sedan",
      "vehicle_plate": "ABC-1234",
      "price": 4500,
      "currency": "BRL",
      "created_at": "2026-01-10T14:30:00Z"
    },
    "links": {
      "self": "/api/v1/storefront/bookings/456"
    }
  }
}
```

### 3.3 Carrinho

```
GET    /api/v1/storefront/cart               # Ver carrinho
POST   /api/v1/storefront/cart/items         # Adicionar item
PUT    /api/v1/storefront/cart/items/:id     # Atualizar item
DELETE /api/v1/storefront/cart/items/:id     # Remover item
POST   /api/v1/storefront/cart/checkout      # Finalizar checkout
```

---

## 4. Admin API (Autenticada)

### 4.1 Dashboard

```
GET    /api/v1/admin/dashboard               # Métricas do dashboard
GET    /api/v1/admin/reports/sales           # Relatório de vendas
GET    /api/v1/admin/reports/bookings        # Relatório de agendamentos
GET    /api/v1/admin/reports/inventory       # Relatório de estoque
```

### 4.2 Produtos (Admin)

```
GET    /api/v1/admin/products                # Listar todos
POST   /api/v1/admin/products                # Criar
PUT    /api/v1/admin/products/:id            # Atualizar
DELETE /api/v1/admin/products/:id            # Excluir
GET    /api/v1/admin/products/:id            # Ver
```

### 4.3 Clientes

```
GET    /api/v1/admin/customers               # Listar
GET    /api/v1/admin/customers/:id           # Ver
PUT    /api/v1/admin/customers/:id           # Atualizar
GET    /api/v1/admin/customers/:id/bookings  # Agendamentos do cliente
```

### 4.4 Agendamentos (Admin)

```
GET    /api/v1/admin/bookings                # Listar
GET    /api/v1/admin/bookings/:id            # Ver
PUT    /api/v1/admin/bookings/:id            # Atualizar status
POST   /api/v1/admin/bookings/:id/cancel     # Cancelar
```

### 4.5 Temas

```
GET    /api/v1/admin/themes                  # Listar temas
GET    /api/v1/admin/themes/:id              # Ver tema
POST   /api/v1/admin/themes                  # Criar tema
PUT    /api/v1/admin/themes/:id              # Atualizar tema
POST   /api/v1/admin/themes/:id/publish      # Publicar
POST   /api/v1/admin/themes/:id/rollback     # Rollback
GET    /api/v1/admin/themes/:id/history      # Histórico de versões
```

### 4.6 Configurações do Tenant

```
GET    /api/v1/admin/settings                # Ver configurações
PUT    /api/v1/admin/settings                # Atualizar configurações
POST   /api/v1/admin/settings/backup         # Criar backup
POST   /api/v1/admin/settings/restore        # Restaurar backup
```

---

## 5. Webhooks

### 5.1 Eventos Disponíveis

| Evento | Descrição |
|--------|-----------|
| `booking.created` | Novo agendamento criado |
| `booking.updated` | Agendamento atualizado |
| `booking.cancelled` | Agendamento cancelado |
| `booking.completed` | Agendamento finalizado |
| `product.created` | Novo produto criado |
| `product.updated` | Produto atualizado |
| `product.deleted` | Produto excluído |
| `order.completed` | Pedido finalizado |
| `payment.received` | Pagamento recebido |
| `payment.failed` | Pagamento falhou |
| `customer.created` | Novo cliente criado |
| `customer.updated` | Cliente atualizado |
| `theme.published` | Tema publicado |
| `theme.updated` | Tema atualizado |

### 5.2 Payload de Webhook

```json
{
  "id": "wh_abc123",
  "type": "booking.created",
  "timestamp": "2026-01-10T14:30:00Z",
  "tenant_id": "tenant_123",
  "data": {
    "type": "booking",
    "id": "456",
    "attributes": {
      "status": "confirmed",
      "customer_name": "João Silva",
      "booking_date": "2026-01-15",
      "booking_time": "10:00"
    }
  }
}
```

### 5.3 Assinatura de Webhook

```
X-Carva-Signature: sha256=abc123def456...
```

- **Algoritmo:** HMAC-SHA256
- **Segredo:** disponível no painel admin do tenant
- **Validação:** verificar timestamp dentro de ±5 minutos

---

## 6. Erros

### 6.1 Códigos de Status

| Status | Descrição |
|--------|-----------|
| `200` | Sucesso |
| `201` | Criado |
| `400` | Request inválido |
| `401` | Não autenticado |
| `403` | Sem permissão |
| `404` | Recurso não encontrado |
| `422` | Validação falhou |
| `429` | Rate limit excedido |
| `500` | Erro interno do servidor |

### 6.2 Formato de Erro

```json
{
  "errors": [
    {
      "status": 422,
      "title": "Validation Error",
      "detail": "O campo 'booking_date' não pode ser uma data passada.",
      "source": {
        "field": "booking_date"
      },
      "code": "VALIDATION_ERROR",
      "meta": {
        "rule": "future_date",
        "accepted_format": "YYYY-MM-DD"
      }
    }
  ]
}
```

---

## 7. SDKs & Clientes

### 7.1 JavaScript

```bash
npm install @carva/sdk
```

```javascript
import { CarvaClient } from '@carva/sdk';

const carva = new CarvaClient({
  apiKey: 'sk_live_abc123def456',
  tenantId: 'tenant_123',
  environment: 'production'
});

// Listar produtos
const products = await carva.storefront.products.list({
  category: 'external',
  page: 1
});

// Criar agendamento
const booking = await carva.storefront.bookings.create({
  customer_name: 'João Silva',
  customer_email: 'joao@email.com',
  service_id: '123',
  booking_date: '2026-01-15',
  booking_time: '10:00'
});
```

### 7.2 Ruby

```bash
gem install carva-ruby
```

```ruby
require 'carva'

carva = Carva::Client.new(
  api_key: 'sk_live_abc123def456',
  tenant_id: 'tenant_123',
  environment: :production
)

# Listar produtos
products = carva.storefront.products.list(category: 'external')

# Criar agendamento
booking = carva.storefront.bookings.create(
  customer_name: 'João Silva',
  customer_email: 'joao@email.com',
  service_id: '123',
  booking_date: '2026-01-15',
  booking_time: '10:00'
)
```

---

## 1.6 Gestão de Tarefas

Todas as mudanças na API são rastreadas via kanban do Hermes. Cada endpoint novo ou modificado deve ter um card correspondente em `TODO/` antes de começar a implementação.

---

*Documento vivo — atualize conforme a API evolui.*
