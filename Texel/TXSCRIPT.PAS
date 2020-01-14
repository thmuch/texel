unit txscript;
{ 1999-03-04 }

interface

uses

	OTypes,OWindows;


type

	PScriptHandler = ^TScriptHandler;
	TScriptHandler = object(TEvent)
		function InterpreteScript(pcmd: PChar; var answ: Pipearray): integer;
	end;




implementation

uses

	Strings,Gem,
	OProcs,
	txtypes,txexport,txsave,txmain,txlang;

const

	CMD_APPGETLONGNAME  = 0;
	CMD_CELL            = CMD_APPGETLONGNAME+1;
	CMD_CHECKAPP        = CMD_CELL+1;
	CMD_CHECKCOMMAND    = CMD_CHECKAPP+1;
	CMD_CLOSE           = CMD_CHECKCOMMAND+1;
	CMD_COPY            = CMD_CLOSE+1;
	CMD_CUT             = CMD_COPY+1;
	CMD_DELETE          = CMD_CUT+1;
	CMD_EXPORT          = CMD_DELETE+1;
	CMD_GETALLCOMMANDS  = CMD_EXPORT+1;
	CMD_GETCELL         = CMD_GETALLCOMMANDS+1;
	CMD_GETCELLFORMULA  = CMD_GETCELL+1;
	CMD_GETCELLVALUE    = CMD_GETCELLFORMULA+1;
	CMD_GETCOLUMNS      = CMD_GETCELLVALUE+1;
	CMD_GETFRONT        = CMD_GETCOLUMNS+1;
	CMD_GETRANGE        = CMD_GETFRONT+1;
	CMD_GETROWS         = CMD_GETRANGE+1;
	CMD_GETSELECTION    = CMD_GETROWS+1;
	CMD_GETVARIABLE     = CMD_GETSELECTION+1;
	CMD_GOTO            = CMD_GETVARIABLE+1;
	CMD_ISBLOCKUSED     = CMD_GOTO+1;
	CMD_ISCELLCONST     = CMD_ISBLOCKUSED+1;
	CMD_ISCELLEMPTY     = CMD_ISCELLCONST+1;
	CMD_ISCELLFORMULA   = CMD_ISCELLEMPTY+1;
	CMD_ISCELLTEXT      = CMD_ISCELLFORMULA+1;
	CMD_NEW             = CMD_ISCELLTEXT+1;
	CMD_OPEN            = CMD_NEW+1;
	CMD_PASTE           = CMD_OPEN+1;
	CMD_PRINT           = CMD_PASTE+1;
	CMD_QUIT            = CMD_PRINT+1;
	CMD_RECALC          = CMD_QUIT+1;
	CMD_RETURNCELLVALUE = CMD_RECALC+1;
	CMD_SAVE            = CMD_RETURNCELLVALUE+1;
	CMD_SAVEAS          = CMD_SAVE+1;
	CMD_SELECT          = CMD_SAVEAS+1;
	CMD_SELECTALL       = CMD_SELECT+1;
	CMD_SETCELL         = CMD_SELECTALL+1;
	CMD_SETCOLOR        = CMD_SETCELL+1;
	CMD_SETTEXTCOLOR    = CMD_SETCOLOR+1;
	CMD_TOFRONT         = CMD_SETTEXTCOLOR+1;

	CMDS_MAX            = CMD_TOFRONT;

var

	cmds,prms: array [0..CMDS_MAX] of PChar;
	milan    : array [0..CMDS_MAX] of boolean;



