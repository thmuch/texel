unit txtoolba;
{ 1999-03-05 }

interface

uses

	OWindows;


type
	
	PColorToolbar = ^TColorToolbar;
	TColorToolbar = object(TToolbar)
		public
		constructor Init(AParent: PWindow; AnIndx,AColIndx: integer; Switch: boolean; Hlp: string);
		destructor Done; virtual;
		private
		used     : boolean;
		oldobtype: integer;
		oldobspec: longint;
	end;

	PTFett = ^TTFett;
	TTFett = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTKursiv = ^TTKursiv;
	TTKursiv = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTUnter = ^TTUnter;
	TTUnter = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTAlignLeft = ^TTAlignLeft;
	TTAlignLeft = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTAlignCenter = ^TTAlignCenter;
	TTAlignCenter = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTAlignRight = ^TTAlignRight;
	TTAlignRight = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTDezPlus = ^TTDezPlus;
	TTDezPlus = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTDezMinus = ^TTDezMinus;
	TTDezMinus = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTSumme = ^TTSumme;
	TTSumme = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTCut = ^TTCut;
	TTCut = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTCopy = ^TTCopy;
	TTCopy = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTPaste = ^TTPaste;
	TTPaste = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTFunction = ^TTFunction;
	TTFunction = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTNumber = ^TTNumber;
	TTNumber = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTDate = ^TTDate;
	TTDate = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTMoney = ^TTMoney;
	TTMoney = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTPercent = ^TTPercent;
	TTPercent = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTDiagram = ^TTDiagram;
	TTDiagram = object(TColorToolbar)
		{$IFNDEF LITE}
		procedure Work; virtual;
		{$ENDIF}
	end;

	PTHome = ^TTHome;
	TTHome = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTSortAuf = ^TTSortAuf;
	TTSortAuf = object(TColorToolbar)
		procedure Work; virtual;
	end;

	PTSortAb = ^TTSortAb;
	TTSortAb = object(TColorToolbar)
		procedure Work; virtual;
	end;




implementation

uses

	Gem,
	OTypes,OProcs,
	txrsc,txtypes,txchart,txmain;



constructor TColorToolbar.Init(AParent: PWindow; AnIndx,AColIndx: integer; Switch: boolean; Hlp: string);
	var pt: PTree;

	begin
		if not(inherited Init(AParent,RTWTOOLBAR,AnIndx,id_No,id_No,nil,false,Switch,Hlp)) then fail;
		used:=false;
		if Application^.HasColorIcons and (AColIndx>=0) and
		   (Application^.Attr.Colors>=15) and TexelApp.UseNewToolbar then
			begin
				TexelApp.ActivateExtResource;
				pt:=Application^.GetAddr(RTWCOLORTB);
				if pt<>nil then
					begin
						oldobtype:=ObjAddr^.ob_type;
						oldobspec:=ObjAddr^.ob_spec.index;
						ObjAddr^.ob_type:=(oldobtype and $ff00) or G_CICON;
						ObjAddr^.ob_spec.index:=pt^[AColIndx].ob_spec.index;
						used:=true
					end;
				TexelApp.DeactivateExtResource
			end
	end;


destructor TColorToolbar.Done;

	begin
		if used then
			begin
				ObjAddr^.ob_type:=oldobtype;
				ObjAddr^.ob_spec.index:=oldobspec
			end;
		inherited Done
	end;


procedure TTCut.Work;

	begin
		PCalcWindow(Parent)^.Cut
	end;


procedure TTCopy.Work;

	begin
		PCalcWindow(Parent)^.Copy
	end;


procedure TTPaste.Work;

	begin
		PCalcWindow(Parent)^.Paste
	end;


procedure TTFunction.Work;

	begin
		with PCalcWindow(Parent)^ do if insfunc<>nil then insfunc^.Work
	end;


