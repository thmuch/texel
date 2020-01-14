unit txprevie;
{ 1998-08-12 }

interface

uses

	OWindows;


type

	PPreview = ^TPreview;
	TPreview = object(TKeyMenu)
		procedure Work; virtual;
		procedure Update(ForceOpen: boolean);
	end;




implementation

uses

	Tos,Gem,
	OTypes,OProcs,
	txrsc,txlang,txtypes,txmiscob,txprint,txmain;


type

	PPreviewDialog = ^TPreviewDialog;
	TPreviewDialog = object(THyperDialog)
		scale,
		pvscale,
		prcfak,
		mmkopf,
		mmfuss,
		fontfak,
		xmm100fak,
		ymm100fak,
		xmmfak,
		ymmfak   : real;
		colors,
		tw,th,
		rs,cs,
		re,ce,
		pagew,
		pageh,
		lcw,trh,
		cwidth,
		cheight,
		bwidth,
		bheight,
		wwidth,
		nwidth,
		xoffs,
		yoffs,
		xoffs2,
		yoffs2,
		rsc,csc,
		rec,cec,
		drvnum,
		devW,
		devH,
		pagenum,
		pages,
		pagex,
		pagey,
		pmaxx,
		pmaxy    : integer;
		XPixOffs,
		YPixOffs,
		printtime: longint;
		srect    : GRECT;
		st       : PStatic;
		pb1,
		pb2,
		pb3,
		pb4      : PButton;
		cb       : PPreviewBox;
		pvok,
		{$IFNDEF NVDI5}
		Speedo,
		{$ENDIF}
		colfx    : boolean;
	  ewrkout  : workout_ARRAY;
		procedure GetWindowClass(var AWndClass: TWndClass); virtual;
		function GetStyle: integer; virtual;
		function GetVDIHandle: integer; virtual;
		procedure GetWorkMax(var maxX,maxY: integer); virtual;
		procedure SetupSize; virtual;
		procedure SetupVDI; virtual;
		procedure SetupWindow; virtual;
		procedure Paint(var PaintInfo: TPaintStruct); virtual;
		function WMKeyDown(Stat,Key: integer): boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure ScanDriver(draw,ForceOpen: boolean);
		procedure Update(ForceOpen: boolean);
		procedure Shrink2Fit;
		procedure CheckButtons;
		function GetColWidth(num: integer): integer;
		function GetRowHeight(num: integer): integer;
		procedure SetFont(indx,sze: integer);
		procedure GetLcwTrh;
	end;



function TPreviewDialog.WMKeyDown(Stat,Key: integer): boolean;

	begin
		WMKeyDown:=false;
		if Stat=K_NORMAL then
			begin
				case Key of
				25641,20011:
					if pagenum<pages-1 then
						begin
							inc(pagenum);
							CheckButtons;
							WMKeyDown:=true
						end;
				25384,18989:
					if pagenum>0 then
						begin
							dec(pagenum);
							CheckButtons;
							WMKeyDown:=true
						end;
				28720:
					if pagenum>0 then
						begin
							pagenum:=0;
							CheckButtons;
							WMKeyDown:=true
						end;
				28974:
					if pagenum<pages-1 then
						begin
							pagenum:=pages-1;
							CheckButtons;
							WMKeyDown:=true
						end
				end
			end
		else
			if Stat=K_ALT then
				if Key=Alt_S then
					begin
						WMKeyDown:=true;
						if st^.GetState=bf_Enabled then ExitDlg(RTPVPAGE)
					end
	end;


procedure TPreviewDialog.GetWindowClass(var AWndClass: TWndClass);

	begin
		inherited GetWindowClass(AWndClass);
		AWndClass.hbrBackground:=White+1
	end;


function TPreviewDialog.GetStyle: integer;

	begin
		GetStyle:=inherited GetStyle or FULLER or SIZER
	end;


function TPreviewDialog.GetVDIHandle: integer;

	begin
		GetVDIHandle:=id_NewHandle
	end;


procedure TPreviewDialog.GetWorkMax(var maxX,maxY: integer);

	begin
		maxX:=pmaxx+DlgTree^[ROOT].ob_width;
		maxY:=pmaxy
	end;


procedure TPreviewDialog.SetupSize;

	begin
		pmaxx:=0;
		pmaxy:=DlgTree^[ROOT].ob_height;
		Attr.VWork.X1:=DlgTree^[ROOT].ob_width-1;
		DlgTree^[ROOT].ob_height:=Application^.Attr.MaxPY;
		drvnum:=-1;
		pvok:=false;
		TWindow.SetupSize;
		ScanDriver(false,false)
	end;


procedure TPreviewDialog.ScanDriver(draw,ForceOpen: boolean);
	label _fertig;

	var num,q,
	    ww,wh,
	    hndl   : integer;
	    wrkout : workout_ARRAY;
	    p      : PCalcWindow;
	    r      : GRECT;

	procedure clearval;

		begin
			drvnum:=-1;
			pvok:=false;
			pmaxx:=0;
			pmaxy:=DlgTree^[RTPVHELP].ob_y+DlgTree^[RTPVHELP].ob_height+8
		end;

	begin
		p:=PCalcWindow(Parent);
		if p^.prnt=nil then
			begin
				clearval;
				goto _fertig
			end;
		if not(PPrint(p^.prnt)^.IsAvailable(true)) then
			begin
				clearval;
				goto _fertig
			end;
		num:=PPrint(p^.prnt)^.GetDevice;
		if (num<11) or (num>99) then
			begin
				clearval;
				goto _fertig
			end;
		if (num=drvnum) and not(ForceOpen) then exit;
		BusyMouse;
		clearval;
		r:=SysInfo.Desktop;
		Calc(WC_WORK,r,r);
		ww:=r.W-DlgTree^[ROOT].ob_width;
		wh:=r.H;
		vOpnwk(num,hndl,wrkout,PPrint(p^.prnt)^.GetPaperSize,'',p^.wnd_prnt_set);
		if hndl<>0 then
			begin
				{ Metafile-Anpassung !!! }
				vq_extnd(hndl,1,ewrkout);
				v_clswk(hndl);
				case ewrkout[20] of
				1:
					begin
						xmmfak:=10000/ewrkout[21];
						ymmfak:=10000/ewrkout[22]
					end;
				2:
					begin
						xmmfak:=100000/ewrkout[21];
						ymmfak:=100000/ewrkout[22]
					end;
				3:
					begin
						xmmfak:=1000000/ewrkout[21];
						ymmfak:=1000000/ewrkout[22]
					end
				else
					begin
						xmmfak:=1000/wrkout[3];
						ymmfak:=1000/wrkout[4]
					end
				end;
				devW:=wrkout[0]+1;
				devH:=wrkout[1]+1;
				if (longint(devH)/longint(wh))<(longint(devW)/longint(ww)) then
					begin
						pmaxx:=ww;
						pmaxy:=round(longint(ww)*longint(devH)/longint(devW));
						pvscale:=longint(pmaxx)/longint(devW)
					end
				else
					begin
						pmaxy:=wh;
						pmaxx:=round(longint(wh)*longint(devW)/longint(devH));
						pvscale:=longint(pmaxy)/longint(devH)
					end;
				{ Treiberr„nder beachten... }
				fontfak:=longint(Application^.Attr.PixH)/longint(wrkout[4]);
				colors:=wrkout[13];
				colfx:=(colors>LWhite);
				drvnum:=num;
				pvok:=true
			end;
		ArrowMouse;
		_fertig:
		r.X:=0;
		r.Y:=0;
		GetWorkMax(r.W,r.H);
		if draw then
			begin
				Calc(WC_BORDER,r,r);
				Curr.W:=r.W;
				Curr.H:=r.H;
				Calc(WC_WORK,Curr,Work);
				WMFulled
			end
		else
			begin
				Calc(WC_BORDER,r,Curr);
				Curr.X:=(SysInfo.Desktop.W-Curr.W) shr 1;
				Curr.Y:=(SysInfo.Desktop.H-Curr.H) shr 1;
				Calc(WC_WORK,Curr,Work)
			end
	end;


