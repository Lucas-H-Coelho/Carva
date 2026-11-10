# S1 — Dono do Lava-Carro

## Perfil

**Nome:** Carlos Eduardo da Silva, 42 anos  
**Negócio:** Lava-Carro "LavaBravas" — 2 unidades (uma principal no bairro, uma filial em expansão)  
**Equipe:** 6 funcionários fixos + 2 temporários nos fins de semana  
**Faturamento mensal:** R$ 18.000 a R$ 25.000  
**Perfil tecnológico:** Sabe usar WhatsApp, Instagram, Pix e app do banco no celular. Já tentou usar planilha do Google mas desistiu porque "ficava bagunçado". Usa caderno de papel para anotar agendamento e estoque, mas perde folhas e esquece de olhar.  
**Dispositivo principal:** Smartphone Android Samsung Galaxy A14, tela 6.5". Usa WhatsApp o dia todo para falar com cliente. Instagram para postar foto do carro lavado. App do banco para verificar saldo.  
**Dor principal:** Não sabe quanto entrou no mês, não sabe quantos carros faltam lavar, não sabe se acabou o shampoo, e perde clientes porque não consegue responder rápido no WhatsApp.  
**Objetivo:** Queria um sistema que funcionasse no celular, que fosse fácil de usar, que me avisasse quando tem agendamento, que me mostrasse quanto entrei no dia, e que me ajudasse a não ficar devendo fornecedor.

---

## Fluxo do Dia a Dia

### Manhã (7h — 12h)

1. **Abro o sistema pelo celular** — vejo a tela principal com:
   - Quantos carros têm agendados hoje (ex: "5 carros para hoje")
   - Quanto entrou ontem (ex: "R$ 850,00")
   - Se tem estoque baixo (ex: "Shampoo: 2 litros restantes")
   - Notificação: "Maria agendou lavagem completa para 14h"

2. **Confiro a fila do dia** — rolo para baixo e vejo a lista de carros com:
   - Nome do cliente
   - Horário agendado
   - Tipo de lavagem (simples, completa, premium)
   - Status (pendente, em andamento, concluído)

3. **Marco os primeiros como "em andamento"** — clica no botão e muda a cor pra amarelo

4. **Compro reposição se necessário** — se o sistema avisou estoque baixo, anoto no caderno ou já peço pro fornecedor pelo WhatsApp

### Tarde (12h — 18h)

5. **Acompanho o progresso** — entro de novo no sistema, vejo quantos já foram lavados e quantos faltam

6. **Respondo clientes no WhatsApp** — uso atalhos do sistema para enviar mensagem pronta: "Seu carro está pronto para retirada!"

7. **Finalizo o dia** — clico em "Fechar expediente" e vejo:
   - Total do dia (R$ X)
   - Quantidade de carros lavados
   - Clientes que não apareceram (faltaram)

### Final de Semana (sábado e domingo)

8. **Dia mais corrido** — sem tempo de abrir o sistema no meio do dia. Só abro na sexta à noite para ver a agenda de sábado e no domingo à noite para fechar.

---

## Fluxo de Atendimento Walk-in

### O que é "walk-in"?

É quando o cliente chega no lava-carro **sem agendamento**, na hora. Tipo: "Boa tarde, meu carro tá sujo, pode lavar?" — e eu atendo na hora, sem marcar nada antes.

No meu lava-carro, **sábado e domingo das 13h às 17h** é horário exclusivo pra walk-in. Não aceito agendar nesse horário — é pra quem chega na hora.

### Passo a passo — Cliente chega sem agendamento

#### Passo 1 — Cliente chega e eu verifico disponibilidade

- **O que eu faço:** Abro o app no celular, vou na tela "Agenda de hoje" e rolo pra ver quantos carros já estão na fila e a que horas.
- **O que o sistema me mostra:**
  - "Hoje tem 5 carros agendados. Próximo horário livre: 15h30."
  - Se tiver horário livre, o sistema mostra em verde: "Tem vaga sim!"
  - Se não tiver, o sistema mostra em vermelho: "Sem vaga agora. Próximo horário: 17h00."
- **Se eu não tiver tempo de abrir o app agora:** Falo pro cliente: "Me dá 1 minutinho que eu verifico aqui" — abro rápido, vejo, e respondo.

