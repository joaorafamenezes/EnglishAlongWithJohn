/**
 * Mobile Validation & Screenshot Automation Suite for iPhone 15 Pro
 * 
 * Target device: Apple iPhone 15 Pro
 * - Viewport: 393 x 852 px
 * - DPR (Device Pixel Ratio): 3
 * - Mobile / Touch Emulation: Active
 * - User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1
 */

import { spawn } from 'node:child_process';
import { existsSync, mkdirSync, writeFileSync, statSync } from 'node:fs';
import { resolve, join } from 'node:path';
import { tmpdir } from 'node:os';

const TARGET_URLS = [
  'http://localhost:5173',
  'http://localhost:3000',
  'https://connectors-in-english.vercel.app'
];

const OUTPUT_DIR = resolve(process.cwd(), 'screenshots', 'mobile-iphone15pro');
const ARTIFACT_DIR = 'C:/Users/joaor/.gemini/antigravity-ide/brain/1ba1f5b3-339a-456c-b086-10f7aa1f5715';
const PORT = 9238;

const IPHONE_15_PRO = {
  width: 393,
  height: 852,
  deviceScaleFactor: 3,
  mobile: true,
  hasTouch: true,
  userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1'
};

function findChromePath() {
  const candidates = [
    'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
    join(process.env.LOCALAPPDATA || '', 'Google\\Chrome\\Application\\chrome.exe')
  ];
  for (const c of candidates) {
    if (existsSync(c)) return c;
  }
  return 'chrome';
}

function sleep(ms) {
  return new Promise(res => setTimeout(res, ms));
}

class CDPClient {
  constructor(wsUrl) {
    this.wsUrl = wsUrl;
    this.id = 1;
    this.callbacks = new Map();
  }

  async connect() {
    return new Promise((res, rej) => {
      this.ws = new WebSocket(this.wsUrl);
      this.ws.onopen = () => res();
      this.ws.onerror = (e) => rej(e);
      this.ws.onmessage = (msg) => {
        const data = JSON.parse(msg.data);
        if (data.id && this.callbacks.has(data.id)) {
          const cb = this.callbacks.get(data.id);
          this.callbacks.delete(data.id);
          if (data.error) cb.reject(data.error);
          else cb.resolve(data.result);
        }
      };
    });
  }

  send(method, params = {}) {
    const id = this.id++;
    return new Promise((resolve, reject) => {
      this.callbacks.set(id, { resolve, reject });
      this.ws.send(JSON.stringify({ id, method, params }));
    });
  }

  close() {
    try { this.ws.close(); } catch (_) {}
  }
}

async function findActiveUrl() {
  for (const u of TARGET_URLS) {
    try {
      const res = await fetch(u, { signal: AbortSignal.timeout(1500) });
      if (res.ok || res.status < 500) {
        return u;
      }
    } catch (_) {}
  }
  return TARGET_URLS[0];
}

async function captureScreen(client, name, fullPage = false) {
  const params = {
    format: 'png',
    captureBeyondViewport: fullPage
  };
  const snap = await client.send('Page.captureScreenshot', params);
  const buffer = Buffer.from(snap.data, 'base64');
  
  const localFile = join(OUTPUT_DIR, name);
  writeFileSync(localFile, buffer);

  if (existsSync(ARTIFACT_DIR)) {
    const artFile = join(ARTIFACT_DIR, name);
    writeFileSync(artFile, buffer);
  }

  const stat = statSync(localFile);
  console.log(`  📸 [Capturado] ${name.padEnd(42)} (${(stat.size / 1024).toFixed(1)} KB)`);
  return localFile;
}

async function evaluateCode(client, expression) {
  const res = await client.send('Runtime.evaluate', {
    expression,
    returnByValue: true
  });
  return res.result?.value;
}

