! Shared under the MIT License
! kralleman @ KLOV
! Copyright 2024

!! Basic Test Program for Missile Command. Inspired by Tempest script found
!! at http://games.rossiters.com/manuals/Fluke/Fluke%209010a/Scripts/Atari/

!! Note: It has been a while since I used this script. It could probably use some additional
!!       verification.

INCLUDE "6502.POD"

SETUP
   trap active force line no
   beep on err transition no  
   POD 6502

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!    HEX      R/W   D7 D6 D5 D4 D3 D2 D2 D0  function
!    ---------+-----+------------------------+------------------------
!    0000-01FF  R/W   D  D  D    D  D  D  D  D   512 bytes working ram
!    0200-05FF  R/W   D  D  D    D  D  D  D  D   3rd color bit region
!                                                of screen ram.
!                                                Each bit of every odd byte is the low color
!                                                bit for the bottom scanlines
!                                                The schematics say that its for the bottom
!                                                32 scanlines, although the code only accesses
!                                                $401-$5FF for the bottom 8 scanlines...
!                                                Pretty wild, huh?
!    0600-063F  R/W   D  D  D    D  D  D  D  D   More working ram.
!    0640-3FFF  R/W   D  D  D    D  D  D  D  D   2-color bit region of
!                                                screen ram.
!                                                Writes to 4 bytes each to effectively
!                                                address $1900-$ffff.
!    1900-FFFF  R/W   D  D                       2-color bit region of
!                                                screen ram
!                                                  Only accessed with
!                                                   LDA ($ZZ,X) and
!                                                   STA ($ZZ,X)
!                                                  Those instructions take longer
!                                                  than 5 cycles.
ADDRESS SPACE INFORMATION
   RAM @ 0000-3FFF	! PROGRAM RAM - 4116 SRAM

PROGRAM TITLE
   DPY-MISSILE COMMAND TEST PROGRAM
   Aux MISSILE COMMAND TEST PROGRAM

REG8 = 60

EXECUTE PAUSE

EXECUTE MENU 

PROGRAM MENU
0: LABEL 0

   DPY-MENU 1=RAM 2=ROM 3=POKEY /1
   Aux MENU 1=RAM 2=ROM 3=POKEY
   IF REG1 = 1 GOTO 1
   IF REG1 = 2 GOTO 2
   IF REG1 = 3 GOTO 3
   GOTO 0

1: LABEL 1
   EXECUTE PROGRAM RAMTEST
   GOTO 0

2: LABEL 2
   EXECUTE PROGRAM ROMTEST
   GOTO 0

3: LABEL 3
   EXECUTE PROGRAM POKEYTEST
   GOTO 0

PROGRAM RAMTEST
   DPY-TESTING WORKING RAM @ X Y #
   Aux TESTING WORKING RAM @ X Y
   RAM SHORT @ 0000-01FF

   DPY-TESTING MORE WORKING RAM @ X Y #
   Aux TESTING MORE WORKING RAM @ X Y
   RAM SHORT @ 0600-063F

   DPY-TESTING SCREEN RAM BIT 3 @ X Y #
   Aux TESTING SCREEN RAM BIT 3 @ X Y
   RAM SHORT @ 0200-05FF

   DPY-TESTING SCREEN RAM BIT 2 @ X Y #
   Aux TESTING SCREEN RAM BIT 2 @ X Y
   RAM SHORT @ 0640-3FFF

   DPY-RAM TESTING COMPLETE #
   Aux RAM TESTING COMPLETE

PROGRAM ROMTEST

0: LABEL 0
   DPY-ROM VERSION 1 - 2 - 3 or 4? /1
   Aux ROM VERSION 1 - 2 - 3 or 4?
   IF REG1 = 1 GOTO 1
   IF REG1 = 2 GOTO 2
   IF REG1 = 3 GOTO 3

   GOTO 0

! REV 1
1: LABEL 1

   DPY-PRESS 1 - 2708 OR 2 - 2716? /1
   Aux PRESS 1 - 2708 OR 2 - 2716?

   IF REG1 = 1 GOTO 4
   IF REG1 = 2 GOTO 5

   GOTO 1


! 2708 ROM rev 1
4: LABEL 4

   DPY-TESTING PROG ROM 035808 @ H1 #
   Aux TESTING PROG ROM 035808 @ H1
   ROM TEST @ 5000-53FF SIG B452

   DPY-TESTING PROG ROM 035809 @ D1 #
   Aux TESTING PROG ROM 035809 @ D1
   ROM TEST @ 5400-57FF SIG F7CC

   DPY-TESTING PROG ROM 035810 @ JK1 #
   Aux TESTING PROG ROM 035810 @ JK1
   ROM TEST @ 5800-5BFF SIG BCFC

   DPY-TESTING PROG ROM 035811 @ E1 #
   Aux TESTING PROG ROM 035811 @ E1
   ROM TEST @ 5C00-5FFF SIG 89CB

   DPY-TESTING PROG ROM 035812 @ KL1 #
   Aux TESTING PROG ROM 035812 @ KL1
   ROM TEST @ 6000-63FF SIG E570

   DPY-TESTING PROG ROM 035813 @ F1 #
   Aux TESTING PROG ROM 035813 @ F1
   ROM TEST @ 6400-67FF SIG 03F4

