# Member 2 - Verification harness

Put your code here (`harness/`) and your tests in `tests/`.

**Input:** tables in the team contract format (see the root `README.md`).
Start with `fixtures/`, then use `output/*/tables/*.json` (Docling) and `output_baseline/*/tables/*.json` (pdfplumber).

**To build**
1. Pydantic v2 models: `TableResult`, `ValidationReport`.
2. Checks: row sums vs the `Total` column, column sums vs the `Total` row, empty cells, same number of cells on every row.
3. One verdict per table: `{ "table_id": "...", "passed": true|false, "reason": "..." }`.
4. pytest on the fixtures: `good_table_1`, `good_table_2` pass; `wrong_total`, `missing_cell`, `ragged_columns` fail, each for its own reason.
5. A PDF with 0 tables where one is expected is a failure (see `samples/sample_wrong_total_long_title.pdf`).
6. Run the validator on `output/` and `output_baseline/` and report the pass rate of each tool to Member 1.

**Gives to:** Member 3 (verdicts) and Member 1 (pass rates for the comparison matrix).
