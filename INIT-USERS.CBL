       IDENTIFICATION DIVISION.
       PROGRAM-ID. INIT-USERS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE ASSIGN TO 'USERS.DAT'
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

       WORKING-STORAGE SECTION.
       01 WS-MSG                  PIC X(50).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           OPEN OUTPUT USER-FILE.

      * Admin User (no account linked)
           MOVE 00001 TO REC-USER-ID.
           MOVE 'ADMIN' TO REC-USER-NAME.
           MOVE 123456 TO REC-USER-PIN.
           MOVE 'A' TO REC-USER-ROLE.
           MOVE 0000000000 TO REC-USER-ACC.
           MOVE 'A' TO REC-USER-STATUS.
           MOVE 0 TO REC-USER-ATTEMPTS.
           WRITE USER-REC.

      * Teller User (no account linked)
           MOVE 00002 TO REC-USER-ID.
           MOVE 'TELLER1' TO REC-USER-NAME.
           MOVE 111111 TO REC-USER-PIN.
           MOVE 'T' TO REC-USER-ROLE.
           MOVE 0000000000 TO REC-USER-ACC.
           MOVE 'A' TO REC-USER-STATUS.
           MOVE 0 TO REC-USER-ATTEMPTS.
           WRITE USER-REC.

      * Customer: John Doe
           MOVE 00003 TO REC-USER-ID.
           MOVE 'JOHN DOE' TO REC-USER-NAME.
           MOVE 100001 TO REC-USER-PIN.
           MOVE 'C' TO REC-USER-ROLE.
           MOVE 1000000001 TO REC-USER-ACC.
           MOVE 'A' TO REC-USER-STATUS.
           MOVE 0 TO REC-USER-ATTEMPTS.
           WRITE USER-REC.

      * Customer: Jane Smith
           MOVE 00004 TO REC-USER-ID.
           MOVE 'JANE SMITH' TO REC-USER-NAME.
           MOVE 100002 TO REC-USER-PIN.
           MOVE 'C' TO REC-USER-ROLE.
           MOVE 1000000002 TO REC-USER-ACC.
           MOVE 'A' TO REC-USER-STATUS.
           MOVE 0 TO REC-USER-ATTEMPTS.
           WRITE USER-REC.

      * Customer: Bob Johnson
           MOVE 00005 TO REC-USER-ID.
           MOVE 'BOB JOHNSON' TO REC-USER-NAME.
           MOVE 100003 TO REC-USER-PIN.
           MOVE 'C' TO REC-USER-ROLE.
           MOVE 1000000003 TO REC-USER-ACC.
           MOVE 'A' TO REC-USER-STATUS.
           MOVE 0 TO REC-USER-ATTEMPTS.
           WRITE USER-REC.

           CLOSE USER-FILE.
           DISPLAY ' '.
           DISPLAY '=== USER DATABASE INITIALIZED ==='.
           DISPLAY ' '.
           DISPLAY 'Default Users Created:'.
           DISPLAY '------------------------'.
           DISPLAY 'ADMIN    | PIN: 123456 | Role: Admin'.
           DISPLAY 'TELLER1  | PIN: 111111 | Role: Teller'.
           DISPLAY 'JOHN DOE | PIN: 100001 | Role: Customer'.
           DISPLAY 'JANE SMITH | PIN: 100002 | Role: Customer'.
           DISPLAY 'BOB JOHNSON | PIN: 100003 | Role: Customer'.
           DISPLAY '------------------------'.
           DISPLAY ' '.

           STOP RUN.
