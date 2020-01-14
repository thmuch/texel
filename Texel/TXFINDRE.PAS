unit txfindre;
{ 1999-03-04 }

interface

uses

	OWindows,ODialogs;


type

	PGoto = ^TGoto;
	TGoto = object(TMenu)
		procedure Work; virtual;
	end;

	PFind = ^TFind;
	TFind = object(TKeyMenu)
		rb1,
		rb2: PRadioButton;
		procedure Work; virtual;
		procedure FindNext;
	end;

	PFindNext = ^TFindNext;
	TFindNext = object(TKeyMenu)
		procedure Work; virtual;
	end;

	PReplace = ^TReplace;
	TReplace = object(TKeyMenu)
		rb1,
		rb2: PRadioButton;
		procedure Work; virtual;
		procedure ReplaceNext(all: boolean);
	end;

	PReplaceNext = ^TReplaceNext;
	TReplaceNext = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	OTypes,OProcs,
	txrsc,txlang,txtypes,txmain;


type

	PFindDialog = ^TFindDialog;
	TFindDialog = object(THyperDialog)
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
	end;

	PReplaceDialog = ^TReplaceDialog;
	TReplaceDialog = object(THyperDialog)
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
	end;



procedure TFindNext.Work;

	begin
		with PCalcWindow(Parent)^ do
			if find<>nil then PFind(find)^.FindNext
	end;


procedure TFind.Work;
	var pb: PButton;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PFindDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_FIND,STG_FIND,ICNTITLE_FIND,RTFIND));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTFIDIRECTION,GROUP_FIND_DIRECTION,''));
						new(PGroupBox,Init(ADialog,RTFIOPTIONS,'',''));
						new(PGroupBox,Init(ADialog,RTFIWHAT,GROUP_FIND_SEARCHIN,''));
						new(PGroupBox,Init(ADialog,RTFIINTERPRETE,GROUP_FIND_SEARCHAS,''));
						new(PGroupBox,Init(ADialog,RTFIDIR,GROUP_FIND_FORBACKWARD,''));
						new(PEdit,Init(ADialog,RTFISEARCHEDIT,46,BUBBLE_FIND_SEARCHFOR));
						new(PRadioButton,Init(ADialog,RTFIROWS,true,BUBBLE_FIND_ROWS));
						new(PRadioButton,Init(ADialog,RTFICOLUMNS,true,BUBBLE_FIND_COLUMNS));
						new(PCheckBox,Init(ADialog,RTFICASE,true,BUBBLE_FIND_CASE));
						new(PCheckBox,Init(ADialog,RTFICOMPLETE,true,BUBBLE_FIND_COMPLETE));
						new(PCheckBox,Init(ADialog,RTFIFORMULA,true,BUBBLE_FIND_FORMULA));
						new(PCheckBox,Init(ADialog,RTFIVALUE,true,BUBBLE_FIND_VALUE));
						new(PCheckBox,Init(ADialog,RTFITEXT,true,BUBBLE_FIND_TEXT));
						new(PRadioButton,Init(ADialog,RTFIINTRFORM,true,BUBBLE_FIND_EDIT));
						new(PRadioButton,Init(ADialog,RTFIINTRVAL,true,BUBBLE_FIND_DISPLAY));
						new(rb1,Init(ADialog,RTFIVOR,true,BUBBLE_FIND_TOEND));
						new(rb2,Init(ADialog,RTFIZURUECK,true,BUBBLE_FIND_TOBEGIN));
						new(pb,Init(ADialog,RTFIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTFICANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTFISEARCH,id_No,true,BUBBLE_FIND_FIND));
						new(PButton,Init(ADialog,RTFIOK,id_OK,true,BUBBLE_FIND_OK));
						ADialog^.TransferBuffer:=@PCalcWindow(Parent)^.findbuf
					end
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;


