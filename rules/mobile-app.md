# Regras de Desenvolvimento Mobile — English along with John (Connectors Edition)

> **Documento de Governança, Arquitetura e Boas Práticas**  
> **Plataforma:** iOS (iPhone) • **Linguagem:** Swift 6.0 • **Framework:** SwiftUI • **Target Mínimo:** iOS 17.0+  
> **Aplicação Base (Web):** [Connectors in English (Gap Runner)](https://connectors-in-english.vercel.app/)  
> **Repositório Base (GitHub):** [joaorafamenezes/englishStudyGame](https://github.com/joaorafamenezes/englishStudyGame.git)

---

## 1. Visão Geral e Propósito do Projeto

Este projeto consiste na versão mobile nativa (iOS) do aplicativo web **Connectors in English (Gap Runner)**, baseado no repositório [joaorafamenezes/englishStudyGame](https://github.com/joaorafamenezes/englishStudyGame.git) e hospedado em [connectors-in-english.vercel.app](https://connectors-in-english.vercel.app/).  
O objetivo é capacitar estudantes de inglês a dominar o uso de conectivos gramaticais de forma didática, fluida e gamificada, combinando um catálogo detalhado de conectivos (*EverGuide*), sessões de prática com preenchimento de lacunas (*Gap Runner*) em dois modos (**Arcade** e **Zen**), feedback pedagógico aprofundado e reprodução de pronúncia/áudio.

Toda funcionalidade criada no app mobile deve preservar ou aprimorar a experiência existente na versão web, adotando padrões de ponta da plataforma Apple (Human Interface Guidelines, fluid animations, dynamic type e feedback tátil).

---

## 2. Stack Tecnológica e Requisitos de Plataforma

| Componente | Tecnologia / Padrão | Justificativa |
| :--- | :--- | :--- |
| **Linguagem** | **Swift 6.0** (Strict Concurrency Checking) | Segurança estática em tempo de compilação, prevenção de *data races* via `Sendable` e `actor`. |
| **Interface (UI)** | **SwiftUI** (iOS 17+) | Declaração de UI moderna, suporte a animações nativas de alta performance e preview dinâmico. |
| **Gerenciamento de Estado** | **Observation Framework (`@Observable`)** | Padrão moderno da Apple (eliminando overhead de `ObservableObject` / `@Published`). |
| **Build & Projetos** | **XcodeGen (`project.yml`) + Swift Package Manager (SPM)** | Controle de versão limpo do projeto, sem conflitos em `.xcodeproj`, compilação modular. |
| **Framework de Testes** | **Swift Testing (`import Testing`)** | Framework oficial da Apple com `@Suite`, `@Test`, `#expect`, argumentos parametrizados. |
| **Persistência Local** | **SwiftData / UserDefaults / Keychain** | Abordagem *offline-first* para salvar progresso, preferências de estudo e conectivos dominados. |
| **Feedback e Sensações** | **CoreHaptics / `.sensoryFeedback`** | Resposta tátil rica em acertos, erros, combos e esgotamento de vidas. |

---

## 3. Arquitetura de Software: Clean Architecture + Modular DDD

O projeto adota estritamente os princípios de **Clean Architecture**, **SOLID** e separação de responsabilidades em camadas desacopladas. O fluxo de dependência aponta invariavelmente para dentro (as camadas externas dependem da camada de Domínio, nunca o contrário).

```
                      ┌─────────────────────────────────┐
                      │    Presentation Layer (SwiftUI) │
                      │  Views, ViewModels, Navigation  │
                      └────────────────┬────────────────┘
                                       │ (usa)
                                       ▼
┌──────────────────────┐      ┌─────────────────────────┐      ┌──────────────────────┐
│     Core Layer       │◄─────┤      Domain Layer       ├─────►│      Data Layer      │
│ Utilities, Tokens,   │      │ Entities, UseCases,     │      │ Repositories, DTOs,  │
│ Design System, Audio │      │ Repositories Contracts  │      │ DataSources (Local)  │
└──────────────────────┘      └─────────────────────────┘      └──────────────────────┘
```

### 3.1. Camada de Domínio (`Sources/Domain`)
- **Regra de Ouro:** Não importa `SwiftUI`, `UIKit` ou bibliotecas de persistência. Contém lógica de negócio pura, agnóstica de plataforma.
- **Entidades e Value Objects:** Devem ser imutáveis (`let`), conformes com `Sendable`, `Identifiable` e `Equatable`.
  - Exemplos: `Connector`, `ConnectorExercise`, `ConnectorSession`, `GameMode`, `ConnectorFamily`.
- **Contratos de Repositórios:** Protocolos que definem operações de consulta e persistência (ex: `ConnectorRepositoryProtocol`).
- **Casos de Uso (`UseCases`):** Cada caso de uso representa uma única ação do usuário ou operação de negócio com método `execute(...)`.
  - Exemplos: `ValidateConnectorAnswerUseCase`, `FetchConnectorsSessionUseCase`, `ToggleConnectorMasteredUseCase`.

### 3.2. Camada de Dados (`Sources/Data`)
- Responsável por obter, armazenar e mapear dados provenientes do catálogo local (JSON) ou de persistência em disco.
- Implementa os contratos de repositório definidos no Domínio.
- Realiza a conversão explícita entre DTOs (`Data Transfer Objects`) e Entidades de Domínio via Mappers puros e testáveis.

### 3.3. Camada de Apresentação (`Sources/Presentation`)
- **Arquitetura MVVM + UDF (Unidirectional Data Flow):**
  - **Views:** SwiftUI Views puras, responsivas, focadas unicamente em renderizar estado e capturar eventos do usuário. Devem ser subdivididas em subcomponentes reutilizáveis (`Sources/Presentation/Common`).
  - **ViewModels:** Classes anotadas com `@Observable` e `@MainActor`. Não possuem referências a tipos de UI (`Color`, `View`, etc.) e utilizam Casos de Uso injetados via construtor.
  - **Coordinators / Navigation:** Navegação desacoplada usando `NavigationStack` com `NavigationPath` tipado.

### 3.4. Camada Central (`Sources/Core`)
- Componentes transversais: Tokens do Design System (Cores, Tipografia IBM Plex Sans / Bricolage Grotesque se configurada, Espaçamentos), Extensões utilitárias, Gerenciador de Áudio/TTS (`AVFoundation`), Haptics e Logging estruturado (`OSLog`).

---

## 4. Política Estrita de Testes Unitários (> 90% de Cobertura)

A qualidade de software e a confiabilidade pedagógica do app são inegociáveis. Toda nova funcionalidade, regra de negócio ou função utilitária deve nascer acompanhada de testes unitários.

### 4.1. Meta de Cobertura
- **Cobertura Mínima Geral:** **90%** (com meta de 95%+ para as camadas de `Domain` e `Presentation/ViewModels`).
- Nenhuma Pull Request ou merge deve ser aprovado com cobertura inferior a 90% no código novo.

### 4.2. Escopo Obrigatório de Testes Unitários
1. **100% dos Casos de Uso (`UseCases`):**
   - Lógica de pontuação do Modo Arcade (pontos base, multiplicador por streak, bônus de tempo restante).
   - Perda de vidas, detecção de Game Over e vitória.
   - Comportamento resiliente do Modo Zen (sem penalidade de vidas).
   - Validação de timeouts (resposta esgotada após 18s).
   - Filtros por família (`ConnectorFamilyFilter`) e ocultação de conectivos dominados (`hideMastered`).
2. **100% dos ViewModels:**
   - Estado inicial correto.
   - Transições de estado (`idle`, `loading`, `answering`, `feedback`, `finished`).
   - Disparo e tratamento de seleções de opções do exercício.
   - Ação de pular, avançar ou reiniciar a sessão.
   - Tratamento e publicação de mensagens de erro amigáveis.
3. **Mappers e Parsers:**
   - Validação de conversão íntegra de JSON / DTO para Entidade de Domínio.
   - Tratamento de campos ausentes ou dados malformados.
4. **Funções Utilitárias e Formatadores:**
   - Formatação de tempo (cronômetro de 18s para string), pontuações, helpers de texto.

### 4.3. Padrão de Implementação dos Testes
- **Framework Padrão:** Utilizar **Swift Testing** (`import Testing`) com `@Suite` e `@Test`.
- **Estrutura AAA:** Todo teste deve ser organizado nos blocos:
  1. `// Arrange`: Preparação do cenário, dados falsos (`mocks` / `stubs`) e `sut` (System Under Test).
  2. `// Act`: Execução da função ou método a ser avaliado.
  3. `// Assert`: Verificação de expectativas utilizando `#expect(...)` ou `#require(...)`.
- **Nomenclatura Descritiva:**
  ```swift
  @Test("Modo Arcade: Resposta correta com streak 3 aplica multiplicador triplo e bônus de tempo")
  func testArcadeCorrectAnswerAppliesMultiplierAndTimeBonus() { ... }
  ```
- **Testes Parametrizados:** Para validar múltiplos cenários de conectivos, famílias ou pontuações, utilize `arguments`:
  ```swift
  @Test("Validação de pontuação base por nível", arguments: [(1, 100), (2, 200), (3, 300)])
  func testBaseScoreCalculation(streak: Int, expectedPoints: Int) { ... }
  ```
- **Determinismo e Mocks:**
  - Proibido acoplamento com rede real, timers assíncronos não controlados ou persistência real em testes unitários.
  - Injetar dependências via protocolos para facilitar a criação de `MockRepositories` ou `FakeTimers`.

---

## 5. Mapeamento das Funcionalidades e Jogos (Web ➔ Mobile)

As regras e mecânicas presentes no repositório [joaorafamenezes/englishStudyGame](https://github.com/joaorafamenezes/englishStudyGame.git) e na aplicação web [connectors-in-english.vercel.app](https://connectors-in-english.vercel.app/) são organizadas no app mobile em **menus independentes e modulares** no padrão Hub:

```
[Tela Inicial / Menu do Sistema]
  ├── 🟣 1. Prática de Conectivos (Connectors Lab)
  │      ├── Gap Runner (Prática com lacunas nos modos Arcade e Zen)
  │      ├── Deck dos 81 Conectivos (Flashcards com filtros por família e Mastery)
  │      └── Match Rápido de Conectivos (Associação rápida em pares)
  │
  ├── 🟠 2. Phrasal Verbs Game
  │      ├── Quiz das Frases (Zen e Arcade com níveis A1, A2, B1, B2, C1)
  │      ├── Match Rápido de Phrasal Verbs (Associação 6x6)
  │      └── Deck de Phrasal Verbs (Flashcards com áudio e dominados)
  │
  ├── 🎯 3. Família -Ever & Whereas
  │      ├── Guia Didático Interativo (Whatever, Whenever, Wherever, Whoever, However, Whereas)
  │      └── Quiz Dedicado de Fixação Sintática
  │
  └── 💡 4. Expressões Idiomáticas (Idiomatic Expressions)
         ├── Desafio das Expressões (Quizzing de significados)
         └── Guia de Expressões com Contexto Cultural e Conversação Real
```

---

### 5.1. Prática de Conectivos (Connectors Lab)
O laboratório central de conectivos reúne três ferramentas de estudo integradas:

#### 5.1.1. Gap Runner (Prática Interativa com Lacunas)
- **Fluxo:** Frase com lacuna visual (`_____`), 4 opções de conectivos e barra de progresso.
- **Modos:**
  - **Modo Arcade:** 18 segundos por questão, 3 vidas (corações), multiplicador de streak (x1, x2, x3...), perda de vida por erro ou timeout, telas de Game Over e Vitória com ranking local Top 5.
  - **Modo Zen:** Estudo sem pressão de tempo e sem contagem de vidas; sons suaves e foco em retenção.
- **Feedback Pedagógico Completo (Drawer/Modal):**
  - **Por que está correto:** Justificativa da regra sintática ou semântica.
  - **Por que as outras falham:** Explicação clara do motivo de cada distrator estar incorreto.
  - **Dica do John (Pro Tip):** Dica prática de uso real.
  - **Tradução:** Tradução completa da sentença em português.

#### 5.1.2. Deck dos 81 Conectivos (Flashcards Interativos)
- Integrado diretamente dentro da experiência de conectivos.
- **Catálogo dos 81 Conectivos:** Agrupados em 10 categorias gramaticais:
  1. *Contraste / Concessão* (Although, However, Despite, In spite of, Whereas...)
  2. *Causa / Efeito* (Because, As a result, Hence, Therefore...)
  3. *Condição* (If, Unless, As long as, Otherwise...)
  4. *Adição* (Along with, As well as, Besides, Furthermore...)
  5. *Tempo* (Meanwhile, Afterwards, In advance...)
  6. *Finalidade* (In order to, So that, Towards...)
  7. *Exemplo* (For instance, Such as...)
  8. *Ênfase* (Actually, Indeed, At least, No longer...)
  9. *Substituição* (Instead of, Rather than...)
  10. *Resumo / Conclusão* (In short, To sum up, All in all...)
- **Mecânica de Estudo:**
  - Card interativo com virada (flip) revelando regra, exemplo em inglês e tradução.
  - Botão de áudio para pronúncia imediata.
  - Sistema de **Dominado (Mastery)** persistido localmente: permite filtrar entre "Todos", "Em Aprendizado" e "Dominados".
  - Barra de busca instantânea e filtros por categoria.

#### 5.1.3. Match Rápido de Conectivos (Jogo de Associação)
- Integrado dentro da experiência de conectivos.
- **Mecânica:** Grade contendo 6 conectivos em inglês e 6 traduções correspondentes em português embaralhados.
- **Regras:**
  - O aluno seleciona 1 card de idioma e seu par correspondente.
  - Combinação correta: cards desaparecem com animação, haptic de sucesso e incremento de streak e score (+100 pts + streak bonus).
  - Combinação incorreta: cards piscam em vermelho com haptic de erro e o streak reinicia.
  - Ao limpar a rodada, avança para nova rodada com fanfarra de vitória.

---

### 5.2. Phrasal Verbs Game
Módulo dedicado ao aprendizado dos verbos frasais mais usados da língua inglesa:

#### 5.2.1. Quiz das Frases (Desafio de Phrasal Verbs)
- Filtro prévio por nível de dificuldade CEFR: **Todos**, **A1**, **A2**, **B1**, **B2**, **C1**.
- Suporte aos modos **Zen** e **Arcade** (3 vidas, 18s por questão, streaks).
- Sentenças contextuais reais com opções de Phrasal Verbs e explicação pedagógica do significado idiomático após cada resposta.

#### 5.2.2. Match Rápido de Phrasal Verbs
- Pareamento ágil entre o Phrasal Verb em inglês (ex: *give up*, *look forward to*, *run out of*) e seu significado equivalente em português (ex: *desistir*, *aguardar ansiosamente*, *ficar sem*).
- Eliminação dinâmica de peças com feedback visual e sonoro.

#### 5.2.3. Deck Didático de Phrasal Verbs
- Navegação em cartões com pronúncia em áudio, partículas destacadas, definição em português, frases reais de exemplo e controle de itens dominados.

---

### 5.3. Família -Ever & Whereas
Módulo focado exclusivamente nos conectivos de maior índice de dúvida sintática:

- **Conectivos Contemplados:** *Whatever*, *Whenever*, *Wherever*, *Whoever*, *However* e *Whereas*.
- **Guia Didático:**
  - Matriz de regras e equivalências práticas (*Whatever = no matter what / anything that*).
  - Comparativo especial: uso concessivo vs restritivo.
  - Destaque sintático para o uso de vírgulas e posições na oração.
- **Quiz de Fixação Sintática:** Perguntas focadas exclusivamente em lacunas envolvendo a família `-ever` e o contraste formal com `whereas`.

---

### 5.4. Expressões Idiomáticas (Idiomatic Expressions)
Módulo didático para expressões idiomáticas coloquiais e profissionais:

- **Catálogo de Expressões:** Expressões essenciais (ex: *Piece of cake*, *Bite the bullet*, *Under the weather*, *Break a leg*, *Hit the nail on the head*...).
- **Desafio de Significados:** Sessão de quizzing dinâmico onde o aluno associa a expressão em inglês ao seu contexto e significado correto em português entre 4 opções.
- **Dicas Culturais do John:** Explicação da origem histórica ou etiqueta de uso da expressão no dia a dia.

---

### 5.5. Arquitetura de Apresentação em Menus do Sistema
- Cada um dos módulos principais (**Connectors Lab**, **Phrasal Verbs**, **Família -Ever & Whereas**, **Expressões Idiomáticas**) deve possuir um card de acesso na tela inicial/hub com:
  - Ícone temático representativo com cores exclusivas do Design System.
  - Título e subtítulo explicativos claros.
  - Botão de ação direta com gradiente visual distintivo.
- O **Deck dos 81 Conectivos** e o **Match Rápido** devem ser integrados e destacados como modos de estudo dentro do **Connectors Lab**.
- Toda navegação deve ser controlada via `AppCoordinator` e rotas tipadas em `AppRoute`.

---

## 6. Padrões de Código, Estilo e Convenções Swift

### 6.1. Swift Concurrency Moderno
- Usar `async/await`, `TaskGroup` e `@MainActor` para operações assíncronas e atualizações de UI.
- Evitar `DispatchQueue.main.async` legado.
- Todos os modelos compartilhados entre threads devem conformar com `Sendable`.

### 6.2. Tratamento Seguro de Nulos e Erros
- **Proibido o uso de Force Unwrap (`!`)** tanto em código de produção quanto em testes (salvo em `XCTest` com justificativa explícita; prefira `#require`).
- Usar `guard let`, `if let` e `nil-coalescing (`??`)`.
- Erros de domínio devem ser enums fortemente tipados em conformidade com `LocalizedError`:
  ```swift
  public enum ConnectorError: LocalizedError, Equatable {
      case exerciseNotFound
      case sessionAlreadyCompleted
      case invalidOptionSelected
  }
  ```

### 6.3. Convenções de Nomenclatura
- **Entidades e Structs:** PascalCase no singular (`Connector`, `ExerciseOption`).
- **Casos de Uso:** Verbo no infinitivo ou indicativo representando a ação + `UseCase` (`ValidateConnectorAnswerUseCase`).
- **ViewModels:** Sufixo `ViewModel` (`ConnectorPracticeViewModel`, `EverGuideViewModel`).
- **Views:** Sufixo `View` (`ConnectorCardView`, `FeedbackDrawerView`).
- **Arquivos:** O nome do arquivo deve corresponder exatamente ao nome do tipo principal contido nele.

---

## 7. Estrutura de Diretórios Recomendada

```
EnglishAlongWithJohn/
├── Package.swift                    # Configuração SPM
├── project.yml                      # Especificação XcodeGen
├── Sources/
│   ├── App/                         # Ponto de entrada e Composition Root (AppContainer)
│   ├── Domain/                      # Regras de Negócio e Contratos Puros
│   │   ├── Connectors/
│   │   │   ├── Entities/            # Connector, ConnectorExercise, ConnectorSession
│   │   │   ├── ValueObjects/        # GameMode, ConnectorFamily, SessionConfig
│   │   │   ├── UseCases/            # ValidateAnswer, FetchSession, ToggleMastered
│   │   │   ├── Repositories/        # Protocolos de repositório
│   │   │   └── Errors/              # ConnectorError
│   │   └── Common/                  # Entidades compartilhadas
│   ├── Data/                        # Implementações de dados e persistência
│   │   ├── Repositories/            # ConnectorRepositoryImpl
│   │   ├── DataSources/             # LocalJSONDataSource, SwiftDataStorage
│   │   └── Mappers/                 # ConnectorDTOtoDomainMapper
│   ├── Presentation/                # UI e Camada Visual
│   │   ├── Common/                  # Design System (Buttons, Badges, Cards, Modals)
│   │   ├── Navigation/              # AppCoordinator, NavigationRoutes
│   │   └── Features/
│   │       └── Connectors/
│   │           ├── Hub/             # Tela inicial de escolha de modo e estatísticas
│   │           ├── Practice/        # Tela do jogo Gap Runner (Arcade/Zen)
│   │           └── EverGuide/       # Catálogo e detalhes de conectivos
│   └── Core/                        # Utilitários, Audio, Haptics, Extensions
│       ├── Audio/                   # SpeechManager / AudioPlayer
│       ├── Haptics/                 # HapticFeedbackManager
│       └── Extensions/              # Color, View, String helpers
├── Tests/
│   └── UnitTests/                   # Testes Unitários com Swift Testing
│       ├── Connectors/              # Testes de Casos de Uso de Conectivos
│       ├── ViewModels/              # Testes de ViewModels
│       └── Mappers/                 # Testes de mapeamento e serialização
└── rules/
    └── mobile-app.md                # Este documento de regras
```

---

## 8. Definition of Done (Critérios de Conclusão para Features)

Para que qualquer tarefa ou funcionalidade seja considerada concluída, ela deve satisfazer os seguintes critérios:

1. [ ] **Compilação Limpa:** Compila sem erros ou *warnings* em Swift 6.0 com verificação estrita de concorrência ativada.
2. [ ] **Cobertura de Testes:** Cobertura de testes unitários superior a 90% para o código novo/modificado.
3. [ ] **Testes Verificados:** Todos os testes unitários passando com sucesso via `swift test` ou no Xcode Test Runner.
4. [ ] **Design e Acessibilidade:** Conformidade visual com o design do app web, suporte fluido a Dark Mode e Dynamic Type.
5. [ ] **Feedback Tátil e Áudio:** Integração de haptic feedback e suporte à pronúncia nas interações chave.
6. [ ] **Tratamento de Falhas:** Ausência total de force unwraps e mensagens de erro amigáveis para estados vazios ou inesperados.