procedure TTSumme.Work;
	var txt,blk: string;
	    ne,
	    r,rvon : integer;
	    loffs  : longint;
	    cell   : PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				if inpline=nil then exit;
				with Parms.Cursor do
					if Block then blk:=StrPTrimF(dblock^.GetText)
					else
						begin
							blk:='';
							if Parms.Cursor.Row>0 then
								begin
									r:=Parms.Cursor.Row;
									repeat
										dec(r);
										if r>=0 then cell:=GetCell(r,Parms.Cursor.Col)
									until (cell^.Typ=CTYPE_TEXT) or (cell^.Typ=CTYPE_EMPTY) or (r<0);
									if r<Parms.Cursor.Row-1 then blk:=GetColumnIndex(Parms.Cursor.Col)+GetRowIndex(r+1)+':'+GetColumnIndex(Parms.Cursor.Col)+GetRowIndex(Parms.Cursor.Row-1)
								end
						end;
				if inpstat then
					begin
						txt:=inpline^.GetText;
						if (length(txt)>0) and (StrPTrimF(txt)<>'=') then Application^.Bing
						else
							begin
								inpline^.SetText('='+TexelApp.SumName+'('+blk+')');
								inpline^.SetCursor(length(inpline^.GetText)-1)
							end
					end
				else
					begin
						with Parms.Cursor do if Block then SetCursorPos(Row,Col,true);
						inpline^.SetText('='+TexelApp.SumName+'('+blk+')');
						EnableInpline;
						inpline^.SetCursor(length(inpline^.GetText)-1)
					end
			end
	end;


procedure TTFett.Work;
	var x,y,rs,re,
	    cmin,cmax,
	    cs,ce    : integer;
	    cell     : PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				cmin:=cs;
				cmax:=ce;
				RowsClearOverflow(rs,re,cmin,cmax);
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								with cell^.TxtVal do
									if IsChecked then Effects:=Effects or TF_THICKENED
									else
										Effects:=Effects and not(TF_THICKENED);
								inc(longint(cell),CELLSIZE)
							end
					end;
				RowsCheckOverflow(rs,re,cmin,cmax);
				SetDirty;
				DrawCells(rs,cmin,re,cmax)
			end
	end;


procedure TTKursiv.Work;
	var x,y,rs,re,
	    cmin,cmax,
	    cs,ce    : integer;
	    cell     : PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				cmin:=cs;
				cmax:=ce;
				RowsClearOverflow(rs,re,cmin,cmax);
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								with cell^.TxtVal do
									if IsChecked then Effects:=Effects or TF_SLANTED
									else
										Effects:=Effects and not(TF_SLANTED);
								inc(longint(cell),CELLSIZE)
							end
					end;
				RowsCheckOverflow(rs,re,cmin,cmax);
				SetDirty;
				DrawCells(rs,cmin,re,cmax)
			end
	end;


procedure TTUnter.Work;
	var x,y,rs,re,
	    cmin,cmax,
	    cs,ce    : integer;
	    cell     : PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				cmin:=cs;
				cmax:=ce;
				RowsClearOverflow(rs,re,cmin,cmax);
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								with cell^.TxtVal do
									if IsChecked then Effects:=Effects or TF_UNDERLINED
									else
										Effects:=Effects and not(TF_UNDERLINED);
								inc(longint(cell),CELLSIZE)
							end
					end;
				RowsCheckOverflow(rs,re,cmin,cmax);
				SetDirty;
				DrawCells(rs,cmin,re,cmax)
			end
	end;


