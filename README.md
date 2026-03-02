# LedgerCOBOL

A simplified COBOL banking system demonstrating fundamental banking operations like account management, transactions, and reporting.

## Features

- **Database Initialization**: Creates sample account data
- **Transaction Processing**: Supports deposits and withdrawals
- **Reporting**: Generates formatted balance summary reports
- **Cross-Platform**: Works on both Windows and Linux/macOS

## Components

| File | Description |
|------|-------------|
| `BANK-MAIN.CBL` | Main menu driver program |
| `INIT-DB.CBL` | Initializes `ACCOUNTS.DAT` with sample data |
| `TRANS-PROC.CBL` | Handles deposit and withdrawal transactions |
| `REPORT-GEN.CBL` | Generates account balance summary report |
| `ACCOUNTS.CPY` | Copybook defining the account record structure |

## Prerequisites

You need **GnuCOBOL** installed on your system.

### Windows (MSYS2)

```powershell
pacman -Sy
pacman -S mingw-w64-x86_64-gnucobol
cobc --version
```

Or download from [GnuCOBOL for Windows](https://www.arnoldtrembley.com/GnuCOBOL.htm)

### Linux (Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install gnucobol
```

### macOS (Homebrew)

```bash
brew install gnucobol
```

## Compilation & Execution

### Quick Start

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

### Windows Environment Setup (if needed)

```powershell
$env:COB_CONFIG_DIR = "C:\msys64\mingw64\share\gnucobol\config"
$env:COB_COPY_DIR = "C:\msys64\mingw64\share\gnucobol\copy"
```

## Usage

When you run the program, you'll see a menu:

```
=== LEDGERCOBOL ===
1. Init Database
2. Transaction
3. Report
4. Exit
Option: 
```

### Sample Accounts

After initializing the database, you'll have these accounts:

| Account Number | Name | Balance |
|----------------|------|---------|
| 1000000001 | JOHN DOE | $5,000.00 |
| 1000000002 | JANE SMITH | $12,500.50 |
| 1000000003 | BOB JOHNSON | $100.00 |

### Transaction Example

```
--- TRANSACTION ---
Account Number: 1000000001
Type (D/W): D
Amount: 500.00
Deposit Ok.
Saving...
```

## File Structure

```
ledgercobol/
├── BANK-MAIN.CBL      # Main program
├── INIT-DB.CBL        # Database initializer
├── TRANS-PROC.CBL     # Transaction processor
├── REPORT-GEN.CBL     # Report generator
├── ACCOUNTS.CPY       # Record copybook
├── .gitignore         # Git ignore rules
├── README.md          # This file
├── CONTRIBUTING.md    # Contribution guidelines
└── LICENSE            # MIT License
```

## Technical Notes

- **File Organization**: Uses LINE SEQUENTIAL for portability
- **Record Format**: Fixed-length records (56 bytes)
- **Balance Storage**: Signed numeric with 2 decimal places (`S9(13)V99`)
- **Cross-Platform**: Auto-detects OS for file operations

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
