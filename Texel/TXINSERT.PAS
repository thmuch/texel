unit txinsert;
{ 1998-07-07 }

interface

uses

	OWindows;

type

	PInsert = ^TInsert;
	TInsert = object(TKeyMenu)
		procedure Work; virtual;
	end;

	PInsertCell = ^TInsertCell;
	TInsertCell = object(TKeyMenu)
		procedure Work; virtual;
	end;

	PInsertRows = ^TInsertRows;
	TInsertRows = object(TKeyMenu)
		procedure Work; virtual;
	end;

	PInsertColumns = ^TInsertColumns;
	TInsertColumns = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Gem,
	OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txmain;


type

	PInsButton = ^TInsButton;
	TInsButton = object(TRadioButton)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;

	PInsertDialog = ^TInsertDialog;
	TInsertDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		rb,
		rb0 : PInsButton;
		rb1,
		rb2,
		rb3,
		rb4,
		rb5 : PRadioButton;
		cb  : PCheckBox;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
		procedure CheckButtons;
		function OK: boolean; virtual;
	end;

	PInsertCellDialog = ^TInsertCellDialog;
	TInsertCellDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		pb  : PButton;
		rb2,
		rb3,
		rb4,
		rb5 : PRadioButton;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
		procedure CheckButtons;
	end;



procedure TInsButton.Changed(AnIndx: integer; DblClick: boolean);

	begin
		PInsertDialog(Parent)^.CheckButtons
	end;


function TInsertDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		case AnIndx of
		RTINBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTININS:
			OK
		end
	end;


procedure TInsertDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk)
	end;


procedure TInsertDialog.CheckButtons;
	var q: integer;

	begin
		if (rb^.GetCheck=bf_Checked) or (rb0^.GetCheck=bf_Checked) then
			begin
				q:=rb1^.GetCheck;
				rb1^.Disable;
				rb1^.SetCheck(q);
				q:=rb2^.GetCheck;
				rb2^.Disable;
				rb2^.SetCheck(q);
				q:=rb3^.GetCheck;
				rb3^.Disable;
				rb3^.SetCheck(q);
				q:=rb4^.GetCheck;
				rb4^.Disable;
				rb4^.SetCheck(q);
				q:=rb5^.GetCheck;
				rb5^.Disable;
				rb5^.SetCheck(q);
				cb^.Disable
			end
		else
			begin
				rb1^.Enable;
				{$IFNDEF LITE}
				rb2^.Enable;
				rb3^.Enable;
				rb4^.Enable;
				rb5^.Enable;
				{$ENDIF}
				cb^.Enable
			end
	end;


function TInsertDialog.OK: boolean;
	var valid: boolean;
	    what,
	    op   : integer;

	begin
		valid:=inherited OK;
		if valid then
			with PCalcWindow(Parent)^ do
				begin
					with tibuffer do
						begin
							if formula=bf_Checked then what:=INS_FORMULA
							else
								if value=bf_Checked then what:=INS_VALUE
								else
									if format=bf_Checked then what:=INS_FORMAT
									else
										if note=bf_Checked then what:=INS_NOTE
										else
											what:=INS_ALL;
							if rb1^.GetState=bf_Disabled then op:=INS_OP_NONE
							else
								if add=bf_Checked then op:=INS_OP_ADD
								else
									if sub=bf_Checked then op:=INS_OP_SUB
									else
										if mul=bf_Checked then op:=INS_OP_MUL
										else
											if divide=bf_Checked then op:=INS_OP_DIV
											else
												op:=INS_OP_NONE
						end;
					InsertFromClipboard(what,op,(tibuffer.empty=bf_Checked) and (cb^.GetState=bf_Enabled),(tibuffer.transpose=bf_Checked),true,false)
				end;
		OK:=valid
	end;


