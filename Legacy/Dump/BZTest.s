     1: /***************************************************************************
     2: 
     3: 	Atari Battlezone hardware
     4: 
     5: 	Games supported:
     6: 		* Battlezone
     7: 		* Bradley Trainer
     8: 		* Red Baron
     9: 
    10: 	Known bugs:
    11: 		* none at this time
    12: 
    13: ****************************************************************************
    14: 
    15: 	Battlezone memory map (preliminary)
    16: 
    17: 	0000-04ff RAM
    18: 	0800      IN0
    19: 	0a00      IN1
    20: 	0c00      IN2
    21: 
    22: 	1200      Vector generator start (write)
    23: 	1400
    24: 	1600      Vector generator reset (write)
    25: 
    26: 	1800      Mathbox Status register
    27: 	1810      Mathbox value (lo-byte)
    28: 	1818      Mathbox value (hi-byte)
    29: 	1820-182f POKEY I/O
    30: 	1828      Control inputs
    31: 	1860-187f Mathbox RAM
    32: 
    33: 	2000-2fff Vector generator RAM
    34: 	3000-37ff Mathbox ROM
    35: 	5000-7fff ROM
    36: 
    37: 	Battlezone settings:
    38: 
    39: 	0 = OFF  1 = ON  X = Don't Care  $ = Atari suggests
    40: 
    41: 	** IMPORTANT - BITS are INVERTED in the game itself **
    42: 
    43: 	TOP 8 SWITCH DIP
    44: 	87654321
    45: 	--------
    46: 	XXXXXX11   Free Play
    47: 	XXXXXX10   1 coin for 2 plays
    48: 	XXXXXX01   1 coin for 1 play
    49: 	XXXXXX00   2 coins for 1 play
    50: 	XXXX11XX   Right coin mech x 1
    51: 	XXXX10XX   Right coin mech x 4
    52: 	XXXX01XX   Right coin mech x 5
    53: 	XXXX00XX   Right coin mech x 6
    54: 	XXX1XXXX   Center (or Left) coin mech x 1
    55: 	XXX0XXXX   Center (or Left) coin mech x 2
    56: 	111XXXXX   No bonus coin
    57: 	110XXXXX   For every 2 coins inserted, game logic adds 1 more
    58: 	101XXXXX   For every 4 coins inserted, game logic adds 1 more
    59: 	100XXXXX   For every 4 coins inserted, game logic adds 2 more
    60: 	011XXXXX   For every 5 coins inserted, game logic adds 1 more
    61: 
    62: 	BOTTOM 8 SWITCH DIP
    63: 	87654321
    64: 	--------
    65: 	XXXXXX11   Game starts with 2 tanks
    66: 	XXXXXX10   Game starts with 3 tanks  $
    67: 	XXXXXX01   Game starts with 4 tanks
    68: 	XXXXXX00   Game starts with 5 tanks
    69: 	XXXX11XX   Missile appears after 5,000 points
    70: 	XXXX10XX   Missile appears after 10,000 points  $
    71: 	XXXX01XX   Missile appears after 20,000 points
    72: 	XXXX00XX   Missile appears after 30,000 points
    73: 	XX11XXXX   No bonus tank
    74: 	XX10XXXX   Bonus taks at 15,000 and 100,000 points  $
    75: 	XX01XXXX   Bonus taks at 20,000 and 100,000 points
    76: 	XX00XXXX   Bonus taks at 50,000 and 100,000 points
    77: 	11XXXXXX   English language
    78: 	10XXXXXX   French language
    79: 	01XXXXXX   German language
    80: 	00XXXXXX   Spanish language
    81: 
    82: 	4 SWITCH DIP
    83: 
    84: 	XX11   All coin mechanisms register on one coin counter
    85: 	XX01   Left and center coin mechanisms on one coin counter, right on second
    86: 	XX10   Center and right coin mechanisms on one coin counter, left on second
    87: 	XX00   Each coin mechanism has it's own counter
    88: 
    89: ****************************************************************************
    90: 
    91: 	Red Baron memory map (preliminary)
    92: 
    93: 	0000-04ff RAM
    94: 	0800      COIN_IN
    95: 	0a00      IN1
    96: 	0c00      IN2
    97: 
    98: 	1200      Vector generator start (write)
    99: 	1400
   100: 	1600      Vector generator reset (write)
   101: 
   102: 	1800      Mathbox Status register
   103: 	1802      Button inputs
   104: 	1804      Mathbox value (lo-byte)
   105: 	1806      Mathbox value (hi-byte)
   106: 	1808      Red Baron Sound (bit 1 selects joystick pot to read also)
   107: 	1810-181f POKEY I/O
   108: 	1818      Joystick inputs
   109: 	1860-187f Mathbox RAM
   110: 
   111: 	2000-2fff Vector generator RAM
   112: 	3000-37ff Mathbox ROM
   113: 	5000-7fff ROM
   114: 
   115: 	RED BARON DIP SWITCH SETTINGS
   116: 	Donated by Dana Colbert
   117: 
   118: 
   119: 	$=Default
   120: 	"K" = 1,000
   121: 
   122: 	Switch at position P10
   123: 	                                  8    7    6    5    4    3    2    1
   124: 	                                _________________________________________
   125: 	English                        $|    |    |    |    |    |    |Off |Off |
   126: 	Spanish                         |    |    |    |    |    |    |Off | On |
   127: 	French                          |    |    |    |    |    |    | On |Off |
   128: 	German                          |    |    |    |    |    |    | On | On |
   129: 	                                |    |    |    |    |    |    |    |    |
   130: 	 Bonus airplane granted at:     |    |    |    |    |    |    |    |    |
   131: 	Bonus at 2K, 10K and 30K        |    |    |    |    |Off |Off |    |    |
   132: 	Bonus at 4K, 15K and 40K       $|    |    |    |    |Off | On |    |    |
   133: 	Bonus at 6K, 20K and 50K        |    |    |    |    | On |Off |    |    |
   134: 	No bonus airplanes              |    |    |    |    | On | On |    |    |
   135: 	                                |    |    |    |    |    |    |    |    |
   136: 	2 aiplanes per game             |    |    |Off |Off |    |    |    |    |
   137: 	3 airplanes per game           $|    |    |Off | On |    |    |    |    |
   138: 	4 airplanes per game            |    |    | On |Off |    |    |    |    |
   139: 	5 airplanes per game            |    |    | On | On |    |    |    |    |
   140: 	                                |    |    |    |    |    |    |    |    |
   141: 	1-play minimum                 $|    |Off |    |    |    |    |    |    |
   142: 	2-play minimum                  |    | On |    |    |    |    |    |    |
   143: 	                                |    |    |    |    |    |    |    |    |
   144: 	Self-adj. game difficulty: on  $|Off |    |    |    |    |    |    |    |
   145: 	Self-adj. game difficulty: off  | On |    |    |    |    |    |    |    |
   146: 	                                -----------------------------------------
   147: 
   148: 	  If self-adjusting game difficulty feature is
   149: 	turned on, the program strives to maintain the
   150: 	following average game lengths (in seconds):
   151: 
   152: 	                                        Airplanes per game:
   153: 	     Bonus airplane granted at:          2   3     4     5
   154: 	2,000, 10,000 and 30,000 points         90  105$  120   135
   155: 	4,000, 15,000 and 40,000 points         75   90   105   120
   156: 	6,000, 20,000 and 50,000 points         60   75    90   105
   157: 	             No bonus airplanes         45   60    75    90
   158: 
   159: 
   160: 
   161: 	Switch at position M10
   162: 	                                  8    7    6    5    4    3    2    1
   163: 	                                _________________________________________
   164: 	    50  PER PLAY                |    |    |    |    |    |    |    |    |
   165: 	 Straight 25  Door:             |    |    |    |    |    |    |    |    |
   166: 	No Bonus Coins                  |Off |Off |Off |Off |Off |Off | On | On |
   167: 	Bonus $1= 3 plays               |Off | On | On |Off |Off |Off | On | On |
   168: 	Bonus $1= 3 plays, 75 = 2 plays |Off |Off | On |Off |Off |Off | On | On |
   169: 	                                |    |    |    |    |    |    |    |    |
   170: 	 25 /$1 Door or 25 /25 /$1 Door |    |    |    |    |    |    |    |    |
   171: 	No Bonus Coins                  |Off |Off |Off |Off |Off | On | On | On |
   172: 	Bonus $1= 3 plays               |Off | On | On |Off |Off | On | On | On |
   173: 	Bonus $1= 3 plays, 75 = 2 plays |Off |Off | On |Off |Off | On | On | On |
   174: 	                                |    |    |    |    |    |    |    |    |
   175: 	    25  PER PLAY                |    |    |    |    |    |    |    |    |
   176: 	 Straight 25  Door:             |    |    |    |    |    |    |    |    |
   177: 	No Bonus Coins                  |Off |Off |Off |Off |Off |Off | On |Off |
   178: 	Bonus 50 = 3 plays              |Off |Off | On |Off |Off |Off | On |Off |
   179: 	Bonus $1= 5 plays               |Off | On |Off |Off |Off |Off | On |Off |
   180: 	                                |    |    |    |    |    |    |    |    |
   181: 	 25 /$1 Door or 25 /25 /$1 Door |    |    |    |    |    |    |    |    |
   182: 	No Bonus Coins                  |Off |Off |Off |Off |Off | On | On |Off |
   183: 	Bonus 50 = 3 plays              |Off |Off | On |Off |Off | On | On |Off |
   184: 	Bonus $1= 5 plays               |Off | On |Off |Off |Off | On | On |Off |
   185: 	                                -----------------------------------------
   186: 
   187: 	Switch at position L11
   188: 	                                                      1    2    3    4
   189: 	                                                    _____________________
   190: 	All 3 mechs same denomination                       | On | On |    |    |
   191: 	Left and Center same, right different denomination  | On |Off |    |    |
   192: 	Right and Center same, left differnnt denomination  |Off | On |    |    |
   193: 	All different denominations                         |Off |Off |    |    |
   194:                                                     ---------------------
   195: 
   196: ***************************************************************************/
   197: 
   198: #include "driver.h" 
   199: #include "vidhrdw/generic.h" 
   200: #include "vidhrdw/vector.h" 
   201: #include "vidhrdw/avgdvg.h" 
   202: #include "machine/mathbox.h" 
   203: #include "machine/atari_vg.h" 
   204: #include "artwork.h" 
   205: #include "bzone.h" 
   206: 
   207: #define IN0_3KHZ (1<<7) 
   208: #define IN0_VG_HALT (1<<6) 
   209: 
   210: 
   211: UINT8 rb_input_select;
   212: 
   213: 
   214: 
   215: /*************************************
   216:  *
   217:  *	Interrupt handling
   218:  *
   219:  *************************************/
   220: 
   221: static INTERRUPT_GEN( bzone_interrupt )
   222: {
   223: 	if (readinputport(0) & 0x10)
   224: 		cpu_set_irq_line(0, IRQ_LINE_NMI, PULSE_LINE);
   225: }
   226: 
   227: 
   228: 
   229: /*************************************
   230:  *
   231:  *	Battlezone input ports
   232:  *
   233:  *************************************/
   234: 
   235: READ_HANDLER( bzone_IN0_r )
   236: {
   237: 	int res;
   238: 
   239: 	res = readinputport(0);
   240: 
   241: 	if (activecpu_gettotalcycles() & 0x100)
   242: 		res |= IN0_3KHZ;
   243: 	else
   244: 		res &= ~IN0_3KHZ;
   245: 
   246: 	if (avgdvg_done())
   247: 		res |= IN0_VG_HALT;
   248: 	else
   249: 		res &= ~IN0_VG_HALT;
   250: 
   251: 	return res;
   252: }
   253: 
   254: 
   255: /* Translation table for one-joystick emulation */
   256: static UINT8 one_joy_trans[] =
   257: {
   258: 	0x00,0x0A,0x05,0x00,0x06,0x02,0x01,0x00,
   259: 	0x09,0x08,0x04,0x00,0x00,0x00,0x00,0x00
   260: };
   261: 
   262: static READ_HANDLER( bzone_IN3_r )
   263: {
   264: 	int res,res1;
   265: 
   266: 	res=readinputport(3);
   267: 	res1=readinputport(4);
   268: 
   269: 	res |= one_joy_trans[res1 & 0x0f];
   270: 
   271: 	return (res);
   272: }
   273: 
   274: 
   275: static WRITE_HANDLER( bzone_coin_counter_w )
   276: {
   277: 	coin_counter_w(offset,data);
   278: }
   279: 
   280: 
   281: 
   282: /*************************************
   283:  *
   284:  *	Red Baron input ports
   285:  *
   286:  *************************************/
   287: 
   288: static READ_HANDLER( redbaron_joy_r )
   289: {
   290: 	return readinputport(rb_input_select ? 5 : 6);
   291: }
   292: 
   293: 
   294: 
   295: /*************************************
   296:  *
   297:  *	Battle Zone overlay
   298:  *
   299:  *************************************/
   300: 
   301: OVERLAY_START( bzone_overlay )
   302: 	OVERLAY_RECT( 0.0, 0.0, 1.0, 0.2, MAKE_ARGB(0x04,0xff,0x20,0x20) )
   303: 	OVERLAY_RECT( 0.0, 0.2, 1.0, 1.0, MAKE_ARGB(0x04,0x20,0xff,0x20) )
   304: OVERLAY_END
   305: 
   306: 
   307: 
   308: /*************************************
   309:  *
   310:  *	Main CPU memory handlers
   311:  *
   312:  *************************************/
   313: 
   314: static MEMORY_READ_START( bzone_readmem )
   315: 	{ 0x0000, 0x03ff, MRA_RAM },
   316: 	{ 0x0800, 0x0800, bzone_IN0_r },    /* IN0 */
   317: 	{ 0x0a00, 0x0a00, input_port_1_r },	/* DSW1 */
   318: 	{ 0x0c00, 0x0c00, input_port_2_r },	/* DSW2 */
   319: 	{ 0x1800, 0x1800, mb_status_r },
   320: 	{ 0x1810, 0x1810, mb_lo_r },
   321: 	{ 0x1818, 0x1818, mb_hi_r },
   322: 	{ 0x1820, 0x182f, pokey1_r },
   323: 	{ 0x2000, 0x2fff, MRA_RAM },
   324: 	{ 0x3000, 0x3fff, MRA_ROM },
   325: 	{ 0x4000, 0x7fff, MRA_ROM },
   326: 	{ 0xf800, 0xffff, MRA_ROM },        /* for the reset / interrupt vectors */
   327: MEMORY_END
   328: 
   329: 
   330: static MEMORY_WRITE_START( bzone_writemem )
   331: 	{ 0x0000, 0x03ff, MWA_RAM },
   332: 	{ 0x1000, 0x1000, bzone_coin_counter_w },
   333: 	{ 0x1200, 0x1200, avgdvg_go_w },
   334: 	{ 0x1400, 0x1400, watchdog_reset_w },
   335: 	{ 0x1600, 0x1600, avgdvg_reset_w },
   336: 	{ 0x1820, 0x182f, pokey1_w },
   337: 	{ 0x1840, 0x1840, bzone_sounds_w },
   338: 	{ 0x1860, 0x187f, mb_go_w },
   339: 	{ 0x2000, 0x2fff, MWA_RAM, &vectorram, &vectorram_size },
   340: 	{ 0x3000, 0x3fff, MWA_ROM },
   341: 	{ 0x4000, 0x7fff, MWA_ROM },
   342: MEMORY_END
   343: 
   344: 
   345: static MEMORY_READ_START( redbaron_readmem )
   346: 	{ 0x0000, 0x03ff, MRA_RAM },
   347: 	{ 0x0800, 0x0800, bzone_IN0_r },    /* IN0 */
   348: 	{ 0x0a00, 0x0a00, input_port_1_r },	/* DSW1 */
   349: 	{ 0x0c00, 0x0c00, input_port_2_r },	/* DSW2 */
   350: 	{ 0x1800, 0x1800, mb_status_r },
   351: 	{ 0x1802, 0x1802, input_port_4_r },	/* IN4 */
   352: 	{ 0x1804, 0x1804, mb_lo_r },
   353: 	{ 0x1806, 0x1806, mb_hi_r },
   354: 	{ 0x1810, 0x181f, pokey1_r },
   355: 	{ 0x1820, 0x185f, atari_vg_earom_r },
   356: 	{ 0x2000, 0x2fff, MRA_RAM },
   357: 	{ 0x3000, 0x3fff, MRA_ROM },
   358: 	{ 0x5000, 0x7fff, MRA_ROM },
   359: 	{ 0xf800, 0xffff, MRA_ROM },        /* for the reset / interrupt vectors */
   360: MEMORY_END
   361: 
   362: 
   363: static MEMORY_WRITE_START( redbaron_writemem )
   364: 	{ 0x0000, 0x03ff, MWA_RAM },
   365: 	{ 0x1000, 0x1000, MWA_NOP },			/* coin out */
   366: 	{ 0x1200, 0x1200, avgdvg_go_w },
   367: 	{ 0x1400, 0x1400, watchdog_reset_w },
   368: 	{ 0x1600, 0x1600, avgdvg_reset_w },
   369: 	{ 0x1808, 0x1808, redbaron_sounds_w },	/* and select joystick pot also */
   370: 	{ 0x180a, 0x180a, MWA_NOP },			/* sound reset, yet todo */
   371: 	{ 0x180c, 0x180c, atari_vg_earom_ctrl_w },
   372: 	{ 0x1810, 0x181f, pokey1_w },
   373: 	{ 0x1820, 0x185f, atari_vg_earom_w },
   374: 	{ 0x1860, 0x187f, mb_go_w },
   375: 	{ 0x2000, 0x2fff, MWA_RAM, &vectorram, &vectorram_size },
   376: 	{ 0x3000, 0x3fff, MWA_ROM },
   377: 	{ 0x5000, 0x7fff, MWA_ROM },
   378: MEMORY_END
   379: 
   380: 
   381: 
   382: /*************************************
   383:  *
   384:  *	Port definitions
   385:  *
   386:  *************************************/
   387: 
   388: INPUT_PORTS_START( bzone )
   389: 	PORT_START	/* IN0 */
   390: 	PORT_BIT ( 0x01, IP_ACTIVE_LOW, IPT_COIN1 )
   391: 	PORT_BIT ( 0x02, IP_ACTIVE_LOW, IPT_COIN2 )
   392: 	PORT_BIT ( 0x0c, IP_ACTIVE_LOW, IPT_UNUSED )
   393: 	PORT_SERVICE( 0x10, IP_ACTIVE_LOW )
   394: 	PORT_BITX( 0x20, IP_ACTIVE_LOW, IPT_SERVICE, "Diagnostic Step", KEYCODE_F1, IP_JOY_NONE )
   395: 	/* bit 6 is the VG HALT bit. We set it to "low" */
   396: 	/* per default (busy vector processor). */
   397:  	/* handled by bzone_IN0_r() */
   398: 	PORT_BIT ( 0x40, IP_ACTIVE_HIGH, IPT_SPECIAL )
   399: 	/* bit 7 is tied to a 3kHz clock */
   400:  	/* handled by bzone_IN0_r() */
   401: 	PORT_BIT ( 0x80, IP_ACTIVE_HIGH, IPT_SPECIAL )
   402: 
   403: 	PORT_START	/* DSW0 */
   404: 	PORT_DIPNAME(0x03, 0x01, DEF_STR( Lives ) )
   405: 	PORT_DIPSETTING (  0x00, "2" )
   406: 	PORT_DIPSETTING (  0x01, "3" )
   407: 	PORT_DIPSETTING (  0x02, "4" )
   408: 	PORT_DIPSETTING (  0x03, "5" )
   409: 	PORT_DIPNAME(0x0c, 0x04, "Missile appears at" )
   410: 	PORT_DIPSETTING (  0x00, "5000" )
   411: 	PORT_DIPSETTING (  0x04, "10000" )
   412: 	PORT_DIPSETTING (  0x08, "20000" )
   413: 	PORT_DIPSETTING (  0x0c, "30000" )
   414: 	PORT_DIPNAME(0x30, 0x10, DEF_STR( Bonus_Life ) )
   415: 	PORT_DIPSETTING (  0x10, "15k and 100k" )
   416: 	PORT_DIPSETTING (  0x20, "20k and 100k" )
   417: 	PORT_DIPSETTING (  0x30, "50k and 100k" )
   418: 	PORT_DIPSETTING (  0x00, "None" )
   419: 	PORT_DIPNAME(0xc0, 0x00, "Language" )
   420: 	PORT_DIPSETTING (  0x00, "English" )
   421: 	PORT_DIPSETTING (  0x40, "German" )
   422: 	PORT_DIPSETTING (  0x80, "French" )
   423: 	PORT_DIPSETTING (  0xc0, "Spanish" )
   424: 
   425: 	PORT_START	/* DSW1 */
   426: 	PORT_DIPNAME(0x03, 0x02, DEF_STR( Coinage ) )
   427: 	PORT_DIPSETTING (  0x03, DEF_STR( 2C_1C ) )
   428: 	PORT_DIPSETTING (  0x02, DEF_STR( 1C_1C ) )
   429: 	PORT_DIPSETTING (  0x01, DEF_STR( 1C_2C ) )
   430: 	PORT_DIPSETTING (  0x00, DEF_STR( Free_Play ) )
   431: 	PORT_DIPNAME(0x0c, 0x00, DEF_STR( Coin_B ) )
   432: 	PORT_DIPSETTING (  0x00, "*1" )
   433: 	PORT_DIPSETTING (  0x04, "*4" )
   434: 	PORT_DIPSETTING (  0x08, "*5" )
   435: 	PORT_DIPSETTING (  0x0c, "*6" )
   436: 	PORT_DIPNAME(0x10, 0x00, DEF_STR( Coin_A ) )
   437: 	PORT_DIPSETTING (  0x00, "*1" )
   438: 	PORT_DIPSETTING (  0x10, "*2" )
   439: 	PORT_DIPNAME(0xe0, 0x00, "Bonus Coins" )
   440: 	PORT_DIPSETTING (  0x00, "None" )
   441: 	PORT_DIPSETTING (  0x20, "3 credits/2 coins" )
   442: 	PORT_DIPSETTING (  0x40, "5 credits/4 coins" )
   443: 	PORT_DIPSETTING (  0x60, "6 credits/4 coins" )
   444: 	PORT_DIPSETTING (  0x80, "6 credits/5 coins" )
   445: 
   446: 	PORT_START	/* IN3 */
   447: 	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_JOYSTICKRIGHT_DOWN | IPF_2WAY )
   448: 	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_JOYSTICKRIGHT_UP   | IPF_2WAY )
   449: 	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_JOYSTICKLEFT_DOWN  | IPF_2WAY )
   450: 	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_JOYSTICKLEFT_UP    | IPF_2WAY )
   451: 	PORT_BIT( 0x10, IP_ACTIVE_HIGH, IPT_BUTTON3 )
   452: 	PORT_BIT( 0x20, IP_ACTIVE_HIGH, IPT_START1 )
   453: 	PORT_BIT( 0x40, IP_ACTIVE_HIGH, IPT_START2 )
   454: 	PORT_BIT( 0x80, IP_ACTIVE_HIGH, IPT_UNUSED )
   455: 
   456: 	PORT_START	/* fake port for single joystick control */
   457: 	/* This fake port is handled via bzone_IN3_r */
   458: 	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_JOYSTICK_UP    | IPF_8WAY | IPF_CHEAT )
   459: 	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_JOYSTICK_DOWN  | IPF_8WAY | IPF_CHEAT )
   460: 	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_JOYSTICK_LEFT  | IPF_8WAY | IPF_CHEAT )
   461: 	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_JOYSTICK_RIGHT | IPF_8WAY | IPF_CHEAT )
   462: 	PORT_BIT( 0x10, IP_ACTIVE_HIGH, IPT_BUTTON1 | IPF_CHEAT )
   463: INPUT_PORTS_END
   464: 
   465: 
   466: INPUT_PORTS_START( redbaron )
   467: 	PORT_START	/* IN0 */
   468: 	PORT_BIT ( 0x01, IP_ACTIVE_LOW, IPT_COIN1)
   469: 	PORT_BIT ( 0x02, IP_ACTIVE_LOW, IPT_COIN2)
   470: 	PORT_BIT ( 0x0c, IP_ACTIVE_LOW, IPT_UNUSED)
   471: 	PORT_SERVICE( 0x10, IP_ACTIVE_LOW )
   472: 	PORT_BITX( 0x20, IP_ACTIVE_LOW, IPT_SERVICE, "Diagnostic Step", KEYCODE_F1, IP_JOY_NONE )
   473: 	/* bit 6 is the VG HALT bit. We set it to "low" */
   474: 	/* per default (busy vector processor). */
   475:  	/* handled by bzone_IN0_r() */
   476: 	PORT_BIT ( 0x40, IP_ACTIVE_HIGH, IPT_SPECIAL )
   477: 	/* bit 7 is tied to a 3kHz clock */
   478:  	/* handled by bzone_IN0_r() */
   479: 	PORT_BIT ( 0x80, IP_ACTIVE_HIGH, IPT_SPECIAL )
   480: 
   481: 	PORT_START	/* DSW0 */
   482: 	/* See the table above if you are really interested */
   483: 	PORT_DIPNAME(0xff, 0xfd, DEF_STR( Coinage ) )
   484: 	PORT_DIPSETTING (  0xfd, "Normal" )
   485: 
   486: 	PORT_START	/* DSW1 */
   487: 	PORT_DIPNAME(0x03, 0x03, "Language" )
   488: 	PORT_DIPSETTING (  0x00, "German" )
   489: 	PORT_DIPSETTING (  0x01, "French" )
   490: 	PORT_DIPSETTING (  0x02, "Spanish" )
   491: 	PORT_DIPSETTING (  0x03, "English" )
   492: 	PORT_DIPNAME(0x0c, 0x04, DEF_STR( Bonus_Life ) )
   493: 	PORT_DIPSETTING (  0x0c, "2k 10k 30k" )
   494: 	PORT_DIPSETTING (  0x08, "4k 15k 40k" )
   495: 	PORT_DIPSETTING (  0x04, "6k 20k 50k" )
   496: 	PORT_DIPSETTING (  0x00, "None" )
   497: 	PORT_DIPNAME(0x30, 0x20, DEF_STR( Lives ) )
   498: 	PORT_DIPSETTING (  0x30, "2" )
   499: 	PORT_DIPSETTING (  0x20, "3" )
   500: 	PORT_DIPSETTING (  0x10, "4" )
   501: 	PORT_DIPSETTING (  0x00, "5" )
   502: 	PORT_DIPNAME(0x40, 0x40, "One Play Minimum" )
   503: 	PORT_DIPSETTING (  0x40, DEF_STR( Off ) )
   504: 	PORT_DIPSETTING (  0x00, DEF_STR( On ) )
   505: 	PORT_DIPNAME(0x80, 0x80, "Self Adjust Diff" )
   506: 	PORT_DIPSETTING (  0x80, DEF_STR( Off ) )
   507: 	PORT_DIPSETTING (  0x00, DEF_STR( On ) )
   508: 
   509: 	/* IN3 - the real machine reads either the X or Y axis from this port */
   510: 	/* Instead, we use the two fake 5 & 6 ports and bank-switch the proper */
   511: 	/* value based on the lsb of the byte written to the sound port */
   512: 	PORT_START
   513: 	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_JOYSTICK_LEFT | IPF_4WAY )
   514: 	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_JOYSTICK_RIGHT | IPF_4WAY )
   515: 	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_JOYSTICK_UP | IPF_4WAY )
   516: 	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_JOYSTICK_DOWN | IPF_4WAY )
   517: 
   518: 	PORT_START	/* IN4 - misc controls */
   519: 	PORT_BIT( 0x3f, IP_ACTIVE_HIGH, IPT_UNKNOWN )
   520: 	PORT_BIT( 0x40, IP_ACTIVE_HIGH, IPT_START1 )
   521: 	PORT_BIT( 0x80, IP_ACTIVE_HIGH, IPT_BUTTON1 )
   522: 
   523: 	/* These 2 are fake - they are bank-switched from reads to IN3 */
   524: 	/* Red Baron doesn't seem to use the full 0-255 range. */
   525: 	PORT_START	/* IN5 */
   526: 	PORT_ANALOG( 0xff, 0x80, IPT_AD_STICK_X, 25, 10, 64, 192 )
   527: 
   528: 	PORT_START	/* IN6 */
   529: 	PORT_ANALOG( 0xff, 0x80, IPT_AD_STICK_Y, 25, 10, 64, 192 )
   530: INPUT_PORTS_END
   531: 
   532: 
   533: INPUT_PORTS_START( bradley )
   534: 	PORT_START	/* IN0 */
   535: 	PORT_BIT ( 0x01, IP_ACTIVE_LOW, IPT_COIN1 )
   536: 	PORT_BIT ( 0x02, IP_ACTIVE_LOW, IPT_COIN2 )
   537: 	PORT_BIT ( 0x0c, IP_ACTIVE_LOW, IPT_UNUSED )
   538: 	PORT_SERVICE( 0x10, IP_ACTIVE_LOW )
   539: 	PORT_BITX( 0x20, IP_ACTIVE_LOW, IPT_SERVICE, "Diagnostic Step", KEYCODE_F1, IP_JOY_NONE )
   540: 	/* bit 6 is the VG HALT bit. We set it to "low" */
   541: 	/* per default (busy vector processor). */
   542:  	/* handled by bzone_IN0_r() */
   543: 	PORT_BIT ( 0x40, IP_ACTIVE_HIGH, IPT_SPECIAL )
   544: 	/* bit 7 is tied to a 3kHz clock */
   545:  	/* handled by bzone_IN0_r() */
   546: 	PORT_BIT ( 0x80, IP_ACTIVE_HIGH, IPT_SPECIAL )
   547: 
   548: 	PORT_START	/* DSW0 */
   549: 	PORT_DIPNAME(0x03, 0x01, DEF_STR( Lives ) )
   550: 	PORT_DIPSETTING (  0x00, "2" )
   551: 	PORT_DIPSETTING (  0x01, "3" )
   552: 	PORT_DIPSETTING (  0x02, "4" )
   553: 	PORT_DIPSETTING (  0x03, "5" )
   554: 	PORT_DIPNAME(0x0c, 0x04, "Missile appears at" )
   555: 	PORT_DIPSETTING (  0x00, "5000" )
   556: 	PORT_DIPSETTING (  0x04, "10000" )
   557: 	PORT_DIPSETTING (  0x08, "20000" )
   558: 	PORT_DIPSETTING (  0x0c, "30000" )
   559: 	PORT_DIPNAME(0x30, 0x10, DEF_STR( Bonus_Life ) )
   560: 	PORT_DIPSETTING (  0x10, "15k and 100k" )
   561: 	PORT_DIPSETTING (  0x20, "20k and 100k" )
   562: 	PORT_DIPSETTING (  0x30, "50k and 100k" )
   563: 	PORT_DIPSETTING (  0x00, "None" )
   564: 	PORT_DIPNAME(0xc0, 0x00, "Language" )
   565: 	PORT_DIPSETTING (  0x00, "English" )
   566: 	PORT_DIPSETTING (  0x40, "German" )
   567: 	PORT_DIPSETTING (  0x80, "French" )
   568: 	PORT_DIPSETTING (  0xc0, "Spanish" )
   569: 
   570: 	PORT_START	/* DSW1 */
   571: 	PORT_DIPNAME(0x03, 0x02, DEF_STR( Coinage ) )
   572: 	PORT_DIPSETTING (  0x03, DEF_STR( 2C_1C ) )
   573: 	PORT_DIPSETTING (  0x02, DEF_STR( 1C_1C ) )
   574: 	PORT_DIPSETTING (  0x01, DEF_STR( 1C_2C ) )
   575: 	PORT_DIPSETTING (  0x00, DEF_STR( Free_Play ) )
   576: 	PORT_DIPNAME(0x0c, 0x00, DEF_STR( Coin_B ) )
   577: 	PORT_DIPSETTING (  0x00, "*1" )
   578: 	PORT_DIPSETTING (  0x04, "*4" )
   579: 	PORT_DIPSETTING (  0x08, "*5" )
   580: 	PORT_DIPSETTING (  0x0c, "*6" )
   581: 	PORT_DIPNAME(0x10, 0x00, DEF_STR( Coin_A ) )
   582: 	PORT_DIPSETTING (  0x00, "*1" )
   583: 	PORT_DIPSETTING (  0x10, "*2" )
   584: 	PORT_DIPNAME(0xe0, 0x00, "Bonus Coins" )
   585: 	PORT_DIPSETTING (  0x00, "None" )
   586: 	PORT_DIPSETTING (  0x20, "3 credits/2 coins" )
   587: 	PORT_DIPSETTING (  0x40, "5 credits/4 coins" )
   588: 	PORT_DIPSETTING (  0x60, "6 credits/4 coins" )
   589: 	PORT_DIPSETTING (  0x80, "6 credits/5 coins" )
   590: 
   591: 	PORT_START	/* IN3 */
   592: 	PORT_BIT( 0x1f, IP_ACTIVE_HIGH, IPT_UNUSED )
   593: 	PORT_BIT( 0x20, IP_ACTIVE_HIGH, IPT_START1 )
   594: 	PORT_BIT( 0xc0, IP_ACTIVE_HIGH, IPT_UNUSED )
   595: 
   596: 	PORT_START	/* 1808 */
   597: 	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_UNUSED )
   598: 	PORT_BIT( 0x02, IP_ACTIVE_LOW, IPT_BUTTON1 )
   599: 	PORT_BITX( 0x04, IP_ACTIVE_LOW, IPT_BUTTON2, "Armor Piercing, Single Shot", KEYCODE_A, IP_JOY_DEFAULT )
   600: 	PORT_BITX( 0x08, IP_ACTIVE_LOW, IPT_BUTTON3, "High Explosive, Single Shot", KEYCODE_Z, IP_JOY_DEFAULT )
   601: 	PORT_BITX( 0x10, IP_ACTIVE_LOW, IPT_BUTTON4, "Armor Piercing, Low Rate", KEYCODE_S, IP_JOY_DEFAULT )
   602: 	PORT_BITX( 0x20, IP_ACTIVE_LOW, IPT_BUTTON5, "High Explosive, Low Rate", KEYCODE_X, IP_JOY_DEFAULT )
   603: 	PORT_BITX( 0x40, IP_ACTIVE_LOW, IPT_BUTTON6, "Armor Piercing, High Rate", KEYCODE_D, IP_JOY_DEFAULT )
   604: 	PORT_BITX( 0x80, IP_ACTIVE_LOW, IPT_BUTTON7, "High Explosive, High Rate", KEYCODE_C, IP_JOY_DEFAULT )
   605: 
   606: 	PORT_START	/* 1809 */
   607: 	PORT_BIT( 0x03, IP_ACTIVE_HIGH, IPT_UNUSED )
   608: 	PORT_BITX( 0x04, IP_ACTIVE_LOW, IPT_BUTTON9, "Select TOW Missiles", KEYCODE_T, IP_JOY_DEFAULT )
   609: 	PORT_BITX( 0x08, IP_ACTIVE_LOW, IPT_BUTTON8, "7.62 mm Machine Gun", KEYCODE_V, IP_JOY_DEFAULT )
   610: 	PORT_BITX( 0x10, IP_ACTIVE_LOW, IPT_BUTTON10 | IPF_TOGGLE, "Magnification Toggle", KEYCODE_M, IP_JOY_DEFAULT )
   611: 	PORT_BIT( 0xe0, IP_ACTIVE_HIGH, IPT_UNUSED )
   612: 
   613: 	PORT_START	/* analog 0 = turret rotation */
   614: 	PORT_ANALOG( 0xff, 0x88, IPT_AD_STICK_X, 25, 10, 0x48, 0xc8 )
   615: 
   616: 	PORT_START	/* analog 1 = turret elevation */
   617: 	PORT_ANALOG( 0xff, 0x86, IPT_AD_STICK_Y, 25, 10, 0x46, 0xc6 )
   618: 
   619: 	PORT_START	/* analog 2 = shell firing range */
   620: 	PORT_ANALOG( 0xff, 0x80, IPT_AD_STICK_Y | IPF_PLAYER2 | IPF_REVERSE, 25, 10, 0x10, 0xf0 )
   621: INPUT_PORTS_END
   622: 
   623: 
   624: 
   625: /*************************************
   626:  *
   627:  *	Sound interfaces
   628:  *
   629:  *************************************/
   630: 
   631: static struct POKEYinterface bzone_pokey_interface =
   632: {
   633: 	1,	/* 1 chip */
   634: 	1500000,	/* 1.5 MHz??? */
   635: 	{ 100 },
   636: 	/* The 8 pot handlers */
   637: 	{ 0 },
   638: 	{ 0 },
   639: 	{ 0 },
   640: 	{ 0 },
   641: 	{ 0 },
   642: 	{ 0 },
   643: 	{ 0 },
   644: 	{ 0 },
   645: 	/* The allpot handler */
   646: 	{ bzone_IN3_r },
   647: };
   648: 
   649: 
   650: static struct POKEYinterface bradley_pokey_interface =
   651: {
   652: 	1,	/* 1 chip */
   653: 	1500000,	/* 1.5 MHz??? */
   654: 	{ 100 },
   655: 	/* The 8 pot handlers */
   656: 	{ 0 },
   657: 	{ 0 },
   658: 	{ 0 },
   659: 	{ 0 },
   660: 	{ 0 },
   661: 	{ 0 },
   662: 	{ 0 },
   663: 	{ 0 },
   664: 	/* The allpot handler */
   665: 	{ input_port_3_r },
   666: };
   667: 
   668: 
   669: static struct CustomSound_interface bzone_custom_interface =
   670: {
   671: 	bzone_sh_start,
   672: 	bzone_sh_stop,
   673: 	bzone_sh_update
   674: };
   675: 
   676: 
   677: static struct POKEYinterface redbaron_pokey_interface =
   678: {
   679: 	1,	/* 1 chip */
   680: 	1500000,	/* 1.5 MHz??? */
   681: 	{ 100 },
   682: 	/* The 8 pot handlers */
   683: 	{ 0 },
   684: 	{ 0 },
   685: 	{ 0 },
   686: 	{ 0 },
   687: 	{ 0 },
   688: 	{ 0 },
   689: 	{ 0 },
   690: 	{ 0 },
   691: 	/* The allpot handler */
   692: 	{ redbaron_joy_r },
   693: };
   694: 
   695: 
   696: static struct CustomSound_interface redbaron_custom_interface =
   697: {
   698: 	redbaron_sh_start,
   699: 	redbaron_sh_stop,
   700: 	redbaron_sh_update
   701: };
   702: 
   703: 
   704: 
   705: /*************************************
   706:  *
   707:  *	Machine driver
   708:  *
   709:  *************************************/
   710: 
   711: static MACHINE_DRIVER_START( bzone )
   712: 
   713: 	/* basic machine hardware */
   714: 	MDRV_CPU_ADD_TAG("main", M6502, 1500000)
   715: 	MDRV_CPU_MEMORY(bzone_readmem,bzone_writemem)
   716: 	MDRV_CPU_VBLANK_INT(bzone_interrupt,6) /* 4.1ms */
   717: 
   718: 	MDRV_FRAMES_PER_SECOND(40)
   719: 
   720: 	/* video hardware */
   721: 	MDRV_VIDEO_ATTRIBUTES(VIDEO_TYPE_VECTOR | VIDEO_RGB_DIRECT)
   722: 	MDRV_SCREEN_SIZE(400, 300)
   723: 	MDRV_VISIBLE_AREA(0, 580, 0, 400)
   724: 	MDRV_PALETTE_LENGTH(32768)
   725: 
   726: 	MDRV_PALETTE_INIT(avg_white)
   727: 	MDRV_VIDEO_START(avg_bzone)
   728: 	MDRV_VIDEO_UPDATE(vector)
   729: 
   730: 	/* sound hardware */
   731: 	MDRV_SOUND_ADD_TAG("pokey",  POKEY,  bzone_pokey_interface)
   732: 	MDRV_SOUND_ADD_TAG("custom", CUSTOM, bzone_custom_interface)
   733: MACHINE_DRIVER_END
   734: 
   735: 
   736: static MACHINE_DRIVER_START( bradley )
   737: 
   738: 	/* basic machine hardware */
   739: 	MDRV_IMPORT_FROM(bzone)
   740: 
   741: 	/* sound hardware */
   742: 	MDRV_SOUND_REPLACE("pokey",  POKEY,  bradley_pokey_interface)
   743: MACHINE_DRIVER_END
   744: 
   745: 
   746: static MACHINE_DRIVER_START( redbaron )
   747: 
   748: 	/* basic machine hardware */
   749: 	MDRV_IMPORT_FROM(bzone)
   750: 	MDRV_CPU_MODIFY("main")
   751: 	MDRV_CPU_MEMORY(redbaron_readmem,redbaron_writemem)
   752: 	MDRV_CPU_VBLANK_INT(bzone_interrupt,4) /* 5.4ms */
   753: 
   754: 	MDRV_FRAMES_PER_SECOND(45)
   755: 	MDRV_NVRAM_HANDLER(atari_vg)
   756: 
   757: 	/* video hardware */
   758: 	MDRV_VISIBLE_AREA(0, 520, 0, 400)
   759: 
   760: 	MDRV_VIDEO_START(avg_redbaron)
   761: 
   762: 	/* sound hardware */
   763: 	MDRV_SOUND_REPLACE("pokey",  POKEY,  redbaron_pokey_interface)
   764: 	MDRV_SOUND_REPLACE("custom", CUSTOM, redbaron_custom_interface)
   765: MACHINE_DRIVER_END
   766: 
   767: 
   768: 
   769: /*************************************
   770:  *
   771:  *	ROM definitions
   772:  *
   773:  *************************************/
   774: 
   775: ROM_START( bzone )
   776: 	ROM_REGION( 0x10000, REGION_CPU1, 0 )	/* 64k for code */
   777: 	ROM_LOAD( "036414.01",  0x5000, 0x0800, CRC(efbc3fa0) SHA1(6d284fab34b09dde8aa0df7088711d4723f07970) )
   778: 	ROM_LOAD( "036413.01",  0x5800, 0x0800, CRC(5d9d9111) SHA1(42638cff53a9791a0f18d316f62a0ea8eea4e194) )
   779: 	ROM_LOAD( "036412.01",  0x6000, 0x0800, CRC(ab55cbd2) SHA1(6bbb8316d9f8588ea0893932f9174788292b8edc) )
   780: 	ROM_LOAD( "036411.01",  0x6800, 0x0800, CRC(ad281297) SHA1(54c5e06b2e69eb731a6c9b1704e4340f493e7ea5) )
   781: 	ROM_LOAD( "036410.01",  0x7000, 0x0800, CRC(0b7bfaa4) SHA1(33ae0f68b4e2eae9f3aecbee2d0b29003ce460b2) )
   782: 	ROM_LOAD( "036409.01",  0x7800, 0x0800, CRC(1e14e919) SHA1(448fab30535e6fad7e0ab4427bc06bbbe075e797) )
   783: 	ROM_RELOAD(             0xf800, 0x0800 )	/* for reset/interrupt vectors */
   784: 	/* Mathbox ROMs */
   785: 	ROM_LOAD( "036422.01",  0x3000, 0x0800, CRC(7414177b) SHA1(147d97a3b475e738ce00b1a7909bbd787ad06eda) )
   786: 	ROM_LOAD( "036421.01",  0x3800, 0x0800, CRC(8ea8f939) SHA1(b71e0ab0e220c3e64dc2b094c701fb1a960b64e4) )
   787: ROM_END
   788: 
   789: 
   790: ROM_START( bzone2 )
   791: 	ROM_REGION( 0x10000, REGION_CPU1, 0 )	/* 64k for code */
   792: 	ROM_LOAD( "036414a.01", 0x5000, 0x0800, CRC(13de36d5) SHA1(40e356ddc5c042bc1ce0b71f51e8b6de72daf1e4) )
   793: 	ROM_LOAD( "036413.01",  0x5800, 0x0800, CRC(5d9d9111) SHA1(42638cff53a9791a0f18d316f62a0ea8eea4e194) )
   794: 	ROM_LOAD( "036412.01",  0x6000, 0x0800, CRC(ab55cbd2) SHA1(6bbb8316d9f8588ea0893932f9174788292b8edc) )
   795: 	ROM_LOAD( "036411.01",  0x6800, 0x0800, CRC(ad281297) SHA1(54c5e06b2e69eb731a6c9b1704e4340f493e7ea5) )
   796: 	ROM_LOAD( "036410.01",  0x7000, 0x0800, CRC(0b7bfaa4) SHA1(33ae0f68b4e2eae9f3aecbee2d0b29003ce460b2) )
   797: 	ROM_LOAD( "036409.01",  0x7800, 0x0800, CRC(1e14e919) SHA1(448fab30535e6fad7e0ab4427bc06bbbe075e797) )
   798: 	ROM_RELOAD(             0xf800, 0x0800 )	/* for reset/interrupt vectors */
   799: 	/* Mathbox ROMs */
   800: 	ROM_LOAD( "036422.01",  0x3000, 0x0800, CRC(7414177b) SHA1(147d97a3b475e738ce00b1a7909bbd787ad06eda) )
   801: 	ROM_LOAD( "036421.01",  0x3800, 0x0800, CRC(8ea8f939) SHA1(b71e0ab0e220c3e64dc2b094c701fb1a960b64e4) )
   802: ROM_END
   803: 
   804: 
   805: ROM_START( bzonec ) /* cocktail version */
   806: 	ROM_REGION( 0x10000, REGION_CPU1, 0 )	/* 64k for code */
   807: 	ROM_LOAD( "bz1g4800",   0x4800, 0x0800, CRC(e228dd64) SHA1(247c788b4ccadf6c1e9201ad4f31d55c0036ff0f) )
   808: 	ROM_LOAD( "bz1f5000",   0x5000, 0x0800, CRC(dddfac9a) SHA1(e6f2761902e1ffafba437a1117e9ba40f116087d) )
   809: 	ROM_LOAD( "bz1e5800",   0x5800, 0x0800, CRC(7e00e823) SHA1(008e491a8074dac16e56c3aedec32d4b340158ce) )
   810: 	ROM_LOAD( "bz1d6000",   0x6000, 0x0800, CRC(c0f8c068) SHA1(66fff6b493371f0015c21b06b94637db12deced2) )
   811: 	ROM_LOAD( "bz1c6800",   0x6800, 0x0800, CRC(5adc64bd) SHA1(4574e4fe375d4ab3151a988235efa11e8744e2c6) )
   812: 	ROM_LOAD( "bz1b7000",   0x7000, 0x0800, CRC(ed8a860e) SHA1(316a3c4870ba44bb3e9cb9fc5200eb081318facf) )
   813: 	ROM_LOAD( "bz1a7800",   0x7800, 0x0800, CRC(04babf45) SHA1(a59da5ff49fc398ca4a948e28f05250af776b898) )
   814: 	ROM_RELOAD(             0xf800, 0x0800 )	/* for reset/interrupt vectors */
   815: 	/* Mathbox ROMs */
   816: 	ROM_LOAD( "036422.01",  0x3000, 0x0800, CRC(7414177b) SHA1(147d97a3b475e738ce00b1a7909bbd787ad06eda) )	// bz3a3000
   817: 	ROM_LOAD( "bz3b3800",   0x3800, 0x0800, CRC(76cf57f6) SHA1(1b8f3fcd664ed04ce60d94fdf27e56b20d52bdbd) )
   818: ROM_END
   819: 
   820: 
   821: ROM_START( bradley )
   822: 	ROM_REGION( 0x10000, REGION_CPU1, 0 )	/* 64k for code */
   823: 	ROM_LOAD( "btc1.bin",   0x4000, 0x0800, CRC(0bb8e049) SHA1(158517ff9a4e8ae7270ccf7eab87bf77427a4a8c) )
   824: 	ROM_LOAD( "btd1.bin",   0x4800, 0x0800, CRC(9e0566d4) SHA1(f14aa5c3d14136c5e9a317004f82d44a8d5d6815) )
   825: 	ROM_LOAD( "bte1.bin",   0x5000, 0x0800, CRC(64ee6a42) SHA1(33d0713ed2a1f4c1c443dce1f053321f2c279293) )
   826: 	ROM_LOAD( "bth1.bin",   0x5800, 0x0800, CRC(baab67be) SHA1(77ad1935bf252b401bb6bbb57bd2ed66a85f0a6d) )
   827: 	ROM_LOAD( "btj1.bin",   0x6000, 0x0800, CRC(036adde4) SHA1(16a9fcf98a2aa287e0b7a665b88c9c67377a1203) )
   828: 	ROM_LOAD( "btk1.bin",   0x6800, 0x0800, CRC(f5c2904e) SHA1(f2cbf720c4f5ce0fc912dbc2f0445cb2c51ffac1) )
   829: 	ROM_LOAD( "btlm.bin",   0x7000, 0x0800, CRC(7d0313bf) SHA1(17e3d8df62b332cf889133f1943c8f27308df027) )
   830: 	ROM_LOAD( "btn1.bin",   0x7800, 0x0800, CRC(182c8c64) SHA1(511af60d86551291d2dc28442970b4863c62624a) )
   831: 	ROM_RELOAD(             0xf800, 0x0800 )	/* for reset/interrupt vectors */
   832: 	/* Mathbox ROMs */
   833: 	ROM_LOAD( "btb3.bin",   0x3000, 0x0800, CRC(88206304) SHA1(6a2e2ff35a929acf460f244db7968f3978b1d239) )
   834: 	ROM_LOAD( "bta3.bin",   0x3800, 0x0800, CRC(d669d796) SHA1(ad606882320cd13612c7962d4718680fe5a35dd3) )
   835: ROM_END
   836: 
   837: 
   838: ROM_START( redbaron )
   839: 	ROM_REGION( 0x10000, REGION_CPU1, 0 )	/* 64k for code */
   840: 	ROM_LOAD( "037587.01",  0x4800, 0x0800, CRC(60f23983) SHA1(7a9e5380bf49bf50a2d8ab0e0bd1ba3ac8efde24) )
   841: 	ROM_CONTINUE(           0x5800, 0x0800 )
   842: 	ROM_LOAD( "037000.01e", 0x5000, 0x0800, CRC(69bed808) SHA1(27d99efc74113cdcbbf021734b8a5a5fdb78c04c) )
   843: 	ROM_LOAD( "036998.01e", 0x6000, 0x0800, CRC(d1104dd7) SHA1(0eab47cb45ede9dcc4dd7498dcf3a8d8194460b4) )
   844: 	ROM_LOAD( "036997.01e", 0x6800, 0x0800, CRC(7434acb4) SHA1(c950c4c12ab556b5051ad356ab4a0ed6b779ba1f) )
   845: 	ROM_LOAD( "036996.01e", 0x7000, 0x0800, CRC(c0e7589e) SHA1(c1aedc95966afffd860d7e0009d5a43e8b292036) )
   846: 	ROM_LOAD( "036995.01e", 0x7800, 0x0800, CRC(ad81d1da) SHA1(8bd66e5f34fc1c75f31eb6b168607e52aa3aa4df) )
   847: 	ROM_RELOAD(             0xf800, 0x0800 )	/* for reset/interrupt vectors */
   848: 	/* Mathbox ROMs */
   849: 	ROM_LOAD( "037006.01e", 0x3000, 0x0800, CRC(9fcffea0) SHA1(69b76655ee75742fcaa0f39a4a1cf3aa58088343) )
   850: 	ROM_LOAD( "037007.01e", 0x3800, 0x0800, CRC(60250ede) SHA1(9c48952bd69863bee0c6dce09f3613149e0151ef) )
   851: ROM_END
   852: 
   853: 
   854: 
   855: /*************************************
   856:  *
   857:  *	Driver initialization
   858:  *
   859:  *************************************/
   860: 
   861: static UINT8 analog_data;
   862: 
   863: static READ_HANDLER( analog_data_r )
   864: {
   865: 	return analog_data;
   866: }
   867: 
   868: 
   869: static WRITE_HANDLER( analog_select_w )
   870: {
   871: 	if (offset <= 2)
   872: 		analog_data = readinputport(6 + offset);
   873: }
   874: 
   875: 
   876: static DRIVER_INIT( bzone )
   877: {
   878: 	artwork_set_overlay(bzone_overlay);
   879: }
   880: 
   881: 
   882: static DRIVER_INIT( bradley )
   883: {
   884: 	install_mem_read_handler(0, 0x400, 0x7ff, MRA_RAM);
   885: 	install_mem_write_handler(0, 0x400, 0x7ff, MWA_RAM);
   886: 
   887: 	install_mem_read_handler(0, 0x1808, 0x1808, input_port_4_r);
   888: 	install_mem_read_handler(0, 0x1809, 0x1809, input_port_5_r);
   889: 	install_mem_read_handler(0, 0x180a, 0x180a, analog_data_r);
   890: 	install_mem_write_handler(0, 0x1848, 0x1850, analog_select_w);
   891: }
   892: 
   893: 
   894: static DRIVER_INIT( redbaron )
   895: {
   896: 	OVERLAY_START( redbaron_overlay )
   897: 		OVERLAY_RECT( 0.0, 0.0, 1.0, 1.0, MAKE_ARGB(0x04,0x88,0xff,0xff) )
   898: 	OVERLAY_END
   899: 
   900: 	artwork_set_overlay(redbaron_overlay);
   901: }
   902: 
   903: 
   904: 
   905: /*************************************
   906:  *
   907:  *	Game drivers
   908:  *
   909:  *************************************/
   910: 
   911: GAME( 1980, bzone,    0,     bzone,    bzone,    bzone,    ROT0, "Atari", "Battle Zone (set 1)" )
   912: GAME( 1980, bzone2,   bzone, bzone,    bzone,    bzone,    ROT0, "Atari", "Battle Zone (set 2)" )
   913: GAMEX(1980, bzonec,   bzone, bzone,    bzone,    bzone,    ROT0, "Atari", "Battle Zone (cocktail)", GAME_NO_COCKTAIL )
   914: GAME( 1980, bradley,  0,     bradley,  bradley,  bradley,  ROT0, "Atari", "Bradley Trainer" )
   915: GAME( 1980, redbaron, 0,     redbaron, redbaron, redbaron, ROT0, "Atari", "Red Baron" )
   916: 

