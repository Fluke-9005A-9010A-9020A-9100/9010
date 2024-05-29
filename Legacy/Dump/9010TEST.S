!!These programs are to be run on one 9010A which is plugged into the 
!!9010A under test (UUT) via the Z80AA (faster) pod.

PROGRAM 1              !Menu for 9010A tests
   DPY-WHICH TEST DO YOU WISH TO DO?
   EX 13
0: LABEL 0
   DPY-0 PIA, 1 FREE RUNNING PROBE,
   EX 13
   DPY-2 PROBE SYNC, 3 PROBE PULSE,
   EX 13
   DPY-4 SIG REGISTER, 5 EVENT CNTR,
   EX 13
   DPY-6 DISPLAY//KEYBOARD, OR
   EX 13
   DPY-7 RS-232 INTERFACE TEST \1

   
   IF REG1 > 7 GOTO 0
   IF REG1 = 0 GOTO 1
   IF REG1 = 1 GOTO 2
   IF REG1 = 2 GOTO 3
   IF REG1 = 3 GOTO 4
   IF REG1 = 4 GOTO 5
   IF REG1 = 5 GOTO 6
   IF REG1 = 6 GOTO 7
   IF REG1 = 7 GOTO 8

1: LABEL 1
   EX PROGRAM 11
   GOTO 0

2: LABEL 2
   EX PROGRAM 2
   GOTO 0

3: LABEL 3
   EX PROGRAM 3
   GOTO 0

4: LABEL 4
   EX PROGRAM 4
   GOTO 0

5: LABEL 5
   EX PROGRAM 5
   GOTO 0

6: LABEL 6
   EX PROGRAM 9
   GOTO 0

7: LABEL 7
   EX PROGRAM 6
   GOTO 0

8: LABEL 8
   EX PROGRAM 8
   GOTO 0

PROGRAM 2              !Free-Run Probe Check

   DPY-FREE-RUN PROBE CHECK#
   SYNC FREE-RUN
   EXECUTE PROGRAM 12
   DPY-JUMP R14//C16 TO TP12 - GRND
   DPY-+ CONT#
   STOP
   
PROGRAM 3              !Synchronized Probe Check

   DPY-SYNC PROBE CHECK#
   EXECUTE PROGRAM 12                      !delay
   DPY-JUMP R14//C16 TO TP2 OR TP1 !disable watchdog
   DPY-+2-CONT#
   STOP
   SYNC FREE-RUN
   DPY-TESTER PROBE TO UUT U41-9   !apply tester pulser to sync input of uut
   DPY-+ - CONT#
   STOP

0: LABEL 0
   DPY-TESTER PULSER OFF - CONT#
   STOP
   REG1 = 1                                !test 1 pointer
   EXECUTE PROGRAM 15                      !read uut probe level status
   IF REGE = 0 GOTO 1                      !check for no low or high
   DPY-SYNC
   GOTO E

1: LABEL 1
   DPY-TESTER TO PULSE LOW -CONT#
   STOP

2: LABEL 2
   REG1 = 2                                !test 2 pointer
   DPY-CONNECT INPUT TO LOW<TP8>
   DPY-+ - CONT#
   STOP
   EXECUTE PROGRAM 15                      !read uut probe level status
   IF REGE = 40 GOTO 3                     !check for low
   DPY-LOW
   GOTO E

3: LABEL 3
   REG 1 = 3                               !test 3 pointer
   DPY-CONNECT INPUT TO HI<TP10>
   DPY -+ - CONT#
   STOP
   EXECUTE PROGRAM 15                      !read uut probe level status
   IF REGE = 80 GOTO F                     !check for high
   DPY-HI
   GOTO E

E: LABEL E
   DPY-+ FAULT#                            !append to test message
   STOP
   IF REG1 = 1 GOTO 0
   IF REG1 = 2 GOTO 2                      !return to test 1, 2, or 3
   IF REG1 = 3 GOTO 3
   GOTO 0

F: LABEL F
   DPY-SYNC PROBE LOGIC OK#

