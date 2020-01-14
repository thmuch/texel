unit txprint;
{ 1998-11-10 }

interface

uses

	OWindows{$IFNDEF WDIALOG},txmiscob{$ENDIF};


type

	PPrint = ^TPrint;
	TPrint = object(TKeyMenu)
		st0 : PStatic;
		{$IFNDEF WDIALOG}
    ppcb: PPrintPercBox;
    {$ENDIF}
		procedure Work; virtual;
		procedure Display(def: integer);
		function IsAvailable(open: boolean): boolean;
		function GetDevice: integer;
		function GetPaperSize: integer;
		procedure GetDriverNames(num,hdl: integer; var txt,dummy: string);
		function PrintSheet(num: integer): boolean;
	end;
	
	PPaper = ^TPaper;
	TPaper = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Strings,Tos,Gem,
	Objects,OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txnewvdi,txprevie,txmain
	{$IFNDEF WDIALOG},OValidat,txmainob{$ENDIF};



procedure TPaper.Work;
	var p          : PCalcWindow;
	    docname    : string;
	    sub_dialogs: PPDLG_SUB;
	    pt         : PTree;

	begin
		p:=PCalcWindow(Parent);
		if TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set) then
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
								private1:=longint(p);
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
				docname:=TEXELWINDPREFIX+TITLE_PAPER+#0;
				with AES_pb do
					begin
						control^[0]:=207;
						control^[1]:=1;
						control^[2]:=1;
						control^[3]:=3;
						control^[4]:=0;
						intin^[0]:=PDLG_PREFS or PDLG_ALWAYS_COPIES or PDLG_ALWAYS_SCALE;
						addrin^[0]:=TexelApp.prnt_dialog;
						addrin^[1]:=p^.wnd_prnt_set;
						addrin^[2]:=@docname[1];
						_crystal(@AES_pb);
						if intout^[0]=PDLG_OK then
							begin
								p^.SetDirty;
								if p^.preview<>nil then PPreview(p^.preview)^.Update(true)
							end;
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
					end
			end
	end;


procedure TPrint.Work;

	begin
		Display(RTPPRINT)
	end;


procedure TPrint.Display(def: integer);
	var t          : string;
	    pe         : PEdit;
	    drivers    : PStringCollection;
	    p          : PCalcWindow;
	    pc         : PCheckBox;
	    pb         : PButton;
	    sub_dialogs: PPDLG_SUB;
	    pt         : PTree;

	begin
		if not(Application^.GDOSActive) then exit;
		p:=PCalcWindow(Parent);
		if TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set) then
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
								private1:=longint(p);
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
				t:=TEXELWINDPREFIX+TITLE_PRINT+#0;
				with AES_pb do
					begin
						control^[0]:=207;
						control^[1]:=1;
						control^[2]:=1;
						control^[3]:=3;
						control^[4]:=0;
						intin^[0]:=PDLG_PRINT or PDLG_ALWAYS_COPIES or PDLG_ALWAYS_SCALE;
						addrin^[0]:=TexelApp.prnt_dialog;
						addrin^[1]:=p^.wnd_prnt_set;
						addrin^[2]:=@t[1];
						_crystal(@AES_pb)
					end;
				if AES_pb.intout^[0]=PDLG_OK then
					begin
						PrintSheet(GetDevice);
						if p^.preview<>nil then PPreview(p^.preview)^.Update(true);
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
		if ADialog=nil then
			begin
				ADialog:=new(PPrintDialog,Init(p,TEXELWINDPREFIX+TITLE_PRINT,STG_PRINT,ICNTITLE_PRINT,RTPRINT));
				if ADialog<>nil then
					begin
						PPrintDialog(ADialog)^.drvinfo:=nil;
						new(PGroupBox,Init(ADialog,RTPBEREICH,GROUP_GENERAL_RANGE,''));
						new(st0,Init(ADialog,RTPTITLE,43,true,BUBBLE_PRINT_FILE));
						new(PCheckBox,Init(ADialog,RTPSHEET,true,BUBBLE_PRINT_SHEET));
						new(PCheckBox,Init(ADialog,RTPFEED,true,BUBBLE_PRINT_FEED));
						new(pe,Init(ADialog,RTPCOPIES,4,BUBBLE_PRINT_COPIES));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(1,99)));
						new(ppcb,Init(ADialog,RTPPERCSIZE,RTPPSCYC,RTPPSTITLE,RTPOPUPS,RTPPRINTPERC,id_no,false,true,BUBBLE_PRINT_SCALE));
						if ppcb<>nil then
							begin
								if ppcb^.Popup<>nil then ppcb^.Popup^.AutoCheck:=false;
								if ppcb^.Edit<>nil then ppcb^.Edit^.SetValidator(new(PRangeValidator,Init(MINPERCENT,MAXPERCENT)))
							end;
						new(drivers,Init(10,5));
						new(PPrintDialog(ADialog)^.drvbox,InitCollection(ADialog,RTPDRIVER,RTPDRIVERCYC,RTPDRIVERTITLE,30,drivers,true,true,false,BUBBLE_PRINT_DRIVER));
						new(pb,Init(ADialog,RTPINFO,id_No,true,''));
						if pb<>nil then pb^.Hide(false);
						PPrintDialog(ADialog)^.inf:=pb;
						new(PPrintDialog(ADialog)^.druck,Init(ADialog,RTPPRINT,id_No,true,BUBBLE_PRINT_PRINT));
						PPrintDialog(ADialog)^.devbox:=new(PDeviceBox,Init(ADialog,RTPDEVICE,RTPDEVCYC,RTPDEVTITLE,RTPOPUPS,RTPDEVICES,id_No,false,false,BUBBLE_PRINT_DEVICE));
						new(pc,Init(ADialog,RTPSW,true,BUBBLE_PRINT_BW));
						if pc<>nil then pc^.Disable; { ... }
						new(PRadioButton,Init(ADialog,RTPPBLOCK,true,BUBBLE_PRINT_RANGE));
						new(PRadioButton,Init(ADialog,RTPALL,true,BUBBLE_PRINT_ALL));
						new(PRadioButton,Init(ADialog,RTPBLOCK,true,BUBBLE_PRINT_SELECTION));
						new(PPrintDialog(ADialog)^.paper,Init(ADialog,RTPPSIZE,RTPPCYC,RTPPTITLE,RTPOPUPS,RTPPAPER,id_No,false,false,BUBBLE_PRINT_PAPER));
						new(pe,Init(ADialog,RTPVON,4,BUBBLE_PRINT_PAGEFROM));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(MINPAGES,MAXPAGESOLD)));
						new(PEdit,Init(ADialog,RTPBIS,4,BUBBLE_PRINT_PAGETO));
						new(pb,Init(ADialog,RTPHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTPPAGESETUP,id_No,true,BUBBLE_PRINT_LAYOUT));
						new(PButton,Init(ADialog,RTPPREVIEW,id_No,true,BUBBLE_PRINT_PREVIEW));
						new(PButton,Init(ADialog,RTPOK,id_OK,true,BUBBLE_PRINT_OK));
						new(PButton,Init(ADialog,RTPCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						p^.prnbuffer:=TexelApp.stdprnbuffer;
						p^.prnbuffer.prcindx:=0;
						ADialog^.TransferBuffer:=@p^.prnbuffer
					end
			end;
		if ADialog<>nil then
			begin
				t:=p^.GetWindowFilename;
				if length(t)=0 then t:=p^.GetRawIconTitle;
				if st0<>nil then st0^.SetText(CompressPath(t,42));
				ADialog^.MakeWindow;
				PPrintDialog(ADialog)^.SetDefaultButton(def)
			end
		{$ENDIF}
	end;


function TPrint.IsAvailable(open: boolean): boolean;

	begin
		if not(TexelApp.ExtPrnSel(PCalcWindow(Parent)^.wnd_prnt_set,TexelApp.app_prnt_set)) then
			begin
				IsAvailable:=false;
				{$IFDEF WDIALOG}
				exit
				{$ELSE}
				if ADialog=nil then
					begin
						if open then Work;
						if ADialog=nil then exit;
						ADialog^.WMClosed
					end
				{$ENDIF}
			end;
		IsAvailable:=true
	end;


function TPrint.GetDevice: integer;
	var p: PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set) then GetDevice:=p^.wnd_prnt_set^.driver_id
		else
		{$IFDEF WDIALOG}
			GetDevice:=-1
		{$ELSE}
			with PPrintDialog(ADialog)^.drvbox^ do GetDevice:=drivers[GetSelection]
		{$ENDIF}
	end;


function TPrint.GetPaperSize: integer;
	var p: PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set) then GetPaperSize:=0
		else
		{$IFDEF WDIALOG}
			GetPaperSize:=0
		{$ELSE}
			GetPaperSize:=PPrintDialog(ADialog)^.paper^.GetSelection
		{$ENDIF}
	end;


