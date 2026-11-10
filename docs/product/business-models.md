# Modelos de Negócio — Carva

> **Status:** Draft — em revisão
> **Criado:** 2025-11-10
> **Objetivo:** Definir como o Carva será vendido e cobrado

---

## Visão Geral

O Carva será oferecido em **3 modalidades**, cada uma com seu público, preço e fluxo de cobrança:

| # | Modelo | Público | Cobrança |
|---|--------|---------|----------|
| 1 | **Mini PC + Instalação** | Lava que quer hardware local, controle total | Entrada única + mensalidade suporte |
| 2 | **SaaS Cloud** | Lava que quer começar rápido, sem hardware | Assinatura mensal |
| 3 | **Revenue Share** | Lava que não quer pagar nada upfront | % sobre serviços (2%) |

---

## 1. Mini PC + Instalação (On-Premise)

O cliente compra o equipamento, você instala e configura. Depois, paga uma mensalidade por suporte.

### Hardware

| Config | Specs | Custo (volume) | Preço de venda |
|--------|-------|----------------|----------------|
| **Starter** | Intel N100, 8GB RAM, 256GB SSD, Win11 Pro | ~R$ 1.100 | **R$ 1.499** |
| **Pro** | Intel N100, 16GB RAM, 512GB SSD, Win11 Pro | ~R$ 1.500 | **R$ 2.199** |

### Instalação + Treinamento

| Item | Custo | Preço |
|------|-------|-------|
| Deslocamento (ida/volta) | ~R$ 30–50 | Incluído |
| Mão de obra no local (2h) | ~R$ 200 | Incluído |
| Configuração remota (1h) | ~R$ 60 | Incluído |
| **Custo instalação** | **~R$ 290–310** | **Incluso no preço** |

#### Opções de Treinamento

| Tipo | Formato | Preço | Quando usar |
|------|---------|-------|-------------|
| **Presencial** | 1 visita (2–3h no local) | Incluído | Primeira instalação |
| **Online ao vivo** | Zoom/Meet, 1h, gravado | **+R$ 99** | Cliente não quer visita, ou está longe |
| **Online gravado** | Vídeo + PDF, auto-estudo | **+R$ 49** | Cliente quer aprender no ritmo dele |
| **Treinamento equipe** | Online, 2h, até 3 pessoas | **+R$ 149** | Dono quer treinar funcionários também |

> **Dica:** Ofereça presencial + online ao vivo como padrão. Gravação e equipe como upsell.

### Fluxo de Vendas

```
1. Cliente mostra interesse
2. Você envia orçamento (R$ 1.499 ou R$ 2.199)
3. Cliente escolhe:
   a) Instalação presencial (incluído)
   b) Online ao vivo (+R$ 99)
   c) Online gravado (+R$ 49)
   d) Pacote completo: presencial + equipe (+R$ 149)
4. Cliente paga via PIX/boleto
5. Você envia o Mini PC (frete grátis)
6. Agenda instalação/treinamento
7. Entra no plano de suporte mensal
```

### 🎓 Seção de Treinamento de Uso

O Carva inclui uma **área de treinamento** dentro do próprio app, acessível pelo dono e funcionários.

#### Estrutura

| Módulo | Conteúdo | Formato | Duração |
|--------|----------|---------|---------|
| **M1 — Primeiros passos** | Criar conta, configurar unidade, cadastrar serviços | Vídeo 5 min | 5 min |
| **M2 — Agendamento** | Como o cliente agenda, como você confirma | Vídeo 8 min | 8 min |
| **M3 — Fluxo de caixa** | Registrar pagamento, ver resumo do dia | Vídeo 10 min | 10 min |
| **M4 — Estoque** | Adicionar produtos, ver alertas, pedir reposição | Vídeo 8 min | 8 min |
| **M5 — Equipe** | Adicionar funcionários, distribuir carros, ver comissões | Vídeo 12 min | 12 min |
| **M6 — Relatórios** | Exportar PDF/Excel, comparar unidades | Vídeo 10 min | 10 min |
| **Quiz de validação** | 5 perguntas pra liberar o acesso completo | Quiz | 3 min |

#### Acesso

```
App → Menu → "Como usar o Carva"
  → Lista de módulos (M1–M6)
  → Cada módulo: vídeo + PDF + quiz
  → Ao completar: desbloqueia módulo seguinte
  → Quiz final: aprova o usuário como "formado"
```

#### Por que ter isso?

- **Reduz suporte** — cliente que treinou precisa 60% menos ligações
- **Escala o onboarding** — 1 vídeo = 100 clientes, sem custo adicional
- **Qualifica o lead** — quem completa o quiz já tá engajado, churn menor
- **Base pra upsell** — módulo "equipe" só aparece se tiver +1 funcionário

#### No futuro

