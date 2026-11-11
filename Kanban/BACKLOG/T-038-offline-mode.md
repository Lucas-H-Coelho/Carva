---
id: T-038
phase: Fase 3
priority: P2
status: todo
depends: T-024, T-028
tags: [feature, carva_storefront, carva_core]
---

# T-038 — Modo offline (S3-050)

## Objetivo

Permitir que funcionários trabalhem sem internet: marcar status, registrar pagamentos, tudo fica salvo localmente e sincroniza quando a internet voltar. Atende S3 (modo offline), S1 (backup manual).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Storage local | IndexedDB no navegador (PWA) para dados do cliente |
| D2 | Sincronização | `SyncQueue` model com `status: pending` → `synced` |
| D3 | Conflitos | Last-write-wins + log de auditoria |
| D4 | PWA | Service worker + manifest.json para instalar no celular |
| D5 | Backup manual | Exportar agendamentos do dia em PDF |

## Passo a Passo

### Passo 1 — Migration SyncQueue

```ruby
# db/migrate/20250101000025_create_sync_queues.rb
class CreateSyncQueues < ActiveRecord::Migration[8.0]
  def change
    create_table :sync_queues do |t|
      t.references :tenant, null: false, type: :bigint
      t.string :entity_type, null: false # Booking, CashEntry, CashExit, Media
      t.integer :entity_id
      t.jsonb :payload, null: false
      t.string :action, null: false # create, update, delete
      t.string :status, default: 'pending', null: false # pending, syncing, synced, failed
      t.text :error_message
      t.datetime :synced_at
      t.datetime :created_at

      t.timestamps
    end

    add_index :sync_queues, [:tenant_id, :status, :created_at]
  end
end
```

### Passo 2 — Service: SyncQueue

```ruby
# app/services/sync_queue_service.rb
class SyncQueueService
  def self.enqueue(tenant, entity_type, entity_id, action, payload)
    sync = SyncQueue.create!(
      tenant: tenant,
      entity_type: entity_type,
      entity_id: entity_id,
      action: action,
      payload: payload,
      status: 'pending'
    )
    sync
  end

  def self.process_pending
    SyncQueue.where(status: 'pending').limit(50).each do |sync|
      begin
        case sync.action
        when 'create'
          create_entity(sync)
        when 'update'
          update_entity(sync)
        when 'delete'
          delete_entity(sync)
        end
        sync.status = 'synced'
        sync.synced_at = Time.now
      rescue => e
        sync.status = 'failed'
        sync.error_message = e.message
      end
      sync.save!
    end
  end

  def self.export_daily_pdf(tenant, date = Date.today)
    # Gera PDF com agendamentos do dia
    bookings = tenant.bookings.where(scheduled_at: date.beginning_of_day..date.end_of_day)
    pdf = PDFKit.new(
      render_to_string(
        template: 'reports/daily_bookings',
        locals: { bookings: bookings, date: date }
      ),
      margin_top: 40,
      margin_bottom: 40
    )
    pdf.to_base64
  end
end
```

### Passo 3 — Worker: SyncProcessor

```ruby
# app/workers/sync_processor.rb
class SyncProcessor
  def self.perform
    SyncQueueService.process_pending
  end
end
```

### Passo 4 — Frontend (PWA)

```javascript
// src/serviceWorker.js
// Service Worker para PWA
self.addEventListener('sync', (event) => {
  if (event.tag === 'sync-queue') {
    event.waitUntil(syncQueue());
  }
});

async function syncQueue() {
  const pending = await db.syncQueue.where({ status: 'pending' }).toArray();
  for (const item of pending) {
    try {
      await api.post('/sync', item);
      item.status = 'synced';
      await db.syncQueue.put(item);
    } catch (error) {
      item.status = 'failed';
      await db.syncQueue.put(item);
    }
  }
}

// Detectar offline/online
navigator.serviceWorker.addEventListener('controllerchange', () => {
  window.location.reload();
});

window.addEventListener('offline', () => {
  showOfflineBanner();
});

window.addEventListener('online', () => {
  hideOfflineBanner();
  syncQueue();
});
```

## Checklist

- [ ] Migration `create_sync_queues` roda com sucesso
- [ ] `SyncQueueService.enqueue` adiciona item à fila
- [ ] `SyncQueueService.process_pending` processa itens pendentes
- [ ] `SyncQueueService.export_daily_pdf` gera PDF de backup
- [ ] `SyncProcessor` worker processa fila periodicamente
- [ ] Service Worker registrado e funcionando
- [ ] IndexedDB armazena dados offline
- [ ] Sincronização automática ao voltar online
- [ ] Banner offline visível quando sem conexão
- [ ] Testes RSpec: sync queue service, worker, PDF export

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Conflito de dados (dois funcionários no mesmo carro) | Last-write-wins + notificar |
| Dados perdidos se IndexedDB limpo | Backup diário no servidor |
| Sincronização lenta com muitos itens | Batch process (50 itens por vez) |
| Service Worker não atualiza | `navigator.serviceWorker.register` com cache busting |
