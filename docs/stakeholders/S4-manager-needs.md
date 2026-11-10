# S4 — Gerente Multi-tenant

## Perfil

**Nome:** Ana Paula Ribeiro, 48 anos  
**Negócio:** Rede "AutoLava" — 5 unidades em São Paulo (3 em bairros da zona sul, 1 na zona norte, 1 em Guarulhos)  
**Equipe:** 1 gerente por unidade (5 no total), ~30 funcionários espalhados entre as unidades  
**Faturamento mensal:** R$ 85.000 a R$ 120.000 (soma de todas as unidades)  
**Perfil tecnológico:** Usa WhatsApp, Instagram, app do banco, Google Planilhas (básico). Já tentou usar um sistema de gestão mas desistiu porque "era muito complicado e não funcionava no celular". Tem um computador no escritório da unidade principal, mas usa celular e tablet o dia todo.  
**Dispositivos principais:** Smartphone Samsung Galaxy S22 (pessoal), iPad Air (escritório), notebook Lenovo (escritório). Usa WhatsApp o dia todo para falar com gerentes de unidade. Instagram para postar foto das unidades. App do banco para verificar saldo de cada conta.  
**Dor principal:** Não consigo ver o desempenho de cada unidade de um só lugar. Não sei qual unidade está dando mais lucro, qual tem mais clientes recorrentes, qual está com problema de estoque ou equipe. Chego a perder 2 horas por semana só compilando planilhas que os gerentes me mandam. E às vezes um gerente mente nos números porque não tenho como conferir.  
**Objetivo:** Queria um sistema que me mostrasse, de um só lugar, como cada unidade está indo — faturamento, equipe, estoque, clientes — e que me permitisse tomar decisões sem depender dos relatórios que os gerentes me mandam. Preciso de transparência e controle.

---

## Fluxo Principal

### Como eu gerencio múltiplas unidades no dia a dia

### Manhã (7h — 12h)

1. **Abro o sistema pelo celular** — vejo o dashboard consolidado com:
   - Resumo de todas as unidades: "5 unidades, 23 carros agendados hoje no total"
   - Faturamento de ontem por unidade (ex: "Tatuapé: R$ 3.200 | Moema: R$ 4.100 | Guarulhos: R$ 2.800")
   - Alertas: "2 unidades com estoque baixo", "1 funcionário faltou no Tatuapé"
   - Gráfico rápido: "Faturamento semanal — Moema em alta, Guarulhos em baixa"

2. **Clico em uma unidade específica** — rolo para baixo e vejo:
   - Agenda do dia daquela unidade
   - Equipe disponível hoje
   - Estoque atual
   - Clientes agendados
   - Status dos serviços em andamento

3. **Comparo unidades** — clico em "Comparar" e vejo:
   - Faturamento mensal lado a lado
   - Quantidade de carros por unidade
   - Satisfação dos clientes (nota média por unidade)
   - Taxa de no-show por unidade

4. **Envio mensagem para o gerente** — se vi um problema (estoque baixo, equipe faltando), clico em "Chamar gerente" e mando mensagem pronta pelo WhatsApp: "Ana, vi que o estoque de shampoo está baixo na unidade Moema. Pode repor hoje?"

### Tarde (12h — 18h)

5. **Verifico unidades que estão com problemas** — entro nas unidades com alerta vermelho:
   - Faturamento abaixo da média
   - Estoque crítico
   - Equipe com faltas
   - Clientes reclamando (avaliação baixa)

6. **Tomo decisões** — se uma unidade está indo mal, posso:
   - Transferir estoque de outra unidade
   - Pedir para o gerente de outra unidade emprestar um funcionário
   - Ajustar preços daquela unidade
   - Agendar visita presencial

7. **Preparo para o dia seguinte** — vejo a agenda de amanhã em todas as unidades e vejo se precisa de ajustes (mais equipe, mais estoque, etc.)

### Final de Semana

8. **Sábado — dia mais corrido** — não tenho tempo de abrir o sistema no meio do dia. Só abro na sexta à noite para ver a agenda de sábado em todas as unidades e no domingo à noite para fechar o balanço semanal.

9. **Domingo à noite — balanço semanal** — clico em "Relatório semanal" e vejo:
   - Faturamento total da semana por unidade
   - Comparativo com semana anterior
   - Top 3 unidades do mês
   - Unidades com queda
   - Comissão total da equipe

### Fim do Mês

10. **Fechamento mensal** — clico em "Relatório mensal" e vejo:
    - Faturamento total de cada unidade
    - Comparativo com mês anterior
    - Crescimento por unidade
    - Comissão total a pagar
    - Custo de insumos por unidade
    - Lucro bruto por unidade
    - Exporto para planilha ou PDF

---

## Tarefas Essenciais (MVP)

