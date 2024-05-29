! Bally-Midway Galaga Test Routine
! Works in all three processor sockets

INCLUDE "Z80.POD"

SETUP   

   TRAP ACTIVE FORCE LINE NO   
   TRAP ACTIVE INTERRUPT NO
   
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   ! MAIN TEST ROUTINE

PROGRAM MAIN   
   DPY-#   
   DPY-SILENCING SOUND   
   EX DELAY   
   REGF=6800
   
QUIET:
   WRITE @ REGF=00
   INC REGF
   IF 6820 > REGF GOTO QUIET
   DPY-#
   DPY-BUS TEST   
   EX DELAY   
   BUS TEST   
   DPY-#   
   DPY-WHICH PROCESSOR ARE YOU TESTING   
   EX DELAY
MAINLOOP:
   DPY-CPU LOCATION 0=4M  1=4J  2=4E \1   
   IF REG1 > 2 GOTO MAINLOOP   
   IF REG1 = 0 GOTO MAINTEST   
   IF REG1 = 1 GOTO MOTIONTEST   
   IF REG1 = 2 GOTO SOUNDTEST
   
MAINTEST:   

   EX MAINPROCESSOR   
   GOTO COMMON

MOTIONTEST:   
   EX MOTION   
   GOTO COMMON

SOUNDTEST:
   EX SOUND   
   GOTO COMMON
   
COMMON:   
   DPY-#RAM TESTS   
   EX DELAY   
   
   DPY-#TESTING RAM AT 1K   
   EX  RAM1KTEST   
   
   DPY-#TESTING RAMS AT 3E AND 3F   
   EX   RAM3EFTEST   
   
   DPY-#TESTING RAMS AT 3K AND 3L   
   EX   RAM3KLTEST   
   
   DPY-#TESTING RAMS AT 3H AND 3J   
   EX   RAM3HJTEST   
   
   DPY-#ALL RAM TESTS COMPLETE   
   EX DELAY   
   
   DPY-TESTING DIP SWITCHES   
   EX DELAY   
   
   DPY-PRESS CONT TO STEP   
   EX DELAY   
   
   REG2=0   
   REGF=67FF

SWITCHLOOP:   
   INC REGF   
   INC REG2   
   READ @REGF   
   IF REGE AND 1 >0 GOTO SW6KOFF    
   GOTO SW6KON

NEXTSW:      
   IF REGE AND 2 >0 GOTO SW6JOFF    
   GOTO SW6JON
ADDTEST:      
   IF REGF >6807 GOTO CONT   
   GOTO SWITCHLOOP
   
SW6KON:   
   DPY-#   
   DPY-6K NUMBER $2 ON   
   STOP   
   GOTO NEXTSW
   
SW6JON:   
   IF REGF=6807 GOTO CONT   
   DPY-#   
   DPY-6J NUMBER $2 ON 
   STOP 
   GOTO ADDTEST
   
SW6KOFF:   
   DPY-#   
   DPY-6K NUMBER $2 OFF   
   STOP   
   GOTO NEXTSW
   
SW6JOFF:   
   IF REGF=6807 GOTO CONT   
   DPY-#   
   DPY-6J NUMBER $2 OFF  
   STOP   
   GOTO ADDTEST
   
CONT:   
   DPY-#   
   DPY-DIP TEST COMPLETE   
   EX DELAY   
   DPY-ATTEMPTING TO RUN SECTION   
   RUN UUT   
   EX DELAY   
   DPY-COMPLETE
   
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   !DELAY ROUTINE
   
PROGRAM DELAY
REG1=40
0:
DEC REG1
IF REG1 >0 GOTO 0

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   ! MAIN PROCESSOR TEST

PROGRAM MAINPROCESSOR   
   DPY-#   
   DPY-TESTING FOR LATEST ROM REVISION   
   WRITE @ 300000 = 0   
   WRITE @ 303FFF = 11
   
WAIT:   
   READ @ REGF   
   IF REGE = B0 GOTO WAIT   
   
   READ @ F0300D   
   IF REGE = 58 GOTO NEXTBYTE
   GOTO BADROM
   
NEXTBYTE:
   READ @ F0300C   
   IF REGE = 3A GOTO GOODROM   
   GOTO BADROM
   
