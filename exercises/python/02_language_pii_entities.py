from ai_lab_client import entity_payload, language_analyze_url, load_env, pii_payload, post_json, print_json, require_env


def main() -> None:
    load_env()
    env = require_env(["AZURE_AI_SERVICES_ENDPOINT", "AZURE_AI_SERVICES_KEY"])

    text = "Ada Lovelace visited Seattle and used the email ada@example.com for the workshop."
    url = language_analyze_url(env["AZURE_AI_SERVICES_ENDPOINT"])

    print("Entities:")
    print_json(post_json(url, env["AZURE_AI_SERVICES_KEY"], entity_payload(text)))

    print("\nPII:")
    print_json(post_json(url, env["AZURE_AI_SERVICES_KEY"], pii_payload(text)))


if __name__ == "__main__":
    main()