procedure TInsert.Work;
	var p : PCalcWindow;
	    pb: PButton;
	    rb: PInsButton;
	    pc: PCheckBox;

	begin
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				ADialog:=new(PInsertDialog,Init(p,TEXELWINDPREFIX+TITLE_INSVAL,STG_INSVAL,ICNTITLE_INSVAL,RTINSERT));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTINBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
						new(PGroupBox,Init(ADialog,RTINWHAT,GROUP_INSERT_PASTE,''));
						new(PGroupBox,Init(ADialog,RTINOPERATION,GROUP_INSERT_OPERATION,''));
						new(PGroupBox,Init(ADialog,RTINOPTIONS,'',''));
						new(PInsertDialog(ADialog)^.bedt,Init(ADialog,RTINBEDIT,16,false,BUBBLE_GENERAL_RANGE));
						new(PInsButton,Init(ADialog,RTINALL,true,BUBBLE_INSVAL_ALL));
						new(PInsButton,Init(ADialog,RTINFORMULA,true,BUBBLE_INSVAL_FORMULA));
						new(PInsButton,Init(ADialog,RTINVALUE,true,BUBBLE_INSVAL_VALUE));
						new(PInsertDialog(ADialog)^.rb,Init(ADialog,RTINFORMATS,true,BUBBLE_INSVAL_FORMAT));
						new(rb,Init(ADialog,RTINNOTES,true,BUBBLE_INSVAL_NOTE));
						PInsertDialog(ADialog)^.rb0:=rb;
						if rb<>nil then rb^.Disable; { ... }
						new(PInsertDialog(ADialog)^.rb1,Init(ADialog,RTINNONE,true,BUBBLE_INSVAL_OPNONE));
						new(PInsertDialog(ADialog)^.rb2,Init(ADialog,RTINADD,true,BUBBLE_INSVAL_OPADD));
						new(PInsertDialog(ADialog)^.rb3,Init(ADialog,RTINSUB,true,BUBBLE_INSVAL_OPSUB));
						new(PInsertDialog(ADialog)^.rb4,Init(ADialog,RTINMUL,true,BUBBLE_INSVAL_OPMUL));
						new(PInsertDialog(ADialog)^.rb5,Init(ADialog,RTINDIV,true,BUBBLE_INSVAL_OPDIV));
						new(PInsertDialog(ADialog)^.cb,Init(ADialog,RTINEMPTY,true,BUBBLE_INSVAL_EMPTY));
						new(pc,Init(ADialog,RTINTRANSPOSE,true,BUBBLE_INSVAL_TRANSPOSE));
						{$IFDEF LITE}
						if pc<>nil then pc^.Disable;
						with PInsertDialog(ADialog)^ do
							begin
								if rb2<>nil then rb2^.Disable;
								if rb3<>nil then rb3^.Disable;
								if rb4<>nil then rb4^.Disable;
								if rb5<>nil then rb5^.Disable;
							end;
						{$ENDIF}
						new(pb,Init(ADialog,RTINHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTINABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTININS,id_No,true,BUBBLE_INSVAL_INSERT));
						new(PButton,Init(ADialog,RTINOK,id_OK,true,BUBBLE_INSVAL_OK));
						with p^.tibuffer do
							begin
								all:=bf_Checked;
								formula:=bf_Unchecked;
								value:=bf_Unchecked;
								format:=bf_Unchecked;
								note:=bf_Unchecked;
								none:=bf_Checked;
								add:=bf_Unchecked;
								sub:=bf_Unchecked;
								mul:=bf_Unchecked;
								divide:=bf_Unchecked;
								empty:=bf_Checked;
								transpose:=bf_Unchecked
							end;
						ADialog^.TransferBuffer:=@p^.tibuffer
					end
			end;
		if ADialog<>nil then
			begin
				PInsertDialog(ADialog)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
				ADialog^.TransferData(tf_SetData);
				ADialog^.MakeWindow;
				PInsertDialog(ADialog)^.CheckButtons
			end
	end;


