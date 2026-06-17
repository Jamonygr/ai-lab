# Troubleshooting

Use this page when a setup, Terraform, Azure, or exercise step fails.

## Terraform

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `terraform init` cannot download providers | Network or registry access issue | Retry from a network that can reach `registry.terraform.io`. |
| `terraform validate` fails on provider schema | Init did not complete or lock file is stale | Run `terraform init -upgrade` and validate again. |
| Resource name already exists | Global Azure name collision or soft-deleted account | Rerun with a new random suffix by cleaning state only after confirmed no active resources exist. |
| Region not supported | Service or model not available in `ctx.location` | Change `ctx.location` to a supported region such as `eastus` or `eastus2`. |
| Azure OpenAI deployment fails | Missing access, quota, or model availability | Leave `deploy_azure_openai = false` until quota is confirmed. |
| Document Intelligence apply fails | Region or SKU is unavailable | Try another supported Azure AI region or keep `deploy_document_intelligence = false`. |
| Foundry apply fails | Provider, region, or connected-resource support differs | Keep `deploy_ai_foundry = false` and use the agent blueprint exercise offline. |
| Key Vault secrets fail | Terraform identity lacks secret permissions | Leave `store_service_keys_in_key_vault = false` or grant data-plane secret permissions. |
| Private endpoints make scripts fail | Local machine cannot resolve or reach private DNS | Re-enable public access for beginner scripts or run from a network joined to the VNet. |

## Azure authentication

Check the active account:

```powershell
az account show
```

Set the intended subscription:

```powershell
az account set --subscription "<subscription-id>"
```

Terraform AzureRM normally uses Azure CLI authentication for this lab. If Terraform cannot authenticate, sign in again with `az login`.

## Python setup

| Symptom | Fix |
|---------|-----|
| `No module named pytest` | Install dependencies with `pip install -r exercises/python/requirements.txt`. |
| `.env` values are missing | Copy `exercises/python/.env.example` to `.env` and fill values from Terraform outputs. |
| Requests return 401 | Check that the endpoint and key come from the same Azure AI resource. |
| Requests return 404 | Check endpoint shape and API version. Rerun `terraform output exercise_environment`. |
| Speech token request fails | Confirm `AZURE_AI_SERVICES_REGION` matches the deployment region. |

## Exercise-specific notes

### Language

Use `AZURE_AI_SERVICES_ENDPOINT` and `AZURE_AI_SERVICES_KEY`. The endpoint should look like:

```text
https://ais-<name>.cognitiveservices.azure.com/
```

### Vision OCR

The sample image is loaded from Microsoft Learn. If the URL is unreachable from your network, replace `image_url` with another public image URL that contains clear printed text.

### Speech

The speech exercise writes `exercises/python/speech-output.wav`. This file is ignored by git and can be deleted after testing.

### Translator

Translator uses the global Translator endpoint plus the Azure AI Services key and region:

```text
https://api.cognitive.microsofttranslator.com/translate
```

### Content Safety

Use `CONTENT_SAFETY_ENDPOINT` and `CONTENT_SAFETY_KEY`, not the main AIServices endpoint.

### Search/RAG

The Search exercise requires:

```hcl
deploy_ai_search = true
```

Then fill:

```text
AI_SEARCH_ENDPOINT
AI_SEARCH_KEY
AI_SEARCH_INDEX
```

Advanced RAG also uses `AI_SEARCH_ADVANCED_INDEX`. If vector index creation fails, confirm the Search service API supports vector fields in your region and SDK version.

### Document Intelligence

The Document Intelligence exercise requires:

```hcl
deploy_document_intelligence = true
```

Then fill:

```text
DOCUMENT_INTELLIGENCE_ENDPOINT
DOCUMENT_INTELLIGENCE_KEY
DOCUMENT_INTELLIGENCE_SAMPLE_URL
```

### Foundry agents

The agent blueprint works offline. The optional Azure OpenAI critique requires:

```text
AZURE_OPENAI_ENDPOINT
AZURE_OPENAI_KEY
AZURE_OPENAI_DEPLOYMENT
```

The optional Foundry identifiers come from:

```text
FOUNDRY_HUB_DISCOVERY_URL
FOUNDRY_PROJECT_ID
```

## Cleanup problems

If `terraform destroy` fails partway through:

1. Rerun `terraform destroy`.
2. Check the Azure portal for the resource group.
3. Delete only the lab resource group if it is clearly tagged `ManagedBy = Terraform` and `Lab = AI Lab`.
4. Run `terraform state list` to confirm whether Terraform still tracks resources.

Do not delete unrelated Azure resources just because they share a similar name.
