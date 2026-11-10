# S2 — Cliente Final

## Perfil

**Nome:** Ricardo Mendes, 32 anos  
**Carro:** Honda Civic 2023, cinza — uso diário para trabalho e fins de semana  
**Bairro:** Residencial, região central de São Paulo (Moema)  
**Trabalho:** Analista de sistemas, horário comercial (8h às 18h, segunda a sexta)  
**Frequência de lavagem:** A cada 15-20 dias, dependendo do uso e da chuva  
**Perfil tecnológico:** Usa WhatsApp, Instagram, app do banco (Nubank), iFood, Uber. Não é expert — sabe o básico, mas não mexe em configurações avançadas. Prefere coisas simples e diretas.  
**Dispositivo principal:** iPhone 14, tela 6.1". Usa celular o dia todo para tudo: trabalho, mensagens, pagamento, agendamento.  
**Dor principal:** Não consigo ir no lava-carro no horário de trabalho. Tenho que ligar, esperar alguém atender, combinar horário, e às vezes a pessoa não responde. Quando vou buscar o carro, não sei se já está pronto — tenho que ligar de novo.  
**Objetivo:** Queria um sistema onde eu pudesse agendar sem ligar, ver os horários disponíveis, pagar rápido (PIX), e receber um aviso no WhatsApp quando o carro estivesse pronto. Sem complicação, sem enrolação.

---

## Fluxo Principal

### Como eu descubro o lava-carro

1. **Encontro o serviço** — vi o "LavaBravas" no Instagram do Carlos (dono do lava-carro) ou um amigo me indicou. O link deles é `carva.app/luabravas` ou algo assim.

2. **Abro o link** — abre uma página bonita no celular, com foto dos carros, preços, e um botão grande "Agendar Lavagem".

3. **Vejo os serviços** — a página mostra:
   - "Lavagem Simples" — R$ 30 (só por fora)
   - "Lavagem Completa" — R$ 50 (por fora e por dentro)
   - "Lavagem Premium" — R$ 80 (com cera e perfume)
   - Não entendo a diferença entre eles, mas o preço me ajuda a escolher.

4. **Escolho o serviço** — clico no que quero (geralmente o "Completa" porque é o meio-termo).

### Como eu agendo

5. **Escolho o horário** — vejo uma grade com os horários disponíveis (ex: 9h, 10h, 11h, 14h, 15h). Clico em um que me convém.

6. **Preencho meus dados** — coloco nome, telefone (que já vem do WhatsApp), e modelo do carro. Se já fui cliente antes, o sistema já me reconhece.

7. **Confirmo** — clico em "Confirmar Agendamento" e recebo uma mensagem no WhatsApp: "Ricardo, sua lavagem está agendada para amanhã às 14h. Confirma?"

8. **Confirmação** — clico em "Sim, confirmo" na mensagem. Pronto, agendado.

### Durante o serviço

9. **Recebo atualizações** — quando o carro começar a ser lavado, recebo: "Seu carro entrou na lavagem!". Quando terminar: "Seu carro está pronto para retirada!"

10. **Vou buscar** — chego no lava-carro, mostro o comprovante no celular (ou falo o nome), e levo o carro embora.

### Pagamento

11. **Pago** — se já paguei adiantado, só confirmo. Se não, pago na hora via PIX, que o sistema gera um QR code na tela.

12. **Avalio** — depois de levar o carro, recebo uma mensagem: "Como foi a lavagem? De 1 a 5 estrelas."

---

## Tarefas Essenciais (MVP)

