# Guia Completo: Como Testar o App no seu iPhone Físico (a partir do Windows)

Este guia explica detalhadamente como gerar o pacote de instalação nativo (**`.ipa`**) do **English Along With John** e instalá-lo diretamente no seu **iPhone físico**, utilizando seu computador com **Windows** e uma conta gratuita da Apple, sem precisar pagar a taxa de US$ 99/ano da Apple Developer.

---

## 🧭 Como Funciona o Processo

```
[Seu Windows / VS Code]
       │
       ▼ (git push)
[GitHub Actions (macOS Runner em Nuvem)]
       ├── Executa testes unitários (Swift Testing)
       ├── Compila o binário nativo arm64 para iOS
       └── Gera o pacote "EnglishAlongWithJohn.ipa" (Artefato para download)
       │
       ▼ (Download do .ipa no Windows)
[Sideloadly no Windows] (Via cabo USB)
       ├── Assina o .ipa com seu Apple ID gratuito
       └── Instala o aplicativo diretamente no seu iPhone
       │
       ▼
[Seu iPhone Físico] (App Nativo Rodando 100% Liso!)
```

---

## 📋 Pré-requisitos

1. **Seu iPhone** (iOS 17.0 ou superior) e cabo USB (Lightning ou USB-C).
2. **Computador com Windows** conectado à internet.
3. **Conta Apple ID comum** (a mesma que você usa na App Store do seu iPhone).
4. O programa gratuito **[Sideloadly para Windows](https://sideloadly.io)**.
   > **Dica sobre Drivers:** Para o Windows reconhecer seu iPhone, é necessário ter o iTunes/iCloud com drivers instalados (o instalador do Sideloadly ajuda a baixar caso você ainda não tenha).

---

## 🚀 Passo a Passo

### 1. Enviar alterações para o GitHub
O repositório já está configurado no arquivo [`.github/workflows/ios_tests.yml`](../.github/workflows/ios_tests.yml) para compilar o `.ipa` automaticamente a cada commit.

No terminal do Windows, envie as atualizações:
```powershell
git add .
git commit -m "feat: preparar build para iphone fisico"
git push origin master
```

---

### 2. Baixar o instalador `.ipa` do GitHub Actions
1. Acesse o seu repositório no GitHub: **[github.com/joaorafamenezes/EnglishAlongWithJohn](https://github.com/joaorafamenezes/EnglishAlongWithJohn)**
2. Clique na aba superior **Actions**.
3. Selecione o workflow **"iOS & Swift Unit Tests"** na coluna esquerda e clique na execução mais recente (ícone verde ✔️ quando finalizar).
4. Role até a seção **Artifacts** no final da página.
5. Clique para baixar o artefato:
   ```text
   📦 EnglishAlongWithJohn-Device-IPA
   ```
6. O download será um arquivo `.zip`. Extraia esse arquivo no seu computador para obter o:
   ```text
   EnglishAlongWithJohn.ipa
   ```

---

### 3. Instalar o Sideloadly no Windows
1. Acesse **[https://sideloadly.io](https://sideloadly.io)** e baixe a versão para Windows (64-bit).
2. Instale o Sideloadly e abra o programa.

---

### 4. Conectar o iPhone no Computador
1. Conecte seu iPhone ao computador usando o cabo USB.
2. Desbloqueie a tela do iPhone.
3. Se aparecer a mensagem **"Confiar neste computador?"**, toque em **"Confiar"** e digite a senha de desbloqueio do seu iPhone.
4. No Sideloadly, verifique se o seu iPhone aparece selecionado no campo superior **"Device"**.

---

### 5. Instalar o App no iPhone pelo Sideloadly
1. **Arraste o arquivo `EnglishAlongWithJohn.ipa`** e solte-o no ícone grande do Sideloadly (ou clique no ícone para selecioná-lo).
2. No campo **"Apple ID"**, digite o e-mail da sua conta Apple.
3. Clique no botão **"Start"**.
4. *(Apenas na primeira vez)* O Sideloadly solicitará a senha do seu Apple ID e, em seguida, o código de autenticação de dois fatores (2FA) que aparecerá na tela do seu iPhone.
5. Aguarde cerca de 1 a 2 minutos enquanto o Sideloadly assina o aplicativo e realiza o envio para o aparelho.
6. Quando aparecer **"Done"**, o ícone do aplicativo **"English with John"** já estará visível na tela inicial do seu iPhone!

---

### 6. Liberar a Execução no iPhone (Passo Obrigatório da Apple)

Por segurança, a Apple exige que você confirme a permissão para apps instalados fora da App Store:

#### A. Confiar no Perfil de Desenvolvedor:
1. No seu iPhone, abra **Ajustes** (*Settings*).
2. Vá em **Geral** > **Gerenciamento de VPN e Dispositivos** (ou *VPN & Device Management*).
3. Na seção "App de Desenvolvedor", toque no seu **Apple ID**.
4. Toque em **"Confiar em [seu e-mail]"** e confirme.

#### B. Ativar o Modo de Desenvolvedor (iOS 16, 17 e 18):
1. No seu iPhone, abra **Ajustes** (*Settings*).
2. Vá em **Privacidade e Segurança** (*Privacy & Security*).
3. Role até o final e toque em **Modo de Desenvolvedor** (*Developer Mode*).
4. Ative a chave.
5. O iPhone pedirá para reiniciar. Toque em **Reiniciar**.
6. Após reiniciar e desbloquear o iPhone, toque em **"Ativar"** no pop-up de confirmação.

---

### 7. Pronto! 📱
Abra o app **English with John** no seu iPhone!  
Você poderá navegar por todos os módulos:
- **Aulas e Exercícios Diários**
- **Gap Runner & Prática de Conectivos**
- **Match Mode & Flashcards**
- **Phrasal Verbs e Expressões Idiomáticas**
- **Guia Especial -Ever & Whereas**

---

## ❓ Perguntas Frequentes & Resolução de Problemas

| Dúvida / Erro | Motivo | Como Resolver |
| :--- | :--- | :--- |
| **Quanto tempo o app fica instalado?** | O certificado gratuito da Apple dura **7 dias**. | Após 7 dias, basta reconectar no Sideloadly e clicar em Start para renovar por mais 7 dias (o Sideloadly também pode renovar automaticamente via Wi-Fi). |
| **"Device not detected" no Sideloadly** | O Windows não possui os drivers de conexão da Apple. | Instale o iTunes ou o pacote de drivers Apple para Windows e garanta que você clicou em "Confiar" na tela do iPhone. |
| **"Developer Mode required" ao abrir o app** | O iOS 17 exige o Modo Desenvolvedor ativo para apps em sideload. | Siga a etapa 6.B deste guia (**Ajustes > Privacidade e Segurança > Modo de Desenvolvedor**). |
| **Posso testar sem cabo USB?** | Sim, via emulador online. | Consulte o guia [docs/TESTAR_NO_APPETIZE.md](TESTAR_NO_APPETIZE.md) para abrir um emulador interativo de iPhone diretamente no navegador. |
