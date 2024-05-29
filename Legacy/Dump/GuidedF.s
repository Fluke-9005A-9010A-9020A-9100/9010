!Guided Fault Isolation Program Listings - from Application Information B0138
!Typed by Kev, John, Jon, and Peter 
!Last edited March 4, 2002 John :-#)#
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        


PROGRAM 3    !KEY ENABLE  12 BYTES            !Enable key interrupt

!Inputs:              none
!Called by:    programs 4, 21, 22, 24
!Calls to:     none
!Output:              Reg B = 40; toggles the enabling of asynchronous keyboard interrupt

     REGB = 40                                 !Initialize reg B
     DPY-+%B                                   !Enable key interrupt to reg B


PROGRAM 4     !KEY WAIT    18 BYTES            !Wait for key interrupt

!Inputs:              none
!Called by:    program 22
!Calls to:     program 3
!Outputs:      Register B = the value of a key pressed (0-3F)

     EXECUTE PROGRAM 3                        !Enable interrupt
1:   LABEL 1    
     IF REGB = 40 GOTO 1                      !Loop till key pressed (<40)


PROGRAM 9    !DELAY   28 BYTES                !Delay loop (variable time)

!Inputs:              Reg F = delay loop parameter
!Called by:    program 21, 22
!Calls to:     none
!Outputs:      delay time to delay program execution for displays

     REG1 = REGF                              !Save delay parameter
0:   LABEL 0                                  !Loop reg 1 times
     IF REG1 = 0 GOTO 1                       !Exit if end of loop
     DEC REG1
     GOTO 0
1:   LABEL 1                                  !End loop


PROGRAM 20    !SUPERVISOR   26 BYTES           !Main Guided Fault Isolation program

!Inputs:              Reg B = any key pressed during Controller program when not looping
!              and not stopped.
!Called by:    any main test program upon detecting a failure
!Calls to:     program 21
!Outputs:      Registers C, 8, and 9 as given by program 22 

!     DPY-GFI SUPERVISOR PROGRAM                !Enter your GFI program here

PROGRAM 21    !CONTROLLER 609 BYTES             !Controls the GFI activity

!Inputs:              Registers C, 8, and 9 as specified by program 20
!Called by:    program 20 or other test program
!Calls to:     program 3, 27, 24, 26, 23, 9, Setup program specified by reg C
!Outputs:      Reg B = value of key pressed by operator during program; reg E =
!              Last reading; reg c, 8, 9 stay unchanged; other globals may change

      IF REGC AND FF00 = 0 GOTO 0              !Branch: no setup program number
      REG3 = REGC SHR SHR SHR SHR SHR SHR SHR SHR AND FF     !Get setup program number

      EXECUTE PROGRAM REG3                     !Condition UUT with setup program
0:    LABEL 0
      REG3 = REG8 AND FF                       !Get pin number to probe
      REGA = REG8 SHR SHR SHR SHR SHR SHR SHR SHR     !Setup to get component number
      REG2 = REGA AND FF                       !Get component number to probe
      REG4 = REGA SHR SHR SHR SHR SHR SHR SHR SHR     !Get signature/lo-hi/history
      REG5 = 0                                 !Initialize loop flag to no loop
      REG6 = REG9 SHR SHR SHR SHR SHR          !Get component types
      REG7 = REGC                              !Save setup/stimulus pgm # parameter
      EXECUTE PROGRAM 3                        !Enable Key interrupt for exit
      DPY-#PROBE                               !Dispaly message to probe
      REGA = REG6                              !Set global"component type parameter
      EXECUTE PROGRAM 27                       !Display component type parameter
      DPY-@2 PIN @3                            !Display chip & pin # to probe
      REGA = 0                                 !Set global: wait-for-probe flag
      EXECUTE PROGRAM 24                       !Wait till porbe is in place
      IF REGB = 40 GOTO 1                      !Branch: operator didn't press key
      IF 40 > REGB GOTO F                      !Exit: operator pressed key not CONT
      REGB = 40                                !Pressed CONT:Reset key interrupt
      GOTO 5                                   !FAIL: no circuit activity at probe
