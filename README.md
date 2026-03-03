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

### 🔐 **Secure Login System**
PIN-based authentication with account lockout after 3 failed attempts.

### 👥 **Role-Based Access Control**
Three user roles with different dashboards and permissions.

### 🛡️ **Admin-Only User Management**
Only administrators can create new users - just like real banks.

</td>
<td width="50%">

### 💸 **Transaction Processing**
Supports deposits and withdrawals with balance validation.

### 📊 **Balance Reporting**
Generates formatted summary reports of all accounts.

### 🔑 **PIN Management**
Users can securely change their PIN. Default PIN for new users: `000000`.

</td>
</tr>
</table>

---

## 👥 **Role-Based Access Control**

| Feature | Admin | Teller | Customer |
|---------|:-----:|:------:|:--------:|
| Create New User | ✅ | ✅ (Customer only) | ❌ |
| View All Users | ✅ | ❌ | ❌ |
| Init Account Database | ✅ | ❌ | ❌ |
| Process Transactions | ✅ | ✅ | ✅ (Own account) |
| View Reports | ✅ | ✅ | ✅ (Own balance) |
| Change PIN | ✅ | ✅ | ✅ |

---

## 📁 **Components**

| File | Description |
|------|-------------|
| `BANK-MAIN.CBL` | Main program with role-based dashboards |
| `LOGIN.CBL` | User authentication with PIN |
| `CREATE-USER.CBL` | Admin/Teller create new users |
| `LIST-USERS.CBL` | Admin view all users |
| `INIT-DB.CBL` | Initializes `ACCOUNTS.DAT` with sample data |
| `INIT-USERS.CBL` | Initializes `USERS.DAT` with default admin |
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
cobc -m CREATE-USER.CBL
cobc -m LIST-USERS.CBL
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

### **First Time Setup**

1. Run the program
2. Select **"2. Init System (First Time Setup)"**
3. This creates default admin user and sample accounts

### **Login Menu**

```
=== SYSTEM LOGIN ===
1. Login
2. Init System (First Time Setup)
3. Exit
Option:
```

### **Default Admin Account**

| Username | PIN | Role |
|----------|-----|------|
| ADMIN | 123456 | Administrator |

> ⚠️ **Important:** Change the default admin PIN after first login!

---

### **Admin Dashboard**

```
========================================
        === ADMIN DASHBOARD ===        
========================================
User: ADMIN
Role: Administrator
----------------------------------------

--- User Management ---
1. Create New User
2. View All Users

--- Account Management ---
3. Init Account Database
4. Process Transaction
5. Account Report

--- Settings ---
6. Change My PIN

9. Logout & Exit
```

### **Teller Dashboard**

```
========================================
        === TELLER DASHBOARD ===       
========================================

--- Customer Service ---
1. Create New Customer
2. Process Transaction
3. Account Report

--- Settings ---
4. Change My PIN

9. Logout & Exit
```

### **Customer Dashboard**

```
========================================
       === CUSTOMER DASHBOARD ===      
========================================
Account: 1000000001

--- Banking Services ---
1. Deposit / Withdraw
2. View My Balance

--- Settings ---
3. Change My PIN

9. Logout & Exit
```

---

## 🔒 **Security Features**

| Feature | Description |
|---------|-------------|
| **PIN Authentication** | 6-digit PIN required for login |
| **Account Lockout** | Locked after 3 failed attempts |
| **Default PIN** | New users get PIN `000000`, must change |
| **Role-Based Access** | Users only see their allowed features |
| **Admin-Only User Creation** | Prevents unauthorized account creation |

---

## 🗂️ **Project Structure**

```
ledgercobol/
├── 📄 BANK-MAIN.CBL      # Main program with role-based menus
├── 📄 LOGIN.CBL          # PIN authentication
├── 📄 CREATE-USER.CBL    # Admin creates new users
├── 📄 LIST-USERS.CBL     # Admin views all users
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
| **Record Format** | Fixed-length records |
| **Balance Storage** | Signed numeric with 2 decimals (`S9(13)V99`) |
| **Cross-Platform** | Auto-detects OS for file operations |
| **User Storage** | Sequential file with role-based records |

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
