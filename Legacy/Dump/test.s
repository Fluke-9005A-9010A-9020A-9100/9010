PROGRAM 0
DPY-6 STAT
write @ 2000 = 00
write @ 2001 = 60
write @ 2002 = 00
write @ 2003 = 60
write @ 2004 = 00
write @ 2005 = 60
write @ 2006 = 00
write @ 2007 = 60
write @ 2008 = 00
write @ 2009 = 60
write @ 200A = 00
write @ 200B = E0
DPY-+ DONE

PROGRAM 1
   0: label 0
        WRITE @ 1200 = 00
STOP
GOTO 0


PROGRAM 2
REG1 = 1
DPY-@1 STATS
REGF = 2000
0: LABEL 0
WRITE @ REGF = 00
INC REGF
write @ REGF = 60
INC REGF
DEC REG1
IF REG1 > 0 GOTO 0

WRITE @ REGF = 00
INC REGF
WRITE @ REGF = e0
DPY-+ DONE @@ ADDRESS $F
