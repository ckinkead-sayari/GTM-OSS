# My Instance Config

This file contains all personal/instance-specific data for your claudeGTM instance.
Copy this template and fill in your values:
```bash
cp .claude/MY-CONFIG.template.md .claude/MY-CONFIG.md
```

Delete sections for tools / services you don't use.

## Who I Am

- **Name:** [Your name]
- **Role:** [Your role — e.g., Account Manager, Customer Success Manager]
- **Territory:** [Your territory — e.g., "North American Healthcare, mid-market"]
- **Accounts:** [Comma-separated list of your key accounts]

## Tool / Service IDs

Fill in only the tools you use. Delete the rest.

- **Email MCP:** [your email account — e.g., your.name@company.com]
- **Calendar MCP:** [same email, or separate if your setup differs]
- **CRM:** [e.g., Salesforce instance / HubSpot portal ID]
- **Product analytics:** [e.g., Mixpanel project ID + workspace ID, Amplitude project ID]
- **Enterprise search:** [e.g., Glean agent IDs, Coveo organization ID]
- **Chat:** [e.g., Slack workspace + DM channel ID for scheduled task outputs]
- **Docs:** [e.g., Notion workspace + Knowledge Base page ID]
- **Call recording:** [e.g., Gong workspace ID]
- **Git Repo Slug:** [your-username/your-fork-name]

## Account → Analytics Mapping (if you use a product analytics tool)

If you use Mixpanel / Amplitude / Heap for product usage telemetry, map each account to the identifier used there. Analytics tools often have BU-specific variants that differ from your CRM account name.

| Account | Analytics identifier(s) | Product Type | Notes |
|---------|--------------------------|-------------|-------|
| [Account 1] | `[identifier A]`, `[identifier B]` | [how you segment — e.g., Core / Platform / Self-Serve] | [e.g., "3 BU variants. Use contains."] |
| [Account 2] | `[identifier]` | [segment] | |

**Product Type determines health scoring approach:**
- **[Segment 1]** → Full analytics-based health scoring (Leading/Lagging/Context)
- **[Segment 2]** → Limited visibility (flag scoring reliability)

Delete this section entirely if you don't use a product analytics tool.

## CRM Database Schema Notes (if you mirror CRM data into a docs platform)

If you mirror account/deal/contact data from your CRM into Notion / Airtable / similar, document the fields here so Claude knows what to read:

```
Accounts database fields: [list]
Deals database fields: [stages, amounts, risk flags, close dates]
Contacts database fields: [people linked to accounts]
Sequences database fields: [Contact, Account, Type, Step, Status]
```

Delete this section if you don't mirror CRM data externally.

## Communication Style

Your email voice is defined in `knowledge/communication-playbook.md`.
If this file doesn't exist yet, create it by:
1. Gathering 30+ of your sent emails (mix of cold, warm, follow-up, internal)
2. Extract patterns: opening styles, closing styles, sentence length, tone markers
3. Document what you never say and what you always say
4. See `knowledge/communication-playbook.template.md` for the full guide
