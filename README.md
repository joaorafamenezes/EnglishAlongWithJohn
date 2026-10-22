# English Along With John (Connectors Edition)

Aplicativo mobile nativo em **SwiftUI** e **Swift 6.0** para iOS 17+, focado no aprendizado e fixação de conectivos da língua inglesa de forma gamificada e didática (*Gap Runner* e *EverGuide*).

- 🌐 **Aplicação Web:** [connectors-in-english.vercel.app](https://connectors-in-english.vercel.app/)
- 💻 **Repositório Base (Web):** [github.com/joaorafamenezes/englishStudyGame](https://github.com/joaorafamenezes/englishStudyGame.git)

---

## 📱 Como Executar e Testar no Windows

Como o projeto é nativo em **iOS (Swift 6 / SwiftUI)** e requer ambiente Apple, disponibilizamos duas formas para testar no Windows:

1. 🌐 **Via Navegador com Appetize.io (Recomendado - Sem Mac e Sem Instalação):**  
   👉 **[Guia Passo a Passo: Testar no Appetize.io via GitHub Actions (docs/TESTAR_NO_APPETIZE.md)](docs/TESTAR_NO_APPETIZE.md)**

2. 💻 **Via Máquina Virtual macOS Local:**  
   👉 **[Guia de Emulação com macOS VM no Windows (docs/EMULAR_IPHONE_WINDOWS.md)](docs/EMULAR_IPHONE_WINDOWS.md)**


---

## 🛠️ Stack Tecnológica

- **Linguagem:** Swift 6.0 (Strict Concurrency)
- **Interface:** SwiftUI (iOS 17.0+)
- **Gerador de Projeto:** [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`project.yml`)
- **Gerenciador de Dependências:** Swift Package Manager (SPM)
- **Testes:** Swift Testing (`import Testing`)
- **Arquitetura:** Clean Architecture + Modular DDD (Domain, Data, Presentation, Core)

---

## 🚀 Como Rodar (em ambiente macOS ou VM)

```bash
# 1. Instalar o XcodeGen (se ainda não tiver)
brew install xcodegen

# 2. Gerar o projeto Xcode (.xcodeproj)
xcodegen generate

# 3. Rodar os testes
swift test

# 4. Abrir no Xcode e selecionar o Simulador de iPhone desejado
open EnglishAlongWithJohn.xcodeproj
```

Consulte [rules/mobile-app.md](rules/mobile-app.md) para detalhes de arquitetura e regras de desenvolvimento.
