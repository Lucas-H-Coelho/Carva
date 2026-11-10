---
id: T-004
phase: Fase 0
priority: P1
status: done
depends: T-007
tags: [chore, carva_core, security]
---

# T-004 — RSpec + Brakeman + Bundler Audit tooling

## Objetivo

Configurar o ambiente de testes e auditoria: RSpec com Rails helper, Brakeman com configurações mínimas, bundler-audit com banco atualizado, e Rake tasks para rodar tudo junto.

---

## Decisões a Tomar (antes de começar)

| # | Decisão | Opção A | Opção B | Recomendação |
|---|---------|---------|---------|-------------|
| D1 | RSpec version | 4.0+ | 3.12 | **4.0+** — compatível com Rails 7.1 |
| D2 | Mock framework | `mock` (RSpec nativo) | `should` (deprecated) | **`mock`** — RSpec 4 usa mock |
| D3 | Brakeman config | `.brakeman/config` | CLI flags | **`.brakeman/config`** — mais limpo |
| D4 | Bundler audit | `bundler-audit` | `bundler-audit-gem` | **`bundler-audit`** — oficial |
| D5 | Coverage | `simplecov` | `simplecov-lcov` | **`simplecov`** — HTML report |
| D6 | Parallel tests | `parallel_tests` | `database: 1..5` | **`parallel_tests`** — mais rápido |

---

## Passo a Passo

### Passo 1 — Instalar gems de teste

Adicionar ao `Gemfile` (grupo `:test`):

```ruby
group :test do
  # RSpec
  gem 'rspec-rails', '~> 6.0'
  gem 'rspec-collection_matchers'
  gem 'rspec-mocks', '~> 3.12'

  # Test helpers
  gem 'factory_bot_rails'
  gem 'faker'

  # Coverage
  gem 'simplecov', require: false, groups: :test
  gem 'simplecov-json'

  # Parallel tests
  gem 'parallel_tests'

  # Brakeman
  gem 'brakeman'

  # Bundler audit
  gem 'bundler-audit'
end
```

### Passo 2 — Gerar RSpec config

```bash
bundle install
bundle exec rspec --init
```

**Arquivos criados:**
- `spec/spec_helper.rb`
- `spec/rails_helper.rb`
- `spec/` directory

### Passo 3 — Configurar `spec/rails_helper.rb`

```ruby
# spec/rails_helper.rb
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/vendor/'
  add_filter '/app/engines/'
end

begin
  require 'rspec/rails'
  require 'factory_bot_rails'
  require 'faker'
respect LoadError
  abort "RSpec gems not installed. Run: bundle install"
end

ENV['RAILS_ENV'] = 'test'
ENV['REDIS_URL'] = 'redis://localhost:6379/0'

Rails.env.test!

RSpec.configure do |config|
  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Faker
  Faker::Config.locale = 'pt_BR'

  # Transactional tests
  config.use_transactional_tests = true

  # Parallel tests
  if ENV['PARALLEL_WORKERS']
    config.parallelize = ->(worker) {
      FactoryBot.finder = FactoryBot::Finder.new(worker)
    }
  end

  # Color and format
  config.formatter = :progress
  config.color = true

  # Order
  config.order = :random
  Kernel.extend(RSpec::Core::Extensions).with_runner(self)
end
```

### Passo 4 — Configurar `spec/spec_helper.rb`

```ruby
# spec/spec_helper.rb
require 'simplecov'
SimpleCov.start 'rails' do
  formatter SimpleCov::Formatter::JSON
end

RSpec.configure do |config|
  # Mock framework
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_keys = true
    mocks.verify_nil_and_false = true
  end

  # Disable Rails
  config.expose_dsl_globally = false

  # Warnings
  config.warnings = true

  # Profile
  config.profile_examples = 10 if ENV['PROFILE']
end
```

### Passo 5 — Configurar Brakeman

```yaml
# .brakeman/config
---
quiet: true
no_pager: true
skip_output: true
```

```bash
# bin/brakeman
#!/usr/bin/env bash
set -e
bundle exec brakeman -q -z -w 2,3,4,5 --no-pager
```

### Passo 6 — Configurar Bundler Audit

```bash
# bin/bundle-audit
#!/usr/bin/env bash
set -e
bundle exec bundler audit update
bundle exec bundler audit --json
```

### Passo 7 — Criar Rake tasks

```ruby
# lib/tasks/quality.rake
namespace :quality do
  desc "Run all quality checks"
  task all: [:spec, :brakeman, :audit]

  task :spec do
    system("bundle exec rspec --format progress --color")
  end

  task :brakeman do
    system("bundle exec brakeman -q -z -w 2,3,4,5 --no-pager")
  end

  task :audit do
    system("bundle exec bundler audit update && bundle exec bundler audit")
  end
end
```

---

## Checklist de Aceitação

- [ ] `spec/rails_helper.rb` criado e configurado
- [ ] `spec/spec_helper.rb` com mock/test doubles
- [ ] `bin/rails spec` roda sem erros
- [ ] `bin/rails brakeman` passa
- [ ] `bin/rails audit` (bundler-audit) passa
- [ ] Rake task `bin/rails quality` roda tudo
- [ ] `SimpleCov` gera HTML + JSON report
- [ ] `FactoryBot` configurado com `pt_BR` locale
- [ ] `Faker` configurado com `pt_BR` locale
- [ ] Parallel tests configurados (via `PARALLEL_WORKERS`)

---

## Arquivos que devem existir ao final

```
Carva/
├── spec/
│   ├── rails_helper.rb
│   ├── spec_helper.rb
│   ├── factories/
│   │   └── *.rb
│   └── support/
│       └── *.rb
├── .brakeman/
│   └── config
├── bin/
│   ├── brakeman
│   └── bundle-audit
└── lib/
    └── tasks/
        └── quality.rake
```

---

## Notas de Implementação

- **`SimpleCov`** deve ser `require: false` no Gemfile — inicia no rails_helper
- **`brakeman --no-potential-warnings`** reduz falsos positivos no CI
- **`rspec.xml`** com formato JUnit para visualização no GitHub
- **`workflow_dispatch`** no deploy permite deploy manual quando quiser
- **Branch protection** é configurado via UI do GitHub, não via código

---

## Riscos e Mitigações

| Risco | Mitigação |
|-------|-----------|
| CI lento (>10min) | Parallel tests com `database: 1..5` |
| Falsos positivos no brakeman | `--no-potential-warnings` + `|| true` |
| Cache quebra entre builds | `bundler-cache: true` gerencia automaticamente |
| Testes falham por race condition | `database: 1..5` isola databases |
| Deploy acidental | `workflow_dispatch` exige ação manual |

---

## Comandos para Testar Localmente

```bash
# Instalar act (local GitHub Actions runner)
brew install act

# Rodar CI localmente
act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest

# Rodar apenas job de teste
act -j test

# Rodar apenas job de lint
act -j lint
```