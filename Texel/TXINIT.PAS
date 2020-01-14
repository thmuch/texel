unit txinit;
{ 1999-03-07 }

interface

uses

	OTypes,OWindows;


type

	PStartupHandler = ^TStartupHandler;
	TStartupHandler = object(TEvent)
		public
		constructor Init(AParent: PEventObject);
		destructor Done; virtual;
		private
		startup: PDialog;
		sta    : PStatic;
		buf    : PByteArray;
		bufsize: longint;
		procedure SetAction(s: string);
		procedure readConfigINF;
		procedure readConfigHistory;
		procedure readConfigUSRDAT;
		procedure readConfigUSRFRM;
		function readConfigDAT: boolean;
		function readConfigFRM: boolean;
		procedure readConfigPalette;
		procedure readConfigPaths;
		procedure readConfigPrintDialog;
	end;




implementation

uses

	Dos,Tos,Gem,
	OProcs,
	txrsc,txlang,txtypes,txprocs,txdhst,txabout,txhelp,
	txload,txspchar,tximport,txoption,txnew,txmain;



constructor TStartupHandler.Init(AParent: PEventObject);
	label _pfadgefunden;

	var txt  : string;
	    pipe : Pipearray;
	    level: integer;
	    opp  : boolean;
	    st   : PStatic;
	    tp   : PTree;
			pspc : PSpecialChars;

	begin
		if not(inherited Init(AParent)) then fail;
		startup:=nil;
		TexelApp.savework:=nil;
		TexelApp.sccsid:='@(#)Spreadsheet/Texel '+VtoS(TEXELVER)+' ('+TEXELDATE+'), Copyright 1994-99 Thomas Much.'#0;
		{$IFDEF ENGLISH}
		Application^.Attr.Country:=UK;
		{$ELSE}
		{$IFDEF FRENCH}
		Application^.Attr.Country:=FRA;
		{$ELSE}
		Application^.Attr.Country:=FRG;
		{$ENDIF}
		{$ENDIF}
		{$IFNDEF BETA}
		if not(KeyCorrect('','')) then
			begin
				{$IFDEF LITE}
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_MILAN,BUTTON_OK);
				{$ELSE}
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_UNREG,BUTTON_OK);
				{$ENDIF}
				Application^.Quit;
				inherited Done;
				fail
			end;
		{$ENDIF}
		if ((Application^.Attr.MaxPX+1) div Application^.Attr.charSWidth<80) or ((Application^.Attr.MaxPY+1) div Application^.Attr.charSHeight<25) then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_SCREEN,BUTTON_OK);
				Application^.Quit;
				inherited Done;
				fail
			end;
		randomize;
		{$IFNDEF DEMO}
		{$IFDEF BETA}
		if (gettime>EXPIRE) or (gettime<BUILT) then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_BETA,BUTTON_OK);
				Application^.Quit;
				inherited Done;
				fail
			end;
		{$ENDIF}
		{$ENDIF}
		{$IFDEF NVDI5}
		if NVDIVersion<$0500 then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_NVDI,BUTTON_OK);
				Application^.Quit;
				inherited Done;
				fail
			end;
		{$ENDIF}
		{$IFDEF WDIALOG}
		if not(TexelApp.SystemHasPrintDialog) then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_WDIALOG,BUTTON_OK);
				Application^.Quit;
				inherited Done;
				fail
			end;
		{$ENDIF}
		txt:=GetEnv('BROWSER');
		if length(txt)>0 then
			begin
				txt:=StrPUpper(GetFilename(txt,false));
				TexelApp.Browser:=txt+StrPSpace(8-length(txt))
			end
		else
			TexelApp.Browser:='CAB     ';
		with TexelApp do
			begin
				ColFX:=(Attr.Colors>LWhite);
				SheetCount:=0;
				mstimer:=TEXELTIMER;
				izitTicks:=0;
				izitWind:=id_No;
				ExtResource:=false;
				GSActive:=false;
				ddfiles:=nil;
				{$IFNDEF LITE}
				importscrap:=nil;
				{$ENDIF}
			end;
		BusyMouse;
		opp:=OpenPrivateProfile(TEXELINF);
		if opp then level:=GetPrivateProfileInt('Texel','Level',7,TEXELINF)
		else
			level:=8;
		TexelApp.DataPath:=GetPrivateProfileString('Setup','DataPath','',TEXELINF);
		if length(TexelApp.DataPath)=0 then
			begin
				txt:=TEXELAPPNAME;
				if shel_find(txt)<>0 then
					begin
						txt:=GetPath(txt);
						if length(txt)>0 then
							begin
								TexelApp.DataPath:=txt;
								goto _pfadgefunden
							end
					end;
				if Application^.apPath<>nil then TexelApp.DataPath:=Application^.apPath^;
				_pfadgefunden:
				if PathExist(TexelApp.DataPath+TEXELDATAPATH) then TexelApp.DataPath:=TexelApp.DataPath+TEXELDATAPATH;
			end;
		Application^.LoadResource(TexelApp.DataPath+TEXELRSC,'');
		if Application^.Status=em_RscNotFound then
			begin
				Application^.Quit;
				inherited Done;
				fail
			end;
		if not(TexelApp.LoadExtResource(TexelApp.DataPath+TEXELRSC2)) then
			begin
				Application^.Error(em_RscNotFound);
				Application^.Quit;
				inherited Done;
				fail
			end;
		readConfigPalette;
		{$IFDEF ENGLISH}
		Application^.BubbleHelpActive:=false;
		{$ELSE}
		{$IFDEF FRENCH}
		Application^.BubbleHelpActive:=false;
		{$ENDIF}
		{$ENDIF}
		ArrowMouse;
		{$IFDEF DEMO}
		if TexelApp.DemoNervAlert(false) then
			begin
				Application^.Quit;
				inherited Done;
				fail
			end;
		{$ENDIF}
		{$IFDEF LITE}
		if TexelApp.DemoNervAlert(false) then
			begin
				Application^.Quit;
				exit
			end;
		if not(KeyCorrect('','')) then
			begin
				Application^.Quit;
				exit
			end;
		{$ENDIF}
		sta:=nil;
		new(startup,Init(nil,'',RTSTART));
		if startup<>nil then
			begin
				new(st,Init(startup,RTSTVERSION,13,false,''));
				{$IFDEF LITE}
				if st<>nil then st^.SetText('Home (Milan)');
				{$ELSE}
				if st<>nil then st^.SetText('Version '+VtoS(TEXELVER));
				{$ENDIF}
				new(sta,Init(startup,RTSTACTION,30,false,''));
				SetAction('');
				with startup^ do
					begin
						Attr.Style:=0;
						Attr.ExStyle:=(Attr.ExStyle and not(ws_ex_TryModeless)) or ws_ex_Modeless;
						MakeWindow;
						if Application^.ChkError=em_InvalidWindow then
							begin
								Application^.Error(em_InvalidWindow);
								Application^.Quit;
								inherited Done;
								fail
							end;
						WMRedraw(Work.X,Work.Y,Work.W,Work.H)
					end
			end;
		readConfigINF;
		readConfigPaths;
		SetAction(STARTUP_STRUCTS);
		with TexelApp.ascbuf do
			begin
				rcTxt:=StrPMid(rcTxt,2,length(rcTxt)-2);
				cellTxt:=StrPMid(cellTxt,2,length(cellTxt)-2);
				textTxt:=StrPMid(textTxt,2,length(textTxt)-2)
			end;
		with TexelApp.stdpsbuffer do
			begin
				hleft:=StrPMid(hleft,2,length(hleft)-2);
				hmid:=StrPMid(hmid,2,length(hmid)-2);
				hright:=StrPMid(hright,2,length(hright)-2);
				fleft:=StrPMid(fleft,2,length(fleft)-2);
				fmid:=StrPMid(fmid,2,length(fmid)-2);
				fright:=StrPMid(fright,2,length(fright)-2)
			end;
		with TexelApp.tipflags do
			begin
				start:=bf_Checked;
				nr:=0;
				resvd:=0
			end;
		with TexelApp do
			begin
				oldTipStart:=tipflags.start;
				if setupbuffer.wysiwyg=bf_Checked then
					begin
						Attr.PixW:=setupbuffer.pixw;
						Attr.PixH:=setupbuffer.pixh
					end
			end;
		if (length(regname)<5) or (length(regkey)<6) or not(KeyCorrect(regname,regkey)) then
			begin
				regname:='';
				regkey:=''
			end;
		{$IFNDEF BETA}
		regname:='';
		regkey:='';
		{$ENDIF}
		{$IFDEF DEMO}
		regname:='';
		regkey:='';
		{$ENDIF}
		with TexelApp do
			begin
				LoadIcon(RTICONS,RTICALC);
				LoadMenu(RTMENU);
				prnt_dialog:=nil;
				fnt_dialog:=nil;
				app_prnt_set:=nil;
				if NoFontSel then
					begin
						tp:=GetAddr(RTPOPUPS);
						if tp<>nil then
							with tp^[tp^[RTPFORMCELL].ob_head] do ob_state:=ob_state or DISABLED;
					end;
				with setupbuffer do
					if (opennew=bf_Unchecked) and (loaddoc=bf_Unchecked) and (nothing=bf_Unchecked) then nothing:=bf_Checked;
				if setupbuffer.xinputmode=bf_Checked then Attr.Style:=Attr.Style or as_XInputMode;
				if setupbuffer.closercancel=bf_Checked then Attr.Style:=Attr.Style or as_CancelOnClose;
				scripthnd:=nil;
				GEMScriptID:=-1;
				GlobalAlloc(helpbuf,768+sizeof(TGSInfo));
				if helpbuf=nil then
					begin
						filebuf:=nil;
						mailbuf:=nil;
						HelpID:=-1;
						WebID:=-1;
						GSInfo:=nil
					end
				else
					begin
						mailbuf:=pointer(longint(helpbuf)+256);
						filebuf:=pointer(longint(helpbuf)+512);
						HelpID:=appl_find('ST-GUIDE');
						WebID:=appl_find(Browser);
						if WebID>=0 then
							begin
								pipe[0]:=CAB_SUPPORT;
								pipe[1]:=apID;
								pipe[2]:=0;
								pipe[3]:=0;
								pipe[4]:=0;
								pipe[5]:=0;
								pipe[6]:=0;
								pipe[7]:=0;
								appl_write(WebID,16,@pipe);
								WebID:=-1
							end;
						GSInfo:=PGSInfo(longint(helpbuf)+768);
						with GSInfo^ do
							begin
								Len:=sizeof(TGSInfo);
								Version:=$0120;
								Msgs:=GSM_COMMAND or GSM_HEXCODING;
								Ext:=#0#0#0#0
							end
					end;
				about:=new(PAbout,Init(nil,RTMABOUT,nil,false));
				createdoc:=new(PNew,Init(nil,K_CTRL,Ctrl_N,RTMNEW,RTM2));
				if createdoc<>nil then PNew(createdoc)^.CheckMenuEntry;
				opennewdoc:=new(POpen,Init(nil,K_CTRL,Ctrl_O,RTMOPEN,RTM2));
			end;
		readConfigHistory;
		SetAction(STARTUP_MENUS);
		with TexelApp do
			begin
				openurl:=new(POpenURL,Init(nil,K_ALT,Alt_U,RTMURLOPEN,RTM2));
				if openurl<>nil then openurl^.Disable;
				import:=new(PImport,Init(nil,RTMIMPORT,RTPOPUPS,RTPIMPORT));
				if import<>nil then
					begin
						{$IFDEF LITE}
						import^.Disable
						{$ELSE}
						PImport(import)^.ascii:=nil;
						PImport(import)^.gdbc:=nil;
						PImport(import)^.quelle:=''
						{$ENDIF}
					end
			end;
		new(pspc,Init(nil,K_SHIFT,Shift_Ins,RTMSPECIALCHARS,RTM4));
		TexelApp.options:=new(POptions,Init(nil,K_CTRL+K_SHIFT,Ctrl_E,RTMOPTIONS,RTM4));
		TexelApp.saveopt:=new(PSaveOpt,Init(nil,K_CTRL+K_SHIFT,Ctrl_S,RTMSAVEOPTIONS,RTM4));
		TexelApp.savework:=new(PSaveWork,Init(nil,RTMSAVEWORK,nil,false));
		{$IFDEF LITE}
		if pspc<>nil then pspc^.Disable;
		if TexelApp.savework<>nil then TexelApp.savework^.Disable;
		{$ENDIF}
		TexelApp.webhelp:=new(PWeb,Init(nil,RTMHELPASH,nil,false));
		if TexelApp.webhelp<>nil then TexelApp.webhelp^.Disable;
		TexelApp.websupport:=new(PWeb,Init(nil,RTMHELPSUPPORT,nil,false));
		if TexelApp.websupport<>nil then TexelApp.websupport^.Disable;
		if not(Exist(TexelApp.DataPath+TEXELTIPS)) then TexelApp.tips:=nil
		else
			TexelApp.tips:=new(PTip,Init(nil,RTMHELPTIPS,nil,false));
		if TexelApp.tips<>nil then TexelApp.tips^.Enable;
		TexelApp.help1:=new(PHelp,Init(nil,RTMHELPONHELP,nil,false));
		if TexelApp.help1<>nil then
			if not(TexelApp.HelpAvailable(false)) then TexelApp.help1^.Disable;
		TexelApp.help2:=new(PHelp,Init(nil,RTMHELPCONTEXT,nil,false));
		if TexelApp.help2<>nil then
			if not(TexelApp.HelpAvailable(false)) then TexelApp.help2^.Disable;
		TexelApp.help3:=new(PHelp,Init(nil,RTMHELPCONTENTS,nil,false));
		if TexelApp.help3<>nil then
			if not(TexelApp.HelpAvailable(false)) then TexelApp.help3^.Disable;
		TexelApp.help4:=new(PHelp,Init(nil,RTMHELPINDEX,nil,false));
		if TexelApp.help4<>nil then
			if not(TexelApp.HelpAvailable(false)) then TexelApp.help4^.Disable;
		TexelApp.help5:=new(PHelpItem,Init(nil,K_CTRL,Ctrl_Help,RTMHELPITEM,RTM5));
		if TexelApp.help5<>nil then
			if not(TexelApp.HelpAvailable(false)) then TexelApp.help5^.Disable;
		ScanFonts(Application^.vdiHandle,Application^.Attr.sysFonts+Application^.Attr.addFonts,TexelApp.Fonts);
		if level>=8 then
			begin
				TexelApp.FontID2Index(TexelApp.setupbuffer.stdfont);
				TexelApp.FontSize2Index(TexelApp.setupbuffer.stdfont,TexelApp.setupbuffer.stdfsize)
			end;
		TexelApp.OLETypes:=nil;
		new(TexelApp.Functions,Init(50,10));
		new(TexelApp.Categories,Init(20,5));
		new(TexelApp.FormCategories,Init(15,5));
		new(TexelApp.Formats,Init(50,10));
		new(TexelApp.UsrForm,Init(30,20));
		buf:=GetMemBuffer(16384,128,bufsize);
		if (TexelApp.Functions=nil) or (TexelApp.Categories=nil) or (TexelApp.FormCategories=nil) or
		   (TexelApp.Formats=nil) or (TexelApp.UsrForm=nil) or (buf=nil) then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_GENERAL_MEMORY,BUTTON_OK);
				Application^.Quit;
				inherited Done;
				fail
			end;
		if readConfigDAT then exit;
		readConfigUSRDAT;
		if readConfigFRM then exit;
		readConfigUSRFRM;
		freemem(buf,bufsize);
		readConfigPrintDialog;
		ArrowMouse;
		SetAction(STARTUP_FINISH)
	end;