- [ ] **Ver dashboard consolidado de todas as unidades** — ver resumo de faturamento, agenda, equipe e estoque de todas as unidades em uma única tela
- [ ] **Selecionar uma unidade específica** — clicar em uma unidade e ver todos os detalhes (agenda, equipe, estoque, clientes)
- [ ] **Comparar faturamento entre unidades** — ver lado a lado quanto cada unidade faturou no dia, semana e mês
- [ ] **Ver desempenho por unidade** — quantidade de carros lavados, taxa de no-show, nota média de avaliação por unidade
- [ ] **Gerenciar equipe multi-unidade** — ver quem trabalha em cada unidade, quem faltou, quem pode ser transferido
- [ ] **Transferir estoque entre unidades** — mover shampoo, cera, etc. de uma unidade para outra quando uma está sem e outra tem sobra
- [ ] **Controlar comissão por unidade** — ver quanto devo pagar de comissão por funcionário e por unidade
- [ ] **Ver fluxo de caixa por unidade** — ver quanto entrou e saiu em cada unidade separadamente
- [ ] **Configurar unidades** — cadastrar nova unidade, definir nome, endereço, equipe, serviços e preços
- [ ] **Ver estoque consolidado** — ver o estoque total de todas as unidades e identificar quais estão críticas
- [ ] **Receber alertas por unidade** — alerta de estoque baixo, equipe faltando, faturamento abaixo da média, avaliação baixa
- [ ] **Enviar mensagem para gerente de unidade** — mandar mensagem pronta pelo WhatsApp para o gerente de uma unidade específica
- [ ] **Ver relatório mensal consolidado** — faturamento total, custos, lucro bruto de todas as unidades
- [ ] **Exportar relatórios** — baixar relatório em PDF ou Excel (por unidade ou consolidado)
- [ ] **Definir preços diferentes por unidade** — uma unidade pode cobrar mais que outra dependendo do bairro
- [ ] **Ver histórico de transferências** — ver quando e quanto foi transferido entre unidades
- [ ] **Gerenciar permissões** — definir quem pode ver o quê (gerente de unidade vê só a sua, eu vejo tudo)
- [ ] **Registrar e gerenciar fechamento temporário de unidade** — quando uma unidade fecha (manutenção, falta de equipe, problema regulatório), registrar o fechamento, avisar clientes, redistribuir agendamentos, redirecionar equipe e estoque, e reabrir com resumo completo
- [ ] **Solicitar e gerenciar transferência de equipe entre unidades** — pedir funcionário emprestado, o gerente aprovar/recusar, registrar a transferência com data/hora/funcionário, e gerenciar a divisão de comissão entre unidades
- [ ] **Definir e monitorar preço mínimo por tipo de lavagem** — definir preço mínimo global ou por região, bloquear preços abaixo do mínimo, alertar quando unidade violar o mínimo, e ajustar preço mínimo globalmente com visão de impacto
- [ ] **Visualizar tabela de preços consolidada por unidade** — ver todos os preços de todos os serviços em todas as unidades lado a lado, comparar com a média do bairro, e exportar em PDF/Excel
- [ ] **Redistribuir agendamentos durante fechamento de unidade** — ver quais unidades têm disponibilidade, arrastar agendamentos para unidades alternativas, e o sistema avisar automaticamente os clientes transferidos

---

## Tarefas Desejáveis (Nice-to-have)

- [ ] **Gráfico de crescimento por unidade** — ver em gráfico de linha como cada unidade cresceu ao longo dos meses
- [ ] **Previsão de demanda por unidade** — o sistema prevê quantos carros cada unidade deve ter baseado na média histórica
- [ ] **Alerta de lucro por unidade** — "A unidade Guarulhos está com margem de lucro abaixo de 15% este mês"
- [ ] **Ranking de gerentes** — ver qual gerente está tendo melhor desempenho (faturamento, satisfação, controle de estoque)
- [ ] **Calendário compartilhado** — ver a agenda de todas as unidades em um calendário só
- [ ] **Chat entre gerentes** — os gerentes de unidade podem conversar entre si no sistema
- [ ] **Treinamento remoto** — enviar vídeo-tutorial para o gerente de uma unidade aprender a usar o sistema
- [ ] **Cupom por unidade** — gerar cupom de desconto específico para uma unidade
- [ ] **Campanha por bairro** — criar campanha de marketing específica para um bairro/unidade
- [ ] **Dashboard em tempo real** — ver os dados atualizarem em tempo real sem precisar recarregar
- [ ] **Notificação push por unidade** — receber alerta no celular quando algo importante acontecer em uma unidade
- [ ] **Exportar por período** — escolher período personalizado (ex: "15/10 a 15/11") para exportar relatório
- [ ] **Filtros avançados** — filtrar relatórios por data, unidade, tipo de serviço, funcionário
- [ ] **Backup automático por unidade** — cada unidade tem backup separado, posso restaurar só uma
- [ ] **Integração com contador** — exportar dados prontos para o contador da empresa
- [ ] **Planilha de metas** — definir meta de faturamento por unidade e ver o progresso

---

## Cenário de Crise — Unidade Fecha Temporariamente

### Quando uma unidade para

Isso já aconteceu comigo: a unidade de Guarulhos ficou 4 dias sem funcionar porque o telhado vazou numa tempestade. O problema é que eu não tinha um plano. Os clientes ligavam, o gerente não sabia o que fazer, e eu ficava no meio sem informação.

### Tipos de fechamento temporário

- **Manutenção na unidade** — teto vazando, falta de energia, reforma urgente, quebraram o equipamento de lavagem
- **Falta de equipe** — todos do plantão doente, ninguém disponível, o gerente também faltou
- **Problema regulatório** — vistoria da prefeitura, licença sanitidade suspensa, multa que obriga fechamento
- **Desastre natural** — enchente, vendaval, queda de árvore na porta

### Como eu aviso os clientes da unidade fechada

1. **Abro a unidade com problema** — no dashboard, a unidade aparece com um alerta vermelho grande: "UNIDADE FECHADA — Motivo: Manutenção urgente"
2. **Clico em "Avisar clientes"** — o sistema mostra todos os clientes agendados nos próximos 3 dias naquela unidade
3. **Escolho como avisar** — tenho três opções:
   - **Mensagem em massa no WhatsApp** — o sistema envia uma mensagem pronta para todos os clientes agendados: "Olá! A unidade [Nome] estará fechada de [data] a [data] por [motivo]. Seus agendamentos foram transferidos para [outra unidade] ou você pode reagendar. Desculpe o inconveniente."
   - **Ligar para os clientes do dia** — o sistema me dá a lista de quem tem agendamento hoje/amanhã e eu ligo um por um
   - **Publicar no Instagram** — o sistema gera um story pronto com o aviso e a unidade alternativa
