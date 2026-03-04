# 🪙 LedgerCOBOL - Solana Blockchain Integration

> **Immutable audit trail for COBOL transactions on Solana**

Every banking transaction in LedgerCOBOL gets recorded on the Solana blockchain (Devnet), creating a tamper-proof audit trail.

---

## ✨ Features

- 🔗 **Real Blockchain** - Transactions recorded on Solana Devnet
- 🆓 **100% Free** - Devnet uses test SOL (no real money)
- 🔒 **Immutable** - Once recorded, cannot be altered
- 🔍 **Verifiable** - Anyone can verify on Solana Explorer
- 📊 **Auto-sync** - Automatically syncs COBOL transactions

---

## 🏗️ How It Works

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   COBOL Transaction                                     │
│   (Transfer $500 from A to B)                          │
│              │                                          │
│              ▼                                          │
│   Python creates SHA256 hash                           │
│   hash = SHA256(transaction_data)                      │
│              │                                          │
│              ▼                                          │
│   Send minimal tx to Solana Devnet                     │
│   (embeds proof on-chain)                              │
│              │                                          │
│              ▼                                          │
│   Receive transaction signature                        │
│   https://explorer.solana.com/tx/xxxxx                 │
│              │                                          │
│              ▼                                          │
│   IMMUTABLE PROOF! ✅                                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd blockchain
pip install -r requirements.txt
```

### 2. Run the Bridge

```bash
python3 solana_bridge.py
```

### 3. First Time? Get Free SOL

```
--- MENU ---
1. Show Status
2. Request Airdrop (free SOL)  ← Select this!
3. Sync COBOL Transactions
...
```

### 4. Sync Transactions

```
--- MENU ---
3. Sync COBOL Transactions  ← This syncs from HISTORY.DAT
```

---

## 📋 Menu Options

| Option | Description |
|--------|-------------|
| **1. Show Status** | View wallet address and SOL balance |
| **2. Request Airdrop** | Get free test SOL from Devnet faucet |
| **3. Sync COBOL Transactions** | Auto-sync from HISTORY.DAT to blockchain |
| **4. Record Manual Transaction** | Manually record a transaction |
| **5. View Blockchain Ledger** | Show all recorded transactions |
| **6. Verify Transaction** | Verify a transaction hash on-chain |
| **7. Exit** | Exit the program |

---

## 🔍 Verifying Transactions

Every transaction gets a Solana signature. You can verify it:

1. Copy the signature from the ledger
2. Go to: `https://explorer.solana.com/tx/YOUR_SIGNATURE?cluster=devnet`
3. See the transaction on-chain!

Example output:
```
📦 Block #1
   Timestamp: 2026-03-04T14:30:25
   Type: T (Transfer)
   Amount: 500000
   Hash: a1b2c3d4e5f6...
   ✅ On-chain: 5KQwC...
   🔍 https://explorer.solana.com/tx/5KQwC...?cluster=devnet
```

---

## 💰 About Devnet

| Aspect | Devnet | Mainnet |
|--------|--------|---------|
| **Cost** | 🆓 FREE | Real SOL ($$$) |
| **SOL** | Test tokens (no value) | Real cryptocurrency |
| **Purpose** | Development & testing | Production |
| **Airdrop** | ✅ Available | ❌ No |

**For this project, we use Devnet only!** No real money needed.

---

## 📁 Files

| File | Description |
|------|-------------|
| `solana_bridge.py` | Main Python script |
| `requirements.txt` | Python dependencies |
| `setup.sh` | Setup script |
| `wallet.json` | Auto-generated wallet (keep secret!) |
| `blockchain_ledger.json` | Local record of all transactions |

---

## ⚠️ Important Notes

1. **wallet.json** is auto-generated. Don't share it!
2. **Devnet SOL has no real value** - it's for testing only
3. **Airdrop may fail** if Devnet faucet is busy - just retry
4. **Transactions are permanent** once on-chain

---

## 🔧 Configuration

Edit `solana_bridge.py` to change:

```python
SOLANA_NETWORK = "https://api.devnet.solana.com"  # Devnet (free)
# SOLANA_NETWORK = "https://api.mainnet-beta.solana.com"  # Mainnet (costs real SOL)

COBOL_HISTORY = "../HISTORY.DAT"  # Path to COBOL history file
```

---

## 🛠️ Troubleshooting

### "Airdrop failed"
Devnet faucet might be busy. Wait a few minutes and try again.

### "Insufficient balance"
Run option 2 to request free SOL airdrop.

### "Transaction failed"
Check your internet connection. Devnet requires internet access.

### "HISTORY.DAT not found"
Make sure COBOL banking system has been used and created transactions.

---

## 🔗 Links

- [Solana Explorer (Devnet)](https://explorer.solana.com/?cluster=devnet)
- [Solana Documentation](https://docs.solana.com/)
- [Solana Devnet Faucet](https://faucet.solana.com/)

---

<div align="center">

**COBOL (1959) + AI + Solana (Web3)**

*The ultimate legacy-to-future bridge*

</div>