#### Passo 2 — Se tem vaga, eu registro o atendimento

- **O que eu faço:** Clico no botão "Novo atendimento walk-in" (tem um botão grande verde no canto da tela).
- **O que preencho:**
  - Nome do cliente (se ele disser)
  - Telefone (se ele quiser receber mensagem de pronto)
  - Modelo do carro (se eu souber)
  - Tipo de lavagem: simples, completa ou premium
  - Horário: o sistema já preenche o próximo horário livre automaticamente
- **Se o cliente não quiser dar telefone:** Deixo o campo vazio. O sistema avisa: "Telefone opcional."

#### Passo 3 — Se não tem vaga, eu agendo pra depois

- **O que eu faço:** Clico em "Agendar pra depois" no lugar de "Atender agora".
- **O que o sistema mostra:** "Próximo horário livre: 17h00. Quer marcar pra esse horário?"
- **Se o cliente aceitar:** Registro como agendamento normal (mesmo fluxo do passo 2).
- **Se o cliente não quiser esperar:** Falo: "Tudo bem, pode voltar mais tarde. Se quiser, eu mando um lembrete quando tiver vaga." — o sistema pode enviar um lembrete automático se eu ativar essa função.

#### Passo 4 — Início do serviço

- **O que eu faço:** Quando chegar a hora, clico no atendimento na lista e depois em "Iniciar".
- **O que o sistema faz:** Muda o status pra "em andamento" (cor amarela) e começa a contar o tempo estimado.
- **Se eu demorar mais que o estimado:** O sistema avisa: "Tempo estimado ultrapassado. Próximo agendamento em 15 min." — pra eu saber se consigo ou não encaixar outro walk-in.

#### Passo 5 — Finalização e pagamento

- **O que eu faço:** Quando o carro estiver lavado, clico em "Concluído".
- **O que o sistema faz:**
  - Mostra o valor da lavagem (ex: "Lavagem Completa — R$ 50,00")
  - Mostra as opções de pagamento: "PIX, Dinheiro, Cartão"
  - Eu clico no método que o cliente escolheu
- **Se o cliente pagar em dinheiro:**
  - O sistema pergunta: "Quanto o cliente deu?" (ex: "Deu R$ 100,00")
  - O sistema calcula o troco automaticamente: "Troco: R$ 50,00"
  - Eu confirmo e o sistema registra: "Pagamento em dinheiro — troco R$ 50,00"
- **Se o cliente pagar em PIX:**
  - O sistema mostra: "PIX confirmado" (se eu já vi a transferência no app do banco)
  - Ou eu posso marcar "Aguardando PIX" e depois confirmar quando o dinheiro cair

#### Passo 6 — Registro de histórico

- **O que o sistema faz automaticamente:**
  - Salva o atendimento no histórico do cliente (se ele tem cadastro)
  - Se o cliente é novo, o sistema pergunta: "Quer cadastrar esse cliente?" — eu clico em "Sim" ou "Não"
  - Se eu cadastrar, o sistema salva: nome, telefone, carro, tipo de lavagem, data, valor
- **O que eu ganho com isso:** Na próxima vez que o cliente vier, o sistema já mostra: "João — Lavagem Completa em 15/10, 02/11. Último pagamento: PIX."

#### Resumo visual — Fluxo walk-in no celular

```
Cliente chega
  → Abro app → Tela "Agenda de hoje"
  → Verifico: tem vaga?
    → Sim → Botão "Novo atendimento walk-in" → Preencho → Horário automático
    → Não → Botão "Agendar pra depois" → Mostro próximo horário livre
  → Chega a hora → Clico "Iniciar" → Amarelo
  → Terminei → Clico "Concluído" → Mostro valor → Clico método de pagamento
  → Sistema salva histórico automaticamente
```

---

## Tarefas Essenciais (MVP)

