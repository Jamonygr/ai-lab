import json
import os
import time
from typing import Dict, List

from ai_lab_client import deterministic_vector, load_env, print_json


DATASET = [
    {
        "question": "How do I avoid committing secrets?",
        "expected_source": "wiki/security-and-cost.md",
        "answer": "Keep .env, Terraform state, and raw keys out of git. Use redacted setup output for evidence.",
        "source": "wiki/security-and-cost.md",
    },
    {
        "question": "What should I run before applying Terraform?",
        "expected_source": "wiki/runbooks/deploy-and-test.md",
        "answer": "Run terraform fmt, terraform init, terraform validate, and review a saved plan.",
        "source": "wiki/runbooks/deploy-and-test.md",
    },
    {
        "question": "When should Search be enabled?",
        "expected_source": "wiki/scenarios/README.md",
        "answer": "Enable Search only for optional RAG exercises after the default AI service scenarios work.",
        "source": "wiki/scenarios/README.md",
    },
]


def score_row(row: Dict[str, str]) -> Dict[str, object]:
    start = time.perf_counter()
    grounded = row["expected_source"] == row["source"]
    relevance = sum(deterministic_vector(row["question"], 4)) * sum(deterministic_vector(row["answer"], 4))
    latency_ms = round((time.perf_counter() - start) * 1000, 3)
    return {
        "question": row["question"],
        "source": row["source"],
        "grounded": grounded,
        "relevanceProxy": round(relevance, 3),
        "latencyMs": latency_ms,
    }


def main() -> None:
    load_env()
    results: List[Dict[str, object]] = [score_row(row) for row in DATASET]
    output_path = os.path.join(os.path.dirname(__file__), "evaluation-output.jsonl")
    with open(output_path, "w", encoding="utf-8") as output:
        for result in results:
            output.write(json.dumps(result) + "\n")

    print_json(
        {
            "rows": len(results),
            "groundedRate": sum(1 for row in results if row["grounded"]) / len(results),
            "outputPath": output_path,
            "applicationInsightsConnectionStringConfigured": bool(os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING", "").strip()),
        }
    )


if __name__ == "__main__":
    main()
