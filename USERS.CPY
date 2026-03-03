      * USERS.CPY - User Record Structure for Authentication
       01  USER-RECORD.
           05  USER-ID             PIC 9(5).
           05  USER-NAME           PIC X(20).
           05  USER-PIN            PIC 9(6).
           05  USER-ROLE           PIC X(1).
               88  ROLE-ADMIN      VALUE 'A'.
               88  ROLE-TELLER     VALUE 'T'.
               88  ROLE-CUSTOMER   VALUE 'C'.
           05  USER-ACC-NUMBER     PIC 9(10).
           05  USER-STATUS         PIC X(1).
               88  USER-ACTIVE     VALUE 'A'.
               88  USER-LOCKED     VALUE 'L'.
               88  USER-INACTIVE   VALUE 'I'.
           05  USER-LOGIN-ATTEMPTS PIC 9(1).
