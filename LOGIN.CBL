       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOGIN.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE ASSIGN TO 'USERS.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-FILE ASSIGN TO 'USERS.TMP'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  USER-FILE.
       01 USER-REC.
          05 REC-USER-ID          PIC 9(5).
          05 REC-USER-NAME        PIC X(20).
          05 REC-USER-PIN         PIC 9(6).
          05 REC-USER-ROLE        PIC X(1).
          05 REC-USER-ACC         PIC 9(10).
          05 REC-USER-STATUS      PIC X(1).
          05 REC-USER-ATTEMPTS    PIC 9(1).

       FD  TEMP-FILE.
       01 TEMP-REC.
          05 TEMP-USER-ID         PIC 9(5).
          05 TEMP-USER-NAME       PIC X(20).
          05 TEMP-USER-PIN        PIC 9(6).
          05 TEMP-USER-ROLE       PIC X(1).
          05 TEMP-USER-ACC        PIC 9(10).
          05 TEMP-USER-STATUS     PIC X(1).
          05 TEMP-USER-ATTEMPTS   PIC 9(1).

       WORKING-STORAGE SECTION.
       01 WS-EOF-FLAG             PIC X         VALUE 'N'.
       01 WS-FOUND-FLAG           PIC X         VALUE 'N'.
       01 WS-LOGIN-SUCCESS        PIC X         VALUE 'N'.
       01 WS-INPUT-NAME           PIC X(20).
       01 WS-INPUT-PIN            PIC 9(6).
       01 WS-MAX-ATTEMPTS         PIC 9         VALUE 3.
       01 WS-CMD                  PIC X(100).
       01 WS-OS-TYPE              PIC X(10).

      * Shared variables untuk session (exported)
       01 WS-CURRENT-USER         PIC X(20).
       01 WS-CURRENT-ROLE         PIC X(1).
       01 WS-CURRENT-ACC          PIC 9(10).
       01 WS-LOGGED-IN            PIC X         VALUE 'N'.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM LOGIN-SCREEN.
           STOP RUN.

       LOGIN-SCREEN.
           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '        LEDGERCOBOL - LOGIN             '.
           DISPLAY '========================================'.
           DISPLAY ' '.
           DISPLAY 'Username: ' WITH NO ADVANCING.
           ACCEPT WS-INPUT-NAME.
           DISPLAY 'PIN (6 digits): ' WITH NO ADVANCING.
           ACCEPT WS-INPUT-PIN.
           DISPLAY ' '.

           PERFORM VALIDATE-LOGIN.

           IF WS-LOGIN-SUCCESS = 'Y'
              DISPLAY '----------------------------------------'
              DISPLAY ' LOGIN SUCCESSFUL!'
              DISPLAY ' Welcome, ' WS-CURRENT-USER
              EVALUATE WS-CURRENT-ROLE
                 WHEN 'A'
                    DISPLAY ' Role: Administrator'
                 WHEN 'T'
                    DISPLAY ' Role: Teller'
                 WHEN 'C'
                    DISPLAY ' Role: Customer'
                    DISPLAY ' Account: ' WS-CURRENT-ACC
              END-EVALUATE
              DISPLAY '----------------------------------------'
              MOVE 'Y' TO WS-LOGGED-IN
           ELSE
              DISPLAY '----------------------------------------'
              DISPLAY ' LOGIN FAILED!'
              DISPLAY ' Invalid username or PIN.'
              DISPLAY '----------------------------------------'
              MOVE 'N' TO WS-LOGGED-IN
           END-IF.

       VALIDATE-LOGIN.
           OPEN INPUT USER-FILE.
           OPEN OUTPUT TEMP-FILE.

           MOVE 'N' TO WS-EOF-FLAG.
           MOVE 'N' TO WS-FOUND-FLAG.
           MOVE 'N' TO WS-LOGIN-SUCCESS.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ USER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       PERFORM CHECK-USER
               END-READ
           END-PERFORM.

           CLOSE USER-FILE.
           CLOSE TEMP-FILE.

      * Update user file with new attempt counts
           ACCEPT WS-OS-TYPE FROM ENVIRONMENT 'OS'.
           IF WS-OS-TYPE = 'Windows_NT'
              MOVE 'cmd /c del USERS.DAT' TO WS-CMD
              CALL 'SYSTEM' USING WS-CMD
              MOVE 'cmd /c ren USERS.TMP USERS.DAT' TO WS-CMD
              CALL 'SYSTEM' USING WS-CMD
           ELSE
              MOVE 'rm -f USERS.DAT' TO WS-CMD
              CALL 'SYSTEM' USING WS-CMD
              MOVE 'mv USERS.TMP USERS.DAT' TO WS-CMD
              CALL 'SYSTEM' USING WS-CMD
           END-IF.

       CHECK-USER.
      * Check if username matches (case-insensitive check)
           IF FUNCTION UPPER-CASE(REC-USER-NAME) = 
              FUNCTION UPPER-CASE(WS-INPUT-NAME)
               MOVE 'Y' TO WS-FOUND-FLAG

      * Check if account is locked
               IF REC-USER-STATUS = 'L'
                   DISPLAY 'Account is LOCKED. Contact admin.'
                   MOVE USER-REC TO TEMP-REC
                   WRITE TEMP-REC
               ELSE
      * Check PIN
                   IF REC-USER-PIN = WS-INPUT-PIN
      * Login success - reset attempts
                       MOVE 'Y' TO WS-LOGIN-SUCCESS
                       MOVE REC-USER-NAME TO WS-CURRENT-USER
                       MOVE REC-USER-ROLE TO WS-CURRENT-ROLE
                       MOVE REC-USER-ACC TO WS-CURRENT-ACC
                       MOVE 0 TO REC-USER-ATTEMPTS
                       MOVE USER-REC TO TEMP-REC
                       WRITE TEMP-REC
                   ELSE
      * Wrong PIN - increment attempts
                       ADD 1 TO REC-USER-ATTEMPTS
                       IF REC-USER-ATTEMPTS >= WS-MAX-ATTEMPTS
                           MOVE 'L' TO REC-USER-STATUS
                           DISPLAY 'Too many attempts. Account LOCKED.'
                       ELSE
                           DISPLAY 'Wrong PIN. Attempts left: '
                               WITH NO ADVANCING
                           COMPUTE WS-MAX-ATTEMPTS = 
                               WS-MAX-ATTEMPTS - REC-USER-ATTEMPTS
                           DISPLAY WS-MAX-ATTEMPTS
                       END-IF
                       MOVE USER-REC TO TEMP-REC
                       WRITE TEMP-REC
                   END-IF
               END-IF
           ELSE
      * Not matching user, just copy
               MOVE USER-REC TO TEMP-REC
               WRITE TEMP-REC
           END-IF.
