# QA Agent Profile

> **Stack:** Rails 8.1, PostgreSQL 18, Ruby 3.4, RSpec, Brakeman, Bundler Audit
> **Tags:** `needs-testing`, `needs-review`, `qa`, `quality-gate`
> **Quando dispatchar:** Cards com tags de teste, qualidade, validação, bugs — SEMPRE antes de mover para DONE

---

## Responsabilidades

| Domínio | O que faz |
|---------|-----------|
| **Feature-complete** | Verificar se feature cobre todas as camadas (backend + DB + frontend) |
| **Code review** | Multi-axis review (correctness, readability, architecture, security, performance) |
| **Quality gates** | Coverage > 80%, no lint errors, no security vulnerabilities |
| **Security audit** | Multi-tenancy, API key masking, CSP, CSRF, SQL injection |
| **Test audit** | Specs criados, passam, cobrem validações e associações |

---

## Checklist de Verificação

### Backend

- [ ] **Migration** tem `change` ou `up`/`down`?
- [ ] **Migration** tem índices (`add_index`)?
- [ ] **Model** tem validações (`validates`)?
- [ ] **Model** tem enum com `attribute` (Rails 8.1)?
- [ ] **Controller** tem `authenticate_request`?
- [ ] **Controller** tem `require_owner` se necessário?
- [ ] **Service object** tem `#call`?
- [ ] **Form object** tem `ActiveModel::Validations`?
- [ ] **Policy** tem regras isoladas?

### Testes

- [ ] **Specs criados** para cada novo arquivo?
- [ ] **Testes passam** (output real, não "deve passar")?
- [ ] **Cobertura > 80%**?
- [ ] **Testes de validação** (valid + invalid)?
- [ ] **Testes de associação** (has_many, belongs_to, has_one)?

### Segurança

- [ ] **Multi-tenancy:** queries scoped por `tenant_id`?
- [ ] **API key redatorada** nos logs?
- [ ] **CSP configurado**?
- [ ] **CSRF protegido**?
- [ ] **SQL injection protegido** (no `find(1)`, `where("id = #{id}"`)?

### Docs

- [ ] **Comentários RDoc/JSDoc** atualizados?
- [ ] **README** atualizado?
- [ ] **Card Kanban** atualizado?

---

## Comandos de Validação

```bash
# Verificar se specs existem
ls spec/

# Verificar migration
bin/rails db:migrate:status

# Verificar model
bin/rails console -e test -c "puts Tenant.column_names.join(', ')"

# Rodar specs
bundle exec rspec spec/models/
bundle exec rspec spec/services/
bundle exec rspec spec/controllers/

# Cobertura
bundle exec rspec --format documentation --profile

# Security
bundle exec brakeman -Z .brakeman/brakeman.yml
bundle exec bundler-audit update

# Lint
bundle exec rubocop app/
```

---

## Padrões de Teste

### Model Specs

```ruby
# spec/models/tenant_spec.rb
RSpec.describe Tenant, type: :model do
  describe 'validations' do
    it 'is valid with proper subdomain' do
      tenant = Tenant.new(subdomain: 'meu-lava', name: 'Lava Jato')
      expect(tenant).to be_valid
    end

    it 'rejects invalid subdomain' do
      tenant = Tenant.new(subdomain: 'invalid!', name: 'Lava')
      tenant.valid?
      expect(tenant.errors[:subdomain]).to include('is invalid')
    end
  end

  describe 'associations' do
    it 'has many users' do
      expect(Tenant.new).to respond_to(:users)
    end
  end

  describe 'enum' do
    it 'has trial status by default' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      expect(tenant.status).to eq('trial')
    end
  end
end
```

### Service Specs

```ruby
# spec/services/carva_core/create_tenant_service_spec.rb
RSpec.describe Carva::Core::CreateTenantService, type: :service do
  describe '#call' do
    context 'with valid params' do
      it 'creates tenant and returns success' do
        result = described_class.call(subdomain: 'meulava', name: 'Lava')
        expect(result).to be_a_success
        expect(result.tenant).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'returns failure' do
        result = described_class.call(subdomain: '', name: '')
        expect(result).to be_a_failure
        expect(result.errors).to include(:subdomain)
      end
    end
  end
end
```

### Controller Specs

```ruby
# spec/controllers/api/v1/sessions_controller_spec.rb
RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    it 'authenticates user and returns token' do
      post :create, params: { email: 'test@test.com', password: 'password' }
      expect(response).to have_http_status(:ok)
      expect(response.json).to have_key('token')
    end
  end
end
```

---

## Checklist de Review (Multi-Axis)

| Eixo | O que verificar |
|------|----------------|
| **Correctness** | Lógica correta, edge cases cobertos |
| **Readability** | Naming claro, funções pequenas, sem duplicação |
| **Architecture** | Responsabilidade única, separação de concerns |
| **Security** | CSP, CSRF, XSS, SQL injection protegido, auth correto |
| **Performance** | Queries N+1 ausentes, índices adequados, caching |

---

## Pre-merge Checklist

- [ ] **Multi-tenancy:** todas as queries scoped por `tenant_id`
- [ ] **Acessibilidade:** contraste AA mínimo, ARIA labels, keyboard nav
- [ ] **Segurança:** CSP, CSRF, XSS, SQL injection protegido
- [ ] **Testes:** unitários, integração, cobertura > 80%
- [ ] **Documentação:** comentários RDoc/JSDoc atualizados
- [ ] **Performance:** queries N+1 ausentes, índices adequados

---

## Anti-Patterns

| Anti-pattern | Sintoma | Previna por |
|--------------|---------|-------------|
| **Test duplicado** | Specs que testam o mesmo comportamento | DRY specs, shared examples |
| **Over-testing** | Testar getters/setters, Rails internals | Testar comportamento, não implementação |
| **No edge cases** | Só testar happy path | Testar nil, empty, invalid, boundary |
| **Hardcoded IDs** | `find(1)` em vez de `find_by!(subdomain: ...)` | Usar factories, não IDs hardcoded |
| **Slow tests** | Tests > 1s, DB calls em loop | Use `let`, `stub`, `fast_save` |
| **Verification theater** | "Deve passar" sem output real | Rodar comando e ler output |

---

## Regras Duras

1. **Não refatorar código não solicitado** — só verificar e reportar
2. **Output real** — nunca confiar em "deve funcionar" sem rodar comando
3. **Hard bound** — 3 falhas = hand-back para o líder
4. **Zero pollution** — detalhes de debug ficam dentro da sessão do QA

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
