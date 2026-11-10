# Carva — Deployment Guide

> **Guia de deploy e infraestrutura do Carva.** Cobertura de ambiente local até produção, com Docker, CI/CD e estratégias de scaling.

---

## 1. Visão Geral da Infraestrutura

```
                    ┌─────────────┐
                    │   Cloudflare │
                    │   (CDN + DNS)│
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   Nginx     │
                    │  (Proxy)    │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
        ┌─────▼─────┐ ┌───▼───┐ ┌─────▼─────┐
        │  Puma #1  │ │Puma #2│ │  Puma #3 │
        │ (Rails)   │ │(Rails) │ │ (Rails)  │
        └─────┬─────┘ └───┬───┘ └─────┬─────┘
              │           │           │
              └───────────┬───────────┘
                          │
            ┌─────────────┼─────────────┐
            │             │             │
      ┌─────▼─────┐ ┌────▼────┐ ┌─────▼─────┐
      │ PostgreSQL │ │ Redis   │ │ Sidekiq  │
      │ (Primary)  │ │(Cache)  │ │ (Queue)  │
      └────────────┘ └─────────┘ └─────────┘
```

---

## 2. Ambiente Local

### 2.1 Requisitos

| Software | Versão Mínima |
|----------|--------------|
| Ruby | 3.3+ |
| Node.js | 20+ |
| PostgreSQL | 15+ |
| Redis | 7+ |
| Docker | 24+ |
| Docker Compose | 2.24+ |

### 2.2 Setup Inicial

```bash
# 1. Clonar o repositório
git clone https://github.com/carva/carva.git
cd carva

# 2. Instalar dependências
bundle install
npm install

# 3. Configurar ambiente
cp .env.example .env
# Editar .env com credenciais locais

# 4. Criar banco de dados
bin/rails db:create db:migrate

# 5. Criar tenant de desenvolvimento
bin/rails db:seed

# 6. Iniciar serviços
docker compose up -d postgres redis

# 7. Iniciar Rails + Vite
bin/dev
```

### 2.3 Docker Compose (Local)

```yaml
# docker-compose.yml
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://carva:password@postgres:5432/carva_dev
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - postgres
      - redis
    volumes:
      - .:/app
      - gem_cache:/usr/local/bundle/gems

  worker:
    build: .
    command: bundle exec sidekiq
    environment:
      - DATABASE_URL=postgresql://carva:password@postgres:5432/carva_dev
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: carva
      POSTGRES_PASSWORD: password
      POSTGRES_DB: carva_dev
    volumes:
      - pg_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  pg_data:
  redis_data:
  gem_cache:
```

---

## 3. CI/CD

### 3.1 Pipeline GitHub Actions

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: carva
          POSTGRES_PASSWORD: password
        ports:
          - 5432:5432
      redis:
        image: redis:7
        ports:
          - 6379:6379

    steps:
      - uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.3
          bundler-cache: true

      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install dependencies
        run: |
          bundle install
          npm install

      - name: Run database migrations
        env:
          DATABASE_URL: postgresql://carva:password@localhost:5432/carva_test
        run: bin/rails db:create db:migrate

      - name: Run RSpec
        env:
          DATABASE_URL: postgresql://carva:password@localhost:5432/carva_test
          REDIS_URL: redis://localhost:6379/0
        run: bundle exec rspec

      - name: Run ESLint
        run: npx eslint app/javascript/ --max-warnings=0

      - name: Run Vite build
        run: npm run build

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Brakeman
        uses: ruby/brakeman@v1
        with:
          workdir: '.'

      - name: Run Bundler Audit
        run: bundle exec bundler-audit update && bundle exec bundler-audit

  deploy:
    needs: [test, security]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # Scripts de deploy serão adicionados aqui
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
          AWS_REGION: us-east-1
