# CI/CD checks

The GitHub Actions workflow keeps the repository safe without creating Azure resources.

## Jobs

| Job | What it checks |
|-----|----------------|
| `terraform` | `terraform fmt -check -recursive`, `terraform init -backend=false`, and `terraform validate`. |
| `python` | Installs exercise dependencies and runs `tests/python`. |
| `repo-quality` | Runs `scripts/check_lab_quality.py` for local markdown links, generated artifacts, secret-like values, and guidance to avoid Prompt Flow classic in new labs. |
| `go-live-skip-safe` | Runs Go tests; live Azure checks skip unless environment variables are set. |

## Why CI does not apply Terraform

CI does not run `terraform apply` because the lab can create billable Azure resources and requires subscription credentials. Use the deploy runbook for live validation.

For a local disposable live run that provisions, smoke tests, and destroys the extended-safe profile, use [Live provisioning validation](../testing/live-provisioning-validation.md).

## Local pre-push checklist

```powershell
terraform fmt -check -recursive
terraform validate
.\.venv\Scripts\python.exe -m pytest tests\python
python scripts\check_lab_quality.py
```

Optional live checks:

```powershell
terraform plan -out tfplan
terraform show -json tfplan > tfplan.json
conftest test tfplan.json --policy policies
```