- [ ] **Ver agenda do dia** — ver quantos carros estão agendados, horários, e status
- [ ] **Criar agendamento** — adicionar novo agendamento manualmente ou por mensagem do WhatsApp
- [ ] **Atualizar status do serviço** — marcar como "em andamento", "concluído", "cancelado"
- [ ] **Cadastrar cliente** — nome, telefone, carro (modelo/placa)
- [ ] **Listar serviços disponíveis** — ver os tipos de lavagem com preço e tempo estimado
- [ ] **Cadastrar preço de serviço** — definir quanto cobra por tipo de lavagem
- [ ] **Controlar estoque de insumos** — ver quantos litros/kg de cada produto restam
- [ ] **Adicionar/repor estoque** — registrar quando comprou mais shampoo, cera, etc.
- [ ] **Verificar fluxo de caixa do dia** — ver quanto entrou, quanto saiu, saldo do dia
- [ ] **Registrar pagamento** — marcar se o cliente pagou (PIX, dinheiro, cartão)
- [ ] **Enviar mensagem de confirmação** — confirmar agendamento automaticamente pro cliente
- [ ] **Enviar mensagem de pronto** — avisar quando o carro estiver lavado
- [ ] **Verificar estoque baixo** — receber alerta quando produto estiver acabando
- [ ] **Listar clientes** — ver todos os clientes cadastrados e histórico de serviços
- [ ] **Cancelar/agendar serviço** — reagendar ou cancelar quando o cliente ligar
- [ ] **Registrar atendimento walk-in** — quando cliente chega sem agendamento, registrar na hora na fila do dia
- [ ] **Separar caixa do negócio** — registrar quanto entra do negócio e quanto tiro pra mim, tudo separado
- [ ] **Registrar despesa do negócio** — anotar quando compro shampoo, pago água/luz, conserto equipamento
- [ ] **Ver lucro do dia** — ver faturamento menos despesas menos retiradas pessoais, tudo de uma vez

---

## Tarefas Desejáveis (Nice-to-have)

- [ ] **Agendamento online** — cliente agenda pelo link do sistema sem ligar
- [ ] **Cartão fidelidade** — a cada 5 lavagens, a 6ª é metade do preço
- [ ] **Mensagem automática de aniversário** — mandar parabéns com desconto pro cliente
- [ ] **Relatório mensal de faturamento** — ver quanto entrou no mês vs mês anterior
- [ ] **Relatório de clientes mais frequentes** — saber quem são os clientes fiéis
- [ ] **Relatório de serviços mais vendidos** — saber qual lavagem vende mais
- [ ] **Cupom de desconto** — gerar cupom para indicar amigo
- [ ] **Avaliação do serviço** — cliente nota de 1 a 5 depois da lavagem
- [ ] **Notificação push** — receber alerta no celular quando chegar agendamento novo
- [ ] **Backup automático** — sistema salva tudo na nuvem, não perde nada
- [ ] **Multi-unidade** — gerenciar as 2 unidades do mesmo lugar
- [ ] **Gestão de funcionários** — ver quem trabalhou, quanto ganhou por comissão
- [ ] **Emissão de nota fiscal** — emitir NF-e integrada
- [ ] **Planilha de exportação** — baixar relatório em Excel/CSV
- [ ] **Chat integrado** — conversar com cliente dentro do sistema sem sair

---

## Pain Points Atuais

- [ ] **Perdo agendamentos** — anoto no caderno de papel, perco a folha, esqueço o horário
- [ ] **Não sei quanto entrei no dia** — misturo dinheiro do caixa com dinheiro pessoal, não consigo separar
- [ ] **Perco clientes por demora** — demoro demais pra responder WhatsApp porque tô lavando carro, perco a oportunidade
- [ ] **Estoque acaba sem avisar** — fico sem shampoo ou cera no meio do dia, tenho que parar serviço
- [ ] **Não consigo controlar comissão** — não sei quanto devo pagar cada funcionário no fim do mês
- [ ] **Fim de semana não tenho tempo** — sábado e domingo é corrido demais, não consigo anotar nada
- [ ] **Cliente liga e eu não sei a agenda** — tô no meio do serviço e o telefone toca, não tenho como consultar rápido
- [ ] **Não tenho visão mensal** — no fim do mês não sei se dei lucro ou só pagarei contas
- [ ] **Não consigo dar desconto personalizado** — cliente pede desconto, eu não sei se já veio 3 vezes esse mês
- [ ] **Perco histórico do cliente** — quando o cliente vem outra vez, não sei que tipo de lavagem ele já fez
- [ ] **Dinheiro do PIX não identifico** — recebo PIX mas não sei qual cliente pagou qual valor
- [ ] **Não consigo cobrar adiantado** — queria pedir sinal pro cliente, mas não tenho como gerar link de pagamento
- [ ] **Perco agendamentos se sistema cair** — se a internet falhar ou o sistema não abrir, não tenho como consultar a agenda e perco clientes
- [ ] **Walk-in desorganiza o dia** — quando o cliente chega sem agendamento, não sei encaixar na fila, cobro errado ou perco o atendimento
- [ ] **Dinheiro do negócio misturado com o pessoal** — no fim do dia não sei quanto sobou do negócio pra pagar conta e quanto posso tirar pra mim

