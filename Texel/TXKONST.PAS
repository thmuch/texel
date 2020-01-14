unit txkonst;
{ 1998-07-06 }

interface

uses

	OWindows;


type

	PKonst = ^TKonst;
	TKonst = object(TKeyMenu)
		kbuf: record
			chng,
			list: integer;
			name,
			value: string[31];
			rem  : string[41]
		end;
		procedure Work; virtual;
		procedure UpdateList(wrk: boolean);
	end;




implementation

{$IFNDEF LITE}

uses

	OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txmain;


type

	PKonstBox = ^TKonstBox;
	TKonstBox = object(TListBox)
		procedure Work; virtual;
	end;

	PKonstDialog = ^TKonstDialog;
	TKonstDialog = object(THyperDialog)
		cb : PCheckBox;
		pkb: PKonstBox;
		pb1,
		pb2: PButton;
		ed1,
		ed2,
		ed3: PEdit;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure UpdateList(wrk: boolean);
	end;



procedure TKonstBox.Work;
	var sel: integer;
	    p  : PKonstDialog;
	    pp : PParameter;

	begin
		if List=nil then exit;
		if List^.Count=0 then exit;
		p:=PKonstDialog(Parent);
		sel:=GetSelection;
		if sel<0 then exit;
		pp:=PParameter(List^.At(sel));
		if pp^.Name=nil then p^.ed1^.Clear
		else
			p^.ed1^.SetText(pp^.Name^);
		if pp^.Txt=nil then p^.ed2^.Clear
		else
			p^.ed2^.SetText(pp^.Txt^);
		if pp^.Descr=nil then p^.ed3^.Clear
		else
			p^.ed3^.SetText(pp^.Descr^);
		if pp^.Predef then
			begin
				p^.pb1^.Disable;
				p^.pb2^.Disable;
				p^.cb^.Disable
			end
		else
			begin
				p^.pb1^.Enable;
				p^.pb2^.Enable;
				p^.cb^.Enable
			end
	end;


procedure TKonstDialog.UpdateList(wrk: boolean);

	begin
		if Attr.Status<>ws_Open then exit;
		pkb^.SetCollection(PCalcWindow(Parent)^.Parameter);
		if wrk then
			begin
				pkb^.SetSelection(pkb^.List^.Count);
				pkb^.ScrollBar^.SetPosition(pkb^.List^.Count)
			end;
		pkb^.Work
	end;


