import os

import requests

from ai_lab_client import document_analyze_url, load_env, print_json, require_env, wait_for_operation


DEFAULT_SAMPLE = "https://raw.githubusercontent.com/Azure-Samples/cognitive-services-REST-api-samples/master/curl/form-recognizer/sample-layout.pdf"


def main() -> None:
    load_env()
    env = require_env(["DOCUMENT_INTELLIGENCE_ENDPOINT", "DOCUMENT_INTELLIGENCE_KEY"])
    sample_url = os.getenv("DOCUMENT_INTELLIGENCE_SAMPLE_URL", DEFAULT_SAMPLE).strip() or DEFAULT_SAMPLE

    response = requests.post(
        document_analyze_url(env["DOCUMENT_INTELLIGENCE_ENDPOINT"]),
        headers={
            "Content-Type": "application/json",
            "Ocp-Apim-Subscription-Key": env["DOCUMENT_INTELLIGENCE_KEY"],
        },
        json={"urlSource": sample_url},
        timeout=30,
    )
    response.raise_for_status()
    operation_url = response.headers["Operation-Location"]
    result = wait_for_operation(operation_url, env["DOCUMENT_INTELLIGENCE_KEY"])

    analyze_result = result.get("analyzeResult", {})
    summary = {
        "modelId": result.get("modelId"),
        "status": result.get("status"),
        "pages": len(analyze_result.get("pages", [])),
        "paragraphs": len(analyze_result.get("paragraphs", [])),
        "tables": len(analyze_result.get("tables", [])),
        "firstContent": analyze_result.get("content", "")[:500],
    }
    print_json(summary)


if __name__ == "__main__":
    main()