---

## Onboarding

### Como eu me cadastro e configuro o sistema pela primeira vez

**Passo 1 — Cadastro (2 minutos)**
- Abro o app ou site
- Coloco meu nome, telefone com WhatsApp, e CPF
- Clico em "Começar"

**Passo 2 — Configurar lava-carro (3 minutos)**
- Nome do lava-carro: "LavaBravas"
- Endereço (opcional, pra futuro)
- Tipo de negócio: "Lava-carro com equipe"
- Quantas unidades: "1" (posso adicionar outra depois)

**Passo 3 — Configurar serviços (5 minutos)**
- O sistema já traz sugestões: Lavagem Simples (R$ 30), Lavagem Completa (R$ 50), Lavagem Premium (R$ 80)
- Posso aceitar os valores padrão ou mudar
- Posso adicionar mais serviços (ex: "Cera", "Polimento", "Limpeza Interna")
- Defino o tempo estimado de cada um

**Passo 4 — Configurar estoque inicial (3 minutos)**
- O sistema sugere produtos comuns: Shampoo automotivo, Cera, Cera Seca, Desinfetante, Toalha
- Coloco quanto tenho de cada um (ex: "Shampoo: 5 litros")
- Defino o nível mínimo de alerta (ex: "Avisar quando ficar com menos de 1 litro")

**Passo 5 — Primeiro agendamento (1 minuto)**
- O sistema mostra um botão "Criar primeiro agendamento"
- Coloco nome do cliente, telefone, carro, tipo de lavagem, horário
- Pronto, sistema está configurado

**Total de tempo:** ~14 minutos. Sem complicação, sem configuração técnica.

---

## Cenário de Emergência

### O que acontece se o sistema cair, a internet falhar ou meu celular quebrar?

#### Cenário 1 — Internet falhando ou fora do ar

- **O que eu vejo:** O app fica cinza, não carrega nada. Mensagem: "Sem conexão. Verifique sua internet."
- **O que eu preciso fazer:**
  - Os agendamentos do dia já estão salvos no celular (modo offline). Mesmo sem internet, consigo ver a lista de quem tem carro hoje.
  - Se eu marcar um agendamento novo sem internet, ele fica "pendente" e sincroniza quando a internet voltar.
  - Se eu marcar status de serviço (ex: "concluído"), também salva localmente e sincroniza depois.
- **Como eu sei que está funcionando offline:** Tem um ícone de nuvem com um raio no canto da tela. Se estiver cinza, tá offline. Se estiver azul, tá online.
- **O que eu perco sem internet:** Não consigo enviar mensagem pro cliente pelo WhatsApp automático, não consigo ver o histórico de outros dias, e não consigo exportar relatório. Mas consigo trabalhar normalmente no dia.

#### Cenário 2 — Celular quebrou ou sumiu

- **O que eu preciso para não perder dados:**
  - Tenho um **caderno de papel** que o sistema já me ensinou a usar no onboarding. Nele, anoto: nome do cliente, telefone, carro, horário e tipo de lavagem.
  - Se eu tiver um **celular reserva** (mesmo um mais simples), posso instalar o app nele e fazer login com o mesmo cadastro.
  - Se eu não tiver celular reserva, posso **emprestar um celular** de um funcionário ou familiar — o sistema funciona em qualquer celular, não precisa ser o meu.
