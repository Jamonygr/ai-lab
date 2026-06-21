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
| `deploy_document_intelligence` | `false` | Optional Document Intelligence account. |
| `deploy_azure_openai` | `false` | Optional Azure OpenAI account and model deployment. |
| `deploy_ai_foundry` | `false` | Optional Foundry hub and project. |
| `deploy_app_hosting` | `false` | Optional Static Web App placeholder. |
| `deploy_private_networking` | `false` | Optional VNet, private DNS, and private endpoints. |
| `deploy_observability_alerts` | `false` | Optional Azure Monitor call-volume alerts. |
| `store_service_keys_in_key_vault` | `false` | Optional Key Vault secret storage for service keys. |
| `grant_deployer_key_vault_secret_permissions` | `false` | Optional Key Vault Secrets Officer role assignment for the current Terraform deployer during live validation. |
| `enable_public_network_access` | `true` | Public endpoints for beginner local scripts. |
| `enable_foundry_project_management` | `true` | Enables project management on the AIServices account where supported. |

Recommended first-run values:

```hcl
deploy_ai_services    = true
deploy_content_safety = true
deploy_ai_search      = false
deploy_document_intelligence = false
deploy_azure_openai   = false
deploy_ai_foundry     = false
deploy_app_hosting    = false
```

Optional features should be enabled one at a time so failures are easy to isolate.

## SKU variables

| Variable | Default | Notes |
|----------|---------|-------|
| `ai_services_sku_name` | `S0` | Pay-as-you-go AI services SKU. |
| `content_safety_sku_name` | `S0` | Content Safety SKU. |
| `ai_search_sku` | `free` | Keep free for beginner exercises. |
| `ai_search_semantic_search_sku` | empty | Keep empty unless enabling semantic ranker on a supported tier. |
| `document_intelligence_sku_name` | `S0` | Document Intelligence SKU. |
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

## Security and observability variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `private_network_address_space` | `["10.42.0.0/16"]` | CIDR range for the optional private endpoint VNet. |
| `private_endpoint_subnet_prefixes` | `["10.42.1.0/24"]` | Subnet prefixes for private endpoints. |
| `observability_total_calls_threshold` | `100` | Total calls alert threshold over the monitor window. |

`store_service_keys_in_key_vault = true` requires the Terraform identity to have Key Vault data-plane permissions for secrets because the lab Key Vault uses RBAC authorization. For disposable live validation runs, set `grant_deployer_key_vault_secret_permissions = true` so Terraform assigns the current deployer `Key Vault Secrets Officer` on the lab Key Vault before writing secrets.