1:    LABEL 1                                  !Loop point for checking ciruit
      DPY-                                     !Clear Display
      REGA = REG6                              !Set global: component type parameter
      EXECUTE PROGRAM 27                       !Display compoent type parameter
      DPY-+@2-@3                               !Display chip & pin # being probed
      REGA=REG4                                !Set global: expected result
      EXECUTE PROGRAM 26                       !Display expected result
      REGD = REGA                              !Get expected sig/history/min count
      REG1 = REGD                              !Get max count
      REGC = REG7                              !Restore setup/stimulus pgm parameter
      EXECUTE PROGRAM 23                       !Set sync mode, stimulate, rd probe
      REGE = REGA                              !Save reading for use by Supervisor
      IF 40 > REGB GOTO A                      !Branch: operator pressed key
2:    LABEL 2                                  !Loop point for CONT during loop
      IF REG9 AND 2 > 0 GOTO 3                 !Branch: check for correct count
      IF REGA = REG0 GOTO 8                    !Branch: sig/history is correct
      GOTO 5                                   !Branch: bad signature/logic history
3:    LABEL 3                                  !Check for correct count
      IF REG0 > REG1 GOTO 4                    !Branch: min is > max (count wrap)
      IF REGA > REG1 GOTO 5                    !Branch: actual is > max (bad)
      IF REG0 > REGA GOTO 5                    !Branch: actual is < min (bad)
      GOTO 8                                   !Branch: count within min-max (good)
4:    LABEL 4                                  !Count wrap limit check
      IF REG1 >= REGA GOTO 8                   !Branch: actual is < max (good)
      IF REGA >= REG0 GOTO 8                   !Branch: actual is >=min (good)
5:    LABEL 5                                  !Handle bad/no readings
      IF 40 > REGB GOTO A                      !Branch: operator pressed key
      DPY-+BAD                                 !Display failure message
      IF REG5 > 0 GOTO 9                       !Branch: loop if loop flag is set
      DPY-+#                                   !Beep
      REGF = 2                                 !Set Delay parameter
      EXECUTE PROGRAM 9                        !Delay to hear second beep
      DPY-+#; LOOP?5                           !Ask whether to loop on failure
      IF REG5 > 0 GOTO 1                       !Branch: loop flag is now set
      DPY-SUSPECT BAD                          !No loop: display message
      REGC = REG7                              !Restore setup/stimulus pgm #s
6:    LABEL 6                                  !Loop to display suspect components
      REG6 = REG6 SHR SHR SHR SHR              !Get suspect component #
      REG7 = REG6 AND FF                       !Mask out other info
      IF REG7 = 0 GOTO 7                       !Branch: end loop if no suspect
      REG6 = REG6 SHR SHR SHR SHR SHR SHR SHR SHR     !Get suspect component type
7:    LABEL 7                                  !Set global: suspect type
      DPY-+#CONT?6                             !Ask whether to continue GFI
      IF REG6 = 1 GOTO A                       !Branch: get next point if yes
      IF 40 > REGB GOTO C                      !Branch: operator pressed key
      DPY-+%B                                  !Disable key interrupt
      GOTO C                                   !Branch to exit (no continue)
8:    LABEL 8                                  !Comparison was good
      DPY-+GOOD                                !Display GOOD message
      IF 40 > REGB GOTO A                      !Branch: operator pressed key
      IF REG5 = 0 GOTO A                       !Branch: loop flag is clear
9:    LABEL 9                                  !Loop flag is set:
      DPY-+CONT                                !Display CONT message
      REGF = 25                                !Set delay parameter
      EXECUTE PROGRAM 9                        !Delay to see message
      GOTO 1                                   !Loop to beginning
A:    LABEL A                                  !Enable exit:
      REGF = 25                                !Set delay parameter
      EXECUTE PROGRAM 9                        !Delay to see reading
      REGC = REG7                              !Restore setup/stimulus pgm #s
      IF REGB = 40 GOTO 0                      !Branch: operator didn't press key
      IF REGB = 25 GOTO B                      !Branch: CONT pressed
      GOTO F                                   !Branch: other key pressed
B:    LABEL B                                  !CONT was pressed
      REGB = 40                                !Reset interrupt register
      IF REG5 = 0 GOTO F                       !Branch: Loop flag is clear
      REG5 = 0                                 !Clear loop flag
      DPY-+%B                                  !Re-enable key interrupt
      GOTO 2                                   !Loop to re-display readings