function TKonstDialog.ExitDlg(AnIndx: integer): boolean;
	var nval,
	    oname,
	    nname: string;
	    sel,
	    q    : integer;
	    pp   : PParameter;
	    p    : PCalcWindow;
	    vnum : TNumber;

	procedure changeconst;
		var r,c : integer;
		    cell: PCell;

		procedure change(p: PNode);
			var q: integer;

			begin
				if p=nil then exit;
				if p^.Typ<5000 then
					begin
						if p^.Typ>=10 then
							begin
								change(p^.Right.Node);
								change(p^.Left.Node)
							end
						else
							if p^.Typ=NT_CONST then
								if p^.Left.Txt<>nil then
									if StrPUpper(p^.Left.Txt^)=oname then
										begin
											DisposeStr(p^.Left.Txt);
											p^.Left.Txt:=NewStr(nname);
											p^.Num^:=vnum
										end
					end
				else
					if p^.Left.List<>nil then
						for q:=0 to p^.Count-1 do change(PNode(p^.Left.List^[q]))
			end;

		begin
			cell:=p^.Sheet;
			for r:=0 to p^.Parms.Rows do
				for c:=0 to p^.Parms.Columns do
					begin
						if cell^.Typ=CTYPE_FORMULA then change(cell^.Data.Formula^.Func);
						inc(longint(cell),CELLSIZE)
					end
		end;

	procedure const2zero;
		var r,c : integer;
		    cell: PCell;

		procedure zero(p: PNode);
			var q: integer;

			begin
				if p=nil then exit;
				if p^.Typ<5000 then
					begin
						if p^.Typ>=10 then
							begin
								zero(p^.Right.Node);
								zero(p^.Left.Node)
							end
						else
							if p^.Typ=NT_CONST then
								if p^.Left.Txt<>nil then
									if StrPUpper(p^.Left.Txt^)=oname then p^.Num^:=0.0
					end
				else
					if p^.Left.List<>nil then
						for q:=0 to p^.Count-1 do zero(PNode(p^.Left.List^[q]))
			end;

		begin
			cell:=p^.Sheet;
			for r:=0 to p^.Parms.Rows do
				for c:=0 to p^.Parms.Columns do
					begin
						if cell^.Typ=CTYPE_FORMULA then zero(cell^.Data.Formula^.Func);
						inc(longint(cell),CELLSIZE)
					end
		end;

	function checkinp(nr: integer): boolean;
		var q: integer;

		function zahl(s: string): boolean;
			label _ok,_again;

			var q,stat,old: integer;

			begin
				zahl:=false;
				if s[1] in ['+','-'] then s:=StrPRight(s,length(s)-1);
				if (s[1] in [DEZTRENNPUNKT,DEZTRENNKOMMA]) then
					begin
						stat:=1;
						q:=2
					end
				else
					begin
						stat:=0;
						q:=1
					end;
				_again:
				if stat=2 then
					if s[q] in ['-','+'] then inc(q);
				old:=q;
				while (q<=length(s)) and (s[q] in ['0'..'9']) do inc(q);
				if old=q then exit;
				if q>length(s) then goto _ok;
				if stat=0 then
					begin
						if (s[q] in [DEZTRENNPUNKT,DEZTRENNKOMMA]) then
							begin
								inc(q);
								stat:=1;
								goto _again
							end
						else
							if s[q]='E' then
								begin
									inc(q);
									stat:=2;
									goto _again
								end
					end
				else
					if stat=1 then
						if s[q]='E' then
							begin
								inc(q);
								stat:=2;
								goto _again
							end;
				_ok:
				if q>length(s) then zahl:=true
			end;

		begin
			checkinp:=false;
			if length(nname)=0 then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_CONST_EMPTY,BUTTON_OK);
					exit
				end;
			if nname[1] in ['0'..'9'] then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_CONST_NAME,BUTTON_OK);
					exit
				end;
			for q:=1 to length(nname) do if not(nname[q] in VarNameSet) then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_CONST_NAME,BUTTON_OK);
					exit
				end;
			if pkb^.List^.Count>0 then
				for q:=0 to pkb^.List^.Count-1 do
					if q<>nr then
						if StrPUpper(nname)=StrPUpper(PParameter(pkb^.List^.At(q))^.Name^) then
							begin
								Application^.Alert(@self,1,NOTE,MESSAGE_CONST_USED1+StrPUpper(nname)+MESSAGE_CONST_USED2,BUTTON_OK);
								exit
							end;
			if length(nval)=0 then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_CONST_VALEMPTY,BUTTON_OK);
					exit
				end;
			if not(zahl(nval)) then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_CONST_VALUE,BUTTON_OK);
					exit
				end;
			checkinp:=true
		end;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		nname:=StrPTrimF(ed1^.GetText);
		nval:=StrPTrimF(ed2^.GetText);
		sel:=pkb^.GetSelection;
		case AnIndx of
		RTCNEU:
			begin
				if not(checkinp(-1)) then exit;
				new(pp);
				if pp<>nil then
					begin
						pp^.Value:=atof(nval);
						pp^.Name:=NewStr(nname);
						pp^.ListName:=NewStr('  '+nname+' '#0);
						pp^.Txt:=NewStr(nval);
						pp^.Descr:=NewStr(StrPTrimF(ed3^.GetText));
						pp^.Predef:=false;
						if (pp^.Name=nil) or (pp^.Txt=nil) then
							begin
								DisposeStr(pp^.Name);
								DisposeStr(pp^.ListName);
								DisposeStr(pp^.Txt);
								DisposeStr(pp^.Descr);
								dispose(pp)
							end
						else
							begin
								p^.Parameter^.Insert(pp);
								UpdateList(true);
								p^.SetDirty
							end
					end
			end;
		RTCCHANGE:
			begin
				if not(checkinp(sel)) then exit;
				pp:=PParameter(pkb^.List^.At(sel));
				oname:=StrPUpper(pp^.Name^);
				DisposeStr(pp^.Name);
				DisposeStr(pp^.ListName);
				DisposeStr(pp^.Txt);
				DisposeStr(pp^.Descr);
				vnum:=atof(nval);
				pp^.Value:=vnum;
				pp^.Name:=NewStr(nname);
				pp^.ListName:=NewStr('  '+nname+' '#0);
				pp^.Txt:=NewStr(nval);
				pp^.Descr:=NewStr(StrPTrimF(ed3^.GetText));
				if cb^.GetCheck=bf_Checked then changeconst
				else
					const2zero;
				q:=pkb^.GetSelection;
				UpdateList(false);
				pkb^.SetSelection(q);
				p^.SetDirty;
				p^.AutoCalculate(true)
			end;
		RTCDELETE:
			begin
				oname:=StrPUpper(PParameter(pkb^.List^.At(sel))^.Name^);
				if Application^.Alert(@self,1,WAIT,MESSAGE_CONST_DELETE1+oname+MESSAGE_CONST_DELETE2,BUTTON_YESNO)=1 then
					begin
						pkb^.List^.AtFree(sel);
						UpdateList(false);
						const2zero;
						p^.SetDirty;
						p^.AutoCalculate(true)
					end
			end
		end
	end;

{$ENDIF}


procedure TKonst.Work;
	var pb: PButton;

	begin
		{$IFNDEF LITE}
		if ADialog=nil then
			begin
				ADialog:=new(PKonstDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_CONST,STG_CONST,ICNTITLE_CONST,RTCONST));
				if ADialog<>nil then
					begin
						new(PKonstDialog(ADialog)^.cb,Init(ADialog,RTCNAMEN,true,BUBBLE_CONST_CHGNAME));
						new(PKonstDialog(ADialog)^.pkb,Init(ADialog,RTCLIST,RTCLISTSLID,RTCLISTDEC,RTCLISTINC,PCalcWindow(Parent)^.Parameter,false,BUBBLE_CONST_LIST));
						new(PKonstDialog(ADialog)^.ed1,Init(ADialog,RTCNAME,31,BUBBLE_CONST_NAME));
						new(PKonstDialog(ADialog)^.ed2,Init(ADialog,RTCVALUE,31,BUBBLE_CONST_VALUE));
						new(PKonstDialog(ADialog)^.ed3,Init(ADialog,RTCREM,41,BUBBLE_CONST_DESCR));
						new(pb,Init(ADialog,RTCHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTCNEU,id_No,true,BUBBLE_CONST_NEW));
						new(PKonstDialog(ADialog)^.pb1,Init(ADialog,RTCCHANGE,id_No,true,BUBBLE_CONST_CHANGE));
						new(PKonstDialog(ADialog)^.pb2,Init(ADialog,RTCDELETE,id_No,true,BUBBLE_CONST_DELETE));
						new(PButton,Init(ADialog,RTCOK,id_OK,true,BUBBLE_GENERAL_OK));
						fillchar(kbuf,sizeof(kbuf),0);
						kbuf.chng:=bf_Checked;
						ADialog^.TransferBuffer:=@kbuf
					end
			end;
		if ADialog<>nil then
			begin
				ADialog^.MakeWindow;
				UpdateList(false)
			end
		{$ENDIF}
	end;


procedure TKonst.UpdateList(wrk: boolean);

	begin
		{$IFNDEF LITE}
		if ADialog<>nil then PKonstDialog(ADialog)^.UpdateList(wrk)
		{$ENDIF}
	end;

end.