from ai_lab_client import language_analyze_url, load_env, post_json, print_json, require_env, sentiment_payload


def main() -> None:
    load_env()
    env = require_env(["AZURE_AI_SERVICES_ENDPOINT", "AZURE_AI_SERVICES_KEY"])

    text = "I am excited to learn Azure AI with Terraform and Python."
    result = post_json(
        language_analyze_url(env["AZURE_AI_SERVICES_ENDPOINT"]),
        env["AZURE_AI_SERVICES_KEY"],
        sentiment_payload(text),
    )

    print_json(result)


if __name__ == "__main__":
    main()

