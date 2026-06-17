import os

import requests

from ai_lab_client import load_env, require_env


def issue_speech_token(region: str, key: str) -> str:
    url = f"https://{region}.api.cognitive.microsoft.com/sts/v1.0/issueToken"
    response = requests.post(url, headers={"Ocp-Apim-Subscription-Key": key}, timeout=30)
    response.raise_for_status()
    return response.text


def synthesize_text(region: str, token: str, text: str) -> bytes:
    url = f"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1"
    ssml = f"""
<speak version="1.0" xml:lang="en-US">
  <voice xml:lang="en-US" xml:gender="Female" name="en-US-JennyNeural">
    {text}
  </voice>
</speak>
""".strip()

    response = requests.post(
        url,
        headers={
            "Authorization": "Bearer " + token,
            "Content-Type": "application/ssml+xml",
            "X-Microsoft-OutputFormat": "riff-24khz-16bit-mono-pcm",
            "User-Agent": "ai-lab",
        },
        data=ssml.encode("utf-8"),
        timeout=30,
    )
    response.raise_for_status()
    return response.content


def main() -> None:
    load_env()
    env = require_env(["AZURE_AI_SERVICES_KEY", "AZURE_AI_SERVICES_REGION"])

    text = "Welcome to AI Lab. This is your first speech exercise."
    token = issue_speech_token(env["AZURE_AI_SERVICES_REGION"], env["AZURE_AI_SERVICES_KEY"])
    audio = synthesize_text(env["AZURE_AI_SERVICES_REGION"], token, text)

    output_path = os.path.join(os.path.dirname(__file__), "speech-output.wav")
    with open(output_path, "wb") as audio_file:
        audio_file.write(audio)

    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()

