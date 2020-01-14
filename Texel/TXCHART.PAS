unit txchart;
{ 1998-07-08 }

interface

uses

	OWindows;


type
	
	PDiagram = ^TDiagram;
	TDiagram = object(TKeyMenu)
		{$IFNDEF LITE}
		procedure Work; virtual;
		procedure SetFile(fname: string);
		procedure CreateDiagramFromBlock;
		{$ENDIF}
	end;




implementation

uses

	Tos,Gem,
	Objects,OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txvalida,txattr,txfont,txmain;


{$IFNDEF LITE}

type

	PDiagrammBox = ^TDiagrammBox;
	TDiagrammBox = object(TRahmenBox)
		procedure SetValue(Sel: integer); virtual;
	end;

	PDiagrammRadio = ^TDiagrammRadio;
	TDiagrammRadio = object(TRadioButton)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;
	
	PDiagrammDialog = ^TDiagrammDialog;
	TDiagrammDialog = object(TBlockChangeDialog)
		ofname,
		bedt    : PStatic;
		pb1     : PButton;
		ed1     : PEdit;
		obic    : PObj;
		tc,
		pc1,
		pc2,
		pc3     : PControl;
		gb1,
		gb2,
		gb3,
		gb4,
		gb5     : PGroupBox;
		cb1     : PCheckBox;
		rbt1,
		rbt2,
		rbt3,
		rb1,
		rb2,
		rb3,
		rb4,
		rb5     : PDiagrammRadio;
		pdb1,
		pdb2    : PDiagrammBox;
		obicspec: longint;
		aendern : integer;
		destructor Done; virtual;
		function CreateDiagram(tadname: string; emb: boolean): boolean;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
		procedure CheckButtons;
	end;



procedure TDiagrammBox.SetValue(Sel: integer);
	var p: PTree;

	begin
		if not(Between(Sel,0,5)) or (Popup=nil) then inherited SetValue(Sel)
		else
			if Popup^.PopTree=nil then inherited SetValue(Sel)
			else
				begin
					with PDiagrammDialog(Parent)^.DlgTree^[ObjAddr^.ob_head] do
						ob_spec.bit_blk^.bi_pdata:=Popup^.PopTree^[Popup^.PopTree^[0].ob_head+Sel].ob_spec.bit_blk^.bi_pdata;
					SetText('')
				end
	end;


