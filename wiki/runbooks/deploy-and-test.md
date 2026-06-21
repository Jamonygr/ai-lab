# Deploy and test runbook

Use this runbook for a complete beginner-safe validation pass. The default deployment creates the core platform, AIServices, and Content Safety. Optional Search, OpenAI, and app hosting stay off until you enable them.

For an automated extended-safe provision, smoke test, and destroy pass, see [Live provisioning validation](../testing/live-provisioning-validation.md).

## 1. Prerequisites

Install and sign in:

```powershell
az login
az account set --subscription "<subscription-id>"
terraform version
python --version
```

Use Terraform 1.9 or later and Python 3.8 or later. Go is only needed for the optional live resource group test in `tests/`.

## 2. Configure variables

Copy the example values and update the owner tag:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
notepad terraform.tfvars
```

First-run settings should normally stay:

```hcl
deploy_ai_services    = true
deploy_content_safety = true
deploy_ai_search      = false
deploy_document_intelligence = false
deploy_azure_openai   = false
deploy_ai_foundry     = false
deploy_app_hosting    = false
deploy_private_networking = false
deploy_observability_alerts = false
```

## 3. Validate before apply

Run from the repository root:

```powershell
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan -out ai-lab.tfplan
```

Review the plan before applying. A default run should create a resource group, storage account, Key Vault, Log Analytics workspace, Application Insights, AIServices account, Content Safety account, and random suffix.

## 4. Apply

```powershell
terraform apply ai-lab.tfplan
```

Capture the outputs:

```powershell
terraform output resource_group_name
terraform output exercise_environment
terraform output -raw ai_services_key
terraform output -raw content_safety_key
```

Do not paste raw keys into screenshots, issues, pull requests, or wiki pages.

## 5. Configure Python exercises

```powershell
cd exercises/python
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
notepad .env
cd ../..
```

Fill `.env` from Terraform outputs. Keep `.env` local.

## 6. Run smoke tests

```powershell
.\exercises\python\.venv\Scripts\python.exe exercises\python\00_setup_check.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\01_language_sentiment.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\02_language_pii_entities.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\03_vision_ocr.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\04_speech_basics.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\05_translator.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\06_content_safety.py
```

Expected results:

| Script | Success signal |
|--------|----------------|
| `00_setup_check.py` | Required values print with keys redacted. |
| `01_language_sentiment.py` | Sentiment result returns `positive`, `neutral`, or `negative`. |
| `02_language_pii_entities.py` | Entities and PII arrays return. |
| `03_vision_ocr.py` | OCR read results return text blocks. |
| `04_speech_basics.py` | `speech-output.wav` is written locally. |
| `05_translator.py` | German and French translations return. |
| `06_content_safety.py` | Category severity values return. |

## 7. Optional Search/RAG

Only after the default lab works:

```hcl
deploy_ai_search = true
```

Apply again, add `AI_SEARCH_ENDPOINT` and `AI_SEARCH_KEY` to `.env`, then run:

```powershell
.\exercises\python\.venv\Scripts\python.exe exercises\python\07_search_rag_optional.py
```

The script creates or updates a tiny index named by `AI_SEARCH_INDEX`, uploads sample documents, and prints top search results.

Run the advanced RAG exercise after the simple Search exercise works:

```powershell
.\exercises\python\.venv\Scripts\python.exe exercises\python\08_search_rag_advanced.py
```

## 8. Optional Document Intelligence

Enable:

```hcl
deploy_document_intelligence = true
```

Apply again, add `DOCUMENT_INTELLIGENCE_ENDPOINT` and `DOCUMENT_INTELLIGENCE_KEY` to `.env`, then run:

```powershell
.\exercises\python\.venv\Scripts\python.exe exercises\python\09_document_intelligence_layout.py
```

## 9. Optional advanced AI scenarios

These use default services unless noted:

```powershell
.\exercises\python\.venv\Scripts\python.exe exercises\python\10_vision_image_analysis.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\11_content_safety_guardrails.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\12_speech_pronunciation_assessment.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\13_foundry_agent_blueprint.py
.\exercises\python\.venv\Scripts\python.exe exercises\python\14_observability_evaluation.py
```

Use `deploy_ai_foundry = true` for Foundry infrastructure and `deploy_observability_alerts = true` for call-volume alerts.

## 10. Live Azure tag check

If Go is installed:

```powershell
$env:ARM_SUBSCRIPTION_ID = "<subscription-id>"
$env:AI_LAB_RESOURCE_GROUP = terraform output -raw resource_group_name
cd tests
go test ./...
cd ..
```

The test skips when environment variables are not set.

## 11. Finish with teardown

Follow [Teardown runbook](teardown.md) after every temporary validation run.
