# Team plan: who does what, and what depends on whom

Each member has one practical part (code) and one theoretical part (slides) on the same topic,
so everyone can defend what they built in the live Q&A.

| Member | Practical (folder) | Theoretical (slides) | Needs from | Gives to |
|---|---|---|---|---|
| 1 | Core engine (`engine/`), samples, fixtures, baseline | Docling architecture, install and CLI, comparison matrix | nobody | everyone |
| 2 | Verification harness (`harness/`, `tests/`) | TableFormer, extraction failures, TEDS, the "harness" idea, Pydantic v2 and pytest | Member 1: fixtures, then real tables | Member 3: verdicts; Member 1: pass rates |
| 3 | Chunking, API, grounded Q&A (`api/`, `qa/`) | Chunking, RAG, grounding, FastAPI | Members 1 and 2 | Member 4: the API |
| 4 | Automation, README, screenshots, video, final zip (`automation/`) | Intro, conclusion, automation options, sequence diagram | Member 3 (API) and all folders | the professor: the archive |

## Day 1 (nobody waits for anyone)

- Member 1: shares this project (the zip) and checks that `fixtures/` and `samples/` are in it.
- Member 2: builds and tests the validator on `fixtures/`.
- Member 3: builds against the fixtures with a hard-coded verdict.
- Member 4: builds the watch-folder against a fake API that returns a fixed answer.

## Integration

Swap the fixtures for real Docling output (`output/*/tables/*.json`), run all four parts together, fix what breaks.

## Cross-review

Each member reviews the next one's code and slides (1 -> 2 -> 3 -> 4 -> 1). The professor can ask any member about any part.

## Note for Members 2 and 3: statuses

`output/run_report.json` gives each file a status: `ok`, `no_tables` or `failed`. Treat `no_tables` (where a table is
expected) and `failed` as failures, never as a pass. AI or OCR output is still just data: it goes through the same
checksums as everything else.

## Honesty rules

Run every command before showing it. Cite a source for every claim. Report mixed or negative results as they are.
