from ai_lab_client import deterministic_vector, load_env, require_env


DOCS = [
    {
        "id": "1",
        "title": "Responsible AI",
        "content": "Content Safety checks prompts and completions for harmful categories, protected material, and prompt attacks.",
        "source": "wiki/security-and-cost.md",
        "category": "responsible-ai",
    },
    {
        "id": "2",
        "title": "Document Intelligence",
        "content": "Document Intelligence extracts text, tables, key-value pairs, and layout structure from PDFs and forms.",
        "source": "wiki/scenarios/README.md",
        "category": "documents",
    },
    {
        "id": "3",
        "title": "RAG quality",
        "content": "A stronger RAG workflow compares keyword search, vector search, citations, and answer grounding.",
        "source": "wiki/runbooks/deploy-and-test.md",
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
        from azure.search.documents.indexes.models import (
            HnswAlgorithmConfiguration,
            SearchField,
            SearchFieldDataType,
            SearchIndex,
            SearchableField,
            SimpleField,
            VectorSearch,
            VectorSearchProfile,
        )
        from azure.search.documents.models import VectorizedQuery
    except ImportError as exc:
        raise RuntimeError("Install requirements.txt before running this exercise.") from exc

    import os

    index_name = os.getenv("AI_SEARCH_ADVANCED_INDEX", "ai-lab-rag-advanced")
    credential = AzureKeyCredential(env["AI_SEARCH_KEY"])
    index_client = SearchIndexClient(env["AI_SEARCH_ENDPOINT"], credential)

    fields = [
        SimpleField(name="id", type=SearchFieldDataType.String, key=True),
        SearchableField(name="title", type=SearchFieldDataType.String),
        SearchableField(name="content", type=SearchFieldDataType.String),
        SimpleField(name="source", type=SearchFieldDataType.String, filterable=True),
        SimpleField(name="category", type=SearchFieldDataType.String, filterable=True, facetable=True),
        SearchField(
            name="content_vector",
            type=SearchFieldDataType.Collection(SearchFieldDataType.Single),
            searchable=True,
            vector_search_dimensions=8,
            vector_search_profile_name="default-vector-profile",
        ),
    ]
    vector_search = VectorSearch(
        algorithms=[HnswAlgorithmConfiguration(name="default-hnsw")],
        profiles=[VectorSearchProfile(name="default-vector-profile", algorithm_configuration_name="default-hnsw")],
    )
    index_client.create_or_update_index(SearchIndex(name=index_name, fields=fields, vector_search=vector_search))

    documents = []
    for doc in DOCS:
        enriched = dict(doc)
        enriched["content_vector"] = deterministic_vector(doc["content"])
        documents.append(enriched)

    search_client = SearchClient(env["AI_SEARCH_ENDPOINT"], index_name, credential)
    search_client.upload_documents(documents)

    question = "How do I make RAG safer and easier to trust?"
    vector_query = VectorizedQuery(vector=deterministic_vector(question), k_nearest_neighbors=3, fields="content_vector")
    results = search_client.search(search_text="safe trustworthy RAG", vector_queries=[vector_query], top=3)

    print("Hybrid vector results with citation sources:")
    for result in results:
        print(f"- {result['title']} ({result['source']}): {result['content']}")


if __name__ == "__main__":
    main()
