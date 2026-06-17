import os
import sys

import pytest


ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
EXERCISES = os.path.join(ROOT, "exercises", "python")
sys.path.insert(0, EXERCISES)

import ai_lab_client


def test_redact_short_values():
    assert ai_lab_client.redact("abc") == "***"


def test_redact_long_values():
    assert ai_lab_client.redact("abcdefghijklmnopqrstuvwxyz") == "abcdef...wxyz"


def test_require_env_returns_values(monkeypatch):
    monkeypatch.setenv("AI_LAB_TEST_VALUE", "present")
    assert ai_lab_client.require_env(["AI_LAB_TEST_VALUE"]) == {"AI_LAB_TEST_VALUE": "present"}


def test_require_env_rejects_missing(monkeypatch):
    monkeypatch.delenv("AI_LAB_TEST_MISSING", raising=False)
    with pytest.raises(RuntimeError):
        ai_lab_client.require_env(["AI_LAB_TEST_MISSING"])


def test_sentiment_payload_shape():
    payload = ai_lab_client.sentiment_payload("hello")
    assert payload["kind"] == "SentimentAnalysis"
    assert payload["analysisInput"]["documents"][0]["text"] == "hello"


def test_content_safety_payload_shape():
    payload = ai_lab_client.content_safety_payload("safe text")
    assert payload["text"] == "safe text"
    assert "Violence" in payload["categories"]


def test_post_json_uses_expected_headers(monkeypatch):
    captured = {}

    class FakeResponse:
        def raise_for_status(self):
            return None

        def json(self):
            return {"ok": True}

    def fake_post(url, headers, json, timeout):
        captured["url"] = url
        captured["headers"] = headers
        captured["json"] = json
        captured["timeout"] = timeout
        return FakeResponse()

    class FakeRequests:
        @staticmethod
        def post(url, headers, json, timeout):
            return fake_post(url, headers, json, timeout)

    monkeypatch.setitem(sys.modules, "requests", FakeRequests)

    result = ai_lab_client.post_json("https://example.test", "key", {"hello": "world"}, region="westeurope")

    assert result == {"ok": True}
    assert captured["headers"]["Ocp-Apim-Subscription-Key"] == "key"
    assert captured["headers"]["Ocp-Apim-Subscription-Region"] == "westeurope"
    assert captured["json"] == {"hello": "world"}

