@echo off
REM Creates the virtual environment and installs everything. Run ONCE (double-click or: setup_windows.bat).
cd /d "%~dp0"
echo === Creating virtual environment (.venv) ===
py -3.12 -m venv .venv || python -m venv .venv
if not exist ".venv\Scripts\activate.bat" (
  echo ERROR: could not create .venv. Check that Python 3.12 is installed: python --version
  pause
  exit /b 1
)
call ".venv\Scripts\activate.bat"
echo === Upgrading pip ===
python -m pip install --upgrade pip
echo === Installing requirements (5-15 minutes, large download) ===
pip install -r requirements.txt
echo === Running tests ===
python -m pytest -q
echo.
echo Done. Next: run_all.bat
pause
