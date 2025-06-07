# 📋 Unified MCP Server - Variáveis e Segredos

## 🔒 **SECRETS (Produção) - wrangler secret put**

### **GitHub OAuth (Obrigatórios)**
```bash
wrangler secret put GITHUB_CLIENT_ID        # Client ID do GitHub OAuth App (produção)
wrangler secret put GITHUB_CLIENT_SECRET    # Client Secret do GitHub OAuth App (produção)
wrangler secret put COOKIE_ENCRYPTION_KEY   # Chave para criptografia de cookies (openssl rand -hex 32)
```

### **Cloudflare Zero Trust (Obrigatórios)**
```bash
wrangler secret put CF_API_TOKEN     # Token da API Cloudflare (Zone:Read, Account:Read, Access:Edit)
wrangler secret put CF_ACCOUNT_ID    # ID da conta Cloudflare
wrangler secret put CF_ZONE_ID       # ID da zona Cloudflare (opcional, para Zero Trust)
```

### **APIs Externas (Opcionais)**
```bash
wrangler secret put OPENAI_API_KEY      # API Key da OpenAI (para GPT models)
wrangler secret put ANTHROPIC_API_KEY   # API Key da Anthropic (para Claude models)
```

---

## 🛠️ **VARIÁVEIS DE DESENVOLVIMENTO (.dev.vars)**

### **Arquivo: `.dev.vars`** (para desenvolvimento local)
```bash
# GitHub OAuth (Development)
GITHUB_CLIENT_ID="your_dev_github_client_id"
GITHUB_CLIENT_SECRET="your_dev_github_client_secret"
COOKIE_ENCRYPTION_KEY="your_32_char_hex_key"

# APIs Externas
OPENAI_API_KEY="sk-..."
ANTHROPIC_API_KEY="sk-ant-..."

# Cloudflare Zero Trust
CF_API_TOKEN="your_cloudflare_api_token"
CF_ACCOUNT_ID="your_account_id"
CF_ZONE_ID="your_zone_id"

# Sistema
NODE_ENV="development"
DEBUG="true"
```

---

## ☁️ **BINDINGS CLOUDFLARE (wrangler.jsonc)**

### **KV Namespaces**
```json
"kv_namespaces": [
  {
    "binding": "OAUTH_KV",           // Armazenamento OAuth (obrigatório)
    "id": "your_oauth_kv_id",
    "preview_id": "your_oauth_kv_preview_id"
  },
  {
    "binding": "KV_STORAGE",         // Armazenamento geral
    "id": "your_kv_storage_id", 
    "preview_id": "your_kv_storage_preview_id"
  }
]
```

### **D1 Database**
```json
"d1_databases": [
  {
    "binding": "D1_DATABASE",        // Banco de dados principal
    "database_name": "unified-mcp-db",
    "database_id": "your_d1_database_id"
  }
]
```

### **R2 Bucket**
```json
"r2_buckets": [
  {
    "binding": "R2_BUCKET",          // Armazenamento de objetos
    "bucket_name": "unified-mcp-storage"
  }
]
```

### **Vectorize Index**
```json
"vectorize": [
  {
    "binding": "VECTORIZE",          // Busca semântica
    "index_name": "unified-mcp-vectors"
  }
]
```

### **AI Binding**
```json
"ai": {
  "binding": "AI"                   // Cloudflare AI models
}
```

---

## 🎯 **INTERFACE ENV (TypeScript)**

```typescript
interface Env {
  // === CLOUDFLARE BINDINGS ===
  D1_DATABASE: D1Database           // Banco principal
  R2_BUCKET: R2Bucket              // Armazenamento objetos
  KV_STORAGE: KVNamespace          // Storage geral
  OAUTH_KV: KVNamespace            // OAuth storage (obrigatório)
  VECTORIZE: VectorizeIndex        // Busca semântica
  AI: Ai                           // Cloudflare AI
  
  // === GITHUB OAUTH ===
  GITHUB_CLIENT_ID: string         // Client ID OAuth
  GITHUB_CLIENT_SECRET: string     // Client Secret OAuth
  COOKIE_ENCRYPTION_KEY: string    // Criptografia cookies
  
  // === CLOUDFLARE ZERO TRUST ===
  CF_API_TOKEN: string             // API Token
  CF_ACCOUNT_ID: string            // Account ID
  CF_ZONE_ID: string               // Zone ID (opcional)
  
  // === APIS EXTERNAS (OPCIONAIS) ===
  OPENAI_API_KEY?: string          // OpenAI
  ANTHROPIC_API_KEY?: string       // Anthropic
}
```