C:    LABEL C                                  !Wait-for-probe loop failed
      REGB = 10                                !Set clear code into interrupt reg
      GOTO F                                   !Branch: exit
D:    LABEL D                                  !No key pressed during routine:
      DPY-=%B                                  !Disable key interrupt
F:    LABEL F                                  !Exit:
      REGA = 1                                 !Set global: remove-probe flag
      EXECUTE PROGRAM 24                       !Wait for probe to be removed


PROGRAM 22   !PACKER  1379 BYTES             !Main Guided Fault Isolation program

!Inputs:    none
!Called by:     none (standalone)
!Calls to:      programs 3, 4, 9, 23, 26, 27, Setup and Stimulus Programs
!Outputs:       registers C, 8, and 9 for use by program 20

   DPY-PARAMETER PACK PROGRAM#              !Display message
   REGF = 50                                !Set delay parameter
   EXECUTE PROGRAM 9                        !Delay to see display
   REGA = 0                                 !Set global: clear type parameter
0: LABEL 0                                  !
   DPY-DEVICE TO PROBE <1-F,ENTER>          !Ask for device type
   DPY-+____                                !
   EXECUTE PROGRAM 27                       !Display device type
   EXECUTE PROGRAM 4                        !Wait for operator to press key
   REG0 = REGA                              !Save device type
   REGA = 0                                 !Set global: clear type parameter
   IF REGB = 1C GOTO 1                      !Branch: ENTER key was pressed
   IF REGB = 0 GOTO 0                       !Branch: 0 type not allowed
   REGA = REGB                              !Set global: save device type
   IF F >= REGB GOTO 0                      !Branch: 1-F types allowed
   REGA = REG0                              !Illegal type: restore last good one
   DPY-+#                                   !Beep for erroneous entry
   GOTO 0                                   !Branch: loop till ENTER pressed
1: LABEL 1                                  !
   DPY-ENTER DEVICE NUMBER <256 =           !Ask for device number
   DPY-+ \7                                 !Save in reg 7
   IF REG7 > FF GOTO 1                      !Branch: >FF not allowed
2: LABEL 2                                  !
   DPY-ENTER PIN NUMBER <256 = \6           !Ask for pin number1; save in reg 6
   IF REG6 > FF GOTO 2                      !Branch: >FF not allowed
3: LABEL 3                                  !
   DPY-1ST SUSPECT TYPE <0-F,ENTER          !Ask for 1st suspect
   DPY-+>___                                !
   EXECUTE PROGRAM 27                       !Display suspect type
   EXECUTE PROGRAM 4                        !Wait till key pressed
   REGE = REGA                              !Save suspect type in reg E
   REGA = 0                                 !Set global: clear type parameter
   IF REGB = 1C GOTO 4                      !Branch: ENTER pressed
   REGA = REGB                              !Set global: save device type
   IF F >= REGB GOTO 3                      !Branch: 1-F types allowed
   REGA = REGE                              !Illegal type: restore last good one
   DPY-+#                                   !Beep for erroneous entry
   GOTO 3                                   !Branch: loop till ENTER pressed
4: LABEL 4                                  !
   REG3 = 0                                 !Clear 1st suspect #
   IF REGE = 0 GOTO 7                       !Branch: 1st suspect type = 0
   DPY-1ST SUSPECT NUMBER <256 =            !Ask for suspect #
   DPY-+ \3                                 !Save in reg 3
   IF REG3 > FF GOTO 4                      !Branch: >FF not allowed
   REG3 = REGE SHL SHL SHL SHL SHL SHL SHL SHL OR REG3     !Merge suspect type with # in reg 3                            
5: LABEL 5                                  !
   IF REG3 = 0 GOTO 7                       !Branch: no 1st suspect
   DPY-2ND SUSPECT TYPE <0-F,ENTER          !Ask for 2nd suspect type
   DPY-+>____                               !
   EXECUTE PROGRAM 27                       !Display 2nd suspect type
   EXECUTE PROGRAM 4                        !Wait for operator to press key
   REGF = REGA                              !Save suspect type in reg F
   REGA = 0                                 !Set global: clear type parameter
   IF REGB = 1C GOTO 6                      !Branch: ENTER pressed
   REGA = REGB                              !Set global: save device type
   IF F >= REGB GOTO 5                      !Branch: 1-F types allowed
   REGA = REGF                              !Illegal type: restore last good one
   DPY-+#                                   !Beep for erroneous entry
   GOTO 5                                   !Branch: loop till ENTER pressed
