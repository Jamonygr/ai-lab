# Teardown runbook

Use this runbook whenever the lab is no longer needed. It prevents idle Azure resources and clears local files that may contain secrets.

## 1. Destroy Terraform-managed resources

Run from the repository root:

```powershell
terraform destroy
```

If you used one-off `-var` values for the apply, pass the same values to destroy.

## 2. Verify Azure deletion

```powershell
$rg = terraform output -raw resource_group_name
az group exists --name $rg
```

If Terraform state is already empty, use the resource group name captured during apply:

```powershell
az group exists --name "rg-ailab-lab-weu-xxxxx"
```

Expected result after deletion:

```text
false
```

## 3. Check Terraform state

```powershell
terraform state list
```

Expected result after successful destroy: no resources are listed.

## 4. Remove local secret-bearing artifacts

Terraform state backups and saved plans can contain sensitive values after apply. They are ignored by git, but they should not be kept longer than needed on shared machines.

```powershell
Remove-Item -Force terraform.tfstate, terraform.tfstate.backup, *.tfplan -ErrorAction SilentlyContinue
Remove-Item -Force exercises/python/*-output.wav, exercises/python/*-output.json, exercises/python/*-output.jsonl -ErrorAction SilentlyContinue
```

Keep `terraform.tfvars` only if you plan to redeploy soon and it does not contain secrets.

## 5. Soft-delete notes

Azure services may keep soft-deleted records for recovery even after active resources are gone. For this lab:

| Service | What to know |
|---------|--------------|
| Resource group | Should be fully gone after destroy. |
| Key Vault | Soft delete is enabled for seven days; purge protection is disabled. |
| Cognitive Services | Deleted accounts may briefly appear in provider recovery views. |
| Document Intelligence | Deleted account may briefly appear as a Form Recognizer/Cognitive Services account. |
| Private endpoints | Deleted with the resource group, but DNS/cache behavior may linger locally. |
| Storage account | Deleted with the resource group. |

Only purge soft-deleted resources when you are sure the lab resource names are no longer needed for recovery.

## 6. Evidence to capture

- `terraform destroy` summary.
- Azure resource group existence check returning `false`.
- Empty `terraform state list` output.
- Any manual cleanup notes.
