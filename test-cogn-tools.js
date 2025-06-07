#!/usr/bin/env node

/**
 * 🧪 COGN MCP TOOLS TESTING SUITE
 * Comprehensive testing of all 21 tools with real data
 * User request: "dps eu qro ver os testes de cada uma delas com dados reais"
 */

const COGN_MCP_URL = process.env.COGN_MCP_URL || 'http://localhost:8787';

// Real test data for comprehensive testing
const testData = {
  reasoning: {
    problem: "How to optimize a microservices architecture for better performance and scalability?",
    criteria: ["performance", "scalability", "maintainability", "cost"],
    options: ["monolith_refactor", "service_mesh", "serverless_migration", "hybrid_approach"]
  },
  filesystem: {
    paths: ["src/index.ts", "package.json", "README.md", "wrangler.toml"],
    content: "// Sample TypeScript code\nexport class CognMCP {\n  constructor() {\n    console.log('Cogn MCP initialized');\n  }\n}",
    search_query: "CognMCP"
  },
  github: {
    owner: "anthropics",
    repo: "claude-code",
    issue_number: 1
  },
  web: {
    url: "https://docs.anthropic.com/en/docs/claude-code",
    test_url: "https://github.com/anthropics/claude-code"
  },
  memory: {
    content: "User prefers TypeScript over JavaScript. Focuses on MCP server development. Uses functional programming patterns.",
    query: "TypeScript preferences",
    tags: ["user_preferences", "development", "languages"]
  },
  system: {
    command: "echo 'Hello from Cogn MCP'",
    process_name: "node"
  },
  development: {
    code: "function calculateTotal(items) {\n  return items.reduce((sum, item) => sum + item.price, 0);\n}",
    requirements: "Create a function to validate user input data",
    issue: "Function returns undefined when array is empty"
  }
};

/**
 * Test runner for individual MCP tools
 */
