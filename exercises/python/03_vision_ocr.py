from ai_lab_client import load_env, post_json, print_json, require_env, vision_ocr_url


def main() -> None:
    load_env()
    env = require_env(["AZURE_AI_SERVICES_ENDPOINT", "AZURE_AI_SERVICES_KEY"])

    image_url = "https://learn.microsoft.com/azure/ai-services/computer-vision/media/quickstarts/presentation.png"
    payload = {"url": image_url}
    result = post_json(
        vision_ocr_url(env["AZURE_AI_SERVICES_ENDPOINT"]),
        env["AZURE_AI_SERVICES_KEY"],
        payload,
    )

    print_json(result)


if __name__ == "__main__":
    main()

