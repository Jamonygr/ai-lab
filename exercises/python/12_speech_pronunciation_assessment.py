import os

import requests

from ai_lab_client import load_env, print_json, require_env


def issue_speech_token(region: str, key: str) -> str:
    url = f"https://{region}.api.cognitive.microsoft.com/sts/v1.0/issueToken"
    response = requests.post(url, headers={"Ocp-Apim-Subscription-Key": key}, timeout=30)
    response.raise_for_status()
    return response.text


def synthesize_reference_audio(region: str, token: str, text: str, output_path: str) -> None:
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
    with open(output_path, "wb") as audio_file:
        audio_file.write(response.content)


def main() -> None:
    load_env()
    env = require_env(["AZURE_AI_SERVICES_KEY", "AZURE_AI_SERVICES_REGION"])

    try:
        import azure.cognitiveservices.speech as speechsdk
    except ImportError as exc:
        raise RuntimeError("Install requirements.txt before running this exercise.") from exc

    reference_text = "AI Lab helps learners practice cloud AI services safely."
    output_path = os.path.join(os.path.dirname(__file__), "pronunciation-output.wav")
    token = issue_speech_token(env["AZURE_AI_SERVICES_REGION"], env["AZURE_AI_SERVICES_KEY"])
    synthesize_reference_audio(env["AZURE_AI_SERVICES_REGION"], token, reference_text, output_path)

    speech_config = speechsdk.SpeechConfig(
        subscription=env["AZURE_AI_SERVICES_KEY"],
        region=env["AZURE_AI_SERVICES_REGION"],
    )
    audio_config = speechsdk.audio.AudioConfig(filename=output_path)
    assessment_config = speechsdk.PronunciationAssessmentConfig(
        reference_text=reference_text,
        grading_system=speechsdk.PronunciationAssessmentGradingSystem.HundredMark,
        granularity=speechsdk.PronunciationAssessmentGranularity.Phoneme,
        enable_miscue=True,
    )
    recognizer = speechsdk.SpeechRecognizer(speech_config=speech_config, audio_config=audio_config, language="en-US")
    assessment_config.apply_to(recognizer)
    result = recognizer.recognize_once()
    assessment = speechsdk.PronunciationAssessmentResult(result)

    print_json(
        {
            "audioFile": output_path,
            "recognizedText": result.text,
            "accuracyScore": assessment.accuracy_score,
            "fluencyScore": assessment.fluency_score,
            "completenessScore": assessment.completeness_score,
            "pronunciationScore": assessment.pronunciation_score,
        }
    )


if __name__ == "__main__":
    main()
