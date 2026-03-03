<div align="center">

<img src="assets/cobol-logo.jpeg" alt="COBOL Logo" width="200"/>

# 🏦 LedgerCOBOL

### **Classic Core Banking System Built with COBOL**

<p align="center">
  <strong>A simplified banking system demonstrating fundamental banking operations</strong>
</p>

<p align="center">
  <a href="#-quick-start"><img src="https://img.shields.io/badge/Quick-Start-blue?style=for-the-badge&logo=rocket" alt="Quick Start"></a>
  <a href="#-features"><img src="https://img.shields.io/badge/Features-View-green?style=for-the-badge" alt="Features"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/COBOL-GnuCOBOL-blue?style=flat-square" alt="COBOL">
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=flat-square" alt="Status">
</p>

---

**[🚀 Quick Start](#-quick-start)** | **[📖 Documentation](#-components)** | **[🤝 Contributing](#-contributing)**

---

</div>

## 🎯 **What is LedgerCOBOL?**

LedgerCOBOL is a **classic core banking system** implemented in COBOL, demonstrating fundamental banking operations like account management, transactions, and reporting. Perfect for learning COBOL or understanding how legacy banking systems work.

### **Why COBOL?**

> 💡 **Fun Fact:** Over 95% of ATM transactions and 80% of in-person transactions still use COBOL today!

- ✅ **Battle-Tested** - Running banks since 1959
- ✅ **Reliable** - Processes trillions of dollars daily
- ✅ **Educational** - Learn how real banking systems work
- ✅ **Cross-Platform** - Works on Windows, Linux, and macOS

---

## ✨ **Features**

<table>
<tr>
<td width="50%">

### 🔐 **Login System**
Secure PIN-based authentication with account lockout after 3 failed attempts.

### 📝 **User Registration**
New users can register their own account with username and PIN.

### 🗄️ **Database Initialization**
Creates sample account and user data for testing.

</td>
<td width="50%">

### 👥 **Role-Based Access**
Three user roles: Admin, Teller, and Customer with different permissions.

### 💸 **Transaction Processing**
Supports deposits and withdrawals with balance validation.

### 🔑 **Change PIN**
Users can securely update their PIN anytime.

</td>
</tr>
</table>

---

## 📁 **Components**

| File | Description |
|------|-------------|
| `BANK-MAIN.CBL` | Main menu driver program with ASCII art |
| `LOGIN.CBL` | User authentication with PIN |
| `REGISTER.CBL` | New user registration |
| `INIT-DB.CBL` | Initializes `ACCOUNTS.DAT` with sample data |
| `INIT-USERS.CBL` | Initializes `USERS.DAT` with sample users |
| `TRANS-PROC.CBL` | Handles deposit and withdrawal transactions |
| `REPORT-GEN.CBL` | Generates account balance summary report |
| `CHANGE-PIN.CBL` | Allows users to change their PIN |
| `ACCOUNTS.CPY` | Copybook for account record structure |
| `USERS.CPY` | Copybook for user record structure |

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

Or download from [GnuCOBOL for Windows](https://www.arnoldtrembley.com/GnuCOBOL.htm)

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
# Compile all modules as shared libraries
cobc -m INIT-DB.CBL
cobc -m INIT-USERS.CBL
cobc -m LOGIN.CBL
cobc -m REGISTER.CBL
cobc -m TRANS-PROC.CBL
cobc -m REPORT-GEN.CBL
cobc -m CHANGE-PIN.CBL

# Compile main program as executable
cobc -x BANK-MAIN.CBL

# Run the program
./BANK-MAIN        # Linux/macOS
BANK-MAIN.exe      # Windows
```

---

## 🖥️ **Usage**

When you run the program, you'll see:

```
================================================
                                                
     LL      EEEEE  DDDD    GGGG  EEEEE RRRR    
     LL      E      D   D  G      E     R   R   
     LL      EEEE   D   D  G  GG  EEEE  RRRR    
     LL      E      D   D  G   G  E     R  R    
     LLLLL   EEEEE  DDDD    GGGG  EEEEE R   R   
                                                
              C O B O L                         
                                                
        Classic Core Banking System             
                                                
================================================

=== LOGIN MENU ===
1. Login
2. Register New User
3. Init User Database (First Time Setup)
4. Exit
Option: 
```

After login:

```
========================================
          === LEDGERCOBOL ===          
========================================
User: JOHN DOE
Role: Customer
Account: 1000000001
----------------------------------------

1. Init Account Database
2. Transaction (Deposit/Withdraw)
3. Account Report
4. Change PIN
5. Logout & Exit

Option: 
```

### **Default Users**

| Username | PIN | Role | Account |
|----------|-----|------|---------|
| ADMIN | 123456 | Administrator | - |
| TELLER1 | 111111 | Teller | - |
| JOHN DOE | 100001 | Customer | 1000000001 |
| JANE SMITH | 100002 | Customer | 1000000002 |
| BOB JOHNSON | 100003 | Customer | 1000000003 |

### **Role Permissions**

| Feature | Admin | Teller | Customer |
|---------|:-----:|:------:|:--------:|
| Init Account DB | ✅ | ✅ | ❌ |
| Transactions | ✅ | ✅ | ✅ |
| View Reports | ✅ | ✅ | ✅ |
| Change PIN | ✅ | ✅ | ✅ |

---

## 🗂️ **Project Structure**

```
ledgercobol/
├── 📄 BANK-MAIN.CBL      # Main program with ASCII banner
├── 📄 LOGIN.CBL          # PIN authentication
├── 📄 REGISTER.CBL       # New user registration
├── 📄 INIT-DB.CBL        # Account database initializer
├── 📄 INIT-USERS.CBL     # User database initializer
├── 📄 TRANS-PROC.CBL     # Transaction processor
├── 📄 REPORT-GEN.CBL     # Report generator
├── 📄 CHANGE-PIN.CBL     # PIN change module
├── 📄 ACCOUNTS.CPY       # Account record copybook
├── 📄 USERS.CPY          # User record copybook
├── 📁 assets/
│   └── 🖼️ cobol-logo.jpeg
├── 📝 .gitignore
├── 📖 README.md
├── 📖 CONTRIBUTING.md
└── 📜 LICENSE
```

---

## 🔧 **Technical Notes**

| Aspect | Details |
|--------|---------|
| **File Organization** | LINE SEQUENTIAL for portability |
| **Record Format** | Fixed-length records (56 bytes) |
| **Balance Storage** | Signed numeric with 2 decimals (`S9(13)V99`) |
| **Cross-Platform** | Auto-detects OS for file operations |

---

## 🤝 **Contributing**

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

```bash
# 1. Fork the repository
# 2. Create your feature branch
git checkout -b feature/amazing-feature

# 3. Commit your changes
git commit -m "feat: add amazing feature"

# 4. Push to the branch
git push origin feature/amazing-feature

# 5. Open a Pull Request
```

---

## 📜 **License**

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### **Made with 💙 for COBOL enthusiasts**

**[⭐ Star this repo](https://github.com/YOUR_USERNAME/ledgercobol)** if you find it useful!

---

**[🚀 Quick Start](#-quick-start)** • **[📖 Docs](#-components)** • **[🐛 Report Bug](https://github.com/YOUR_USERNAME/ledgercobol/issues)** • **[💡 Request Feature](https://github.com/YOUR_USERNAME/ledgercobol/issues)**

</div>
