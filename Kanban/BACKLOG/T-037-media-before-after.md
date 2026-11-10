---
id: T-037
phase: Fase 3
priority: P2
status: todo
depends: T-024
tags: [feature, carva_storefront]
---

# T-037 — Fotos before/after do carro (S3-048, S3-049)

## Objetivo

Permitir que o funcionário tire foto do carro antes e depois da lavagem, registre danos existentes e armazene as fotos. O dono vê as fotos como prova e o cliente pode ver o resultado. Atende S3 (foto antes/depois, registrar dano), S2 (ver foto antes de retirar).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Storage | AWS S3 (ou similar) para armazenar fotos |
| D2 | Modelo | `Media` com `booking_id`, `type` (before, after, damage), `url` |
| D3 | Upload | Upload direto do frontend para S3 (presigned URL) |
| D4 | Dano | `Media` com `type: 'damage'` + `description` no booking |
| D5 | Retenção | Fotos salvas por 30 dias (configurável por tenant) |

## Passo a Passo

### Passo 1 — Migration Media

```ruby
# db/migrate/20250101000024_create_media.rb
class CreateMedia < ActiveRecord::Migration[8.0]
  def change
    create_table :media do |t|
      t.references :booking, null: false, foreign_key: true, type: :bigint
      t.string :type, null: false # before, after, damage
      t.string :url, null: false
      t.string :s3_key
      t.integer :width
      t.integer :height
      t.text :description
      t.datetime :taken_at

      t.timestamps
    end

    add_index :media, [:booking_id, :type]
  end
end
```

### Passo 2 — Modelo Media

```ruby
# app/models/media.rb
class Media < ApplicationRecord
  belongs_to :booking
  belongs_to :tenant, through: :booking

  enum :type, { before: 'before', after: 'after', damage: 'damage' }, prefix: true

  validates :type, presence: true
  validates :url, presence: true

  before_create :generate_s3_key

  def self.for_booking(booking)
    where(booking: booking).order(type: :desc)
  end

  def self.before_photo(booking)
    find_by(booking: booking, type: 'before')
  end

  def self.after_photo(booking)
    find_by(booking: booking, type: 'after')
  end

  private
  def generate_s3_key
    self.s3_key = "media/#{tenant_id}/#{booking.id}/#{type}_#{SecureRandom.uuid}.jpg"
  end
end
```

### Passo 3 — Controller: Media

```ruby
# app/controllers/api/v1/media_controller.rb
module Api
  module V1
    class MediaController < ApplicationController
      def presigned_url
        media = Media.new(tenant: Current.tenant, booking_id: params[:booking_id], type: params[:type])
        url = S3_BUCKET.presigned_url(:put_object,
          key: media.s3_key,
          content_type: 'image/jpeg',
          expires_after: 5.minutes
        )
        render json: { url: url, s3_key: media.s3_key }
      end

      def save
        media = Media.create!(
          tenant: Current.tenant,
          booking_id: params[:booking_id],
          type: params[:type],
          url: params[:url],
          s3_key: params[:s3_key],
          description: params[:description],
          taken_at: Time.now
        )
        render json: { success: true, media: media.as_json }
      end

      def show(booking_id)
        media = Media.for_booking(
          Current.tenant.bookings.find(booking_id)
        )
        render json: media
      end

      def delete(media_id)
        media = Current.tenant.media.find(media_id)
        S3_BUCKET.object(media.s3_key).delete
        media.destroy
        render json: { success: true }
      end
    end
  end
end
```

## Checklist

- [ ] Migration `create_media` roda com sucesso
- [ ] `Media` model com tipos before/after/damage
- [ ] `Media.for_booking` retorna fotos de um booking
- [ ] `Media#before_photo` / `#after_photo` retornam foto específica
- [ ] `Media#generate_s3_key` gera chave S3 única
- [ ] `MediaController#presigned_url` retorna URL de upload
- [ ] `MediaController#save` salva metadados da foto
- [ ] `MediaController#show` retorna fotos de um booking
- [ ] `MediaController#delete` remove foto + arquivo S3
- [ ] Testes RSpec: media model, controller, S3 integration

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Upload falha no S3 | Retry com backoff, logar erro |
| Foto corrompida | Validar `width` e `height` no upload |
| Fotos expiradas | Worker limpa fotos com mais de 30 dias |
| Storage caro | Comprimir imagens antes do upload |