PROGRAM 4              !Probe Pulse Output Check

   DPY-#PULSE OUTPUT CHECK
   EXECUTE PROGRAM 12                      !delay
   DPY-JUMP R14//C16 TO TP2 OR TP1 !display watchdog
   DPY-+2-CONT#
   STOP

0: LABEL 0
   REG1 = 0
   WRITE @ 100C3 = 30                      !cb2=0
WRITE @ 100C1 = 0
WRITE @ 100C0 = FF                      !pia port a to out
WRITE @ 100C1 = 4
WRITE @ 100C0 = 10                      !beep
WRITE @ 100C0 = A0                      !pulse low/free-run
WRITE @ 100C3 = 38                      !cb2=1
GOTO 3

1: LABEL 1
WRITE @ 100C3 = 30
WRITE @ 100C1 = 0
WRITE @ 100C0 = FF
WRITE @ 100C1 = 4
WRITE @ 100C0 = C0                      !afree-run/high pulse
WRITE @ 100C3 = 38
GOTO 3

2: LABEL 2
WRITE @ 100C3 = 30
WRITE @ 100C1 = 0
WRITE @ 100C0 = FF
WRITE @ 100C1 = 4
WRITE @ 100C0 = E0                      !free-run/high & low pulse
WRITE @ 100C3 = 38
GOTO 3

3: LABEL 3
WRITE @ 100C1 = 0
WRITE @ 100C0 = 0                       !pia port a to input
WRITE @ 100C1 = 4
READ @ 100C0                            !read port a
INC REG1
REGE = REGE AND E0                      !mask off all but probe level status
IF REGE = 60 GOTO 4                     !check for low & invalid
IF REGE = A0 GOTO 5                     !check for high & invalid
IF REGE = E0 GOTO 6                     !check for low, invalid, high
GOTO 0

4: LABEL 4
DPY-#PULSE LOW <GREEN>
EXECUTE PROGRAM 13
IF REG1 = 1 GOTO 1
IF REG1 = 2 GOTO 2
GOTO 0

5: LABEL 5
DPY-PULSE HIGH <RED>#
EXECUTE PROGRAM 13
IF REG1 = 1 GOTO 1
IF REG1 = 2 GOTO 2
GOTO 0

6: LABEL 6
DPY-#PULSE HIGH AND LOW <BOTH>
EXECUTE PROGRAM 13
IF REG1 = 1 GOTO 1
IF REG1 = 2 GOTO 2
GOTO 0

PROGRAM 5 460 BYTES                     !Signature Register Test

DPY-SIGNATURE REGISTER CHECK
DPY-+#
EXECUTE PROGRAM 12                      !delay
SYNC DATA
DPY-JUMP R14//C16 TO TP2 OR TP1 !disable watchdog
DPY-+2-CONT#
STOP
DPY-TESTER PROBE TO U41-9
DPY-+, CONT#
STOP
DPY-TESTER PULSE OFF - CONT#            !setup info
STOP
DPY-UUT PROBE TO TP10<+5V>
DPY-+, CONT#
STOP
WRITE @ 100C3 = 30                      !cb2=0
WRITE @ 100C1 = 0
WRITE @ 100C0 = FF                      !port a to output
WRITE @ 100C1 = 4
WRITE @ 100C0 = 80                      !free-run/pulse off
WRITE @ 100C3 = 38                      !cb2=1
READ @ 10020                            !reset signature/event counter
DPY-PRESS PULSE LOW ON TESTER
DPY-+, CONT#
STOP
REG1 = 0
REGF = 10040                            !sig. 10 byte address

1: LABEL 1
READ @ REGF
INC REG1                                !9 clks to sig. register
IF REG1 = 9 GOTO 2
GOTO 1

2: LABEL 2
IF REGE = FE GOTO 3                     !check lo-byte
DPY-SIGNATURE ERROR-LO BYTE
STOP
GOTO F

3: LABEL 3
REG1 = 0
REGE = 0
REGF = 10060                            !sig. high byte address

