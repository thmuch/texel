unit txmainob;
{ 1998-08-12 }

interface

uses

	OWindows,ODialogs;


type

{$IFNDEF WDIALOG}
	PDeviceBox = ^TDeviceBox;
	TDeviceBox = object(TComboBox)
		procedure Work; virtual;
	end;
{$ENDIF}

	PPatternBox = ^TPatternBox;
	TPatternBox = object(TComboBox)
		function TestIndex(AnIndx: integer): boolean; virtual;
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
		procedure SetValue(Sel: integer); virtual;
		procedure Work; virtual;
	end;

	PBorderBox = ^TBorderBox;
	TBorderBox = object(TComboBox)
		function TestIndex(AnIndx: integer): boolean; virtual;
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
		procedure SetValue(Sel: integer); virtual;
		procedure Work; virtual;
	end;

	PPercentBox = ^TPercentBox;
	TPercentBox = object(TComboBox)
		procedure Work; virtual;
	end;

	PCalcScroller = ^TCalcScroller;
	TCalcScroller = object(TScroller)
		procedure RedrawParent(XDif,YDif: longint); virtual;
	end;

	PBlock = ^TBlock;
	TBlock = object(TKey)
		procedure Work; virtual;
	end;

	PCalculate = ^TCalculate;
	TCalculate = object(TKeyMenu)
		procedure Work; virtual;
	end;

	PCellProtect = ^TCellProtect;
	TCellProtect = object(TMenu)
		procedure Work; virtual;
	end;

	PCellUnprotect = ^TCellUnprotect;
	TCellUnprotect = object(TMenu)
		procedure Work; virtual;
	end;

	PFormCell = ^ TFormCell;
	TFormCell = object(TSubMenu)
		procedure HandleMenu(Indx: integer); virtual;
	end;

	PFormRow = ^ TFormRow;
	TFormRow = object(TSubMenu)
		procedure HandleMenu(Indx: integer); virtual;
	end;

	PFormCol = ^ TFormCol;
	TFormCol = object(TSubMenu)
		procedure HandleMenu(Indx: integer); virtual;
	end;

	PUmbruch = ^TUmbruch;	
	TUmbruch = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Gem,
	OTypes,OProcs,
	txrsc,txtypes,txmain
	{$IFNDEF WDIALOG},Tos,txlang,txnewvdi,txmiscob{$ENDIF};



procedure TUmbruch.Work;
	var p    : PCalcWindow;
	    rbis,
	    cbis,
	    cmin,
	    cmax,
	    dummy,
	    r,c  : integer;

	begin
		p:=PCalcWindow(Parent);
		with p^ do
			begin
				GetBlock(dblock^.GetText,false,r,c,rbis,cbis,dummy,dummy);
				cmin:=cbis;
				cmax:=cmin;
				RowsClearOverflow(0,Parms.Rows,cmin,cmax);
				PRowFlags^[rbis]:=PRowFlags^[rbis] or CRF_UMBRUCH;
				PColFlags^[cbis]:=PColFlags^[cbis] or CRF_UMBRUCH;
				RowsCheckOverflow(0,Parms.Rows,cmin,cmax);
				DrawCells(0,cmin,Parms.Rows,cmax);
				DrawCells(rbis,0,rbis,Parms.Columns);
				SetDirty
			end
	end;


procedure TFormCell.HandleMenu(Indx: integer);
	var p   : PCalcWindow;
	    cell: PCell;

	begin
		p:=PCalcWindow(Parent);
		cell:=p^.GetCell(p^.Parms.Cursor.Row,p^.Parms.Cursor.Col);
		case Indx of
		0:
			p^.FontSelect;
		1:
			p^.AttrDialogs(0,0,cell);
		2:
			p^.AttrDialogs(1,0,cell);
		3:
			p^.AttrDialogs(6,0,cell);
		4:
			p^.AttrDialogs(5,0,cell)
		end
	end;


