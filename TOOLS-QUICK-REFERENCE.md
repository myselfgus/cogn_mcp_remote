# 🚀 Zeo MCP Tools - Quick Reference

## 📋 Tools by Category

### 🧠 Reasoning & Intelligence
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `unified_reasoner` | Multi-strategy reasoning | `problem`, `strategy`, `beam_width` |
| `strategic_intelligence` | Strategic analysis | `domain`, `scope`, `timeframe` |
| `pattern_intelligence` | Pattern detection | `source_path`, `pattern_types`, `include_refactoring` |
| `decision_engine` | Multi-criteria decisions | `decision_context`, `criteria`, `options`, `weights` |

### 📂 Smart File System
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `intelligent_file_ops` | AI file operations | `operation`, `paths`, `content`, `include_analysis` |
| `codebase_navigator` | Codebase exploration | `root_path`, `action`, `depth` |
| `project_analyzer` | Project health | `project_path`, `analysis_type`, `include_metrics` |
| `content_transformer` | Content transformation | `source`, `transformation`, `target_format` |

### 🔗 External Integration
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `github_orchestrator` | GitHub operations | `action`, `owner`, `repo`, `number` |
| `web_intelligence` | Web analysis | `url`, `action`, `extract_type`, `analysis_depth` |
| `system_commander` | System commands | `operation`, `command`, `timeout` |

### 💾 Memory & Knowledge
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `persistent_memory_engine` | Memory management | `action`, `content`, `query`, `tags` |
| `dynamic_context_manager` | Context handling | `action`, `session_id`, `context_data` |
| `knowledge_graph_navigator` | Graph operations | `action`, `entity_type`, `relationship_type` |
| `insight_aggregator` | Analytics | `action`, `data_sources`, `time_window` |

### ⚡ Performance & Operations
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `performance_optimizer` | Performance tuning | `target`, `action`, `optimization_level` |
| `workflow_automator` | Workflow orchestration | `action`, `workflow_name`, `steps`, `trigger` |

### 🔒 Security
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `security_guardian` | Security analysis | `action`, `target`, `scan_type`, `compliance_framework` |

### 🎨 Development Experience
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `dev_assistant` | Development aid | `action`, `language`, `code_input`, `requirements` |
| `genai_scripter` | Script generation | `action`, `script_type`, `target_platform` |
| `functional_architect` | Functional design | `action`, `domain_context`, `data_flow` |

### 🆕 Creative Intelligence
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `ideation_engine` | Creative brainstorming | `seed_concept`, `creativity_mode`, `constraints` |
| `implementation_bridge` | Tool output translation | `source_tool_output`, `target_format`, `optimization_level` |

---

## 🎯 Common Patterns

### Pipeline Structure
All tools follow: **Input → Processing → Analysis → Output**

### Confidence Scoring
- **Randomized**: 0.2-1.0 with algorithms
- **Fixed**: 0.85 for strategic operations
- **Calculated**: Based on complexity factors
- **Composable**: Inherits from source tools

### Performance Levels
- **Quick**: <30s, basic analysis
- **Comprehensive**: 1-3min, full analysis
- **Real-time**: <100ms, immediate results

### Safety Features
- **Command Validation**: Dangerous command blocking
- **Input Validation**: Schema-based validation
- **Error Handling**: Graceful failure handling
- **Timeout Protection**: Configurable timeouts

---

## 🔧 Usage Examples

### Quick Start Commands
```typescript
// Strategic analysis
strategic_intelligence({
  domain: "architecture",
  scope: "microservices migration",
  timeframe: "short_term"
})

// Code analysis  
pattern_intelligence({
  source_path: "./src",
  pattern_types: ["design_patterns", "anti_patterns"],
  include_refactoring: true
})

// Creative ideation
ideation_engine({
  seed_concept: "real-time collaboration",
  creativity_mode: "divergent",
  alternatives_count: 7
})

// Implementation bridge
implementation_bridge({
  source_tool_output: strategic_analysis_result,
  source_tool_name: "strategic_intelligence", 
  target_format: "typescript",
  optimization_level: "maintainable"
})
```

### Common Workflows
1. **Problem → Analysis → Implementation**
   - `unified_reasoner` → `strategic_intelligence` → `implementation_bridge`

2. **Code → Analysis → Refactoring**
   - `codebase_navigator` → `pattern_intelligence` → `content_transformer`

3. **Idea → Validation → Implementation**
   - `ideation_engine` → `decision_engine` → `dev_assistant`

---

## 📊 Performance Guide

### High Performance Tools (< 1s)
- `unified_reasoner` (beam_width: 1-3)
- `decision_engine` (< 5 options)
- `intelligent_file_ops` (single file)

### Medium Performance Tools (1-30s)
- `project_analyzer` (quick mode)
- `github_orchestrator` (single repo)
- `web_intelligence` (basic analysis)

### Comprehensive Tools (30s-3min)
- `project_analyzer` (comprehensive)
- `security_guardian` (full scan)
- `performance_optimizer` (system-wide)

### Optimization Tips
- Use appropriate `depth` parameters
- Choose `basic` vs `comprehensive` analysis
- Batch operations when possible
- Set appropriate timeouts

---

## 🚨 Safety & Best Practices

### Blocked Operations
- `rm -rf` commands
- `format` operations  
- `shutdown` commands
- Dangerous system modifications

### Recommended Practices
- Always use `include_analysis: true` for insights
- Set reasonable `timeout` values
- Use `preserve_intent: true` for translations
- Apply appropriate `optimization_level`

### Error Handling
- All tools return structured error responses
- Confidence scores indicate reliability
- Failed operations return `confidence: 0.0`
- Graceful degradation for partial failures

---

**Total: 23 enterprise-grade AI tools ready for production use** 🎉