4. **O sistema registra quem foi avisado** — vejo quantos clientes já receberam o aviso e quantos ainda faltam

### Como redistribuo agendamentos para outras unidades

1. **Vejo quais unidades têm disponibilidade** — clico em "Unidades disponíveis" e vejo:
   - "Moema: 8 vagas hoje"
   - "Tatuapé: 5 vagas hoje"
   - "Brooklin: 12 vagas hoje"
2. **Arrasto os agendamentos** — na tela da unidade fechada, vejo a lista de clientes agendados. Arrasto cada um para uma unidade disponível (ou clico na unidade destino)
3. **O sistema avisa o cliente automaticamente** — quando eu transfere um agendamento, o cliente recebe: "Seu agendamento na unidade [X] foi transferido para [Y] por motivo de [motivo]. Endereço: [endereço da nova unidade]. Confirme recebendo esta mensagem."
4. **Vejo o aceite** — o cliente pode confirmar ou recusar. Se recusar, o agendamento volta para mim e eu preciso resolver manualmente
5. **Compensação** — o sistema sugere: "Oferecer 10% de desconto para os clientes transferidos?" Eu aprovo e o desconto é aplicado automaticamente

### Como mantenho equipe e estoque funcionando durante o fechamento

1. **Redirecionamento de equipe** — se a unidade fechou e tem funcionários parados:
   - Clico em "Redirecionar equipe"
   - Vejo quais funcionários estão disponíveis
   - Arrasto para outras unidades que precisam de pessoal
   - O sistema registra: "João transferido temporariamente de Guarulhos para Moema até [data estimada de retorno]"
2. **Proteção de estoque** — se a unidade vai fechar por mais de 2 dias:
   - O sistema pergunta: "Mover estoque das unidades fechadas para outras?"
   - Eu escolho quais produtos mover e para quais unidades
   - O sistema registra a transferência e atualiza o estoque
3. **Manter custos registrados** — mesmo fechada, a unidade continua gerando custos (aluguel, energia). O sistema registra: "Guarulhos: R$ 1.200 de custo fixo este dia sem faturamento"

### Como registro a crise e o tempo de fechamento

1. **Crio um registro de crise** — clico em "Registrar fechamento" e preencho:
   - Motivo: "Teto vazando — tempestade"
   - Data/hora de início: automático (quando detectei o problema)
   - Data/hora estimada de retorno: "3 dias"
   - Fotos: tiro foto do problema e anexo
   - Contato do prestador de serviço: "Pedro Telhas — (11) 99999-1234"
2. **O sistema cria um cronômetro** — fica contando quantos dias a unidade está fechada
3. **Alerta automático** — se a unidade ultrapassar 3 dias fechada, eu recebo um alerta: "Guarulhos está fechada há 4 dias. Ação necessária?"
4. **Histórico de crises** — no relatório mensal, vejo quantos dias cada unidade ficou parada e quanto isso custou

### Como recupero os agendamentos quando a unidade reabre

1. **Clico em "Reabrir unidade"** — o sistema pergunta: "Confirmar reabertura da unidade [Nome]?"
2. **Vejo o resumo do fechamento** — antes de reabrir, vejo:
   - "Guarulhos ficou fechada de 10/10 a 14/10 (4 dias)"
   - "12 clientes foram transferidos"
   - "3 clientes recusaram a transferência"
   - "2 funcionários foram redirecionados"
   - "Faturamento perdido estimado: R$ 8.400"
3. **Reatribuo os clientes recusados** — clico em "Clientes recusados" e vejo os 3 que não aceitaram a transferência. Clico em "Reagendar" e o sistema sugere horários disponíveis
4. **Devolvo a equipe** — se redirecionei funcionários, o sistema pergunta: "Devolver João para Guarulhos?" Eu confirmo
5. **O estoque é verificado** — o sistema mostra: "Guarulhos tem 80% do estoque original. Faltam: Cera (500ml), Toalha (3 unidades)"
6. **A unidade volta ao dashboard** — aparece com um aviso: "Reabriu hoje — 3 agendados para hoje"

---

## Fluxo de Transferência de Equipe

### Quando posso pedir emprestado

- **Emergência** — funcionário doente de última hora, ninguém para cobrir o plantão
- **Dia de pico** — sexta-feira, feriado, chuva (clientes querem lavar o carro que estava guardado) — uma unidade tem 20 agendados e só 2 funcionários
- **Falta de habilidade** — preciso de alguém que saiba fazer polimento e a unidade não tem
- **Férias ou licença** — o funcionário regular está de folga e preciso de cobertura

### Como peço (botão, mensagem, notificação)

1. **Abro a unidade que precisa de ajuda** — clico na unidade com problema
2. **Clico em "Pedir equipe emprestada"** — abre um formulário rápido:
   - "Qual função precisa?" — "Lavador" / "Polidor" / "Gerente"
   - "Quantos funcionários?" — "1"
   - "Por quanto tempo?" — "Hoje" / "2 dias" / "Até segunda"
   - "Motivo?" — "Falta de pessoal — 3 faltas hoje"