procedure TTAlignLeft.Work;
	var x,y,rs,re,
	    cmin,cmax,
	    cs,ce     : integer;
	    cell,cell2: PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				if inpstat then
					begin
						if (paligncenter^.IsChecked) or (palignright^.IsChecked) then palignleft^.Uncheck
						else
							palignleft^.Check;
						Application^.Bing;
						exit
					end;
				if palignleft<>nil then palignleft^.Check;
				if paligncenter<>nil then paligncenter^.Uncheck;
				if palignright<>nil then palignright^.Uncheck;
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd;
							cell2:=nil
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col;
							cell2:=GetCell(rs,cs)
						end;
				cmin:=cs;
				cmax:=ce;
				RowsClearOverflow(rs,re,cmin,cmax);
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								cell^.TxtVal.Align:=(cell^.TxtVal.Align and $f0) or TA_LEFT;
								inc(longint(cell),CELLSIZE)
							end
					end;
				RowsCheckOverflow(rs,re,cmin,cmax);
				SetDirty;
				DrawCells(rs,cmin,re,cmax);
				SetInpline(cell2)
			end
	end;


procedure TTAlignCenter.Work;
	var x,y,rs,re,
	    cmin,cmax,
	    cs,ce     : integer;
	    cell,cell2: PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				if inpstat then
					begin
						if (palignleft^.IsChecked) or (palignright^.IsChecked) then paligncenter^.Uncheck
						else
							paligncenter^.Check;
						Application^.Bing;
						exit
					end;
				if paligncenter<>nil then paligncenter^.Check;
				if palignleft<>nil then palignleft^.Uncheck;
				if palignright<>nil then palignright^.Uncheck;
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd;
							cell2:=nil
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col;
							cell2:=GetCell(rs,cs)
						end;
				cmin:=cs;
				cmax:=ce;
				RowsClearOverflow(rs,re,cmin,cmax);
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								cell^.TxtVal.Align:=(cell^.TxtVal.Align and $f0) or TA_CENTER;
								inc(longint(cell),CELLSIZE)
							end
					end;
				RowsCheckOverflow(rs,re,cmin,cmax);
				SetDirty;
				DrawCells(rs,cmin,re,cmax);
				SetInpline(cell2)
			end
	end;


procedure TTAlignRight.Work;
	var x,y,rs,re,
	    cmin,cmax,
	    cs,ce     : integer;
	    cell,cell2: PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				if inpstat then
					begin
						if (palignleft^.IsChecked) or (paligncenter^.IsChecked) then palignright^.Uncheck
						else
							palignright^.Check;
						Application^.Bing;
						exit
					end;
				if palignright<>nil then palignright^.Check;
				if palignleft<>nil then palignleft^.Uncheck;
				if paligncenter<>nil then paligncenter^.Uncheck;
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd;
							cell2:=nil
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col;
							cell2:=GetCell(rs,cs)
						end;
				cmin:=cs;
				cmax:=ce;
				RowsClearOverflow(rs,re,cmin,cmax);
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								cell^.TxtVal.Align:=(cell^.TxtVal.Align and $f0) or TA_RIGHT;
								inc(longint(cell),CELLSIZE)
							end
					end;
				RowsCheckOverflow(rs,re,cmin,cmax);
				SetDirty;
				DrawCells(rs,cmin,re,cmax);
				SetInpline(cell2)
			end
	end;


procedure TTNumber.Work;
	var cell : PCell;
	    x,y,
	    nform,
	    rs,cs,
	    re,ce: integer;
	    vrnd : boolean;

	begin
		vrnd:=false;
		{$IFDEF ENGLISH}
		nform:=60;
		{$ELSE}
		nform:=TexelApp.FormStart[2];
		{$ENDIF}
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								if cell^.Typ<>CTYPE_TEXT then
									if cell^.Format<>nform then
										begin
											cell^.Format:=nform;
											vrnd:=true
										end;
								inc(longint(cell),CELLSIZE)
							end
					end;
				if vrnd then
					begin
						SetDirty;
						DrawCells(rs,cs,re,ce)
					end
				else
					Application^.Bing
			end
	end;


