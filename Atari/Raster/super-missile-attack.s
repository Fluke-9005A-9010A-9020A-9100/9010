! Shared under the MIT License
! kralleman @ KLOV
! Copyright 2024

!! This is just a start. It has been a while since I ran it so it needs verification
!! and could probably be improved.

setup
	trap active force line no
	include "6502.POD"
	POD 6502

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! Main program. Performs basic Super Missile Attack testing for suprmatk (romset shortname)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PROGRAM MAIN
	DPY-BUS TEST  
   	EX DELAY   
   	BUS TEST

	DPY Now some short RAM tests
	EX DELAY
	EX RAMTEST

	DPY Now some rom tests
	EX DELAY
	EX ROMTEST

	DPY Now some long RAM tests
	EX DELAY
	EX LONGRAM

	DPY Success
	EX DELAY

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   !DELAY ROUTINE
   
PROGRAM DELAY
	REG1=40
	0:
	DEC REG1
	IF REG1 >0 GOTO 0
   
PROGRAM RAMTEST
	RAM SHORT @ 0 - 3FFF

PROGRAM LONGRAM
	RAM LONG @ 0 - 3FFF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   !ROM ROUTINE
   
PROGRAM ROMTEST
	ROM @ 5000-57FF SIG F25A !035820.02
	ROM @ 5800-5FFF SIG 3977 !035821.02
	ROM @ 6000-67FF SIG E850 !035822.02
	ROM @ 6800-6FFF SIG EF62 !035823.02
	ROM @ 7000-77FF SIG B25D !035824.02
	ROM @ 7800-7FFF SIG B888 !035825.02