- [ ] **Ver os serviços disponíveis e preços** — saber o que tem, quanto custa, e o que cada um inclui
- [ ] **Ver horários disponíveis** — ver uma grade de horários e escolher um que me convém
- [ ] **Agendar lavagem** — escolher serviço + horário + preencher dados em poucos toques
- [ ] **Cancelar agendamento** — mudar de ideia e cancelar sem ligar para ninguém
- [ ] **Receber confirmação por WhatsApp** — saber que o agendamento foi registrado de verdade
- [ ] **Receber aviso quando o carro estiver pronto** — não ter que ligar para perguntar
- [ ] **Pagar via PIX** — pagar rápido, sem enrolação, com QR code ou link
- [ ] **Ver histórico de lavagens** — saber quando lavei, que tipo, e quanto gastei
- [ ] **Reavaliar e reagendar** — se não puder ir no horário, mudar para outro sem ligar
- [ ] **Ver meu histórico de pagamentos** — saber quanto gastei e como paguei
- [ ] **Cadastrar meu carro** — nome o modelo e placa uma vez, o sistema lembra
- [ ] **Receber lembrete antes do agendamento** — uma mensagem 1h antes: "Lembrete: lavagem amanhã às 14h"
- [ ] **Cancelar agendamento com informação de multa** — ver um botão "Cancelar" que me mostra se tem multa e quanto volta antes de confirmar
- [ ] **Reagendar horário sem ligar** — ver um botão "Mudar horário" que me mostra os horários disponíveis e me permite trocar em 2 toques
- [ ] **Ver meus pontos e créditos de fidelidade** — uma tela "Minha Conta" mostrando pontos, créditos, indicações e progresso para recompensas
- [ ] **Registrar reclamação e receber solução** — poder reportar um problema com foto e receber resposta em até 24h (revisita ou crédito)

---

## Tarefas Desejáveis (Nice-to-have)

- [ ] **Agendar retorno automático** — "Lembrete para lavar de novo em 15 dias"
- [ ] **Programar lavagem recorrente** — "Lave meu carro toda segunda às 10h"
- [ ] **Ver foto do carro antes de retirar** — o sistema tira foto quando termina, eu vejo no celular
- [ ] **Indicar amigo com desconto** — "Indique um amigo e ganhe R$ 10 na próxima lavagem"
- [ ] **Cartão fidelidade** — a cada 5 lavagens, a 6ª é metade do preço
- [ ] **Avaliar o serviço** — dar nota de 1 a 5 e escrever um comentário
- [ ] **Pedir serviço extra** — "Quero adicionar cera na próxima lavagem"
- [ ] **Ver tempo estimado de espera** — "Seu carro estará pronto em 40 minutos"
- [ ] **Pagamento automático por assinatura** — pagar mensalidade fixa e lavar quantas vezes quiser
- [ ] **Chat com o lava-carro** — conversar no app sem sair, sem precisar de WhatsApp separado
- [ ] **Desconto para clientes frequentes** — ver que já sou cliente fiel e receber desconto automático
- [ ] **Notificação push** — receber alerta no celular quando o carro estiver pronto (sem depender do WhatsApp)
- [ ] **Agendar para outros carros** — se tenho mais de um carro, escolher qual lavar
- [ ] **Ver avaliações de outros clientes** — saber se o lava-carro é bom antes de agendar

---

## Pain Points Atuais