3. **O sistema envia para as unidades próximas** — escolho automaticamente as unidades mais próximas (raio de 5 km) ou escolho manualmente
4. **Recebo notificação** — o gerente da unidade solicitada recebe: "Ana Paula (AutoLava) pede 1 lavador emprestado para Tatuapé hoje. Motivo: falta de pessoal. Aceitar?"

### Como o gerente da outra unidade aprova ou recusa

1. **O gerente recebe a solicitação** — no celular, abre o app e vê:
   - "Solicitação de empréstimo: 1 lavador para Tatuapé (5 km)"
   - "Quanto tempo: Hoje"
   - "Quem pode emprestar: João (disponível agora)"
2. **O gerente pode aprovar, recusar ou contra-propor**:
   - **Aprovar** — clica em "Aceitar" e o funcionário é reservado
   - **Recusar** — clica em "Recusar" e escolhe o motivo: "Não tenho disponível" / "Estou no pico agora" / "Não posso emprestar neste momento"
   - **Contra-propor** — clica em "Oferecer outro" e escolhe um funcionário diferente ou propõe um horário diferente
3. **Se não responder em 30 minutos** — o sistema envia um lembrete: "Lembrete: Ana Paula precisa de 1 lavador para Tatuapé. Responda até 14h."
4. **Se não responder em 1 hora** — o sistema me alerta: "O gerente de Moema não respondeu. Tentar outra unidade?"

### Como registro a transferência (data, hora, funcionário, unidade origem/destino)

1. **Quando aprovado, o sistema gera um registro automático**:
   - "Transferência #T-2024-042"
   - "De: Moema → Para: Tatuapé"
   - "Funcionário: João Silva"
   - "Data: 15/11/2024"
   - "Horário: 08h00 — 18h00"
   - "Motivo: Falta de pessoal"
   - "Autorizado por: Ana Paula (gerente geral)"
2. **O funcionário recebe um aviso** — no app dele aparece: "Você foi transferido temporariamente para Tatuapé hoje (08h-18h). Endereço: [endereço]. Confirme recebendo esta mensagem."
3. **O funcionário confirma no app** — clica em "Confirmar" e o sistema registra o aceite
4. **A equipe das duas unidades é atualizada** — Moema perde 1 da contagem, Tatuapé ganha 1

### Como funciona a comissão (quem paga, quanto, como divide)

1. **A comissão é dividida automaticamente** — quando o funcionário trabalha em outra unidade:
   - **50% da comissão vai para a unidade de origem** (Moema) — porque o funcionário é deles
   - **50% da comissão é cobrada da unidade de destino** (Tatuapé) — porque foi ela que usou
2. **O sistema registra a divisão** — no relatório de comissão:
   - "João Silva — R$ 50,00 de comissão"
   - "Metade (R$ 25,00) cobrada de Tatuapé"
   - "Metade (R$ 25,00) paga por Moema"
3. **O gerente de cada unidade vê a divisão** — o gerente de Tatuapé vê: "R$ 25,00 de comissão transferida (João Silva, emprestado de Moema)"
4. **No fechamento mensal, aparece separado** — "Comissões com transferência inter-unidade: R$ 350,00 no mês"

### O que acontece se o funcionário não quiser ir

1. **O sistema pergunta no app do funcionário** — "Você foi transferido para Tatuapé hoje. Aceitar?"
2. **Se ele recusar** — o sistema me avisa: "João Silva recusou a transferência para Tatuapé. Motivo: 'Não posso hoje'."
3. **Eu preciso achar outro** — clico em "Outro funcionário" e o sistema mostra quem mais está disponível naquela unidade
4. **Se não houver ninguém** — o sistema sugere:
   - "Reduzir a carga horária de outros funcionários"
   - "Pedir para o gerente de outra unidade emprestar"
   - "Fechar a unidade mais cedo"
5. **Registro a recusa** — o sistema anota: "João Silva recusou transferência — motivo não informado. Reavaliar em 1 semana."

---

## Gestão de Preços

### Como defino um preço mínimo por tipo de lavagem

1. **Vou em "Preços mínimos"** — clico no menu e escolho "Definir preço mínimo"
2. **Escolho o tipo de lavagem** — "Lavagem Simples" / "Completa" / "Premium" / "Polimento" / "Cera"
3. **Defino o preço mínimo** — "Lavagem Simples não pode ser cobrada menos de R$ 25 em nenhuma unidade"
4. **O sistema salva e distribui** — todas as unidades recebem o preço mínimo atualizado
5. **Posso definir por região** — "Zona Sul: mínimo R$ 25 | Zona Norte: mínimo R$ 20 | Guarulhos: mínimo R$ 22"

### Como cada unidade define seu preço acima do mínimo

1. **Cada gerente define o preço da unidade** — dentro do app da unidade, o gerente vê:
   - "Preço mínimo definido pela rede: R$ 25,00"
   - "Preço atual da sua unidade: R$ 30,00"
   - "Bairro: Moema (renda média alta) — preço sugerido: R$ 35,00"
2. **O sistema sugere um preço** — baseado no poder de compra do bairro e na média da região
3. **O gerente pode ajustar** — desde que não fique abaixo do mínimo. Se tentar colocar R$ 20, o sistema bloqueia: "Preço abaixo do mínimo da rede (R$ 25,00). Ajuste para R$ 25,00 ou solicite redução de mínimo."
4. **Se o gerente quer cobrar menos** — ele clica em "Solicitar redução de preço mínimo" e eu (gerente geral) aprovo ou recuso

### Tabela de preços por unidade (visão consolidada)

