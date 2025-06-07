#!/bin/bash

# 🚀 UNIFIED MCP SERVER - SCRIPT DE CONFIGURAÇÃO COMPLETO
# Baseado no template oficial: cloudflare/ai/demos/remote-mcp-github-oauth
# Versão: 1.0.0

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emoji para melhor visualização
ROCKET="🚀"
CHECK="✅"
WARNING="⚠️"
INFO="ℹ️"
GEAR="⚙️"
LOCK="🔒"
KEY="🔑"
DATABASE="🗄️"
CLOUD="☁️"

echo -e "${PURPLE}${ROCKET} UNIFIED MCP SERVER - CONFIGURAÇÃO AUTOMÁTICA${NC}"
echo -e "${PURPLE}================================================================${NC}"
echo ""

# ===== VERIFICAÇÕES PRELIMINARES =====

echo -e "${BLUE}${INFO} Verificando dependências...${NC}"

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js não encontrado. Instale o Node.js 18+ primeiro.${NC}"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2)
echo -e "${GREEN}${CHECK} Node.js ${NODE_VERSION} encontrado${NC}"

# Verificar Wrangler
if ! command -v wrangler &> /dev/null; then
    echo -e "${YELLOW}${WARNING} Wrangler não encontrado. Instalando...${NC}"
    npm install -g wrangler
fi

WRANGLER_VERSION=$(wrangler --version)
echo -e "${GREEN}${CHECK} Wrangler ${WRANGLER_VERSION} disponível${NC}"

# Verificar login no Cloudflare
if ! wrangler whoami &> /dev/null; then
    echo -e "${YELLOW}${WARNING} Não logado no Cloudflare. Fazendo login...${NC}"
    wrangler login
fi

CLOUDFLARE_USER=$(wrangler whoami)
echo -e "${GREEN}${CHECK} Logado como: ${CLOUDFLARE_USER}${NC}"

echo ""

# ===== CONFIGURAÇÕES DO PROJETO =====

echo -e "${CYAN}${GEAR} Configurações do Projeto${NC}"
echo -e "${CYAN}==============================${NC}"

# Nome do projeto
read -p "Nome do projeto (unified-mcp-server): " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-unified-mcp-server}

# Account ID
echo -e "${INFO} Obtendo Account ID..."
ACCOUNT_ID=$(wrangler whoami | grep "Account ID" | awk '{print $3}' || echo "")
if [ -z "$ACCOUNT_ID" ]; then
    read -p "Account ID do Cloudflare: " ACCOUNT_ID
fi
echo -e "${GREEN}${CHECK} Account ID: ${ACCOUNT_ID}${NC}"

# Zone ID (opcional)
read -p "Zone ID (opcional, para Zero Trust): " ZONE_ID

echo ""

# ===== CRIAR PROJETO COM TEMPLATE OFICIAL =====

echo -e "${PURPLE}${ROCKET} Criando projeto com template oficial...${NC}"

if [ -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}${WARNING} Diretório $PROJECT_NAME já existe. Deseja sobrescrever? (y/N)${NC}"
    read -p "" OVERWRITE
    if [[ $OVERWRITE =~ ^[Yy]$ ]]; then
        rm -rf "$PROJECT_NAME"
    else
        echo -e "${RED}❌ Operação cancelada.${NC}"
        exit 1
    fi
fi

# Criar projeto com template oficial
npm create cloudflare@latest "$PROJECT_NAME" --template=cloudflare/ai/demos/remote-mcp-github-oauth --yes

cd "$PROJECT_NAME"

echo -e "${GREEN}${CHECK} Projeto criado com template oficial${NC}"
echo ""

# ===== CONFIGURAR GITHUB OAUTH =====

echo -e "${LOCK}${KEY} Configuração GitHub OAuth${NC}"
echo -e "${LOCK}===============================${NC}"

echo -e "${INFO} Para configurar OAuth, você precisa criar 2 GitHub OAuth Apps:"
echo -e "${CYAN}1. Development: http://localhost:8787/callback${NC}"
echo -e "${CYAN}2. Production: https://${PROJECT_NAME}.your-account.workers.dev/callback${NC}"
echo ""
echo -e "${YELLOW}Acesse: https://github.com/settings/developers${NC}"
echo ""

