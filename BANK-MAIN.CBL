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
      * Show menu based on role
           EVALUATE WS-CURRENT-ROLE
               WHEN 'A'
                   PERFORM ADMIN-MENU UNTIL WS-CHOICE = '9'
               WHEN 'T'
                   PERFORM TELLER-MENU UNTIL WS-CHOICE = '9'
               WHEN 'C'
                   PERFORM CUSTOMER-MENU UNTIL WS-CHOICE = '9'
           END-EVALUATE.
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
           DISPLAY '=== SYSTEM LOGIN ==='.
           DISPLAY '1. Login'.
           DISPLAY '2. Init System (First Time Setup)'.
           DISPLAY '3. Exit'.
           DISPLAY 'Option: ' WITH NO ADVANCING.
           ACCEPT WS-LOGIN-CHOICE.

           EVALUATE WS-LOGIN-CHOICE
               WHEN '1'
                   PERFORM DO-LOGIN
               WHEN '2'
                   DISPLAY ' '.
                   DISPLAY 'Initializing system databases...'.
                   CALL 'INIT-USERS'
                   CALL 'INIT-DB'
                   DISPLAY 'System initialized successfully!'.
                   DISPLAY ' '.
               WHEN '3'
                   DISPLAY 'Goodbye!'
                   STOP RUN
               WHEN OTHER
                   DISPLAY 'Invalid option.'
           END-EVALUATE.

       DO-LOGIN.
           CALL 'LOGIN'.
      * For demo, we simulate successful login
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

      *==========================================================
      * ADMIN MENU - Full access to all features
      *==========================================================
       ADMIN-MENU.
           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '        === ADMIN DASHBOARD ===        '.
           DISPLAY '========================================'.
           DISPLAY 'User: ' WS-CURRENT-USER.
           DISPLAY 'Role: Administrator'.
           DISPLAY '----------------------------------------'.
           DISPLAY ' '.
           DISPLAY '--- User Management ---'.
           DISPLAY '1. Create New User'.
           DISPLAY '2. View All Users'.
           DISPLAY ' '.
           DISPLAY '--- Account Management ---'.
           DISPLAY '3. Init Account Database'.
           DISPLAY '4. Process Transaction'.
           DISPLAY '5. Account Report'.
           DISPLAY ' '.
           DISPLAY '--- Settings ---'.
           DISPLAY '6. Change My PIN'.
           DISPLAY ' '.
           DISPLAY '9. Logout & Exit'.
           DISPLAY ' '.
           DISPLAY 'Option: ' WITH NO ADVANCING.
           ACCEPT WS-CHOICE.

           EVALUATE WS-CHOICE
               WHEN '1'
                   CALL 'CREATE-USER'
               WHEN '2'
                   CALL 'LIST-USERS'
               WHEN '3'
                   CALL 'INIT-DB'
               WHEN '4'
                   CALL 'TRANS-PROC'
               WHEN '5'
                   CALL 'REPORT-GEN'
               WHEN '6'
                   CALL 'CHANGE-PIN'
               WHEN '9'
                   DISPLAY ' '
                   DISPLAY 'Logging out...'
               WHEN OTHER
                   DISPLAY 'Invalid option.'
           END-EVALUATE.

      *==========================================================
      * TELLER MENU - Customer management & transactions
      *==========================================================
       TELLER-MENU.
           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '        === TELLER DASHBOARD ===       '.
           DISPLAY '========================================'.
           DISPLAY 'User: ' WS-CURRENT-USER.
           DISPLAY 'Role: Teller'.
           DISPLAY '----------------------------------------'.
           DISPLAY ' '.
           DISPLAY '--- Customer Service ---'.
           DISPLAY '1. Create New Customer'.
           DISPLAY '2. Process Transaction'.
           DISPLAY '3. Account Report'.
           DISPLAY ' '.
           DISPLAY '--- Settings ---'.
           DISPLAY '4. Change My PIN'.
           DISPLAY ' '.
           DISPLAY '9. Logout & Exit'.
           DISPLAY ' '.
           DISPLAY 'Option: ' WITH NO ADVANCING.
           ACCEPT WS-CHOICE.

           EVALUATE WS-CHOICE
               WHEN '1'
                   CALL 'CREATE-USER'
               WHEN '2'
                   CALL 'TRANS-PROC'
               WHEN '3'
                   CALL 'REPORT-GEN'
               WHEN '4'
                   CALL 'CHANGE-PIN'
               WHEN '9'
                   DISPLAY ' '
                   DISPLAY 'Logging out...'
               WHEN OTHER
                   DISPLAY 'Invalid option.'
           END-EVALUATE.

      *==========================================================
      * CUSTOMER MENU - Limited to own account only
      *==========================================================
       CUSTOMER-MENU.
           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '       === CUSTOMER DASHBOARD ===      '.
           DISPLAY '========================================'.
           DISPLAY 'User: ' WS-CURRENT-USER.
           DISPLAY 'Role: Customer'.
           DISPLAY 'Account: ' WS-CURRENT-ACC.
           DISPLAY '----------------------------------------'.
           DISPLAY ' '.
           DISPLAY '--- Banking Services ---'.
           DISPLAY '1. Deposit / Withdraw'.
           DISPLAY '2. View My Balance'.
           DISPLAY ' '.
           DISPLAY '--- Settings ---'.
           DISPLAY '3. Change My PIN'.
           DISPLAY ' '.
           DISPLAY '9. Logout & Exit'.
           DISPLAY ' '.
           DISPLAY 'Option: ' WITH NO ADVANCING.
           ACCEPT WS-CHOICE.

           EVALUATE WS-CHOICE
               WHEN '1'
                   CALL 'TRANS-PROC'
               WHEN '2'
                   CALL 'REPORT-GEN'
               WHEN '3'
                   CALL 'CHANGE-PIN'
               WHEN '9'
                   DISPLAY ' '
                   DISPLAY 'Logging out...'
               WHEN OTHER
                   DISPLAY 'Invalid option.'
           END-EVALUATE.