function TDiagrammDialog.CreateDiagram(tadname: string; emb: boolean): boolean;
	label _raus,_error;
	
	var fname,
	    sd,
	    s    : string;
	    l1,l2,
	    lofs,
	    anz,
	    fsize,
	    res  : longint;
	    pf   : PFont;
	    cs,rs,
	    ce,re,
	    dummy,
	    q,w,
	    coll,
	    rowl,
	    rof,
	    cof,
	    findx,
	    hdl  : integer;
	    pc   : pointer;
	    tag  : TTAG;
	    lr   : LRECT;
	    p    : PCalcWindow;
	    cell2,
	    cell : PCell;
	    almin,
	    almax,
	    aumin,
	    aumax,
	    xcmp,
	    xmin,
	    xmax,
	    vcmp,
	    vmin,
	    vmax : real;
	    xy   : array [0..4] of integer;
	    pt   : record
	    	x,y: real
	    end;
	    achse: record
	    	amin,
	    	amax    : real;
	    	ticks,
	    	subticks: longint
	    end;

	function bwrite(buf: pointer; count: longint): boolean;

		begin
			if fwrite(hdl,count,buf)=count then bwrite:=false
			else
				begin
					res:=-1;
					bwrite:=true
				end
		end;

	function cell2txt: string;

		begin
			case cell^.Typ of
			CTYPE_TEXT:
				cell2txt:=cell^.Data.Txt^+#0;
			CTYPE_CONST:
				cell2txt:=p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil)+#0;
			CTYPE_FORMULA:
				cell2txt:=p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil)+#0
			else
				cell2txt:=#0
			end
		end;

	function GetCellValue: real;

		begin
			if (cell^.Typ<>CTYPE_FORMULA) and (cell^.Typ<>CTYPE_CONST) then GetCellValue:=HUGE_VAL
			else
				GetCellValue:=p^.GetCellValue(cell,false)
		end;

	begin
		CreateDiagram:=false;
		if Application^.Multitasking and emb then
			if Application^.OLGAManager<0 then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_GENERAL_OLGA,BUTTON_OK);
					exit
				end;
		p:=PCalcWindow(Parent);
		lr.x:=20000;
		lr.y:=20000;
		lr.w:=round(atof(p^.diagrammbuf.szWidth)*1000.0);
		lr.h:=round(atof(p^.diagrammbuf.szHeight)*1000.0);
		if not(p^.GetBlock(p^.dblock^.GetText,false,rs,cs,re,ce,dummy,dummy)) then exit;
		almin:=atof(p^.diagrammbuf.AlMin);
		almax:=atof(p^.diagrammbuf.AlMax);
		aumin:=atof(p^.diagrammbuf.AuMin);
		aumax:=atof(p^.diagrammbuf.AuMax);
		if p^.diagrammbuf.nRow=bf_Checked then
			begin
				if re<=rs then
					begin
						Application^.Alert(@self,1,NOTE,MESSAGE_DIAGRAM_ROWS,BUTTON_OK);
						exit
					end;
				rowl:=1
			end
		else
			rowl:=0;
		if p^.diagrammbuf.nColumn=bf_Checked then
			begin
				if ce<=cs then
					begin
						Application^.Alert(@self,1,NOTE,MESSAGE_DIAGRAM_COLUMNS,BUTTON_OK);
						exit
					end;
				coll:=1
			end
		else
			coll:=0;
		if p^.diagrammbuf.typKreis=bf_Checked then anz:=0
		else
			anz:=1;
		if (ce+1-cs-coll)*(re+1-rs-rowl)<=anz then
			begin
				Application^.Alert(@self,1,NOTE,MESSAGE_DIAGRAM_CELLS,BUTTON_OK);
				exit
			end;
		if (p^.diagrammbuf.typLinie=bf_Checked) and (p^.diagrammbuf.xyLinear=bf_Unchecked) then
			begin
				if (p^.diagrammbuf.dRows=bf_Checked) and (re-rs-rowl<1) then
					begin
						Application^.Alert(@self,1,NOTE,MESSAGE_DIAGRAM_ROWS,BUTTON_OK);
						exit
					end;
				if (p^.diagrammbuf.dColumns=bf_Checked) and (ce-cs-coll<1) then
					begin
						Application^.Alert(@self,1,NOTE,MESSAGE_DIAGRAM_COLUMNS,BUTTON_OK);
						exit
					end;
				if p^.diagrammbuf.xyAlternate=bf_Checked then
					begin
						if (p^.diagrammbuf.dRows=bf_Checked) and (((re+1-rs-rowl) mod 2)<>0) then
							begin
								Application^.Alert(@self,1,NOTE,MESSAGE_DIAGRAM_ROWEVEN,BUTTON_OK);
								exit
							end;
						if (p^.diagrammbuf.dColumns=bf_Checked) and (((ce+1-cs-coll) mod 2)<>0) then
							begin
								Application^.Alert(@self,1,NOTE,MESSAGE_DIAGRAM_COLEVEN,BUTTON_OK);
								exit
							end
					end
			end;
		BusyMouse;
		lofs:=longint(p^.Parms.Columns+1)*CELLSIZE;
		if (p^.diagrammbuf.typBalken=bf_Checked) and (p^.diagrammbuf.Stapeln=bf_Checked) then
			begin
				if p^.diagrammbuf.dColumns=bf_Checked then
					for q:=rs+rowl to re do
						begin
							cell:=p^.GetCell(q,cs+coll);
							vcmp:=0;
							for w:=cs+coll to ce do
								begin
									vcmp:=vcmp+p^.GetCellValue(cell,false);
									inc(longint(cell),CELLSIZE)
								end;
							if q=rs+rowl then
								begin
									vmin:=vcmp;
									vmax:=vcmp
								end
							else
								begin
									if vcmp>vmax then vmax:=vcmp;
									if vcmp<vmin then vmin:=vcmp
								end
						end
				else
					for w:=cs+coll to ce do
						begin
							cell:=p^.GetCell(rs+rowl,w);
							vcmp:=0;
							for q:=rs+rowl to re do
								begin
									vcmp:=vcmp+p^.GetCellValue(cell,false);
									inc(longint(cell),lofs)
								end;
							if w=cs+coll then
								begin
									vmin:=vcmp;
									vmax:=vcmp
								end
							else
								begin
									if vcmp>vmax then vmax:=vcmp;
									if vcmp<vmin then vmin:=vcmp
								end
						end
			end
		else
			if (p^.diagrammbuf.typLinie=bf_Checked) and (p^.diagrammbuf.xyFirst=bf_Checked) then
				begin
					xmin:=0;
					xmax:=0;
					if p^.diagrammbuf.dColumns=bf_Checked then
						begin
							cell:=p^.GetCell(rs+rowl,cs+coll);
							for q:=rs+rowl to re do
								begin
									if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
										begin
											xcmp:=p^.GetCellValue(cell,false);
											if q=rs+rowl then
												begin
													xmin:=xcmp;
													xmax:=xcmp
												end
											else
												begin
													if xcmp>xmax then xmax:=xcmp;
													if xcmp<xmin then xmin:=xcmp
												end
										end;
									inc(longint(cell),lofs)
								end;
							cof:=1;
							rof:=0
						end
					else
						begin
							cell:=p^.GetCell(rs+rowl,cs+coll);
							for w:=cs+coll to ce do
								begin
									if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
										begin
											xcmp:=p^.GetCellValue(cell,false);
											if w=cs+coll then
												begin
													xmin:=xcmp;
													xmax:=xcmp
												end
											else
												begin
													if xcmp>xmax then xmax:=xcmp;
													if xcmp<xmin then xmin:=xcmp
												end
										end;
									inc(longint(cell),CELLSIZE)
								end;
							cof:=0;
							rof:=1
						end;
					vmin:=p^.GetCellValue(p^.GetCell(rs+rowl+rof,cs+coll+cof),false);
					vmax:=vmin;
					for q:=rs+rowl+rof to re do
						begin
							cell:=p^.GetCell(q,cs+coll+cof);
							for w:=cs+coll+cof to ce do
								begin
									if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
										begin
											vcmp:=p^.GetCellValue(cell,false);
											if vcmp>vmax then vmax:=vcmp;
											if vcmp<vmin then vmin:=vcmp
										end;
									inc(longint(cell),CELLSIZE)
								end
						end
				end
			else
				if (p^.diagrammbuf.typLinie=bf_Checked) and (p^.diagrammbuf.xyAlternate=bf_Checked) then
					begin
						if p^.diagrammbuf.dColumns=bf_Checked then
							begin
								{ !!! }
							end
						else
							begin
								q:=rs+rowl;
								vmin:=p^.GetCellValue(p^.GetCell(rs+rowl+1,cs+coll),false);
								vmax:=vmin;
								xmin:=p^.GetCellValue(p^.GetCell(rs+rowl,cs+coll),false);
								xmax:=xmin;
								while q<=re do
									begin
										cell:=p^.GetCell(q,cs+coll);
										cell2:=PCell(longint(cell)+lofs);
										for w:=cs+coll to ce do
											begin
												if (cell2^.Typ=CTYPE_FORMULA) or (cell2^.Typ=CTYPE_CONST) then
													begin
														vcmp:=p^.GetCellValue(cell2,false);
														if vcmp>vmax then vmax:=vcmp;
														if vcmp<vmin then vmin:=vcmp
													end;
												if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
													begin
														xcmp:=p^.GetCellValue(cell,false);
														if xcmp>xmax then xmax:=xcmp;
														if xcmp<xmin then xmin:=xcmp
													end;
												inc(longint(cell),CELLSIZE);
												inc(longint(cell2),CELLSIZE)
											end;
										inc(q,2)
									end
							end
					end
				else
					if p^.diagrammbuf.typKreis=bf_Unchecked then
						begin
							vmin:=p^.GetCellValue(p^.GetCell(rs+rowl,cs+coll),false);
							vmax:=vmin;
							for q:=rs+rowl to re do
								begin
									cell:=p^.GetCell(q,cs+coll);
									for w:=cs+coll to ce do
										begin
											if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
												begin
													vcmp:=p^.GetCellValue(cell,false);
													if vcmp>vmax then vmax:=vcmp;
													if vcmp<vmin then vmin:=vcmp
												end;
											inc(longint(cell),CELLSIZE)
										end
								end
						end;
		if length(tadname)>0 then fname:=tadname
		else
			if length(p^.diagrammbuf.objFilename)=0 then
				begin
					repeat
						fname:=GetTexelTempDir+GetTempFilename
					until not(Exist(GetPath(fname)+GetFilename(fname,false)+'.tad'))
				end
			else
				fname:=p^.diagrammbuf.objFilename;
		fname:=GetPath(fname)+GetFilename(fname,false)+'.tad';
		res:=fcreate(fname,0);
		if res<0 then goto _raus;
		hdl:=integer(res);
		tag.tag_id:='TXAW';
		tag.tag_len:=0;
		tag.tag_flags:=$00000100;
		if length(tadname)=0 then tag.tag_flags:=tag.tag_flags or $00030000;
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		tag.tag_id:='BBOX';
		tag.tag_len:=sizeof(LRECT);
		tag.tag_flags:=0;
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		if bwrite(@lr,sizeof(LRECT)) then goto _error;
		tag.tag_id:='BTYP';
		tag.tag_len:=0;
		if p^.diagrammbuf.Border=bf_Checked then tag.tag_flags:=1
		else
			tag.tag_flags:=0;
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		tag.tag_id:='FTYP';
		tag.tag_len:=0;
		if p^.diagrammbuf.Farbe=bf_Checked then tag.tag_flags:=1
		else
			tag.tag_flags:=2;
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		tag.tag_id:='DPNT';
		tag.tag_len:=0;
		tag.tag_flags:=ord(',');
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		s:=p^.diagrammbuf.Titel+#0;
		tag.tag_id:='TITL';
		tag.tag_len:=length(s);
		tag.tag_flags:=0;
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		if bwrite(@s[1],length(s)) then goto _error;
		if p^.Fonts=nil then findx:=vqt_name(p^.vdiHandle,1,sd)
		else
			if (p^.diagrammbuf.Font>=0) and (p^.diagrammbuf.Font<p^.Fonts^.Count) then findx:=PFont(p^.Fonts^.At(p^.diagrammbuf.Font))^.index
			else
				findx:=vqt_name(p^.vdiHandle,1,sd);
		if p^.Fonts=nil then fsize:=10
		else
			if (p^.diagrammbuf.Font<0) or (p^.diagrammbuf.Font>=p^.Fonts^.Count) then fsize:=10
			else
				begin
					pf:=p^.Fonts^.At(p^.diagrammbuf.Font);
					if pf^.SizeCount=0 then fsize:=4+p^.diagrammbuf.Size
					else
						if (p^.diagrammbuf.Size<0) or (p^.diagrammbuf.Size>=pf^.SizeCount) then fsize:=10
						else
							fsize:=pf^.Sizes^[pf^.SizeCount-p^.diagrammbuf.Size-1]
				end;
		fsize:=fsize shl 16;
		tag.tag_id:='FONT';
		tag.tag_len:=6;
		tag.tag_flags:=1;
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		if bwrite(@findx,2) then goto _error;
		if bwrite(@fsize,4) then goto _error;
		tag.tag_flags:=14;
		if bwrite(@tag,sizeof(TTAG)) then goto _error;
		if bwrite(@findx,2) then goto _error;
		anz:=0;
		if bwrite(@anz,4) then goto _error;
		if p^.diagrammbuf.typKreis=bf_Checked then
			begin
				vmax:=0.0;
				anz:=0;
				if p^.diagrammbuf.Absolut=bf_Checked then tag.tag_flags:=2
				else
					tag.tag_flags:=0;
				tag.tag_len:=sizeof(longint);
				if p^.diagrammbuf.dRows=bf_Checked then
					begin
						cell:=p^.GetCell(rs+rowl,cs+coll);
						for q:=cs+coll to ce do
							begin
								if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
									begin
										vmax:=vmax+abs(p^.GetCellValue(cell,false));
										inc(anz)
									end;
								inc(longint(cell),CELLSIZE)
							end;
						if p^.diagrammbuf.nRow=bf_Checked then
							if p^.diagrammbuf.Legende=bf_Checked then
								begin
									tag.tag_flags:=tag.tag_flags or $0001;
									cell:=p^.GetCell(rs,cs+coll);
									for q:=cs+coll to ce do
										begin
											inc(tag.tag_len,length(cell2txt));
											inc(longint(cell),CELLSIZE)
										end
								end
					end
				else
					begin
						cell:=p^.GetCell(rs+rowl,cs+coll);
						for w:=rs+rowl to re do
							begin
								if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
									begin
										vmax:=vmax+abs(p^.GetCellValue(cell,false));
										inc(anz)
									end;
								inc(longint(cell),lofs)
							end;
						if p^.diagrammbuf.nColumn=bf_Checked then
							if p^.diagrammbuf.Legende=bf_Checked then
								begin
									tag.tag_flags:=tag.tag_flags or $0001;
									cell:=p^.GetCell(rs+rowl,cs);
									for w:=rs+rowl to re do
										begin
											inc(tag.tag_len,length(cell2txt));
											inc(longint(cell),lofs)
										end
								end
					end;
				if vmax=0.0 then anz:=0;
				tag.tag_id:='PPIE';
				inc(tag.tag_len,(2*anz+1)*sizeof(real));
				if bwrite(@tag,sizeof(TTAG)) then goto _error;
				if bwrite(@anz,sizeof(longint)) then goto _error;
				vcmp:=0.0;
				if bwrite(@vcmp,sizeof(real)) then goto _error;
				if anz>0 then
					begin
						if p^.diagrammbuf.dRows=bf_Checked then
							begin
								cell:=p^.GetCell(rs+rowl,cs+coll);
								for q:=cs+coll to ce do
									begin
										if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
											begin
												vcmp:=p^.GetCellValue(cell,false);
												vmin:=3600*abs(vcmp)/vmax;
												if bwrite(@vmin,sizeof(real)) then goto _error;
												if bwrite(@vcmp,sizeof(real)) then goto _error
											end;
										inc(longint(cell),CELLSIZE)
									end;
								if p^.diagrammbuf.nRow=bf_Checked then
									if p^.diagrammbuf.Legende=bf_Checked then
										begin
											cell:=p^.GetCell(rs,cs+coll);
											for q:=cs+coll to ce do
												begin
													s:=cell2txt;
													if bwrite(@s[1],length(s)) then goto _error;
													inc(longint(cell),CELLSIZE)
												end
										end
							end
						else
							begin
								cell:=p^.GetCell(rs+rowl,cs+coll);
								for w:=rs+rowl to re do
									begin
										if (cell^.Typ=CTYPE_FORMULA) or (cell^.Typ=CTYPE_CONST) then
											begin
												vcmp:=p^.GetCellValue(cell,false);
												vmin:=3600*abs(vcmp)/vmax;
												if bwrite(@vmin,sizeof(real)) then goto _error;
												if bwrite(@vcmp,sizeof(real)) then goto _error
											end;
										inc(longint(cell),lofs)
									end;
								if p^.diagrammbuf.nColumn=bf_Checked then
									if p^.diagrammbuf.Legende=bf_Checked then
										begin
											cell:=p^.GetCell(rs+rowl,cs);
											for w:=rs+rowl to re do
												begin
													s:=cell2txt;
													if bwrite(@s[1],length(s)) then goto _error;
													inc(longint(cell),lofs)
												end
										end
							end
					end
			end
		else
			begin
				{ linear/first/alternate !!! }
				s:=p^.diagrammbuf.alName+#0;
				tag.tag_id:='AXIS';
				tag.tag_len:=sizeof(achse)+length(s);
				tag.tag_flags:=$00030000;
				if bwrite(@tag,sizeof(TTAG)) then goto _error;
				if almin<>almax then
					begin
						if almin>almax then
							begin
								vmin:=almax;
								vmax:=almin
							end
						else
							begin
								vmin:=almin;
								vmax:=almax
							end
					end;
				if p^.diagrammbuf.typBalken=bf_Checked then
					begin
						if (vmin>0) and (vmax>0) then vmin:=0
						else
							if (vmin<0) and (vmax<0) then vmax:=0
					end;
				achse.amin:=vmin;
				achse.amax:=vmax;
				if p^.diagrammbuf.Ticks=bf_Checked then
					begin
						achse.ticks:=atol(p^.diagrammbuf.numTicks)+2;
						achse.amax:=achse.amin+int((achse.amax-achse.amin)/(achse.ticks-1.0)+0.999999999)*(achse.ticks-1.0)
					end
				else
					achse.ticks:=2;
				if p^.diagrammbuf.alTicks=bf_Checked then achse.subticks:=atol(p^.diagrammbuf.alNum)+2
				else
					achse.subticks:=2;
				if bwrite(@achse,sizeof(achse)) then goto _error;
				if bwrite(@s[1],length(s)) then goto _error;
				s:=p^.diagrammbuf.auName+#0;
				tag.tag_id:='AXIS';
				tag.tag_len:=sizeof(achse)+length(s);
				tag.tag_flags:=$00010000;
				if p^.diagrammbuf.dColumns=bf_Checked then
					begin
						if p^.diagrammbuf.nColumn=bf_Checked then
							begin
								tag.tag_flags:=tag.tag_flags or $0004;
								cell:=p^.GetCell(rs+rowl,cs);
								for q:=rs+rowl to re do
									begin
										inc(tag.tag_len,length(cell2txt));
										inc(longint(cell),lofs)
									end
							end;
						if bwrite(@tag,sizeof(TTAG)) then goto _error;
						if aumin<>aumax then
							begin
								if aumin>aumax then
									begin
										achse.amin:=aumax;
										achse.amax:=aumin
									end
								else
									begin
										achse.amin:=aumin;
										achse.amax:=aumax
									end
							end
						else
							begin
								achse.amin:=0.0;
								achse.amax:=re+2-rs-rowl
							end;
						achse.ticks:=re+3-rs-rowl;
						if p^.diagrammbuf.auTicks=bf_Checked then achse.subticks:=atol(p^.diagrammbuf.auNum)+2
						else
							achse.subticks:=2;
						if bwrite(@achse,sizeof(achse)) then goto _error;
						if bwrite(@s[1],length(s)) then goto _error;
						if p^.diagrammbuf.nColumn=bf_Checked then
							begin
								cell:=p^.GetCell(rs+rowl,cs);
								for q:=rs+rowl to re do
									begin
										s:=cell2txt;
										if bwrite(@s[1],length(s)) then goto _error;
										inc(longint(cell),lofs)
									end
							end;
						if p^.diagrammbuf.typBalken=bf_Checked then
							begin
								tag.tag_id:='PBAR';
								if p^.diagrammbuf.DreiD=bf_Checked then tag.tag_flags:=3
								else
									if p^.diagrammbuf.Neben=bf_Checked then tag.tag_flags:=2
									else
										tag.tag_flags:=1;
								l1:=ce+1-cs-coll;
								l2:=re+1-rs-rowl;
								tag.tag_len:=2*sizeof(longint)+l1*l2*sizeof(real);
								if p^.diagrammbuf.nRow=bf_Checked then
									begin
										cell:=p^.GetCell(rs,cs+coll);
										for q:=cs+coll to ce do
											begin
												inc(tag.tag_len,length(cell2txt));
												inc(longint(cell),CELLSIZE)
											end
									end
								else
									inc(tag.tag_len,l1);
								if bwrite(@tag,sizeof(TTAG)) then goto _error;
								if bwrite(@l1,sizeof(longint)) then goto _error;
								if bwrite(@l2,sizeof(longint)) then goto _error;
								for w:=rs+rowl to re do
									begin
										cell:=p^.GetCell(w,cs+coll);
										for q:=cs+coll to ce do
											begin
												pt.y:=GetCellValue;
												if bwrite(@pt.y,sizeof(real)) then goto _error;
												inc(longint(cell),CELLSIZE)
											end
									end;
								if p^.diagrammbuf.nRow=bf_Checked then
									begin
										cell:=p^.GetCell(rs,cs+coll);
										for q:=cs+coll to ce do
											begin
												s:=cell2txt;
												if bwrite(@s[1],length(s)) then goto _error;
												inc(longint(cell),CELLSIZE)
											end
									end
								else
									begin
										s:=#0;
										for q:=cs+coll to ce do
											if bwrite(@s[1],1) then goto _error
									end
							end
						else
							for q:=cs+coll to ce do
								begin
									cell:=p^.GetCell(rs,q);
									if p^.diagrammbuf.nRow=bf_Checked then
										begin
											s:=cell2txt;
											inc(longint(cell),lofs)
										end
									else
										s:=#0;
									tag.tag_id:='P_XY';
									tag.tag_flags:=re+1-rs-rowl;
									tag.tag_len:=2*tag.tag_flags*sizeof(real)+sizeof(xy)+length(s);
									if bwrite(@tag,sizeof(TTAG)) then goto _error;
									xy[0]:=1;
									xy[1]:=3;
									if p^.diagrammbuf.xyLine=bf_Checked then xy[2]:=1
									else
										if p^.diagrammbuf.xyPt=bf_Checked then xy[2]:=2
										else
											xy[2]:=3;
									xy[3]:=p^.diagrammbuf.stilLinie+1;
									xy[4]:=p^.diagrammbuf.stilPunkt+1;
									if bwrite(@xy,sizeof(xy)) then goto _error;
									for w:=rs+rowl to re do
										begin
											pt.x:=w+1-rs-rowl;
											pt.y:=GetCellValue;
											if bwrite(@pt,sizeof(pt)) then goto _error;
											inc(longint(cell),lofs)
										end;
									if bwrite(@s[1],length(s)) then goto _error
								end
					end
				else
					begin
						if p^.diagrammbuf.nRow=bf_Checked then
							begin
								tag.tag_flags:=tag.tag_flags or $0004;
								cell:=p^.GetCell(rs,cs+coll);
								for q:=cs+coll to ce do
									begin
										inc(tag.tag_len,length(cell2txt));
										inc(longint(cell),CELLSIZE)
									end
							end;
						if bwrite(@tag,sizeof(TTAG)) then goto _error;
						if aumin<>aumax then
							begin
								if aumin>aumax then
									begin
										achse.amin:=aumax;
										achse.amax:=aumin
									end
								else
									begin
										achse.amin:=aumin;
										achse.amax:=aumax
									end
							end
						else
							begin
								achse.amin:=0.0;
								achse.amax:=ce+2-cs-coll
							end;
						achse.ticks:=ce+3-cs-coll;
						if p^.diagrammbuf.auTicks=bf_Checked then achse.subticks:=atol(p^.diagrammbuf.auNum)+2
						else
							achse.subticks:=2;
						if bwrite(@achse,sizeof(achse)) then goto _error;
						if bwrite(@s[1],length(s)) then goto _error;
						if p^.diagrammbuf.nRow=bf_Checked then
							begin
								cell:=p^.GetCell(rs,cs+coll);
								for q:=cs+coll to ce do
									begin
										s:=cell2txt;
										if bwrite(@s[1],length(s)) then goto _error;
										inc(longint(cell),CELLSIZE)
									end
							end;
						if p^.diagrammbuf.typBalken=bf_Checked then
							begin
								tag.tag_id:='PBAR';
								if p^.diagrammbuf.DreiD=bf_Checked then tag.tag_flags:=3
								else
									if p^.diagrammbuf.Neben=bf_Checked then tag.tag_flags:=2
									else
										tag.tag_flags:=1;
								l1:=re+1-rs-rowl;
								l2:=ce+1-cs-coll;
								tag.tag_len:=2*sizeof(longint)+l1*l2*sizeof(real);
								if p^.diagrammbuf.nColumn=bf_Checked then
									begin
										cell:=p^.GetCell(rs+rowl,cs);
										for q:=rs+rowl to re do
											begin
												inc(tag.tag_len,length(cell2txt));
												inc(longint(cell),lofs)
											end
									end
								else
									inc(tag.tag_len,l1);
								if bwrite(@tag,sizeof(TTAG)) then goto _error;
								if bwrite(@l1,sizeof(longint)) then goto _error;
								if bwrite(@l2,sizeof(longint)) then goto _error;
								for w:=cs+coll to ce do
									begin
										cell:=p^.GetCell(rs+rowl,w);
										for q:=rs+rowl to re do
											begin
												pt.y:=GetCellValue;
												if bwrite(@pt.y,sizeof(real)) then goto _error;
												inc(longint(cell),lofs)
											end
									end;
								if p^.diagrammbuf.nColumn=bf_Checked then
									begin
										cell:=p^.GetCell(rs+rowl,cs);
										for q:=rs+rowl to re do
											begin
												s:=cell2txt;
												if bwrite(@s[1],length(s)) then goto _error;
												inc(longint(cell),lofs)
											end
									end
								else
									begin
										s:=#0;
										for q:=rs+rowl to re do
											if bwrite(@s[1],1) then goto _error
									end
							end
						else
							for q:=rs+rowl to re do
								begin
									cell:=p^.GetCell(q,cs);
									if p^.diagrammbuf.nColumn=bf_Checked then
										begin
											s:=cell2txt;
											inc(longint(cell),CELLSIZE)
										end
									else
										s:=#0;
									tag.tag_id:='P_XY';
									tag.tag_flags:=ce+1-cs-coll;
									tag.tag_len:=2*tag.tag_flags*sizeof(real)+sizeof(xy)+length(s);
									if bwrite(@tag,sizeof(TTAG)) then goto _error;
									xy[0]:=1;
									xy[1]:=3;
									if p^.diagrammbuf.xyLine=bf_Checked then xy[2]:=1
									else
										if p^.diagrammbuf.xyPt=bf_Checked then xy[2]:=2
										else
											xy[2]:=3;
									xy[3]:=p^.diagrammbuf.stilLinie+1;
									xy[4]:=p^.diagrammbuf.stilPunkt+1;
									if bwrite(@xy,sizeof(xy)) then goto _error;
									for w:=cs+coll to ce do
										begin
											pt.x:=w+1-cs-coll;
											pt.y:=GetCellValue;
											if bwrite(@pt,sizeof(pt)) then goto _error;
											inc(longint(cell),CELLSIZE)
										end;
									if bwrite(@s[1],length(s)) then goto _error
								end
					end
			end;
		tag.tag_id:='ENDE';
		tag.tag_len:=0;
		tag.tag_flags:=255;
		bwrite(@tag,sizeof(TTAG));
		_error:
		fclose(hdl);
		if res<0 then goto _raus;
		TexelApp.FileChanged(fname);
		if Application^.Multitasking and emb then p^.EmbedNewObject(fname,0,0,0,0,0,nil,nil,@p^.diagrammbuf,false,false,false,true,true,true,false);
		if length(tadname)=0 then
			if p^.diagramm<>nil then PDiagram(p^.diagramm)^.SetFile('');
		CreateDiagram:=true;
		_raus:
		ArrowMouse
	end;


