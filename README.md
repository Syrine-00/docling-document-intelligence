# Layout-Aware Document Intelligence & Table Structure Reconstruction Harness with IBM Docling

Subject #20 (DS1). Team project: a pipeline that turns complex PDFs into verified tables,
and only answers questions from tables that passed deterministic checks.

```
PDF dropped in a watch-folder / n8n webhook
  -> Docling (layout analysis + TableFormer)        [Member 1: engine/]
  -> tables as JSON in the team contract            [Member 1: engine/]
  -> checksum validation (Pydantic v2 + pytest)     [Member 2: harness/, tests/]
  -> chunking, FastAPI, grounded Q&A                [Member 3: api/, qa/]
  -> automation, packaging, demo                    [Member 4: automation/]
```

Official reference: https://github.com/docling-project/docling

---

## What is verified and what is not

| Item | Status |
|---|---|
| `engine/convert.py` on 3 sample PDFs with Docling 2.151.1 on Windows | Run by Yosr: 1 table each for `sample_simple_table`, `sample_two_column_table` and `sample_wrong_total` |
| `sample_wrong_total_long_title.pdf` | Docling found **0 tables** (normal, OCR, accurate, OCR+accurate), and the CLI labelled the table as an image. Cause not established. Kept as a real failure case |
| 55 `pytest` tests (no AI models needed) | Pass in the author's test environment. Include a real Docling run on an Excel file and on a corrupt Word file |
| Word, Excel and HTML input (real Docling run, 3 files) | Worked in the author's test environment: 1 table each; number formats parsed. Not tested on your PCs |
| PDF retry cascade (fast, accurate, OCR + accurate) and the AI vision option `--vlm` | Logic tested with fake converters only. The real PDF cascade and `--vlm` have **not** been run |
| Scanned PDFs, borderless tables, merged cells, images, PowerPoint | **Not tested** |
| `setup_windows.bat`, `run_all.bat` | Written but **not tested on Windows**. If one fails, use the manual commands below |
| Table content correctness across tools | **Not measured yet**: needs Member 2's validator and harder PDFs |

---

## Quick start on Windows (everyone does this)

Requirements: **Python 3.12** (3.10 or newer works), internet for the first run, about 5 GB free disk.

**Option A: two double-clicks**

1. Unzip the project. Open the **inner** folder that contains `README.md` (you may see `docling_team_project\docling_team_project`).
2. Double-click `setup_windows.bat` (5-15 minutes). It must end with `55 passed`.
3. Double-click `run_all.bat`. The first run downloads the AI models.

**Option B: manual commands (use this if a .bat fails)**

```
cd C:\path\to\docling_team_project
py -m venv .venv
.venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
python -m pytest -q
python -m engine.convert samples --out output
python compare_pdfplumber.py samples --out output_baseline
python compare_report.py
```

Replace `C:\path\to\docling_team_project` with the real folder. You must see `(.venv)` at the start of the
line before `python` or `pip`. Open a new terminal later? Repeat the `cd` and the `activate.bat` lines.

### Which files does it accept, and what does it do when something goes wrong?

It does **not** accept "any" file. It accepts: PDF, Word `.docx`, PowerPoint `.pptx`, Excel `.xlsx`, HTML, and
images (`.png .jpg .tif`). Old `.doc`, `.ppt`, `.xls` files are ignored: save them as `.docx`, `.pptx`, `.xlsx` first.

| Situation | What the engine does |
|---|---|
| A file cannot be read (corrupt, password-protected, too big) | Marks it `failed` with the error, keeps going with the other files, exits with code 2 |
| A PDF gives 0 tables | Retries: fast, then accurate, then OCR + accurate (and the AI vision model if you pass `--vlm`). If still 0: status `no_tables` and a warning |
| Numbers like `1 234,56`, `1.234,56`, `(120)`, `$40` | Converted to numbers. `12%` and `5 TND` stay text. `1,500` is read as 1500 |
| Tables with merged cells | Flattened to rows and columns (multi-level headers are joined); the structure is not kept |