procedure TPrint.GetDriverNames(num,hdl: integer; var txt,dummy: string);
	var p: PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set) then
			begin
				if vqtExtDevinfo(hdl,num,dummy,txt) then
					if (length(dummy)>0) or (length(txt)>0) then
						begin
							dummy:=StrPLeft(dummy,12);
							txt:=StrPLeft(txt,42);
							exit
						end;
				if vqtDevinfo(hdl,num,dummy,txt) then
					if (length(dummy)>0) or (length(txt)>0) then
						begin
							dummy:=StrPLeft(dummy,12);
							txt:=StrPLeft(txt,42);
							exit
						end;
				txt:='';
				dummy:=STRING_DEVICE+' #'+ltoa(num)
			end
		{$IFNDEF WDIALOG}
		else
			with PPrintDialog(ADialog)^.drvbox^ do
				begin
					txt:=longnames[GetSelection];
					dummy:=shortnames[GetSelection]
				end
		{$ENDIF}
	end;


function TPrint.PrintSheet(num: integer): boolean;
	label _leer,_error,_borderr;

	var hndl,q,l,
	    copies,w,
	    multicopy,
	    tw,th,
	    pgx,pgy,t,
	    pagew,pageh,
	    pagex,pagey,
	    pages,page,
	    cwidth,cheight,
	    bwidth,bheight,
	    cw,wwidth,
	    nwidth,lcw,trh,
	    pgvon,pgbis,
	    vbpages,
	    rsc,csc,
	    rec,cec,
	    rs,cs,re,ce : integer;
	    xmm,ymm,
	    XPixOffs,
	    YPixOffs,
	    printtime,
	    xoffs,yoffs,
	    xoffs2,
	    yoffs2      : longint;
	    ymmfak,yfak,
	    xmmfak,xfak,
	    prcfak,
	    ymm100fak,
	    xmm100fak,
	    mmkopf,
	    mmfuss,
	    pcstemp     : real;
	    wrkout,
	    ewrkout     : workout_ARRAY;
	    progress    : PDialog;
	    bitimage,
	    colfx,meta  : boolean;
	    pps,ppa,
	    st,ppp,ppc  : PStatic;
	    cell        : PCell;
	    p           : PCalcWindow;
	    srect       : GRECT;
	    dummy,txt   : string;
	    pe          : PEmbedded;

	function GetColWidth(num: integer): integer;

		begin
			GetColWidth:=round(longint(p^.PCol^[num])*xmm100fak)+1
		end;

	function GetRowHeight(num: integer): integer;

		begin
			GetRowHeight:=round(longint(p^.PRow^[num])*ymm100fak)+1
		end;

	function abort: boolean;
		var ret,dummy,
		    kstat,key: integer;
		    pipe     : Pipearray;

		begin
			abort:=false;
			ret:=evnt_multi(MU_KEYBD or MU_TIMER,2,1,1,0,0,0,0,0,0,0,0,0,0,pipe,1,0,dummy,dummy,dummy,kstat,key,dummy);
			if bTst(ret,MU_KEYBD) then
				if (kstat=K_NORMAL) and (key=S_Esc) then
					if Application^.Alert(p,2,WAIT,MESSAGE_PRINT_STOP,BUTTON_YESNO)=1 then abort:=true
		end;

	procedure setfont(indx,sze: integer);

		begin
			vst_font(hndl,indx);
			{$IFDEF NVDI5}
			vst_arbpt(hndl,round(sze*prcfak),cwidth,cheight,bwidth,bheight);
			{$ELSE}
			if p^.Speedo then vst_arbpt(hndl,round(sze*prcfak),cwidth,cheight,bwidth,bheight)
			else
				vst_point(hndl,round(sze*prcfak),cwidth,cheight,bwidth,bheight);
			{$ENDIF}
			if vqt_width(hndl,ord('W'),cw,l,l)=ord('W') then wwidth:=cw
			else
				wwidth:=cwidth;
			if vqt_width(hndl,ord('9'),cw,l,l)=ord('9') then nwidth:=cw
			else
				nwidth:=cwidth
		end;

	procedure StartGroup;
		var value,dummy: integer;

		begin
			if not(meta) then exit;
			value:=10;
			v_write_meta(hndl,1,@value,0,@dummy)
		end;

	procedure EndGroup;
		var value,dummy: integer;

		begin
			if not(meta) then exit;
			value:=11;
			v_write_meta(hndl,1,@value,0,@dummy)
		end;

	function printdoc(xoffs,yoffs,xoffs2,yoffs2: integer): boolean;
		label _nextgit,_endgit;

		var xy,xy2,xy3,brd,
		    tover             : ARRAY_4;
		    ext               : ARRAY_8;
		    clp,clp2,clp3,clip,
		    sr,bclp           : GRECT;
		    q,w,dummy,c2,
		    oldstyle,oldcolor,
		    oldinter,oldlcolor,
		    b,tx,ty           : integer;
		    cnum,lofs         : longint;
		    title,sval        : string;
		    prctemp           : real;
		    pe                : PEmbedded;
		    cmpval            : TOldTxtVal;
		    cell2             : PCell;

		procedure setfontattr(const tval: TTxtVal);
		
			begin
				if (tval.Font<>cmpval.oldfont) or (tval.Size<>cmpval.oldsize) then
					begin
						setfont(tval.Font,tval.Size);
						cmpval.oldsize:=tval.Size;
						cmpval.oldfont:=tval.Font
					end
			end;
		
		procedure drawbackground;
		
			begin
				with PCell(cnum)^ do
					begin
						if Style<>oldstyle then
							begin
								vsf_style(hndl,Style);
								oldstyle:=Style
							end;
						if Interior<>oldinter then
							begin
								vsf_interior(hndl,Interior);
								oldinter:=Interior
							end;
						if Color<>oldcolor then
							begin
								vsf_color(hndl,Color);
								oldcolor:=Color
							end
					end;
				vr_recfl(hndl,xy3)
			end;

		begin
			if abort then
				begin
					printdoc:=false;
					exit
				end
			else
				printdoc:=true;
			StartGroup;
			vst_color(hndl,Black);
			vst_effects(hndl,TF_NORMAL);
			vst_rotation(hndl,0);
			{$IFNDEF NVDI5}
			if p^.Speedo then
			{$ENDIF}
				vst_skew(hndl,0);
			vst_alignment(hndl,TA_LEFT,TA_BASELINE,dummy,dummy);
			vsl_udsty(hndl,$5555);
			vsm_height(hndl,1);
			vsf_color(hndl,Black);
			vsf_style(hndl,0);
			vsf_interior(hndl,FIS_HOLLOW);
			clip.X1:=xoffs;
			clip.X2:=xoffs2;
			if mmkopf>0.0 then
				begin
					StartGroup;
					clip.Y1:=round(atof(p^.Parms.psbuffer.oben)*ymmfak);
					clip.Y2:=yoffs-1;
					A2toGR(clip);
					vs_clip(hndl,CLIP_ON,clip.A2);
					prctemp:=prcfak;
					prcfak:=1.0;
					setfont(p^.GetStdFontIndex,p^.GetStdFontSize);
					if p^.Parms.psbuffer.hlefton=bf_Checked then p^.OutputKF(hndl,clip.X1,clip.Y1,TA_LEFT,TA_TOP,page,pages,printtime,p^.Parms.psbuffer.hleft);
					if p^.Parms.psbuffer.hcenteron=bf_Checked then p^.OutputKF(hndl,(clip.X1+clip.X2) shr 1,clip.Y1,TA_CENTER,TA_TOP,page,pages,printtime,p^.Parms.psbuffer.hmid);
					if p^.Parms.psbuffer.hrighton=bf_Checked then p^.OutputKF(hndl,clip.X2,clip.Y1,TA_RIGHT,TA_TOP,page,pages,printtime,p^.Parms.psbuffer.hright);
					prcfak:=prctemp;
					EndGroup
				end;
			StartGroup;
			clip.Y1:=yoffs;
			clip.Y2:=yoffs2;
			A2toGR(clip);
			vs_clip(hndl,CLIP_ON,clip.A2);
			if p^.Parms.psbuffer.hcenter=bf_Checked then
				begin
					dummy:=pagew-srect.W;
					if p^.Parms.psbuffer.rows=bf_Checked then dec(dummy,lcw);
					inc(xoffs,dummy shr 1)
				end;
			if p^.Parms.psbuffer.vcenter=bf_Checked then
				begin
					dummy:=pageh-srect.H;
					if p^.Parms.psbuffer.columns=bf_Checked then dec(dummy,trh);
					inc(yoffs,dummy shr 1)
				end;
			{ Quadrat links oben zeichnen }
			if (p^.Parms.psbuffer.rows=bf_Checked) and (p^.Parms.psbuffer.columns=bf_Checked) then
				begin
					xy[0]:=xoffs;
					xy[1]:=yoffs;
					xy[2]:=xoffs+lcw-1;
					xy[3]:=yoffs+trh-1;
					v_bar(hndl,xy);
					if colfx then
						begin
							inc(xy[0]);
							inc(xy[1]);
							vsf_interior(hndl,FIS_SOLID);
							vsf_color(hndl,LWhite);
							v_bar(hndl,xy);
							vsf_interior(hndl,FIS_HOLLOW);
							vsf_color(hndl,Black)
						end
				end;
			vst_alignment(hndl,TA_CENTER,TA_BOTTOM,dummy,dummy);
			setfont(p^.GetStdFontIndex,p^.GetStdFontSize);
			{ PaintNumbers }
			if p^.Parms.psbuffer.rows=bf_Checked then
				begin
					w:=rs;
					clp.X:=xoffs;
					if p^.Parms.psbuffer.columns=bf_Checked then clp.Y:=yoffs+trh+1
					else
						clp.Y:=yoffs;
					clp.W:=lcw;
					clp.H:=GetRowHeight(w);
					xy[0]:=clp.X-1;
					xy[1]:=clp.Y-1;
					xy[2]:=clp.X+clp.W;
					GRtoA2(clp);
					repeat
						inc(w);
						clp2:=clp;
						if rc_intersect(clip,clp2) then
							begin
								vs_clip(hndl,CLIP_ON,clp2.A2);
								xy[3]:=clp.Y2;
								v_bar(hndl,xy);
								dec(xy[3]);
								if colfx then
									begin
										vsf_interior(hndl,FIS_SOLID);
										vsf_color(hndl,LWhite);
										inc(xy[0],2);
										inc(xy[1],2);
										v_bar(hndl,xy);
										dec(xy[0],2);
										vsf_interior(hndl,FIS_HOLLOW);
										vsf_color(hndl,Black)
									end;
								vswr_mode(hndl,MD_TRANS);
								v_gtext(hndl,(xy[0]+xy[2]) shr 1,xy[3],ltoa(w));
								vswr_mode(hndl,MD_REPLACE)
							end;
						if w>re then break;
						clp.Y1:=clp.Y2+1;
						inc(clp.Y2,GetRowHeight(w));
						A2toGR(clp);
						xy[1]:=clp.Y-1
					until clp.Y1>clip.Y2;
					sr.X:=xoffs+lcw+1
				end
			else
				sr.X:=xoffs+1;
			if abort then
				begin
					printdoc:=false;
					exit
				end;
			{ PaintNames}
			if p^.Parms.psbuffer.columns=bf_Checked then
				begin
					q:=cs;
					if p^.Parms.psbuffer.rows=bf_Checked then clp.X:=xoffs+lcw+1
					else
						clp.X:=xoffs+1;
					clp.Y:=yoffs;
					clp.W:=GetColWidth(q)-1;
					clp.H:=trh;
					xy[0]:=clp.X-1;
					xy[1]:=clp.Y-1;
					xy[3]:=clp.Y+clp.H;
					GRtoA2(clp);
					repeat
						clp2:=clp;
						if rc_intersect(clip,clp2) then
							begin
								vs_clip(hndl,CLIP_ON,clp2.A2);
								xy[2]:=clp.X2;
								v_bar(hndl,xy);
								if colfx then
									begin
										vsf_interior(hndl,FIS_SOLID);
										vsf_color(hndl,LWhite);
										inc(xy[0],2);
										inc(xy[1],2);
										dec(xy[2]);
										v_bar(hndl,xy);
										dec(xy[1],2);
										vsf_interior(hndl,FIS_HOLLOW);
										vsf_color(hndl,Black)
									end;
								vswr_mode(hndl,MD_TRANS);
								v_gtext(hndl,(xy[0]+xy[2]) shr 1,xy[3],p^.GetColumnName(q));
								vswr_mode(hndl,MD_REPLACE)
							end;
						inc(q);
						if q>ce then break;
						clp.X1:=clp.X2+1;
						inc(clp.X2,GetColWidth(q));
						A2toGR(clp);
						xy[0]:=clp.X-1
					until clp.X1>clip.X2;
					sr.Y:=yoffs+trh+1
				end
			else
				sr.Y:=yoffs+1;
			EndGroup;
			{ Zeilen durchlaufen }
			lofs:=longint(p^.Parms.Columns+1)*CELLSIZE;
			w:=rs;
			clp.X:=0;
			if p^.Parms.psbuffer.columns=bf_Checked then clp.Y:=yoffs+trh+1
			else
				clp.Y:=yoffs;
			if p^.Parms.psbuffer.rows=bf_Checked then clp.W:=xoffs+lcw
			else
				clp.W:=xoffs;
			clp.H:=GetRowHeight(w);
			GRtoA2(clp);
			with cmpval do
				begin
					oldfont:=p^.GetFontIndex;
					oldsize:=p^.GetFontSize;
					brd1w:=Max(round(prcfak*Border1*xmmfak)-1,0);
					brd2w:=Max(round(prcfak*Border2*xmmfak)-1,0);
					brd3w:=Max(round(prcfak*Border3*xmmfak)-1,0);
					brd1h:=Max(round(prcfak*Border1*ymmfak)-1,0);
					brd2h:=Max(round(prcfak*Border2*ymmfak)-1,0);
					brd3h:=Max(round(prcfak*Border3*ymmfak)-1,0);
					gitter:=(p^.Parms.psbuffer.gitter=bf_Checked)
				end;
			oldcolor:=White;
			oldlcolor:=Black;
			oldstyle:=0;
			oldinter:=FIS_HOLLOW;
			vsf_color(hndl,oldcolor);
			vsf_style(hndl,oldstyle);
			vsf_interior(hndl,oldinter);
			vsl_color(hndl,oldlcolor);
			setfont(cmpval.oldfont,cmpval.oldsize);
			p^.InitTextValues(hndl,cmpval);
			if abort then
				begin
					printdoc:=false;
					exit
				end;
			repeat
				{ Spalten durchlaufen }
				q:=cs;
				cnum:=longint(p^.Sheet)+(longint(w)*longint(p^.Parms.Columns+1)+longint(q))*CELLSIZE;
				inc(w);
				clp3.X:=clp.X2+2;
				clp3.Y:=clp.Y;
				clp3.W:=GetColWidth(q)-1;
				clp3.H:=clp.H;
				xy3[0]:=clp3.X-1;
				xy3[1]:=clp3.Y-1;
				xy3[3]:=clp3.Y+clp3.H-1;
				if cmpval.gitter then dec(xy3[3]);
				GRtoA2(clp3);
				repeat
					clp2:=clp3;
					if rc_intersect(clip,clp2) then
						begin
							StartGroup;
							vs_clip(hndl,CLIP_ON,clp2.A2);
							xy3[2]:=clp3.X2;
							if cmpval.gitter then
								if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then dec(xy3[2]);
							{ Zellinhalt }
							drawbackground;
							with PCell(cnum)^ do
								begin
									vswr_mode(hndl,MD_TRANS);
									case Typ of
									CTYPE_TEXT:
										if Data.Value<>0 then
											begin
												setfontattr(TxtVal);
												p^.OutputVectorText(hndl,PCell(cnum),Data.Txt^,TxtVal,cmpval,xy3,false)
											end;
									CTYPE_CONST:
										with Data.Konst^ do
											begin
												if p^.Val2Txt(Value,sval,FPts,Format,PCell(cnum)) then drawbackground;
												setfontattr(TxtVal);
												p^.OutputVectorText(hndl,PCell(cnum),sval,TxtVal,cmpval,xy3,true)
											end;
									CTYPE_FORMULA:
										with Data.Formula^ do
											if Error=FE_OK then
												begin
													if p^.Val2Txt(Value,sval,FPts,Format,PCell(cnum)) then drawbackground;
													setfontattr(TxtVal);
													p^.OutputVectorText(hndl,PCell(cnum),sval,TxtVal,cmpval,xy3,true)
												end
											else
												begin
													setfontattr(TxtVal);
													p^.OutputErrorText(hndl,PCell(cnum),TxtVal,cmpval,xy3,Error)
												end;
									CTYPE_EMPTY:
										begin
											if bTst(TxtVal.Flags,TFL_TEXTFROMLEFT) then
												begin
													tover:=xy3;
													c2:=q;
													cell2:=PCell(cnum);
													repeat
														dec(longint(cell2),CELLSIZE);
														dec(c2);
														if c2<0 then break
														else
															begin
																tover[2]:=tover[0]-1;
																dec(tover[0],GetColWidth(c2))
															end;
													until (cell2^.TxtVal.Flags and TFL_RIGHTMASK)=TFL_TEXT2RIGHT;
													if c2>=0 then
														begin
															setfontattr(cell2^.TxtVal);
															p^.OutputVectorText(hndl,cell2,cell2^.Data.Txt^,cell2^.TxtVal,cmpval,tover,false)
														end
												end
											else
												if bTst(TxtVal.Flags,TFL_TEXTFROMRIGHT) then
													begin
														tover:=xy3;
														c2:=q;
														cell2:=PCell(cnum);
														repeat
															inc(longint(cell2),CELLSIZE);
															inc(c2);
															if c2>p^.Parms.Columns then break
															else
																begin
																	tover[0]:=tover[2]+1;
																	inc(tover[2],GetColWidth(c2));
																	if cmpval.gitter then dec(tover[2])
																end;
														until (cell2^.TxtVal.Flags and TFL_LEFTMASK)=TFL_TEXT2LEFT;
														if c2<=p^.Parms.Columns then
															begin
																setfontattr(cell2^.TxtVal);
																p^.OutputVectorText(hndl,cell2,cell2^.Data.Txt^,cell2^.TxtVal,cmpval,tover,false)
															end
													end
										end
									end;
									vswr_mode(hndl,MD_REPLACE);
									if cmpval.gitter then
										begin
											if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then inc(xy3[2]);
											inc(xy3[3])
										end;
									with Border do
										if (Val1<>0) or (Val2<>0) then
											begin
												bclp.X:=clp3.X-1;
												bclp.Y:=clp3.Y-1;
												bclp.W:=clp3.W+1;
												bclp.H:=clp3.H+1;
												if rc_intersect(clip,bclp) then
													begin
														vs_clip(hndl,CLIP_ON,bclp.A2);
														if Left>=16 then
															if (TxtVal.Flags and TFL_LEFTBORDER)=0 then
																begin
																	if (Left and $f)<>oldlcolor then
																		begin
																			oldlcolor:=Left and $f;
																			vsl_color(hndl,oldlcolor)
																		end;
																	if q=cs then inc(xy3[0]);
																	case (Left shr 4) of
																	1:
																		begin
																			brd[0]:=xy3[0];
																			brd[1]:=xy3[1];
																			brd[2]:=brd[0];
																			brd[3]:=xy3[3];
																			v_pline(hndl,2,brd)
																		end;
																	2:
																		begin
																			brd[0]:=xy3[0];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd1w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					inc(brd[0])
																				end
																		end;
																	3:
																		begin
																			brd[0]:=xy3[0];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd2w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					inc(brd[0])
																				end
																		end;
																	4:
																		begin
																			brd[0]:=xy3[0];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd3w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					inc(brd[0])
																				end
																		end;
																	5:
																		begin
																			brd[0]:=xy3[0];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd1w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					inc(brd[0])
																				end;
																			brd[0]:=xy3[0]+cmpval.brd3w;
																			for b:=0 to cmpval.brd1w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					dec(brd[0])
																				end
																		end
																	end;
																	if q=cs then dec(xy3[0])
																end;
														if Right>=16 then
															if (TxtVal.Flags and TFL_RIGHTBORDER)=0 then
																begin
																	if (Right and $f)<>oldlcolor then
																		begin
																			oldlcolor:=Right and $f;
																			vsl_color(hndl,oldlcolor)
																		end;
																	case (Right shr 4) of
																	1:
																		begin
																			brd[0]:=xy3[2];
																			brd[1]:=xy3[1];
																			brd[2]:=brd[0];
																			brd[3]:=xy3[3];
																			v_pline(hndl,2,brd)
																		end;
																	2:
																		begin
																			brd[0]:=xy3[2];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd1w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					dec(brd[0])
																				end
																		end;
																	3:
																		begin
																			brd[0]:=xy3[2];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd2w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					dec(brd[0])
																				end
																		end;
																	4:
																		begin
																			brd[0]:=xy3[2];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd3w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					dec(brd[0])
																				end
																		end;
																	5:
																		begin
																			brd[0]:=xy3[2];
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd1w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					dec(brd[0])
																				end;
																			brd[0]:=xy3[2]-cmpval.brd3w;
																			brd[1]:=xy3[1];
																			brd[3]:=xy3[3];
																			for b:=0 to cmpval.brd1w do
																				begin
																					brd[2]:=brd[0];
																					v_pline(hndl,2,brd);
																					inc(brd[0])
																				end
																		end
																	end
																end;
														if Top>=16 then
															begin
																if (Top and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Top and $f;
																		vsl_color(hndl,oldlcolor)
																	end;
																if w=rs+1 then inc(xy3[1]);
																case (Top shr 4) of
																1:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[1];
																		brd[2]:=xy3[2];
																		brd[3]:=brd[1];
																		v_pline(hndl,2,brd)
																	end;
																2:
																	begin
																		brd[1]:=xy3[1];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end
																	end;
																3:
																	begin
																		brd[1]:=xy3[1];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd2h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end
																	end;
																4:
																	begin
																		brd[1]:=xy3[1];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd3h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end
																	end;
																5:
																	begin
																		brd[1]:=xy3[1];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end;
																		brd[1]:=xy3[1]+cmpval.brd3h;
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				dec(brd[1])
																			end
																	end
																end;
																if w=rs+1 then dec(xy3[1])
															end;
														if Bottom>=16 then
															begin
																if (Bottom and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Bottom and $f;
																		vsl_color(hndl,oldlcolor)
																	end;
																case (Bottom shr 4) of
																1:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[3];
																		brd[2]:=xy3[2];
																		brd[3]:=brd[1];
																		v_pline(hndl,2,brd)
																	end;
																2:
																	begin
																		brd[1]:=xy3[3];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				dec(brd[1])
																			end
																	end;
																3:
																	begin
																		brd[1]:=xy3[3];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd2h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				dec(brd[1])
																			end
																	end;
																4:
																	begin
																		brd[1]:=xy3[3];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd3h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				dec(brd[1])
																			end
																	end;
																5:
																	begin
																		brd[1]:=xy3[3];
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				dec(brd[1])
																			end;
																		brd[1]:=xy3[3]-cmpval.brd3h;
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end
																	end
																end
															end;
														if Hor>=16 then
															begin
																if (Hor and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Hor and $f;
																		vsl_color(hndl,oldlcolor)
																	end;
																case (Hor shr 4) of
																1:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=(xy3[1]+xy3[3]) shr 1;
																		brd[2]:=xy3[2];
																		brd[3]:=brd[1];
																		v_pline(hndl,2,brd)
																	end;
																2:
																	begin
																		brd[1]:=(xy3[1]+xy3[3]-cmpval.brd1h) shr 1;
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end
																	end;
																3:
																	begin
																		brd[1]:=(xy3[1]+xy3[3]-cmpval.brd2h) shr 1;
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd2h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end
																	end;
																4:
																	begin
																		brd[1]:=(xy3[1]+xy3[3]-cmpval.brd3h) shr 1;
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd3h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end
																	end;
																5:
																	begin
																		brd[1]:=(xy3[1]+xy3[3]-cmpval.brd3h) shr 1;
																		brd[0]:=xy3[0];
																		brd[2]:=xy3[2];
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				inc(brd[1])
																			end;
																		brd[1]:=(xy3[1]+xy3[3]+cmpval.brd3h) shr 1;
																		for b:=0 to cmpval.brd1h do
																			begin
																				brd[3]:=brd[1];
																				v_pline(hndl,2,brd);
																				dec(brd[1])
																			end
																	end
																end
															end;
														if Vert>=16 then
															begin
																if (Vert and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Vert and $f;
																		vsl_color(hndl,oldlcolor)
																	end;
																case (Vert shr 4) of
																1:
																	begin
																		brd[0]:=(xy3[0]+xy3[2]) shr 1;
																		brd[1]:=xy3[1];
																		brd[2]:=brd[0];
																		brd[3]:=xy3[3];
																		v_pline(hndl,2,brd)
																	end;
																2:
																	begin
																		brd[0]:=(xy3[0]+xy3[2]-cmpval.brd1w) shr 1;
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(hndl,2,brd);
																				inc(brd[0])
																			end
																	end;
																3:
																	begin
																		brd[0]:=(xy3[0]+xy3[2]-cmpval.brd2w) shr 1;
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd2w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(hndl,2,brd);
																				inc(brd[0])
																			end
																	end;
																4:
																	begin
																		brd[0]:=(xy3[0]+xy3[2]-cmpval.brd3w) shr 1;
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd3w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(hndl,2,brd);
																				inc(brd[0])
																			end
																	end;
																5:
																	begin
																		brd[0]:=(xy3[0]+xy3[2]-cmpval.brd3w) shr 1;
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(hndl,2,brd);
																				inc(brd[0])
																			end;
																		brd[0]:=(xy3[0]+xy3[2]+cmpval.brd3w) shr 1;
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(hndl,2,brd);
																				dec(brd[0])
																			end
																	end
																end
															end;
														vs_clip(hndl,CLIP_ON,clp2.A2)
													end
											end;
									if cmpval.gitter then dec(xy3[3])
								end;
							if cmpval.gitter then
								begin
									{ Begrenzungslinien }
									if oldlcolor<>Black then
										begin
											oldlcolor:=Black;
											vsl_color(hndl,oldlcolor)
										end;
									vsl_type(hndl,LT_USERDEF);
									if PCell(cnum)^.Border.Right<16 then
										if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then
											begin
												if q<p^.Parms.Columns then
													if PCell(cnum+CELLSIZE)^.Border.Left>=16 then goto _nextgit;
												xy2[0]:=xy3[2];
												xy2[1]:=xy3[1];
												xy2[2]:=xy2[0];
												xy2[3]:=xy3[3]+1;
												v_pline(hndl,2,xy2)
											end;
									_nextgit:
									if PCell(cnum)^.Border.Bottom<16 then
										begin
											if w<=p^.Parms.Rows then
												if PCell(cnum+lofs)^.Border.Top>=16 then goto _endgit;
											xy2[0]:=xy3[0];
											xy2[1]:=xy3[3]+1;
											xy2[2]:=xy3[2];
											xy2[3]:=xy2[1];
											v_pline(hndl,2,xy2)
										end;
									_endgit:
									vsl_type(hndl,LT_SOLID)
								end
							else
								dec(xy3[3]);
							EndGroup;
							if not(cmpval.gitter) then inc(xy3[3])
						end;
					inc(q);
					if q>ce then break;
					clp3.X1:=clp3.X2+1;
					inc(clp3.X2,GetColWidth(q));
					A2toGR(clp3);
					xy3[0]:=clp3.X-1;
					inc(cnum,CELLSIZE)
				until clp3.X1>clip.X2;
				if abort then
					begin
						printdoc:=false;
						exit
					end;
				{ n„chste Zeile }
				if w>re then break;
				clp.Y1:=clp.Y2+1;
				inc(clp.Y2,GetRowHeight(w));
				A2toGR(clp)
			until clp.Y1>clip.Y2;
			if p^.Embedded<>nil then
				if p^.Parms.psbuffer.images=bf_Checked then
					begin
						clp.X:=xoffs;
						if p^.Parms.psbuffer.rows=bf_Checked then inc(clp.X,lcw);
						clp.Y:=yoffs;
						if p^.Parms.psbuffer.columns=bf_Checked then inc(clp.Y,trh);
						clp.W:=srect.W;
						clp.H:=srect.H;
						if rc_intersect(clip,clp) then
							begin
								pe:=p^.Embedded;
								while pe<>nil do
									begin
										if pe^.CanPrint then
											begin
												pe^.SetWorkstationValues(num,wrkout[13],XPixOffs-xoffs,YPixOffs-yoffs,xmm100fak,ymm100fak,prcfak,1.0,bTst(ewrkout[30],1),false);
												if pe^.IsVisible(clp,false) then
													begin
														vs_clip(hndl,CLIP_ON,clp.A2);
														pe^.Paint(hndl,clp,false)
													end
											end;
										pe:=pe^.Next
									end
							end
					end;
			setfont(p^.GetStdFontIndex,p^.GetStdFontSize);
			p^.RestoreTextValues(hndl);
			vsl_color(hndl,Black);
			vs_clip(hndl,CLIP_ON,clip.A2);
			{ durchgezogene Linien }
			if (p^.Parms.psbuffer.columns=bf_Checked) or (p^.Parms.psbuffer.rows=bf_Checked) or cmpval.gitter then
				begin
					StartGroup;
					pxya[0]:=xoffs;
					pxya[1]:=yoffs;
					pxya[2]:=xoffs+srect.X2-1;
					if p^.Parms.psbuffer.rows=bf_Checked then inc(pxya[2],lcw);
					pxya[3]:=yoffs;
					v_pline(hndl,2,pxya);
					if p^.Parms.psbuffer.columns=bf_Checked then
						begin
							pxya[1]:=yoffs+trh-1;
							pxya[3]:=pxya[1];
							v_pline(hndl,2,pxya);
							pxya[1]:=yoffs+trh+srect.Y2
						end
					else
						pxya[1]:=yoffs+srect.Y2;
					pxya[3]:=pxya[1];
					v_pline(hndl,2,pxya);
					pxya[0]:=xoffs;
					pxya[1]:=yoffs;
					pxya[2]:=xoffs;
					pxya[3]:=yoffs+srect.Y2;
					if p^.Parms.psbuffer.columns=bf_Checked then inc(pxya[3],trh);
					v_pline(hndl,2,pxya);
					if p^.Parms.psbuffer.rows=bf_Checked then
						begin
							pxya[0]:=xoffs+lcw-1;
							pxya[2]:=pxya[0];
							v_pline(hndl,2,pxya);
							pxya[0]:=xoffs+lcw+srect.X2-1
						end
					else
						pxya[0]:=xoffs+srect.X2-1;
					pxya[2]:=pxya[0];
					v_pline(hndl,2,pxya);
					EndGroup
				end;
			if mmfuss>0.0 then
				begin
					StartGroup;
					vsf_interior(hndl,FIS_HOLLOW);
					clip.Y1:=yoffs2+1;
					clip.Y2:=wrkout[1]-round(atof(p^.Parms.psbuffer.unten)*ymmfak);
					A2toGR(clip);
					vs_clip(hndl,CLIP_ON,clip.A2);
					prctemp:=prcfak;
					prcfak:=1.0;
					setfont(p^.GetStdFontIndex,p^.GetStdFontSize);
					if p^.Parms.psbuffer.flefton=bf_Checked then p^.OutputKF(hndl,clip.X1,clip.Y2,TA_LEFT,TA_BOTTOM,page,pages,printtime,p^.Parms.psbuffer.fleft);
					if p^.Parms.psbuffer.fcenteron=bf_Checked then p^.OutputKF(hndl,(clip.X1+clip.X2) shr 1,clip.Y2,TA_CENTER,TA_BOTTOM,page,pages,printtime,p^.Parms.psbuffer.fmid);
					if p^.Parms.psbuffer.frighton=bf_Checked then p^.OutputKF(hndl,clip.X2,clip.Y2,TA_RIGHT,TA_BOTTOM,page,pages,printtime,p^.Parms.psbuffer.fright);
					prcfak:=prctemp;
					EndGroup
				end;
			EndGroup;
			if abort then
				begin
					printdoc:=false;
					exit
				end;
			if ppa<>nil then ppa^.Disable;
			if pps<>nil then pps^.SetText(STRING_PRINTPAGE);
			v_updwk(hndl);
			if ppa<>nil then ppa^.Enable
		end;

	begin
		PrintSheet:=false;
		p:=PCalcWindow(Parent);
		BusyMouse;
		printtime:=gettime;
		if p^.IsNormalPrintArea then
			begin
				cell:=p^.Sheet;
				rsc:=0;
				csc:=0;
				rec:=-1;
				cec:=-1;
				for q:=0 to p^.Parms.Rows do
					for w:=0 to p^.Parms.Columns do
						begin
							if cell^.Typ=CTYPE_EMPTY then
								if cell^.TxtVal.Flags=0 then
									if cell^.Color=Black then
										if cell^.Style=8 then
											if cell^.Interior=FIS_HOLLOW then
												with cell^.Border do
													if Left<16 then
														if Right<16 then
															if Top<16 then
																if Bottom<16 then
																	if Hor<16 then
																		if Vert<16 then goto _leer;
							if q>rec then rec:=q;
							if w>cec then cec:=w;
							_leer:
							inc(longint(cell),CELLSIZE)
						end;
				if p^.Embedded<>nil then
					if p^.Parms.psbuffer.images=bf_Checked then
						begin
							xmm:=0;
							ymm:=0;
							pe:=p^.Embedded;
							while pe<>nil do
								begin
									if pe^.CanPrint then
										begin
											if pe^.XPos_mm100+pe^.Width_mm100>xmm then xmm:=pe^.XPos_mm100+pe^.Width_mm100;
											if pe^.YPos_mm100+pe^.Height_mm100>ymm then ymm:=pe^.YPos_mm100+pe^.Height_mm100
										end;
									pe:=pe^.Next
								end;
							if xmm>0 then
								begin
									q:=-1;
									repeat
										inc(q);
										dec(xmm,longint(p^.GetColWidth_mm100(q)))
									until (xmm<0) or (q>=p^.Parms.Columns);
									if q>cec then cec:=q
								end;
							if ymm>0 then
								begin
									w:=-1;
									repeat
										inc(w);
										dec(ymm,longint(p^.GetRowHeight_mm100(w)))
									until (ymm<0) or (w>=p^.Parms.Rows);
									if w>rec then rec:=w
								end
						end;
				if (rec<0) or (cec<0) then
					begin
						Application^.Alert(p,1,NOTE,MESSAGE_PRINT_EMPTY,BUTTON_OK);
						goto _error
					end
			end
		else
			if p^.IsBlockPrintArea then p^.GetBlock(p^.Parms.psbuffer.bereich,false,rsc,csc,rec,cec,q,q)
			else
				p^.GetBlock(p^.dblock^.GetText,false,rsc,csc,rec,cec,q,q);
		meta:=Between(num,31,40);
		bitimage:=Between(num,91,99);
		if not(TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set)) then
		{$IFDEF WDIALOG}
			goto _error;
		{$ELSE}
			begin
				if meta then
					if not(FileSelect(p,FSELTITLE_PRINTMETA,'*.gem',TexelApp.LastPath[11],TexelApp.LastFile[11],false)) then goto _error;
				if bitimage then
					if not(FileSelect(p,FSELTITLE_PRINTIMG,'*.img',TexelApp.LastPath[14],TexelApp.LastFile[14],false)) then goto _error;
			end;
		{$ENDIF}
 		if bitimage then vOpnwk(num,hndl,wrkout,p^.prnbuffer.papier,TexelApp.LastPath[14]+TexelApp.LastFile[14],p^.wnd_prnt_set)
 		else
			vOpnwk(num,hndl,wrkout,p^.prnbuffer.papier,'',p^.wnd_prnt_set);
		if hndl=0 then Application^.Alert(p,1,NOTE,MESSAGE_PRINT_DEVICE1+ltoa(num)+MESSAGE_PRINT_DEVICE2,BUTTON_OK)
		else
			begin
				{$IFNDEF WDIALOG}
				if not(TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set)) then
					if meta then vm_filename(hndl,TexelApp.LastPath[11]+TexelApp.LastFile[11]);
				{$ENDIF}
				if vs_document_info(hndl,0,TEXELNAME) then
					begin
						dummy:=StrPTrimF(p^.infobuf.DocTitle);
						if length(dummy)=0 then
							begin
								dummy:=p^.GetWindowFilename;
								if length(dummy)=0 then dummy:=p^.GetRawIconTitle
								else
									dummy:=StrPRight(dummy,length(dummy)-RPos('\',dummy));
							end;
						vs_document_info(hndl,1,dummy);
						vs_document_info(hndl,2,p^.infobuf.Autor);
						dummy:=p^.infobuf.Rem1;
						if (length(dummy)>0) and (length(p^.infobuf.Rem2)>0) then dummy:=dummy+' ';
						dummy:=dummy+p^.infobuf.Rem2;
						if (length(dummy)>0) and (length(p^.infobuf.Rem3)>0) then dummy:=dummy+' ';
						dummy:=dummy+p^.infobuf.Rem3;
						vs_document_info(hndl,3,dummy);
						vs_document_info(hndl,4,CompressPath(p^.GetWindowFilename,intin_max-1))
					end;
				pcstemp:=p^.PercentSize;
				p^.PercentSize:=1.0;
				progress:=nil;
				vq_extnd(hndl,1,ewrkout);
				case ewrkout[20] of
				1:
					begin
						xmmfak:=10000/ewrkout[21];
						ymmfak:=10000/ewrkout[22]
					end;
				2:
					begin
						xmmfak:=100000/ewrkout[21];
						ymmfak:=100000/ewrkout[22]
					end;
				3:
					begin
						xmmfak:=1000000/ewrkout[21];
						ymmfak:=1000000/ewrkout[22]
					end
				else
					begin
						xmmfak:=1000/wrkout[3];
						ymmfak:=1000/wrkout[4]
					end
				end;
				inc(wrkout[10],vst_load_fonts(hndl,0));
				{$IFNDEF NVDI5}
				if p^.Speedo then
				{$ENDIF}
					vst_kern(hndl,0,1,q,q);
				mmkopf:=atof(p^.Parms.psbuffer.kopf);
				mmfuss:=atof(p^.Parms.psbuffer.fuss);
				xoffs:=round(atof(p^.Parms.psbuffer.links)*xmmfak);
				yoffs:=round((atof(p^.Parms.psbuffer.oben)+mmkopf)*ymmfak);
				xoffs2:=round(atof(p^.Parms.psbuffer.rechts)*xmmfak);
				yoffs2:=round((atof(p^.Parms.psbuffer.unten)+mmfuss)*ymmfak);
				prcfak:=p^.GetPercent/65536.0;
				xmm100fak:=xmmfak*prcfak/100.0;
				ymm100fak:=ymmfak*prcfak/100.0;
				if meta then
					begin
						inc(xoffs,10);
						inc(xoffs2,10);
						inc(yoffs,10);
						inc(yoffs2,10);
						wrkout[0]:=xoffs+xoffs2;
						wrkout[1]:=yoffs+yoffs2;
						for q:=csc to cec do inc(wrkout[0],GetColWidth(q));
						for q:=rsc to rec do inc(wrkout[1],GetRowHeight(q));
						vm_pagesize(hndl,round((longint(wrkout[0])+longint(1))*longint(10)/xmmfak),round((longint(wrkout[1])+longint(1))*longint(10)/ymmfak));
						vmCoords(hndl,0,wrkout[1],wrkout[0],0);
						v_meta_extents(hndl,0,0,wrkout[0],wrkout[1])
					end;
				xoffs2:=wrkout[0]-xoffs2;
				yoffs2:=wrkout[1]-yoffs2;
				if (xoffs2<=xoffs) or (yoffs2<=yoffs) then
					begin
						Application^.Alert(p,1,NOTE,MESSAGE_PRINT_MARGINS,BUTTON_OK);
						goto _borderr
					end;
				setfont(p^.GetStdFontIndex,p^.GetStdFontSize);
				lcw:=nwidth*trunc(ln(rec+2)/ln(10))+((3*nwidth) shr 1);
				trh:=bheight-1;
				if p^.Parms.psbuffer.rows=bf_Checked then tw:=lcw
				else
					tw:=0;
				if p^.Parms.psbuffer.columns=bf_Checked then th:=trh
				else
					th:=0;
				pagew:=xoffs2+1-xoffs;
				pagex:=0;
				srect.X:=tw;
				t:=csc;
				for q:=csc to cec do
					begin
						inc(srect.X,GetColWidth(q));
						if (srect.X>pagew) or bTst(p^.PColFlags^[q],CRF_UMBRUCH) then
							begin
								inc(pagex);
								if t=q then srect.X:=tw
								else
									begin
										srect.X:=tw+GetColWidth(q);
										t:=q
									end
							end
					end;
				if srect.X>tw then inc(pagex);
				pageh:=yoffs2+1-yoffs;
				pagey:=0;
				srect.Y:=th;
				t:=rsc;
				for q:=rsc to rec do
					begin
						inc(srect.Y,GetRowHeight(q));
						if (srect.Y>pageh) or bTst(p^.PRowFlags^[q],CRF_UMBRUCH) then
							begin
								inc(pagey);
								if t=q then srect.Y:=th
								else
									begin
										srect.Y:=th+GetRowHeight(q);
										t:=q
									end
							end
					end;
				if srect.Y>th then inc(pagey);
				pages:=pagex*pagey;
				new(progress,Init(p,TEXELNAME,RTPRINTPROGRESS));
				if progress<>nil then
					begin
						new(st,Init(progress,RTPPFILE,50,false,''));
						if st<>nil then
							begin
								dummy:=p^.GetWindowFilename;
								if length(dummy)=0 then dummy:=p^.GetRawIconTitle;
								st^.SetText(CompressPath(dummy,49))
							end;
						new(st,Init(progress,RTPPDEVICE,59,false,''));
						if st<>nil then
							begin
								GetDriverNames(num,hndl,txt,dummy);
								if length(txt)>0 then dummy:=dummy+' ('+txt+')';
								st^.SetText(dummy)
							end;
						new(ppp,Init(progress,RTPPPAGE,14,false,''));
						if ppp<>nil then ppp^.Clear;
						new(ppc,Init(progress,RTPPCOPY,15,false,''));
						if ppc<>nil then ppc^.Clear;
						new(pps,Init(progress,RTPPSTATE,20,false,''));
						if pps<>nil then pps^.Clear;
						new(ppa,Init(progress,RTPPABBRUCH,18,false,''));
						if ppa<>nil then ppa^.Enable;
						with progress^ do
							begin
								Attr.Style:=NAME or MOVER;
								MakeWindow;
								WMRedraw(Work.X,Work.Y,Work.W,Work.H)
							end
					end;
				copies:=p^.GetCopies(hndl);
				multicopy:=p^.GetMulticopy(hndl);
				colfx:=(wrkout[13]>LWhite);
				pgvon:=p^.GetPageFrom;
				pgbis:=p^.GetPageTo;
				if not(Between(pgbis,MINPAGES,MAXPAGES)) then pgbis:=pgvon;
				if pgvon>pages then pgvon:=pages;
				if pgbis>pages then pgbis:=pages;
				dec(pgvon);
				dec(pgbis);
				if pgvon>pgbis then
					begin
						pgy:=pgvon;
						pgvon:=pgbis;
						pgbis:=pgy
					end;
				vbpages:=pgbis+1-pgvon;
				repeat
					if ppc<>nil then
						begin
							if multicopy>1 then ppc^.SetText(ltoa(multicopy)+' '+STRING_COPIES)
							else
								ppc^.SetText(STRING_COPY+' '+ltoa(p^.GetCopies(hndl)+1-copies)+'/'+ltoa(p^.GetCopies(hndl)));
						end;
					re:=rsc-1;
					for pgy:=0 to pagey-1 do
						begin
							rs:=re+1;
							srect.Y:=th;
							repeat
								inc(re);
								inc(srect.Y,GetRowHeight(re))
							until (srect.Y>pageh) or (re=rec) or bTst(p^.PRowFlags^[re],CRF_UMBRUCH);
							if (re>rs) and (((re<>rec) and not(bTst(p^.PRowFlags^[re],CRF_UMBRUCH))) or (srect.Y>pageh)) then dec(re);
							ce:=csc-1;
							for pgx:=0 to pagex-1 do
								begin
									cs:=ce+1;
									srect.X:=tw;
									repeat
										inc(ce);
										inc(srect.X,GetColWidth(ce))
									until (srect.X>pagew) or (ce=cec) or bTst(p^.PColFlags^[ce],CRF_UMBRUCH);
									if (ce>cs) and (((ce<>cec) and not(bTst(p^.PColFlags^[ce],CRF_UMBRUCH))) or (srect.X>pagew)) then dec(ce);
									if p^.Parms.psbuffer.num1=bf_Checked then page:=pgy*pagex+pgx
									else
										page:=pgx*pagey+pgy;
									if (page>=pgvon) and (page<=pgbis) then
										begin
											if ppp<>nil then ppp^.SetText(STRING_PAGE+' '+ltoa(pgy*pagex+pgx+1-pgvon)+'/'+ltoa(vbpages));
											if pps<>nil then pps^.SetText(STRING_BUILDPAGE);
											if progress<>nil then
												begin
													wind_update(BEG_UPDATE);
													with SysInfo.Desktop do progress^.WMRedraw(X,Y,W,H);
													wind_update(END_UPDATE)
												end;
											{$IFNDEF NVDI5}
											if NVDIVersion=0 then
												if p^.ClearDispList then v_clear_disp_list(hndl);
											{$ENDIF}
											srect.X1:=0;
											srect.Y1:=0;
											srect.X2:=0;
											srect.Y2:=0;
											for q:=cs to ce do inc(srect.X2,GetColWidth(q));
											for q:=rs to re do inc(srect.Y2,GetRowHeight(q));
											A2toGR(srect);
											if p^.Parms.psbuffer.rows=bf_Checked then XPixOffs:=-lcw-1
											else
												XPixOffs:=0;
											if p^.Parms.psbuffer.columns=bf_Checked then YPixOffs:=-trh-1
											else
												YPixOffs:=0;
											if cs>0 then
												for q:=0 to cs-1 do inc(XPixOffs,GetColWidth(q));
											if rs>0 then
												for q:=0 to rs-1 do inc(YPixOffs,GetRowHeight(q));
											if not(printdoc(xoffs,yoffs,xoffs2,yoffs2)) then
												begin
													if p^.ClearDispList then v_clear_disp_list(hndl);
													goto _borderr
												end;
											{$IFDEF NVDI5}
											v_clrwk(hndl);
											{$ELSE}
											if NVDIVersion<>0 then v_clrwk(hndl)
											else
												if p^.DoFeed then v_form_adv(hndl);
											{$ENDIF}
											if not(p^.DoSheet) then
												if Application^.Alert(p,1,NOTE,MESSAGE_PRINT_NEWSHEET,BUTTON_OKCANCEL)=2 then goto _borderr
										end
								end
						end;
					dec(copies)
				until copies<=0;
				PrintSheet:=true;
				inc(p^.infobuf.Printed);
				p^.SetDirty;
				_borderr:
				vst_unload_fonts(hndl,0);
				v_clswk(hndl);
				p^.PercentSize:=pcstemp;
				if progress<>nil then dispose(progress,Done);
				if TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set) then TexelApp.UpdateFile(StrPas(p^.wnd_prnt_set^.device),0)
				{$IFNDEF WDIALOG}
				else
					begin
						if meta then TexelApp.UpdateFile(TexelApp.LastPath[11]+TexelApp.LastFile[11],0);
						if bitimage then TexelApp.UpdateFile(TexelApp.LastPath[14]+TexelApp.LastFile[14],0)
					end
				{$ENDIF}
			end;
		_error:
		ArrowMouse
	end;

end.