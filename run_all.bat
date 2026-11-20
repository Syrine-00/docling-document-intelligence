@echo off
REM Runs the whole Member 1 pipeline: Docling engine + pdfplumber baseline + comparison report.
cd /d "%~dp0"
if not exist ".venv\Scripts\activate.bat" (
  echo ERROR: run setup_windows.bat first.
  pause
  exit /b 1
)
call ".venv\Scripts\activate.bat"
echo === 1/3 Docling engine on samples\ (first run downloads models: be patient) ===
python -m engine.convert samples --out output
echo === 2/3 pdfplumber baseline ===
python compare_pdfplumber.py samples --out output_baseline
echo === 3/3 Comparison report ===
python compare_report.py
echo.
echo Results: output\  output_baseline\  comparison_report.md
pause
