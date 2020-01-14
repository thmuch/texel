unit txattr;
{ 1998-07-08 }

interface

uses

	OWindows,ODialogs,
	txtypes;


type

	PRahmenBox = ^TRahmenBox;
	TRahmenBox = object(TComboBox)
		function TestIndex(AnIndx: integer): boolean; virtual;
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
		procedure SetValue(Sel: integer); virtual;
	end;

	PAttrDialogs = ^TAttrDialogs;
	TAttrDialogs = object(TEvent)
		public
		constructor Init(AParent: PEventObject);
		procedure Call(num,indx: integer; cell: PCell);
		procedure ScrollToNumFormatSelection;
		private
		rahmen,
		pattern,
		colsize,
		colname,
		rowsize,
		numformats,
		textattr  : PDialog;
	end;




implementation

uses

	Gem,
	OTypes,OProcs,
	txrsc,txlang,txcollec,txvalida,txcolor,txmain;


type

	PRahmenDialog = ^TRahmenDialog;
	TRahmenDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
	end;

	PPatternDialog = ^TPatternDialog;
	TPatternDialog = object(TBlockChangeDialog)
		bedt,
		cn  : PStatic;
		pc,
		pp,
		ps  : PControl;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure Color2Name;
		procedure BlockChanged(blk: string); virtual;
	end;

	PRowSizeDialog = ^TRowSizeDialog;
	TRowSizeDialog = object(TBlockChangeDialog)
		ed1: PStatic;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
	end;

	PColSizeDialog = ^TColSizeDialog;
	TColSizeDialog = object(TBlockChangeDialog)
		ed1: PStatic;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
	end;

	PColNameDialog = ^TColNameDialog;
	TColNameDialog = object(TBlockChangeDialog)
		st1,
		st2: PStatic;
		ed1: PEdit;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
	end;

	PTextAttrDialog = ^TTextAttrDialog;
	TTextAttrDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		cb1,
		cb2,
		cb3,
		cb4,
		cb5,
		cb6 : PTriState;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
		function ChangeValues: boolean;
	end;

	PFormCategoryBox = ^TFormCategoryBox;

	PCatFormBox = ^TCatFormBox;
	TCatFormBox = object(TListBox)
		pfcb: PFormCategoryBox;
		procedure Work; virtual;
	end;

	TFormCategoryBox = object(TListBox)
		fbox   : PCatFormBox;
		flist  : PFormatCollection;
		preview: PStatic;
		format : PEdit;
		chgbtn,
		delbtn,
		okbtn,
		setbtn : PButton;
		procedure Work; virtual;
	end;

	PNumFormatsDialog = ^TNumFormatsDialog;
	TNumFormatsDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		pfcb: PFormCategoryBox;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
	end;



constructor TAttrDialogs.Init(AParent: PEventObject);

	begin
		inherited Init(AParent);
		rahmen:=nil;
		pattern:=nil;
		colsize:=nil;
		colname:=nil;
		rowsize:=nil;
		numformats:=nil;
		textattr:=nil
	end;


procedure TAttrDialogs.ScrollToNumFormatSelection;
	var sel: integer;

	begin
		if numformats=nil then exit;
		if PNumFormatsDialog(numformats)^.pfcb=nil then exit;
		if numformats^.Attr.Status<>ws_Open then exit;
		sel:=PNumFormatsDialog(numformats)^.pfcb^.GetSelection;
		if (sel<0) or (sel>1) then
			begin
				PNumFormatsDialog(numformats)^.pfcb^.SetSelection(1);
				PNumFormatsDialog(numformats)^.pfcb^.ScrollBar^.SetPosition(0)
			end
		else
			PNumFormatsDialog(numformats)^.pfcb^.Work;
		PNumFormatsDialog(numformats)^.pfcb^.fbox^.SetSelection(PNumFormatsDialog(numformats)^.pfcb^.fbox^.List^.Count-1);
		PNumFormatsDialog(numformats)^.pfcb^.fbox^.ScrollBar^.SetPosition(PNumFormatsDialog(numformats)^.pfcb^.fbox^.List^.Count)
	end;