- **M7 — WhatsApp** | Configurar notificações, templates | Vídeo 8 min | 8 min
- **M8 — Fidelidade** | Pontos, créditos, indicações | Vídeo 10 min | 10 min
- **M9 — Troubleshooting** | Erros comuns, como resolver | Vídeo 15 min | 15 min
- **M10 — Avançado** | API, tema custom, integrações | Vídeo 20 min | 20 min

---

### Mensalidade de Suporte

| Plano | Preço | Inclui |
|-------|-------|--------|
| **Básico** | **R$ 79/mês** | Atualizações, monitoramento, 2h suporte remoto/mês |
| **Completo** | **R$ 149/mês** | + backup remoto, + WhatsApp config, + 4h remoto/mês |
| **Premium** | **R$ 249/mês** | + SLA 24h, + 1 visita presencial/mês, + treinamento equipe |

### Fluxo de Vendas

```
1. Cliente mostra interesse
2. Você envia orçamento (R$ 1.499 ou R$ 2.199)
3. Cliente paga via PIX/boleto
4. Você envia o Mini PC (frete grátis)
5. Agenda instalação (1 visita de 2-3h)
6. Configura + treina o dono
7. Entra no plano de suporte mensal
```

### Vantagens

- ✅ Receita inicial alta (R$ 1.499–2.199)
- ✅ Cliente comprometido (pagou upfront)
- ✅ Zero custo de infra pra você
- ✅ Dados do cliente ficam locais (argumento de venda)

### Desvantagens

- ❌ Mão de obra não escala (1 visita = 3h do seu dia)
- ❌ Custo de deslocamento por cliente
- ❌ Limite natural de ~10 instalações/mês (se fizer sozinho)

### Escala da mão de obra

```
Fase 1 (0-10 clientes): Você instala
Fase 2 (10-50 clientes): Treina 1 técnico local
  → Ele cobra R$ 150, você paga R$ 100
  → Margem de R$ 50 por instalação
Fase 3 (50+ clientes): Rede de técnicos por região
  → Você indica, técnico cobra do cliente
  → Você ganha R$ 79/mês de suporte (sem custo)
```

---

## 2. SaaS Cloud (Multi-tenant)

Você hospeda, cliente usa pelo celular. Assinatura mensal.

### Planos

| Plano | Preço | Inclui |
|-------|-------|--------|
| **Lava** | **R$ 49/mês** | 1 unidade, 1 funcionário, agendamento, caixa, WhatsApp básico |
| **Lava Pro** | **R$ 99/mês** | 1 unidade, funcionários ilimitados, relatórios, estoque, fidelidade |
| **Rede** | **R$ 199/mês** | Até 5 unidades, dashboard consolidado, transferências, metas |
| **Rede Plus** | **R$ 399/mês** | Unidades ilimitadas, API, tema custom, suporte prioritário |

### Add-ons (avulso)

| Add-on | Preço |
|--------|-------|
| 📱 WhatsApp notifications | +R$ 29/mês |
| 📊 Relatórios avançados (PDF/Excel) | +R$ 19/mês |
| 🎨 Tema premium | +R$ 39/mês |
| 📸 Fotos antes/depois | +R$ 19/mês |
| 🔔 SMS (fallback) | +R$ 0,10/mensagem |

### Fluxo de Vendas

```
1. Cliente acessa carva.com.br
2. Cria conta grátis (trial 30 dias)
3. Configura em < 15 minutos
4. Começa a usar
5. No dia 30, escolhe plano ou para
```

### Vantagens

- ✅ Onboarding auto (sem contato humano)
- ✅ Escala exponencial (1 servidor = 100+ clientes)
- ✅ Visibilidade total do uso
- ✅ Upsell natural (add-ons, upgrade de plano)

### Desvantagens

- ❌ Você paga infra
- ❌ Support overhead (clientes não técnicos)
- ❌ Churn mais fácil (cancela sem custo de saída)

### 🔮 Melhorias Futuras (não implementar agora)

| # | Melhoria | Quando | Impacto |
|---|----------|--------|---------|
| 1 | **Preço anual com desconto** (R$ 490/ano vs R$ 588) | Fase 3 | Reduz churn, aumenta LTV |
| 2 | **Plano família** (2 unidades no mesmo preço) | Fase 3 | Captura redes pequenas |
| 3 | **Cobrança por uso real** (R$ 0,50 por agendamento) | Fase 4 | Alinha preço ao volume |
| 4 | **Marketplace de lavas** (visibilidade cruzada) | Fase 4 | Network effect, retenção |
| 5 | **White-label para franqueadores** | Fase 5 | Canal de vendas indireto |
| 6 | **Data-as-a-Service** (venda de insights anônimos) | Fase 5 | Receita extra, zero custo |

> **Nota:** Manter essa seção como referência. Implementar só quando o produto estiver estável e com > 50 clientes ativos.

