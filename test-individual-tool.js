#!/usr/bin/env node

/**
 * 🔍 INDIVIDUAL TOOL TESTER
 * Test specific Cogn MCP tools with custom parameters
 * Usage: node test-individual-tool.js <tool_name> [parameters_json]
 */

const COGN_MCP_URL = process.env.COGN_MCP_URL || 'http://localhost:8787';

// Tool examples with real parameters
const toolExamples = {
  unified_reasoner: {
    problem: "Should we migrate from REST to GraphQL for our API?",
    strategy: "mcts",
    beam_width: 4,
    max_iterations: 8
  },
  strategic_intelligence: {
    domain: "performance",
    scope: "API response optimization",
    timeframe: "immediate"
  },
  pattern_intelligence: {
    source_path: "src/",
    pattern_types: ["design_patterns", "anti_patterns"],
    include_refactoring: true
  },
  decision_engine: {
    decision_context: "Database choice for new microservice",
    criteria: ["performance", "scalability", "consistency", "cost"],
    options: ["postgresql", "mongodb", "redis", "dynamodb"],
    weights: [0.4, 0.3, 0.2, 0.1]
  },
  intelligent_file_ops: {
    operation: "search",
    paths: ["src/", "test/"],
    search_query: "export class",
    include_analysis: true
  },
  codebase_navigator: {
    root_path: "/workspaces/cogn_mcp_remote",
    action: "map_dependencies",
    depth: 3
  },
  project_analyzer: {
    project_path: "/workspaces/cogn_mcp_remote",
    analysis_type: "health_check",
    include_metrics: true
  },
  content_transformer: {
    source: "function add(a, b) { return a + b; }",
    transformation: "document",
    target_format: "typescript",
    options: { add_jsdoc: true, strict_types: true }
  },
  github_orchestrator: {
    action: "list_issues",
    owner: "microsoft",
    repo: "typescript",
    since: "2025-01-01"
  },
  web_intelligence: {
    url: "https://www.npmjs.com/package/@modelcontextprotocol/sdk",
    action: "extract",
    extract_type: "structured",
    analysis_depth: "basic"
  },
  system_commander: {
    operation: "list_processes",
    process_name: "node",
    timeout: 15
  },
  persistent_memory_engine: {
    action: "search",
    query: "TypeScript development patterns",
    tags: ["development", "patterns"],
    context: { session: "current" }
  },
  dynamic_context_manager: {
    action: "load_context",
    session_id: "dev_session_2025",
    timeframe: "current"
  },
  knowledge_graph_navigator: {
    action: "query_graph",
    query: "development tools",
    depth: 2
  },
  insight_aggregator: {
    action: "analyze_trends",
    data_sources: ["memory", "sessions"],
    time_window: "month",
    insight_types: ["patterns", "recommendations"]
  },
  performance_optimizer: {
    target: "system",
    action: "benchmark",
    metrics: ["cpu", "memory", "response_time", "throughput"],
    optimization_level: "aggressive"
  },
  workflow_automator: {
    action: "execute_workflow",
    workflow_name: "Code Quality Check",
    steps: [
      { type: "lint", command: "npm run lint" },
      { type: "test", command: "npm test" },
      { type: "security", command: "npm audit" }
    ]
  },
  security_guardian: {
    action: "compliance_check",
    target: "application",
    compliance_framework: "SOC2",
    scan_type: "comprehensive"
  },
  dev_assistant: {
    action: "create_tests",
    language: "typescript",
    code_input: "export class UserService {\n  async getUser(id: string) {\n    return { id, name: 'Test' };\n  }\n}",
    requirements: "Unit tests with mocking"
  },
  genai_scripter: {
    action: "create_template",
    script_type: "automation",
    target_platform: "node",
    template_name: "MCP Server Template",
    workflow_description: "Template for creating new MCP servers"
  },
  functional_architect: {
    action: "create_pipeline",
    domain_context: "Data processing pipeline",
    data_flow: ["validate", "transform", "enrich", "store", "notify"],
    type_requirements: "Strong typing with Result monad"
  }
};

