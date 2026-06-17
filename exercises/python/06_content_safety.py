from ai_lab_client import content_safety_payload, content_safety_url, load_env, post_json, print_json, require_env


def main() -> None:
    load_env()
    env = require_env(["CONTENT_SAFETY_ENDPOINT", "CONTENT_SAFETY_KEY"])

    sample = "I want to learn how to build safer AI applications for students."
    result = post_json(
        content_safety_url(env["CONTENT_SAFETY_ENDPOINT"]),
        env["CONTENT_SAFETY_KEY"],
        content_safety_payload(sample),
    )

    print_json(result)


if __name__ == "__main__":
    main()

