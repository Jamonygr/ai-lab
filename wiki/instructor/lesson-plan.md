# Instructor lesson plan

Use this plan for a half-day workshop or split it into two shorter sessions.

## Session flow

| Time | Activity | Evidence |
|------|----------|----------|
| 15 min | Repository tour and safety briefing | Learner identifies feature flags and teardown command |
| 25 min | Terraform default deploy | Plan/apply summary and resource group screenshot |
| 35 min | Core AI scenarios | Setup, Language, Vision OCR, Speech, Translator, Content Safety output |
| 25 min | Responsible AI discussion | Severity decision table and logging policy note |
| 30 min | RAG 2.0 | Search result sources and groundedness discussion |
| 30 min | Document Intelligence or Vision upgrade | Extracted layout or caption/object output |
| 25 min | Agent blueprint | Tool catalog, handoff rules, risk review |
| 20 min | Observability and evaluation | JSONL evidence and quality metric summary |
| 20 min | Teardown | Destroy summary and resource group deletion check |

## Facilitation notes

- Keep optional Azure OpenAI off unless quota is confirmed before class.
- Pair learners for the responsible AI and agent design sections.
- Require redacted evidence only; raw keys should never appear in screenshots.
- Use the static app in `app/` to explain scenario flow before learners run scripts.
- Stop and destroy if costs or quota behavior differs from expectations.

## Grading rubric

| Area | Pass | Strong |
|------|------|--------|
| Terraform | Plan and apply succeed | Explains each optional flag and cost impact |
| Python | Core scripts run | Modifies samples and explains API responses |
| Responsible AI | Reads severity output | Defines block/review/allow rules |
| RAG | Runs retrieval | Explains citations and missing evidence behavior |
| Operations | Destroys lab | Verifies state, resource group deletion, and local artifact cleanup |
