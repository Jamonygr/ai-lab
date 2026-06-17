# AI Lab scenarios

<p align="center">
  <img src="../../docs/images/lab-scenarios.svg" alt="AI Lab scenario map" width="1000" />
</p>

Run the scenarios in order. The first six use the default deployment. Advanced scenarios are opt-in and should be enabled one track at a time.

## Scenario 0: Setup check

Script: `exercises/python/00_setup_check.py`

Tasks:

- Confirm `.env` exists.
- Confirm required endpoints and keys are present.
- Print redacted values so learners can confirm configuration without leaking secrets.

Success signal:

- Required variables print.
- Keys are shortened with `...`.
- Optional values show `(not configured)` unless you enabled optional services.

## Scenario 1: Language sentiment

Script: `exercises/python/01_language_sentiment.py`

Tasks:

- Send short text samples to the Language REST API.
- Review sentiment labels and confidence scores.
- Change the sample text and rerun.

Try one positive, one neutral, and one frustrated sentence. Compare the confidence scores and discuss where a user-facing app should avoid overreacting to low confidence.

## Scenario 2: PII and entities

Script: `exercises/python/02_language_pii_entities.py`

Tasks:

- Detect named entities.
- Detect personally identifiable information.
- Discuss why PII handling matters before storing prompts or transcripts.

Evidence to capture:

- Entity categories returned by the API.
- Redacted text from the PII response.
- A note explaining whether your app should store raw input, redacted input, or neither.

## Scenario 3: Vision OCR

Script: `exercises/python/03_vision_ocr.py`

Tasks:

- Analyze an image URL.
- Extract readable text.
- Compare clean printed text with screenshots or handwritten input.

Change the sample URL to another public image with text. OCR quality depends on resolution, contrast, language, and layout.

## Scenario 4: Speech basics

Script: `exercises/python/04_speech_basics.py`

Tasks:

- Request a Speech token.
- Convert a sentence to a small audio file.
- Review why Speech APIs need region information as well as a key.

The script writes `exercises/python/speech-output.wav`. Delete it after testing if you do not need the evidence file.

## Scenario 5: Translator

Script: `exercises/python/05_translator.py`

Tasks:

- Translate a short phrase.
- Change target languages.
- Compare the Translator endpoint with the regional AI Services endpoint.

## Scenario 6: Content Safety

Script: `exercises/python/06_content_safety.py`

Tasks:

- Submit safe and risky text samples.
- Review returned categories and severity levels.
- Decide how an app should handle blocked or escalated content.

Discussion prompts:

- Which severity should block a request?
- Which severity should ask the user to rephrase?
- What should be logged, and what should be redacted?
- Who reviews borderline cases?

## Scenario 7: Optional Search/RAG

Script: `exercises/python/07_search_rag_optional.py`

Required flag:

```hcl
deploy_ai_search = true
```

Tasks:

- Create a tiny local search index.
- Upload three beginner documents.
- Search the index before answering a question.

Clean up optional Search resources by running `terraform destroy` or by turning `deploy_ai_search = false` and applying again.

## Scenario 8: Advanced Search/RAG

Script: `exercises/python/08_search_rag_advanced.py`

Required flag:

```hcl
deploy_ai_search = true
```

Tasks:

- Create an index with text, metadata, and vector fields.
- Upload tiny lab documents with deterministic demo vectors.
- Run a hybrid keyword/vector query.
- Print citation sources next to retrieved content.

## Scenario 9: Document Intelligence

Script: `exercises/python/09_document_intelligence_layout.py`

Required flag:

```hcl
deploy_document_intelligence = true
```

Tasks:

- Analyze a sample PDF with the prebuilt layout model.
- Count pages, paragraphs, and tables.
- Review how structured extraction differs from OCR.

## Scenario 10: Vision analysis upgrade

Script: `exercises/python/10_vision_image_analysis.py`

Tasks:

- Request captions, tags, objects, people, and read results.
- Compare image-level descriptions with OCR text.
- Decide which visual outputs are useful evidence for an app.

## Scenario 11: Advanced Content Safety guardrails

Script: `exercises/python/11_content_safety_guardrails.py`

Tasks:

- Submit a prompt-attack sample to Prompt Shields.
- Submit a text sample to protected material detection.
- Convert the response into an allow, review, or block decision.

## Scenario 12: Pronunciation assessment

Script: `exercises/python/12_speech_pronunciation_assessment.py`

Tasks:

- Generate a short reference audio file.
- Run pronunciation assessment against the reference text.
- Review accuracy, fluency, completeness, and pronunciation scores.

## Scenario 13: Foundry agent blueprint

Script: `exercises/python/13_foundry_agent_blueprint.py`

Optional flags:

```hcl
deploy_ai_foundry   = true
deploy_azure_openai = true
```

Tasks:

- Review the agent instructions, tool catalog, and handoff rules.
- Optionally ask an Azure OpenAI deployment to critique the blueprint.
- Discuss what traces and evaluations should exist before production use.

## Scenario 14: Observability and evaluation

Script: `exercises/python/14_observability_evaluation.py`

Optional flag:

```hcl
deploy_observability_alerts = true
```

Tasks:

- Generate a local evaluation JSONL file.
- Review groundedness rate and latency evidence.
- Connect the same metric ideas to Application Insights and Foundry evaluation.
