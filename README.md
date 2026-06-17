# AI Lab

[![Terraform](https://img.shields.io/badge/Terraform->=1.9.0-623CE4?logo=terraform)](https://terraform.io)
[![Azure](https://img.shields.io/badge/Azure-AzureRM%204.x-0078D4?logo=microsoftazure)](https://azure.microsoft.com)
[![Python](https://img.shields.io/badge/Python->=3.8-3776AB?logo=python)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

<p align="center">
  <img src="docs/images/hero-ai-lab.svg" alt="AI Lab banner" width="1000" />
</p>

AI Lab is a beginner-friendly, Terraform-first Azure AI sandbox. It deploys a small set of low-cost Microsoft Foundry Tools resources, formerly Azure AI services, and pairs them with Python exercises for text, image, speech, translation, content safety, optional search/RAG, document extraction, Foundry agents, evaluation, and hardening tracks.

This lab is intentionally smaller than a production AI platform. The goal is to help beginners learn what each service does, how Terraform deploys it, and how a script calls it.

## What you can practice

| Area | What the lab teaches |
|------|----------------------|
| AI fundamentals | Language, Vision OCR, Speech, Translator, and Content Safety basics. |
| Infrastructure as code | Deploy AI services with reusable Terraform modules and feature toggles. |
| Responsible AI | Review text with Content Safety before wiring model-heavy workflows. |
| Search and RAG | Optionally deploy Azure AI Search and run a tiny retrieval exercise. |
| Document intelligence | Extract layout, tables, and document structure from PDF samples. |
| Agents and evaluation | Design a Foundry agent blueprint, review tool routing, and produce evaluation evidence. |
| Operations | Use storage, Key Vault, Log Analytics, and Application Insights as AI app foundations. |
| Security hardening | Optionally add Key Vault secret storage, private endpoints, policies, and cleanup checks. |

## Architecture

<p align="center">
  <img src="docs/images/architecture-overview.svg" alt="AI Lab architecture overview" width="1000" />
</p>

The default deployment creates:

| Component | Purpose | Default |
|-----------|---------|---------|
| Resource group | Container for all lab resources | On |
| Storage account | Exercise data and future app artifacts | On |
| Key Vault | Secret store for future hardening exercises | On |
| Log Analytics | Central logs and monitoring foundation | On |
| Application Insights | Optional app observability | On |
| AIServices account | Foundry Tools account for Language, Vision, Speech, and Translator exercises | On |
| Content Safety account | Safety review exercise | On |
| Azure AI Search | Optional search/RAG exercise | Off |
| Document Intelligence | Optional document extraction exercise | Off |
| Azure OpenAI | Optional model deployment for quota-enabled subscriptions | Off |
| Azure AI Foundry | Optional hub and project for agent/evaluation work | Off |
| Static Web App | Optional hosted demo placeholder | Off |
| Private endpoints | Optional advanced network hardening | Off |
| Monitor alerts | Optional call-volume guardrail alerts | Off |

## Master Control Panel

Copy `terraform.tfvars.example` to `terraform.tfvars`, then change these flags:

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

Beginner defaults keep cost and quota risk low. Turn on optional components only when the related scenario asks for them.

## Quick Start

1. Sign in to Azure:

   ```powershell
   az login
   az account set --subscription "<subscription-id>"
   ```

2. Configure Terraform:

   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   terraform init
   terraform plan
   terraform apply
   ```

3. Configure Python exercises:

   ```powershell
   cd exercises/python
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   Copy-Item .env.example .env
   ```

4. Fill `.env` using Terraform outputs:

   ```powershell
   terraform output exercise_environment
   terraform output -raw ai_services_key
   terraform output -raw content_safety_key
   ```

5. Run the first checks:

   ```powershell
   python 00_setup_check.py
   python 01_language_sentiment.py
   ```

## Lab Scenarios

<p align="center">
  <img src="docs/images/lab-scenarios.svg" alt="AI Lab scenarios" width="1000" />
</p>

| Scenario | Exercise | Skills |
|----------|----------|--------|
| Text sentiment | `01_language_sentiment.py` | REST calls, sentiment labels, confidence scores |
| PII and entities | `02_language_pii_entities.py` | Entity extraction, privacy review |
| Vision OCR | `03_vision_ocr.py` | Image analysis, read results |
| Speech basics | `04_speech_basics.py` | Speech region, token, text-to-speech |
| Translator | `05_translator.py` | Translation endpoint, target languages |
| Content Safety | `06_content_safety.py` | Harm categories, severities |
| Optional RAG | `07_search_rag_optional.py` | Search index, tiny document retrieval |
| Advanced RAG | `08_search_rag_advanced.py` | Vector search, hybrid retrieval, citation sources |
| Document Intelligence | `09_document_intelligence_layout.py` | Layout extraction, tables, page summaries |
| Vision analysis | `10_vision_image_analysis.py` | Captions, tags, objects, people, read results |
| Guardrails | `11_content_safety_guardrails.py` | Prompt Shields and protected material checks |
| Pronunciation | `12_speech_pronunciation_assessment.py` | Speech scoring and generated evidence audio |
| Agent blueprint | `13_foundry_agent_blueprint.py` | Foundry-oriented tool catalog and handoff rules |
| Evaluation | `14_observability_evaluation.py` | Groundedness, latency, and local JSONL evidence |

## Documentation

<p align="center">
  <img src="docs/images/documentation-map.svg" alt="AI Lab documentation map" width="1000" />
</p>

- Start here: `wiki/README.md`
- Deep dive guide: `wiki/book.md`
- Architecture: `wiki/architecture/overview.md`
- Scenarios: `wiki/scenarios/README.md`
- Testing: `wiki/testing/lab-testing-guide.md`
- Variables: `wiki/reference/variables.md`
- Workbook: `wiki/certifications/lab-workbook.md`
- Advanced tracks: `wiki/advanced-tracks.md`
- Instructor pack: `wiki/instructor/lesson-plan.md`

## Cost Notes

- Default services are designed for low-volume learning.
- Azure AI Search is off by default; the free tier is intended for the optional RAG exercise.
- Document Intelligence, Foundry, private networking, and monitor alerts are off by default.
- Azure OpenAI is off by default because it requires access, model quota, and region availability.
- Always run `terraform destroy` when finished with the lab.

## Project Structure

```text
.
|-- modules/              # Reusable Terraform modules
|-- exercises/python/     # Beginner Python exercises
|-- app/                  # Static scenario console demo
|-- wiki/                 # Lab documentation
|-- scripts/              # Repo quality checks
|-- docs/images/          # SVG diagrams
|-- policies/             # OPA/Rego policy checks
|-- tests/                # Go and Python tests
|-- main.tf               # Root Terraform orchestration
|-- variables.tf          # Inputs and feature toggles
|-- outputs.tf            # Exercise endpoints and resource names
`-- terraform.tfvars.example
```

## References

- Microsoft Foundry overview: https://learn.microsoft.com/azure/foundry/what-is-foundry
- Foundry Tools / Azure AI services: https://learn.microsoft.com/azure/ai-services/what-are-ai-services
- Terraform Foundry resources: https://learn.microsoft.com/azure/foundry/how-to/create-resource-terraform
- Azure AI Search: https://learn.microsoft.com/azure/search/

## License

MIT. See [LICENSE](LICENSE).