6: LABEL 6                                  !
   REG2 = 0                                 !Clear 2nd suspect #
   IF REGF = 0 GOTO 7                       !Branch: no 2nd suspect type
   DPY-2ND SUSPECT NUMBER <256 =            !Ask for 2nd suspect #
   DPY-+ \2                                 !Save in reg 2
   IF REG2 > FF GOTO 6                      !Branch: >FF not allowed
   REG2 = REGF SHL SHL SHL SHL SHL SHL SHL SHL OR REG2      !Merge suspect type with # in reg 2                           
7: LABEL 7                                  !
   DPY-PRESS 0=SIG, 1=LEVEL,                !Ask for sig/level/count mode
   DPY-+ 2 = COUNT                          !
   EXECUTE PROGRAM 4                        !Wait for operator to press key
   REG5 = REGB                              !Save key in reg 5
   IF REG5 > 2 GOTO 7                       !Branch: >2 not allowed
8: LABEL 8                                  !
   DPY-PRESS 0=FREE 1=ADRS 2=DATA           !Ask for sync mode
   DPY-+ SYNC                               !
   EXECUTE PROGRAM 4                        !Wait for operator to press key
   REG4 = REGB                              !Save key in reg 4
   IF REG4 > 2 GOTO 8                       !Branch: >2 not allowed
   IF REG4 > 0 GOTO 9                       !Branch: A or D sync selected
   IF REG5 > 0 GOTO 9                       !Branch: not sig and free-run
   DPY-#NO FREE-RUN SIGNATURES              !Display error message
   REGF = 40                                !Set delay parameter
   EXECUTE PROGRAM 9                        !Delay to see display
   GOTO 7                                   !Loop for re-entry of mode & sync
9: LABEL 9                                  !
   REG1 = 0                                 !Clear setup program number
   REGA = 0                                 !Clear stimulus program number
   DPY-SETUP PGM= \A; STIMULUS PGM          !Ask for setup/stimulus pgm #s (dec)
   DPY-+ =\1                                !Save in reg A and 1
   IF REG1 > 63 GOTO 9                      !Branch: >99 decimal not allowed
   IF REGA > 63 GOTO 9                      !Branch: >99 decimal not allowed
   REG1 = REGA SHL SHL SHL SHL SHL SHL SHL SHL OR REG1     !Merge pgm #s together in reg 1
   REG8 = REG7 SHL SHL SHL SHL SHL SHL SHL SHL OR REG6      !Merge probe chip & pin # to reg 8
   REG9 = REG2 SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL OR REG3     !Merge 1st and 2nd suspects to reg9
   REG9 = REG9 SHL SHL SHL SHL OR REG0      !Merge probe device type to reg 9
   REG9 = REG9 SHL SHL OR REG4              !Merge sync type to reg 9
   REG9 = REG9 SHL SHL OR REG5              !Merge sig/level/count type to reg 9
   EXECUTE PROGRAM 3                        !Enable key interrupt
   REG4 = 7F                                !Set min count to max
   REG5 = 0                                 !Set max count to min
   IF REGA = 0 GOTO A                       !Branch: no setup progream
   EXECUTE PROGRAM REGA                     !Execute setup program
A: LABEL A                                  !Loop to get known good result
   IF REG8 = 1D GOTO 7                      !Branch: restart if CLEAR pressed
   IF 40 > REG8 GOTO C                      !Branch: loop if no key pressed
   DPY-____                                 !Clear display
   REGA = REG0                              !Set global: device type to probe
   EXECUTE PROGRAM 27                       !Display type to probe
   DPY-+@7-@6                               !Display device number and pin
   REGA = FFFFF                             !Set global: no expected result
   EXECUTE PROGRAM 26                       !Display sig/level/count type
   REGC = REG1                              !Set global: setup/stimulus pgm #s
   EXECUTE PROGRAM 23                       !Stimulate, take, display reading
   DPY-+ CONT                               !Prompt to press CONT when done
   REGF = 50                                !Set delay parameter
   EXECUTE PROGRAM 9                        !Delay to see reading
   IF 2 > REG9 AND 3 GOTO A                 !Branch: not event count
   IF REG5 > REGA GOTO B                    !Branch: old max > new count
   REG5 = REGA                              !Save new max count