4: LABEL 4
READ @ REGF
INC REG1                                !8 clks to sig register
IF REG1 = 8 GOTO 5
GOTO 4

5: LABEL 5
IF REGE = FE GOTO F                     !check high-byte
DPY-SIGNATURE ERROR-HI BYTE
STOP

F: LABEL F
DPY-SIGNATURE TEST COMPLETE

PROGRAM 6 1395 BYTES                    !Display/Keyboard Communication Check

WRITE @ 10081 = FF                      !reset display/kybd
READ @ 10080 REPT                       !clear out buffer
DPY-DISPLAY/KYBD COMM. CHECK
EXECUTE PROGRAM 12                      !delay
DPY-JUMP R14//C16 TO TP2 OR TP1 !disable watchdog
DPY -+2-CONT#
STOP

0: LABEL 0
READ @ 10080                            !clear buffer
DPY-HIT UUT 'WRITE' - CONTI
STOP
READ @ 10081                            !read status
IF REGE AND 1 = 1 GOTO 1                !check - buffer full - yes
DPY-#BAD STATUS BIT 0 <NO KEY>  !no - error
DPY-+-CONT
STOP
GOTO 0                                  !repeat status check

1:LABEL 1                               !buffer -full
READ @ 10080                            !clear buffer
DPY-HIT UUT 'RAMP' - CONT#
STOP
READ @ 10080                            !read kybd
IF REGE = 21 GOTO 2                     !check for 'ramp' key - yes
DPY-READ DATA FAILURE - CONT#   !not correct data
STOP
GOTO 1                                  !repeat test

2: LABEL 2                              !read data passes
DPY-#HIT UUT 'READ' TWICE, CONT
STOP
READ @ 10081                            !read status
IF REGE AND 80 > 0 GOTO 3               !overrun bit set - yes
DPY-#BAD STATUS BIT 7, NO OVER  !overrun bit not set - fail
DPY-+RUN
STOP
GOTO 2                                  !repeat test

3: LABEL 3
DPY-TEST STATUS BIT 3=0 <CTRL>#
EXECUTE PROGRAM 13                      !delay
WRITE @ 10081= FF                       !reset
READ @ 10081                            !read status
IF REGE AND 8 = 0 GOTO D                !last command "control"?- fail goto c
DPY-#TEST STATUS BIT 3=1 <DATA>
EXECUTE PROGRAM 13
WRITE @ 10080 = AA                      !write data
READ @ 10081                            !read status
IF REGE AND 8 > 0 GOTO D                !last command "data"?- fail goto d
WRITE @ 10081 = C0                      !clear display
DPY-DISPLAY U'S LEFT-TO-RIGHT#
REG2 = 0                                !digit counter
WRITE @ 10081 = 20                      !pointer to left most digit

4: LABEL 4
WRITE @ 10080 = 55                      !write a "u" and increment (shift right) one digit
INC REG2                                !increment digit counter
IF 20 > REG2 GOTO 4                     !> than decimal 32 goto 4
DPY-#ALL U'S - YES//NO?O
IF REG0 = 0 GOTO E                      !user checks for all u's - if no go to e
DPY-DISPLAY#. RIGHT-TO-LEFT#
REG3 = 20                               !digit counter to right most

5: LABEL 5
REG2 = REG3 DEC
WRITE @ 10081 = 20 OR REG2              !set digit pointer = let most digit + dec. value of reg 2 to right
WRITE @ 10080 = AA                      !write a "#." to display; move pointer to right 1 digit
DEC REG3                                !decrement digit counter
IF REG3 > 0 GOTO 5                      !dme - go to 5
DPY-#ALL #.'S - YES//NO?O
IF REG0 = 0 GOTO E                      !user checks for all "#."'s - if not goto e
DPY-#FLASH EACH DIGIT
REG2 = 0                                !flash pointer

