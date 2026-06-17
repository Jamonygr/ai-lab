import os

from ai_lab_client import load_env, post_json, print_json, require_env, vision_analysis_url


def main() -> None:
    load_env()
    env = require_env(["AZURE_AI_SERVICES_ENDPOINT", "AZURE_AI_SERVICES_KEY"])

    image_url = os.getenv(
        "VISION_SAMPLE_URL",
        "https://learn.microsoft.com/azure/ai-services/computer-vision/media/quickstarts/presentation.png",
    )
    features = ["caption", "tags", "objects", "people", "read"]
    result = post_json(
        vision_analysis_url(env["AZURE_AI_SERVICES_ENDPOINT"], features),
        env["AZURE_AI_SERVICES_KEY"],
        {"url": image_url},
    )

    print_json(
        {
            "caption": result.get("captionResult", {}),
            "tags": result.get("tagsResult", {}).get("values", [])[:5],
            "objects": result.get("objectsResult", {}).get("values", [])[:5],
            "people": result.get("peopleResult", {}).get("values", [])[:5],
            "readLines": [
                line.get("text")
                for block in result.get("readResult", {}).get("blocks", [])
                for line in block.get("lines", [])
            ][:8],
        }
    )


if __name__ == "__main__":
    main()