read -p "GitHub Client ID (Development): " GITHUB_CLIENT_ID_DEV
read -p "GitHub Client Secret (Development): " GITHUB_CLIENT_SECRET_DEV
read -p "GitHub Client ID (Production): " GITHUB_CLIENT_ID_PROD
read -p "GitHub Client Secret (Production): " GITHUB_CLIENT_SECRET_PROD

# Gerar cookie encryption key
COOKIE_ENCRYPTION_KEY=$(openssl rand -hex 32)
echo -e "${GREEN}${CHECK} Cookie encryption key gerada automaticamente${NC}"

echo ""

# ===== CONFIGURAR APIS EXTERNAS =====

echo -e "${CLOUD}${KEY} APIs Externas (Opcionais)${NC}"
echo -e "${CLOUD}==============================${NC}"

read -p "OpenAI API Key (opcional): " OPENAI_API_KEY
read -p "Anthropic API Key (opcional): " ANTHROPIC_API_KEY

# Cloudflare API Token para Zero Trust
echo -e "${INFO} Para Zero Trust, precisamos de um API Token da Cloudflare"
echo -e "${CYAN}Acesse: https://dash.cloudflare.com/profile/api-tokens${NC}"
echo -e "${CYAN}Permissões necessárias: Zone:Read, Account:Read, Access:Edit${NC}"
read -p "Cloudflare API Token: " CF_API_TOKEN

echo ""

# ===== CRIAR RECURSOS CLOUDFLARE =====

echo -e "${DATABASE}${GEAR} Criando recursos Cloudflare...${NC}"

# KV Namespaces
echo -e "${INFO} Criando KV Namespaces..."
OAUTH_KV_ID=$(wrangler kv:namespace create "OAUTH_KV" --preview false | grep -o 'id = "[^"]*"' | cut -d'"' -f2)
OAUTH_KV_PREVIEW_ID=$(wrangler kv:namespace create "OAUTH_KV" --preview | grep -o 'id = "[^"]*"' | cut -d'"' -f2)

KV_STORAGE_ID=$(wrangler kv:namespace create "KV_STORAGE" --preview false | grep -o 'id = "[^"]*"' | cut -d'"' -f2)
KV_STORAGE_PREVIEW_ID=$(wrangler kv:namespace create "KV_STORAGE" --preview | grep -o 'id = "[^"]*"' | cut -d'"' -f2)

echo -e "${GREEN}${CHECK} KV Namespaces criados${NC}"

# D1 Database
echo -e "${INFO} Criando D1 Database..."
wrangler d1 create "${PROJECT_NAME}-db" > /tmp/d1_output.txt
D1_DATABASE_ID=$(grep -o 'database_id = "[^"]*"' /tmp/d1_output.txt | cut -d'"' -f2)
echo -e "${GREEN}${CHECK} D1 Database criada: ${D1_DATABASE_ID}${NC}"

# R2 Bucket
echo -e "${INFO} Criando R2 Bucket..."
wrangler r2 bucket create "${PROJECT_NAME}-storage"
echo -e "${GREEN}${CHECK} R2 Bucket criado: ${PROJECT_NAME}-storage${NC}"

# Vectorize Index
echo -e "${INFO} Criando Vectorize Index..."
wrangler vectorize create "${PROJECT_NAME}-vectors" --dimensions=768 --metric=cosine
echo -e "${GREEN}${CHECK} Vectorize Index criado: ${PROJECT_NAME}-vectors${NC}"

echo ""

# ===== CONFIGURAR WRANGLER.JSONC =====

echo -e "${GEAR} Gerando wrangler.jsonc...${NC}"

