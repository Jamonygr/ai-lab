# Module guide

Each Terraform module is intentionally small and beginner-readable.

| Module | Responsibility |
|--------|----------------|
| `modules/core` | Resource group, storage, Key Vault, Log Analytics, Application Insights |
| `modules/foundry-services` | Main AIServices account for Foundry Tools exercises |
| `modules/content-safety` | Content Safety account |
| `modules/search` | Optional Azure AI Search service |
| `modules/document-intelligence` | Optional Document Intelligence account |
| `modules/openai` | Optional Azure OpenAI account and model deployment |
| `modules/foundry` | Optional Azure AI Foundry hub and project |
| `modules/app-hosting` | Optional Static Web App placeholder |
| `modules/private-networking` | Optional private endpoint network, DNS zones, and endpoints |
| `modules/observability` | Optional Azure Monitor call-volume alerts |

## Design rules

- Modules should own one service family.
- Root variables control whether optional modules deploy.
- Outputs should expose only what learners need for exercises.
- Secrets may be output as sensitive values, but should not be written to files.
- Defaults should favor short-lived lab use over production completeness.
- Cost caps belong in the default path when they do not make beginner exercises harder.

## Module contracts

| Module | Inputs to watch | Outputs used by learners |
|--------|-----------------|--------------------------|
| `core` | Names, location, tags | Resource group, storage, Key Vault, monitoring names |
| `foundry-services` | SKU, public network access, project management | Endpoint and key for Language, Vision, Speech, Translator |
| `content-safety` | SKU and public network access | Endpoint and key for Content Safety |
| `search` | SKU, semantic ranker setting, public access | Endpoint and admin key for optional Search/RAG |
| `document-intelligence` | SKU and public network access | Endpoint and key for document extraction |
| `openai` | Model name, version, capacity | Endpoint and key for optional model calls |
| `foundry` | Core resource IDs and public access | Hub discovery URL and project ID |
| `app-hosting` | Name and tags | Static Web App hostname |
| `private-networking` | Private endpoint targets and CIDR ranges | VNet, subnet, and endpoint IDs |
| `observability` | Cognitive account targets and call threshold | Metric alert IDs |