procedure TDiagrammRadio.Changed(AnIndx: integer; DblClick: boolean);

	begin
		PDiagrammDialog(Parent)^.CheckButtons
	end;


destructor TDiagrammDialog.Done;

	begin
		obic^.ob_spec.index:=obicspec;
		inherited Done
	end;


procedure TDiagrammDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk)
	end;


procedure TDiagrammDialog.CheckButtons;
	label _weiter;

	begin
		if rb1^.GetCheck=bf_Checked then
			begin
				if aendern=1 then goto _weiter;
				gb2^.Hide(false);
				gb3^.Hide(false);
				gb4^.Hide(false);
				gb5^.Hide(false);
				InitFocus;
				gb1^.Unhide;
				aendern:=1
			end
		else if rb2^.GetCheck=bf_Checked then
			begin
				if aendern=2 then goto _weiter;
				gb1^.Hide(false);
				gb3^.Hide(false);
				gb4^.Hide(false);
				gb5^.Hide(false);
				InitFocus;
				gb2^.Unhide;
				InitFocus;
				aendern:=2
			end
		else if rb3^.GetCheck=bf_Checked then
			begin
				if aendern=3 then goto _weiter;
				gb1^.Hide(false);
				gb2^.Hide(false);
				gb4^.Hide(false);
				gb5^.Hide(false);
				InitFocus;
				gb3^.Unhide;
				InitFocus;
				aendern:=3
			end
		else if rb4^.GetCheck=bf_Checked then
			begin
				if aendern=4 then goto _weiter;
				gb1^.Hide(false);
				gb2^.Hide(false);
				gb3^.Hide(false);
				gb5^.Hide(false);
				InitFocus;
				gb4^.Unhide;
				InitFocus;
				aendern:=4
			end
		else
			begin
				if aendern=5 then goto _weiter;
				gb1^.Hide(false);
				gb2^.Hide(false);
				gb3^.Hide(false);
				gb4^.Hide(false);
				InitFocus;
				gb5^.Unhide;
				InitFocus;
				aendern:=5
			end;
		_weiter:
		if rbt1^.GetCheck=bf_Checked then
			begin
				cb1^.Hide(true);
				pc3^.Hide(false);
				pc1^.Unhide;
				pc2^.Unhide;
				pdb1^.Unhide;
				pdb2^.Unhide;
				rb2^.Enable;
				obic^.ob_spec.icon_blk:=rbt1^.ObjAddr^.ob_spec.icon_blk
			end
		else if rbt2^.GetCheck=bf_Checked then
			begin
				cb1^.Disable;
				cb1^.Unhide;
				pc1^.Hide(false);
				pc2^.Hide(true);
				pdb1^.Hide(true);
				pdb2^.Hide(true);
				pc3^.Unhide;
				rb2^.Enable;
				obic^.ob_spec.icon_blk:=rbt2^.ObjAddr^.ob_spec.icon_blk
			end
		else
			begin
				cb1^.Enable;
				cb1^.Unhide;
				pc3^.Hide(true);
				pc1^.Hide(true);
				pc2^.Hide(true);
				pdb1^.Hide(true);
				pdb2^.Hide(true);
				rb2^.Disable;
				obic^.ob_spec.icon_blk:=rbt3^.ObjAddr^.ob_spec.icon_blk
			end;
		tc^.Paint
	end;