- **Como recupero meus dados:**
  - Abro o app no celular novo, faço login com o mesmo telefone e CPF.
  - Todos os dados estão na nuvem (salvos automaticamente). Basta fazer login e pronto.
  - Se eu anotou coisas no caderno de papel durante o período sem celular, posso **digitar manualmente** os agendamentos depois — o sistema aceita cadastrar agendamento com data passada.
- **Backup manual do caderno de papel:** Todo dia, antes de fechar o expediente, tiro uma foto do caderno com o celular e mando pra mim mesma no WhatsApp. Assim, mesmo que o caderno perca, tenho a foto.

#### Cenário 3 — Sistema fora do ar (servidor do lava-carro)

- **O que eu vejo:** O app mostra "Servidor indisponível. Tente daqui a 5 minutos."
- **O que eu preciso fazer:**
  - Continuar atendendo no caderno de papel. Anotar tudo: quem veio, que tipo de lavagem, quanto cobrou, como pagou.
  - O sistema tem um **botão "Exportar agendamentos do dia"** que gera um PDF com nome, telefone, carro, horário e tipo de lavagem. Se eu tiver internet, tiro esse PDF antes de dormir e guardo no WhatsApp.
  - Se não tiver internet, a foto do caderno já serve como backup.
- **Quanto tempo demora pra voltar:** O sistema avisa quando voltar. Se demorar mais de 1 hora, posso ligar no suporte pelo WhatsApp (tem o número salvo no app).

#### Cenário 4 — Esqueci o celular em casa ou a bateria acabou

- **O que eu preciso:**
  - Um **funcionário de confiança** pode acessar a agenda dele no próprio celular e ver quantos carros têm pra hoje.
  - Se eu precisar consultar algo urgente, posso ligar pro funcionário e ele me lê a tela do app dele.
- **Como evito isso no futuro:**
  - Manter o celular carregando à noite (tenho uma tomada perto da cama).
  - Ter um power bank (carregador portátil) na bolsa ou no carro.

#### Resumo — O que eu preciso ter sempre à mão

| Item | Por que | Onde guardar |
|------|---------|-------------|
| Caderno de papel + caneta | Anotar agendamentos se sistema cair | Mesa do caixa |
| Celular carregando à noite | Não ficar sem acesso | Tomada perto da cama |
| Power bank | Celular sem bateria fora de casa | Bolsa ou gaveta do caixa |
| Foto do caderno no WhatsApp | Backup se perder o caderno | Enviada todo dia pro meu próprio WhatsApp |
| Número do suporte no WhatsApp | Ligar se sistema não voltar | Salvo nos contatos do celular |

---

## Regras de Negócio

- **Horário de funcionamento:** Segunda a sábado, 7h às 18h. Domingo fecha (mas posso mudar).
- **Serviços e preços:** Cada tipo de lavagem tem um preço fixo. Posso mudar quando quiser. No fim de semana, posso cobrar mais (ex: +R$ 10 na lavagem completa).
- **Tempo de serviço:** Lavagem simples = 30 min, Completa = 60 min, Premium = 90 min. O sistema usa isso pra não agendar dois carros no mesmo horário.
- **Pagamento:** O cliente paga no ato (dinheiro, PIX ou cartão). O sistema registra como "pendente" até o cliente pagar. PIX é o mais usado (~70% dos pagamentos).
- **Adiantamento/Sinal:** Quero cobrar 50% adiantado via PIX pra garantir o agendamento. O sistema deve registrar o sinal e o restante na retirada.
- **Estoque:** Cada serviço consome uma quantidade do insumo. Ex: Lavagem Completa gasta 0.5L de shampoo. O sistema deve descontar automaticamente.
- **Cancelamento:** Se o cliente cancelar com mais de 2h de antecedência, não cobra nada. Se faltar menos de 2h, cobra 50%. Se não aparecer ("no-show"), cobra 100%.
- **Comissão funcionário:** Quero pagar por carro lavado. Simples = R$ 5, Completa = R$ 8, Premium = R$ 12. O sistema deve calcular por funcionário.
- **Agendamento:** Só aceito agendamento para o mesmo dia ou dia seguinte. Não aceito agendar com mais de 3 dias de antecedência.
- **Clientes recorrentes:** Cliente que veio 3 vezes no mês recebe 10% de desconto na 4ª lavagem.
- **Multi-unidade:** Se eu tiver 2 unidades, cada uma tem seu próprio caixa, estoque e agenda.
- **Horário de pico:** Sexta e sábado das 13h às 17h não aceito agendar — é horário de atendimento walk-in (sem agendamento).

