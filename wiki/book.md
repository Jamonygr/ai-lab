# AI Lab book guide

This guide explains the lab in the order a beginner should use it.

## Chapter 1: The idea

AI Lab is a small Azure AI sandbox. Terraform creates the resources. Python scripts call the APIs. The wiki explains what each part is for and what evidence a learner should capture.

The default deployment avoids the biggest blockers for beginners:

- No Azure OpenAI requirement.
- No private networking requirement.
- No VM footprint.
- No production governance assumptions.

The lab is useful because it keeps the first pass concrete. Learners deploy real resources, call real endpoints, see real response payloads, and then tear the environment down.

## Chapter 2: Terraform shape

The root module owns the lab orchestration:

- `providers.tf` pins Terraform and provider versions.
- `variables.tf` exposes the Master Control Panel.
- `locals.tf` normalizes names, location abbreviations, and tags.
- `main.tf` calls the reusable modules.
- `outputs.tf` returns endpoints and resource names used by Python.

The modules are intentionally simple. Each module owns one service family and exposes only the outputs a beginner needs.

## Chapter 3: Default deployment

The first deployment creates:

- One resource group.
- One storage account.
- One Key Vault.
- One Log Analytics workspace.
- One Application Insights resource.
- One AIServices account.
- One Content Safety account.

This is enough to run the first six exercises.

Default observability resources use small daily caps so later app experiments do not accidentally create large telemetry bills.

## Chapter 4: Optional deployment

Enable optional components only when needed:

- `deploy_ai_search = true` for the optional Search/RAG exercise.
- `deploy_azure_openai = true` only when the subscription has model access and quota.
- `deploy_app_hosting = true` for a later web demo path.

## Chapter 5: Python exercises

The exercises are deliberately small:

1. Validate local setup.
2. Analyze sentiment.
3. Detect entities and PII.
4. Read text from an image.
5. Convert text to speech.
6. Translate text.
7. Review text with Content Safety.
8. Optionally search tiny documents.

Each script should be readable by a beginner without hiding the API call behind too much abstraction.

The shared helper `ai_lab_client.py` handles only repeated chores: loading `.env`, validating required variables, redacting keys, building API URLs, and sending JSON requests.

The setup flow is:

```powershell
cd exercises/python
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
```

Then fill `.env` from Terraform outputs.

## Chapter 6: Evidence

For learning or certification prep, capture:

- Terraform plan and apply summaries.
- Portal screenshots of the deployed services.
- Exercise output showing successful API calls.
- Notes about cost, quota, and responsible AI decisions.

## Chapter 7: Teardown

When finished, destroy the lab:

```powershell
terraform destroy
```

Then verify the resource group is gone in the Azure portal.

Also remove local state backups and saved plans after temporary validation runs because they can contain sensitive output values:

```powershell
Remove-Item -Force terraform.tfstate, terraform.tfstate.backup, *.tfplan -ErrorAction SilentlyContinue
```

## Chapter 8: Where to extend next

Good next increments are:

- Add private networking after the public endpoint workflow is understood.
- Store exercise keys in Key Vault and load them with managed identity.
- Enable Azure AI Search and compare keyword retrieval with grounded answers.
- Enable Azure OpenAI only after access, quota, and regional model support are confirmed.
- Add Document Intelligence as a separate module and exercise.
