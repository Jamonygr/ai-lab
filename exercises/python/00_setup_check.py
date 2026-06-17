from ai_lab_client import load_env, redact, require_env


REQUIRED = [
    "AZURE_AI_SERVICES_ENDPOINT",
    "AZURE_AI_SERVICES_KEY",
    "AZURE_AI_SERVICES_REGION",
    "CONTENT_SAFETY_ENDPOINT",
    "CONTENT_SAFETY_KEY",
]

OPTIONAL = [
    "AI_SEARCH_ENDPOINT",
    "AI_SEARCH_KEY",
    "AZURE_OPENAI_ENDPOINT",
    "AZURE_OPENAI_KEY",
    "AZURE_OPENAI_DEPLOYMENT",
]


def main() -> None:
    load_env()
    values = require_env(REQUIRED)

    print("Required AI Lab settings:")
    for name in REQUIRED:
        value = values[name]
        if name.endswith("_KEY"):
            value = redact(value)
        print(f"  {name}={value}")

    print("\nOptional settings:")
    import os

    for name in OPTIONAL:
        value = os.getenv(name, "").strip()
        if not value or value.startswith("<"):
            value = "(not configured)"
        elif name.endswith("_KEY"):
            value = redact(value)
        print(f"  {name}={value}")


if __name__ == "__main__":
    main()

