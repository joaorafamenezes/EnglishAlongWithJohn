# English Along With John (Connectors Edition)

Aplicativo mobile nativo em **SwiftUI** e **Swift 6.0** para iOS 17+, focado no aprendizado e fixação de conectivos da língua inglesa de forma gamificada e didática (*Gap Runner* e *EverGuide*).

- 🌐 **Aplicação Web:** [connectors-in-english.vercel.app](https://connectors-in-english.vercel.app/)
- 💻 **Repositório Base (Web):** [github.com/joaorafamenezes/englishStudyGame](https://github.com/joaorafamenezes/englishStudyGame.git)

---

## 📱 Como Testar o App (Direto no seu iPhone ou no Navegador)

Como o projeto é nativo em **iOS (Swift 6 / SwiftUI)** e o desenvolvimento está sendo feito no Windows, disponibilizamos as melhores alternativas para compilar e testar:

1. 📱 **No seu iPhone Físico (Recomendado - 100% Gratuito e Ilimitado):**  
   Instale o aplicativo nativo direto no seu aparelho via USB usando sua conta gratuita da Apple.  
   👉 **[Guia Passo a Passo: Testar no iPhone Físico via Sideloadly (docs/TESTAR_NO_IPHONE_FISICO.md)](docs/TESTAR_NO_IPHONE_FISICO.md)**

2. 🌐 **Via Navegador com Appetize.io (Sem cabos e sem instalação):**  
   Execute o simulador interativo de iPhone direto no seu navegador.  
   👉 **[Guia Passo a Passo: Testar no Appetize.io via GitHub Actions (docs/TESTAR_NO_APPETIZE.md)](docs/TESTAR_NO_APPETIZE.md)**


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