function TScriptHandler.InterpreteScript(pcmd: PChar; var answ: Pipearray): integer;
	label _error;
	
	var pw   : PCalcWindow;
	    txt,
	    txt2 : string;
	    pbuf : pointer;
	    pn   : PChar;
	    ibuf,
	    rs,cs,
	    re,ce,
	    f1,f2: integer;
	    cell : PCell;
	    nval : TNumber;
	    isrc : boolean;

	function IsCmdNr(cmdnr: integer): boolean;
	
		begin
			if stricomp(pcmd,cmds[cmdnr])=0 then
				begin
					inc(longint(pcmd),StrLen(cmds[cmdnr])+1);
					IsCmdNr:=true;
				end
			else
				IsCmdNr:=false;
		end;

	function NextToken: boolean;
		label _again;
	
		begin
			NextToken:=false;
			if pcmd=nil then exit;
			_again:
			if pcmd^=#0 then
				begin
					pn:=pcmd;
					exit
				end;
			if pcmd^ in [#3..#6] then
				begin
					inc(longint(pcmd),StrLen(pcmd)+1);
					goto _again
				end;
			if pcmd^=#1 then
				begin
					inc(longint(pcmd),StrLen(pcmd)+1);
					pn:=PChar(longint(pcmd)-1)
				end
			else
				begin
					pn:=pcmd;
					inc(longint(pcmd),StrLen(pcmd)+1)
				end;
			NextToken:=true
		end;
	
	function GetToken(p: PChar): string;
		var s  : string;
		    w  : word;
		    one: boolean;
	
		begin
			if p=nil then GetToken:=''
			else
				if p^=#2 then
					begin
						s:='';
						w:=0;
						one:=false;
						while p^<>#0 do
							begin
								w:=w shl 4;
								if p^ in ['0'..'9'] then w:=w+ord(p^)-48
								else
									if upcase(p^) in ['A'..'F'] then w:=w+ord(upcase(p^))-55
									else
										break;
								if one then
									begin
										s:=s+chr(lo(w));
										if length(s)=255 then break
									end;
								one:=not(one);
								inc(longint(p))
							end;
						GetToken:=s
					end
				else
					GetToken:=StrPas(p)
		end;
	
	function CheckCommand(tst: string): string;
		var i: integer;
	
		begin
			CheckCommand:='0';
			tst:=tst+#0;
			for i:=0 to CMDS_MAX do
				begin
					{$IFDEF LITE}
					if not(milan[i]) then continue;
					{$ENDIF}
					if stricomp(@tst[1],cmds[i])=0 then
						begin
							CheckCommand:='1';
							exit;
						end;
				end;
		end;

{$IFNDEF LITE}
	function findtopsheet: PCalcWindow;
		var pfw  : PWindow;
		    o1,g1,
		    u1,
		    dummy: integer;

		begin
			wind_update(BEG_UPDATE);
			u1:=DESK;
			wind_get(DESK,WF_TOP,o1,dummy,u1,dummy);
			if o1<0 then o1:=u1;
			pfw:=nil;
			if not(appl_xgetinfo(11,g1,dummy,dummy,dummy)) then g1:=0;
			repeat
				pfw:=Application^.GetGPWindow(o1);
				if pfw<>nil then
					if pfw^.GetClassName<>TEXELWINDCLASS then pfw:=nil;
				if pfw=nil then
					if bTst(g1,16) then wind_get(o1,WF_OWNER,dummy,dummy,dummy,o1);
			until (pfw<>nil) or (o1<=DESK) or not(bTst(g1,16));
			wind_update(END_UPDATE);
			findtopsheet:=PCalcWindow(pfw)
		end;

	function getwindow(p: PChar; usetop: boolean): PCalcWindow;
		var ptw: PWindow;
		    s  : string;
	
		begin
			getwindow:=nil;
			if p=nil then exit;
			if p^=#0 then
				begin
					if usetop then getwindow:=findtopsheet
				end
			else
				begin
					s:=StrPUpper(GetToken(p));
					ptw:=Application^.MainWindow;
					while ptw<>nil do
						begin
							if ptw^.GetClassName=TEXELWINDCLASS then
								if StrPUpper(PCalcWindow(ptw)^.GetWindowFilename)=s then
									begin
										getwindow:=PCalcWindow(ptw);
										exit
									end;
							ptw:=ptw^.Next
						end;
					if pos('\',s)>0 then exit;
					s:=GetFilename(s,true);
					ptw:=Application^.MainWindow;
					while ptw<>nil do
						begin
							if ptw^.GetClassName=TEXELWINDCLASS then
								if GetFilename(StrPUpper(PCalcWindow(ptw)^.GetWindowFilename),true)=s then
									begin
										getwindow:=PCalcWindow(ptw);
										exit
									end;
							ptw:=ptw^.Next
						end;
					if pos('.',s)>0 then exit;
					s:=GetFilename(s,false);
					ptw:=Application^.MainWindow;
					while ptw<>nil do
						begin
							if ptw^.GetClassName=TEXELWINDCLASS then
								if GetFilename(StrPUpper(PCalcWindow(ptw)^.GetWindowFilename),false)=s then
									begin
										getwindow:=PCalcWindow(ptw);
										exit
									end;
							ptw:=ptw^.Next
						end
				end
		end;
{$ENDIF}
	
	procedure answer(s: string);
	
		begin
			s:=s+#0#0;
			GlobalAlloc(pbuf,length(s));
			if pbuf=nil then exit;
			move(s[1],pbuf^,length(s));
			answ[5]:=integer(HiWord(pbuf));
			answ[6]:=integer(LoWord(pbuf))
		end;

	function exportfile: boolean;
		var texbuf: TExportBuf;

		begin
			exportfile:=false;
			{$IFNDEF LITE}
			if pw^.export=nil then exit;
			with texbuf do
				begin
					exporttype:=-1;
					if length(txt2)=0 then clipboard:=bf_Checked
					else
						clipboard:=bf_Unchecked;
					bereich:=bf_Unchecked;
					htmldoctype:=1;
					htmlsavedt:=bf_Checked;
					htmlcolor:=bf_Checked;
					csvformula:=bf_Unchecked;
					csvvalue:=bf_Checked;
					difformula:=bf_Unchecked;
					difvalue:=bf_Checked;
					difstandard:=bf_Checked;
					difexcel:=bf_Unchecked;
					with ascii do
						begin
							hor:=bf_Checked;
							vert:=bf_Unchecked;
							rctxt:='13,10';
							rcval:=0;
							celltxt:='9';
							cellval:=0;
							texttxt:='34';
							textval:=0;
							quote:=bf_Checked;
							numbers:=0;
							formula:=bf_Unchecked;
							value:=bf_Checked
						end;
					difformat:=bf_Checked;
					csvformat:=bf_Checked;
					asciiformat:=bf_Checked;
					htmlembed:=bf_Unchecked;
					filter:=0;
					htmlnoesc:=bf_Unchecked;
					xlsversion:=0; { 2 ... }
					htmlcss:=1;
					texelvers:=0;
					htmlfonts:=bf_Checked;
					if (txt='XLS') or (txt='BIFF4') then exporttype:=1
					else if (txt='SYLK') or (txt='SLK') then exporttype:=2
					else if txt='DIF' then exporttype:=3
					else if txt='CSV' then exporttype:=4
					else if (txt='ASCII') or (txt='ASC') then exporttype:=5
					else if txt='TXT' then exporttype:=6
					else if txt='TEX' then exporttype:=7
					else if (txt='HTML') or (txt='HTML-32') then exporttype:=8
					else if txt='UDO' then exporttype:=9
					else if txt='RTF' then exporttype:=10
					else if (txt='TEXEL') or (txt='TEXEL-16') then exporttype:=11
					else if txt='TEXEL-20' then
						begin
							exporttype:=11;
							texelvers:=1
						end
					else if txt='BIFF2' then
						begin
							exporttype:=1;
							xlsversion:=0
						end
					else if txt='BIFF3' then
						begin
							exporttype:=1;
{							xlsversion:=1 ... }
						end
					else if txt='BIFF5' then
						begin
							exporttype:=1;
{							xlsversion:=3 ... }
						end
					else if txt='HTML-30' then
						begin
							exporttype:=8;
							htmldoctype:=0
						end
					else if txt='HTML-40' then
						begin
							exporttype:=8;
							htmldoctype:=2
						end;
				end;
			exportfile:=PExport(pw^.export)^.Export(texbuf,txt2)
			{$ENDIF}
		end;

{$IFNDEF LITE}
	procedure getvariable;
		var ret: real;
		    w  : longint;
	
		begin
			ret:=0.0;
			with pw^ do
				begin
					if Variables<>nil then
						if Variables^.Count>0 then
							for w:=Variables^.Count-1 downto 0 do
								with PVariable(Variables^.At(w))^ do
									if txt=StrPUpper(Name^) then
										if (RefRow>=0) and (RefRow<=Parms.Rows) and (RefCol>=0) and (RefCol<=Parms.Columns) then
											begin
												ret:=Evaluate(GetCell(RefRow,RefCol));
												break
											end
				end;
			answer(ftoa(ret))
		end;
{$ENDIF}

	procedure GetAllCommands;
		var len,l: longint;
		    i    : integer;
		    full : boolean;
		    cbuf : pointer;
		    cp   : PChar;
	
		begin
			{$IFNDEF LITE}
			full:=true;
			{$ELSE}
			full:=false;
			{$ENDIF}
			len:=1;
			for i:=0 to CMDS_MAX do
				if (full or milan[i]) then
					begin
						inc(len,StrLen(cmds[i])+1);
						l:=StrLen(prms[i]);
						if (l>0) then inc(len,l+1);
					end;
			GlobalAlloc(cbuf,len);
			if cbuf=nil then exit;
			cp:=cbuf;
			for i:=0 to CMDS_MAX do
				if (full or milan[i]) then
					begin
						StrCopy(cp,cmds[i]);
						l:=StrLen(prms[i]);
						if (l>0) then
							begin
								StrCat(cp,' ');
								StrCat(cp,prms[i]);
								inc(longint(cp),StrLen(cmds[i])+l+2);
							end
						else
							inc(longint(cp),StrLen(cmds[i])+1);
					end;
			cp^:=#0;
			answ[5]:=integer(HiWord(cbuf));
			answ[6]:=integer(LoWord(cbuf));
		end;

	begin
		InterpreteScript:=GSACK_ERROR;
		if pcmd=nil then exit;
		if pcmd^=#0 then exit;
		InterpreteScript:=GSACK_OK;
		{$IFNDEF LITE}
		if IsCmdNr(CMD_RETURNCELLVALUE) then
			begin
				if not(NextToken) then goto _error;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(NextToken) then goto _error;
				if not(pw^.GetBlock(GetToken(pn),false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				if cell^.Typ<>CTYPE_FORMULA then goto _error;
				with cell^.Data.Formula^.Func^ do
					if (Typ<>NT_SCRIPTNO) and not(Between(Typ,NT_EXTMIN,NT_EXTMAX)) then goto _error;
				if not(NextToken) then goto _error;
				nval:=atof(GetToken(pn));
				if nval<>cell^.Data.Formula^.Value then
					begin
						cell^.Data.Formula^.Value:=nval;
						pw^.DrawCells(rs,cs,rs,cs);
						pw^.AutoCalculate(true)
					end;
				exit
			end;
		if IsCmdNr(CMD_GETVARIABLE) then
			begin
				if not(NextToken) then goto _error;
				txt:=StrPUpper(GetToken(pn));
				if length(txt)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				getvariable;
				exit
			end;
		if IsCmdNr(CMD_SELECT) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.GotoBlock(txt);
				exit
			end;
		if IsCmdNr(CMD_SETCELL) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				if not(NextToken) then goto _error;
				txt2:=GetToken(pn);
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				ibuf:=pw^.sheetbuffer.autocalc;
				pw^.sheetbuffer.autocalc:=bf_Unchecked;
				pw^.ChangeCell(pw^.GetCell(rs,cs),txt2,rs,cs,true);
				pw^.sheetbuffer.autocalc:=ibuf;
				exit
			end;
		if IsCmdNr(CMD_GETRANGE) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				answer(ltoa(rs)+#0+ltoa(cs)+#0+ltoa(re)+#0+ltoa(ce));
				exit
			end;
		if IsCmdNr(CMD_CELL) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if not(NextToken) then goto _error;
				txt2:=GetToken(pn);
				if length(txt2)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				answer(pw^.GetColumnName(atol(txt2))+pw^.GetRowIndex(atol(txt)));
				exit
			end;
		if IsCmdNr(CMD_SETCOLOR) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.SetCellColor(atol(txt));
				exit
			end;
		if IsCmdNr(CMD_SETTEXTCOLOR) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.SetTextColor(atol(txt));
				exit
			end;
		if IsCmdNr(CMD_ISBLOCKUSED) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				if pw^.IsBlockUsed(rs,cs,re,ce,1) then answer('1')
				else
					answer('0');
				exit
			end;
		if IsCmdNr(CMD_CUT) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.Cut;
				exit
			end;
		if IsCmdNr(CMD_COPY) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.Copy;
				exit
			end;
		if IsCmdNr(CMD_PASTE) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.Paste;
				exit
			end;
		if IsCmdNr(CMD_DELETE) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.Delete;
				exit
			end;
		if IsCmdNr(CMD_SELECTALL) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.SelectAll;
				exit
			end;
		if IsCmdNr(CMD_PRINT) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.Print;
				exit
			end;
		if IsCmdNr(CMD_SAVE) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.save^.Work;
				exit
			end;
		if IsCmdNr(CMD_SAVEAS) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				PSaveAs(pw^.saveas)^.SaveAs(txt,0);
				exit
			end;
		if IsCmdNr(CMD_TOFRONT) then
			begin
				if not(NextToken) then goto _error;
				pw:=getwindow(pn,false);
				if pw=nil then goto _error;
				pw^.Top;
				exit
			end;
		if IsCmdNr(CMD_GETFRONT) then
			begin
				pw:=findtopsheet;
				if pw=nil then goto _error;
				txt:=pw^.GetWindowFilename;
				if length(txt)=0 then goto _error;
				answer(txt);
				exit
			end;
		if IsCmdNr(CMD_GETSELECTION) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				txt:=StrPTrimF(pw^.dblock^.GetText);
				if length(txt)=0 then goto _error;
				answer(txt);
				exit
			end;
		if IsCmdNr(CMD_GETCELL) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				case cell^.Typ of
				CTYPE_TEXT:
					txt:=cell^.Data.Txt^;
				CTYPE_CONST:
					txt:=pw^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil);
				CTYPE_FORMULA:
					txt:=pw^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil);
				else
					txt:=''
				end;
				if length(txt)=0 then txt:=#1;
				answer(txt);
				exit
			end;
		if IsCmdNr(CMD_GETCELLFORMULA) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				case cell^.Typ of
				CTYPE_TEXT:
					txt:=pw^.GetOutputLine(cell);
				CTYPE_CONST:
					begin
						if cell^.Data.Konst^.Txt=nil then
							txt:=pw^.Val2TxtF(cell^.Data.Konst^.Value,MAXCIPHERS,0,nil)
						else
							txt:=cell^.Data.Konst^.Txt^;
						TexelApp.KommaToPunkt(txt)
					end;
				CTYPE_FORMULA:
					txt:=pw^.BuildFunction(cell,true);
				else
					txt:=''
				end;
				if length(txt)=0 then txt:=#1;
				answer(txt);
				exit
			end;
		if IsCmdNr(CMD_GETCELLVALUE) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				case cell^.Typ of
				CTYPE_TEXT:
					txt:=pw^.GetOutputLine(cell);
				CTYPE_CONST:
					txt:=TexelApp.Num2Txt(cell^.Data.Konst^.Value,MAXCIPHERS,false,false);
				CTYPE_FORMULA:
					txt:=TexelApp.Num2Txt(cell^.Data.Formula^.Value,MAXCIPHERS,false,false);
				else
					txt:=''
				end;
				if length(txt)=0 then txt:=#1;
				answer(txt);
				exit
			end;
		if IsCmdNr(CMD_ISCELLEMPTY) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				if cell^.Typ=CTYPE_EMPTY then answer('1')
				else
					answer('0');
				exit
			end;
		if IsCmdNr(CMD_ISCELLTEXT) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				if cell^.Typ=CTYPE_TEXT then answer('1')
				else
					answer('0');
				exit
			end;
		if IsCmdNr(CMD_ISCELLCONST) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				if cell^.Typ=CTYPE_CONST then answer('1')
				else
					answer('0');
				exit
			end;
		if IsCmdNr(CMD_ISCELLFORMULA) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then goto _error;
				if (txt[1] in ['0'..'9']) then
					begin
						rs:=atol(txt);
						if not(NextToken) then goto _error;
						cs:=atol(GetToken(pn));
						isrc:=true
					end
				else
					isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				cell:=pw^.GetCell(rs,cs);
				if cell^.Typ=CTYPE_FORMULA then answer('1')
				else
					answer('0');
				exit
			end;
		if IsCmdNr(CMD_GETROWS) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				answer(ltoa(pw^.Parms.Rows+1));
				exit
			end;
		if IsCmdNr(CMD_GETCOLUMNS) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				answer(ltoa(pw^.Parms.Columns+1));
				exit
			end;
		if IsCmdNr(CMD_GOTO) then
			begin
				if not(NextToken) then goto _error;
				txt:=GetToken(pn);
				if length(txt)=0 then
					begin
						rs:=0;
						cs:=0;
						isrc:=true
					end
				else
					if (txt[1] in ['0'..'9']) then
						begin
							rs:=atol(txt);
							if not(NextToken) then goto _error;
							cs:=atol(GetToken(pn));
							isrc:=true
						end
					else
						isrc:=false;
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(isrc) then
					if not(pw^.GetBlock(txt,false,rs,cs,re,ce,f1,f2)) then goto _error;
				pw^.SetCursorPos(rs,cs,true);
				exit
			end;
		if IsCmdNr(CMD_RECALC) then
			begin
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				pw^.Calculate(true);
				exit
			end;
		if IsCmdNr(CMD_CLOSE) then
			begin
				while NextToken do
					begin
						pw:=getwindow(pn,true);
						if pw<>nil then pw^.WMClosed
					end;
				exit
			end;
		if IsCmdNr(CMD_OPEN) then
			begin
				if pcmd^=#0 then TexelApp.opennewdoc^.Work
				else
					while NextToken do
						begin
							if pn^=#0 then TexelApp.opennewdoc^.Work
							else
								TexelApp.LoadFile(nil,GetToken(pn))
						end;
				exit
			end;
		if IsCmdNr(CMD_EXPORT) then
			begin
				if not(NextToken) then goto _error;
				txt:=StrPUpper(GetToken(pn));
				if length(txt)=0 then goto _error;
				if not(NextToken) then goto _error;
				txt2:=GetToken(pn);
				NextToken;
				pw:=getwindow(pn,true);
				if pw=nil then goto _error;
				if not(exportfile) then goto _error;
				exit
			end;
		if IsCmdNr(CMD_NEW) then
			begin
				new(PCalcWindow,Init(nil));
				exit
			end;
		{$ENDIF}
		if IsCmdNr(CMD_APPGETLONGNAME) then
			begin
				answer(TEXELNAME);
				exit
			end;
		if IsCmdNr(CMD_CHECKAPP) then
			begin
				if not(NextToken) then goto _error;
				if Application^.StartApp(GetToken(pn),'')<0 then goto _error;
				exit
			end;
		if IsCmdNr(CMD_CHECKCOMMAND) then
			begin
				if not(NextToken) then goto _error;
				answer(CheckCommand(GetToken(pn)));
				exit
			end;
		if IsCmdNr(CMD_GETALLCOMMANDS) then
			begin
				GetAllCommands;
				exit
			end;
		if IsCmdNr(CMD_QUIT) then
			begin
				Application^.Quit;
				exit
			end;
		InterpreteScript:=GSACK_UNKNOWN;
		exit;
		_error:
		InterpreteScript:=GSACK_ERROR
	end;


begin
	cmds[CMD_APPGETLONGNAME]:='AppGetLongName';		milan[CMD_APPGETLONGNAME]:=true;		prms[CMD_APPGETLONGNAME]:='';
	cmds[CMD_CELL]:='Cell';												milan[CMD_CELL]:=false;							prms[CMD_CELL]:=CMD_DOC_CELL;
	cmds[CMD_CHECKAPP]:='CheckApp';								milan[CMD_CHECKAPP]:=true;					prms[CMD_CHECKAPP]:=CMD_DOC_CHECKAPP;
	cmds[CMD_CHECKCOMMAND]:='CheckCommand';				milan[CMD_CHECKCOMMAND]:=true;			prms[CMD_CHECKCOMMAND]:=CMD_DOC_CHECKCOMMAND;
	cmds[CMD_CLOSE]:='Close';											milan[CMD_CLOSE]:=false;						prms[CMD_CLOSE]:=CMD_DOC_CLOSE;
	cmds[CMD_COPY]:='Copy';												milan[CMD_COPY]:=false;							prms[CMD_COPY]:=CMD_DOC_COPY;
	cmds[CMD_CUT]:='Cut';													milan[CMD_CUT]:=false;							prms[CMD_CUT]:=CMD_DOC_CUT;
	cmds[CMD_DELETE]:='Delete';										milan[CMD_DELETE]:=false;						prms[CMD_DELETE]:=CMD_DOC_DELETE;
	cmds[CMD_EXPORT]:='Export';										milan[CMD_EXPORT]:=false;						prms[CMD_EXPORT]:=CMD_DOC_EXPORT;
	cmds[CMD_GETALLCOMMANDS]:='GetAllCommands';		milan[CMD_GETALLCOMMANDS]:=true;		prms[CMD_GETALLCOMMANDS]:='';
	cmds[CMD_GETCELL]:='GetCell';									milan[CMD_GETCELL]:=false;					prms[CMD_GETCELL]:=CMD_DOC_GETCELL;
	cmds[CMD_GETCELLFORMULA]:='GetCellFormula';		milan[CMD_GETCELLFORMULA]:=false;		prms[CMD_GETCELLFORMULA]:=CMD_DOC_GETCELLFORMULA;
	cmds[CMD_GETCELLVALUE]:='GetCellValue';				milan[CMD_GETCELLVALUE]:=false;			prms[CMD_GETCELLVALUE]:=CMD_DOC_GETCELLVALUE;
	cmds[CMD_GETCOLUMNS]:='GetColumns';						milan[CMD_GETCOLUMNS]:=false;				prms[CMD_GETCOLUMNS]:=CMD_DOC_GETCOLUMNS;
	cmds[CMD_GETFRONT]:='GetFront';								milan[CMD_GETFRONT]:=false;					prms[CMD_GETFRONT]:='';
	cmds[CMD_GETRANGE]:='GetRange';								milan[CMD_GETRANGE]:=false;					prms[CMD_GETRANGE]:=CMD_DOC_GETRANGE;
	cmds[CMD_GETROWS]:='GetRows';									milan[CMD_GETROWS]:=false;					prms[CMD_GETROWS]:=CMD_DOC_GETROWS;
	cmds[CMD_GETSELECTION]:='GetSelection';				milan[CMD_GETSELECTION]:=false;			prms[CMD_GETSELECTION]:=CMD_DOC_GETSELECTION;
	cmds[CMD_GETVARIABLE]:='GetVariable';					milan[CMD_GETVARIABLE]:=false;			prms[CMD_GETVARIABLE]:=CMD_DOC_GETVARIABLE;
	cmds[CMD_GOTO]:='Goto';												milan[CMD_GOTO]:=false;							prms[CMD_GOTO]:=CMD_DOC_GOTO;
	cmds[CMD_ISBLOCKUSED]:='IsBlockUsed';					milan[CMD_ISBLOCKUSED]:=false;			prms[CMD_ISBLOCKUSED]:=CMD_DOC_ISBLOCKUSED;
	cmds[CMD_ISCELLCONST]:='IsCellConst';					milan[CMD_ISCELLCONST]:=false;			prms[CMD_ISCELLCONST]:=CMD_DOC_ISCELLCONST;
	cmds[CMD_ISCELLEMPTY]:='IsCellEmpty';					milan[CMD_ISCELLEMPTY]:=false;			prms[CMD_ISCELLEMPTY]:=CMD_DOC_ISCELLEMPTY;
	cmds[CMD_ISCELLFORMULA]:='IsCellFormula';			milan[CMD_ISCELLFORMULA]:=false;		prms[CMD_ISCELLFORMULA]:=CMD_DOC_ISCELLFORMULA;
	cmds[CMD_ISCELLTEXT]:='IsCellText';						milan[CMD_ISCELLTEXT]:=false;				prms[CMD_ISCELLTEXT]:=CMD_DOC_ISCELLTEXT;
	cmds[CMD_NEW]:='New';													milan[CMD_NEW]:=false;							prms[CMD_NEW]:='';
	cmds[CMD_OPEN]:='Open';												milan[CMD_OPEN]:=false;							prms[CMD_OPEN]:=CMD_DOC_OPEN;
	cmds[CMD_PASTE]:='Paste';											milan[CMD_PASTE]:=false;						prms[CMD_PASTE]:=CMD_DOC_PASTE;
	cmds[CMD_PRINT]:='Print';											milan[CMD_PRINT]:=false;						prms[CMD_PRINT]:=CMD_DOC_PRINT;
	cmds[CMD_QUIT]:='Quit';												milan[CMD_QUIT]:=true;							prms[CMD_QUIT]:='';
	cmds[CMD_RECALC]:='Recalc';										milan[CMD_RECALC]:=false;						prms[CMD_RECALC]:=CMD_DOC_RECALC;
	cmds[CMD_RETURNCELLVALUE]:='ReturnCellValue';	milan[CMD_RETURNCELLVALUE]:=false;	prms[CMD_RETURNCELLVALUE]:=CMD_DOC_RETURNCELLVALUE;
	cmds[CMD_SAVE]:='Save';												milan[CMD_SAVE]:=false;							prms[CMD_SAVE]:=CMD_DOC_SAVE;
	cmds[CMD_SAVEAS]:='SaveAs';										milan[CMD_SAVEAS]:=false;						prms[CMD_SAVEAS]:=CMD_DOC_SAVEAS;
	cmds[CMD_SELECT]:='Select';										milan[CMD_SELECT]:=false;						prms[CMD_SELECT]:=CMD_DOC_SELECT;
	cmds[CMD_SELECTALL]:='SelectAll';							milan[CMD_SELECTALL]:=false;				prms[CMD_SELECTALL]:=CMD_DOC_SELECTALL;
	cmds[CMD_SETCELL]:='SetCell';									milan[CMD_SETCELL]:=false;					prms[CMD_SETCELL]:=CMD_DOC_SETCELL;
	cmds[CMD_SETCOLOR]:='SetColor';								milan[CMD_SETCOLOR]:=false;					prms[CMD_SETCOLOR]:=CMD_DOC_SETCOLOR;
	cmds[CMD_SETTEXTCOLOR]:='SetTextColor';				milan[CMD_SETTEXTCOLOR]:=false;			prms[CMD_SETTEXTCOLOR]:=CMD_DOC_SETTEXTCOLOR;
	cmds[CMD_TOFRONT]:='ToFront';									milan[CMD_TOFRONT]:=false;					prms[CMD_TOFRONT]:=CMD_DOC_TOFRONT;
end.