6: LABEL 6
WRITE @ 10081 = 60 OR REG2              !set flash mode - position = leftmost + dec. value of reg 2
INC REG2                                !inc. flash position
IF 20 > REG2 GOTO 6                     !flashed all characters
WRITE @ 10081 = 80                      !turn off flash mode
DPY-+#-YES//NO?O
IF REG0 = 0 GOTO C                      !user verifies all char flashed - if no goto c
DPY-BLANK DISPLAY TWICE#
WRITE @ 10081 = DF                      !blank display (31 scans)
EXECUTE PROGRAM 12                      !delay
WRITE @ REGF = DF                       !blank display (31 scans)
DPY-+#-YES//NO?O
IF REG0 = 0 GOTO C                      !user verifies display blanked - if no goto c
DPY-#MASTER RESET TEST
EXECUTE PROGRAM 13
WRITE @ 10081= FF                       !master reset
DPY-#
DPY-DISPLAY BLANK-YES//NO?O
IF REG0 = 0 GOTO C                      !user verifies display went blank - if no goto c
DPY-#LIGHT ALL LED'S
WRITE @ 10081 = 5F                      !light all leds
DPY-+#-YES//NO?O
IF REG0 = 0 GOTO C                      !user verifies display went blank - if no goto c
DPY-#SINGLE SEGMENT TEST CMD
WRITE @ 10081= 00                       !reset test
WRITE @ REGF = 1                        !start seg. test
DPY-+-OK?O
IF REG0 = 0 GOTO C                      !user verifies test started - if no goto c

DPY-#WALKING CHARACTER TEST CMD
WRITE @ 10081= 0                        !reset test
WRITE @ REGF = 2                        !start walk. char. test
DPY-+-OK?O
IF REG0 = 0 GOTO C                      !user verifies test started - if no goto c
WRITE @ 10081 = 0                       !reset test
DPY-HIT UUT PULSE LOW AND HIGH­
DPY-+CONT#
STOP
DPY-#LED TEST COMMAND
WRITE @ REGF = 4                        !start led test
DPY-+#-ALL LEDS ON?O
IF REG0 = 0 GOTO C                      !user verifies test started - if no goto c
DPY-UUT PULSE HIGH AND LOW OFF­
DPY-+CONT#
STOP
DPY-#KEY TEST CMND
WRITE @ 10081= 0                        !reset test
WRITE @ REGF = 8                        !start key test
DPY-+#-STARTED?O
IF REG0 = 0 GOTO C                      !user verifies test started - if no goto c
GOTO F

C: LABEL C
DPY-WRITE CMND FAIL-CONT#
STOP
GOTO 3

D: LABEL D
DPY-#BAD STATUS BIT 3<$E>               !fail messages
STOP
GOTO 3

E: LABEL E
DPY-WRITE DATA FAIL-CONT#
STOP
GOTO 3

F: LABEL F
DPY-DISPLAY/KYBD TEST COMPLETE  !test complete
WRITE @ 10081 = FF                      !reset display


PROGRAM 7              !sub-routine

   READ PROBE
   WRITE @ 100E3 = AA
   READ @ 100E2
   READ @ 100E1
   READ PROBE
   REG1 = REG0 AND 7000000
   REG2 = REGA AND FFFF00
   REG3 = REGA AND 7F
   IF REG1 = REGA GOTO A
   IF REG2 = REGA GOTO A
   IF REG3 = REGA GOTO A
   REGA = 0
   GOTO B
A: LABEL A
   REGA = 1
   GOTO B
B: LABEL B
   IF REGB = 1 GOTO C
   IF REGB = 2 GOTO D
   IF REGB = 3 GOTO E
C: LABEL C
   DPY-U1-23
   GOTO F
D: LABEL D
   DPY-U1-4
   GOTO F
E: LABEL E
   DPY-U1-18
F: LABEL F