1. **Clico em "Tabela de preços"** — vejo uma tabela com todas as unidades e seus preços:

   | Serviço | Tatuapé | Moema | Brooklin | Zona Norte | Guarulhos |
   |---------|---------|-------|----------|------------|-----------|
   | Lavagem Simples | R$ 30 | R$ 35 | R$ 28 | R$ 25 | R$ 27 |
   | Lavagem Completa | R$ 50 | R$ 55 | R$ 48 | R$ 45 | R$ 47 |
   | Lavagem Premium | R$ 80 | R$ 90 | R$ 75 | R$ 70 | R$ 72 |
   | Polimento | R$ 120 | R$ 140 | R$ 110 | R$ 100 | R$ 105 |
   | Cera | R$ 60 | R$ 70 | R$ 55 | R$ 50 | R$ 52 |

2. **Vejo o preço médio da região** — ao lado de cada preço, uma cor indica se está acima ou abaixo da média do bairro
3. **Filtro por serviço** — clico em "Lavagem Simples" e vejo só os preços desse serviço em todas as unidades
4. **Exporto a tabela** — baixo em PDF ou Excel para enviar ao contador ou para uma reunião

### Alerta se unidade cobrar abaixo do mínimo

1. **O sistema monitora em tempo real** — se uma unidade começa a cobrar abaixo do mínimo:
   - **Alerta amarelo** — "A unidade Zona Norte está cobrando R$ 23 na lavagem simples (mínimo: R$ 25). Verifique se é erro de digitação ou estratégia intencional."
   - **Bloqueio de agendamento** — se o preço está abaixo do mínimo, o sistema impede novos agendamentos naquele preço
   - **Alerta vermelho** — se a unidade já cobrou abaixo do mínimo 3 vezes em uma semana: "A unidade Zona Norte violou o preço mínimo 3 vezes esta semana. Ação imediata necessária."
2. **Eu recebo a notificação** — no celular: "⚠️ Preço abaixo do mínimo — Zona Norte — Lavagem Simples: R$ 23,00 (mínimo: R$ 25,00)"
3. **Posso corrigir na hora** — clico em "Corrigir preço" e o sistema atualiza o preço da unidade automaticamente
4. **Registro a violação** — o sistema anota: "Zona Norte — violação de preço mínimo — 15/11/2024 — Lavagem Simples R$ 23 vs mínimo R$ 25"

### Como ajusto preço mínimo globalmente

1. **Vou em "Ajustar preço mínimo global"** — clico no menu de preços
2. **Escolho o serviço** — "Lavagem Simples"
3. **Vejo o preço mínimo atual** — "Atual: R$ 25,00"
4. **Vejo a média de preços praticada** — "Média praticada: R$ 30,00 | Menor preço: R$ 25,00 | Maior preço: R$ 35,00"
5. **Defino o novo mínimo** — "R$ 28,00"
6. **O sistema mostra o impacto** — "3 unidades estão no mínimo atual. Se aumentar para R$ 28, 2 unidades terão que ajustar. Impacto estimado: +R$ 2.000/mês"
7. **Confirmo a mudança** — clico em "Aplicar" e todas as unidades recebem o novo mínimo
8. **As unidades que estavam no mínimo antigo** — recebem um aviso: "Seu preço mínimo foi ajustado de R$ 25 para R$ 28. Você pode manter o preço atual ou ajustar."

### Como comparo preços por bairro/região

1. **Clico em "Comparativo por bairro"** — vejo um mapa com as unidades e seus preços
2. **Filtro por serviço** — escolho "Lavagem Completa" e vejo:
   - "Moema: R$ 55 (acima da média do bairro em 10%)"
   - "Zona Norte: R$ 45 (abaixo da média do bairro em 5%)"
   - "Guarulhos: R$ 47 (dentro da média)"
3. **Vejo se estou perdendo clientes por preço** — "Zona Norte: taxa de no-show de 12% (média: 5%) — possível que o preço esteja muito baixo e o cliente desconfie da qualidade"
4. **Vejo se estou deixando dinheiro na mesa** — "Moema: preço 10% acima da média, mas taxa de ocupação de 85% (média: 70%) — podemos aumentar mais"
5. **Gero um relatório de precificação** — clico em "Relatório de preços" e baixo um PDF com análise completa

---

## Pain Points Atuais

