       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHANGE-PIN.

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
       01 WS-INPUT-NAME           PIC X(20).
       01 WS-OLD-PIN              PIC 9(6).
       01 WS-NEW-PIN              PIC 9(6).
       01 WS-CONFIRM-PIN          PIC 9(6).
       01 WS-CMD                  PIC X(100).
       01 WS-OS-TYPE              PIC X(10).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY ' '.
           DISPLAY '=== CHANGE PIN ==='.
           DISPLAY ' '.
           DISPLAY 'Username: ' WITH NO ADVANCING.
           ACCEPT WS-INPUT-NAME.
           DISPLAY 'Current PIN: ' WITH NO ADVANCING.
           ACCEPT WS-OLD-PIN.
           DISPLAY 'New PIN (6 digits): ' WITH NO ADVANCING.
           ACCEPT WS-NEW-PIN.
           DISPLAY 'Confirm New PIN: ' WITH NO ADVANCING.
           ACCEPT WS-CONFIRM-PIN.

      * Validate new PIN
           IF WS-NEW-PIN NOT = WS-CONFIRM-PIN
               DISPLAY ' '.
               DISPLAY '*** ERROR: PINs do not match! ***'
               STOP RUN
           END-IF.

           IF WS-NEW-PIN = WS-OLD-PIN
               DISPLAY ' '.
               DISPLAY '*** ERROR: New PIN same as old PIN! ***'
               STOP RUN
           END-IF.

           OPEN INPUT USER-FILE.
           OPEN OUTPUT TEMP-FILE.

           MOVE 'N' TO WS-EOF-FLAG.
           MOVE 'N' TO WS-FOUND-FLAG.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ USER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       PERFORM PROCESS-USER
               END-READ
           END-PERFORM.

           CLOSE USER-FILE.
           CLOSE TEMP-FILE.

           IF WS-FOUND-FLAG = 'Y'
               DISPLAY ' '.
               DISPLAY '*** PIN CHANGED SUCCESSFULLY! ***'
               DISPLAY 'Please use your new PIN next login.'
      * Replace old file with new
               ACCEPT WS-OS-TYPE FROM ENVIRONMENT 'OS'
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
               END-IF
           ELSE
               DISPLAY ' '.
               DISPLAY '*** ERROR: User not found or wrong PIN! ***'
      * Delete temp file
               ACCEPT WS-OS-TYPE FROM ENVIRONMENT 'OS'
               IF WS-OS-TYPE = 'Windows_NT'
                   MOVE 'cmd /c del USERS.TMP' TO WS-CMD
                   CALL 'SYSTEM' USING WS-CMD
               ELSE
                   MOVE 'rm -f USERS.TMP' TO WS-CMD
                   CALL 'SYSTEM' USING WS-CMD
               END-IF
           END-IF.

           STOP RUN.

       PROCESS-USER.
           IF FUNCTION UPPER-CASE(REC-USER-NAME) =
              FUNCTION UPPER-CASE(WS-INPUT-NAME)
               IF REC-USER-PIN = WS-OLD-PIN
                   MOVE 'Y' TO WS-FOUND-FLAG
                   MOVE WS-NEW-PIN TO REC-USER-PIN
               END-IF
           END-IF.
           MOVE USER-REC TO TEMP-REC.
           WRITE TEMP-REC.
