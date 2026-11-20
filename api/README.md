# Member 3 - API (FastAPI)

Put your code here (`api/`); retrieval and answering go in `qa/`.

**Input:** `output/*/<pdf>.docling.json`, `output/*/tables/*.json`, and Member 2's verdicts
(use a hard-coded verdict until they exist).

**To build:** `POST /convert`, `GET /tables/{id}`, `POST /ask`.
Add the libraries you need (for example `fastapi`, `uvicorn`) to `requirements.txt` and tell the team.

**Gives to:** Member 4, who calls the API from the watch-folder / n8n workflow.
