# Lab testing guide

Use this checklist before and after deploying the lab.

## Static checks

Run from the repository root:

```powershell
terraform fmt -check -recursive
terraform init
terraform validate
```

Run Python tests:

```powershell
cd exercises/python
pip install -r requirements.txt
cd ../..
python -m pytest tests/python
```

For a disposable local environment from the repository root:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r exercises\python\requirements.txt
.\.venv\Scripts\python.exe -m pytest tests\python
```

## Policy checks

The `policies/` folder contains OPA/Rego examples for:

- Required tags.
- Approved regions.
- Storage public access.
- Cost-heavy optional resources.
- Secret-like values in Terraform plans.

If Conftest is installed:

```powershell
terraform plan -out tfplan
terraform show -json tfplan > tfplan.json
conftest test tfplan.json --policy policies
```

## Live checks

Live Go checks skip unless `ARM_SUBSCRIPTION_ID` and `AI_LAB_RESOURCE_GROUP` are set.

```powershell
$env:ARM_SUBSCRIPTION_ID = "<subscription-id>"
$env:AI_LAB_RESOURCE_GROUP = terraform output -raw resource_group_name
cd tests
go test ./...
cd ..
```

Expected live checks:

- Resource group exists.
- Required tags are present.
- Optional resources are checked only if matching environment variables are set.

## Exercise smoke test

After `terraform apply`, configure `exercises/python/.env` and run:

```powershell
python exercises/python/00_setup_check.py
python exercises/python/01_language_sentiment.py
python exercises/python/02_language_pii_entities.py
python exercises/python/03_vision_ocr.py
python exercises/python/04_speech_basics.py
python exercises/python/05_translator.py
python exercises/python/06_content_safety.py
```

Do not run `07_search_rag_optional.py` unless `deploy_ai_search = true` and `AI_SEARCH_ENDPOINT` plus `AI_SEARCH_KEY` are configured.

## Teardown check

Run:

```powershell
terraform destroy
```

Then confirm the lab resource group no longer exists.

```powershell
az group exists --name "<resource-group-name>"
terraform state list
```

Expected results:

- `az group exists` returns `false`.
- `terraform state list` prints no tracked resources.

## Current validation notes

The default path has been exercised successfully with Terraform 1.12.0, Azure CLI 2.83.0, Python 3.8, and AzureRM provider 4.77.0. Local Go execution requires Go to be installed; the GitHub Actions workflow installs Go for CI.
