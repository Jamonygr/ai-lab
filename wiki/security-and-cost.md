# Security and cost guide

AI Lab is intentionally beginner-friendly, but it still creates real cloud resources. Treat every endpoint, key, and Terraform state file as sensitive.

## Default safety posture

| Area | Default | Reason |
|------|---------|--------|
| Optional Search | Off | Avoids extra cost until the learner reaches RAG. |
| Optional Azure OpenAI | Off | Requires access, quota, and region availability. |
| Optional app hosting | Off | Keeps the first run focused on API scripts. |
| Public endpoints | On | Makes beginner local scripts work without private networking. |
| Log Analytics daily quota | 1 GB | Reduces surprise ingestion cost in a lab. |
| Application Insights daily cap | 1 GB | Protects later app experiments from runaway telemetry. |
| Storage public access | Disabled | Avoids accidental public blobs. |
| Key Vault purge protection | Off | Allows cleanup in temporary labs. |

## Secrets

Do not commit:

- `terraform.tfvars` when it contains private values.
- `.env` files.
- Terraform state files.
- Saved Terraform plans from after an apply.
- Screenshots showing raw keys.

Use redacted output for evidence. `00_setup_check.py` redacts key values before printing.

## Public network access

The default value `enable_public_network_access = true` is deliberate for beginner use. Change it only when you are ready to add private endpoints, DNS, and a different local testing path.

When hardening the lab:

- Disable public network access.
- Prefer managed identity where supported.
- Store exercise keys in Key Vault rather than `.env`.
- Add private DNS and endpoint modules.
- Add policy checks that fail plans with public endpoints in non-lab environments.

## Cost controls

Use the Master Control Panel before each apply:

| Toggle | Cost behavior |
|--------|---------------|
| `deploy_ai_services` | Usage-based calls to Language, Vision, Speech, and Translator. |
| `deploy_content_safety` | Usage-based Content Safety calls. |
| `deploy_ai_search` | Free by default, but paid SKUs can cost continuously. |
| `deploy_azure_openai` | Quota-based model deployment and usage charges. |
| `deploy_app_hosting` | Free Static Web App by default. |

Recommended lab habits:

1. Keep optional flags off until needed.
2. Use short smoke tests.
3. Destroy the lab at the end of the session.
4. Review Azure Cost Management after longer experiments.
5. Tag every run with owner, environment, and purpose.

## Responsible AI practice

The Content Safety exercise is not just another API call. Use it to discuss:

- Which categories should block a user request.
- Which severities should trigger review.
- Whether raw user input should be stored.
- How PII output should be redacted from logs.
- What a user should see when a request is blocked.

## Policy checks

The `policies/` folder includes Rego examples for:

- Required tags.
- Approved regions.
- Storage public access.
- Cost-heavy optional components.
- Secret-like values in plan JSON.

Run them when Conftest is installed:

```powershell
terraform plan -out tfplan
terraform show -json tfplan > tfplan.json
conftest test tfplan.json --policy policies
```