procedure TPreviewDialog.SetupVDI;
	var dummy: integer;

	begin
		Attr.ExStyle:=Attr.ExStyle or ws_ex_LoadFonts;
		inherited SetupVDI;
		{$IFNDEF NVDI5}
		Speedo:=Application^.SpeedoActive;
		if Speedo then
		{$ENDIF}
			vst_kern(vdiHandle,0,1,dummy,dummy)
	end;


procedure TPreviewDialog.SetupWindow;

	begin
		inherited SetupWindow;
		Attr.ExStyle:=(Attr.ExStyle and not(ws_ex_TryModeless)) or ws_ex_Modeless;
		pagenum:=0;
		pages:=1
	end;


function TPreviewDialog.GetColWidth(num: integer): integer;

	begin
		GetColWidth:=round(longint(PCalcWindow(Parent)^.PCol^[num])*xmm100fak)+1
	end;


function TPreviewDialog.GetRowHeight(num: integer): integer;

	begin
		GetRowHeight:=round(longint(PCalcWindow(Parent)^.PRow^[num])*ymm100fak)+1
	end;


procedure TPreviewDialog.SetFont(indx,sze: integer);
	var cw,dummy: integer;

	begin
		vst_font(vdiHandle,indx);
		{$IFDEF NVDI5}
		vst_arbpt(vdiHandle,Max(round(sze*prcfak*fontfak*scale),1),cwidth,cheight,bwidth,bheight);
		{$ELSE}
		if Speedo then vst_arbpt(vdiHandle,Max(round(sze*prcfak*fontfak*scale),1),cwidth,cheight,bwidth,bheight)
		else
			vst_point(vdiHandle,Max(round(sze*prcfak*fontfak*scale),1),cwidth,cheight,bwidth,bheight);
		{$ENDIF}
		if vqt_width(vdiHandle,ord('W'),cw,dummy,dummy)=ord('W') then wwidth:=cw
		else
			wwidth:=cwidth;
		if vqt_width(vdiHandle,ord('9'),cw,dummy,dummy)=ord('9') then nwidth:=cw
		else
			nwidth:=cwidth
	end;


