unit txhelp;
{ 1999-03-07 }

interface

uses

	OWindows;


type
	
	PTip = ^TTip;
	TTip = object(TMenu)
		procedure Work; virtual;
	end;

	PHelp = ^THelp;
	THelp = object(TMenu)
		procedure Work; virtual;
	end;

	PHelpItem = ^THelpItem;
	THelpItem = object(TKeyMenu)
		procedure Work; virtual;
	end;

	PWeb = ^TWeb;
	TWeb = object(TMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Strings,Tos,Gem,
	OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txdhst,txmain
	{$IFNDEF BETA},txprocs{$ENDIF};



type

	PTipDialog = ^TTipDialog;
	TTipDialog = object(THyperDialog)
		st1,
		st2,
		st3,
		st4,
		st5: PStatic;
		gb : PGroupBox;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure NextTip;
	end;

	PHelpItemDialog = ^THelpItemDialog;
	THelpItemDialog = object(THyperDialog)
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;



function TTipDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=RTTPNEXT then NextTip
	end;


procedure TTipDialog.NextTip;
	var res,spos: longint;
	    hdl,q   : integer;
	    s       : string;

	begin
		BusyMouse;
		if st1<>nil then st1^.Clear;
		if st2<>nil then st2^.Clear;
		if st3<>nil then st3^.Clear;
		if st4<>nil then st4^.Clear;
		if st5<>nil then st5^.Clear;
		res:=fopen(TexelApp.DataPath+TEXELTIPS,FO_READ);
		if res>=0 then
			begin
				hdl:=integer(res);
				spos:=TexelApp.tipflags.nr shl 8;
				inc(TexelApp.tipflags.nr);
				fseek(spos,hdl,0);
				if fread(hdl,256,@s)<>256 then
					begin
						TexelApp.tipflags.nr:=1;
						fseek(0,hdl,0);
						fread(hdl,256,@s)
					end;
				q:=pos('|',s);
				if q=0 then st1^.SetText(s)
				else
					begin
						st1^.SetText(StrPLeft(s,q-1));
						CutLeft(s,q);
						q:=pos('|',s);
						if q=0 then st2^.SetText(s)
						else
							begin
								st2^.SetText(StrPLeft(s,q-1));
								CutLeft(s,q);
								q:=pos('|',s);
								if q=0 then st3^.SetText(s)
								else
									begin
										st3^.SetText(StrPLeft(s,q-1));
										CutLeft(s,q);
										q:=pos('|',s);
										if q=0 then st4^.SetText(s)
										else
											begin
												st4^.SetText(StrPLeft(s,q-1));
												st5^.SetText(CutLeftF(s,q))
											end
									end
							end
					end;
				if TexelApp.abruf<>nil then PAbruf(TexelApp.abruf)^.Dirty:=true;
				fclose(hdl)
			end;
		if gb<>nil then gb^.Paint;
		ArrowMouse
	end;


procedure TTip.Work;
	var pb: PButton;

	begin
		if ADialog=nil then
			begin
				TexelApp.ActivateExtResource;
				ADialog:=new(PTipDialog,Init(nil,TEXELWINDPREFIX+TITLE_TIPS,STG_TIPS,ICNTITLE_TIPS,RTTIPS));
				if ADialog<>nil then
					begin
						new(PTipDialog(ADialog)^.gb,Init(ADialog,RTTPTEXTS,GROUP_TIP_TITLE,BUBBLE_TIP_TEXTS));
						new(PTipDialog(ADialog)^.st1,Init(ADialog,RTTPTEXT1,51,false,BUBBLE_TIP_TEXTS));
						new(PTipDialog(ADialog)^.st2,Init(ADialog,RTTPTEXT2,51,false,BUBBLE_TIP_TEXTS));
						new(PTipDialog(ADialog)^.st3,Init(ADialog,RTTPTEXT3,51,false,BUBBLE_TIP_TEXTS));
						new(PTipDialog(ADialog)^.st4,Init(ADialog,RTTPTEXT4,51,false,BUBBLE_TIP_TEXTS));
						new(PTipDialog(ADialog)^.st5,Init(ADialog,RTTPTEXT5,51,false,BUBBLE_TIP_TEXTS));
						new(PCheckBox,Init(ADialog,RTTPSTART,true,BUBBLE_TIP_START));
						new(pb,Init(ADialog,RTTPHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTTPNEXT,id_No,true,BUBBLE_TIP_NEXT));
						new(PButton,Init(ADialog,RTTPOK,id_OK,true,BUBBLE_GENERAL_CLOSE));
						ADialog^.TransferBuffer:=@TexelApp.tipflags
					end;
				TexelApp.DeactivateExtResource
			end;
		if ADialog<>nil then
			begin
				PTipDialog(ADialog)^.NextTip;
				ADialog^.MakeWindow
			end
	end;


procedure THelp.Work;
	label _aufruf;

	var pipe: Pipearray;
	    p   : PWindow;

	begin
		if not(TexelApp.HelpAvailable(true)) then exit;
		case VMNum of
		RTMHELPCONTEXT:
			begin
				p:=Application^.GetPTopWindow;
				if p<>nil then
					begin
						if p^.IsDialog then
							begin
								PDialog(p)^.Help;
								exit
							end
						{$IFNDEF LITE}
						else
							if p^.GetClassName='SpecialCharactersWindow' then
								begin
									if Exist(TexelApp.DataPath+TEXELHELP) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELP+' '+STG_SPECIALCHARS)
									else
										StrPCopy(helpbuf,GUIDES+TEXELHELP+' '+STG_SPECIALCHARS);
									goto _aufruf
								end;
						{$ENDIF}
					end;
				if Exist(TexelApp.DataPath+TEXELHELP) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELP)
				else
					StrPCopy(helpbuf,GUIDES+TEXELHELP)
			end;
		RTMHELPONHELP:
			StrPCopy(helpbuf,'*:\st-guide.hyp');
		RTMHELPCONTENTS:
			begin
				if Exist(TexelApp.DataPath+TEXELHELP) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELP)
				else
					StrPCopy(helpbuf,GUIDES+TEXELHELP)
			end;
		RTMHELPINDEX:
			begin
				if Exist(TexelApp.DataPath+TEXELHELP) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELP+' Index')
				else
					StrPCopy(helpbuf,GUIDES+TEXELHELP+' Index')
			end
		end;
		_aufruf:
		pipe[0]:=VA_START;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(helpbuf));
		pipe[4]:=integer(LoWord(helpbuf));
		pipe[5]:=0;
		pipe[6]:=0;
		pipe[7]:=0;
		appl_write(TexelApp.HelpID,16,@pipe)
	end;