- [ ] **Ligar para agendar é complicado** — tenho que esperar alguém atender no lava-carro, e muitas vezes não tem ninguém pra atender porque estão ocupados lavando carros
- [ ] **Não sei se o carro está pronto** — tenho que ligar de novo para perguntar, e se não atender, tenho que ir lá ou deixar mensagem
- [ ] **Horário não combina com meu trabalho** — o lava-carro funciona no horário que eu trabalho, então tenho que agendar no início ou fim do dia, e os horários bons já estão cheios
- [ ] **Preço não é claro** — às vezes o preço muda sem eu saber, ou cobram coisa que não combinamos. Não tem uma tabela de preços fixa e visível
- [ ] **Não consigo cancelar sem avisar** — se eu não puder ir, tenho que avisar antes senão cobram mesmo assim. Mas não tenho como cancelar sozinho
- [ ] **Pagamento em dinheiro é tranque** — tenho que levar dinheiro trocado, e às vezes o lava-carro não tem troco
- [ ] **Esqueço de lavar o carro** — não tenho lembrete, então o carro fica sujo por mais tempo do que eu queria
- [ ] **Não sei a diferença entre os serviços** — "lavagem completa" vs "premium" — não entendo o que muda, e às vezes pago mais sem precisar
- [ ] **Fila não tem previsão** — chego e não sei quantos carros estão na frente, quanto tempo vou esperar
- [ ] **Não consigo agendar para outra pessoa** — se for meu vizinho ou colega de trabalho usar, tenho que passar meus dados e não tem como agendar por outra pessoa
- [ ] **Perco o comprovante de pagamento** — se precisar de comprovante para reembolso do cartão ou algo assim, não tenho como baixar
- [ ] **Não sei se o lava-carro é bom** — não tenho avaliações de outros clientes para me guiar antes de experimentar
- [ ] **Não sei como cancelar sem ser cobrado** — se eu precisar cancelar, não sei se tem multa, quanto custa, e se o dinheiro volta. Preciso ver tudo isso antes de confirmar o cancelamento
- [ ] **Não consigo reclamar se o serviço foi ruim** — se o carro não ficou limpo ou teve riscos, não tenho como registrar reclamação e pedir reembolso ou revisita sem ligar
- [ ] **Não vejo meus pontos e descontos de forma clara** — se tenho programa de fidelidade, quero ver quantos pontos tenho, quanto de crédito e quantas lavagens faltam para o próximo prêmio em uma tela só

---

## Onboarding

### Como eu me cadastro pela primeira vez

**Passo 1 — Acessar o link (10 segundos)**
- Vejo o link do lava-carro no Instagram ou recebo de um amigo
- Abro o link no celular: `carva.app/lavabras`
- A página abre bonita, com foto de carros lavados e preços

**Passo 2 — Agendar primeiro serviço (1 minuto)**
- Clico em "Agendar Lavagem"
- Escolho o serviço (ex: "Lavagem Completa")
- Escolho o horário na grade (ex: "amanhã às 14h")
- Preencho: nome, telefone (que já puxa do WhatsApp), e modelo do carro

**Passo 3 — Confirmar (10 segundos)**
- Clico em "Confirmar"
- Recebo mensagem no WhatsApp: "Ricardo, sua lavagem está agendada para amanhã às 14h. Confirma?"
- Clico em "Sim, confirmo"

**Passo 4 — Pronto (0 segundos)**
- Já estou cadastrado no sistema
- Na próxima vez, só preciso escolher serviço e horário — meus dados já estão salvos

**Total de tempo:** ~2 minutos. Sem cadastro complicado, sem senha, sem e-mail. Só nome, telefone e carro.

---

## Regras de Uso

- **Cancelamento:** Posso cancelar até 2 horas antes do agendamento sem custo. Se cancelar depois, cobram 50%. Se não aparecer ("no-show"), cobram 100%. Isso precisa estar claro na hora de agendar.
- **Pagamento:** PIX é o método principal. Gero o QR code na hora do agendamento (adiantado) ou na retirada. Aceitam também dinheiro e cartão, mas eu prefiro PIX.
- **Reagendamento:** Posso mudar o horário quantas vezes quiser, desde que haja disponibilidade e eu mude com pelo menos 2h de antecedência.
- **Horário de agendamento:** Só posso agendar para o mesmo dia ou dias seguintes (máximo 3 dias). Não adianta tentar agendar para semana que vem.
- **Horários indisponíveis:** Sexta e sábado à tarde (13h-17h) não aceitam agendamento — é atendimento sem hora marcada. Tenho que chegar na hora deles.
- **Dados pessoais:** Só preciso fornecer nome, telefone e modelo do carro. Não quero dar CPF, endereço, ou outras informações desnecessárias.
- **Confirmação:** Todo agendamento precisa de confirmação minha via WhatsApp. Se eu não confirmar em 30 minutos, o agendamento é cancelado.
- **Atraso:** Se eu me atrasar, posso avisar pelo WhatsApp e eles tentam encaixar. Se não der, tenho que reagendar.
- **Avaliação:** Posso avaliar de 1 a 5 estrelas depois da lavagem. É opcional, mas se eu der 5 estrelas, ganho um desconto na próxima.
- **Carro não aparece:** Se eu não aparecer para buscar o carro, eles guardam por 24h. Depois disso, cobram uma taxa de armazenamento (precisa estar claro).

