       IDENTIFICATION DIVISION.
       PROGRAM-ID. LIST-USERS.

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
       01 WS-EOF-FLAG             PIC X         VALUE 'N'.
       01 WS-COUNT                PIC 9(5)      VALUE 0.
       01 WS-ROLE-DISPLAY         PIC X(12).
       01 WS-STATUS-DISPLAY       PIC X(10).
       01 WS-LINE                 PIC X(70)     VALUE ALL '-'.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           OPEN INPUT USER-FILE.

           DISPLAY ' '.
           DISPLAY '========================================'.
           DISPLAY '           USER LIST REPORT             '.
           DISPLAY '========================================'.
           DISPLAY ' '.
           DISPLAY 'ID    | NAME                 | ROLE     '
                   '    | STATUS'.
           DISPLAY WS-LINE.

           MOVE 'N' TO WS-EOF-FLAG.
           MOVE 0 TO WS-COUNT.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ USER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       PERFORM DISPLAY-USER
               END-READ
           END-PERFORM.

           CLOSE USER-FILE.

           DISPLAY WS-LINE.
           DISPLAY ' '.
           DISPLAY 'Total Users: ' WS-COUNT.
           DISPLAY ' '.

           STOP RUN.

       DISPLAY-USER.
           ADD 1 TO WS-COUNT.

      * Convert role code to display name
           EVALUATE REC-USER-ROLE
               WHEN 'A'
                   MOVE 'Admin' TO WS-ROLE-DISPLAY
               WHEN 'T'
                   MOVE 'Teller' TO WS-ROLE-DISPLAY
               WHEN 'C'
                   MOVE 'Customer' TO WS-ROLE-DISPLAY
               WHEN OTHER
                   MOVE 'Unknown' TO WS-ROLE-DISPLAY
           END-EVALUATE.

      * Convert status code to display name
           EVALUATE REC-USER-STATUS
               WHEN 'A'
                   MOVE 'Active' TO WS-STATUS-DISPLAY
               WHEN 'L'
                   MOVE 'Locked' TO WS-STATUS-DISPLAY
               WHEN 'I'
                   MOVE 'Inactive' TO WS-STATUS-DISPLAY
               WHEN OTHER
                   MOVE 'Unknown' TO WS-STATUS-DISPLAY
           END-EVALUATE.

           DISPLAY REC-USER-ID ' | ' 
                   REC-USER-NAME ' | '
                   WS-ROLE-DISPLAY ' | '
                   WS-STATUS-DISPLAY.
