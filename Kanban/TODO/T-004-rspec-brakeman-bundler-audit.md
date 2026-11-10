---
id: T-004
phase: Fase 0
priority: P1
status: todo
depends: none
---

# T-004 — RSpec + Brakeman + bundler-audit

## Descrição

Configurar tooling de qualidade e segurança: RSpec com configurações, Brakeman para audit de segurança, bundler-audit para dependências.

## Escopo

- `spec/rails_helper.rb` configurado
- `spec/spec_helper.rb` com configurações
- Brakeman com configurações mínimas
- bundler-audit atualizado
- Rake tasks para rodar tudo junto

## Acceptance Criteria

- [ ] `spec/rails_helper.rb` criado e configurado
- [ ] `spec/spec_helper.rb` com mock/test doubles
- [ ] `bin/rails spec` roda sem erros
- [ ] `bin/rails brakeman` passa
- [ ] `bin/rails audit` (bundler-audit) passa
- [ ] Rake task `bin/rails quality` roda tudo

## Implementation Notes

```ruby
# lib/tasks/quality.rake
namespace :quality do
  desc "Run all quality checks"
  task all: [:spec, :brakeman, :audit]

  task :spec do
    system("bundle exec rspec")
  end

  task :brakeman do
    system("bundle exec brakeman --quiet")
  end

  task :audit do
    system("bundle exec bundler audit")
  end
end
```

## Dependencies

- T-007 (Gemfile + dependências base)
