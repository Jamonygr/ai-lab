# Advanced tracks

These tracks implement the enrichment backlog while keeping the default lab low-cost. Enable one track at a time, collect evidence, then destroy or disable it.

## Track map

| Track | Feature flags | Main exercise | Evidence |
|-------|---------------|---------------|----------|
| RAG 2.0 | `deploy_ai_search = true` | `08_search_rag_advanced.py` | Hybrid/vector results with citation sources |
| Document Intelligence | `deploy_document_intelligence = true` | `09_document_intelligence_layout.py` | Page, paragraph, table, and content summary |
| Vision upgrade | Default AIServices | `10_vision_image_analysis.py` | Captions, tags, objects, people, and OCR lines |
| Responsible AI advanced | Default Content Safety | `11_content_safety_guardrails.py` | Prompt Shields and protected material response |
| Speech upgrade | Default AIServices | `12_speech_pronunciation_assessment.py` | Pronunciation scores and generated audio path |
| Foundry agents | `deploy_ai_foundry = true` | `13_foundry_agent_blueprint.py` | Tool catalog, handoff rules, optional model critique |
| Observability/evaluation | Optional alerts | `14_observability_evaluation.py` | Groundedness rate, latency, JSONL evidence |
| Security hardening | `deploy_private_networking`, `store_service_keys_in_key_vault` | Security runbook | Private endpoints, Key Vault secrets, policy results |
| Real app demo | `deploy_app_hosting = true` | `app/index.html` | Scenario console and guardrail decision board |
| Instructor pack | None | `instructor/lesson-plan.md` | Quiz, rubric, workbook, evidence checklist |

## Recommended order

1. Run the default lab and scenarios 0 through 6.
2. Enable Search and run simple RAG, then advanced RAG.
3. Enable Document Intelligence and run layout extraction.
4. Run advanced Content Safety and Speech exercises.
5. Add evaluation evidence and review quality tradeoffs.
6. Enable Foundry only when the learner is ready for agent design.
7. Add private networking and Key Vault secret storage as a hardening lab.

## Cost and quota notes

- Search free tier is still limited. Keep documents tiny.
- Document Intelligence and AI service calls are usage based.
- Azure OpenAI and Foundry agent work can be quota constrained.
- Private endpoints may add networking cost and make local testing harder.
- Always run `terraform destroy` after temporary advanced runs.

## Prompt Flow direction

Do not build new Prompt Flow classic labs. Use Foundry projects, agents, tracing, evaluation, and explicit Python exercises for new learning paths.
