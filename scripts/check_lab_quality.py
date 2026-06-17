import os
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SECRET_PATTERNS = [
    re.compile(r"(?i)(api[_-]?key|subscription[_-]?key|access[_-]?key)\s*=\s*['\"][A-Za-z0-9+/=]{24,}"),
    re.compile(r"(?i)EndpointSuffix=core\.windows\.net;AccountName=.*;AccountKey="),
]
GENERATED_NAMES = {"terraform.tfstate", "terraform.tfstate.backup", "ai-lab.tfplan", "speech-output.wav"}
MARKDOWN_LINK = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


def tracked_files() -> list:
    import subprocess

    output = subprocess.check_output(["git", "ls-files"], cwd=ROOT, text=True)
    return [ROOT / line.strip() for line in output.splitlines() if line.strip()]


def check_generated_artifacts(files: list) -> list:
    return [f"Generated artifact is tracked: {path.relative_to(ROOT)}" for path in files if path.name in GENERATED_NAMES]


def check_secrets(files: list) -> list:
    errors = []
    for path in files:
        if path.suffix.lower() in {".png", ".jpg", ".jpeg", ".gif", ".pdf", ".wav"}:
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        for pattern in SECRET_PATTERNS:
            if pattern.search(text):
                errors.append(f"Possible secret pattern in {path.relative_to(ROOT)}")
    return errors


def check_markdown_links(files: list) -> list:
    errors = []
    for path in files:
        if path.suffix.lower() != ".md":
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        for match in MARKDOWN_LINK.finditer(text):
            target = match.group(1).split("#", 1)[0]
            if not target or re.match(r"^[a-z]+://", target) or target.startswith("mailto:"):
                continue
            candidate = (path.parent / target).resolve()
            if not str(candidate).startswith(str(ROOT.resolve())):
                errors.append(f"Markdown link escapes repo in {path.relative_to(ROOT)}: {target}")
            elif not candidate.exists():
                errors.append(f"Broken markdown link in {path.relative_to(ROOT)}: {target}")
    return errors


def check_prompt_flow_guidance(files: list) -> list:
    errors = []
    for path in files:
        if path.suffix.lower() not in {".md", ".py", ".tf", ".txt", ".yml"}:
            continue
        text = path.read_text(encoding="utf-8", errors="ignore").lower()
        if "prompt flow" in text and "not build new prompt flow" not in text and "avoid prompt flow" not in text:
            errors.append(f"Prompt Flow mention needs retirement guidance in {path.relative_to(ROOT)}")
    return errors


def main() -> int:
    files = tracked_files()
    errors = []
    errors.extend(check_generated_artifacts(files))
    errors.extend(check_secrets(files))
    errors.extend(check_markdown_links(files))
    errors.extend(check_prompt_flow_guidance(files))

    if errors:
        for error in errors:
            print(error)
        return 1

    print(f"Lab quality checks passed for {len(files)} tracked files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
