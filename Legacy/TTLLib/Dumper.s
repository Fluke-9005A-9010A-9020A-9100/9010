!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! The DUMPER Utility (from the Fluke Programmer manual)
!
! This program will take the operator input for the begining
! ending memory locations (in hex) then send ASCII formatted
! text out the 232 port to the host computer.
!
! Capture the text on your host computer and save as a text file.
!
! Use the Hex2Bin.EXE (DOS) or Hex2BIN32.EXE (Windows) program
! to covert the ASCII text file to a binary file for your ROM
! burner.  Thanks to Zonn Moore for these utilities!
!
! This utility is handy for dumpping out ROMs that may be soldered
! in the board or otherwise not removable.
!
! NOTE: This is a fairly slow task, a 2532 (4K) file will take a 
! couple of minutes to dump & produce a ~14K text file.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

PROGRAM 0   90 BYTES

   DPY-DUMPER UTILITY
   DPY-+-PRESS CONT
   STOP
   DPY-BEGIN /1  END /2
   REG1 = REG1 AND FFF0
   AUX-
1: LABEL 1
   IF REG1 AND F> 0 GOTO 3
   AUX-
   IF REG1 > FFF GOTO 2
   AUX-0+
   IF REG1 > FF GOTO 2
   AUX-0+
   IF REG1 > F GOTO 2
   AUX-0+
2: LABEL 2
   AUX-$1+
3: LABEL 3
   AUX- +
   IF REG1 AND 7 > 0 GOTO 4
   AUX- +
4: LABEL 4
   READ @ REG1
   IF REGE > F GOTO 5
   AUX-0+
5: LABEL 5
   AUX-$E+
   INC REG1
   IF REG2 >= REG1 GOTO 1
   AUX-