B: LABEL B                                  !Old max > new count
   IF REGA > REG4 GOTO A                    !Branch: new count > min count
   REG4 = REGA                              !Save new min count
   GOTO A                                   !Branch: do next reading
C: LABEL C                                  !Routine to enter knwon-good result
   IF REG9 AND 3 = 2 GOTO E                 !Branch: event count mode
   REGD = REGA                              !Set global: save reading
   REG7 = 0                                 !Clear min count
   REG6 = REGD AND FFFF                     !Get signature
   IF REG9 AND 3 = 0 GOTO D                 !Branch: signature mode
   REG6 = REGD SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR SHR AND 7    !Get logic level history
   DPY-ENTER LVL <4,2,1=L,X,H> $6           !Ask for history bit pattern
   DPY-+ = \6                               !Save in reg 6
   IF REG6 > 7 GOTO C                       !Branch: >7 not allowed
   REG6 = REG6 SHL SHL SHL SHL SHL SHL SHL SHL  !Move history for later merging
   GOTO F                                   !
D: LABEL D                                  !Routine to enter known good history
   DPY-ENTER SIGNATURE $6 = \6              !Ask for good sig; save in reg 6 
   IF REG6 > FFFF GOTO D                    !Branch: >FFFF not allowed
   GOTO F                                   !Exit
E: LABEL E                                  !Routine to enter min and max count
   REG6 = REG4                              !Get min count read
   REG7 = REG5                              !Get max count read
   DPY-ENTER COUNT MIN @6=\6                !Ask for min count; save in reg 6
   DPY-, MAX @7=\7                          !Ask for max count; save in reg 7
   IF REG6 > 7F GOTO E                      !Branch: >7F min not allowed
   IF REG7 > 7F GOTO E                      !Branch: >7F max not allowed
   REG6 = REG6 SHL SHL SHL SHL SHL SHL SHL SHL   !Move counts for later merging
F: LABEL F                                  !Display parameters and loop
   REG8 = REG6 SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL OR REG8  !Merge sig, hist, max cnt into reg 8
   REG8 = REG7 SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL SHL OR REG8  !Merge known-good min count to reg 8
   REGC = REG1                              !Get   setup/stimulus   program   #s
   DPY-REG C=$C; 8=$8; 9=$9                 !Display parametes for program 20
   AUX-REG C=$C;  8=$8;  9=$9               !Send parameters to RS-232 I/F
   EXECUTE PROGRAM 4                        !Wait for operator to press a key
   REGA = 0                                 !Set global: initialize device type
   SYNC FREE-RUN                            !Reset sync mode to free-run
   GOTO 0                                   !Loop to beginning of program
 
PROGRAM 23  !READER  223 BYTES          !Simulate circuit and take readings

!Inputs:        Registers C, 8, and 9 as setup by program 20 or 22
!Called by:     programs 21, 22
!Calls to:      program 9, 25, and Stimulus program specified by register C
!Output:        Reg A = actual result

   REG1 = REGD                                  !Save any D register value
   IF REG9 AND C = C GOTO D                     !Branch: invalid sync parameter
   IF REG9 AND 3 = 3 GOTO D                     !Branch: invalid mode parameter
   REG2 = REGC AND FF                           !Get stimulus program number
0: LABEL 0
   SYNC DATA                                    !Initialise with Data sync mode
   IF REG9 AND 8 > 0 GOTO 1                     !Branch: Data sync flag is set
   SYNC ADDRESS                                 !Enable Address sync mode
   IF REG9 AND 4 > 0 GOTO 1                     !Branch: Address sync flag is set
   IF REG9 AND 3 = 0 GOTO 1                     !Branch: force adrs sync if sig mode
   SYNC FREE-RUN                                !No other sync: select free-run sync
1: LABEL 1
   READ PROBE                                   !Initialise signature/count/history
   READ PROBE                                   !Take quick reading
   IF REG2 = 0 GOTO 2                           !Branch: no stimulus program #
   EXECUTE PROGRAM REG2                         !Stimulate circuit under test
   READ PROBE                                   !Take signature, count or history
