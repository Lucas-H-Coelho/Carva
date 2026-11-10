---
id: T-036
phase: Fase 2
priority: P1
status: todo
depends: T-013
tags: [feature, carva_core]
---

# T-036 — Configurações da unidade (settings)

## Objetivo

Permitir que o dono configure sua unidade: nome, endereço, horário de funcionamento, serviços padrão, estoque inicial, tema visual, notificações. Atende S1 (onboarding, configurações), S4 (configurar unidades).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Configuração | `Tenant` model com campos de configuração (no settings JSONB) |
| D2 | Onboarding | Wizard de 5 passos (cadastro → serviços → estoque → equipe → primeiro agendamento) |
| D3 | Tema | `Tenant.settings[:theme]` com cor, logo, nome personalizado |
| D4 | Notificações | `Tenant.settings[:notifications]` com toggles por tipo |
| D5 | Horários de pico | `Tenant.settings[:peak_hours]` — sexta/sábado 13h-17h sem agendamento |

## Passo a Passo

### Passo 1 — Migration (campos de configuração no Tenant)

```ruby
# db/migrate/20250101000023_add_settings_to_tenants.rb
class AddSettingsToTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :settings, :jsonb, default: '{}'
    add_column :tenants, :timezone, :string, default: 'America/Sao_Paulo'
    add_column :tenants, :working_hours_start, :string, default: '07:00'
    add_column :tenants, :working_hours_end, :string, default: '18:00'
    add_column :tenants, :peak_days, :string, array: true, default: ['friday', 'saturday']
    add_column :tenants, :peak_hours_start, :string, default: '13:00'
    add_column :tenants, :peak_hours_end, :string, default: '17:00'

    add_index :tenants, :settings, using: 'gin'
  end
end
```

### Passo 2 — Modelo Tenant (settings accessor)

```ruby
# app/models/tenant.rb
class Tenant < ApplicationRecord
  # ... existing code ...

  def settings
    self[:settings] ||= {}
  end

  def settings=(value)
    self[:settings] = value.to_h
  end

  def theme
    settings.fetch('theme', {
      primary_color: '#10B981',
      logo_url: nil,
      business_name: name
    })
  end

  def theme=(value)
    settings['theme'] = value
    save!
  end

  def notifications
    settings.fetch('notifications', {
      booking_confirmation: true,
      car_ready: true,
      reminder: true,
      low_stock: true,
      unit_alert: true
    })
  end

  def notifications=(value)
    settings['notifications'] = value
    save!
  end

  def is_peak_hour?(datetime)
    return false if !peak_days.include?(datetime.strftime('%A').downcase)
    hour = datetime.hour
    start_hour = peak_hours_start.split(':').first.to_i
    end_hour = peak_hours_end.split(':').first.to_i
    hour >= start_hour && hour < end_hour
  end
end
```

### Passo 3 — Controller: Settings

```ruby
# app/controllers/api/v1/settings_controller.rb
module Api
  module V1
    class SettingsController < ApplicationController
      before_action :require_owner

      def update
        Current.tenant.settings = settings_params
        Current.tenant.save!
        render json: { success: true, settings: Current.tenant.settings }
      end

      def update_theme
        Current.tenant.theme = theme_params
        Current.tenant.save!
        render json: { success: true, theme: Current.tenant.theme }
      end

      def update_notifications
        Current.tenant.notifications = notifications_params
        Current.tenant.save!
        render json: { success: true, notifications: Current.tenant.notifications }
      end

      def show
        render json: {
          settings: Current.tenant.settings,
          theme: Current.tenant.theme,
          notifications: Current.tenant.notifications,
          working_hours: {
            start: Current.tenant.working_hours_start,
            end: Current.tenant.working_hours_end,
            peak_days: Current.tenant.peak_days,
            peak_hours: {
              start: Current.tenant.peak_hours_start,
              end: Current.tenant.peak_hours_end
            }
          }
        }
      end

      private
      def settings_params
        params.require(:tenant).permit(
          :name, :address, :timezone,
          :working_hours_start, :working_hours_end,
          :peak_days, :peak_hours_start, :peak_hours_end
        )
      end

      def theme_params
        params.require(:tenant).permit(:primary_color, :logo_url, :business_name)
      end

      def notifications_params
        params.require(:tenant).permit(
          :booking_confirmation, :car_ready, :reminder,
          :low_stock, :unit_alert
        )
      end

      def require_owner
        unless Current.user.owner?
          render json: { error: 'Permissão negada' }, status: :forbidden
        end
      end
    end
  end
end
```

## Checklist

- [ ] Migration `add_settings_to_tenants` roda com sucesso
- [ ] `Tenant.settings` retorna hash de configurações
- [ ] `Tenant.theme` retorna/define tema visual
- [ ] `Tenant.notifications` retorna/define toggles de notificação
- [ ] `Tenant.is_peak_hour?` verifica horário de pico
- [ ] `SettingsController#show` retorna todas as configurações
- [ ] `SettingsController#update` atualiza configurações gerais
- [ ] `SettingsController#update_theme` atualiza tema
- [ ] `SettingsController#update_notifications` atualiza notificações
- [ ] Testes RSpec: tenant settings, controller, peak hour logic

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Settings JSONB vazio | `default: '{}'` na migration |
| Configurações perdidas em update | `settings.merge!(params)` em vez de replace |
| Peak hours inválidos | Validar `peak_hours_start < peak_hours_end` |
| Tema não aplicado | Cache do tema no CDN se houver |
