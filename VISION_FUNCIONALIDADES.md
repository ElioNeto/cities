# Visão de Funcionalidades - Cities

## 1. Sistema de Mapa e Grade

- Mapa baseado em grade de 128x128 células
- Cada célula pode conter: solo vazio, estrada, zona ou construção
- Terreno plano para simplificar (opcional: diferentes altitudes)
- Visualização em tiles com sprites 2D para cada tipo
- Sistema de coordenadas (x, y) para posicionamento preciso

## 2. Construção de Estradas

- Ferramenta de desenho com clique e arraste
- Snap automático para a grade
- **Tipos de estrada**:
  - Rua de terra: baixo custo, baixa capacidade
  - Asfalto: custo médio, capacidade média
  - Avenida: alto custo, alta capacidade e velocidade
- Edifícios só podem ser construídos adjacentes a estradas
- Sistema de trânsito simplificado com veículos
- Congestionamentos reduzem satisfação

## 3. Zoneamento

- **Zonas residenciais**: baixa, média e alta densidade
- **Zonas comerciais**: baixa e alta densidade
- **Zonas industriais**: leve e pesada
- Crescimento automático baseado em demanda
- Sprites variáveis para diferentes tamanhos de edifícios
- **Fatores de demanda**:
  - População atual
  - Empregos disponíveis
  - Nível de impostos
  - Satisfação geral

## 4. Serviços Públicos e Infraestrutura

### Eletricidade
- Usinas: carvão, solar, eólica
- Rede elétrica com postes/linhas de transmissão
- Todas construções precisam estar conectadas

### Água
- Bombas d'água
- Rede de canos
- Estações de tratamento

### Emergência
- Delegacias (reduzem crime)
- Bombeiros (combatem incêndios)
- Hospitais (aumentam saúde)
- Cobertura por veículos em área

### Educação
- Escolas (aumentam nível educacional)
- Universidades (desbloqueiam indústria avançada)

### Lazer
- Parques e áreas verdes
- Aumentam satisfação e valor do terreno

## 5. Gestão Financeira e Orçamento

- **Impostos ajustáveis** por setor:
  - Residencial
  - Comercial
  - Industrial
- Custos de manutenção mensais
- Empréstimos bancários para emergências
- Indicadores de caixa e receita/despesa mensal
- Balanço financeiro em tempo real

## 6. População e Satisfação

- Cada edifício residencial abriga N cidadãos
- **Fatores de satisfação**:
  - Poluição (ar, sonora, água)
  - Congestionamento de trânsito
  - Acesso a serviços (saúde, educação, segurança)
  - Nível de impostos
  - Taxa de desemprego
- Satisfação baixa → migração/abandono de edifícios

## 7. Informações e Feedback

### Modos de Visualização
- Mapa de poluição
- Densidade de trânsito
- Cobertura de serviços
- Zoneamento
- Valor do terreno

### Indicadores
- Gráficos de tendências:
  - População
  - Receita
  - Demanda por zona
- Notificações de problemas:
  - Falta de energia
  - Incêndios
  - Crime alto
  - Dinheiro baixo

## 8. Câmera e Interface

- Câmera com arrasto (clique e arraste)
- Zoom com roda do mouse
- Menu lateral/inferior com abas:
  - Construção de estradas
  - Zoneamento
  - Serviços
  - Informações
- Controle de velocidade do tempo:
  - Pausa
  - Normal
  - Rápido (2x, 3x)

## 9. Salvamento e Carregamento

- Salvar estado completo da cidade
- Carregar partidas salvas
- Múltiplos slots de salvamento
- Auto-save periódico opcional

## 10. Extras (Opcionais)

### Ciclo Dia/Noite
- Apenas visual
- Iluminação diferenciada

### Desastres Naturais
- Incêndios aleatórios
- Tornados
- Requerem resposta rápida

### Modos de Jogo
- **Sandbox**: dinheiro infinito, tudo desbloqueado
- **Desafio**: orçamento limitado, objetivos específicos

## Fluxo de Jogo Exemplo

1. Jogador inicia com área vazia e reserva inicial de dinheiro
2. Constrói estrada principal
3. Conecta usina elétrica
4. Desenha zonas residenciais e industriais próximas às estradas
5. Edifícios surgem automaticamente
6. Demanda por comércio e serviços aumenta
7. Jogador equilibra orçamento e expande infraestrutura
8. Adiciona delegacias para controlar crime
9. Cidade cresce e desbloqueia novas opções
10. Gestão contínua de satisfação, finanças e expansão

## Prioridades de Implementação

1. **v0.1**: Grade + Estradas + Câmera
2. **v0.2**: Zoneamento + Demanda básica
3. **v0.3**: Eletricidade + Serviços
4. **v0.4**: Finanças + População
5. **v0.5**: UI completa + Salvamento
6. **v1.0**: Polimento + Extras