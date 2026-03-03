@echo off
REM LedgerCOBOL AI Agent Setup Script for Windows
REM ==============================================

echo ===============================================================
echo            LEDGERCOBOL AI AGENT - SETUP SCRIPT
echo ===============================================================
echo.

REM Step 1: Check Python
echo [Step 1] Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found!
    echo         Please install Python 3.8+ from https://python.org
    pause
    exit /b 1
)
echo [OK] Python found

REM Step 2: Install Python dependencies
echo.
echo [Step 2] Installing Python dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed

REM Step 3: Check Ollama
echo.
echo [Step 3] Checking Ollama...
ollama --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Ollama not found!
    echo           Please install from https://ollama.ai
    echo           Then run: ollama pull llama3.2
    pause
    exit /b 1
)
echo [OK] Ollama found

REM Step 4: Pull model
echo.
echo [Step 4] Pulling AI model (llama3.2)...
echo          This may take a few minutes...
ollama pull llama3.2

echo.
echo ===============================================================
echo                     SETUP COMPLETE!
echo ===============================================================
echo.
echo To start the AI Agent:
echo.
echo 1. Open a new terminal and run:
echo    ollama serve
echo.
echo 2. In this terminal, run:
echo    python ai_agent.py
echo.
echo 3. Start chatting!
echo.
pause
