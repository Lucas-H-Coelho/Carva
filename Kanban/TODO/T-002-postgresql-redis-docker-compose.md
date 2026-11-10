---
id: T-002
phase: Fase 0
priority: P0
status: todo
depends: none
---

# T-002 — PostgreSQL + Redis Docker Compose

## Descrição

Configurar `docker-compose.yml` com PostgreSQL 15+ e Redis 7+ para ambiente local de desenvolvimento.

## Escopo

- Serviço `postgres` com volume persistente
- Serviço `redis` com volume persistente
- Variáveis de ambiente para conexão
- Health checks para ambos os serviços
- Rede Docker customizada

## Acceptance Criteria

- [ ] `docker-compose.yml` criado com `postgres` e `redis`
- [ ] `docker compose up -d` inicia ambos os serviços
- [ ] PostgreSQL acessível em `localhost:5432`
- [ ] Redis acessível em `localhost:6379`
- [ ] Volumes persistentes configurados
- [ ] Health checks passando

## Implementation Notes

```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: carva_dev
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports: ["5432:5432"]
    volumes: ["pg_data:/var/lib/postgresql/data"]
    healthcheck: ...

  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]
    volumes: ["redis_data:/data"]
    healthcheck: ...
```

## Dependencies

- Fase 0 (setup inicial)