PROGRAM 8              !RS-232 test

   DPY-RS-232 TEST#
   EXECUTE PROGRAM 12
   DPY-JUMP R14//C16 TO TP12 - GRND
   DPY-+ CONT#
   STOP
   DPY-#SET PARITY ON, ODD; CONT
   STOP
   DPY-#SET 8 BITS, 1 STOP BIT;
   DPY-+ CONT
   STOP
   DPY-#SET BAUD RATE = 9600, CONT
   STOP
   DPY-JUMPER RS232 PIN 2 TO 3#, 
   DPY-+CONT
   STOP
   DPY-#MASTER CLEAR TEST
   EXECUTE PROGRAM 12
   REG4 = 7000000
   SYNC FREE-RUN
   DPY-POWER OFF UUT, PROBE U1-21
   DPY-+CONT
   STOP
   READ PROBE
   DPY-POWER ON UUT, CONT#
   STOP
   READ PROBE
   IF REG4 > REG0 AND REG4 GOTO D
0: LABEL 0
   DPY-XMIT BUFFER STATUS TEST#
   EXECUTE PROGRAM 13
   READ @ 100E2
   IF REGE AND 10 = 10 GOTO 1
   DPY-XMIT BUFFER FULL
   GOTO E
1: LABEL 1
   DPY-DATA RECV'D STATUS TEST#
   EXECUTE PROGRAM 13
   READ @ 100E1
   READ @ 100E2
   IF REGE AND 8 = 0 GOTO 2
   DPY-DATA RECV'D-NONE SENT-
   GOTO E
2: LABEL 2
   DPY-OVERRUN STATUS TEST#
   EXECUTE PROGRAM 13
   REGB = 10
   REG1 = 55
   EXECUTE PROGRAM 16
   WRITE @ 100E3 = REG1
   EXECUTE PROGRAM 16
   WRITE @ 100E3 = REG1
   EXECUTE PROGRAM 12
   READ @ 100E2
   IF REGE AND 4 = 4 GOTO 3
   DPY-OVERRUN STATUS
   GOTO E
3: LABEL 3
   DPY-DATA XMIT//REC'D TEST#
   EXECUTE PROGRAM 13
   READ @ 100E1
   IF REGE = REG1 GOTO 4
   GOTO C
4: LABEL 4
   REG1 = AA
   REGB = 10
   EXECUTE PROGRAM 16
   WRITE @ 100E3 = REG1
   EXECUTE PROGRAM 12
   READ @ 100E1
   IF REGE = REG1 GOTO F
   GOTO C
5: LABEL 5
   SYNC FREE-RUN
   DPY-PROBE U1-1,34,37-HIGH?0
   IF REG0 = 0 GOTO E
   DPY-PROBE U1-3,16-ALL LOW?0
   IF REG0 = 0 GOTO E
   DPY-#UART CONTROL TEST
   EXECUTE PROGRAM 12
   SYNC ADDRESS
   REGB = 1
   DPY-@PROBE U1-23 - CONT
   STOP
   REGA = 300
   EXECUTE PROGRAM 7
   IF REGA = 0 GOTO E
   REGB = 2
   DPY-#PROBE U1-4 - CONT
   STOP
   REGA = 600
   EXECUTE PROGRAM 7
   IF REGA = 0 GOTO E
   REGB = 3
   DPY-#PROBE U1-18 - CONT
   STOP
   REGA = 600
   EXECUTE PROGRAM 7
   IF REGA = 0 GOTO E
   DPY-#UART TRANSMIT TEST
   EXECUTE PROGRAM 12
   DPY-PROBE U1-25 - CONT
   STOP
   REGA = 4
   EXECUTE PROGRAM 7
   IF REGA = 0 GOTO 6
   GOTO A
6: LABEL 6
   DPY-#U1-25 TRANSMIT ERROR - CON
   DPY-+T
   STOP
   GOTO F
A: LABEL A
   SYNC FREE-RUN
   DPY-#BAD ITEM NOT FOUND
   EXECUTE PROGRAM 13
   DPY-#USE A SCOPE TO CHECK INPUT
   DPY-+ AND
   EXECUTE PROGRAM 13
   DPY-#OUTPUT OPTO ISOLATORS.
   EXECUTE PROGRAM 13
   DPY-A 55 IS BEING SENT CONTINUO
   DPY-+SLY#
   EXECUTE PROGRAM 13
   REG0 = 40
   DPY-#HIT CLEAR//NO TO END TEST
   DPY-+%0