---

## Cancelamento e Reagendamento

### Como eu cancelo

**Botão "Cancelar agendamento" na tela principal**
- Quando abro o app, vejo meus agendamentos em destaque. Cada um tem um botão "Cancelar" em vermelho.
- Se eu clicar, aparece uma tela: "Tem certeza que quer cancelar? Sua lavagem é para amanhã às 14h."
- Se for **mais de 2 horas antes** do horário: cancela sem custo, o dinheiro volta na hora via PIX.
- Se for **menos de 2 horas**: aparece "Cancelamento na última hora — taxa de 50% (R$ 15). Confirmar?"
- Se eu **não aparecer** ("no-show"): aparece "Você não apareceu. Será cobrado 100% (R$ 30). Deseja confirmar o cancelamento?"
- O dinheiro volta para a minha conta do app ou para o PIX em até 5 minutos. Preciso ver isso na tela, não ouvir depois.

**Cancelar pelo WhatsApp**
- Se eu não estiver no app, posso mandar "cancelar" no WhatsApp e o bot responde: "Seu agendamento é para amanhã às 14h. Cancelar? (Sim/Não)"
- Se eu confirmar, o bot diz: "Cancelado. Reembolso de R$ 30 será processado em até 5 minutos."

### Como eu mudo o horário (reagendamento)

**Reagendar pelo app**
- Na tela do meu agendamento, tem um botão "Mudar horário" ao lado do "Cancelar".
- Clico e vejo os horários disponíveis de novo. Escolho um novo e confirmo.
- Se o novo horário for no mesmo dia ou outro dia, funciona.
- Se não tiver mais horários no serviço que eu escolhi, o app me mostra outros serviços disponíveis.
- Se eu pagar adiantado, o valor já está travado — não tem diferença de preço.

**Reagendar pelo WhatsApp**
- Posso mandar "mudar horário" no WhatsApp. O bot me mostra os horários disponíveis e eu escolho um.
- Se eu confirmar, recebo: "Horário alterado para amanhã às 15h. Confirma?"

**Limites**
- Posso reagendar quantas vezes quiser, desde que mude com pelo menos 2h de antecedência.
- Se eu reagendar na última hora, o cancelamento e o reagendamento contam como duas ações separadas — a taxa de 50% vale só para o cancelamento.

### E se o lava-carro cancelar por mim?

**Choveu ou falta de equipe**
- Se o lava-carro precisar cancelar por causa de chuva ou falta de equipe, eu recebo uma mensagem: "Ricardo, sua lavagem de amanhã às 14h foi cancelada por motivos operacionais. Oferecemos dois horários disponíveis: 15h ou 16h. Qual prefere?"
- Se eu não responder em 2 horas, o sistema oferece um novo horário automaticamente e me avisa.
- **O pagamento é integralmente reembolsado**, sem nenhuma taxa. Isso precisa estar claro na mensagem.

**O lava-carro não cumpre o horário**
- Se eu chegar e o carro não estiver pronto no horário agendado, eu posso registrar isso pelo app ou WhatsApp.
- Recebo um desconto de 20% na próxima lavagem automaticamente.
- Se eu esperar mais de 30 minutos além do horário, a próxima lavagem é grátis.

### O que acontece com o pagamento já feito?