---

## 3. Revenue Share (Pay-per-Service)

Grátis pra começar. Você ganha 2% sobre cada serviço pago via PIX/cartão.

### Mecânica

| Item | Detalhe |
|------|---------|
| **Setup** | R$ 0 — cadastro auto |
| **Cobrança** | 2% sobre cada serviço pago |
| **Mínimo** | R$ 9/mês (cap de 2% = ~R$ 450/mês de serviços) |
| **Upgrade** | Se faturar > R$ 450/mês, migra pro Lava Pro (R$ 99) |

### Exemplo real

```
Lava Bravas fatura R$ 2.000/mês em serviços
→ Você ganha: 2% × R$ 2.000 = R$ 40/mês
→ Lava Pro custa R$ 99/mês → ele migra (economiza R$ 59)
→ Você ganha R$ 99/mês fixo
```

### Vantagens

- ✅ Zero fricção inicial
- ✅ Alinhamento total de interesses
- ✅ Auto-escalável
- ✅ Natural upgrade path

### Desvantagens

- ❌ Receita menor no início
- ❌ Dificuldade de medir faturamento real (depende do gateway)
- ❌ Cliente pode evitar pagamento via gateway pra "escapar" da taxa

### 🔮 Melhorias Futuras (não implementar agora)

| # | Melhoria | Quando | Impacto |
|---|----------|--------|---------|
| 1 | **Cobrança por agendamento** (R$ 0,50 por agendamento concluído) | Fase 4 | Mais previsível que % |
| 2 | **Taxa fixa mínima** (R$ 19/mês se faturar < R$ 950) | Fase 4 | Protege contra uso mínimo |
| 3 | **Split automático** (2% vai direto do PIX pra sua conta) | Fase 4 | Elimina risco de evasão |
| 4 | **Bônus de volume** (0,5% se faturar > R$ 5.000/mês) | Fase 5 | Incentiva crescimento |
| 5 | **Integração com banco** (relatório automático de fluxo) | Fase 5 | Validação cruzada de faturamento |

> **Nota:** Manter como referência. Implementar só quando o produto estiver estável e com > 50 clientes ativos.

---

## Comparação

| Fator | Mini PC | SaaS Cloud | Revenue Share |
|-------|---------|------------|---------------|
| **Receita inicial** | ✅ Alta (R$ 1.499) | ❌ Zero | ❌ Zero |
| **Receita mensal** | ✅ R$ 79–249 | ✅ R$ 49–399 | ✅ Variável (2%) |
| **Custo infra** | ✅ Zero | ❌ Você paga | ❌ Você paga |
| **Custo suporte** | ❌ Alto (visita) | ✅ Baixo (remoto) | ✅ Baixo (remoto) |
| **Barreira entrada** | ❌ Alta | ✅ Zero | ✅ Zero |
| **Churn** | ✅ Baixo | ❌ Alto | ✅ Médio |
| **Escalabilidade** | ❌ Linear | ✅ Exponencial | ✅ Exponencial |
| **Dados** | ✅ Cliente controla | ❌ Você controla | ❌ Você controla |

---

## Recomendação: Hybrid Model

```
┌─────────────────────────────────────────────────────┐
│              Carva — Hybrid Pricing                  │
├─────────────────────────────────────────────────────┤
│                                                     │
│  CAMPO GRANDE (massa)                               │
│  → SaaS Cloud (R$ 49–199/mês)                       │
│  → Zero fricção, auto-onboarding, escala exponencial│
│                                                     │
│  LAVA BRABAS (enterprise local)                     │
│  → Mini PC + instalação (R$ 1.499 entrada + R$ 79) │
│  → Cliente quer dados locais, tem 5 unidades        │
│                                                     │
│  INICIANTE (caça)                                   │
│  → Revenue Share (2% sobre serviços)                │
│  → Zero upfront, alinha interesses                  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Fluxo do cliente

```
Free trial (30 dias)
  → (usa muito) → Lava Pro R$ 99/mês
  → (usa pouco) → Revenue Share 2%
  → (quer local) → Mini PC R$ 1.499 + R$ 79/mês
```

---

## Próximos Passos

| # | Ação | Responsável | Status |
|---|------|-------------|--------|
| 1 | Criar cards Kanban para billing multi-tier | Agente | Pendente |
| 2 | Implementar trial de 30 dias no SaaS | Agente | Pendente |
| 3 | Montar pacote Mini PC (comprar 2 unidades piloto) | Você | Pendente |
| 4 | Criar playbook de instalação (checklist, config) | Agente | Pendente |
| 5 | Vender primeiro Mini PC pra um lava conhecido | Você | Pendente |
| 6 | Lançar SaaS cloud pra massa | Agente | Pendente |

---

*Documento vivo — atualize conforme o projeto evolui.*
