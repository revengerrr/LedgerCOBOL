      * HISTORY.CPY - Transaction History Record Structure
       01  HISTORY-RECORD.
           05  HIST-DATE           PIC 9(8).
           05  HIST-TIME           PIC 9(6).
           05  HIST-FROM-ACC       PIC 9(10).
           05  HIST-TO-ACC         PIC 9(10).
           05  HIST-TYPE           PIC X(1).
               88  HIST-TRANSFER   VALUE 'T'.
               88  HIST-DEPOSIT    VALUE 'D'.
               88  HIST-WITHDRAW   VALUE 'W'.
           05  HIST-AMOUNT         PIC S9(13)V99.
           05  HIST-STATUS         PIC X(1).
               88  HIST-SUCCESS    VALUE 'S'.
               88  HIST-FAILED     VALUE 'F'.
               88  HIST-PENDING    VALUE 'P'.
