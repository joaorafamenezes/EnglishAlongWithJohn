# Regras de Desenvolvimento Mobile — English along with John (Connectors Edition)

> **Documento de Governança, Arquitetura e Boas Práticas**  
> **Plataforma:** iOS (iPhone) • **Linguagem:** Swift 6.0 • **Framework:** SwiftUI • **Target Mínimo:** iOS 17.0+  
> **Aplicação Base:** [Connectors in English (Gap Runner)](https://connectors-in-english.vercel.app/)

---

## 1. Visão Geral e Propósito do Projeto

Este projeto consiste na versão mobile nativa (iOS) do aplicativo web **Connectors in English (Gap Runner)**.  
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

## 5. Mapeamento das Funcionalidades (Web ➔ Mobile)

As seguintes funcionalidades presentes no site `connectors-in-english.vercel.app` devem ser fielmente reproduzidas e refinadas para iOS:

### 5.1. Prática Interativa: "Gap Runner"
- **Fluxo do Exercício:**
  - Sentença em destaque com lacuna visual clara (`_____`).
  - Lista de 4 opções em formato de botões de toque com resposta háptica.
  - Barra de progresso da sessão (ex: Questão 3 de 10).
- **Modos de Jogo:**
  - **Modo Arcade:**
    - Temporizador decrescente de 18 segundos por questão com indicador visual circular ou barra animada.
    - 3 vidas (representadas por corações); cada resposta errada ou timeout consome 1 vida com haptic de erro.
    - Multiplicador de Streak dinâmico (x1, x2, x3...).
    - Tela de Game Over com estatísticas ou Tela de Vitória com pontuação total e revisão.
  - **Modo Zen:**
    - Estudo sem pressão de tempo e sem contagem de vidas.
    - Foco na retenção gramatical e aprendizado calmo.
- **Gaveta / Modal de Explicação Pedagógica (Feedback Drawer):**
  - Exibido após cada resposta:
    - **Por que está correto:** Justificativa da regra sintática ou semântica.
    - **Por que as outras falham:** Explicação clara do motivo de cada distrator estar incorreto.
    - **Dica do John (Pro Tip):** Dica prática de uso real.
    - **Tradução da frase completa:** Tradução para pt-BR.

### 5.2. Catálogo Didático: "EverGuide"
- Listagem categorizada por famílias de conectivos:
  - *Contrast & Concession* (Although, However, Despite, In spite of, Whereas...)
  - *Addition* (Furthermore, Moreover, In addition, Besides...)
  - *Cause, Reason & Purpose* (Because of, Due to, In order to, So that...)
  - *Condition & Consequence* (Therefore, As a result, Unless, Otherwise...)
- Detalhes de cada conectivo: tradução, regras gramaticais, notas de pontuação (ex: uso de vírgulas) e exemplos contextualizados.
- Ação de favoritar / marcar como **"Mastered"** (Dominado).
- Barra de busca instantânea e filtros por família gramatical.

### 5.3. Pronúncia e Áudio
- Botão de áudio em cada conectivo e frase exemplo utilizando síntese de voz nativa (`AVSpeechSynthesizer`) ou arquivos de áudio remotos/locais com controle de reprodução.

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
