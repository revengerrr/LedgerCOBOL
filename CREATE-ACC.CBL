       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE-ACC.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE ASSIGN TO 'ACCOUNTS.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-FILE ASSIGN TO 'ACCOUNTS.TMP'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-FILE.
       01 ACCOUNT-REC.
          05 REC-ACC-NUMBER    PIC 9(10).
          05 REC-ACC-NAME      PIC X(30).
          05 REC-ACC-BALANCE   PIC S9(13)V99.
          05 REC-ACC-STATUS    PIC X(1).

       FD  TEMP-FILE.
       01 TEMP-REC.
          05 TEMP-ACC-NUMBER   PIC 9(10).
          05 TEMP-ACC-NAME     PIC X(30).
          05 TEMP-ACC-BALANCE  PIC S9(13)V99.
          05 TEMP-ACC-STATUS   PIC X(1).

       WORKING-STORAGE SECTION.
       01 WS-EOF-FLAG          PIC X         VALUE 'N'.
       01 WS-DUPLICATE-FLAG    PIC X         VALUE 'N'.
       01 WS-NEW-ACC           PIC 9(10).
       01 WS-NEW-NAME          PIC X(30).
       01 WS-NEW-BALANCE       PIC S9(13)V99.
       01 WS-LAST-ACC          PIC 9(10)     VALUE 1000000000.
       01 WS-CMD               PIC X(100).
       01 WS-OS-TYPE           PIC X(10).
       01 WS-FORMATTED-BAL     PIC $$$,$$$,$$$,$$9.99.
       01 WS-CONFIRM           PIC X.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '        CREATE NEW BANK ACCOUNT        '.
           DISPLAY '========================================'.
           DISPLAY ' '.
           DISPLAY 'Customer Name (max 30 chars): '
               WITH NO ADVANCING.
           ACCEPT WS-NEW-NAME.

           IF WS-NEW-NAME = SPACES
               DISPLAY ' '
               DISPLAY '*** ERROR: Name cannot be empty! ***'
               STOP RUN
           END-IF.

           DISPLAY 'Initial Deposit Amount: ' WITH NO ADVANCING.
           ACCEPT WS-NEW-BALANCE.

           IF WS-NEW-BALANCE < 0
               DISPLAY ' '
               DISPLAY '*** ERROR: Initial balance cannot be negative!'
               STOP RUN
           END-IF.

      * Find last account number
           OPEN INPUT ACCOUNT-FILE.
           MOVE 'N' TO WS-EOF-FLAG.
           MOVE 1000000000 TO WS-LAST-ACC.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ ACCOUNT-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       IF REC-ACC-NUMBER > WS-LAST-ACC
                           MOVE REC-ACC-NUMBER TO WS-LAST-ACC
                       END-IF
               END-READ
           END-PERFORM.
           CLOSE ACCOUNT-FILE.

      * Generate new account number
           ADD 1 TO WS-LAST-ACC GIVING WS-NEW-ACC.

      * Confirm with user
           MOVE WS-NEW-BALANCE TO WS-FORMATTED-BAL.
           DISPLAY ' '.
           DISPLAY '--- Confirm Account Creation ---'.
           DISPLAY 'Account Number : ' WS-NEW-ACC.
           DISPLAY 'Customer Name  : ' WS-NEW-NAME.
           DISPLAY 'Initial Balance: ' WS-FORMATTED-BAL.
           DISPLAY ' '.
           DISPLAY 'Create this account? (Y/N): ' WITH NO ADVANCING.
           ACCEPT WS-CONFIRM.

           IF WS-CONFIRM NOT = 'Y' AND WS-CONFIRM NOT = 'y'
               DISPLAY ' '
               DISPLAY 'Account creation cancelled.'
               STOP RUN
           END-IF.

      * Copy existing accounts and add new one
           OPEN INPUT ACCOUNT-FILE.
           OPEN OUTPUT TEMP-FILE.
           MOVE 'N' TO WS-EOF-FLAG.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ ACCOUNT-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       MOVE ACCOUNT-REC TO TEMP-REC
                       WRITE TEMP-REC
               END-READ
           END-PERFORM.

      * Add new account
           MOVE WS-NEW-ACC TO TEMP-ACC-NUMBER.
           MOVE WS-NEW-NAME TO TEMP-ACC-NAME.
           MOVE WS-NEW-BALANCE TO TEMP-ACC-BALANCE.
           MOVE 'A' TO TEMP-ACC-STATUS.
           WRITE TEMP-REC.

           CLOSE ACCOUNT-FILE.
           CLOSE TEMP-FILE.

      * Replace old file
           ACCEPT WS-OS-TYPE FROM ENVIRONMENT 'OS'.
           IF WS-OS-TYPE = 'Windows_NT'
               MOVE 'cmd /c del ACCOUNTS.DAT 2>nul' TO WS-CMD
               CALL 'SYSTEM' USING WS-CMD
               MOVE 'cmd /c ren ACCOUNTS.TMP ACCOUNTS.DAT' TO WS-CMD
               CALL 'SYSTEM' USING WS-CMD
           ELSE
               MOVE 'rm -f ACCOUNTS.DAT' TO WS-CMD
               CALL 'SYSTEM' USING WS-CMD
               MOVE 'mv ACCOUNTS.TMP ACCOUNTS.DAT' TO WS-CMD
               CALL 'SYSTEM' USING WS-CMD
           END-IF.

           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '     ACCOUNT CREATED SUCCESSFULLY!     '.
           DISPLAY '========================================'.
           DISPLAY ' '.
           DISPLAY 'Account Number : ' WS-NEW-ACC.
           DISPLAY 'Customer Name  : ' WS-NEW-NAME.
           DISPLAY 'Balance        : ' WS-FORMATTED-BAL.
           DISPLAY 'Status         : Active'.
           DISPLAY ' '.
           DISPLAY 'Please link this account to a user via'.
           DISPLAY 'Create User menu if needed.'.
           DISPLAY ' '.

           STOP RUN.
