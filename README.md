# 🚀 Cogn - Unified MCP Server

**Advanced AI-powered development assistant with 21 specialized tools based on real MCP implementations.**

> **Status**: ✅ All 21 tools implemented and ready for testing  
> **Framework**: Cloudflare Workers + Durable Objects  
> **MCP Version**: Latest (@modelcontextprotocol/sdk ^1.12.1)

Cogn is a production-ready Model Context Protocol (MCP) server that consolidates 21 powerful tools across 7 categories, all based on researched and real MCP server implementations. Each tool provides specialized AI-powered capabilities for development, reasoning, system management, and knowledge work.

## ✨ Features

### 🧠 **21 Specialized AI Tools** across 7 categories:

- **🧠 Reasoning & Intelligence (4 tools)**: Multi-strategy reasoning, strategic analysis, pattern detection, decision engine
- **📂 Smart File System (4 tools)**: Intelligent file ops, codebase navigation, project analysis, content transformation
- **🔗 External Integration (3 tools)**: GitHub orchestration, web intelligence, system command execution
- **💾 Memory & Knowledge (4 tools)**: Persistent memory, dynamic context, knowledge graphs, insight aggregation
- **⚡ Performance & Operations (2 tools)**: Performance optimization, workflow automation
- **🔒 Security (1 tool)**: Comprehensive security analysis and compliance
- **🎨 Development Experience (3 tools)**: AI development assistance, script generation, functional architecture

### 🎯 **Key Capabilities**

- **Persistent Memory**: Maintains context across sessions with semantic search
- **GitHub OAuth**: Secure authentication with repository access
- **Zero Trust Integration**: Native Cloudflare Zero Trust support
- **AI-Powered Safety**: Built-in safety checks for all operations
- **Semantic Search**: Vector-based code and content search
- **Strategic Analysis**: High-level insights and recommendations

## 🏗️ Architecture

Built following Cloudflare's official MCP remote server patterns (2024-2025):

- **Runtime**: Cloudflare Workers with Durable Objects
- **Database**: D1 SQLite with 15 optimized tables
- **Vector Search**: Cloudflare Vectorize for embeddings
- **Storage**: R2 for file storage, KV for sessions
- **AI**: Cloudflare AI models with fallback to OpenAI/Anthropic
- **Auth**: GitHub OAuth 2.1 with secure session management

## 🚀 Quick Start

### 1. **Clone & Setup**
```bash
git clone https://github.com/myselfgus/cogn_mcp_remote.git
cd cogn_mcp_remote
npm install
```

### 2. **Configure GitHub OAuth**
Create GitHub OAuth apps at https://github.com/settings/developers

- **Development**: `http://localhost:8787/callback`
- **Production**: `https://your-worker.workers.dev/callback`

### 3. **Set Environment Variables**
```bash
cp .dev.vars.example .dev.vars
# Edit .dev.vars with your credentials
```

### 4. **Deploy to Cloudflare**
```bash
# Login to Cloudflare
wrangler login

# Create resources (interactive)
npm run setup

# Deploy
npm run deploy
```

### 5. **Connect to Claude Desktop**
Add to your Claude Desktop config:
```json
{
  \"mcpServers\": {
    \"cogn\": {
      \"command\": \"npx\",
      \"args\": [\"mcp-remote\", \"https://your-worker.workers.dev/sse\"]
    }
  }
}
```

## 🛠️ Development

### **Available Commands**
```bash
npm run dev          # Start development server (wrangler dev)
npm run deploy       # Deploy to production
npm run db:migrate   # Apply database schema
npm run db:reset     # Reset and recreate database
npm run logs         # View real-time logs
node test-cogn-tools.js        # Test all 21 tools with real data
node test-individual-tool.js   # Test individual tools interactively
```

### **Local Development**
```bash
npm run dev
# Server available at http://localhost:8787
# MCP endpoint: http://localhost:8787/sse
# Docs: http://localhost:8787/docs
```

## 📊 Tool Categories

### 🧠 **Reasoning & Intelligence (4 tools)**
- `unified_reasoner` - Multi-strategy AI reasoning (Beam Search, MCTS)
- `strategic_intelligence` - Domain-specific strategic analysis
- `pattern_intelligence` - Code pattern detection and optimization
- `decision_engine` - Multi-criteria decision making

### 📂 **Smart File System (4 tools)**
- `intelligent_file_ops` - AI-enhanced file operations
- `codebase_navigator` - Architectural codebase exploration
- `project_analyzer` - Comprehensive project health analysis
- `content_transformer` - Smart content refactoring and optimization

### 🔗 **External Integration (3 tools)**
- `github_orchestrator` - GitHub repository analysis and management
- `web_intelligence` - Web content analysis and extraction
- `system_commander` - Safe system command execution

### 💾 **Memory & Knowledge (4 tools)**
- `persistent_memory_engine` - Cross-session memory with vector embeddings
- `dynamic_context_manager` - Intelligent context management
- `knowledge_graph_navigator` - Graph-based knowledge representation
- `insight_aggregator` - Pattern discovery and recommendation synthesis

