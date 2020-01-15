unit txtypes;
{ 2000-03-03 }

interface

uses

	Gem,OTypes;


const

	TEXELVER          = $0230;
	TEXELDATE         = '03.03.2000';
	RELEASE           =     0;
	BUILT             = (20 shl 25) + (3 shl 21) + (3 shl 16);
	EXPIRE            = (21 shl 25) + (2 shl 21);
	EXPIRESTR         = '31.01.2001';
	TEXELCOMPAT       =    45;

	TEXELWINDCLASS    = 'TexelCalcWindow';
	BLOCKWINDCLASS    = 'BlockChangeDialog';
	TEXELEXTENSION    =   'txl';
	TEXELSCRIPTEXT    =   'tsc';
	TEXELMAGIC        =  'TEXL';
	TEXELNAME         = 'Texel';
	TEXELWINDPREFIX   = TEXELNAME+' - ';
	TEXELFILE         = 'texel';
	TEXELAPPNAME      = TEXELFILE+'.app';
	TEXELINF          = TEXELFILE+'.inf';
	TEXELUSRVAL       = TEXELFILE+'usr.val';
	TEXELUSRFRM       = TEXELFILE+'usr.frm';
	TEXELUSRDAT       = TEXELFILE+'usr.dat';
	TEXELSOUND        = TEXELFILE+'.cla';
	TEXELHISTORY      = TEXELFILE+'.his';
	TEXELPATHS        = TEXELFILE+'.pth';
	TEXELPALETTE      = TEXELFILE+'.pal';
	TEXELPRNSET       = TEXELFILE+'.prs';
	TEXELWORK         = TEXELFILE+'.wrk';
	GUIDES            = '*:\';
	GEMJING           = 'gemjing.prg';
	{$IFDEF FRENCH}
	TEXELFRM          = TEXELFILE+'_f.frm';
	TEXELDAT          = TEXELFILE+'_f.dat';
	TEXELVAL          = TEXELFILE+'_f.val';
	TEXELRSC          = TEXELFILE+'_f.rsc';
	TEXELRSC2         = TEXELFILE+'2_f.rsc';
	TEXELHELP         = TEXELFILE+'_f.hyp';
	TEXELHELPREF      = TEXELFILE+'_f.hyp'; { ... }
	TEXELDATAPATH     = 'Fichiers\';
	TEXELSCRIPTPATH   = 'Scripts\';
	TEXELTIPS         = TEXELFILE+'_f.tip';
	{$ELSE}
	{$IFDEF ENGLISH}
	TEXELFRM          = TEXELFILE+'_e.frm';
	TEXELDAT          = TEXELFILE+'_e.dat';
	TEXELVAL          = TEXELFILE+'_e.val';
	TEXELRSC          = TEXELFILE+'_e.rsc';
	TEXELRSC2         = TEXELFILE+'2_e.rsc';
	TEXELHELP         = TEXELFILE+'_e.hyp';
	TEXELHELPREF      = TEXELFILE+'_e.hyp'; { ... }
	TEXELDATAPATH     = 'Data\';
	TEXELSCRIPTPATH   = 'Scripts\';
	TEXELTIPS         = TEXELFILE+'_e.tip';
	{$ELSE}
	TEXELFRM          = TEXELFILE+'.frm';
	TEXELDAT          = TEXELFILE+'.dat';
	TEXELVAL          = TEXELFILE+'.val';
	TEXELRSC          = TEXELFILE+'.rsc';
	TEXELRSC2         = TEXELFILE+'2.rsc';
	TEXELHELP         = TEXELFILE+'.hyp';
	TEXELHELPREF      = TEXELFILE+'.hyp'; { ... }
	TEXELDATAPATH     = 'Daten\';
	TEXELSCRIPTPATH   = 'Skripte\';
	TEXELTIPS         = TEXELFILE+'.tip';
	{$ENDIF}
	{$ENDIF}
	TEXELTEMPPATH     = 'Temp\';
	TEXELTIMER        =    2000;
	{$IFDEF LITE}
	MAXLINES          =      64;
	MAXCOLUMNS        =      32;
	{$ELSE}
	MAXLINES          =   16384;
	MAXCOLUMNS        =     702;
	{$ENDIF}
	ARGTRENNSEMIKOLON = ';';
	ARGTRENNKOMMA     = ',';
	DEZTRENNPUNKT     = '.';
	DEZTRENNKOMMA     = ',';
	DATETRENNPUNKT    = '.';
	DATETRENNSLASH    = '/';
	TIMETRENN         = ':';
	CSVTRENN          = ';';
	Ctrl_Insert       =   20992;
	CtrlShift_Insert  =   21008;
	Ctrl_Return       =    7178;
	Ctrl_Help         =   25088;
	FIXRSC            =    true;
	FIX_BBONLY        =   false;
	EMB_TYPE_ID4      =       0;
	EMB_TYPE_IMG      =       1;
	EMB_TYPE_TEXT     =       2;
	EMB_TYPE_TAD      =       3;
	EMB_TYPE_CHECKBOX =       4;
	PA_HORIZONTAL     =       0;
	PA_VERTICAL       =       1;
	PA_BLOCK          =       2;
	CELL_SELECTED     =       1;
	CELL_PROTECTED    =       2;
	CELL_HASNOTE      =       4; { ... }
	CELL_CHANGED      =      16;
	CELL_INVISIBLE    =      32; { ... }
	CELL_CALCULATED   =      64;
	CELL_USED         =     128;
	CELL_EMPTYMASK    = CELL_PROTECTED; { ... }
	GOP_ABANDON       = GOP_USERDEF;
	GOP_FORMERR       = GOP_USERDEF+1;
	CTYPE_EMPTY       =       0;
	CTYPE_TEXT        =       1;
	CTYPE_FORMULA     =       2;
	CTYPE_CONST       =       3;
	CTYPE_PARSED      =      42;
	RF_COLABS         =       1;
	RF_ROWABS         =       2;
	CRF_UMBRUCH       =       1;
	TFL_TEXT2LEFT     =       1;
	TFL_TEXT2RIGHT    =       2;
	TFL_TEXTFROMLEFT  =       4;
	TFL_TEXTFROMRIGHT =       8;
	TFL_CLIP          =     128;
	TFL_OVERFLOWMASK  = TFL_TEXT2LEFT or TFL_TEXT2RIGHT or TFL_TEXTFROMLEFT or TFL_TEXTFROMRIGHT;
	TFL_LEFTMASK      = TFL_TEXT2LEFT or TFL_TEXTFROMRIGHT;
	TFL_RIGHTMASK     = TFL_TEXT2RIGHT or TFL_TEXTFROMLEFT;
	TFL_GITTERMASK    = TFL_TEXT2RIGHT or TFL_TEXTFROMRIGHT;
	TFL_LEFTBORDER    = TFL_TEXT2LEFT or TFL_TEXTFROMLEFT;
	TFL_RIGHTBORDER   = TFL_TEXT2RIGHT or TFL_TEXTFROMRIGHT;
	TA_HOR_DEFAULT    =     $03; { ... }
	TA_VER_DEFAULT    =     $30; { ... }
	TA_UNTEN          =     $00;
	TA_OBEN           =     $10;
	TA_MITTE          =     $20;
	INS_FORMULA       =       1;
	INS_VALUE         =       2;
	INS_FORMAT        =       4;
	INS_NOTE          =       8;
	INS_ALL           = INS_FORMULA or INS_VALUE or INS_FORMAT or INS_NOTE;
	INS_OP_NONE       =       0;
	INS_OP_ADD        =       1;
	INS_OP_SUB        =       2;
	INS_OP_MUL        =       3;
	INS_OP_DIV        =       4;
	CRS_NONE          =       4;
	CRS_DOWN          =       7;
	CRS_RIGHT         =       5;
	CRS_UP            =       1;
	CRS_LEFT          =       3;
	CRS_NW            =       0;
	CRS_NE            =       2;
	CRS_SW            =       6;
	CRS_SE            =       8;
	OBJ_NONE          =       0;
	OBJ_TOGGLEALL     =       1;
	OBJ_COLOFFSET     =      -1;
	OBJ_ROWOFFSET     =  -65537;
	OBJ_CSIZEOFFSET   = -131073;
	OBJ_RSIZEOFFSET   = -196609;
	DEV_PLOTTER       =       0; { GDOS-GerÑte }
	DEV_PRINTER       =       1;
	DEV_META          =       2;
	DEV_CAMERA        =       3;
	DEV_TABLET        =       4;
	DEV_MEMORY        =       5;
	DEV_FAX           =       6;
	DEV_IMG           =       7;
	MINPERCENT        =       5;
	MAXPERCENT        =     999;
	MINPAGES          =       1;
	MAXPAGESOLD       =     999;
	MAXPAGES          =    9999;
	MAXCIPHERS        =      15;
	PFMAX             =      20;
	FSEL_OPEN         =       0;
	FSEL_SAVE         =       1;
	FSEL_EMBED        =       2;
	FSEL_LOADCSV      =       7;
	FSEL_LOADDIF      =       8;
	FSEL_LOADASCII    =       9;
	FSEL_SAVE2        =      11;
	FSEL_LOADXLS      =      12;
	FSEL_LOADLDW      =      14;
	FSEL_LOAD123      =      15;
	FSEL_LOADDBF      =      16;
	FSEL_LOADPSION    =      17;
	FSEL_EXPORT       =      20;
	FSEL_LOADIMG      =      21;
	FSEL_LOADTEXT     =      22;
	FSEL_DIAGRAM      =      23;
	FE_OK             =       0; { Fehlermeldungen }
	FE_DIVBYZERO      =      -1;
	FE_CIRCREF        =      -2;
	FE_OPUNKNOWN      =      -3;
	FE_CELLOUTOFRANGE =      -4;
	FE_UNDEFINED      =      -5;
	FE_ERROR          =      -6;
	FE_OVERFLOW       =      -7;
	FE_EXTERN         =      -8;
	FE_STRING         =      -9;
	NT_ENDOFDATA      =      -1;
	NT_LIST_EMPTY     =       0;
	NT_CONST          =       1; { Operatoren }
	NT_CELL           =       2;
	NT_RANGE          =       3;
	NT_VARIABLE       =       4;
	NT_STRING         =       5;   { TEXELCOMPAT > 43 }
	NT_PLUS           =      10;
	NT_MINUS          =      11;
	NT_MULT           =      12;
	NT_DIV            =      13;
	NT_POWER          =      14;
	NT_NEGATE         =      15;
	NT_PERCENT        =      16;
	NT_EQUAL          =      20;
	NT_GREATER        =      21;
	NT_LESS           =      22;
	NT_GREATEREQUAL   =      23;
	NT_LESSEQUAL      =      24;
	NT_UNEQUAL        =      25;
	NT_KLAMMER        =      30;
	NT_DEFINE         =      31; { ... }
	NT_NAT_PLUS       =      50;
	NT_NAT_MINUS      =      51;
	NT_NAT_MULT       =      52;
	NT_NAT_DIV        =      53;
	NT_NAT_POWER      =      54;
	NT_NAT_NEGATE     =      55;
	NT_RND            =    1000; { Funktionen }
	NT_FEHLER         =    1001;
	NT_HEUTE          =    1010;
	NT_JETZT          =    1011;
	NT_STD1           =    1012;
	NT_MIN1           =    1013;
	NT_SEK1           =    1014;
	NT_FALSE          =    1015;
	NT_TRUE           =    1016;
	NT_PI             =    1017;
	NT_ISTZAHL        =    1100;
	NT_ISTTEXT        =    1101;
	NT_ISTLEER        =    1102;
	NT_ISTFEHLER      =    1103;
	NT_ANZAHL         =    1150;
	NT_SPALTEN        =    1151;
	NT_ZEILEN         =    1152;
	NT_ANZAHL2        =    1153;
	NT_MDET           =    1160;
	NT_SIN            =    2000;
	NT_COS            =    2001;
	NT_TAN            =    2002;
	NT_COT            =    2003;
	NT_SINH           =    2004;
	NT_COSH           =    2005;
	NT_TANH           =    2006;
	NT_ARCSIN         =    2007;
	NT_ARCCOS         =    2008;
	NT_ARCTAN         =    2009;
	NT_ARCCOT         =    2010;
	NT_ARSINH         =    2011;
	NT_ARCOSH         =    2012;
	NT_ARTANH         =    2013;
	NT_ARCOTH         =    2014;
	NT_SEC            =    2015;
	NT_COSEC          =    2016;
	NT_COTH           =    2017;
	NT_GRAD           =    2090;
	NT_RAD            =    2091;
	NT_VAL            =    2092;
	NT_SGN            =    2100;
	NT_ABS            =    2101;
	NT_FRAC           =    2102;
	NT_INT            =    2103;
	NT_ROUND          =    2104;
	NT_TRUNC          =    2105;
	NT_GERADE         =    2106;
	NT_UNGERADE       =    2107;
	NT_BNICHT         =    2108;
	NT_KEHRWERT       =    2109;
	NT_EXP            =    2150;
	NT_LN             =    2151;
	NT_LOG10          =    2152;
	NT_SQRT           =    2153;
	NT_FAK            =    2154;
	NT_NICHT          =    2155;
	NT_LD             =    2156;
	NT_SQR            =    2157;
	NT_STDNORMVERT    =    2200;
	NT_BALMER         =    2250;
	NT_STUNDE         =    2260;
	NT_MINUTE         =    2261;
	NT_SEKUNDE        =    2262;
	NT_JAHR           =    2263;
	NT_MONAT          =    2264;
	NT_TAG            =    2265;
	NT_OSTERN         =    2266;
	NT_TAGE           =    2267;
	NT_SCHALTJAHR     =    2268;
	NT_STUNDEN        =    2269;
	NT_LOG            =    2300;
	NT_WOCHENTAG      =    2310;
	NT_EXPVERT        =    2400;
	NT_RANDOM         =    2401;
	NT_ROOT           =    2402;
	NT_ARCTAN2        =    2403;
	NT_MOD            =    2404;
	NT_INTDIV         =    2405;
	NT_BSCHIEBL       =    2410;
	NT_BSCHIEBR       =    2411;
	NT_SUMME          =    5000; { ab hier fn's mit bel. Parametern! }
	NT_PRODUKT        =    5001;
	NT_MIN            =    5002;
	NT_MAX            =    5003;
	NT_UND            =    5004;
	NT_ODER           =    5005;
	NT_BUND           =    5010;
	NT_BODER          =    5011;
	NT_BEOR           =    5012;
	NT_SCRIPTNO       =    5020;
	NT_MITTEL         =    5100;
	NT_GEOMITTEL      =    5101;
	NT_HARMITTEL      =    5102;
	NT_QUADMITTEL     =    5103;
	NT_VARIANZ        =    5110;
	NT_VARIANZN       =    5111;
	NT_STDABW         =    5112;
	NT_STDABWN        =    5113;
	NT_MITTELABW      =    5114;
	NT_SUMQUADABW     =    5115;
	NT_MEDIAN         =    5116;
	NT_QUARTILUNTEN   =    5117;
	NT_QUARTILOBEN    =    5118;
	NT_QUARTILSABST   =    5119;
	NT_SPANNWEITE     =    5120;
	NT_GLEICHVERT     =    5200;
	NT_NORMVERT       =    5201;
	NT_DATUM          =    5210;
	NT_ZEIT           =    5211;
	NT_LIA            =    5250;
	NT_ADA            =    5251;
	NT_GDA            =    5252;
	NT_DIGA           =    5253;
	NT_DDA            =    5254;
	NT_RMZ            =    5255;
	NT_WENN           =    5300;
	NT_WAHL           =    5301;
	NT_QUANTIL        =    5302;
	{ von 9000..9999 (-1000..-1) externe Texel-Funktionen }
	{ von 10000..32000 (0..22000) benutzerdefinierte Funktionen }
	NT_EXTMIN         =    9000;
	NT_EXTMAX         =   32000;

	PERR_OK                  =   0;
	PERR_NOMEM               =  -1;
	PERR_INCOMPCHARS         =  -2;
	PERR_INCOMPCHARSFUNC     =  -3;
	PERR_COMPINCOMPLETE      =  -4;
	PERR_SUMMANDMISSING      =  -5;
	PERR_SUBTRAHENDMISSING   =  -6;
	PERR_FAKTORMISSING       =  -7;
	PERR_DIVISORMISSING      =  -8;
	PERR_POWERMISSING        =  -9;
	PERR_FACTORINVALID       = -10;
	PERR_ARGCELLRANGE        = -14;
	PERR_TOOFEWARGS          = -16;
	PERR_ARGEMPTY            = -17;
	PERR_TOOMANYARGS         = -19;
	PERR_KLAMMERZUFEHLT      = -20;
	PERR_TOKENTOOLONG        = -21;
	PERR_STRINGNOTTERMINATED = -22;
	PERR_COLUMNWRONG         = -23;
	PERR_ROWWRONG            = -24;
	PERR_RANGEINCOMPLETE     = -25;
	PERR_NUMBERSEXPECTED     = -26;
	PERR_KLAMMERAUFFEHLT     = -27;
	PERR_KLAMMERORSEMIKOLON  = -28;
	PERR_ARGNORANGE          = -29;

	RV_NUMBER = 0;
	RV_TEXT   = 1;
	RV_CELL   = 2;
	RV_MATRIX = 3;

	FFL_RANGEONLY = $0001;
	FFL_SECONDFIX = $0002;
	FFL_NORANGE   = $0004;
	FFL_FIXARGS   = $0008;

	FF_SYSTEM         =    $0001; { Fontselektor-Flags }
	FF_MONOSPACED     =    $0002;
	FF_PROPORTIONAL   =    $0004;
	FF_BITMAP         =    $0008;
	FF_SPD            =    $0010;
	FF_TTF            =    $0020;
	FF_PFB            =    $0040;
	FF_CFN            =    $0080;
	FF_VECTOR         = FF_SPD or FF_TTF or FF_PFB or FF_CFN;
	FF_ALL            = FF_MONOSPACED or FF_PROPORTIONAL or FF_VECTOR or FF_BITMAP;
	FF_CHANGED        =    $8000;
  FF_VEKTOR         = FF_VECTOR;
  FF_MONO           = FF_MONOSPACED;
  FF_PROP           = FF_PROPORTIONAL;

	CC_WINDOW         =    $0001;
	CC_APPMODAL       =    $0002;
	CC_FIX31          =    $0004;
	CC_FAKESTYLE      =    $0008;
	CC_CLOSER         =    $0010;
	CC_NOSIZE         =    $0100;
	CC_NOCOLOR        =    $0200;
	CC_NOATTR         =    $0400;
	CC_NOWIDTH        =    $0800;
	CC_NOKERN         =    $1000;
	CC_NOSKEW         =    $2000;
	CC_DFLTSIZE       =   $10000;
	CC_INVSTYLE       =   $20000;

	XF_SIZE           =    $0001;
	XF_COLOR          =    $0002;
	XF_ATTR           =    $0004;
	XF_WIDTH          =    $0008;
	XF_KERN           =    $0010;
	XF_SKEW           =    $0020;
	XF_FIX31          =    $0100;
	XF_POPUP          =    $0200;
	XF_DRAGDROP       =    $0400;

	xFS_PARERROR      =       -9;
	xFS_LOADERROR     =       -8;
	xFS_RES_ERROR     =       -7;
	xFS_NO_HANDLE     =       -6;
	xFS_NO_WINDOW     =       -5;
	xFS_NO_FONTS      =       -4;
	xFS_NO_FONTSIZE   =       -3;
	xFS_ACTIVE        =       -2;
	xFS_ERROR         =       -1;
	xFS_STOP          =        0;
	xFS_OK            =        1;
	xFS_HELP          =        2;
	xFS_EVENT         =        3;
	xFS_POPUP         =        4;

	THA_LEFT          =        0;
	THA_CENTER        =        1;
	THA_RIGHT         =        2;

	TVA_BOTTOM        =        0;
	TVA_CENTER        =        1;
	TVA_TOP           =        2;

	V_CHAR_IND        =       -1;
	V_CHAR_ASC        =       -2;
	V_CHAR_PRT        =       -3;
	V_CHAR_ALL        =       -4;

	MAP_DIRECT        =        0;
	MAP_ASCII         =        1;

	PDLG_3D            =       1;
	PDLG_CANCEL        =       1;
	PDLG_OK            =       2;
	PDLG_PREFS         =   $0000;
	PDLG_PRINT         =   $0001;
	PDLG_ALWAYS_COPIES =   $0010;
	PDLG_ALWAYS_ORIENT =   $0020;
	PDLG_ALWAYS_SCALE  =   $0040;

	FNTS_BTMP         =        1;
	FNTS_OUTL         =        2;
	FNTS_MONO         =        4;
	FNTS_PROP         =        8;
	FNTS_ALL          = FNTS_BTMP or FNTS_OUTL or FNTS_MONO or FNTS_PROP;

	FNTS_3D           =        1;

	FNTS_SNAME        =    $0001;
	FNTS_SSTYLE       =    $0002;
	FNTS_SSIZE        =    $0004;
	FNTS_SRATIO       =    $0008;

	FNTS_CHNAME       =    $0100;
	FNTS_CHSTYLE      =    $0200;
	FNTS_CHSIZE       =    $0400;
	FNTS_CHRATIO      =    $0800;
	FNTS_RATIO        =    $1000;
	FNTS_BSET         =    $2000;
	FNTS_BMARK        =    $4000;

	FNTS_CANCEL       =        1;
	FNTS_OK           =        2;
	FNTS_SET          =        3;
	FNTS_MARK         =        4;
	FNTS_OPT          =        5;

	STIC_DEVICE       =        0;
	STIC_BIG          =        1;
	STIC_SMALL        =        2;


type

	PPRN_SETTINGS = ^PRN_SETTINGS;
	PRN_SETTINGS  = record
		magic       : TCookieID;
		len,
		format,
		reserved,
		page_flags  : longint;
		first_page,
		last_page,
		no_copies,
		orientation : integer;
		scale       : longint;
		driver_id,
		driver_type : integer;
		driver_mode,
		reserved1,
		reserved2,
		printer_id,
		mode_id     : longint;
		mode_hdpi,
		mode_vdpi   : integer;
		quality_id,
		color_mode,
		plane_flags,
		dither_mode,
		dither_value,
		size_id,
		type_id,
		input_id,
		output_id,
		contrast,
		brightness,
		reserved3,
		reserved4,
		reserved5,
		reserved6,
		reserved7,
		reserved8   : longint;
		device      : array [0..127] of char;
		mac_settings: array [0..119] of byte
	end;
	
	PPDLG_SUB = ^PDLG_SUB;
	PDLG_SUB  = record
		next        : PPDLG_SUB;
		length,
		format,
		reserved    : longint;
		drivers     : pointer;
		option_flags,
		sub_id      : integer;
		dialog      : pointer;
		tree        : PObj;
		index_offset,
		reserved1   : integer;
		reserved2,
		reserved3,
		reserved4   : longint;
		init_dlg    : function(d1,d2: pointer; d3,d4,d5: longint; settings: PPRN_SETTINGS; sub: PPDLG_SUB): longint;
		do_dlg      : function(d1,d2: pointer; d3,d4,d5: longint; settings: PPRN_SETTINGS; sub: PPDLG_SUB; exit_obj: integer): longint;
		reset_dlg   : function(d1,d2: pointer; d3,d4,d5: longint; settings: PPRN_SETTINGS; sub: PPDLG_SUB): longint;
		reserved5   : longint;
		sub_icon    : PObj;
		sub_tree    : PTree;
		reserved6,
		reserved7,
		private1,
		private2,
		private3,
		private4    : longint
	end;

	ITAB_REF = pointer;

	COLOR_RGB = record
		reserved,
		red,
		green,
		blue    : word
	end;

	COLOR_CMYK = record
		cyan,
		magenta,
		yellow,
		black  : word
	end;

	COLOR_ENTRY  = record
		case boolean of
		false: (rgb : COLOR_RGB);
		true:  (cmyk: COLOR_CMYK)
	end;

	CTAB_REF  = ^COLOR_TAB;
	COLOR_TAB = record
		magic,
		length,
		format,
		reserved,
		map_id,
		color_space,
		flags,
		no_colors,
		reserved1,
		reserved2,
		reserved3,
		reserved4  : longint;
		colors     : array [0..255] of COLOR_ENTRY
	end;

	PBITMAPPtr = ^PBITMAP;
	PBITMAP    = record
		magic,
		length,
		format,
		reserved : longint;
		addr     : pointer;
		width,
		bits,
		px_format,
		xmin,
		ymin,
		xmax,
		ymax     : longint;
		ctab     : CTAB_REF;
		itab     : ITAB_REF;
		reserved0,
		reserved1: longint
	end;

{$IFDEF LITE}
	PPCI = ^TPCI;
	TPCI = record
		subjar,
		version                  : longint;
		find_pci_device          : procedure;
		find_pci_classcode       : procedure;		read_config_byte         : procedure;		read_config_word         : procedure;		read_config_longword     : procedure;		fast_read_config_byte    : procedure;		fast_read_config_word    : procedure;		fast_read_config_longword: procedure;		write_config_byte        : procedure;		write_config_word        : procedure;		write_config_longword    : procedure;		hook_interrupt           : procedure;		unhook_interrupt         : procedure;		special_cycle            : procedure;		get_routing              : procedure;		set_interrupt            : procedure;		get_resource             : procedure;		get_card_used            : procedure;		set_card_used            : procedure;		read_mem_byte            : procedure;		read_mem_word            : procedure;		read_mem_longword        : procedure;		fast_read_mem_byte       : procedure;		fast_read_mem_word       : procedure;		fast_read_mem_longword   : procedure;		write_mem_byte           : procedure;		write_mem_word           : procedure;		write_mem_longword       : procedure;		read_io_byte             : procedure;		read_io_word             : procedure;		read_io_longword         : procedure;		fast_read_io_byte        : procedure;		fast_read_io_word        : procedure;		fast_read_io_longword    : procedure;		write_io_byte            : procedure;		write_io_word            : procedure;		write_io_longword        : procedure;		get_machine_id           : function: longint;		get_pagesize             : procedure;		virt_to_bus              : procedure;		bus_to_virt              : procedure;		virt_to_phys             : procedure;		phys_to_virt             : procedure;
	end;
{$ENDIF}

	UFSLPtr = ^UFSL;
	UFSL    = record
		id           : longint;
		version      : word;
		dialtyp      : integer;
		font_selinit : function(d1,d2: pointer; d3,d4,d5: longint): integer;
		font_selinput: function(d1,d2: pointer; d3,d4,d5: longint; vdihandle,fanz: integer; text: PChar; ftype: integer; var fretid,fretsize: integer): integer;
		helpbutton,
		helpfunc     : longint
	end;

	FSIZE = record
		case boolean of
		false: (size  : integer);
		true:  (size31: fix31)
	end;

	FONTINFOPtr = ^FONTINFO;
	FONTINFO    = record
		fontid,
		fonttype  : integer;
		fontname  : PChar;
		fontsize,
		fontwidth : FSIZE;
		trackkern,
		pairkern  : byte;
		fontattr,
		fontskew,
		fontcol,
		backcol,
		halign,
		valign,
		rotation,
		validtype : integer;
		validchars: PChar
	end;

	xFSL_PARPtr = ^xFSL_PAR;
	xFSL_PAR    = record
		par_size,
		pfi_size   : integer;
		control    : longint;
		headline,
		example,
		helptext   : PChar;
		font       : FONTINFOPtr;
		fontflags  : word;
		poptext    : PChar;
		num_entries,
		sel_entry  : integer;
		popup      : pointer;
		helpinfo   : PChar
	end;

	xFSLPtr = ^xFSL;
	xFSL    = record
		id        : TCookieID;
		revision  : word;
		product   : TCookieID;
		version   : word;
		xfsl_input: function(d1,d2: pointer; d3,d4,d5: longint; vdihandle: integer; fontflags: word; headline: PChar; var fid,fsize: integer): integer;
		xfsl_init : function(d1,d2: pointer; d3,d4,d5: longint; vdihandle: integer; xpar: xFSL_PARPtr): integer;
		xfsl_event: function(d1,d2: pointer; d3,d4,d5: longint; xfsl_handle: integer; event: EVENTPtr): integer;
		xfsl_exit : procedure(d1,d2: pointer; d3,d4,d5: longint; xfsl_handle: integer);
		xfsl_info : function(d1,d2: pointer; d3,d4,d5: longint): longint;
	end;
	
	PSTIC = ^TSTIC;
	TSTIC = record
		version  : integer;
		magic    : TCookieID;
		str_icon : function(d1,d2: pointer; d3,d4,d5: longint; s: PChar; tree: integer): PObj;
		ext_icon : procedure(d1,d2: pointer; d3,d4,d5: longint; id: integer; big: PObj; small: PObj; flag: integer);
		id_icon  : function(d1,d2: pointer; d3,d4,d5: longint; id, tree: integer): PObj;
		top_icon : function(d1,d2: pointer; d3,d4,d5: longint; tree: integer): PObj;
		menu_icon: function(d1,d2: pointer; d3,d4,d5: longint; tree: integer): PObj;
	end;

	PIMGHeader = ^TIMGHeader;
	TIMGHeader = record
		version,
		headlen,
		planes,
		pat_run,
		pix_width,
		pix_height,
		sl_width,
		sl_height : integer
	end;

	PNumber = ^TNumber;
	TNumber = real;

	PNode = ^TNode;

	PLGRECT = ^LGRECT;
	LGRECT  = record
		case boolean of
			false: (X,Y,W,H,X1,Y1,X2,Y2: longint);
			true:  (A1,A2              : array [0..3] of longint)
	end;
	
	PLRECT = ^LRECT;
	LRECT  = record
		x,y,w,h: longint
	end;

	PTAG = ^TTAG;
	TTAG = record
		tag_id   : TCookieID;
		tag_len,
		tag_flags: longint
	end;

	TTipFlags = record
		start: integer;
		nr,
		resvd: longint
	end;

	TCursor = record
		Block   : boolean;
		OldRow,
		OldCol,
		Row,
		Col,
		RowStart,
		ColStart,
		RowEnd,
		ColEnd  : integer
	end;
	
	POldTxtVal = ^TOldTxtVal;
	TOldTxtVal = record
		oldfont,
		oldsize,
		oldtcolor,
		oldeffects,
		oldrotat,
		oldskew,
    brd1w,
    brd2w,
    brd3w,
    brd1h,
    brd2h,
    brd3h     : integer;
    gitter    : boolean
	end;

	PTxtVal = ^TTxtVal;
	TTxtVal = record
		Font,
		Size,
		Rotat,
		Skew   : integer;
		Color,
		Effects,
		Align,
		Flags  : byte
	end;

	PConst = ^TConst;
	TConst = record
		Value : TNumber;
		Txt   : PString;
		FPts  : byte
	end;

	PFormula = ^TFormula;
	TFormula = record
		Value : TNumber;
		Func  : PNode;
		VarDef: PString;
		FPts  : byte;
		Error : shortint
	end;

	PCombiData = ^TCombiData;
	TCombiData = record
		case byte of
			0: (Value  : longint);
			1: (Txt    : PString);
			2: (Konst  : PConst);
			3: (Formula: PFormula)
	end;

	PBorders = ^TBorders;
	TBorders = record
		case byte of
			0: (Left,
			    Top,
			    Right,
			    Bottom,
			    Hor,
			    Vert  : byte);
			1: (Val1: integer;
			    Val2: longint)
	end;

	PCell = ^TCell;
	TCell = record
		Data    : TCombiData;
		Flags,
		Typ,
		Color,
		Style,
		Interior,
		Resvd   : byte;
		Format  : integer;
		Border  : TBorders;
		TxtVal  : TTxtVal
	end;

	PCombiNode = ^TCombiNode;
	TCombiNode = record
		case byte of
			0: (Node  : PNode);
			1: (RowRef,
			    ColRef: integer);
			2: (Txt   : PString);
			3: (List  : PItemList);
			4: (Flg   : integer);
			5: (All   : longint)
	end;

	TNode = record
		Typ  : integer;
		Left,
		Right: TCombiNode;
		case byte of
			0: (Num    : PNumber);
			1: (RowRef,
			    ColRef : integer);
			2: (Count  : longint);
			3: (Varb   : PString);
			4: (Ref1Flg,
			    Ref2Flg: integer);
			5: (All    : longint);
			6: (Chars  : PChar)
	end;

	PReturnValue = ^TReturnValue;
	TReturnValue = record
		case Typ: integer of
			RV_NUMBER:
				(Num : TNumber);
			RV_TEXT:
				(Txt : PString);
			RV_CELL:
				(Row,
			   Col,
			   Flag: integer);
			RV_MATRIX:
				(Mat : pointer);
	end;

	PDiagrammBuf = ^TDiagrammBuf;
	TDiagrammBuf = record
		rb1,
		rb2,
		rb3,
		rb4,
		rb5,
		typLinie,
		typBalken,
		typKreis,
		Farbe,
		Absolut,
		xyLinear,
		xyFirst,
		xyAlternate,
		xyLine,
		xyPt,
		xyLinept,
		Stapeln,
		DreiD,
		Neben,
		stilLinie,
		stilPunkt  : integer;
		Titel      : string[41];
		Legende,
		Border,
		nRow,
		nColumn,
		Font,
		Size,
		dRows,
		dColumns,
		Ticks      : integer;
		numTicks   : string[3];
		alName     : string[41];
		alTicks    : integer;
		alNum      : string[3];
		alMin,
		alMax      : string[13];
		auName     : string[41];
		auTicks    : integer;
		auNum      : string[3];
		auMin,
		auMax      : string[13];
		szWidth,
		szHeight   : string[7];
		objFilename: string
	end;
	
	PSortBuf = ^TSortBuf;
	TSortBuf = record
		Pop1,
		Up1,
		Down1,
		Pop2,
		Up2,
		Down2,
		Pop3,
		Up3,
		Down3,
		Columns,
		Rows,
		Ins,
		Pre,
		Post,
		Chars,
		EmptyPre,
		EmptyPost,
		Lexikal,
		Absolut,
		Attribute: integer
	end;

	PFindBuf = ^TFindBuf;
	TFindBuf = record
		search  : string[45];
		rows,
		columns,
		cse,
		complete,
		formula,
		value,
		txt,
		iform,
		ival,
		vor,
		zurueck,
		resvd   : integer
	end;

	PReplaceBuf = ^TReplaceBuf;
	TReplaceBuf = record
		search,
		replace : string[45];
		rows,
		columns,
		cse,
		complete,
		formula,
		value,
		txt,
		vor,
		zurueck,
		resvd   : integer
	end;

	PSmallInfo = ^TSmallInfo;
	TSmallInfo = record
		Autor,
		Stichwort,
		Rem1,
		Rem2,
		Rem3,
		DocTitle : string[51];
	end;

	PInfoBuf = ^TInfoBuf;
	TInfoBuf = record
		Autor,
		Stichwort,
		Rem1,
		Rem2,
		Rem3,
		DocTitle : string[51];
		Encrypt,
		Resvd    : integer;
		Created,
		Last,
		Resvd0   : longint;
		Used,
		Printed,
		Version,
		Release  : word
	end;

	PExportAscBuf = ^TExportAscBuf;
	TExportAscBuf = record
		hor,
		vert   : integer;
		rctxt  : string[21];
		rcval  : integer;
		celltxt: string[21];
		cellval: integer;
		texttxt: string[5];
		textval,
		quote,
		numbers,
		formula,
		value  : integer
	end;

	PImportAscBuf = ^TImportAscBuf;
	TImportAscBuf = record
		hor,
		vert   : integer;
		rctxt  : string[21];
		rcval  : integer;
		celltxt: string[21];
		cellval: integer;
		texttxt: string[5];
		textval,
		quote,
		numbers,
		filter : integer
	end;

	PZielBuf = ^TZielBuf;
	TZielBuf = record
		zzelle,
		vzelle     : string[7];
		wert       : string[15];
		iterationen: string[7]
	end;

	PExportBuf = ^TExportBuf;
	TExportBuf = record
		exporttype,
		clipboard,
		bereich,
		htmldoctype,
		htmlsavedt,
		htmlcolor,
		csvformula,
		csvvalue,
		difformula,
		difvalue,
		difstandard,
		difexcel   : integer;
		ascii      : TExportAscBuf;
		difformat,
		csvformat,
		asciiformat,
		htmlembed,
		filter,
		htmlnoesc,
		xlsversion,
		htmlcss,
		texelvers,
		htmlfonts  : integer;
	end;

	PFillBuffer = ^TFillBuffer;
	TFillBuffer = record
		rows,
		columns,
		arithm,
		geom,
		date,
		cpy,
		trend,
		day,
		wday,
		month,
		year   : integer;
		stepval,
		endval : string[13]
	end;

	POLEType = ^TOLEType;
	TOLEType = record
		Descr: PString;
		Ext  : string[4]
	end;

	PPrintBuffer = ^TPrintBuffer;
	TPrintBuffer = record
		sheet,
		feed     : integer;
		copies,
		percent  : string[3];
		prcindx,
		driver,
		device,
		sw,
		pblock,
		alles,
		block,
		papier   : integer;
		von,
		bis      : string[3]
	end;

	PFont = ^TFont;
	TFont = record
		Index,
		SizeCount: integer;
		Sizes    : PIntegerArray;
		Name     : PString
	end;

	PFunction = ^TFunction;
	TFunction = record
		Name,
		Descr1,
		Descr2  : PString;
		ArgMin,
		ArgMax,
		ArgFlags,
		Opcode,
		Group   : integer
	end;

	PFormat = ^TFormat;
	TFormat = record
		Name : PString;
		Group,
		Index: integer
	end;

	PCategory = ^TCategory;
	TCategory = record
		Name : PString;
		Group: integer
	end;

	PParameter = ^TParameter;
	TParameter = record
		Value   : TNumber;
		Name,
		ListName,
		Txt,
		Descr   : PString;
		Predef  : boolean
	end;

	PVariable = ^TVariable;
	TVariable = record
		RefRow,
		RefCol: integer;
		Name: PString
	end;

	PRahmenBuffer = ^TRahmenBuffer;
	TRahmenBuffer = record
		gline,
		oline,
		uline,
		lline,
		rline,
		hline,
		vline,
		gcolor,
		color,
		hcolor,
		vcolor: integer
	end;

	PSheetBuffer = ^TSheetBuffer;
	TSheetBuffer = record
		rows     : string[5];
		columns  : string[3];
		font,
		size,
		gitter,
		autocalc,
		vorlage,
		lhor,
		lvert,
		lmouse,
		llayout,
		images,
		protect,
		umbruch,
		exceldate: integer
	end;

	PDialogBuffer = ^TDialogBuffer;
	TDialogBuffer = record
		font,
		size,
		percent,
		color,
		pattern,
		direction: integer;
		input    : string;
		txtcolor,
		border   : integer;
		resvd1,
		resvd2,
		resvd3,
		resvd4   : longint
	end;
	
	PEmbedCheckBuf = ^TEmbedCheckBuf;
	TEmbedCheckBuf = record
		Title   : string[45];
		Zelle   : string[7];
		Status,
		Row,
		Column,
		Reserved: integer
	end;

	PEmbedBuf = ^TEmbedBuf;
	TEmbedBuf = record
		color,
		trans,
		border,
		fcolor,
		fid,
		fsize : integer
	end;

	PPassWord = ^TPassWord;
	TPassWord = record
		Flag: integer;
		Code,
		Mask: longint
	end;

	PTexelHeader = ^TTexelHeader;
	TTexelHeader = record
		Magic     : array [0..3] of char;
		Version,
		Compatible: word;
		PackAlgo,
		Release,
		Resvd1,
		Resvd2,
		Resvd3,
		Resvd4    : integer
	end;

	PBlockHeader = ^TBlockHeader;
	TBlockHeader = record
		Width,
		Height,
		ColOffs,
		RowOffs,
		Resvd0,
		Resvd1,
		Resvd2,
		Resvd3,
		Resvd4 : integer
	end;

	PTexelHead2 = ^TTexelHead2;
	TTexelHead2 = record
		Resvd0,
		Resvd1,
		Resvd2,
		Resvd3,
		Resvd4,
		Resvd5,
		Resvd6,
		PassCode : longint;
		PassFlag,
		CryptFlag: integer;
		RSeed    : longint
	end;

	PPSBuffer = ^TPSBuffer;
	TPSBuffer = record
		oben,
		unten,
		links,
		rechts   : string[9];
		hcenter,
		vcenter,
		gitter,
		rows,
		columns  : integer;
		bereich  : string[15];
		hleft,
		hmid,
		hright,
		fleft,
		fmid,
		fright   : string[41];
		num1,
		num2,
		hlefton,
		hcenteron,
		hrighton,
		flefton,
		fcenteron,
		frighton,
		images   : integer;
		kopf,
		fuss     : string[9]
	end;

	PTexelParms = ^TTexelParms;
	TTexelParms = record
		Rows,
		Columns,
		Percent : integer;
		ScrlXPos,
		ScrlYPos: longint;
		CurrSize: GRECT;
		Cursor  : TCursor;
		psbuffer: TPSBuffer;
		Toolbar : integer
	end;

	PTexelObjectInfo = ^TTexelObjectInfo;
	TTexelObjectInfo = record
		oi     : TOLGAObjectInfo;
		ie     : TOLGAIEInfo;
		r1,
		r2     : GRECT;
		fname  : array [0..255] of char;
		Data   : pointer;
		DataLen,
		x100,
		y100,
		w100,
		h100   : longint;
		oabuf  : TEmbedBuf;
		istad,
		xyvalid,
		prop,
		embd,
		dirty  : boolean;
		diabuf : TDiagrammBuf;
		prntflg,
		lckflg : boolean
	end;


const

	CELLSIZE       : longint =  sizeof(TCell);
	ev_normalfaktor: TNumber =  0.39894228040143267793;
	ev_pihalbe     : TNumber =  1.57079632679489661926;
	ev_ln2         : TNumber =  0.69314718055994530943;
	ev_ln10        : TNumber =  2.30258509299404568425;
	ev_rad2grad    : TNumber = 57.29577951308232087579;
	ev_grad2rad    : TNumber =  0.01745329251994329577;
	std1           : TNumber =  0.041666666666667;
	min1           : TNumber =  0.000694444444445;
	sek1           : TNumber =  0.000011574074075;
	TIMEROUND      : TNumber =  0.000000000001;
	RSC_LOADED     : pointer = pointer(1);
	Border1        : real    =  0.3;
	Border2        : real    =  0.6;
	Border3        : real    =  0.9;
	HUGE_VAL       : real    =  1.189731495357231765E+4932;
	DANKMAX        = 7;
	dank           : array [0..DANKMAX] of string[120] =
	                 ('                                        Was Sie noch nie wissen wollten, aber nun gezwungen werden zu lesen...   ',
	                  'Programm: Thomas Much - Handbuch und Onlinehilfe: Gîtz Hoffart - Betatester: Christoph Bartholme, Sven & Wilfried',
	                  ' Behne, Daniel Beretzki, Karl Brandt, Oliver Buchmann, Friedrich Burgwedel, Jens Cardinal, Gerd Castan, Alexander',
	                  ' Clauss, Joe Connor, Ralf Heckmann, Thomas Hoffmann, Gerd Hofmann, Matthias Jaap, Andreas Kromke, Thomas KÅnneth,',
	                  ' Manfred Lippert, Mario Meissner, Philipp Oelwein, Ulli Ramps, Volker Ritzhaupt,',
	                  ' Michael Schwingen, Ben Sommer, Peter G. Spengler, Alexander Stehling, Rainer Wiesenfeller und Christian Witt',
                    ' - Homepage: http://www.texel-home.de - EMail: support@texel-home.de - ASH-Mailbox: +49 (0)6221 / 303671',
                    ' - Piep, piep, piep... we apologise for the inconvenience.                                               ');
	Buchstabe      : set of char = ['a'..'z','A'..'Z'];
	DezZiffer      : set of char = ['0'..'9'];
	HexZiffer      : set of char = ['0'..'9','a'..'f','A'..'F'];
	OctZiffer      : set of char = ['0'..'7'];
	BinZiffer      : set of char = ['0','1'];
	Dezimaltrenner : set of char = [',','.'];
	Vorzeichen     : set of char = ['+','-'];
	Exponent       : set of char = ['E','e'];
	months365      : array [0..11] of integer = (31,28,31,30,31,30,31,31,30,31,30,31);
	months366      : array [0..11] of integer = (31,29,31,30,31,30,31,31,30,31,30,31);
	{$IFNDEF BETA}
	ash_name       : array [0..30] of char = 'nnnnnnnnnnnnnnnnnnnnnnnnnnnnnn'#0;
	ash_firma      : array [0..30] of char = 'ffffffffffffffffffffffffffffff'#0;
	ash_serno      : array [0..10] of char = 'ssssssssss'#0;
	{$ENDIF}


var

	VarNameSet,
	VarNameFirst: set of char;



implementation


begin
	VarNameSet:=['_','Ñ','é','î','ô','Å','ö','û']+Buchstabe+DezZiffer;
	VarNameFirst:=VarNameSet-DezZiffer;
end.