procedure TTDate.Work;
	var cell : PCell;
	    x,y,
	    nform,
	    rs,cs,
	    re,ce: integer;
	    vrnd : boolean;

	begin
		vrnd:=false;
		{$IFDEF FRENCH}
		nform:=72;
		{$ELSE}
		{$IFDEF ENGLISH}
		nform:=73;
		{$ELSE}
		nform:=TexelApp.FormStart[3];
		{$ENDIF}
		{$ENDIF}
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								if cell^.Typ<>CTYPE_TEXT then
									if cell^.Format<>nform then
										begin
											cell^.Format:=nform;
											vrnd:=true
										end;
								inc(longint(cell),CELLSIZE)
							end
					end;
				if vrnd then
					begin
						SetDirty;
						DrawCells(rs,cs,re,ce)
					end
				else
					Application^.Bing
			end
	end;


procedure TTMoney.Work;
	var cell : PCell;
	    x,y,
	    nform,
	    rs,cs,
	    re,ce: integer;
	    vrnd : boolean;

	begin
		vrnd:=false;
		case TexelApp.setupbuffer.currency of
		1:
			nform:=52;
		2:
			nform:=48;
		3: 
			nform:=68;
		4:
			nform:=64;
		5:
			nform:=75;
		6:
			nform:=79;
		7:
			nform:=83;
		else
			nform:=TexelApp.FormStart[7]
		end;
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								if cell^.Typ<>CTYPE_TEXT then
									if cell^.Format<>nform then
										begin
											cell^.Format:=nform;
											vrnd:=true
										end;
								inc(longint(cell),CELLSIZE)
							end
					end;
				if vrnd then
					begin
						SetDirty;
						DrawCells(rs,cs,re,ce)
					end
				else
					Application^.Bing
			end
	end;


procedure TTPercent.Work;
	var cell : PCell;
	    x,y,
	    nform,
	    rs,cs,
	    re,ce: integer;
	    vrnd : boolean;

	begin
		vrnd:=false;
		nform:=TexelApp.FormStart[5];
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								if cell^.Typ<>CTYPE_TEXT then
									if cell^.Format<>nform then
										begin
											cell^.Format:=nform;
											vrnd:=true
										end;
								inc(longint(cell),CELLSIZE)
							end
					end;
				if vrnd then
					begin
						SetDirty;
						DrawCells(rs,cs,re,ce)
					end
				else
					Application^.Bing
			end
	end;


{$IFNDEF LITE}

procedure TTDiagram.Work;

	begin
		PDiagram(PCalcWindow(Parent)^.diagramm)^.CreateDiagramFromBlock
	end;

{$ENDIF}


procedure TTHome.Work;

	begin
		PCalcWindow(Parent)^.SetCursorPos(0,0,true)
	end;


procedure TTSortAuf.Work;
	var cs,ce,
	    c2,c3,
	    dummy: integer;

	begin
		with PCalcWindow(Parent)^ do
			begin
				GetBlock(dblock^.GetText,false,dummy,cs,dummy,ce,dummy,dummy);
				if ce>cs then c2:=cs+1
				else
					c2:=-1;
				if ce>cs+1 then c3:=cs+2
				else
					c3:=-1;
				Sort(cs,c2,c3,0,true,true,true,false,false,false,true,false,false)
			end
	end;


procedure TTSortAb.Work;
	var cs,ce,
	    c2,c3,
	    dummy: integer;

	begin
		with PCalcWindow(Parent)^ do
			begin
				GetBlock(dblock^.GetText,false,dummy,cs,dummy,ce,dummy,dummy);
				if ce>cs then c2:=cs+1
				else
					c2:=-1;
				if ce>cs+1 then c3:=cs+2
				else
					c3:=-1;
				Sort(cs,c2,c3,0,false,false,false,false,false,false,true,false,false)
			end
	end;