BADROM:
   DPY-#ROM CHECKSUM ERROR OR OLD REV   
   STOP   
   GOTO MAINEND
   
GOODROM:
   DPY-#ROM CHECKSUM OK   
   EX DELAY   
   GOTO MAINEND
   
MAINEND:

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   ! MOTION PROCESSOR TEST

PROGRAM MOTION
   DPY-#   
   DPY-WHAT ROM DO YOU HAVE   
   EX DELAY
SPEEDLOOP:   
   DPY-0=NORMAL  1=SPEED UP \1   
   IF REG1=0 GOTO NORMALTEST   
   IF REG1=1 GOTO SPEEDTEST   
   IF REG1>1 GOTO SPEEDLOOP
 
NORMALTEST:
   EX NORMAL   
   GOTO TESTEND
SPEEDTEST:   
   EX SPEED   
   GOTO TESTEND
TESTEND:

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!      
   !ROM TEST FOR NORMAL SPEED
   
PROGRAM NORMAL

DPY-TESTING NORMAL SPEED ROM
ROM @ 0-0FFF SIG F241

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   !ROM TEST FOR SPEED UP ROM
   
PROGRAM SPEED

DPY-TESTING SPEED UP ROM
ROM @ 0-0FFF SIG 7E69

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   ! SOUND PROCESSOR TEST
   
PROGRAM SOUND

DPY-TESTING SOUND PROCESSOR ROM
ROM @ 0-0FFF SIG B2BF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! RAM 1K TEST
   
PROGRAM RAM1KTEST

   WRITE @ 208000 = 0   
   WRITE @ 2087FF = 11
   
WAIT:
   READ @ REGF   
   IF REGE = B0 GOTO WAIT   
   IF REGE = B1 GOTO WAIT   
   IF REGE = B2 GOTO WAIT   

   IF REGE = C0 GOTO RAM1KOK   
   GOTO RAM1KBAD
   
RAM1KOK:
   DPY-#RAM 1K TESTS OK   
   EX DELAY   
   GOTO RAM1KEND
   
RAM1KBAD:   
   RAM LONG @ 8000 - 87FF
RAM1KEND:
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! RAM 3EF TEST
   
PROGRAM RAM3EFTEST   
   WRITE @ 208800 = 0   
   WRITE @ 208BFF = 11

WAIT:
   READ @ REGF   
   IF REGE = B0 GOTO WAIT   
   IF REGE = B1 GOTO WAIT   
   IF REGE = B2 GOTO WAIT   
   
   IF REGE = C0 GOTO RAM3EFOK   
   GOTO RAM3EFBAD
   
RAM3EFOK:
   DPY-#RAMS 3E AND 3F OK   
   EX DELAY   
   GOTO RAM3EFEND
   
RAM3EFBAD:
   RAM LONG @ 8800 - 8BFF
RAM3EFEND:

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! RAM 3KL TEST
   
PROGRAM RAM3KLTEST
   WRITE @ 209000 = 0   
   WRITE @ 2093FF = 11
   
WAIT:
   READ @ REGF   
   IF REGE = B0 GOTO WAIT   
   IF REGE = B1 GOTO WAIT   
   IF REGE = B2 GOTO WAIT
      
   IF REGE = C0 GOTO RAM3KLOK   
   GOTO RAM3KLBAD
   
RAM3KLOK:
   DPY-#RAM 3K AND 3L OK   
   EX DELAY   
   GOTO RAM3KLEND
   
RAM3KLBAD:   
   RAM LONG @ 9000 - 93FF
RAM3KLEND:

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   ! RAM 3HJ TEST
   
PROGRAM RAM3HJTEST

    WRITE @ 209800 = 0   
    WRITE @ 209BFF = 11

WAIT:
   READ @ REGF   
   IF REGE = B0 GOTO WAIT   
   IF REGE = B1 GOTO WAIT   
   IF REGE = B2 GOTO WAIT   

   IF REGE = C0 GOTO RAM3HJOK   
   GOTO RAM3HJBAD
   
RAM3HJOK:
   DPY-#RAM 3H AND 3J OK   
   EX DELAY   
   GOTO RAM3HJEND
   
RAM3HJBAD:
   RAM LONG @ 9800 - 9BFF
RAM3HJEND:
