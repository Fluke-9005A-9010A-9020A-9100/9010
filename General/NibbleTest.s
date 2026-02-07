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


PROGRAM BlockVerifyMask
   DPY-BVM /1 END /2 VALUE /3 MASK /4

MAINLOOP:
    DPY R1
	!Read the value at R1
    Read @ Reg1
	!Verify it matches the expected from R3 (mask the nibble)
    if REGC AND REG4 = REG3 GOTO GOOD

	!Failed
	DPY ERROR A $1 W $3 R $C #
	stop

GOOD:
	!Advance the R1 position
    inc REG1
    IF REG2 >= REG1 GOTO MAINLOOP
	DPY DONE #



PROGRAM NibbleWriteInc

   DPY-BLOCK WRITE INC
   DPY-BEGIN /1 END /2

	REG3 = 00
1: LABEL 1
   DPY R1
   WRITE @ REG1 = REG3
   INC REG1
	INC REG3
	IF REG3 > 0F goto 3

2:
   IF REG2 >= REG1 GOTO 1
   DPY DONE

3:
	REG3 = 0
	goto 2


PROGRAM NibbleVerifyInc

   DPY-BLOCK WRITE INC
   DPY-BEGIN /1 END /2

	REG3 = 00
1: LABEL 1
   DPY R1
   READ @ REG1

	!verify the value read is as expected
	IF REGC = REG3 goto 2
	DPY Verify fail A $1 #
	stop

2:
	INC REG1
	INC REG3
	IF REG3 > 0F goto 4

3:
   IF REG2 >= REG1 GOTO 1
   DPY DONE

4:
	REG3 = 0
	goto 2




program HighNibbleTest
    DPY-High Nibble test

	!The mask used when verifying
	REG4 = F0

    DPY 0x test
    reg3 = 00
    execute BlockWrite
    execute BlockVerifyMask

    DPY Fx test
    reg3 = F0
    execute BlockWrite
    execute BlockVerifyMask

    DPY 5x test
    reg3 = 50
    execute BlockWrite
    execute BlockVerifyMask

    DPY Ax test
    reg3 = A0
    execute BlockWrite
    execute BlockVerifyMask

program LowNibbleTest
    DPY-High Nibble test

	!The mask used when verifying
	REG4 = 0F

    DPY x0 test
    reg3 = 00
    execute BlockWrite
    execute BlockVerifyMask

    DPY xF test
    reg3 = 0F
    execute BlockWrite
    execute BlockVerifyMask

    DPY x5 test
    reg3 = 05
    execute BlockWrite
    execute BlockVerifyMask

    DPY xA test
    reg3 = 0A
    execute BlockWrite
    execute BlockVerifyMask

