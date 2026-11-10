# S3 — Funcionário do Lava-Carro

## Perfil

**Nome:** José Antônio Ferreira, 34 anos  
**Cargo:** Funcionário fixo — "chefe de serviço" (organiza quem lava qual carro)  
**Experiência:** 8 anos em lava-carros, 3 anos neste (LavaBravas)  
**Formação:** Ensino médio incompleto. Trabalha desde os 18 anos.  
**Perfil tecnológico:** Sabe usar WhatsApp (conversa, envia foto, áudio), Instagram (só rola feed e curte), app do banco básico. Nunca mexeu em sistema de gestão. Já viu o dono tentar usar um tablet mas ele "travava" e ninguém soube mexer.  
**Dispositivo principal:** Smartphone Android barato (Xiaomi Redmi 9A, 3GB RAM, tela 6.2"). Às vezes usa um tablet da loja (Samsung Galaxy Tab A, antigo, meio lento) que fica encostado no balcão.  
**Dor principal:** Não sabe quantos carros faltam lavar, não sabe quem lava qual carro, não sabe se o cliente pagou, e quando o dono pede pra ele organizar a equipe, ele não tem como anotar tudo direito. No fim do mês, não sabe quantos carros lavou e quanto merece de comissão.  
**Objetivo:** Queria uma tela no celular onde eu visse o que tem pra fazer hoje, pudesse marcar "comecei" e "terminei", e o sistema me lembrasse quanto o cliente deve. Sem complicação, sem configuração — só abrir e usar.

---

## Fluxo do Dia a Dia

### Chegada (7h — 7h30)

1. **Abro o sistema no celular** — clico no ícone que o dono instalou (se tiver app) ou abro o link no navegador. A tela principal abre com:
   - "Hoje: 5 carros para lavar"
   - Lista dos carros com horário e nome do cliente
   - Um botão grande: "Começar o dia"

2. **Vejo a fila** — rolo para baixo e vejo:
   - Nome do cliente (ex: "Maria Souza")
   - Horário (ex: "09:00")
   - Tipo de lavagem (ex: "Completa")
   - Status (ex: "⏳ Pendente" — amarelo)
   - Se o cliente pagou adiantado (ex: "✅ Sinal recebido")

3. **Organizo a equipe** — se tem mais funcionário, eu distribuo:
   - Clico em "Distribuir carros"
   - Vejo quem está disponível hoje (eu, Pedrinho, Carlos)
   - Arrasto o carro da Maria pro Pedrinho
   - Arrasto o segundo carro pro Carlos
   - Eu fico com o terceiro carro
   - Cada funcionário vê só o carro designado pra ele no celular

### Durante o serviço (8h — 17h)

4. **Marco "comecei"** — quando começar a lavar um carro, clico no botão "Começar" e o status muda pra "🟡 Em andamento" (amarelo)

5. **Marco "terminei"** — quando terminar, clico em "Finalizar" e o status muda pra "✅ Concluído" (verde)

6. **Registro pagamento** — quando o cliente chega e paga:
   - Clico em "Registrar pagamento"
   - Escolho o método: PIX, dinheiro ou cartão
   - O sistema registra e muda o status pra "Pago"

7. **Atendo walk-in (sem agendamento)** — se um cliente chega sem hora marcada:
   - Clico em "Novo atendimento"
   - Coloco nome, tipo de lavagem
   - O sistema encaixa na fila do dia
   - Se eu sou "chefe de serviço", posso atribuir o carro pra alguém da equipe

8. **Registro dano no carro** — se o carro chega com arranhão ou dano:
   - Clico em "📸 Foto do carro"
   - Tiro foto do dano
   - Clico em "Registrar dano", escolho a parte e descrevo
   - O dono recebe notificação no WhatsApp

9. **Reporto estoque baixo** — se estiver acabando o shampoo ou cera:
   - Clico em "Reportar estoque"
   - Escolho o produto e escrevo: "Shampoo quase acabando"
   - O dono recebe a notificação

10. **Reatribuo carros se precisar** — se um funcionário foi pro banheiro ou saiu mais cedo:
    - Clico em "Distribuir carros"
    - Arrasto o carro pro outro funcionário disponível
    - O funcionário original perde o carro, o novo ganha
    - O sistema avisa os dois no WhatsApp

### Final do dia (17h — 18h)

9. **Fechei o dia** — clico em "Fechar expediente" e vejo:
   - Quantos carros lavei hoje
   - Quantos clientes pagaram
   - Meu nome na lista (se o sistema rastreia por funcionário)

10. **Confiro minha comissão** — no fim do mês, clico em "Minha comissão" e vejo:
    - Quantos carros lavei no mês
    - Quanto devo receber
    - Histórico de cada lavagem

---

## Tarefas Essenciais (MVP)

- [ ] **Ver a lista de carros do dia** — ver nome do cliente, horário, tipo de lavagem, status, e quem é o responsável
- [ ] **Marcar "comecei" no serviço** — botão grande que muda o status de "pendente" pra "em andamento"
- [ ] **Marcar "finalizei" no serviço** — botão grande que muda o status de "em andamento" pra "concluído"
- [ ] **Ver quem lava qual carro** — saber qual carro foi designado pra mim e qual foi pro outro funcionário
- [ ] **Distribuir carros entre funcionários** — clicar em "Distribuir", arrastar carro pra funcionário, ou reatribuir se alguém saiu
- [ ] **Ver equipe disponível** — ver quem está no trabalho hoje, quem está de folga, quem pode trabalhar
- [ ] **Registrar pagamento do cliente** — marcar se o cliente pagou (PIX, dinheiro, cartão) e quanto pagou
- [ ] **Criar atendimento walk-in** — encaixar cliente que chegou sem agendamento na fila do dia
- [ ] **Ver meu histórico de lavagens** — saber quantos carros lavei hoje, essa semana, esse mês
- [ ] **Ver minha comissão** — saber quanto devo receber no fim do mês baseado nos carros que lavei
- [ ] **Reportar estoque baixo** — avisar quando um produto estiver acabando
- [ ] **Ver status do carro** — saber se o carro já foi pago, se tem sinal, se está pronto pra retirada
- [ ] **Cancelar/reagendar serviço** — quando o cliente ligar pedindo pra mudar o horário
- [ ] **Ver detalhes do cliente** — nome, telefone, tipo de carro, histórico de lavagens anteriores
- [ ] **Filtrar por status** — ver só os "pendentes", só os "em andamento", ou só os "concluídos"
- [ ] **Buscar cliente por nome** — campo de busca pra encontrar um cliente rápido quando ele liga
- [ ] **Tirar foto do carro antes/depois** — registrar visualmente o estado do carro, especialmente se tem dano
- [ ] **Registrar dano no carro** — se o carro chega com arranhão, tiro foto, escolho a parte, descrevo e envio pro dono
- [ ] **Trabalhar sem internet (modo offline)** — marcar status, registrar pagamentos, tudo fica salvo localmente e sincroniza depois

---

## Tarefas Desejáveis (Nice-to-have)

- [ ] **Notificação de novo agendamento** — receber alerta no celular quando chegar agendamento novo
- [ ] **Tirar foto do carro antes/depois** — registrar visualmente o estado do carro
- [ ] **Adicionar serviço extra** — quando o cliente pede "me põe cera também", registrar na hora
- [ ] **Ver mapa da fila** — ver todos os carros em uma grade visual, não só lista
- [ ] **Escalar serviço** — quando um carro for difícil (muito sujo, precisa polir), marcar como "prioridade"
- [ ] **Chat com o dono** — enviar mensagem rápida pro dono sem sair do sistema
- [ ] **Exportar meu relatório** — baixar um resumo dos carros que lavei no mês
- [ ] **Modo offline** — usar o sistema sem internet e sincronizar depois
- [ ] **Trocar carro de fila** — quando um carro mais urgente chegar, reorganizar a ordem
- [ ] **Ver previsão de término** — estimativa de quanto tempo falta pra terminar cada carro
- [ ] **Receber bônus por avaliação** — se o cliente der 5 estrelas, ver que ganhei um bônus
- [ ] **Treinamento interativo** — tutorial de 3 minutos mostrando cada botão do sistema
- [ ] **Tema escuro** — pra não ficar cegando à noite ou com o sol forte

---

## Pain Points Atuais

- [ ] **Não sei quem lava qual carro** — o dono fala de boca, esquece, e todo mundo começa a lavar ao mesmo tempo. Fica confusão.
- [ ] **Não sei se o cliente pagou** — às vezes o cliente diz "já paguei" mas não pagou nada. Só descubro quando o dono cobra.
- [ ] **Não tenho como anotar sem atrapalhar** — se eu paro pra anotar no caderno, o cliente espera e fica bravo. Preciso de algo rápido.
- [ ] **O tablet da loja é lento** — quando tentam usar o tablet, ele trava, demora pra abrir, e ninguém quer usar.
- [ ] **Não sei minha comissão** — no fim do mês, o dono fala um valor e eu não tenho como conferir. Não sei se ele calculou certo.
- [ ] **Cliente walk-in não entra na fila** — quando alguém chega sem agendamento, não tem como encaixar direito. Às vezes pulam na frente.
- [ ] **Estoque acaba e ninguém avisa** — fico sabendo que acabou shampoo quando vou usar e não tem. Perde serviço e cliente.
- [ ] **Não tenho visão do dia inteiro** — chego e não sei quantos carros têm, quais são mais urgentes, e em que ordem lavar.
- [ ] **Não consigo ver histórico do cliente** — quando o cliente chega, não sei se ele já veio antes, que tipo de lavagem ele gosta, se tem desconto.
- [ ] **Não tem como reportar problema** — se o carro tem um arranhão ou algo que preciso avisar o dono, não tenho como registrar.
- [ ] **Sempre que o dono muda a ordem, eu perco o controle** — ele chega e diz "troca a ordem", mas não tem registro de quem era pra lavar o quê.
- [ ] **Não consigo trabalhar sem internet** — se a internet cai, não consigo fazer nada. Preciso de modo offline.
- [ ] **Não tenho como distribuir carros entre funcionários** — falo de boca, esqueço, e um funcionário fica sem trabalho enquanto outro trabalha dobrado.
- [ ] **Se um funcionário sai mais cedo, não tenho como reatribuir** — os carros dele ficam pendentes e eu não sei quem lava.
- [ ] **Se o carro chega com dano, não tenho como registrar** — o cliente pode reclamar depois que o carro ficou riscado, mas não tenho prova de que já estava assim.
- [ ] **Se eu arranhar o carro sem querer, não tenho como registrar** — o dono pode achar que foi o cliente e eu levo a culpa sem poder provar.

---

## Onboarding

### Como eu aprendo a usar o sistema pela primeira vez

**Passo 1 — O dono me chama (5 minutos)**

- O dono me pega de lado: "João, hoje você vai usar o sistema pra organizar a fila."
- Ele abre o app no meu celular ou me entrega o tablet
- Não tem cadastro — eu já entro logado porque o dono me cadastrou

**Passo 2 — Tutorial rápido (3 minutos)**

- O sistema mostra 3 telas de tutorial com desenhos:
  1. "Aqui você vê os carros do dia" — mostra a lista com nome, horário, status
  2. "Aqui você marca 'comecei' e 'finalizei'" — mostra os botões grandes
  3. "Aqui você registra pagamento" — mostra o botão de pagamento
- Cada tela tem um botão "Entendi" ou "Próxima"
- Se eu errar, o sistema mostra uma dica: "Toque no botão amarelo pra começar o serviço"

**Passo 3 — Primeiro dia prático (com o dono ao lado)**

- O dono fica ao meu lado nas primeiras 2 horas
- Ele me diz: "Esse carro da Maria, marque como 'comecei'"
- Eu clico, ele confirma: "Isso aí! Agora marca 'finalizei' quando terminar"
- Ele me mostra como registrar pagamento
- Ele me mostra como reportar estoque

**Passo 4 — Sozinho (dia seguinte)**

- No dia seguinte, uso sozinho
- Se tiver dúvida, clico no botão "?" no canto da tela
- O dono pode me chamar se precisar de ajuda

**Total de tempo:** ~11 minutos de treinamento. Sem teoria, só prática.

---

## Regras de Uso

- **Acesso:** Sou cadastrado pelo dono. Não tenho senha — acesso pelo celular com meu número de WhatsApp vinculado. Se perder o celular, o dono me recredencia.
- **Permissão de status:** Só posso mudar status de "pendente" → "em andamento" → "concluído". Não posso cancelar agendamento — só o dono pode.
- **Permissão de pagamento:** Posso registrar pagamento, mas não posso dar desconto — só o dono aprova desconto.
- **Permissão de estoque:** Posso reportar estoque baixo, mas não posso comprar reposição — só o dono compra.
- **Permissão de equipe:** Como "chefe de serviço", posso distribuir carros entre os funcionários. Os funcionários comuns só veem o carro designado pra eles.
- **Horário de uso:** Uso o sistema durante o horário de trabalho (7h-18h). Não uso fora disso.
- **Dispositivo:** Uso meu próprio celular (Xiaomi) ou o tablet da loja. Se usar o tablet, ele fica sempre no balcão.
- **Dados do cliente:** Não posso apagar ou editar dados do cliente — só ver. Se precisar mudar algo, peço pro dono.
- **Comissão:** Minha comissão é por carro lavado. Simples = R$ 5, Completa = R$ 8, Premium = R$ 12. O sistema calcula automaticamente.
- **Privacidade:** Não posso ver a planilha financeira do dono (quanto ele lucra, quanto paga de conta). Só vejo o que é do meu trabalho.
- **Modo offline:** Se a internet cair, posso continuar marcando status. Quando a internet voltar, o sistema sincroniza automaticamente.

---

## Cenário de Emergência

### O que acontece se o sistema cair ou a internet falhar

**Cenário:** Sexta-feira à tarde, 15h. A internet da loja caiu. Tem 8 carros na fila, 3 clientes esperando.

**O que eu preciso:**

1. **Continuar trabalhando sem internet** — o sistema precisa funcionar no celular mesmo sem conexão
2. **Marcar status localmente** — "comecei", "finalizei", "pagou" — tudo fica salvo no celular
3. **Sincronizar depois** — quando a internet voltar, o sistema sobe tudo automaticamente
4. **Não perder dados** — se eu fecho o app e abre de novo, os dados estão lá
5. **Não duplicar** — se dois funcionários marcam o mesmo carro, o sistema detecta e avisa

**O que NÃO pode acontecer:**

- Não posso perder um agendamento porque a internet caiu
- Não posso marcar dois funcionários no mesmo carro
- Não posso registrar pagamento e depois perder o registro quando a internet voltar

**Solução ideal:**

- O sistema salva tudo no celular (localStorage ou banco local)
- Quando a internet volta, sobe automaticamente em segundo plano
- Se der conflito (dois funcionários marcaram o mesmo carro), o sistema pergunta: "João, você ou Pedrinho começou primeiro?"
- Se o celular desligar, os dados não somem — ficam salvos localmente

---

## Registro de Dano no Carro

### O que acontece se o carro chegar com arranhão ou dano

**Cenário:** Cliente da placa ABC chegou com um Honda Civic. Quando eu vou lavar, vejo que tem um arranhão grande na porta dianteira e um buraco no para-choque traseiro.

**O que eu preciso fazer:**

1. **Tirar foto ANTES de começar** — foto do arranhão, foto do buraco, foto geral do carro
2. **Registrar o dano no sistema** — clicar em "Dano no carro", escolher a parte (porta, para-choque, capô, etc.), escrever uma descrição curta
3. **O dono aprova** — o dono recebe a notificação e aprova ou questiona
4. **Se eu causar dano** — se eu arranhar o carro sem querer, registro também. O dono precisa saber.

**Como funciona na prática:**

- Botão grande: "📸 Foto do carro"
- Abre a câmera do celular
- Tiro foto do dano (ou de todo o carro)
- Clico em "Registrar dano"
- Escolho a parte: porta, para-choque, capô, lanternas, espelhos
- Escrevo: "Arranhão na porta dianteira direita, ~15cm"
- Clico em "Enviar"
- O dono recebe no WhatsApp: "⚠️ Dano reportado — Honda Civic placa ABC — Arranhão porta direita"

**Regras:**

- Se o carro já tem dano, registro ANTES de começar a lavar
- Se eu causar dano durante o serviço, registro IMEDIATAMENTE
- Não posso apagar um registro de dano — só o dono pode
- Fotos ficam salvas no sistema por 30 dias (pra resolver disputa)

---

## Gestão de Equipe

### Como o "chefe de serviço" distribui os carros entre funcionários

**Cenário:** Segunda-feira, 8h. Chegam 6 carros na fila. Tem eu (José Antônio), Pedrinho e Carlos. Preciso distribuir quem lava qual carro.

**O que eu preciso:**

1. **Ver a equipe disponível** — quem está no trabalho hoje, quem está de folga
2. **Distribuir carros manualmente** — arrastar um carro pra um funcionário, ou clicar em "atribuir"
3. **Ver quem lava qual carro** — cada funcionário vê só o carro designado pra ele
4. **Reatribuir se precisar** — se Pedrinho foi pro banheiro, reatribuo o carro dele pro Carlos
5. **Ver o progresso da equipe** — quantos cada um já lavou, quantos faltam

**Como funciona na prática:**

- Tela "Distribuir carros" — mostra a fila de carros e a lista de funcionários
- Clico em um carro, depois clico no funcionário — o carro é atribuído
- Ou arrasto o carro pra cima do nome do funcionário
- Cada funcionário abre o sistema e vê só o carro designado pra ele
- Se eu reatribuir, o funcionário antigo perde o carro e o novo ganha

**Permissões:**

- **Chefe de serviço** (eu): posso distribuir, reatribuir e ver todos os carros
- **Funcionário comum**: só vê o carro designado pra mim, não vejo a distribuição
- **Dono**: vê tudo, pode redistribuir se quiser

**Regras:**

- Só posso atribuir um carro pra um funcionário por vez — não pode dois no mesmo carro
- Se eu reatribuir um carro "em andamento", o funcionário original é avisado
- Se eu redistribuir no meio do dia, o sistema envia notificação pro WhatsApp do funcionário
- No fim do dia, o sistema gera um relatório: "João lavou 4, Pedrinho lavou 3, Carlos lavou 2"

---

## Comunicação

- **Com o dono:** Falo pelo WhatsApp no dia a dia. Se o sistema tiver chat integrado, uso ele pra coisas rápidas ("acabou shampoo", "cliente da placa ABC pediu pra por cera").
- **Com outros funcionários:** Falo de boca na hora. Sou o "chefe de serviço", então mando na fila. Os outros funcionários me obedecem porque eu distribuo os carros.
- **Com o cliente:** Falo de boca quando ele chega. Se ele liga, eu consulto no sistema e respondo. Não falo com cliente pelo sistema — tudo é presencial ou WhatsApp.
- **Com o fornecedor:** Não uso o sistema pra isso. O dono fala direto com o fornecedor por WhatsApp ou telefone.
- **Em caso de problema:** Se o carro tem dano, se o cliente briga, se tem problema técnico — eu aviso o dono pelo WhatsApp. O sistema não tem módulo pra isso ainda.

---

## Integrações

- **WhatsApp** — O sistema deve enviar notificação pro meu WhatsApp quando chegar agendamento novo, quando o cliente pagar, ou quando o estoque estiver baixo. Já uso WhatsApp o dia todo.
- **Câmera do celular** — Quero tirar foto do carro antes e depois da lavagem. Isso ajuda a provar que o carro estava sujo e ficou limpo. Também ajuda se o cliente reclamar.
- **Tablet da loja** — O sistema deve funcionar no tablet, mas o tablet é secundário. Meu celular é o principal.
- **Impressora térmica** — No futuro, quero imprimir um comprovante simples na hora do pagamento.
- **App do banco** — Não preciso integrar. O dono baixa um resumo e anota no app dele.
- **Google Maps** — Se o cliente liga perguntando onde é o lava-carro, quero abrir o Maps na hora pra mandar a localização.

---

## Priorização

| Prioridade | Tarefa | Por quê |
|------------|--------|---------|
| P0 | Ver a lista de carros do dia | Sem isso, não sei o que tem pra fazer |
| P0 | Marcar "comecei" no serviço | Preciso registrar que estou lavando aquele carro |
| P0 | Marcar "finalizei" no serviço | Preciso registrar que terminei, senão fica pendente pra sempre |
| P0 | Ver quem lava qual carro | Sem isso, todo mundo começa a lavar ao mesmo tempo e fica confusão |
| P0 | Distribuir carros entre funcionários | Sou o chefe de serviço, preciso saber quem lava o quê |
| P0 | Ver equipe disponível | Preciso saber quem está no trabalho hoje antes de distribuir |
| P0 | Registrar pagamento do cliente | Preciso saber quem pagou e quem não pagou |
| P0 | Ver status do carro | Preciso saber se o carro está pronto, se foi pago, se tem sinal |
| P0 | Criar atendimento walk-in | Cliente que chega sem hora precisa ser encaixado na fila |
| P0 | Ver meu histórico de lavagens | Preciso saber quantos lavei e conferir minha comissão |
| P0 | Ver minha comissão | Preciso saber quanto devo receber e poder conferir |
| P0 | Buscar cliente por nome | Quando o cliente liga, preciso encontrar ele rápido |
| P0 | Tirar foto do carro antes/depois | Preciso provar que o carro já tinha dano ou que lavei certo |
| P0 | Registrar dano no carro | Se o carro chega com arranhão, preciso registrar antes de lavar |
| P0 | Trabalhar sem internet (modo offline) | Se a internet cair, preciso continuar trabalhando |
| P1 | Ver detalhes do cliente | Saber histórico, tipo de carro, se tem desconto |
| P1 | Filtrar por status | Ver só os pendentes ou só os concluídos |
| P1 | Cancelar/reagendar serviço | Cliente liga e precisa mudar — preciso poder fazer |
| P1 | Reportar estoque baixo | Se eu não reportar, o dono não sabe que precisa comprar |
| P1 | Notificação de novo agendamento | Não preciso ficar ficando a tela o dia todo |
| P1 | Modo offline (sincronização automática) | Se a internet voltar, o sistema sobe tudo sozinho |
| P2 | Adicionar serviço extra | Cliente pede cera no meio do serviço — preciso registrar |
| P2 | Chat com o dono | Pra avisar sem sair do sistema |
| P2 | Ver mapa da fila | Uma visão visual é melhor que lista |
| P2 | Treinamento interativo | Tutorial de 3 minutos pro novo funcionário |
| P2 | Exportar meu relatório | Pra ter meu próprio registro dos carros que lavei |
| P2 | Tema escuro | Não quero ficar cegando com tela clara no sol |

---

## Notas Adicionais

### O que NÃO é prioridade agora
- Dashboard financeiro — isso é coisa do dono, não minha
- Configurações do sistema — eu não mexo em configuração
- Relatórios complexos — eu só quero ver minha comissão
- App nativo para instalar — web app no navegador já resolve
- Cadastro com e-mail e senha — eu uso WhatsApp, não e-mail
- Chatbot com IA — não quero conversar com robô
- Relatórios de equipe — isso é coisa do dono, eu só quero ver meus carros

### Cenário de uso mais importante
> "São 10h da manhã. Tenho 3 carros na fila. O primeiro já começou, o segundo está pendente, o terceiro nem começou ainda. Preciso ver na tela: quem lava qual carro, qual já foi pago, e qual está pronto pra retirada. Tudo isso em uma única tela, com botões grandes que eu posso tocar com a mão molhada. Se o Pedrinho foi pro banheiro, toco em 'Distribuir', arrasto o carro dele pro Carlos, e pronto."

### Cenário de uso mais doloroso
> "O cliente da placa ABC ligou perguntando se o carro já está pronto. Estou no meio de lavar o carro da Maria. Preciso parar, pegar o celular, procurar o cliente na lista, ver o status. Se o sistema for lento ou complicado, o cliente fica esperando e eu perco a lavagem. Preciso de algo que abra rápido e mostre o status em um toque. E se a internet caiu, preciso continuar trabalhando."

### Cenário de uso ideal
> "Chego no trabalho, abro o sistema. Vejo 5 carros na fila. Toco em 'Começar o dia'. O sistema mostra: 'João, você lava os carros 1, 3 e 5. Pedrinho, você lava os carros 2 e 4.' Toco em 'comecei' no carro da Maria. Quando terminar, toco em 'finalizei'. O cliente chega, pago via PIX, toco em 'pagamento → PIX'. Pronto. Sem anotar nada, sem caderno, sem confusão. Se o carro da Maria já tinha um arranhão, tiro foto, registro, e o dono recebe no WhatsApp."

### Regras de negócio que impactam o funcionário
- **Comissão por carro:** Simples = R$ 5, Completa = R$ 8, Premium = R$ 12. O sistema deve calcular e mostrar por funcionário.
- **Distribuição de carros:** O "chefe de serviço" (eu) distribui os carros. Os outros funcionários só veem o carro designado pra eles.
- **Desconto:** Só o dono pode aprovar desconto. Se eu der desconto, não conta na minha comissão.
- **No-show:** Se o cliente agendou e não apareceu, eu marco como "faltou". O dono decide se cobra ou não.
- **Serviço extra:** Se o cliente pede algo além do agendamento (cera, polimento), eu registro como "serviço extra" e o dono aprova o valor.
- **Dano no carro:** Se o carro já tem dano quando chega, eu tiro foto e anoto. Se eu causar dano, registro no sistema.
- **Horário de pico:** Sexta e sábado à tarde (13h-17h) é só walk-in — sem agendamento. A fila é pela ordem de chegada.
- **Modo offline:** Se a internet cair, continuo trabalhando. Quando voltar, sincroniza tudo automaticamente.
- **Reatribuição:** Se um funcionário sai mais cedo, redistribuo os carros dele. O sistema avisa no WhatsApp.