procedure TFind.FindNext;
	label _raus;

	var p    : PCalcWindow;
	    dir,
	    x,y,
	    r,c  : integer;
	    cell : PCell;
	    offs : longint;
	    s,cmp: string;

	function checkcell: boolean;

		function checks: boolean;

			begin
				checks:=false;
				if length(s)=0 then exit;
				if p^.findbuf.cse=bf_Unchecked then s:=StrPUpper(s);
				if p^.findbuf.complete=bf_Checked then checks:=(s=cmp)
				else
					checks:=(pos(cmp,s)>0)
			end;

		begin
			checkcell:=false;
			if cell^.Data.Value=0 then exit;
			case cell^.Typ of
			CTYPE_TEXT:
				if p^.findbuf.txt=bf_Checked then
					begin
						s:=cell^.Data.Txt^;
						checkcell:=checks
					end;
			CTYPE_CONST:
				if p^.findbuf.value=bf_Checked then
					begin
						if p^.findbuf.iform=bf_Checked then
							begin
								if cell^.Data.Konst^.Txt=nil then s:=''
								else
									s:=cell^.Data.Konst^.Txt^
							end
						else
							with cell^.Data.Konst^ do p^.Val2Txt(Value,s,FPts,cell^.Format,nil);
						checkcell:=checks
					end;
			CTYPE_FORMULA:
				if p^.findbuf.formula=bf_Checked then
					begin
						if p^.findbuf.iform=bf_Checked then s:=p^.BuildFunction(cell,true)
						else
							with cell^.Data.Formula^ do
								if Error=FE_OK then p^.Val2Txt(Value,s,FPts,cell^.Format,nil)
								else
									s:=p^.Error2Txt(Error);
						checkcell:=checks
					end
			end
		end;

	begin
		p:=PCalcWindow(Parent);
		if ADialog<>nil then
			if ADialog^.Attr.Status=ws_Open then ADialog^.TransferData(tf_GetData);
		with p^.findbuf do
			begin
				if (length(search)=0) or ((formula=bf_Unchecked) and (value=bf_Unchecked) and (txt=bf_Unchecked)) then
					begin
						Application^.Bing;
						exit
					end;
				cmp:=search;
				if cse=bf_Unchecked then cmp:=StrPUpper(cmp)
			end;
		r:=-1;
		c:=-1;
		y:=p^.Parms.Cursor.Row;
		x:=p^.Parms.Cursor.Col;
		if (y=0) and (x=0) then
			begin
				if (p^.findbuf.vor=bf_Unchecked) then
					begin
						p^.findbuf.vor:=bf_Checked;
						p^.findbuf.zurueck:=bf_Unchecked;
						if rb1<>nil then rb1^.Check;
						if rb2<>nil then rb2^.Uncheck;
					end;
			end
		else if (y=p^.Parms.Rows) and (x=p^.Parms.Columns) then
			begin
				if (p^.findbuf.zurueck=bf_Unchecked) then
					begin
						p^.findbuf.vor:=bf_Unchecked;
						p^.findbuf.zurueck:=bf_Checked;
						if rb1<>nil then rb1^.Uncheck;
						if rb2<>nil then rb2^.Check;
					end;
			end;
		cell:=p^.GetCell(y,x);
		if p^.findbuf.rows=bf_Checked then offs:=CELLSIZE
		else
			offs:=CELLSIZE*longint(p^.Parms.Columns+1);
		if p^.findbuf.vor=bf_Unchecked then
			begin
				offs:=-offs;
				dir:=-1
			end
		else
			dir:=1;
		if p^.findbuf.rows=bf_Checked then
			repeat
				inc(x,dir);
				if x<0 then
					begin
						if y=0 then goto _raus
						else
							begin
								dec(y);
								x:=p^.Parms.Columns;
								cell:=p^.GetCell(y,x)
							end
					end
				else
					if x>p^.Parms.Columns then
						begin
							if y=p^.Parms.Rows then goto _raus
							else
								begin
									inc(y);
									x:=0;
									cell:=p^.GetCell(y,x)
								end
						end
					else
						inc(longint(cell),offs);
				if checkcell then
					begin
						r:=y;
						c:=x;
						goto _raus
					end
			until false
		else
			repeat
				inc(y,dir);
				if y<0 then
					begin
						if x=0 then goto _raus
						else
							begin
								dec(x);
								y:=p^.Parms.Rows;
								cell:=p^.GetCell(y,x)
							end
					end
				else
					if y>p^.Parms.Rows then
						begin
							if x=p^.Parms.Columns then goto _raus
							else
								begin
									inc(x);
									y:=0;
									cell:=p^.GetCell(y,x)
								end
						end
					else
						inc(longint(cell),offs);
				if checkcell then
					begin
						r:=y;
						c:=x;
						goto _raus;
					end;
			until false;
		_raus:
		if (r>=0) and (c>=0) then p^.SetCursorPos(r,c,true)
		else
			begin
				Application^.Bing;
				with p^.findbuf do
					if vor=bf_Checked then
						begin
							vor:=bf_Unchecked;
							zurueck:=bf_Checked;
							if rb1<>nil then rb1^.Uncheck;
							if rb2<>nil then rb2^.Check;
						end
					else
						begin
							vor:=bf_Checked;
							zurueck:=bf_Unchecked;
							if rb1<>nil then rb1^.Check;
							if rb2<>nil then rb2^.Uncheck;
						end;
			end;
	end;


function TFindDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=RTFISEARCH then
			with PCalcWindow(Parent)^ do
				if find<>nil then PFind(find)^.FindNext
	end;


function TFindDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTFISEARCH);
		OK:=valid
	end;


procedure TReplaceNext.Work;

	begin
		with PCalcWindow(Parent)^ do
			if replace<>nil then PReplace(replace)^.ReplaceNext(false)
	end;


procedure TReplace.Work;
	var pb: PButton;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PReplaceDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_REPLACE,STG_REPLACE,ICNTITLE_REPLACE,RTREPLACE));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTREDIRECTION,GROUP_REPLACE_DIRECTION,''));
						new(PGroupBox,Init(ADialog,RTREOPTIONS,'',''));
						new(PGroupBox,Init(ADialog,RTREWHAT,GROUP_REPLACE_REPLIN,''));
						new(PGroupBox,Init(ADialog,RTREDIR,GROUP_REPLACE_FORBACK,''));
						new(PEdit,Init(ADialog,RTRESEARCH,46,BUBBLE_REPL_SEARCHFOR));
						new(PEdit,Init(ADialog,RTREREPLACEWITH,46,BUBBLE_REPL_REPLWITH));
						new(PRadioButton,Init(ADialog,RTREROWS,true,BUBBLE_REPL_ROWS));
						new(PRadioButton,Init(ADialog,RTRECOLUMNS,true,BUBBLE_REPL_COLUMNS));
						new(PCheckBox,Init(ADialog,RTRECASE,true,BUBBLE_REPL_CASE));
						new(PCheckBox,Init(ADialog,RTRECOMPLETE,true,BUBBLE_REPL_COMPLETE));
						new(PCheckBox,Init(ADialog,RTREFORMULA,true,BUBBLE_REPL_FORMULA));
						new(PCheckBox,Init(ADialog,RTREVALUE,true,BUBBLE_REPL_VALUE));
						new(PCheckBox,Init(ADialog,RTRETEXT,true,BUBBLE_REPL_TEXT));
						new(rb1,Init(ADialog,RTREVOR,true,BUBBLE_REPL_TOEND));
						new(rb2,Init(ADialog,RTREZURUECK,true,BUBBLE_REPL_TOBEGIN));
						new(pb,Init(ADialog,RTREHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTRECANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTREALL,id_No,true,BUBBLE_REPL_ALL));
						new(PButton,Init(ADialog,RTREREPLACE,id_No,true,BUBBLE_REPL_REPLACE));
						new(PButton,Init(ADialog,RTREOK,id_OK,true,BUBBLE_REPL_OK));
						ADialog^.TransferBuffer:=@PCalcWindow(Parent)^.replacebuf
					end
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;