---

## Gestão de Caixa

### Por que eu preciso disso?

Hoje eu misturo o dinheiro do lava-carro com o dinheiro da minha casa. Quando preciso pagar água, luz ou shampoo, não sei se tem dinheiro suficiente. No fim do mês, não sei se dei lucro ou só pagué contas. Quero separar o dinheiro do negócio do pessoal e saber exatamente quanto entra e quanto sai.

### Passo 1 — Separar o dinheiro do negócio do pessoal

- **O que eu faço:** Tenho uma **caixinha de papel** (ou um envelope) no caixa do lava-carro. Todo dinheiro que entra do negócio vai pra lá.
- **No sistema:** Tem um botão "Separar caixa do negócio" — eu clico e o sistema começa a registrar tudo que é do negócio separadamente.
- **Regra:** Todo dinheiro que entra de lavagem vai pra caixinha do negócio. Todo dinheiro que eu tiro pra mim vai pra caixinha pessoal.
- **Se eu tiro dinheiro pra mim:** Clico em "Retirar pra pessoal" no sistema, coloco o valor, e o sistema registra: "Carlos tirou R$ 200,00 pra uso pessoal — 10/11."

### Passo 2 — Registrar quanto entrou no dia

- **O que eu faço no fim do dia:** Clico em "Fechar expediente" e vejo:
  - "Hoje entrou: R$ 1.250,00"
  - "PIX: R$ 850,00 (17 pagamentos)"
  - "Dinheiro: R$ 400,00 (8 pagamentos)"
  - "Cartão: R$ 0,00 (0 pagamentos)"
- **Se eu não fechei o expediente no dia:** O sistema avisa no dia seguinte: "Você não fechou o expediente de ontem. Faltam R$ 350,00 não registrados."

### Passo 3 — Registrar quanto saiu no dia (despesas do negócio)

- **O que eu registro como despesa do negócio:**
  - Compra de shampoo, cera, toalha (fornecedor)
  - Conta de água, luz, internet
  - Taxa do cartão de crédito
  - Reparo no equipamento (ex: consertou a bomba de água)
  - Combustível do carro (se eu uso o carro do lava-carro pra ir ao fornecedor)
- **Como registro:** Clico em "Nova despesa", escolho a categoria, coloco o valor e a data.
- **O que o sistema mostra:** "Despesas do negócio este mês: R$ 2.300,00" — dividido por categoria.

### Passo 4 — Registrar quanto eu tiro pra mim (despesas pessoais)

- **O que eu registro como despesa pessoal:**
  - Mercado da casa
  - Conta de luz do meu apartamento
  - Almoço, transporte pessoal
  - Qualquer coisa que não tem a ver com o lava-carro
- **Como registro:** Clico em "Nova despesa pessoal", coloco o valor e a descrição.
- **O que o sistema mostra:** "Retiradas pessoais este mês: R$ 800,00" — separado das despesas do negócio.

### Passo 5 — Controle de troco

- **Quando o cliente paga em dinheiro:**
  - O sistema pergunta: "Quanto o cliente deu?"
  - Ex: Lavagem R$ 50,00 — cliente deu R$ 100,00
  - O sistema calcula: "Troco: R$ 50,00"
  - Eu confirmo e o sistema registra: "Troco dado: R$ 50,00"
- **No fim do dia:** O sistema mostra:
  - "Dinheiro no caixa: R$ 400,00"
  - "Troco dado hoje: R$ 150,00"
  - "Saldo real em dinheiro: R$ 250,00"
- **Se o dinheiro não bater:** O sistema avisa: "Faltam R$ 30,00 no caixa. Verifique os trocos."

### Passo 6 — Controle de contas a pagar

- **O que eu registro:**
  - Água: R$ 180,00/mês — vence todo dia 15
  - Luz: R$ 250,00/mês — vence todo dia 20
  - Shampoo (fornecedor): R$ 300,00 — pago quando compro
  - Cera (fornecedor): R$ 150,00 — pago quando compro
