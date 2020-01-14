unit txoption;
{ 1999-02-27 }

interface

uses

	OWindows;


type

	PSaveOpt = ^TSaveOpt;
	TSaveOpt = object(TKeyMenu)
		procedure Work; virtual;
	end;
	
	PSaveWork = ^TSaveWork;
	TSaveWork = object(TMenu)
		procedure Work; virtual;
	end;

	POptions = ^TOptions;
	TOptions = object(TKeyMenu)
		spage: PDialog;
		constructor Init(AParent: PEventObject; Stat,Key,mNum,tNum: integer);
		procedure Work; virtual;
		procedure PageSetup;
	end;




implementation

uses

	Tos,Gem,
	Objects,OTypes,OProcs,ODialogs,OValidat,
	txrsc,txlang,txtypes,txfont,txvalida,txnew,txmain
	{$IFNDEF WDIALOG},txmiscob,txmainob{$ENDIF};


type

	PPfadButton = ^TPfadButton;
	TPfadButton = object(TButton)
		public
		constructor Init(AParent: PDialog; AnIndx,AnID,pIdx: integer; UserDef: boolean; Ext,Hlp: string);
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
		procedure Update;
		private
		Extension: string;
		pfadIndex: integer;
	end;

	PPfadDialog = ^TPfadDialog;
	TPfadDialog = object(THyperDialog)
		public
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure UpdateButtons;
		private
		pfade,
		namen: array [0..PFMAX] of string;
		pb0,
		pb2,
		pb4,
		pb6,
		pb7,
		pb9,
		pb10,
		pb11,
		pb12,
		pb14,
		pb15,
		pb17,
		pb18,
		pb19,
		pb20 : PPfadButton;
	end;

	POptionsDialog = ^TOptionsDialog;
	TOptionsDialog = object(THyperDialog)
		{$IFNDEF WDIALOG}
		prnt: PPrintDialog;
		{$ENDIF}
		paths: PPfadDialog;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure EditPaths;
	end;