procedure TPreviewDialog.Paint(var PaintInfo: TPaintStruct);
	label _fertig;

	var p      : PCalcWindow;
	    pr,r,r2,
	    clip   : GRECT;
	    dummy  : integer;
	    prctemp: real;

	function xcolor(cl: integer): integer;

		begin
			if cl>=colors then xcolor:=Black
			else
				xcolor:=cl
		end;

	procedure printdoc(xoffs,yoffs,xoffs2,yoffs2: integer);
		label _nextgit,_endgit;

		var xy,xy2,xy3,xy4,
		    brd,tover        : ARRAY_4;
		    ext              : ARRAY_8;
		    clp,clp2,clp3,
		    sr,bclp          : GRECT;
		    oldlcolor,
		    q,w,b,c2,
		    oldstyle,oldcolor,
		    oldinter,tx,ty   : integer;
		    cnum,lofs        : longint;
		    title,sval       : string;
		    pe               : PEmbedded;
		    cmpval           : TOldTxtVal;
		    cell2            : PCell;

		procedure setfontattr(const tval: TTxtVal);
		
			begin
				if (tval.Font<>cmpval.oldfont) or (tval.Size<>cmpval.oldsize) then
					begin
						SetFont(tval.Font,tval.Size);
						cmpval.oldsize:=tval.Size;
						cmpval.oldfont:=tval.Font
					end
			end;
		
		procedure drawbackground;
		
			begin
				with PCell(cnum)^ do
					begin
						if Style<>oldstyle then
							begin
								vsf_style(vdiHandle,Style);
								oldstyle:=Style
							end;
						if Interior<>oldinter then
							begin
								vsf_interior(vdiHandle,Interior);
								oldinter:=Interior
							end;
						if Color<>oldcolor then
							begin
								vsf_color(vdiHandle,xcolor(Color));
								oldcolor:=Color
							end
					end;
				vr_recfl(vdiHandle,xy4)
			end;

		begin
			vst_color(vdihandle,xcolor(Black));
			vst_effects(vdihandle,TF_NORMAL);
			vst_rotation(vdihandle,0);
			{$IFNDEF NVDI5}
			if Speedo then
			{$ENDIF}
				vst_skew(vdiHandle,0);
			vst_alignment(vdiHandle,TA_LEFT,TA_BASELINE,dummy,dummy);
			vsl_udsty(vdiHandle,$5555);
			vsl_color(vdiHandle,xcolor(Black));
			vsm_height(vdihandle,1);
			SetFont(p^.GetStdFontIndex,p^.GetStdFontSize);
			vsf_color(vdiHandle,xcolor(White));
			vsf_style(vdiHandle,0);
			vsf_interior(vdiHandle,FIS_HOLLOW);
			if p^.Parms.psbuffer.hcenter=bf_Checked then
				begin
					dummy:=pagew-srect.W;
					if p^.Parms.psbuffer.rows=bf_Checked then dec(dummy,lcw);
					inc(xoffs,dummy shr 1)
				end;
			if p^.Parms.psbuffer.vcenter=bf_Checked then
				begin
					dummy:=pageh-srect.H;
					if p^.Parms.psbuffer.columns=bf_Checked then dec(dummy,trh);
					inc(yoffs,dummy shr 1)
				end;
			if (p^.Parms.psbuffer.rows=bf_Checked) and (p^.Parms.psbuffer.columns=bf_Checked) then
				begin
					xy[0]:=pr.X1+round(scale*xoffs);
					xy[1]:=pr.Y1+round(scale*yoffs);
					xy[2]:=pr.X1+round((xoffs+lcw-1)*scale);
					xy[3]:=pr.Y1+round((yoffs+trh-1)*scale);
					v_bar(vdiHandle,xy);
					if colfx then
						begin
							xy[0]:=pr.X1+round(scale*(xoffs+1));
							xy[1]:=pr.Y1+round(scale*(yoffs+1));
							vsf_interior(vdiHandle,FIS_SOLID);
							vsf_color(vdiHandle,xcolor(LWhite));
							v_bar(vdiHandle,xy);
							vsf_interior(vdiHandle,FIS_HOLLOW);
							vsf_color(vdiHandle,xcolor(Black))
						end
				end;
			vst_alignment(vdiHandle,TA_CENTER,TA_BOTTOM,dummy,dummy);
			if p^.Parms.psbuffer.rows=bf_Checked then
				begin
					w:=rs;
					clp.X:=xoffs;
					if p^.Parms.psbuffer.columns=bf_Checked then clp.Y:=yoffs+trh+1
					else
						clp.Y:=yoffs;
					clp.W:=lcw;
					clp.H:=GetRowHeight(w);
					GRtoA2(clp);
					xy[0]:=clp.X-1;
					xy[1]:=clp.Y-1;
					xy[2]:=clp.X+clp.W;
					repeat
						inc(w);
						clp2.X1:=pr.X1+round(scale*clp.X1);
						clp2.X2:=pr.X1+round(scale*clp.X2);
						clp2.Y1:=pr.Y1+round(scale*clp.Y1);
						clp2.Y2:=pr.Y1+round(scale*clp.Y2);
						A2toGR(clp2);
						if rc_intersect(clip,clp2) then
							begin
								vs_clip(vdiHandle,CLIP_ON,clp2.A2);
								xy[3]:=clp.Y2;
								xy2[0]:=pr.X1+round(scale*xy[0]);
								xy2[1]:=pr.Y1+round(scale*xy[1]);
								xy2[2]:=pr.X1+round(scale*xy[2]);
								xy2[3]:=pr.Y1+round(scale*xy[3]);
								v_bar(vdiHandle,xy2);
								dec(xy[3]);
								xy2[3]:=pr.Y1+round(scale*xy[3]);
								if colfx then
									begin
										vsf_interior(vdiHandle,FIS_SOLID);
										vsf_color(vdiHandle,xcolor(LWhite));
										inc(xy[0],2);
										inc(xy[1],2);
										xy2[0]:=pr.X1+round(scale*xy[0]);
										xy2[1]:=pr.Y1+round(scale*xy[1]);
										v_bar(vdiHandle,xy2);
										dec(xy[0],2);
										xy2[0]:=pr.X1+round(scale*xy[0]);
										vsf_interior(vdiHandle,FIS_HOLLOW);
										vsf_color(vdiHandle,xcolor(Black))
									end;
								vswr_mode(vdiHandle,MD_TRANS);
								v_gtext(vdiHandle,(xy2[0]+xy2[2]) shr 1,xy2[3],ltoa(w));
								vswr_mode(vdiHandle,MD_REPLACE);
								dec(xy2[3]);
								xy2[1]:=xy2[3];
								v_pline(vdiHandle,2,xy2)
							end;
						if w>re then break;
						clp.Y1:=clp.Y2+1;
						inc(clp.Y2,GetRowHeight(w));
						A2toGR(clp);
						xy[1]:=clp.Y-1
					until round(scale*clp.Y1)>clip.Y2;
					sr.X:=xoffs+lcw+1
				end
			else
				sr.X:=xoffs+1;
			if p^.Parms.psbuffer.columns=bf_Checked then
				begin
					q:=cs;
					if p^.Parms.psbuffer.rows=bf_Checked then clp.X:=xoffs+lcw+1
					else
						clp.X:=xoffs+1;
					clp.Y:=yoffs;
					clp.W:=GetColWidth(q)-1;
					clp.H:=trh;
					xy[0]:=clp.X-1;
					xy[1]:=clp.Y-1;
					xy[3]:=clp.Y+clp.H;
					GRtoA2(clp);
					repeat
						clp2.X1:=pr.X1+round(scale*clp.X1);
						clp2.X2:=pr.X1+round(scale*clp.X2);
						clp2.Y1:=pr.Y1+round(scale*clp.Y1);
						clp2.Y2:=pr.Y1+round(scale*clp.Y2);
						A2toGR(clp2);
						if rc_intersect(clip,clp2) then
							begin
								vs_clip(vdiHandle,CLIP_ON,clp2.A2);
								xy[2]:=clp.X2;
								xy2[0]:=pr.X1+round(scale*xy[0]);
								xy2[1]:=pr.Y1+round(scale*xy[1]);
								xy2[2]:=pr.X1+round(scale*xy[2]);
								xy2[3]:=pr.Y1+round(scale*xy[3]);
								v_bar(vdiHandle,xy);
								if colfx then
									begin
										vsf_interior(vdiHandle,FIS_SOLID);
										vsf_color(vdiHandle,xcolor(LWhite));
										inc(xy[0],2);
										inc(xy[1],2);
										dec(xy[2]);
										xy2[0]:=pr.X1+round(scale*xy[0]);
										xy2[1]:=pr.Y1+round(scale*xy[1]);
										xy2[2]:=pr.X1+round(scale*xy[2]);
										v_bar(vdiHandle,xy2);
										dec(xy[1],2);
										xy2[1]:=pr.Y1+round(scale*xy[1]);
										vsf_interior(vdiHandle,FIS_HOLLOW);
										vsf_color(vdiHandle,xcolor(Black))
									end;
								vswr_mode(vdiHandle,MD_TRANS);
								v_gtext(vdiHandle,(xy2[0]+xy2[2]) shr 1,xy2[3],p^.GetColumnName(q));
								vswr_mode(vdiHandle,MD_REPLACE);
								dec(xy2[2]);
								xy2[0]:=xy2[2];
								v_pline(vdiHandle,2,xy2)
							end;
						inc(q);
						if q>ce then break;
						clp.X1:=clp.X2+1;
						inc(clp.X2,GetColWidth(q));
						A2toGR(clp);
						xy[0]:=clp.X-1
					until round(scale*clp.X1)>clip.X2;
					sr.Y:=yoffs+trh+1
				end
			else
				sr.Y:=yoffs+1;
			w:=rs;
			clp.X:=0;
			if p^.Parms.psbuffer.columns=bf_Checked then clp.Y:=yoffs+trh+1
			else
				clp.Y:=yoffs;
			if p^.Parms.psbuffer.rows=bf_Checked then clp.W:=xoffs+lcw
			else
				clp.W:=xoffs;
			clp.H:=GetRowHeight(w);
			GRtoA2(clp);
			oldcolor:=White;
			oldlcolor:=Black;
			oldstyle:=0;
			oldinter:=FIS_HOLLOW;
			vsf_color(vdiHandle,xcolor(oldcolor));
			vsf_style(vdiHandle,oldstyle);
			vsf_interior(vdiHandle,oldinter);
			vsl_color(vdiHandle,xcolor(oldlcolor));
			with cmpval do
				begin
					oldfont:=p^.GetFontIndex;
					oldsize:=p^.GetFontSize;
					brd1w:=Max(round(Border1*prcfak*xmmfak*scale)-1,0);
					brd2w:=Max(round(Border2*prcfak*xmmfak*scale)-1,0);
					brd3w:=Max(round(Border3*prcfak*xmmfak*scale)-1,0);
					brd1h:=Max(round(Border1*prcfak*ymmfak*scale)-1,0);
					brd2h:=Max(round(Border2*prcfak*ymmfak*scale)-1,0);
					brd3h:=Max(round(Border3*prcfak*ymmfak*scale)-1,0);
					gitter:=(p^.Parms.psbuffer.gitter=bf_Checked)
				end;
			SetFont(cmpval.oldfont,cmpval.oldsize);
			p^.InitTextValues(vdiHandle,cmpval);
			lofs:=longint(p^.Parms.Columns+1)*CELLSIZE;
			repeat
				q:=cs;
				cnum:=longint(p^.Sheet)+(longint(w)*longint(p^.Parms.Columns+1)+longint(q))*CELLSIZE;
				inc(w);
				clp3.X:=clp.X2+2;
				clp3.Y:=clp.Y;
				clp3.W:=GetColWidth(q)-1;
				clp3.H:=clp.H;
				xy3[0]:=clp3.X-1;
				xy3[1]:=clp3.Y-1;
				xy3[3]:=clp3.Y+clp3.H-1;
				if cmpval.gitter then dec(xy3[3]);
				GRtoA2(clp3);
				repeat
					clp2.X1:=pr.X1+round(scale*clp3.X1);
					clp2.X2:=pr.X1+round(scale*clp3.X2);
					clp2.Y1:=pr.Y1+round(scale*clp3.Y1);
					clp2.Y2:=pr.Y1+round(scale*clp3.Y2);
					A2toGR(clp2);
					if rc_intersect(clip,clp2) then
						begin
							vs_clip(vdiHandle,CLIP_ON,clp2.A2);
							xy3[2]:=clp3.X2;
							if cmpval.gitter then
								if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then dec(xy3[2]);
							xy4[0]:=pr.X1+round(scale*xy3[0]);
							xy4[1]:=pr.Y1+round(scale*xy3[1]);
							xy4[2]:=pr.X1+round(scale*xy3[2]);
							xy4[3]:=pr.Y1+round(scale*xy3[3]);
							drawbackground;
							with PCell(cnum)^ do
								begin
									vswr_mode(vdiHandle,MD_TRANS);
									case Typ of
									CTYPE_TEXT:
										if Data.Value<>0 then
											begin
												setfontattr(TxtVal);
												p^.OutputVectorText(vdiHandle,PCell(cnum),Data.Txt^,TxtVal,cmpval,xy4,false)
											end;
									CTYPE_CONST:
										with Data.Konst^ do
											begin
												if p^.Val2Txt(Value,sval,FPts,Format,PCell(cnum)) then drawbackground;
												setfontattr(TxtVal);
												p^.OutputVectorText(vdiHandle,PCell(cnum),sval,TxtVal,cmpval,xy4,true)
											end;
									CTYPE_FORMULA:
										with Data.Formula^ do
											if Error=FE_OK then
												begin
													if p^.Val2Txt(Value,sval,FPts,Format,PCell(cnum)) then drawbackground;
													setfontattr(TxtVal);
													p^.OutputVectorText(vdiHandle,PCell(cnum),sval,TxtVal,cmpval,xy4,true)
												end
											else
												begin
													setfontattr(TxtVal);
													p^.OutputErrorText(vdiHandle,PCell(cnum),TxtVal,cmpval,xy4,Error)
												end;
									CTYPE_EMPTY:
										begin
											if bTst(TxtVal.Flags,TFL_TEXTFROMLEFT) then
												begin
													tover:=xy3;
													c2:=q;
													cell2:=PCell(cnum);
													repeat
														dec(longint(cell2),CELLSIZE);
														dec(c2);
														if c2<cs then break
														else
															begin
																tover[2]:=tover[0]-1;
																dec(tover[0],GetColWidth(c2))
															end;
													until (cell2^.TxtVal.Flags and TFL_RIGHTMASK)=TFL_TEXT2RIGHT;
													if c2>=cs then
														begin
															tover[0]:=pr.X1+round(scale*tover[0]);
															tover[1]:=pr.Y1+round(scale*tover[1]);
															tover[2]:=pr.X1+round(scale*tover[2]);
															tover[3]:=pr.Y1+round(scale*tover[3]);
															setfontattr(cell2^.TxtVal);
															p^.OutputVectorText(vdiHandle,cell2,cell2^.Data.Txt^,cell2^.TxtVal,cmpval,tover,false)
														end
												end
											else
												if bTst(TxtVal.Flags,TFL_TEXTFROMRIGHT) then
													begin
														tover:=xy3;
														c2:=q;
														cell2:=PCell(cnum);
														repeat
															inc(longint(cell2),CELLSIZE);
															inc(c2);
															if c2>ce then break
															else
																begin
																	tover[0]:=tover[2]+1;
																	inc(tover[2],GetColWidth(c2));
																	if cmpval.gitter then dec(tover[2])
																end;
														until (cell2^.TxtVal.Flags and TFL_LEFTMASK)=TFL_TEXT2LEFT;
														if c2<=ce then
															begin
																tover[0]:=pr.X1+round(scale*tover[0]);
																tover[1]:=pr.Y1+round(scale*tover[1]);
																tover[2]:=pr.X1+round(scale*tover[2]);
																tover[3]:=pr.Y1+round(scale*tover[3]);
																setfontattr(cell2^.TxtVal);
																p^.OutputVectorText(vdiHandle,cell2,cell2^.Data.Txt^,cell2^.TxtVal,cmpval,tover,false)
															end
													end
										end
									end;
									vswr_mode(vdiHandle,MD_REPLACE);
									if cmpval.gitter then
										begin
											if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then inc(xy3[2]);
											inc(xy3[3])
										end;
									with Border do
										if (Val1<>0) or (Val2<>0) then
											begin
												bclp.X1:=pr.X1+round(scale*clp3.X1)-1;
												bclp.X2:=pr.X1+round(scale*clp3.X2)-1;
												bclp.Y1:=pr.Y1+round(scale*clp3.Y1);
												bclp.Y2:=pr.Y1+round(scale*clp3.Y2);
												A2toGR(bclp);
												if rc_intersect(clip,bclp) then
													begin
														vs_clip(vdiHandle,CLIP_ON,bclp.A2);
														if Left>=16 then
															if (TxtVal.Flags and TFL_LEFTBORDER)=0 then
																begin
																	if (Left and $f)<>oldlcolor then
																		begin
																			oldlcolor:=Left and $f;
																			vsl_color(vdiHandle,xcolor(oldlcolor))
																		end;
																	if q=cs then inc(xy3[0]);
																	case (Left shr 4) of
																	1:
																		begin
																			brd[0]:=xy3[0];
																			brd[1]:=xy3[1];
																			brd[2]:=brd[0];
																			brd[3]:=xy3[3];
																			xy4[0]:=pr.X1+round(scale*brd[0]);
																			xy4[1]:=pr.Y1+round(scale*brd[1]);
																			xy4[2]:=pr.X1+round(scale*brd[2]);
																			xy4[3]:=pr.Y1+round(scale*brd[3]);
																			v_pline(vdiHandle,2,xy4)
																		end;
																	2:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[0]);
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd1w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					inc(xy4[0])
																				end
																		end;
																	3:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[0]);
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd2w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					inc(xy4[0])
																				end
																		end;
																	4:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[0]);
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd3w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					inc(xy4[0])
																				end
																		end;
																	5:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[0]);
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd1w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					inc(xy4[0])
																				end;
																			xy4[0]:=pr.X1+round(scale*xy3[0])+cmpval.brd3w;
																			for b:=0 to cmpval.brd1w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					dec(xy4[0])
																				end
																		end
																	end;
																	if q=cs then dec(xy3[0])
																end;
														if Right>=16 then
															if (TxtVal.Flags and TFL_RIGHTBORDER)=0 then
																begin
																	if (Right and $f)<>oldlcolor then
																		begin
																			oldlcolor:=Right and $f;
																			vsl_color(vdiHandle,xcolor(oldlcolor))
																		end;
																	case (Right shr 4) of
																	1:
																		begin
																			brd[0]:=xy3[2];
																			brd[1]:=xy3[1];
																			brd[2]:=brd[0];
																			brd[3]:=xy3[3];
																			xy4[0]:=pr.X1+round(scale*brd[0])-1;
																			xy4[1]:=pr.Y1+round(scale*brd[1]);
																			xy4[2]:=pr.X1+round(scale*brd[2])-1;
																			xy4[3]:=pr.Y1+round(scale*brd[3]);
																			v_pline(vdiHandle,2,xy4)
																		end;
																	2:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[2])-1;
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd1w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					dec(xy4[0])
																				end
																		end;
																	3:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[2])-1;
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd2w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					dec(xy4[0])
																				end
																		end;
																	4:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[2])-1;
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd3w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					dec(xy4[0])
																				end
																		end;
																	5:
																		begin
																			xy4[0]:=pr.X1+round(scale*xy3[2])-1;
																			xy4[1]:=pr.Y1+round(scale*xy3[1]);
																			xy4[3]:=pr.Y1+round(scale*xy3[3]);
																			for b:=0 to cmpval.brd1w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					dec(xy4[0])
																				end;
																			xy4[0]:=pr.X1+round(scale*xy3[2])-cmpval.brd3w-1;
																			for b:=0 to cmpval.brd1w do
																				begin
																					xy4[2]:=xy4[0];
																					v_pline(vdiHandle,2,xy4);
																					inc(xy4[0])
																				end
																		end
																	end
																end;
														if Top>=16 then
															begin
																if (Top and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Top and $f;
																		vsl_color(vdiHandle,xcolor(oldlcolor))
																	end;
																if w=rs+1 then inc(xy3[1]);
																case (Top shr 4) of
																1:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[1];
																		brd[2]:=xy3[2];
																		brd[3]:=brd[1];
																		xy4[0]:=pr.X1+round(scale*brd[0]);
																		xy4[1]:=pr.Y1+round(scale*brd[1]);
																		xy4[2]:=pr.X1+round(scale*brd[2]);
																		xy4[3]:=pr.Y1+round(scale*brd[3]);
																		v_pline(vdiHandle,2,xy4)
																	end;
																2:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end
																	end;
																3:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd2h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end
																	end;
																4:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd3h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end
																	end;
																5:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end;
																		xy4[1]:=pr.Y1+round(scale*xy3[1])+cmpval.brd3h;
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				dec(xy4[1])
																			end
																	end
																end;
																if w=rs+1 then dec(xy3[1])
															end;
														if Bottom>=16 then
															begin
																if (Bottom and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Bottom and $f;
																		vsl_color(vdiHandle,xcolor(oldlcolor))
																	end;
																case (Bottom shr 4) of
																1:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[3];
																		brd[2]:=xy3[2];
																		brd[3]:=brd[1];
																		xy4[0]:=pr.X1+round(scale*brd[0]);
																		xy4[1]:=pr.Y1+round(scale*brd[1])-1;
																		xy4[2]:=pr.X1+round(scale*brd[2]);
																		xy4[3]:=pr.Y1+round(scale*brd[3])-1;
																		v_pline(vdiHandle,2,xy4)
																	end;
																2:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[3])-1;
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				dec(xy4[1])
																			end
																	end;
																3:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[3])-1;
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd2h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				dec(xy4[1])
																			end
																	end;
																4:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[3])-1;
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd3h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				dec(xy4[1])
																			end
																	end;
																5:
																	begin
																		xy4[1]:=pr.Y1+round(scale*xy3[3])-1;
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				dec(xy4[1])
																			end;
																		xy4[1]:=pr.Y1+round(scale*xy3[3])-cmpval.brd3h-1;
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end
																	end
																end
															end;
														if Hor>=16 then
															begin
																if (Hor and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Hor and $f;
																		vsl_color(vdiHandle,xcolor(oldlcolor))
																	end;
																case (Hor shr 4) of
																1:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=(xy3[1]+xy3[3]) shr 1;
																		brd[2]:=xy3[2];
																		brd[3]:=brd[1];
																		xy4[0]:=pr.X1+round(scale*brd[0]);
																		xy4[1]:=pr.Y1+round(scale*brd[1]);
																		xy4[2]:=pr.X1+round(scale*brd[2]);
																		xy4[3]:=pr.Y1+round(scale*brd[3]);
																		v_pline(vdiHandle,2,xy4)
																	end;
																2:
																	begin
																		xy4[1]:=pr.Y1+round(scale*(xy3[1]+xy3[3])/2.0)-((cmpval.brd1h+1) shr 1);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end
																	end;
																3:
																	begin
																		xy4[1]:=pr.Y1+round(scale*(xy3[1]+xy3[3])/2.0)-((cmpval.brd2h+1) shr 1);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd2h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end
																	end;
																4:
																	begin
																		xy4[1]:=pr.Y1+round(scale*(xy3[1]+xy3[3])/2.0)-((cmpval.brd3h+1) shr 1);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd3h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end
																	end;
																5:
																	begin
																		xy4[1]:=pr.Y1+round(scale*(xy3[1]+xy3[3])/2.0)-((cmpval.brd3h+1) shr 1);
																		xy4[0]:=pr.X1+round(scale*xy3[0]);
																		xy4[2]:=pr.X1+round(scale*xy3[2]);
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[1])
																			end;
																		xy4[1]:=pr.Y1+round(scale*(xy3[1]+xy3[3])/2.0)+cmpval.brd3h-((cmpval.brd3h+1) shr 1);
																		for b:=0 to cmpval.brd1h do
																			begin
																				xy4[3]:=xy4[1];
																				v_pline(vdiHandle,2,xy4);
																				dec(xy4[1])
																			end
																	end
																end
															end;
														if Vert>=16 then
															begin
																if (Vert and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Vert and $f;
																		vsl_color(vdiHandle,xcolor(oldlcolor))
																	end;
																case (Vert shr 4) of
																1:
																	begin
																		brd[0]:=(xy3[0]+xy3[2]) shr 1;
																		brd[1]:=xy3[1];
																		brd[2]:=brd[0];
																		brd[3]:=xy3[3];
																		xy4[0]:=pr.X1+round(scale*brd[0]);
																		xy4[1]:=pr.Y1+round(scale*brd[1]);
																		xy4[2]:=pr.X1+round(scale*brd[2]);
																		xy4[3]:=pr.Y1+round(scale*brd[3]);
																		v_pline(vdiHandle,2,xy4)
																	end;
																2:
																	begin
																		xy4[0]:=pr.X1+round(scale*(xy3[0]+xy3[2])/2.0)-((cmpval.brd1w+1) shr 1);
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[3]:=pr.Y1+round(scale*xy3[3]);
																		for b:=0 to cmpval.brd1w do
																			begin
																				xy4[2]:=xy4[0];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[0])
																			end
																	end;
																3:
																	begin
																		xy4[0]:=pr.X1+round(scale*(xy3[0]+xy3[2])/2.0)-((cmpval.brd2w+1) shr 1);
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[3]:=pr.Y1+round(scale*xy3[3]);
																		for b:=0 to cmpval.brd2w do
																			begin
																				xy4[2]:=xy4[0];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[0])
																			end
																	end;
																4:
																	begin
																		xy4[0]:=pr.X1+round(scale*(xy3[0]+xy3[2])/2.0)-((cmpval.brd3w+1) shr 1);
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[3]:=pr.Y1+round(scale*xy3[3]);
																		for b:=0 to cmpval.brd3w do
																			begin
																				xy4[2]:=xy4[0];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[0])
																			end
																	end;
																5:
																	begin
																		xy4[0]:=pr.X1+round(scale*(xy3[0]+xy3[2])/2.0)-((cmpval.brd3w+1) shr 1);
																		xy4[1]:=pr.Y1+round(scale*xy3[1]);
																		xy4[3]:=pr.Y1+round(scale*xy3[3]);
																		for b:=0 to cmpval.brd1w do
																			begin
																				xy4[2]:=xy4[0];
																				v_pline(vdiHandle,2,xy4);
																				inc(xy4[0])
																			end;
																		xy4[0]:=pr.X1+round(scale*(xy3[0]+xy3[2])/2.0)+cmpval.brd3w-((cmpval.brd3w+1) shr 1);
																		for b:=0 to cmpval.brd1w do
																			begin
																				xy4[2]:=xy4[0];
																				v_pline(vdiHandle,2,xy4);
																				dec(xy4[0])
																			end
																	end
																end
															end;
														vs_clip(vdiHandle,CLIP_ON,clp2.A2);
													end
											end;
									if cmpval.gitter then dec(xy3[3])
								end;
							if cmpval.gitter then
								begin
									if colfx then
										begin
											if oldlcolor<>LWhite then
												begin
													vsl_color(vdiHandle,xcolor(LWhite));
													oldlcolor:=LWhite
												end
										end
									else
										begin
											if oldlcolor<>Black then
												begin
													vsl_color(vdiHandle,xcolor(Black));
													oldlcolor:=Black
												end;
											vsl_type(vdiHandle,LT_USERDEF)
										end;
									if PCell(cnum)^.Border.Right<16 then
										if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then
											begin
												if q<p^.Parms.Columns then
													if PCell(cnum+CELLSIZE)^.Border.Left>=16 then goto _nextgit;
												xy2[0]:=xy3[2];
												xy2[1]:=xy3[1];
												xy2[2]:=xy2[0];
												xy2[3]:=xy3[3]+1;
												xy4[0]:=pr.X1+round(scale*xy2[0])-1;
												xy4[1]:=pr.Y1+round(scale*xy2[1]);
												xy4[2]:=pr.X1+round(scale*xy2[2])-1;
												xy4[3]:=pr.Y1+round(scale*xy2[3]);
												v_pline(vdiHandle,2,xy4)
											end;
									_nextgit:
									if PCell(cnum)^.Border.Bottom<16 then
										begin
											if w<=p^.Parms.Rows then
												if PCell(cnum+lofs)^.Border.Top>=16 then goto _endgit;
											xy2[0]:=xy3[0];
											xy2[1]:=xy3[3]+1;
											xy2[2]:=xy3[2];
											xy2[3]:=xy2[1];
											xy4[0]:=pr.X1+round(scale*xy2[0]);
											xy4[1]:=pr.Y1+round(scale*xy2[1])-1;
											xy4[2]:=pr.X1+round(scale*xy2[2]);
											xy4[3]:=pr.Y1+round(scale*xy2[3])-1;
											v_pline(vdiHandle,2,xy4)
										end;
									_endgit:
									vsl_type(vdiHandle,LT_SOLID)
								end
							else
								dec(xy3[3]);
							if not(cmpval.gitter) then inc(xy3[3])
						end;
					inc(q);
					if q>ce then break;
					clp3.X1:=clp3.X2+1;
					inc(clp3.X2,GetColWidth(q));
					A2toGR(clp3);
					xy3[0]:=clp3.X-1;
					inc(cnum,CELLSIZE)
				until round(scale*clp3.X1)>clip.X2;
				if w>re then break;
				clp.Y1:=clp.Y2+1;
				inc(clp.Y2,GetRowHeight(w));
				A2toGR(clp)
			until round(scale*clp.Y1)>clip.Y2;
			if p^.Embedded<>nil then
				if p^.Parms.psbuffer.images=bf_Checked then
					begin
						clp.X:=pr.X1+round(scale*xoffs);
						if p^.Parms.psbuffer.rows=bf_Checked then inc(clp.X,round(scale*(lcw+1)));
						clp.Y:=pr.Y1+round(scale*yoffs);
						if p^.Parms.psbuffer.columns=bf_Checked then inc(clp.Y,round(scale*(trh+1)));
						clp.W:=round(scale*srect.W);
						clp.H:=round(scale*srect.H);
						if rc_intersect(clip,clp) then
							begin
								pe:=p^.Embedded;
								while pe<>nil do
									begin
										if pe^.CanPrint then
											begin
												pe^.SetWorkstationValues(drvnum,colors,-pr.X1-round(scale*(xoffs-XPixOffs)),-pr.Y1-round(scale*(yoffs-YPixOffs)),scale*xmm100fak,scale*ymm100fak,prcfak,fontfak*scale,bTst(ewrkout[30],1),true);
												if pe^.IsVisible(clp,false) then
													begin
														vs_clip(vdiHandle,CLIP_ON,clp.A2);
														pe^.Paint(vdiHandle,clp,false)
													end
											end;
										pe:=pe^.Next
									end
							end
					end;
			SetFont(p^.GetStdFontIndex,p^.GetStdFontSize);
			p^.RestoreTextValues(vdiHandle);
			vsl_color(vdiHandle,Black);
			vs_clip(vdiHandle,CLIP_ON,clip.A2);
			if (p^.Parms.psbuffer.columns=bf_Checked) or (p^.Parms.psbuffer.rows=bf_Checked) or cmpval.gitter then
				begin
					pxya[0]:=pr.X1+round(scale*xoffs);
					pxya[1]:=pr.Y1+round(scale*yoffs);
					pxya[2]:=xoffs+srect.X2-1;
					if p^.Parms.psbuffer.rows=bf_Checked then inc(pxya[2],lcw);
					pxya[2]:=pr.X1+round(scale*pxya[2]);
					pxya[3]:=pr.Y1+round(scale*yoffs);
					v_pline(vdiHandle,2,pxya);
					if p^.Parms.psbuffer.columns=bf_Checked then
						begin
							pxya[1]:=pr.Y1+round(scale*(yoffs+trh-1));
							pxya[3]:=pxya[1];
							v_pline(vdiHandle,2,pxya);
							pxya[1]:=pr.Y1+round(scale*(yoffs+trh+srect.Y2))
						end
					else
						pxya[1]:=pr.Y1+round(scale*(yoffs+srect.Y2));
					pxya[3]:=pxya[1];
					v_pline(vdiHandle,2,pxya);
					pxya[0]:=pr.X1+round(scale*xoffs);
					pxya[1]:=pr.Y1+round(scale*yoffs);
					pxya[2]:=pr.X1+round(scale*xoffs);
					pxya[3]:=yoffs+srect.Y2;
					if p^.Parms.psbuffer.columns=bf_Checked then inc(pxya[3],trh);
					pxya[3]:=pr.Y1+round(scale*pxya[3]);
					v_pline(vdiHandle,2,pxya);
					if p^.Parms.psbuffer.rows=bf_Checked then
						begin
							pxya[0]:=pr.X1+round(scale*(xoffs+lcw-1));
							pxya[2]:=pxya[0];
							v_pline(vdiHandle,2,pxya);
							pxya[0]:=pr.X1+round(scale*(xoffs+lcw+srect.X2-1))
						end
					else
						pxya[0]:=pr.X1+round(scale*(xoffs+srect.X2-1));
					pxya[2]:=pxya[0];
					v_pline(vdiHandle,2,pxya)
				end
		end;

	begin
		inherited Paint(PaintInfo);
		if not(pvok) then exit;
		p:=PCalcWindow(Parent);
		pr.X:=Work.X+DlgTree^[ROOT].ob_width;
		pr.Y:=Work.Y;
		pr.W:=pmaxx;
		pr.H:=pmaxy;
		GRtoA2(pr);
		pxya[0]:=pr.X-1;
		pxya[1]:=pr.Y1;
		pxya[2]:=pxya[0];
		pxya[3]:=pr.Y2;
		vsl_color(vdiHandle,xcolor(LWhite));
		v_pline(vdiHandle,2,pxya);
		r:=PaintInfo.rcPaint;
		if not(rc_intersect(pr,r)) then exit;
		vst_color(vdihandle,xcolor(Black));
		vst_effects(vdihandle,TF_NORMAL);
		vst_rotation(vdihandle,0);
		{$IFNDEF NVDI5}
		if Speedo then
		{$ENDIF}
			vst_skew(vdihandle,0);
		vst_alignment(vdihandle,TA_LEFT,TA_BASELINE,dummy,dummy);
		vsl_udsty(vdihandle,$5555);
		vsm_height(vdihandle,1);
		vsf_color(vdihandle,xcolor(White));
		vsf_style(vdihandle,0);
		vsf_interior(vdihandle,FIS_HOLLOW);
		clip.X1:=pr.X1+round(scale*xoffs);
		clip.X2:=pr.X1+round(scale*xoffs2);
		if mmkopf>0.0 then
			begin
				clip.Y1:=pr.Y1+round(atof(p^.Parms.psbuffer.oben)*ymmfak*scale);
				clip.Y2:=pr.Y1+round(yoffs*scale)-1;
				A2toGR(clip);
				r2:=r;
				if rc_intersect(clip,r2) then
					begin
						vs_clip(vdihandle,CLIP_ON,r2.A2);
						prctemp:=prcfak;
						prcfak:=1.0;
						SetFont(p^.GetStdFontIndex,p^.GetStdFontSize);
						if p^.Parms.psbuffer.hlefton=bf_Checked then p^.OutputKF(vdiHandle,clip.X1,clip.Y1,TA_LEFT,TA_TOP,pagenum,pages,printtime,p^.Parms.psbuffer.hleft);
						if p^.Parms.psbuffer.hcenteron=bf_Checked then p^.OutputKF(vdiHandle,(clip.X1+clip.X2) shr 1,clip.Y1,TA_CENTER,TA_TOP,pagenum,pages,printtime,p^.Parms.psbuffer.hmid);
						if p^.Parms.psbuffer.hrighton=bf_Checked then p^.OutputKF(vdiHandle,clip.X2,clip.Y1,TA_RIGHT,TA_TOP,pagenum,pages,printtime,p^.Parms.psbuffer.hright);
						prcfak:=prctemp
					end
			end;
		if mmfuss>0.0 then
			begin
				clip.Y1:=pr.Y1+round(scale*yoffs2)+1;
				clip.Y2:=pr.Y2-round(atof(p^.Parms.psbuffer.unten)*ymmfak*scale);
				A2toGR(clip);
				r2:=r;
				if rc_intersect(clip,r2) then
					begin
						vs_clip(vdiHandle,CLIP_ON,r2.A2);
						prctemp:=prcfak;
						prcfak:=1.0;
						SetFont(p^.GetStdFontIndex,p^.GetStdFontSize);
						if p^.Parms.psbuffer.flefton=bf_Checked then p^.OutputKF(vdiHandle,clip.X1,clip.Y2,TA_LEFT,TA_BOTTOM,pagenum,pages,printtime,p^.Parms.psbuffer.fleft);
						if p^.Parms.psbuffer.fcenteron=bf_Checked then p^.OutputKF(vdiHandle,(clip.X1+clip.X2) shr 1,clip.Y2,TA_CENTER,TA_BOTTOM,pagenum,pages,printtime,p^.Parms.psbuffer.fmid);
						if p^.Parms.psbuffer.frighton=bf_Checked then p^.OutputKF(vdiHandle,clip.X2,clip.Y2,TA_RIGHT,TA_BOTTOM,pagenum,pages,printtime,p^.Parms.psbuffer.fright);
						prcfak:=prctemp
					end
			end;
		if (rec<0) or (cec<0) then goto _fertig;
		clip.Y1:=pr.Y1+round(scale*yoffs);
		clip.Y2:=pr.Y1+round(scale*yoffs2);
		A2toGR(clip);
		if rc_intersect(r,clip) then
			begin
				vs_clip(vdiHandle,CLIP_ON,clip.A2);
				printdoc(xoffs,yoffs,xoffs2,yoffs2)
			end;
		_fertig:
		if cb^.GetCheck=bf_Checked then
			begin
				vs_clip(vdiHandle,CLIP_ON,r.A2);
				vsl_color(vdiHandle,xcolor(Black));
				vsl_type(vdiHandle,LT_USERDEF);
				pxya[0]:=pr.X1;
				pxya[1]:=pr.Y1+round(atof(p^.Parms.psbuffer.oben)*ymmfak*scale);
				pxya[2]:=pr.X2;
				pxya[3]:=pxya[1];
				v_pline(vdiHandle,2,pxya);
				pxya[0]:=pr.X1;
				pxya[1]:=pr.Y1+round(yoffs*scale)-1;
				pxya[2]:=pr.X2;
				pxya[3]:=pxya[1];
				v_pline(vdiHandle,2,pxya);
				pxya[0]:=pr.X1;
				pxya[1]:=pr.Y2-round(atof(p^.Parms.psbuffer.unten)*ymmfak*scale);
				pxya[2]:=pr.X2;
				pxya[3]:=pxya[1];
				v_pline(vdiHandle,2,pxya);
				pxya[0]:=pr.X1;
				pxya[1]:=pr.Y1+round(yoffs2*scale)+1;
				pxya[2]:=pr.X2;
				pxya[3]:=pxya[1];
				v_pline(vdiHandle,2,pxya);
				pxya[0]:=pr.X1+round(atof(p^.Parms.psbuffer.links)*xmmfak*scale);
				pxya[1]:=pr.Y1;
				pxya[2]:=pxya[0];
				pxya[3]:=pr.Y2;
				v_pline(vdiHandle,2,pxya);
				pxya[0]:=pr.X2-round(atof(p^.Parms.psbuffer.rechts)*xmmfak*scale);
				pxya[1]:=pr.Y1;
				pxya[2]:=pxya[0];
				pxya[3]:=pr.Y2;
				v_pline(vdiHandle,2,pxya);
				vsl_type(vdiHandle,LT_SOLID)
			end
	end;


