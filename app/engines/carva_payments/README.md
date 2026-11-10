# Carva Payments Engine

## Responsabilidade

Gateway de pagamentos com integração Stripe, webhooks e processamento de transações.

## Namespace

`Carva::Payments`

## Dependências

- `carva_core`
- `carva_billing`

## Estrutura

```
carva_payments/
├── app/
│   ├── controllers/
│   ├── models/
│   ├── services/
│   └── workers/
├── config/
│   └── routes.rb
├── db/
│   └── migrate/
├── lib/
│   └── carva/payments.rb
├── spec/
├── carva_payments.gemspec
└── README.md
```
