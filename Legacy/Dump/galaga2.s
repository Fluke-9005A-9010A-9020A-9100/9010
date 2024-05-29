!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Bally-Midway Galaga Test Routine
! Works in all three processor sockets
! Modified for use with normal (not QT) Z80 pod and different rom signatures
! and user prompts
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! Testing Notes:
!	1. For testing CPU 2 or 3, start the script with EXEC YES immediately
!        on powerup or the main CPU 1 will be running and will upset the
!        ram tests as it is writing to the rams.
!        Even with that there may still be some false ram errors shown,
!        (what's best to stop the main CPU 1 ? pull it out?)
!
!
!
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
INCLUDE "Z80.POD"

SETUP

   TRAP ACTIVE FORCE LINE NO
   TRAP ACTIVE INTERRUPT NO

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! MAIN TEST ROUTINE
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM MAIN
   DPY-#
   DPY-GALAGA TEST SCRIPT REV2
   EX DELAY
   DPY-#
   DPY-SILENCING SOUND 6800-681F=0
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

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! COMMON tests done after approprate CPU rom test done
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
COMMON:
   DPY-#RAM TESTS
   EX DELAY

   EX   RAM1KTEST
   EX   RAM3EFTEST
   EX   RAM3KLTEST
   EX   RAM3HJTEST

   DPY-#ALL RAM TESTS COMPLETE
   EX DELAY
DIPTESTPROMPT:
   DPY-#
   DPY-TEST DIP SWITCHES? 0=NO 1=YES \1
   IF REG1 > 1 GOTO DIPTESTPROMPT
   IF REG1 = 0 GOTO DIPTESTSKIP
   IF REG1 = 1 GOTO DIPTESTEXECUTE
DIPTESTEXECUTE:
   EX DIPSWITCHTEST
DIPTESTSKIP:
   EX DELAY
   DPY-ATTEMPTING TO RUN TARGET CPU
   RUN UUT
   EX DELAY
   DPY-TEST SCRIPT COMPLETED


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! DIPSWITCH tests
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM DIPSWITCHTEST
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
   IF REGF >6807 GOTO DIPTESTEND
   GOTO SWITCHLOOP

SW6KON:
   DPY-#
   DPY-6K NUMBER $2 ON
   STOP
   GOTO NEXTSW

SW6JON:
   IF REGF=6807 GOTO DIPTESTEND
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
   IF REGF=6807 GOTO DIPTESTEND
   DPY-#
   DPY-6J NUMBER $2 OFF
   STOP
   GOTO ADDTEST
DIPTESTEND:
   DPY-#
   DPY-DIP SWITCHES TEST COMPLETE

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!DELAY ROUTINE
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM DELAY
   REG1=40
0:
   DEC REG1
   IF REG1 >0 GOTO 0

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! MAIN PROCESSOR TEST
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM MAINPROCESSOR

   DPY-#
   DPY-TESTING MAIN CPU 4M ROMS1-4
   EX DELAY
   DPY-#

   DPY-ROM1 AT 0000-0FFF
      ROM @ 0000-0FFF SIG 9E7B
   DPY-ROM2 AT 1000-1FFF
      ROM @ 1000-1FFF SIG 7590
   DPY-ROM3 AT 2000-2FFF
      ROM @ 2000-2FFF SIG F663
   DPY-ROM4 AT 3000-3FFF
      ROM @ 3000-3FFF SIG 9B5D
   
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! MOTION PROCESSOR TEST
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM MOTION

   DPY-#
   DPY-TESTING MOTION CPU 4J ROM5
   EX DELAY

   DPY-ROM1 AT 0000-0FFF
      ROM @ 0000-0FFF SIG 7EF7

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! SOUND PROCESSOR TEST
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM SOUND

   DPY-#
   DPY-TESTING SOUND CPU 4E ROM7
   EX DELAY

      ROM @ 0-0FFF SIG 2E38

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! RAM 1K TEST
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM RAM1KTEST

   DPY-#
   DPY-TESTING RAM 1K

   RAM SHORT @ 8000 - 87FF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! RAM 3EF TEST
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM RAM3EFTEST

   DPY-#
   DPY-TESTING RAM 3E AND 3F

   RAM SHORT @ 8800 - 8BFF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! RAM 3KL TEST
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM RAM3KLTEST

   DPY-#
   DPY-TESTING RAM 3K AND 3L

   RAM SHORT @ 9000 - 93FF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! RAM 3HJ TEST
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM RAM3HJTEST

   DPY-#
   DPY-TESTING RAM 3H AND 3J

   RAM SHORT @ 9800 - 9BFF



!****************************************************************************
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Reference information from galaga.c mame source code (with comments
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!/***************************************************************************
!
!Galaga memory map (preliminary)
!
!CPU #1:                //main cpu
!0000-3fff ROM		//ROM1>0000-0FFF ROM2>1000-1FFF ROM3>2000-2FFF ROM4>3000-3FFF 
!CPU #2:			//motion cpu
!0000-1fff ROM		//ROM1>0000-0FFF 
!CPU #3:			//sound cpu
!0000-1fff ROM		//ROM1>0000-0FFF 
!ALL CPUS:
!8000-83ff Video RAM
!8400-87ff Color RAM
!8b80-8bff sprite code/color
!9380-93ff sprite position
!9b80-9bff sprite control
!8800-9fff RAM
!
!read:
!6800-6807 dip switches (only bits 0 and 1 are used - bit 0 is DSW1, bit 1 is DSW2)
!	  dsw1:
!	    bit 6-7 lives
!	    bit 3-5 bonus
!	    bit 0-2 coins per play
!		  dsw2: (bootleg version, the original version is slightly different)
!		    bit 7 cocktail/upright (1 = upright)
!	    bit 6 ?
!	    bit 5 RACK TEST
!	    bit 4 pause (0 = paused, 1 = not paused)
!	    bit 3 ?
!	    bit 2 ?
!	    bit 0-1 difficulty
!7000-     custom IO chip return values
!7100      custom IO chip status ($10 = command executed)
!
!write:
!6805      sound voice 1 waveform (nibble)
!6811-6813 sound voice 1 frequency (nibble)
!6815      sound voice 1 volume (nibble)
!680a      sound voice 2 waveform (nibble)
!6816-6818 sound voice 2 frequency (nibble)
!681a      sound voice 2 volume (nibble)
!680f      sound voice 3 waveform (nibble)
!681b-681d sound voice 3 frequency (nibble)
!681f      sound voice 3 volume (nibble)
!6820      cpu #1 irq acknowledge/enable
!6821      cpu #2 irq acknowledge/enable
!6822      cpu #3 nmi acknowledge/enable
!6823      if 0, halt CPU #2 and #3
!6830      Watchdog reset?
!7000-     custom IO chip parameters
!7100      custom IO chip command (see machine/galaga.c for more details)
!a000-a001 starfield scroll speed (only bit 0 is significant)
!a002      starfield scroll direction (0 = backwards) (only bit 0 is significant)
!a003-a004 starfield blink
!a005      starfield enable
!a007      flip screen
!
!Interrupts:
!CPU #1 IRQ mode 1
!       NMI is triggered by the custom IO chip to signal the CPU to read/write
!	       parameters
!CPU #2 IRQ mode 1
!CPU #3 NMI (@120Hz)
!
!***************************************************************************/


