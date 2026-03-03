       IDENTIFICATION DIVISION.
       PROGRAM-ID. HISTORY.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT HISTORY-FILE ASSIGN TO 'HISTORY.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT SESSION-FILE ASSIGN TO 'SESSION.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
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
       01 WS-COUNT             PIC 9(5)      VALUE 0.
       01 WS-LINE              PIC X(75)     VALUE ALL '-'.
       01 WS-TYPE-DISPLAY      PIC X(10).
       01 WS-STATUS-DISPLAY    PIC X(10).
       01 WS-FORMATTED-AMT     PIC $$$,$$$,$$$,$$9.99.
       01 WS-FORMATTED-DATE    PIC X(10).
       01 WS-FORMATTED-TIME    PIC X(8).
       01 WS-USER-ROLE         PIC X(1).
       01 WS-USER-ACC          PIC 9(10).
       01 WS-FILTER-ACC        PIC 9(10).
       01 WS-SHOW-RECORD       PIC X         VALUE 'N'.
       01 WS-DATE-WORK.
          05 WS-D-YEAR         PIC 9(4).
          05 WS-D-MONTH        PIC 9(2).
          05 WS-D-DAY          PIC 9(2).
       01 WS-TIME-WORK.
          05 WS-T-HOUR         PIC 9(2).
          05 WS-T-MIN          PIC 9(2).
          05 WS-T-SEC          PIC 9(2).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
      * Read session to check role
           PERFORM READ-SESSION.

           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '        TRANSACTION HISTORY            '.
           DISPLAY '========================================'.
           DISPLAY ' '.

      * If customer, only show their transactions
           IF WS-USER-ROLE = 'C'
               MOVE WS-USER-ACC TO WS-FILTER-ACC
               DISPLAY 'Showing history for account: ' WS-FILTER-ACC
           ELSE
               DISPLAY 'Enter Account Number (0 for all): '
                   WITH NO ADVANCING
               ACCEPT WS-FILTER-ACC
               IF WS-FILTER-ACC = 0
                   DISPLAY 'Showing ALL transactions'
               ELSE
                   DISPLAY 'Filtering by account: ' WS-FILTER-ACC
               END-IF
           END-IF.

           DISPLAY ' '.
           DISPLAY WS-LINE.
           DISPLAY 'DATE       | TIME     | TYPE     | AMOUNT    '
                   '     | FROM/TO'.
           DISPLAY WS-LINE.

           OPEN INPUT HISTORY-FILE.
           MOVE 'N' TO WS-EOF-FLAG.
           MOVE 0 TO WS-COUNT.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ HISTORY-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       PERFORM DISPLAY-HISTORY
               END-READ
           END-PERFORM.

           CLOSE HISTORY-FILE.

           DISPLAY WS-LINE.
           DISPLAY ' '.
           DISPLAY 'Total Transactions: ' WS-COUNT.
           DISPLAY ' '.

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

       DISPLAY-HISTORY.
      * Check if should show this record
           MOVE 'N' TO WS-SHOW-RECORD.

           IF WS-FILTER-ACC = 0
               MOVE 'Y' TO WS-SHOW-RECORD
           ELSE
               IF HIST-FROM-ACC = WS-FILTER-ACC OR
                  HIST-TO-ACC = WS-FILTER-ACC
                   MOVE 'Y' TO WS-SHOW-RECORD
               END-IF
           END-IF.

           IF WS-SHOW-RECORD = 'Y'
               ADD 1 TO WS-COUNT

      * Format date (YYYYMMDD -> YYYY-MM-DD)
               MOVE HIST-DATE TO WS-DATE-WORK
               STRING WS-D-YEAR '-' WS-D-MONTH '-' WS-D-DAY
                   DELIMITED BY SIZE INTO WS-FORMATTED-DATE

      * Format time (HHMMSS -> HH:MM:SS)
               MOVE HIST-TIME TO WS-TIME-WORK
               STRING WS-T-HOUR ':' WS-T-MIN ':' WS-T-SEC
                   DELIMITED BY SIZE INTO WS-FORMATTED-TIME

      * Convert type code
               EVALUATE HIST-TYPE
                   WHEN 'T'
                       MOVE 'TRANSFER' TO WS-TYPE-DISPLAY
                   WHEN 'D'
                       MOVE 'DEPOSIT' TO WS-TYPE-DISPLAY
                   WHEN 'W'
                       MOVE 'WITHDRAW' TO WS-TYPE-DISPLAY
                   WHEN OTHER
                       MOVE 'UNKNOWN' TO WS-TYPE-DISPLAY
               END-EVALUATE

      * Format amount
               MOVE HIST-AMOUNT TO WS-FORMATTED-AMT

      * Display based on type
               IF HIST-TYPE = 'T'
                   DISPLAY WS-FORMATTED-DATE ' | '
                       WS-FORMATTED-TIME ' | '
                       WS-TYPE-DISPLAY ' | '
                       WS-FORMATTED-AMT
                   DISPLAY '           FROM: ' HIST-FROM-ACC
                       ' -> TO: ' HIST-TO-ACC
               ELSE
                   DISPLAY WS-FORMATTED-DATE ' | '
                       WS-FORMATTED-TIME ' | '
                       WS-TYPE-DISPLAY ' | '
                       WS-FORMATTED-AMT ' | '
                       HIST-FROM-ACC
               END-IF
           END-IF.
