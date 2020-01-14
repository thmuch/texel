unit txclear;
{ 1998-07-07 }

interface

uses

	OWindows;


type

	PClear = ^ TClear;
	TClear = object(TSubMenu)
		procedure HandleMenu(Indx: integer); virtual;
	end;

	PClearCell = ^TClearCell;
	TClearCell = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Gem,
	OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txmain;


type

	PClearCellDialog = ^TClearCellDialog;
	TClearCellDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		rb1,
		rb2,
		rb3,
		rb4,
		rb5 : PRadioButton;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
		procedure CheckButtons;
	end;



procedure TClear.HandleMenu(Indx: integer);
	var p    : PCalcWindow;
	    x,y,
	    cmin,
	    cmax,
	    rs,cs,
	    re,ce: integer;
	    cell : PCell;
	    valid: boolean;

	begin
		p:=PCalcWindow(Parent);
		with p^.Parms.Cursor do
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
		case Indx of
		0:
			p^.DeleteCells;
		1:
			begin
				cmin:=cs;
				cmax:=ce;
				p^.RowsClearOverflow(rs,re,cmin,cmax);
				for y:=rs to re do
					begin
						cell:=p^.GetCell(y,cs);
						for x:=cs to ce do
							begin
								with cell^ do
									begin
										Flags:=Flags and not(CELL_EMPTYMASK);
										Color:=Black;
										Style:=8;
										Interior:=FIS_HOLLOW;
										Border.Val1:=0;
										Border.Val2:=0;
										Format:=0;
										with TxtVal do
											begin
												if Typ=0 then
													begin
														Font:=0;
														Size:=0;
														Align:=0
													end;
												Rotat:=0;
												Skew:=0;
												Color:=Black;
												Effects:=0;
												Flags:=0
											end
									end;
								inc(longint(cell),CELLSIZE)
							end
					end;
				p^.RowsCheckOverflow(rs,re,cmin,cmax);
				p^.SetDirty;
				p^.DrawCells(rs,cmin,re,cmax);
				p^.CheckToolbarTextFX(p^.GetCell(rs,cs))
			end;
		2:
			begin
				cmin:=cs;
				cmax:=ce;
				p^.RowsClearOverflow(rs,re,cmin,cmax);
				valid:=p^.FreeBlock(rs,cs,re,ce,false);
				p^.RowsCheckOverflow(rs,re,cmin,cmax);
				if valid then
					begin
						p^.SetDirty;
						p^.DrawCells(rs,cmin,re,cmax);
						p^.AutoCalculate(true);
						cell:=p^.GetCell(rs,cs);
						p^.CheckToolbarTextFX(cell);
						p^.SetInpline(cell)
					end
				else
					Application^.Bing
			end;
		3:
			{ Notizen l”schen... }
		end
	end;


function TClearCellDialog.ExitDlg(AnIndx: integer): boolean;
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


procedure TClearCellDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk);
		CheckButtons
	end;


procedure TClearCellDialog.CheckButtons;
	var rs,cs,re,
	    ce,dummy: integer;
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
				rb1^.Check
			end
		else
			if (cs=0) and (ce=p^.Parms.Columns) then
				begin
					rb4^.Enable;
					rb5^.Enable;
					if (rb2^.GetCheck=bf_Checked) or (rb3^.GetCheck=bf_Checked) then rb4^.Check;
					rb2^.Disable;
					rb3^.Disable;
					rb2^.Uncheck;
					rb3^.Uncheck;
					if rs=0 then
						begin
							if rb5^.GetCheck=bf_Checked then
								begin
									rb5^.Uncheck;
									rb4^.Check
								end;
							rb5^.Disable
						end
					else
						if re=p^.Parms.Rows then
							begin
								if rb4^.GetCheck=bf_Checked then
									begin
										rb4^.Uncheck;
										rb5^.Check
									end;
								rb4^.Disable
							end
				end
			else
				if (rs=0) and (re=p^.Parms.Rows) then
					begin
						rb2^.Enable;
						rb3^.Enable;
						if (rb4^.GetCheck=bf_Checked) or (rb5^.GetCheck=bf_Checked) then rb2^.Check;
						rb4^.Disable;
						rb5^.Disable;
						rb4^.Uncheck;
						rb5^.Uncheck;
						if cs=0 then
							begin
								if rb3^.GetCheck=bf_Checked then
									begin
										rb3^.Uncheck;
										rb2^.Check
									end;
								rb3^.Disable
							end
						else
							if ce=p^.Parms.Columns then
								begin
									if rb2^.GetCheck=bf_Checked then
										begin
											rb2^.Uncheck;
											rb3^.Check
										end;
									rb2^.Disable
								end
					end
				else
					begin
						rb2^.Enable;
						rb3^.Enable;
						rb4^.Enable;
						rb5^.Enable;
						if cs=0 then
							begin
								if rb3^.GetCheck=bf_Checked then
									begin
										rb3^.Uncheck;
										rb1^.Check
									end;
								rb3^.Disable
							end
						else
							if ce=p^.Parms.Columns then
								begin
									if rb2^.GetCheck=bf_Checked then
										begin
											rb2^.Uncheck;
											rb1^.Check
										end;
									rb2^.Disable
								end;
						if rs=0 then
							begin
								if rb5^.GetCheck=bf_Checked then
									begin
										rb5^.Uncheck;
										rb1^.Check
									end;
								rb5^.Disable
							end
						else
							if re=p^.Parms.Rows then
								begin
									if rb4^.GetCheck=bf_Checked then
										begin
											rb4^.Uncheck;
											rb1^.Check
										end;
									rb4^.Disable
								end
					end
	end;