```

### 3.2 Branch Strategy

| Branch | Uso | Deploy |
|--------|-----|--------|
| `main` | Código production-ready | Production |
| `develop` | Integração de features | Staging |
| `feature/*` | Desenvolvimento de features | Não deploya |
| `hotfix/*` | Correções urgentes | Production (direto) |

---

## 4. Deploy Produção

### 4.1 Pré-requisitos

| Item | Status |
|------|--------|
| PostgreSQL 15+ provisionado | ✅ |
| Redis provisionado | ✅ |
| Docker Compose instalado | ✅ |
| SSL certificate configurado | ✅ |
| DNS configurado | ✅ |
| API keys configuradas | ✅ |
| Webhook endpoints configurados | ✅ |

### 4.2 Script de Deploy

```bash
#!/bin/bash
# scripts/deploy.sh

set -euo pipefail

echo "=== Carva Deployment ==="
echo "Branch: $BRANCH"
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# 1. Pull latest code
echo "→ Pulling latest code..."
git pull origin main

# 2. Install dependencies
echo "→ Installing dependencies..."
bundle install --without development test
npm ci --production

# 3. Run migrations
echo "→ Running database migrations..."
bundle exec rails db:migrate

# 4. Build assets
echo "→ Building assets..."
npm run build

# 5. Precompile assets
echo "→ Precompiling assets..."
bundle exec rails assets:precompile

# 6. Run seed tasks (if needed)
echo "→ Running seed tasks..."
bundle exec rails db:seed

# 7. Restart services
echo "→ Restarting services..."
docker compose restart web worker

# 8. Health check
echo "→ Running health check..."
sleep 5
curl -f http://localhost:3000/health || exit 1

echo "=== Deployment complete ==="
```

### 4.3 Variáveis de Ambiente (Produção)

```bash
# .env.production
RAILS_ENV=production
RAILS_LOG_LEVEL=info
RAILS_SERVE_STATIC_FILES=true
RAILS_MAX_THREADS=5
RAILS_LOG_TO_STDOUT=true

# Database
DATABASE_URL=postgresql://carva:password@localhost:5432/carva_prod

# Redis
REDIS_URL=redis://localhost:6379/0

# Sidekiq
SIDEKIQ_CONCURRENCY=10

# Stripe
STRIPE_SECRET_KEY=sk_live_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

# Twilio
TWILIO_AUTH_TOKEN=xxx
TWILIO_PHONE_NUMBER=+5511999999999

# Sentry
SENTRY_DSN=https://xxx@ingest.sentry.io/xxx

# SMTP
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=carva@carva.com
SMTP_PASSWORD=xxx

# CORS
CARVA_ALLOWED_ORIGINS=https://carva.com,https://www.carva.com

# CSP
CARVA_CSP_DEFAULT_SRC="'self'"
CARVA_CSP_SCRIPT_SRC="'self' cdn.carva.com"
CARVA_CSP_STYLE_SRC="'self' 'unsafe-inline'"
```

---

## 5. Scaling

### 5.1 Horizontal Scaling

```yaml
# docker-compose.prod.yml
services:
  web:
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  worker:
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
```

### 5.2 Auto-scaling (Kubernetes)

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: carva-web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: carva-web
  template:
    metadata:
      labels:
        app: carva-web
    spec:
      containers:
        - name: web
          image: carva/web:latest
          ports:
            - containerPort: 3000
          resources:
            requests:
              cpu: 500m
              memory: 512Mi
            limits:
              cpu: '2'
              memory: 2Gi
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: carva-web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: carva-web
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

---

## 6. Monitoring & Observability

### 6.1 Health Check

```bash
# Health check endpoint
GET /health

# Response
{
  "status": "healthy",
  "timestamp": "2026-01-10T14:30:00Z",
  "version": "1.0.0",
  "database": "connected",
  "redis": "connected",
  "sidekiq": "running"
}
```

### 6.2 Metrics

| Metric | Tipo | Descrição |
|--------|------|-----------|
| `carva.request.duration` | Histogram | Duração de request |
| `carva.request.count` | Counter | Contagem de requests |
| `carva.db.query.duration` | Histogram | Duração de query |
| `carva.sidekiq.queue.size` | Gauge | Tamanho da fila |
| `carva.sidekiq.processed` | Counter | Jobs processados |
| `carva.tenant.active_count` | Gauge | Tenants ativos |
| `carva.theme.render.duration` | Histogram | Tempo de renderização |

### 6.3 Logging

```ruby
# config/environments/production.rb
Rails.application.configure do
  config.logger = ActiveSupport::TaggedLogger.new(
    ActiveSupport::Logger.new(STDOUT)
  )

  config.log_tags = {
    tenant_id: -> { Current.tenant&.id },
    request_id: -> { RequestStore.store[:request_id] }
  }

  config.log_level = :info
  config.logger.formatter = config.log_formatter = Lograge.formatter
end
```

---

## 7. Backup & Disaster Recovery

### 7.1 Backup Strategy

| Recurso | Frequência | Retenção | Método |
|---------|-----------|----------|--------|
| PostgreSQL | Diária | 30 dias | `pg_dump` + S3 |
| Redis | Horária | 7 dias | `BGSAVE` + S3 |
| Assets | Diária | 14 dias | S3 sync |
| Database (full) | Semanal | 90 dias | `pg_dumpall` + S3 |

### 7.2 Backup Script

```bash
#!/bin/bash
# scripts/backup.sh

set -euo pipefail

BACKUP_DIR="/tmp/carva-backup-$(date +%Y%m%d-%H%M%S)"
S3_BUCKET="s3://carva-backups"

mkdir -p "$BACKUP_DIR"

# Backup PostgreSQL
echo "→ Backing up PostgreSQL..."
pg_dump -h localhost -U carva carva_prod > "$BACKUP_DIR/database.sql"
gzip "$BACKUP_DIR/database.sql"

# Backup Redis
echo "→ Backing up Redis..."
redis-cli BGSAVE
sleep 5
cp /data/dump.rdb "$BACKUP_DIR/redis-dump.rdb"

# Upload to S3
echo "→ Uploading to S3..."
aws s3 sync "$BACKUP_DIR" "$S3_BUCKET/$(date +%Y/%m/%d)/"

# Cleanup
echo "→ Cleaning up..."
rm -rf "$BACKUP_DIR"

echo "→ Backup complete!"
```

### 7.3 Recovery Time Objective (RTO)

| Cenário | RTO | RPO |
|---------|-----|-----|
| Database crash | 15 min | 1 hora |
| Application crash | 5 min | 0 |
| Full infrastructure | 1 hora | 1 hora |
| Regional outage | 4 horas | 4 horas |

---

## 8. SSL & HTTPS

### 8.1 Certificate Management

```bash
# Let's Encrypt (certbot)
sudo certbot --nginx -d carva.com -d www.carva.com
sudo certbot --nginx -d *.carva.com

# Auto-renewal
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

### 8.2 Nginx Config

```nginx
# /etc/nginx/sites-available/carva
server {
    listen 80;
    server_name carva.com www.carva.com *.carva.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name carva.com www.carva.com *.carva.com;

    ssl_certificate /etc/letsencrypt/live/carva.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/carva.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!eNULL:!PSK:!SEED:!IDEA:!3DES;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-XSS-Protection "1; mode=block" always;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /health {
        proxy_pass http://127.0.0.1:3000/health;
        access_log off;
    }
}
```

---

## 9. DNS Configuration

```
; Carva DNS Records
@           IN  A       203.0.113.1
www         IN  CNAME   carva.com.
*.carva     IN  CNAME   carva.com.
api         IN  CNAME   api.carva.com.
cdn         IN  CNAME   cdn.carva.com.
```

---

## 1.6 Gestão de Tarefas

Todas as mudanças de infraestrutura e deploy são rastreadas via sistema Kanban em `Kanban/`. Cada tarefa de deploy, CI/CD ou scaling deve ter um card em `TODO/` antes de começar.

---

*Documento vivo — atualize conforme a infraestrutura evolui.*