- **Como registro:** Clico em "Contas a pagar", coloco o valor, a data de vencimento e a recorrência (mensal, quinzenal, etc.).
- **O que o sistema faz:**
  - 5 dias antes do vencimento: manda alerta "Conta de água vence em 5 dias — R$ 180,00"
  - No dia do vencimento: manda alerta "Conta de água vence hoje — R$ 180,00"
  - Depois de pago: eu clico em "Pagar" e o sistema marca como quitado
- **Se eu não pagar:** O sistema continua lembrando todo dia até eu pagar.

### Passo 7 — Saber quanto lucro real tenho no fim do dia

- **O que eu clico:** Botão "Ver lucro do dia"
- **O que o sistema mostra:**
  ```
  Faturamento do dia:    R$ 1.250,00
  (-) Despesas do dia:   R$ 50,00 (shampoo)
  (-) Custo de insumos:  R$ 35,00 (shampoo + cera gastos)
  (=) Lucro bruto:       R$ 1.165,00
  (-) Retirada pessoal:  R$ 200,00
  (=) Lucro líquido:     R$ 965,00
  ```
- **No fim da semana:** O sistema mostra: "Lucro da semana: R$ 6.500,00" — comparado com a semana anterior.
- **No fim do mês:** O sistema mostra: "Lucro do mês: R$ 28.000,00" — comparado com o mês passado e com a meta.

### Resumo — Fluxo de caixa no dia a dia

```
Cliente paga R$ 50,00 em PIX
  → Clico "Registrar pagamento" → Clico "PIX"
  → Sistema registra: "+R$ 50,00 no caixa do negócio"

Cliente paga R$ 50,00 em dinheiro
  → Clico "Registrar pagamento" → Clico "Dinheiro"
  → Sistema pergunta: "Quanto deu?" → "Deu R$ 100,00"
  → Sistema calcula: "Troco: R$ 50,00"
  → Confirmo → Sistema registra: "+R$ 50,00 no caixa, -R$ 50,00 troco"

Compro shampoo por R$ 300,00
  → Clico "Nova despesa" → Categoria "Insumo" → R$ 300,00
  → Sistema registra: "-R$ 300,00 despesa do negócio"

Tiro R$ 200,00 pra mim
  → Clico "Retirar pra pessoal" → R$ 200,00
  → Sistema registra: "-R$ 200,00 retirada pessoal"

Fechar expediente
  → Clico "Fechar expediente"
  → Vejo: entrou, saiu, lucro, troco, contas a pagar
```

---

## Relatórios Necessários

- **Resumo do dia** — quanto entrei hoje, quantos carros lavei, quantos agendados, quantos faltaram
- **Resumo da semana** — comparativo seg-sáb, ver qual dia foi melhor
- **Resumo do mês** — faturamento total, quantidade de serviços, média por dia
- **Comparativo mensal** — quanto entrei este mês vs mês passado (ex: "R$ 22.000 vs R$ 18.500 = +19%")
- **Top clientes** — quem são os 10 clientes que mais vêm (para oferecer fidelidade)
- **Serviços mais vendidos** — qual tipo de lavagem tem mais demanda
- **Estoque consumido** — quanto de cada produto gastei no mês (para comprar reposição)
- **Comissão por funcionário** — quanto devo pagar cada um no mês
- **Faltas (no-show)** — quantos clientes agendaram e não apareceram (e quanto perdi)
- **Lucro bruto** — faturamento menos custo de insumos (quanto gastei de shampoo, cera, etc.)
- **Receita por unidade** — se tiver mais de uma unidade, ver qual rende mais

---

## Integrações