function TClearCellDialog.OK: boolean;
	var valid,
	    movesize : boolean;
	    p        : PCalcWindow;
	    rs,cs,
	    re,ce,
	    r,rbis,
	    c,cbis,
	    x,cdif,
	    y,rdif,
	    cmin,cmax,
	    rmin,rmax,
	    dummy    : integer;
	    ocell,
	    cell     : PCell;
	    oldsel   : byte;

	begin
		valid:=inherited OK;
		if valid then
			begin
				p:=PCalcWindow(Parent);
				if rb1^.GetCheck=bf_Checked then p^.DeleteCells
				else
					begin
						BusyMouse;
						p^.GetBlock(p^.dblock^.GetText,false,rs,cs,re,ce,dummy,dummy);
						if rb2^.GetCheck=bf_Checked then
							begin
								rmin:=rs;
								rmax:=re;
								cmin:=cs;
								cmax:=p^.Parms.Columns
							end
						else if rb3^.GetCheck=bf_Checked then
							begin
								rmin:=rs;
								rmax:=re;
								cmin:=0;
								cmax:=ce
							end
						else if rb4^.GetCheck=bf_Checked then
							begin
								rmin:=rs;
								rmax:=p^.Parms.Rows;
								cmin:=cs;
								cmax:=ce
							end
						else
							begin
								rmin:=0;
								rmax:=re;
								cmin:=cs;
								cmax:=ce
							end;
						p^.RowsClearOverflow(rmin,rmax,cmin,cmax);
						p^.FreeBlock(rs,cs,re,ce,true);
						if rb2^.GetCheck=bf_Checked then
							begin
								movesize:=(rs=0) and (re=p^.Parms.Rows);
								c:=ce+1;
								cbis:=p^.Parms.Columns;
								r:=rs;
								rbis:=re;
								if movesize then
									for x:=c to cbis do p^.PCol^[cs+x-c]:=p^.PCol^[x];
								for y:=r to rbis do
									begin
										cell:=p^.GetCell(y,cs);
										ocell:=p^.GetCell(y,c);
										for x:=c to cbis do
											begin
												oldsel:=cell^.Flags and CELL_SELECTED;
												cell^:=ocell^;
												cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
												inc(longint(cell),CELLSIZE);
												inc(longint(ocell),CELLSIZE)
											end
									end;
								p^.ClearBlock(r,cbis-Min(ce-cs,cbis-c),rbis,cbis);
								if movesize then
									for x:=cbis-Min(ce-cs,cbis-c) to cbis do p^.PCol^[x]:=p^.PCol^[x-1];
								cdif:=cs-ce-1;
								rdif:=0;
								ce:=cbis
							end
						else
							if rb3^.GetCheck=bf_Checked then
								begin
									movesize:=(rs=0) and (re=p^.Parms.Rows);
									c:=0;
									cbis:=cs-1;
									r:=rs;
									rbis:=re;
									if movesize then
										for x:=cbis downto c do p^.PCol^[ce+x-cbis]:=p^.PCol^[x];
									for y:=r to rbis do
										begin
											cell:=p^.GetCell(y,ce);
											ocell:=p^.GetCell(y,cbis);
											for x:=cbis downto c do
												begin
													oldsel:=cell^.Flags and CELL_SELECTED;
													cell^:=ocell^;
													cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
													dec(longint(cell),CELLSIZE);
													dec(longint(ocell),CELLSIZE)
												end
										end;
									p^.ClearBlock(r,0,rbis,Min(ce-cs,cbis-c));
									if movesize then
										for x:=Min(ce-cs,cbis-c) downto 0 do p^.PCol^[x]:=p^.PCol^[x+1];
									cdif:=ce+1-cs;
									rdif:=0;
									cs:=0
								end
							else
								if rb4^.GetCheck=bf_Checked then
									begin
										movesize:=(cs=0) and (ce=p^.Parms.Columns);
										c:=cs;
										cbis:=ce;
										r:=re+1;
										rbis:=p^.Parms.Rows;
										for y:=r to rbis do
											begin
												cell:=p^.GetCell(rs+y-r,c);
												ocell:=p^.GetCell(y,c);
												if movesize then p^.PRow^[rs+y-r]:=p^.PRow^[y];
												for x:=c to cbis do
													begin
														oldsel:=cell^.Flags and CELL_SELECTED;
														cell^:=ocell^;
														cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
														inc(longint(cell),CELLSIZE);
														inc(longint(ocell),CELLSIZE)
													end
											end;
										p^.ClearBlock(rbis-Min(re-rs,rbis-r),c,rbis,cbis);
										if movesize then
											for y:=rbis-Min(re-rs,rbis-r) to rbis do p^.PRow^[y]:=p^.PRow^[y-1];
										cdif:=0;
										rdif:=rs-re-1;
										re:=rbis
									end
								else
									begin
										movesize:=(cs=0) and (ce=p^.Parms.Columns);
										c:=cs;
										cbis:=ce;
										r:=0;
										rbis:=rs-1;
										for y:=rbis downto r do
											begin
												cell:=p^.GetCell(re+y-rbis,c);
												ocell:=p^.GetCell(y,c);
												if movesize then p^.PRow^[re+y-rbis]:=p^.PRow^[y];
												for x:=c to cbis do
													begin
														oldsel:=cell^.Flags and CELL_SELECTED;
														cell^:=ocell^;
														cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
														inc(longint(cell),CELLSIZE);
														inc(longint(ocell),CELLSIZE)
													end
											end;
										p^.ClearBlock(0,c,Min(re-rs,rbis-r),cbis);
										if movesize then
											for y:=Min(re-rs,rbis-r) downto 0 do p^.PRow^[y]:=p^.PRow^[y+1];
										cdif:=0;
										rdif:=re+1-rs;
										rs:=0
									end;
						p^.TranslateCells(r,c,rbis,cbis,rdif,cdif,true);
						p^.RowsCheckOverflow(rmin,rmax,cmin,cmax);
						p^.SetDirty;
						if movesize then
							begin
								p^.SetScrollerRange;
								p^.ForceVRedraw
							end
						else
							p^.DrawCells(rmin,cmin,rmax,cmax);
						p^.AutoCalculate(true);
						ArrowMouse
					end
			end;
		OK:=valid
	end;