procedure TFormRow.HandleMenu(Indx: integer);
	var p    : PCalcWindow;
	    rs,re,
	    dummy: integer;

	begin
		p:=PCalcWindow(Parent);
		p^.GetBlock(p^.dblock^.GetText,false,rs,dummy,re,dummy,dummy,dummy);
		case Indx of
		0:
			p^.AttrDialogs(2,rs,nil);
		1:
			{ ... };
		2:
			p^.StandardHoehe(rs,re);
		4:
			{ ... };
		5:
			{ ... }
		end
	end;


procedure TFormCol.HandleMenu(Indx: integer);
	var p    : PCalcWindow;
	    cs,ce,
	    dummy: integer;

	begin
		p:=PCalcWindow(Parent);
		p^.GetBlock(p^.dblock^.GetText,false,dummy,cs,dummy,ce,dummy,dummy);
		case Indx of
		0:
			p^.AttrDialogs(3,cs,nil);
		1:
			{ ... };
		2:
			p^.StandardBreite(cs,ce);
		4:
			p^.AttrDialogs(4,cs,nil);
		6:
			{ ... };
		7:
			{ ... }
		end
	end;


procedure TCalculate.Work;

	begin
		PCalcWindow(Parent)^.Calculate(true)
	end;


procedure TCellProtect.Work;
	var x,y : integer;
	    cell: PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							for y:=RowStart to RowEnd do
								begin
									cell:=GetCell(y,ColStart);
									for x:=ColStart to ColEnd do
										begin
											cell^.Flags:=cell^.Flags or CELL_PROTECTED;
											inc(longint(cell),CELLSIZE)
										end
								end;
							DrawCells(RowStart,ColStart,RowEnd,ColEnd)
						end
					else
						begin
							cell:=GetCell(Row,Col);
							cell^.Flags:=cell^.Flags or CELL_PROTECTED;
							DrawCells(Row,Col,Row,Col)
						end;
				SetDirty
			end
	end;


procedure TCellUnprotect.Work;
	var x,y : integer;
	    cell: PCell;

	begin
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							for y:=RowStart to RowEnd do
								begin
									cell:=GetCell(y,ColStart);
									for x:=ColStart to ColEnd do
										begin
											cell^.Flags:=cell^.Flags and not(CELL_PROTECTED);
											inc(longint(cell),CELLSIZE)
										end
								end;
							DrawCells(RowStart,ColStart,RowEnd,ColEnd)
						end
					else
						begin
							cell:=GetCell(Row,Col);
							cell^.Flags:=cell^.Flags and not(CELL_PROTECTED);
							DrawCells(Row,Col,Row,Col)
						end;
				SetDirty
			end
	end;


function TBorderBox.TestIndex(AnIndx: integer): boolean;

	begin
		if AnIndx=ObjAddr^.ob_head then
			begin
				TestIndex:=true;
				exit
			end;
		TestIndex:=inherited TestIndex(AnIndx)
	end;


procedure TBorderBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		if AnIndx=ObjAddr^.ob_head then AnIndx:=ObjIndx;
		inherited Changed(AnIndx,DblClick)
	end;


procedure TBorderBox.SetValue(Sel: integer);
	var p: PTree;

	begin
		p:=Application^.GetAddr(RTICONS);
		PCalcWindow(Parent)^.DlgTree^[ObjAddr^.ob_head].ob_spec.bit_blk^.bi_pdata:=p^[p^[RTIRAHMEN].ob_head+Sel].ob_spec.bit_blk^.bi_pdata;
		Paint
	end;


