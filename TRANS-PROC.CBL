       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANS-PROC.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE ASSIGN TO 'ACCOUNTS.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-FILE ASSIGN TO 'ACCOUNTS.TMP'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT HISTORY-FILE ASSIGN TO 'HISTORY.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT SESSION-FILE ASSIGN TO 'SESSION.DAT'
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

       FD  HISTORY-FILE.
       01 HISTORY-REC.
          05 HIST-DATE         PIC 9(8).
          05 HIST-TIME         PIC 9(6).
          05 HIST-FROM-ACC     PIC 9(10).
          05 HIST-TO-ACC       PIC 9(10).
          05 HIST-TYPE         PIC X(1).
          05 HIST-AMOUNT       PIC S9(13)V99.
          05 HIST-STATUS       PIC X(1).

       FD  SESSION-FILE.
       01 SESSION-REC.
          05 SESS-LOGGED-IN    PIC X(1).
          05 SESS-USER-NAME    PIC X(20).
          05 SESS-USER-ROLE    PIC X(1).
          05 SESS-USER-ACC     PIC 9(10).

       WORKING-STORAGE SECTION.
       01 WS-EOF-FLAG          PIC X         VALUE 'N'.
       01 WS-FOUND-FLAG        PIC X         VALUE 'N'.
       01 WS-TRANS-TYPE        PIC X.
       01 WS-TRANS-AMOUNT      PIC 9(13)V99.
       01 WS-TARGET-ACC        PIC 9(10).
       01 WS-CMD               PIC X(100).
       01 WS-OS-TYPE           PIC X(10).
       01 WS-USER-ROLE         PIC X(1).
       01 WS-USER-ACC          PIC 9(10).
       01 WS-CURRENT-DATE.
          05 WS-YEAR           PIC 9(4).
          05 WS-MONTH          PIC 9(2).
          05 WS-DAY            PIC 9(2).
       01 WS-CURRENT-TIME.
          05 WS-HOUR           PIC 9(2).
          05 WS-MIN            PIC 9(2).
          05 WS-SEC            PIC 9(2).
       01 WS-DATE-NUM          PIC 9(8).
       01 WS-TIME-NUM          PIC 9(6).
       01 WS-TRANS-SUCCESS     PIC X         VALUE 'N'.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
      * Read session to check role and account
           PERFORM READ-SESSION.

           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '         DEPOSIT / WITHDRAW            '.
           DISPLAY '========================================'.
           DISPLAY ' '.

      * If customer, auto-fill their account
           IF WS-USER-ROLE = 'C'
               MOVE WS-USER-ACC TO WS-TARGET-ACC
               DISPLAY 'Account Number: ' WS-TARGET-ACC 
                   ' (Your Account)'
           ELSE
               DISPLAY 'Account Number: ' WITH NO ADVANCING
               ACCEPT WS-TARGET-ACC
           END-IF.

           DISPLAY 'Type (D=Deposit / W=Withdraw): ' WITH NO ADVANCING.
           ACCEPT WS-TRANS-TYPE.
           DISPLAY 'Amount: ' WITH NO ADVANCING.
           ACCEPT WS-TRANS-AMOUNT.

           IF WS-TRANS-AMOUNT <= 0
               DISPLAY ' '
               DISPLAY '*** ERROR: Amount must be greater than 0! ***'
               STOP RUN
           END-IF.

           OPEN INPUT ACCOUNT-FILE.
           OPEN OUTPUT TEMP-FILE.

           MOVE 'N' TO WS-EOF-FLAG.
           MOVE 'N' TO WS-FOUND-FLAG.
           MOVE 'N' TO WS-TRANS-SUCCESS.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ ACCOUNT-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       IF REC-ACC-NUMBER = WS-TARGET-ACC
                           MOVE 'Y' TO WS-FOUND-FLAG
                           IF WS-TRANS-TYPE = 'D' OR 'd'
                               ADD WS-TRANS-AMOUNT TO REC-ACC-BALANCE
                               DISPLAY ' '
                               DISPLAY '*** Deposit Successful! ***'
                               MOVE 'Y' TO WS-TRANS-SUCCESS
                           ELSE
                               IF WS-TRANS-TYPE = 'W' OR 'w'
                                   IF REC-ACC-BALANCE >= WS-TRANS-AMOUNT
                                       SUBTRACT WS-TRANS-AMOUNT
                                           FROM REC-ACC-BALANCE
                                       DISPLAY ' '
                                       DISPLAY '*** Withdrawal Successful! ***'
                                       MOVE 'Y' TO WS-TRANS-SUCCESS
                                   ELSE
                                       DISPLAY ' '
                                       DISPLAY '*** ERROR: Insufficient balance! ***'
                                   END-IF
                               ELSE
                                   DISPLAY ' '
                                   DISPLAY '*** ERROR: Invalid transaction type! ***'
                               END-IF
                           END-IF
                       END-IF
                       MOVE ACCOUNT-REC TO TEMP-REC
                       WRITE TEMP-REC
               END-READ
           END-PERFORM.

           CLOSE ACCOUNT-FILE.
           CLOSE TEMP-FILE.

           IF WS-FOUND-FLAG = 'Y'
               ACCEPT WS-OS-TYPE FROM ENVIRONMENT 'OS'
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
               END-IF
      * Log to history if successful
               IF WS-TRANS-SUCCESS = 'Y'
                   PERFORM LOG-TRANSACTION
               END-IF
           ELSE
               DISPLAY ' '
               DISPLAY '*** ERROR: Account not found! ***'
               ACCEPT WS-OS-TYPE FROM ENVIRONMENT 'OS'
               IF WS-OS-TYPE = 'Windows_NT'
                   MOVE 'cmd /c del ACCOUNTS.TMP 2>nul' TO WS-CMD
                   CALL 'SYSTEM' USING WS-CMD
               ELSE
                   MOVE 'rm -f ACCOUNTS.TMP' TO WS-CMD
                   CALL 'SYSTEM' USING WS-CMD
               END-IF
           END-IF.

           STOP RUN.

       READ-SESSION.
           OPEN INPUT SESSION-FILE.
           READ SESSION-FILE
               AT END
                   MOVE 'A' TO WS-USER-ROLE
                   MOVE 0 TO WS-USER-ACC
               NOT AT END
                   MOVE SESS-USER-ROLE TO WS-USER-ROLE
                   MOVE SESS-USER-ACC TO WS-USER-ACC
           END-READ.
           CLOSE SESSION-FILE.

       LOG-TRANSACTION.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE
               WS-CURRENT-TIME.
           STRING WS-YEAR WS-MONTH WS-DAY DELIMITED BY SIZE
               INTO WS-DATE-NUM.
           STRING WS-HOUR WS-MIN WS-SEC DELIMITED BY SIZE
               INTO WS-TIME-NUM.

           OPEN EXTEND HISTORY-FILE.
           MOVE WS-DATE-NUM TO HIST-DATE.
           MOVE WS-TIME-NUM TO HIST-TIME.
           MOVE WS-TARGET-ACC TO HIST-FROM-ACC.
           MOVE 0 TO HIST-TO-ACC.
           IF WS-TRANS-TYPE = 'D' OR 'd'
               MOVE 'D' TO HIST-TYPE
           ELSE
               MOVE 'W' TO HIST-TYPE
           END-IF.
           MOVE WS-TRANS-AMOUNT TO HIST-AMOUNT.
           MOVE 'S' TO HIST-STATUS.
           WRITE HISTORY-REC.
           CLOSE HISTORY-FILE.