async function testIndividualTool(toolName, parameters = null) {
  const params = parameters || toolExamples[toolName];
  
  if (!params) {
    console.log(`❌ No example parameters found for tool: ${toolName}`);
    console.log('Available tools:');
    Object.keys(toolExamples).forEach(tool => console.log(`  - ${tool}`));
    return false;
  }

  console.log(`🔧 Testing individual tool: ${toolName}`);
  console.log(`📊 Parameters:`);
  console.log(JSON.stringify(params, null, 2));
  console.log('─'.repeat(50));

  try {
    const startTime = Date.now();
    
    const response = await fetch(`${COGN_MCP_URL}/mcp`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        jsonrpc: '2.0',
        id: `test_${toolName}_${Date.now()}`,
        method: 'tools/call',
        params: {
          name: toolName,
          arguments: params
        }
      })
    });

    const responseTime = Date.now() - startTime;

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    const result = await response.json();
    
    if (result.error) {
      console.log(`❌ Tool Error:`);
      console.log(JSON.stringify(result.error, null, 2));
      return false;
    }

    console.log(`✅ Tool executed successfully!`);
    console.log(`⏱️  Response time: ${responseTime}ms`);
    console.log(`📄 Result:`);
    
    if (result.result?.content?.[0]?.text) {
      const output = result.result.content[0].text;
      try {
        // Try to parse and pretty-print JSON
        const parsed = JSON.parse(output.split(':\n\n')[1] || output);
        console.log(JSON.stringify(parsed, null, 2));
      } catch {
        // If not JSON, show first 500 chars
        console.log(output.substring(0, 500) + (output.length > 500 ? '...' : ''));
      }
    } else {
      console.log(JSON.stringify(result.result, null, 2));
    }

    return true;
  } catch (error) {
    console.log(`❌ Test failed:`, error.message);
    return false;
  }
}

async function interactiveMode() {
  const readline = require('readline');
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  console.log('\n🎯 INTERACTIVE TOOL TESTING MODE');
  console.log('Available tools:');
  Object.keys(toolExamples).forEach((tool, i) => {
    console.log(`  ${i + 1}. ${tool}`);
  });
  
  return new Promise((resolve) => {
    rl.question('\nEnter tool name (or number): ', async (input) => {
      const toolNames = Object.keys(toolExamples);
      const toolName = isNaN(input) ? input : toolNames[parseInt(input) - 1];
      
      if (toolName && toolExamples[toolName]) {
        await testIndividualTool(toolName);
      } else {
        console.log('❌ Invalid tool name/number');
      }
      
      rl.close();
      resolve();
    });
  });
}

async function main() {
  const args = process.argv.slice(2);
  
  console.log('🔍 COGN MCP - Individual Tool Tester');
  console.log('=' * 50);

  // Health check first
  try {
    const response = await fetch(`${COGN_MCP_URL}/health`);
    if (!response.ok) throw new Error('Server not responding');
    
    const health = await response.json();
    console.log(`✅ Server: ${health.server} v${health.version}`);
    console.log(`🔧 Tools: ${health.tools} available\n`);
  } catch (error) {
    console.log('❌ Server health check failed:', error.message);
    console.log('💡 Make sure to run: wrangler dev\n');
  }

  if (args.length === 0) {
    await interactiveMode();
  } else {
    const toolName = args[0];
    let parameters = null;
    
    if (args[1]) {
      try {
        parameters = JSON.parse(args[1]);
      } catch (error) {
        console.log('❌ Invalid JSON parameters');
        return;
      }
    }
    
    await testIndividualTool(toolName, parameters);
  }
}

// Usage examples
if (require.main === module) {
  if (process.argv.includes('--help') || process.argv.includes('-h')) {
    console.log(`
🔍 COGN MCP Individual Tool Tester

Usage:
  node test-individual-tool.js                           # Interactive mode
  node test-individual-tool.js <tool_name>               # Test with example params
  node test-individual-tool.js <tool_name> '<json>'      # Test with custom params

Examples:
  node test-individual-tool.js unified_reasoner
  node test-individual-tool.js dev_assistant '{"action":"generate_code","language":"typescript","requirements":"Create a user validation function"}'
  
Environment:
  COGN_MCP_URL=http://localhost:8787  # Server URL (default: localhost:8787)
`);
  } else {
    main().catch(console.error);
  }
}

module.exports = { testIndividualTool, toolExamples };