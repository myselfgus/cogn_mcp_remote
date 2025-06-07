-- 🗄️ COGN UNIFIED MCP SERVER - DATABASE SCHEMA
-- Advanced AI-powered development assistant with persistent memory
-- Designed for optimal performance with D1 and semantic search capabilities

-- ===== 🧠 KNOWLEDGE & MEMORY TABLES =====

-- File Knowledge Storage with AI Insights
CREATE TABLE IF NOT EXISTS file_knowledge (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT UNIQUE NOT NULL,
    content_hash TEXT NOT NULL,
    file_size INTEGER,
    language TEXT,
    insights TEXT, -- JSON: AI analysis, patterns, complexity metrics
    embedding_id TEXT, -- Reference to Vectorize embedding
    last_analyzed DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- File Operations History  
CREATE TABLE IF NOT EXISTS file_operations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL,
    operation TEXT NOT NULL, -- create, update, refactor, optimize
    instruction TEXT, -- Natural language instruction used
    result TEXT, -- JSON: operation result, optimizations applied
    user_id TEXT,
    success BOOLEAN DEFAULT TRUE,
    duration_ms INTEGER,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- System Command Executions
CREATE TABLE IF NOT EXISTS command_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    command TEXT NOT NULL,
    working_dir TEXT,
    result TEXT, -- JSON: stdout, stderr, exit_code
    impact_analysis TEXT, -- JSON: AI analysis of command impact
    safety_score REAL, -- 0.0 to 1.0 safety rating
    user_id TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    duration_ms INTEGER
);

-- Repository Analysis Cache
CREATE TABLE IF NOT EXISTS repository_analyses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    owner TEXT NOT NULL,
    repo TEXT NOT NULL,
    analysis_type TEXT NOT NULL, -- basic, full, strategic
    analysis_data TEXT, -- JSON: comprehensive analysis results
    trends TEXT, -- JSON: velocity, quality trends
    strategic_insights TEXT, -- JSON: high-level recommendations
    confidence_score REAL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME, -- Cache expiration
    UNIQUE(owner, repo, analysis_type)
);

-- Strategic Insights & Recommendations
CREATE TABLE IF NOT EXISTS strategic_insights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    domain TEXT NOT NULL, -- architecture, performance, security, business
    scope TEXT NOT NULL, -- Project or analysis scope
    timeframe TEXT NOT NULL, -- immediate, short_term, long_term
    insights TEXT, -- JSON: recommendations, risks, opportunities
    confidence REAL,
    user_id TEXT,
    project_context TEXT, -- JSON: relevant project information
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- User Sessions with Persistent Memory
CREATE TABLE IF NOT EXISTS user_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT UNIQUE NOT NULL,
    login TEXT NOT NULL,
    permissions TEXT, -- JSON: user permissions array
    preferences TEXT, -- JSON: user preferences object
    memory_graph TEXT, -- JSON: serialized memory graph
    last_activity DATETIME DEFAULT CURRENT_TIMESTAMP,
    session_start DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_sessions INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tool Usage Analytics
CREATE TABLE IF NOT EXISTS tool_usage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    tool_name TEXT NOT NULL,
    category TEXT NOT NULL, -- File System, Code Analysis, etc.
    parameters TEXT, -- JSON: input parameters
    result TEXT, -- JSON: tool output
    success BOOLEAN DEFAULT TRUE,
    error_message TEXT,
    duration_ms INTEGER,
    ai_confidence REAL, -- AI confidence in result
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===== 🔍 SEMANTIC SEARCH & EMBEDDINGS =====

-- Semantic Memory Storage
CREATE TABLE IF NOT EXISTS semantic_memory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    content_type TEXT, -- code, text, documentation, issue, etc.
    embedding_id TEXT, -- Reference to Vectorize
    tags TEXT, -- JSON: array of tags
    metadata TEXT, -- JSON: additional context
    user_id TEXT,
    relevance_score REAL,
    access_count INTEGER DEFAULT 0,
    last_accessed DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Knowledge Graph Entities
CREATE TABLE IF NOT EXISTS knowledge_entities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL, -- file, function, class, concept, etc.
    entity_name TEXT NOT NULL,
    properties TEXT, -- JSON: entity properties
    embedding_id TEXT,
    user_id TEXT,
    project_context TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(entity_type, entity_name, user_id)
);

