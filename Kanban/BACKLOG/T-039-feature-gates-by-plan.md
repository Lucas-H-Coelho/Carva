---
id: T-039
phase: Fase 2
priority: P1
status: todo
depends: T-020
tags: [feature, carva_core]
---

# T-039 — Feature gates por plano (expansão do T-020)

## Objetivo

Expandir o sistema de feature gates do T-020 para suportar funcionalidades específicas por plano (Mini PC, SaaS Cloud, Revenue Share). Cada plano libera features diferentes. Atende S1 (acesso a features do plano), S4 (feature gates multi-tenant).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Feature flags | `Tenant.features` JSONB com chaves booleanas |
| D2 | Plano → Features | `PlanFeature` table mapeia plano para features disponíveis |
| D3 | Runtime check | `Tenant#feature_enabled?(:feature_name)` |
| D4 | Grace period | Features expiradas têm 7 dias de grace period |
| D5 | Audit log | `FeatureChangeLog` registra quem ativou/desativou |

## Passo a Passo

### Passo 1 — Migration PlanFeatures

```ruby
# db/migrate/20250101000026_create_plan_features.rb
class CreatePlanFeatures < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_features do |t|
      t.string :plan, null: false # Lava, Lava Pro, Rede, Rede Plus
      t.string :feature, null: false # whatsapp, loyalty, multi_unit, offline, advanced_reports
      t.boolean :enabled, default: true

      t.timestamps
    end

    add_index :plan_features, [:plan, :feature], unique: true
  end
end
```

### Passo 2 — Seed PlanFeatures

```ruby
# db/seeds/plan_features.rb
plan_features = {
  'Lava' => {
    'whatsapp' => true,
    'loyalty' => false,
    'multi_unit' => false,
    'offline' => false,
    'advanced_reports' => false,
    'team_distribution' => true,
    'cash_flow' => true,
    'reviews' => false,
    'media' => false,
    'feature_gates' => false
  },
  'Lava Pro' => {
    'whatsapp' => true,
    'loyalty' => true,
    'multi_unit' => false,
    'offline' => true,
    'advanced_reports' => true,
    'team_distribution' => true,
    'cash_flow' => true,
    'reviews' => true,
    'media' => true,
    'feature_gates' => false
  },
  'Rede' => {
    'whatsapp' => true,
    'loyalty' => true,
    'multi_unit' => true,
    'offline' => true,
    'advanced_reports' => true,
    'team_distribution' => true,
    'cash_flow' => true,
    'reviews' => true,
    'media' => true,
    'feature_gates' => true
  },
  'Rede Plus' => {
    'whatsapp' => true,
    'loyalty' => true,
    'multi_unit' => true,
    'offline' => true,
    'advanced_reports' => true,
    'team_distribution' => true,
    'cash_flow' => true,
    'reviews' => true,
    'media' => true,
    'feature_gates' => true
  }
}

plan_features.each do |plan, features|
  features.each do |feature, enabled|
    PlanFeature.find_or_create_by!(plan: plan, feature: feature) do |pf|
      pf.enabled = enabled
    end
  end
end
```

### Passo 3 — Modelo Tenant (feature check)

```ruby
# app/models/tenant.rb
class Tenant < ApplicationRecord
  # ... existing code ...

  def feature_enabled?(feature_name)
    return false if features.blank?
    features[feature_name.to_s] == true
  end

  def enable_feature(feature_name)
    self.features = (features || {}).merge(feature_name.to_s => true)
    save!
    FeatureChangeLog.create!(
      tenant: self,
      feature: feature_name.to_s,
      action: 'enabled',
      user_id: Current.user&.id
    )
  end

  def disable_feature(feature_name)
    self.features = (features || {}).merge(feature_name.to_s => false)
    save!
    FeatureChangeLog.create!(
      tenant: self,
      feature: feature_name.to_s,
      action: 'disabled',
      user_id: Current.user&.id
    )
  end

  def available_features
    PlanFeature.where(plan: plan).where(enabled: true).pluck(:feature)
  end
end
```

### Passo 4 — Migration FeatureChangeLog

```ruby
# db/migrate/20250101000027_create_feature_change_logs.rb
class CreateFeatureChangeLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :feature_change_logs do |t|
      t.references :tenant, null: false, foreign_key: true, type: :bigint
      t.string :feature, null: false
      t.string :action, null: false # enabled, disabled
      t.references :user, type: :bigint
      t.datetime :occurred_at

      t.timestamps
    end

    add_index :feature_change_logs, [:tenant_id, :feature, :occurred_at]
  end
end
```

## Checklist

- [ ] Migration `create_plan_features` roda com sucesso
- [ ] Seed de `PlanFeature` com 4 planos e 10 features
- [ ] `Tenant.feature_enabled?` verifica feature do plano
- [ ] `Tenant.enable_feature` / `disable_feature` atualiza + loga
- [ ] `Tenant.available_features` retorna features do plano atual
- [ ] Migration `create_feature_change_logs` roda com sucesso
- [ ] `FeatureChangeLog` model com auditoria
- [ ] Middleware bloqueia acesso a features não habilitadas
- [ ] Testes RSpec: tenant features, plan features, middleware

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Feature habilitada mas plano expirado | Verificar `license_expires_at` no check |
| Features adicionadas depois | Worker que resync features expiradas |
| Log de auditoria perdido | `FeatureChangeLog` em transação DB |
| Plano muda mas features não | Trigger que resync features no change de plano |
