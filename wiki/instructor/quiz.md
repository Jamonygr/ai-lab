# Instructor quiz

## Questions

1. Which files should never be committed after running the lab?
2. Why is Azure OpenAI disabled by default?
3. What does Content Safety add before a model-heavy workflow?
4. What makes advanced RAG more trustworthy than a single keyword search?
5. Why does the Speech exercise need a region and a key?
6. What evidence proves teardown is complete?
7. When should private endpoints be enabled?
8. Why should new work avoid Prompt Flow classic?

## Answer key

1. `.env`, `terraform.tfvars` with private values, Terraform state, saved plans, raw key screenshots, and generated evidence files.
2. It requires subscription access, quota, model availability, and extra cost awareness.
3. Harm category checks, prompt attack detection, protected material review, and explicit allow/review/block decisions.
4. It can combine keyword and vector retrieval, cite sources, and record groundedness evidence.
5. Speech token and voice endpoints are regional.
6. `terraform destroy` completes, the resource group existence check returns `false`, state is empty or removed, and local artifacts are cleaned.
7. After the beginner public endpoint path is understood and the learner is ready for DNS, networking, and access changes.
8. Prompt Flow classic is not the recommended direction for new labs; Foundry agents, tracing, evaluation, and direct Python exercises are better for this repo.