cat > wrangler.jsonc << EOF
{
  "name": "${PROJECT_NAME}",
  "main": "src/index.ts",
  "compatibility_date": "2024-04-01",
  "compatibility_flags": ["nodejs_compat"],
  
  "vars": {
    "ENVIRONMENT": "production"
  },
  
  "kv_namespaces": [
    {
      "binding": "OAUTH_KV",
      "id": "${OAUTH_KV_ID}",
      "preview_id": "${OAUTH_KV_PREVIEW_ID}"
    },
    {
      "binding": "KV_STORAGE", 
      "id": "${KV_STORAGE_ID}",
      "preview_id": "${KV_STORAGE_PREVIEW_ID}"
    }
  ],
  
  "d1_databases": [
    {
      "binding": "D1_DATABASE",
      "database_name": "${PROJECT_NAME}-db",
      "database_id": "${D1_DATABASE_ID}"
    }
  ],
  
  "r2_buckets": [
    {
      "binding": "R2_BUCKET",
      "bucket_name": "${PROJECT_NAME}-storage"
    }
  ],
  
  "vectorize": [
    {
      "binding": "VECTORIZE",
      "index_name": "${PROJECT_NAME}-vectors"
    }
  ],
  
  "ai": {
    "binding": "AI"
  },
  
  "durable_objects": {
    "bindings": [
      {
        "name": "UNIFIED_MCP",
        "class_name": "UnifiedMCPAgent"
      }
    ]
  }
}
EOF

echo -e "${GREEN}${CHECK} wrangler.jsonc configurado${NC}"

# ===== CONFIGURAR VARIÁVEIS DE DESENVOLVIMENTO =====

echo -e "${GEAR} Configurando .dev.vars...${NC}"

cat > .dev.vars << EOF
# GitHub OAuth (Development)
GITHUB_CLIENT_ID="${GITHUB_CLIENT_ID_DEV}"
GITHUB_CLIENT_SECRET="${GITHUB_CLIENT_SECRET_DEV}"
COOKIE_ENCRYPTION_KEY="${COOKIE_ENCRYPTION_KEY}"

# APIs Externas
OPENAI_API_KEY="${OPENAI_API_KEY}"
ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}"

# Cloudflare Zero Trust
CF_API_TOKEN="${CF_API_TOKEN}"
CF_ACCOUNT_ID="${ACCOUNT_ID}"
CF_ZONE_ID="${ZONE_ID}"

# Configurações do Sistema
NODE_ENV="development"
DEBUG="true"
EOF

echo -e "${GREEN}${CHECK} .dev.vars configurado${NC}"

# ===== CONFIGURAR SECRETS DE PRODUÇÃO =====

echo -e "${LOCK} Configurando secrets de produção...${NC}"

echo "${GITHUB_CLIENT_ID_PROD}" | wrangler secret put GITHUB_CLIENT_ID
echo "${GITHUB_CLIENT_SECRET_PROD}" | wrangler secret put GITHUB_CLIENT_SECRET  
echo "${COOKIE_ENCRYPTION_KEY}" | wrangler secret put COOKIE_ENCRYPTION_KEY

if [ -n "$OPENAI_API_KEY" ]; then
    echo "${OPENAI_API_KEY}" | wrangler secret put OPENAI_API_KEY
fi

if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "${ANTHROPIC_API_KEY}" | wrangler secret put ANTHROPIC_API_KEY
fi

echo "${CF_API_TOKEN}" | wrangler secret put CF_API_TOKEN
echo "${ACCOUNT_ID}" | wrangler secret put CF_ACCOUNT_ID

if [ -n "$ZONE_ID" ]; then
    echo "${ZONE_ID}" | wrangler secret put CF_ZONE_ID
fi

echo -e "${GREEN}${CHECK} Secrets de produção configurados${NC}"

# ===== CONFIGURAR BANCO DE DADOS =====

echo -e "${DATABASE} Configurando esquema do banco de dados...${NC}"

cat > schema.sql << EOF
-- Schema para Unified MCP Server

-- Tabela de conhecimento de arquivos
CREATE TABLE IF NOT EXISTS file_knowledge (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT UNIQUE NOT NULL,
    content_hash TEXT NOT NULL,
    insights TEXT, -- JSON
    embedding_id TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de operações em arquivos
CREATE TABLE IF NOT EXISTS file_operations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL,
    operation TEXT NOT NULL,
    result TEXT, -- JSON
    user_id TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de execução de comandos
CREATE TABLE IF NOT EXISTS command_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    command TEXT NOT NULL,
    working_dir TEXT,
    result TEXT, -- JSON
    impact_analysis TEXT, -- JSON
    user_id TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    duration_ms INTEGER
);