-- Knowledge Graph Relationships
CREATE TABLE IF NOT EXISTS knowledge_relationships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_entity_id INTEGER NOT NULL,
    target_entity_id INTEGER NOT NULL,
    relationship_type TEXT NOT NULL, -- depends_on, implements, calls, etc.
    strength REAL DEFAULT 1.0, -- Relationship strength 0.0 to 1.0
    properties TEXT, -- JSON: relationship metadata
    user_id TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_entity_id) REFERENCES knowledge_entities(id),
    FOREIGN KEY (target_entity_id) REFERENCES knowledge_entities(id),
    UNIQUE(source_entity_id, target_entity_id, relationship_type)
);

-- ===== 🔒 SECURITY & ACCESS CONTROL =====

-- Zero Trust Policy Analysis
CREATE TABLE IF NOT EXISTS zero_trust_analyses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    scope TEXT NOT NULL, -- network, applications, devices, users, all
    configuration TEXT, -- JSON: current ZT configuration
    analysis_results TEXT, -- JSON: security analysis
    recommendations TEXT, -- JSON: improvement recommendations
    risk_score REAL, -- 0.0 to 1.0 risk assessment
    user_id TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Security Event Monitoring
CREATE TABLE IF NOT EXISTS security_events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_type TEXT NOT NULL,
    event_data TEXT, -- JSON: event details
    threat_patterns TEXT, -- JSON: identified threat patterns
    severity TEXT NOT NULL, -- low, medium, high, critical
    analysis TEXT, -- JSON: AI analysis of event
    resolved BOOLEAN DEFAULT FALSE,
    user_id TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===== 📊 PERFORMANCE & OPTIMIZATION =====

-- Performance Metrics & Monitoring
CREATE TABLE IF NOT EXISTS performance_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    metric_type TEXT NOT NULL, -- response_time, memory_usage, ai_inference, etc.
    metric_value REAL NOT NULL,
    context TEXT, -- JSON: measurement context
    user_id TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- AI Reasoning Session History
CREATE TABLE IF NOT EXISTS reasoning_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    problem_description TEXT NOT NULL,
    strategy TEXT NOT NULL, -- sequential, beam_search, mcts
    steps TEXT, -- JSON: reasoning steps taken
    conclusion TEXT,
    confidence REAL,
    duration_ms INTEGER,
    user_id TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===== 🔧 INDEXES FOR PERFORMANCE =====

-- Primary indexes for fast lookups
CREATE INDEX IF NOT EXISTS idx_file_knowledge_path ON file_knowledge(path);
CREATE INDEX IF NOT EXISTS idx_file_knowledge_language ON file_knowledge(language);
CREATE INDEX IF NOT EXISTS idx_file_knowledge_updated ON file_knowledge(updated_at);

CREATE INDEX IF NOT EXISTS idx_file_operations_path ON file_operations(path);
CREATE INDEX IF NOT EXISTS idx_file_operations_user ON file_operations(user_id);
CREATE INDEX IF NOT EXISTS idx_file_operations_timestamp ON file_operations(timestamp);

CREATE INDEX IF NOT EXISTS idx_command_executions_user ON command_executions(user_id);
CREATE INDEX IF NOT EXISTS idx_command_executions_timestamp ON command_executions(timestamp);

CREATE INDEX IF NOT EXISTS idx_repository_analyses_repo ON repository_analyses(owner, repo);
CREATE INDEX IF NOT EXISTS idx_repository_analyses_type ON repository_analyses(analysis_type);
CREATE INDEX IF NOT EXISTS idx_repository_analyses_expires ON repository_analyses(expires_at);

CREATE INDEX IF NOT EXISTS idx_strategic_insights_domain ON strategic_insights(domain);
CREATE INDEX IF NOT EXISTS idx_strategic_insights_user ON strategic_insights(user_id);
CREATE INDEX IF NOT EXISTS idx_strategic_insights_created ON strategic_insights(created_at);

CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_activity ON user_sessions(last_activity);

CREATE INDEX IF NOT EXISTS idx_tool_usage_user_tool ON tool_usage(user_id, tool_name);
CREATE INDEX IF NOT EXISTS idx_tool_usage_category ON tool_usage(category);
CREATE INDEX IF NOT EXISTS idx_tool_usage_timestamp ON tool_usage(timestamp);
CREATE INDEX IF NOT EXISTS idx_tool_usage_success ON tool_usage(success);

CREATE INDEX IF NOT EXISTS idx_semantic_memory_type ON semantic_memory(content_type);
CREATE INDEX IF NOT EXISTS idx_semantic_memory_user ON semantic_memory(user_id);
CREATE INDEX IF NOT EXISTS idx_semantic_memory_accessed ON semantic_memory(last_accessed);

CREATE INDEX IF NOT EXISTS idx_knowledge_entities_type ON knowledge_entities(entity_type);
CREATE INDEX IF NOT EXISTS idx_knowledge_entities_name ON knowledge_entities(entity_name);
CREATE INDEX IF NOT EXISTS idx_knowledge_entities_user ON knowledge_entities(user_id);

