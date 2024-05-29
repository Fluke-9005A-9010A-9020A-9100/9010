! Use this version, last edited Feb 18, 2002
! Bally-Midway Pacman(MS) Routine

INCLUDE "Z80.POD"

SETUP   

   TRAP ACTIVE FORCE LINE NO   
   TRAP ACTIVE INTERRUPT NO

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

PROGRAM MAIN

DOTS:
   REGE = 10
   DPY-PUTS A YELLOW DOT IN EACH CORNER

   WRITE @4040 = REGE
   WRITE @405F = REGE
   WRITE @43A0 = REGE
   WRITE @43BF = REGE

INC REGE

IF REGE = 17 GOTO DOTS

   
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   ! MAIN TEST ROUTINE

   DPY-#
   DPY-BUS TEST   
   EX DELAY   
   BUS TEST   
   DPY-#       
   DPY-WHICH GAME ARE YOU TESTING?
   EX DELAY

MAINLOOP:
   DPY-0 PACMAN, 1 MS, 2 CLONE MS \1
   EX DELAY

   IF REG1 > 2 GOTO MAINLOOP   
   IF REG1 = 0 GOTO PACTEST
   IF REG1 = 1 GOTO MSTEST   
   IF REG1 = 2 GOTO CLONETEST

PACTEST:   

   EX PACMANROM   
   GOTO COMMON

MSTEST:   
   EX MSROM   
   GOTO COMMON

CLONETEST:
   EX CLONEROM  
   GOTO COMMON
   
COMMON:   
   DPY-#RAM TESTS   
   EX DELAY   
   
   DPY-#TESTING RAM AT 4K AND 4N  
   EX  RAM4KNTEST   
   
   DPY-#TESTING RAM AT 4L AND 4P   
   EX   RAM4LPTEST   
   
   DPY-#TESTING RAM AT 4M AND 4R    
   EX   RAM4MRTEST   
   
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
   ! PACMAN ROM TEST

PROGRAM PACMANROM   
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
   DPY-TESTING 6E ROM
   ROM @ 0-0FFF SIG 8B1A 
   DPY-TESTING 6F ROM
   ROM @ 1000-1FFF SIG 8859
   DPY-TESTING 6H ROM
   ROM @ 2000-2FFF SIG 1934
   DPY-TESTING 6J ROM
   ROM @ 3000-3FFF SIG 0A4B 
   GOTO MAINEND
   
GOODROM:
   DPY-#ROM CHECKSUM OK   
   EX DELAY   
   GOTO MAINEND
   
MAINEND:

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
   ! MS PACMAN ROM TEST

PROGRAM MSROM
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
   ! CLONE ROM TEST  Regular Speed
   
PROGRAM CLONEROM

DPY-TESTING PROCESSOR ROM
ROM @ 0-3FFF SIG DB91
DPY-TESTING 7H/J ROM
ROM @ 8000-8FFF SIG 7DE1
DPY-TESTING 7K-2716 ROM
ROM @ 9000-97FF SIG 862A
DPY-TESTING 7K-2732 ROM
ROM @ 9000-9FFF SIG 06B5

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! RAM 4K & 4N TEST
   
PROGRAM RAM4KNTEST

   WRITE @ 204000 = 0    !Quick Ram Test start  
   WRITE @ 2043FF = 11   !Quick Ram Test finish address increment by 1
   
WAIT:
   READ @ REGF   
   IF REGE = B0 GOTO WAIT  !QRam busy w/ read/write tests
   IF REGE = B1 GOTO WAIT  !QRam busy w/ address decoding checks
   IF REGE = B2 GOTO WAIT  !QRam busy w/ ????

   IF REGE = C0 GOTO RAM4KNOK   !Qram says everyting OK!
   DPY-#RAMS 4K-0X OR 4N-X0 PROBLEM
   GOTO RAM4KNBAD
   
RAM4KNOK:
   DPY-#RAM 4K AND 4N TEST OK   
   EX DELAY   
   GOTO RAM4KNEND
   
RAM4KNBAD:   
   RAM LONG @ 4000 - 43FF
RAM4KNEND:
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! RAM 4L & 4P TEST
   
PROGRAM RAM4LPTEST   
   WRITE @ 204400 = 0   !QRam start
   WRITE @ 2047FF = 11  !Qram stop, inc. add. by 1

WAIT:
   READ @ REGF   
   IF REGE = B0 GOTO WAIT   
   IF REGE = B1 GOTO WAIT   
   IF REGE = B2 GOTO WAIT   
   
   IF REGE = C0 GOTO RAM4LPOK   
   DPY-#RAMS 4L-0X  4P-X0 PROBLEM
   GOTO RAM4LPBAD
   
RAM4LPOK:
   DPY-#RAMS 4L AND 4P OK   
   EX DELAY   
   GOTO RAM4LPEND
   
RAM4LPBAD:
   RAM LONG @ 4400 - 47FF
RAM4LPEND:

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! RAM 4M & 4R TEST
   
PROGRAM RAM4MRTEST
   WRITE @ 204C00 = 0   
   WRITE @ 204FFF = 11
   
WAIT:
   READ @ REGF   
   IF REGE = B0 GOTO WAIT   
   IF REGE = B1 GOTO WAIT   
   IF REGE = B2 GOTO WAIT
      
   IF REGE = C0 GOTO RAM4MROK   
   DPY-#RAMS 4M-0X 4R-X0 PROBLEM
   GOTO RAM4MRBAD
   
RAM4MROK:
   DPY-#RAM 4M AND 4R OK   
   EX DELAY   
   GOTO RAM4MREND
   
RAM4MRBAD:   
   RAM LONG @ 4C00 - 4FFF
RAM4MREND:

