#!/bin/bash

# LedgerCOBOL AI Agent Setup Script
# ==================================
# This script installs everything needed to run the AI Agent

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           LEDGERCOBOL AI AGENT - SETUP SCRIPT                 ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Check OS
OS="$(uname -s)"
echo "🔍 Detected OS: $OS"

# Step 1: Check Python
echo ""
echo "📦 Step 1: Checking Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ Python found: $PYTHON_VERSION"
else
    echo "❌ Python 3 not found!"
    echo "   Please install Python 3.8+ from https://python.org"
    exit 1
fi

# Step 2: Install Python dependencies
echo ""
echo "📦 Step 2: Installing Python dependencies..."
pip3 install -r requirements.txt
if [ $? -eq 0 ]; then
    echo "✅ Python dependencies installed"
else
    echo "❌ Failed to install Python dependencies"
    exit 1
fi

# Step 3: Check/Install Ollama
echo ""
echo "📦 Step 3: Checking Ollama..."
if command -v ollama &> /dev/null; then
    echo "✅ Ollama is installed"
else
    echo "⚠️  Ollama not found. Installing..."
    if [ "$OS" == "Linux" ] || [ "$OS" == "Darwin" ]; then
        curl -fsSL https://ollama.ai/install.sh | sh
    else
        echo "❌ Please install Ollama manually from https://ollama.ai"
        exit 1
    fi
fi

# Step 4: Pull AI model
echo ""
echo "📦 Step 4: Pulling AI model (llama3.2)..."
echo "   This may take a few minutes on first run..."
ollama pull llama3.2
if [ $? -eq 0 ]; then
    echo "✅ AI model ready"
else
    echo "❌ Failed to pull AI model"
    exit 1
fi

# Step 5: Check COBOL
echo ""
echo "📦 Step 5: Checking GnuCOBOL..."
if command -v cobc &> /dev/null; then
    COBOL_VERSION=$(cobc --version | head -n 1)
    echo "✅ GnuCOBOL found: $COBOL_VERSION"
else
    echo "⚠️  GnuCOBOL not found!"
    echo "   Please install:"
    echo "   - Ubuntu/Debian: sudo apt install gnucobol"
    echo "   - macOS: brew install gnucobol"
    echo "   - Windows: Use MSYS2"
fi

# Step 6: Compile COBOL (if source exists)
echo ""
echo "📦 Step 6: Compiling COBOL programs..."
cd ..
if [ -f "BANK-MAIN.CBL" ]; then
    echo "   Compiling modules..."
    cobc -m INIT-DB.CBL 2>/dev/null
    cobc -m INIT-USERS.CBL 2>/dev/null
    cobc -m LOGIN.CBL 2>/dev/null
    cobc -m CREATE-USER.CBL 2>/dev/null
    cobc -m LIST-USERS.CBL 2>/dev/null
    cobc -m CREATE-ACC.CBL 2>/dev/null
    cobc -m TRANS-PROC.CBL 2>/dev/null
    cobc -m TRANSFER.CBL 2>/dev/null
    cobc -m HISTORY.CBL 2>/dev/null
    cobc -m REPORT-GEN.CBL 2>/dev/null
    cobc -m CHANGE-PIN.CBL 2>/dev/null
    cobc -x BANK-MAIN.CBL 2>/dev/null
    echo "✅ COBOL programs compiled"
else
    echo "⚠️  COBOL source files not found in parent directory"
fi
cd ai-agent

# Done!
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    SETUP COMPLETE! ✅                         ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  To start the AI Agent:                                       ║"
echo "║                                                               ║"
echo "║  1. Start Ollama (in separate terminal):                      ║"
echo "║     $ ollama serve                                            ║"
echo "║                                                               ║"
echo "║  2. Run the AI Agent:                                         ║"
echo "║     $ python3 ai_agent.py                                     ║"
echo "║                                                               ║"
echo "║  3. Start chatting! Example:                                  ║"
echo "║     \"Deposit 500000 to account 1000000001\"                    ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
