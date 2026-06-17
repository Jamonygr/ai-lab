# Variables reference

## Lab context

| Variable | Default | Purpose |
|----------|---------|---------|
| `ctx.project` | `ailab` | Short internal project name for Azure resources. |
| `ctx.location` | `westeurope` | Azure region in lowercase format. |
| `ctx.environment` | `lab` | Environment suffix. |
| `ctx.owner` | `Your Name` | Owner tag value. |
| `ctx.tags` | `{}` | Extra tags merged with required tags. |

## Master Control Panel

| Variable | Default | Purpose |
|----------|---------|---------|
| `deploy_ai_services` | `true` | Main Foundry Tools / AIServices account. |
| `deploy_content_safety` | `true` | Content Safety account. |
| `deploy_ai_search` | `false` | Optional Azure AI Search for RAG. |
| `deploy_azure_openai` | `false` | Optional Azure OpenAI account and model deployment. |
| `deploy_app_hosting` | `false` | Optional Static Web App placeholder. |
| `enable_public_network_access` | `true` | Public endpoints for beginner local scripts. |
| `enable_foundry_project_management` | `true` | Enables project management on the AIServices account where supported. |

Recommended first-run values:

```hcl
deploy_ai_services    = true
deploy_content_safety = true
deploy_ai_search      = false
deploy_azure_openai   = false
deploy_app_hosting    = false
```

Optional features should be enabled one at a time so failures are easy to isolate.

## SKU variables

| Variable | Default | Notes |
|----------|---------|-------|
| `ai_services_sku_name` | `S0` | Pay-as-you-go AI services SKU. |
| `content_safety_sku_name` | `S0` | Content Safety SKU. |
| `ai_search_sku` | `free` | Keep free for beginner exercises. |
| `openai_sku_name` | `S0` | Azure OpenAI account SKU. |

## Azure OpenAI variables

Only matter when `deploy_azure_openai = true`.

| Variable | Default |
|----------|---------|
| `openai_deployment_name` | `gpt-4o-mini-lab` |
| `openai_model_name` | `gpt-4o-mini` |
| `openai_model_version` | `2024-07-18` |
| `openai_model_capacity` | `1` |

Azure OpenAI availability is subscription, quota, model, and region dependent. A valid Terraform configuration can still fail during apply when the subscription does not have access to the requested model in the selected region.
