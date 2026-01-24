! create a method that takes a starting address and ending address 
! then writes a set of value to each item in that range
! reading them back to ensure they were written correctly.






PROGRAM BlockWrite

   DPY-BLOCK WRITE UTILITY
   DPY-+-PRESS CONT
   STOP
   DPY-BEGIN /1 END /2 VALUE /3
1: LABEL 1
   DPY R1
   WRITE @ REG1 = REG3
   INC REG1
   IF REG2 >= REG1 GOTO 1
   DPY DONE

PROGRAM BlockVerify
   DPY-BEGIN /1 END /2 VALUE /3
1: LABEL 1
    DPY R1
    Read @ Reg1 



program NibbleTest
    DPY-Nibble test

    DPY 0x test
    reg3 = 00
    execute BlockWrite
    execute BlockVerify

    DPY Fx test
    reg3 = F0
    execute BlockWrite
    execute BlockVerify

    DPY 5x test
    reg3 = 50
    execute BlockWrite
    execute BlockVerify

    DPY Ax test
    reg3 = A0
    execute BlockWrite
    execute BlockVerify