procedure TTDezPlus.Work;
	var cell : PCell;
	    x,y,
	    nnr,
	    rs,cs,
	    re,ce: integer;
	    chg,
	    vrnd : boolean;
	    p    : PCalcWindow;
	    pfm  : PFormat;
	    s,ret: string;

	procedure ChangeFormat(frm: integer);
		var q: integer;

		function DezPlus(t: string): string;
			var q,flg: integer;

			begin
				DezPlus:=t;
				if length(t)=0 then exit;
				flg:=0;
				q:=1;
				while q<=length(t) do
					begin
						if t[q]='{' then flg:=1
						else
							if ((t[q]='}') or (t[q]='E')) and (flg>0) then
								begin
									if flg=2 then
										begin
											if t[q-1]='|' then
												begin
													{$IFDEF ENGLISH}
													t:=StrPLeft(t,q-1)+'.0'+StrPRight(t,length(t)+1-q);
													{$ELSE}
													t:=StrPLeft(t,q-1)+',0'+StrPRight(t,length(t)+1-q);
													{$ENDIF}
													inc(q,2)
												end
											else
												begin
													t:=StrPLeft(t,q-1)+'0'+StrPRight(t,length(t)+1-q);
													inc(q)
												end
										end
									else
										begin
											{$IFDEF ENGLISH}
											t:=StrPLeft(t,q-1)+'|.0'+StrPRight(t,length(t)+1-q);
											{$ELSE}
											t:=StrPLeft(t,q-1)+'|,0'+StrPRight(t,length(t)+1-q);
											{$ENDIF}
											inc(q,3)
										end;
									DezPlus:=t;
									chg:=true;
									flg:=0
								end
							else
								if t[q]='|' then
									if flg=1 then flg:=2;
						inc(q)
					end
			end;

		begin
			if frm<=0 then exit;
			if frm>=1000 then pfm:=PFormat(p^.UsrFormats^.At(frm-1000))
			else
				pfm:=PFormat(TexelApp.Formats^.At(frm));
			s:=pfm^.Name^;
			ret:='';
			chg:=false;
			q:=pos(';',s);
			while q>0 do
				begin
					ret:=ret+DezPlus(StrPLeft(s,q-1))+';';
					s:=StrPRight(s,length(s)-q);
					q:=pos(';',s);
				end;
			ret:=ret+DezPlus(s);
			if chg then
				begin
					nnr:=0;
					if p^.UsrFormats^.Count>0 then
						for q:=0 to p^.UsrFormats^.Count-1 do
							if PFormat(p^.UsrFormats^.At(q))^.Name^=ret then
								begin
									nnr:=PFormat(p^.UsrFormats^.At(q))^.Index;
									break
								end;
					if nnr=0 then
						if TexelApp.Formats^.Count>0 then
							for q:=0 to TexelApp.Formats^.Count-1 do
								if PFormat(TexelApp.Formats^.At(q))^.Name^=ret then
									begin
										nnr:=PFormat(TexelApp.Formats^.At(q))^.Index;
										break
									end;
					if nnr=0 then nnr:=p^.NewNumFormat(ret);
					cell^.Format:=nnr;
					vrnd:=true
				end
		end;

	begin
		p:=PCalcWindow(Parent);
		vrnd:=false;
		with p^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								if cell^.Typ=CTYPE_FORMULA then
									with cell^.Data.Formula^ do
										begin
											if FPts<MAXCIPHERS then
												begin
													inc(Fpts);
													vrnd:=true
												end
										end
								else
									if cell^.Typ=CTYPE_CONST then
										with cell^.Data.Konst^ do
											if FPts<MAXCIPHERS then
												begin
													inc(Fpts);
													vrnd:=true
												end;
								ChangeFormat(cell^.Format);
								inc(longint(cell),CELLSIZE)
							end
					end;
				if vrnd then
					begin
						SetDirty;
						DrawCells(rs,cs,re,ce)
					end
				else
					Application^.Bing
			end
	end;