B: LABEL B
   IF REG0 = 1D GOTO F
   WRITE @ 100E3 = 55
   GOTO B
C: DPY-DATA ERROR-SENT $1-REC'D $E
   DPY-+-CONT#
   STOP
   GOTO 5
E: LABEL E
   DPY-+ERROR-CONT#
   STOP
   GOTO 5
D: LABEL D
   DPY-#BAD MASTER CLEAR, CONT
   STOP
   GOTO F
F: LABEL F
   DPY-#END RS-232-C TEST

PROGRAM 9 347 BYTES

SYNC DATA
DPY-#EVENT COUNTER TEST

EXECUTE PROGRAM 12                      !delay
DPY-JUMP R14//C16 TO TP2 OR TP1         !disable watchdog
DPY-+2-CONT#
STOP
DPY-UUT PROBE TO +5V<TP10>-CONT
DPY-+#
STOP
DPY-TESTER PROBE TO U59-1-CONT#         !setup instructions
STOP
DPY-TESTER TO PULSE OFF - CONT#
STOP
READ @ 10020                                    !reset event counter
DPY-TESTER TO PULSE LOW-CONT#
STOP
REG2 = 0                                        !initialize count

0: LABEL 0
READ @ 10000                                    !read event counter
REGE = REGE AND 7F                              !mask off fuse blown bit
INC REG2                                        !increment count
DPY-DATA READ = $E
IF REG2 = 80 GOTO 1                             !count = 80 - done
IF REGE = REG2 GOTO 0                           !check - is hardware event count (rege)= soft count (reg2)
DPY-DATA = $E SHOULD BE = $2
DPY-+ - CONT#
STOP
DPY-CHECK U59 AND U60
STOP

1: LABEL 1
DPY-END OF EVENT COUNTER CHECK


PROGRAM 11             !PIA (U22) Test 

   DPY-PIA TEST <U22>#
   SYNC ADDRESS
   EXECUTE PROGRAM 12                 !delay
   DPY-JUMP R14//C16 TO TP2 OR TPl    !disable watchdog
   DPY-+2-CONT#
   STOP
   REG1 = 0

1: LABEL 1 
   INC REG1 
   REG3 = 0
   IF REG1 = 6 GOTO F
IF REG1 = 5 GOTO 7
IF REG1 = 4 GOTO 4 
IF REG1 = 3 GOTO 3 
IF REG1 = 2 GOTO 2
DPY-#TEST PORT A OUTPUT 
EXECUTE PROGRAM 12
DPY-TESTER PULSE HIGH, LOW OUT-
DPY-+CONT#
STOP
WRITE @ 100C1 = 0
WRITE @ REGF DEC = FF
WRITE @ REGF INC = 4
REG2 = 2
REG6 = A00
REGF = 100C0
GOTO 5

2: LABEL 2
   DPY-#TEST PORT B OUTPUT
   EXECUTE PROGRAM 12
   WRITE @ 100C3 = 0
   WRITE @ REGF DEC = FF
   WRITE @ REGF INC = 4
   REG2 = 10
   REG6 = A00
   REGF = 100C2
   GOTO 5

3: LABEL 3
   DPY-TEST PORT A INPUT#
   EXECUTE PROGRAM 12
   WRITE @ 100C1 = 0
   WRITE @ REGF DEC = 0
   WRITE @ REGF INC = 4
   DPY-TESTER PULSE HIGH, LOW IN-
   DPY-+CONT#
   STOP
   REG2 = 2
   REG6 = 1
   REGF = 100C0
   GOTO 5

