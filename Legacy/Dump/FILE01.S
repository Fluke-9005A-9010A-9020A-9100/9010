
PROGRAM 1   93 BYTES

   REG1 = 20
1: LABEL 1
   DPY-REG 1 CONTAINS $1 HEX
   REGF = 40
3: LABEL 3
   DEC REGF
   IF REGF > 0 GOTO 3
   REG2 = 10
2: LABEL 2
   DPY-@2
   DEC REG2
   IF REG2 > 0 GOTO 2
   DEC REG1
   IF REG1 > 0 GOTO 1
   DPY-DONE#

PROGRAM 2   159 BYTES

   DPY-ENTER UUT MEM IN HEX /F
1: LABEL 1
   READ @ REGF
   IF REGE > F GOTO 2
   DPY-UUT MEM.$F=0$E
   DPY-+  ** HIT CONT **
   GOTO 3
2: LABEL 2
   DPY-UUT MEM.$F=$E
   DPY-+  ** HIT CONT **
3: LABEL 3
   STOP
   INC REGF
   IF FFFF >= REGF GOTO 1
   DPY-ENTER NEW VALUE/F
   GOTO 1
