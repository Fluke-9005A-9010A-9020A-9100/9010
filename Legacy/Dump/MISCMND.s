! MISSILE COMMAND Test Routine
! Use 6502 in CPU processor socket
! Program created by Mowerman@erols.com
! Program written on 5/9/02
! Revision Date 5/9/02
! Revision number 0

SETUP

   TRAP ACTIVE FORCE LINE NO
   TRAP ACTIVE INTERRUPT NO

PROGRAM MAIN
   DPY-MISSILE COMMAND TEST
   DPY-+-PRESS CONT
   STOP

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! MAIN LOOP ROUTINE

! Proposed standard
! 1 = RAM Test
! 2 = ROM Test
! 3 = SND Test
! 4 = I/O Test
! 5 = DIP Test
! 6 = PROBE Test
! 0 = Run UUT
!
! Register 1 is used for keyboard input for selection
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

MAINLOOP:

   DPY- 1-RAM 2-ROM 3-SND 4-IO 5-DIP\1
   IF REG1 = 1 GOTO RAMTEST
   IF REG1 = 2 GOTO ROMTEST
   IF REG1 = 3 GOTO SNDTEST
   IF REG1 = 4 GOTO IOTEST
   IF REG1 = 5 GOTO DIPTEST
   IF REG1 = 6 GOTO PRBTEST
   IF REG1 = 9 GOTO RTEST
   GOTO MAINLOOP

RAMTEST:
     EXECUTE TSTRAM
     GOTO MAINLOOP
ROMTEST:
     EXECUTE TSTROM
     GOTO MAINLOOP
SNDTEST:
     EXECUTE TSTSND
     GOTO MAINLOOP
IOTEST:
     EXECUTE TSTIO
     GOTO MAINLOOP
DIPTEST:
     EXECUTE DIPTST
     GOTO MAINLOOP
PRBTEST:
     EXECUTE TSTPRB
     GOTO MAINLOOP
RTEST:
     EXECUTE TSTRUN
     GOTO MAINLOOP

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      RAM TEST
!
! Display each (set) of RAMs as testing many Rams are 4 bit wide such as
! the common 2114s.
!
! RAM SHORT @ *RAMSTART1 - *RAMLENGTH1
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

PROGRAM TSTRAM
   DPY-TESTING PGM RAM R3 M3#
   RAM SHORT @ 0-3FF
   DPY-TESTING RAM
   RAM SHORT @ 400-7FF
   DPY-TESTING RAM 2
   RAM SHORT @ 800-BFF
   DPY-TESTING RAM 3
   RAM SHORT @ C00-FFF
   DPY- RAM TEST COMPLETE PRESS CONT#
   STOP


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      ROM TEST
!
! Promt for version of ROM (if needed).  Response goes into REG1.
! REG1 used for GOTO jump to corresponding LABEL for proper test.
!
! Rom Test is done by removeable roms rather than blocks of memory this
! helps pinpoint the bad rom to replace.
!
! ROM TEST @ *ROMSTART1 - *ROMEND1 SIG *ROMSIG1
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

PROGRAM TSTROM

0: LABEL 0
   DPY-ROM VERSION 1 OR 2 ? /1
   IF REG1 = 1 GOTO 1
   IF REG1 = 2 GOTO 4
   GOTO 0
1: LABEL 1
! MISSLE COMMAND 8316/2716 ROMS VERSION -01
   DPY-TESTING ROM H1
   ROM TEST @ 5000-57FF SIG 3A1F
   DPY-TESTING ROM J//K1
   ROM TEST @ 5800-5FFF SIG FE9F
   DPY-TESTING ROM K//L1
   ROM TEST @ 6000-67FF SIG DAE6
   DPY-TESTING ROM L//M1
   ROM TEST @ 6800-6FFF SIG AE3F
   DPY-TESTING ROM N//P1
   ROM TEST @ 7000-77FF SIG AB6A
   DPY-TESTING ROM R1
   ROM TEST @ 7800-7FFF SIG 293D

   GOTO F
4: LABEL 4                             ! Super Missile Attack from Alex Yeckley

   DPY-TESTING ROM H1
   ROM TEST @ 5000-57FF SIG 29E4
   DPY-TESTING ROM J//K1
   ROM TEST @ 5800-5FFF SIG 6BEC
   DPY-TESTING ROM K//L1
   ROM TEST @ 6000-67FF SIG 7CF2
   DPY-TESTING ROM L//M1
   ROM TEST @ 6800-6FFF SIG 365E
   DPY-TESTING ROM N//P1
   ROM TEST @ 7000-77FF SIG 14A9
   DPY-TESTING ROM R1
   ROM TEST @ 7800-7FFF SIG 4974
   DPY-TESTING ROM
   ROM TEST @ 8000-87FF SIG 4974
   DPY-TESTING ROM
   ROM TEST @ 8800-8FFF SIG 72E9

F: LABEL F
   DPY-ROM TEST COMPLETE
   STOP

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      SND TEST
!
! Sound test very dependant on game.  Some games will have a separate sound
! processor & some may be directly accessible from the main processor.
! This test is for directly accessible sound generators.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

PROGRAM TSTSND



DPY-POKEY #1 4-CHANNELS
   STOP
   DPY-1 CHAN 1
   WRITE @ 400F = 00
   WRITE @ 400F = 03
   WRITE @ 4000 = 55
   WRITE @ 4001 = AF
   STOP

   DPY-1 CHAN 2
   WRITE @ 4001 = 00
   WRITE @ 4002 = 45
   WRITE @ 4003 = AF
   STOP
   
   DPY-1 CHAN 3
   WRITE @ 4003 = 00
   WRITE @ 4004 = 35
   WRITE @ 4005 = AF
   STOP
   
   DPY-1 CHAN 4
   WRITE @ 4005 = 00
   WRITE @ 4006 = 25
   WRITE @ 4007 = AF
   STOP
   WRITE @ 4007 = 00
   STOP

F: LABEL F
   DPY-SND TESTS COMPLETE. PRESS
   DPY-+ CONT%1#
   STOP


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      I/O TEST
!
! This test may be configured to test all individual inputs one at a time or
! may just be configured to display the bytewide register of inputs.  By
! looking at bytewide inputs for Normally Open momentary inputs (buttons /
! joysticks, coins etc) you can verify none are stuck on.
!
! READ @ *IO1
! REGE is contents of previous 9010A command, so display them.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

PROGRAM TSTIO

   READ @ *IO1
   DPY-IO2 = $E PRESS CONT
   STOP

   DPY-TESTING POKEY
1: LABEL 1
   WRITE @ 400F = 3                     ! SKCTL bits 0,1 <> 0
   READ @ 400A
   REG1 = REGE
   READ @ 400A
   IF REGE=REG1 GOTO 2
   GOTO 3
2: LABEL 2
   DPY-POKEY NUMBER NOT RANDOM
   STOP
3: LABEL 3

! WRITE FF @ 4800                    Test LEDS, COUNTERS, SCREEN FLIP
! READ @ 4900                        INPUT SWITCHES

   DPY-IO TESTS COMPLETE. PRESS
   DPY-+ CONT%1#
   STOP 


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      DIP SWITCH TEST
!
! The DIP Test is 3 stages, a All on test, All off test, Factory settings
!
! Set REGF = *DIP1 location
! REGE is contents of previous 9010A command, so use it.
! 
! I could not get it to compare to REGE so I used REG1 = REGE and then
! compared to REG1.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

PROGRAM DIPTST

REGF = 4008

SW1ON:
   DPY- TURN ALL DIPS ON AT R8 #
   STOP
   READ @ REGF
   REG1 = REGE
   IF REG1 = FF GOTO SW1OFF
   DPY- ERROR R8 OFF PRESS CONT # 
   STOP
   GOTO SW1ON
