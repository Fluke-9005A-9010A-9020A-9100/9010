! Shared under the MIT License
! David Shoemaker
! Letsplaycafe@outlook.com
! Copyright 2024

INCLUDE "6809E.POD"

SETUP   

   TRAP ACTIVE FORCE LINE NO   
   TRAP ACTIVE INTERRUPT NO

ADDRESS SPACE INFORMATION

!Main roms, address space constant
ROM @ D000-D7FF	SIG	2541 !defend.1
ROM @ D800-DFFF	SIG	BFB7 !defend.4
ROM @ E000-EFFF	SIG	E7CE !defend.2
ROM @ F000-FFFF	SIG	2013 !defend.3

!Rom banks show up at C000-CFFF if selected (ALSO C900=01 to read rom)
!Requires bank switch d000=01
!ROM @ C000-C7FF	SIG	16B9 !defend.9
!ROM @ C800-CFFF	SIG	4404 !defend.12

!Requires bank switch d000=02
!ROM @ C000-C7FF	SIG	FF14 !defend.8
!ROM @ C800-CFFF	SIG	0B40 !defend.11

!Requires bank switch d000=03
!ROM @ C000-C7FF	SIG	ADEA !defend.7
!ROM @ C800-CFFF	SIG	A534 !defend.10

!Requires bank switch d000=07
! Rom 5 is not loaded on this game
!ROM @ C000-C7FF	SIG	6B52 !defend.6

!Proms
!ROM @ 0000-01FF	SIG 5428 !	decoder.2
!ROM @ 0200-03FF	SIG 687A !	decoder.3

!ram
!RAM CC00-CFFF !NV Ram 5101
RAM 0000-3FFF ! column 1
RAM 4000-7FFF ! column 2
RAM 8000-BFFF ! column 3

!Video ram ( 0xC900=00 to read all ram)
!RAM 0000-97FF

! ROM_ENABLE ADDRESS 0xC900:D0 1 = read rom, 0 means read ram
! Screen buffer is 0x0000-0x97FF (overlap rom)

program Main
   DPY-#       

MAINLOOP:
   DPY-Ram Test 0, Rom Test 1 \1
   EX DELAY

   IF REG1 = 0 GOTO RamTest
   IF REG1 = 1 GOTO RomTest
goto mainloop

RamTest:
    EX SelectRam

    DPY Ram Col 1
    RAM SHORT 0000-3FFF

    DPY Ram col 2
    RAM short 4000-7FFF

    DPY ram col 3
    RAM short 8000-BFFF

    DPY NVRAM 
    !RAM SHORT C400-C4FF

    DPY Color Ram
    !ram short C000-C00F

    DPY Ram test done
    stop
    goto MAINLOOP

RomTest:
    DPY Rom TESTS
    ex DELAY

    DPY MainRoms. 1
    ROM @ D000-D7FF	SIG	2541 !defend.1
    DPY + 4
    ROM @ D800-DFFF	SIG	BFB7 !defend.4
    DPY + 2
    ROM @ E000-EFFF	SIG	E7CE !defend.2
    DPY + 3
    ROM @ F000-FFFF	SIG	2013 !defend.3

    !Rom banks show up at C000-CFFF if selected (ALSO C900=01 to read rom)
    EX SelectRom

    DPY Rom bank 1. 9
    EX Bank1
    !Requires bank switch d000=01
    ROM @ C000-C7FF	SIG	16B9 !defend.9

    DPY + 12
    ROM @ C800-CFFF	SIG	4404 !defend.12

    DPY Rom bank 2. 8
    EX Bank2
    !Requires bank switch d000=02
    ROM @ C000-C7FF	SIG	FF14 !defend.8
    DPY + 11
    ROM @ C800-CFFF	SIG	0B40 !defend.11

    DPY Rom bank 3. 7
    !Requires bank switch d000=03
    EX Bank3
    ROM @ C000-C7FF	SIG	ADEA !defend.7
    DPY + 10
    ROM @ C800-CFFF	SIG	A534 !defend.10

    DPY Rom bank 4. 6
    !Requires bank switch d000=07
    ! Rom 5 is not loaded on this game
    EX Bank4
    ROM @ C000-C7FF	SIG	6B52 !defend.6

    DPY Rom Test done
    stop
    goto MAINLOOP



program SelectRom
write @C900= 01

program SelectRam
write @C900= 00

!select rom & Io into shared memory area
program Bankio
write @d000=00

program Bank1
write @d000=01

program Bank2
write @d000=02

program Bank3
write @d000=03

program Bank4
write @d000=07

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   !DELAY ROUTINE
   
PROGRAM DELAY
REG1=40
0:
DEC REG1
IF REG1 >0 GOTO 0