async function testTool(toolName, parameters) {
  try {
    console.log(`🔧 Testing: ${toolName}`);
    console.log(`📊 Parameters:`, JSON.stringify(parameters, null, 2));
    
    const response = await fetch(`${COGN_MCP_URL}/mcp`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        jsonrpc: '2.0',
        id: Math.random().toString(36).substring(7),
        method: 'tools/call',
        params: {
          name: toolName,
          arguments: parameters
        }
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    const result = await response.json();
    
    if (result.error) {
      console.log(`❌ Error:`, result.error);
      return false;
    }

    console.log(`✅ Success:`, result.result?.content?.[0]?.text ? 'Response received' : 'Tool executed');
    console.log(`📄 Sample output:`, result.result?.content?.[0]?.text?.substring(0, 200) + '...');
    console.log('---');
    return true;
  } catch (error) {
    console.log(`❌ Failed:`, error.message);
    console.log('---');
    return false;
  }
}

/**
 * Test all 21 Cogn MCP tools systematically
 */
async function runAllTests() {
  console.log('🚀 Starting comprehensive Cogn MCP Tools testing...');
  console.log(`🎯 Testing against: ${COGN_MCP_URL}`);
  console.log('=' * 60);

  let passedTests = 0;
  let totalTests = 0;

  // 🧠 REASONING & INTELLIGENCE (4 tools)
  console.log('\n🧠 REASONING & INTELLIGENCE TOOLS');
  console.log('=' * 40);

  totalTests++;
  if (await testTool('unified_reasoner', {
    problem: testData.reasoning.problem,
    strategy: 'beam_search',
    beam_width: 3,
    max_iterations: 5
  })) passedTests++;

  totalTests++;
  if (await testTool('strategic_intelligence', {
    domain: 'architecture',
    scope: 'microservices optimization',
    timeframe: 'short_term'
  })) passedTests++;

  totalTests++;
  if (await testTool('pattern_intelligence', {
    source_path: 'src/',
    pattern_types: ['design_patterns', 'anti_patterns'],
    include_refactoring: true
  })) passedTests++;

  totalTests++;
  if (await testTool('decision_engine', {
    decision_context: 'Architecture choice for new service',
    criteria: testData.reasoning.criteria,
    options: testData.reasoning.options,
    weights: [0.3, 0.3, 0.2, 0.2]
  })) passedTests++;

  // 📂 SMART FILE SYSTEM (4 tools)
  console.log('\n📂 SMART FILE SYSTEM TOOLS');
  console.log('=' * 40);

  totalTests++;
  if (await testTool('intelligent_file_ops', {
    operation: 'read',
    paths: testData.filesystem.paths,
    include_analysis: true
  })) passedTests++;

  totalTests++;
  if (await testTool('codebase_navigator', {
    root_path: '/workspaces/cogn_mcp_remote',
    action: 'explore',
    depth: 2
  })) passedTests++;

  totalTests++;
  if (await testTool('project_analyzer', {
    project_path: '/workspaces/cogn_mcp_remote',
    analysis_type: 'comprehensive',
    include_metrics: true
  })) passedTests++;

  totalTests++;
  if (await testTool('content_transformer', {
    source: testData.filesystem.content,
    transformation: 'refactor',
    target_format: 'typescript',
    options: { add_types: true, optimize: true }
  })) passedTests++;

  // 🔗 EXTERNAL INTEGRATION (3 tools)
  console.log('\n🔗 EXTERNAL INTEGRATION TOOLS');
  console.log('=' * 40);

  totalTests++;
  if (await testTool('github_orchestrator', {
    action: 'analyze_repo',
    owner: testData.github.owner,
    repo: testData.github.repo
  })) passedTests++;

  totalTests++;
  if (await testTool('web_intelligence', {
    url: testData.web.url,
    action: 'analyze',
    analysis_depth: 'comprehensive'
  })) passedTests++;

  totalTests++;
  if (await testTool('system_commander', {
    operation: 'execute',
    command: testData.system.command,
    timeout: 10
  })) passedTests++;

  // 💾 MEMORY & KNOWLEDGE (4 tools)
  console.log('\n💾 MEMORY & KNOWLEDGE TOOLS');
  console.log('=' * 40);

  totalTests++;
  if (await testTool('persistent_memory_engine', {
    action: 'store',
    content: testData.memory.content,
    tags: testData.memory.tags,
    context: { session: 'test_session', project: 'cogn_mcp' }
  })) passedTests++;

  totalTests++;
  if (await testTool('dynamic_context_manager', {
    action: 'save_context',
    session_id: 'test_session',
    context_data: {
      preferences: { language: 'typescript', ai_level: 'advanced' },
      project: 'cogn_mcp_server',
      activities: ['reasoning', 'file_analysis', 'memory_storage']
    }
  })) passedTests++;

  totalTests++;
  if (await testTool('knowledge_graph_navigator', {
    action: 'create_entity',
    entity_type: 'project',
    entity_name: 'Cogn MCP Server'
  })) passedTests++;

  totalTests++;
  if (await testTool('insight_aggregator', {
    action: 'generate_insights',
    data_sources: ['memory', 'sessions', 'projects'],
    time_window: 'week',
    insight_types: ['patterns', 'trends', 'recommendations']
  })) passedTests++;

  // ⚡ PERFORMANCE & OPERATIONS (2 tools)
  console.log('\n⚡ PERFORMANCE & OPERATIONS TOOLS');
  console.log('=' * 40);

  totalTests++;
  if (await testTool('performance_optimizer', {
    target: 'application',
    action: 'analyze',
    metrics: ['cpu', 'memory', 'response_time'],
    optimization_level: 'balanced'
  })) passedTests++;

  totalTests++;
  if (await testTool('workflow_automator', {
    action: 'create_workflow',
    workflow_name: 'Test Deployment Pipeline',
    steps: [
      { type: 'test', command: 'npm test' },
      { type: 'build', command: 'npm run build' },
      { type: 'deploy', command: 'wrangler deploy' }
    ],
    trigger: 'manual'
  })) passedTests++;

  // 🔒 SECURITY (1 tool)
  console.log('\n🔒 SECURITY TOOLS');
  console.log('=' * 40);

  totalTests++;
  if (await testTool('security_guardian', {
    action: 'scan_vulnerabilities',
    target: 'application',
    scan_type: 'comprehensive'
  })) passedTests++;

  // 🎨 DEVELOPMENT EXPERIENCE (3 tools)
  console.log('\n🎨 DEVELOPMENT EXPERIENCE TOOLS');
  console.log('=' * 40);

  totalTests++;
  if (await testTool('dev_assistant', {
    action: 'review_code',
    language: 'typescript',
    code_input: testData.development.code
  })) passedTests++;

  totalTests++;
  if (await testTool('genai_scripter', {
    action: 'generate_script',
    script_type: 'test',
    target_platform: 'node',
    workflow_description: 'Automated testing pipeline for MCP server'
  })) passedTests++;

  totalTests++;
  if (await testTool('functional_architect', {
    action: 'design_domain',
    domain_context: 'MCP Server Development',
    type_requirements: 'Strong typing with error handling'
  })) passedTests++;

  // 📊 FINAL RESULTS
  console.log('\n📊 TESTING RESULTS');
  console.log('=' * 60);
  console.log(`✅ Passed: ${passedTests}/${totalTests} tools`);
  console.log(`📈 Success Rate: ${((passedTests/totalTests) * 100).toFixed(1)}%`);
  
  if (passedTests === totalTests) {
    console.log('🎉 ALL TOOLS WORKING PERFECTLY!');
  } else {
    console.log(`⚠️  ${totalTests - passedTests} tools need attention`);
  }

  console.log('\n🔗 Next Steps:');
  console.log('1. Deploy to Cloudflare Workers');
  console.log('2. Configure Zero Trust tunnel');
  console.log('3. Connect to Claude Desktop');
  console.log('4. Test with real Claude.ai integration');
}

/**
 * Health check before testing
 */
async function healthCheck() {
  try {
    console.log('🏥 Checking Cogn MCP Server health...');
    const response = await fetch(`${COGN_MCP_URL}/health`);
    
    if (!response.ok) {
      throw new Error(`Server not responding: ${response.status}`);
    }

    const health = await response.json();
    console.log('✅ Server healthy:', health.server, 'v' + health.version);
    console.log(`🔧 Tools available: ${health.tools}`);
    return true;
  } catch (error) {
    console.log('❌ Server health check failed:', error.message);
    console.log('💡 Make sure to run: wrangler dev');
    return false;
  }
}

/**
 * Main execution
 */
async function main() {
  console.log('🧪 COGN MCP TOOLS - COMPREHENSIVE TESTING SUITE');
  console.log('Testing all 21 tools with real data as requested');
  console.log('=' * 60);

  const isHealthy = await healthCheck();
  if (!isHealthy) {
    console.log('\n❌ Cannot proceed with testing - server not available');
    process.exit(1);
  }

  await runAllTests();
}

// Execute if run directly
if (require.main === module) {
  main().catch(console.error);
}

module.exports = { testTool, runAllTests, healthCheck };