2: LABEL 2
   IF REG9 AND 2 > 0 GOTO 3                     !Branch: event counts selected
   IF REG9 AND 1 > 0 GOTO 4                     !Branch: logic history selected
   REGA = REG0 SHR SHR SHR SHR SHR SHR SHR SHR AND FFFF  !Mask out history and count
   DPY-+$A                                      !Display signature taken
   GOTO E                                       !Exit
3: LABEL 3                                      !Event counts:
   REGA = REG0 AND 7F                           !Mask out signature and history
   DPY-+@A                                      !Display counts in decimal
   GOTO E                                       !Exit
4: LABEL 4                                      !Logic level history
   REGA = REG0 AND 7000000                      !Mask out signature and count
   EXECUTE PROGRAM 25                           !Display history
   GOTO E                                       !Exit
D: LABEL D                                      !Stop for invalid reg9 parameters
   DPY-+#BAD REG9=$9                            !Display error message
   STOP                                         !Stop the program
   GOTO F                                       !Exit on continue
E: LABEL E                                      !Exit
   DPY-+,__                                     !Add comma and space to display
F: LABEL F                                      !Exit
   REGD = REG1                                  !Restore value to reg D


PROGRAM 24  !MONITOR  236 BYTES         !Ensure probe in or out of circuit

!Inputs:        Reg A = 0 to insert probe, 1 to remove probe: reg 8 and 9 as
!                specified by program 20
!Called by:     program 21
!Calls to:      program 3
!Output:        Reg B = 40 if no key pressed; 41 if CONT during lop; key value

   SYNC FREE-RUN                                !Set free-run to enable async probe
   IF REGA > 0 GOTO 0                           !Branch: remove probe
   IF REG9 AND 1 = 0 GOTO 0                     !Branch: no CONT if not history
   IF REG8 AND 7000000 = 2000000 GOTO 4         !Branch: not seeking invalid state
0: LABEL 0                                      !Loop point for repeating check
   REG1 = 10                                    !Initialise pass counter
1: LABEL 1
   READ PROBE                                   !Take probe reading
   IF REGA = 0 GOTO 2                           !Branch: insert probe
   IF REG0 AND 5000000 = 0 GOTO 3               !Branch: high/low received
   DPY-REMOVE PROBE                             !Display message
   GOTO 0                                       !Loop till probe is removed 10 tries
2: LABEL 2                                      !Wait until probe is inserted
   IF 40 > REGB GOTO D                          !Branch: operator pressed key
   IF REG0 AND 5000000 = 0 GOTO 0               !Branch: high/low not received
3: LABEL 3                                      !High/low received
   DEC REG1                                     !Decrement pass counter
   IF 40 > REGB GOTO F                          !Branch: operator pressed key
   IF REG1 > 0 GOTO 1                           !Branch: loop til 10 good passes
   GOTO F                                       !Exit after 10 good passes
4: LABEL 4                                      !Entry if needed to press CONT
   DPY-+, CONTINUE                              !Display message
5: LABEL 5
   IF REGB = 40 GOTO 5                          !Wait till operator presses key
   IF REGB = 25 GOTO 6                          !Branch: operator pressed CONT
   GOTO F                                       !Exit
6: LABEL 6
   EXECUTE PROGRAM 3                            !Re-enable key interupt
   GOTO F                                       !Exit
D: LABEL D                                      !Key pressed during check routine
   IF REGB = 25 GOTO E                          !Branch: key was CONT
   GOTO F                                       !Exit: key was not CONT
E: LABEL E                                      !CONT key was pressed
   EXECUTE PROGRAM 3                            !Re-enable key interrupt
   REGB = 41                                    !Set global: CONT pressed
   DPY-+                                        !Add space to display
F: LABEL F                                      !Exit


PROGRAM 25  !D-HISTORY  103 BYTES               !Display logic history

!Inputs:        Reg A = history Y000000, where Y bits are LXH, or FFFFF (from)
!               program 22 for no history
!Called by:     programs 23 and 26
!Calls to:      none
!Output:        display only

   IF REGA AND 7000000 > 0 GOTO 0               !Branch: some history indicated
   DPY-+HOME                                    !Display message of no history
   GOTO 3                                       !Branch: exit
0: LABEL 0                                      !Display type of history
   IF REGA AND 1000000 = 0 GOTO 1               !Branch: not HIGH
   DPY-+H                                       !Display H
