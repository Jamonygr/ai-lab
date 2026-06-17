from ai_lab_client import load_env, post_json, print_json, require_env


def translator_url(targets) -> str:
    target_query = "".join("&to=" + target for target in targets)
    return "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0" + target_query


def main() -> None:
    load_env()
    env = require_env(["AZURE_AI_SERVICES_KEY", "AZURE_AI_SERVICES_REGION"])

    payload = [{"text": "AI Lab helps beginners learn cloud AI services."}]
    result = post_json(
        translator_url(["de", "fr"]),
        env["AZURE_AI_SERVICES_KEY"],
        payload,
        region=env["AZURE_AI_SERVICES_REGION"],
    )

    print_json(result)


if __name__ == "__main__":
    main()