procedure THelpItem.Work;
	var pb: PButton;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PHelpItemDialog,Init(nil,TEXELWINDPREFIX+TITLE_HELP,STG_HELP,ICNTITLE_HELP,RTHELPITEM));
				if ADialog<>nil then
					begin
						new(PEdit,Init(ADialog,RTHIITEM,41,BUBBLE_HELP_ITEM));
						new(pb,Init(ADialog,RTHIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTHICANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTHISEARCH,id_No,true,BUBBLE_HELP_SEARCH));
						new(PButton,Init(ADialog,RTHIOK,id_OK,true,BUBBLE_HELP_OK));
						TexelApp.HelpItem:='';
						ADialog^.TransferBuffer:=@TexelApp.HelpItem
					end
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;


function THelpItemDialog.OK: boolean;
	var valid: boolean;
	    pipe : Pipearray;
	    dummy: string;

	begin
		valid:=inherited OK;
		OK:=valid;
		if valid then
			begin
				dummy:=StrPTrimF(TexelApp.HelpItem);
				if (length(dummy)=0) or not(TexelApp.HelpAvailable(true)) then exit;
				if Exist(TexelApp.DataPath+TEXELHELPREF) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELPREF+' '+dummy)
				else
					StrPCopy(helpbuf,GUIDES+TEXELHELPREF+' '+dummy);
				pipe[0]:=VA_START;
				pipe[1]:=Application^.apID;
				pipe[2]:=0;
				pipe[3]:=integer(HiWord(helpbuf));
				pipe[4]:=integer(LoWord(helpbuf));
				pipe[5]:=0;
				pipe[6]:=0;
				pipe[7]:=0;
				appl_write(TexelApp.HelpID,16,@pipe);
				TexelApp.HelpItem:=''
			end
	end;


