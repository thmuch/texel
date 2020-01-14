unit txfont;
{ 1998-07-08 }

interface

uses

	ODialogs;


type

	PFontSelectBox = ^TFontSelectBox;
	TFontSelectBox = object(TComboBox)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
		procedure OpenPopup; virtual;
	end;

	PFontSizeBox = ^TFontSizeBox;
	TFontSizeBox = object(TFontSelectBox)
		setsize: boolean;
		procedure Work; virtual;
	end;

	PFontBox = ^TFontBox;
	TFontBox = object(TFontSelectBox)
		fsizebox: PFontSizeBox;
		newsize : integer;
		procedure SetValue(Sel: integer); virtual;
		procedure Work; virtual;
	end;




implementation

uses

	Objects,OTypes,OProcs,
	txtypes,txmain;



procedure TFontSelectBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		if DblClick then
			if Parent^.GetClassName=TEXELWINDCLASS then
				begin
					PCalcWindow(Parent)^.FontSelect;
					exit
				end;
		inherited Changed(AnIndx,DblClick)
	end;


procedure TFontSelectBox.OpenPopup;

	begin
		Popup^.SetOffset(GetSelection-2)
	end;


procedure TFontBox.SetValue(Sel: integer);

	begin
		if Popup<>nil then SetText(StrPTrimF(StrPLeft(StrPTrimF(Popup^.GetText(Sel)),25)))
	end;


procedure TFontBox.Work;
	var p      : PStringCollection;
	    pf     : PFont;
	    q,n,old,
	    neu,cm,
	    oldofs : integer;
	    dummy  : string;
	    found,
	    chng   : boolean;

	begin
		if (GetSelection<0) or (GetSelection>=List^.Count) or (fsizebox=nil) then exit;
		p:=fsizebox^.List;
		pf:=PFont(List^.At(GetSelection));
		if (p=nil) or (pf=nil) then exit;
		old:=atol(fsizebox^.GetText);
		if old=0 then old:=10;
		if fsizebox^.Popup<>nil then oldofs:=fsizebox^.Popup^.GetOffset;
		cm:=fsizebox^.GetSelection;
		fsizebox^.ClearSelection(true);
		if (pf^.SizeCount<>0) or (p^.Count<>124) then
			begin
				chng:=true;
				p^.FreeAll;
				if pf^.SizeCount=0 then
					begin
						for q:=4 to 127 do
							begin
								if q<10 then dummy:='    '
								else
									if q<100 then dummy:='   '
									else
										dummy:='  ';
								p^.Insert(NewStr(dummy+ltoa(q)+' '#0))
							end;
						neu:=old;
						cm:=neu-4
					end
				else
					begin
						found:=false;
						for q:=0 to pf^.SizeCount-1 do
							begin
								n:=pf^.Sizes^[q];
								if n<10 then dummy:='    '
								else
									if n<100 then dummy:='   '
									else
										dummy:='  ';
								p^.Insert(NewStr(dummy+ltoa(n)+' '#0));
								if not(found) then
									if n<=old then
										begin
											if q=0 then
												begin
													neu:=n;
													cm:=pf^.SizeCount-1
												end
											else
												if (old-n)>(pf^.Sizes^[q-1]-old) then
													begin
														neu:=pf^.Sizes^[q-1];
														cm:=pf^.SizeCount-q
													end
												else
													begin
														neu:=n;
														cm:=pf^.SizeCount-q-1
													end;
											found:=true
										end
							end
					end
			end
		else
			chng:=false;
		with fsizebox^ do
			begin
				if chng then
					if Popup<>nil then
						with Popup^ do
							begin
								SetCollection(p);
								SetOffset(oldofs)
							end;
				setsize:=false;
				if newsize<0 then SetSelection(cm,true)
				else
					begin
						SetSelection(PCalcWindow(Parent)^.FontSize2Index(newsize),false);
						newsize:=-1
					end;
				setsize:=true
			end
	end;


procedure TFontSizeBox.Work;
	var rs,cs,re,ce,
	    cmin,cmax,
	    x,y,nsize,
	    nfont      : integer;
	    cell       : PCell;
	    p          : PCalcWindow;

	begin
		with PWindow(Parent)^ do
			begin
				if GetClassName<>TEXELWINDCLASS then exit;
				if Attr.Status<>ws_Open then exit
			end;
		nsize:=atol(GetText);
		if nsize<4 then exit;
		p:=PCalcWindow(Parent);
		nfont:=PFont(p^.pfbox^.List^.At(p^.pfbox^.GetSelection))^.Index;
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
		cmin:=cs;
		cmax:=ce;
		p^.RowsClearOverflow(rs,re,cmin,cmax);
		for y:=rs to re do
			begin
				cell:=p^.GetCell(y,cs);
				for x:=cs to ce do
					begin
						with cell^.TxtVal do
							begin
								if not(setsize) or (Font=0) then Font:=nfont;
								if setsize or (Size=0) then Size:=nsize
							end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		p^.RowsCheckOverflow(rs,re,cmin,cmax);
		p^.SetDirty;
		p^.DrawCells(rs,cmin,re,cmax)
	end;

end.