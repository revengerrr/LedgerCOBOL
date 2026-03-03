# 🤖 LedgerCOBOL AI Agent

> **Talk to a 1959 banking system using natural language AI**

This is the AI-powered interface for LedgerCOBOL. It uses **Ollama** (local LLM) to understand your banking requests and execute them on the COBOL system.

---

## ✨ Features

- 💬 **Natural Language** - Just talk normally, AI understands
- 🏦 **Full Banking** - Deposits, withdrawals, transfers
- 🔒 **100% Local** - No cloud, no API fees, runs offline
- 🚀 **Fast Setup** - One script to install everything

---

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- GnuCOBOL (for the banking system)
- 8GB RAM (for AI model)

### Installation

**Linux/macOS:**
```bash
cd ai-agent
chmod +x setup.sh
./setup.sh
```

**Windows:**
```cmd
cd ai-agent
setup.bat
```

### Running

**Terminal 1 - Start Ollama:**
```bash
ollama serve
```

**Terminal 2 - Start AI Agent:**
```bash
python3 ai_agent.py
```

---

## 💬 Usage Examples

Just type naturally:

```
👤 You: Hi, I want to deposit some money

🤖 AI: Hello! I'd be happy to help you make a deposit. 
       Which account would you like to deposit to, and how much?

👤 You: Deposit 500000 to account 1000000001

🤖 AI: I'll deposit $500,000 to account 1000000001 for you.
⏳ Processing deposit...
✅ Deposited $500,000 to account 1000000001

👤 You: Now transfer 100000 to account 1000000002

🤖 AI: I'll transfer $100,000 to account 1000000002.
⏳ Processing transfer...
✅ Transferred $100,000 from 1000000001 to 1000000002

👤 You: Show my balance

🤖 AI: Let me check your balance.
⏳ Fetching balance report...
[Balance report displayed]
```

---

## 🎯 Supported Commands

| Command | Example |
|---------|---------|
| **Deposit** | "Deposit 500000 to account 1000000001" |
| **Withdraw** | "Withdraw 100000 from my account" |
| **Transfer** | "Transfer 1 million to account 1000000002" |
| **Balance** | "Show my balance" / "Check balance" |
| **History** | "Show transaction history" |
| **Login** | "Login as admin" |
| **Logout** | "Logout" |
| **Help** | "Help" |

---

## 🔧 Configuration

Edit `ai_agent.py` to change:

```python
MODEL = "llama3.2"  # Change to "mistral", "phi3", etc.
OLLAMA_URL = "http://localhost:11434/api/generate"
COBOL_DIR = ".."  # Path to COBOL executables
```

### Supported AI Models

| Model | RAM Required | Quality | Speed |
|-------|-------------|---------|-------|
| `llama3.2:1b` | 4GB | ⭐⭐⭐ | ⚡⚡⚡ |
| `llama3.2` (3b) | 6GB | ⭐⭐⭐⭐ | ⚡⚡ |
| `mistral` | 8GB | ⭐⭐⭐⭐ | ⚡⚡ |
| `phi3` | 4GB | ⭐⭐⭐ | ⚡⚡⚡ |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     USER INPUT                          │
│              "Deposit 500k to John"                     │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                   OLLAMA (Local LLM)                    │
│                                                         │
│  Understands intent → Returns structured command:       │
│  {"action": "DEPOSIT", "amount": "500000", ...}        │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                  PYTHON BRIDGE                          │
│                                                         │
│  Parses AI response → Calls COBOL program              │
│  subprocess.run("TRANS-PROC", inputs=[...])            │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                  COBOL BANKING SYSTEM                   │
│                                                         │
│  TRANS-PROC.CBL executes → Updates ACCOUNTS.DAT        │
│  Returns result to Python                               │
└─────────────────────────────────────────────────────────┘
```

---

## 🐛 Troubleshooting

### "Ollama is not running"
```bash
# Start Ollama server
ollama serve
```

### "Model not found"
```bash
# Pull the model first
ollama pull llama3.2
```

### "COBOL program not found"
```bash
# Compile COBOL first
cd ..
cobc -x BANK-MAIN.CBL
cobc -m TRANS-PROC.CBL
# ... compile all modules
```

### Slow response
```bash
# Use smaller model
# Edit ai_agent.py:
MODEL = "llama3.2:1b"  # Faster, less accurate
```

---

## 📜 License

MIT License - Same as LedgerCOBOL

---

<div align="center">

**🤖 Where 1959 meets 2026**

*AI-Powered Legacy Banking*

</div>