function THelpItemDialog.ExitDlg(AnIndx: integer): boolean;
	var pipe : Pipearray;
	    dummy: string;

	begin
		ExitDlg:=false;
		if AnIndx<>RTHISEARCH then exit;
		TransferData(tf_GetData);
		dummy:=StrPTrimF(TexelApp.HelpItem);
		if (length(dummy)=0) or not(TexelApp.HelpAvailable(true)) then exit;
		if Exist(TexelApp.DataPath+TEXELHELPREF) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELPREF+' '+dummy)
		else
			StrPCopy(helpbuf,GUIDES+TEXELHELPREF+' '+dummy);
		pipe[0]:=VA_START;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(helpbuf));
		pipe[4]:=integer(LoWord(helpbuf));
		pipe[5]:=0;
		pipe[6]:=0;
		pipe[7]:=0;
		appl_write(TexelApp.HelpID,16,@pipe)
	end;


procedure TWeb.Work;
	var pipe : Pipearray;
	    txt,
	    fname: string;
	    ret  : longint;
	    hdl  : integer;

	begin
		if (TexelApp.WebID<0) or (helpbuf=nil) or (GetState<>bf_Enabled) then exit;
		case VMNum of
		RTMHELPASH:
			begin
				StrPCopy(helpbuf,STRING_WEB_HOMEPAGE);
				pipe[0]:=CAB_VIEW;
				pipe[1]:=Application^.apID;
				pipe[2]:=0;
				pipe[3]:=integer(HiWord(helpbuf));
				pipe[4]:=integer(LoWord(helpbuf));
				pipe[5]:=1;
				pipe[6]:=0;
				pipe[7]:=0
			end;
		RTMHELPSUPPORT:
			begin
				fname:=CreateUniqueTempFilename(GetTexelTempDir);
				ret:=fcreate(fname,0);
				if ret<0 then exit;
				hdl:=integer(ret);
				txt:=STRING_WEB_MAILDEF1+#13#10#13#10+STRING_WEB_MAILDEF2+' '+TEXELNAME+' '+VtoS(TEXELVER)+'r'+ltoa(RELEASE)+' '+STRING_WEB_MAILDATEOF+' '+TEXELDATE+':'#13#10#13#10#13#10#13#10+STRING_WEB_MAILDEF3+' ';
				{$IFDEF DEMO}
				txt:=txt+'('+STRING_DEMOVERSION+')';
				{$ELSE}
				{$IFDEF BETA}
				if length(regname)=0 then txt:=txt+'(unregistrierte Version)'
				else
					txt:=txt+regname;
				{$ELSE}
				txt:=txt+decode_name(ash_name);
				{$ENDIF}
				{$ENDIF}
				txt:=txt+#13#10;
				fwrite(hdl,length(txt),@txt[1]);
				fclose(hdl);
				StrPCopy(helpbuf,STRING_WEB_SUPPORT+'?'+STRING_WEB_MAILSUBJECT+' '+TEXELNAME+' '+VtoS(TEXELVER));
				StrPCopy(mailbuf,fname);
				pipe[0]:=CAB_MAIL;
				pipe[1]:=Application^.apID;
				pipe[2]:=0;
				pipe[3]:=integer(HiWord(helpbuf));
				pipe[4]:=integer(LoWord(helpbuf));
				pipe[5]:=integer(HiWord(mailbuf));
				pipe[6]:=integer(LoWord(mailbuf));
				pipe[7]:=3
			end
		end;
		appl_write(TexelApp.WebID,16,@pipe)
	end;

end.