-- Tabela de análises de repositório
CREATE TABLE IF NOT EXISTS repository_analyses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    owner TEXT NOT NULL,
    repo TEXT NOT NULL,
    analysis_type TEXT NOT NULL,
    analysis_data TEXT, -- JSON
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(owner, repo, analysis_type)
);

-- Tabela de insights estratégicos
CREATE TABLE IF NOT EXISTS strategic_insights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    domain TEXT NOT NULL,
    insights TEXT, -- JSON
    confidence REAL,
    user_id TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de sessões de usuário
CREATE TABLE IF NOT EXISTS user_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT UNIQUE NOT NULL,
    session_data TEXT, -- JSON
    last_activity DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de uso de ferramentas
CREATE TABLE IF NOT EXISTS tool_usage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    tool_name TEXT NOT NULL,
    parameters TEXT, -- JSON
    result TEXT, -- JSON
    success BOOLEAN DEFAULT TRUE,
    duration_ms INTEGER,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_file_knowledge_path ON file_knowledge(path);
CREATE INDEX IF NOT EXISTS idx_file_operations_path ON file_operations(path);
CREATE INDEX IF NOT EXISTS idx_command_executions_user ON command_executions(user_id);
CREATE INDEX IF NOT EXISTS idx_repository_analyses_repo ON repository_analyses(owner, repo);
CREATE INDEX IF NOT EXISTS idx_strategic_insights_domain ON strategic_insights(domain);
CREATE INDEX IF NOT EXISTS idx_tool_usage_user_tool ON tool_usage(user_id, tool_name);
CREATE INDEX IF NOT EXISTS idx_tool_usage_timestamp ON tool_usage(timestamp);
EOF

# Aplicar schema
wrangler d1 execute "${PROJECT_NAME}-db" --file=schema.sql

echo -e "${GREEN}${CHECK} Schema do banco aplicado${NC}"

# ===== CONFIGURAR PACKAGE.JSON =====

echo -e "${GEAR} Atualizando package.json...${NC}"

# Backup do package.json original
cp package.json package.json.backup

# Adicionar scripts e dependências
npm install --save-dev @types/node

# Atualizar scripts
npx json -I -f package.json -e '
this.scripts = {
  ...this.scripts,
  "dev": "wrangler dev",
  "deploy": "wrangler deploy",
  "deploy:staging": "wrangler deploy --env staging",
  "db:migrate": "wrangler d1 execute unified-mcp-db --file=schema.sql",
  "db:reset": "wrangler d1 execute unified-mcp-db --command=\"DROP TABLE IF EXISTS file_knowledge; DROP TABLE IF EXISTS file_operations; DROP TABLE IF EXISTS command_executions; DROP TABLE IF EXISTS repository_analyses; DROP TABLE IF EXISTS strategic_insights; DROP TABLE IF EXISTS user_sessions; DROP TABLE IF EXISTS tool_usage;\" && npm run db:migrate",
  "logs": "wrangler tail",
  "test": "wrangler dev --test",
  "lint": "eslint src/",
  "type-check": "tsc --noEmit"
}'

echo -e "${GREEN}${CHECK} package.json atualizado${NC}"

# ===== CONFIGURAR CLAUDE DESKTOP =====

echo -e "${PURPLE}${GEAR} Configuração para Claude Desktop${NC}"

WORKER_URL="${PROJECT_NAME}.$(wrangler whoami | grep -o '[^@]*@[^.]*\.[^.]*' | cut -d'@' -f2).workers.dev"

cat > claude-desktop-config.json << EOF
{
  "mcpServers": {
    "${PROJECT_NAME}": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://${WORKER_URL}/sse"
      ]
    }
  }
}
EOF