Options: `--accurate`, `--ocr`, `--vlm` (AI vision model: slow, large download, not tested), `--no-fallback`.
Everything is written to `output\run_report.json`: `ok`, `no_tables` or `failed` for every file.

**AI does not replace the checks.** Whatever Docling, OCR or the vision model extracts is only data. It must pass the
harness checksums (Member 2) before anyone answers from it. A table that is read wrongly but looks plausible is the
real danger, and only the checksums can catch it.

### Expected result of `python -m engine.convert samples --out output`

```
sample_simple_table.pdf: 1 table(s) [ok] -> output\sample_simple_table
sample_two_column_table.pdf: 1 table(s) [ok] -> output\sample_two_column_table
sample_wrong_total.pdf: 1 table(s) [ok] -> output\sample_wrong_total
sample_wrong_total_long_title.pdf: 0 table(s) [no_tables] -> output\sample_wrong_total_long_title  <- 0 tables
  WARNING: 0 tables found. ...
  attempts: fast=0, accurate=0, ocr+accurate=0
```

(each line also shows `[ok]` and the output folder; shortened here). The last PDF is expected to give 0 tables, and the retries take extra time. If your numbers differ, tell Member 1 and keep your output: it is a result.

### Docling command line (for the slides)

```
docling convert samples/sample_simple_table.pdf --to md --output cli_output
```

Options confirmed in `docling convert --help` for 2.151.1: `--to`, `--output`, `--table-mode fast|accurate`, `--ocr/--no-ocr`, `--device`.

---

## The team contract (JSON)

Member 1 produces tables in this format; everyone reads it:

```json
{
  "doc_id": "sample_simple_table",
  "table_id": "sample_simple_table_p1_t1",
  "page": 1,
  "columns": ["Item", "Q1", "Q2", "Q3", "Total"],
  "rows": [["Laptops", 120, 135, 150, 405], ["Total", 400, 410, 440, 1250]]
}
```

(abridged: real files contain every row). An empty cell is `null`. Member 2 returns one verdict per table:

```json
{ "table_id": "sample_simple_table_p1_t1", "passed": true, "reason": "" }
```

Member 3 answers only from tables with `passed: true`. A PDF with **0 tables** where one is expected counts as a failure.
Never rename a field without telling all four members the same day.

---

## Who does what

See `TEAM_PLAN.md`, and the README inside each folder (`harness/`, `api/`, `qa/`, `automation/`).

## Folder map

```
engine/               Member 1: PDF -> Docling -> contract JSON (contract.py needs no Docling)
fixtures/             5 hand-written tables (2 good, 3 broken) to build against
samples/              4 sample PDFs (made by make_samples.py)
harness/  tests/      Member 2: checksum validator and its pytest suite (tests/ already holds Member 1's tests)
api/  qa/             Member 3: FastAPI endpoints, chunking, grounded Q&A
automation/           Member 4: watch-folder / n8n, packaging, demo
docs/                 slide guide for Member 1
compare_pdfplumber.py baseline extractor (same output format)
compare_report.py     counts tables found per PDF for both tools
make_samples.py       regenerates samples/ (close the PDFs first)
setup_windows.bat, run_all.bat   Windows helpers
```

## Common problems

| Problem | Fix |
|---|---|
| `No module named engine` | You are not in the project folder: `cd` into the folder that contains `README.md` |
| `PermissionError` on a file | That file is open in Excel or a PDF viewer. Close it and run again |
| First run is very slow | Docling is downloading its models, once. Wait |
| `python` not found | Reinstall Python 3.12 with "Add python.exe to PATH" ticked, open a new terminal |
| `No module named 'encodings'` | Broken Python install: remove old Python versions and clean the PATH, then reinstall |
| 0 tables for a PDF | Expected for `sample_wrong_total_long_title.pdf`. The engine already retries; for others try `--vlm` and report it |
| `failed` for a file | Read the `ERROR:` line. Corrupt, password-protected or unsupported files cannot be read; the other files are still processed |

## Rules from the professor

Zero forcing, zero hallucinations, zero falsifications: every command in the slides must have been run by you,
and every claim needs a source link. Archive name: `Section_GroupNumber_20.zip`.
