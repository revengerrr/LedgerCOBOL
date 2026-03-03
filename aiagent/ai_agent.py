#!/usr/bin/env python3
"""
LedgerCOBOL AI Agent
====================
AI-powered interface for the COBOL banking system.
Uses Ollama (local LLM) to understand natural language commands.

Requirements:
- Python 3.8+
- Ollama installed (https://ollama.ai)
- LedgerCOBOL compiled

Usage:
    python ai_agent.py
"""

import subprocess
import json
import re
import os
import requests
from datetime import datetime

# Configuration
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "llama3.2"  # or "mistral", "phi3", etc.
COBOL_DIR = ".."  # Directory where COBOL executables are

class LedgerCOBOLAgent:
    def __init__(self):
        self.session = {
            "logged_in": False,
            "username": None,
            "role": None,
            "account": None
        }
        self.history = []
        
    def check_ollama(self):
        """Check if Ollama is running"""
        try:
            response = requests.get("http://localhost:11434/api/tags", timeout=5)
            return response.status_code == 200
        except:
            return False
    
    def ask_ai(self, prompt, system_prompt=None):
        """Send prompt to Ollama and get response"""
        if system_prompt is None:
            system_prompt = self.get_system_prompt()
        
        payload = {
            "model": MODEL,
            "prompt": prompt,
            "system": system_prompt,
            "stream": False
        }
        
        try:
            response = requests.post(OLLAMA_URL, json=payload, timeout=60)
            if response.status_code == 200:
                return response.json().get("response", "")
            else:
                return f"Error: {response.status_code}"
        except Exception as e:
            return f"Error connecting to Ollama: {e}"
    
    def get_system_prompt(self):
        """System prompt for the AI"""
        return """You are a banking assistant for LedgerCOBOL, a COBOL-based banking system.

Your job is to understand user requests and convert them to banking commands.

Available actions:
1. LOGIN - Login to the system
2. DEPOSIT - Deposit money to an account
3. WITHDRAW - Withdraw money from an account
4. TRANSFER - Transfer money between accounts
5. BALANCE - Check account balance
6. HISTORY - View transaction history
7. HELP - Show available commands
8. LOGOUT - Logout from the system

When user makes a request, respond with a JSON object:
{
    "action": "ACTION_NAME",
    "params": {
        "param1": "value1",
        ...
    },
    "message": "Friendly message to user"
}

Examples:

User: "I want to deposit 500000 to account 1000000001"
Response: {"action": "DEPOSIT", "params": {"account": "1000000001", "amount": "500000"}, "message": "I'll deposit $500,000 to account 1000000001 for you."}

User: "Transfer 1 million from my account to 1000000002"
Response: {"action": "TRANSFER", "params": {"to_account": "1000000002", "amount": "1000000"}, "message": "I'll transfer $1,000,000 to account 1000000002."}

User: "What's my balance?"
Response: {"action": "BALANCE", "params": {}, "message": "Let me check your balance."}

User: "Hello, how are you?"
Response: {"action": "CHAT", "params": {}, "message": "Hello! I'm your LedgerCOBOL banking assistant. How can I help you today? You can ask me to check your balance, make deposits, withdrawals, or transfers."}

Always respond with valid JSON only. No extra text."""

    def parse_ai_response(self, response):
        """Parse AI response to extract action and params"""
        try:
            # Try to find JSON in response
            json_match = re.search(r'\{.*\}', response, re.DOTALL)
            if json_match:
                return json.loads(json_match.group())
            else:
                return {"action": "CHAT", "params": {}, "message": response}
        except json.JSONDecodeError:
            return {"action": "CHAT", "params": {}, "message": response}

    def execute_cobol(self, program, inputs=None):
        """Execute a COBOL program with given inputs"""
        try:
            cmd = os.path.join(COBOL_DIR, program)
            
            # Check if executable exists
            if os.name == 'nt':  # Windows
                cmd += '.exe'
            
            if not os.path.exists(cmd):
                return f"Error: Program {program} not found. Make sure COBOL is compiled."
            
            # Run with inputs
            process = subprocess.Popen(
                cmd,
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                cwd=COBOL_DIR
            )
            
            input_str = "\n".join(inputs) if inputs else ""
            stdout, stderr = process.communicate(input=input_str, timeout=30)
            
            return stdout
        except subprocess.TimeoutExpired:
            return "Error: Command timed out"
        except Exception as e:
            return f"Error executing COBOL: {e}"

    def handle_action(self, parsed):
        """Handle the parsed action from AI"""
        action = parsed.get("action", "CHAT")
        params = parsed.get("params", {})
        message = parsed.get("message", "")
        
        print(f"\n🤖 AI: {message}")
        
        if action == "CHAT":
            return
        
        elif action == "LOGIN":
            username = params.get("username", "")
            pin = params.get("pin", "")
            
            if not username:
                username = input("📝 Enter username: ")
            if not pin:
                pin = input("🔐 Enter PIN: ")
            
            # For demo, we'll simulate login
            print("\n⏳ Processing login...")
            result = self.execute_cobol("LOGIN", [username, pin])
            print(result)
            
            if "SUCCESSFUL" in result.upper():
                self.session["logged_in"] = True
                self.session["username"] = username
                print("✅ Login successful!")
            else:
                print("❌ Login failed.")
        
        elif action == "DEPOSIT":
            account = params.get("account", "")
            amount = params.get("amount", "")
            
            if not account:
                account = input("📝 Enter account number: ")
            if not amount:
                amount = input("💰 Enter amount: ")
            
            print("\n⏳ Processing deposit...")
            result = self.execute_cobol("TRANS-PROC", [account, "D", amount])
            print(result)
            
            if "SUCCESSFUL" in result.upper():
                print(f"✅ Deposited ${int(amount):,} to account {account}")
                self.log_transaction("DEPOSIT", account, amount)
        
        elif action == "WITHDRAW":
            account = params.get("account", "")
            amount = params.get("amount", "")
            
            if not account:
                account = input("📝 Enter account number: ")
            if not amount:
                amount = input("💰 Enter amount: ")
            
            print("\n⏳ Processing withdrawal...")
            result = self.execute_cobol("TRANS-PROC", [account, "W", amount])
            print(result)
            
            if "SUCCESSFUL" in result.upper():
                print(f"✅ Withdrew ${int(amount):,} from account {account}")
                self.log_transaction("WITHDRAW", account, amount)
        
        elif action == "TRANSFER":
            from_acc = params.get("from_account", self.session.get("account", ""))
            to_acc = params.get("to_account", "")
            amount = params.get("amount", "")
            
            if not from_acc:
                from_acc = input("📝 From account: ")
            if not to_acc:
                to_acc = input("📝 To account: ")
            if not amount:
                amount = input("💰 Amount: ")
            
            print("\n⏳ Processing transfer...")
            result = self.execute_cobol("TRANSFER", [from_acc, to_acc, amount])
            print(result)
            
            if "SUCCESSFUL" in result.upper():
                print(f"✅ Transferred ${int(amount):,} from {from_acc} to {to_acc}")
                self.log_transaction("TRANSFER", f"{from_acc}->{to_acc}", amount)
        
        elif action == "BALANCE":
            print("\n⏳ Fetching balance report...")
            result = self.execute_cobol("REPORT-GEN", [])
            print(result)
        
        elif action == "HISTORY":
            account = params.get("account", "0")
            print("\n⏳ Fetching transaction history...")
            result = self.execute_cobol("HISTORY", [account])
            print(result)
        
        elif action == "HELP":
            self.show_help()
        
        elif action == "LOGOUT":
            self.session = {"logged_in": False, "username": None, "role": None, "account": None}
            print("👋 Logged out successfully!")

    def log_transaction(self, type, account, amount):
        """Log transaction to local history"""
        self.history.append({
            "time": datetime.now().isoformat(),
            "type": type,
            "account": account,
            "amount": amount
        })

    def show_help(self):
        """Show help message"""
        print("""
╔═══════════════════════════════════════════════════════════════╗
║                    LEDGERCOBOL AI AGENT                       ║
║                        HELP GUIDE                             ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  You can talk to me naturally! Examples:                      ║
║                                                               ║
║  💰 "Deposit 500000 to account 1000000001"                    ║
║  💸 "Withdraw 100000 from my account"                         ║
║  💱 "Transfer 1 million to account 1000000002"                ║
║  📊 "Show my balance"                                         ║
║  📝 "Show transaction history"                                ║
║  🔐 "Login as admin"                                          ║
║  👋 "Logout"                                                  ║
║                                                               ║
║  Or just chat with me and I'll help you!                      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
        """)

    def show_welcome(self):
        """Show welcome banner"""
        print("""
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║     ██╗     ███████╗██████╗  ██████╗ ███████╗██████╗          ║
║     ██║     ██╔════╝██╔══██╗██╔════╝ ██╔════╝██╔══██╗         ║
║     ██║     █████╗  ██║  ██║██║  ███╗█████╗  ██████╔╝         ║
║     ██║     ██╔══╝  ██║  ██║██║   ██║██╔══╝  ██╔══██╗         ║
║     ███████╗███████╗██████╔╝╚██████╔╝███████╗██║  ██║         ║
║     ╚══════╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝         ║
║                                                               ║
║              🤖 AI-POWERED COBOL BANKING 🏦                   ║
║                                                               ║
║     Talk to me naturally - I understand banking requests!     ║
║     Type 'help' for examples or 'quit' to exit.               ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
        """)

    def run(self):
        """Main loop"""
        self.show_welcome()
        
        # Check Ollama
        print("🔍 Checking Ollama connection...")
        if not self.check_ollama():
            print("""
❌ Ollama is not running!

Please install and start Ollama:
1. Install: curl -fsSL https://ollama.ai/install.sh | sh
2. Pull model: ollama pull llama3.2
3. Start: ollama serve

Then run this script again.
            """)
            return
        
        print(f"✅ Connected to Ollama (model: {MODEL})")
        print("\n" + "="*60)
        print("💬 Start chatting! (type 'quit' to exit)")
        print("="*60 + "\n")
        
        while True:
            try:
                user_input = input("👤 You: ").strip()
                
                if not user_input:
                    continue
                
                if user_input.lower() in ['quit', 'exit', 'bye', 'q']:
                    print("\n👋 Goodbye! Thank you for using LedgerCOBOL AI.")
                    break
                
                if user_input.lower() == 'help':
                    self.show_help()
                    continue
                
                # Get AI response
                print("\n🤔 Thinking...")
                ai_response = self.ask_ai(user_input)
                
                # Parse and execute
                parsed = self.parse_ai_response(ai_response)
                self.handle_action(parsed)
                
                print()  # Empty line for readability
                
            except KeyboardInterrupt:
                print("\n\n👋 Goodbye!")
                break
            except Exception as e:
                print(f"\n❌ Error: {e}")
                continue


if __name__ == "__main__":
    agent = LedgerCOBOLAgent()
    agent.run()