procedure TSaveOpt.Work;
	var q,hdl: integer;
	    ret  : longint;

	begin
		SliceMouse;
		if WritePrivateProfileString('CalcWindowDefaults','Rows',TexelApp.setupbuffer.stdrows,TEXELINF) then
			begin
				WritePrivateProfileString('CalcWindowDefaults','Columns',TexelApp.setupbuffer.stdcolumns,TEXELINF);
				WritePrivateProfileString('CalcWindowDefaults','StdColWidth',TexelApp.setupbuffer.stdcolwidth,TEXELINF);
				WritePrivateProfileInt('CalcWindowDefaults','StdFont',TexelApp.GetStdFontIndex,TEXELINF);
				WritePrivateProfileInt('CalcWindowDefaults','StdFontSize',TexelApp.GetStdFontSize,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('CalcWindowDefaults','AutoCalc',TexelApp.setupbuffer.autocalc,TEXELINF);
				WritePrivateProfileInt('CalcWindowDefaults','ExcelDate',TexelApp.setupbuffer.exceldate,TEXELINF);
				WritePrivateProfileInt('Setup','OpenNew',TexelApp.setupbuffer.opennew,TEXELINF);
				WritePrivateProfileInt('Setup','LoadDoc',TexelApp.setupbuffer.loaddoc,TEXELINF);
				WritePrivateProfileInt('Setup','Nothing',TexelApp.setupbuffer.nothing,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Setup','SaveOpt',TexelApp.setupbuffer.saveopt,TEXELINF);
				WritePrivateProfileInt('Setup','SaveWork',TexelApp.setupbuffer.savework,TEXELINF);
				WritePrivateProfileInt('Setup','FullSize',TexelApp.setupbuffer.fullsize,TEXELINF);
				WritePrivateProfileInt('Setup','WYSIWYG',TexelApp.setupbuffer.wysiwyg,TEXELINF);
				WritePrivateProfileInt('Setup','WYSIWYG.PixW',TexelApp.setupbuffer.pixw,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Setup','WYSIWYG.PixH',TexelApp.setupbuffer.pixh,TEXELINF);
				WritePrivateProfileInt('Setup','Recalc',TexelApp.setupbuffer.recalc,TEXELINF);
				WritePrivateProfileInt('Setup','Online',TexelApp.setupbuffer.online,TEXELINF);
				WritePrivateProfileInt('Setup','Backup',TexelApp.setupbuffer.bak,TEXELINF);
				WritePrivateProfileInt('Setup','FormErr',TexelApp.setupbuffer.formerr,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Setup','Toolbar',TexelApp.setupbuffer.toolbar,TEXELINF);
				WritePrivateProfileInt('Setup','Currency',TexelApp.setupbuffer.currency,TEXELINF);
				WritePrivateProfileInt('Setup','Overflow',TexelApp.setupbuffer.overflow,TEXELINF);
				WritePrivateProfileInt('Setup','BottomLine',TexelApp.setupbuffer.bottomline,TEXELINF);
				WritePrivateProfileInt('Setup','XInputMode',TexelApp.setupbuffer.xinputmode,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Setup','CursorWrap',TexelApp.setupbuffer.cursorwrap,TEXELINF);
				WritePrivateProfileInt('Setup','CancelOnClose',TexelApp.setupbuffer.closercancel,TEXELINF);
				WritePrivateProfileString('Setup','SizerRange',TexelApp.setupbuffer.sizerrange,TEXELINF);
				WritePrivateProfileString('Setup','FloatingPoint',TexelApp.setupbuffer.floatpoint,TEXELINF);
				WritePrivateProfileString('Setup','History',TexelApp.setupbuffer.history,TEXELINF);
				SliceMouseNext;
				{$IFNDEF WDIALOG}
				WritePrivateProfileInt('Printer','Sheet',TexelApp.stdprnbuffer.sheet,TEXELINF);
				WritePrivateProfileInt('Printer','BlackWhite',TexelApp.stdprnbuffer.sw,TEXELINF);
				WritePrivateProfileInt('Printer','Feed',TexelApp.stdprnbuffer.feed,TEXELINF);
				WritePrivateProfileInt('Printer','Driver',TexelApp.stdprnbuffer.driver,TEXELINF);
				WritePrivateProfileInt('Printer','Device',TexelApp.stdprnbuffer.device,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileString('Printer','Copies',TexelApp.stdprnbuffer.copies,TEXELINF);
				WritePrivateProfileString('Printer','Percent',TexelApp.stdprnbuffer.percent,TEXELINF);
				WritePrivateProfileString('Printer','Von',TexelApp.stdprnbuffer.von,TEXELINF);
				WritePrivateProfileString('Printer','Bis',TexelApp.stdprnbuffer.bis,TEXELINF);
				WritePrivateProfileInt('Printer','Papier',TexelApp.stdprnbuffer.papier,TEXELINF);
				SliceMouseNext;
				{$ENDIF}
				WritePrivateProfileInt('Printer','Alles',TexelApp.stdprnbuffer.alles,TEXELINF);
				WritePrivateProfileInt('Printer','Block',TexelApp.stdprnbuffer.block,TEXELINF);
				WritePrivateProfileInt('Printer','PBlock',TexelApp.stdprnbuffer.pblock,TEXELINF);
				WritePrivateProfileInt('Import','Hor',TexelApp.ascbuf.hor,TEXELINF);
				WritePrivateProfileInt('Import','Vert',TexelApp.ascbuf.vert,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileString('Import','rcTxt','"'+TexelApp.ascbuf.rcTxt+'"',TEXELINF);
				WritePrivateProfileInt('Import','rcVal',TexelApp.ascbuf.rcval,TEXELINF);
				WritePrivateProfileString('Import','cellTxt','"'+TexelApp.ascbuf.cellTxt+'"',TEXELINF);
				WritePrivateProfileInt('Import','cellVal',TexelApp.ascbuf.cellval,TEXELINF);
				WritePrivateProfileString('Import','textTxt','"'+TexelApp.ascbuf.textTxt+'"',TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Import','textVal',TexelApp.ascbuf.textval,TEXELINF);
				WritePrivateProfileInt('Import','Quote',TexelApp.ascbuf.quote,TEXELINF);
				WritePrivateProfileInt('Import','Numbers',TexelApp.ascbuf.numbers,TEXELINF);
				WritePrivateProfileInt('Import','Filter',TexelApp.ascbuf.filter,TEXELINF);
				WritePrivateProfileString('Page Setup','Oben',TexelApp.stdpsbuffer.oben,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileString('Page Setup','Unten',TexelApp.stdpsbuffer.unten,TEXELINF);
				WritePrivateProfileString('Page Setup','Links',TexelApp.stdpsbuffer.links,TEXELINF);
				WritePrivateProfileString('Page Setup','Rechts',TexelApp.stdpsbuffer.rechts,TEXELINF);
				WritePrivateProfileString('Page Setup','Kopf',TexelApp.stdpsbuffer.kopf,TEXELINF);
				WritePrivateProfileString('Page Setup','Fuss',TexelApp.stdpsbuffer.fuss,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileString('Page Setup','Bereich',TexelApp.stdpsbuffer.bereich,TEXELINF);
				WritePrivateProfileString('Page Setup','hLeft','"'+TexelApp.stdpsbuffer.hleft+'"',TEXELINF);
				WritePrivateProfileString('Page Setup','hMid','"'+TexelApp.stdpsbuffer.hmid+'"',TEXELINF);
				WritePrivateProfileString('Page Setup','hRight','"'+TexelApp.stdpsbuffer.hright+'"',TEXELINF);
				WritePrivateProfileString('Page Setup','fLeft','"'+TexelApp.stdpsbuffer.fleft+'"',TEXELINF);
				SliceMouseNext;
				WritePrivateProfileString('Page Setup','fMid','"'+TexelApp.stdpsbuffer.fmid+'"',TEXELINF);
				WritePrivateProfileString('Page Setup','fRight','"'+TexelApp.stdpsbuffer.fright+'"',TEXELINF);
				WritePrivateProfileInt('Page Setup','hCenter',TexelApp.stdpsbuffer.hcenter,TEXELINF);
				WritePrivateProfileInt('Page Setup','vCenter',TexelApp.stdpsbuffer.vcenter,TEXELINF);
				WritePrivateProfileInt('Page Setup','Gitter',TexelApp.stdpsbuffer.gitter,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Page Setup','Rows',TexelApp.stdpsbuffer.rows,TEXELINF);
				WritePrivateProfileInt('Page Setup','Columns',TexelApp.stdpsbuffer.columns,TEXELINF);
				WritePrivateProfileInt('Page Setup','Num1',TexelApp.stdpsbuffer.num1,TEXELINF);
				WritePrivateProfileInt('Page Setup','Num2',TexelApp.stdpsbuffer.num2,TEXELINF);
				WritePrivateProfileInt('Page Setup','hLeftOn',TexelApp.stdpsbuffer.hlefton,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Page Setup','hCenterOn',TexelApp.stdpsbuffer.hcenteron,TEXELINF);
				WritePrivateProfileInt('Page Setup','hRightOn',TexelApp.stdpsbuffer.hrighton,TEXELINF);
				WritePrivateProfileInt('Page Setup','fLeftOn',TexelApp.stdpsbuffer.flefton,TEXELINF);
				WritePrivateProfileInt('Page Setup','fCenterOn',TexelApp.stdpsbuffer.fcenteron,TEXELINF);
				WritePrivateProfileInt('Page Setup','fRightOn',TexelApp.stdpsbuffer.frighton,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Page Setup','Images',TexelApp.stdpsbuffer.images,TEXELINF);
				WritePrivateProfileString('Texel','Version',VtoS(TEXELVER),TEXELINF);
				WritePrivateProfileString('Texel','Release',ltoa(RELEASE),TEXELINF);
				SliceMouseNext;
				WritePrivateProfileString('Texel','Date',TEXELDATE,TEXELINF);
				WritePrivateProfileInt('Texel','Level',TEXELCOMPAT,TEXELINF);
				WritePrivateProfileString('Texel','OGEMVersion',VtoS(GOVersion),TEXELINF);
				WritePrivateProfileString('Texel','OGEMDate',DtoS(GODate),TEXELINF);
				WritePrivateProfileInt('Setup','FormErrCell',TexelApp.setupbuffer.formerrcell,TEXELINF);
				SliceMouseNext;
				WritePrivateProfileInt('Setup','InfoDial',TexelApp.setupbuffer.infodial,TEXELINF);
				SavePrivateProfile
			end;
		ArrowMouse;
		BusyMouse;
		ret:=fcreate(GetHomeDir(false)+'defaults\'+TEXELPATHS,0);
		if ret<0 then ret:=fcreate(GetHomeDir(false)+TEXELPATHS,0);
		if ret>=0 then
			begin
				hdl:=integer(ret);
				q:=PFMAX;
				fwrite(hdl,2,@q);
				for q:=0 to PFMAX do
					begin
						fwrite(hdl,length(TexelApp.LastPath[q])+1,@TexelApp.LastPath[q]);
						fwrite(hdl,length(TexelApp.LastFile[q])+1,@TexelApp.LastFile[q])
					end;
				fclose(hdl)
			end;
		if TexelApp.app_prnt_set<>nil then
			if TexelApp.app_prnt_set^.magic='pset' then
				begin
					ret:=fcreate(GetHomeDir(false)+'defaults\'+TEXELPRNSET,0);
					if ret<0 then ret:=fcreate(GetHomeDir(false)+TEXELPRNSET,0);
					if ret>=0 then
						begin
							hdl:=integer(ret);
							fwrite(hdl,TexelApp.app_prnt_set^.len,TexelApp.app_prnt_set);
							fclose(hdl)
						end
				end;
		ArrowMouse
	end;


procedure TSaveWork.Work;
	var p  : PWindow;
	    ret: longint;
	    hdl,
	    anz: integer;
	    s  : string;

	begin
		{$IFNDEF LITE}
		BusyMouse;
		p:=Application^.MainWindow;
		anz:=0;
		while p<>nil do
			begin
				if p^.GetClassName=TEXELWINDCLASS then
					if length(PCalcWindow(p)^.GetWindowFilename)>0 then inc(anz);
				p:=p^.Next
			end;
		ret:=fcreate(GetHomeDir(false)+'defaults\'+TEXELWORK,0);
		if ret<0 then ret:=fcreate(GetHomeDir(false)+TEXELWORK,0);
		if ret>=0 then
			begin
				hdl:=integer(ret);
				fwrite(hdl,2,@anz);
				p:=Application^.MainWindow;
				while p<>nil do
					begin
						if p^.GetClassName=TEXELWINDCLASS then
							begin
								s:=PCalcWindow(p)^.GetWindowFilename;
								if length(s)>0 then fwrite(hdl,256,@s[0])
							end;
						p:=p^.Next
					end;
				fclose(hdl)
			end;
		ArrowMouse
		{$ENDIF}
	end;


constructor TOptions.Init(AParent: PEventObject; Stat,Key,mNum,tNum: integer);

	begin
		if not(inherited Init(AParent,Stat,Key,mNum,tNum)) then fail;
		spage:=nil
	end;


procedure TOptions.Work;
	var pe    : PEdit;
	    pb    : PButton;
	    fsizes: PStringCollection;
	    pfsb  : PFontSizeBox;
	    pfb   : PFontBox;
	    pc    : PCheckBox;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(POptionsDialog,Init(nil,TEXELWINDPREFIX+TITLE_SETUP,STG_SETUP,ICNTITLE_SETUP,RTSETUP));
				if ADialog<>nil then
					begin
						{$IFNDEF WDIALOG}
						POptionsDialog(ADialog)^.prnt:=nil;
						{$ENDIF}
						POptionsDialog(ADialog)^.paths:=nil;
						new(PCard,Init(ADialog,RTSSTANDARD,RTSTSTANDARD,0,crd_First,BUBBLE_SETUP_DEFDOC));
						new(PCard,Init(ADialog,RTSWINDOW,RTSTWINDOW,0,crd_Normal,BUBBLE_SETUP_WINDOW));
						new(PCard,Init(ADialog,RTSGENERAL,RTSTGENERAL,0,crd_Normal,BUBBLE_SETUP_GENERAL));
						new(PCard,Init(ADialog,RTSSTART,RTSTSTART,0,crd_Last,BUBBLE_SETUP_STARTEND));
						new(pe,Init(ADialog,RTSSTDROWS,6,BUBBLE_SETUP_ROWS));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(2,MAXLINES)));
						new(pe,Init(ADialog,RTSSTDCOLUMNS,4,BUBBLE_SETUP_COLUMNS));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(2,MAXCOLUMNS)));
						new(pe,Init(ADialog,RTSSTDCOLWIDTH,3,BUBBLE_SETUP_COLWIDTH));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(1,25)));
						new(PCheckBox,Init(ADialog,RTSAUTOCALC,true,BUBBLE_SETUP_AUTOCALC));
						new(PCheckBox,Init(ADialog,RTSEXCELDATE,true,BUBBLE_SETUP_EXCELDATE));
						new(pfb,InitCollection(ADialog,RTSFONTPOP,RTSFONTCYC,RTSFONTTITLE,26,TexelApp.Fonts,false,false,false,BUBBLE_SETUP_FONTID));
						if pfb<>nil then
							begin
								pfb^.newsize:=-1;
								new(fsizes,Init(130,20));
								new(pfsb,InitCollection(ADialog,RTSSIZEPOP,RTSSIZECYC,RTSSIZETITLE,6,fsizes,true,false,false,BUBBLE_SETUP_FONTSIZE));
								pfsb^.setsize:=true;
								pfb^.fsizebox:=pfsb;
								pfb^.Work
							end;
						new(pe,Init(ADialog,RTSSIZERRANGE,2,BUBBLE_SETUP_SIZERRANGE));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(0,5)));
						new(pe,Init(ADialog,RTSFLOATPOINT,3,BUBBLE_SETUP_FPOINT));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(0,MAXCIPHERS)));
						new(pe,Init(ADialog,RTSHISTORY,3,BUBBLE_SETUP_HISTORY));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(0,99)));
						new(PCheckBox,Init(ADialog,RTSCURSORWRAP,true,BUBBLE_SETUP_CRSWRAP));
						new(PCheckBox,Init(ADialog,RTSXINPUT,true,BUBBLE_SETUP_XINPUT));
						new(PCheckBox,Init(ADialog,RTSCLOSERCANCEL,true,BUBBLE_SETUP_CLOSER));
						new(PGroupBox,Init(ADialog,RTSGSTART,GROUP_SETUP_START,BUBBLE_SETUP_START));
						new(PGroupBox,Init(ADialog,RTSGENDE,GROUP_SETUP_END,BUBBLE_SETUP_END));
						new(PRadioButton,Init(ADialog,RTSOPENNEW,true,BUBBLE_SETUP_NEW));
						new(PRadioButton,Init(ADialog,RTSLOADDOC,true,BUBBLE_SETUP_OPEN));
						new(PRadioButton,Init(ADialog,RTSNOTHING,true,BUBBLE_SETUP_NOTHING));
						new(PCheckBox,Init(ADialog,RTSSAVEOPT,true,BUBBLE_SETUP_SAVEOPT));
						new(pc,Init(ADialog,RTSSAVEWORK,true,BUBBLE_SETUP_SAVEWORK));
						{$IFDEF LITE}
						if pc<>nil then pc^.Disable;
						{$ENDIF}
						new(PCheckBox,Init(ADialog,RTSFULLSIZE,true,BUBBLE_SETUP_FULLSIZE));
						new(pc,Init(ADialog,RTSBLOCK,true,BUBBLE_SETUP_BLOCK));
						{$IFDEF NVDI5}
						if pc<>nil then pc^.Disable;
						{$ENDIF}
						new(PCheckBox,Init(ADialog,RTSRECALC,true,BUBBLE_SETUP_RECALC));
						new(PCheckBox,Init(ADialog,RTSONLINE,true,BUBBLE_SETUP_RTBLOCK));
						new(PCheckBox,Init(ADialog,RTSBACKUP,true,BUBBLE_SETUP_BACKUP));
						new(PCheckBox,Init(ADialog,RTSFORMERR,true,BUBBLE_SETUP_FORMERR));
						new(PCheckBox,Init(ADialog,RTSFORMCELL,true,BUBBLE_SETUP_FORMCELL));
						new(PCheckBox,Init(ADialog,RTSTOOLBAR,true,BUBBLE_SETUP_TOOLBAR));
						new(PComboBox,Init(ADialog,RTSCURRENCY,RTSCURRCYC,RTSCURRTITLE,RTPOPUPS,RTPCURRENCY,id_No,true,false,BUBBLE_SETUP_CURRENCY));
						new(PCheckBox,Init(ADialog,RTSOVERFLOW,true,BUBBLE_SETUP_OVERFLOW));
						new(PCheckBox,Init(ADialog,RTSBOTTOMLINE,true,BUBBLE_SETUP_BOTTOMLINE));
						new(PCheckBox,Init(ADialog,RTSINFODIAL,true,BUBBLE_SETUP_INFODIAL));
						new(pb,Init(ADialog,RTSHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(pb,Init(ADialog,RTSPRINTER,id_No,true,BUBBLE_SETUP_PRINTER));
						if Application^.GDOSActive then pb^.Enable
						else
							pb^.Disable;
						new(PButton,Init(ADialog,RTSPFADE,id_No,true,BUBBLE_SETUP_PATHS));
						new(PButton,Init(ADialog,RTSOK,id_OK,true,BUBBLE_GENERAL_OK2));
						new(PButton,Init(ADialog,RTSCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						ADialog^.TransferBuffer:=@TexelApp.setupbuffer
					end
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;


procedure TOptions.PageSetup;
	var pe: PEdit;
	    pc: PCheckBox;
	    pb: PButton;

	begin
		if spage=nil then
			begin
				spage:=new(PPSDialog,Init(ADialog,TEXELWINDPREFIX+TITLE_SETUP,STG_LAYOUT,ICNTITLE_SETUPLAYOUT,RTPAGESETUP));
				if spage<>nil then
					begin
						new(PGroupBox,Init(spage,RTPSMARGINS,GROUP_LAYOUT_MARGINS,''));
						new(PGroupBox,Init(spage,RTPSCENTER,GROUP_LAYOUT_CENTER,''));
						new(PGroupBox,Init(spage,RTPSPRINT,GROUP_LAYOUT_PRINTWITH,''));
						new(PGroupBox,Init(spage,RTPSBEREICH,GROUP_LAYOUT_PRINTRANGE,''));
						new(PGroupBox,Init(spage,RTPSHEAD,GROUP_LAYOUT_HEAD,''));
						new(PGroupBox,Init(spage,RTPSFOOT,GROUP_LAYOUT_FOOT,''));
						new(PGroupBox,Init(spage,RTPSNUM,GROUP_LAYOUT_NUM,''));
						new(pe,Init(spage,RTPSTOP,9,BUBBLE_LAYOUT_TMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pe,Init(spage,RTPSBOTTOM,9,BUBBLE_LAYOUT_BMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pe,Init(spage,RTPSLEFT,9,BUBBLE_LAYOUT_LMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pe,Init(spage,RTPSRIGHT,9,BUBBLE_LAYOUT_RMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(PCheckBox,Init(spage,RTPSHCENTER,true,BUBBLE_LAYOUT_HCENTER));
						new(PCheckBox,Init(spage,RTPSVCENTER,true,BUBBLE_LAYOUT_VCENTER));
						new(PCheckBox,Init(spage,RTPSGITTER,true,BUBBLE_LAYOUT_GRID));
						new(PCheckBox,Init(spage,RTPSROWS,true,BUBBLE_LAYOUT_NUMBERS));
						new(PCheckBox,Init(spage,RTPSCOLUMNS,true,BUBBLE_LAYOUT_NAMES));
						new(pe,Init(spage,RTPSBEDIT,16,BUBBLE_LAYOUT_PRNTRANGE));
						new(pe,Init(spage,RTPSHLEFT,42,BUBBLE_LAYOUT_LHEAD));
						new(pe,Init(spage,RTPSHMID,42,BUBBLE_LAYOUT_CHEAD));
						new(pe,Init(spage,RTPSHRIGHT,42,BUBBLE_LAYOUT_RHEAD));
						new(pe,Init(spage,RTPSFLEFT,42,BUBBLE_LAYOUT_LFOOT));
						new(pe,Init(spage,RTPSFMID,42,BUBBLE_LAYOUT_CFOOT));
						new(pe,Init(spage,RTPSFRIGHT,42,BUBBLE_LAYOUT_RFOOT));
						new(PRadioButton,Init(spage,RTPSNUM1,false,BUBBLE_LAYOUT_NUMHOR));
						new(PRadioButton,Init(spage,RTPSNUM2,false,BUBBLE_LAYOUT_NUMVERT));
						new(pc,Init(spage,RTPSHLEFTON,true,BUBBLE_LAYOUT_PLHEAD));
						new(pc,Init(spage,RTPSHCENTERON,true,BUBBLE_LAYOUT_PCHEAD));
						new(pc,Init(spage,RTPSHRIGHTON,true,BUBBLE_LAYOUT_PRHEAD));
						new(pc,Init(spage,RTPSFLEFTON,true,BUBBLE_LAYOUT_PLFOOT));
						new(pc,Init(spage,RTPSFCENTERON,true,BUBBLE_LAYOUT_PCFOOT));
						new(pc,Init(spage,RTPSFRIGHTON,true,BUBBLE_LAYOUT_PRFOOT));
						new(PCheckBox,Init(spage,RTPSOBJECTS,true,BUBBLE_LAYOUT_POBJECTS));
						new(pe,Init(spage,RTPSKOPF,9,BUBBLE_LAYOUT_MHEAD));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pe,Init(spage,RTPSFUSS,9,BUBBLE_LAYOUT_MFOOT));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pb,Init(spage,RTPSHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(pb,Init(spage,RTPSMINIMAL,id_No,true,''));
						if pb<>nil then pb^.Hide(false);
						new(PButton,Init(spage,RTPSCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(pb,Init(spage,RTPSSET,id_No,true,''));
						if pb<>nil then pb^.Hide(false);
						new(PButton,Init(spage,RTPSOK,id_OK,true,BUBBLE_GENERAL_OK));
						spage^.TransferBuffer:=@TexelApp.stdpsbuffer
					end
			end;
		if spage<>nil then spage^.MakeWindow
	end;


function TOptionsDialog.OK: boolean;
	var valid: boolean;
	    oldof: integer;
	    pw   : PWindow;

	begin
		oldof:=TexelApp.setupbuffer.overflow;
		valid:=inherited OK;
		if valid then
			with TexelApp do
				begin
					if createdoc<>nil then PNew(createdoc)^.CheckMenuEntry;
					if setupbuffer.xinputmode=bf_Checked then Attr.Style:=Attr.Style or as_XInputMode
					else
						Attr.Style:=Attr.Style and not(as_XInputMode);
					if oldof<>setupbuffer.overflow then
						begin
							pw:=Application^.MainWindow;
							while pw<>nil do
								begin
									if pw^.GetClassName=TEXELWINDCLASS then pw^.ForceRedraw;
									pw:=pw^.Next
								end
						end
				end;
		OK:=valid
	end;


function TOptionsDialog.ExitDlg(AnIndx: integer): boolean;
	var st         : PStatic;
	    pe         : PEdit;
	    pb         : PButton;
	    drivers    : PStringCollection;
	    pc         : PCheckBox;
	    docname    : string;
	    sub_dialogs: PPDLG_SUB;
	    pt         : PTree;
	    {$IFNDEF WDIALOG}
	    pcb        : PPrintPercBox;
	    {$ENDIF}

	begin
		ExitDlg:=false;
		case AnIndx of
		RTSPFADE:
			EditPaths;
		RTSPRINTER:
			begin
				if TexelApp.ExtPrnSel(TexelApp.app_prnt_set,nil) then
					begin
						getmem(sub_dialogs,sizeof(PDLG_SUB));
						if sub_dialogs<>nil then
							begin
								pt:=Application^.GetAddr(RTICONS);
								with sub_dialogs^ do
									begin
										next:=nil;
										option_flags:=0;
										sub_id:=-1;
										sub_icon:=@pt^[RTIPRINTRANGE];
										sub_tree:=Application^.GetAddr(RTPRINTSUBDIAL);
										dialog:=nil;
										tree:=nil;
										index_offset:=0;
										reserved1:=0;
										reserved2:=0;
										init_dlg:=pinit_texel;
										do_dlg:=nil;
										reset_dlg:=preset_texel;
										reserved3:=0;
										private1:=0;
										private2:=0;
										private3:=0;
										private4:=0
									end;
								with AES_pb do
									begin
										control^[0]:=205;
										control^[1]:=1;
										control^[2]:=1;
										control^[3]:=2;
										control^[4]:=0;
										intin^[0]:=3;
										addrin^[0]:=TexelApp.prnt_dialog;
										addrin^[1]:=sub_dialogs;
										_crystal(@AES_pb)
									end
							end;
						docname:=TEXELWINDPREFIX+TITLE_SETUP+#0;
						with AES_pb do
							begin
								control^[0]:=207;
								control^[1]:=1;
								control^[2]:=1;
								control^[3]:=3;
								control^[4]:=0;
								intin^[0]:=PDLG_PREFS or PDLG_ALWAYS_COPIES or PDLG_ALWAYS_SCALE;
								addrin^[0]:=TexelApp.prnt_dialog;
								addrin^[1]:=TexelApp.app_prnt_set;
								addrin^[2]:=@docname[1];
								_crystal(@AES_pb)
							end;
						if sub_dialogs<>nil then
							begin
								with AES_pb do
									begin
										control^[0]:=205;
										control^[1]:=1;
										control^[2]:=1;
										control^[3]:=1;
										control^[4]:=0;
										intin^[0]:=4;
										addrin^[0]:=TexelApp.prnt_dialog;
										_crystal(@AES_pb)
									end;
								free_sub_dialogs(sub_dialogs)
							end;
						exit
					end;
				{$IFNDEF WDIALOG}
				if prnt=nil then
					begin
						new(prnt,Init(@self,TEXELWINDPREFIX+TITLE_SETUP,STG_PRINT,ICNTITLE_SETUPPRINTER,RTPRINT));
						if prnt<>nil then
							begin
								prnt^.drvinfo:=nil;
								new(PGroupBox,Init(prnt,RTPBEREICH,GROUP_GENERAL_RANGE,''));
								new(st,Init(prnt,RTPSUPTITLE,13,false,''));
								if st<>nil then st^.Hide(true);
								new(st,Init(prnt,RTPTITLE,43,true,''));
								if st<>nil then st^.SetText(STRING_DEFAULTPRINTER);
								new(PCheckBox,Init(prnt,RTPSHEET,true,BUBBLE_PRINT_SHEET));
								new(PCheckBox,Init(prnt,RTPFEED,true,BUBBLE_PRINT_FEED));
								new(pe,Init(prnt,RTPCOPIES,4,BUBBLE_PRINT_COPIES));
								if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(1,99)));
								new(pcb,Init(prnt,RTPPERCSIZE,RTPPSCYC,RTPPSTITLE,RTPOPUPS,RTPPRINTPERC,id_no,false,true,BUBBLE_PRINT_SCALE));
								if pcb<>nil then
									begin
										if pcb^.Popup<>nil then pcb^.Popup^.AutoCheck:=false;
										if pcb^.Edit<>nil then pcb^.Edit^.SetValidator(new(PRangeValidator,Init(MINPERCENT,MAXPERCENT)))
									end;
								new(drivers,Init(10,5));
								new(prnt^.drvbox,InitCollection(prnt,RTPDRIVER,RTPDRIVERCYC,RTPDRIVERTITLE,30,drivers,true,true,false,BUBBLE_PRINT_DRIVER));
								new(prnt^.inf,Init(prnt,RTPINFO,id_No,true,BUBBLE_PRINT_INFO));
								new(prnt^.druck,Init(prnt,RTPPRINT,id_No,true,BUBBLE_PRINT_PRINT));
								prnt^.devbox:=new(PDeviceBox,Init(prnt,RTPDEVICE,RTPDEVCYC,RTPDEVTITLE,RTPOPUPS,RTPDEVICES,id_No,false,false,BUBBLE_PRINT_DEVICE));
								new(pc,Init(prnt,RTPSW,true,BUBBLE_PRINT_BW));
								if pc<>nil then pc^.Disable; { ... }
								new(PRadioButton,Init(prnt,RTPPBLOCK,true,BUBBLE_PRINT_RANGE));
								new(PRadioButton,Init(prnt,RTPALL,true,BUBBLE_PRINT_ALL));
								new(PRadioButton,Init(prnt,RTPBLOCK,true,BUBBLE_PRINT_SELECTION));
								new(prnt^.paper,Init(prnt,RTPPSIZE,RTPPCYC,RTPPTITLE,RTPOPUPS,RTPPAPER,id_No,false,false,BUBBLE_PRINT_PAPER));
								new(pe,Init(prnt,RTPVON,4,BUBBLE_PRINT_PAGEFROM));
								if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(MINPAGES,MAXPAGESOLD)));
								new(PEdit,Init(prnt,RTPBIS,4,BUBBLE_PRINT_PAGETO));
								new(pb,Init(prnt,RTPHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(pb,Init(prnt,RTPPREVIEW,id_No,true,''));
								if pb<>nil then pb^.Hide(false);
								new(PButton,Init(prnt,RTPPAGESETUP,id_No,true,BUBBLE_PRINT_LAYOUT));
								new(PButton,Init(prnt,RTPOK,id_OK,true,BUBBLE_GENERAL_OK));
								new(PButton,Init(prnt,RTPCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								prnt^.SetDefaultButton(RTPOK);
								if prnt^.druck<>nil then prnt^.druck^.Hide(true);
								prnt^.TransferBuffer:=@TexelApp.stdprnbuffer
							end
					end;
				if prnt<>nil then prnt^.MakeWindow
				{$ENDIF}
			end
		end
	end;


procedure TOptionsDialog.EditPaths;
	var pb: PButton;

	begin
		if paths=nil then
			begin
				new(paths,Init(nil,TEXELWINDPREFIX+TITLE_PATHS,STG_PATHS,ICNTITLE_PATHS,RTPFADE));
				if paths<>nil then
					begin
						new(PGroupBox,Init(paths,RTPFGENERAL,'',''));
						new(PGroupBox,Init(paths,RTPFOBJECTS,GROUP_PATHS_OBJECTS,''));
						new(PGroupBox,Init(paths,RTPFIMPORT,GROUP_PATHS_IMPORT,''));
						new(paths^.pb0,Init(paths,RTPFTXL,id_No,0,true,'txl',BUBBLE_PATHS_TXL));
						new(paths^.pb15,Init(paths,RTPFEXPORT,id_No,15,true,'*',BUBBLE_PATHS_EXPORT));
						new(paths^.pb11,Init(paths,RTPFMETA,id_No,11,true,'gem',BUBBLE_PATHS_META));
						new(paths^.pb17,Init(paths,RTPFID4,id_No,17,true,'*',BUBBLE_PATHS_ID4));
						new(paths^.pb18,Init(paths,RTPFTEXT,id_No,18,true,'txt',BUBBLE_PATHS_TEXT));
						new(paths^.pb14,Init(paths,RTPFGRAFIK,id_No,14,true,'img',BUBBLE_PATHS_GRAFIK));
						new(paths^.pb19,Init(paths,RTPFDIAGRAMM,id_No,19,true,'tad',BUBBLE_PATHS_DIAGRAMM));
						new(paths^.pb9,Init(paths,RTPFLDW,id_No,9,true,'ldp',BUBBLE_PATHS_LDW));
						new(paths^.pb2,Init(paths,RTPFDIF,id_No,2,true,'dif',BUBBLE_PATHS_DIF));
						new(paths^.pb4,Init(paths,RTPFCSV,id_No,4,true,'csv',BUBBLE_PATHS_CSV));
						new(paths^.pb6,Init(paths,RTPFASCII,id_No,6,true,'*',BUBBLE_PATHS_ASCII));
						new(paths^.pb12,Init(paths,RTPFDBASE,id_No,12,true,'dbf',BUBBLE_PATHS_DBF));
						new(paths^.pb7,Init(paths,RTPFEXCEL,id_No,7,true,'xls',BUBBLE_PATHS_EXCEL));
						new(paths^.pb10,Init(paths,RTPF123,id_No,10,true,'wk?',BUBBLE_PATHS_123));
						new(paths^.pb20,Init(paths,RTPFPSION,id_No,20,true,'spr',BUBBLE_PATHS_PSION));
						new(pb,Init(paths,RTPFHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(paths,RTPFABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(paths,RTPFOK,id_OK,true,BUBBLE_GENERAL_OK))
					end
			end;
		if paths<>nil then
			begin
				paths^.UpdateButtons;
				paths^.MakeWindow
			end
	end;


constructor TPfadButton.Init(AParent: PDialog; AnIndx,AnID,pIdx: integer; UserDef: boolean; Ext,Hlp: string);

	begin
		if not(inherited Init(AParent,AnIndx,AnID,UserDef,Hlp)) then fail;
		pfadIndex:=pIdx;
		Extension:=Ext
	end;


procedure TPfadButton.Changed(AnIndx: integer; DblClick: boolean);

	begin
		if FilePathSelect(Parent,FSELTITLE_PATHS,'*.'+Extension,PPfadDialog(Parent)^.pfade[pfadIndex],PPfadDialog(Parent)^.namen[pfadIndex],true,false) then Update;
	end;


procedure TPfadButton.Update;

	begin
		SetText(CompressPath(PPfadDialog(Parent)^.pfade[pfadIndex]+PPfadDialog(Parent)^.namen[pfadIndex],23))
	end;


function TPfadDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false
	end;


function TPfadDialog.OK: boolean;
	var valid: boolean;
	    q    : integer;

	begin
		valid:=inherited OK;
		if valid then
			for q:=0 to PFMAX do
				if not(q in [1,3,5,8,13,16]) then
					begin
						TexelApp.LastPath[q]:=pfade[q];
						TexelApp.LastFile[q]:=namen[q]
					end;
		OK:=valid
	end;


procedure TPfadDialog.UpdateButtons;
	var q: integer;

	begin
		for q:=0 to PFMAX do
			begin
				pfade[q]:=TexelApp.LastPath[q];
				namen[q]:=TexelApp.LastFile[q]
			end;
		pb0^.Update;
		pb15^.Update;
		pb11^.Update;
		pb17^.Update;
		pb18^.Update;
		pb14^.Update;
		pb19^.Update;
		pb9^.Update;
		pb2^.Update;
		pb4^.Update;
		pb6^.Update;
		pb12^.Update;
		pb7^.Update;
		pb10^.Update;
		pb20^.Update
	end;

end.