### ⚡ **Performance & Operations (2 tools)**
- `performance_optimizer` - System and application optimization
- `workflow_automator` - Intelligent workflow orchestration

### 🔒 **Security (1 tool)**
- `security_guardian` - Comprehensive security analysis and compliance

### 🎨 **Development Experience (3 tools)**
- `dev_assistant` - AI-powered development assistance
- `genai_scripter` - AI script and template generation
- `functional_architect` - Functional programming design patterns

---

## 🧪 **Testing Suite**

### **Comprehensive Testing**
Test all 21 tools with real data:

```bash
node test-cogn-tools.js
```

### **Individual Tool Testing**
Test specific tools interactively:

```bash
# Interactive mode
node test-individual-tool.js

# Specific tool with default parameters
node test-individual-tool.js unified_reasoner

# Custom parameters
node test-individual-tool.js dev_assistant '{"action":"generate_code","language":"typescript","requirements":"Create a user service class"}'
```

### **Health Check**
```bash
curl http://localhost:8787/health
```

### **Tool Sources**
Each tool is based on real MCP implementations:

- **Reasoning**: [Jacck/mcp-reasoner](https://github.com/Jacck/mcp-reasoner)
- **System Integration**: [wonderwhy-er/DesktopCommanderMCP](https://github.com/wonderwhy-er/DesktopCommanderMCP)
- **Official Tools**: [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- **Memory Services**: [doobidoo/mcp-memory-service](https://github.com/doobidoo/mcp-memory-service)
- **Knowledge Graphs**: [shaneholloman/mcp-knowledge-graph](https://github.com/shaneholloman/mcp-knowledge-graph)

See [COGN-FERRAMENTAS-MAPEAMENTO.md](./COGN-FERRAMENTAS-MAPEAMENTO.md) for complete mapping.

## 🔧 Configuration

### **Required Secrets** (via `wrangler secret put`)
```bash
GITHUB_CLIENT_ID           # GitHub OAuth client ID
GITHUB_CLIENT_SECRET        # GitHub OAuth client secret  
COOKIE_ENCRYPTION_KEY       # 32-character hex key
CF_API_TOKEN               # Cloudflare API token
CF_ACCOUNT_ID              # Cloudflare account ID
CF_ZONE_ID                 # Cloudflare zone ID (optional)
```

### **Optional APIs**
```bash
OPENAI_API_KEY             # OpenAI API key
ANTHROPIC_API_KEY          # Anthropic API key
```

### **Required Cloudflare Resources**
- **KV Namespaces**: `OAUTH_KV`, `KV_STORAGE`
- **D1 Database**: `cogn-mcp-db`
- **R2 Bucket**: `cogn-mcp-storage`
- **Vectorize Index**: `cogn-mcp-vectors`
- **AI Binding**: Enabled

## 🌐 Endpoints

- `/sse` - MCP Server-Sent Events endpoint
- `/health` - Health check and status
- `/metrics` - Server metrics and analytics
- `/docs` - Interactive documentation
- `/oauth/callback` - GitHub OAuth callback

## 🔒 Security

- **OAuth 2.1** with GitHub integration
- **Zero Trust** native support
- **AI Safety Checks** for all operations
- **Encrypted Sessions** with secure cookie handling
- **Command Safety Analysis** before execution
- **No Secrets in Code** - all via Wrangler secrets

## 📈 Performance

- **Edge Computing** via Cloudflare Workers
- **Global Distribution** with minimal latency
- **Durable Objects** for stateful operations
- **Optimized Database** with 25+ indexes
- **Vector Search** for semantic queries
- **Smart Caching** for repeated operations

## 🤝 Integration with Claude.ai

Cogn is specifically designed for seamless integration with Claude.ai:

1. **Remote MCP Protocol** - Standard MCP over HTTPS
2. **GitHub Authentication** - Secure access to repositories  
3. **Persistent Memory** - Maintains context across conversations
4. **Tool Categories** - Organized for easy discovery
5. **Error Handling** - Graceful failures with helpful messages
6. **Performance Optimized** - Fast response times for real-time use

## 📚 Documentation

- **API Documentation**: Available at `/docs` endpoint
- **Tool Reference**: See [CLAUDE.md](./CLAUDE.md) for detailed tool descriptions
- **Setup Guide**: See [mcp-variables-reference.md](./mcp-variables-reference.md)
- **Architecture**: See [src/unified-mcp-server.ts](./src/unified-mcp-server.ts)

## 🛟 Support

- **Issues**: [GitHub Issues](https://github.com/myselfgus/cogn_mcp_remote/issues)
- **Discussions**: [GitHub Discussions](https://github.com/myselfgus/cogn_mcp_remote/discussions)
- **Documentation**: [Cloudflare Agents](https://developers.cloudflare.com/agents/)

## 📄 License

MIT License - see [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- **Cloudflare** for the Workers platform and AI services
- **Anthropic** for the Model Context Protocol
- **OpenAI** for GPT models and API
- **GitHub** for OAuth and repository integration

---

**Built with ❤️ using Cloudflare Workers, following official MCP patterns for seamless Claude.ai integration.**