       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-MAIN.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CHOICE           PIC X.
       01 WS-LOGGED-IN        PIC X         VALUE 'N'.
       01 WS-CURRENT-USER     PIC X(20).
       01 WS-CURRENT-ROLE     PIC X(1).
       01 WS-CURRENT-ACC      PIC 9(10).
       01 WS-LOGIN-CHOICE     PIC X.

       PROCEDURE DIVISION.
       MAIN-START.
           PERFORM SHOW-WELCOME.
           PERFORM LOGIN-MENU UNTIL WS-LOGGED-IN = 'Y'.
           PERFORM MAIN-MENU UNTIL WS-CHOICE = '5'.
           DISPLAY ' '.
           DISPLAY 'Thank you for using LedgerCOBOL!'.
           DISPLAY 'Goodbye!'.
           DISPLAY ' '.
           STOP RUN.

       SHOW-WELCOME.
           DISPLAY ' '.
           DISPLAY '================================================'.
           DISPLAY '                                                '.
           DISPLAY '     LL      EEEEE  DDDD    GGGG  EEEEE RRRR    '.
           DISPLAY '     LL      E      D   D  G      E     R   R   '.
           DISPLAY '     LL      EEEE   D   D  G  GG  EEEE  RRRR    '.
           DISPLAY '     LL      E      D   D  G   G  E     R  R    '.
           DISPLAY '     LLLLL   EEEEE  DDDD    GGGG  EEEEE R   R   '.
           DISPLAY '                                                '.
           DISPLAY '              C O B O L                         '.
           DISPLAY '                                                '.
           DISPLAY '        Classic Core Banking System             '.
           DISPLAY '                                                '.
           DISPLAY '================================================'.
           DISPLAY ' '.

       LOGIN-MENU.
           DISPLAY '=== LOGIN MENU ==='.
           DISPLAY '1. Login'.
           DISPLAY '2. Register New User'.
           DISPLAY '3. Init User Database (First Time Setup)'.
           DISPLAY '4. Exit'.
           DISPLAY 'Option: ' WITH NO ADVANCING.
           ACCEPT WS-LOGIN-CHOICE.

           EVALUATE WS-LOGIN-CHOICE
               WHEN '1'
                   PERFORM DO-LOGIN
               WHEN '2'
                   CALL 'REGISTER'
               WHEN '3'
                   CALL 'INIT-USERS'
               WHEN '4'
                   DISPLAY 'Goodbye!'
                   STOP RUN
               WHEN OTHER
                   DISPLAY 'Invalid option.'
           END-EVALUATE.

       DO-LOGIN.
           CALL 'LOGIN'.
      * For demo, we simulate successful login
      * In real implementation, LOGIN would set these values
           DISPLAY ' '.
           DISPLAY 'Demo Mode: Enter role (A=Admin/T=Teller/C=Cust):'
               WITH NO ADVANCING.
           ACCEPT WS-CURRENT-ROLE.
           IF WS-CURRENT-ROLE = 'A' OR 'T' OR 'C'
               MOVE 'Y' TO WS-LOGGED-IN
               MOVE 'DEMO USER' TO WS-CURRENT-USER
               IF WS-CURRENT-ROLE = 'C'
                   MOVE 1000000001 TO WS-CURRENT-ACC
               END-IF
           ELSE
               DISPLAY 'Invalid role.'
           END-IF.

       MAIN-MENU.
           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '          === LEDGERCOBOL ===          '.
           DISPLAY '========================================'.
           DISPLAY 'User: ' WS-CURRENT-USER.
           EVALUATE WS-CURRENT-ROLE
               WHEN 'A'
                   DISPLAY 'Role: Administrator'
               WHEN 'T'
                   DISPLAY 'Role: Teller'
               WHEN 'C'
                   DISPLAY 'Role: Customer'
                   DISPLAY 'Account: ' WS-CURRENT-ACC
           END-EVALUATE.
           DISPLAY '----------------------------------------'.
           DISPLAY ' '.
           DISPLAY '1. Init Account Database'.
           DISPLAY '2. Transaction (Deposit/Withdraw)'.
           DISPLAY '3. Account Report'.
           DISPLAY '4. Change PIN'.
           DISPLAY '5. Logout & Exit'.
           DISPLAY ' '.
           DISPLAY 'Option: ' WITH NO ADVANCING.
           ACCEPT WS-CHOICE.

           EVALUATE WS-CHOICE
               WHEN '1'
      * Only Admin and Teller can init database
                   IF WS-CURRENT-ROLE = 'A' OR WS-CURRENT-ROLE = 'T'
                       CALL 'INIT-DB'
                   ELSE
                       DISPLAY ' '.
                       DISPLAY '*** ACCESS DENIED ***'
                       DISPLAY 'Only Admin/Teller can initialize DB.'
                   END-IF
               WHEN '2'
                   CALL 'TRANS-PROC'
               WHEN '3'
                   CALL 'REPORT-GEN'
               WHEN '4'
                   CALL 'CHANGE-PIN'
               WHEN '5'
                   DISPLAY ' '.
                   DISPLAY 'Logging out...'
               WHEN OTHER
                   DISPLAY 'Invalid option.'
           END-EVALUATE.