function TPreviewDialog.ExitDlg(AnIndx: integer): boolean;
	var p   : PCalcWindow;
	    dbuf: string[15];
	    d   : PDialog;
	    ps  : PStatic;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTPVPAGE:
			begin
				new(d,Init(@self,'',RTPREVPAGE));
				if d<>nil then
					begin
						d^.Attr.ExStyle:=(d^.Attr.ExStyle and not(ws_ex_Center2Parent)) or ws_ex_Popup;
						new(PEdit,Init(d,RTPPINPUT,5,BUBBLE_PAGE_NEW));
						new(ps,Init(d,RTPPMAX,11,false,BUBBLE_PAGE_MAX));
						if ps<>nil then ps^.SetText('('+STRING_PAGEOF+' '+ltoa(pages)+')');
						new(PButton,Init(d,RTPPCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(d,RTPPOK,id_OK,true,BUBBLE_PAGE_OK));
						dbuf:=ltoa(pagenum+1);
						d^.TransferBuffer:=@dbuf;
						if Application^.ExecDialog(d)=RTPPOK then
							if length(StrPTrimF(dbuf))>0 then
								begin
									pagenum:=atol(StrPTrimF(dbuf))-1;
									if pagenum<0 then pagenum:=0;
									if pagenum>=pages then pagenum:=pages-1;
									CheckButtons
								end
					end
			end;
		RTPVDEC:
			if pagenum>0 then
				begin
					dec(pagenum);
					CheckButtons
				end;
		RTPVINC:
			if pagenum<pages-1 then
				begin
					inc(pagenum);
					CheckButtons
				end;
		RTPVPRINT:
			if p^.prnt<>nil then PPrint(p^.prnt)^.Display(RTPOK);
		RTPVPAPER:
			if p^.paper<>nil then p^.paper^.Work;
		RTPVFIT:
			Shrink2Fit;
		RTPV100:
			p^.SetPercent(65536.0);
		RTPVLAYOUT:
			if p^.pagesetup<>nil then p^.pagesetup^.Work
		end
	end;


procedure TPreviewDialog.Shrink2Fit;
	label _raus;
	
	var p    : PCalcWindow;
	    nprc1,
	    nprc2: real;
	    q    : integer;
	    pixw,
	    pixh : longint;

	begin
		if not(pvok) then exit;
		if (pagew<=0) or (pageh<=0) then exit;
		BusyMouse;
		p:=PCalcWindow(Parent);
		xmm100fak:=xmmfak/100;
		ymm100fak:=ymmfak/100;
		pixw:=0;
		pixh:=0;
		for q:=csc to cec do inc(pixw,GetColWidth(q));
		for q:=rsc to rec do inc(pixh,GetRowHeight(q));
		if (pixw<=0) or (pixh<=0) then goto _raus;
		prcfak:=1.0;
		GetLcwTrh;
		inc(pixw,tw);
		inc(pixh,th);
		nprc1:=pagew*65207.0/pixw;
		nprc2:=pageh*65207.0/pixh;
		if nprc1<nprc2 then p^.SetPercent(nprc1)
		else
			p^.SetPercent(nprc2);
		_raus:
		ArrowMouse
	end;


procedure TPreviewDialog.GetLcwTrh;
	var p: PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		scale:=1.0;
		SetFont(p^.GetStdFontIndex,p^.GetStdFontSize);
		lcw:=nwidth*trunc(ln(rec+2)/ln(10))+((3*nwidth) shr 1);
		trh:=bheight-1;
		if p^.Parms.psbuffer.rows=bf_Checked then tw:=lcw
		else
			tw:=0;
		if p^.Parms.psbuffer.columns=bf_Checked then th:=trh
		else
			th:=0;
	end;


procedure TPreviewDialog.Update(ForceOpen: boolean);
	label _leer,_error;

	var cell : PCell;
	    q,w,t: integer;
	    p    : PCalcWindow;
	    pe   : PEmbedded;
	    xmm,
	    ymm  : longint;

	begin
		if Attr.Status<>ws_Open then exit;
		ScanDriver(true,ForceOpen);
		if not(pvok) then
			begin
				st^.SetText(STRING_NODRIVER);
				_error:
				st^.Disable;
				pb1^.Disable;
				pb2^.Disable;
				pb3^.Disable;
				pb4^.Disable;
				scale:=pvscale;
				ForceVRedraw;
				exit
			end;
		p:=PCalcWindow(Parent);
		printtime:=gettime;
		rsc:=0;
		csc:=0;
		rec:=-1;
		cec:=-1;
		mmkopf:=atof(p^.Parms.psbuffer.kopf);
		mmfuss:=atof(p^.Parms.psbuffer.fuss);
		xoffs:=round(atof(p^.Parms.psbuffer.links)*xmmfak);
		yoffs:=round((atof(p^.Parms.psbuffer.oben)+mmkopf)*ymmfak);
		xoffs2:=devW-round(atof(p^.Parms.psbuffer.rechts)*xmmfak)-1;
		yoffs2:=devH-round((atof(p^.Parms.psbuffer.unten)+mmfuss)*ymmfak)-1;
		prcfak:=p^.GetPercent/65536.0;
		xmm100fak:=xmmfak*prcfak/100;
		ymm100fak:=ymmfak*prcfak/100;
		if (xoffs2<=xoffs) or (yoffs2<=yoffs) then
			begin
				st^.SetText(STRING_WRONGMARGINS);
				goto _error
			end;
		if p^.IsNormalPrintArea then
			begin
				cell:=p^.Sheet;
				for q:=0 to p^.Parms.Rows do
					for w:=0 to p^.Parms.Columns do
						begin
							if cell^.Typ=CTYPE_EMPTY then
								if cell^.TxtVal.Flags=0 then
									if cell^.Color=Black then
										if cell^.Style=8 then
											if cell^.Interior=FIS_HOLLOW then
												with cell^.Border do
													if Left<16 then
														if Right<16 then
															if Top<16 then
																if Bottom<16 then
																	if Hor<16 then
																		if Vert<16 then goto _leer;
							if q>rec then rec:=q;
							if w>cec then cec:=w;
							_leer:
							inc(longint(cell),CELLSIZE)
						end;
				if p^.Embedded<>nil then
					if p^.Parms.psbuffer.images=bf_Checked then
						begin
							xmm:=0;
							ymm:=0;
							pe:=p^.Embedded;
							while pe<>nil do
								begin
									if pe^.CanPrint then
										begin
											if pe^.XPos_mm100+pe^.Width_mm100>xmm then xmm:=pe^.XPos_mm100+pe^.Width_mm100;
											if pe^.YPos_mm100+pe^.Height_mm100>ymm then ymm:=pe^.YPos_mm100+pe^.Height_mm100
										end;
									pe:=pe^.Next
								end;
							if xmm>0 then
								begin
									q:=-1;
									repeat
										inc(q);
										dec(xmm,longint(p^.GetColWidth_mm100(q)))
									until (xmm<0) or (q>=p^.Parms.Columns);
									if q>cec then cec:=q
								end;
							if ymm>0 then
								begin
									w:=-1;
									repeat
										inc(w);
										dec(ymm,longint(p^.GetRowHeight_mm100(w)))
									until (ymm<0) or (w>=p^.Parms.Rows);
									if w>rec then rec:=w
								end
						end;
				if (rec<0) or (cec<0) then
					begin
						st^.SetText(STRING_PAGEEMPTY);
						goto _error
					end
			end
		else
			if p^.IsBlockPrintArea then p^.GetBlock(p^.Parms.psbuffer.bereich,false,rsc,csc,rec,cec,q,q)
			else
				p^.GetBlock(p^.dblock^.GetText,false,rsc,csc,rec,cec,q,q);
		GetLcwTrh;
		pagew:=xoffs2+1-xoffs;
		pagex:=0;
		srect.X:=tw;
		t:=csc;
		for q:=csc to cec do
			begin
				inc(srect.X,GetColWidth(q));
				if (srect.X>pagew) or bTst(p^.PColFlags^[q],CRF_UMBRUCH) then
					begin
						inc(pagex);
						if t=q then srect.X:=tw
						else
							begin
								srect.X:=tw+GetColWidth(q);
								t:=q
							end
					end
			end;
		if srect.X>tw then inc(pagex);
		pageh:=yoffs2+1-yoffs;
		pagey:=0;
		srect.Y:=th;
		t:=rsc;
		for q:=rsc to rec do
			begin
				inc(srect.Y,GetRowHeight(q));
				if (srect.Y>pageh) or bTst(p^.PRowFlags^[q],CRF_UMBRUCH) then
					begin
						inc(pagey);
						if t=q then srect.Y:=th
						else
							begin
								srect.Y:=th+GetRowHeight(q);
								t:=q
							end
					end
			end;
		if srect.Y>th then inc(pagey);
		pages:=pagex*pagey;
		if pagenum>=pages then pagenum:=pages-1;
		st^.Enable;
		CheckButtons
	end;


procedure TPreviewDialog.CheckButtons;
	label _found;

	var pgy,pgx,page,q: integer;
	    p             : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		scale:=1.0;
		re:=rsc-1;
		for pgy:=0 to pagey-1 do
			begin
				rs:=re+1;
				srect.Y:=th;
				repeat
					inc(re);
					inc(srect.Y,GetRowHeight(re))
				until (srect.Y>pageh) or (re=rec) or bTst(p^.PRowFlags^[re],CRF_UMBRUCH);
				if (re>rs) and (((re<>rec) and not(bTst(p^.PRowFlags^[re],CRF_UMBRUCH))) or (srect.Y>pageh)) then dec(re);
				ce:=csc-1;
				for pgx:=0 to pagex-1 do
					begin
						cs:=ce+1;
						srect.X:=tw;
						repeat
							inc(ce);
							inc(srect.X,GetColWidth(ce))
						until (srect.X>pagew) or (ce=cec) or bTst(p^.PColFlags^[ce],CRF_UMBRUCH);
						if (ce>cs) and (((ce<>cec) and not(bTst(p^.PColFlags^[ce],CRF_UMBRUCH))) or (srect.X>pagew)) then dec(ce);
						if p^.Parms.psbuffer.num1=bf_Checked then page:=pgy*pagex+pgx
						else
							page:=pgx*pagey+pgy;
						if page=pagenum then goto _found
					end
			end;
		_found:
		srect.X1:=0;
		srect.Y1:=0;
		srect.X2:=0;
		srect.Y2:=0;
		for q:=cs to ce do inc(srect.X2,GetColWidth(q));
		for q:=rs to re do inc(srect.Y2,GetRowHeight(q));
		A2toGR(srect);
		if p^.Parms.psbuffer.rows=bf_Checked then XPixOffs:=-lcw-1
		else
			XPixOffs:=0;
		if p^.Parms.psbuffer.columns=bf_Checked then YPixOffs:=-trh-1
		else
			YPixOffs:=0;
		if cs>0 then
			for q:=0 to cs-1 do inc(XPixOffs,GetColWidth(q));
		if rs>0 then
			for q:=0 to rs-1 do inc(YPixOffs,GetRowHeight(q));
		st^.SetText(STRING_PAGE+' '+ltoa(pagenum+1));
		if pages<1 then
			begin
				pb1^.Disable;
				pb2^.Disable;
				pb3^.Disable;
				pb4^.Disable
			end
		else
			begin
				if pagenum=0 then pb1^.Disable
				else
					pb1^.Enable;
				if pagenum=pages-1 then pb2^.Disable
				else
					pb2^.Enable;
				pb3^.Enable;
				pb4^.Enable
			end;
		scale:=pvscale;
		ForceVRedraw
	end;


procedure TPreview.Work;
	var p : PCalcWindow;
	    pb: PButton;

	begin
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				ADialog:=new(PPreviewDialog,Init(p,TEXELWINDPREFIX+TITLE_PREVIEW,STG_PREVIEW,ICNTITLE_PREVIEW,RTPREVIEW));
				if ADialog<>nil then
					begin
						new(PPreviewDialog(ADialog)^.st,Init(ADialog,RTPVPAGE,11,false,BUBBLE_PREVIEW_PAGE));
						if PPreviewDialog(ADialog)^.st<>nil then PPreviewDialog(ADialog)^.st^.Style:=PPreviewDialog(ADialog)^.st^.Style and not(sts_Fill);
						new(PPreviewDialog(ADialog)^.cb,Init(ADialog,RTPVMARGINS,true,BUBBLE_PREVIEW_MARGINS));
						new(PPreviewDialog(ADialog)^.pb1,Init(ADialog,RTPVDEC,id_No,true,BUBBLE_PREVIEW_DEC));
						new(PPreviewDialog(ADialog)^.pb2,Init(ADialog,RTPVINC,id_No,true,BUBBLE_PREVIEW_INC));
						new(pb,Init(ADialog,RTPVPAPER,id_No,true,BUBBLE_PREVIEW_PAPER));
						if not(TexelApp.ExtPrnSel(p^.wnd_prnt_set,TexelApp.app_prnt_set)) then
							if pb<>nil then pb^.Disable;
						new(PButton,Init(ADialog,RTPVPRINT,id_No,true,BUBBLE_PREVIEW_PRINT));
						new(PButton,Init(ADialog,RTPVLAYOUT,id_No,true,BUBBLE_PREVIEW_LAYOUT));
						new(PPreviewDialog(ADialog)^.pb3,Init(ADialog,RTPVFIT,id_No,true,BUBBLE_PREVIEW_SCALE));
						new(PPreviewDialog(ADialog)^.pb4,Init(ADialog,RTPV100,id_No,true,BUBBLE_PREVIEW_100));
						new(PButton,Init(ADialog,RTPVOK,id_OK,true,BUBBLE_PREVIEW_OK));
						new(pb,Init(ADialog,RTPVHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
					end
			end;
		if ADialog<>nil then
			begin
				ADialog^.MakeWindow;
				Update(false)
			end
	end;


procedure TPreview.Update(ForceOpen: boolean);

	begin
		if ADialog<>nil then PPreviewDialog(ADialog)^.Update(ForceOpen)
	end;

end.