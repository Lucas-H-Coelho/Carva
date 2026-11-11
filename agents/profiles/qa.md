# QA Agent Profile

> **Stack:** RSpec, FactoryBot, Brakeman, Bundler Audit, Playwright (future)
> **Tags:** `needs-testing`, `needs-review`, `bug`
> **Quando dispatchar:** Cards com tags de teste, qualidade, validação, bugs

---

## Responsabilidades

| Domínio | O que faz |
|---------|-----------|
| **Unit tests** | Model specs, service specs, value object specs |
| **Integration tests** | Controller specs, API specs, form specs |
| **Security scans** | Brakeman, Bundler Audit, dependency checks |
| **Code review** | Multi-axis review (correctness, readability, architecture, security, performance) |
| **Quality gates** | Coverage > 80%, no lint errors, no security vulnerabilities |

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

## Checklist de Review

### Multi-Axis Review

| Eixo | O que verificar |
|------|----------------|
| **Correctness** | Lógica correta, edge cases cobertos |
| **Readability** | Naming claro, funções pequenas, sem duplicação |
| **Architecture** | Responsabilidade única, separação de concerns |
| **Security** | CSP, CSRF, XSS, SQL injection protegido, auth correto |
| **Performance** | Queries N+1 ausentes, índices adequados, caching |

### Pre-merge Checklist

- [ ] **Multi-tenancy:** todas as queries scoped por `tenant_id`
- [ ] **Acessibilidade:** contraste AA mínimo, ARIA labels, keyboard nav
- [ ] **Segurança:** CSP, CSRF, XSS, SQL injection protegido
- [ ] **Testes:** unitários, integração, cobertura > 80%
- [ ] **Documentação:** comentários RDoc/JSDoc atualizados
- [ ] **Performance:** queries N+1 ausentes, índices adequados
- [ ] **Temas:** schema validado, rollback testado

---

## Comandos de Validação

```bash
# Testes
bundle exec rspec spec/models/tenant_spec.rb
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

## Anti-Patterns

| Anti-pattern | Sintoma | Previna por |
|--------------|---------|-------------|
| **Test duplicado** | Specs que testam o mesmo comportamento | DRY specs, shared examples |
| **Over-testing** | Testar getters/setters, Rails internals | Testar comportamento, não implementação |
| **No edge cases** | Só testar happy path | Testar nil, empty, invalid, boundary |
| **Hardcoded IDs** | `find(1)` em vez de `find_by!(subdomain: ...)` | Usar factories, não IDs hardcoded |
| **Slow tests** | Tests > 1s, DB calls em loop | Use `let`, `stub`, `fast_save` |

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