procedure TBorderBox.Work;

	begin
		with PCalcWindow(Parent)^ do
			begin
				if Attr.Status<>ws_Open then exit;
				case GetSelection of
				0:
					SetBorder(0,White,0,White,0,White,0,White,0,White,0,White,-1,0);
				1:
					SetBorder(-1,0,-1,0,-1,0,2,Black,-1,0,-1,0,-1,0);
				2:
					SetBorder(2,Black,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0);
				3:
					SetBorder(-1,0,2,Black,-1,0,-1,0,-1,0,-1,0,-1,0);
				4:
					SetBorder(-1,0,-1,0,-1,0,5,Black,-1,0,-1,0,-1,0);
				5:
					SetBorder(-1,0,-1,0,-1,0,3,Black,-1,0,-1,0,-1,0);
				6:
					SetBorder(-1,0,-1,0,2,Black,2,Black,-1,0,-1,0,-1,0);
				7:
					SetBorder(-1,0,-1,0,2,Black,5,Black,-1,0,-1,0,-1,0);
				8:
					SetBorder(-1,0,-1,0,2,Black,3,Black,-1,0,-1,0,-1,0);
				9:
					SetBorder(1,Black,1,Black,1,Black,1,Black,-1,0,-1,0,2,Black);
				10:
					SetBorder(-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,2,Black);
				11:
					SetBorder(-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,3,Black)
				end
			end
	end;


procedure TPercentBox.Work;
	var prc: integer;
	    txt: string;
	    p  : PCalcWindow;
	    x,y: longint;
	    fak: real;

	begin
		p:=PCalcWindow(Parent);
		x:=p^.Scroller^.XPos;
		y:=p^.Scroller^.YPos;
		fak:=1.0/p^.PercentSize;
		txt:=StrPTrimF(GetText);
		prc:=atol(StrPLeft(txt,length(txt)-1));
		p^.SetPercentSize(prc);
		fak:=fak*p^.PercentSize;
		p^.Scroller^.TrackMode:=false;
		p^.Scroller^.ScrollTo(round(x*fak),round(y*fak));
		p^.Scroller^.TrackMode:=true
	end;


procedure TBlock.Work;

	begin
		with PCalcWindow(Parent)^ do
			begin
				with dblock^ do
					begin
						ObjAddr^.ob_state:=ObjAddr^.ob_state or SELECTED;
						Paint
					end;
				ExitDlg(RTWDBLOCK);
				with dblock^ do
					begin
						ObjAddr^.ob_state:=ObjAddr^.ob_state and not(SELECTED);
						Paint
					end
			end
	end;


procedure TCalcScroller.RedrawParent(XDif,YDif: longint);
	var p    : PCalcWindow;
	    r    : GRECT;
	    valid: boolean;

	begin
		p:=PCalcWindow(Window);
		HideMouse;
		valid:=p^.FirstWorkRect(r);
		while valid do
			begin
				if XDif<>0 then p^.PaintNames(r);
				if YDif<>0 then p^.PaintNumbers(r);
				valid:=p^.NextWorkRect(r)
			end;
		vs_clip(Application^.vdiHandle,CLIP_ON,SysInfo.Desktop.A2);
		ShowMouse
	end;


function TPatternBox.TestIndex(AnIndx: integer): boolean;

	begin
		if AnIndx=ObjAddr^.ob_head then TestIndex:=true
		else
			TestIndex:=inherited TestIndex(AnIndx)
	end;


procedure TPatternBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		if AnIndx=ObjAddr^.ob_head then AnIndx:=ObjIndx;
		inherited Changed(AnIndx,DblClick)
	end;


procedure TPatternBox.SetValue(Sel: integer);

	begin
		with ObjAddr^ do
			if ((ob_spec.index shr 4) and $07)<>Sel then
				begin
					ob_spec.index:=(ob_spec.index and $ffffff8f) or (Sel shl 4);
					Paint
				end
	end;


