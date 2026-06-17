import hashlib
import json
import os
import time
from typing import Dict, Iterable, List, Optional


def load_env() -> None:
    try:
        from dotenv import load_dotenv
    except ImportError:
        return

    load_dotenv()


def require_env(names: Iterable[str]) -> Dict[str, str]:
    missing: List[str] = []
    values: Dict[str, str] = {}

    for name in names:
        value = os.getenv(name, "").strip()
        if not value or value.startswith("<"):
            missing.append(name)
        else:
            values[name] = value

    if missing:
        raise RuntimeError("Missing required environment variables: " + ", ".join(missing))

    return values


def redact(value: str) -> str:
    if not value:
        return ""
    if len(value) <= 10:
        return "***"
    return value[:6] + "..." + value[-4:]


def print_json(data: object) -> None:
    print(json.dumps(data, indent=2, sort_keys=True))


def request_json(
    method: str,
    url: str,
    key: str,
    payload: Optional[object] = None,
    region: Optional[str] = None,
    extra_headers: Optional[Dict[str, str]] = None,
    timeout: int = 30,
) -> object:
    import requests

    headers = {
        "Content-Type": "application/json",
        "Ocp-Apim-Subscription-Key": key,
    }
    if region:
        headers["Ocp-Apim-Subscription-Region"] = region
    if extra_headers:
        headers.update(extra_headers)

    response = requests.request(method, url, headers=headers, json=payload, timeout=timeout)
    response.raise_for_status()
    if not response.text:
        return {}
    return response.json()


def post_json(
    url: str,
    key: str,
    payload: object,
    region: Optional[str] = None,
    extra_headers: Optional[Dict[str, str]] = None,
    timeout: int = 30,
) -> object:
    return request_json("POST", url, key, payload, region, extra_headers, timeout)


def language_analyze_url(endpoint: str) -> str:
    return endpoint.rstrip("/") + "/language/:analyze-text?api-version=2023-04-01"


def sentiment_payload(text: str, language: str = "en") -> Dict[str, object]:
    return {
        "kind": "SentimentAnalysis",
        "analysisInput": {
            "documents": [
                {
                    "id": "1",
                    "language": language,
                    "text": text,
                }
            ]
        },
    }


def entity_payload(text: str, language: str = "en") -> Dict[str, object]:
    return {
        "kind": "EntityRecognition",
        "analysisInput": {
            "documents": [
                {
                    "id": "1",
                    "language": language,
                    "text": text,
                }
            ]
        },
    }


def pii_payload(text: str, language: str = "en") -> Dict[str, object]:
    return {
        "kind": "PiiEntityRecognition",
        "analysisInput": {
            "documents": [
                {
                    "id": "1",
                    "language": language,
                    "text": text,
                }
            ]
        },
    }


def content_safety_payload(text: str) -> Dict[str, object]:
    return {
        "text": text,
        "categories": ["Hate", "SelfHarm", "Sexual", "Violence"],
        "outputType": "FourSeverityLevels",
    }


def content_safety_url(endpoint: str) -> str:
    return endpoint.rstrip("/") + "/contentsafety/text:analyze?api-version=2024-09-01"


def content_safety_shield_prompt_url(endpoint: str) -> str:
    return endpoint.rstrip("/") + "/contentsafety/text:shieldPrompt?api-version=2024-09-01"


def content_safety_protected_material_url(endpoint: str) -> str:
    return endpoint.rstrip("/") + "/contentsafety/text:detectProtectedMaterial?api-version=2024-09-01"


def shield_prompt_payload(user_prompt: str, documents: Optional[List[str]] = None) -> Dict[str, object]:
    return {
        "userPrompt": user_prompt,
        "documents": documents or [],
    }


def protected_material_payload(text: str) -> Dict[str, object]:
    return {"text": text}


def vision_ocr_url(endpoint: str) -> str:
    return endpoint.rstrip("/") + "/computervision/imageanalysis:analyze?features=read&api-version=2024-02-01"


def vision_analysis_url(endpoint: str, features: Iterable[str]) -> str:
    feature_query = ",".join(features)
    return endpoint.rstrip("/") + f"/computervision/imageanalysis:analyze?features={feature_query}&api-version=2024-02-01"


def document_analyze_url(endpoint: str, model_id: str = "prebuilt-layout") -> str:
    return endpoint.rstrip("/") + f"/documentintelligence/documentModels/{model_id}:analyze?api-version=2024-11-30"


def openai_chat_completions_url(endpoint: str, deployment: str) -> str:
    return endpoint.rstrip("/") + f"/openai/deployments/{deployment}/chat/completions?api-version=2025-01-01-preview"


def deterministic_vector(text: str, dimensions: int = 8) -> List[float]:
    digest = hashlib.sha256(text.encode("utf-8")).digest()
    values = []
    for index in range(dimensions):
        raw = digest[index] / 255.0
        values.append(round((raw * 2.0) - 1.0, 6))
    return values


def wait_for_operation(
    operation_url: str,
    key: str,
    status_path: str = "status",
    success_values: Optional[List[str]] = None,
    timeout_seconds: int = 120,
    poll_seconds: int = 3,
) -> object:
    success = set(success_values or ["succeeded", "Succeeded"])
    deadline = time.time() + timeout_seconds

    while time.time() < deadline:
        result = request_json("GET", operation_url, key)
        status = result
        for part in status_path.split("."):
            status = status.get(part, "") if isinstance(status, dict) else ""
        if status in success:
            return result
        if str(status).lower() in {"failed", "canceled", "cancelled"}:
            raise RuntimeError(f"Operation failed with status {status}: {result}")
        time.sleep(poll_seconds)

    raise TimeoutError(f"Operation did not finish within {timeout_seconds} seconds")
