<div align="center">

<img src="assets/cobol-logo.jpeg" alt="COBOL Logo" width="200"/>

# 🏦 LedgerCOBOL

### **Classic Core Banking System Built with COBOL**

<p align="center">
  <strong>A full-featured banking system demonstrating real banking operations</strong>
</p>

<p align="center">
  <a href="#-quick-start"><img src="https://img.shields.io/badge/Quick-Start-blue?style=for-the-badge&logo=rocket" alt="Quick Start"></a>
  <a href="#-features"><img src="https://img.shields.io/badge/Features-View-green?style=for-the-badge" alt="Features"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/COBOL-GnuCOBOL-blue?style=flat-square" alt="COBOL">
  <img src="https://img.shields.io/badge/AI-Ollama%20%2B%20Llama-purple?style=flat-square" alt="AI">
  <img src="https://img.shields.io/badge/Version-3.5-orange?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-brightgreen?style=flat-square" alt="Status">
</p>

---

**[🚀 Quick Start](#-quick-start)** | **[📖 Documentation](#-components)** | **[🤝 Contributing](#-contributing)**

---

</div>

## 🎯 **What is LedgerCOBOL?**

LedgerCOBOL is a **full-featured core banking system** implemented in COBOL, demonstrating real banking operations including transfers, transaction history, and role-based access control.

### **Why COBOL?**

> 💡 **Fun Fact:** Over 95% of ATM transactions and 80% of in-person transactions still use COBOL today!

- ✅ **Battle-Tested** - Running banks since 1959
- ✅ **Reliable** - Processes trillions of dollars daily
- ✅ **Educational** - Learn how real banking systems work
- ✅ **Full-Featured** - Transfer, history, access control

---

## ✨ **Features**

<table>
<tr>
<td width="50%">

### 🔐 **Real Authentication**
PIN-based login with session management and account lockout.

### 💱 **Transfer Antar Akun**
Send money between accounts with full validation.

### 📝 **Transaction History**
Complete audit trail with date, time, and amount.

</td>
<td width="50%">

### 👥 **Role-Based Access**
Admin, Teller, Customer with different permissions.

### 🏦 **Account Management**
Create new bank accounts with auto-generated numbers.

### 🔒 **Customer Access Control**
Customers can only access their own account.

</td>
</tr>
</table>

---

## 👥 **Role-Based Access Control**

| Feature | Admin | Teller | Customer |
|---------|:-----:|:------:|:--------:|
| Create User | ✅ | ✅ | ❌ |
| View All Users | ✅ | ❌ | ❌ |
| Create Account | ✅ | ✅ | ❌ |
| Init Database | ✅ | ❌ | ❌ |
| Deposit/Withdraw | ✅ (any) | ✅ (any) | ✅ (own) |
| Transfer | ✅ (any) | ✅ (any) | ✅ (from own) |
| View History | ✅ (all) | ✅ (all) | ✅ (own) |
| Account Report | ✅ | ✅ | ✅ (own) |
| Change PIN | ✅ | ✅ | ✅ |

---

## 📁 **Components**

| File | Description |
|------|-------------|
| `BANK-MAIN.CBL` | Main program with role-based dashboards |
| `LOGIN.CBL` | Real authentication with session management |
| `CREATE-USER.CBL` | Admin/Teller create new users |
| `LIST-USERS.CBL` | Admin view all users |
| `CREATE-ACC.CBL` | Create new bank accounts |
| `INIT-DB.CBL` | Initialize sample account data |
| `INIT-USERS.CBL` | Initialize default admin user |
| `TRANS-PROC.CBL` | Deposit/Withdraw with history logging |
| `TRANSFER.CBL` | Transfer between accounts |
| `HISTORY.CBL` | View transaction history |
| `REPORT-GEN.CBL` | Account balance report |
| `CHANGE-PIN.CBL` | Change user PIN |
| `ACCOUNTS.CPY` | Account record copybook |
| `USERS.CPY` | User record copybook |
| `HISTORY.CPY` | Transaction history copybook |

---

## 🚀 **Quick Start**

### **Prerequisites**

You need **GnuCOBOL** installed on your system.

<details>
<summary>📦 <strong>Windows (MSYS2)</strong></summary>

```powershell
pacman -Sy
pacman -S mingw-w64-x86_64-gnucobol
cobc --version
```

</details>

<details>
<summary>🐧 <strong>Linux (Debian/Ubuntu)</strong></summary>

```bash
sudo apt-get update
sudo apt-get install gnucobol
```

</details>

<details>
<summary>🍎 <strong>macOS (Homebrew)</strong></summary>

```bash
brew install gnucobol
```

</details>

---

### **Compilation & Execution**

```bash
# Compile all modules
cobc -m INIT-DB.CBL
cobc -m INIT-USERS.CBL
cobc -m LOGIN.CBL
cobc -m CREATE-USER.CBL
cobc -m LIST-USERS.CBL
cobc -m CREATE-ACC.CBL
cobc -m TRANS-PROC.CBL
cobc -m TRANSFER.CBL
cobc -m HISTORY.CBL
cobc -m REPORT-GEN.CBL
cobc -m CHANGE-PIN.CBL

# Compile main program
cobc -x BANK-MAIN.CBL

# Run
./BANK-MAIN        # Linux/macOS
BANK-MAIN.exe      # Windows
```

---

## 🖥️ **Usage**

### **First Time Setup**

1. Run the program
2. Select **"2. Init System"** to create default admin and sample data
3. Login with default admin credentials

### **Default Admin Account**

| Username | PIN | Role |
|----------|-----|------|
| ADMIN | 123456 | Administrator |

> ⚠️ **Important:** Change the default admin PIN after first login!

---

### **Admin Dashboard**

```
================================================
            === ADMIN DASHBOARD ===             
================================================
User: ADMIN
Role: Administrator
------------------------------------------------

--- User Management ---
 1. Create New User
 2. View All Users

--- Account Management ---
 3. Create New Account (Rekening)
 4. Init Account Database

--- Transactions ---
 5. Deposit / Withdraw
 6. Transfer Antar Akun
 7. Transaction History

--- Reports ---
 8. Account Balance Report

--- Settings ---
 9. Change My PIN

99. Logout & Exit
```

### **Customer Dashboard**

```
================================================
          === CUSTOMER DASHBOARD ===            
================================================
User   : JOHN DOE
Role   : Customer
Account: 1000000001
------------------------------------------------

--- Banking Services ---
 1. Deposit / Withdraw
 2. Transfer to Another Account
 3. View My Balance
 4. My Transaction History

--- Settings ---
 5. Change My PIN

99. Logout & Exit
```

---

## 💱 **Transfer Feature**

```
========================================
          TRANSFER ANTAR AKUN          
========================================

From Account: 1000000001 (Your Account)
To Account Number: 1000000002
Amount: 500000

Processing transfer...

========================================
       TRANSFER SUCCESSFUL!            
========================================

From    : 1000000001 (JOHN DOE)
To      : 1000000002 (JANE SMITH)
Amount  : $500,000.00

========================================
```

---

## 📝 **Transaction History**

```
========================================
        TRANSACTION HISTORY            
========================================

---------------------------------------------------------------------------
DATE       | TIME     | TYPE     | AMOUNT          | FROM/TO
---------------------------------------------------------------------------
2026-03-03 | 14:30:25 | TRANSFER | $500,000.00
           FROM: 1000000001 -> TO: 1000000002
2026-03-03 | 14:25:10 | DEPOSIT  | $100,000.00     | 1000000001
2026-03-03 | 14:20:05 | WITHDRAW | $50,000.00      | 1000000002
---------------------------------------------------------------------------

Total Transactions: 3
```

---

## 🔒 **Security Features**

| Feature | Description |
|---------|-------------|
| **Real Authentication** | Validates against `USERS.DAT` database |
| **Session Management** | Login state saved to `SESSION.DAT` |
| **Account Lockout** | Locked after 3 failed attempts |
| **Customer Isolation** | Customers only access own account |
| **Transfer Validation** | Check balance before transfer |
| **Audit Trail** | All transactions logged to `HISTORY.DAT` |
| **Session Cleanup** | Session file deleted on logout |

---

## 🗂️ **Project Structure**

```
ledgercobol/
├── 📄 BANK-MAIN.CBL      # Main program
├── 📄 LOGIN.CBL          # Authentication
├── 📄 CREATE-USER.CBL    # User creation
├── 📄 LIST-USERS.CBL     # List users
├── 📄 CREATE-ACC.CBL     # Account creation
├── 📄 INIT-DB.CBL        # Init accounts
├── 📄 INIT-USERS.CBL     # Init users
├── 📄 TRANS-PROC.CBL     # Deposit/Withdraw
├── 📄 TRANSFER.CBL       # Transfer
├── 📄 HISTORY.CBL        # Transaction history
├── 📄 REPORT-GEN.CBL     # Reports
├── 📄 CHANGE-PIN.CBL     # Change PIN
├── 📄 ACCOUNTS.CPY       # Account copybook
├── 📄 USERS.CPY          # User copybook
├── 📄 HISTORY.CPY        # History copybook
├── 📁 ai-agent/          # 🤖 AI Integration
│   ├── 🐍 ai_agent.py    # Python AI bridge
│   ├── 📋 requirements.txt
│   ├── 🔧 setup.sh       # Linux/macOS setup
│   ├── 🔧 setup.bat      # Windows setup
│   └── 📖 README.md
├── 📁 assets/
│   └── 🖼️ cobol-logo.jpeg
├── 📝 .gitignore
├── 📖 README.md
├── 📖 CONTRIBUTING.md
└── 📜 LICENSE
```

---

## 🔧 **Data Files**

| File | Description | Auto-generated |
|------|-------------|----------------|
| `USERS.DAT` | User credentials & roles | By INIT-USERS |
| `ACCOUNTS.DAT` | Bank accounts & balances | By INIT-DB |
| `SESSION.DAT` | Current login session | By LOGIN |
| `HISTORY.DAT` | Transaction audit trail | By transactions |

---

## 🤝 **Contributing**

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

```bash
git checkout -b feature/amazing-feature
git commit -m "feat: add amazing feature"
git push origin feature/amazing-feature
```

---

## 🤖 **AI Agent (NEW!)**

LedgerCOBOL now supports **natural language commands** via AI!

```
👤 You: "Transfer 500000 to account 1000000002"

🤖 AI: I'll transfer $500,000 to account 1000000002.
       ⏳ Processing transfer...
       ✅ Transfer successful!
```

### Quick Start

```bash
cd ai-agent
./setup.sh          # Install dependencies
ollama serve        # Start AI (in separate terminal)
python ai_agent.py  # Run the agent
```

📖 See [ai-agent/README.md](ai-agent/README.md) for full documentation.

---

## 📜 **License**

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### **Made with 💙 for COBOL enthusiasts**

**[⭐ Star this repo](https://github.com/YOUR_USERNAME/ledgercobol)** if you find it useful!

---

**v3.5** - Now with AI Agent! 🤖

**[🚀 Quick Start](#-quick-start)** • **[🤖 AI Agent](#-ai-agent-new)** • **[📖 Docs](#-components)** • **[🐛 Report Bug](https://github.com/YOUR_USERNAME/ledgercobol/issues)**

</div>