---

## 🚀 **COMANDOS DE CRIAÇÃO**

### **1. KV Namespaces**
```bash
# OAuth KV (obrigatório para workers-oauth-provider)
wrangler kv:namespace create "OAUTH_KV"
wrangler kv:namespace create "OAUTH_KV" --preview

# Storage geral
wrangler kv:namespace create "KV_STORAGE"  
wrangler kv:namespace create "KV_STORAGE" --preview
```

### **2. D1 Database**
```bash
wrangler d1 create "unified-mcp-db"
```

### **3. R2 Bucket**
```bash
wrangler r2 bucket create "unified-mcp-storage"
```

### **4. Vectorize Index**
```bash
wrangler vectorize create "unified-mcp-vectors" --dimensions=768 --metric=cosine
```

---

## 🔑 **GITHUB OAUTH APPS**

### **Development App**
- **Homepage URL**: `http://localhost:8787`
- **Callback URL**: `http://localhost:8787/callback`

### **Production App**  
- **Homepage URL**: `https://your-worker.your-account.workers.dev`
- **Callback URL**: `https://your-worker.your-account.workers.dev/callback`

### **Scopes Necessários**
- `read:user` - Informações básicas do usuário
- `user:email` - Email do usuário
- `repo` - Acesso aos repositórios (se necessário)

---

## 🔒 **CLOUDFLARE API TOKEN**

### **Permissões Necessárias**
```
Zone:Read              # Ler zonas
Account:Read           # Ler conta  
Access:Edit            # Gerenciar Zero Trust
Workers:Edit           # Deploy workers
D1:Edit               # Gerenciar D1
R2:Edit               # Gerenciar R2
KV:Edit               # Gerenciar KV
Vectorize:Edit        # Gerenciar Vectorize
```

### **Criação**
1. Acesse: https://dash.cloudflare.com/profile/api-tokens
2. Clique "Create Token" 
3. Use template "Custom Token"
4. Configure as permissões acima
5. Adicione filtros de conta/zona se necessário

---

## 📱 **CONFIGURAÇÃO CLAUDE DESKTOP**

### **Arquivo de Configuração**
**Localização:**
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`  
- **Linux**: `~/.config/Claude/claude_desktop_config.json`

**Conteúdo:**
```json
{
  "mcpServers": {
    "unified-mcp": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://your-worker.your-account.workers.dev/sse"
      ]
    }
  }
}
```

---

## 🧪 **TESTING & DEBUG**

### **Variáveis de Debug**
```bash
# .dev.vars
DEBUG="true"                    # Ativar logs detalhados
NODE_ENV="development"          # Ambiente desenvolvimento
LOG_LEVEL="debug"              # Nível de log
```

### **Comandos de Teste**
```bash
npm run dev                    # Desenvolvimento local
npm run test                   # Testes automatizados
wrangler tail                  # Logs em tempo real
wrangler dev --test           # Modo de teste
```

### **URLs de Teste**
- **Local**: `http://localhost:8787/sse`
- **MCP Inspector**: `http://localhost:5173`
- **Health Check**: `http://localhost:8787/health`

---

## ⚠️ **SECURITY CHECKLIST**

### **✅ Verificações de Segurança**
- [ ] Secrets não commitados no git
- [ ] `.dev.vars` no `.gitignore`
- [ ] API Tokens com permissões mínimas
- [ ] OAuth callbacks corretos
- [ ] Cookie encryption key segura (32+ chars)
- [ ] Zero Trust policies configuradas
- [ ] CORS headers apropriados

### **🔒 Boas Práticas**
- Rotar secrets regularmente
- Usar scoped permissions
- Monitorar logs de acesso
- Backup de configurações
- Testar em ambiente staging

---

## 📚 **REFERÊNCIAS**

- **Template Oficial**: `cloudflare/ai/demos/remote-mcp-github-oauth`
- **Documentação MCP**: https://developers.cloudflare.com/agents/
- **OAuth Provider**: https://github.com/cloudflare/workers-oauth-provider
- **Wrangler CLI**: https://developers.cloudflare.com/workers/wrangler/
- **Zero Trust**: https://developers.cloudflare.com/cloudflare-one/

---

> 🎯 **Todas as variáveis listadas seguem os padrões oficiais da Cloudflare e são baseadas no template `remote-mcp-github-oauth`**