1: LABEL 1
   IF REGA AND 2000000 = 0 GOTO 2               !Branch: not INVALID STATE
   DPY-+X                                       !Display X
2: LABEL 2
   IF REGA AND 4000000 = 0 GOTO 3               !Branch: not LOW
   DPY-+L                                       !Display L
3: LABEL 3


PROGRAM 26  !D-EXPECTED  169 BYTES              !Display mode and expected result

!Inputs:        Reg A = expected result from program 21, FFFFF from program 22;
!                Reg 9 = setup by program 20, 22
!Called by:     programs 21, 22
!Calls to:      program 25
!Output:        Reg A = expected sig, history, min count; reg D = exp max count

   IF REG9 AND 1 = 1 GOTO 2                     !Branch: logic history selected
   IF REG9 AND 2 = 2 GOTO 3                     !Branch: event count selected
1: LABEL 1                                      !Signature selected
   DPY-+SIG                                     !Display reading type
   IF REGA > FFFF GOTO 5                        !Branch: no expected result
   DPY-+ $A                                     !Display expected signature
   GOTO 5                                       !Exit
2: LABEL 2                                      !Logic history selected
   DPY-+LEVEL                                   !Display reading type
   IF REGA > FFFF GOTO 5                        !Branch: no expected result
   REGA = REGB AND 7000000                      !Mask out all but history
   EXECUTE PROGRAM 25                           !Display history
   GOTO 5                                       !Exit
3: LABEL 3                                      !Event count selected
   IF REGA > FFFF GOTO 4                        !Branch: no expected result
   REGD = REGA AND 7F                           !Mask out all but maximum count
   REGA = REGA SHR SHR SHR SHR SHR SHR SHR SHR AND 7F  !Mask out all but maximum count
   DPY-+CNT @A-@D                               !Display minimum and maximum count
4: LABEL 4                                      !Display form program 22
   DPY-+COUNT                                   !Display reading type
5: LABEL 5                                      !Exit
   DPY-+ =_                                     !Add equality sign to display


PROGRAM 27  !D-DEVICE  284 BYTES                !Displays device type

!Inputs:        RegA = value 0 through F to display a device (0=none)
!Called by:     programs 21 and 22
!Calls to:      none
!Outputs:       display only

   REG1 = REGA AND F                            !Mask out all but the lower nibble
   IF REG1 = 0 GOTO F                           !Branch: to selected display code
   IF REG1 = 1 GOTO 1
   IF REG1 = 2 GOTO 2                           !Note: modify display steps to
   IF REG1 = 3 GOTO 3                           !tailor this program to your needs
   IF REG1 = 4 GOTO 4
   IF REG1 = 5 GOTO 5
   IF REG1 = 6 GOTO 6
   IF REG1 = 7 GOTO 7
   IF REG1 = 8 GOTO 8
   IF REG1 = 9 GOTO 9
   IF REG1 = A GOTO A
   IF REG1 = B GOTO B
   IF REG1 = C GOTO C
   IF REG1 = D GOTO D
   IF REG1 = E GOTO E
   DPY-+                                        !Display item F (Available for use)
   GOTO F                                       !Exit
1: LABEL 1
   DPY-+U                                       !Display item 1: Integrated circuit
   GOTO F
2: LABEL 2
   DPY-+Q                                       !Transistor
   GOTO F
3: LABEL 3
   DPY-+R                                       !Resistor
   GOTO F
4: LABEL 4
   DPY-+C                                       !Capacitor
   GOTO F
5: LABEL 5
   DPY-+CR                                      !Diode
   GOTO F
6: LABEL 6
   DPY-+SW                                      !Switch
   GOTO F
7: LABEL 7
   DPY-+LED                                     !Light emitting diode
   GOTO F
8: LABEL 8
   DPY-+KEY                                     !Pushbutton or key
   GOTO F
9: LABEL 9
   DPY-+K                                       !Relay
   GOTO F
A: LABEL A
   DPY-+P                                       !Plug
   GOTO F
B: LABEL B
   DPY-+J                                       !Jack
   GOTO F
C: LABEL C
   DPY-+X                                       !IC socket
   GOTO F
D: LABEL D
   DPY-+BP                                      !Backplane
   GOTO F
E: LABEL E
   DPY-+                                        !Available for your use
   GOTO F
F: LABEL F