- [ ] **Dependo dos relatórios dos gerentes** — eles me mandam planilha no WhatsApp, às vezes erram os números, às vezes mentem. Não tenho como conferir.
- [ ] **Perco 2 horas por semana compilando dados** — peço relatório para cada gerente, recebo 5 planilhas diferentes, tenho que juntar tudo manualmente.
- [ ] **Não sei qual unidade é a mais lucrativa** — vejo o faturamento bruto, mas não sei qual unidade realmente dá mais lucro depois dos custos.
- [ ] **Estoque descontrolado entre unidades** — às vezes uma unidade tem sobra de shampoo e outra está sem. Não tenho como transferir rápido.
- [ ] **Equipe não se equilibra** — numa unidade tem funcionário sobrando e na outra tem falta. Não tenho como redistribuir.
- [ ] **Preços diferentes por unidade me confundem** — uma unidade cobra R$ 30 e outra R$ 35. Não tenho uma visão clara de qual estratégia está funcionando.
- [ ] **Não consigo dar nota para o gerente** — não tenho como avaliar o desempenho do gerente de cada unidade. Só vejo o número, não a gestão.
- [ ] **Fechamento mensal é uma dor** — no fim do mês, tenho que juntar 5 planilhas, somar tudo, conferir com o banco. Leva horas e às vezes dá erro.
- [ ] **Não vejo o lucro bruto por unidade** — só no fim do mês eu descubro se uma unidade deu prejuízo. Preciso ver isso em tempo real.
- [ ] **Não consigo comparar com mês anterior** — não tenho como ver se uma unidade cresceu ou caiu em relação ao mês passado.
- [ ] **Transferência de dinheiro entre unidades é complicada** — se preciso mover dinheiro de uma conta para outra para pagar conta, não tenho registro organizado.
- [ ] **Não tenho visão de custo por unidade** — não sei quanto cada unidade gasta de insumo, energia, aluguel. Só vejo o faturamento.
- [ ] **Se um gerente sai, não tenho como passar o bastão** — o conhecimento fica todo com ele. Se ele sai, eu perco o controle.
- [ ] **Não consigo ver a satisfação do cliente por unidade** — não sei qual unidade tem os clientes mais satisfeitos e qual precisa melhorar.
- [ ] **Relatórios em papel ou WhatsApp são desorganizados** — quando o gerente me manda foto de planilha no WhatsApp, eu não consigo comparar com outras.
- [ ] **Não tenho plano de crise** — quando uma unidade fecha (manutenção, falta de equipe, problema regulatório), eu não sei como avisar os clientes, redistribuir agendamentos ou manter as outras unidades funcionando. Perco clientes e dinheiro sem um processo.
- [ ] **Transferência de equipe é manual e confusa** — quando preciso emprestar um funcionário de uma unidade para outra, faço por WhatsApp, anoto no caderno, e ninguém sabe direito quem pagou a comissão. A divisão de comissão entre unidades é um caos.
- [ ] **Não controlo preços mínimos entre unidades** — uma unidade pode cobrar R$ 20 e outra R$ 35 pelo mesmo serviço. Não tenho como impedir que uma unidade faça preço abaixo do que eu defino como mínimo, e às vezes uma unidade desvaloriza o serviço no bairro.

---

## Onboarding

### Como eu configuro o sistema pela primeira vez

**Passo 1 — Cadastro (3 minutos)**
- Abro o app ou site
- Coloco meu nome, telefone com WhatsApp, e CPF/CNPJ
- Clico em "Começar"

**Passo 2 — Configurar a primeira unidade (5 minutos)**
- Nome da unidade: "AutoLava Tatuapé"
- Endereço completo
- Tipo de negócio: "Lava-carro com equipe"
- Quantos funcionários: "6"
- O sistema cria automaticamente o cargo "Gerente de Unidade" para mim

**Passo 3 — Configurar serviços e preços (5 minutos)**
- O sistema já traz sugestões: Lavagem Simples (R$ 30), Completa (R$ 50), Premium (R$ 80)
- Posso aceitar os valores padrão ou mudar
- Posso adicionar serviços extras (cera, polimento, etc.)
- Defino o tempo estimado de cada um

**Passo 4 — Configurar estoque inicial (3 minutos)**
- O sistema sugere produtos comuns: Shampoo automotivo, Cera, Cera Seca, Desinfetante, Toalha
- Coloco quanto tenho de cada um
- Defino o nível mínimo de alerta

**Passo 5 — Adicionar gerentes de unidade (5 minutos)**
- Clico em "Adicionar gerente"
- Coloco nome, telefone, e a unidade que ele vai gerenciar
- O gerente recebe um link de acesso pelo WhatsApp

**Passo 6 — Adicionar mais unidades (5 minutos)**
- Clico em "Adicionar unidade"
- Repito o processo: nome, endereço, equipe, serviços
- Cada unidade é independente: seu próprio caixa, estoque e agenda

**Passo 7 — Configurar permissões (3 minutos)**
- Eu (Ana Paula) vejo tudo
- Cada gerente vê só sua unidade
- Funcionários veem só o que é do trabalho deles

**Total de tempo:** ~24 minutos. Sem complicação, sem configuração técnica.

---

## Regras de Negócio

- **Unidades independentes:** Cada unidade tem seu próprio caixa, estoque, agenda e equipe. Os dados são separados, mas eu vejo tudo consolidado.
- **Preços podem variar por unidade:** Uma unidade no bairro nobre pode cobrar mais que uma na periferia. Cada unidade define seus próprios preços (dentro de um limite mínimo que eu defino).
- **Transferência de estoque:** Posso transferir produtos entre unidades. A transferência é registrada com data, hora, produto, quantidade e quem autorizou. O estoque é atualizado automaticamente nas duas unidades.
- **Transferência de equipe:** Em casos de emergência, posso pedir para um funcionário de uma unidade ajudar em outra por um dia. Isso é registrado e a comissão é dividida.
- **Comissão por unidade:** A comissão do funcionário é calculada com base nos carros que ele lavou NA UNIDADE dele. Se ele for emprestado para outra unidade, a comissão é dividida proporcionalmente.
- **Fechamento por unidade:** Cada unidade fecha o caixa separadamente. No fim do mês, eu fecho o consolidado de todas.
- **Meta por unidade:** Posso definir uma meta de faturamento para cada unidade. O sistema mostra o progresso em tempo real.
- **Avaliação por unidade:** Cada unidade tem sua nota média de avaliação. Se a nota cair abaixo de 4.0, eu recebo um alerta.
- **Custo por unidade:** Cada unidade tem seus custos (aluguel, energia, água, internet). Eu registro esses custos e o sistema calcula o lucro bruto por unidade.
- **Campanhas por unidade:** Posso criar campanha de desconto ou promoção específica para uma unidade.
- **Horário de funcionamento:** Cada unidade pode ter horário diferente. A unidade do Tatuapé funciona das 7h às 18h, a de Guarulhos das 8h às 17h.
- **No-show:** Se o cliente agendou e não apareceu, o gerente marca como "faltou". Se repetir 3 vezes, o sistema marca o cliente como "não confiável" e cobra 50% adiantado.
- **Relatórios:** Eu posso exportar relatório de uma unidade só ou consolidado de todas. O relatório consolidado soma tudo e mostra também a média.
- **Backup:** Cada unidade tem backup automático diário. Posso restaurar uma unidade específica sem afetar as outras.

