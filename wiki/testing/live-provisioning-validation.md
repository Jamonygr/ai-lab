# Live provisioning validation

Use this guide for a disposable end-to-end Azure validation run. It provisions an extended-but-safe lab, runs static and live smoke tests, then destroys the resources and verifies deletion.

## Live profile

The automation script uses this profile by default:

| Area | Setting |
|------|---------|
| Environment | `livetest` |
| Region | `westeurope` |
| Enabled | Core platform, AIServices, Content Safety, AI Search, Document Intelligence, Static Web App, Monitor alerts |
| Disabled | Azure OpenAI, AI Foundry, private networking |
| Secret storage | Enabled |
| Deployer Key Vault RBAC | Enabled with `grant_deployer_key_vault_secret_permissions = true` |

Azure OpenAI, AI Foundry, and private endpoints are intentionally off because they are more likely to fail from quota, regional availability, DNS, or access constraints.

## Run the validation

Run from the repository root after `az login`:

```powershell
.\scripts\invoke-live-validation.ps1
```

Optional parameters:

```powershell
.\scripts\invoke-live-validation.ps1 -Location westeurope -Environment livetest
.\scripts\invoke-live-validation.ps1 -SubscriptionId "<subscription-id>"
.\scripts\invoke-live-validation.ps1 -KeepResources
.\scripts\invoke-live-validation.ps1 -SkipSmokeTests
```

The script refuses to run if `terraform.tfstate` already exists, unless `-AllowExistingState` is passed. Use that override only when the state belongs to the disposable live validation run.

## What the script does

1. Creates a temporary tfvars file outside the repository.
2. Runs Terraform format, init, validate, plan, and apply.
3. Creates or reuses `exercises/python/.venv` and installs Python requirements.
4. Runs Python unit tests, repo quality checks, and Go skip-safe tests.
5. Writes `exercises/python/.env` from Terraform outputs without printing secrets.
6. Runs the live resource group tag test.
7. Runs the default and extended-safe Python smoke tests.
8. Runs `terraform destroy` in cleanup unless `-KeepResources` is set.
9. Verifies the Azure resource group is gone and Terraform state is empty.
10. Removes generated exercise artifacts and restores any pre-existing `.env`.

## Smoke test matrix

| Script | Purpose |
|--------|---------|
| `00_setup_check.py` | Confirms required and optional environment values with secrets redacted. |
| `01_language_sentiment.py` | Calls Language sentiment analysis. |
| `02_language_pii_entities.py` | Calls entity recognition and PII detection. |
| `03_vision_ocr.py` | Calls Vision OCR. |
| `04_speech_basics.py` | Calls Speech and writes local audio evidence. |
| `05_translator.py` | Calls Translator through the AIServices account. |
| `06_content_safety.py` | Calls Content Safety text analysis. |
| `07_search_rag_optional.py` | Creates/uploads a small AI Search index and queries it. |
| `08_search_rag_advanced.py` | Creates a tiny hybrid/vector search index and queries it. |
| `09_document_intelligence_layout.py` | Calls Document Intelligence layout extraction against a sample PDF. |
| `10_vision_image_analysis.py` | Calls richer Vision analysis features. |
| `11_content_safety_guardrails.py` | Calls prompt shield and protected material checks. |
| `12_speech_pronunciation_assessment.py` | Calls Speech pronunciation assessment. |
| `13_foundry_agent_blueprint.py` | Prints the agent blueprint; model review is skipped because OpenAI is off. |
| `14_observability_evaluation.py` | Writes local evaluation evidence and reports telemetry configuration. |

## Failure handling

If a command fails, the script keeps logs under a temporary `ai-lab-live-validation-*` directory and still attempts `terraform destroy` when provisioning started.

If Key Vault secret writes fail with an authorization error, verify the deploying account can create role assignments. The script does not silently skip secret storage because live validation is meant to prove that path works.

## Teardown evidence

Capture these success signals:

- `terraform destroy` completes successfully.
- `az group exists --name <resource-group>` returns `false`.
- `terraform state list` returns no resources.
- Generated files such as `.env`, `speech-output.wav`, and `evaluation-output.jsonl` are absent or restored to their pre-run state.
