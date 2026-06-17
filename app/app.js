const scenarios = [
  ["Setup", "Validate endpoints, regions, and redacted keys."],
  ["Language", "Run sentiment, entities, and PII review."],
  ["Vision", "Compare OCR with captions, tags, objects, and people detection."],
  ["Speech", "Create audio and assess pronunciation scores."],
  ["Content Safety", "Check harm categories, prompt shields, and protected material."],
  ["Document Intelligence", "Extract layout, tables, and document structure."],
  ["RAG", "Compare keyword, vector, citations, and groundedness evidence."],
  ["Foundry Agents", "Design tool use, handoff rules, traces, and evaluation gates."],
];

const grid = document.querySelector("#scenario-grid");

for (const [title, description] of scenarios) {
  const card = document.createElement("article");
  card.className = "card";
  card.innerHTML = `<h3>${title}</h3><p>${description}</p>`;
  grid.appendChild(card);
}

document.querySelector("#guardrail-form").addEventListener("submit", (event) => {
  event.preventDefault();
  const prompt = document.querySelector("#prompt").value.toLowerCase();
  const risky = ["ignore", "system prompt", "bypass", "jailbreak", "reveal"].some((term) => prompt.includes(term));
  const output = document.querySelector("#guardrail-output");
  output.value = risky
    ? "Decision: block or review. Run 11_content_safety_guardrails.py for live Prompt Shields evidence."
    : "Decision: likely allow. Still run Content Safety before model-heavy workflows.";
});