procedure TAttrDialogs.Call(num,indx: integer; cell: PCell);
	var pe   : PEdit;
	    pc   : PTriState;
	    pcc  : PCheckBox;
	    pb   : PButton;
	    st   : PStatic;
	    pfcb : PFormCategoryBox;
	    x,y,
	    dummy: integer;
	    offs,
	    q    : longint;
	    c1,c2: PCell;
	    lfb,
	    rtb,
	    topb,
	    botb : byte;
	    lfeq,
	    rteq,
	    topeq,
	    boteq: boolean;
	    p    : PCalcWindow;

	function bequal(b1,b2: byte): boolean;
	
		begin
			bequal:=(((b1 and $0f)=(b2 and $0f)) or ((b1 shr 4)=0) or ((b2 shr 4)=0))
		end;
	
	function bcolor(b1,b2,b3,b4: byte): byte;
	
		begin
			if (b1 shr 4)>0 then bcolor:=(b1 and $0f)
			else if (b2 shr 4)>0 then bcolor:=(b2 and $0f)
			else if (b3 shr 4)>0 then bcolor:=(b3 and $0f)
			else if (b4 shr 4)>0 then bcolor:=(b4 and $0f)
			else
				bcolor:=White
		end;

	begin
		p:=PCalcWindow(Parent);
		case num of
		0:
			begin
				if textattr=nil then
					begin
						textattr:=new(PTextAttrDialog,Init(p,TEXELWINDPREFIX+TITLE_TEXTATTR,STG_TEXTATTR,ICNTITLE_TEXTATTR,RTTEXTATTR));
						if textattr<>nil then
							begin
								new(PGroupBox,Init(textattr,RTTABEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
								new(PGroupBox,Init(textattr,RTTAEFFECTS,GROUP_TEXT_FX,''));
								new(PGroupBox,Init(textattr,RTTAANGLE,GROUP_TEXT_ANGLE,''));
								new(PGroupBox,Init(textattr,RTTAALIGN,GROUP_TEXT_ALIGNMENT,''));
								new(PGroupBox,Init(textattr,RTTAMISC,GROUP_TEXT_MISC,''));
								new(PTextAttrDialog(textattr)^.bedt,Init(textattr,RTTABEDIT,16,false,BUBBLE_GENERAL_RANGE));
								new(PTextAttrDialog(textattr)^.cb1,Init(textattr,RTTABOLD,BUBBLE_TEXTATTR_BOLD));
								new(PTextAttrDialog(textattr)^.cb2,Init(textattr,RTTALIGHT,BUBBLE_TEXTATTR_LIGHT));
								new(PTextAttrDialog(textattr)^.cb3,Init(textattr,RTTAITALIC,BUBBLE_TEXTATTR_ITALIC));
								new(PTextAttrDialog(textattr)^.cb4,Init(textattr,RTTAUNDERLINED,BUBBLE_TEXTATTR_UNDERL));
								new(PTextAttrDialog(textattr)^.cb5,Init(textattr,RTTAOUTLINE,BUBBLE_TEXTATTR_OUTL));
								new(PTextAttrDialog(textattr)^.cb6,Init(textattr,RTTASHADOW,BUBBLE_TEXTATTR_SHADOW));
								new(PEdit,Init(textattr,RTTAROTAT,6,BUBBLE_TEXTATTR_ROTAT));
								new(pe,Init(textattr,RTTASKEW,6,BUBBLE_TEXTATTR_SKEW));
								{$IFNDEF NVDI5}
								if not(p^.Speedo) then
									if pe<>nil then pe^.Disable;
								{$ENDIF}
								new(PTriState,Init(textattr,RTTACLIP,BUBBLE_TEXTATTR_CLIP));
								new(PRadioButton,Init(textattr,RTTALEFT,true,BUBBLE_TEXTATTR_LEFT));
								new(PRadioButton,Init(textattr,RTTACENTER,true,BUBBLE_TEXTATTR_CENTER));
								new(PRadioButton,Init(textattr,RTTARIGHT,true,BUBBLE_TEXTATTR_RIGHT));
								new(PColorBox,Init(textattr,RTTACOLOR,RTTACOLCYC,RTTACOLTITLE,RTPOPUPS,RTPCOLOR,RTPCOLSTART,false,false,BUBBLE_TEXTATTR_COLOR));
								new(PCheckBox,Init(textattr,RTTAROTOFF,true,BUBBLE_TEXTATTR_CROTAT));
								new(pcc,Init(textattr,RTTASKEWOFF,true,BUBBLE_TEXTATTR_CSKEW));
								{$IFNDEF NVDI5}
								if not(p^.Speedo) then
									if pcc<>nil then pcc^.Disable;
								{$ENDIF}
								new(PCheckBox,Init(textattr,RTTAALIGNOFF,true,BUBBLE_TEXTATTR_CHALIGN));
								new(PCheckBox,Init(textattr,RTTACOLOFF,true,BUBBLE_TEXTATTR_CCOLOR));
								new(PCheckBox,Init(textattr,RTTAALIGNOFF2,true,BUBBLE_TEXTATTR_CVALIGN));
								new(PRadioButton,Init(textattr,RTTAOBEN,true,BUBBLE_TEXTATTR_TOP));
								new(PRadioButton,Init(textattr,RTTAMITTE,true,BUBBLE_TEXTATTR_MIDDLE));
								new(PRadioButton,Init(textattr,RTTAUNTEN,true,BUBBLE_TEXTATTR_BOTTOM));
								new(PButton,Init(textattr,RTTANONE,id_No,true,BUBBLE_TEXTATTR_FXOFF));
								new(PButton,Init(textattr,RTTAFXOFF,id_No,true,BUBBLE_TEXTATTR_FXIGNOR));
								new(pb,Init(textattr,RTTAHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(textattr,RTTACANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(textattr,RTTASET,id_No,true,BUBBLE_GENERAL_SET));
								new(PButton,Init(textattr,RTTAOK,id_OK,true,BUBBLE_GENERAL_SETOK));
								with p^.txabuffer do
									begin
										rotoff:=bf_Checked;
										skewoff:=bf_Checked;
										alignoff:=bf_Checked;
										coloff:=bf_Checked;
										alignoff2:=bf_Checked
									end;
								textattr^.TransferBuffer:=@p^.txabuffer
							end
					end;
				if textattr<>nil then
					begin
						PTextAttrDialog(textattr)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
						with p^.txabuffer do
							begin
								left:=bf_Unchecked;
								center:=bf_Unchecked;
								right:=bf_Unchecked;
								unten:=bf_Unchecked;
								mitte:=bf_Unchecked;
								oben:=bf_Unchecked
							end;
						with cell^.TxtVal do
							begin
								p^.txabuffer.rotat:=ftoa(Rotat/10);
								p^.txabuffer.skew:=ftoa(Skew/10);
								p^.txabuffer.color:=Color;
								case (Align and $0f) of
								TA_CENTER:
									p^.txabuffer.center:=bf_Checked;
								TA_RIGHT:
									p^.txabuffer.right:=bf_Checked;
								else
									p^.txabuffer.left:=bf_Checked
								end;
								case (Align and $f0) of
								TA_OBEN:
									p^.txabuffer.oben:=bf_Checked;
								TA_MITTE:
									p^.txabuffer.mitte:=bf_Checked
								else
									p^.txabuffer.unten:=bf_Checked
								end;
								if bTst(Flags,TFL_CLIP) then p^.txabuffer.clip:=bf_Checked
								else
									p^.txabuffer.clip:=bf_Unchecked;
								if bTst(Effects,TF_THICKENED) then p^.txabuffer.bold:=bf_Checked
								else
									p^.txabuffer.bold:=bf_Unchecked;
								if bTst(Effects,TF_LIGHTENED) then p^.txabuffer.light:=bf_Checked
								else
									p^.txabuffer.light:=bf_Unchecked;
								if bTst(Effects,TF_SLANTED) then p^.txabuffer.italic:=bf_Checked
								else
									p^.txabuffer.italic:=bf_Unchecked;
								if bTst(Effects,TF_UNDERLINED) then p^.txabuffer.under:=bf_Checked
								else
									p^.txabuffer.under:=bf_Unchecked;
								if bTst(Effects,TF_OUTLINED) then p^.txabuffer.outl:=bf_Checked
								else
									p^.txabuffer.outl:=bf_Unchecked;
								if bTst(Effects,TF_SHADOWED) then p^.txabuffer.shadow:=bf_Checked
								else
									p^.txabuffer.shadow:=bf_Unchecked
							end;
						if (p^.txabuffer.left=bf_Unchecked) and (p^.txabuffer.center=bf_Unchecked) and (p^.txabuffer.right=bf_Unchecked) then p^.txabuffer.left:=bf_Checked;
						textattr^.TransferData(tf_SetData);
						textattr^.MakeWindow
					end
			end;
		1:
			begin
				if numformats=nil then
					begin
						numformats:=new(PNumFormatsDialog,Init(p,TEXELWINDPREFIX+TITLE_NUMFORMAT,STG_NUMFORMAT,ICNTITLE_NUMFORMAT,RTFORMATS));
						if numformats<>nil then
							begin
								new(PGroupBox,Init(numformats,RTFBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
								new(PNumFormatsDialog(numformats)^.bedt,Init(numformats,RTFBEDIT,16,false,BUBBLE_GENERAL_RANGE));
								new(pfcb,Init(numformats,RTFCATEGORY,RTFCATSLID,RTFCATDEC,RTFCATINC,TexelApp.FormCategories,false,BUBBLE_NUMFORM_CATEGORY));
								new(pfcb^.flist,Init(75,25));
								new(pfcb^.fbox,Init(numformats,RTFFORMATS,RTFFORMSLID,RTFFORMDEC,RTFFORMINC,pfcb^.flist,true,BUBBLE_NUMFORM_FORMLIST));
								if pfcb^.fbox<>nil then pfcb^.fbox^.pfcb:=pfcb;
								new(pfcb^.format,Init(numformats,RTFFORMAT,51,BUBBLE_NUMFORM_FORMAT));
								new(pfcb^.preview,Init(numformats,RTFPREVIEW,31,false,BUBBLE_NUMFORM_PREVIEW));
								new(PButton,Init(numformats,RTFNEW,id_No,true,BUBBLE_NUMFORM_NEW));
								new(pfcb^.delbtn,Init(numformats,RTFDELETE,id_No,true,BUBBLE_NUMFORM_DELETE));
								new(pfcb^.chgbtn,Init(numformats,RTFCHANGE,id_No,true,BUBBLE_NUMFORM_CHANGE));
								new(pb,Init(numformats,RTFHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(numformats,RTFABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(pfcb^.setbtn,Init(numformats,RTFSET,id_No,true,BUBBLE_GENERAL_SET));
								new(pfcb^.okbtn,Init(numformats,RTFOK,id_OK,true,BUBBLE_GENERAL_SETOK));
								PNumFormatsDialog(numformats)^.pfcb:=pfcb;
								if pfcb<>nil then pfcb^.Work;
								with p^.nformbuffer do
									begin
										category:=0;
										frmindex:=0;
										format:=StrPTrimF(PFormat(pfcb^.fbox^.List^.At(0))^.Name^)
									end;
								numformats^.TransferBuffer:=@p^.nformbuffer
							end
					end;
				if numformats<>nil then
					begin
						PNumFormatsDialog(numformats)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
						p^.nformbuffer.category:=0;
						p^.nformbuffer.frmindex:=0;
						if cell^.Format>=1000 then p^.nformbuffer.category:=1
						else
							if cell^.Format<>0 then
								if TexelApp.Formats^.Count>0 then
									for q:=0 to TexelApp.Formats^.Count-1 do
										if PFormat(TexelApp.Formats^.At(q))^.Index=cell^.Format then
											begin
												p^.nformbuffer.category:=PFormat(TexelApp.Formats^.At(q))^.Group;
												break
											end;
						PNumFormatsDialog(numformats)^.pfcb^.SetSelection(p^.nformbuffer.category);
						PNumFormatsDialog(numformats)^.pfcb^.Work;
						if PNumFormatsDialog(numformats)^.pfcb^.fbox^.List^.Count>0 then
							for q:=0 to PNumFormatsDialog(numformats)^.pfcb^.fbox^.List^.Count-1 do
								if PFormat(PNumFormatsDialog(numformats)^.pfcb^.fbox^.List^.At(q))^.Index=cell^.Format then
									begin
										p^.nformbuffer.frmindex:=q;
										break
									end;
						PNumFormatsDialog(numformats)^.pfcb^.ScrollBar^.SetPosition(p^.nformbuffer.category);
						PNumFormatsDialog(numformats)^.pfcb^.fbox^.ScrollBar^.SetPosition(p^.nformbuffer.frmindex);
						numformats^.MakeWindow;
						PNumFormatsDialog(numformats)^.pfcb^.fbox^.Work
					end
			end;
		2:
			begin
				if rowsize=nil then
					begin
						rowsize:=new(PRowSizeDialog,Init(p,TEXELWINDPREFIX+TITLE_ROWSIZE,STG_ROWSIZE,ICNTITLE_ROWSIZE,RTROWSIZE));
						if rowsize<>nil then
							begin
								new(PRowSizeDialog(rowsize)^.ed1,Init(rowsize,RTRSROW,23,false,BUBBLE_ROWSIZE_BLOCK));
								new(pe,Init(rowsize,RTRSHEIGHT,7,BUBBLE_ROWSIZE_HEIGHT));
								if pe<>nil then pe^.SetValidator(new(PPosMaxValidator,Init(655.35)));
								new(pb,Init(rowsize,RTRSHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(rowsize,RTRSCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(rowsize,RTRSOK,id_OK,true,BUBBLE_ROWSIZE_OK));
								rowsize^.TransferBuffer:=@p^.rsbuffer
							end
					end;
				if rowsize<>nil then
					begin
						if not(p^.Parms.Cursor.Block) or (indx<p^.Parms.Cursor.RowStart) or (indx>p^.Parms.Cursor.RowEnd) or (p^.Parms.Cursor.ColStart<>0) or (p^.Parms.Cursor.ColEnd<>p^.Parms.Columns) then
						  PRowSizeDialog(rowsize)^.ed1^.SetText(STRING_ROW+': '+p^.GetRowIndex(indx))						else
							if p^.Parms.Cursor.RowStart=p^.Parms.Cursor.RowEnd then PRowSizeDialog(rowsize)^.ed1^.SetText(STRING_ROW+': '+p^.GetRowIndex(p^.Parms.Cursor.RowStart))
							else
								PRowSizeDialog(rowsize)^.ed1^.SetText(STRING_ROW+': '+p^.GetRowIndex(p^.Parms.Cursor.RowStart)+' '+STRING_ROWTO+' '+p^.GetRowIndex(p^.Parms.Cursor.RowEnd));
						p^.rsbuffer:=StrPLeft(ftoa(((p^.GetRowHeight_mm100(indx))+round(longint(Application^.Attr.PixH)/10.0))/100.0),6);
						rowsize^.TransferData(tf_SetData);
						rowsize^.MakeWindow
					end
			end;
		3:
			begin
				if colsize=nil then
					begin
						colsize:=new(PColSizeDialog,Init(p,TEXELWINDPREFIX+TITLE_COLSIZE,STG_COLSIZE,ICNTITLE_COLSIZE,RTCOLSIZE));
						if colsize<>nil then
							begin
								new(PColSizeDialog(colsize)^.ed1,Init(colsize,RTCSCOLUMN,23,false,BUBBLE_COLSIZE_BLOCK));
								new(pe,Init(colsize,RTCSWIDTH,7,BUBBLE_COLSIZE_WIDTH));
								if pe<>nil then pe^.SetValidator(new(PPosMaxValidator,Init(655.35)));
								new(pb,Init(colsize,RTCSHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(colsize,RTCSCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(colsize,RTCSOK,id_OK,true,BUBBLE_COLSIZE_OK));
								colsize^.TransferBuffer:=@p^.csbuffer
							end
					end;
				if colsize<>nil then
					begin
						if not(p^.Parms.Cursor.Block) or (indx<p^.Parms.Cursor.ColStart) or (indx>p^.Parms.Cursor.ColEnd) or (p^.Parms.Cursor.RowStart<>0) or (p^.Parms.Cursor.RowEnd<>p^.Parms.Rows) then
							PColSizeDialog(colsize)^.ed1^.SetText(STRING_COL+': '+p^.GetColumnIndex(indx))
						else
							if p^.Parms.Cursor.ColStart=p^.Parms.Cursor.ColEnd then PColSizeDialog(colsize)^.ed1^.SetText(STRING_COL+': '+p^.GetColumnIndex(p^.Parms.Cursor.ColStart))
							else
								PColSizeDialog(colsize)^.ed1^.SetText(STRING_COL+': '+p^.GetColumnIndex(p^.Parms.Cursor.ColStart)+' '+STRING_COLTO+' '+p^.GetColumnIndex(p^.Parms.Cursor.ColEnd));
						p^.csbuffer:=StrPLeft(ftoa((p^.GetColWidth_mm100(indx)+round(longint(Application^.Attr.PixW)/10.0))/100.0),6);
						colsize^.TransferData(tf_SetData);
						colsize^.MakeWindow
					end
			end;
		4:
			begin
				if colname=nil then
					begin
						colname:=new(PColNameDialog,Init(p,TEXELWINDPREFIX+TITLE_COLNAME,STG_COLNAME,ICNTITLE_COLNAME,RTCOLNAME));
						if colname<>nil then
							begin
								new(PColNameDialog(colname)^.st1,Init(colname,RTCNCOLUMN,53,false,BUBBLE_COLNAME_SEL));
								new(PColNameDialog(colname)^.st2,Init(colname,RTCNOLD,41,false,BUBBLE_COLNAME_OLD));
								if PColNameDialog(colname)^.st2<>nil then PColNameDialog(colname)^.st2^.EnableTransfer;
								new(PColNameDialog(colname)^.ed1,Init(colname,RTCNNEW,41,BUBBLE_COLNAME_NEW));
								new(pb,Init(colname,RTCNHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(colname,RTCNCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(colname,RTCNOK,id_OK,true,BUBBLE_COLNAME_OK));
								colname^.TransferBuffer:=@p^.cnbuffer
							end
					end;
				if colname<>nil then
					begin
						PColNameDialog(colname)^.st1^.SetText(STRING_COL+':     '+p^.GetColumnIndex(indx));
						with p^.cnbuffer do
							begin
								nold:=p^.GetColumnName(indx);
								nnew:=nold
							end;
						colname^.TransferData(tf_SetData);
						colname^.MakeWindow
					end
			end;
		5:
			begin
				if pattern=nil then
					begin
						pattern:=new(PPatternDialog,Init(p,TEXELWINDPREFIX+TITLE_PATTERN,STG_PATTERN,ICNTITLE_PATTERN,RTMUSTER));
						if pattern<>nil then
							begin
								new(PGroupBox,Init(pattern,RTMBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
								new(PPatternDialog(pattern)^.bedt,Init(pattern,RTMBEDIT,16,false,BUBBLE_GENERAL_RANGE));
								new(PPatternDialog(pattern)^.cn,Init(pattern,RTMCOLORNAME,16,false,BUBBLE_PATTERN_NAME));
								new(PPatternDialog(pattern)^.pc,Init(pattern,RTMCOLORS,BUBBLE_PATTERN_COLORS));
								new(PPatternDialog(pattern)^.pp,Init(pattern,RTMPATTERN,BUBBLE_PATTERN_PATTERN));
								new(PPatternDialog(pattern)^.ps,Init(pattern,RTMSHOW,BUBBLE_PATTERN_PREVIEW));
								new(pb,Init(pattern,RTMHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(pattern,RTMABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(pattern,RTMSETZEN,id_No,true,BUBBLE_GENERAL_SET));
								new(PButton,Init(pattern,RTMOK,id_OK,true,BUBBLE_GENERAL_SETOK))
							end
					end;
				if pattern<>nil then
					begin
						PPatternDialog(pattern)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
						if cell^.Interior=FIS_HOLLOW then
							begin
								with PPatternDialog(pattern)^.ps^.ObjAddr^.ob_spec do index:=(index and $ffffff8f) or (7 shl 4);
								PPatternDialog(pattern)^.ps^.SetColor(White)
							end
						else
							begin
								dummy:=cell^.Style;
								if dummy=8 then dummy:=7;
								with PPatternDialog(pattern)^.ps^.ObjAddr^.ob_spec do index:=(index and $ffffff8f) or (dummy shl 4);
								PPatternDialog(pattern)^.ps^.SetColor(cell^.Color)
							end;
						PPatternDialog(pattern)^.Color2Name;
						pattern^.MakeWindow
					end
			end;
		6:
			begin
				if rahmen=nil then
					begin
						rahmen:=new(PRahmenDialog,Init(p,TEXELWINDPREFIX+TITLE_BORDERS,STG_BORDERS,ICNTITLE_BORDERS,RTRAHMEN));
						if rahmen<>nil then
							begin
								new(PGroupBox,Init(rahmen,RTRABEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
								new(PGroupBox,Init(rahmen,RTRABREITEN,'',''));
								new(PGroupBox,Init(rahmen,RTRAZELLE,GROUP_BORDER_CELLS,''));
								new(PGroupBox,Init(rahmen,RTRAGESAMT,GROUP_BORDER_BLOCK,''));
								new(PRahmenDialog(rahmen)^.bedt,Init(rahmen,RTRABEDIT,22,false,BUBBLE_GENERAL_RANGE));
								new(PRahmenBox,Init(rahmen,RTRAGLINE,RTRAGCYC,RTRAGTITLE,RTPOPUPS,RTPBORDERS,id_No,false,false,BUBBLE_BORDER_OUTLINE));
								new(PRahmenBox,Init(rahmen,RTRAOLINE,RTRAOCYC,RTRAOTITLE,RTPOPUPS,RTPBORDERS,id_No,false,false,BUBBLE_BORDER_TOP));
								new(PRahmenBox,Init(rahmen,RTRAULINE,RTRAUCYC,RTRAUTITLE,RTPOPUPS,RTPBORDERS,id_No,false,false,BUBBLE_BORDER_BOTTOM));
								new(PRahmenBox,Init(rahmen,RTRALLINE,RTRALCYC,RTRALTITLE,RTPOPUPS,RTPBORDERS,id_No,false,false,BUBBLE_BORDER_LEFT));
								new(PRahmenBox,Init(rahmen,RTRARLINE,RTRARCYC,RTRARTITLE,RTPOPUPS,RTPBORDERS,id_No,false,false,BUBBLE_BORDER_RIGHT));
								new(PRahmenBox,Init(rahmen,RTRAHLINE,RTRAHCYC,RTRAHTITLE,RTPOPUPS,RTPBORDERS,id_No,false,false,BUBBLE_BORDER_HOR));
								new(PRahmenBox,Init(rahmen,RTRAVLINE,RTRAVCYC,RTRAVTITLE,RTPOPUPS,RTPBORDERS,id_No,false,false,BUBBLE_BORDER_VERT));
								new(PColorBox,Init(rahmen,RTRAGCOLOR,RTRAGCOLORCYC,id_No,RTPOPUPS,RTPCOLOR,RTPCOLSTART,false,false,BUBBLE_BORDER_OCOLOR));
								new(PColorBox,Init(rahmen,RTRACOLOR,RTRACOLORCYC,id_No,RTPOPUPS,RTPCOLOR,RTPCOLSTART,false,false,BUBBLE_BORDER_4COLOR));
								new(PColorBox,Init(rahmen,RTRAHCOLOR,RTRAHCOLORCYC,id_No,RTPOPUPS,RTPCOLOR,RTPCOLSTART,false,false,BUBBLE_BORDER_HCOLOR));
								new(PColorBox,Init(rahmen,RTRAVCOLOR,RTRAVCOLORCYC,id_No,RTPOPUPS,RTPCOLOR,RTPCOLSTART,false,false,BUBBLE_BORDER_VCOLOR));
								new(pb,Init(rahmen,RTRAHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(rahmen,RTRAABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(rahmen,RTRASETZEN,id_No,true,BUBBLE_GENERAL_SET));
								new(PButton,Init(rahmen,RTRAOK,id_OK,true,BUBBLE_GENERAL_SETOK));
								rahmen^.TransferBuffer:=@p^.rabuf
							end
					end;
				if rahmen<>nil then
					begin
						PRahmenDialog(rahmen)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
						with p^.rabuf do
							begin
								lline:=0;
								rline:=0;
								oline:=0;
								uline:=0;
								hline:=0;
								vline:=0;
								gline:=0;
								color:=Black;
								hcolor:=Black;
								vcolor:=Black;
								gcolor:=Black
							end;
						if p^.Parms.Cursor.Block then
							begin
								lfeq:=true;
								rteq:=true;
								topeq:=true;
								boteq:=true;
								c1:=p^.GetCell(p^.Parms.Cursor.RowStart,p^.Parms.Cursor.ColStart);
								c2:=p^.GetCell(p^.Parms.Cursor.RowEnd,p^.Parms.Cursor.ColStart);
								topb:=c1^.Border.Top;
								botb:=c2^.Border.Bottom;
								for x:=p^.Parms.Cursor.ColStart to p^.Parms.Cursor.ColEnd do
									begin
										if c1^.Border.Top<>topb then topeq:=false;
										if c2^.Border.Bottom<>botb then boteq:=false;
										inc(longint(c1),CELLSIZE);
										inc(longint(c2),CELLSIZE)
									end;
								c1:=p^.GetCell(p^.Parms.Cursor.RowStart,p^.Parms.Cursor.ColStart);
								c2:=p^.GetCell(p^.Parms.Cursor.RowStart,p^.Parms.Cursor.ColEnd);
								lfb:=c1^.Border.Left;
								rtb:=c2^.Border.Right;
								offs:=CELLSIZE*longint(p^.Parms.Columns+1);
								for y:=p^.Parms.Cursor.RowStart to p^.Parms.Cursor.RowEnd do
									begin
										if c1^.Border.Left<>lfb then lfeq:=false;
										if c2^.Border.Right<>rtb then rteq:=false;
										inc(longint(c1),offs);
										inc(longint(c2),offs)
									end;
								if lfeq and rteq and topeq and boteq and (lfb=rtb) and (lfb=topb) and (lfb=botb) and (rtb=topb) and (rtb=botb) and (topb=botb) then
									begin
										p^.rabuf.gcolor:=lfb and $0f;
										p^.rabuf.gline:=(lfb shr 4)+1
									end
								else
									if bequal(lfb,rtb) and bequal(lfb,topb) and bequal(lfb,botb) and bequal(rtb,topb) and bequal(rtb,botb) and bequal(topb,botb) then
										begin
											p^.rabuf.color:=bcolor(lfb,rtb,topb,botb);
											if lfeq and (p^.Parms.Cursor.ColStart=p^.Parms.Cursor.ColEnd) then p^.rabuf.lline:=(lfb shr 4)+1;
											if rteq and (p^.Parms.Cursor.ColStart=p^.Parms.Cursor.ColEnd) then p^.rabuf.rline:=(rtb shr 4)+1;
											if topeq and (p^.Parms.Cursor.RowStart=p^.Parms.Cursor.RowEnd) then p^.rabuf.oline:=(topb shr 4)+1;
											if boteq and (p^.Parms.Cursor.RowStart=p^.Parms.Cursor.RowEnd) then p^.rabuf.uline:=(botb shr 4)+1
										end
							end
						else
							with cell^.Border do
								begin
									p^.rabuf.hline:=(Hor shr 4)+1;
									p^.rabuf.hcolor:=Hor and $0f;
									p^.rabuf.vline:=(Vert shr 4)+1;
									p^.rabuf.vcolor:=Vert and $0f;
									if bequal(Left,Right) and bequal(Left,Top) and bequal(Left,Bottom) and bequal(Right,Top) and bequal(Right,Bottom) and bequal(Top,Bottom) then
										begin
											p^.rabuf.color:=bcolor(Left,Right,Top,Bottom);
											p^.rabuf.lline:=(Left shr 4)+1;
											p^.rabuf.rline:=(Right shr 4)+1;
											p^.rabuf.oline:=(Top shr 4)+1;
											p^.rabuf.uline:=(Bottom shr 4)+1
										end
								end;
						rahmen^.TransferData(tf_SetData);
						rahmen^.MakeWindow
					end
			end
		end
	end;


function TTextAttrDialog.ChangeValues: boolean;
	var rs,cs,re,
	    ce,x,y,
	    cmin,cmax,
	    nalgn,
	    nalgn2,
	    dummy,
	    nrot,nskw: integer;
	    p        : PCalcWindow;
	    cell     : PCell;

	begin
		p:=PCalcWindow(Parent);
		ChangeValues:=false;
		if p^.GetBlock(bedt^.GetText,false,rs,cs,re,ce,dummy,dummy) then
			begin
				cmin:=cs;
				cmax:=ce;
				p^.RowsClearOverflow(rs,re,cmin,cmax);
				if p^.txabuffer.right=bf_Checked then nalgn:=TA_RIGHT
				else
					if p^.txabuffer.center=bf_Checked then nalgn:=TA_CENTER
					else
						nalgn:=TA_LEFT;
				if p^.txabuffer.oben=bf_Checked then nalgn2:=TA_OBEN
				else
					if p^.txabuffer.mitte=bf_Checked then nalgn2:=TA_MITTE
					else
						nalgn2:=TA_UNTEN;
				nrot:=round(atof(p^.txabuffer.rotat)*10);
				nskw:=round(atof(p^.txabuffer.skew)*10);
				for y:=rs to re do
					begin
						cell:=p^.GetCell(y,cs);
						for x:=cs to ce do
							begin
								with cell^.TxtVal do
									begin
										if p^.txabuffer.rotoff=bf_Checked then Rotat:=nrot;
										if p^.txabuffer.skewoff=bf_Checked then Skew:=nskw;
										if p^.txabuffer.coloff=bf_Checked then Color:=p^.txabuffer.color;
										if p^.txabuffer.alignoff=bf_Checked then Align:=(Align and $f0) or nalgn;
										if p^.txabuffer.alignoff2=bf_Checked then Align:=(Align and $0f) or nalgn2;
										if p^.txabuffer.clip=bf_Checked then Flags:=Flags or TFL_CLIP
										else
											if p^.txabuffer.clip=bf_Unchecked then Flags:=Flags and not(TFL_CLIP);
										if p^.txabuffer.bold=bf_Checked then Effects:=Effects or TF_THICKENED
										else
											if p^.txabuffer.bold=bf_Unchecked then Effects:=Effects and not(TF_THICKENED);
										if p^.txabuffer.light=bf_Checked then Effects:=Effects or TF_LIGHTENED
										else
											if p^.txabuffer.light=bf_Unchecked then Effects:=Effects and not(TF_LIGHTENED);
										if p^.txabuffer.italic=bf_Checked then Effects:=Effects or TF_SLANTED
										else
											if p^.txabuffer.italic=bf_Unchecked then Effects:=Effects and not(TF_SLANTED);
										if p^.txabuffer.under=bf_Checked then Effects:=Effects or TF_UNDERLINED
										else
											if p^.txabuffer.under=bf_Unchecked then Effects:=Effects and not(TF_UNDERLINED);
										if p^.txabuffer.outl=bf_Checked then Effects:=Effects or TF_OUTLINED
										else
											if p^.txabuffer.outl=bf_Unchecked then Effects:=Effects and not(TF_OUTLINED);
										if p^.txabuffer.shadow=bf_Checked then Effects:=Effects or TF_SHADOWED
										else
											if p^.txabuffer.shadow=bf_Unchecked then Effects:=Effects and not(TF_SHADOWED);
									end;
								inc(longint(cell),CELLSIZE)
							end
					end;
				p^.RowsCheckOverflow(rs,re,cmin,cmax);
				p^.SetDirty;
				p^.DrawCells(rs,cmin,re,cmax);
				p^.CheckToolbarTextFX(p^.GetCell(rs,cs));
				ChangeValues:=true
			end
		else
			Application^.Alert(@self,1,NOTE,MESSAGE_GENERAL_RANGE,BUTTON_OK)
	end;


procedure TTextAttrDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk)
	end;


function TTextAttrDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then valid:=ChangeValues;
		OK:=valid
	end;


function TTextAttrDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		case AnIndx of
		RTTABEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTTANONE:
			begin
				if cb1<>nil then cb1^.Uncheck;
				if cb2<>nil then cb2^.Uncheck;
				if cb3<>nil then cb3^.Uncheck;
				if cb4<>nil then cb4^.Uncheck;
				if cb5<>nil then cb5^.Uncheck;
				if cb6<>nil then cb6^.Uncheck
			end;
		RTTAFXOFF:
			begin
				if cb1<>nil then cb1^.Gray;
				if cb2<>nil then cb2^.Gray;
				if cb3<>nil then cb3^.Gray;
				if cb4<>nil then cb4^.Gray;
				if cb5<>nil then cb5^.Gray;
				if cb6<>nil then cb6^.Gray
			end;
		RTTASET:
			begin
				TransferData(tf_GetData);
				ChangeValues
			end
		end;
		ExitDlg:=false
	end;


procedure TFormCategoryBox.Work;
	var q,sel: integer;
	    pfm  : PFormat;
	    pfc  : PFormatCollection;

	begin
		if TexelApp.Formats^.Count=0 then exit;
		sel:=GetSelection;
		if sel<0 then exit;
		flist^.FreeAll;
		flist^.Sort:=false;
		if sel<>1 then
			for q:=0 to TexelApp.Formats^.Count-1 do
				if (sel=0) or (PFormat(TexelApp.Formats^.At(q))^.Group=sel) then
					begin
						new(pfm);
						if pfm<>nil then
							begin
								pfm^.Name:=NewStr('  '+StrPLeft(PFormat(TexelApp.Formats^.At(q))^.Name^,30)+' '#0);
								pfm^.Group:=PFormat(TexelApp.Formats^.At(q))^.Group;
								pfm^.Index:=PFormat(TexelApp.Formats^.At(q))^.Index;
								flist^.Insert(pfm)
							end
					end;
		if (sel=0) or (sel=1) then
			begin
				pfc:=PCalcWindow(Parent^.Parent)^.UsrFormats;
				if pfc<>nil then
					if pfc^.Count>0 then
						for q:=0 to pfc^.Count-1 do
							begin
								new(pfm);
								if pfm<>nil then
									begin
										pfm^.Name:=NewStr('  '+StrPLeft(PFormat(pfc^.At(q))^.Name^,30)+' '#0);
										pfm^.Group:=PFormat(pfc^.At(q))^.Group;
										pfm^.Index:=PFormat(pfc^.At(q))^.Index;
										flist^.Insert(pfm)
									end
							end
			end;
		fbox^.SetCollection(flist);
		if (flist^.Count=0) or (sel<>1) then
			begin
				delbtn^.Disable;
				chgbtn^.Disable
			end
		else
			begin
				delbtn^.Enable;
				chgbtn^.Enable
			end;
		if flist^.Count=0 then
			begin
				okbtn^.Disable;
				setbtn^.Disable;
				format^.Clear;
				preview^.Clear
			end
		else
			begin
				okbtn^.Enable;
				setbtn^.Enable
			end
	end;


procedure TCatFormBox.Work;
	var pfm : PFormat;
	    p   : PCalcWindow;
	    cell: PCell;
	    idx : integer;

	begin
		if List=nil then exit;
		if List^.Count=0 then exit;
		p:=PCalcWindow(Parent^.Parent);
		with p^.Parms.Cursor do
			if Block then cell:=p^.GetCell(RowStart,ColStart)
			else
				cell:=p^.GetCell(Row,Col);
		idx:=PFormat(List^.At(GetSelection))^.Index;
		if idx>=1000 then pfm:=PFormat(PCalcWindow(Parent^.Parent)^.UsrFormats^.At(idx-1000))
		else
			pfm:=PFormat(TexelApp.Formats^.At(idx));
		pfcb^.format^.SetText(StrPTrimF(pfm^.Name^));
		case cell^.Typ of
		CTYPE_TEXT:
			pfcb^.preview^.SetText(cell^.Data.Txt^);
		CTYPE_CONST:
			with cell^.Data.Konst^ do pfcb^.preview^.SetText(p^.Val2TxtF(Value,FPts,pfm^.Index,nil));
		CTYPE_FORMULA:
			with cell^.Data.Formula^ do pfcb^.preview^.SetText(p^.Val2TxtF(Value,FPts,pfm^.Index,nil))
		else
			pfcb^.preview^.Clear
		end;
		if pfm^.Group=1 then
			begin
				pfcb^.delbtn^.Enable;
				pfcb^.chgbtn^.Enable
			end
		else
			begin
				pfcb^.delbtn^.Disable;
				pfcb^.chgbtn^.Disable
			end
	end;


function TNumFormatsDialog.ExitDlg(AnIndx: integer): boolean;
	var p    : PCalcWindow;
	    rs,cs,
	    re,ce,
	    x,y,
	    idx  : integer;
	    cell : PCell;
	    vrnd : boolean;
	    s    : string;
	    pfm  : PFormat;

	function checkinp: boolean;
		var q,anz: integer;

		begin
			checkinp:=false;
			if p^.UsrFormats=nil then
				begin
					Application^.Bing;
					exit
				end;
			s:=StrPTrimF(p^.nformbuffer.format);
			if length(s)=0 then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_NUMFORM_EMPTY,BUTTON_OK);
					exit
				end;
			anz:=0;
			for q:=1 to length(s) do if s[q]=';' then inc(anz);
			if anz>2 then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_NUMFORM_PARTS,BUTTON_OK);
					exit
				end;
			anz:=0;
			for q:=1 to length(s) do
				if s[q] in ['(','[','{'] then
					begin
						if anz<>0 then break
						else
							if s[q]='(' then anz:=1
							else
								if s[q]='[' then anz:=2
								else
									anz:=3
					end
				else
					if (s[q]=')') then
						begin
							dec(anz);
							if anz<>0 then break
						end
					else
						if (s[q]=']') then
							begin
								dec(anz,2);
								if anz<>0 then break
							end
						else
							if (s[q]='}') then
								begin
									dec(anz,3);
									if anz<>0 then break
								end;
			if anz<>0 then
				begin
					Application^.Alert(@self,1,NOTE,MESSAGE_NUMFORM_BRACES,BUTTON_OK);
					exit
				end;
			checkinp:=true
		end;

	begin
		p:=PCalcWindow(Parent);
		TransferData(tf_GetData);
		case AnIndx of
		RTFBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTFNEW:
			if checkinp then p^.NewNumFormat(s);
		RTFCHANGE:
			if checkinp then
				begin
					idx:=PFormat(pfcb^.fbox^.List^.At(p^.nformbuffer.frmindex))^.Index;
					pfm:=PFormat(p^.UsrFormats^.At(idx-1000));
					DisposeStr(pfm^.Name);
					pfm^.Name:=NewStr(s);
					p^.SetDirty;
					pfcb^.Work;
					p^.ForceVRedraw
				end;
		RTFDELETE:
			begin
				idx:=PFormat(pfcb^.fbox^.List^.At(p^.nformbuffer.frmindex))^.Index;
				pfm:=PFormat(p^.UsrFormats^.At(idx-1000));
				if Application^.Alert(@self,1,WAIT,MESSAGE_NUMFORM_DEL1+StrPTrimF(pfm^.Name^)+MESSAGE_NUMFORM_DEL2,BUTTON_YESNO)=1 then
					begin
						if p^.UsrFormats^.Count>(idx-999) then
							for y:=idx-999 to p^.UsrFormats^.Count-1 do dec(PFormat(p^.UsrFormats^.At(y))^.Index);
						p^.UsrFormats^.AtDelete(idx-1000);
						cell:=p^.Sheet;
						for y:=0 to p^.Parms.Rows do
							for x:=0 to p^.Parms.Columns do
								begin
									if cell^.Format=idx then cell^.Format:=0
									else
										if cell^.Format>idx then dec(cell^.Format);
									inc(longint(cell),CELLSIZE)
								end;
						p^.SetDirty;
						pfcb^.Work;
						p^.ForceVRedraw
					end
			end;
		RTFSET:
			begin
				idx:=PFormat(pfcb^.fbox^.List^.At(p^.nformbuffer.frmindex))^.Index;
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
						vrnd:=false;
						for y:=rs to re do
							begin
								cell:=GetCell(y,cs);
								for x:=cs to ce do
									begin
										if cell^.Format<>idx then
											begin
												cell^.Format:=idx;
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
			end
		end;
		ExitDlg:=false
	end;


procedure TNumFormatsDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk);
		pfcb^.fbox^.Work
	end;


function TNumFormatsDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTFSET);
		OK:=valid
	end;


function TRowSizeDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=RTRSROW then WMKeyDown(K_CTRL,Ctrl_B)
	end;


function TRowSizeDialog.OK: boolean;
	var valid    : boolean;
	    von,bis,q: integer;
	    p        : PCalcWindow;
	    nh       : longint;

	begin
		valid:=inherited OK;
		if valid then
			begin
				p:=PCalcWindow(Parent);
				with p^ do
					begin
						GetBlock(dblock^.GetText,false,von,q,bis,q,q,q);
						nh:=Max(round(atof(rsbuffer)*100.0-longint(Application^.Attr.PixH)/10.0),0)
					end;
				if bis>von then
					for q:=bis downto von+1 do p^.SetRowHeight_mm100(q,nh,false);
				p^.SetRowHeight_mm100(von,nh,true)
			end;
		OK:=valid
	end;


procedure TRowSizeDialog.BlockChanged(blk: string);
	var rs,re,dummy: integer;

	begin
		PCalcWindow(Parent)^.GetBlock(blk,false,rs,dummy,re,dummy,dummy,dummy);
		if ed1<>nil then
			begin
				if rs=re then ed1^.SetText(STRING_ROW+': '+PCalcWindow(Parent)^.GetRowIndex(rs))
				else
					ed1^.SetText(STRING_ROW+': '+PCalcWindow(Parent)^.GetRowIndex(rs)+' '+STRING_ROWTO+' '+PCalcWindow(Parent)^.GetRowIndex(re))
			end
	end;


function TColSizeDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=RTCSCOLUMN then WMKeyDown(K_CTRL,Ctrl_B)
	end;


function TColSizeDialog.OK: boolean;
	var valid    : boolean;
	    von,bis,q: integer;
	    p        : PCalcWindow;
	    nw       : longint;

	begin
		valid:=inherited OK;
		if valid then
			begin
				p:=PCalcWindow(Parent);
				with p^ do
					begin
						GetBlock(dblock^.GetText,false,q,von,q,bis,q,q);
						nw:=Max(round(atof(csbuffer)*100.0-longint(Application^.Attr.PixW)/10.0),0)
					end;
				if bis>von then
					for q:=bis downto von+1 do p^.SetColWidth_mm100(q,nw,false);
				p^.SetColWidth_mm100(von,nw,true)
			end;
		OK:=valid
	end;


procedure TColSizeDialog.BlockChanged(blk: string);
	var cs,ce,dummy: integer;
	    p          : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		p^.GetBlock(blk,false,dummy,cs,dummy,ce,dummy,dummy);
		if ed1<>nil then
			begin
				if cs=ce then ed1^.SetText(STRING_COL+': '+p^.GetColumnIndex(cs))
				else
					ed1^.SetText(STRING_COL+': '+p^.GetColumnIndex(cs)+' '+STRING_COLTO+' '+p^.GetColumnIndex(ce))
			end
	end;


function TColNameDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=RTCNCOLUMN then WMKeyDown(K_CTRL,Ctrl_B)
	end;


function TColNameDialog.OK: boolean;
	var valid,v: boolean;
	    q      : integer;
	    r      : GRECT;
	    p      : PCalcWindow;
	    ncol   : string;

	begin
		valid:=inherited OK;
		if valid then
			begin
				p:=PCalcWindow(Parent);
				with p^ do
					with cnbuffer do
						begin
							StrPTrim(nnew);
							StrPTrim(nold);
							if nold<>nnew then
								begin
									ncol:=StrPTrimF(StrPRight(st1^.GetText,length(st1^.GetText)-7));
									q:=ColIndex2Nr(ncol,true);
									DisposeStr(PString(PColNames^[q]));
									if nnew<>ncol then PColNames^[q]:=NewStr(nnew);
									SetDirty;
									wind_update(BEG_UPDATE);
									HideMouse;
									v:=FirstWorkRect(r);
									while v do
										begin
											PaintNames(r);
											v:=NextWorkRect(r)
										end;
									vs_clip(Application^.vdiHandle,CLIP_ON,SysInfo.Desktop.A2);
									ShowMouse;
									wind_update(END_UPDATE)
								end
						end
			end;
		OK:=valid
	end;


procedure TColNameDialog.BlockChanged(blk: string);
	var cs,dummy: integer;
	    p       : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		p^.GetBlock(blk,false,dummy,cs,dummy,dummy,dummy,dummy);
		if st1<>nil then st1^.SetText(STRING_COL+':     '+p^.GetColumnIndex(cs));
		if st2<>nil then st2^.SetText(p^.GetColumnName(cs));
		if ed1<>nil then ed1^.SetText(p^.GetColumnName(cs))
	end;


function TPatternDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTMSETZEN);
		OK:=valid
	end;


procedure TPatternDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk)
	end;


function TPatternDialog.ExitDlg(AnIndx: integer): boolean;
	var dummy,
	    st,pt,
	    x,y,
	    rs,cs,
	    re,ce: integer;
	    p    : PCalcWindow;
	    cell : PCell;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTMBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTMSETZEN:
			begin
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
				st:=(ps^.ObjAddr^.ob_spec.index shr 4) and $7;
				if st=7 then st:=8;
				dummy:=ps^.GetColor;
				if (st=0) and (dummy=White) then
					begin
						pt:=FIS_HOLLOW;
						st:=8
					end
				else
					if st=8 then pt:=FIS_SOLID
					else
						pt:=FIS_PATTERN;
				for y:=rs to re do
					begin
						cell:=p^.GetCell(y,cs);
						for x:=cs to ce do
							begin
								cell^.Color:=dummy;
								cell^.Interior:=pt;
								cell^.Style:=st;
								inc(longint(cell),CELLSIZE)
							end
					end;
				p^.SetDirty;
				p^.DrawCells(rs,cs,re,ce)
			end
		else
			if (AnIndx>=pc^.ObjAddr^.ob_head) and (AnIndx<=pc^.ObjAddr^.ob_tail) then
				begin
					ps^.SetColor(AnIndx-pc^.ObjAddr^.ob_head);
					Color2Name
				end
			else
				if (AnIndx>=pp^.ObjAddr^.ob_head) and (AnIndx<=pp^.ObjAddr^.ob_tail) then
					begin
						dummy:=AnIndx-pp^.ObjAddr^.ob_head;
						if dummy<>((ps^.ObjAddr^.ob_spec.index shr 4) and $7) then
							begin
								with ps^.ObjAddr^.ob_spec do index:=(index and $ffffff8f) or (dummy shl 4);
								ps^.Paint
							end
					end
		end
	end;


procedure TPatternDialog.Color2Name;
	var s: string;

	begin
		s:=TexelApp.Farben[ps^.GetColor];
		cn^.SetText(StrPSpace(15-length(s))+s)
	end;


function TRahmenDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTRASETZEN);
		OK:=valid
	end;


procedure TRahmenDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk)
	end;


function TRahmenDialog.ExitDlg(AnIndx: integer): boolean;
	var trb: TRahmenBuffer;
	    prb: pointer;

	begin
		ExitDlg:=false;
		case AnIndx of
		RTRABEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTRASETZEN:
			begin
				prb:=TransferBuffer;
				TransferBuffer:=@trb;
				TransferData(tf_GetData);
				TransferBuffer:=prb;
				with trb do
					PCalcWindow(Parent)^.SetBorder(lline-1,color,rline-1,color,oline-1,color,uline-1,color,hline-1,hcolor,vline-1,vcolor,gline-1,gcolor)
			end
		end
	end;


function TRahmenBox.TestIndex(AnIndx: integer): boolean;

	begin
		if AnIndx=ObjAddr^.ob_head then
			begin
				TestIndex:=true;
				exit
			end;
		TestIndex:=inherited TestIndex(AnIndx)
	end;


procedure TRahmenBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		if AnIndx=ObjAddr^.ob_head then AnIndx:=ObjIndx;
		inherited Changed(AnIndx,DblClick)
	end;


procedure TRahmenBox.SetValue(Sel: integer);
	var p: PTree;

	begin
		if Sel<3 then
			begin
				with PCalcWindow(Parent)^.DlgTree^[ObjAddr^.ob_head] do ob_flags:=ob_flags or HIDETREE;
				inherited SetValue(Sel)
			end
		else
			begin
				p:=Application^.GetAddr(RTICONS);
				with PCalcWindow(Parent)^.DlgTree^[ObjAddr^.ob_head] do
					begin
						ob_flags:=ob_flags and not(HIDETREE);
						ob_spec.bit_blk^.bi_pdata:=p^[p^[RTILINIEN].ob_head+Sel-3].ob_spec.bit_blk^.bi_pdata
					end;
				SetText('')
			end
	end;

end.