!LM1 is a 2716 ROM in all revisions
   DPY-TESTING PROG ROM 035823 @ LM1 #
   Aux TESTING PROG ROM 035823 @ LM1
   ROM TEST @ 6800-6FFF SIG EF62

   DPY-TESTING PROG ROM 035809 @ NP1 #
   Aux TESTING PROG ROM 035809 @ NP1
   ROM TEST @ 7000-73FF SIG F565

   DPY-TESTING PROG ROM 035809 @ MN1 #
   Aux TESTING PROG ROM 035809 @ MN1
   ROM TEST @ 7400-77FF SIG 4952

   DPY-TESTING PROG ROM 035818 @ R1 #
   Aux TESTING PROG ROM 035818 @ R1
   ROM TEST @ 7800-7BFF SIG 9834

   DPY-TESTING PROG ROM 035819 @ R3 #
   Aux TESTING PROG ROM 035819 @ R3
   ROM TEST @ 7C00-7FFF SIG 3FD7
   DPY-ROM TEST COMPLETE #
   Aux ROM TEST COMPLETE


! 2716 ROM rev 1
5: LABEL 5
   DPY-TESTING PROG ROM 035820 @ H1 #
   Aux TESTING PROG ROM 035820 @ H1
   ROM @ 5000-57FF SIG F25A !035820.02

   DPY-TESTING PROG ROM 035821 @ JK1 #
   Aux TESTING PROG ROM 035821 @ JK1
   ROM @ 5800-5FFF SIG 3977 !035821.02

   DPY-TESTING PROG ROM 035822 @ KL1 #
   Aux TESTING PROG ROM 035822 @ KL1
   ROM @ 6000-67FF SIG E850 !035822.02

   DPY-TESTING PROG ROM 035823 @ LM1 #
   Aux TESTING PROG ROM 035823 @ LM1
   ROM @ 6800-6FFF SIG EF62 !035823.02

   DPY-TESTING PROG ROM 035824 @ NP1 #
   Aux TESTING PROG ROM 035824 @ NP1
   ROM @ 7000-77FF SIG B25D !035824.02

   DPY-TESTING PROG ROM 035825 @ R1 #
   Aux TESTING PROG ROM 035825 @ R1
   ROM @ 7800-7FFF SIG B888 !035825.02

   DPY-ROM TEST COMPLETE #
   Aux ROM TEST COMPLETE

! REV 2
2: LABEL 2

   DPY-PRESS 1 - 2708 OR 2 - 2716? /1
   Aux PRESS 1 - 2708 OR 2 - 2716?

   IF REG1 = 1 GOTO 6
   IF REG1 = 2 GOTO 7

   GOTO 2


! 2708 ROM rev 2 
6: LABEL 6
   DPY-ROM TEST COMPLETE #
   Aux ROM TEST COMPLETE

! 2716 ROM rev 2
7: LABEL 7
   ROM @ 5000-57FF SIG 3A1F !35820-01.h1
   ROM @ 5800-5FFF SIG FE9F !35821-01.jk1
   ROM @ 6000-67FF SIG DAE6 !35822-01.kl1
   ROM @ 6800-6FFF SIG AE3F !35823-01.mn1
   ROM @ 7000-77FF SIG AB6A !35824-01.np1
   ROM @ 7800-7FFF SIG 293D !35825-01.r1
   DPY-ROM TEST COMPLETE #
   Aux ROM TEST COMPLETE

! REV 3
3: LABEL 3

   DPY-PRESS 1 - 16K ROM OR 2 - 32k? /1
   Aux PRESS 1 - 16K ROM OR 2 - 32k?

   IF REG1 = 1 GOTO 8
   IF REG1 = 2 GOTO 9
   GOTO 3

! 2708 ROM rev 3
8: LABEL 8
   DPY-ROM TEST COMPLETE #
   Aux ROM TEST COMPLETE

9: LABEL 9
   DPY-ROM TEST COMPLETE #
   Aux ROM TEST COMPLETE

PROGRAM POKEYTEST
   DPY-REQUIRES AUDIO. CONT

   STOP
   
   DPY-CONFIRM AUDIO. CONT#

   Aux CONFIRM AUDIO. CONT

   DPY-+=EXIT%1#

0: LABEL 0

   WRITE @ 3000 = 00
   IF REG1 = 25 GOTO 2
   GOTO 0

2: LABEL 2
   DPY-##


!!!!!! Pause Routine !!!!!!!!!!!!!!!

PROGRAM PAUSE

REG2 = REG8

	DLOOP:

	DEC REG2

	IF REG2 > 0 GOTO DLOOP