CREATE INDEX IF NOT EXISTS idx_knowledge_relationships_source ON knowledge_relationships(source_entity_id);
CREATE INDEX IF NOT EXISTS idx_knowledge_relationships_target ON knowledge_relationships(target_entity_id);
CREATE INDEX IF NOT EXISTS idx_knowledge_relationships_type ON knowledge_relationships(relationship_type);

CREATE INDEX IF NOT EXISTS idx_zero_trust_scope ON zero_trust_analyses(scope);
CREATE INDEX IF NOT EXISTS idx_zero_trust_risk ON zero_trust_analyses(risk_score);

CREATE INDEX IF NOT EXISTS idx_security_events_type ON security_events(event_type);
CREATE INDEX IF NOT EXISTS idx_security_events_severity ON security_events(severity);
CREATE INDEX IF NOT EXISTS idx_security_events_resolved ON security_events(resolved);
CREATE INDEX IF NOT EXISTS idx_security_events_timestamp ON security_events(timestamp);

CREATE INDEX IF NOT EXISTS idx_performance_metrics_type ON performance_metrics(metric_type);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_timestamp ON performance_metrics(timestamp);

CREATE INDEX IF NOT EXISTS idx_reasoning_sessions_strategy ON reasoning_sessions(strategy);
CREATE INDEX IF NOT EXISTS idx_reasoning_sessions_user ON reasoning_sessions(user_id);

-- ===== 🔧 TRIGGERS FOR AUTO-MAINTENANCE =====

-- Auto-update timestamps
CREATE TRIGGER IF NOT EXISTS trigger_file_knowledge_updated
AFTER UPDATE ON file_knowledge
BEGIN
    UPDATE file_knowledge SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS trigger_knowledge_entities_updated
AFTER UPDATE ON knowledge_entities
BEGIN
    UPDATE knowledge_entities SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Auto-increment session activity
CREATE TRIGGER IF NOT EXISTS trigger_user_sessions_activity
AFTER UPDATE ON user_sessions
BEGIN
    UPDATE user_sessions SET last_activity = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Auto-increment access count for semantic memory
CREATE TRIGGER IF NOT EXISTS trigger_semantic_memory_access
AFTER UPDATE ON semantic_memory
BEGIN
    UPDATE semantic_memory 
    SET access_count = access_count + 1, last_accessed = CURRENT_TIMESTAMP 
    WHERE id = NEW.id AND NEW.last_accessed > OLD.last_accessed;
END;

-- ===== 📋 INITIAL DATA SETUP =====

-- Insert default performance metric types
INSERT OR IGNORE INTO performance_metrics (metric_type, metric_value, context, timestamp)
VALUES 
    ('server_startup', 0, '{"event": "schema_created"}', CURRENT_TIMESTAMP),
    ('database_version', 1.0, '{"schema_version": "1.0.0"}', CURRENT_TIMESTAMP);

-- Create default admin insights
INSERT OR IGNORE INTO strategic_insights (domain, scope, timeframe, insights, confidence, user_id, created_at)
VALUES (
    'system',
    'cogn_mcp_server',
    'immediate',
    '{"status": "initialized", "message": "Cogn Unified MCP Server database schema created successfully", "capabilities": ["20_specialized_tools", "persistent_memory", "semantic_search", "ai_reasoning", "zero_trust_integration"]}',
    1.0,
    'system',
    CURRENT_TIMESTAMP
);

-- ===== 📊 SCHEMA METADATA =====

-- Store schema version and metadata
CREATE TABLE IF NOT EXISTS schema_metadata (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT OR REPLACE INTO schema_metadata (key, value) VALUES 
    ('version', '1.0.0'),
    ('created_at', datetime('now')),
    ('server_name', 'Cogn Unified MCP Server'),
    ('total_tables', '15'),
    ('total_indexes', '25'),
    ('capabilities', '["file_operations", "code_analysis", "github_integration", "ai_reasoning", "memory_management", "system_integration", "zero_trust_security"]');

-- ===== ✅ SCHEMA VALIDATION =====

-- Validate schema was created successfully
SELECT 
    'Schema created successfully!' as status,
    COUNT(*) as total_tables
FROM sqlite_master 
WHERE type = 'table' AND name NOT LIKE 'sqlite_%';

-- Display all created tables
SELECT 
    name as table_name,
    type
FROM sqlite_master 
WHERE type IN ('table', 'index') 
    AND name NOT LIKE 'sqlite_%'
ORDER BY type, name;