procedure TReplace.ReplaceNext(all: boolean);
	label _raus;

	var p    : PCalcWindow;
	    dir,q,
	    x,y,
	    r,c  : integer;
	    cell : PCell;
	    offs : longint;
	    t,
	    s,cmp: string;

	function checkcell: boolean;

		function checks: boolean;

			begin
				checks:=false;
				if length(s)=0 then exit;
				if p^.replacebuf.cse=bf_Unchecked then t:=StrPUpper(s)
				else
					t:=s;
				if p^.replacebuf.complete=bf_Checked then
					begin
						q:=1;
						checks:=(t=cmp)
					end
				else
					begin
						q:=pos(cmp,t);
						checks:=(q>0)
					end
			end;

		begin
			checkcell:=false;
			if cell^.Data.Value=0 then exit;
			case cell^.Typ of
			CTYPE_TEXT:
				if p^.replacebuf.txt=bf_Checked then
					begin
						s:=cell^.Data.Txt^;
						if not(checks) then exit
					end
				else
					exit;
			CTYPE_CONST:
				if p^.replacebuf.value=bf_Checked then
					begin
						if cell^.Data.Konst^.Txt=nil then s:=''
						else
							s:=cell^.Data.Konst^.Txt^;
						if not(checks) then exit
					end
				else
					exit;
			CTYPE_FORMULA:
				if p^.replacebuf.formula=bf_Checked then
					begin
						s:=p^.BuildFunction(cell,true);
						if not(checks) then exit
					end
				else
					exit;
			else
				exit
			end;
			checkcell:=true;
			s:=StrPLeft(s,q-1)+p^.replacebuf.replace+StrPRight(s,length(s)+1-q-length(cmp));
			p^.ChangeCell(cell,s,y,x,false);
			p^.SetInpline(cell)
		end;

	begin
		p:=PCalcWindow(Parent);
		if ADialog<>nil then
			if ADialog^.Attr.Status=ws_Open then ADialog^.TransferData(tf_GetData);
		with p^.replacebuf do
			begin
				if (length(search)=0) or ((formula=bf_Unchecked) and (value=bf_Unchecked) and (txt=bf_Unchecked)) then
					begin
						Application^.Bing;
						exit
					end;
				cmp:=search;
				if cse=bf_Unchecked then cmp:=StrPUpper(cmp)
			end;
		r:=-1;
		c:=-1;
		y:=p^.Parms.Cursor.Row;
		x:=p^.Parms.Cursor.Col;
		cell:=p^.GetCell(y,x);
		if p^.replacebuf.rows=bf_Checked then offs:=CELLSIZE
		else
			offs:=CELLSIZE*longint(p^.Parms.Columns+1);
		if p^.replacebuf.vor=bf_Unchecked then
			begin
				offs:=-offs;
				dir:=-1
			end
		else
			dir:=1;
		if p^.replacebuf.rows=bf_Checked then
			repeat
				inc(x,dir);
				if x<0 then
					begin
						if y=0 then goto _raus
						else
							begin
								dec(y);
								x:=p^.Parms.Columns;
								cell:=p^.GetCell(y,x)
							end
					end
				else
					if x>p^.Parms.Columns then
						begin
							if y=p^.Parms.Rows then goto _raus
							else
								begin
									inc(y);
									x:=0;
									cell:=p^.GetCell(y,x)
								end
						end
					else
						inc(longint(cell),offs);
				if checkcell then
					begin
						r:=y;
						c:=x;
						if not(all) then goto _raus
					end
			until false
		else
			repeat
				inc(y,dir);
				if y<0 then
					begin
						if x=0 then goto _raus
						else
							begin
								dec(x);
								y:=p^.Parms.Rows;
								cell:=p^.GetCell(y,x)
							end
					end
				else
					if y>p^.Parms.Rows then
						begin
							if x=p^.Parms.Columns then goto _raus
							else
								begin
									inc(x);
									y:=0;
									cell:=p^.GetCell(y,x)
								end
						end
					else
						inc(longint(cell),offs);
				if checkcell then
					begin
						r:=y;
						c:=x;
						if not(all) then goto _raus
					end
			until false;
		_raus:
		if (r>=0) and (c>=0) then p^.SetCursorPos(r,c,true)
		else
			begin
				Application^.Bing;
				with p^.replacebuf do
					if vor=bf_Checked then
						begin
							vor:=bf_Unchecked;
							zurueck:=bf_Checked;
							if rb1<>nil then rb1^.Uncheck;
							if rb2<>nil then rb2^.Check
						end
					else
						begin
							vor:=bf_Checked;
							zurueck:=bf_Unchecked;
							if rb1<>nil then rb1^.Check;
							if rb2<>nil then rb2^.Uncheck
						end
			end
	end;


function TReplaceDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		case AnIndx of
		RTREREPLACE:
			with PCalcWindow(Parent)^ do
				if replace<>nil then PReplace(replace)^.ReplaceNext(false);
		RTREALL:
			begin
				with PCalcWindow(Parent)^ do
					if replace<>nil then PReplace(replace)^.ReplaceNext(true);
				ExitDlg:=true
			end
		end
	end;


function TReplaceDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTREREPLACE);
		OK:=valid
	end;


procedure TGoto.Work;

	begin
		PCalcWindow(Parent)^.ExitDlg(RTWDBLOCK)
	end;

end.