procedure TTDezMinus.Work;
	var cell : PCell;
	    x,y,
	    nnr,
	    rs,cs,
	    re,ce: integer;
	    vrnd,
	    eflg,
	    chg  : boolean;
	    s,ret: string;
	    pfm  : PFormat;
	    p    : PCalcWindow;

	procedure ChangeFormat(frm: integer);
		var q: integer;

		function DezMinus(t: string): string;
			var q,w,flg,nk,nk1: integer;

			begin
				DezMinus:=t;
				if length(t)=0 then exit;
				flg:=0;
				q:=1;
				while q<=length(t) do
					begin
						if t[q]='{' then flg:=1
						else
							if t[q]='}' then flg:=0
							else
								if t[q]='|' then
									if flg=1 then
										begin
											w:=q+1;
											nk:=0;
											nk1:=0;
											eflg:=false;
											while w<=length(t) do
												begin
													if t[w]='0' then
														begin
															nk:=w;
															if nk1=0 then nk1:=nk
														end
													else
														if (t[w]='}') then break
														else
															if t[w]='E' then
																begin
																	eflg:=true;
																	break
																end;
													inc(w)
												end;
											if nk>0 then
												begin
													if nk1=nk then
														begin
															if eflg then t:=StrPLeft(t,q)+StrPRight(t,length(t)-nk)
															else
																begin
																	t:=StrPLeft(t,q-1)+StrPRight(t,length(t)-nk);
																	dec(q)
																end
														end
													else
														t:=StrPLeft(t,nk-1)+StrPRight(t,length(t)-nk);
													DezMinus:=t;
													chg:=true
												end
										end;
						inc(q)
					end
			end;

		begin
			if frm<=0 then exit;
			if frm>=1000 then pfm:=PFormat(p^.UsrFormats^.At(frm-1000))
			else
				pfm:=PFormat(TexelApp.Formats^.At(frm));
			s:=pfm^.Name^;
			ret:='';
			chg:=false;
			q:=pos(';',s);
			while q>0 do
				begin
					ret:=ret+DezMinus(StrPLeft(s,q-1))+';';
					s:=StrPRight(s,length(s)-q);
					q:=pos(';',s);
				end;
			ret:=ret+DezMinus(s);
			if chg then
				begin
					nnr:=0;
					if p^.UsrFormats^.Count>0 then
						for q:=0 to p^.UsrFormats^.Count-1 do
							if PFormat(p^.UsrFormats^.At(q))^.Name^=ret then
								begin
									nnr:=PFormat(p^.UsrFormats^.At(q))^.Index;
									break
								end;
					if nnr=0 then
						if TexelApp.Formats^.Count>0 then
							for q:=0 to TexelApp.Formats^.Count-1 do
								if PFormat(TexelApp.Formats^.At(q))^.Name^=ret then
									begin
										nnr:=PFormat(TexelApp.Formats^.At(q))^.Index;
										break
									end;
					if nnr=0 then nnr:=p^.NewNumFormat(ret);
					cell^.Format:=nnr;
					vrnd:=true
				end
		end;

	begin
		vrnd:=false;
		p:=PCalcWindow(Parent);
		with p^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							rs:=RowStart;
							re:=RowEnd;
							cs:=ColStart;
							ce:=ColEnd
						end
					else
						begin
							rs:=Row;
							re:=Row;
							cs:=Col;
							ce:=Col
						end;
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								if cell^.Typ=CTYPE_FORMULA then
									with cell^.Data.Formula^ do
										begin
											if FPts>0 then
												begin
													dec(Fpts);
													vrnd:=true
												end
										end
								else
									if cell^.Typ=CTYPE_CONST then
										with cell^.Data.Konst^ do
											if FPts>0 then
												begin
													dec(Fpts);
													vrnd:=true
												end;
								ChangeFormat(cell^.Format);
								inc(longint(cell),CELLSIZE)
							end
					end;
				if vrnd then
					begin
						SetDirty;
						DrawCells(rs,cs,re,ce)
					end
				else
					Application^.Bing
			end
	end;

end.