function TDiagrammDialog.ExitDlg(AnIndx: integer): boolean;
	var p: PCalcWindow;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTDITEMPDATEI:
			if p^.diagramm<>nil then PDiagram(p^.diagramm)^.SetFile('');
		RTDIDATEI:
			if p^.diagramm<>nil then
				begin
					if Application^.Multitasking then
						begin
							if XFileSelect(p,FSELTITLE_DIAGRAM,'*.cwg',TexelApp.LastPath[19],TexelApp.LastFile[19],1,FSEL_DIAGRAM,false,false) then PDiagram(p^.diagramm)^.SetFile(TexelApp.LastPath[19]+TexelApp.LastFile[19])
						end
					else
						begin
							if XFileSelect(p,FSELTITLE_TAD,'*.tad',TexelApp.LastPath[19],TexelApp.LastFile[19],1,FSEL_DIAGRAM,false,false) then PDiagram(p^.diagramm)^.SetFile(TexelApp.LastPath[19]+TexelApp.LastFile[19])
						end
				end;
		RTDIBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTDICREATETAD:
			begin
				if FileSelect(Parent,FSELTITLE_TADSAVEAS,'*.tad',TexelApp.LastPath[19],TexelApp.LastFile[19],false) then
					begin
						TransferData(tf_GetData);
						CreateDiagram(TexelApp.LastPath[19]+TexelApp.LastFile[19],false)
					end
			end;
		RTDIINSERT:
			begin
				TransferData(tf_GetData);
				CreateDiagram('',true)
			end
		end
	end;


function TDiagrammDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTDIINSERT);
		OK:=valid
	end;


procedure TDiagram.Work;
	var pb    : PButton;
	    p     : PCalcWindow;
	    pe    : PEdit;
	    pr    : PRadioButton;
	    pc    : PCheckBox;
	    fsizes: PStringCollection;
	    pfsb  : PFontSizeBox;
	    pfb   : PFontBox;

	begin
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				TexelApp.ActivateExtResource;
				ADialog:=new(PDiagrammDialog,Init(p,TEXELWINDPREFIX+TITLE_DIAGRAM,STG_DIAGRAM,ICNTITLE_DIAGRAM,RTDIAGRAM));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTDIBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
						new(PGroupBox,Init(ADialog,RTDICHANGE,GROUP_DIAGRAM_CHANGE,BUBBLE_DIAGRAM_CHANGE));
						new(PDiagrammDialog(ADialog)^.gb1,Init(ADialog,RTDIGRPTYP,'',BUBBLE_DIAGRAM_GRPTYPE));
						new(PDiagrammDialog(ADialog)^.gb2,Init(ADialog,RTDIGRPACHSE,'',BUBBLE_DIAGRAM_GRPAXIS));
						new(PDiagrammDialog(ADialog)^.gb3,Init(ADialog,RTDIGRPREIHE,'',BUBBLE_DIAGRAM_GRPDATA));
						new(PDiagrammDialog(ADialog)^.gb4,Init(ADialog,RTDIGRPLEGENDE,'',BUBBLE_DIAGRAM_GRPLEG));
						new(PDiagrammDialog(ADialog)^.gb5,Init(ADialog,RTDIGRPOBJEKT,'',BUBBLE_DIAGRAM_GRPOBJ));
						new(PDiagrammDialog(ADialog)^.bedt,Init(ADialog,RTDIBEDIT,16,false,BUBBLE_GENERAL_RANGE));
						new(PDiagrammDialog(ADialog)^.tc,Init(ADialog,RTDIPICON,''));
						new(PDiagrammDialog(ADialog)^.rb1,Init(ADialog,RTDITYP,true,BUBBLE_DIAGRAM_RTYPE));
						new(PDiagrammDialog(ADialog)^.rb2,Init(ADialog,RTDIACHSEN,true,BUBBLE_DIAGRAM_RAXIS));
						new(PDiagrammDialog(ADialog)^.rb3,Init(ADialog,RTDIREIHE,true,BUBBLE_DIAGRAM_RDATA));
						new(PDiagrammDialog(ADialog)^.rb4,Init(ADialog,RTDILEGENDE,true,BUBBLE_DIAGRAM_RLEG));
						new(PDiagrammDialog(ADialog)^.rb5,Init(ADialog,RTDIOBJEKT,true,BUBBLE_DIAGRAM_ROBJ));
						new(PDiagrammDialog(ADialog)^.rbt1,Init(ADialog,RTDILINIEN,false,BUBBLE_DIAGRAM_LINE));
						new(PDiagrammDialog(ADialog)^.rbt2,Init(ADialog,RTDIBALKEN,false,BUBBLE_DIAGRAM_BLOCK));
						new(PDiagrammDialog(ADialog)^.rbt3,Init(ADialog,RTDIKREIS,false,BUBBLE_DIAGRAM_CIRCLE));
						new(PCheckBox,Init(ADialog,RTDIFARBE,true,BUBBLE_DIAGRAM_COLOR));
						new(PDiagrammDialog(ADialog)^.cb1,Init(ADialog,RTDIVALUE,true,BUBBLE_DIAGRAM_VALUE));
						new(PDiagrammDialog(ADialog)^.pc1,Init(ADialog,RTDILGRP1,''));
						new(PDiagrammDialog(ADialog)^.pc2,Init(ADialog,RTDILGRP2,''));
						new(PDiagrammDialog(ADialog)^.pc3,Init(ADialog,RTDIBGRP,''));
						new(PRadioButton,Init(ADialog,RTDIXLINEAR,true,BUBBLE_DIAGRAM_XLINEAR));
						new(pr,Init(ADialog,RTDIX1REIHE,true,BUBBLE_DIAGRAM_X1DATA));
						if pr<>nil then pr^.Disable; { !!! }
						new(pr,Init(ADialog,RTDIXYABWECHS,true,BUBBLE_DIAGRAM_XYALT));
						if pr<>nil then pr^.Disable; { !!! }
						new(PRadioButton,Init(ADialog,RTDILLINES,true,BUBBLE_DIAGRAM_LLINES));
						new(PRadioButton,Init(ADialog,RTDILPOINTS,true,BUBBLE_DIAGRAM_LPOINTS));
						new(PRadioButton,Init(ADialog,RTDILBOTH,true,BUBBLE_DIAGRAM_LBOTH));
						new(PRadioButton,Init(ADialog,RTDISTAPELN,true,BUBBLE_DIAGRAM_STACK));
						new(PRadioButton,Init(ADialog,RTDIHINTEREIN,true,BUBBLE_DIAGRAM_BEHIND));
						new(PRadioButton,Init(ADialog,RTDINEBENEIN,true,BUBBLE_DIAGRAM_SIDE));
						new(PDiagrammDialog(ADialog)^.pdb1,Init(ADialog,RTDILINESTYLE,RTDILSCYC,RTDILSTITLE,RTPOPUPS2,RTP2LINIENSTIL,id_No,true,false,BUBBLE_DIAGRAM_LSTYLE));
						new(PDiagrammDialog(ADialog)^.pdb2,Init(ADialog,RTDIPOINTSTYLE,RTDIPSCYC,RTDIPSTITLE,RTPOPUPS2,RTP2PUNKTSTIL,id_No,true,false,BUBBLE_DIAGRAM_PSTYLE));
						new(PDiagrammDialog(ADialog)^.ed1,Init(ADialog,RTDITITEL,41,BUBBLE_DIAGRAM_TITLE));
						if PDiagrammDialog(ADialog)^.ed1<>nil then PDiagrammDialog(ADialog)^.ed1^.Clear;
						new(PCheckBox,Init(ADialog,RTDILEGENDEANZ,true,BUBBLE_DIAGRAM_LCOUNT));
						new(PCheckBox,Init(ADialog,RTDIUMRAHMEN,true,BUBBLE_DIAGRAM_BORDER));
						new(PGroupBox,Init(ADialog,RTDINAMES,GROUP_DIAGRAM_NAMESIN,BUBBLE_DIAGRAM_NAMES));
						new(PCheckBox,Init(ADialog,RTDINROW,true,BUBBLE_DIAGRAM_NROW));
						new(PCheckBox,Init(ADialog,RTDINCOL,true,BUBBLE_DIAGRAM_NCOL));
						new(pfb,InitCollection(ADialog,RTDIFONTPOP,RTDIFONTCYC,RTDIFONTTITLE,26,p^.Fonts,false,false,false,BUBBLE_DIAGRAM_FONTID));
						if pfb<>nil then
							begin
								pfb^.newsize:=-1;
								new(fsizes,Init(130,20));
								new(pfsb,InitCollection(ADialog,RTDISIZEPOP,RTDISIZECYC,RTDISIZETITLE,6,fsizes,true,false,false,BUBBLE_DIAGRAM_FONTSIZE));
								pfsb^.setsize:=true;
								pfb^.fsizebox:=pfsb;
								pfb^.Work
							end;
						new(PGroupBox,Init(ADialog,RTDIREIHEN,GROUP_DIAGRAM_DATA,BUBBLE_DIAGRAM_DATA));
						new(PRadioButton,Init(ADialog,RTDIDROWS,true,BUBBLE_DIAGRAM_DROWS));
						new(PRadioButton,Init(ADialog,RTDIDCOLUMNS,true,BUBBLE_DIAGRAM_DCOLUMNS));
						new(PGroupBox,Init(ADialog,RTDIRTICKS,'',BUBBLE_DIAGRAM_RTICKS));
						new(PCheckBox,Init(ADialog,RTDITICKS,true,BUBBLE_DIAGRAM_TICKS));
						new(PEdit,Init(ADialog,RTDINUMTICKS,3,BUBBLE_DIAGRAM_NUMTICKS));
						new(PGroupBox,Init(ADialog,RTDIAXISLEFT,GROUP_DIAGRAM_AXISLEFT,BUBBLE_DIAGRAM_AXISLEFT));
						new(PEdit,Init(ADialog,RTDIALNAME,41,BUBBLE_DIAGRAM_ALNAME));
						new(PCheckBox,Init(ADialog,RTDIALSUBTICKS,true,BUBBLE_DIAGRAM_ALSUBT));
						new(PEdit,Init(ADialog,RTDIALSUBNUM,3,BUBBLE_DIAGRAM_ALSUBNUM));
						new(PEdit,Init(ADialog,RTDIALMIN,13,BUBBLE_DIAGRAM_ALMIN));
						new(PEdit,Init(ADialog,RTDIALMAX,13,BUBBLE_DIAGRAM_ALMAX));
						new(PGroupBox,Init(ADialog,RTDIAXISBOTTOM,GROUP_DIAGRAM_AXISBOTM,BUBBLE_DIAGRAM_AXISBOTM));
						new(PEdit,Init(ADialog,RTDIAUNAME,41,BUBBLE_DIAGRAM_ABNAME));
						new(PCheckBox,Init(ADialog,RTDIAUSUBTICKS,true,BUBBLE_DIAGRAM_ABSUBT));
						new(PEdit,Init(ADialog,RTDIAUSUBNUM,3,BUBBLE_DIAGRAM_ABSUBNUM));
						new(PEdit,Init(ADialog,RTDIAUMIN,13,BUBBLE_DIAGRAM_ABMIN));
						new(PEdit,Init(ADialog,RTDIAUMAX,13,BUBBLE_DIAGRAM_ABMAX));
						new(PGroupBox,Init(ADialog,RTDISIZE,GROUP_DIAGRAM_SIZE,BUBBLE_DIAGRAM_SIZE));
						new(pe,Init(ADialog,RTDIWIDTH,7,BUBBLE_DIAGRAM_WIDTH));
						if pe<>nil then pe^.SetValidator(new(PMinMaxValidator,Init(4.0,999.99)));
						new(pe,Init(ADialog,RTDIHEIGHT,7,BUBBLE_DIAGRAM_HEIGHT));
						if pe<>nil then pe^.SetValidator(new(PMinMaxValidator,Init(4.0,999.99)));
						new(PButton,Init(ADialog,RTDIDATEI,id_No,true,BUBBLE_DIAGRAM_FILE));
						new(PDiagrammDialog(ADialog)^.pb1,Init(ADialog,RTDITEMPDATEI,id_No,true,BUBBLE_DIAGRAM_TEMPFILE));
						new(PDiagrammDialog(ADialog)^.ofname,Init(ADialog,RTDIDATEINAME,39,false,BUBBLE_DIAGRAM_FILENAME));
						new(pb,Init(ADialog,RTDIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTDIABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTDICREATETAD,id_No,true,BUBBLE_DIAGRAM_CREATAD));
						new(pb,Init(ADialog,RTDIINSERT,id_No,true,BUBBLE_DIAGRAM_INSERT));
						if pb<>nil then
							if not(Application^.Multitasking) then pb^.Disable;
						new(pb,Init(ADialog,RTDIOK,id_OK,true,BUBBLE_DIAGRAM_OK));
						if pb<>nil then
							if not(Application^.Multitasking) then pb^.Disable;
						ADialog^.TransferBuffer:=@p^.diagrammbuf;
						PDiagrammDialog(ADialog)^.aendern:=-1;
						PDiagrammDialog(ADialog)^.obic:=@ADialog^.DlgTree^[RTDIICON];
						PDiagrammDialog(ADialog)^.obicspec:=PDiagrammDialog(ADialog)^.obic^.ob_spec.index
					end;
				TexelApp.DeactivateExtResource
			end;
		if ADialog<>nil then
			begin
				PDiagrammDialog(ADialog)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
				if (length(PDiagrammDialog(ADialog)^.ed1^.GetText)=0) and (length(p^.GetWindowFilename)>0) then p^.diagrammbuf.Titel:=p^.GetRawIconTitle;
				ADialog^.TransferData(tf_SetData);
				PDiagrammDialog(ADialog)^.CheckButtons;
				ADialog^.MakeWindow;
				SetFile(p^.diagrammbuf.objFilename)
			end
	end;