procedure TClearCell.Work;
	var p : PCalcWindow;
	    pb: PButton;

	begin
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				ADialog:=new(PClearCellDialog,Init(p,TEXELWINDPREFIX+TITLE_CLEAR,STG_CLEAR,ICNTITLE_CLEAR,RTCLEARCELL));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTCCBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
						new(PGroupBox,Init(ADialog,RTCCFILL,GROUP_DELCELL_FILL,''));
						new(PClearCellDialog(ADialog)^.bedt,Init(ADialog,RTCCBEDIT,16,false,BUBBLE_GENERAL_RANGE));
						new(PClearCellDialog(ADialog)^.rb1,Init(ADialog,RTCCEMPTY,true,BUBBLE_CLEAR_FILL));
						new(PClearCellDialog(ADialog)^.rb2,Init(ADialog,RTCCLEFT,true,BUBBLE_CLEAR_LEFT));
						new(PClearCellDialog(ADialog)^.rb3,Init(ADialog,RTCCRIGHT,true,BUBBLE_CLEAR_RIGHT));
						new(PClearCellDialog(ADialog)^.rb4,Init(ADialog,RTCCUP,true,BUBBLE_CLEAR_UP));
						new(PClearCellDialog(ADialog)^.rb5,Init(ADialog,RTCCDOWN,true,BUBBLE_CLEAR_DOWN));
						new(pb,Init(ADialog,RTCCHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTCCZEILE,id_No,true,BUBBLE_CLEAR_ROW));
						new(PButton,Init(ADialog,RTCCSPALTE,id_No,true,BUBBLE_CLEAR_COLUMN));
						new(PButton,Init(ADialog,RTCCABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTCCOK,id_OK,true,BUBBLE_CLEAR_OK));
						with p^.tccbuffer do
							begin
								empty:=bf_Unchecked;
								left:=bf_Checked;
								right:=bf_Unchecked;
								up:=bf_Unchecked;
								down:=bf_Unchecked
							end;
						ADialog^.TransferBuffer:=@p^.tccbuffer
					end
			end;
		if ADialog<>nil then
			begin
				PClearCellDialog(ADialog)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
				ADialog^.TransferData(tf_SetData);
				ADialog^.MakeWindow;
				PClearCellDialog(ADialog)^.CheckButtons
			end
	end;

end.