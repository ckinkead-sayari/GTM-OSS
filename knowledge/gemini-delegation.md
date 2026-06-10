# Gemini CLI Delegation Patterns

## Overview

Gemini CLI (`gemini` v0.35.1) runs as a sub-agent for two remaining use cases: Google Drive/Docs operations and large-context repo analysis. All other operations have migrated to native MCPs.

**Migrated (do NOT use Gemini for these):**
- Gmail → Gmail MCP (`gmail_search_messages`, `gmail_read_message`, `gmail_create_draft`)
- Calendar → GCal MCP (`gcal_list_events`, `gcal_get_event`, `gcal_find_meeting_times`)
- Mixpanel → Mixpanel MCP (`Run-Query`, `Get-Events`)
- Cross-source search → Glean MCP (`search`, `chat`, `read_document`)

## Command Syntax

### Core Flags

| Flag | Purpose | When to Use |
|------|---------|-------------|
| `-p "prompt"` | Headless mode (required) | Always — never run interactive |
| `-o json` | JSON output | When Claude needs to parse results |
| `-o text` | Text output | When output is for human consumption |
| `-o stream-json` | Streaming JSON | For large responses |
| `-y` / `--yolo` | Auto-approve all actions | For scheduled tasks only |
| `--approval-mode auto_edit` | Auto-approve edits only | When creating Docs/Drafts |

### Google Drive Patterns

**Search for documents:**
```bash
gemini -p "Search my Google Drive for documents about [topic]. Return file names, file types, last modified dates, and the first few sentences of each." -o json
```

**Find PRDs/specs before building:**
```bash
gemini -p "Search Google Drive for any PRD, product spec, or requirements document related to [feature/project]. List all matches with their locations." -o json
```

**Read a specific document:**
```bash
gemini -p "Find and read the Google Doc titled '[document name]'. Summarize its key sections and action items." -o text
```

### Large-Context Repo Analysis

**Full repo scan:**
```bash
gemini -p "Scan this entire repository and identify all files that reference [pattern/concept]. List each file with the relevant lines." -o json
```

**Architecture review:**
```bash
gemini -p "Analyze the architecture of this repository. What are the main modules, how do they interact, and what patterns are used?" -o text
```

**Find implementation patterns:**
```bash
gemini -p "Search this entire codebase for how [pattern] is implemented. Show examples from different files." -o json
```

### Google Docs Creation

**Draft release notes:**
```bash
gemini -p "Create a Google Doc titled 'Release Notes - [date]' with the following content: [content]. Save it to my Drive." --approval-mode auto_edit
```

**Draft meeting notes:**
```bash
gemini -p "Create a Google Doc titled '[Meeting] Notes - [date]' summarizing: [bullet points]. Save to Drive." --approval-mode auto_edit
```

## Error Handling

### Auth Expired
If Gemini returns an authentication error or prompts for login:
1. Stop the current workflow
2. Tell YOUR-NAME: "Gemini auth has expired. Run `gemini` in terminal to re-authenticate via browser."
3. Do NOT retry until YOUR-NAME confirms auth is fixed
4. Fall back to Chrome MCP or Claude native tools if the task is urgent

### Empty/Null Response
If Gemini returns empty results:
1. Try rephrasing the query with more specific terms
2. If still empty, the data may not exist — report to YOUR-NAME
3. Do NOT hallucinate results

### Timeout
Gemini headless calls should complete in <30 seconds. If a call hangs:
1. The query may be too broad — narrow it
2. Network may be down — try a simple test: `gemini -p "Hello" -o text`
3. Fall back to Chrome MCP

## Token Cost Comparison

| Operation | Chrome MCP (screenshots) | Gemini Delegation | Native MCP (current) |
|-----------|-------------------------|-------------------|---------------------|
| Gmail search | 5-10 screenshots = 15-30K tokens | 1 bash call = ~500 tokens | Gmail MCP = ~200-500 tokens ✅ |
| Calendar lookup | 3-5 screenshots = 10-20K tokens | 1 bash call = ~500 tokens | GCal MCP = ~200-500 tokens ✅ |
| Mixpanel usage | 5-10 screenshots = 15-30K tokens | N/A | Mixpanel MCP = ~500-2K tokens ✅ |
| Drive search | Not available via Chrome | 1 bash call = ~500 tokens | Glean MCP = ~500-1K tokens ✅ |
| Full repo scan | Not feasible (context limits) | Gemini handles with 2M context | N/A (Gemini still best) |
| Read a Google Doc | 3-8 screenshots = 10-25K tokens | 1 bash call = ~500 tokens | Glean `read_document` = ~500-1K tokens ✅ |

## Retained Use Cases

Gemini CLI is used by the claudeGTM system for exactly two things:

1. **Google Docs creation** — drafting documents to Google Drive (no native Docs MCP yet)
2. **Large-context repo analysis** — 2M token context window for full codebase scans

All scheduled tasks now use native MCPs. Gemini CLI is only invoked during interactive sessions when these two use cases arise.