procedure TPatternBox.Work;
	var x,y,st,
	    oldint,
	    inter : integer;
	    cell  : PCell;

	begin
		if Parent^.Attr.Status<>ws_Open then exit;
		st:=GetSelection;
		if st=0 then
			begin
				st:=8;
				inter:=FIS_HOLLOW
			end
		else
			begin
				if st=7 then st:=8;
				inter:=FIS_PATTERN
			end;
		with PCalcWindow(Parent)^ do
			begin
				with Parms.Cursor do
					if Block then
						begin
							for y:=RowStart to RowEnd do
								begin
									cell:=GetCell(y,ColStart);
									for x:=ColStart to ColEnd do
										begin
											cell^.Interior:=inter;
											cell^.Style:=st;
											if inter=FIS_HOLLOW then cell^.Color:=Black;
											inc(longint(cell),CELLSIZE)
										end
								end;
							DrawCells(RowStart,ColStart,RowEnd,ColEnd)
						end
					else
						begin
							cell:=GetCell(Row,Col);
							oldint:=cell^.Interior;
							cell^.Interior:=inter;
							cell^.Style:=st;
							if inter=FIS_HOLLOW then cell^.Color:=Black;
							DrawCells(Row,Col,Row,Col);
							if pcbox<>nil then
								begin
									if inter=FIS_HOLLOW then pcbox^.SetSelection(0,false)
									else
										if oldint=FIS_HOLLOW then pcbox^.SetSelection(1,false)
								end
						end;
				SetDirty
			end
	end;


{$IFNDEF WDIALOG}