async function main() {
  console.log('='.repeat(70));
  console.log('📱 SUÍTE DE EMULAÇÃO & QA MOBILE: iPHONE 15 PRO');
  console.log('='.repeat(70));

  mkdirSync(OUTPUT_DIR, { recursive: true });

  const activeUrl = await findActiveUrl();
  console.log(`🌐 Servidor ativo detectado: ${activeUrl}`);
  console.log(`📁 Diretório de saída: ${OUTPUT_DIR}\n`);

  const chromePath = findChromePath();
  const profileDir = join(tmpdir(), `chrome_qa_profile_${Date.now()}`);
  mkdirSync(profileDir, { recursive: true });

  console.log(`🚀 Inicializando Chromium headless (${chromePath})...`);
  const chrome = spawn(chromePath, [
    '--headless=new',
    `--remote-debugging-port=${PORT}`,
    `--user-data-dir=${profileDir}`,
    '--no-first-run',
    '--no-default-browser-check',
    '--disable-gpu',
    '--hide-scrollbars',
    'about:blank'
  ], { stdio: 'ignore' });

  // Wait for CDP
  let wsUrl = null;
  for (let i = 0; i < 30; i++) {
    try {
      const res = await fetch(`http://127.0.0.1:${PORT}/json/version`);
      if (res.ok) {
        const json = await res.json();
        wsUrl = json.webSocketDebuggerUrl;
        break;
      }
    } catch (_) {}
    await sleep(250);
  }

  if (!wsUrl) {
    chrome.kill();
    throw new Error('Falha ao conectar no Chrome via DevTools Protocol.');
  }

  // Open target URL
  const targetRes = await fetch(`http://127.0.0.1:${PORT}/json/new?${encodeURIComponent(activeUrl)}`, { method: 'PUT' });
  const target = await targetRes.json();
  const client = new CDPClient(target.webSocketDebuggerUrl);
  await client.connect();

  console.log('📱 Configurando parâmetros do iPhone 15 Pro:');
  console.log(`   - Viewport: ${IPHONE_15_PRO.width}x${IPHONE_15_PRO.height} px`);
  console.log(`   - Device Scale Factor (DPR): ${IPHONE_15_PRO.deviceScaleFactor}`);
  console.log(`   - Touch / Mobile: Ativados`);
  console.log(`   - User-Agent: ${IPHONE_15_PRO.userAgent}\n`);

  await client.send('Page.enable');
  await client.send('DOM.enable');
  await client.send('Network.enable');

  await client.send('Network.setUserAgentOverride', {
    userAgent: IPHONE_15_PRO.userAgent,
    platform: 'iPhone'
  });

  await client.send('Emulation.setDeviceMetricsOverride', {
    width: IPHONE_15_PRO.width,
    height: IPHONE_15_PRO.height,
    deviceScaleFactor: IPHONE_15_PRO.deviceScaleFactor,
    mobile: true,
    screenWidth: IPHONE_15_PRO.width,
    screenHeight: IPHONE_15_PRO.height
  });

  await client.send('Emulation.setTouchEmulationEnabled', {
    enabled: true,
    maxTouchPoints: 5
  });

  console.log('⏳ Aguardando renderização de fontes, estilos e componentes...');
  await sleep(4000);

  console.log('\n--- 1. Rota Principal & Home ---');
  await captureScreen(client, '01_iphone15pro_home_viewport.png', false);
  await captureScreen(client, '02_iphone15pro_home_fullpage.png', true);

  console.log('\n--- 2. Prática Guiada de Conectivos ---');
  await evaluateCode(client, `
    (() => {
      const btn = Array.from(document.querySelectorAll('button, a')).find(b => b.innerText && b.innerText.includes('Começar a Praticar'));
      if (btn) btn.click();
    })()
  `);
  await sleep(1500);
  await captureScreen(client, '03_iphone15pro_pratica_guiada.png', false);

  // Selecionar resposta no quiz
  await evaluateCode(client, `
    (() => {
      const options = Array.from(document.querySelectorAll('button')).filter(b => b.className && (b.className.includes('option') || b.className.includes('choice') || b.className.includes('btn')));
      const opt = options.find(o => !o.innerText.includes('Voltar') && !o.innerText.includes('Ranking') && !o.innerText.includes('Som'));
      if (opt) opt.click();
    })()
  `);
  await sleep(1000);
  await captureScreen(client, '04_iphone15pro_pratica_respondida.png', false);

  console.log('\n--- 3. Phrasal Verbs Academy ---');
  await evaluateCode(client, `
    (() => {
      const tab = Array.from(document.querySelectorAll('button, a')).find(b => b.innerText && b.innerText.includes('Phrasal Verbs'));
      if (tab) tab.click();
    })()
  `);
  await sleep(1500);
  await captureScreen(client, '05_iphone15pro_phrasal_verbs.png', false);

  console.log('\n--- 4. Deck de Estudo dos 81 Conectivos ---');
  await evaluateCode(client, `
    (() => {
      const tab = Array.from(document.querySelectorAll('button, a')).find(b => b.innerText && b.innerText.includes('Deck dos 81'));
      if (tab) tab.click();
    })()
  `);
  await sleep(1500);
  await captureScreen(client, '06_iphone15pro_deck_conectivos.png', false);

  console.log('\n--- 5. Idiomatic Expressions (Quiz) ---');
  await evaluateCode(client, `
    (() => {
      const tab = Array.from(document.querySelectorAll('button, a')).find(b => b.innerText && b.innerText.includes('Idiomatic Expressions'));
      if (tab) tab.click();
    })()
  `);
  await sleep(1500);
  await captureScreen(client, '07_iphone15pro_idiomatic_expressions.png', false);

  console.log('\n--- 6. Modal de Ranking (Hall da Fama) ---');
  await evaluateCode(client, `
    (() => {
      const rankBtn = Array.from(document.querySelectorAll('button')).find(b => b.innerText && b.innerText.includes('Ranking'));
      if (rankBtn) rankBtn.click();
    })()
  `);
  await sleep(1200);
  await captureScreen(client, '08_iphone15pro_ranking_modal.png', false);

  // Finalizar
  client.close();
  chrome.kill();

  console.log('\n' + '='.repeat(70));
  console.log('✅ SUÍTE DE TESTES E CAPTURA CONCLUÍDA COM SUCESSO!');
  console.log(`📁 Todos os screenshots foram salvos em: ${OUTPUT_DIR}`);
  console.log('='.repeat(70));
}

main().catch(err => {
  console.error('\n❌ Erro durante a execução da suíte mobile:', err);
  process.exit(1);
});