procedure TDiagram.SetFile(fname: string);

	begin
		PCalcWindow(Parent)^.diagrammbuf.objFilename:=fname;
		if ADialog<>nil then
			with PDiagrammDialog(ADialog)^ do
				if ofname<>nil then
					begin
						if length(fname)=0 then
							begin
								ofname^.SetText(' ['+STRING_TEMPORARYFILE+']');
								if pb1<>nil then pb1^.Disable
							end
						else
							begin
								ofname^.SetText(CompressPath(fname,38));
								if pb1<>nil then pb1^.Enable
							end
					end
	end;


procedure TDiagram.CreateDiagramFromBlock;
	var p    : PCalcWindow;
	    old  : TDiagrammBuf;
	    cell : PCell;
	    lofs : longint;
	    q,
	    rs,cs,
	    re,ce,
	    dummy: integer;

	begin
		p:=PCalcWindow(Parent);
		if Application^.Multitasking then
			if p^.Parms.Cursor.Block then
				if p^.GetBlock(p^.dblock^.GetText,false,rs,cs,re,ce,dummy,dummy) then
					if p^.diagramm<>nil then
						begin
							if p^.diagramm^.ADialog=nil then
								begin
									p^.diagramm^.Work;
									if p^.diagramm^.ADialog<>nil then p^.diagramm^.ADialog^.WMClosed
								end;
							if p^.diagramm^.ADialog<>nil then
								with PDiagrammDialog(p^.diagramm^.ADialog)^ do
									begin
										old:=p^.diagrammbuf;
										with p^.diagrammbuf do
											begin
												typLinie:=bf_Unchecked;
												typBalken:=bf_Checked;
												typKreis:=bf_Unchecked;
												Stapeln:=bf_Unchecked;
												DreiD:=bf_Unchecked;
												Neben:=bf_Checked;
												Absolut:=bf_Checked;
												if Application^.Attr.MaxColors=2 then Farbe:=bf_Unchecked
												else
													Farbe:=bf_Checked;
												Titel:=p^.GetRawIconTitle;
												Border:=bf_Checked;
												Size:=TexelApp.setupbuffer.stdfsize;
												Font:=TexelApp.setupbuffer.stdfont;
												alName:='';
												alMin:='';
												alMax:='';
												auName:='';
												auMin:='';
												auMax:='';
												szWidth:='50.0';
												szHeight:='50.0';
												objFilename:='';
												Ticks:=bf_Checked;
												numTicks:='4';
												alTicks:=bf_Checked;
												alNum:='3';
												auTicks:=bf_Checked;
												auNum:='3';
												nRow:=bf_Unchecked;
												nColumn:=bf_Unchecked;
												dRows:=bf_Unchecked;
												dColumns:=bf_Unchecked;
												if cs=ce then
													begin
														dColumns:=bf_Checked;
														cell:=p^.GetCell(rs,cs);
														if cell^.Typ=CTYPE_TEXT then nRow:=bf_Checked
													end
												else
													if rs=re then
														begin
															dRows:=bf_Checked;
															cell:=p^.GetCell(rs,cs);
															if cell^.Typ=CTYPE_TEXT then nColumn:=bf_Checked
														end
													else
														begin
															lofs:=longint(p^.Parms.Columns+1)*CELLSIZE;
															cell:=p^.GetCell(rs,cs+1);
															for q:=cs+1 to ce do
																begin
																	if cell^.Typ=CTYPE_TEXT then
																		begin
																			nRow:=bf_Checked;
																			break
																		end;
																	inc(longint(cell),CELLSIZE)
																end;
															cell:=p^.GetCell(rs+1,cs);
															for q:=rs+1 to re do
																begin
																	if cell^.Typ=CTYPE_TEXT then
																		begin
																			nColumn:=bf_Checked;
																			break
																		end;
																	inc(longint(cell),lofs)
																end;
															cell:=p^.GetCell(rs,cs);
															if cell^.Typ=CTYPE_TEXT then
																if (nRow=bf_Unchecked) and (nColumn=bf_Unchecked) then
																	begin
																		if (ce-cs)<(re-rs) then nRow:=bf_Checked
																		else
																			nColumn:=bf_Checked
																	end;
															if (nRow=bf_Checked) and (nColumn=bf_Unchecked) then dColumns:=bf_Checked
															else
																dRows:=bf_Checked
														end;
												if (nRow=bf_Checked) or (nColumn=bf_Checked) then Legende:=bf_Checked
												else
													Legende:=bf_Unchecked;
												if (Kbshift(-1) and K_SHIFT)>0 then
													begin
														if dRows=bf_Checked then
															begin
																dRows:=bf_Unchecked;
																dColumns:=bf_Checked
															end
														else
															begin
																dRows:=bf_Checked;
																dColumns:=bf_Unchecked
															end
													end
											end;
										CreateDiagram('',true);
										p^.diagrammbuf:=old;
										exit
									end
						end;
		Application^.Bing
	end;

{$ENDIF}

end.
