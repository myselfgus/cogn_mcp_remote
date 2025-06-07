# 🚀 Cogn - Unified MCP Server

**Advanced AI-powered development assistant with 20 specialized tools**

Cogn is a production-ready Model Context Protocol (MCP) server built on Cloudflare Workers, designed to integrate seamlessly with Claude.ai and provide comprehensive development assistance through AI-powered tools.

## ✨ Features

### 🧠 **20 Specialized AI Tools** across 7 categories:

- **📁 File System (3 tools)**: Intelligent file reading, semantic code search, AI-assisted editing
- **🔍 Code Analysis (3 tools)**: Architecture analysis, pattern detection, dependency management  
- **🐙 GitHub Integration (3 tools)**: Repository analysis, issue management, PR reviews
- **🧠 AI Reasoning (3 tools)**: Sequential reasoning, strategic analysis, beam search
- **💾 Memory Management (3 tools)**: Knowledge graph, semantic memory, contextual memory
- **🖥️ System Integration (2 tools)**: Desktop commands, process management
- **🔒 Zero Trust Security (3 tools)**: Security analysis, policy management, event monitoring

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
npm run dev          # Start development server
npm run deploy       # Deploy to production
npm run db:migrate   # Apply database schema
npm run db:reset     # Reset and recreate database
npm run logs         # View real-time logs
npm run test         # Run tests
npm run lint         # Lint code
npm run type-check   # TypeScript type checking
```

### **Local Development**
```bash
npm run dev
# Server available at http://localhost:8787
# MCP endpoint: http://localhost:8787/sse
# Docs: http://localhost:8787/docs
```

## 📊 Tool Categories

### 📁 **File System Tools**
- `intelligent_file_reader` - Read and analyze files with AI insights
- `semantic_code_search` - Natural language code search with context
- `ai_file_editor` - AI-assisted file editing with safety checks

### 🔍 **Code Analysis Tools** 
- `architectural_analysis` - Project architecture analysis and recommendations
- `pattern_detection` - Design patterns and anti-patterns detection
- `dependency_analyzer` - Dependency analysis with security scanning

### 🐙 **GitHub Integration Tools**
- `repository_analyzer` - Comprehensive repository analysis with trends
- `intelligent_issue_manager` - AI-powered issue categorization and solutions
- `ai_pr_reviewer` - Automated pull request review and suggestions

### 🧠 **AI Reasoning Tools**
- `sequential_reasoning` - Advanced step-by-step problem solving
- `strategic_analyzer` - High-level strategic analysis and planning
- `beam_search_reasoning` - Explore multiple solution paths simultaneously

### 💾 **Memory Management Tools**
- `knowledge_graph_manager` - Persistent knowledge graph with relationships
- `semantic_memory` - Semantic memory storage and retrieval
- `contextual_memory` - Context-aware memory across sessions

### 🖥️ **System Integration Tools**
- `desktop_commander` - Execute system commands with AI safety analysis
- `process_manager` - System process management with AI insights

### 🔒 **Zero Trust Security Tools**
- `zero_trust_analyzer` - Analyze and improve Zero Trust posture
- `access_policy_manager` - Manage Cloudflare Access policies
- `security_monitor` - Monitor security events with threat detection

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