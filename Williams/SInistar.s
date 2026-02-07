! Shared under the MIT License
! David Shoemaker
! Letsplaycafe@outlook.com
! Copyright 2026

! Script for Sinistar by Williams V 0.2

INCLUDE "6809E.POD"

SETUP   
   TRAP ACTIVE FORCE LINE NO   
   TRAP ACTIVE INTERRUPT NO

ADDRESS SPACE INFORMATION
   !ROM_LOAD( "sinistar_rom_1-b_16-3004-53.1d",  0x00000, 0x1000, CRC(f6f3a22c) SHA1(026d8cab07734fa294a5645edbe65a904bcbc302) )
	!ROM_LOAD( "sinistar_rom_2-b_16-3004-54.1c",  0x01000, 0x1000, CRC(cab3185c) SHA1(423d1e3b0c07333ec582529bc4d0b7baf591820a) )
	!ROM_LOAD( "sinistar_rom_3-b_16-3004-55.1a",  0x02000, 0x1000, CRC(1ce1b3cc) SHA1(5bc03d7249529d827dc60c087e074ab3e4ea7361) )
	!ROM_LOAD( "sinistar_rom_4-b_16-3004-56.2d",  0x03000, 0x1000, CRC(6da632ba) SHA1(72c0c3d5a5ca87ca4d95fcedaf834206e4633950) )
	!ROM_LOAD( "sinistar_rom_5-b_16-3004-57.2c",  0x04000, 0x1000, CRC(b662e8fc) SHA1(828a89d2ea13d8a362dae708f86bff54cb231887) )
	!ROM_LOAD( "sinistar_rom_6-b_16-3004-58.2a",  0x05000, 0x1000, CRC(2306183d) SHA1(703e29e6446856615760a4897c0f5d79cc7bdfb2) )
	!ROM_LOAD( "sinistar_rom_7-b_16-3004-59.3d",  0x06000, 0x1000, CRC(e5dd918e) SHA1(bf4e2ada6a59d246218544d822ba5355da925924) )
	!ROM_LOAD( "sinistar_rom_8-b_16-3004-60.3c",  0x07000, 0x1000, CRC(4785a787) SHA1(8c7eca656b2c23b0da41a8c7ce51a2735cab85a4) )
	!ROM_LOAD( "sinistar_rom_9-b_16-3004-61.3a",  0x08000, 0x1000, CRC(50cb63ad) SHA1(96e28e4fef98fff2649741a266fa590e0313e3b0) )
	!ROM_LOAD( "sinistar_rom_10-b_16-3004-62.4c", 0x0e000, 0x1000, CRC(3d670417) SHA1(81802622bee8dbea5c0f08019d87d941dcdbe292) )
	!ROM_LOAD( "sinistar_rom_11-b_16-3004-63.4a", 0x0f000, 0x1000, CRC(3162bc50) SHA1(2f38e572ab9c731e38dfe9bad3cc8222a775c5ea) )

!ROM access is controlled by doing a write to C900
! Write 0x00 to select CPU RAMs
! Write 0x01 to select Rom board ROMs 0000-8FFF

ROM @ 0000-0FFF	SIG	B850 !Sinistar.1D
ROM @ 1000-1FFF	SIG	D06F !Sinistar.1C
ROM @ 2000-2FFF	SIG	0316 !Sinistar.1A
ROM @ 3000-3FFF	SIG	A20F !Sinistar.2D
ROM @ 4000-4FFF	SIG	C4AA !Sinistar.2C
ROM @ 5000-5FFF	SIG	C4B9 !Sinistar.2A
ROM @ 6000-6FFF	SIG	F539 !Sinistar.3D
ROM @ 7000-7FFF	SIG	2B1C !Sinistar.3C
ROM @ 8000-8FFF	SIG	906D !Sinistar.3A

!Main roms, address space constant
! NOT bank switched
ROM @ E000-EFFF	SIG	C006 !Sinistar.4C
ROM @ F000-FFFF	SIG	40D1 !Sinistar.4A

! Ram on ROM board, only on Sinistar
! NOT bank selected
RAM D000-D7FF ! 6116 static ram @ 4D
RAM D800-DFFF ! 6116 static ram @ 6D


!Proms on main board, not CPU readable
!ROM @ 0000-01FF	SIG 5702 !	decoder.4
!ROM @ 0200-03FF	SIG B999 !	decoder.6

!ram on CPU board
! (0xC900=00 to read all ram)
RAM 0000-3FFF ! column 1
RAM 4000-7FFF ! column 2
RAM 8000-BFFF ! column 3

!RAM CC00-CFFF !NV Ram 5101 

! 7 segment display controlled by 6821 on rom board
! Write C804

! Inputs controlled by reading 6821 on Interface board
! Read C80C

! ROM_ENABLE ADDRESS 0xC900:D0 1 = read rom, 0 means read ram
! Screen buffer is 0x0000-0x97FF (overlap rom)

program Main
   DPY-SINISTAR Test
   EX DELAY
   stop
   goto mainloop

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

    DPY Rom board 6116 @ 4D
    RAM SHORT D000-D7FF

    DPY Rom board 6116 @ 6D
    RAM SHORT D800-DFFF


    DPY Ram test done
    stop
    goto MAINLOOP

RomTest:
    DPY Rom TESTS
    ex DELAY

   DPY Fixed rom E000 4C
   ROM @ E000-EFFF	SIG	C006 !Sinistar.4C
   DPY Fixed rom F000 4A
   ROM @ F000-FFFF	SIG	40D1 !Sinistar.4A

   DPY Banked roms
   ex SelectRom

   DPY Banked rom 0000 1D
   ROM @ 0000-0FFF	SIG	B850 !Sinistar.1D

   DPY Banked rom 1000 1C
   ROM @ 1000-1FFF	SIG	D06F !Sinistar.1C

   DPY Banked rom 2000 1A
   ROM @ 2000-2FFF	SIG	0316 !Sinistar.1A

   DPY Banked rom 3000 2D
   ROM @ 3000-3FFF	SIG	A20F !Sinistar.2D

   DPY Banked rom 4000 2c
   ROM @ 4000-4FFF	SIG	C4AA !Sinistar.2C

   DPY Banked rom 5000 2A
   ROM @ 5000-5FFF	SIG	C4B9 !Sinistar.2A

   DPY Banked rom 6000 3D
   ROM @ 6000-6FFF	SIG	F539 !Sinistar.3D

   DPY Banked rom 7000 3C
   ROM @ 7000-7FFF	SIG	2B1C !Sinistar.3C

   DPY Banked rom 8000 3A
   ROM @ 8000-8FFF	SIG	906D !Sinistar.3A

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