---

## Relatórios Necessários

- **Dashboard consolidado** — resumo de todas as unidades em uma tela: faturamento total, carros agendados, equipe disponível, estoque crítico
- **Faturamento por unidade (dia/semana/mês)** — ver quanto cada unidade faturou e comparar com a média
- **Comparativo mensal** — quanto cada unidade faturou este mês vs mês passado (ex: "Moema: +15%, Guarulhos: -8%")
- **Ranking de unidades** — ver quais são as 3 melhores e as 3 piores unidades do mês
- **Lucro bruto por unidade** — faturamento menos custos (insumos, comissão, custos fixos)
- **Custo por unidade** — quanto cada unidade gasta de insumos, energia, aluguel
- **Equipe por unidade** — quantos funcionários, quantos faltaram, quem está disponível
- **Comissão consolidada** — quanto devo pagar no total e por unidade
- **Estoque consolidado** — estoque total de todas as unidades e quais estão críticas
- **Transferências entre unidades** — histórico de tudo que foi transferido
- **Satisfação do cliente por unidade** — nota média de avaliação por unidade
- **Taxa de no-show por unidade** — quantos clientes agendaram e não apareceram
- **Top clientes por unidade** — quem são os clientes mais frequentes em cada unidade
- **Serviços mais vendidos por unidade** — qual lavagem vende mais em cada unidade
- **Relatório de crescimento** — gráfico de como cada unidade cresceu ao longo dos meses
- **Relatório de gerentes** — desempenho de cada gerente (faturamento, satisfação, controle de estoque)
- **Exportar relatório consolidado** — baixar PDF ou Excel com dados de todas as unidades
- **Exportar relatório por unidade** — baixar PDF ou Excel de uma unidade específica

---

## Integrações

- **WhatsApp** — enviar mensagem para gerentes de unidade, receber alertas de cada unidade, enviar mensagem pronta para o gerente quando algo estiver errado
- **Google Planilhas** — exportar dados para planilha, importar planilha existente (se o gerente já usa)
- **App do banco** — exportar resumo de faturamento por unidade para conciliar com o banco
- **PIX** — registrar pagamento PIX e identificar qual unidade recebeu
- **Google Agenda** — ver a agenda de todas as unidades em um calendário só
- **Instagram** — postar foto de cada unidade separadamente, com nome da unidade na foto
- **Sistema de pagamento (Mercado Pago, etc.)** — gerar link de pagamento PIX com identificação da unidade
- **Impressora térmica** — cada unidade pode ter sua própria impressora, o sistema identifica qual é qual
- **Google Maps** — ver todas as unidades no mapa, com endereço e horário de funcionamento
- **Email** — receber relatório semanal por email (além do WhatsApp)

---

## Priorização

| Prioridade | Tarefa | Por quê |
|------------|--------|---------|
| P0 | Ver dashboard consolidado | Sem isso, não vejo o panorama geral de todas as unidades |
| P0 | Selecionar uma unidade específica | Preciso entrar nos detalhes de cada unidade individualmente |
| P0 | Comparar faturamento entre unidades | Preciso saber qual unidade está indo melhor e qual está pior |
| P0 | Ver desempenho por unidade | Preciso ver carros lavados, no-show, avaliação por unidade |
| P0 | Gerenciar equipe multi-unidade | Preciso saber quem trabalha em cada unidade e quem faltou |
| P0 | Transferir estoque entre unidades | Se uma unidade está sem e outra tem sobra, preciso mover rápido |
| P0 | Controlar comissão por unidade | Preciso saber quanto devo pagar por funcionário e por unidade |
| P0 | Ver fluxo de caixa por unidade | Preciso ver quanto entrou e saiu em cada unidade separadamente |
| P0 | Configurar unidades | Preciso cadastrar nova unidade sem complicação |
| P0 | Ver estoque consolidado | Preciso identificar quais unidades estão com estoque crítico |
| P0 | Receber alertas por unidade | Preciso saber quando algo está errado em alguma unidade |
| P0 | Ver relatório mensal consolidado | Preciso do fechamento mensal de todas as unidades |
| P0 | Registrar fechamento temporário de unidade | Se uma unidade para, preciso avisar clientes e redistribuir agendamentos sem perder ninguém |
| P0 | Redistribuir agendamentos durante fechamento | Preciso ver quais unidades têm disponibilidade e mover os agendamentos dos clientes |
| P0 | Definir e monitorar preço mínimo | Preciso impedir que nenhuma unidade cobre abaixo do mínimo que eu definir |
| P1 | Exportar relatórios | Preciso baixar em PDF/Excel para enviar ao contador e arquivar |
| P1 | Definir preços diferentes por unidade | Cada bairro tem poder de compra diferente |
| P1 | Enviar mensagem para gerente | Preciso comunicar com o gerente sem sair do sistema |
| P1 | Ver histórico de transferências | Preciso saber o que foi transferido e quando |
| P1 | Gerenciar permissões | Preciso controlar quem vê o quê |
| P1 | Solicitar transferência de equipe entre unidades | Preciso pedir funcionário emprestado e o sistema registrar tudo (data, hora, comissão) |
| P1 | Visualizar tabela de preços consolidada | Preciso ver todos os preços de todas as unidades lado a lado e comparar com a média do bairro |
| P2 | Gráfico de crescimento por unidade | Visualização é melhor que tabela para entender tendência |
| P2 | Previsão de demanda | Me ajudaria a planejar equipe e estoque |
| P2 | Alerta de lucro por unidade | Não quero descobrir no fim do mês que uma unidade deu prejuízo |
| P2 | Ranking de gerentes | Preciso avaliar o desempenho de cada gerente |
| P2 | Calendário compartilhado | Ver todas as agendas em um só lugar |
| P2 | Chat entre gerentes | Facilita comunicação entre unidades |
| P2 | Dashboard em tempo real | Não quero ficar recarregando a página |
| P2 | Planilha de metas | Definir meta e acompanhar progresso |
| P2 | Campanha por unidade | Marketing específico para cada bairro |
| P2 | Exportar por período | Quero escolher período personalizado |
| P2 | Filtros avançados | Filtrar por data, unidade, tipo de serviço |