destructor TStartupHandler.Done;

	begin
		Application^.SetQuit(RTMQUIT,RTM2);
		if startup<>nil then dispose(startup,Done);
		inherited Done
	end;


procedure TStartupHandler.SetAction(s: string);

	begin
		if sta<>nil then sta^.SetText(s+'...');
	end;
	

procedure TStartupHandler.readConfigINF;

	begin
		SetAction(STARTUP_INF);
		SliceMouse;
		TexelApp.setupbuffer.opennew:=GetPrivateProfileInt('Setup','OpenNew',bf_Unchecked,TEXELINF);
		TexelApp.setupbuffer.loaddoc:=GetPrivateProfileInt('Setup','LoadDoc',bf_Unchecked,TEXELINF);
		TexelApp.setupbuffer.nothing:=GetPrivateProfileInt('Setup','Nothing',bf_Unchecked,TEXELINF);
		TexelApp.setupbuffer.saveopt:=GetPrivateProfileInt('Setup','SaveOpt',bf_Unchecked,TEXELINF);
		TexelApp.setupbuffer.savework:=GetPrivateProfileInt('Setup','SaveWork',bf_Unchecked,TEXELINF);
		SliceMouseNext;
		TexelApp.setupbuffer.fullsize:=GetPrivateProfileInt('Setup','FullSize',bf_Unchecked,TEXELINF);
		TexelApp.setupbuffer.wysiwyg:=GetPrivateProfileInt('Setup','WYSIWYG',bf_Unchecked,TEXELINF);
		TexelApp.setupbuffer.recalc:=GetPrivateProfileInt('Setup','Recalc',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.online:=GetPrivateProfileInt('Setup','Online',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.bak:=GetPrivateProfileInt('Setup','Backup',bf_Checked,TEXELINF);
		SliceMouseNext;
		TexelApp.setupbuffer.formerr:=GetPrivateProfileInt('Setup','FormErr',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.toolbar:=GetPrivateProfileInt('Setup','Toolbar',bf_Checked,TEXELINF);
		{$IFDEF FRENCH}
		TexelApp.setupbuffer.currency:=GetPrivateProfileInt('Setup','Currency',3,TEXELINF);
		{$ELSE}
		{$IFDEF ENGLISH}
		TexelApp.setupbuffer.currency:=GetPrivateProfileInt('Setup','Currency',1,TEXELINF);
		{$ELSE}
		TexelApp.setupbuffer.currency:=GetPrivateProfileInt('Setup','Currency',0,TEXELINF);
		{$ENDIF}
		{$ENDIF}
		TexelApp.setupbuffer.overflow:=GetPrivateProfileInt('Setup','Overflow',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.bottomline:=GetPrivateProfileInt('Setup','BottomLine',bf_Unchecked,TEXELINF);
		SliceMouseNext;
		TexelApp.setupbuffer.pixw:=GetPrivateProfileInt('Setup','WYSIWYG.PixW',282,TEXELINF);
		TexelApp.setupbuffer.pixh:=GetPrivateProfileInt('Setup','WYSIWYG.PixH',282,TEXELINF);
		TexelApp.setupbuffer.cursorwrap:=GetPrivateProfileInt('Setup','CursorWrap',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.xinputmode:=GetPrivateProfileInt('Setup','XInputMode',bf_Unchecked,TEXELINF);
		TexelApp.setupbuffer.closercancel:=GetPrivateProfileInt('Setup','CancelOnClose',bf_Checked,TEXELINF);
		SliceMouseNext;
		TexelApp.setupbuffer.sizerrange:=GetPrivateProfileString('Setup','SizerRange','1',TEXELINF);
		TexelApp.setupbuffer.floatpoint:=GetPrivateProfileString('Setup','FloatingPoint','2',TEXELINF);
		TexelApp.setupbuffer.history:=GetPrivateProfileString('Setup','History','4',TEXELINF);
		{$IFNDEF WDIALOG}
		TexelApp.UseExtPrn:=(GetPrivateProfileInt('Setup','ExtPrnSel',bf_Checked,TEXELINF)=bf_Checked);
		{$ENDIF}
		TexelApp.UseNewToolbar:=(GetPrivateProfileInt('Setup','NewToolbar',bf_Checked,TEXELINF)=bf_Checked);
		TexelApp.CheckHistory:=(GetPrivateProfileInt('Setup','CheckHistory',bf_Checked,TEXELINF)=bf_Checked);
		SliceMouseNext;
		TexelApp.setupbuffer.stdrows:=GetPrivateProfileString('CalcWindowDefaults','Rows','64',TEXELINF);
		TexelApp.setupbuffer.stdcolumns:=GetPrivateProfileString('CalcWindowDefaults','Columns','32',TEXELINF);
		TexelApp.setupbuffer.stdcolwidth:=GetPrivateProfileString('CalcWindowDefaults','StdColWidth','10',TEXELINF);
		TexelApp.setupbuffer.stdfsize:=GetPrivateProfileInt('CalcWindowDefaults','StdFontSize',10,TEXELINF);
		TexelApp.setupbuffer.stdfont:=GetPrivateProfileInt('CalcWindowDefaults','StdFont',0,TEXELINF);
		SliceMouseNext;
		TexelApp.setupbuffer.autocalc:=GetPrivateProfileInt('CalcWindowDefaults','AutoCalc',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.exceldate:=GetPrivateProfileInt('CalcWindowDefaults','ExcelDate',bf_Unchecked,TEXELINF);
		TexelApp.stdprnbuffer.pblock:=GetPrivateProfileInt('Printer','PBlock',bf_Checked,TEXELINF);
		TexelApp.stdprnbuffer.alles:=GetPrivateProfileInt('Printer','Alles',bf_Unchecked,TEXELINF);
		TexelApp.stdprnbuffer.block:=GetPrivateProfileInt('Printer','Block',bf_Unchecked,TEXELINF);
		SliceMouseNext;
		{$IFNDEF WDIALOG}
		TexelApp.stdprnbuffer.driver:=GetPrivateProfileInt('Printer','Driver',0,TEXELINF);
		TexelApp.stdprnbuffer.device:=GetPrivateProfileInt('Printer','Device',1,TEXELINF);
		TexelApp.stdprnbuffer.copies:=ltoa(GetPrivateProfileIntRange('Printer','Copies',1,1,99,TEXELINF));
		TexelApp.stdprnbuffer.von:=ltoa(GetPrivateProfileIntRange('Printer','Von',1,MINPAGES,MAXPAGESOLD,TEXELINF));
		TexelApp.stdprnbuffer.bis:=ltoa(GetPrivateProfileIntRange('Printer','Bis',999,MINPAGES,MAXPAGESOLD,TEXELINF));
		SliceMouseNext;
		TexelApp.stdprnbuffer.percent:=ltoa(GetPrivateProfileIntRange('Printer','Percent',100,MINPERCENT,MAXPERCENT,TEXELINF));
		TexelApp.stdprnbuffer.prcindx:=0;
		TexelApp.stdprnbuffer.papier:=GetPrivateProfileInt('Printer','Papier',0,TEXELINF);
		TexelApp.stdprnbuffer.sheet:=GetPrivateProfileInt('Printer','Sheet',bf_Checked,TEXELINF);
		TexelApp.stdprnbuffer.sw:=GetPrivateProfileInt('Printer','BlackWhite',bf_Unchecked,TEXELINF);
		TexelApp.stdprnbuffer.feed:=GetPrivateProfileInt('Printer','Feed',bf_Checked,TEXELINF);
		SliceMouseNext;
		{$ENDIF}
		TexelApp.ascbuf.hor:=GetPrivateProfileInt('Import','Hor',bf_Checked,TEXELINF);
		TexelApp.ascbuf.vert:=GetPrivateProfileInt('Import','Vert',bf_Unchecked,TEXELINF);
		TexelApp.ascbuf.rcTxt:=GetPrivateProfileString('Import','rcTxt','"13,10"',TEXELINF);
		TexelApp.ascbuf.rcval:=GetPrivateProfileInt('Import','rcVal',0,TEXELINF);
		TexelApp.ascbuf.cellTxt:=GetPrivateProfileString('Import','cellTxt','"9"',TEXELINF);
		SliceMouseNext;
		TexelApp.ascbuf.cellval:=GetPrivateProfileInt('Import','cellVal',0,TEXELINF);
		TexelApp.ascbuf.textTxt:=GetPrivateProfileString('Import','textTxt','"34"',TEXELINF);
		TexelApp.ascbuf.textval:=GetPrivateProfileInt('Import','textVal',0,TEXELINF);
		TexelApp.ascbuf.quote:=GetPrivateProfileInt('Import','Quote',bf_Checked,TEXELINF);
		TexelApp.ascbuf.numbers:=GetPrivateProfileInt('Import','Numbers',0,TEXELINF);
		SliceMouseNext;
		TexelApp.ascbuf.filter:=GetPrivateProfileInt('Import','Filter',0,TEXELINF);
		TexelApp.stdpsbuffer.oben:=GetPrivateProfileString('Page Setup','Oben','0',TEXELINF);
		TexelApp.stdpsbuffer.unten:=GetPrivateProfileString('Page Setup','Unten','0',TEXELINF);
		TexelApp.stdpsbuffer.links:=GetPrivateProfileString('Page Setup','Links','0',TEXELINF);
		TexelApp.stdpsbuffer.rechts:=GetPrivateProfileString('Page Setup','Rechts','0',TEXELINF);
		SliceMouseNext;
		TexelApp.stdpsbuffer.kopf:=GetPrivateProfileString('Page Setup','Kopf','0',TEXELINF);
		TexelApp.stdpsbuffer.fuss:=GetPrivateProfileString('Page Setup','Fuss','0',TEXELINF);
		TexelApp.stdpsbuffer.bereich:=GetPrivateProfileString('Page Setup','Bereich','',TEXELINF);
		TexelApp.stdpsbuffer.hleft:=GetPrivateProfileString('Page Setup','hLeft','""',TEXELINF);
		TexelApp.stdpsbuffer.hmid:=GetPrivateProfileString('Page Setup','hMid','""',TEXELINF);
		SliceMouseNext;
		TexelApp.stdpsbuffer.hright:=GetPrivateProfileString('Page Setup','hRight','""',TEXELINF);
		TexelApp.stdpsbuffer.fleft:=GetPrivateProfileString('Page Setup','fLeft','""',TEXELINF);
		TexelApp.stdpsbuffer.fmid:=GetPrivateProfileString('Page Setup','fMid','""',TEXELINF);
		TexelApp.stdpsbuffer.fright:=GetPrivateProfileString('Page Setup','fRight','""',TEXELINF);
		TexelApp.stdpsbuffer.hcenter:=GetPrivateProfileInt('Page Setup','hCenter',bf_Unchecked,TEXELINF);
		SliceMouseNext;
		TexelApp.stdpsbuffer.vcenter:=GetPrivateProfileInt('Page Setup','vCenter',bf_Unchecked,TEXELINF);
		TexelApp.stdpsbuffer.gitter:=GetPrivateProfileInt('Page Setup','Gitter',bf_Checked,TEXELINF);
		TexelApp.stdpsbuffer.rows:=GetPrivateProfileInt('Page Setup','Rows',bf_Unchecked,TEXELINF);
		TexelApp.stdpsbuffer.columns:=GetPrivateProfileInt('Page Setup','Columns',bf_Unchecked,TEXELINF);
		TexelApp.stdpsbuffer.num1:=GetPrivateProfileInt('Page Setup','Num1',bf_Checked,TEXELINF);
		SliceMouseNext;
		TexelApp.stdpsbuffer.num2:=GetPrivateProfileInt('Page Setup','Num2',bf_Unchecked,TEXELINF);
		TexelApp.stdpsbuffer.hlefton:=GetPrivateProfileInt('Page Setup','hLeftOn',bf_Checked,TEXELINF);
		TexelApp.stdpsbuffer.hcenteron:=GetPrivateProfileInt('Page Setup','hCenterOn',bf_Checked,TEXELINF);
		TexelApp.stdpsbuffer.hrighton:=GetPrivateProfileInt('Page Setup','hRightOn',bf_Checked,TEXELINF);
		TexelApp.stdpsbuffer.flefton:=GetPrivateProfileInt('Page Setup','fLeftOn',bf_Checked,TEXELINF);
		SliceMouseNext;
		TexelApp.stdpsbuffer.fcenteron:=GetPrivateProfileInt('Page Setup','fCenterOn',bf_Checked,TEXELINF);
		TexelApp.stdpsbuffer.frighton:=GetPrivateProfileInt('Page Setup','fRightOn',bf_Checked,TEXELINF);
		TexelApp.stdpsbuffer.images:=GetPrivateProfileInt('Page Setup','Images',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.formerrcell:=GetPrivateProfileInt('Setup','FormErrCell',bf_Checked,TEXELINF);
		TexelApp.setupbuffer.infodial:=GetPrivateProfileInt('Setup','InfoDial',bf_Unchecked,TEXELINF);
		SliceMouseNext;
		regname:=GetPrivateProfileString('Beta','Name','',TEXELINF);
		regkey:=GetPrivateProfileString('Beta','Key','',TEXELINF);
		ArrowMouse
	end;
	
	
procedure TStartupHandler.readConfigHistory;
	label _fehler;
	
	var res,
	    aret: longint;
	    hdl,
	    q,w : integer;
	    tipf: TTipFlags;
	    txt : string;

	begin
		TexelApp.ActivateExtResource;
		TexelApp.abruf:=new(PAbruf,Init(nil,RTMABRUF,RTPOPUPS2,RTP2ABRUF));
		TexelApp.DeactivateExtResource;
		if TexelApp.abruf<>nil then
			begin
				SetAction(STARTUP_HISTORY);
				res:=fopen(GetHomeDir(false)+'defaults\'+TEXELHISTORY,0);
				if res<0 then res:=fopen(GetHomeDir(false)+TEXELHISTORY,0);
				if res>=0 then
					begin
						hdl:=integer(res);
						if fread(hdl,2,@q)<>2 then goto _fehler;
						if q>0 then
							for w:=0 to q-1 do
								begin
									if fread(hdl,1,@txt[0])<>1 then goto _fehler;
									if ord(txt[0])>0 then
										if fread(hdl,ord(txt[0]),@txt[1])<>ord(txt[0]) then goto _fehler;
									if not(TexelApp.CheckHistory) then PAbruf(TexelApp.abruf)^.Add(txt,false)
									else
										begin
											aret:=fopen(txt,FO_READ);
											if aret>=0 then
												begin
													fclose(integer(aret));
													PAbruf(TexelApp.abruf)^.Add(txt,false)
												end
										end
								end;
						if fread(hdl,sizeof(TTipFlags),@tipf)=sizeof(TTipFlags) then
							begin
								TexelApp.tipflags:=tipf;
								TexelApp.oldTipStart:=TexelApp.tipflags.start
							end;
						_fehler:
						fclose(hdl)
					end;
				PAbruf(TexelApp.abruf)^.Dirty:=false
			end
	end;

	
procedure TStartupHandler.readConfigUSRDAT;
	var res,
	    w,opc  : longint;
	    hdl,q  : integer;
	    pf     : PFunction;
	    fdescr1,
	    fdescr2,
	    fname,
	    txt    : string;

	begin
		SetAction(STARTUP_USRDAT);
		res:=fopen(TexelApp.DataPath+TEXELUSRDAT,FO_READ);
		if res>=0 then
			begin
				txt:='';
				hdl:=integer(res);
				repeat
					res:=fread(hdl,bufsize,buf);
					if res>0 then
						for w:=0 to res-1 do
							if buf^[w]=CR then
								begin
									StrPTrim(txt);
									if length(txt)>0 then
										if txt[1]<>';' then
											begin
												q:=pos(';',txt);
												if q>0 then
													begin
														fdescr1:=StrPTrimF(StrPRight(txt,length(txt)-q));
														txt:=StrPTrimF(StrPLeft(txt,q-1));
														q:=pos('|',fdescr1);
														if q>0 then
															begin
																fdescr2:=StrPTrimF(StrPRight(fdescr1,length(fdescr1)-q));
																fdescr1:=StrPTrimF(StrPLeft(fdescr1,q-1))
															end
														else
															fdescr2:=''
													end
												else
													begin
														fdescr1:='';
														fdescr2:=''
													end;
												q:=pos(' ',txt);
												if q=0 then continue;
												fname:=StrPLeft(txt,q-1);
												opc:=atol(StrPTrimF(StrPRight(txt,length(txt)-q)));
												if not(Between(opc,0,22000)) then continue;
												new(pf);
												if pf<>nil then
													begin
														pf^.Opcode:=10000+opc;
														pf^.Group:=12;
														pf^.ArgMin:=1;
														pf^.ArgMax:=32767;
														pf^.ArgFlags:=0;
														pf^.Name:=NewStr(fname);
														if pf^.Name=nil then dispose(pf)
														else
															begin
																pf^.Descr1:=NewStr(fdescr1);
																pf^.Descr2:=NewStr(fdescr2);
																TexelApp.Functions^.Insert(pf)
															end
													end
											end;
									txt:=''
								end
							else
								if buf^[w]>=32 then txt:=txt+chr(buf^[w])
				until res<>bufsize;
				fclose(hdl)
			end
	end;
	

procedure TStartupHandler.readConfigUSRFRM;
	var res,
	    w  : longint;
	    hdl: integer;
	    pfm: PFormat;
	    txt: string;

	begin
		SetAction(STARTUP_USRFRM);
		TexelApp.UsrForm^.Sort:=false;
		res:=fopen(TexelApp.DataPath+TEXELUSRFRM,FO_READ);
		if res>=0 then
			begin
				txt:='';
				hdl:=integer(res);
				repeat
					res:=fread(hdl,bufsize,buf);
					if res>0 then
						for w:=0 to res-1 do
							if buf^[w]=CR then
								begin
									StrPTrim(txt);
									if length(txt)>0 then
										if txt[1]<>';' then
											begin
												new(pfm);
												if pfm<>nil then
													begin
														pfm^.Group:=1;
														pfm^.Index:=1000+TexelApp.UsrForm^.Count;
														pfm^.Name:=NewStr(txt);
														TexelApp.UsrForm^.Insert(pfm)
													end
											end;
									txt:=''
								end
							else
								if buf^[w]>=32 then txt:=txt+chr(buf^[w])
				until res<>bufsize;
				fclose(hdl)
			end
	end;
	

function TStartupHandler.readConfigDAT: boolean;
	var res,
	    w,opc  : longint;
	    hdl,q,
	    gr     : integer;
	    pcg    : PCategory;
	    pf     : PFunction;
	    fdescr1,
	    fdescr2,
	    fname,
	    fparm,
	    txt    : string;

	begin
		readConfigDAT:=true;
		SetAction(STARTUP_DAT);
		TexelApp.Functions^.Sort:=true;
		TexelApp.Functions^.CaseSensitive:=false;
		TexelApp.Categories^.Sort:=false;
		new(pcg);
		if pcg<>nil then
			begin
				pcg^.Group:=0;
				pcg^.Name:=NewStr('  '+STRING_ALL+' '#0);
				TexelApp.Categories^.Insert(pcg)
			end;
		BusyMouse;
		res:=fopen(TexelApp.DataPath+TEXELDAT,FO_READ);
		if res<0 then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_LOAD1+TEXELDAT+MESSAGE_STARTUP_LOAD2,BUTTON_OK);
				Application^.Quit;
				exit
			end;
		hdl:=integer(res);
		txt:='';
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for w:=0 to res-1 do
					if buf^[w]=CR then
						begin
							StrPTrim(txt);
							if length(txt)>0 then
								begin
									if txt[1]='#' then
										begin
											q:=pos(' ',txt);
											if q>0 then
												begin
													new(pcg);
													if pcg<>nil then
														begin
															pcg^.Group:=atol(StrPMid(txt,2,q-2));
															pcg^.Name:=NewStr('  '+StrPLeft(StrPTrimF(StrPRight(txt,length(txt)-q)),20)+' '#0);
															TexelApp.Categories^.Insert(pcg)
														end
												end
										end
									else
										if txt[1]<>';' then
											begin
												q:=pos(';',txt);
												if q>0 then
													begin
														fdescr1:=StrPTrimF(StrPRight(txt,length(txt)-q));
														txt:=StrPTrimF(StrPLeft(txt,q-1));
														q:=pos('|',fdescr1);
														if q>0 then
															begin
																fdescr2:=StrPTrimF(StrPRight(fdescr1,length(fdescr1)-q));
																fdescr1:=StrPTrimF(StrPLeft(fdescr1,q-1))
															end
														else
															fdescr2:=''
													end
												else
													begin
														fdescr1:='';
														fdescr2:=''
													end;
												q:=pos(' ',txt);
												if q=0 then continue;
												fname:=StrPLeft(txt,q-1);
												txt:=StrPTrimF(StrPRight(txt,length(txt)-q));
												q:=pos(' ',txt);
												if q=0 then continue;
												fparm:=StrPLeft(txt,q-1);
												txt:=StrPTrimF(StrPRight(txt,length(txt)-q));
												q:=pos(' ',txt);
												if q>0 then
													begin
														gr:=atol(StrPRight(txt,length(txt)-q));
														opc:=atol(StrPLeft(txt,q-1))
													end
												else
													begin
														gr:=0;
														opc:=atol(txt)
													end;
												if opc<1000 then continue;
												new(pf);
												if pf<>nil then
													begin
														pf^.Opcode:=opc;
														pf^.Group:=gr;
														pf^.Name:=NewStr(fname);
														if pf^.Name=nil then dispose(pf)
														else
															begin
																if fparm='0' then
																	begin
																		pf^.ArgMin:=0;
																		pf^.ArgMax:=0;
																		pf^.ArgFlags:=FFL_FIXARGS
																	end
																else if fparm='1' then
																	begin
																		pf^.ArgMin:=1;
																		pf^.ArgMax:=1;
																		pf^.ArgFlags:=FFL_FIXARGS
																	end
																else if fparm='1!' then
																	begin
																		pf^.ArgMin:=1;
																		pf^.ArgMax:=1;
																		pf^.ArgFlags:=FFL_RANGEONLY or FFL_FIXARGS
																	end
																else if StrPLeft(fparm,1)='2' then
																	begin
																		pf^.ArgMin:=2;
																		pf^.ArgMax:=2;
																		pf^.ArgFlags:=FFL_FIXARGS;
																		if StrPRight(fparm,1)<>'?' then pf^.ArgFlags:=pf^.ArgFlags or FFL_SECONDFIX;
																	end
																else
																	begin
																		if StrPMid(fparm,2,1)='*' then pf^.ArgMin:=1
																		else
																			pf^.ArgMin:=atol(StrPMid(fparm,2,1));
																		if StrPRight(fparm,1)='*' then pf^.ArgMax:=32767
																		else
																			pf^.ArgMax:=atol(StrPRight(fparm,1));
																		if StrPLeft(fparm,1)='#' then pf^.ArgFlags:=0
																		else
																			pf^.ArgFlags:=FFL_NORANGE;
																	end;
																pf^.Descr1:=NewStr(fdescr1);
																pf^.Descr2:=NewStr(fdescr2);
																TexelApp.Functions^.Insert(pf);
																if opc=NT_SUMME then TexelApp.SumName:=fname;
															end
													end
											end
								end;
							txt:=''
						end
					else
						if buf^[w]>=32 then txt:=txt+chr(buf^[w]);
		until res<>bufsize;
		fclose(hdl);
		readConfigDAT:=false
	end;
	

function TStartupHandler.readConfigFRM: boolean;
	var res,
	    w,opc: longint;
	    hdl,
	    q,e  : integer;
	    pfm  : PFormat;
	    txt  : string;

	begin
		readConfigFRM:=true;
		SetAction(STARTUP_FRM);
		TexelApp.FormCategories^.Sort:=false;
		TexelApp.Formats^.Sort:=false;
		res:=fopen(TexelApp.DataPath+TEXELFRM,FO_READ);
		if res<0 then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_LOAD1+TEXELFRM+MESSAGE_STARTUP_LOAD2,BUTTON_OK);
				Application^.Quit;
				exit
			end;
		hdl:=integer(res);
		txt:='';
		TexelApp.FormPredef:=-2;
		fillchar(TexelApp.FormStart,sizeof(TexelApp.FormStart),0);
		new(pfm);
		if pfm<>nil then
			begin
				pfm^.Name:=NewStr(STRING_STANDARD);
				pfm^.Group:=0;
				pfm^.Index:=0;
				TexelApp.Formats^.Insert(pfm)
			end;
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for w:=0 to res-1 do
					if buf^[w]=CR then
						begin
							StrPTrim(txt);
							if length(txt)>0 then
								if txt[1]='#' then
									begin
										q:=pos(' ',txt);
										if q>0 then
											TexelApp.FormCategories^.Insert(NewStr('  '+StrPLeft(StrPTrimF(StrPRight(txt,length(txt)-q)),17)+' '#0));
									end
								else
									if txt[1]='=' then TexelApp.FormPredef:=atol(StrPTrimF(StrPRight(txt,length(txt)-1)))
									else
										if txt[1]='c' then
											begin
												txt:=StrPTrimF(StrPRight(txt,length(txt)-1));
												for q:=0 to 14 do
													begin
														e:=pos(' ',txt);
														TexelApp.Farben[q]:=StrPLeft(txt,e-1);
														txt:=StrPTrimF(StrPRight(txt,length(txt)-e))
													end;
												TexelApp.Farben[15]:=txt
											end
										else
											if txt[1]='m' then
												begin
													if txt[2]='1' then
														begin
															txt:=StrPTrimF(StrPRight(txt,length(txt)-2));
															for q:=1 to 11 do
																begin
																	e:=pos(' ',txt);
																	TexelApp.Monate[q]:=StrPLeft(txt,e-1);
																	txt:=StrPTrimF(StrPRight(txt,length(txt)-e))
																end;
															TexelApp.Monate[12]:=txt
														end
													else
														begin
															txt:=StrPTrimF(StrPRight(txt,length(txt)-2));
															for q:=1 to 11 do
																begin
																	e:=pos(' ',txt);
																	TexelApp.Monate3[q]:=StrPLeft(txt,e-1);
																	txt:=StrPTrimF(StrPRight(txt,length(txt)-e))
																end;
															TexelApp.Monate3[12]:=txt
														end
												end
											else
												if txt[1]='d' then
													begin
														if txt[2]='1' then
															begin
																txt:=StrPTrimF(StrPRight(txt,length(txt)-2));
																for q:=0 to 5 do
																	begin
																		e:=pos(' ',txt);
																		TexelApp.Tage[q]:=StrPLeft(txt,e-1);
																		txt:=StrPTrimF(StrPRight(txt,length(txt)-e))
																	end;
																TexelApp.Tage[6]:=txt
															end
														else
															begin
																txt:=StrPTrimF(StrPRight(txt,length(txt)-2));
																for q:=0 to 5 do
																	begin
																		e:=pos(' ',txt);
																		TexelApp.Tage2[q]:=StrPLeft(txt,e-1);
																		txt:=StrPTrimF(StrPRight(txt,length(txt)-e))
																	end;
																TexelApp.Tage2[6]:=txt
															end
													end
												else
													if txt[1]<>';' then
														begin
															q:=pos(' ',txt);
															if q>0 then
																begin
																	opc:=atol(StrPLeft(txt,q-1));
																	txt:=StrPTrimF(StrPRight(txt,length(txt)-q));
																	if opc=1 then
																		begin
																			new(pfm);
																			if pfm<>nil then
																				begin
																					pfm^.Group:=1;
																					pfm^.Index:=1000+TexelApp.UsrForm^.Count;
																					pfm^.Name:=NewStr(txt);
																					TexelApp.UsrForm^.Insert(pfm)
																				end
																		end
																	else
																		begin
																			q:=pos(' ',txt);
																			if q>0 then
																				begin
																					new(pfm);
																					if pfm<>nil then
																						begin
																							pfm^.Group:=opc;
																							pfm^.Index:=atol(StrPLeft(txt,q-1));
																							pfm^.Name:=NewStr(StrPTrimF(StrPRight(txt,length(txt)-q)));
																							TexelApp.Formats^.Insert(pfm);
																							if TexelApp.FormStart[opc]=0 then TexelApp.FormStart[opc]:=pfm^.Index
																						end
																				end
																		end
																end
														end;
							txt:=''
						end
					else
						if buf^[w]>=32 then txt:=txt+chr(buf^[w]);
		until res<>bufsize;
		fclose(hdl);
		if TexelApp.Formats^.Count<>TexelApp.FormPredef+1 then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_STARTUP_FRM1+TEXELFRM+MESSAGE_STARTUP_FRM2+' ('+ltoa(TexelApp.Formats^.Count)+'/'+ltoa(TexelApp.FormPredef)+').',BUTTON_OK);
				Application^.Quit
			end
		else
			readConfigFRM:=false;
	end;
	

procedure TStartupHandler.readConfigPalette;
	label _palerr;

	type PRGBArray = ^TRGBArray;
	     TRGBArray = array [0..511] of ARRAY_3;
	
	var res,w : longint;
	    hdl,q : integer;
	    palbuf: PRGBArray;

	begin
		res:=fopen(TexelApp.DataPath+TEXELPALETTE,FO_READ);
		if res>=0 then
			begin
				palbuf:=nil;
				hdl:=integer(res);
				w:=fseek(0,hdl,2);
				if w<6 then goto _palerr;
				if (w mod 6)<>0 then goto _palerr;
				getmem(palbuf,w);
				if palbuf=nil then goto _palerr;
				if fseek(0,hdl,0)<0 then goto _palerr;
				if fread(hdl,w,palbuf)<>w then goto _palerr;
				for q:=0 to Min(Application^.Attr.Colors,w div 6)-1 do vs_color(Application^.vdiHandle,q,palbuf^[q]);
				_palerr:
				fclose(hdl);
				if palbuf<>nil then freemem(palbuf,w)
			end;
		TexelApp.ColorTable.Count:=Application^.Attr.Colors;
		for q:=0 to TexelApp.ColorTable.Count do vq_color(Application^.vdiHandle,q,1,TexelApp.ColorTable.Colors[q].RGB);
	end;
	

procedure TStartupHandler.readConfigPaths;
	label _pfehler;
	
	var res: longint;
	    hdl,
	    q,w: integer;
	    txt: string;

	begin
		SetAction(STARTUP_PATHS);
		BusyMouse;
		for q:=0 to PFMAX do
			begin
				TexelApp.LastPath[q]:='';
				TexelApp.LastFile[q]:=''
			end;
		res:=fopen(GetHomeDir(false)+'defaults\'+TEXELPATHS,0);
		if res<0 then res:=fopen(GetHomeDir(false)+TEXELPATHS,0);
		if res>=0 then
			begin
				hdl:=integer(res);
				if fread(hdl,2,@q)<>2 then goto _pfehler;
				for w:=0 to Min(q,PFMAX) do
					begin
						if fread(hdl,1,@txt[0])<>1 then goto _pfehler;
						if ord(txt[0])>0 then
							if fread(hdl,ord(txt[0]),@txt[1])<>ord(txt[0]) then goto _pfehler;
						CorrectPath(txt);
						TexelApp.LastPath[w]:=txt;
						if fread(hdl,1,@txt[0])<>1 then goto _pfehler;
						if ord(txt[0])>0 then
							if fread(hdl,ord(txt[0]),@txt[1])<>ord(txt[0]) then goto _pfehler;
						TexelApp.LastFile[w]:=txt
					end;
				_pfehler:
				fclose(hdl)
			end;
		ArrowMouse;
		if length(TexelApp.LastPath[11])=0 then TexelApp.LastPath[11]:=GetTempDir;
		if length(TexelApp.LastFile[11])=0 then TexelApp.LastFile[11]:='gemfile.gem';
		if length(TexelApp.LastPath[14])=0 then TexelApp.LastPath[14]:=GetTempDir;
		if length(TexelApp.LastFile[14])=0 then TexelApp.LastFile[14]:='page0001.img';
	end;


procedure TStartupHandler.readConfigPrintDialog;
	var res: longint;
	    hdl: integer;

	begin
		SetAction(STARTUP_PRINTDIAL);
		if TexelApp.ExtPrnSel(TexelApp.app_prnt_set,nil) then
			if TexelApp.app_prnt_set^.magic='pset' then
				begin
					res:=fopen(GetHomeDir(false)+'defaults\'+TEXELPRNSET,0);
					if res<0 then res:=fopen(GetHomeDir(false)+TEXELPRNSET,0);
					if res>=0 then
						begin
							hdl:=integer(res);
							fread(hdl,TexelApp.app_prnt_set^.len,TexelApp.app_prnt_set);
							fclose(hdl);
							with AES_pb do
								begin
									control^[0]:=205;
									control^[1]:=1;
									control^[2]:=1;
									control^[3]:=2;
									control^[4]:=0;
									intin^[0]:=8;
									addrin^[0]:=TexelApp.prnt_dialog;
									addrin^[1]:=TexelApp.app_prnt_set;
									_crystal(@AES_pb)
								end
						end
				end
	end;

end.