- **Cancelamento normal (2h+ antes):** Reembolso integral via PIX em até 5 minutos.
- **Cancelamento na última hora (menos de 2h):** Reembolso de 50% via PIX em até 5 minutos.
- **No-show:** Sem reembolso. O valor é retido.
- **Cancelamento pelo lava-carro:** Reembolso integral, sem discussão.
- **Revisita por reclamação:** Se eu reclamar e o lava-carro concordar, a próxima lavagem é grátis (não tem reembolso em dinheiro, só crédito no app).

---

## Programa de Fidelização

### Como funciona o programa de pontos

**Ganho pontos em cada lavagem**
- Cada lavagem me dá pontos: Lavagem Simples = 10 pontos, Completa = 20 pontos, Premium = 30 pontos.
- Os pontos aparecem na tela do app: "Você tem 45 pontos. Mais 5 pontos para a próxima lavagem grátis!"
- Os pontos nunca expiram — posso acumular quantos quiser.

**Troco pontos por lavagem grátis ou desconto**
- **50 pontos** = 1 lavagem simples grátis
- **100 pontos** = 1 lavagem completa grátis
- **150 pontos** = 1 lavagem premium grátis
- Ou posso trocar 20 pontos por 10% de desconto na próxima lavagem.
- A troca é automática: quando eu agendar, o app já aplica o desconto ou marca a lavagem grátis.

**Bônus por frequência**
- Se eu lavar **4 vezes no mês**, ganho 10% de desconto automático na 5ª lavagem.
- Se eu lavar **8 vezes no mês**, ganho 15% de desconto e acesso a horários prioritários (pulo a fila).
- O app me mostra: "Você lavou 3 vezes este mês. Mais 1 e ganha 10% de desconto!"

### Indicação de amigo

**Como funciona**
- Tenho um botão "Indicar amigo" no app. Clico e o app gera um link ou código: `carva.app/ricardo32`.
- Quando meu amigo se cadastra usando meu link, ele ganha 20% de desconto na primeira lavagem.
- **Eu ganho R$ 10 de crédito no app** (para usar na próxima lavagem).
- Se meu amigo lavar 3 vezes, eu ganho mais R$ 15.
- Se meu amigo lavar 5 vezes, eu ganho 1 lavagem grátis.

**Como vejo quantas indicações fiz**
- Na tela do app, tem uma seção "Indicações": "Você indicou 3 amigos. Ganhou R$ 30 em créditos."
- Cada amigo mostra o nome e o status: "João — primeira lavagem agendada", "Maria — 2 lavagens feitas".

### Como eu vejo meus pontos e descontos

**Tela "Minha Conta"**
- Mostra: "Seus pontos: 45/50 para lavagem grátis"
- Mostra: "Seus créditos: R$ 10 (válido até 30/12/2026)"
- Mostra: "Lavagens este mês: 3 de 4 para 10% de desconto"
- Mostra: "Indicações: 3 amigos — R$ 30 em créditos"
- Tudo em uma tela só, sem precisar procurar em vários lugares.

**Notificação de progresso**
- Quando estou perto de ganhar um prêmio, recebo uma mensagem: "Faltam 5 pontos para uma lavagem grátis! Agende agora."
- Isso me motiva a voltar e agendar.

### O que me motiva a voltar

- **Ver o progresso na tela** — saber que estou perto de uma lavagem grátis me faz querer agendar.
- **Desconto automático** — não quero ter que digitar um cupom. O desconto já aparece no preço.
- **Recompensa surpresa** — às vezes o app me dá um "presente": "Hoje é seu dia! Lavagem com 50% de desconto." Isso me faz sentir especial.
- **Status de cliente VIP** — se eu lavar 10 vezes no ano, ganho o status "VIP" e acesso a horários exclusivos.
- **Aniversário** — no mês do meu aniversário, recebo uma lavagem grátis. Preciso ver isso anunciado, não só descobrir depois.

---

## Problema e Reclamação

