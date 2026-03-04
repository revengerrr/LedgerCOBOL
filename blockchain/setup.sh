#!/bin/bash

# LedgerCOBOL - Solana Blockchain Setup
# ======================================

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║       LEDGERCOBOL - SOLANA BLOCKCHAIN SETUP                   ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Check Python
echo "📦 Step 1: Checking Python..."
if command -v python3 &> /dev/null; then
    echo "✅ Python found"
else
    echo "❌ Python 3 not found!"
    exit 1
fi

# Step 2: Install Python packages
echo ""
echo "📦 Step 2: Installing Solana Python packages..."
pip3 install -r requirements.txt

if [ $? -eq 0 ]; then
    echo "✅ Packages installed"
else
    echo "❌ Failed to install packages"
    exit 1
fi

# Step 3: Install Solana CLI (optional but recommended)
echo ""
echo "📦 Step 3: Checking Solana CLI (optional)..."
if command -v solana &> /dev/null; then
    echo "✅ Solana CLI found"
    solana --version
else
    echo "⚠️  Solana CLI not found (optional)"
    echo "   Install: sh -c \"\$(curl -sSfL https://release.solana.com/stable/install)\""
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    SETUP COMPLETE! ✅                         ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  To start:                                                    ║"
echo "║                                                               ║"
echo "║  1. Run the blockchain bridge:                                ║"
echo "║     $ python3 solana_bridge.py                                ║"
echo "║                                                               ║"
echo "║  2. First time? Request free SOL:                             ║"
echo "║     Select option 2 (Airdrop)                                 ║"
echo "║                                                               ║"
echo "║  3. Sync COBOL transactions:                                  ║"
echo "║     Select option 3                                           ║"
echo "║                                                               ║"
echo "║  Network: Solana Devnet (FREE, no real crypto needed)         ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