4: LABEL 4
DPY-TEST PORT B INPUT#
EXECUTE PROGRAM 12
WRITE @ 100C3 = 0                                                   ! Part of
WRITE @ REGF DEC = 0                            !pia port b to input! Test 4
WRITE @ REGF INC = 4
REG2 = 101                                      !st pia pin number
REG6 = 1                                        !expected signature
REGF = 100C2                                    !port b address

5: LABEL 5
DPY-PR0BE U22 PIN $2                            !does oper wish to probe current pia pin?
DPY-+, YES/NO #?7
IF REG7 = 0 GOTO D                              !no - increment pin and bit number
READ PROBE                                      !yes - read probe
IF REG1 = 5 GOTO 8                              !if test 4 complete, check cb2 line
IF REG1 > 2 GOTO 6                              !if test 2 complete, continue with test 3, or 4
WRITE @ REGF = 0                                !sets pia port to 0
DTOG @ REGF = FF BIT REG3                       !toggle the bit no. inPart of reg. 3 Test 1 and 2
DTOG @ REGF = REGE BIT REGD                     !repeat toggle using defaul t reg.
WRITE @ REGF = 0                                !pia to zero
READ PROBE                                      !gather signature
IF REG0 AND FFFF00 = REG6 GOTO C                !mask off all but sig and check against reg. 6
GOTO E

6: LABEL 6
READ @ REGF                                     !read pulse at pia portPart
REG8 = REGE                                     !save dataof
READ @ REGF                                     !read pulse at pia portTest
IF REG8 AND REG6 = REGE AND REG6 GOTO E         !if pulse present 3 and 4 at each read, error
SHL REG6                                        !move the test bit to next position for next pia pin check
GOTO C

7: LABEL 7
DPY-#CB2 TEST
EXECUTE PROGRAM 12
DPY-TESTER PULSE HIGH, LOW OUT­
DPY-+CONT#
STOP
REG2 = 19                                       !cb2 pin no.
REG3 = 7                                        !full count in bit counter
REG6 = 2                                        !expected event count
GOTO 5

8: LABEL 8
WRITE @ 100C3 = 38
WRITE @ REGF = 30                               !stimulate cb2 line
WRITE @ REGF = 38
WRITE @ REGF = 30
READ PROBE                                      !gather event count
IF REG0 AND 7F = REG6 GOTO C                    !verity event count - o.k. goto a
GOTO E                                          !not correct count - goto e

C: LABEL C                                      !sig o.k.
DPY-+, GOOD
EXECUTE PROGRAM 12                              !delay

D: LABEL D
INC REG2                                        !increment pin
INC REG3                                        !increment bit
IF REG3 = 8 GOTO 1
GOTO 5

E: LABEL E                                              !sig. failure
DPY-'U22 PIN $2 BIT $3 FAILURE
DPY-+ LOOP'?5                                   !repeat test
IF REG5 = 1 GOTO 5                              !yes
DPY-TEST FAIL#
STOP

F: LABEL F
DPY-PIA TEST PASSED#

PROGRAM 12             !Delay ~ 1 second
   REG1 = 40
1: LABEL 1
   DEC REG1
   IF REG1 > 0 GOTO 1

PROGRAM 13             !Delay ~ 3 seconds

   EXECUTE PROGRAM 12
   EXECUTE PROGRAM 12
   EXECUTE PROGRAM 12

PROGRAM 15

        WRITE @ 100C3 = 30                      !cb2=0
        WRITE @ 100C1 = 0
        WRITE @ 100C0 = FF                      !pia port a to out
        WRITE @ 100C1 = 4
        WRITE @ 100C0 = 0                       !sync mode/pulse off
        WRITE @ 100C3 = 38                      !cb2=1
        WRITE @ 100C1 = 0
        WRITE @ 100C0 = 0                               !pia port to input
        WRITE @ 100C1 = 4
        READ @ 100C0                            !read port a
        REGE = REGE AND C0                      !mask off all except high/low probe status

PROGRAM 16             !sub-routine

0: LABEL 0
   READ @ 100E2
   IF REGE AND REGB = REGB GOTO F
   GOTO 0

F: LABEL F

