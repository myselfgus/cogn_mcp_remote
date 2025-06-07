# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Unified MCP (Model Context Protocol) Server built using Cloudflare Workers, following the official `cloudflare/ai/demos/remote-mcp-github-oauth` template. The project implements an AI-powered development assistant with 20 specialized tools across 7 categories.

### Core Architecture

- **Base Framework**: McpAgent + workers-oauth-provider pattern (official Cloudflare standard)
- **Authentication**: GitHub OAuth 2.1 with Zero Trust integration
- **Storage**: D1 Database, R2 Bucket, KV Storage, Vectorize Index
- **AI Engine**: Cloudflare AI with multiple specialized engines:
  - AdvancedMemoryEngine (semantic memory + knowledge graph)
  - IntelligentCodeEngine (code analysis + optimization)
  - MCPReasoningEngine (sequential reasoning + strategic analysis)
  - DesktopIntegrationEngine (system integration)

### Tool Categories (20 tools total)

1. **File System Tools (3)**: intelligent_file_reader, semantic_code_search, ai_file_editor
2. **Code Analysis Tools (3)**: architectural_analysis, pattern_detection, dependency_analyzer
3. **GitHub Integration (3)**: repository_analyzer, intelligent_issue_manager, ai_pr_reviewer
4. **AI Reasoning Tools (3)**: sequential_reasoning, strategic_analyzer, beam_search_reasoning
5. **Memory Management (3)**: knowledge_graph_manager, semantic_memory, contextual_memory
6. **System Integration (2)**: desktop_commander, process_manager
7. **Zero Trust Security (3)**: zero_trust_analyzer, access_policy_manager, security_monitor

## Development Commands

### Local Development
```bash
npm run dev                    # Start local development server (port 8787)
npm run deploy                 # Deploy to production
npm run deploy:staging         # Deploy to staging environment
npm run test                   # Run tests with wrangler
```

### Database Management
```bash
npm run db:migrate             # Apply schema.sql to D1 database
npm run db:reset               # Reset database and reapply schema
```

### Monitoring & Debugging
```bash
npm run logs                   # View real-time logs with wrangler tail
wrangler dev --test           # Test mode
```

## Configuration Files

### Essential Configuration
- `wrangler.jsonc`: Cloudflare Worker configuration with all bindings
- `.dev.vars`: Development environment variables (not committed)
- `schema.sql`: Database schema with 7 tables for knowledge storage
- `mcp-setup-script.sh`: Automated setup script for complete deployment

### Environment Setup
The project requires specific Cloudflare resources and GitHub OAuth apps:
- **Production**: GitHub OAuth callback at `https://your-worker.workers.dev/callback`
- **Development**: GitHub OAuth callback at `http://localhost:8787/callback`

Reference `mcp-variables-reference.md` for complete list of required secrets and bindings.

## Key Implementation Patterns

### Session Management
The system maintains persistent user sessions with:
- Memory graph for contextual knowledge
- Tool execution history
- User preferences (code language, AI reasoning level, security level)
- Strategic insights storage

### AI-Powered Operations
All file operations include AI analysis:
- Safety checks before dangerous operations
- Code optimization suggestions
- Pattern detection and anti-pattern identification
- Semantic search capabilities

### Zero Trust Integration
Built-in Cloudflare Zero Trust integration:
- Access policy management
- Security event monitoring
- Threat pattern identification
- Compliance analysis

## Testing & Validation

### Local Testing URLs
- **MCP Endpoint**: `http://localhost:8787/sse`
- **Health Check**: `http://localhost:8787/health`
- **OAuth Callback**: `http://localhost:8787/callback`

### Claude Desktop Integration
Configure Claude Desktop to connect to the MCP server using the generated `claude-desktop-config.json` file.

## Security Considerations

- All secrets must be set via `wrangler secret put` (never committed)
- Cookie encryption uses 32-character hex keys
- API tokens use minimal required permissions
- File operations include AI safety analysis
- Command execution has safety checks and impact analysis

## Database Schema

The system uses 7 main tables:
- `file_knowledge`: AI insights about files with embeddings
- `file_operations`: History of file modifications
- `command_executions`: System command logs with impact analysis
- `repository_analyses`: GitHub repository analysis cache
- `strategic_insights`: High-level strategic recommendations
- `user_sessions`: Persistent user state and preferences
- `tool_usage`: Complete tool execution history

## Development Notes

- Follow the McpAgent pattern from the official Cloudflare template
- All engines are modular and can be extended independently
- The system is designed for enterprise-grade production use
- Memory engine supports semantic search via Vectorize embeddings
- Reasoning engine implements multiple strategies (sequential, beam search, MCTS)