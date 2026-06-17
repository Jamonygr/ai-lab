# AI Lab workbook

Use this checklist while working through the lab.

## Phase 0: Baseline deployment

- [ ] Copy `terraform.tfvars.example` to `terraform.tfvars`.
- [ ] Review the Master Control Panel.
- [ ] Confirm optional resources are off for the first run.
- [ ] Run `terraform init`.
- [ ] Run `terraform fmt -check -recursive`.
- [ ] Run `terraform validate`.
- [ ] Run `terraform plan`.
- [ ] Run `terraform apply`.
- [ ] Capture the resource group and service names.

Evidence:

- Terraform plan summary.
- Azure portal screenshot of the resource group.

## Phase 1: Local exercise setup

- [ ] Create a Python virtual environment.
- [ ] Install `exercises/python/requirements.txt`.
- [ ] Copy `.env.example` to `.env`.
- [ ] Fill endpoint and key values from Terraform outputs.
- [ ] Run `00_setup_check.py`.

Evidence:

- Redacted setup check output.

## Phase 2: Language exercises

- [ ] Run sentiment analysis.
- [ ] Change the input text.
- [ ] Run entity and PII analysis.
- [ ] Record why PII should not be logged by default.

Evidence:

- Script output with sentiment and detected PII categories.

## Phase 3: Vision, Speech, and Translator

- [ ] Run the OCR exercise.
- [ ] Run the text-to-speech exercise.
- [ ] Run the translation exercise.
- [ ] Compare endpoint and region requirements.

Evidence:

- OCR text output.
- Generated speech file path.
- Translation output.

## Phase 4: Responsible AI

- [ ] Run Content Safety with a safe sample.
- [ ] Run Content Safety with a risky sample.
- [ ] Decide what the application should do with severe content.

Evidence:

- Safety categories and severity values.
- Short mitigation note.

## Phase 5: Optional Search/RAG

- [ ] Set `deploy_ai_search = true`.
- [ ] Apply Terraform.
- [ ] Add Search endpoint and key to `.env`.
- [ ] Run `07_search_rag_optional.py`.
- [ ] Run `08_search_rag_advanced.py`.

Evidence:

- Search query results.
- Notes on why retrieval helps ground an answer.
- Advanced RAG output with source paths.

## Phase 5A: Optional Document and Vision upgrades

- [ ] Set `deploy_document_intelligence = true`.
- [ ] Apply Terraform.
- [ ] Add Document Intelligence endpoint and key to `.env`.
- [ ] Run `09_document_intelligence_layout.py`.
- [ ] Run `10_vision_image_analysis.py`.

Evidence:

- Document page, paragraph, and table counts.
- Vision captions, tags, object, people, and read output.

## Phase 5B: Optional Responsible AI, Speech, Agents, and Evaluation

- [ ] Run `11_content_safety_guardrails.py`.
- [ ] Run `12_speech_pronunciation_assessment.py`.
- [ ] Review `13_foundry_agent_blueprint.py`.
- [ ] Run `14_observability_evaluation.py`.
- [ ] Optional: set `deploy_ai_foundry = true`.
- [ ] Optional: set `deploy_observability_alerts = true`.

Evidence:

- Prompt Shields and protected material response.
- Pronunciation scores.
- Agent tool catalog and handoff rules.
- Evaluation JSONL summary.

## Phase 6: Teardown

- [ ] Run `terraform destroy`.
- [ ] Confirm the resource group is deleted.
- [ ] Confirm `terraform state list` is empty.
- [ ] Delete local state backups and saved plans from temporary runs.
- [ ] Record which optional components created extra cost or setup work.
