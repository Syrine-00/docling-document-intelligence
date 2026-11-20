# Member 4 - Automation, packaging, demo

**To build**
1. Watch-folder script (`watchdog`) and/or an n8n workflow: new PDF arrives -> call the API -> save the result.
   Until Member 3's API exists, build against a fake API that returns a fixed answer.
2. The command that converts PDFs (run from the project root): `python -m engine.convert samples --out output`.
3. Final README, high-resolution screenshots, a 3-5 minute demo video.
4. The archive `Section_GroupNumber_20.zip`: slides, source code with README.md, screenshots, video.
   Do not include `.venv/`, `output*/` or `__pycache__/`.
5. The sequence diagram of the whole flow (ask Members 1-3 for their route and file names early).