SW1OFF:   
   DPY- TURN ALL DIPS OFF AT R8 #
   STOP
   READ @REGF
   REG1 = REGE
   IF REG1 = 0 GOTO SW1FACTORY 
   DPY- ERROR R8 ON PRESS CONT #
   STOP
   GOTO SW1OFF
SW1FACTORY:
   DPY- FACT SET SW1 00000001 #
   STOP
   READ @REGF
   REG1 = REGE
   IF REG1 = 80 GOTO SW2
   DPY- ERROR R8 FACT PRESS CONT #
   STOP
   GOTO SW1FACTORY
 
SW2:

REGF = 4A00

SW2ON:
   DPY- TURN ALL DIPS ON AT R10 #
   STOP
   READ @ REGF
   REG1 = REGE
   IF REG1 = FF GOTO SW2OFF
   DPY- ERROR R10 OFF PRESS CONT # 
   STOP
   GOTO SW2ON
SW2OFF:   
   DPY- TURN ALL DIPS OFF AT R10 #
   STOP
   READ @REGF
   REG1 = REGE
   IF REG1 = 0 GOTO SW2FACTORY 
   DPY- ERROR SW1 ON PRESS CONT #
   STOP
   GOTO SW2OFF
SW2FACTORY:
   DPY- FACT SET R10 00000001 #
   STOP
   READ @REGF
   REG1 = REGE
   IF REG1 = 80 GOTO SW3
   DPY- ERROR SW1 FACT PRESS CONT #
   STOP
   GOTO SW2FACTORY

SW3:

  DPY-DIP TEST COMPLETE. PRESS
  DPY-+ CONT%1#
  STOP



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      PROBE TEST
!
! Copied from Asteroids Test by *Sorry I don't have his name at the moment
! 
! The probe test is designed to excercise given signals on the board, such
! as flip, enable, select etc to aid in finding faults.
!
! I'm not real clear on the implementation here, basically I belive the
! program does a set number of writes to trigger a signal & the probe counts
! to see if it recieves all of the triggered signals.  I have noticed that
! it is possible to see the 'wrong' signal & thus get a false positive test.
!
! REG9 = *ProbeLocation1
! REGB = *Number of Triggers excercised
! REG0 = Number of triggers read by probe
!
! Improvement or use of Signatures here should be investigated.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

PROGRAM TSTPRB

   SYNC ADDRESS
   DPY-PLACE PROBE ON POINTS
   DPY-+ SHOWN.#
   STOP
   DPY-FLIP 5J-6.#
   STOP
   REGB = 1
   REG9 = 7D82
   REGB = 40
   EXECUTE PROGRAM 65
   STOP

PROGRAM 65   116 BYTES

   READ PROBE
   REG1 = REGB
1: LABEL 1
   IF REG8 = 0 GOTO 2
   READ @ REG9
   GOTO 3
2: LABEL 2
   WRITE @ REG9 = REGA
3: LABEL 3
   DEC REG1
   IF REG1 > 0 GOTO 1
   READ PROBE
   REG0 = REG0 AND 7F
   IF REG0 = REGB GOTO 4
   DPY-+CNT BAD.
   GOTO 5
4: LABEL 4
   DPY-+ OK. 
5: LABEL 5
   DPY-+COUNT @0=@B#
   STOP


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      RUN UUT TEST
!
! Simply runs Unit Under Test in operating mode
! May require a pointer, but watchdog/reset feature of board should start
! the board correctly
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

PROGRAM TSTRUN

   DPY-RUNNING BOARD
   RUN UUT
   STOP

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      DELAY
!
! Simply runs a 1 second Delay. 
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


PROGRAM DELAY
    REG1=40  0:
    DEC REG1
    IF REG1 >0 GOTO 0

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!      R1POKEY
!
! Reads 1 Pokey, ALLPOT format read for Digital inputs. 
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

PROGRAM R1POKEY
    WRITE @ 400F = 00               ! Place POKEY in SLOW scan mode
    WRITE @ 400B = 01               ! Init POKEY POTGO register
    READ @ 4008                     ! Read POKEY ALLPOT register