### Como eu avalio o serviço

**Avaliação por estrelas (1 a 5)**
- Depois de levar o carro, recebo uma mensagem no WhatsApp: "Como foi a lavagem? De 1 a 5 estrelas."
- Clico nas estrelas diretamente na mensagem — sem precisar abrir app.
- Se eu der **5 estrelas**, o app já aplica automaticamente 10% de desconto na próxima lavagem.
- Se eu der **3 estrelas ou menos**, o app pergunta: "Conte-nos o que não ficou bom." com opções pré-definidas:
  - "Carro não ficou limpo"
  - "Riscos no carro"
  - "Atraso no horário"
  - "Atendimento ruim"
  - "Outro" (escrevo eu)

**Comentário opcional**
- Posso escrever um comentário curto (máximo 200 caracteres) ou não escrever nada.
- Se eu escrever, o dono do lava-carro recebe e pode responder.

### Como eu reclamo se não ficou bom

**Registrar reclamação pelo app**
- Na tela do meu histórico de lavagens, tem um botão "Reportar problema" em cada lavagem.
- Clico e escolho o problema: "Carro não ficou limpo", "Riscos", "Atraso", "Outro".
- Posso tirar uma foto do carro e enviar junto (opcional, mas ajuda).
- Recebo uma confirmação: "Reclamação registrada. O dono do lava-carro vai responder em até 24h."

**Registrar reclamação pelo WhatsApp**
- Posso mandar "reclamação" no WhatsApp e o bot pergunta: "Qual foi o problema?" com as mesmas opções do app.
- Se eu descrever o problema, o bot confirma: "Reclamação registrada. Resposta em até 24h."

**Registrar reclamação por telefone**
- Se eu não quiser usar app ou WhatsApp, posso ligar. Mas isso é o último recurso — prefiro tudo pelo celular.

### O que acontece quando eu reclamo

**Resposta do lava-carro (até 24h)**
- O dono do lava-carro recebe a reclamação e responde pelo app ou WhatsApp.
- Se o problema for **carro não limpo**: o lava-carro oferece uma **revisita grátis** (lavo de novo sem custo) ou **crédito de 50% do valor** na próxima lavagem.
- Se o problema for **riscos no carro**: o lava-carro avalia o caso e pode oferecer compensação. Se confirmado, eu recebo crédito no app.
- Se o problema for **atraso**: recebo desconto automático de 20% na próxima lavagem.

**Se eu não ficar satisfeito com a resposta**
- Se a resposta do lava-carro não me agradar, posso "escalar" a reclamação.
- No app, tem um botão "Escalrar" que envia para um canal externo (não sei ainda qual, mas preciso que exista).
- Na escalada, eu recebo **reembolso integral** em até 48h via PIX.

### Prazo para reclamar

- Tenho **48 horas** após a lavagem para registrar reclamação.
- Depois disso, o botão "Reportar problema" desaparece do app.
- A mensagem de avaliação também expira em 48h — se eu não avaliar, não recebo o desconto de 5 estrelas, mas ainda posso reclamar pelo app.
- Se eu reclamar depois de 48h, o app diz: "O prazo para reclamações expirou. Entre em contato por telefone."

### Resumo do fluxo de reclamação

1. **Eu avalio** — 1 a 5 estrelas no WhatsApp, logo após a lavagem.
2. **Se 3 estrelas ou menos** — escolho o problema e posso enviar foto.
3. **Confirmação** — "Reclamação registrada. Resposta em até 24h."
4. **Resposta do lava-carro** — em até 24h, recebo a solução (revisita, crédito, desconto).
5. **Se não gostar** — escalo e recebo reembolso integral em 48h.
6. **Prazo** — tudo precisa ser feito em 48h após a lavagem.

---

## Fidelização

### O que me faria voltar

- **Lembrete automático** — "Ricardo, faz 15 dias que você lavou o carro. Quer agendar?" — isso é OBRIGATÓRIO. Sem lembrete, eu esqueço.
- **Desconto para recorrente** — se eu venho 3 vezes no mês, a 4ª lavagem tem 10% de desconto. Preciso ver isso na tela, não só ouvir de boca.
- **Cartão fidelidade** — a cada 5 lavagens, a 6ª é grátis ou com desconto. Ver minha contagem de lavagens no app.
- **Aviso de pronto** — receber a mensagem "seu carro está pronto" SEMPRE, sem eu ter que perguntar. Isso é o básico.
- **Preço justo e transparente** — ver o preço antes de agendar, sem surpresas na hora de pagar.
- **Agendar em 3 toques** — se for difícil agendar, eu volto a ligar. O processo tem que ser mais fácil que ligar.
- **Indicação com benefício** — "Indique um amigo e ganhe R$ 10" — isso me motiva a indicar o lava-carro para outros.
- **Avaliação visível** — ver que outros clientes gostaram do serviço me dá confiança para voltar.
- **Desconto de aniversário** — receber um desconto no mês do meu aniversário é um toque pessoal que me faz sentir valorizado.
- **Agendamento recorrente** — poder programar "lave meu carro toda segunda" é o sonho. Não ter que pensar nisso.

---

## Integrações

- **WhatsApp** — é OBRIGATÓRIO. Quero receber confirmação, lembrete, aviso de pronto e avaliação por lá. É onde eu já estou, não quero baixar outro app.
- **PIX** — quero pagar com PIX, gerando QR code ou link direto. É o método mais rápido e eu já uso no app do banco.
- **App do banco (Nubank, Inter, etc.)** — não preciso integrar diretamente, mas quero exportar um resumo de gastos para anotar no app do banco.
- **Google Calendar** — opcional, mas seria ótimo: o agendamento aparecer na minha agenda do celular automaticamente.
- **Instagram** — se o lava-carro postar foto do meu carro lavado no Instagram e me marcar, eu gosto disso. É tipo um "antes e depois".
- **Mapa / GPS** — se o lava-carro tiver endereço, quero ver no Google Maps e traçar rota até lá.
- **Câmera do celular** — tirar foto do carro antes e depois da lavagem. Isso é legal para ver a diferença e postar no Instagram.

---

## Priorização

| Prioridade | Tarefa | Por quê |
|------------|--------|---------|
| P0 | Ver serviços e preços | Sem saber o que tem e quanto custa, não agendo |
| P0 | Ver horários disponíveis | Preciso ver o que funciona na minha agenda |
| P0 | Agendar lavagem em poucos toques | Se for complicado, eu desisto e ligo (que é pior) |
| P0 | Receber confirmação por WhatsApp | Preciso saber que o agendamento deu certo |
| P0 | Receber aviso quando o carro estiver pronto | Não posso ligar para perguntar — preciso ser avisado |
| P0 | Pagar via PIX | É o jeito mais rápido e eu já uso todo dia |
| P0 | Cancelar agendamento sozinho | Se eu mudar de ideia, preciso poder cancelar sem ligar |
| P0 | Cancelar com informação de multa | Preciso ver se tem multa e quanto volta ANTES de confirmar o cancelamento |
| P0 | Reagendar horário | Se eu me atrasar, preciso mudar sem ligar |
| P0 | Reagendar pelo WhatsApp | Se eu não estiver no app, preciso mudar pelo WhatsApp também |
| P0 | Receber lembrete antes do agendamento | Sem lembrete, eu esqueço e perco o horário |
| P0 | Cadastrar meu carro uma vez | Não quero repetir modelo/placa toda vez |
| P1 | Ver histórico de lavagens | Quero saber quando lavei e quanto gastei |
| P1 | Ver histórico de pagamentos | Preciso controlar meus gastos com lavagem |
| P1 | Agendar retorno automático | "Lembrete em 15 dias" me ajuda a manter a rotina |
| P1 | Ver tempo estimado de espera | Saber quanto tempo vou esperar me ajuda a planejar |
| P1 | Indicar amigo com desconto | Motivação para indicar o lava-carro |
| P1 | Cartão fidelidade | Recompensa por ser cliente fiel |
| P1 | Ver pontos e créditos | Preciso ver quantos pontos tenho, quanto de crédito e quanto falta para a próxima lavagem grátis |
| P1 | Registrar reclamação | Se o serviço foi ruim, preciso reportar e receber solução (revisita ou crédito) em até 24h |
| P1 | Avaliar o serviço | Dar nota e feedback ajuda a melhorar |
| P1 | Ver avaliações de outros clientes | Me dá confiança antes de agendar |
| P2 | Agendar lavagem recorrente | "Toda segunda às 10h" seria perfeito |
| P2 | Ver foto do carro antes de retirar | Ver o resultado sem ir lá |
| P2 | Pagamento por assinatura | Mensalidade fixa seria conveniente |
| P2 | Chat com o lava-carro | Conversar sem sair do app |
| P2 | Notificação push | Alerta no celular além do WhatsApp |
| P2 | Agendar para outros carros | Se eu tiver mais de um carro |
| P2 | Desconto de aniversário | Toque pessoal que me faz sentir valorizado |
| P2 | Programa de indicação | Ganhar desconto indicando amigos |

---

## Notas Adicionais

### O que NÃO é prioridade agora
- App nativo para instalar — web app no celular já resolve
- Cadastro com e-mail e senha — só preciso de nome e telefone
- Dashboard complexo — quero tela simples, botão grande, pouco texto
- Integração com sistema de pagamento externo — PIX direto já basta
- Chatbot com IA — não quero conversar com robô, quero falar com pessoa se precisar

### Cenário de uso mais importante
> "Estou no trabalho, de manhã. Quero agendar a lavagem do meu carro para amanhã à tarde. Abro o link do lava-carro no celular, vejo os horários livres, clico em um, confirmo com um toque, e pronto. Recebo a confirmação no WhatsApp. Tudo em menos de 1 minuto, sem ligar para ninguém."

### Cenário de uso mais doloroso
> "O carro está sujo, eu quero lavar. Mas o lava-carro funciona no horário que eu trabalho. Ligam para agendar, mas ninguém atende porque estão ocupados. Deixo mensagem no WhatsApp, mas demoram para responder. Quando finalmente confirmam, o horário que eu queria já está cheio. No dia combinado, eu vou lá e não sei se o carro já está pronto. Tenho que ligar de novo. Se não atenderem, tenho que ir lá ou deixar mensagem. É frustrante."

### Cenário de uso ideal
> "Recebo uma mensagem no WhatsApp: 'Ricardo, faz 15 dias que você lavou o carro. Quer agendar?' Clico em 'Sim'. Vejo os horários disponíveis, clico em 'amanhã às 14h'. Confirmo. Recebo a confirmação. No dia, o carro está pronto, recebo a mensagem 'Seu carro está pronto para retirada!' Pago via PIX na hora, com um QR code. Na volta para casa, recebo: 'Como foi a lavagem? De 1 a 5 estrelas.' Dê 5 estrelas e ganhe 10% de desconto na próxima."

### Regras de negócio que impactam o cliente
- **Horário de pico (sexta/sábado 13h-17h):** Não aceita agendamento — é walk-in. O cliente precisa saber isso antes de tentar agendar.
- **Cancelamento com 2h de antecedência:** Sem custo. Depois disso, 50%. No-show, 100%. Isso precisa estar claro na tela de agendamento.
- **Confirmação em 30 minutos:** Se o cliente não confirmar o agendamento pelo WhatsApp em 30 minutos, o sistema cancela automaticamente.
- **Retenção de carro:** Se o cliente não aparecer para buscar, o carro fica guardado por 24h. Depois, cobra taxa.
