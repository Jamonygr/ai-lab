from ai_lab_client import load_env, require_env


DOCS = [
    {
        "id": "1",
        "title": "AI Lab",
        "content": "AI Lab teaches beginner Azure AI services with Terraform and Python.",
        "category": "overview",
    },
    {
        "id": "2",
        "title": "Content Safety",
        "content": "Content Safety helps review user text for harmful content categories.",
        "category": "responsible-ai",
    },
    {
        "id": "3",
        "title": "Azure AI Search",
        "content": "Azure AI Search can retrieve relevant documents before an app produces an answer.",
        "category": "retrieval",
    },
]


def main() -> None:
    load_env()
    env = require_env(["AI_SEARCH_ENDPOINT", "AI_SEARCH_KEY"])

    try:
        from azure.core.credentials import AzureKeyCredential
        from azure.search.documents import SearchClient
        from azure.search.documents.indexes import SearchIndexClient
        from azure.search.documents.indexes.models import SearchField, SearchFieldDataType, SearchIndex, SimpleField, SearchableField
    except ImportError as exc:
        raise RuntimeError("Install requirements.txt before running this exercise.") from exc

    index_name = __import__("os").getenv("AI_SEARCH_INDEX", "ai-lab-docs")
    credential = AzureKeyCredential(env["AI_SEARCH_KEY"])
    index_client = SearchIndexClient(env["AI_SEARCH_ENDPOINT"], credential)

    fields = [
        SimpleField(name="id", type=SearchFieldDataType.String, key=True),
        SearchableField(name="title", type=SearchFieldDataType.String),
        SearchableField(name="content", type=SearchFieldDataType.String),
        SearchField(name="category", type=SearchFieldDataType.String, filterable=True, facetable=True),
    ]
    index = SearchIndex(name=index_name, fields=fields)
    index_client.create_or_update_index(index)

    search_client = SearchClient(env["AI_SEARCH_ENDPOINT"], index_name, credential)
    search_client.upload_documents(DOCS)

    print("Top results for: responsible AI")
    for result in search_client.search("responsible AI", top=3):
        print(f"- {result['title']}: {result['content']}")


if __name__ == "__main__":
    main()