function TInsertCellDialog.ExitDlg(AnIndx: integer): boolean;
	var rs,cs,re,ce,
	    rw,cl,dummy: integer;
	    cell       : PCell;
	    p          : PCalcWindow;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTCCBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTCCZEILE:
			with p^ do
				if GetBlock(bedt^.GetText,false,rs,cs,re,ce,dummy,dummy) then
					begin
						if (cs=0) and (ce=Parms.Columns) then exit;
						DrawCursor;
						DeselectAll;
						with Parms.Cursor do
							begin
								Block:=true;
								RowStart:=rs;
								ColStart:=0;
								RowEnd:=re;
								ColEnd:=Parms.Columns
							end;
						SetBlock;
						for rw:=rs to re do
							begin
								cell:=GetCell(rw,0);
								for cl:=0 to Parms.Columns do
									begin
										with cell^ do Flags:=Flags or CELL_SELECTED;
										inc(longint(cell),CELLSIZE)
									end
							end;
						DrawCursor
					end
				else
					Application^.Bing;
		RTCCSPALTE:
			with p^ do
				if GetBlock(bedt^.GetText,false,rs,cs,re,ce,dummy,dummy) then
					begin
						if (rs=0) and (re=Parms.Rows) then exit;
						DrawCursor;
						DeselectAll;
						with Parms.Cursor do
							begin
								Block:=true;
								RowStart:=0;
								ColStart:=cs;
								RowEnd:=Parms.Rows;
								ColEnd:=ce
							end;
						SetBlock;
						for rw:=0 to Parms.Rows do
							begin
								cell:=GetCell(rw,cs);
								for cl:=cs to ce do
									begin
										with cell^ do Flags:=Flags or CELL_SELECTED;
										inc(longint(cell),CELLSIZE)
									end
							end;
						DrawCursor
					end
				else
					Application^.Bing
		end
	end;


procedure TInsertCellDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk);
		CheckButtons
	end;


procedure TInsertCellDialog.CheckButtons;
	var rs,cs,re,
	    ce,dummy: integer;
	    oldcheck: PRadioButton;
	    p       : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if not(p^.GetBlock(bedt^.GetText,false,rs,cs,re,ce,dummy,dummy)) then exit;
		if (rs=0) and (cs=0) and (re=p^.Parms.Rows) and (ce=p^.Parms.Columns) then
			begin
				rb2^.Disable;
				rb2^.Uncheck;
				rb3^.Disable;
				rb3^.Uncheck;
				rb4^.Disable;
				rb4^.Uncheck;
				rb5^.Disable;
				rb5^.Uncheck;
				pb^.Disable
			end
		else
			begin
				oldcheck:=nil;
				if rb2^.GetCheck=bf_Checked then oldcheck:=rb2
				else
					if rb3^.GetCheck=bf_Checked then oldcheck:=rb3
					else
						if rb4^.GetCheck=bf_Checked then oldcheck:=rb4
						else
							if rb5^.GetCheck=bf_Checked then oldcheck:=rb5;
				if cs=0 then
					begin
						rb2^.Disable;
						rb2^.Uncheck
					end
				else
					rb2^.Enable;
				if ce=p^.Parms.Columns then
					begin
						rb3^.Disable;
						rb3^.Uncheck
					end
				else
					rb3^.Enable;
				if rs=0 then
					begin
						rb4^.Disable;
						rb4^.Uncheck
					end
				else
					rb4^.Enable;
				if re=p^.Parms.Rows then
					begin
						rb5^.Disable;
						rb5^.Uncheck
					end
				else
					rb5^.Enable;
				if oldcheck=nil then
					begin
						if rb3^.GetState=bf_Enabled then rb3^.Check
						else
							if rb5^.GetState=bf_Enabled then rb5^.Check
							else
								if rb4^.GetState=bf_Enabled then rb4^.Check
								else
									rb2^.Check
					end
				else
					if oldcheck^.GetCheck<>bf_Checked then
						begin
							if rb3^.GetState=bf_Enabled then rb3^.Check
							else
								if rb5^.GetState=bf_Enabled then rb5^.Check
								else
									if rb4^.GetState=bf_Enabled then rb4^.Check
									else
										rb2^.Check
						end;
				pb^.Enable
			end
	end;


