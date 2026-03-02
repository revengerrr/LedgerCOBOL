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

### 🗄️ **Database Initialization**
Creates sample account data with pre-configured balances for testing.

### 💸 **Transaction Processing**
Supports real-time deposits and withdrawals with balance validation.

</td>
<td width="50%">

### 📊 **Balance Reporting**
Generates formatted summary reports of all accounts and total bank balance.

### 🌐 **Cross-Platform**
Auto-detects OS for file operations (Windows/Linux/macOS).

</td>
</tr>
</table>

---

## 📁 **Components**

| File | Description |
|------|-------------|
| `BANK-MAIN.CBL` | Main menu driver program |
| `INIT-DB.CBL` | Initializes `ACCOUNTS.DAT` with sample data |
| `TRANS-PROC.CBL` | Handles deposit and withdrawal transactions |
| `REPORT-GEN.CBL` | Generates account balance summary report |
| `ACCOUNTS.CPY` | Copybook defining the account record structure |

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
# Compile modules as shared libraries
cobc -m INIT-DB.CBL
cobc -m TRANS-PROC.CBL
cobc -m REPORT-GEN.CBL

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
=== LEDGERCOBOL ===
1. Init Database
2. Transaction
3. Report
4. Exit
Option: 
```

### **Sample Accounts**

After initializing the database:

| Account Number | Name | Balance |
|----------------|------|---------|
| 1000000001 | JOHN DOE | $5,000.00 |
| 1000000002 | JANE SMITH | $12,500.50 |
| 1000000003 | BOB JOHNSON | $100.00 |

### **Transaction Example**

```
--- TRANSACTION ---
Account Number: 1000000001
Type (D/W): D
Amount: 500.00
Deposit Ok.
Saving...
```

---

## 🗂️ **Project Structure**

```
ledgercobol/
├── 📄 BANK-MAIN.CBL      # Main program
├── 📄 INIT-DB.CBL        # Database initializer
├── 📄 TRANS-PROC.CBL     # Transaction processor
├── 📄 REPORT-GEN.CBL     # Report generator
├── 📄 ACCOUNTS.CPY       # Record copybook
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