---

## Notas Adicionais

### O que NÃO é prioridade agora
- IA para prever demanda (ainda não tenho dados suficientes para 5 unidades)
- App nativo para instalar (web app responsivo no celular e tablet já resolve)
- Chatbot com IA (não quero conversar com robô, quero falar com gerente)
- Sistema de RH completo (gestão de folha de pagamento, férias, etc.) — isso é coisa do contador
- Integração com sistema de pagamento externo (PIX direto já basta por enquanto)
- Marketplace (não quero que clientes de uma unidade agendem em outra)

### Cenário de uso mais importante
> "Estou no escritório da unidade Tatuapé, com o iPad na mão. Abro o sistema e vejo o dashboard: 5 unidades, 23 carros agendados hoje, R$ 18.500 de faturamento ontem. Vejo que a unidade Guarulhos teve queda de 15% em relação à semana passada. Clico em Guarulhos, entro nos detalhes, vejo que o gerente faltou 3 dias esta semana e o estoque de shampoo está baixo. Clico em 'Chamar gerente', mando mensagem: 'Carlos, vi que o estoque de shampoo está baixo e você faltou 3 dias. Pode repor hoje e me explicar as faltas?'. Pronto. Sem ligar, sem planilha, sem esperar."

### Cenário de uso mais doloroso
> "É domingo à noite, vou fechar o balanço semanal. Peço para cada um dos 5 gerentes me mandar a planilha do dia. Recebo 5 mensagens no WhatsApp com fotos de planilhas. Abro o Google Planilhas, copio os dados de cada uma, coloco tudo em uma planilha só. Somei no papel. Perdi 2 horas. E ainda assim não tenho certeza se os números estão certos porque o gerente de Guarulhos errou a soma. No fim do mês, é o mesmo processo mas com 30 dias de dados. Levo o dia inteiro."

### Cenário de uso ideal
> "Abro o sistema no iPad. Vejo o dashboard consolidado: 5 unidades, 47 carros agendados hoje, R$ 32.000 de faturamento esperado. Vejo que a unidade Moema está com faturamento 20% acima da média, e Guarulhos 15% abaixo. Clico em Guarulhos, vejo que o estoque de cera está baixo e o gerente faltou. Clico em 'Transferir estoque', escolho 'Cera' da unidade Moema (que tem sobra), e mando para Guarulhos. O sistema registra a transferência e atualiza o estoque das duas unidades. Clico em 'Chamar gerente', mando mensagem. Em 5 minutos, resolvi dois problemas que antes levavam 2 horas."

### Regras de negócio que impactam o gerente multi-tenant
- **Unidades independentes:** Cada unidade tem seu próprio caixa, estoque e agenda. Não misturo os dados.
- **Preços variáveis:** Cada unidade pode ter preços diferentes. Mas defino um preço mínimo que nenhuma unidade pode baixar.
- **Transferência de estoque:** Registro tudo que é transferido. Quem autorizou, quando, quanto, e para qual unidade.
- **Transferência de equipe:** Em emergências, posso emprestar funcionário. A comissão é dividida proporcionalmente.
- **Fechamento:** Cada unidade fecha o caixa separadamente. Eu fecho o consolidado.
- **Meta:** Posso definir meta de faturamento por unidade. O sistema mostra o progresso em tempo real.
- **Avaliação:** Cada unidade tem nota média. Se cair abaixo de 4.0, recebo alerta.
- **Custo:** Registro custos fixos de cada unidade (aluguel, energia, água) para calcular lucro bruto.
- **Campanhas:** Posso criar campanha específica por unidade ou campanha geral para todas.
- **Backup:** Cada unidade tem backup diário separado. Posso restaurar uma unidade sem afetar as outras.

### Diferença entre S1 (Dono) e S4 (Gerente Multi-tenant)

| Aspecto | S1 — Dono (1 unidade) | S4 — Gerente (3-10 unidades) |
|---------|------------------------|------------------------------|
| Escopo | Vê só sua unidade | Vê todas as unidades + consolidado |
| Equipe | Gerencia 6-8 funcionários | Gerencia 5 gerentes + 30 funcionários |
| Relatórios | Resumo do dia/mês | Comparativo entre unidades, ranking, lucro bruto |
| Estoque | Controla estoque da sua unidade | Controla estoque de todas + transferências |
| Preços | Define preços para sua unidade | Define preços mínimos, cada unidade pode variar |
| Decisões | Opera o dia a dia | Toma decisões estratégicas (transferir, ajustar) |
| Dispositivo | Celular principal | Celular + tablet + computador |
| Tempo | Usa o sistema o dia todo | Usa em blocos: manhã, tarde, fim de semana |
