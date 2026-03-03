       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE-USER.

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
       01 WS-DUPLICATE-FLAG       PIC X         VALUE 'N'.
       01 WS-NEW-NAME             PIC X(20).
       01 WS-NEW-PIN              PIC 9(6).
       01 WS-NEW-ROLE             PIC X(1).
       01 WS-NEW-ACC              PIC 9(10).
       01 WS-LAST-ID              PIC 9(5)      VALUE 0.
       01 WS-NEW-ID               PIC 9(5).
       01 WS-CMD                  PIC X(100).
       01 WS-OS-TYPE              PIC X(10).
       01 WS-ROLE-DISPLAY         PIC X(15).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '      CREATE NEW USER (Admin Only)      '.
           DISPLAY '========================================'.
           DISPLAY ' '.
           DISPLAY 'Enter Username (max 20 chars): ' 
               WITH NO ADVANCING.
           ACCEPT WS-NEW-NAME.
           
           IF WS-NEW-NAME = SPACES
               DISPLAY ' '
               DISPLAY '*** ERROR: Username cannot be empty! ***'
               STOP RUN
           END-IF.

           DISPLAY ' '.
           DISPLAY 'Select Role:'.
           DISPLAY '  A = Administrator'.
           DISPLAY '  T = Teller'.
           DISPLAY '  C = Customer'.
           DISPLAY 'Role: ' WITH NO ADVANCING.
           ACCEPT WS-NEW-ROLE.

           IF WS-NEW-ROLE NOT = 'A' AND 
              WS-NEW-ROLE NOT = 'T' AND
              WS-NEW-ROLE NOT = 'C' AND
              WS-NEW-ROLE NOT = 'a' AND
              WS-NEW-ROLE NOT = 't' AND
              WS-NEW-ROLE NOT = 'c'
               DISPLAY ' '
               DISPLAY '*** ERROR: Invalid role! ***'
               STOP RUN
           END-IF.

      * Convert to uppercase
           IF WS-NEW-ROLE = 'a'
               MOVE 'A' TO WS-NEW-ROLE
           END-IF.
           IF WS-NEW-ROLE = 't'
               MOVE 'T' TO WS-NEW-ROLE
           END-IF.
           IF WS-NEW-ROLE = 'c'
               MOVE 'C' TO WS-NEW-ROLE
           END-IF.

      * Only ask for account number if Customer
           IF WS-NEW-ROLE = 'C'
               DISPLAY 'Account Number (10 digits): '
                   WITH NO ADVANCING
               ACCEPT WS-NEW-ACC
           ELSE
               MOVE 0 TO WS-NEW-ACC
           END-IF.

           DISPLAY ' '.
           DISPLAY 'Default PIN will be set to: 000000'.
           DISPLAY 'User must change PIN on first login.'.
           MOVE 000000 TO WS-NEW-PIN.

           DISPLAY ' '.
           DISPLAY 'Checking username availability...'.

      * Check for duplicates and find last ID
           OPEN INPUT USER-FILE.
           MOVE 'N' TO WS-EOF-FLAG.
           MOVE 'N' TO WS-DUPLICATE-FLAG.
           MOVE 0 TO WS-LAST-ID.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ USER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       PERFORM CHECK-DUPLICATE
               END-READ
           END-PERFORM.
           CLOSE USER-FILE.

           IF WS-DUPLICATE-FLAG = 'Y'
               DISPLAY ' '
               DISPLAY '*** ERROR: Username already exists! ***'
               STOP RUN
           END-IF.

      * Create new user - copy all existing + add new
           OPEN INPUT USER-FILE.
           OPEN OUTPUT TEMP-FILE.
           MOVE 'N' TO WS-EOF-FLAG.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ USER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       MOVE USER-REC TO TEMP-REC
                       WRITE TEMP-REC
               END-READ
           END-PERFORM.

      * Add new user record
           ADD 1 TO WS-LAST-ID GIVING WS-NEW-ID.
           MOVE WS-NEW-ID TO TEMP-USER-ID.
           MOVE WS-NEW-NAME TO TEMP-USER-NAME.
           MOVE WS-NEW-PIN TO TEMP-USER-PIN.
           MOVE WS-NEW-ROLE TO TEMP-USER-ROLE.
           MOVE WS-NEW-ACC TO TEMP-USER-ACC.
           MOVE 'A' TO TEMP-USER-STATUS.
           MOVE 0 TO TEMP-USER-ATTEMPTS.
           WRITE TEMP-REC.

           CLOSE USER-FILE.
           CLOSE TEMP-FILE.

      * Replace old file with new
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

      * Set role display name
           EVALUATE WS-NEW-ROLE
               WHEN 'A'
                   MOVE 'Administrator' TO WS-ROLE-DISPLAY
               WHEN 'T'
                   MOVE 'Teller' TO WS-ROLE-DISPLAY
               WHEN 'C'
                   MOVE 'Customer' TO WS-ROLE-DISPLAY
           END-EVALUATE.

           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '       USER CREATED SUCCESSFULLY!       '.
           DISPLAY '========================================'.
           DISPLAY ' '.
           DISPLAY 'User ID    : ' WS-NEW-ID.
           DISPLAY 'Username   : ' WS-NEW-NAME.
           DISPLAY 'Role       : ' WS-ROLE-DISPLAY.
           DISPLAY 'Default PIN: 000000'.
           IF WS-NEW-ACC > 0
               DISPLAY 'Account    : ' WS-NEW-ACC
           END-IF.
           DISPLAY ' '.
           DISPLAY 'IMPORTANT: User must change PIN on first login!'.
           DISPLAY ' '.

           STOP RUN.

       CHECK-DUPLICATE.
      * Check if username already exists (case-insensitive)
           IF FUNCTION UPPER-CASE(REC-USER-NAME) =
              FUNCTION UPPER-CASE(WS-NEW-NAME)
               MOVE 'Y' TO WS-DUPLICATE-FLAG
           END-IF.
      * Track highest user ID
           IF REC-USER-ID > WS-LAST-ID
               MOVE REC-USER-ID TO WS-LAST-ID
           END-IF.
