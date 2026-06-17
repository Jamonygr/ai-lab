import json
import os
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


def post_json(
    url: str,
    key: str,
    payload: object,
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

    response = requests.post(url, headers=headers, json=payload, timeout=timeout)
    response.raise_for_status()
    return response.json()


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


def vision_ocr_url(endpoint: str) -> str:
    return endpoint.rstrip("/") + "/computervision/imageanalysis:analyze?features=read&api-version=2024-02-01"

