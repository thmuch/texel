unit txformsh;
{ 2000-01-31 }

interface

uses

	OWindows;


type

	PFormSheet = ^TFormSheet;
	TFormSheet = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Gem,
	Objects,OTypes,OProcs,ODialogs,OValidat,
	txrsc,txlang,txtypes,txfont,txmain;


type

	PSheetDialog = ^TSheetDialog;
	TSheetDialog = object(THyperDialog)
		ed1,
		ed2: PEdit;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
	end;



procedure TFormSheet.Work;
	var pe    : PEdit;
	    fsizes: PStringCollection;
	    pfsb  : PFontSizeBox;
	    pfb   : PFontBox;
	    pc    : PCheckBox;
	    pb    : PButton;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PSheetDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_SHFORM,STG_SHFORM,ICNTITLE_SHFORM,RTFORMSHEET));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTFSSIZE,GROUP_SHEET_SIZE,BUBBLE_SHFORM_SIZE));
						new(PGroupBox,Init(ADialog,RTFSLINEAL,GROUP_SHEET_RULER,''));
						new(PGroupBox,Init(ADialog,RTFSGENERAL,GROUP_SHEET_GENERAL,''));
						new(pe,Init(ADialog,RTFSROWS,6,BUBBLE_SHFORM_ROWS));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(2,MAXLINES)));
						PSheetDialog(ADialog)^.ed1:=pe;
						new(pe,Init(ADialog,RTFSCOLUMNS,4,BUBBLE_SHFORM_COLUMNS));
						if pe<>nil then pe^.SetValidator(new(PRangeValidator,Init(2,MAXCOLUMNS)));
						PSheetDialog(ADialog)^.ed2:=pe;
						new(pfb,InitCollection(ADialog,RTFSFONTPOP,RTFSFONTCYC,RTFSFONTTITLE,26,PCalcWindow(Parent)^.Fonts,false,false,false,BUBBLE_SHFORM_FONTID));
						if pfb<>nil then
							begin
								pfb^.newsize:=-1;
								new(fsizes,Init(130,20));
								new(pfsb,InitCollection(ADialog,RTFSSIZEPOP,RTFSSIZECYC,RTFSSIZETITLE,6,fsizes,true,false,false,BUBBLE_SHFORM_FONTSIZE));
								pfsb^.setsize:=true;
								pfb^.fsizebox:=pfsb;
								pfb^.Work
							end;
						new(PCheckBox,Init(ADialog,RTFSGITTER,true,BUBBLE_SHFORM_GRID));
						new(PCheckBox,Init(ADialog,RTFSAUTOCALC,true,BUBBLE_SHFORM_AUTOCALC));
						new(PCheckBox,Init(ADialog,RTFSVORLAGE,true,BUBBLE_SHFORM_FORM));
						new(pc,Init(ADialog,RTFSLHOR,true,BUBBLE_SHFORM_HRULER));
						if pc<>nil then pc^.Disable; { ... }
						new(pc,Init(ADialog,RTFSLVERT,true,BUBBLE_SHFORM_VRULER));
						if pc<>nil then pc^.Disable; { ... }
						new(pc,Init(ADialog,RTFSLMOUSE,true,BUBBLE_SHFORM_RMOUSE));
						if pc<>nil then pc^.Disable; { ... }
						new(pc,Init(ADialog,RTFSLLAYOUT,true,BUBBLE_SHFORM_RLAYOUT));
						if pc<>nil then pc^.Disable; { ... }
						new(PCheckBox,Init(ADialog,RTFSOBJECTS,true,BUBBLE_SHFORM_OBJECTS));
						new(pc,Init(ADialog,RTFSPROTECT,true,BUBBLE_SHFORM_PROTECT));
						if pc<>nil then pc^.Disable; { ... }
						new(PCheckBox,Init(ADialog,RTFSUMBRUCH,true,BUBBLE_SHFORM_BREAK));
						new(PCheckBox,Init(ADialog,RTFSEXCELDATE,true,BUBBLE_SHFORM_EXCELDATE));
						new(PButton,Init(ADialog,RTFSCURRENT,id_No,true,BUBBLE_SHFORM_CURRENT));
						new(PButton,Init(ADialog,RTFSMINIMAL,id_No,true,BUBBLE_SHFORM_MINIMAL));
						new(pb,Init(ADialog,RTFSHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTFSOK,id_OK,true,BUBBLE_GENERAL_OK2));
						new(PButton,Init(ADialog,RTFSCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						ADialog^.TransferBuffer:=@PCalcWindow(Parent)^.sheetbuffer
					end
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;


function TSheetDialog.ExitDlg(AnIndx: integer): boolean;
	var cell: PCell;
	    p   : PCalcWindow;
	    q,w,
	    rmax,
	    cmax: integer;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTFSMINIMAL:
			begin
				cell:=p^.Sheet;
				rmax:=1;
				cmax:=1;
				for q:=0 to p^.Parms.Rows do
					for w:=0 to p^.Parms.Columns do
						begin
							if cell^.Data.Value<>0 then
								begin
									if q>rmax then rmax:=q;
									if w>cmax then cmax:=w
								end;
							inc(longint(cell),CELLSIZE)
						end;
				ed1^.SetText(ltoa(rmax+1));
				ed2^.SetText(ltoa(cmax+1))
			end;
		RTFSCURRENT:
			begin
				ed1^.SetText(ltoa(p^.Parms.Rows+1));
				ed2^.SetText(ltoa(p^.Parms.Columns+1))
			end
		end
	end;


function TSheetDialog.OK: boolean;
	label _raus,_weiter;

	var nsheet,cell,
	    ocell      : PCell;
	    osb        : TSheetBuffer;
	    nprowflags,
	    npcolflags : PByteArray;
			nprow,
			npcol      : PWordArray;
			npcolnames : PItemList;
			r,c,ro,co,
			dummy,x,y,
			lcopy,loffs,
			oloffs     : longint;
			autorecalc,
			lossy      : boolean;
			i,ww,q     : integer;
			pe         : PEmbedded;

	begin
		osb:=PCalcWindow(Parent)^.sheetbuffer;
		if inherited OK then
			begin
				with PCalcWindow(Parent)^ do
					begin
						autorecalc:=false;
						r:=atol(sheetbuffer.rows);
						c:=atol(sheetbuffer.columns);
						ro:=atol(osb.rows);
						co:=atol(osb.columns);
						if (ro<>r) or (co<>c) then
							begin
								lossy:=false;
								if r<ro then
									for y:=r to ro-1 do
										begin
											cell:=GetCell(y,0);
											for x:=0 to co-1 do
												begin
													if cell^.Data.Value<>0 then
														begin
															lossy:=true;
															goto _weiter
														end;
													inc(longint(cell),CELLSIZE)
												end
										end;
								if c<co then
									for y:=0 to ro-1 do
										begin
											cell:=GetCell(y,c);
											for x:=c to co-1 do
												begin
													if cell^.Data.Value<>0 then
														begin
															lossy:=true;
															goto _weiter
														end;
													inc(longint(cell),CELLSIZE)
												end
										end;
								_weiter:
								if lossy then
									if Application^.Alert(@self,1,NOTE,MESSAGE_WINDOW_SIZE,BUTTON_GOCANCEL)<>1 then
										begin
											sheetbuffer:=osb;
											goto _raus
										end;
								getmem(nprow,r shl 1);
								getmem(npcol,c shl 1);
								getmem(npcolnames,c shl 2);
								getmem(nprowflags,r);
								getmem(npcolflags,c);
								dummy:=r*c*CELLSIZE;
								getmem(nsheet,dummy);
								if (nprow=nil) or (npcol=nil) or (nsheet=nil) or (npcolnames=nil)  or (nprowflags=nil) or (npcolflags=nil) then
									begin
										if nprow<>nil then freemem(nprow,r shl 1);
										if npcol<>nil then freemem(npcol,c shl 1);
										if nprowflags<>nil then freemem(nprowflags,r);
										if npcolflags<>nil then freemem(npcolflags,c);
										if npcolnames<>nil then freemem(npcolnames,c shl 2);
										if nsheet<>nil then freemem(nsheet,dummy);
										sheetbuffer:=osb;
										Application^.Alert(@self,1,STOP,MESSAGE_WINDOW_SIZEERR,BUTTON_OK);
										goto _raus
									end;
								SetCursorPos(0,0,true);
								RowsClearOverflow(0,Parms.Rows,q,q);
								{ Pos/Block beibehalten ... }
								fillchar(npcolnames^,c shl 2,0);
								fillchar(npcolflags^,c,0);
								fillchar(nprowflags^,r,0);
								fillchar(nsheet^,dummy,0);
								TexelApp.InitCells(nsheet,r,c);
								if r<ro then
									begin
										system.move(PRow^,nprow^,r shl 1);
										system.move(PRowFlags^,nprowflags^,r)
									end
								else
									begin
										system.move(PRow^,nprow^,ro shl 1);
										system.move(PRowFlags^,nprowflags^,ro)
									end;
								freemem(PRow,ro shl 1);
								freemem(PRowFlags,ro);
								PRow:=nprow;
								PRowFlags:=nprowflags;
								loffs:=c*CELLSIZE;
								oloffs:=co*CELLSIZE;
								if c<co then
									begin
										system.move(PCol^,npcol^,c shl 1);
										system.move(PColNames^,npcolnames^,c shl 2);
										system.move(PColFlags^,npcolflags^,c);
										for y:=c to co-1 do DisposeStr(PString(PColNames^[y]));
										lcopy:=loffs
									end
								else
									begin
										system.move(PCol^,npcol^,co shl 1);
										system.move(PColNames^,npcolnames^,co shl 2);
										system.move(PColFlags^,npcolflags^,co);
										lcopy:=oloffs
									end;
								freemem(PColNames,co shl 2);
								freemem(PCol,co shl 1);
								freemem(PColFlags,co);
								PColNames:=npcolnames;
								PColFlags:=npcolflags;
								PCol:=npcol;
								cell:=nsheet;
								ocell:=Sheet;
								x:=Min(r,ro)-1;
								for y:=0 to x do
									begin
										system.move(ocell^,cell^,lcopy);
										inc(longint(cell),loffs);
										inc(longint(ocell),oloffs)
									end;
								if (r<ro) and (c<co) then
									begin
										FreeBlock(0,c,r-1,co-1,false);
										FreeBlock(r,0,ro-1,co-1,false)
									end
								else
									if r<ro then FreeBlock(r,0,ro-1,co-1,false)
									else
										if c<co then FreeBlock(0,c,ro-1,co-1,false);
								freemem(Sheet,ro*co*CELLSIZE);
								Sheet:=nsheet;
								Parms.Rows:=r-1;
								Parms.Columns:=c-1;
								vst_font(vdiHandle,GetStdFontIndex);
								{$IFDEF NVDI5}
								vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
								{$ELSE}
								if Speedo then vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
								else
									vst_point(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
								{$ENDIF}
								if vqt_width(vdiHandle,ord('W'),ww,i,i)<>ord('W') then ww:=Attr.charWidth;
								if r>ro then
									begin
										y:=round(longint(Attr.boxHeight)*longint(Application^.Attr.PixH)/10.0);
										for x:=ro to r-1 do SetRowHeight_mm100(x,y,false)
									end;
								if c>co then
									begin
										y:=round(longint(ww)*atol(TexelApp.setupbuffer.stdcolwidth)*longint(Application^.Attr.PixW)/10.0);
										for x:=co to c-1 do SetColWidth_mm100(x,y,false)
									end;
								SetSystemFont(vdiHandle,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
								SheetCheckOverflow;
								pe:=Embedded;
								while pe<>nil do
									begin
										if pe^.GetType=EMB_TYPE_CHECKBOX then PEmbeddedElement(pe)^.UpdateRefPointer(false);
										pe:=pe^.Next
									end;
								autorecalc:=true
							end;
						SetFont(GetStdFontIndex,GetStdFontSize);
						SetBorderSize;
						if autorecalc or (osb.exceldate<>sheetbuffer.exceldate) then AutoCalculate(true);
						ForceVRedraw;
						SetDirty
					end;
				OK:=true
			end
		else
			_raus:
			OK:=false
	end;

end.