- **WhatsApp** — enviar mensagem de confirmação, aviso de pronto, lembrete de agendamento. Já uso WhatsApp o dia todo, precisa ser por lá.
- **PIX** — registrar pagamento PIX e identificar qual cliente pagou. Quero que o sistema mostre "PIX recebido de Maria — R$ 50,00 — Lavagem Completa".
- **App do banco** — não preciso integrar diretamente, mas quero exportar um resumo em texto pra copiar e colar no app do banco como anotação.
- **Google Agenda** — opcional, pra eu ver a agenda do lava-carro junto com minha agenda pessoal.
- **Instagram** — quero um botão "Postar no Instagram" que gere uma foto bonita do carro lavado com o nome do lava-carro.
- **Sistema de pagamento (Mercado Pago, etc.)** — no futuro, gerar link de pagamento PIX pra cliente pagar adiantado pelo link.
- **Impressora térmica** — no futuro, imprimir comprovante/recibo na hora.

---

## Priorização

| Prioridade | Tarefa | Por quê |
|------------|--------|---------|
| P0 | Ver agenda do dia | Sem isso, não sei quem vem e quando |
| P0 | Criar agendamento | Preciso registrar quando o cliente liga |
| P0 | Atualizar status do serviço | Preciso saber o que já foi feito e o que falta |
| P0 | Cadastrar cliente | Preciso saber quem é cada cliente e seu telefone |
| P0 | Controlar estoque de insumos | Se acabar o produto, o serviço para |
| P0 | Verificar fluxo de caixa do dia | Preciso saber quanto entrei e se tá tudo certo |
| P0 | Registrar pagamento | Preciso saber quem pagou e como pagou |
| P0 | Enviar mensagem de pronto | Cliente quer saber quando pode vir buscar |
| P1 | Ver estoque baixo (alerta) | Evita ficar sem produto no meio do dia |
| P1 | Listar clientes | Preciso ver histórico e não perder ninguém |
| P1 | Cancelar/agendar serviço | Cliente liga e precisa mudar horário |
| P1 | Cadastrar preço de serviço | Preciso definir e mudar preços quando quiser |
| P1 | Adicionar/repor estoque | Preciso registrar quando compro mais produto |
| P1 | Enviar mensagem de confirmação | Evita esquecimento e no-show |
| P2 | Agendamento online | Cliente agenda sozinho, menos trabalho pra mim |
| P2 | Relatório mensal de faturamento | Preciso ver se o negócio tá crescendo |
| P2 | Relatório de clientes frequentes | Pra oferecer desconto e fidelizar |
| P2 | Cartão fidelidade | Cliente volta mais se tiver recompensa |
| P2 | Notificação push | Não preciso ficar abrindo o app pra ver agendamento |
| P2 | Multi-unidade | Se eu expandir, preciso gerencitar tudo junto |
| P2 | Emissão de nota fiscal | Futuro, quando crescer e precisar |
| P2 | Chat integrado | Não quero ficar saindo do app pra falar com cliente |
| P0 | Registrar atendimento walk-in | Cliente chega sem agendamento e eu preciso encaixar na fila na hora |
| P0 | Separar caixa do negócio | Se eu misturo dinheiro do negócio com o pessoal, no fim não sei quanto sobou pra pagar conta |
| P1 | Ver lucro do dia | Preciso saber quanto entrei menos quanto gastei, tudo de uma vez |
| P1 | Registrar despesa do negócio | Preciso anotar quando compro shampoo ou pago conta pra não esquecer |
| P1 | Controlar troco | Preciso saber quanto de troco dei pra não perder dinheiro |
| P1 | Verificar contas a pagar | Preciso saber quando vou pagar água, luz e fornecedor pra não ficar devendo |

---

## Notas Adicionais

### O que NÃO é prioridade agora
- IA para prever demanda (ainda não tenho dados suficientes)
- App nativo (web app responsivo no celular já resolve)
- Dashboard complexo (eu quero tela simples, botão grande, pouco texto)
- Automação avançada (primeiro preciso do básico funcionando)

### Cenário de uso mais importante
> "Estou no meio de lavar um carro, o telefone toca. O cliente liga dizendo que vai chegar em 30 minutos. Eu preciso abrir o celular, ver se tem horário livre, confirmar o agendamento e mandar mensagem de confirmação. Tudo isso em menos de 30 segundos, com um ou dois toques na tela."

### Cenário de uso mais doloroso
> "É domingo à noite, vou fechar o dia. Abro o caderno de papel, conto os recibos, somo no papel. Perco um recibo. Não sei se o valor bate com o que entrou no banco. No fim do mês, não consigo saber se dei lucro."