procedure TDeviceBox.Work;
	label _fehler,_weiter;

	var unten,oben,
	    q,hndl,
	    sel,hdl   : integer;
	    bufsize,
	    res,w     : longint;
	    buf       : PByteArray;
	    pcb       : PDriverBox;
	    cb        : PComboBox;
	    wrkin     : workin_ARRAY;
	    wrkout    : workout_ARRAY;
	    names     : array [0..24] of string[80];
	    devfound  : array [0..24] of boolean;
	    txt,txt2  : string;
	    ok        : boolean;

	begin
		pcb:=PPrintDialog(Parent)^.drvbox;
		if pcb=nil then exit;
		SliceMouse;
		sel:=GetSelection;
		if pcb^.List=nil then exit;
		pcb^.List^.FreeAll;
		pcb^.List^.Sort:=false;
		if Sel<DEV_FAX then unten:=Sel*10+11
		else
			unten:=Sel*10+21;
		if Sel=DEV_MEMORY then oben:=80
		else
			if Sel=DEV_IMG then oben:=99
			else
				oben:=unten+9;
		pcb^.drvcnt:=0;
		{$IFNDEF NVDI5}
		if NVDIVersion>=$0300 then
		{$ENDIF}
			for q:=unten to oben do
				begin
					SliceMouseNext;
					if vqtExtDevinfo(Application^.aesHandle,q,txt2,txt) then
						begin
							pcb^.drivers[pcb^.drvcnt]:=q;
							if (length(txt2)>0) or (length(txt)>0) then
								begin
									if length(txt)>0 then names[pcb^.drvcnt]:='  '+StrPLeft(txt,75)+' '#0
									else
										names[pcb^.drvcnt]:='  '+StrPLeft(ltoa(q)+' '+txt2,75)+' '#0;
									pcb^.shortnames[pcb^.drvcnt]:=StrPLeft(txt2,12);
									pcb^.longnames[pcb^.drvcnt]:=StrPLeft(txt,42);
									devfound[pcb^.drvcnt]:=true
								end
							else
								begin
									names[pcb^.drvcnt]:='  '+ltoa(q);
									pcb^.shortnames[pcb^.drvcnt]:='';
									pcb^.longnames[pcb^.drvcnt]:='';
									devfound[pcb^.drvcnt]:=false
								end;
							inc(pcb^.drvcnt)
						end
		{$IFNDEF NVDI5}
				end
		else
			begin
		   	for q:=1 to 9 do wrkin[q]:=1;
		 		wrkin[10]:=RC;
				for q:=unten to oben do
					begin
						SliceMouseNext;
						wrkin[0]:=q;
						v_opnwk(wrkin,hndl,wrkout);
						if hndl<>0 then
							begin
								pcb^.drivers[pcb^.drvcnt]:=q;
								if vqtDevinfo(hndl,q,txt2,txt) then
									if (length(txt2)>0) or (length(txt)>0) then
										begin
											if length(txt)>0 then names[pcb^.drvcnt]:='  '+StrPLeft(txt,75)+' '#0
											else
												names[pcb^.drvcnt]:='  '+StrPLeft(ltoa(q)+' '+txt2,75)+' '#0;
											pcb^.shortnames[pcb^.drvcnt]:=StrPLeft(txt2,12);
											pcb^.longnames[pcb^.drvcnt]:=StrPLeft(txt,42);
											devfound[pcb^.drvcnt]:=true;
											goto _weiter
										end;
								names[pcb^.drvcnt]:='  '+ltoa(q);
								pcb^.shortnames[pcb^.drvcnt]:='';
								pcb^.longnames[pcb^.drvcnt]:='';
								devfound[pcb^.drvcnt]:=false;
								_weiter:
								v_clswk(hndl);
								inc(pcb^.drvcnt)
							end
					end
		{$ENDIF}
			end;
		_fehler:
		if pcb^.drvcnt=0 then
			begin
				pcb^.SetText(STRING_NODRIVER2);
				pcb^.Disable;
				with PPrintDialog(Parent)^ do
					begin
						if inf<>nil then inf^.Disable;
						if druck<>nil then druck^.Disable
					end
			end
		else
			begin
				BusyMouse;
				ok:=true;
				for q:=0 to pcb^.drvcnt-1 do
					if not(devfound[q]) then
						begin
							ok:=false;
							break
						end;
				if not(ok) then
					begin
						txt:=BootDevice+':\assign.sys';
						if not(Exist(txt)) then
							begin
								txt:='assign.sys';
								if shel_find(txt)=0 then
									begin
										pcb^.drvcnt:=0;
										ArrowMouse;
										goto _fehler
									end
							end;
						buf:=GetMemBuffer(16384,128,bufsize);
						if buf=nil then
							begin
								pcb^.drvcnt:=0;
								ArrowMouse;
								goto _fehler
							end;
						res:=fopen(txt,FO_READ);
						if res<0 then
							begin
								pcb^.drvcnt:=0;
								freemem(buf,bufsize);
								ArrowMouse;
								goto _fehler
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
											hndl:=atol(StrPLeft(txt,2));
											if (hndl>=11) and (hndl<=99) then
												begin
													txt:=StrPTrimF(StrPRight(txt,length(txt)-3));
													for q:=0 to pcb^.drvcnt-1 do
														if hndl=pcb^.drivers[q] then
															if not(devfound[q]) then
																begin
																	names[q]:=StrPLeft(names[q]+' '+txt,75)+' '#0;
																	pcb^.shortnames[q]:=StrPLeft(txt,12)
																end
												end;
											txt:=''
										end
									else
										if buf^[w]>=32 then txt:=txt+chr(buf^[w])
						until res<>bufsize;
						fclose(hdl);
						freemem(buf,bufsize)
					end;
				for q:=0 to pcb^.drvcnt-1 do pcb^.List^.Insert(NewStr(names[q]));
				ArrowMouse
			end;
		with pcb^ do
			begin
				if Popup<>nil then Popup^.SetCollection(List);
				if drvcnt=0 then
					begin
						ClearSelection(true);
						SetText(STRING_NODRIVER2);
						Disable;
						with PPrintDialog(Parent)^ do
							begin
								if inf<>nil then inf^.Disable;
								if druck<>nil then druck^.Disable
							end
					end
				else
					begin
						SetSelection(0,true);
						SetText(Popup^.GetText(0));
						Enable;
						with PPrintDialog(Parent)^ do
							begin
								if inf<>nil then inf^.Enable;
								if druck<>nil then druck^.Enable
							end
					end
			end;
		cb:=PPrintDialog(Parent)^.paper;
		if cb<>nil then
			begin
				{$IFNDEF NVDI5}
				if NVDIVersion<$0300 then cb^.Disable
				else
				{$ENDIF}
					if (Sel=DEV_IMG) or (Sel=DEV_PRINTER) then cb^.Enable
					else
						cb^.Disable
			end;
		ArrowMouse
	end;

{$ENDIF}

end.