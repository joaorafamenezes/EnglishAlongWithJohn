# Guia: Como Testar o App no Appetize.io via GitHub Actions

Este guia ensina como gerar o build do aplicativo iOS (**English Along With John**) na nuvem utilizando o **GitHub Actions** e executá-lo diretamente pelo navegador no Windows através do emulador online **[Appetize.io](https://appetize.io)**, sem a necessidade de possuir um Mac físico ou instalar máquinas virtuais.

---

## 📋 Como Funciona a Arquitetura da Solução

```
[Seu Windows / VS Code] 
        │
        ▼ (git push)
[GitHub Repository]
        │
        ▼ (Gatilho automático no macOS Runner)
[GitHub Actions (.github/workflows/ios_tests.yml)]
        ├── 1. Executa testes unitários (Swift Testing)
        ├── 2. Instala o XcodeGen e gera o .xcodeproj
        ├── 3. Compila o .app para o iOS Simulator (iOS 17+, Swift 6)
        └── 4. Compacta e publica o artefato "EnglishAlongWithJohn-Simulator.zip"
        │
        ▼ (Download do .zip)
[Appetize.io (Navegador Web)]
        │
        ▼
[Emulador Interativo de iPhone rodando na tela do Windows!]
```

---

## ⚙️ 1. Configuração do GitHub Actions

O repositório já possui a automação configurada no arquivo:
👉 [`.github/workflows/ios_tests.yml`](../.github/workflows/ios_tests.yml)

### Trecho responsável por compilar e disponibilizar o `.app`:

```yaml
# Gera o projeto Xcode a partir do project.yml
- name: Instalar XcodeGen e Gerar Projeto Xcode (.xcodeproj)
  run: |
    brew install xcodegen || true
    xcodegen generate

# Compila o app no modo Debug voltado para a arquitetura do simulador iOS
- name: Compilar App (.app) para o Simulador iOS
  run: |
    xcodebuild build \
      -project EnglishAlongWithJohn.xcodeproj \
      -scheme EnglishAlongWithJohn \
      -destination "id=${{ steps.sim.outputs.id }}" \
      -configuration Debug \
      -derivedDataPath build

# Disponibiliza a pasta .app compactada em .zip nos artefatos da execução
- name: Disponibilizar App para Download (Artifacts)
  uses: actions/upload-artifact@v4
  with:
    name: EnglishAlongWithJohn-Simulator
    path: build/Build/Products/Debug-iphonesimulator/EnglishAlongWithJohn.app
    retention-days: 7
```

---

## 🚀 2. Passo a Passo: Gerando e Baixando o Build

### Passo 2.1: Enviar alterações para o GitHub
Sempre que fizer alterações no código, envie para o repositório remoto:
```bash
git add .
git commit -m "feat: minhas atualizacoes"
git push origin master
```

### Passo 2.2: Acessar a execução no GitHub Actions
1. Acesse o seu repositório no [GitHub](https://github.com).
2. Clique na aba superior **Actions**.
3. Na barra lateral esquerda (**Workflows**), clique em **"iOS & Swift Unit Tests"**.
   > **Nota caso veja a tela "Get started with GitHub Actions":**  
   > Se aparecer uma grade com cartões como *"Deploy Node.js to Azure"*, certifique-se de que nenhum filtro de categoria esteja ativo (clique no `X` de filtros selecionados) e clique em **"All workflows"** na coluna esquerda.
4. Clique na execução mais recente (identificada pela mensagem do seu commit).

### Passo 2.3: Baixar o Artefato
1. Na página de resumo da execução (Run summary), role a tela até a seção **Artifacts** (ao final da página).
2. Localize o artefato chamado:
   ```text
   📦 EnglishAlongWithJohn-Simulator
   ```
3. Clique nele para realizar o download. O GitHub fará o download de um arquivo:
   ```text
   EnglishAlongWithJohn-Simulator.zip
   ```
   *(Não é necessário descompactar este arquivo; o Appetize.io aceita o `.zip` diretamente!)*

---

## 🌐 3. Passo a Passo: Executando no Appetize.io

O **[Appetize.io](https://appetize.io)** é um serviço em nuvem que executa simuladores iOS e transmite a tela em tempo real via navegador.

### Passo 3.1: Acessar a área de Upload
1. Acesse: **[https://appetize.io/upload](https://appetize.io/upload)**.
2. *(Opcional, mas recomendado)*: Crie uma conta gratuita para gerenciar seus apps e acompanhar minutos de uso gratuito mensais.

### Passo 3.2: Enviar o arquivo do App
1. Arraste e solte o arquivo `EnglishAlongWithJohn-Simulator.zip` na área de upload (ou clique em **"Select file"**).
2. Aguarde a barra de progresso concluir o processamento do binário.

### Passo 3.3: Configurar e Iniciar o Simulador
1. Após o upload, você será redirecionado para a página de pré-visualização.
2. Defina os parâmetros do dispositivo:
   - **Device**: `iPhone 15`, `iPhone 15 Pro` ou `iPhone 16`
   - **OS Version**: `iOS 17.x` ou superior (o app foi desenvolvido para iOS 17+)
   - **Device Color / Scale**: ajuste conforme sua preferência de tela
3. Clique no botão central **"Tap to Play"** (ou **Play ▶**).

Pronto! O aplicativo iniciará na tela virtual do iPhone e você poderá testar navegação, botões, animações e fluxos de jogo diretamente com o cursor do mouse e teclado.

---

## 🛠️ 4. Solução de Problemas Comuns

| Sintoma | Causa Provável | Solução |
| :--- | :--- | :--- |
| **"Artifacts" não aparece na execução do GitHub Actions** | A execução ainda está em andamento ou ocorreu um erro nos testes/build. | Aguarde o status ficar verde (✔️). Se falhar (❌), abra a etapa do job para verificar o log do erro de compilação ou de teste. |
| **Appetize.io dá erro: "Invalid build architecture"** | O `.zip` contém binário compilado para dispositivo físico (`iphoneos`) em vez de simulador. | O workflow oficial compila com `-configuration Debug` para o destino `Debug-iphonesimulator`, garantindo compatibilidade total com o Appetize.io. |
| **O app fecha ao abrir no Appetize.io** | Versão do iOS selecionada no Appetize inferior a 17.0. | Selecione **iOS 17.0+** nas opções do dispositivo do Appetize.io, pois o `Package.swift` e `project.yml` exigem iOS 17+. |
| **Minutos gratuitos esgotados no Appetize** | A cota gratuita mensal da sessão terminou. | O plano gratuito do Appetize.io oferece minutos mensais generosos para testes. Você pode pausar o simulador quando não estiver usando ou renovar a sessão. |

---

## 🔄 5. O que fazer quando os minutos gratuitos do Appetize.io acabarem?

O plano gratuito do Appetize.io disponibiliza cerca de 100 minutos por mês (que se renovam a cada ciclo mensal). Caso sua cota acabe ou você queira sessões de testes contínuas e ilimitadas, utilize uma das alternativas abaixo:

### 📱 5.1 Instalar diretamente no seu iPhone Físico (100% Gratuito e Ilimitado)
Esta é a **melhor alternativa**, pois você testa no aparelho real, sem limites de minutos, com fluidez nativa e resposta tátil imediata.

1. **Obter o instalador `.ipa`**:
   - É gerado pelo GitHub Actions da mesma forma que o `.app` do simulador.
2. **Instalar o [Sideloadly](https://sideloadly.io) no Windows**:
   - O Sideloadly é um aplicativo para Windows que permite instalar apps em iPhones conectados via USB utilizando qualquer conta comum da Apple (gratuita).
3. **Conectar e Instalar**:
   - Conecte o iPhone no PC com cabo USB e confirme *"Confiar neste computador"*.
   - Arraste o arquivo `.ipa` para o Sideloadly, digite o e-mail da sua Apple ID e clique em **Start**.
4. **Liberar no aparelho**:
   - No iPhone, vá em: **Ajustes > Geral > Gerenciamento de VPN e Dispositivos** e clique em **Confiar**.
   - No iOS 16+, ative o **Modo de Desenvolvedor** em: **Ajustes > Privacidade e Segurança > Modo de Desenvolvedor**.

---

### 💻 5.2 Rodar o macOS em Máquina Virtual no Windows (Simulador Oficial da Apple)
Se você não tem um iPhone físico nem um Mac, pode rodar o **macOS com Xcode** dentro do Windows usando o VMware ou VirtualBox:

- **Como funciona:** Você cria uma VM com macOS no Windows, instala o **Xcode** oficial e roda o **iOS Simulator** da Apple diretamente na tela do seu computador.
- **Vantagens:** 100% gratuito, sem limite de tempo e com acesso ao simulador oficial da Apple para qualquer modelo de iPhone ou iPad.
- **Guia passo a passo:** Consulte o documento [`docs/EMULAR_IPHONE_WINDOWS.md`](EMULAR_IPHONE_WINDOWS.md).

---

### ☁️ 5.3 Outras Plataformas de Teste em Nuvem
Existem outros provedores de nuvem que oferecem períodos de teste gratuitos para emular e testar aplicativos móveis no navegador:

- **[BrowserStack App Live](https://www.browserstack.com/app-live):** Permite testar em iPhones físicos reais transmitidos pela web.
- **[LambdaTest](https://www.lambdatest.com):** Ambiente de testes web e mobile em nuvem com plano gratuito inicial.
- **Renovação Mensal:** A cota gratuita de 100 minutos do **Appetize.io** é renovada automaticamente no primeiro dia de cada mês.

---

### 🖥️ 5.4 Mac Remoto na Nuvem (Cloud Mac)
Caso queira o ambiente Xcode completo sem instalar máquina virtual:
- Serviços como **[MacInCloud](https://www.macincloud.com)** ou instâncias Mac na **AWS** e **Scaleway** alugam acesso a um Mac por hora ou mês.
- Você se conecta diretamente pelo aplicativo de Área de Trabalho Remota ou VNC do Windows.

