# Chrome Automation Patterns — Knowledge Base

Best practices for scheduled tasks that use Chrome browser automation (Gong pipeline sync). Derived from Anthropic's computer use reference implementation and real-world task execution.

**NOTE (2026-03-26): Mixpanel has migrated to native Mixpanel MCP.** Chrome is no longer needed for Mixpanel. These patterns now apply to Gong deals board automation only.

## 1. Browser Setup (RUN FIRST)

Before any Chrome navigation, set the viewport to a consistent size. High-resolution or retina displays send oversized screenshots that reduce model accuracy on data-dense UIs.

**Required:** At the start of every Chrome automation task, resize the browser window:
- Target: **1280x800** (WXGA) — optimal balance of readability and model accuracy
- Use `resize_window` with `width: 1280, height: 800` before navigating
- This must happen before the first screenshot or navigation action

Why: Anthropic's computer use demo explicitly scales all screenshots down to XGA/WXGA before sending to the model. Resolutions above this range degrade accuracy, especially for reading numbers, small text, and table data.

## 2. Zoom for Data Extraction

When reading specific values from crowded UIs (deal amounts, metric numbers, table cells), don't rely on full-page screenshots. Use the zoom action to crop and inspect specific regions.

**Pattern:**
1. Take a full-page screenshot to orient
2. Identify the region containing the data you need
3. Use `zoom` with `region: [x0, y0, x1, y1]` to crop that region
4. Read the zoomed image for precise values

**When to zoom:**
- Gong deals board: deal amounts, stage labels, close dates in crowded card views
- Any table where columns are narrow or text is small
- When a full-page screenshot returned ambiguous or uncertain values

**When NOT to zoom:**
- Navigation (clicking buttons, tabs, menus) — full screenshots are fine
- Reading large text or page headers
- Confirming page state (logged in, correct page loaded)

## 3. Progress Checkpoints for Long-Running Tasks

Chrome automation tasks that process multiple accounts should write checkpoint state so interrupted tasks can resume.

**State file pattern:**
```json
{
  "task": "gong-pipeline-sync",
  "started_at": "2026-03-25T17:00:00Z",
  "status": "running",
  "step": "processing_accounts",
  "accounts_processed": ["Account_A", "Account_B", "Account_C"],
  "accounts_remaining": ["Account_D", "Account_G", "Account_K"],
  "last_checkpoint": "2026-03-25T17:04:30Z"
}
```

**File location:** `memory/task-state/{task-name}.json`

**Lifecycle:**
1. At task start: check for existing state file
   - If exists and `status: "running"` with `last_checkpoint` < 30 minutes ago → resume from last checkpoint
   - If exists and stale (> 30 min) → start fresh, overwrite state file
   - If not exists → start fresh, create state file
2. After each account/step: update `accounts_processed`, `accounts_remaining`, `last_checkpoint`
3. On successful completion: delete state file
4. On failure: leave state file for next run to resume

**Which tasks should use checkpoints:**
- `gong-pipeline-sync` — processes 14 accounts, takes 5-10 minutes
- No other scheduled tasks use Chrome (all migrated to native MCPs)

## 4. Parallel Account Research

When a task needs to research or look up data for multiple accounts (retros, staleness checks, briefings), structure the work to maximize parallel tool calls.

**Pattern:**
- Instead of researching accounts one at a time sequentially, batch independent lookups
- Example: when checking Notion for 5 account statuses, fire all 5 `notion-fetch` calls in a single message
- Chrome tasks can't parallelize (single browser), but non-Chrome lookups (Notion, Gmail, GCal) can

**Where this applies:**
- `pipeline-staleness-check`: checking multiple accounts' last activity in parallel
- `weekly-gtm-retro`: pulling account data from Notion in parallel
- `daily-gtm-briefing`: checking calendar + pipeline + usage signals in parallel
- Any interactive session doing multi-account research

## 5. Navigation Reliability

Tips for reliable Chrome navigation in Gong:

**Gong:**
- Navigate directly to the deals board URL rather than clicking through the UI
- Wait for page load after navigation (use `wait` action, 2-3 seconds)
- If the deals board has filters, verify the correct view is loaded before reading data
- Deal cards may be truncated — click into individual deals for full data when needed

**General:**
- Always take a screenshot after navigation to confirm the page loaded correctly
- If a page shows an auth wall or error, report it immediately rather than retrying blindly
- Use `find` to locate elements by description rather than guessing coordinates
- After clicking, wait briefly and screenshot to confirm the expected state change happened