echo -e "${INFO} Para conectar ao Claude Desktop, copie o conteúdo de claude-desktop-config.json"
echo -e "${INFO} para seu arquivo de configuração do Claude Desktop."
echo -e "${CYAN}Localização do arquivo de config:${NC}"
echo -e "${CYAN}  • macOS: ~/Library/Application Support/Claude/claude_desktop_config.json${NC}"
echo -e "${CYAN}  • Windows: %APPDATA%\\Claude\\claude_desktop_config.json${NC}"
echo -e "${CYAN}  • Linux: ~/.config/Claude/claude_desktop_config.json${NC}"

# ===== CONFIGURAR AMBIENTE DE DESENVOLVIMENTO =====

echo -e "${GEAR} Configurando ambiente de desenvolvimento...${NC}"

# Criar .gitignore
cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment files
.dev.vars
.env*
!.env.example

# Build outputs
dist/
.wrangler/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Temporary files
tmp/
temp/
.tmp/

# Cloudflare
wrangler.toml.bak
claude-desktop-config.json
schema.sql
package.json.backup
EOF

# Criar .env.example
cat > .env.example << EOF
# GitHub OAuth
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
COOKIE_ENCRYPTION_KEY=your_cookie_encryption_key

# APIs Externas
OPENAI_API_KEY=your_openai_api_key
ANTHROPIC_API_KEY=your_anthropic_api_key

# Cloudflare Zero Trust
CF_API_TOKEN=your_cloudflare_api_token
CF_ACCOUNT_ID=your_account_id
CF_ZONE_ID=your_zone_id

# Sistema
NODE_ENV=development
DEBUG=true
EOF

echo -e "${GREEN}${CHECK} Ambiente de desenvolvimento configurado${NC}"

# ===== INSTALAR DEPENDÊNCIAS =====

echo -e "${GEAR} Instalando dependências...${NC}"

npm install

echo -e "${GREEN}${CHECK} Dependências instaladas${NC}"

# ===== DEPLOY INICIAL =====

echo -e "${ROCKET} Fazendo deploy inicial...${NC}"

npm run deploy

echo -e "${GREEN}${CHECK} Deploy inicial concluído${NC}"

# ===== RESUMO FINAL =====

echo ""
echo -e "${PURPLE}${ROCKET} CONFIGURAÇÃO CONCLUÍDA COM SUCESSO! ${ROCKET}${NC}"
echo -e "${PURPLE}================================================${NC}"
echo ""
echo -e "${GREEN}${CHECK} Projeto criado: ${PROJECT_NAME}${NC}"
echo -e "${GREEN}${CHECK} URL do Worker: https://${WORKER_URL}${NC}"
echo -e "${GREEN}${CHECK} Endpoint MCP: https://${WORKER_URL}/sse${NC}"
echo ""
echo -e "${CYAN}${INFO} Próximos passos:${NC}"
echo -e "${CYAN}1. Configure o Claude Desktop com claude-desktop-config.json${NC}"
echo -e "${CYAN}2. Teste localmente: npm run dev${NC}"
echo -e "${CYAN}3. Acesse http://localhost:8787 para testar${NC}"
echo -e "${CYAN}4. Use o MCP Inspector para validar as ferramentas${NC}"
echo ""
echo -e "${YELLOW}${WARNING} Recursos criados:${NC}"
echo -e "  • KV Namespaces: OAUTH_KV, KV_STORAGE"
echo -e "  • D1 Database: ${PROJECT_NAME}-db"
echo -e "  • R2 Bucket: ${PROJECT_NAME}-storage"  
echo -e "  • Vectorize Index: ${PROJECT_NAME}-vectors"
echo ""
echo -e "${LOCK}${INFO} Secrets configurados:${NC}"
echo -e "  • GITHUB_CLIENT_ID/SECRET"
echo -e "  • COOKIE_ENCRYPTION_KEY"
echo -e "  • CF_API_TOKEN/ACCOUNT_ID"
echo -e "  • OPENAI_API_KEY (se fornecido)"
echo -e "  • ANTHROPIC_API_KEY (se fornecido)"
echo ""
echo -e "${PURPLE}Documentação: https://developers.cloudflare.com/agents/${NC}"
echo -e "${PURPLE}Template usado: cloudflare/ai/demos/remote-mcp-github-oauth${NC}"
echo ""
echo -e "${GREEN}🎉 Seu MCP Server está pronto para uso! 🎉${NC}"