function TInsertCellDialog.OK: boolean;
	var valid: boolean;
	    p    : PCalcWindow;
	    rs,cs,
	    re,ce,
	    dir,
	    dummy: integer;

	begin
		valid:=inherited OK;
		if valid then
			begin
				p:=PCalcWindow(Parent);
				p^.GetBlock(p^.dblock^.GetText,false,rs,cs,re,ce,dummy,dummy);
				if rb2^.GetCheck=bf_Checked then dir:=CRS_LEFT
				else
					if rb3^.GetCheck=bf_Checked then dir:=CRS_RIGHT
					else
						if rb4^.GetCheck=bf_Checked then dir:=CRS_UP
						else
							dir:=CRS_DOWN;
				p^.InsertCells(rs,cs,re,ce,dir)
			end;
		OK:=valid
	end;


procedure TInsertCell.Work;
	var p : PCalcWindow;
	    pb: PButton;

	begin
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				ADialog:=new(PInsertCellDialog,Init(p,TEXELWINDPREFIX+TITLE_INSERT,STG_INSERT,ICNTITLE_INSERT,RTINSERTCELLS));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTICBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
						new(PGroupBox,Init(ADialog,RTICMOVE,'',''));
						new(PInsertCellDialog(ADialog)^.bedt,Init(ADialog,RTICBEDIT,16,false,BUBBLE_GENERAL_RANGE));
						new(PInsertCellDialog(ADialog)^.rb2,Init(ADialog,RTICLEFT,true,BUBBLE_INSERT_LEFT));
						new(PInsertCellDialog(ADialog)^.rb3,Init(ADialog,RTICRIGHT,true,BUBBLE_INSERT_RIGHT));
						new(PInsertCellDialog(ADialog)^.rb4,Init(ADialog,RTICUP,true,BUBBLE_INSERT_UP));
						new(PInsertCellDialog(ADialog)^.rb5,Init(ADialog,RTICDOWN,true,BUBBLE_INSERT_DOWN));
						new(pb,Init(ADialog,RTICHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTICZEILE,id_No,true,BUBBLE_INSERT_ROW));
						new(PButton,Init(ADialog,RTICSPALTE,id_No,true,BUBBLE_INSERT_COLUMN));
						new(PButton,Init(ADialog,RTICABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PInsertCellDialog(ADialog)^.pb,Init(ADialog,RTICOK,id_OK,true,BUBBLE_INSERT_OK));
						with p^.ticbuffer do
							begin
								left:=bf_Unchecked;
								right:=bf_Checked;
								up:=bf_Unchecked;
								down:=bf_Unchecked
							end;
						ADialog^.TransferBuffer:=@p^.ticbuffer
					end
			end;
		if ADialog<>nil then
			begin
				PInsertCellDialog(ADialog)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
				ADialog^.TransferData(tf_SetData);
				ADialog^.MakeWindow;
				PInsertCellDialog(ADialog)^.CheckButtons
			end
	end;


procedure TInsertRows.Work;
	var p    : PCalcWindow;
	    rs,re,
	    dummy: integer;

	begin
		p:=PCalcWindow(Parent);
		p^.GetBlock(p^.dblock^.GetText,false,rs,dummy,re,dummy,dummy,dummy);
		p^.InsertCells(rs,0,re,p^.Parms.Columns,CRS_DOWN)
	end;


procedure TInsertColumns.Work;
	var p    : PCalcWindow;
	    cs,ce,
	    dummy: integer;

	begin
		p:=PCalcWindow(Parent);
		p^.GetBlock(p^.dblock^.GetText,false,dummy,cs,dummy,ce,dummy,dummy);
		p^.InsertCells(0,cs,p^.Parms.Rows,ce,CRS_RIGHT)
	end;

end.