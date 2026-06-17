# Outputs reference

## Core outputs

| Output | Purpose |
|--------|---------|
| `resource_group_name` | Lab resource group. |
| `key_vault_name` | Key Vault for lab secrets and future hardening. |
| `storage_account_name` | Storage account for exercise data. |
| `log_analytics_workspace_name` | Monitoring workspace. |
| `application_insights_connection_string` | Sensitive app telemetry connection string. |

## Exercise outputs

| Output | Purpose |
|--------|---------|
| `ai_services_endpoint` | Endpoint for Language, Vision, Speech, and Translator exercises. |
| `ai_services_key` | Sensitive key for the main AIServices account. |
| `content_safety_endpoint` | Endpoint for Content Safety. |
| `content_safety_key` | Sensitive key for Content Safety. |
| `ai_search_endpoint` | Optional Azure AI Search endpoint. |
| `ai_search_admin_key` | Optional sensitive Search admin key. |
| `document_intelligence_endpoint` | Optional Document Intelligence endpoint. |
| `document_intelligence_key` | Optional sensitive Document Intelligence key. |
| `azure_openai_endpoint` | Optional Azure OpenAI endpoint. |
| `azure_openai_key` | Optional sensitive Azure OpenAI key. |
| `static_web_app_url` | Optional Static Web App hostname. |
| `foundry_hub_discovery_url` | Optional Foundry hub discovery URL. |
| `foundry_project_id` | Optional Foundry project resource ID. |
| `private_endpoint_ids` | Optional private endpoint IDs by target key. |
| `observability_alert_ids` | Optional Azure Monitor alert IDs by target key. |

## Environment helper

`exercise_environment` returns non-secret values that can be copied into `exercises/python/.env`.

Use separate `terraform output -raw ...` commands for keys because Terraform marks them sensitive.

Common setup commands:

```powershell
terraform output exercise_environment
terraform output -raw ai_services_key
terraform output -raw content_safety_key
```

Optional setup commands:

```powershell
terraform output -raw ai_search_admin_key
terraform output -raw document_intelligence_key
terraform output -raw azure_openai_key
```

Never paste raw key output into committed markdown, GitHub issues, pull requests, chat logs, or screenshots.
