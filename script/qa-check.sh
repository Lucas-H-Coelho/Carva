#!/usr/bin/env bash
# qa-check.sh — Verificação automática de qualidade para features Carva
#
# Uso:
#   ./script/qa-check.sh [diretorio]
#   Ex: ./script/qa-check.sh app/models/carva_core
#
# Retorna:
#   0 — tudo passou
#   1 — alguma verificação falhou

set -euo pipefail

TARGET="${1:-.}"
PASS=0
FAIL=0
WARNINGS=()

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_pass() { echo -e "  ${GREEN}✓${NC} $1"; PASS=$((PASS + 1)); }
log_fail() { echo -e "  ${RED}✗${NC} $1"; FAIL=$((FAIL + 1)); }
log_warn() { echo -e "  ${YELLOW}⚠${NC} $1"; WARNINGS+=("$1"); }

echo "========================================"
echo "  QA Check — $TARGET"
echo "========================================"
echo ""

# --- Migration ---
echo "📦 Migration"
if [ -d "$TARGET/db/migrate" ]; then
  for f in "$TARGET"/db/migrate/*.rb; do
    [ -f "$f" ] || continue
    basename_f=$(basename "$f")
    if grep -q 'def change' "$f" || grep -q 'def up' "$f" || grep -q 'def down' "$f"; then
      log_pass "$basename_f tem change/up/down"
    else
      log_fail "$basename_f sem change/up/down"
    fi
    if grep -q 'add_index' "$f"; then
      log_pass "$basename_f tem índices"
    else
      log_warn "$basename_f sem índices (pode ser OK para tabelas pequenas)"
    fi
  done
else
  log_warn "Nenhum diretório de migration encontrado"
fi

# --- Model ---
echo ""
echo "📋 Model"
if [ -d "$TARGET/app/models" ]; then
  for f in "$TARGET"/app/models/*.rb; do
    [ -f "$f" ] || continue
    basename_f=$(basename "$f")
    # Verificar validações
    if grep -q 'validates' "$f"; then
      log_pass "$basename_f tem validações"
    else
      log_warn "$basename_f sem validações explícitas"
    fi
    # Verificar enum com attribute (Rails 8.1)
    if grep -q 'enum.*attribute' "$f" || grep -q 'enum.*{' "$f"; then
      log_pass "$basename_f tem enum"
    else
      log_warn "$basename_f sem enum (pode ser OK)"
    fi
  done
else
  log_warn "Nenhum diretório de models encontrado"
fi

# --- Controller ---
echo ""
echo "🎮 Controller"
if [ -d "$TARGET/app/controllers" ]; then
  for f in "$TARGET"/app/controllers/*.rb; do
    [ -f "$f" ] || continue
    basename_f=$(basename "$f")
    # Verificar authenticate_request
    if grep -q 'authenticate_request' "$f"; then
      log_pass "$basename_f tem authenticate_request"
    else
      log_warn "$basename_f sem authenticate_request"
    fi
    # Verificar require_owner
    if grep -q 'require_owner' "$f"; then
      log_pass "$basename_f tem require_owner"
    else
      log_warn "$basename_f sem require_owner (pode ser OK)"
    fi
  done
else
  log_warn "Nenhum diretório de controllers encontrado"
fi

# --- Specs ---
echo ""
echo "🧪 Specs"
if [ -d "spec" ]; then
  spec_count=$(find spec -name '*_spec.rb' -type f 2>/dev/null | wc -l)
  if [ "$spec_count" -gt 0 ]; then
    log_pass "Encontrados $spec_count arquivos de spec"
  else
    log_fail "Nenhum arquivo de spec encontrado"
  fi
else
  log_fail "Diretório spec/ não existe"
fi

# --- Security ---
echo ""
echo "🔒 Segurança"
# Verificar multi-tenancy (tenant_id nas queries)
if grep -r 'where(tenant_id:' app/ 2>/dev/null | head -1 > /dev/null; then
  log_pass "Queries scoped por tenant_id encontradas"
else
  log_warn "Nenhuma query scoped por tenant_id encontrada"
fi

# Verificar API key nos logs
if grep -r 'mask.*api_key\|redact.*api_key\|filter.*api_key' config/ 2>/dev/null | head -1 > /dev/null; then
  log_pass "API key redatorada nos logs"
else
  log_warn "API key pode não estar redatorada nos logs"
fi

# Verificar CSP
if grep -r 'csp\|Content-Security-Policy' config/ 2>/dev/null | head -1 > /dev/null; then
  log_pass "CSP configurado"
else
  log_warn "CSP não encontrado"
fi

# Verificar CSRF
if grep -q 'protect_from_forgery' app/controllers/application_controller.rb 2>/dev/null; then
  log_pass "CSRF protegido"
else
  log_warn "CSRF não encontrado no application_controller"
fi

# Verificar SQL injection
if grep -rE 'where\(".*\$\{' app/ 2>/dev/null | head -1 > /dev/null; then
  log_fail "SQL injection possível (string interpolation no where)"
else
  log_pass "Sem SQL injection óbvio"
fi

# --- Docs ---
echo ""
echo "📚 Docs"
if [ -f "README.md" ]; then
  log_pass "README.md existe"
else
  log_warn "README.md não encontrado"
fi

# --- Summary ---
echo ""
echo "========================================"
echo "  Resultado: $PASS passados, $FAIL falhas"
if [ ${#WARNINGS[@]} -gt 0 ]; then
  echo "  ${#WARNINGS[@]} avisos"
fi
echo "========================================"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
