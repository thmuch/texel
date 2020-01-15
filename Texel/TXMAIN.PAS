unit txmain;
{ 2000-01-31 }

interface

uses

	Gem,
	Objects,OTypes,OWindows,ODialogs,
	txtypes,txcollec,txmiscob;


type

	PCalcWindow = ^TCalcWindow;

	PHyperDialog = ^THyperDialog;
	THyperDialog = object(TDialog)
		ddtext     : PString;
		ddfiles    : PChar;
		hdIconTitle,
		HyperHelp  : string;
		constructor Init(AParent: PWindow; ATitle,HypHelp,hdTitle: string; Indx: integer);
		function Help: boolean; virtual;
		function WMKeyDown(Stat,Key: integer): boolean; virtual;
		function DDReadArgs(dSize: longint; PipeHnd,OrgID,mX,mY,KStat: integer): boolean; virtual;
		function DDHeaderReply(dType,dName,fName: string; dSize: longint; OrgID,mX,mY,KStat: integer): byte; virtual;
		function DDReadData(dType,dName,fName: string; dSize: longint; PipeHnd,OrgID,mX,mY,KStat: integer): boolean; virtual;
		procedure DDFinished(OrgID,mX,mY,KStat: integer); virtual;
		function GetIconTitle: string; virtual;
	end;

	PBlockChangeDialog = ^TBlockChangeDialog;
	TBlockChangeDialog = object(THyperDialog)
		function GetClassName: string; virtual;
		procedure BlockChanged(blk: string); virtual;
	end;

	PProtoEmbedded = ^TProtoEmbedded;
	TProtoEmbedded = object(TObject)
		FileName : string;
		Data     : pointer;
		X100,
		Y100,
		Width100,
		Height100,
		DataLen  : longint;
		ObjTyp   : integer;
		oabuf    : TEmbedBuf;
		cbbuf    : TEmbedCheckBuf;
		diabuf   : PDiagrammBuf;
		prntflg,
		lckflg,
		skal,
		umbr,
		prop,
		embd     : boolean;
		Next     : PProtoEmbedded;
		constructor Init(otyp: integer; fname: string; fdat: pointer; fdatlen,x,y,w100,h100: longint; const oab: TEmbedBuf; const cbb: TEmbedCheckBuf; pdb: PDiagrammBuf; prp,emb,skl,umb,prnt,lck: boolean);
		destructor Done; virtual;
		procedure Realize(p: PCalcWindow);
	end;

	PEmbedded = ^TEmbedded;
	TEmbedded = object(TObject)
		public
		Data        : pointer;
		DataLen,
		XPos_mm100,
		YPos_mm100,
		Width_mm100,
		Height_mm100: longint;
		ServerID,
		PaintX,
		PaintY,
		PaintW,
		PaintH      : integer;
		Parent      : PCalcWindow;
		Prev,
		Next        : PEmbedded;
		oabuf       : TEmbedBuf;
		osbuf       : record
			x,y,
			width,
			height: string[7];
			prop,
			sperr : integer
		end;
		constructor Init(AParent: PCalcWindow; poi: POLGAObjectInfo; fName: string; srvid,pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,embd,prntflg,lckflg: boolean; poa: PEmbedBuf);
		destructor Done; virtual;
		function IsExternal: boolean; virtual;
		function HasFile: boolean; virtual;
		function GetType: integer; virtual;
		function Save(hdl: integer; emb: boolean): boolean;
		function SaveData(hdl: integer; emb: boolean): boolean; virtual;
		function GetExt(embed,default: boolean): string; virtual;
		function GetDefaultExt: string; virtual;
		procedure Link; virtual;
		procedure Unlink; virtual;
		procedure BreakLink; virtual;
		procedure CheckLink; virtual;
		procedure Update;
		function CreateLinkFile: boolean;
		procedure SetWorkstationValues(dev,colrs: integer; xofs,yofs: longint; xmm100,ymm100,perc,ffak: real; scale,outs: boolean);
		procedure Paint(handle: integer; const clip: GRECT; screen: boolean);
		procedure UserPaint(handle: integer; clip: GRECT; screen: boolean); virtual;
		procedure Redraw;
		procedure Unembed;
		function IsVisible(const r: GRECT; screen: boolean): boolean;
		procedure Resize(pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100: longint; xyvalid,draw: boolean);
		function GetPixXPos(screen: boolean): integer;
		function GetPixYPos(screen: boolean): integer;
		function GetPixWidth(screen: boolean): integer;
		function GetPixHeight(screen: boolean): integer;
		function IsInside(mx,my: integer): boolean;
		procedure DoClick(mX,mY,KStat: integer); virtual;
		procedure Click(mX,mY,KStat: integer);
		procedure DblClick(mX,mY,KStat: integer); virtual;
		procedure RButton(mX,mY,KStat,Clicks: integer);
		procedure DoMenu(mX,mY: integer); virtual;
		procedure HandleMenu(indx: integer);
		procedure Edit; virtual;
		function IsEmbedded: boolean;
		procedure SetEmbedFlag;
		procedure ClearEmbedFlag; virtual;
		procedure Select;
		procedure Deselect;
		procedure Toggle;
		function IsSelected: boolean;
		procedure Destroy;
		procedure Cut;
		procedure Copy;
		procedure Paste;
		procedure SetDirty;
		procedure ClearDirtyFlag;
		function IsDirty: boolean;
		procedure SetPropFlag;
		procedure ClearPropFlag;
		function IsProportional: boolean;
		procedure Lock;
		procedure Unlock;
		function IsLocked: boolean;
		procedure SetPrintFlag;
		procedure ClearPrintFlag;
		function CanPrint: boolean;
		procedure IEActivate;
		procedure IEDeactivate;
		procedure IESendButton(X,Y,Clicks,Button,KStat: integer);
		function IsIEActive: boolean;
		function CanUseIE: boolean;
		procedure SetFile(s: string);
		function GetFile: string;
		function bwrite(hdl: integer; count: longint; var buffer): boolean;
		private
		objsize,
		objattr     : PHyperDialog;
		ScaleIMG,
		outscr,
		selected,
		printflag,
		ieactivated,
		embfiledirty,
		embedflag   : boolean;
		objectinfo  : POLGAObjectInfo;
		FileName    : PString;
		fontfak,
		percent,
		xmm100fak,
		ymm100fak   : real;
		colors,
		devID       : integer;
		XOffs,
		YOffs       : longint;
	end;
	
	PEmbeddedStatic = ^TEmbeddedStatic;
	TEmbeddedStatic = object(TEmbedded)
		function IsExternal: boolean; virtual;
		function GetExt(embed,default: boolean): string; virtual;
	end;

	PEmbeddedElement = ^TEmbeddedElement;
	TEmbeddedElement = object(TEmbeddedStatic)
		elPrev,
		elNext: PEmbeddedElement;
		constructor Init(AParent: PCalcWindow; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,prntflg,lckflg: boolean; poa: PEmbedBuf);
		destructor Done; virtual;
		function HasFile: boolean; virtual;
		function GetExt(embed,default: boolean): string; virtual;
		procedure Link; virtual;
		procedure Unlink; virtual;
		procedure BreakLink; virtual;
		procedure CheckLink; virtual;
		procedure ClearEmbedFlag; virtual;
		procedure DblClick(mX,mY,KStat: integer); virtual;
		procedure CheckRef; virtual;
		procedure SetRef; virtual;
		procedure UpdateRefPointer(warn: boolean); virtual;
	end;
	
	PEmbeddedTAD = ^TEmbeddedTAD;
	TEmbeddedTAD = object(TEmbedded)
		dbvalid: boolean;
		diabuf : TDiagrammBuf;
		constructor Init(AParent: PCalcWindow; poi: POLGAObjectInfo; fName: string; srvid,pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,embd,prntflg,lckflg: boolean; poa: PEmbedBuf; pdb: PDiagrammBuf);
		function GetType: integer; virtual;
		function SaveData(hdl: integer; emb: boolean): boolean; virtual;
		procedure DoMenu(mX,mY: integer); virtual;
	end;

	PEmbeddedIMG = ^TEmbeddedIMG;
	TEmbeddedIMG = object(TEmbeddedStatic)
		imgxy    : ARRAY_8;
		colidx   : ARRAY_2;
		fd_dlen  : longint;
		srcMFDB,
		desMFDB  : MFDB;
		skalieren: boolean;
		constructor Init(AParent: PCalcWindow; fName: string; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,embd,skal,prntflg,lckflg: boolean; poa: PEmbedBuf);
		destructor Done; virtual;
		function GetDefaultExt: string; virtual;
		function GetType: integer; virtual;
		function SaveData(hdl: integer; emb: boolean): boolean; virtual;
		procedure CheckLink; virtual;
		function Decode: boolean;
		procedure UserPaint(handle: integer; clip: GRECT; screen: boolean); virtual;
		procedure DoMenu(mX,mY: integer); virtual;
	end;
	
	PEmbeddedText = ^TEmbeddedText;
	TEmbeddedText = object(TEmbeddedStatic)
	  txOffs,
	  tyOffs : integer;
		umbruch: boolean;
		constructor Init(AParent: PCalcWindow; fName: string; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,embd,umbr,prntflg,lckflg: boolean; poa: PEmbedBuf);
		function GetDefaultExt: string; virtual;
		function GetType: integer; virtual;
		function SaveData(hdl: integer; emb: boolean): boolean; virtual;
		procedure CheckLink; virtual;
		procedure UserPaint(handle: integer; clip: GRECT; screen: boolean); virtual;
		procedure DblClick(mX,mY,KStat: integer); virtual;
		procedure DoMenu(mX,mY: integer); virtual;
	end;

	PEmbeddedCheckBox = ^TEmbeddedCheckBox;
	TEmbeddedCheckBox = object(TEmbeddedElement)
		objelm : PBlockChangeDialog;
		refcell: PCell;
		ocbbuf : TEmbedCheckBuf;
		constructor Init(AParent: PCalcWindow; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,prntflg,lckflg: boolean; poa: PEmbedBuf; pcb: PEmbedCheckBuf);
		function GetType: integer; virtual;
		function SaveData(hdl: integer; emb: boolean): boolean; virtual;
		procedure UserPaint(handle: integer; clip: GRECT; screen: boolean); virtual;
		procedure DoClick(mX,mY,KStat: integer); virtual;
		procedure DoMenu(mX,mY: integer); virtual;
		procedure Edit; virtual;
		procedure CheckRef; virtual;
		procedure SetRef; virtual;
		procedure UpdateRefPointer(warn: boolean); virtual;
	end;

	PLinkData = ^TLinkData;
	TLinkData = record
		Descr : PString;
		ObjRef: PEmbedded;
	end;

	PLink = ^TLink;
	TLink = object(THyperDialog)
		pb1,
		pb2,
		pb3     : PButton;
		plb     : PListBox;
		linklist: PStringCollection;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure EndDlg(Indx: integer; DblClick: boolean); virtual;
		procedure AddObject(pe: PEmbedded);
		procedure RemoveObject(pe: PEmbedded);
		procedure UpdateList(pe: PEmbedded);
	end;

	TCalcWindow = object(THyperDialog)
		Parms       : TTexelParms;
		LeftColWidth,
		TopRowHeight,
		PaintOffs,
		lcnum,
		tcnum,
		wWidth,
		numWidth,
		prnRangeFlag,
		fneOp,
		actFont,
		actPoint,
		alertret    : integer;
		lpoffs,
		tpoffs      : longint;
		PercentSize : real;
		PRow,
		PCol        : PWordArray;
		PRowFlags,
		PColFlags   : PByteArray;
		PColNames   : PItemList;
		fnecell,
		Sheet       : PCell;
		Dirty,
		{$IFNDEF NVDI5}
		Speedo,
		{$ENDIF}
		currvalid,
		tbactive,
		closing,
		inpstat     : boolean;
		parser,
		attrdialog  : PEvent;
		{$IFNDEF LITE}
		konstanten,
		{$ENDIF}
		pagesetup,
		insrow,
		inscol,
		find,
		replace,
		abandon,
		textobj,
		grafik,
		oleobject,
		paper,
		prnt,
		preview,
		diagramm,
		insfunc,
		export,
		save,
		saveas      : PKeyMenu;
		clrinh,
		formrow,
		formcol,
		objects,
		fill        : PSubMenu;
		links       : PLink;
		bblock      : PKey;
		tbonoff,
		inpok,
		inpcancel   : PControl;
		dblock      : PStatic;
		inpline     : PInputEdit;
		dezplus,
		dezminus,
		tsumme,
		pfett,
		pkursiv,
		punter,
		palignleft,
		paligncenter,
		palignright : PToolbar;
		ppbox,
		pcbox,
		ptcbox,
		pbrdbox,
		pfbox       : PComboBox;
		pdirbox     : PDirectionBox;
		tccbuffer   : record
			empty,
			left,
			right,
			up,
			down   : integer
		end;
		ticbuffer   : record
			left,
			right,
			up,
			down   : integer
		end;
		tibuffer    : record
			all,
			formula,
			value,
			format,
			note,
			none,
			add,
			sub,
			mul,
			divide,
			empty,
			transpose: integer
		end;
		nformbuffer : record
			category,
			frmindex: integer;
			format  : string[51]
		end;
		txabuffer   : record
			bold,
			light,
			italic,
			under,
			outl,
			shadow   : integer;
			rotat,
			skew     : string[5];
			clip,
			left,
			center,
			right,
			color,
			rotoff,
			skewoff,
			alignoff,
			coloff,
			alignoff2,
			oben,
			mitte,
			unten    : integer
		end;
		cnbuffer    : record
			nold,
			nnew: string[41]
		end;
		rsbuffer    : string[7];
		csbuffer    : string[7];
		zwbuf       : TZielBuf;
		exportbuf   : TExportBuf;
		dtbuffer    : TDialogBuffer;
		sheetbuffer : TSheetBuffer;
		prnbuffer   : TPrintBuffer;
		rabuf       : TRahmenBuffer;
		sortbuf     : TSortBuf;
		diagrammbuf : TDiagrammBuf;
		infobuf     : TInfoBuf;
		findbuf     : TFindBuf;
		replacebuf  : TReplaceBuf;
		fillbuf     : TFillBuffer;
		Fonts       : PFontCollection;
		Parameter   : PParameterCollection;
		Variables   : PVariableCollection;
		Embedded    : PEmbedded;
		Elements    : PEmbeddedElement;
		UsrFormats  : PFormatCollection;
		BlockHistory: PStringCollection;
		wnd_prnt_set: PPRN_SETTINGS;
		longfile    : string;
		PassWord    : TPassWord;
		constructor Init(psi: PSmallInfo);
		constructor InitFile(const FNam: string; pg: PProgressWindow; const AParm: TTexelParms; const ADBuf: TDialogBuffer; const ASBuf: TSheetBuffer; const FBuf: TFindBuf; const RBuf: TReplaceBuf; const FlBuf: TFillBuffer;
		                     const zBuf: TZielBuf; const ExBuf: TExportBuf; const SrtBuf: TSortBuf; const InfBuf: TInfoBuf; const DiaBuf: TDiagrammBuf;
		                     ASheet: PCell; ARow,ACol: PWordArray; CNam: PItemList; Parm: PParameterCollection; UFrm: PFormatCollection; ProtoEmb: PProtoEmbedded;
		                     apwd: TPassWord; bhist: PStringCollection; CFlags,RFlags: PByteArray; prntset: PPRN_SETTINGS; prnrange: integer; drt,checkover: boolean);
		{$IFNDEF LITE}
		constructor InitImport(pg: PProgressWindow; rw,cl: integer; const FNam: string; ASheet: PCell; ARow,ACol: PWordArray; CNam: PItemList; breiten: boolean);
		{$ENDIF}
		procedure CommonInit1;
		function CommonInit2(breiten: boolean): boolean;
		procedure CommonParmInit(setsize: boolean);
		procedure GetWorkMin(var minX,minY: integer); virtual;
		function CanClose: boolean; virtual;
		function GetStyle: integer; virtual;
		function GetVDIHandle: integer; virtual;
		procedure GetWindowClass(var AWndClass: TWndClass); virtual;
		function GetClassName: string; virtual;
		function GetRawIconTitle: string;
		function GetIconTitle: string; virtual;
		function GetScroller: PScroller; virtual;
		procedure GetWorkMax(var maxX,maxY: integer); virtual;
		procedure SetupSize; virtual;
		procedure SetupVDI; virtual;
		procedure SetupWindow; virtual;
		procedure ShutdownWindow; virtual;
		procedure PaintNumbers(rect: GRECT);
		procedure PaintNames(rect: GRECT);
		function Val2Txt(fval: TNumber; var vtxt: string; fp: byte; frm: integer; cell: PCell): boolean;
		function Val2TxtF(fval: TNumber; fp: byte; frm: integer; cell: PCell): string;
		procedure InitTextValues(handle: integer; var cmpval: TOldTxtVal);
		procedure RestoreTextValues(handle: integer);
		procedure RowsClearOverflow(rs,re: integer; var cmin,cmax: integer);
		procedure RowsCheckOverflow(rs,re: integer; var cmin,cmax: integer);
		procedure SheetCheckOverflow;
		function ClearOverflow(cell: PCell; var cmin,cmax: integer): boolean;
		function CheckOverflow(cell: PCell; var cmin,cmax: integer): boolean;
		procedure OutputVectorText(handle: integer; cell: PCell; const txt: string; const tval: TTxtVal; var cmpval: TOldTxtVal; csize: ARRAY_4; isnum: boolean);
		procedure OutputKF(handle,kfx,kfy,alh,alv,pagenum,pages: integer; printtime: longint; s: string);
		procedure OutputErrorText(handle: integer; cell: PCell; const tval: TTxtVal; var cmpval: TOldTxtVal; csize: ARRAY_4; err: shortint);
		procedure Paint(var PaintInfo: TPaintStruct); virtual;
		procedure ForceVRedraw; virtual;
		procedure Print; virtual;
		procedure SelectAll; virtual;
		procedure DeselectAll;
		procedure StandardBreite(cs,ce: integer);
		procedure StandardHoehe(rs,re: integer);
		procedure InsertCell(rs,cs,re,ce: integer);
		procedure WMRubbox(r: GRECT); virtual;
		procedure WMClick(mX,mY,KStat: integer); virtual;
		procedure InternalDragDrop(mX,mY: integer);
		procedure CopyFromInternalDragDrop(from: PCalcWindow; rs,cs,re,ce,r,c: integer; mve: boolean);
		function DoRubbox(mX,mY,KStat: integer): boolean; virtual;
		procedure WMDblClick(mX,mY,KStat: integer); virtual;
		procedure WMRButton(mX,mY,KStat,Clicks: integer); virtual;
		procedure AttrDialogs(num,indx: integer; cell: PCell);
		function WMKeyDown(Stat,Key: integer): boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure GotoBlock(s: string);
		procedure ToggleToolbar;
		function SelectDisabled(AnIndx,KStat,Clicks: integer): boolean; virtual;
		function GetColWidth(num: integer): integer;
		procedure SetColWidth(num: integer; width: longint; draw: boolean);
		function GetRowHeight(num: integer): integer;
		procedure SetRowHeight(num: integer; height: longint; draw: boolean);
		function GetColWidth_mm100(num: integer): word;
		procedure SetColWidth_mm100(num: integer; width: longint; draw: boolean);
		function GetRowHeight_mm100(num: integer): word;
		procedure SetRowHeight_mm100(num: integer; height: longint; draw: boolean);
		function FindObject(x,y: integer; sizer: boolean): longint;
		function GetCell(r,c: integer): PCell;
		procedure Cell2RC(cell: PCell; var r,c: integer);
		procedure Mouse2Cell(x,y: integer; var r,c: integer);
		procedure Cell2Rect(r,c: integer; var rect: LGRECT);
		procedure Cell2VRect(r,c: integer; var vrect: GRECT);
		procedure GetSheetRect(var sr: GRECT);
		function GetBlock(blck: string; whole: boolean; var rs,cs,re,ce,f1,f2: integer): boolean;
		function GetVisibleBlockRect(rs,cs,re,ce: integer; var sr: GRECT): boolean;
		procedure DrawCells(rs,cs,re,ce: integer);
		procedure DrawBlockRaw(rs,cs,re,ce: integer; const r: GRECT);
		procedure DrawBlock(rs,cs,re,ce: integer);
		procedure DrawCursor;
		procedure EnableInpline;
		procedure CancelInpline;
		function GetOutputLine(cell: PCell): string;
		procedure SetInpline(cell: PCell);
		procedure Calculate(clr: boolean);
		procedure AutoCalculate(clr: boolean);
		function NewNode(var p: PNode): boolean;
		procedure DeleteNode(var p: PNode);
		procedure TranslateCells(rs,cs,re,ce,rdif,cdif: integer; clr: boolean);
		function BuildFunction(cell: PCell; fnames: boolean): string;
		function BuildTree(cell: PCell; p: PNode; fnames: boolean; rrel,crel: integer): string;
		procedure NewVariable(ar,ac: integer; const aName: string);
		function EvalNode(cell: PCell; knoten: PNode): TNumber;
		function Evaluate(cell: PCell): TNumber;
		function GetCellValue(cell: PCell; clr: boolean): TNumber;
		function Error2Txt(err: shortint): string;
		procedure ChangeCell(cell: PCell; intxt: string; r,c: integer; chgval: boolean);
		procedure CheckToolbarTextFX(cell: PCell);
		procedure SetCursorPos(r,c: integer; scrl: boolean);
		procedure ClearCalcFlags;
		procedure SetBlock;
		procedure SetBorderSize;
		function ColIndex2Nr(indx: string; clip: boolean): integer;
		function GetColumnIndex(Nr: integer): string;
		function GetColumnName(Nr: integer): string;
		function GetRowIndex(Nr: integer): string;
		procedure SetScrollerRange;
		procedure SetPercentSize(pct: integer);
		function GetWindowFileName: string;
		procedure SetWindowFileName(s: string);
		procedure SetDirty;
		procedure ClearDirty;
		procedure SetFont(fIndex,fSize: integer);
		function GetStdFontIndex: integer;
		function GetStdFontSize: integer;
		function GetFontIndex: integer;
		function GetFontSize: integer;
		function FontID2Index(anid: integer): integer;
		function FontSize2Index(asize: integer): integer;
		function FontChanged(OrgID,AnID,ASize,AColor,BackColor,TheEffects,ARotation,ASkew,HorAlign,VertAlign,AWidth,TrackKern: integer; Size31: fix31; PairKern,cWnd: boolean): boolean; virtual;
		procedure FontSelect;
		procedure Cut; virtual;
		procedure Copy; virtual;
		procedure Paste; virtual;
		procedure Delete; virtual;
		procedure CutCells;
		procedure CopyCells;
		procedure PasteCells;
		procedure DeleteCells;
		procedure InsertFromClipboard(what,op: integer; empty,transpose,report,copyalign: boolean);
		function FreeCell(cell: PCell; clr: boolean): boolean;
		function FreeBlock(rs,cs,re,ce: integer; clr: boolean): boolean;
		procedure ClearBlock(rs,cs,re,ce: integer);
		function IsBlockUsed(rs,cs,re,ce,tnum: integer): boolean;
		function IsEmptyCell(cell: PCell): boolean;
		procedure InsertCells(rs,cs,re,ce,dir: integer);
		procedure Sort(n1,n2,n3,nrs: integer; n1up,n2up,n3up,rows,cse,ebeg,lex,absl,noattr: boolean);
		procedure SetBorder(ltyp,lcol,rtyp,rcol,otyp,ocol,utyp,ucol,htyp,hcol,vtyp,vcol,gtyp,gcol: integer);
		function Num2Hour(num: TNumber): integer;
		function Num2Minute(num: TNumber): integer;
		function Num2Second(num: TNumber): integer;
		function Num2Year(num: TNumber): longint;
		function Num2Month(num: TNumber): integer;
		function Num2Day(num: TNumber): integer;
		function Today: TNumber;
		function Now: TNumber;
		function Weekday(num: TNumber; typ: integer): integer;
		function DDGetPath: string; virtual;
		procedure OLGAGetInfo(OrgID,InfoNr: integer);
		procedure OLGAUpdated(OrgID,SrvID,InfoNr: integer; Link: string); virtual;
		procedure OLGARenameLink(OrgID: integer; OldLink,NewLink: string); virtual;
		procedure OLGALinkBroken(OrgID: integer; Link: string); virtual;
		procedure PRNChanged(Device,Action: integer);
		function NewNumFormat(s: string): integer;
		procedure DeselectAllObjects;
		function FirstSelectedObject: PEmbedded;
		procedure Embed(poi: POLGAObjectInfo; srvid: integer; ow,oh,x100,y100,dlen: longint; dat: pointer; poabuf: PEmbedBuf; pdb: PDiagrammbuf; xyvalid,prop,embd,drty,istad,prntflg,lckflg: boolean);
		procedure EmbedNewObject(fname: string; w100,h100,x100,y100,dlen: longint; dat: pointer; poabuf: PEmbedBuf; pdb: PDiagrammBuf; xyvalid,prop,embd,drty,istad,prntflg,lckflg: boolean);
		function CheckPasteObject(var p: PPopup): boolean;
		function PasteObject: boolean;
		procedure CallID4Server(fname: string);
		procedure Unembed(srvID: integer);
		procedure SetPercent(prc: real);
		function GetPercent: real;
		function IsNormalPrintArea: boolean;
		function IsBlockPrintArea: boolean;
		function GetPageFrom: integer;
		function GetPageTo: integer;
		function GetMulticopy(hdl: integer): integer;
		function GetCopies(hdl: integer): integer;
		function DoFeed: boolean;
		function DoSheet: boolean;
		function ClearDispList: boolean;
		procedure SetTextColor(ntc: integer);
		procedure SetCellColor(nc: integer);
		function GetHelp(mX,mY: integer): string; virtual;
		procedure ColorID(OrgID,mX,mY,palIndex: integer); virtual;
	end;

	TTexelApplication = object(TApplication)
		ExtResource,
		{$IFNDEF WDIALOG}
		UseExtPrn,
		{$ENDIF}
		UseNewToolbar,
		CheckHistory,
		GSActive,
		ColFX         : boolean;
		FormPredef,
		WebID,
		CABVersion,
		CABFlags4,
		CABFlags5,
		HelpID,
		GEMScriptID,
		oldTipStart,
		izitWind,
		SheetCount    : integer;
		izitTicks,
		mstimer       : longint;
		FormStart     : array [0..19] of integer;
		Browser,
		HelpItem      : string[41];
		LastPath,
		LastFile      : array [0..PFMAX] of string;
		fnt_titel,
		SumName,
		DataPath      : string;
		sccsid        : string[79];
		setupbuffer   : record
			stdrows     : string[5];
			stdcolumns  : string[3];
			stdcolwidth : string[3];
			autocalc,
			exceldate,
			stdfont,
			stdfsize    : integer;
			sizerrange  : string[1];
			floatpoint,
			history     : string[3];
			cursorwrap,
			xinputmode,
			closercancel,
			opennew,
			loaddoc,
			nothing,
			saveopt,
			savework,
			fullsize,
			wysiwyg,
			recalc,
			online,
			bak,
			formerr,
			formerrcell,
			toolbar,
			currency,
			overflow,
			bottomline,
			infodial,
			pixw,
			pixh        : integer
		end;
		app_prnt_set  : PPRN_SETTINGS;
		filebuf,
		prnt_dialog,
		fnt_dialog    : pointer;
		GSInfo        : PGSInfo;
		ascbuf        : TImportAscBuf;
		stdpsbuffer   : TPSBuffer;
		about,
		savework,
		websupport,
		webhelp,
		tips,
		help1,
		help2,
		help3,
		help4         : PMenu;
		help5,
		createdoc,
		options,
		saveopt,
		openurl,
		opennewdoc    : PKeyMenu;
		import,
		abruf         : PSubMenu;
		scripthnd     : PEvent;
		tipflags      : TTipFlags;
		stdprnbuffer  : TPrintBuffer;
		Fonts         : PFontCollection;
		Functions     : PFunctionCollection;
		Categories    : PCategoryCollection;
		UsrForm,
		Formats       : PFormatCollection;
		OLETypes      : POLECollection;
		FormCategories: PStringCollection;
		{$IFNDEF LITE}
		importscrap   : PHyperDialog;
		{$ENDIF}
		ddfiles       : PChar;
		saveglobal,
		extglobal     : global_ARRAY;
		ColorTable    : TOLGAColorTable;
		Monate        : array [1..12] of string[15];
		Monate3       : array [1..12] of string[3];
		Tage          : array [0..6] of string[15];
		Tage2         : array [0..6] of string[2];
		Farben        : array [0..15] of string[19];
		destructor Done; virtual;
		procedure SetupVDI; virtual;
		procedure InitInstance; virtual;
		procedure InitMainWindow; virtual;
		procedure LoadFile(p: PCalcWindow; s: string);
		procedure Terminate; virtual;
		procedure VAStart(OrgID: integer; Cmd: PChar); virtual;
		procedure FileSelected(Window: PWindow; OrgID: integer; Group: byte; Path: string; Files: PChar); virtual;
		procedure GetXAccAttr(var XAccAttr: TXAccAttr); virtual;
		procedure GetMenuEntries(var Entries: TMenuEntries); virtual;
		function GetIconTitle: string; virtual;
		function EscText2Formula(txt: string): string;
		function Num2Txt(fval: TNumber; fp: byte; cut0,komma: boolean): string;
		procedure Unembed(srvID: integer);
		procedure KommaToPunkt(var s: string);
		function ScriptByNumber(nr: longint; datei,zelle,prm: string): boolean;
		procedure HandleKeybd(Stat,Key: integer); virtual;
		procedure HandleMesag(Pipe: Pipearray); virtual;
		procedure HandleAV(Pipe: Pipearray); virtual;
		procedure HandleTimer; virtual;
		function GetMsTimer: longint; virtual;
		function GetStdFontIndex: integer;
		function GetStdFontSize: integer;
		procedure FontID2Index(var index: integer);
		procedure FontSize2Index(fntindx: integer; var index: integer);
		function DDReadArgs(dSize: longint; PipeHnd,OrgID,WindID,mX,mY,KStat: integer): boolean; virtual;
		procedure DDFinished(OrgID,WindID,mX,mY,KStat: integer); virtual;
		function DDGetPreferredTypes(WindID: integer): string; virtual;
		function IsInteger(s: string): boolean;
		function IsNumber(s: string; var num: TNumber; var nums: string; komma2punkt: boolean): boolean;
		{$IFNDEF LITE}
		procedure SCChanged(OrgID: integer; Bits: word; Ext: string); virtual;
		{$ENDIF}
		procedure PRNChanged(OrgID,Device,Action: integer); virtual;
{		procedure FNTChanged(OrgID: integer); virtual; ... }
		function SystemHasPrintDialog: boolean;
		function ExtPrnSel(var prnt_set: PPRN_SETTINGS; pcopyps: PPRN_SETTINGS): boolean;
		function NoFontSel: boolean;
		function Time2Str(atime: longint): string;
		procedure FileChanged(const s: string);
		procedure UpdateFile(const s: string; info: integer);
		procedure OLEExit(OrgID: integer); virtual;
		procedure OLGAInit(OrgID,Msg,Ver,eFlag: integer); virtual;
		procedure OLGAGetInfo(OrgID,InfoNr: integer); virtual;
		procedure OLGAAck(Pipe: Pipearray); virtual;
		procedure OLGAObjects(OrgID,Rest: integer; Ext,Descr: string); virtual;
		function LoadExtResource(fnam: string): boolean;
		procedure FreeExtResource;
		procedure ActivateExtResource;
		procedure DeactivateExtResource;
		function num2str(s: string): string;
		function XAccText(OrgID: integer; pText: pointer): boolean; virtual;
		function HelpAvailable(loadstg: boolean): boolean;
		procedure ErrorWindowMemory(p: PWindow);
		procedure InitSheetStructs(var parms: TTexelParms; var shbuf: TSheetBuffer; var dgbuf: TDialogBuffer; var zwbuf: TZielBuf; var dibuf: TDiagrammBuf; var exbuf: TExportBuf;
		                           var srbuf: TSortBuf; var inbuf: TInfoBuf; var fibuf: TFindBuf; var rebuf: TReplaceBuf; var flbuf: TFillBuffer);
		procedure FilterString(id: integer; var s: string);
		procedure FilterExportString(id: integer; var s: string);
		function dosmask(s: string): string;
		function macmask(s: string): string;
		procedure AbandonFile(p: PCalcWindow);
		procedure InitCells(cell: PCell; rmax,cmax: integer);
		function GetShortCreatorString: string;
		function GetCreatorString: string;
		function GetAuthorName: string;
		function IsSchaltjahr(year: integer; exceldate: boolean): boolean;
		function Days(year: integer; exceldate: boolean): integer;
		function CountDays(Year: longint; Month,Day: integer; exceldate: boolean): longint;
		function Date(Year: longint; Month,Day: integer; exceldate: boolean): TNumber;
		function IsDate(const s: string; var sz: TNumber; var ret: string; var frm: integer; exceldate: boolean): boolean;
		function Time(Hour,Minute,Second: integer): TNumber;
		function IsTime(const s: string; var sz: TNumber; var ret: string; var frm: integer): boolean;
		function DemoNervAlert(ende: boolean): boolean;
	end;

	PPSDialog = ^TPSDialog;
	TPSDialog = object(THyperDialog)
		ed1,
		ed2: PEdit;
		function OK: boolean; virtual;
		procedure MinimalHeadFoot;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;

{$IFNDEF WDIALOG}
	PPrintDialog = ^TPrintDialog;
	TPrintDialog = object(THyperDialog)
		drvinfo: PHyperDialog;
		devbox,
		paper  : PComboBox;
		drvbox : PDriverBox;
		inf,
		druck  : PButton;
		st1,
		st2,
		st3,
		st4,
		st5,
		st6,
		st7,
		st8,
		st9,
		st10,
		st11,
		st12   : PStatic;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure ShowInfo;
	end;
{$ENDIF}


function GetTexelTempDir: string;
procedure vOpnwk(device: integer; var handle: integer; var workOut: workout_Array; psize: integer; fname: string; var prnset: PPRN_SETTINGS);
function pinit_texel(d1,d2: pointer; d3,d4,d5: longint; settings: PPRN_SETTINGS; sub: PPDLG_SUB): longint;
function preset_texel(d1,d2: pointer; d3,d4,d5: longint; settings: PPRN_SETTINGS; sub: PPDLG_SUB): longint;
procedure free_sub_dialogs(sub_dialogs: PPDLG_SUB);


var

	TexelApp: TTexelApplication;
	regname,
	regkey  : string;
	mailbuf,
	helpbuf : pointer;




implementation

uses

	Strings,Dos,Tos,
	OProcs,
	txrsc,txlang,txprocs,txnewvdi,txvalida,txsave,txload,
	txfill,txdhst,tximport,txexport,txabout,txfunct,
	txchart,txprevie,txinfo,txprint,txzielwe,txkonst,
	txsort,txembed,txattr,txfindre,txmainob,txclear,txinsert,
	txformsh,txfont,txcolor,txtoolba,txpsetup,txscript,
	txparse,txinit;


type

	PObjAttrBox = ^TObjAttrBox;
	TObjAttrBox = object(TCheckBox)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;
	
	PObjSizeDialog = ^TObjSizeDialog;
	TObjSizeDialog = object(THyperDialog)
		embedobj: pointer;
		ed1,
		ed2,
		ed3,
		ed4     : PEdit;
		cb1,
		cb2     : PCheckBox;
		constructor Init(AParent: PWindow; AEmbed: pointer; ATitle,HypHelp,hdTitle: string; Indx: integer);
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;

	PObjAttrDialog = ^TObjAttrDialog;
	TObjAttrDialog = object(THyperDialog)
		embedobj: pointer;
		pbg     : PComboBox;
		setbtn  : integer;
		constructor Init(AParent: PWindow; AEmbed: pointer; ATitle,HypHelp,hdTitle: string; Indx,sbt: integer);
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;

	PElementCBDialog = ^TElementCBDialog;
	TElementCBDialog = object(TBlockChangeDialog)
		ed   : PEdit;
		elmcb: PEmbeddedCheckBox;
		procedure BlockChanged(blk: string); virtual;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;

{$IFNDEF LITE}
	PScrapDialog = ^TScrapDialog;
	TScrapDialog = object(THyperDialog)
		ext: string;
		procedure GetWindowClass(var AWndClass: TWndClass); virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
	end;
{$ENDIF}


var

	fnerror    : integer;
	callufsl   : UFSLPtr;
	callxfsl   : xFSLPtr;
	parserrwin : PCalcWindow;
	parserrcell: PCell;
	parserrpos : longint;



function pinit_texel(d1,d2: pointer; d3,d4,d5: longint; settings: PPRN_SETTINGS; sub: PPDLG_SUB): longint;
	var tree  : PTree;
	    offset: integer;

	begin
		tree:=PTree(sub^.tree);
		offset:=sub^.index_offset;
		if sub^.private1<>0 then
			case PCalcWindow(sub^.private1)^.prnRangeFlag of
			1:
				tree^[offset+RTPSD2].ob_state:=tree^[offset+RTPSD2].ob_state or SELECTED;
			2:
				tree^[offset+RTPSD3].ob_state:=tree^[offset+RTPSD3].ob_state or SELECTED;
			else
				tree^[offset+RTPSD1].ob_state:=tree^[offset+RTPSD1].ob_state or SELECTED
			end
		else
			with TexelApp.stdprnbuffer do
				begin
					if alles=bf_Checked then tree^[offset+RTPSD2].ob_state:=tree^[offset+RTPSD2].ob_state or SELECTED
					else
						if block=bf_Checked then tree^[offset+RTPSD3].ob_state:=tree^[offset+RTPSD3].ob_state or SELECTED
						else
							tree^[offset+RTPSD1].ob_state:=tree^[offset+RTPSD1].ob_state or SELECTED
				end;
		pinit_texel:=1
	end;


function preset_texel(d1,d2: pointer; d3,d4,d5: longint; settings: PPRN_SETTINGS; sub: PPDLG_SUB): longint;
	var tree  : PTree;
	    offset: integer;

	begin
		tree:=PTree(sub^.tree);
		offset:=sub^.index_offset;
		if sub^.private1<>0 then
			begin
				if bTst(tree^[offset+RTPSD1].ob_state,SELECTED) then PCalcWindow(sub^.private1)^.prnRangeFlag:=0;
				if bTst(tree^[offset+RTPSD2].ob_state,SELECTED) then PCalcWindow(sub^.private1)^.prnRangeFlag:=1;
				if bTst(tree^[offset+RTPSD3].ob_state,SELECTED) then PCalcWindow(sub^.private1)^.prnRangeFlag:=2
			end
		else
			begin
				with TexelApp.stdprnbuffer do
					begin
						pblock:=bf_Unchecked;
						alles:=bf_Unchecked;
						block:=bf_Unchecked
					end;
				if bTst(tree^[offset+RTPSD1].ob_state,SELECTED) then TexelApp.stdprnbuffer.pblock:=bf_Checked;
				if bTst(tree^[offset+RTPSD2].ob_state,SELECTED) then TexelApp.stdprnbuffer.alles:=bf_Checked;
				if bTst(tree^[offset+RTPSD3].ob_state,SELECTED) then TexelApp.stdprnbuffer.block:=bf_Checked
			end;
		preset_texel:=1
	end;


procedure free_sub_dialogs(sub_dialogs: PPDLG_SUB);
	var next: PPDLG_SUB;

	begin
		while sub_dialogs<>nil do
			begin
				next:=sub_dialogs^.next;
				freemem(sub_dialogs,sizeof(PDLG_SUB));
				sub_dialogs:=next
			end
	end;


procedure vOpnwk(device: integer; var handle: integer; var workOut: workout_Array; psize: integer; fname: string; var prnset: PPRN_SETTINGS);
	var q     : integer;
	    workIn: workin_Array;

	begin
   	for q:=1 to 9 do workIn[q]:=1;
		workIn[0]:=device;
 		workIn[10]:=RC;
		if TexelApp.ExtPrnSel(prnset,TexelApp.app_prnt_set) then
			begin
				with AES_pb do
					begin
						control^[0]:=205;
						control^[1]:=1;
						control^[2]:=1;
						control^[3]:=2;
						control^[4]:=0;
						intin^[0]:=9;
						addrin^[0]:=TexelApp.prnt_dialog;
						addrin^[1]:=prnset;
						_crystal(@AES_pb);
						if intout^[0]=0 then
							begin
								handle:=0;
								exit
							end
					end;
				with VDI_pb do
					begin
						control^[0]:=1;
						control^[1]:=0;
						control^[3]:=16;
						control^[6]:=0;
						for q:=0 to 10 do intin^[q]:=workIn[q];
						intin^[11]:=prnset^.size_id;
						intin^[12]:=integer(HiWord(@prnset^.device));
						intin^[13]:=integer(LoWord(@prnset^.device));
						intin^[14]:=integer(HiWord(prnset));
						intin^[15]:=integer(LoWord(prnset));
						vdi(@VDI_pb);
						handle:=control^[6];
						for q:=0 to 44 do workOut[q]:=intout^[q];
						for q:=0 to 11 do workOut[q+45]:=ptsout^[q]
					end
			end
		{$IFNDEF WDIALOG}
		else if (NVDIVersion>=$0300) and (Between(workIn[0],21,40) or Between(workIn[0],91,99)) then
			with VDI_pb do
				begin
					control^[0]:=1;
					control^[1]:=0;
					control^[3]:=16;
					control^[6]:=0;
					for q:=0 to 10 do intin^[q]:=workIn[q];
					if Between(workIn[0],31,40) then intin^[11]:=0
					else
						case psize of
						0..4:
							intin^[11]:=psize;
						5..9:
							intin^[11]:=psize+11
						else
							intin^[11]:=0
						end;
					if length(fname)=0 then
						begin
							intin^[12]:=0;
							intin^[13]:=0
						end
					else
						begin
							fname:=fname+#0;
							intin^[12]:=integer(HiWord(@fname[1]));
							intin^[13]:=integer(LoWord(@fname[1]))
						end;
					intin^[14]:=0;
					intin^[15]:=0;
					vdi(@VDI_pb);
					handle:=control^[6];
					for q:=0 to 44 do workOut[q]:=intout^[q];
					for q:=0 to 11 do workOut[q+45]:=ptsout^[q]
				end
		else
			v_opnwk(workIn,handle,workOut)
		{$ENDIF}
	end;


function GetTexelTempDir: string;
	var s: string;

	begin
		s:=GetTempDir;
		if s=BootDevice+':\' then
			begin
				s:=TexelApp.DataPath+TEXELTEMPPATH;
				if not(PathExist(s)) then dcreate(CutRightF(s,1)+#0)
			end
		else
			if TexelApp.apPath<>nil then
				if s=TexelApp.apPath^ then
					begin
						s:=TexelApp.DataPath+TEXELTEMPPATH;
						if not(PathExist(s)) then dcreate(CutRightF(s,1)+#0)
					end;
		GetTexelTempDir:=s
	end;


constructor THyperDialog.Init(AParent: PWindow; ATitle, HypHelp,hdTitle: string; Indx: integer);

	begin
		if not(inherited Init(AParent,ATitle,Indx)) then fail;
		if TexelApp.ExtResource then LoadIcon(new(PIcon,Init(@self,RTICONS2,RTI2CALC,0,0,false,false,'','')));
		ddfiles:=nil;
		ddtext:=nil;
		hdIconTitle:=hdTitle;
		HyperHelp:=HypHelp
	end;


function THyperDialog.Help: boolean;
	var pipe: Pipearray;

	begin
		Help:=false;
		if (length(HyperHelp)=0) or not(TexelApp.HelpAvailable(true)) then exit;
		if Exist(TexelApp.DataPath+TEXELHELP) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELP+' '+HyperHelp)
		else
			StrPCopy(helpbuf,GUIDES+TEXELHELP+' '+HyperHelp);
		pipe[0]:=VA_START;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(helpbuf));
		pipe[4]:=integer(LoWord(helpbuf));
		pipe[5]:=0;
		pipe[6]:=0;
		pipe[7]:=0;
		appl_write(TexelApp.HelpID,16,@pipe)
	end;


function THyperDialog.WMKeyDown(Stat,Key: integer): boolean;

	begin
		WMKeyDown:=false;
		if Stat=K_CTRL then
			if Parent<>nil then
				if Parent^.GetClassName=TEXELWINDCLASS then
					case Key of
					Ctrl_B:
						begin
							WMKeyDown:=true;
							with PCalcWindow(Parent)^ do if bblock<>nil then bblock^.Work
						end
					end
	end;


function THyperDialog.DDReadArgs(dSize: longint; PipeHnd,OrgID,mX,mY,KStat: integer): boolean;

	begin
		DDReadArgs:=false;
		if ddfiles<>nil then freemem(ddfiles,StrLen(ddfiles)+1);
		getmem(ddfiles,dSize+1);
		if ddfiles<>nil then
			begin
				if fread(PipeHnd,dSize,ddfiles)<>dSize then
					begin
						freemem(ddfiles,dSize+1);
						ddfiles:=nil
					end
				else
					begin
						PChar(longint(ddfiles)+dSize)^:=#0;
						DDReadArgs:=true
					end
			end
		else
			inherited DDReadArgs(dSize,PipeHnd,OrgID,mX,mY,KStat)
	end;


function THyperDialog.DDHeaderReply(dType,dName,fName: string; dSize: longint; OrgID,mX,mY,KStat: integer): byte;

	begin
		dType:=StrPUpper(dType);
		if (dType='.TXT') or (dType='.ASC') or (dType='.FLT') then DDHeaderReply:=DD_OK
		else
			DDHeaderReply:=DD_EXT
	end;


function THyperDialog.DDReadData(dType,dName,fName: string; dSize: longint; PipeHnd,OrgID,mX,mY,KStat: integer): boolean;
	label _fehler;

	var buffer: array [0..1023] of byte;
	    count : integer;
	    tflag,
	    fnsh  : boolean;
	    s,tag : string;

	procedure fillstr(anz: integer);
		var q,w: integer;

		begin
			if StrPUpper(dType)='.FLT' then
				begin
					q:=0;
					while q<anz do
						begin
							if buffer[q]=9 then
								begin
									s:=StrPTrimF(s)+' ';
									tflag:=true;
									tag:=''
								end
							else
								if tflag then
									begin
										if buffer[q]=ord(':') then tflag:=false
										else
											tag:=tag+chr(buffer[q])
									end
								else
									if tag<>'Group' then
										if buffer[q]>=32 then
											if length(s)<255 then s:=s+chr(buffer[q]);
							inc(q)
						end;
					ddtext^:=StrPTrimF(s);
					count:=length(ddtext^)
				end
			else
				for q:=0 to anz do
					begin
						if fnsh then exit;
						if count>=255 then exit;
						if buffer[q]=13 then fnsh:=true
						else
							if buffer[q]>=32 then
								if (count>0) or (buffer[q]<>64) then
									begin
										inc(count);
										ddtext^[count]:=chr(buffer[q])
									end
					end
		end;

	begin
		DDReadData:=false;
		if dSize<=0 then exit;
		if ddtext=nil then getmem(ddtext,256);
		if ddtext=nil then exit;
		tflag:=true;
		tag:='';
		s:='';
		count:=0;
		fnsh:=false;
		while dSize>1024 do
			begin
				if fread(PipeHnd,1024,@buffer)<>1024 then goto _fehler;
				fillstr(1023);
				dec(dSize,1024);
			end;
		if fread(PipeHnd,dSize,@buffer)<>dSize then goto _fehler;
		fillstr(dSize-1);
		if count=0 then goto _fehler;
		ddtext^[0]:=chr(count);
		DDReadData:=true;
		exit;
		_fehler:
		freemem(ddtext,256);
		ddtext:=nil
	end;


procedure THyperDialog.DDFinished(OrgID,mX,mY,KStat: integer);
	var p  : PChar;
	    q  : integer;
	    s,e: string;

	begin
		if ddtext<>nil then
			begin
				if GetClassName=TEXELWINDCLASS then
					with PCalcWindow(@self)^ do
						if (inpline<>nil) and not(inpstat) then
							begin
								if Parms.Cursor.Block then SetCursorPos(Parms.Cursor.Row,Parms.Cursor.Col,true);
								inpline^.Clear;
								EnableInpline
							end;
				for q:=1 to length(ddtext^) do InsertChar(ddtext^[q]);
				freemem(ddtext,256);
				ddtext:=nil
			end
		else
			if ddfiles<>nil then
				begin
					p:=ddfiles;
					while p<>nil do
						begin
							s:=GetQuotedName(p);
							if GetClassName=TEXELWINDCLASS then
								begin
									e:=StrPUpper(GetExtension(s));
									if e='.IMG' then
										begin
											{$IFNDEF LITE}
											if PCalcWindow(@self)^.grafik<>nil then PGrafik(PCalcWindow(@self)^.grafik)^.Load(s)
											{$ENDIF}
										end
									else if (e='.TXT') or (e='.ASC') then
										begin
											{$IFNDEF LITE}
											if PCalcWindow(@self)^.textobj<>nil then PTextObj(PCalcWindow(@self)^.textobj)^.Load(s)
											{$ENDIF}
										end
									else
										TexelApp.LoadFile(PCalcWindow(@self),s)
								end
							else
								TexelApp.LoadFile(nil,s)
						end;
					freemem(ddfiles,StrLen(ddfiles)+1);
					ddfiles:=nil
				end
	end;


function THyperDialog.GetIconTitle: string;

	begin
		GetIconTitle:=hdIconTitle
	end;


function TBlockChangeDialog.GetClassName: string;

	begin
		GetClassName:=BLOCKWINDCLASS
	end;


procedure TBlockChangeDialog.BlockChanged(blk: string);

	begin
	end;


constructor TCalcWindow.Init(psi: PSmallInfo);
	var dummy: longint;

	begin
		currvalid:=false;
		if not(inherited Init(nil,TEXELWINDPREFIX+'['+STRING_NONAME+' '+ltoa(TexelApp.SheetCount+1)+']',STG_CALCWINDOW,'',RTWDIALOG)) then fail;
		CommonInit1;
		if parser=nil then fail;
		inc(TexelApp.SheetCount);
		CommonParmInit(true);
		getmem(PRow,(Parms.Rows+1) shl 1);
		getmem(PCol,(Parms.Columns+1) shl 1);
		getmem(PColNames,(Parms.Columns+1) shl 2);
		if PColNames<>nil then fillchar(PColNames^,(Parms.Columns+1) shl 2,0);
		dummy:=longint(Parms.Rows+1)*longint(Parms.Columns+1)*CELLSIZE;
		getmem(Sheet,dummy);
		if Sheet<>nil then fillchar(Sheet^,dummy,0);
		if (PRow=nil) or (PCol=nil) or (Sheet=nil) or (PColNames=nil) or (PRowFlags=nil) or (PColFlags=nil) then
			begin
				TexelApp.ErrorWindowMemory(@self);
				Done;
				ArrowMouse;
				fail
			end;
		TexelApp.InitCells(Sheet,Parms.Rows+1,Parms.Columns+1);
		Sheet^.Flags:=CELL_SELECTED;
		ScanConst(TexelApp.DataPath,Parameter);
		if not(CommonInit2(true)) then
			begin
				Done;
				fail
			end;
		if psi<>nil then
			with psi^ do
				begin
					infobuf.Autor:=Autor;
					infobuf.Stichwort:=Stichwort;
					infobuf.Rem1:=Rem1;
					infobuf.Rem2:=Rem2;
					infobuf.Rem3:=Rem3;
					infobuf.DocTitle:=DocTitle
				end;
		pdirbox^.SetSelection(CRS_DOWN,true);
		if abandon<>nil then abandon^.Disable
	end;


{$IFNDEF LITE}

constructor TCalcWindow.InitImport(pg: PProgressWindow; rw,cl: integer; const FNam: string; ASheet: PCell; ARow,ACol: PWordArray; CNam: PItemList; breiten: boolean);
	var cell   : PCell;
	    errpos,
	    q,w    : longint;
	    errcode: integer;
	    vars   : string;
	    dummy  : PString;

	begin
		currvalid:=false;
		if FNam=StrPUpper(FNam) then vars:=StrPUpper(TEXELEXTENSION)
		else
			vars:=TEXELEXTENSION;
		if not(inherited Init(nil,CompressPath(GetPath(FNam)+GetFilename(FNam,false)+'.'+vars,76),STG_CALCWINDOW,'',RTWDIALOG)) then
			begin
				if pg<>nil then dispose(pg,Done);
				fail
			end;
		CommonInit1;
		if parser=nil then
			begin
				if pg<>nil then dispose(pg,Done);
				fail
			end;
		longfile:=GetPath(FNam)+GetFilename(FNam,false)+'.'+vars;
		Parms.Rows:=rw;
		Parms.Columns:=cl;
		CommonParmInit(false);
		if (PRowFlags=nil) or (PColFlags=nil) then
			begin
				if PRowFlags<>nil then freemem(PRowFlags,Parms.Rows+1);
				if PColFlags<>nil then freemem(PColFlags,Parms.Columns+1);
				TexelApp.ErrorWindowMemory(@self);
				fail
			end;
		Sheet:=ASheet;
		PRow:=ARow;
		PCol:=ACol;
		PColNames:=CNam;
		ScanConst(TexelApp.DataPath,Parameter);
		cell:=Sheet;
		for w:=0 to Parms.Rows do
			begin
				for q:=0 to Parms.Columns do
					begin
						if cell^.Typ=CTYPE_PARSED then
							begin
								{ !!! }
							end
						else
							if cell^.Typ=CTYPE_FORMULA then
								begin
									if PParser(parser)^.Parse(cell^.Data.Formula^.VarDef^,vars,cell^.Data.Formula^.Func,cell,w,q,true,errpos,errcode) then
										begin
											DisposeStr(cell^.Data.Formula^.VarDef);
											cell^.Data.Formula^.VarDef:=NewStr(vars)
										end
									else
										begin
											dummy:=cell^.Data.Formula^.VarDef;
											dispose(cell^.Data.Formula);
											cell^.Typ:=CTYPE_TEXT;
											cell^.Data.Txt:=dummy
										end
								end;
						inc(longint(cell),CELLSIZE)
					end;
				if pg<>nil then pg^.Progress(1)
			end;
		Sheet^.Flags:=CELL_SELECTED;
		if pg<>nil then dispose(pg,Done);
		if not(CommonInit2(breiten)) then
			begin
				Done;
				fail
			end;
		pdirbox^.SetSelection(CRS_DOWN,true);
		if abandon<>nil then abandon^.Disable;
		SetCursorPos(0,0,true);
		SheetCheckOverflow;
		Calculate(true)
	end;

{$ENDIF}


constructor TCalcWindow.InitFile(const FNam: string; pg: PProgressWindow; const AParm: TTexelParms; const ADBuf: TDialogBuffer; const ASBuf: TSheetBuffer; const FBuf: TFindBuf; const RBuf: TReplaceBuf; const FlBuf: TFillBuffer;
                                 const zBuf: TZielBuf; const ExBuf: TExportBuf; const SrtBuf: TSortBuf; const InfBuf: TInfoBuf; const DiaBuf: TDiagrammBuf;
                                 ASheet: PCell; ARow,ACol: PWordArray; CNam: PItemList; Parm: PParameterCollection; UFrm: PFormatCollection; ProtoEmb: PProtoEmbedded;
                                 apwd: TPassWord; bhist: PStringCollection; CFlags,RFlags: PByteArray; prntset: PPRN_SETTINGS; prnrange: integer; drt,checkover: boolean);
	var cell   : PCell;
	    errpos,
	    q,w    : longint;
	    vars   : string;
	    errcode,
	    r,c    : integer;
	    pv     : PVariable;
	    dummy  : PString;

	begin
		Curr:=AParm.CurrSize;
		currvalid:=true;
		if not(inherited Init(nil,CompressPath(FNam,76),STG_CALCWINDOW,'',RTWDIALOG)) then
			begin
				if pg<>nil then dispose(pg,Done);
				fail
			end;
		CommonInit1;
		if parser=nil then
			begin
				if pg<>nil then dispose(pg,Done);
				fail
			end;
		PassWord:=apwd;
		BlockHistory:=bhist;
		longfile:=FNam;
		Parms:=AParm;
		dtbuffer:=ADBuf;
		sheetbuffer:=ASBuf;
		findbuf:=FBuf;
		replacebuf:=RBuf;
		fillbuf:=FlBuf;
		exportbuf:=ExBuf;
		diagrammbuf:=DiaBuf;
		zwbuf:=zBuf;
		sortbuf:=SrtBuf;
		infobuf:=InfBuf;
		Sheet:=ASheet;
		PRow:=ARow;
		PCol:=ACol;
		PColNames:=CNam;
		PColFlags:=CFlags;
		PRowFlags:=RFlags;
		Parameter:=Parm;
		UsrFormats:=UFrm;
		tbactive:=(Parms.Toolbar=bf_Checked);
		if prntset<>nil then TexelApp.ExtPrnSel(wnd_prnt_set,prntset);
		if prnrange>=0 then prnRangeFlag:=prnrange;
		cell:=Sheet;
		for w:=0 to Parms.Rows do
			begin
				for q:=0 to Parms.Columns do
					begin
						if cell^.Typ=CTYPE_PARSED then
							begin
								cell^.Typ:=CTYPE_FORMULA;
								if cell^.Data.Formula^.VarDef<>nil then
									begin
										if Variables=nil then
											begin
												new(Variables,Init(20,10));
												if Variables<>nil then Variables^.CaseSensitive:=false
											end;
										if Variables<>nil then
											begin
												new(pv);
												if pv<>nil then
													begin
														pv^.Name:=NewStr(cell^.Data.Formula^.VarDef^);
														if pv^.Name=nil then dispose(pv)
														else
															begin
																pv^.RefRow:=w;
																pv^.RefCol:=q;
																Variables^.Insert(pv)
															end
													end
											end
									end
							end
						else
							if cell^.Typ=CTYPE_FORMULA then
								begin
									if PParser(parser)^.Parse(cell^.Data.Formula^.VarDef^,vars,cell^.Data.Formula^.Func,cell,w,q,true,errpos,errcode) then
										begin
											DisposeStr(cell^.Data.Formula^.VarDef);
											cell^.Data.Formula^.VarDef:=NewStr(vars)
										end
									else
										begin
											dummy:=cell^.Data.Formula^.VarDef;
											dispose(cell^.Data.Formula);
											cell^.Typ:=CTYPE_TEXT;
											cell^.Data.Txt:=dummy
										end
								end;
						inc(longint(cell),CELLSIZE)
					end;
				if pg<>nil then pg^.Progress(1)
			end;
		with Parms.Cursor do
			if not(Block) then
				begin
					cell:=GetCell(Row,Col);
					with cell^ do Flags:=Flags or CELL_SELECTED
				end
			else
				for r:=RowStart to RowEnd do
					begin
						cell:=GetCell(r,ColStart);
						for c:=ColStart to ColEnd do
							begin
								with cell^ do Flags:=Flags or CELL_SELECTED;
								inc(longint(cell),CELLSIZE)
							end
					end;
		if pg<>nil then dispose(pg,Done);
		if not(CommonInit2(true)) then
			begin
				Done;
				fail
			end;
		with dtbuffer do
			if (direction>=0) and (direction<=3) then pdirbox^.SetSelection(direction,true);
		if checkover then SheetCheckOverflow;
		if TexelApp.setupbuffer.recalc=bf_Checked then Calculate(true);
		if ProtoEmb<>nil then ProtoEmb^.Realize(@self);
		if drt then SetDirty;
		if abandon<>nil then abandon^.Disable
	end;


procedure TCalcWindow.CommonInit1;

	begin
		BusyMouse;
		wnd_prnt_set:=nil;
		Variables:=nil;
		BlockHistory:=nil;
		Embedded:=nil;
		Elements:=nil;
		Parameter:=nil;
		Fonts:=nil;
		attrdialog:=nil;
		links:=nil;
		if TexelApp.stdprnbuffer.alles=bf_Checked then prnRangeFlag:=1
		else
			if TexelApp.stdprnbuffer.block=bf_Checked then prnRangeFlag:=2
			else
				prnRangeFlag:=0;
		fnecell:=nil;
		fneOp:=0;
		Dirty:=false;
		closing:=false;
		PassWord.Flag:=0;
		PassWord.Code:=0;
		PassWord.Mask:=0;
		numWidth:=0;
		longfile:='';
		tbactive:=(TexelApp.setupbuffer.toolbar=bf_Checked);
		parser:=new(PParser,Init(@self))
	end;


function TCalcWindow.CommonInit2(breiten: boolean): boolean;
	var pf    : PFont;
	    fsizes: PStringCollection;
	    pfsb  : PFontSizeBox;
	    q,w   : integer;
	    sze   : longint;
	    ppcb  : PPercentBox;
	    s     : string;
	    found : boolean;
	    pfm   : PFormat;

	begin
		CommonInit2:=true;
		new(tbonoff,Init(@self,RTWDTBSWITCH,BUBBLE_FNBAR_TBONOFF));
		if tbactive then ToggleToolbar;
		sheetbuffer.rows:=ltoa(Parms.Rows+1);
		sheetbuffer.columns:=ltoa(Parms.Columns+1);
		PercentSize:=Parms.Percent/100;
		fillchar(rabuf,sizeof(rabuf),0);
		ScanFonts(vdiHandle,Attr.sysFonts+Attr.addFonts,Fonts);
		SetFont(GetStdFontIndex,GetStdFontSize);
		if (TexelApp.UsrForm^.Count>0) and (UsrFormats<>nil) then
			for q:=0 to TexelApp.UsrForm^.Count-1 do
				begin
					s:=PFormat(TexelApp.UsrForm^.At(q))^.Name^;
					found:=false;
					if UsrFormats^.Count>0 then
						for w:=0 to UsrFormats^.Count-1 do
							if PFormat(UsrFormats^.At(w))^.Name^=s then
								begin
									found:=true;
									break
								end;
					if not(found) then
						begin
							new(pfm);
							if pfm<>nil then
								begin
									pfm^.Name:=NewStr(s);
									pfm^.Group:=1;
									pfm^.Index:=1000+UsrFormats^.Count;
									UsrFormats^.Insert(pfm)
								end
						end
				end;
		pfbox:=new(PFontBox,InitCollection(@self,RTWDFONTPOP,RTWDFONTCYC,id_No,26,Fonts,false,false,false,BUBBLE_FNBAR_FONTID));
		if pfbox<>nil then
			begin
				pfbox^.SetShortcut('F');
				PFontBox(pfbox)^.newsize:=-1;
				new(fsizes,Init(130,20));
				new(pfsb,InitCollection(@self,RTWDSIZEPOP,RTWDSIZECYC,id_No,6,fsizes,true,false,false,BUBBLE_FNBAR_FONTSIZE));
				pfsb^.SetShortcut('R');
				pfsb^.setsize:=true;
				PFontBox(pfbox)^.fsizebox:=pfsb;
				pfbox^.Work;
				pfsb^.ChangeAlways:=true;
				pfbox^.ChangeAlways:=true
			end;
		new(ppcb,Init(@self,RTWDPERCENTPOP,RTWDPERCENTCYC,id_No,RTPOPUPS,RTPPERCENT,id_No,false,false,BUBBLE_FNBAR_PERCENT));
		if ppcb<>nil then ppcb^.SetShortcut('Z');
		pcbox:=new(PColorBox,Init(@self,RTWCOLORPOP,RTWCOLORCYC,id_No,RTPOPUPS,RTPCOLOR,RTPCOLSTART,false,false,BUBBLE_FNBAR_BACKCOLOR));
		ppbox:=new(PPatternBox,Init(@self,RTWPATTERNPOP,RTWPATTERNCYC,id_No,RTPOPUPS,RTPPATTERN,id_No,false,false,BUBBLE_FNBAR_PATTERN));
		new(pdirbox,Init(@self,RTWDCRSDIR,id_No,id_No,RTPOPUPS,RTPCRSDIR,id_No,false,false,BUBBLE_FNBAR_AUTOCURSOR));
		new(dblock,Init(@self,RTWDBLOCK,16,false,BUBBLE_FNBAR_BLOCK));
		new(inpcancel,Init(@self,RTWDCANCEL,BUBBLE_FNBAR_CANCEL));
		new(inpok,Init(@self,RTWDOK,BUBBLE_FNBAR_OK));
		new(inpline,Init(@self,RTWDINPUT,256));
		ptcbox:=new(PTextColorBox,Init(@self,RTWTCOLORPOP,RTWTCOLORCYC,id_No,RTPOPUPS,RTPCOLOR,RTPCOLSTART,false,false,BUBBLE_FNBAR_TEXTCOLOR));
		pbrdbox:=new(PBorderBox,Init(@self,RTWBORDERPOP,RTWBORDERCYC,id_No,RTPOPUPS,RTPRAHMEN,id_No,false,false,BUBBLE_FNBAR_BORDER));
		if pdirbox<>nil then
			begin
				if pdirbox^.Popup<>nil then pdirbox^.Popup^.AutoCheck:=false;
				pdirbox^.ChangeAlways:=true;
				pdirbox^.CenterX:=true
			end;
		if pbrdbox<>nil then
			begin
				pbrdbox^.CenterX:=true;
				pbrdbox^.ChangeAlways:=true
			end;
		if pcbox<>nil then pcbox^.ChangeAlways:=true;
		if ptcbox<>nil then ptcbox^.ChangeAlways:=true;
		if ppbox<>nil then
			begin
				ppbox^.ChangeAlways:=true;
				ppbox^.CenterX:=true
			end;
		if inpcancel<>nil then inpcancel^.Hide(false);
		if inpok<>nil then inpok^.Hide(false);
		if inpline<>nil then
			begin
				if MagiCVersion>=$0300 then inpline^.ObjAddr^.ob_spec.ted_info^.te_thickness:=-2;
				inpline^.Disable
			end;
		inpstat:=false;
		TransferBuffer:=@dtbuffer;
		if not(currvalid) then
			begin
				sze:=round(longint(Attr.boxHeight)*longint(Application^.Attr.PixH)/10.0);
				for q:=0 to Parms.Rows do SetRowHeight_mm100(q,sze,false);
				if breiten then
					begin
						sze:=round(longint(wWidth)*atol(TexelApp.setupbuffer.stdcolwidth)*longint(Application^.Attr.PixW)/10.0);
						for q:=0 to Parms.Columns do SetColWidth_mm100(q,sze,false)
					end
			end;
		SetBorderSize;
		SetBlock;
		if not(TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set)) then
			if paper<>nil then paper^.Disable;
		if currvalid then Scroller^.ScrollTo(Parms.ScrlXPos,Parms.ScrlYPos);
		ArrowMouse;
		{$IFDEF LITE}
		if (Parms.Rows>=MAXLINES) or (Parms.Columns>=MAXCOLUMNS) then Application^.Alert(nil,1,NOTE,MESSAGE_HOME_2BIG1+ltoa(MAXLINES)+MESSAGE_HOME_2BIG2+ltoa(MAXCOLUMNS)+MESSAGE_HOME_2BIG3,BUTTON_OK);
		{$ENDIF}
		if AppFlag then
			begin
				MakeWindow;
				if Application^.ChkError=em_InvalidWindow then
					begin
						Application^.Alert(@self,1,NOTE,MESSAGE_WINDOW_WINDOWS,BUTTON_OK);
						CommonInit2:=false
					end
			end
	end;


procedure TCalcWindow.CommonParmInit(setsize: boolean);

	begin
		new(UsrFormats,Init(50,25));
		if UsrFormats<>nil then UsrFormats^.Sort:=false;
		if setsize then
			with Parms do
				begin
					Rows:=atol(TexelApp.setupbuffer.stdrows)-1;
					Columns:=atol(TexelApp.setupbuffer.stdcolumns)-1
				end;
		TexelApp.InitSheetStructs(Parms,sheetbuffer,dtbuffer,zwbuf,diagrammbuf,exportbuf,sortbuf,infobuf,findbuf,replacebuf,fillbuf);
		getmem(PRowFlags,Parms.Rows+1);
		getmem(PColFlags,Parms.Columns+1);
		if PRowFlags<>nil then fillchar(PRowFlags^,Parms.Rows+1,0);
		if PColFlags<>nil then fillchar(PColFlags^,Parms.Columns+1,0);
	end;


procedure TCalcWindow.GetWorkMin(var minX,minY: integer);

	begin
		inherited GetWorkMin(minX,minY);
		if DlgTree<>nil then
			if minY<=DlgTree^[ROOT].ob_height then minY:=DlgTree^[ROOT].ob_height+1
	end;


function TCalcWindow.CanClose: boolean;
	var valid: boolean;
	    ret  : integer;

	begin
		valid:=inherited CanClose;
		if valid and Dirty then
			begin
				ret:=Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_CLOSE1+GetRawIconTitle+MESSAGE_WINDOW_CLOSE2,BUTTON_YESNOCANCEL);
				if ret=1 then
					begin
						closing:=true;
						alertret:=0;
						save^.Work;
						valid:=(alertret<>3);
						closing:=false
					end
				else
					if ret<>2 then valid:=false
			end;
		CanClose:=valid
	end;


function TCalcWindow.GetStyle: integer;

	begin
		GetStyle:=inherited GetStyle or SLIDER or FULLER or SIZER
	end;


function TCalcWindow.GetVDIHandle: integer;

	begin
		GetVDIHandle:=id_NewHandle
	end;


procedure TCalcWindow.GetWindowClass(var AWndClass: TWndClass);

	begin
		inherited GetWindowClass(AWndClass);
		with AWndClass do
			Style:=Style or cs_WorkBackground or cs_WindowMenuToolbar or cs_OLGADocument or cs_FreeOnClose or cs_Rubbox
	end;


function TCalcWindow.GetClassName: string;

	begin
		GetClassName:=TEXELWINDCLASS
	end;


function TCalcWindow.GetRawIconTitle: string;
	var t: string;

	begin
		t:=GetTitle;
		if StrPLeft(t,2)='* ' then t:=StrPRight(t,length(t)-2);
		if length(longfile)=0 then
			begin
				t:=StrPRight(t,length(t)-length(TEXELWINDPREFIX)-length(STRING_NONAME)-2);
				t:='TEXEL '+StrPLeft(t,length(t)-1)
			end
		else
			begin
				t:=StrPRight(longfile,length(longfile)-RPos('\',longfile));
				if RPos('.',t)>0 then t:=StrPLeft(t,RPos('.',t)-1)
			end;
		GetRawIconTitle:=t
	end;


function TCalcWindow.GetIconTitle: string;

	begin
		if Dirty then GetIconTitle:='*'+GetRawIconTitle
		else
			GetIconTitle:=GetRawIconTitle
	end;


function TCalcWindow.GetScroller: PScroller;

	begin
		GetScroller:=new(PCalcScroller,Init(@self,1,1,1,1));
		if Scroller<>nil then
			with Scroller^ do Style:=Style or scs_BitbltScrolling
	end;


procedure TCalcWindow.GetWorkMax(var maxX,maxY: integer);

	begin
		maxX:=maxint;
		maxY:=maxint
	end;


procedure TCalcWindow.SetupSize;
	var oldcurr: GRECT;

	procedure CheckBottomLine;
	
		begin
			if TexelApp.setupbuffer.bottomline=bf_Checked then
				begin
					dec(Full.H,TexelApp.Attr.boxSHeight);
					GRtoA2(Full);
					Curr:=Full;
					Calc(WC_WORK,Curr,Work)
				end
		end;

	begin
		with DlgTree^[ROOT] do
			begin
				PaintOffs:=ob_height+1;
				ob_width:=Application^.Attr.MaxPX
			end;
		oldcurr:=Curr;
		TWindow.SetupSize;
		if currvalid then
			begin
				if TexelApp.setupbuffer.fullsize=bf_Unchecked then
					begin
						GRtoA2(oldcurr);
						if oldcurr.X2>Sysinfo.Desktop.X2 then dec(oldcurr.X,oldcurr.X2-Sysinfo.Desktop.X2);
						if oldcurr.X<Sysinfo.Desktop.X then oldcurr.X:=SysInfo.Desktop.X;
						if oldcurr.X+oldcurr.W>=Sysinfo.Desktop.X2 then oldcurr.W:=Sysinfo.Desktop.X2+1-oldcurr.X;
						if oldcurr.Y2>Sysinfo.Desktop.Y2 then dec(oldcurr.Y,oldcurr.Y2-Sysinfo.Desktop.Y2);
						if oldcurr.Y<Sysinfo.Desktop.Y then oldcurr.Y:=SysInfo.Desktop.Y;
						if oldcurr.Y+oldcurr.H>=Sysinfo.Desktop.Y2 then oldcurr.H:=Sysinfo.Desktop.Y2+1-oldcurr.Y;
						GRtoA2(oldcurr);
						Curr:=oldcurr;
						Calc(WC_WORK,Curr,Work)
					end
				else
					CheckBottomLine
			end
		else
			CheckBottomLine
	end;


procedure TCalcWindow.SetupVDI;
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


procedure TCalcWindow.SetupWindow;
	var pt  : PColorToolbar;
	    pzw : PZielwert;
	    pide: PInsertDialogElement;
	    ptd : PTDiagram;
	    pcp : PCellProtect;
	    pcu : PCellUnprotect;

	begin
		inherited SetupWindow;
		Attr.ExStyle:=(Attr.ExStyle and not(ws_ex_TryModeless)) or ws_ex_Modeless;
		if currvalid or (TexelApp.setupbuffer.bottomline=bf_Checked) then Attr.ExStyle:=Attr.ExStyle and not(ws_ex_CenterOnce);
		LoadMenu(RTWMENU,false);
		LoadIcon(new(PIcon,Init(@self,RTICONS,RTICALC,0,0,false,false,'','')));
		bblock:=new(PBlock,Init(@self,K_CTRL,Ctrl_B,nil,false));
		save:=new(PSave,Init(@self,K_CTRL,Ctrl_S,RTWMSAVE,RTWM2));
		saveas:=new(PSaveAs,Init(@self,K_CTRL,Ctrl_M,RTWMSAVEAS,RTWM2));
		abandon:=new(PAbandon,Init(@self,K_CTRL,Ctrl_H,RTWMABANDON,RTWM2));
		export:=new(PExport,Init(@self,K_CTRL,Ctrl_E,RTWMEXPORT,RTWM2));
		prnt:=new(PPrint,Init(@self,K_CTRL,Ctrl_P,RTWMPRINT,RTWM2));
		pagesetup:=new(PPageSetup,Init(@self,K_CTRL+K_SHIFT,Ctrl_P,RTWMPAGESETUP,RTWM2));
		preview:=new(PPreview,Init(@self,K_ALT,Alt_P,RTWMPREVIEW,RTWM2));
		paper:=new(PPaper,Init(@self,K_ALT+K_SHIFT,Alt_P,RTWMPAPER,RTWM2));
		new(PInfo,Init(@self,K_CTRL,Ctrl_I,RTWMINFO,RTWM2));
		clrinh:=new(PClear,Init(@self,RTWMCLEAR,RTPOPUPS,RTPCLEAR));
		objects:=new(PObjects,Init(@self,RTWMOBJECTS,RTPOPUPS,RTPOBJECTS));
		if objects<>nil then objects^.Disable;
		new(PClearCell,Init(@self,K_CTRL,Ctrl_D,RTWMCLEARCELL,RTWM3));
		find:=new(PFind,Init(@self,K_CTRL,Ctrl_F,RTWMFIND,RTWM3));
		if find<>nil then
			begin
				PFind(find)^.rb1:=nil;
				PFind(find)^.rb2:=nil
			end;
		new(PFindNext,Init(@self,K_CTRL,Ctrl_G,RTWMFINDNEXT,RTWM3));
		replace:=new(PReplace,Init(@self,K_CTRL,Ctrl_R,RTWMREPLACE,RTWM3));
		if replace<>nil then
			begin
				PReplace(replace)^.rb1:=nil;
				PReplace(replace)^.rb2:=nil
			end;
		new(PReplaceNext,Init(@self,K_CTRL,Ctrl_T,RTWMREPLACENEXT,RTWM3));
		new(pcp,Init(@self,RTWMPROTECT,nil,false));
		if pcp<>nil then pcp^.Disable; { ... }
		new(pcu,Init(@self,RTWMUNPROTECT,nil,false));
		if pcu<>nil then pcu^.Disable; { ... }
		new(PInsert,Init(@self,K_NORMAL,S_Insert,RTWMINSERT,RTWM4));
		new(PInsertCell,Init(@self,K_CTRL+K_SHIFT,Ctrl_V,RTWMINSCELL,RTWM4));
		insrow:=new(PInsertRows,Init(@self,K_CTRL,Ctrl_Insert,RTWMINSROWS,RTWM4));
		inscol:=new(PInsertColumns,Init(@self,K_CTRL+K_SHIFT,CtrlShift_Insert,RTWMINSCOLS,RTWM4));
		new(PUmbruch,Init(@self,K_CTRL+K_SHIFT,Ctrl_U,RTWMUMBRUCH,RTWM4));
		insfunc:=new(PFunktion,Init(@self,K_CTRL+K_SHIFT,Ctrl_F,RTWMFUNCTION,RTWM4));
		diagramm:=new(PDiagram,Init(@self,K_CTRL+K_SHIFT,Ctrl_D,RTWMDIAGRAM,RTWM4));
		grafik:=new(PGrafik,Init(@self,K_CTRL+K_SHIFT,Ctrl_G,RTWMIMAGE,RTWM4));
		textobj:=new(PTextObj,Init(@self,K_ALT+K_SHIFT,Alt_T,RTWMTEXT,RTWM4));
		new(pide,Init(@self,RTWMDIALOG,RTPOPUPS,RTPDIALOG));
		oleobject:=new(POLEObject,Init(@self,K_CTRL+K_SHIFT,Ctrl_O,RTWMOBJECT,RTWM4));
		{$IFNDEF LITE}
		if oleobject<>nil then
			if TexelApp.OLETypes<>nil then oleobject^.Enable;
		{$ENDIF}
		fill:=new(PFill,Init(@self,RTWMFILL,RTPOPUPS,RTPFILL));
		if fill<>nil then PFill(fill)^.reihe:=nil;
		if fill<>nil then fill^.Disable; { !!! }
		new(PFormCell,Init(@self,RTWMFORMCELL,RTPOPUPS,RTPFORMCELL));
		formrow:=new(PFormRow,Init(@self,RTWMFORMROW,RTPOPUPS,RTPFORMROW));
		formcol:=new(PFormCol,Init(@self,RTWMFORMCOL,RTPOPUPS,RTPFORMCOL));
		new(PFormSheet,Init(@self,K_CTRL+K_SHIFT,Ctrl_B,RTWMFORMSHEET,RTWM5));
		new(pzw,Init(@self,K_ALT+K_SHIFT,Alt_S,RTWMFINDVALUE,RTWM6));
		new(PSort,Init(@self,K_ALT,Alt_S,RTWMSORT,RTWM6));
		{$IFNDEF LITE}
		konstanten:=new(PKonst,Init(@self,K_CTRL,Ctrl_K,RTWMCONST,RTWM6));
		{$ENDIF}
		new(PCalculate,Init(@self,K_CTRL,Ctrl_Return,RTWMUPDATE,RTWM6));
		new(PGoto,Init(@self,RTWMGOTO,nil,false));
		new(pt,Init(@self,RTWTSAVE,RTWTCSAVE,false,BUBBLE_TOOLBAR_SAVE));
		if pt<>nil then pt^.SetMenuIndex(RTWMSAVE);
		new(pt,Init(@self,RTWTPRINT,RTWTCPRINT,false,BUBBLE_TOOLBAR_PRINT));
		if pt<>nil then pt^.SetMenuIndex(RTWMPRINT);
		if not(Application^.GDOSActive) then
			begin
				if prnt<>nil then prnt^.Disable;
				if preview<>nil then preview^.Disable;
				if paper<>nil then paper^.Disable;
				if pt<>nil then pt^.Disable
			end;
		new(PTCut,Init(@self,RTWTCUT,RTWTCCUT,false,BUBBLE_TOOLBAR_CUT));
		new(PTCopy,Init(@self,RTWTCOPY,RTWTCCOPY,false,BUBBLE_TOOLBAR_COPY));
		new(PTPaste,Init(@self,RTWTPASTE,RTWTCPASTE,false,BUBBLE_TOOLBAR_PASTE));
		tsumme:=new(PTSumme,Init(@self,RTWTSUM,RTWTCSUM,false,BUBBLE_TOOLBAR_SUM));
		new(PTFunction,Init(@self,RTWTFN,RTWTCFN,false,BUBBLE_TOOLBAR_FN));
		pfett:=new(PTFett,Init(@self,RTWTFETT,RTWTCFETT,true,BUBBLE_TOOLBAR_BOLD));
		pkursiv:=new(PTKursiv,Init(@self,RTWTKURSIV,RTWTCKURSIV,true,BUBBLE_TOOLBAR_ITALIC));
		punter:=new(PTUnter,Init(@self,RTWTUNTERSTR,RTWTCUNTERSTR,true,BUBBLE_TOOLBAR_UNDERL));
		palignleft:=new(PTAlignLeft,Init(@self,RTWTLINKS,RTWTCLINKS,true,BUBBLE_TOOLBAR_LEFT));
		paligncenter:=new(PTAlignCenter,Init(@self,RTWTMITTE,RTWTCMITTE,true,BUBBLE_TOOLBAR_CENTER));
		palignright:=new(PTAlignRight,Init(@self,RTWTRECHTS,RTWTCRECHTS,true,BUBBLE_TOOLBAR_RIGHT));
		new(PTNumber,Init(@self,RTWTNUMBER,RTWTCNUMBER,false,BUBBLE_TOOLBAR_NUMBER));
		new(PTDate,Init(@self,RTWTDATE,RTWTCDATE,false,BUBBLE_TOOLBAR_DATE));
		new(PTMoney,Init(@self,RTWTMONEY,RTWTCMONEY,false,BUBBLE_TOOLBAR_MONEY));
		new(PTPercent,Init(@self,RTWTPERCENT,RTWTCPERCENT,false,BUBBLE_TOOLBAR_PERCENT));
		new(PTSortAuf,Init(@self,RTWTSORTAUF,RTWTCSORTAUF,false,BUBBLE_TOOLBAR_SORTUP));
		new(PTSortAb,Init(@self,RTWTSORTAB,RTWTCSORTAB,false,BUBBLE_TOOLBAR_SORTDOWN));
		dezplus:=new(PTDezPlus,Init(@self,RTWTDEZPLUS,RTWTCDEZPLUS,false,BUBBLE_TOOLBAR_FPLUS));
		dezminus:=new(PTDezMinus,Init(@self,RTWTDEZMINUS,RTWTCDEZMINUS,false,BUBBLE_TOOLBAR_FMINUS));
		new(ptd,Init(@self,RTWTDIAGRAM,RTWTCDIAGRAM,false,BUBBLE_TOOLBAR_DIAGRAM));
		new(PTHome,Init(@self,RTWTHOME,RTWTCHOME,false,BUBBLE_TOOLBAR_HOME));
		{$IFDEF LITE}
		if oleobject<>nil then oleobject^.Disable;
		if export<>nil then export^.Disable;
		if pzw<>nil then pzw^.Disable;
		if pide<>nil then pide^.Disable;
		if textobj<>nil then textobj^.Disable;
		if grafik<>nil then grafik^.Disable;
		if diagramm<>nil then diagramm^.Disable;
		if ptd<>nil then ptd^.Disable;
		{$ENDIF}
		Fonts:=nil;
		PColNames:=nil;
		PRowFlags:=nil;
		PColFlags:=nil;
		PRow:=nil;
		PCol:=nil;
		Sheet:=nil
	end;


procedure TCalcWindow.ShutdownWindow;
	var q   : longint;
	    cell: PCell;

	begin
		links:=nil;
		while (Embedded<>nil) do Embedded^.Free;
		if Fonts<>nil then dispose(Fonts,Done);
		if Parameter<>nil then dispose(Parameter,Done);
		if UsrFormats<>nil then dispose(UsrFormats,Done);
		if Variables<>nil then dispose(Variables,Done);
		if BlockHistory<>nil then dispose(BlockHistory,Done);
		if PColNames<>nil then
			begin
				for q:=0 to Parms.Columns do DisposeStr(PString(PColNames^[q]));
				freemem(PColNames,(Parms.Columns+1) shl 2);
			end;
		if PRowFlags<>nil then freemem(PRowFlags,Parms.Rows+1);
		if PColFlags<>nil then freemem(PColFlags,Parms.Columns+1);
		if PRow<>nil then freemem(PRow,(Parms.Rows+1) shl 1);
		if PCol<>nil then freemem(PCol,(Parms.Columns+1) shl 1);
		if wnd_prnt_set<>nil then
			with AES_pb do
				begin
					control^[0]:=205;
					control^[1]:=1;
					control^[2]:=1;
					control^[3]:=1;
					control^[4]:=0;
					intin^[0]:=6;
					addrin^[0]:=wnd_prnt_set;
					_crystal(@AES_pb)
				end;
		if Sheet<>nil then
			begin
				cell:=Sheet;
				for q:=0 to longint(Parms.Rows)*longint(Parms.Columns)+longint(Parms.Rows)+longint(Parms.Columns) do
					begin
						case cell^.Typ of
						CTYPE_TEXT:
							DisposeStr(cell^.Data.Txt);
						CTYPE_CONST:
							begin
								DisposeStr(cell^.Data.Konst^.Txt);
								dispose(cell^.Data.Konst)
							end;
						CTYPE_FORMULA:
							begin
								DisposeStr(cell^.Data.Formula^.VarDef);
								DeleteNode(cell^.Data.Formula^.Func);
								dispose(cell^.Data.Formula)
							end
						end;
						inc(longint(cell),CELLSIZE)
					end;
				freemem(Sheet,longint(Parms.Rows+1)*longint(Parms.Columns+1)*CELLSIZE)
			end
	end;


procedure TCalcWindow.PaintNumbers(rect: GRECT);
	var clp,clp2: GRECT;
	    w,dummy : integer;
	    xy      : ARRAY_4;

	begin
		if TexelApp.ColFX then
			begin
				vsf_interior(vdiHandle,FIS_SOLID);
				vsf_color(vdiHandle,LWhite)
			end;
		
		{ Offsets berechnen... }
		
		{ oberen Offset berechnen }
		tpoffs:=Scroller^.YPos;
		tcnum:=0;
		while tpoffs>=0 do
			begin
				dec(tpoffs,GetRowHeight(tcnum));
				inc(tcnum)
			end;
		dec(tcnum);
		inc(tpoffs,GetRowHeight(tcnum));
		{ erste Spalte jeder Zeile }
		w:=tcnum;
		clp.X:=Work.X;
		clp.Y:=Work.Y+PaintOffs+TopRowHeight+1;
		clp.W:=LeftColWidth;
		clp.H:=GetRowHeight(w)-tpoffs;
		xy[0]:=clp.X-1;
		xy[1]:=clp.Y-tpoffs-1;
		xy[2]:=clp.X+clp.W;
		GRtoA2(clp);
		vst_alignment(vdiHandle,TA_CENTER,TA_BOTTOM,dummy,dummy);
		repeat
			clp2:=clp;
			inc(w);
			if rc_intersect(rect,clp2) then
				begin
					vs_clip(Application^.vdiHandle,CLIP_ON,clp2.A2);
					vs_clip(vdiHandle,CLIP_ON,clp2.A2);
					xy[3]:=clp.Y2;
					v_bar(Application^.vdiHandle,xy);
					dec(xy[3]);
					if TexelApp.ColFX then
						begin
							inc(xy[0],2);
							inc(xy[1],2);
							v_bar(vdiHandle,xy);
							dec(xy[0],2)
						end;
					vswr_mode(vdiHandle,MD_TRANS);
					v_gtext(vdiHandle,(xy[0]+xy[2]) shr 1,xy[3],ltoa(w));
					vswr_mode(vdiHandle,MD_REPLACE)
				end;
			if w>Parms.Rows then break;
			clp.Y1:=clp.Y2+1;
			inc(clp.Y2,GetRowHeight(w));
			A2toGR(clp);
			xy[1]:=clp.Y-1
		until clp.Y1>Work.Y2;
		if clp.Y2<Work.Y2 then
			begin
				vs_clip(vdiHandle,CLIP_ON,SysInfo.Desktop.A2);
				if TexelApp.ColFX then
					begin
						vsf_interior(vdiHandle,FIS_SOLID);
						vsf_color(vdiHandle,LWhite)
					end
				else
					vsf_interior(vdiHandle,FIS_HOLLOW);
				clp2.X:=Work.X1;
				clp2.Y:=clp.Y2+1;
				clp2.W:=LeftColWidth;
				clp2.H:=Work.Y2-clp.Y2;
				if rc_intersect(rect,clp2) then vr_recfl(vdiHandle,clp2.A2)
			end;
		vst_alignment(vdiHandle,TA_LEFT,TA_BASELINE,dummy,dummy)
	end;


procedure TCalcWindow.PaintNames(rect: GRECT);
	var clp,clp2: GRECT;
	    q,dummy : integer;
	    xy      : ARRAY_4;

	begin
		if TexelApp.ColFX then
			begin
				vsf_interior(vdiHandle,FIS_SOLID);
				vsf_color(vdiHandle,LWhite)
			end;
		
		{ Offsets berechnen... }
		
		{ linken Offset berechnen }
		lpoffs:=Scroller^.XPos;
		lcnum:=0;
		while lpoffs>=0 do
			begin
				dec(lpoffs,GetColWidth(lcnum));
				inc(lcnum)
			end;
		dec(lcnum);
		inc(lpoffs,GetColWidth(lcnum));
		{ erste Zeile zeichnen }
		q:=lcnum;
		clp.X:=Work.X+LeftColWidth+1;
		clp.Y:=Work.Y+PaintOffs;
		clp.W:=GetColWidth(q)-lpoffs-1;
		clp.H:=TopRowHeight;
		xy[0]:=clp.X-lpoffs-1;
		xy[1]:=clp.Y-1;
		xy[3]:=clp.Y+clp.H;
		GRtoA2(clp);
		vst_alignment(vdiHandle,TA_CENTER,TA_BOTTOM,dummy,dummy);
		repeat
			clp2:=clp;
			if rc_intersect(rect,clp2) then
				begin
					vs_clip(Application^.vdiHandle,CLIP_ON,clp2.A2);
					vs_clip(vdiHandle,CLIP_ON,clp2.A2);
					xy[2]:=clp.X2;
					v_bar(Application^.vdiHandle,xy);
					if TexelApp.ColFX then
						begin
							inc(xy[0],2);
							inc(xy[1],2);
							dec(xy[2]);
							v_bar(vdiHandle,xy);
							dec(xy[1],2)
						end;
					vswr_mode(vdiHandle,MD_TRANS);
					v_gtext(vdiHandle,(xy[0]+xy[2]) shr 1,xy[3],GetColumnName(q));
					vswr_mode(vdiHandle,MD_REPLACE)
				end;
			inc(q);
			if q>Parms.Columns then break;
			clp.X1:=clp.X2+1;
			inc(clp.X2,GetColWidth(q));
			A2toGR(clp);
			xy[0]:=clp.X-1
		until clp.X1>Work.X2;
		if clp.X2<Work.X2 then
			begin
				vs_clip(vdiHandle,CLIP_ON,SysInfo.Desktop.A2);
				if TexelApp.ColFX then
					begin
						vsf_interior(vdiHandle,FIS_SOLID);
						vsf_color(vdiHandle,LWhite)
					end
				else
					vsf_interior(vdiHandle,FIS_HOLLOW);
				clp2.X:=clp.X2+1;
				clp2.Y:=Work.Y+PaintOffs;
				clp2.W:=Work.X2-clp.X2;
				clp2.H:=TopRowHeight;
				if rc_intersect(rect,clp2) then vr_recfl(vdiHandle,clp2.A2)
			end;
		vst_alignment(vdiHandle,TA_LEFT,TA_BASELINE,dummy,dummy)
	end;


function TCalcWindow.Val2TxtF(fval: TNumber; fp: byte; frm: integer; cell: PCell): string;
	var txt: string;

	begin
		Val2Txt(fval,txt,fp,frm,cell);
		Val2TxtF:=txt
	end;


function TCalcWindow.Val2Txt(fval: TNumber; var vtxt: string; fp: byte; frm: integer; cell: PCell): boolean;
	var q,usr: integer;

	procedure interprete;
		var pmz,
		    state   : integer;
		    n       : longint;
		    pfm     : PFormat;
		    orgval  : TNumber;
		    dummy,
		    dummy2  : string[19];
		    frmt    : string[59];
		    ret     : string;
		    ch      : char;
		    backflag,
	  	  found   : boolean;

		procedure symb2val;
			label _fvalvalid;
			
			var w: integer;

			function fvalvalid(s: string): boolean;
				var s2: string[19];
				    i : integer;
			
				function s2valid: boolean;
				
					begin
						s2valid:=false;
						case s2[1] of
						'=':
							begin
								if atof(CutLeftF(s2,1))<>orgval then exit
							end;
						'>':
							begin
								if s2[2]='=' then
									begin
										if orgval<atof(CutLeftF(s2,2)) then exit
									end
								else
									if orgval<=atof(CutLeftF(s2,1)) then exit
							end;
						'<':
							begin
								if s2[2]='=' then
									begin
										if orgval>atof(CutLeftF(s2,2)) then exit
									end
								else
									if orgval>=atof(CutLeftF(s2,1)) then exit
							end;
						else
							begin
								exit
							end
						end;
						s2valid:=true
					end;

				begin
					fvalvalid:=true;
					while length(s)>0 do
						begin
							i:=pos(',',s);
							if i>0 then
								begin
									s2:=StrPLeft(s,i-1);
									s:=StrPRight(s,length(s)-i)
								end
							else
								begin
									s2:=s;
									s:=''
								end;
							if not(s2valid) then
								begin
									fvalvalid:=false;
									exit
								end
						end
				end;

			begin
				if dummy='T' then
					begin
						vtxt:=vtxt+ltoa(Num2Day(fval));
						exit
					end;
				if dummy='TT' then
					begin
						n:=Num2Day(fval);
						if n<10 then vtxt:=vtxt+'0';
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='TTT' then
					begin
						vtxt:=vtxt+TexelApp.Tage2[Weekday(fval,3)];
						exit
					end;
				if dummy='TTTT' then
					begin
						vtxt:=vtxt+TexelApp.Tage[Weekday(fval,3)];
						exit
					end;
				if dummy='M' then
					begin
						vtxt:=vtxt+ltoa(Num2Month(fval));
						exit
					end;
				if dummy='MM' then
					begin
						n:=Num2Month(fval);
						if n<10 then vtxt:=vtxt+'0';
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='MMM' then
					begin
						vtxt:=vtxt+TexelApp.Monate3[Num2Month(fval)];
						exit
					end;
				if dummy='MMMM' then
					begin
						vtxt:=vtxt+TexelApp.Monate[Num2Month(fval)];
						exit
					end;
				if dummy='J' then
					begin
						vtxt:=vtxt+ltoa(Num2Year(fval) mod 100);
						exit
					end;
				if dummy='JJ' then
					begin
						n:=Num2Year(fval) mod 100;
						if n<10 then vtxt:=vtxt+'0';
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='JJJJ' then
					begin
						vtxt:=vtxt+ltoa(Num2Year(fval));
						exit
					end;
				if dummy='H' then
					begin
						n:=Num2Hour(fval);
						if n>12 then dec(n,12);
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='HH' then
					begin
						n:=Num2Hour(fval);
						if n>12 then dec(n,12);
						if n<10 then vtxt:=vtxt+'0';
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='#h' then
					begin
						vtxt:=vtxt+ltoa(Num2Hour(fval)+24*trunc(fval));
						exit
					end;
				if dummy='h' then
					begin
						vtxt:=vtxt+ltoa(Num2Hour(fval));
						exit
					end;
				if dummy='hh' then
					begin
						n:=Num2Hour(fval);
						if n<10 then vtxt:=vtxt+'0';
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='m' then
					begin
						vtxt:=vtxt+ltoa(Num2Minute(fval));
						exit
					end;
				if dummy='mm' then
					begin
						n:=Num2Minute(fval);
						if n<10 then vtxt:=vtxt+'0';
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='s' then
					begin
						vtxt:=vtxt+ltoa(Num2Second(fval));
						exit
					end;
				if dummy='ss' then
					begin
						n:=Num2Second(fval);
						if n<10 then vtxt:=vtxt+'0';
						vtxt:=vtxt+ltoa(n);
						exit
					end;
				if dummy='w' then
					begin
						if abs(fval)>maxlongint then vtxt:=vtxt+'###'
						else
							vtxt:=vtxt+ltoa(trunc(fval) mod 360);
						exit
					end;
				if dummy='wm' then
					begin
						if abs(fval)>maxlongint then vtxt:=vtxt+'##'
						else
							vtxt:=vtxt+ltoa(trunc(frac(fval)*60.0));
						exit
					end;
				if dummy='ws' then
					begin
						if abs(fval)>maxlongint then vtxt:=vtxt+'##'
						else
							vtxt:=vtxt+ltoa(trunc(frac(frac(fval)*60.0)*60.0));
						exit
					end;
				if StrPLeft(dummy,1)='$' then
					begin
						vtxt:=vtxt+CutLeftF(ltoh(trunc(fval),atol(CutLeftF(dummy,1))),1);
						exit
					end;
				if StrPLeft(dummy,1)='%' then
					begin
						vtxt:=vtxt+CutLeftF(ltob(trunc(fval),atol(CutLeftF(dummy,1))),1);
						exit
					end;
				if StrPLeft(dummy,1)='&' then
					begin
						vtxt:=vtxt+CutLeftF(ltoo(trunc(fval),atol(CutLeftF(dummy,1))),1);
						exit
					end;
				w:=pos('/',dummy);
				if w>0 then
					begin
						n:=Num2Hour(fval);
						if n>12 then vtxt:=vtxt+StrPRight(dummy,length(dummy)-w)
						else
							vtxt:=vtxt+StrPLeft(dummy,w-1);
						exit
					end;
				{ Attribute ... }
				if cell<>nil then
					begin
						w:=pos('|',dummy);
						if w>0 then
							begin
								dummy2:=StrPRight(dummy,length(dummy)-w);
								dummy:=StrPLeft(dummy,w-1);
								while length(dummy2)>0 do
									begin
										w:=pos('|',dummy2);
										if w>0 then
											begin
												if fvalvalid(StrPLeft(dummy2,w-1)) then goto _fvalvalid;
												dummy2:=StrPRight(dummy2,length(dummy2)-w)
											end
										else
											begin
												if fvalvalid(dummy2) then goto _fvalvalid;
												dummy2:=''
											end
									end;
								exit
							end;
						_fvalvalid:
						if dummy[1]='\' then
							begin
								backflag:=true;
								CutLeft(dummy,1)
							end
						else
							backflag:=false;
						found:=false;
						for w:=0 to 15 do
							if dummy=TexelApp.Farben[w] then
								begin
									found:=true;
									break
								end;
						if found then
							begin
								if backflag then
									begin
										cell^.Color:=w;
										cell^.Interior:=FIS_SOLID;
										cell^.Style:=8;
										Val2Txt:=true
									end
								else
									cell^.TxtVal.Color:=w
							end
					end
			end;

		procedure num2val;
			label _wiss;

			var w,e: integer;
			    r  : TNumber;

			procedure vorkomma(v: TNumber);
				label _ende;

				var i: integer;

				begin
					ret:='';
					while e>0 do
						begin
							if dummy[e]='0' then
								begin
									v:=int(v)/10.0;
									ret:=chr(round(frac(v)*10.0)+48)+ret
								end
							else
								if dummy[e]='#' then
									begin
										if v<1.0 then
											begin
												i:=0;
												while not(ret[i+1] in ['0'..'9']) and (i<length(ret)) do inc(i);
												ret:=StrPRight(ret,length(ret)-i);
												goto _ende
											end
										else
											begin
												v:=int(v)/10.0;
												ret:=chr(round(frac(v)*10.0)+48)+ret;
												if v<1.0 then goto _ende
											end
									end
								else
									ret:=dummy[e]+ret;
							dec(e)
						end;
					while v>=1.0 do
						begin
							v:=int(v)/10.0;
							ret:=chr(round(frac(v)*10.0)+48)+ret
						end;
					_ende:
					vtxt:=vtxt+ret
				end;

			procedure nachkomma(k: TNumber);
			
				begin
					e:=w+1;
					while e<=length(dummy) do
						begin
							if dummy[e]='0' then
								begin
									k:=k*10.0;
									vtxt:=vtxt+chr(trunc(k)+48);
									k:=frac(k)
								end
							else
								vtxt:=vtxt+dummy[e];
							inc(e)
						end
				end;

			procedure num2wiss;
				var k    : TNumber;
				    i,j,l: integer;

				begin
					j:=0;
					k:=fval;
					if k>=1.0 then
						begin
							while k>=1e100 do
								begin
									k:=k/1e100;
									inc(j,100)
								end;
							while k>=1e10 do
								begin
									k:=k/1e10;
									inc(j,10)
								end;
							while k>=10 do
								begin
									k:=k/10;
									inc(j)
								end
						end
					else
						if k>0.0 then
							begin
								while k<=1e-100 do
									begin
										k:=k*1e100;
										dec(j,100)
									end;
								while k<=1e-10 do
									begin
										k:=k*1e10;
										dec(j,10)
									end;
								while k<1.0 do
									begin
										k:=k*10;
										dec(j)
									end
							end;
					i:=e;
					l:=length(dummy);
					dummy[0]:=chr(i-1);
					w:=pos('|',dummy);
					if w>0 then
						begin
							r:=0.5;
							e:=w+1;
							while e<=length(dummy) do
								begin
									if dummy[e]='0' then r:=r/10.0;
									inc(e)
								end;
							r:=k+r;
							e:=w-1;
							if e>0 then vorkomma(int(r));
							nachkomma(frac(r))
						end
					else
						vtxt:=vtxt+'#####';
					vtxt:=vtxt+'E';
					if dummy[i+1]='+' then
						begin
							if j>=0 then vtxt:=vtxt+'+';
							i:=l-i-1
						end
					else
						i:=l-i;
					if j<0 then
						begin
							vtxt:=vtxt+'-';
							j:=-j
						end;
					ret:=ltoa(j);
					while length(ret)<i do ret:='0'+ret;
					vtxt:=vtxt+ret
				end;

			begin
				if fval<0.0 then
					begin
						vtxt:=vtxt+'-';
						fval:=-fval
					end;
				_wiss:
				e:=pos('E',dummy);
				if e>0 then num2wiss
				else
					begin
						if fval>1e29 then
							begin
								dummy:='0|,0000E+0';
								goto _wiss
							end;
						w:=pos('|',dummy);
						if w>0 then
							begin
								r:=0.5;
								e:=w+1;
								while e<=length(dummy) do
									begin
										if dummy[e]='0' then r:=r/10.0;
										inc(e)
									end;
								r:=fval+r;
								e:=w-1;
								if e>0 then vorkomma(int(r));
								nachkomma(frac(r))
							end
						else
							begin
								e:=length(dummy);
								if e>0 then
									begin
										if frac(fval)>=0.5 then vorkomma(int(fval)+1.0)
										else
											vorkomma(int(fval))
									end
							end
					end
			end;

		begin
			if frm>=1000 then pfm:=PFormat(UsrFormats^.At(frm-1000))
			else
				pfm:=PFormat(TexelApp.Formats^.At(frm));
			frmt:=pfm^.Name^;
			vtxt:='';
			orgval:=fval;
			q:=pos(';',frmt);
			if q>0 then
				begin
					n:=RPos(';',frmt);
					if q=n then
						begin
							if fval<0.0 then
								begin
									fval:=-fval;
									frmt:=StrPRight(frmt,length(frmt)-q)
								end
							else
								frmt:=StrPLeft(frmt,q-1)
						end
					else
						if fval>0.0 then frmt:=StrPLeft(frmt,q-1)
						else
							if fval<0.0 then
								begin
									fval:=-fval;
									frmt:=StrPMid(frmt,q+1,n-q-1)
								end
							else
								frmt:=StrPRight(frmt,length(frmt)-n)
				end;
			q:=1;
			dummy:='';
			state:=0;
			while (q<=length(frmt)) do
				begin
					ch:=frmt[q];
					if state=1 then
						begin
							if ch=']' then
								begin
									symb2val;
									dummy:='';
									state:=0
								end
							else
								dummy:=dummy+ch
						end
					else
						if state=2 then
							begin
								if ch='}' then
									begin
										num2val;
										dummy:='';
										state:=0
									end
								else
									dummy:=dummy+ch
							end
						else
							if state=3 then
								begin
									if ch=')' then
										begin
											fval:=fval*atof(dummy);
											dummy:='';
											state:=0
										end
									else
										dummy:=dummy+ch
								end
							else
								if ch='[' then state:=1
								else
									if ch='{' then state:=2
									else
										if ch='(' then state:=3
										else
											vtxt:=vtxt+ch;
					inc(q)
				end
		end;

	begin
		Val2Txt:=false;
		if (frm>0) and (frm<=TexelApp.FormPredef) then interprete
		else
			begin
				if UsrFormats=nil then usr:=0
				else
					usr:=1000+UsrFormats^.Count;
				if (frm>=1000) and (frm<usr) then interprete
				else
					vtxt:=TexelApp.Num2Txt(fval,fp,false,true)
			end
	end;


procedure TCalcWindow.InitTextValues(handle: integer; var cmpval: TOldTxtVal);
	var dummy: integer;

	begin
		with cmpval do
			begin
				oldtcolor:=Black;
				oldeffects:=TF_NORMAL;
				oldskew:=0;
				oldrotat:=0
			end;
		vst_color(handle,cmpval.oldtcolor);
		vst_effects(handle,cmpval.oldeffects);
		vst_rotation(handle,cmpval.oldrotat);
		{$IFNDEF NVDI5}
		if Speedo then
		{$ENDIF}
			vst_skew(handle,cmpval.oldskew);
		vst_alignment(handle,TA_LEFT,TA_TOP,dummy,dummy)
	end;


procedure TCalcWindow.RestoreTextValues(handle: integer);
	var dummy: integer;

	begin
		vst_color(handle,Black);
		vst_effects(handle,TF_NORMAL);
		vst_rotation(handle,0);
		{$IFNDEF NVDI5}
		if Speedo then
		{$ENDIF}
			vst_skew(handle,0);
		vst_alignment(handle,TA_LEFT,TA_BASELINE,dummy,dummy)
	end;


procedure TCalcWindow.RowsClearOverflow(rs,re: integer; var cmin,cmax: integer);
	var x,y,
	    cmi,cmx: integer;
	    cell   : PCell;

	begin
		for y:=rs to re do
			begin
				cell:=GetCell(y,0);
				for x:=0 to Parms.Columns do
					begin
						if ClearOverflow(cell,cmi,cmx) then
							begin
								if cmi<cmin then cmin:=cmi;
								if cmx>cmax then cmax:=cmx
							end;
						inc(longint(cell),CELLSIZE)
					end
			end
	end;


procedure TCalcWindow.RowsCheckOverflow(rs,re: integer; var cmin,cmax: integer);
	var cell: PCell;
	    x,y,
	    cmi,
	    cmx : integer;

	begin
		cell:=GetCell(rs,0);
		for y:=rs to re do
			for x:=0 to Parms.Columns do
				begin
					if CheckOverflow(cell,cmi,cmx) then
						begin
							if cmi<cmin then cmin:=cmi;
							if cmx>cmax then cmax:=cmx
						end;
					inc(longint(cell),CELLSIZE)
				end
	end;


procedure TCalcWindow.SheetCheckOverflow;
	var r,c,
	    dummy: integer;
	    cell : PCell;

	begin
		BusyMouse;
		cell:=Sheet;
		for r:=0 to Parms.Rows do
			for c:=0 to Parms.Columns do
				begin
					CheckOverflow(cell,dummy,dummy);
					inc(longint(cell),CELLSIZE)
				end;
		ArrowMouse
	end;


function TCalcWindow.ClearOverflow(cell: PCell; var cmin,cmax: integer): boolean;
	var r,c,c2: integer;
	    cell2 : PCell;

	begin
		ClearOverflow:=false;
		if cell^.Typ<>CTYPE_TEXT then exit;
		Cell2RC(cell,r,c);
		ClearOverflow:=((cell^.TxtVal.Flags and (TFL_LEFTMASK or TFL_RIGHTMASK))>0);
		cmin:=c;
		cmax:=c;
		cell2:=cell;
		c2:=c;
		while ((cell2^.TxtVal.Flags and TFL_LEFTMASK)>0) and (c2>=0) do
			begin
				cmin:=c2;
				cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags and not(TFL_LEFTMASK);
				dec(longint(cell2),CELLSIZE);
				dec(c2)
			end;
		cell2:=cell;
		c2:=c;
		while ((cell2^.TxtVal.Flags and TFL_RIGHTMASK)>0) and (c2<=Parms.Columns) do
			begin
				cmax:=c2;
				cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags and not(TFL_RIGHTMASK);
				inc(longint(cell2),CELLSIZE);
				inc(c2)
			end
	end;


function TCalcWindow.CheckOverflow(cell: PCell; var cmin,cmax: integer): boolean;
	var r,c,c2,
	    dummy,
	    xmin,xmax,
	    txtwidth,
	    colwidth : integer;
	    extent   : ARRAY_8;
	    cell2    : PCell;

	begin
		CheckOverflow:=false;
		if cell^.Typ<>CTYPE_TEXT then exit;
		if cell^.Data.Value=0 then exit;
		if bTst(cell^.TxtVal.Flags,TFL_CLIP) then exit;
		if (cell^.TxtVal.Rotat<>0) and (cell^.TxtVal.Rotat<>1800) then exit;
		Cell2RC(cell,r,c);
		colwidth:=GetColWidth(c);
		SetFont(cell^.TxtVal.Font,cell^.TxtVal.Size);
		vst_effects(vdiHandle,cell^.TxtVal.Effects);
		vst_rotation(vdiHandle,cell^.TxtVal.Rotat);
		{$IFNDEF NVDI5}
		if Speedo then
		{$ENDIF}
			vst_skew(vdiHandle,cell^.TxtVal.Skew);
		vst_alignment(vdiHandle,TA_LEFT,TA_TOP,dummy,dummy);
		{$IFDEF NVDI5}
		vqt_real_extent(vdiHandle,0,0,cell^.Data.Txt^,extent);
		{$ELSE}
		if Speedo then vqt_my_extent(vdiHandle,cell^.Data.Txt^,extent)
		else
			vqt_extent(vdiHandle,cell^.Data.Txt^,extent);
		{$ENDIF}
		xmin:=Min(Min(extent[0],extent[2]),Min(extent[4],extent[6]));
		xmax:=Max(Max(extent[0],extent[2]),Max(extent[4],extent[6]));
		txtwidth:=xmax-xmin;
		if txtwidth>colwidth then
			begin
				case (cell^.TxtVal.Align and $0f) of
				TA_RIGHT:
					begin
						cell^.TxtVal.Flags:=cell^.TxtVal.Flags or TFL_TEXT2LEFT;
						c2:=c-1;
						cell2:=PCell(longint(cell)-CELLSIZE);
						dec(txtwidth,colwidth);
						while (txtwidth>0) and (c2>=0) do
							begin
								if bTst(PColFlags^[c2],CRF_UMBRUCH) then break;
								if cell2^.Typ<>CTYPE_EMPTY then break;
								if (cell2^.TxtVal.Flags and TFL_OVERFLOWMASK)<>0 then break;
								cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags or TFL_LEFTMASK;
								dec(txtwidth,GetColWidth(c2));
								dec(longint(cell2),CELLSIZE);
								dec(c2)
							end;
						inc(longint(cell2),CELLSIZE);
						cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags and not(TFL_TEXT2LEFT);
						cmin:=c2+1;
						cmax:=c
					end;
				TA_CENTER:
					begin
						dec(txtwidth,colwidth);
						dummy:=txtwidth shr 1;
						txtwidth:=dummy;
						cell^.TxtVal.Flags:=cell^.TxtVal.Flags or TFL_TEXT2LEFT;
						c2:=c-1;
						cell2:=PCell(longint(cell)-CELLSIZE);
						while (txtwidth>0) and (c2>=0) do
							begin
								if bTst(PColFlags^[c2],CRF_UMBRUCH) then break;
								if cell2^.Typ<>CTYPE_EMPTY then break;
								if (cell2^.TxtVal.Flags and TFL_OVERFLOWMASK)<>0 then break;
								cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags or TFL_LEFTMASK;
								dec(txtwidth,GetColWidth(c2));
								dec(longint(cell2),CELLSIZE);
								dec(c2)
							end;
						inc(longint(cell2),CELLSIZE);
						cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags and not(TFL_TEXT2LEFT);
						cmin:=c2+1;
						txtwidth:=dummy;
						cell^.TxtVal.Flags:=cell^.TxtVal.Flags or TFL_TEXT2RIGHT;
						c2:=c+1;
						cell2:=PCell(longint(cell)+CELLSIZE);
						while (txtwidth>0) and (c2<=Parms.Columns) do
							begin
								if bTst(PColFlags^[c2-1],CRF_UMBRUCH) then break;
								if cell2^.Typ<>CTYPE_EMPTY then break;
								if (cell2^.TxtVal.Flags and TFL_OVERFLOWMASK)<>0 then break;
								cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags or TFL_RIGHTMASK;
								dec(txtwidth,GetColWidth(c2));
								inc(longint(cell2),CELLSIZE);
								inc(c2)
							end;
						dec(longint(cell2),CELLSIZE);
						cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags and not(TFL_TEXT2RIGHT);
						cmax:=c2-1
					end
				else
					begin
						cell^.TxtVal.Flags:=cell^.TxtVal.Flags or TFL_TEXT2RIGHT;
						c2:=c+1;
						cell2:=PCell(longint(cell)+CELLSIZE);
						dec(txtwidth,colwidth);
						while (txtwidth>0) and (c2<=Parms.Columns) do
							begin
								if bTst(PColFlags^[c2-1],CRF_UMBRUCH) then break;
								if cell2^.Typ<>CTYPE_EMPTY then break;
								if (cell2^.TxtVal.Flags and TFL_OVERFLOWMASK)<>0 then break;
								cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags or TFL_RIGHTMASK;
								dec(txtwidth,GetColWidth(c2));
								inc(longint(cell2),CELLSIZE);
								inc(c2)
							end;
						dec(longint(cell2),CELLSIZE);
						cell2^.TxtVal.Flags:=cell2^.TxtVal.Flags and not(TFL_TEXT2RIGHT);
						cmax:=c2-1;
						cmin:=c
					end
				end;
				CheckOverflow:=true
			end;
		SetFont(GetStdFontIndex,GetStdFontSize);
		RestoreTextValues(vdiHandle)
	end;


procedure TCalcWindow.OutputVectorText(handle: integer; cell: PCell; const txt: string; const tval: TTxtVal; var cmpval: TOldTxtVal; csize: ARRAY_4; isnum: boolean);
	var extent   : ARRAY_8;
	    dummy,
	    xmin,ymin,
	    xmax,ymax,
	    tx,ty    : integer;

	procedure doalign;
	
		begin
			xmin:=Min(Min(extent[0],extent[2]),Min(extent[4],extent[6]));
			ymin:=Min(Min(extent[1],extent[3]),Min(extent[5],extent[7]));
			xmax:=Max(Max(extent[0],extent[2]),Max(extent[4],extent[6]));
			ymax:=Max(Max(extent[1],extent[3]),Max(extent[5],extent[7]));
			case (cell^.TxtVal.Align and $f0) of
			TA_OBEN:
				begin
					ty:=csize[1]+cmpval.brd1h-ymin;
					if cell^.Border.Top>16 then
						case (cell^.Border.Top shr 4) of
						2:
							inc(ty,cmpval.brd1h);
						3:
							inc(ty,cmpval.brd2h);
						4,5:
							inc(ty,cmpval.brd3h)
						end
				end;
			TA_MITTE:
				ty:=((csize[1]+csize[3]) shr 1)-((ymin+ymax) shr 1);
			else
				begin
					ty:=csize[3]-cmpval.brd1h-ymax;
					if cmpval.gitter then inc(ty);
					if cell^.Border.Bottom>16 then
						case (cell^.Border.Bottom shr 4) of
						2:
							dec(ty,cmpval.brd1h);
						3:
							dec(ty,cmpval.brd2h);
						4,5:
							dec(ty,cmpval.brd3h)
						end
				end
			end;
			case (cell^.TxtVal.Align and $0f) of
			TA_RIGHT:
				begin
					tx:=csize[2]-cmpval.brd1w-xmax;
					if not(cmpval.gitter) then dec(tx);
					if cell^.Border.Right>16 then
						case (cell^.Border.Right shr 4) of
						2:
							dec(tx,cmpval.brd1w);
						3:
							dec(tx,cmpval.brd2w);
						4,5:
							dec(tx,cmpval.brd3w)
						end
				end;
			TA_CENTER:
				tx:=((csize[0]+csize[2]) shr 1)-((xmin+xmax) shr 1);
			else
				begin
					tx:=csize[0]+Max(cmpval.brd1w,1)-xmin;
					if cell^.Border.Left>16 then
						case (cell^.Border.Left shr 4) of
						2:
							inc(tx,cmpval.brd1w);
						3:
							inc(tx,cmpval.brd2w);
						4,5:
							inc(tx,cmpval.brd3w)
						end
				end
			end
		end;

	procedure checkrotat;
	
		begin
			case cmpval.oldrotat of
			900:
				begin
					extent[1]:=-extent[1];
					extent[3]:=-extent[3];
					extent[5]:=-extent[5];
					extent[7]:=-extent[7]
				end;
			1800:
				begin
					extent[0]:=-extent[0];
					extent[1]:=-extent[1];
					extent[2]:=-extent[2];
					extent[3]:=-extent[3];
					extent[4]:=-extent[4];
					extent[5]:=-extent[5];
					extent[6]:=-extent[6];
					extent[7]:=-extent[7]
				end;
			2700:
				begin
					extent[0]:=-extent[0];
					extent[2]:=-extent[2];
					extent[4]:=-extent[4];
					extent[6]:=-extent[6]
				end
			end
		end;

	function overflow: boolean;

		begin
			inc(xmin,tx);
			inc(xmax,tx);
			inc(ymin,ty);
			inc(ymax,ty);
			overflow:=((xmin<csize[0]-cmpval.brd1w-1) or (ymin<csize[1]-cmpval.brd1h-1) or (xmax>csize[2]+cmpval.brd1w+1) or (ymax>csize[3]+cmpval.brd1h+1))
		end;

	begin
		{ Textattribute setzen}
		if tval.Color<>cmpval.oldtcolor then
			begin
				vst_color(handle,tval.Color);
				cmpval.oldtcolor:=tval.Color
			end;
		if tval.Effects<>cmpval.oldeffects then
			begin
				vst_effects(handle,tval.Effects);
				cmpval.oldeffects:=tval.Effects
			end;
		if tval.Rotat<>cmpval.oldrotat then
			begin
				vst_rotation(handle,tval.Rotat);
				cmpval.oldrotat:=tval.Rotat
			end;
		if tval.Skew<>cmpval.oldskew then
			begin
				{$IFNDEF NVDI5}
				if Speedo then
				{$ENDIF}
					vst_skew(handle,tval.Skew);
				cmpval.oldskew:=tval.Skew
			end;
		{ Text ausgeben }
		{$IFNDEF NVDI5}
		if NVDIVersion>=$0300 then
			begin
		{$ENDIF}
				vqt_real_extent(handle,0,0,txt,extent);
				doalign;
				if isnum then
					if TexelApp.setupbuffer.overflow=bf_Checked then
						if overflow then
							begin
								v_ftext(handle,tx,ty,StrPFill(length(txt),'#'));
								exit
						  end;
				v_ftext(handle,tx,ty,txt);
		{$IFNDEF NVDI5}
			end
		else
			begin
				if Speedo then vqt_f_extent(handle,txt,extent)
				else
					vqt_extent(handle,txt,extent);
				checkrotat;
				doalign;
				if isnum then
					if TexelApp.setupbuffer.overflow=bf_Checked then
						if overflow then
							begin
								if Speedo then v_ftext(handle,tx,ty,StrPFill(length(txt),'#'))
								else
									v_gtext(handle,tx,ty,StrPFill(length(txt),'#'));
								exit
							end;
				if Speedo then v_ftext(handle,tx,ty,txt)
				else
					v_gtext(handle,tx,ty,txt)
			end
		{$ENDIF}
	end;


procedure TCalcWindow.OutputKF(handle,kfx,kfy,alh,alv,pagenum,pages: integer; printtime: longint; s: string);
	var k,dummy: integer;
	    wert,s2: string;

	begin
		if length(s)=0 then exit;
		k:=pos('#',s);
		s2:='';
		while k>0 do
			begin
				wert:='';
				case upcase(s[k+1]) of
				'#':
					wert:='#';
				'D':
					wert:=StrPLeft(TexelApp.Time2Str(printtime),8);
				'T','Z':
					wert:=StrPRight(TexelApp.Time2Str(printtime),5);
				'F':
					begin
						wert:=GetWindowFilename;
						if length(wert)=0 then wert:=GetRawIconTitle
					end;
				'P','S':
					wert:=ltoa(pagenum+1);
				'G':
					wert:=ltoa(pages);
				'A':
					wert:=infobuf.Autor;
				'N':
					wert:=infobuf.DocTitle;
				end;
				s2:=s2+StrPLeft(s,k-1)+wert;
				s:=StrPRight(s,length(s)-k-1);
				k:=pos('#',s)
			end;
		vst_alignment(handle,alh,alv,dummy,dummy);
		{$IFDEF NVDI5}
		v_ftext(handle,kfx,kfy,s2+s)
		{$ELSE}
		if Speedo then v_ftext(handle,kfx,kfy,s2+s)
		else
			v_gtext(handle,kfx,kfy,s2+s)
		{$ENDIF}
	end;


procedure TCalcWindow.OutputErrorText(handle: integer; cell: PCell; const tval: TTxtVal; var cmpval: TOldTxtVal; csize: ARRAY_4; err: shortint);
	var s: string;

	begin
		s:=Error2Txt(err);
		OutputVectorText(handle,cell,s,tval,cmpval,csize,false)
	end;


procedure TCalcWindow.Paint(var PaintInfo: TPaintStruct);
	label _nextgit,_endgit;

	var cnum,lofs,
      greylen   : longint;
	    clp,clp2,
	    gclp,
	    clp3,bclp : GRECT;
	    xy,xy2,xy3,
	    brd,tover,
	    notexy,
	    protxy    : ARRAY_4;
	    q,w,yofs,
	    dummy,b,
	    tx,ty,c2,
	    protsize,
	    oldlcolor,
	    oldcolor,
	    oldstyle,
	    oldinter  : integer;
	    pttrn     : word;
	    umbruch,
	    umorgit,
	    greyed    : boolean;
	    sval      : string;
	    colarray  : ARRAY_2;
	    ext       : ARRAY_8;
	    pe        : PEmbedded;
	    srcmfdb,
	    dstmfdb   : MFDB;
	    pgrey     : PWord;
	    grey50    : pointer;
	    cmpval    : TOldTxtVal;
	    cell2     : PCell;

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
							vsf_color(vdiHandle,Color);
							oldcolor:=Color
						end
				end;
			vr_recfl(vdiHandle,xy3)
		end;
	
	procedure greyout;
		var w,q: integer;
	
		begin
			ext[4]:=clp2.X1;
			ext[5]:=clp2.Y1;
			ext[6]:=clp2.X2;
			ext[7]:=clp2.Y2;
			ext[2]:=clp2.W-1;
			ext[3]:=clp2.H-1;
			srcmfdb.fd_stand:=0;
			srcmfdb.fd_nplanes:=1;
			srcmfdb.fd_w:=clp2.W;
			srcmfdb.fd_h:=clp2.H;
			srcmfdb.fd_wdwidth:=(clp2.W+15) shr 4;
			greylen:=longint(srcmfdb.fd_h)*longint(srcmfdb.fd_wdwidth shl 1);
			getmem(grey50,greylen);
			if grey50<>nil then
				begin
					pttrn:=$5555;
					pgrey:=PWord(grey50);
					for q:=0 to clp2.H-1 do
						begin
							for w:=1 to  srcmfdb.fd_wdwidth do
								begin
									pgrey^:=pttrn;
									inc(longint(pgrey),2)
								end;
							pttrn:=pttrn xor $ffff
						end;
					srcmfdb.fd_addr:=grey50;
					dstmfdb.fd_addr:=nil;
					vs_clip(vdiHandle,CLIP_ON,clp2.A2);
					vrt_cpyfm(vdiHandle,2,ext,srcmfdb,dstmfdb,colarray);
					freemem(grey50,greylen)
				end
		end;

	begin
		{ Dialog zeichnen }
		inherited Paint(PaintInfo);
		{ Offsets berechnen... }
		yofs:=Work.Y+PaintOffs;
		{ Linie zwischen Dialog und Blatt }
		pxya[0]:=Work.X1;
		pxya[1]:=yofs-1;
		pxya[2]:=Work.X2;
		pxya[3]:=pxya[1];
		v_pline(Application^.vdiHandle,2,pxya);
		{ Quadrat links oben zeichnen }
		xy[0]:=Work.X;
		xy[1]:=yofs;
		xy[2]:=xy[0]+LeftColWidth-1;
		xy[3]:=xy[1]+TopRowHeight-1;
		vsf_color(vdiHandle,White);
		v_bar(vdiHandle,xy);
		if TexelApp.ColFX then
			begin
				inc(xy[0]);
				inc(xy[1]);
				vsf_interior(vdiHandle,FIS_SOLID);
				vsf_color(vdiHandle,LWhite);
				v_bar(vdiHandle,xy)
			end;
		{ durchgezogene Linien }
		pxya[0]:=Work.X1;
		pxya[1]:=yofs+TopRowHeight;
		pxya[2]:=Work.X2;
		pxya[3]:=pxya[1];
		v_pline(Application^.vdiHandle,2,pxya);
		pxya[0]:=Work.X1+LeftColWidth;
		pxya[1]:=yofs;
		pxya[2]:=pxya[0];
		pxya[3]:=Work.Y2;
		v_pline(Application^.vdiHandle,2,pxya);
		PaintNames(PaintInfo.rcPaint);
		PaintNumbers(PaintInfo.rcPaint);
		{ Zeilen durchlaufen }
		lofs:=longint(Parms.Columns+1)*CELLSIZE;
		w:=tcnum;
		q:=GetRowHeight(w);
		clp.X:=Work.X;
		clp.Y:=yofs+TopRowHeight+1;
		clp.W:=LeftColWidth;
		clp.H:=q-tpoffs;
		GRtoA2(clp);
		xy3[3]:=clp.Y2;
		xy3[1]:=xy3[3]-q;
		if sheetbuffer.protect=bf_Unchecked then protsize:=-1
		else
			protsize:=round(2*percentsize);
		with cmpval do
			begin
				oldfont:=GetFontIndex;
				oldsize:=GetFontSize;
				brd1w:=Max(round(percentsize*Border1*1000.0/longint(Application^.Attr.PixW))-1,0);
				brd2w:=Max(round(percentsize*Border2*1000.0/longint(Application^.Attr.PixW))-1,0);
				brd3w:=Max(round(percentsize*Border3*1000.0/longint(Application^.Attr.PixW))-1,0);
				brd1h:=Max(round(percentsize*Border1*1000.0/longint(Application^.Attr.PixH))-1,0);
				brd2h:=Max(round(percentsize*Border2*1000.0/longint(Application^.Attr.PixH))-1,0);
				brd3h:=Max(round(percentsize*Border3*1000.0/longint(Application^.Attr.PixH))-1,0);
				gitter:=(sheetbuffer.gitter=bf_Checked)
			end;
		oldcolor:=White;
		oldlcolor:=Black;
		oldstyle:=0;
		oldinter:=FIS_HOLLOW;
		umbruch:=(sheetbuffer.umbruch=bf_Checked);
		umorgit:=cmpval.gitter or umbruch;
		vsf_color(vdiHandle,oldcolor);
		vsf_style(vdiHandle,oldstyle);
		vsf_interior(vdiHandle,oldinter);
		vsf_interior(Application^.vdiHandle,FIS_SOLID);
		vsl_color(vdiHandle,oldlcolor);
		SetFont(cmpval.oldfont,cmpval.oldsize);
		InitTextValues(vdiHandle,cmpval);
		repeat
			inc(w);
			{ Spalten durchlaufen }
			cnum:=longint(Sheet)+(longint(w-1)*longint(Parms.Columns+1)+longint(lcnum))*CELLSIZE;
			q:=lcnum;
			clp3.X:=clp.X2+2;
			clp3.Y:=clp.Y;
			clp3.W:=GetColWidth(q)-lpoffs-1;
			clp3.H:=clp.H;
			xy3[0]:=clp.X2+1-lpoffs;
			if cmpval.gitter then dec(xy3[3]);
			protxy[1]:=xy3[1];
			protxy[3]:=protxy[1]+protsize;
			notexy[1]:=protxy[3]+1;
			notexy[3]:=notexy[1]+protsize;
			GRtoA2(clp3);
			repeat
				clp2:=clp3;
				if rc_intersect(PaintInfo.rcPaint,clp2) then
					begin
						vs_clip(Application^.vdiHandle,CLIP_ON,clp2.A2);
						vs_clip(vdiHandle,CLIP_ON,clp2.A2);
						xy3[2]:=clp3.X2;
						if cmpval.gitter then
							if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then dec(xy3[2]);
						{ Zellinhalt }
						drawbackground;
						with PCell(cnum)^ do
							begin
								vswr_mode(vdiHandle,MD_TRANS);
								case Typ of
								CTYPE_TEXT:
									if Data.Value<>0 then
										begin
											setfontattr(TxtVal);
											OutputVectorText(vdiHandle,PCell(cnum),Data.Txt^,TxtVal,cmpval,xy3,false)
										end;
								CTYPE_CONST:
									with Data.Konst^ do
										begin
											if Val2Txt(Value,sval,FPts,Format,PCell(cnum)) then drawbackground;
											setfontattr(TxtVal);
											OutputVectorText(vdiHandle,PCell(cnum),sval,TxtVal,cmpval,xy3,true)
										end;
								CTYPE_FORMULA:
									with Data.Formula^ do
										if Error=FE_OK then
											begin
												if Val2Txt(Value,sval,FPts,Format,PCell(cnum)) then drawbackground;
												setfontattr(TxtVal);
												OutputVectorText(vdiHandle,PCell(cnum),sval,TxtVal,cmpval,xy3,true)
											end
										else
											begin
												setfontattr(TxtVal);
												OutputErrorText(vdiHandle,PCell(cnum),TxtVal,cmpval,xy3,Error)
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
													if c2<0 then break
													else
														begin
															tover[2]:=tover[0]-1;
															dec(tover[0],GetColWidth(c2))
														end;
												until (cell2^.TxtVal.Flags and TFL_RIGHTMASK)=TFL_TEXT2RIGHT;
												if c2>=0 then
													begin
														setfontattr(cell2^.TxtVal);
														OutputVectorText(vdiHandle,cell2,cell2^.Data.Txt^,cell2^.TxtVal,cmpval,tover,false)
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
														if c2>Parms.Columns then break
														else
															begin
																tover[0]:=tover[2]+1;
																inc(tover[2],GetColWidth(c2));
																if cmpval.gitter then dec(tover[2])
															end;
													until (cell2^.TxtVal.Flags and TFL_LEFTMASK)=TFL_TEXT2LEFT;
													if c2<=Parms.Columns then
														begin
															setfontattr(cell2^.TxtVal);
															OutputVectorText(vdiHandle,cell2,cell2^.Data.Txt^,cell2^.TxtVal,cmpval,tover,false)
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
											bclp.X:=clp3.X-1;
											bclp.Y:=clp3.Y-1;
											bclp.W:=clp3.W+1;
											bclp.H:=clp3.H+1;
											if rc_intersect(PaintInfo.rcPaint,bclp) then
												begin
													vs_clip(vdiHandle,CLIP_ON,bclp.A2);
													if Left>=16 then
														if (TxtVal.Flags and TFL_LEFTBORDER)=0 then
															begin
																if (Left and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Left and $f;
																		vsl_color(vdiHandle,oldlcolor)
																	end;
																case (Left shr 4) of
																1:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[1];
																		brd[2]:=brd[0];
																		brd[3]:=xy3[3];
																		v_pline(vdiHandle,2,brd)
																	end;
																2:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				inc(brd[0])
																			end
																	end;
																3:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd2w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				inc(brd[0])
																			end
																	end;
																4:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd3w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				inc(brd[0])
																			end
																	end;
																5:
																	begin
																		brd[0]:=xy3[0];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				inc(brd[0])
																			end;
																		brd[0]:=xy3[0]+cmpval.brd3w;
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				dec(brd[0])
																			end
																	end
																end
															end;
													if Right>=16 then
														if (TxtVal.Flags and TFL_RIGHTBORDER)=0 then
															begin
																if (Right and $f)<>oldlcolor then
																	begin
																		oldlcolor:=Right and $f;
																		vsl_color(vdiHandle,oldlcolor)
																	end;
																case (Right shr 4) of
																1:
																	begin
																		brd[0]:=xy3[2];
																		brd[1]:=xy3[1];
																		brd[2]:=brd[0];
																		brd[3]:=xy3[3];
																		v_pline(vdiHandle,2,brd)
																	end;
																2:
																	begin
																		brd[0]:=xy3[2];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				dec(brd[0])
																			end
																	end;
																3:
																	begin
																		brd[0]:=xy3[2];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd2w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				dec(brd[0])
																			end
																	end;
																4:
																	begin
																		brd[0]:=xy3[2];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd3w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				dec(brd[0])
																			end
																	end;
																5:
																	begin
																		brd[0]:=xy3[2];
																		brd[1]:=xy3[1];
																		brd[3]:=xy3[3];
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				dec(brd[0])
																			end;
																		brd[0]:=xy3[2]-cmpval.brd3w;
																		for b:=0 to cmpval.brd1w do
																			begin
																				brd[2]:=brd[0];
																				v_pline(vdiHandle,2,brd);
																				inc(brd[0])
																			end
																	end
																end
															end;
													if Top>=16 then
														begin
															if (Top and $f)<>oldlcolor then
																begin
																	oldlcolor:=Top and $f;
																	vsl_color(vdiHandle,oldlcolor)
																end;
															case (Top shr 4) of
															1:
																begin
																	brd[0]:=xy3[0];
																	brd[1]:=xy3[1];
																	brd[2]:=xy3[2];
																	brd[3]:=brd[1];
																	v_pline(vdiHandle,2,brd)
																end;
															2:
																begin
																	brd[1]:=xy3[1];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end
																end;
															3:
																begin
																	brd[1]:=xy3[1];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd2h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end
																end;
															4:
																begin
																	brd[1]:=xy3[1];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd3h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end
																end;
															5:
																begin
																	brd[1]:=xy3[1];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end;
																	brd[1]:=xy3[1]+cmpval.brd3h;
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			dec(brd[1])
																		end
																end
															end
														end;
													if Bottom>=16 then
														begin
															if (Bottom and $f)<>oldlcolor then
																begin
																	oldlcolor:=Bottom and $f;
																	vsl_color(vdiHandle,oldlcolor)
																end;
															case (Bottom shr 4) of
															1:
																begin
																	brd[0]:=xy3[0];
																	brd[1]:=xy3[3];
																	brd[2]:=xy3[2];
																	brd[3]:=brd[1];
																	v_pline(vdiHandle,2,brd)
																end;
															2:
																begin
																	brd[1]:=xy3[3];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			dec(brd[1])
																		end
																end;
															3:
																begin
																	brd[1]:=xy3[3];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd2h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			dec(brd[1])
																		end
																end;
															4:
																begin
																	brd[1]:=xy3[3];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd3h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			dec(brd[1])
																		end
																end;
															5:
																begin
																	brd[1]:=xy3[3];
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			dec(brd[1])
																		end;
																	brd[1]:=xy3[3]-cmpval.brd3h;
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end
																end
															end
														end;
													if Hor>=16 then
														begin
															if (Hor and $f)<>oldlcolor then
																begin
																	oldlcolor:=Hor and $f;
																	vsl_color(vdiHandle,oldlcolor)
																end;
															case (Hor shr 4) of
															1:
																begin
																	brd[0]:=xy3[0];
																	brd[1]:=(xy3[1]+xy3[3]) shr 1;
																	brd[2]:=xy3[2];
																	brd[3]:=brd[1];
																	v_pline(vdiHandle,2,brd)
																end;
															2:
																begin
																	brd[1]:=(xy3[1]+xy3[3]-cmpval.brd1h) shr 1;
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end
																end;
															3:
																begin
																	brd[1]:=(xy3[1]+xy3[3]-cmpval.brd2h) shr 1;
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd2h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end
																end;
															4:
																begin
																	brd[1]:=(xy3[1]+xy3[3]-cmpval.brd3h) shr 1;
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd3h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end
																end;
															5:
																begin
																	brd[1]:=(xy3[1]+xy3[3]-cmpval.brd3h) shr 1;
																	brd[0]:=xy3[0];
																	brd[2]:=xy3[2];
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[1])
																		end;
																	brd[1]:=(xy3[1]+xy3[3]+cmpval.brd3h) shr 1;
																	for b:=0 to cmpval.brd1h do
																		begin
																			brd[3]:=brd[1];
																			v_pline(vdiHandle,2,brd);
																			dec(brd[1])
																		end
																end
															end
														end;
													if Vert>=16 then
														begin
															if (Vert and $f)<>oldlcolor then
																begin
																	oldlcolor:=Vert and $f;
																	vsl_color(vdiHandle,oldlcolor)
																end;
															case (Vert shr 4) of
															1:
																begin
																	brd[0]:=(xy3[0]+xy3[2]) shr 1;
																	brd[1]:=xy3[1];
																	brd[2]:=brd[0];
																	brd[3]:=xy3[3];
																	v_pline(vdiHandle,2,brd)
																end;
															2:
																begin
																	brd[0]:=(xy3[0]+xy3[2]-cmpval.brd1w) shr 1;
																	brd[1]:=xy3[1];
																	brd[3]:=xy3[3];
																	for b:=0 to cmpval.brd1w do
																		begin
																			brd[2]:=brd[0];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[0])
																		end
																end;
															3:
																begin
																	brd[0]:=(xy3[0]+xy3[2]-cmpval.brd2w) shr 1;
																	brd[1]:=xy3[1];
																	brd[3]:=xy3[3];
																	for b:=0 to cmpval.brd2w do
																		begin
																			brd[2]:=brd[0];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[0])
																		end
																end;
															4:
																begin
																	brd[0]:=(xy3[0]+xy3[2]-cmpval.brd3w) shr 1;
																	brd[1]:=xy3[1];
																	brd[3]:=xy3[3];
																	for b:=0 to cmpval.brd3w do
																		begin
																			brd[2]:=brd[0];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[0])
																		end
																end;
															5:
																begin
																	brd[0]:=(xy3[0]+xy3[2]-cmpval.brd3w) shr 1;
																	brd[1]:=xy3[1];
																	brd[3]:=xy3[3];
																	for b:=0 to cmpval.brd1w do
																		begin
																			brd[2]:=brd[0];
																			v_pline(vdiHandle,2,brd);
																			inc(brd[0])
																		end;
																	brd[0]:=(xy3[0]+xy3[2]+cmpval.brd3w) shr 1;
																	for b:=0 to cmpval.brd1w do
																		begin
																			brd[2]:=brd[0];
																			v_pline(vdiHandle,2,brd);
																			dec(brd[0])
																		end
																end
															end
														end;
													vs_clip(vdiHandle,CLIP_ON,clp2.A2)
												end
										end;
								if cmpval.gitter then dec(xy3[3])
							end;
						if umorgit then
							begin
								if not(cmpval.gitter) then dec(xy3[3]);
								{ Begrenzungslinien }
								if TexelApp.ColFX then vsl_color(Application^.vdiHandle,LWhite)
								else
									vsl_type(Application^.vdiHandle,LT_USERDEF);
								if PCell(cnum)^.Border.Right<16 then
									if (PCell(cnum)^.TxtVal.Flags and TFL_GITTERMASK)=0 then
										begin
											if q<Parms.Columns then
												if PCell(cnum+CELLSIZE)^.Border.Left>=16 then goto _nextgit;
											xy2[0]:=xy3[2];
											xy2[1]:=xy3[1];
											xy2[2]:=xy2[0];
											xy2[3]:=xy3[3]+1;
											if bTst(PColFlags^[q],CRF_UMBRUCH) and umbruch then
												begin
													vsl_type(Application^.vdiHandle,LT_DASHDOTDOT);
													vsl_color(Application^.vdiHandle,LRed);
													v_pline(Application^.vdiHandle,2,xy2);
													if TexelApp.ColFX then
														begin
															vsl_color(Application^.vdiHandle,LWhite);
															vsl_type(Application^.vdiHandle,LT_SOLID)
														end
													else
														vsl_type(Application^.vdiHandle,LT_USERDEF)
												end
											else
												if cmpval.gitter then v_pline(Application^.vdiHandle,2,xy2)
										end;
								_nextgit:
								if PCell(cnum)^.Border.Bottom<16 then
									begin
										if w<=Parms.Rows then
											if PCell(cnum+lofs)^.Border.Top>=16 then goto _endgit;
										xy2[0]:=xy3[0];
										xy2[1]:=xy3[3]+1;
										xy2[2]:=xy3[2];
										xy2[3]:=xy2[1];
										if bTst(PRowFlags^[w-1],CRF_UMBRUCH) and umbruch then
											begin
												vsl_type(Application^.vdiHandle,LT_DASHDOTDOT);
												vsl_color(Application^.vdiHandle,LRed);
												v_pline(Application^.vdiHandle,2,xy2)
											end
										else
											if cmpval.gitter then v_pline(Application^.vdiHandle,2,xy2)
									end;
								_endgit:
								vsl_type(Application^.vdiHandle,LT_SOLID);
								vsl_color(Application^.vdiHandle,Black)
							end
						else
							dec(xy3[3]);
						if bTst(PCell(cnum)^.Flags,CELL_PROTECTED) then
							if protsize>0 then
								begin
									protxy[0]:=xy3[0];
									protxy[2]:=protxy[0]+protsize;
									vsf_color(Application^.vdiHandle,Red);
									vr_recfl(Application^.vdiHandle,protxy);
									vsf_color(Application^.vdiHandle,Black)
								end;
						if bTst(PCell(cnum)^.Flags,CELL_HASNOTE) then
							if protsize>0 then
								begin
									notexy[0]:=xy3[0];
									notexy[2]:=notexy[0]+protsize;
									vsf_color(Application^.vdiHandle,Green);
									vr_recfl(Application^.vdiHandle,notexy);
									vsf_color(Application^.vdiHandle,Black)
								end;
						if bTst(PCell(cnum)^.Flags,CELL_SELECTED) then
							begin
								dec(xy3[2]);
								vswr_mode(Application^.vdiHandle,MD_XOR);
								vr_recfl(Application^.vdiHandle,xy3);
								vswr_mode(Application^.vdiHandle,MD_REPLACE)
							end;
						if not(cmpval.gitter) then inc(xy3[3])
					end;
				inc(q);
				if q>Parms.Columns then break;
				clp3.X1:=clp3.X2+1;
				inc(clp3.X2,GetColWidth(q));
				A2toGR(clp3);
				xy3[0]:=clp3.X-1;
				inc(cnum,CELLSIZE)
			until clp3.X1>Work.X2;
			{ n„chste Zeile }
			if w>Parms.Rows then break;
			clp.Y1:=clp.Y2+1;
			xy3[1]:=clp.Y2;
			inc(clp.Y2,GetRowHeight(w));
			A2toGR(clp);
			xy3[3]:=xy3[1]+clp.H
		until clp.Y1>Work.Y2;
		vsl_color(vdiHandle,Black);
		vs_clip(vdiHandle,CLIP_ON,SysInfo.Desktop.A2);
		if TexelApp.ColFX then
			begin
				vsf_interior(vdiHandle,FIS_SOLID);
				vsf_color(vdiHandle,LWhite)
			end
		else
			vsf_interior(vdiHandle,FIS_HOLLOW);
		if clp3.X2<Work.X2 then
			begin
				clp2.X:=clp3.X2+1;
				clp2.Y:=yofs+TopRowHeight+1;
				clp2.W:=Work.X2-clp3.X2;
				clp2.H:=Work.Y2+1-clp2.Y;
				clp3:=clp2;
				if rc_intersect(PaintInfo.rcPaint,clp2) then vr_recfl(vdiHandle,clp2.A2)
			end
		else
			clp3.W:=0;
		if clp.Y2<Work.Y2 then
			begin
				clp2.X:=Work.X1+LeftColWidth+1;
				clp2.Y:=clp.Y2+1;
				clp2.W:=Work.X2+1-clp2.X;
				clp2.H:=Work.Y2-clp.Y2;
				clp:=clp2;
				if rc_intersect(PaintInfo.rcPaint,clp2) then vr_recfl(vdiHandle,clp2.A2)
			end
		else
			clp.W:=0;
		if Embedded<>nil then
			if sheetbuffer.images=bf_Checked then
				begin
					GetSheetRect(bclp);
					if rc_intersect(PaintInfo.rcPaint,bclp) then
						begin
							ext[0]:=0;
							ext[1]:=0;
							colarray[0]:=0;
							colarray[1]:=0;
							pe:=Embedded;
							while pe<>nil do
								begin
									if pe^.IsVisible(bclp,true) then
										begin
											vs_clip(vdiHandle,CLIP_ON,bclp.A2);
											pe^.Paint(vdiHandle,bclp,true);
											gclp.X:=pe^.GetPixXPos(true);
											gclp.Y:=pe^.GetPixYPos(true);
											gclp.W:=pe^.GetPixWidth(true);
											gclp.H:=pe^.GetPixHeight(true);
											greyed:=false;
											if clp.W>0 then
												begin
													clp2:=gclp;
													if rc_intersect(bclp,clp2) then
														if rc_intersect(clp,clp2) then
															begin
																greyout;
																greyed:=true
															end
												end;
											if clp3.W>0 then
												begin
													clp2:=gclp;
													if greyed then
														begin
															GRtoA2(clp2);
															clp2.Y2:=clp.Y-1;
															A2toGR(clp2)
														end;
													if rc_intersect(bclp,clp2) then
														if rc_intersect(clp3,clp2) then greyout
												end
										end;
									pe:=pe^.Next
								end
						end
				end;
		vsl_color(vdiHandle,Black);
		vs_clip(vdiHandle,CLIP_ON,SysInfo.Desktop.A2);
		SetFont(GetStdFontIndex,GetStdFontSize);
		RestoreTextValues(vdiHandle);
		vsf_interior(Application^.vdiHandle,FIS_HOLLOW);
		vs_clip(Application^.vdiHandle,CLIP_ON,SysInfo.Desktop.A2)
	end;


procedure TCalcWindow.ForceVRedraw;
	var pipe: Pipearray;

	begin
		pipe[0]:=WM_REDRAW;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=Attr.gemHandle;
		pipe[4]:=Work.X;
		pipe[5]:=Work.Y+PaintOffs;
		pipe[6]:=Work.W;
		pipe[7]:=Work.H-PaintOffs;
		appl_write(pipe[1],16,@pipe)
	end;


function TCalcWindow.GetColWidth_mm100(num: integer): word;

	begin
		GetColWidth_mm100:=PCol^[num]
	end;


procedure TCalcWindow.SetColWidth_mm100(num: integer; width: longint; draw: boolean);
	var cmin,
	    cmax: integer;
	    sr  : GRECT;

	begin
		if width>65535 then width:=65535
		else
			if width<0 then width:=0;
		PCol^[num]:=width;
		if draw then
			begin
				SetScrollerRange;
				cmin:=num;
				cmax:=num;
				RowsClearOverflow(0,Parms.Rows,cmin,cmax);
				RowsCheckOverflow(0,Parms.Rows,cmin,cmax);
				wind_update(BEG_UPDATE);
				if GetVisibleBlockRect(0,cmin,Parms.Rows,Parms.Columns,sr) then WMRedraw(sr.X-1,Work.Y+PaintOffs,Work.X+Work.W,Work.H);
				wind_update(END_UPDATE);
				SetDirty
			end
	end;


function TCalcWindow.GetRowHeight_mm100(num: integer): word;

	begin
		GetRowHeight_mm100:=PRow^[num]
	end;


procedure TCalcWindow.SetRowHeight_mm100(num: integer; height: longint; draw: boolean);
	var r   : LGRECT;
	    pipe: Pipearray;

	begin
		if height>65535 then height:=65535
		else
			if height<0 then height:=0;
		PRow^[num]:=height;
		if draw then
			begin
				SetScrollerRange;
				Cell2Rect(num,0,r);
				pipe[0]:=WM_REDRAW;
				pipe[1]:=Application^.apID;
				pipe[2]:=0;
				pipe[3]:=Attr.gemHandle;
				pipe[4]:=Work.X;
				pipe[5]:=Max(integer(r.Y),Work.Y+PaintOffs);
				pipe[6]:=Work.W;
				pipe[7]:=Work.H;
				appl_write(pipe[1],16,@pipe);
				SetDirty
			end
	end;


function TCalcWindow.GetColWidth(num: integer): integer;

	begin
		GetColWidth:=round(longint(PCol^[num])*10.0*PercentSize/longint(Application^.Attr.PixW))+1
	end;


procedure TCalcWindow.SetColWidth(num: integer; width: longint; draw: boolean);

	begin
		SetColWidth_mm100(num,round(longint(width)*longint(Application^.Attr.PixW)/10.0),draw)
	end;


function TCalcWindow.GetRowHeight(num: integer): integer;

	begin
		GetRowHeight:=round(longint(PRow^[num])*10.0*PercentSize/longint(Application^.Attr.PixH))+1
	end;


procedure TCalcWindow.SetRowHeight(num: integer; height: longint; draw: boolean);

	begin
		SetRowHeight_mm100(num,round(longint(height)*longint(Application^.Attr.PixH)/10.0),draw)
	end;


procedure TCalcWindow.InsertCell(rs,cs,re,ce: integer);
	var txt  : string;
	    w,x  : integer;
	    tl,tr: char;

	begin
		txt:=StrPTrimF(inpline^.GetText);
		if length(txt)>0 then
			if txt[1]<>'=' then
				begin
					Application^.Bing;
					exit
				end;
		if (rs=re) and (cs=ce) then
			begin
				if (length(txt)=0) or (txt='=') then
					begin
						txt:='='+GetColumnIndex(cs)+GetRowIndex(rs);
						inpline^.SetText(txt);
						inpline^.SetCursor(length(txt))
					end
				else
					begin
						w:=inpline^.GetCursor;
						if w<1 then Application^.Bing
						else
							begin
								txt:=inpline^.GetText;
								tl:=txt[w];
								if w<length(txt) then tr:=txt[w+1]
								else
									tr:=#0;
								if (tl in [' ','(','+','-','*','/','^',';','=',':']) and (tr in [#0,' ',')','+','-','*','/','^',';',':']) then
									begin
										x:=length(txt)-w;
										txt:=StrPTrimF(StrPLeft(txt,w)+GetColumnIndex(cs)+GetRowIndex(rs)+StrPRight(txt,x));
										inpline^.SetText(txt);
										inpline^.SetCursor(length(txt)-x)
									end
								else
									Application^.Bing
							end
					end
			end
		else
			begin
				w:=inpline^.GetCursor;
				if w<1 then Application^.Bing
				else
					begin
						txt:=inpline^.GetText;
						tl:=txt[w];
						if w<length(txt) then tr:=txt[w+1]
						else
							tr:=#0;
						if (tl in [' ','(',';']) and (tr in [' ',')',';']) then
							begin
								x:=length(txt)-w;
								txt:=StrPTrimF(StrPLeft(txt,w)+GetColumnIndex(cs)+GetRowIndex(rs)+':'+GetColumnIndex(ce)+GetRowIndex(re)+StrPRight(txt,x));
								inpline^.SetText(txt);
								inpline^.SetCursor(length(txt)-x)
							end
						else
							Application^.Bing
					end
			end
	end;


procedure TCalcWindow.WMRubbox(r: GRECT);
	var cell      : PCell;
	    xl,xr,yo,
	    yu,cl,rw  : integer;

	begin
		inc(r.X,Work.X);
		inc(r.Y,Work.Y);
		GRtoA2(r);
		Mouse2Cell(r.X1,r.Y1,yo,xl);
		Mouse2Cell(r.X2,r.Y2,yu,xr);
		if inpstat then InsertCell(yo,xl,yu,xr)
		else
			with Parms.Cursor do
				if (xr>xl) or (yu>yo) then
					begin
						DrawCursor;
						DeselectAll;
						Block:=true;
						RowStart:=yo;
						ColStart:=xl;
						RowEnd:=yu;
						ColEnd:=xr;
						SetBlock;
						for rw:=yo to yu do
							begin
								cell:=GetCell(rw,xl);
								for cl:=xl to xr do
									begin
										with cell^ do Flags:=Flags or CELL_SELECTED;
										inc(longint(cell),CELLSIZE)
									end
							end;
						DrawCursor
					end
				else
					SetCursorPos(yo,xl,true)
	end;


procedure TCalcWindow.Mouse2Cell(x,y: integer; var r,c: integer);
	var q: longint;

	begin
		q:=(FindObject(x,y,false)-longint(Sheet)) div CELLSIZE;
		r:=q div (Parms.Columns+1);
		c:=q mod (Parms.Columns+1)
	end;


procedure TCalcWindow.DeselectAll;
	var x,y : integer;
	    cell: PCell;

	begin
		with Parms.Cursor do
			if Block then
				begin
					for y:=RowStart to RowEnd do
						begin
							cell:=GetCell(y,ColStart);
							for x:=ColStart to ColEnd do
								begin
									with cell^ do Flags:=Flags and not(CELL_SELECTED);
									inc(longint(cell),CELLSIZE)
								end
						end
				end
			else
				begin
					cell:=GetCell(Row,Col);
					with cell^ do Flags:=Flags and not(CELL_SELECTED)
				end
	end;


procedure TCalcWindow.StandardBreite(cs,ce: integer);
	var nw: longint;
	    q : integer;

	begin
		nw:=round(longint(wWidth)*atol(TexelApp.setupbuffer.stdcolwidth)*longint(Application^.Attr.PixW)/10.0);
		if ce>cs then
			for q:=ce downto cs+1 do SetColWidth_mm100(q,nw,false);
		SetColWidth_mm100(cs,nw,true)
	end;


procedure TCalcWindow.StandardHoehe(rs,re: integer);
	var nh: longint;
	    q : integer;

	begin
		nh:=round(longint(Attr.boxHeight)*longint(Application^.Attr.PixH)/10.0);
		if re>rs then
			for q:=re downto rs+1 do SetRowHeight_mm100(q,nh,false);
		SetRowHeight_mm100(rs,nh,true)
	end;


procedure TCalcWindow.WMRButton(mX,mY,KStat,Clicks: integer);
	var p     : PPopup;
	    num   : longint;
	    indx,w,
	    cmin,
	    cmax,
	    r,c   : integer;
	    cell  : PCell;
	    pe    : PEmbedded;

	procedure checkp2;

		begin
			p^.Disable(2);
			if Clipboard=nil then exit;
			with Clipboard^ do
				begin
					if not(OpenClipboard(false)) then exit;
					if GetPriorityClipboardFormat(TEXELEXTENSION+'.dif.csv')=TEXELEXTENSION then p^.Enable(2);
					{ andere Formate... }
					CloseClipboard
				end
		end;

	begin
		if Clicks<>1 then exit;
		num:=FindObject(mX,mY,false);
		if num=OBJ_TOGGLEALL then
			begin
				Application^.BubbleHelp(mX,mY,BUBBLE_SHEET_TOGGLE,false,false);
				exit
			end;
		if inpstat then
			begin
				Application^.Bing;
				exit
			end;
		if num<=OBJ_ROWOFFSET then
			begin
				indx:=OBJ_ROWOFFSET-num;
				if not(Parms.Cursor.Block) or (indx<Parms.Cursor.RowStart) or (indx>Parms.Cursor.RowEnd) or (Parms.Cursor.ColStart<>0) or (Parms.Cursor.ColEnd<>Parms.Columns) then
					begin
						DrawCursor;
						DeselectAll;
						with Parms.Cursor do
							begin
								Block:=true;
								RowStart:=indx;
								ColStart:=0;
								RowEnd:=RowStart;
								ColEnd:=Parms.Columns
							end;
						SetBlock;
						cell:=GetCell(Parms.Cursor.RowStart,0);
						for w:=0 to Parms.Columns do
							begin
								cell^.Flags:=cell^.Flags or CELL_SELECTED;
								inc(longint(cell),CELLSIZE)
							end;
						DrawCursor
					end;
				new(p,Init(@self,RTPOPUPS,RTPROWS,id_No));
				if p<>nil then
					begin
						checkp2;
						if Parms.Cursor.RowStart<>Parms.Cursor.RowEnd then p^.Disable(9)
						else
							if bTst(PRowFlags^[Parms.Cursor.RowStart],CRF_UMBRUCH) then p^.Check(9);
						case Application^.Popup(p,mX,mY,POP_CENTER) of
						0:
							CutCells;
						1:
							CopyCells;
						2:
							PasteCells;
						3:
							DeleteCells;
						5:
							AttrDialogs(2,indx,nil);
						6:
							{ ... };
						7:
							with Parms.Cursor do StandardHoehe(RowStart,RowEnd);
						9:
							begin
								PRowFlags^[Parms.Cursor.RowStart]:=PRowFlags^[Parms.Cursor.RowStart] xor CRF_UMBRUCH;
								DrawCells(Parms.Cursor.RowStart,0,Parms.Cursor.RowStart,Parms.Columns);
								SetDirty
							end;
						11:
							{ ... };
						12:
							{ ... }
						end
					end;
				exit
			end;
		if num<=OBJ_COLOFFSET then
			begin
				indx:=OBJ_COLOFFSET-num;
				if not(Parms.Cursor.Block) or (indx<Parms.Cursor.ColStart) or (indx>Parms.Cursor.ColEnd) or (Parms.Cursor.RowStart<>0) or (Parms.Cursor.RowEnd<>Parms.Rows) then
					begin
						DrawCursor;
						DeselectAll;
						with Parms.Cursor do
							begin
								Block:=true;
								RowStart:=0;
								ColStart:=indx;
								RowEnd:=Parms.Rows;
								ColEnd:=ColStart
							end;
						SetBlock;
						cell:=GetCell(0,Parms.Cursor.ColStart);
						for w:=0 to Parms.Rows do
							begin
								cell^.Flags:=cell^.Flags or CELL_SELECTED;
								inc(longint(cell),longint(Parms.Columns+1)*CELLSIZE)
							end;
						DrawCursor
					end;
				new(p,Init(@self,RTPOPUPS,RTPCOLUMNS,id_No));
				if p<>nil then
					begin
						checkp2;
						if Parms.Cursor.ColStart<>Parms.Cursor.ColEnd then p^.Disable(11)
						else
							if bTst(PColFlags^[Parms.Cursor.ColStart],CRF_UMBRUCH) then p^.Check(11);
						case Application^.Popup(p,mX,mY,POP_CENTER) of
						0:
							CutCells;
						1:
							CopyCells;
						2:
							PasteCells;
						3:
							DeleteCells;
						5:
							AttrDialogs(3,indx,nil);
						6:
							{ ... };
						7:
							with Parms.Cursor do StandardBreite(ColStart,ColEnd);
						9:
							AttrDialogs(4,indx,nil);
						11:
							begin
								cmin:=Parms.Cursor.ColStart;
								cmax:=cmin;
								RowsClearOverflow(0,Parms.Rows,cmin,cmax);
								PColFlags^[Parms.Cursor.ColStart]:=PColFlags^[Parms.Cursor.ColStart] xor CRF_UMBRUCH;
								RowsCheckOverflow(0,Parms.Rows,cmin,cmax);
								DrawCells(0,cmin,Parms.Rows,cmax);
								SetDirty
							end;
						13:
							{ ... };
						14:
							{ ... }
						end
					end;
				exit
			end;
		if num>$7fff then
			begin
				if Embedded<>nil then
					if sheetbuffer.images=bf_Checked then
						begin
							pe:=Embedded;
							while pe^.Next<>nil do pe:=pe^.Next;
							while pe<>nil do
								begin
									if pe^.IsInside(mX,mY) then
										begin
											pe^.RButton(mX,mY,KStat,Clicks);
											exit
										end;
									pe:=pe^.Prev
								end
						end;
				cell:=PCell(num);
				Cell2RC(cell,r,c);
				if not(Parms.Cursor.Block) or not(Between(r,Parms.Cursor.RowStart,Parms.Cursor.RowEnd)) or not(Between(c,Parms.Cursor.ColStart,Parms.Cursor.ColEnd)) then SetCursorPos(r,c,true);
				new(p,Init(@self,RTPOPUPS,RTPCELLS,id_No));
				if p<>nil then
					begin
						checkp2;
						if TexelApp.NoFontSel then p^.Disable(5);
{						if not(Parms.Cursor.Block) then !!! } p^.Disable(11);
{						if not(Parms.Cursor.Block) then ... } p^.Disable(13);
						case Application^.Popup(p,mX,mY,POP_CENTER) of
						0:
							CutCells;
						1:
							CopyCells;
						2:
							PasteCells;
						3:
							DeleteCells;
						5:
							FontSelect;
						6:
							AttrDialogs(0,0,cell);
						7:
							AttrDialogs(1,0,cell);
						8:
							AttrDialogs(6,0,cell);
						9:
							AttrDialogs(5,0,cell);
						11:
							if fill<>nil then fill^.HandleMenu(5);
						13:
							{ Export ... }
						end
					end
			end
	end;


procedure TCalcWindow.AttrDialogs(num,indx: integer; cell: PCell);

	begin
		if attrdialog=nil then attrdialog:=new(PAttrDialogs,Init(@self));
		if attrdialog<>nil then PAttrDialogs(attrdialog)^.Call(num,indx,cell)
		else
			Application^.Bing
	end;


function TCalcWindow.WMKeyDown(Stat,Key: integer): boolean;
	label _repon;

	var vr : GRECT;
	    r,c: integer;

	procedure insrtchar;

		begin
			if inpline=nil then exit;
			if chr(Key)<#32 then exit;
			if not(inpstat) then
				begin
					if Parms.Cursor.Block then SetCursorPos(Parms.Cursor.Row,Parms.Cursor.Col,true);
					inpline^.Clear;
					EnableInpline;
					InsertChar(chr(Key))
				end
		end;

	procedure crsoffs(dx,dy,wrap: integer);

		begin
			inc(dx,Parms.Cursor.Col);
			inc(dy,Parms.Cursor.Row);
			if dy<0 then
				begin
					if wrap=bf_Unchecked then dy:=0
					else
						if dx=0 then dy:=0
						else
							begin
								dy:=Parms.Rows;
								dec(dx)
							end
				end
			else
				if dy>Parms.Rows then
					begin
						if wrap=bf_Unchecked then dy:=Parms.Rows
						else
							if dx=Parms.Columns then dy:=Parms.Rows
							else
								begin
									dy:=0;
									inc(dx)
								end
					end;
			if dx<0 then
				begin
					if wrap=bf_Unchecked then dx:=0
					else
						if dy=0 then dx:=0
						else
							begin
								dx:=Parms.Columns;
								dec(dy)
							end
				end
			else
				if dx>Parms.Columns then
					begin
						if wrap=bf_Unchecked then dx:=Parms.Columns
						else
							if dy=Parms.Rows then dx:=Parms.Columns
							else
								begin
									dx:=0;
									inc(dy)
								end
					end;
			SetCursorPos(dy,dx,true)
		end;

	function anzh(dir: integer): integer;
		var ah: integer;

		begin
			GetVWork(vr);
			if vr.W<1 then
				begin
					anzh:=Parms.Cursor.Col;
					exit
				end;
			ah:=Parms.Cursor.Col;
			while (vr.W>0) and (ah>=0) and (ah<=Parms.Columns) do
				begin
					dec(vr.W,GetColWidth(ah));
					inc(ah,dir)
				end;
			dec(ah,dir);
			if ah=Parms.Cursor.Col then inc(ah,dir);
			anzh:=ah
		end;

	function anzv(dir: integer): integer;
		var av: integer;

		begin
			GetVWork(vr);
			if vr.H<1 then
				begin
					anzv:=Parms.Cursor.Row;
					exit
				end;
			av:=Parms.Cursor.Row;
			while (vr.H>0) and (av>=0) and (av<=Parms.Rows) do
				begin
					dec(vr.H,GetRowHeight(av));
					inc(av,dir)
				end;
			dec(av,dir);
			if av=Parms.Cursor.Row then inc(av,dir);
			anzv:=av
		end;

	begin
		KeyRepeatOff;
		WMKeyDown:=true;
		if Stat=K_NORMAL then
			begin
				if (Key=Return) or (Key=Enter) then
					case pdirbox^.GetSelection of
					CRS_DOWN:
						Key:=Cur_Down;
					CRS_RIGHT:
						Key:=Cur_Right;
					CRS_UP:
						Key:=Cur_Up;
					CRS_LEFT:
						Key:=Cur_Left;
					CRS_NW:
						begin
							crsoffs(-1,-1,TexelApp.setupbuffer.cursorwrap);
							goto _repon
						end;
					CRS_NE:
						begin
							crsoffs(1,-1,TexelApp.setupbuffer.cursorwrap);
							goto _repon
						end;
					CRS_SW:
						begin
							crsoffs(-1,1,TexelApp.setupbuffer.cursorwrap);
							goto _repon
						end;
					CRS_SE:
						begin
							crsoffs(1,1,TexelApp.setupbuffer.cursorwrap);
							goto _repon
						end
					else
						begin
							SetCursorPos(Parms.Cursor.Row,Parms.Cursor.Col,true);
							goto _repon
						end
					end;
				case Key of
				Backspace,S_Insert:;
				Tab:
					if inpline<>nil then
						begin
							if not(inpstat) then
								begin
									if Parms.Cursor.Block then SetCursorPos(Parms.Cursor.Row,Parms.Cursor.Col,true);
									EnableInpline
								end
							else
								CancelInpline
						end;
				Cur_Up:
					crsoffs(0,-1,TexelApp.setupbuffer.cursorwrap);
				Cur_Down:
					crsoffs(0,1,TexelApp.setupbuffer.cursorwrap);
				Cur_Left:
					crsoffs(-1,0,TexelApp.setupbuffer.cursorwrap);
				Cur_Right:
					crsoffs(1,0,TexelApp.setupbuffer.cursorwrap);
				F2:
					if pfett<>nil then
						begin
							pfett^.Toggle;
							pfett^.Work
						end;
				F3:
					if pkursiv<>nil then
						begin
							pkursiv^.Toggle;
							pkursiv^.Work
						end;
				F4:
					if punter<>nil then
						begin
							punter^.Toggle;
							punter^.Work
						end;
				F5:
					if palignleft<>nil then palignleft^.Work;
				F6:
					if paligncenter<>nil then paligncenter^.Work;
				F7:
					if palignright<>nil then palignright^.Work;
				F8:
					if dezplus<>nil then dezplus^.Work;
				F9:
					if dezminus<>nil then dezminus^.Work;
				F10:
					if tsumme<>nil then tsumme^.Work;
				18688:
					crsoffs(0,anzv(-1)-Parms.Cursor.Row,bf_Unchecked);
				20736:
					crsoffs(0,anzv(1)-Parms.Cursor.Row,bf_Unchecked);
				20224:
					begin
						SetCursorPos(Parms.Rows,Parms.Columns,false);
						Scroller^.ScrollTo(Scroller^.XRange,Scroller^.YRange)
					end;
				Home:
					begin
						SetCursorPos(0,0,false);
						Scroller^.ScrollTo(0,0)
					end
				else
					insrtchar
				end;
				goto _repon
			end;
		if Stat=K_CTRL then
			begin
				case Key of
				18432:
					Scroller^.ScrollBy(0,-Scroller^.YPage);
				20480:
					Scroller^.ScrollBy(0,Scroller^.YPage);
				29440:
					Scroller^.ScrollBy(-Scroller^.XPage,0);
				29696:
					Scroller^.ScrollBy(Scroller^.XPage,0);
				Ctrl_Z:
					FontSelect;
				30464:
					SetCursorPos(Parms.Cursor.OldRow,Parms.Cursor.OldCol,true)
				else
					WMKeyDown:=false
				end;
				goto _repon
			end;
		if Stat=K_ALT then
			begin
				case Key of
				Alt_D:
					if clrinh<>nil then clrinh^.HandleMenu(1);
				Alt_V:
					if Embedded<>nil then
						if objects<>nil then objects^.HandleMenu(9);
				Alt_H:
					formrow^.HandleMenu(0);
				Alt_B:
					formcol^.HandleMenu(0)
				else
					insrtchar
				end;
				goto _repon
			end;
		if (Stat and K_SHIFT)>0 then
			begin
				if bTst(Stat,K_CTRL) then
					case (MapKey(Key) and $00ff) of
					65:
{						if fill<>nil then fill^.HandleMenu(5) !!! };
					77:
						AttrDialogs(5,0,GetCell(Parms.Cursor.Row,Parms.Cursor.Col));
					84:
						AttrDialogs(0,0,GetCell(Parms.Cursor.Row,Parms.Cursor.Col));
					90:
						AttrDialogs(1,0,GetCell(Parms.Cursor.Row,Parms.Cursor.Col));
					82:
						AttrDialogs(6,0,GetCell(Parms.Cursor.Row,Parms.Cursor.Col));
					56:
						pdirbox^.SetSelection(CRS_UP,true);
					52,115:
						pdirbox^.SetSelection(CRS_LEFT,true);
					54,116:
						pdirbox^.SetSelection(CRS_RIGHT,true);
					50:
						pdirbox^.SetSelection(CRS_DOWN,true)
					end
				else
					if bTst(Stat,K_ALT) then
						case Key of
						Alt_D:
							if clrinh<>nil then clrinh^.HandleMenu(0);
						else
							begin
								if chr(Key)=#0 then WMKeyDown:=false
								else
									insrtchar
							end
						end
					else
						case Key of
						Shift_Home:
							begin
								SetCursorPos(Parms.Rows,Parms.Columns,false);
								Scroller^.ScrollTo(Scroller^.XRange,Scroller^.YRange)
							end;
						Shift_CU:
							crsoffs(0,anzv(-1)-Parms.Cursor.Row,bf_Unchecked);
						Shift_CD:
							crsoffs(0,anzv(1)-Parms.Cursor.Row,bf_Unchecked);
						Shift_CL:
							crsoffs(anzh(-1)-Parms.Cursor.Col,0,bf_Unchecked);
						Shift_CR:
							crsoffs(anzh(1)-Parms.Cursor.Col,0,bf_Unchecked);
						else
							insrtchar
						end;
				goto _repon
			end;
		WMKeyDown:=false;
		_repon:
		KeyRepeatRestore
	end;


function TCalcWindow.ExitDlg(AnIndx: integer): boolean;
	var s    : string;
	    p    : PBlockDialog;
	    ed   : PEdit;
	    psc  : PStringCollection;
	    q    : integer;
	    pbuf : record
		    inp: string[15];
		    sel: integer
	    end;

	begin
		case AnIndx of
		RTWDBLOCK:
			begin
				new(p,Init(@self,'',RTBLOCK));
				if p<>nil then
					begin
						if BlockHistory=nil then new(BlockHistory,Init(5+atol(TexelApp.setupbuffer.history),10));
						if BlockHistory<>nil then
							begin
								BlockHistory^.Sort:=false;
								s:='  '+dblock^.GetText+#0;
								BlockHistory^.Insert(NewStr(s));
								if BlockHistory^.Count>1 then
									for q:=0 to BlockHistory^.Count-2 do
										if PString(BlockHistory^.At(q))^=s then
											begin
												BlockHistory^.AtFree(q);
												break
											end;
								while BlockHistory^.Count>atol(TexelApp.setupbuffer.history) do BlockHistory^.AtFree(0)
							end;
						p^.Attr.ExStyle:=(p^.Attr.ExStyle and not(ws_ex_Center2Parent)) or ws_ex_Popup;
						new(ed,Init(p,RTBINPUT,16,BUBBLE_BLOCK_EDIT));
						new(psc,Init(50+atol(TexelApp.setupbuffer.history),20));
						if psc<>nil then
							begin
								psc^.Sort:=false;
								if Variables<>nil then
									if Variables^.Count>0 then
										for q:=0 to Variables^.Count-1 do
											begin
												with PVariable(Variables^.At(q))^ do
													begin
														s:=' '+GetColumnIndex(RefCol)+GetRowIndex(RefRow)+#0;
														if length(Name^)>20-length(s) then s:='  '+StrPLeft(Name^,17-length(s))+'...'+s
														else
															s:='  '+Name^+StrPSpace(20-length(Name^)-length(s))+s
													end;
												psc^.Insert(NewStr(s))
											end;
								if BlockHistory<>nil then
									if BlockHistory^.Count>0 then
										for q:=0 to BlockHistory^.Count-1 do psc^.AtInsert(0,NewStr(PString(BlockHistory^.At(q))^))
							end;
						new(p^.pbb,Init(p,RTBLIST,RTBLSLIDER,RTBLUP,RTBLDOWN,psc,true,BUBBLE_BLOCK_LIST));
						if p^.pbb<>nil then p^.pbb^.ed:=ed;
						new(PButton,Init(p,RTBCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(p,RTBOK,id_OK,true,BUBBLE_BLOCK_OK));
						pbuf.inp:=StrPTrimF(dblock^.GetText);
						pbuf.sel:=0;
						p^.TransferBuffer:=@pbuf;
						if Application^.ExecDialog(p)=RTBOK then
							if pbuf.inp<>StrPTrimF(dblock^.GetText) then GotoBlock(pbuf.inp)
					end
			end;
		RTWDOK:
			SetCursorPos(Parms.Cursor.Row,Parms.Cursor.Col,true);
		RTWDCANCEL:
			CancelInpline;
		RTWDTBSWITCH:
			ToggleToolbar;
		end;
		ExitDlg:=false
	end;


procedure TCalcWindow.ToggleToolbar;
	var pt: PTree;

	begin
		pt:=Application^.GetAddr(RTICONS);
		if Class.ToolbarTree<>nil then
			begin
				if (tbonoff<>nil) and (pt<>nil) then
					tbonoff^.ObjAddr^.ob_spec.bit_blk^.bi_pdata:=pt^[RTITBON].ob_spec.bit_blk^.bi_pdata;
				FreeToolbar(RTWTOOLBAR);
			end
		else
			begin
				if (tbonoff<>nil) and (pt<>nil) then
					tbonoff^.ObjAddr^.ob_spec.bit_blk^.bi_pdata:=pt^[RTITBOFF].ob_spec.bit_blk^.bi_pdata;
				LoadToolbar(RTWTOOLBAR);
				if Class.ToolbarTree<>nil then
					with Class.ToolbarTree^[0] do
						begin
							ob_height:=Class.ToolbarTree^[ob_head].ob_spec.icon_blk^.ib_hicon+(Class.ToolbarTree^[ob_head].ob_y shl 1);
							if MagiCVersion>=$0300 then ob_spec.index:=(ob_spec.index and $ff00ffff) or $00020000
						end
			end
	end;


procedure TCalcWindow.GotoBlock(s: string);
	var dummy,
	    rs,cs,
	    re,ce,
	    rw,cl: integer;
	    cell : PCell;

	begin
		if GetBlock(s,false,rs,cs,re,ce,dummy,dummy) then
			with Parms.Cursor do
				if (re>rs) or (ce>cs) then
					begin
						DrawCursor;
						DeselectAll;
						Block:=true;
						RowStart:=rs;
						ColStart:=cs;
						RowEnd:=re;
						ColEnd:=ce;
						SetBlock;
						for rw:=rs to re do
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
					SetCursorPos(rs,cs,true)
	end;


function TCalcWindow.SelectDisabled(AnIndx,KStat,Clicks: integer): boolean;

	begin
		if AnIndx=RTWDINPUT then
			begin
				SelectDisabled:=true;
				if inpline=nil then exit;
				if Parms.Cursor.Block then SetCursorPos(Parms.Cursor.Row,Parms.Cursor.Col,true);
				EnableInpline
			end
		else
			SelectDisabled:=false
	end;


procedure TCalcWindow.WMClick(mX,mY,KStat: integer);
	label _setcursor,_normal;

	var num,nr,onr,
	    xsc,ysc    : longint;
	    rs,cs,re,ce,
	    dummy,btn,
	    w,r,c,x,y,
	    ro,co,
	    ms,ks,r2,c2,
	    xo,yo,xofs,
	    yofs,xn,yn : integer;
	    cell       : PCell;
	    rci        : GRECT;
	    rct        : LGRECT;
	    pe         : PEmbedded;

	procedure InvertBlock(rs,cs,re,ce: integer);
		var x,y : integer;
		    cell: PCell;

		begin
			DrawBlock(rs,cs,re,ce);
			for y:=rs to re do
				begin
					cell:=GetCell(y,cs);
					for x:=cs to ce do
						begin
							with cell^ do Flags:=Flags xor CELL_SELECTED;
							inc(longint(cell),CELLSIZE)
						end
				end
		end;

	procedure DrawHVCursor(vert: boolean);
		var valid: boolean;
		    rect : GRECT;

		begin
			if vert then
				begin
					pxya[0]:=x-xofs;
					pxya[1]:=rci.Y1;
					pxya[2]:=pxya[0];
					pxya[3]:=rci.Y2
				end
			else
				begin
					pxya[0]:=rci.X1;
					pxya[1]:=y-yofs;
					pxya[2]:=rci.X2;
					pxya[3]:=pxya[1]
				end;
			HideMouse;
			valid:=FirstWorkRect(rect);
			while valid do
				begin
					if rc_intersect(rci,rect) then
						begin
							vs_clip(vdiHandle,CLIP_ON,rect.A2);
							v_pline(vdiHandle,2,pxya)
						end;
					valid:=NextWorkRect(rect)
				end;
			ShowMouse
		end;

	procedure DrawIntersection;
		var rso,cso,reo,ceo: integer;
		    oldb,newb,same : GRECT;

		procedure Invert(rect: GRECT);
		
			begin
				GRtoA2(rect);
				if same.Y1>rect.Y1 then InvertBlock(rect.Y1,Min(same.X1,rect.X1),same.Y1-1,Max(same.X2,rect.X2));
				if same.Y2<rect.Y2 then InvertBlock(same.Y2+1,Min(same.X1,rect.X1),rect.Y2,Max(same.X2,rect.X2));
				if same.X1>rect.X1 then InvertBlock(Max(rect.Y1,same.Y1),rect.X1,Min(rect.Y2,same.Y2),same.X1-1);
				if same.X2<rect.X2 then InvertBlock(Max(rect.Y1,same.Y1),same.X2+1,Min(rect.Y2,same.Y2),rect.X2)
			end;

		begin
			with Parms.Cursor do
				begin
					if Block then
						begin
							rso:=RowStart;
							cso:=ColStart;
							reo:=RowEnd;
							ceo:=ColEnd
						end
					else
						begin
							rso:=Row;
							cso:=Col;
							reo:=rso;
							ceo:=cso
						end;
					Block:=true;
					RowStart:=Min(r,r2);
					ColStart:=Min(c,c2);
					RowEnd:=Max(r,r2);
					ColEnd:=Max(c,c2);
					SetBlock;
					with oldb do
						begin
							X:=cso;
							Y:=rso;
							W:=ceo+1-cso;
							H:=reo+1-rso
						end;
					with newb do
						begin
							X:=ColStart;
							Y:=RowStart;
							W:=ColEnd+1-ColStart;
							H:=RowEnd+1-RowStart
						end;
					same:=newb;
					rc_intersect(oldb,same);
					GRtoA2(same);
					Invert(oldb);
					Invert(newb)
				end
		end;

	begin
		if Application^.GetPTopWindow=nil then Top;
		num:=FindObject(mX,mY,true);
		if num=OBJ_TOGGLEALL then
			begin
				if inpstat then
					begin
						Application^.Bing;
						exit
					end;
				if Parms.Cursor.Block then
					begin
						DrawCursor;
						DeselectAll;
						Parms.Cursor.Block:=false;
						SetBlock;
						cell:=GetCell(Parms.Cursor.Row,Parms.Cursor.Col);
						with cell^ do Flags:=Flags or CELL_SELECTED;
						DrawCursor
					end
				else
					SelectAll;
				Application^.ReleaseMouseButton(1);
				exit
			end;
		if num<=OBJ_RSIZEOFFSET then
			begin
				wind_update(BEG_UPDATE);
				wind_update(BEG_MCTRL);
				SetMouse(IDC_CROSS,nil);
				graf_mkstate(x,yo,ms,ks);
				num:=OBJ_RSIZEOFFSET-num;
				Cell2Rect(num,0,rct);
				yofs:=yo-rct.Y2-1;
				yn:=yo;
				rci:=Work;
				inc(rci.Y,PaintOffs+TopRowHeight+1);
				dec(rci.H,PaintOffs+TopRowHeight+1);
				vswr_mode(vdiHandle,MD_XOR);
				vsl_type(vdiHandle,LT_USERDEF);
				repeat
					y:=yn;
					DrawHVCursor(false);
					repeat
						graf_mkstate(x,yn,ms,ks);
						if yn<rct.Y1+1 then yn:=rct.Y1+1
					until (y<>yn) or ((ms and 3)<>1);
					DrawHVCursor(false)
				until (ms and 3)<>1;
				vsl_type(vdiHandle,LT_SOLID);
				vswr_mode(vdiHandle,MD_REPLACE);
				vs_clip(vdihandle,CLIP_ON,SysInfo.Desktop.A2);
				repeat
					graf_mkstate(x,x,xo,x)
				until (xo and 3)=0;
				LastMouse;
				wind_update(END_MCTRL);
				wind_update(END_UPDATE);
				if (y<>yo) and not(bTst(ms,2)) then SetRowHeight(num,round((GetRowHeight(num)+y-yo-1)/PercentSize),true);
				exit
			end;
		if num<=OBJ_CSIZEOFFSET then
			begin
				wind_update(BEG_UPDATE);
				wind_update(BEG_MCTRL);
				SetMouse(IDC_CROSS,nil);
				graf_mkstate(xo,y,ms,ks);
				num:=OBJ_CSIZEOFFSET-num;
				Cell2Rect(0,num,rct);
				xofs:=xo-rct.X2-1;
				xn:=xo;
				rci:=Work;
				inc(rci.X,LeftColWidth+1);
				inc(rci.Y,PaintOffs);
				dec(rci.W,LeftColWidth+1);
				dec(rci.H,PaintOffs);
				vswr_mode(vdiHandle,MD_XOR);
				vsl_type(vdiHandle,LT_USERDEF);
				repeat
					x:=xn;
					DrawHVCursor(true);
					repeat
						graf_mkstate(xn,y,ms,ks);
						if xn<rct.X1+1 then xn:=rct.X1+1
					until (x<>xn) or ((ms and 3)<>1);
					DrawHVCursor(true)
				until (ms and 3)<>1;
				vsl_type(vdiHandle,LT_SOLID);
				vswr_mode(vdiHandle,MD_REPLACE);
				vs_clip(vdihandle,CLIP_ON,SysInfo.Desktop.A2);
				repeat
					graf_mkstate(y,y,yo,y)
				until (yo and 3)=0;
				LastMouse;
				wind_update(END_MCTRL);
				wind_update(END_UPDATE);
				if (x<>xo) and not(bTst(ms,2)) then SetColWidth(num,round((GetColWidth(num)+x-xo-1)/PercentSize),true);
				exit
			end;
		if num<=OBJ_ROWOFFSET then
			begin
				if inpstat then
					begin
						Application^.Bing;
						exit
					end;
				DrawCursor;
				DeselectAll;
				with Parms.Cursor do
					begin
						Block:=true;
						RowStart:=OBJ_ROWOFFSET-num;
						ColStart:=0;
						RowEnd:=RowStart;
						ColEnd:=Parms.Columns
					end;
				SetBlock;
				cell:=GetCell(Parms.Cursor.RowStart,0);
				for w:=0 to Parms.Columns do
					begin
						cell^.Flags:=cell^.Flags or CELL_SELECTED;
						inc(longint(cell),CELLSIZE)
					end;
				DrawCursor;
				wind_update(BEG_MCTRL);
				onr:=num;
				graf_mkstate(x,y,ms,ks);
				while bTst(ms,1) do
					begin
						if y<Work.Y1+PaintOffs+TopRowHeight+1 then Scroller^.ScrollBy(0,-GetRowHeight(OBJ_ROWOFFSET-onr))
						else
							if y>Work.Y2 then Scroller^.ScrollBy(0,GetRowHeight(OBJ_ROWOFFSET-onr));
						nr:=FindObject(Work.X,Max(y,Work.Y+PaintOffs+TopRowHeight+1),false);
						if nr<>onr then
							if nr<=OBJ_ROWOFFSET then
								begin
									with Parms.Cursor do
										if nr<num then
											begin
												RowStart:=OBJ_ROWOFFSET-num;
												RowEnd:=OBJ_ROWOFFSET-nr
											end
										else
											begin
												RowStart:=OBJ_ROWOFFSET-nr;
												RowEnd:=OBJ_ROWOFFSET-num
											end;
									SetBlock;
									if onr<nr then
										begin
											r:=OBJ_ROWOFFSET-nr;
											r2:=OBJ_ROWOFFSET-onr
										end
									else
										begin
											r:=OBJ_ROWOFFSET-onr;
											r2:=OBJ_ROWOFFSET-nr
										end;
									if Sgn(num-onr)=-Sgn(num-nr) then
										begin
											InvertBlock(r,0,OBJ_ROWOFFSET-num-1,Parms.Columns);
											InvertBlock(OBJ_ROWOFFSET+1-num,0,r2,Parms.Columns)
										end
									else
										begin
											if nr<num then inc(r)
											else
												if nr>num then dec(r2)
												else
													begin
														if onr<num then inc(r)
														else
															dec(r2)
													end;
											InvertBlock(r,0,r2,Parms.Columns)
										end;
									onr:=nr
								end;
						graf_mkstate(x,y,ms,ks)
					end;
				wind_update(END_MCTRL);
				exit
			end;
		if num<=OBJ_COLOFFSET then
			begin
				if inpstat then
					begin
						Application^.Bing;
						exit
					end;
				DrawCursor;
				DeselectAll;
				with Parms.Cursor do
					begin
						Block:=true;
						RowStart:=0;
						ColStart:=OBJ_COLOFFSET-num;
						RowEnd:=Parms.Rows;
						ColEnd:=ColStart
					end;
				SetBlock;
				cell:=GetCell(0,Parms.Cursor.ColStart);
				for w:=0 to Parms.Rows do
					begin
						cell^.Flags:=cell^.Flags or CELL_SELECTED;
						inc(longint(cell),longint(Parms.Columns+1)*CELLSIZE)
					end;
				DrawCursor;
				wind_update(BEG_MCTRL);
				onr:=num;
				graf_mkstate(x,y,ms,ks);
				while bTst(ms,1) do
					begin
						if x<Work.X1+LeftColWidth+1 then Scroller^.ScrollBy(-GetColWidth(OBJ_COLOFFSET-onr),0)
						else
							if x>Work.X2 then Scroller^.ScrollBy(GetColWidth(OBJ_COLOFFSET-onr),0);
						nr:=FindObject(Max(x,Work.X+LeftColWidth+1),Work.Y+PaintOffs,false);
						if nr<>onr then
							if (nr>OBJ_ROWOFFSET) and (nr<=OBJ_COLOFFSET) then
								begin
									with Parms.Cursor do
										if nr<num then
											begin
												ColStart:=OBJ_COLOFFSET-num;
												ColEnd:=OBJ_COLOFFSET-nr
											end
										else
											begin
												ColStart:=OBJ_COLOFFSET-nr;
												ColEnd:=OBJ_COLOFFSET-num
											end;
									SetBlock;
									if onr<nr then
										begin
											r:=OBJ_COLOFFSET-nr;
											r2:=OBJ_COLOFFSET-onr
										end
									else
										begin
											r:=OBJ_COLOFFSET-onr;
											r2:=OBJ_COLOFFSET-nr
										end;
									if Sgn(num-onr)=-Sgn(num-nr) then
										begin
											InvertBlock(0,r,Parms.Rows,OBJ_COLOFFSET-num-1);
											InvertBlock(0,OBJ_COLOFFSET+1-num,Parms.Rows,r2)
										end
									else
										begin
											if nr<num then inc(r)
											else
												if nr>num then dec(r2)
												else
													begin
														if onr<num then inc(r)
														else
															dec(r2)
													end;
											InvertBlock(0,r,Parms.Rows,r2)
										end;
									onr:=nr
								end;
						graf_mkstate(x,y,ms,ks)
					end;
				wind_update(END_MCTRL);
				exit
			end;
		if num>$7fff then
			begin
				if Embedded<>nil then
					if sheetbuffer.images=bf_Checked then
						begin
							pe:=Embedded;
							while pe^.Next<>nil do pe:=pe^.Next;
							while pe<>nil do
								begin
									if pe^.IsInside(mX,mY) then
										begin
											pe^.Click(mX,mY,KStat);
											exit
										end;
									pe:=pe^.Prev
								end
						end;
				Mouse2Cell(mX,mY,r,c);
				with Parms.Cursor do
					begin
						if (TexelApp.setupbuffer.online=bf_Checked) and not(inpstat) then
							begin
								if (Block and Between(r,RowStart,RowEnd) and Between(c,ColStart,ColEnd)) or (not(Block) and (r=Row) and (c=Col) and ((Kbshift(-1) and (K_SHIFT or K_CTRL))>0)) then goto _normal;
								if (Kbshift(-1) and (K_SHIFT or K_CTRL))>0 then goto _normal;
								if bTst(Kbshift(-1),K_ALT) then goto _normal;
								wind_update(BEG_UPDATE);
								wind_update(BEG_MCTRL);
								graf_mouse(POINT_HAND,nil);
								onr:=num;
								r2:=r;
								c2:=c;
								repeat
									if (r2=r) and (c2=c) then SetCursorPos(r,c,true)
									else
										DrawIntersection;
									ro:=r2;
									co:=c2;
									repeat
										graf_mkstate(x,y,ms,ks);
										if x<Work.X1+LeftColWidth+1 then xsc:=-GetColWidth(Min(co,c))
										else
											if x>Work.X2 then xsc:=GetColWidth(Max(co,c))
											else
												xsc:=0;
										if y<Work.Y1+PaintOffs+TopRowHeight+1 then ysc:=-GetRowHeight(Min(ro,r))
										else
											if y>Work.Y2 then ysc:=GetRowHeight(Max(ro,r))
											else
												ysc:=0;
										if (xsc<>0) or (ysc<>0) then Scroller^.ScrollBy(xsc,ysc);
										nr:=FindObject(Max(x,Work.X+LeftColWidth+1),Max(y,Work.Y+PaintOffs+TopRowHeight+1),false)
									until (nr<>onr) or not(bTst(ms,1));
									if nr<>onr then
										if nr>$7fff then
											begin
												Cell2RC(PCell(nr),r2,c2);
												onr:=nr
											end
								until not(bTst(ms,1));
								graf_mouse(ARROW,nil);
								wind_update(END_MCTRL);
								wind_update(END_UPDATE);
								exit
							end;
						_normal:
						if bTst(KStat,K_ALT) then
							begin
								if Block then
									begin
										rs:=RowStart;
										cs:=ColStart;
										re:=RowEnd;
										ce:=ColEnd
									end
								else
									begin
										rs:=Row;
										cs:=Col;
										re:=Row;
										ce:=Col
									end;
								if Between(r,rs,re) then
									begin
										if r-rs<re-r then rs:=r
										else
											re:=r
									end
								else
									if r<rs then rs:=r
									else
										re:=r;
								if Between(c,cs,ce) then
									begin
										if c-cs<ce-c then cs:=c
										else
											ce:=c
									end
								else
									if c<cs then cs:=c
									else
										ce:=c;
								if (ce>cs) or (re>rs) then
									begin
										DrawCursor;
										DeselectAll;
										Block:=true;
										RowStart:=rs;
										ColStart:=cs;
										RowEnd:=re;
										ColEnd:=ce;
										SetBlock;
										for y:=rs to re do
											begin
												cell:=GetCell(y,cs);
												for x:=cs to ce do
													begin
														with cell^ do Flags:=Flags or CELL_SELECTED;
														inc(longint(cell),CELLSIZE)
													end
											end;
										DrawCursor
									end
								else
									SetCursorPos(rs,cs,true);
								Application^.ReleaseMouseButton(1)
							end
						else
							if (Block and Between(r,RowStart,RowEnd) and Between(c,ColStart,ColEnd)) or (not(Block) and (r=Row) and (c=Col)) then
								begin
									evnt_timer(10,0);
									graf_mkstate(w,w,ms,w);
									if not(bTst(ms,1)) then goto _setcursor;
									InternalDragDrop(mX,mY)
								end
							else
								begin
									_setcursor:
									if inpstat then InsertCell(r,c,r,c)
									else
										SetCursorPos(r,c,true);
									Application^.ReleaseMouseButton(1)
								end
					end
			end
	end;


procedure TCalcWindow.InternalDragDrop(mX,mY: integer);
	var rci,sr,
	    thisr   : GRECT;
	    forcexit: boolean;
	    x,y,
	    x2,y2,
	    ro,co,
	    ur,uc,
	    bs,r,c,
	    rs,cs,
	    re,ce,
	    xs,ys,
	    xe,ye,
	    wnd,
	    dummy   : integer;
	    oldx,
	    oldy,
	    xsc,
	    ysc     : longint;
	    pw      : PWindow;
	    pcw     : PCalcWindow;
	    pipe    : Pipearray;

	procedure InvertDragDropCell;
		var rect,rc: GRECT;
		    valid  : boolean;

		begin
			if pcw=nil then exit;
			if (ro<0) or (co<0) then exit;
			pcw^.Cell2VRect(ro,co,rect);
			valid:=pcw^.FirstWorkRect(rc);
			while valid do
				begin
					if rc_intersect(rect,rc) then vr_recfl(Application^.vdiHandle,rc.A2);
					valid:=pcw^.NextWorkRect(rc)
				end
		end;

	procedure getrc(var r,c: integer);

		begin
			if Between(x,sr.X1,sr.X2) and Between(y,sr.Y1,sr.Y2) then
				begin
					pcw^.Mouse2Cell(x,y,r,c);
					if pcw=@self then
						if ((r=ur) and (c=uc)) or ((r=rs) and (c=cs)) then
							begin
								r:=-1;
								c:=-1
							end
				end
			else
				begin
					r:=-1;
					c:=-1
				end
		end;

	begin
		wind_update(BEG_UPDATE);
		wind_update(BEG_MCTRL);
		GetSheetRect(thisr);
		with Parms.Cursor do
			if Block then
				begin
					GetVisibleBlockRect(RowStart,ColStart,RowEnd,ColEnd,rci);
					rs:=RowStart;
					cs:=ColStart;
					re:=RowEnd;
					ce:=ColEnd
				end
			else
				begin
					GetVisibleBlockRect(Row,Col,Row,Col,rci);
					rs:=Row;
					cs:=Col;
					re:=Row;
					ce:=Col
				end;
		SetMouse(FLAT_HAND,nil);
		vswr_mode(Application^.vdiHandle,MD_XOR);
		vsl_type(Application^.vdiHandle,LT_USERDEF);
		vsf_interior(Application^.vdiHandle,FIS_PATTERN);
		Mouse2Cell(mX,mY,ur,uc);
		x2:=mX;
		y2:=mY;
		wnd:=0;
		pcw:=nil;
		HideMouse;
		repeat
			x:=x2;
			y:=y2;
			dummy:=wind_find(x,y);
			if dummy>0 then
				begin
					if dummy<>wnd then
						begin
							InvertDragDropCell;
							pcw:=nil;
							wnd:=dummy;
							pw:=Application^.GetGPWindow(wnd);
							if pw<>nil then
								if pw^.GetClassName=TEXELWINDCLASS then pcw:=PCalcWindow(pw);
							if pcw<>nil then
								begin
									pcw^.GetSheetRect(sr);
									getrc(ro,co);
									InvertDragDropCell
								end
						end
					else
						if pcw<>nil then
							begin
								getrc(r,c);
								if (r<>ro) or (c<>co) then
									begin
										InvertDragDropCell;
										ro:=r;
										co:=c;
										InvertDragDropCell
									end
							end
				end
			else
				if wnd>0 then
					begin
						InvertDragDropCell;
						pcw:=nil;
						wnd:=0
					end;
			forcexit:=false;
			if (pcw=nil) or (pcw=@self) then
				if IsTop then
					if (Kbshift(-1) and K_SHIFT)=0 then
						begin
							Mouse2Cell(thisr.X1,thisr.Y1,ys,xs);
							Mouse2Cell(thisr.X2,thisr.Y2,ye,xe);
							if x<thisr.X1 then xsc:=-GetColWidth(xs)
							else
								if x>thisr.X2 then xsc:=GetColWidth(xe)
								else
									xsc:=0;
							if y<thisr.Y1 then ysc:=-GetRowHeight(ys)
							else
								if y>thisr.Y2 then ysc:=GetRowHeight(ye)
								else
									ysc:=0;
							if (xsc<>0) or (ysc<>0) then
								begin
									vswr_mode(Application^.vdiHandle,MD_REPLACE);
									vsl_type(Application^.vdiHandle,LT_SOLID);
									vsf_interior(Application^.vdiHandle,FIS_HOLLOW);
									oldy:=Scroller^.YPos;
									oldx:=Scroller^.XPos;
									Scroller^.ScrollBy(xsc,ysc);
									evnt_timer(10,0);
									vswr_mode(Application^.vdiHandle,MD_XOR);
									vsl_type(Application^.vdiHandle,LT_USERDEF);
									vsf_interior(Application^.vdiHandle,FIS_PATTERN);
									forcexit:=((Scroller^.YPos<>oldy) or (Scroller^.XPos<>oldx))
								end
						end;
			pxya[0]:=rci.X1+x-mX;
			pxya[1]:=rci.Y1+y-mY;
			pxya[2]:=rci.X2+x-mX;
			pxya[3]:=pxya[1];
			pxya[4]:=pxya[2];
			pxya[5]:=rci.Y2+y-mY;
			pxya[6]:=pxya[0];
			pxya[7]:=pxya[5];
			pxya[8]:=pxya[0];
			pxya[9]:=pxya[1];
			v_pline(Application^.vdiHandle,5,pxya);
			ShowMouse;
			repeat
				graf_mkstate(x2,y2,bs,dummy)
			until (x<>x2) or (y<>y2) or (bs<>1) or forcexit;
			HideMouse;
			v_pline(Application^.vdiHandle,5,pxya)
		until bs<>1;
		InvertDragDropCell;
		ShowMouse;
		vswr_mode(Application^.vdiHandle,MD_REPLACE);
		vsl_type(Application^.vdiHandle,LT_SOLID);
		vsf_interior(Application^.vdiHandle,FIS_HOLLOW);
		LastMouse;
		wind_update(END_MCTRL);
		wind_update(END_UPDATE);
		if bs=0 then
			begin
				if pcw=nil then
					begin
						dummy:=wind_find(x,y);
						if dummy=DESK then
							if Application^.AVServer>=0 then
								begin
									pipe[0]:=AV_WHAT_IZIT;
									pipe[1]:=Application^.apID;
									pipe[2]:=0;
									pipe[3]:=x;
									pipe[4]:=y;
									pipe[5]:=0;
									pipe[6]:=0;
									pipe[7]:=0;
									appl_write(Application^.AVServer,16,@pipe);
									TexelApp.izitWind:=Attr.gemHandle;
									TexelApp.izitTicks:=GetTicks
								end
					end
				else
					if (ro>=0) and (co>=0) then pcw^.CopyFromInternalDragDrop(@self,rs,cs,re,ce,ro,co,(Kbshift(-1) and K_CTRL)>0)
			end
	end;


procedure TCalcWindow.CopyFromInternalDragDrop(from: PCalcWindow; rs,cs,re,ce,r,c: integer; mve: boolean);
	label _raus;

	var rbis,cbis,
	    x,y,yend,
	    yinc,xsc,
	    errcode,
	    xstart,
	    xend,xinc,
	    cmin,cmax,
	    cminf,cmaxf,
	    rmin,rmax,
	    rrel,crel  : integer;
	    q,w,
	    cellinc    : longint;
	    cell,fcell : PCell;
	    lossy,
	    vorh,mvrnd : boolean;
	    oldsel     : byte;
	    ptxt,vars  : string;
	    pp         : PParameter;

	function CopyTree(nFrom: PNode; var nTo: PNode): boolean;
		label _fertig;
		
		var q: longint;

		begin
			nTo:=nil;
			if nFrom=nil then goto _fertig;
			CopyTree:=false;
			if nFrom^.Typ>=5000 then
				begin
					if not(NewNode(nTo)) then exit;
					nTo^.Typ:=nFrom^.Typ;
					if nFrom^.Left.List=nil then exit;
					nTo^.Count:=nFrom^.Count;
					getmem(nTo^.Left.List,nTo^.Count shl 2);
					if nTo^.Left.List=nil then exit;
					fillchar(nTo^.Left.List^,nTo^.Count shl 2,0);
					for q:=0 to nFrom^.Count-1 do
						if nFrom^.Left.List^[q]<>nil then
							if not(CopyTree(PNode(nFrom^.Left.List^[q]),PNode(nTo^.Left.List^[q]))) then exit;
				end
			else
				if nFrom^.Typ>=1000 then
					begin
						if not(NewNode(nTo)) then exit;
						nTo^.Typ:=nFrom^.Typ;
						if not(CopyTree(nFrom^.Left.Node,nTo^.Left.Node)) then exit;
						if not(CopyTree(nFrom^.Right.Node,nTo^.Right.Node)) then exit;
					end
				else
					begin
						if not(NewNode(nTo)) then exit;
						case nFrom^.Typ of
						NT_CONST:
							begin
								nTo^.Typ:=NT_CONST;
								if nFrom^.Num=nil then exit;
								new(nTo^.Num);
								if nTo^.Num=nil then exit;
								nTo^.Num^:=nFrom^.Num^;
								if nFrom^.Left.Txt<>nil then nTo^.Left.Txt:=NewStr(nFrom^.Left.Txt^);
							end;
						NT_CELL:
							begin
								nTo^.Typ:=NT_CELL;
								nTo^.ColRef:=nFrom^.ColRef;
								nTo^.RowRef:=nFrom^.RowRef;
								nTo^.Right.Flg:=nFrom^.Right.Flg
							end;
						NT_RANGE:
							begin
								nTo^.Typ:=NT_RANGE;
								nTo^.Left.ColRef:=nFrom^.Left.ColRef;
								nTo^.Left.RowRef:=nFrom^.Left.RowRef;
								nTo^.Right.ColRef:=nFrom^.Right.ColRef;
								nTo^.Right.RowRef:=nFrom^.Right.RowRef;
								nTo^.Ref1Flg:=nFrom^.Ref1Flg;
								nTo^.Ref2Flg:=nFrom^.Ref2Flg
							end;
						NT_VARIABLE:
							begin
								nTo^.Typ:=NT_VARIABLE;
								if nFrom^.Varb=nil then exit;
								nTo^.Varb:=NewStr(nFrom^.Varb^);
								if nTo^.Varb=nil then exit;
							end;
						NT_STRING:
							begin
								nTo^.Typ:=NT_STRING;
								nTo^.Chars:=ChrNew(StrPPas(nFrom^.Chars))
							end;
						NT_PERCENT,
						NT_NAT_NEGATE,
						NT_NEGATE,
						NT_KLAMMER:
							begin
								nTo^.Typ:=nFrom^.Typ;
								if not(CopyTree(nFrom^.Left.Node,nTo^.Left.Node)) then exit;
							end;
						NT_POWER,
						NT_EQUAL,
						NT_GREATER,
						NT_LESS,
						NT_GREATEREQUAL,
						NT_LESSEQUAL,
						NT_UNEQUAL,
						NT_MINUS,
						NT_MULT,
						NT_DIV,
						NT_NAT_PLUS,
						NT_NAT_MINUS,
						NT_NAT_MULT,
						NT_NAT_DIV,
						NT_NAT_POWER,
						NT_PLUS:
							begin
								nTo^.Typ:=nFrom^.Typ;
								if not(CopyTree(nFrom^.Left.Node,nTo^.Left.Node)) then exit;
								if not(CopyTree(nFrom^.Right.Node,nTo^.Right.Node)) then exit
							end;
						else
							exit
						end
					end;
			_fertig:
			CopyTree:=true
		end;

	begin
		BusyMouse;
		mvrnd:=false;
		rbis:=r+re-rs;
		cbis:=c+ce-cs;
		lossy:=false;
		if rbis>Parms.Rows then
			begin
				rbis:=Parms.Rows;
				re:=rs+rbis-r;
				lossy:=true
			end;
		if cbis>Parms.Columns then
			begin
				cbis:=Parms.Columns;
				ce:=cs+cbis-c;
				lossy:=true
			end;
		if lossy then
			begin
				if mve then
					begin
						if Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_DDMOVE,BUTTON_GOCANCEL)<>1 then goto _raus
					end
				else
					begin
						if Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_DDCOPY,BUTTON_GOCANCEL)<>1 then goto _raus
					end
			end;
		if IsBlockUsed(r,c,rbis,cbis,1) then goto _raus;
		rrel:=r-rs;
		crel:=c-cs;
		if from=@self then
			begin
				if r>rs then
					begin
						y:=re;
						yend:=rs-1;
						yinc:=-1
					end
				else
					begin
						y:=rs;
						yend:=re+1;
						yinc:=1
					end;
				if c>cs then
					begin
						xstart:=ce;
						xsc:=cbis;
						xend:=cs-1;
						xinc:=-1;
						cellinc:=-CELLSIZE
					end
				else
					begin
						xstart:=cs;
						xsc:=c;
						xend:=ce+1;
						xinc:=1;
						cellinc:=CELLSIZE
					end;
				cmin:=Min(cs,c);
				cmax:=Max(ce,cbis);
				rmin:=Min(rs,r);
				rmax:=Max(re,rbis);
				RowsClearOverflow(rmin,rmax,cmin,cmax)
			end
		else
			begin
				y:=rs;
				yend:=re+1;
				yinc:=1;
				xstart:=cs;
				xsc:=c;
				xend:=ce+1;
				xinc:=1;
				cellinc:=CELLSIZE;
				cmin:=c;
				cmax:=cbis;
				RowsClearOverflow(r,rbis,cmin,cmax);
				if mve then
					begin
						cminf:=cs;
						cmaxf:=ce;
						from^.RowsClearOverflow(rs,re,cminf,cmaxf)
					end
			end;
		repeat
			fcell:=from^.GetCell(y,xstart);
			cell:=GetCell(r+y-rs,xsc);
			x:=xstart;
			repeat
				oldsel:=cell^.Flags and CELL_SELECTED;
				FreeCell(cell,false);
				cell^:=fcell^;
				cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
				cell^.TxtVal.Flags:=cell^.TxtVal.Flags and not(TFL_OVERFLOWMASK);
				cell^.Data.Value:=0;
				case cell^.Typ of
				CTYPE_TEXT:
					cell^.Data.Txt:=NewStr(fcell^.Data.Txt^);
				CTYPE_CONST:
					begin
						new(cell^.Data.Konst);
						if cell^.Data.Konst<>nil then
							with cell^.Data.Konst^ do
								begin
									Value:=fcell^.Data.Konst^.Value;
									FPts:=fcell^.Data.Konst^.FPts;
									Txt:=NewStr(fcell^.Data.Konst^.Txt^)
								end
						else
							cell^.Typ:=CTYPE_EMPTY
					end;
				CTYPE_FORMULA:
					begin
						new(cell^.Data.Formula);
						if cell^.Data.Formula<>nil then
							with cell^.Data.Formula^ do
								begin
									Value:=fcell^.Data.Formula^.Value;
									FPts:=fcell^.Data.Formula^.FPts;
									VarDef:=nil;
									Error:=FE_OK;
									vorh:=false;
									if fcell^.Data.Formula^.VarDef<>nil then
										if Variables<>nil then
											if Variables^.Count>0 then
												begin
													ptxt:=StrPUpper(fcell^.Data.Formula^.VarDef^);
													for q:=0 to Variables^.Count-1 do
														if ptxt=StrPUpper(PVariable(Variables^.At(q))^.Name^) then
															begin
																vorh:=true;
																break
															end
												end;
									if not(CopyTree(fcell^.Data.Formula^.Func,Func)) then
										begin
											dispose(cell^.Data.Formula);
											ptxt:='='+from^.BuildTree(fcell,fcell^.Data.Formula^.Func,true,rrel,crel);
											if not(vorh) then
												if fcell^.Data.Formula^.VarDef<>nil then ptxt:='='+fcell^.Data.Formula^.VarDef^+ptxt;
											cell^.Typ:=CTYPE_TEXT;
											cell^.Data.Txt:=NewStr(ptxt)
										end
									else
										if fcell^.Data.Formula^.VarDef<>nil then
											if not(vorh) then
												begin
													vars:=fcell^.Data.Formula^.VarDef^;
													VarDef:=NewStr(vars);
													if VarDef<>nil then NewVariable(r+y-rs,xsc+x-xstart,vars)
												end;
								end
						else
							cell^.Typ:=CTYPE_EMPTY
					end
				end;
				if mve then
					if not(from^.IsEmptyCell(fcell)) then
						begin
							from^.FreeCell(fcell,true);
							mvrnd:=true
						end;
				if cell^.Format>=1000 then
					if from<>@self then
						begin
							w:=0;
							if UsrFormats^.Count>0 then
								begin
									ptxt:=PFormat(from^.UsrFormats^.At(cell^.Format-1000))^.Name^;
									for q:=0 to UsrFormats^.Count-1 do
										if PFormat(UsrFormats^.At(q))^.Name^=ptxt then
											begin
												w:=PFormat(UsrFormats^.At(q))^.Index;
												break
											end
								end;
							if w=0 then w:=NewNumFormat(ptxt);
							cell^.Format:=w
						end;
				inc(longint(fcell),cellinc);
				inc(longint(cell),cellinc);
				inc(x,xinc)
			until(x=xend);
			inc(y,yinc)
		until y=yend;
		if from<>@self then
			if from^.Parameter^.Count>0 then
				begin
					for w:=0 to from^.Parameter^.Count-1 do
						begin
							ptxt:=StrPUpper(PParameter(from^.Parameter^.At(w))^.Name^);
							vorh:=false;
							if Parameter^.Count>0 then
								for q:=0 to Parameter^.Count-1 do
									if StrPUpper(PParameter(Parameter^.At(q))^.Name^)=ptxt then
										begin
											vorh:=true;
											break
										end;
							if not(vorh) then
								begin
									new(pp);
									if pp<>nil then
										begin
											pp^.Value:=PParameter(from^.Parameter^.At(w))^.Value;
											pp^.Name:=NewStr(PParameter(from^.Parameter^.At(w))^.Name^);
											pp^.ListName:=NewStr('  '+pp^.Name^+' '#0);
											pp^.Txt:=NewStr(PParameter(from^.Parameter^.At(w))^.Txt^);
											pp^.Descr:=NewStr(PParameter(from^.Parameter^.At(w))^.Descr^);
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
												Parameter^.Insert(pp)
										end
								end
						end;
					{$IFNDEF LITE}
					if konstanten<>nil then PKonst(konstanten)^.UpdateList(true);
					{$ENDIF}
				end;
		if from=@self then
			begin
				RowsCheckOverflow(rmin,rmax,cmin,cmax);
				SetDirty;
				DrawCells(rmin,cmin,rmax,cmax);
				AutoCalculate(true)
			end
		else
			begin
				RowsCheckOverflow(r,rbis,cmin,cmax);
				if mve then from^.RowsCheckOverflow(rs,re,cminf,cmaxf);
				SetDirty;
				DrawCells(r,cmin,rbis,cmax);
				AutoCalculate(true);
				if mvrnd then
					begin
						from^.SetDirty;
						from^.DrawCells(rs,cminf,re,cmaxf);
						from^.AutoCalculate(true)
					end
			end;
		_raus:
		ArrowMouse
	end;


function TCalcWindow.DoRubbox(mX,mY,KStat: integer): boolean;
	var r,c: integer;

	begin
		Mouse2Cell(mX,mY,r,c);
		with Parms.Cursor do
			if (Block and Between(r,RowStart,RowEnd) and Between(c,ColStart,ColEnd)) or (not(Block) and (r=Row) and (c=Col) and ((Kbshift(-1) and (K_SHIFT or K_CTRL))>0)) then DoRubbox:=false
			else
				if (Kbshift(-1) and (K_SHIFT or K_CTRL))>0 then
					begin
						SetCursorPos(r,c,true);
						DoRubbox:=false
					end
				else
					DoRubbox:=not(bTst(Kbshift(-1),K_ALT)) and ((TexelApp.setupbuffer.online=bf_Unchecked) or inpstat)
	end;


procedure TCalcWindow.WMDblClick(mX,mY,KStat: integer);
	var r,c: integer;
	    pe : PEmbedded;

	begin
		if FindObject(mX,mY,true)>$7fff then
			begin
				if Embedded<>nil then
					if sheetbuffer.images=bf_Checked then
						begin
							pe:=Embedded;
							while pe^.Next<>nil do pe:=pe^.Next;
							while pe<>nil do
								begin
									if pe^.IsInside(mX,mY) then
										begin
											pe^.DblClick(mX,mY,KStat);
											exit
										end;
									pe:=pe^.Prev
								end
						end;
				Mouse2Cell(mX,mY,r,c);
				SetCursorPos(r,c,true);
				Application^.ReleaseMouseButton(1);
				if inpline<>nil then
					if not(inpstat) then EnableInpline
			end
	end;


function TCalcWindow.FindObject(x,y: integer; sizer: boolean): longint;
	var lcoffs,lroffs,
	    xl,yl,dummy,
	    range        : longint;
	    cnum,rnum    : integer;
	    r            : LGRECT;

	begin
		FindObject:=OBJ_NONE;
		dec(x,Work.X);
		dec(y,Work.Y+PaintOffs);
		
		{ Offsets berechnen... }
		
		if y<=TopRowHeight then
			begin
				if x<=LeftColWidth then
					begin
						FindObject:=OBJ_TOGGLEALL;
						exit
					end;
				xl:=x+Scroller^.XPos+1-LeftColWidth;
				lcoffs:=0;
				cnum:=0;
				while (lcoffs<xl) and (cnum<=Parms.Columns) do
					begin
						inc(lcoffs,GetColWidth(cnum));
						inc(cnum)
					end;
				if sizer then
					begin
						Cell2Rect(0,cnum-1,r);
						range:=atol(TexelApp.setupbuffer.sizerrange);
						if cnum>1 then
							begin
								dummy:=longint(x)+longint(Work.X)+1-r.X;
								if (dummy>=0) and (dummy<=range) then
									begin
										FindObject:=OBJ_CSIZEOFFSET+2-cnum;
										exit
									end
							end;
						dummy:=r.X2+1-longint(x)-longint(Work.X);
						if (dummy>=0) and (dummy<=range) then
							begin
								FindObject:=OBJ_CSIZEOFFSET+1-cnum;
								exit
							end
					end;
				FindObject:=OBJ_COLOFFSET+1-cnum
			end
		else
			if x<=LeftColWidth then
				begin
					yl:=y+Scroller^.YPos+1-TopRowHeight;
					lroffs:=0;
					rnum:=0;
					while (lroffs<yl) and (rnum<=Parms.Rows) do
						begin
							inc(lroffs,GetRowHeight(rnum));
							inc(rnum)
						end;
					if sizer then
						begin
							Cell2Rect(rnum-1,0,r);
							range:=atol(TexelApp.setupbuffer.sizerrange);
							if rnum>1 then
								begin
									dummy:=longint(y)+longint(Work.Y)+longint(PaintOffs)+1-r.Y;
									if (dummy>=0) and (dummy<=range) then
										begin
											FindObject:=OBJ_RSIZEOFFSET+2-rnum;
											exit
										end
								end;
							dummy:=r.Y2+1-longint(y)-longint(Work.Y)-longint(PaintOffs);
							if (dummy>=0) and (dummy<=range) then
								begin
									FindObject:=OBJ_RSIZEOFFSET+1-rnum;
									exit
								end
						end;
					FindObject:=OBJ_ROWOFFSET+1-rnum
				end
			else
				begin
					xl:=x+Scroller^.XPos+1-LeftColWidth;
					lcoffs:=0;
					cnum:=0;
					while (lcoffs<xl) and (cnum<=Parms.Columns) do
						begin
							inc(lcoffs,GetColWidth(cnum));
							inc(cnum)
						end;
					dec(cnum);
					yl:=y+Scroller^.YPos+1-TopRowHeight;
					lroffs:=0;
					rnum:=0;
					while (lroffs<yl) and (rnum<=Parms.Rows) do
						begin
							inc(lroffs,GetRowHeight(rnum));
							inc(rnum)
						end;
					dec(rnum);
					FindObject:=longint(Sheet)+(longint(rnum)*longint(Parms.Columns+1)+longint(cnum))*CELLSIZE;
				end
	end;


procedure TCalcWindow.SelectAll;
	var q,cnum: longint;

	begin
		with Parms.Cursor do
			if Block then
				if (RowStart=0) and (ColStart=0) and (RowEnd=Parms.Rows) and (ColEnd=Parms.Columns) then exit;
		DrawCursor;
		with Parms.Cursor do
			begin
				Block:=true;
				RowStart:=0;
				ColStart:=0;
				RowEnd:=Parms.Rows;
				ColEnd:=Parms.Columns
			end;
		SetBlock;
		cnum:=longint(Sheet);
		for q:=1 to longint(Parms.Rows+1)*longint(Parms.Columns+1) do
			begin
				with PCell(cnum)^ do Flags:=Flags or CELL_SELECTED;
				inc(cnum,CELLSIZE)
			end;
		DrawCursor
	end;


function TCalcWindow.GetCell(r,c: integer): PCell;

	begin
		GetCell:=PCell(longint(Sheet)+(longint(r)*longint(Parms.Columns+1)+longint(c))*CELLSIZE)
	end;


procedure TCalcWindow.Cell2RC(cell: PCell; var r,c: integer);
	var q: longint;

	begin
		if cell=nil then
			begin
				r:=0;
				c:=0
			end
		else
			begin
				q:=(longint(cell)-longint(Sheet)) div CELLSIZE;
				r:=q div (Parms.Columns+1);
				c:=q mod (Parms.Columns+1)
			end
	end;


procedure TCalcWindow.Cell2Rect(r,c: integer; var rect: LGRECT);
	var xoffs,yoffs: longint;
	    q          : integer;

	begin
		xoffs:=LeftColWidth+Work.X-Scroller^.XPos;
		if c>0 then
			for q:=0 to c-1 do inc(xoffs,GetColWidth(q));
		yoffs:=PaintOffs+TopRowHeight+Work.Y+1-Scroller^.YPos;
		if r>0 then
			for q:=0 to r-1 do inc(yoffs,GetRowHeight(q));
		with rect do
			begin
				X:=xoffs;
				Y:=yoffs;
				W:=GetColWidth(c)-1;
				H:=GetRowHeight(r)-1
			end;
		LGRtoA2(rect)
	end;


procedure TCalcWindow.GetSheetRect(var sr: GRECT);

	begin
		sr:=Work;
		with sr do
			begin
				inc(X,LeftColWidth+1);
				dec(W,LeftColWidth+1);
				inc(Y,PaintOffs+TopRowHeight+1);
				dec(H,PaintOffs+TopRowHeight+1)
			end;
		GRtoA2(sr)
	end;


procedure TCalcWindow.Cell2VRect(r,c: integer; var vrect: GRECT);
	var rect: LGRECT;

	begin
		Cell2Rect(r,c,rect);
		GetSheetRect(vrect);
		if not(lrc_intersect(rect,vrect)) then
			with vrect do
				begin
					X:=Application^.Attr.MaxPX+10;
					Y:=0;
					W:=1;
					H:=1
				end;
		GRtoA2(vrect)
	end;


function TCalcWindow.GetBlock(blck: string; whole: boolean; var rs,cs,re,ce,f1,f2: integer): boolean;
	var c,flg1,flg2: integer;

	function cellcorrect(cl: string; nr: integer; var r,c,flg: integer): boolean;
		var q,w,qs,ws: integer;

		begin
			cellcorrect:=false;
			StrPTrim(cl);
			if length(cl)=0 then exit;
			if (cl[1]='$') and whole then
				begin
					flg:=RF_COLABS;
					qs:=2
				end
			else
				begin
					flg:=0;
					qs:=1
				end;
			q:=qs;
			while (cl[q] in ['A'..'Z']) and (q<=length(cl)) do inc(q);
			if q=qs then
				if whole then exit;
			ws:=q;
			if ws<=length(cl) then
				if cl[ws]='$' then
					if whole then
						begin
							inc(ws);
							flg:=flg or RF_ROWABS
						end;
			w:=ws;
			while (cl[w] in ['0'..'9']) and (w<=length(cl)) do inc(w);
			if w=ws then
				if whole or (w=qs) then exit;
			if w=length(cl)+1 then
				begin
					if q>qs then
						begin
							c:=ColIndex2Nr(StrPRight(cl,length(cl)+1-qs),true);
							if nr=0 then ce:=c
						end
					else
						case nr of
						0:
							begin
								c:=0;
								ce:=Parms.Columns
							end;
						1:
							c:=0;
						2:
							c:=Parms.Columns
						end;
					if w>ws then
						begin
							r:=Min(Max(atol(StrPRight(cl,length(cl)+1-ws))-1,0),Parms.Rows);
							if nr=0 then re:=r
						end
					else
						case nr of
						0:
							begin
								r:=0;
								re:=Parms.Rows
							end;
						1:
							r:=0;
						2:
							r:=Parms.Rows
						end;
					cellcorrect:=true
				end
		end;

	begin
		GetBlock:=false;
		f1:=0;
		f2:=0;
		blck:=StrPUpper(blck);
		c:=pos(':',blck);
		if c>0 then
			begin
				flg1:=0;
				if not(cellcorrect(StrPLeft(blck,c-1),1,rs,cs,flg1)) then exit;
				flg2:=0;
				if cellcorrect(StrPRight(blck,length(blck)-c),2,re,ce,flg2) then
					begin
						GetBlock:=true;
						if re<rs then
							begin
								c:=re;
								re:=rs;
								rs:=c;
								if bTst(flg2,RF_ROWABS) then f1:=f1 or RF_ROWABS;
								if bTst(flg1,RF_ROWABS) then f2:=f2 or RF_ROWABS
							end
						else
							begin
								if bTst(flg1,RF_ROWABS) then f1:=f1 or RF_ROWABS;
								if bTst(flg2,RF_ROWABS) then f2:=f2 or RF_ROWABS
							end;
						if ce<cs then
							begin
								c:=ce;
								ce:=cs;
								cs:=c;
								if bTst(flg2,RF_COLABS) then f1:=f1 or RF_COLABS;
								if bTst(flg1,RF_COLABS) then f2:=f2 or RF_COLABS
							end
						else
							begin
								if bTst(flg1,RF_COLABS) then f1:=f1 or RF_COLABS;
								if bTst(flg2,RF_COLABS) then f2:=f2 or RF_COLABS
							end
					end
			end
		else
			if not(whole) then
				if cellcorrect(blck,0,rs,cs,f1) then GetBlock:=true
	end;


function TCalcWindow.GetVisibleBlockRect(rs,cs,re,ce: integer; var sr: GRECT): boolean;
	var crs,crs2,r: LGRECT;

	begin
		Cell2Rect(rs,cs,crs);
		Cell2Rect(re,ce,crs2);
		GetSheetRect(sr);
		r.X:=crs.X;
		r.Y:=crs.Y;
		r.W:=crs2.X2+2-r.X;
		r.H:=crs2.Y2+2-r.Y;
		GetVisibleBlockRect:=lrc_intersect(r,sr)
	end;


procedure TCalcWindow.DrawCells(rs,cs,re,ce: integer);
	var sr: GRECT;

	begin
		wind_update(BEG_UPDATE);
		if GetVisibleBlockRect(rs,cs,re,ce,sr) then WMRedraw(sr.X-1,sr.Y-1,sr.W+2,sr.H+2);
		wind_update(END_UPDATE)
	end;


procedure TCalcWindow.DrawBlockRaw(rs,cs,re,ce: integer; const r: GRECT);
	var crs,crs2,crs3: LGRECT;
	    r2           : GRECT;
	    x,y          : integer;

	begin
		vswr_mode(vdiHandle,MD_XOR);
		vsf_interior(vdiHandle,FIS_SOLID);
		Cell2Rect(rs,cs,crs);
		for y:=rs to re do
			begin
				crs.H:=GetRowHeight(y)-1;
				crs2:=crs;
				crs2.X:=r.X;
				crs2.W:=r.W;
				r2:=r;
				if lrc_intersect(crs2,r2) then
					begin
						crs2:=crs;
						for x:=cs to ce do
							begin
								crs2.W:=GetColWidth(x)-1;
								crs3:=crs2;
								r2:=r;
								if lrc_intersect(crs3,r2) then vr_recfl(vdiHandle,r2.A2);
								inc(crs2.X,crs2.W+1)
							end
					end;
				inc(crs.Y,crs.H+1)
			end;
		vsf_interior(vdiHandle,FIS_HOLLOW);
		vswr_mode(vdiHandle,MD_REPLACE)
	end;


procedure TCalcWindow.DrawBlock(rs,cs,re,ce: integer);
	var valid        : boolean;
	    r,r2,sr      : GRECT;
	    crs,crs2,crs3: LGRECT;
	    x,y          : integer;

	begin
		wind_update(BEG_UPDATE);
		HideMouse;
		vswr_mode(vdiHandle,MD_XOR);
		vsf_interior(vdiHandle,FIS_SOLID);
		GetSheetRect(sr);
		valid:=FirstWorkRect(r);
		while valid do
			begin
				if rc_intersect(sr,r) then
					begin
						Cell2Rect(rs,cs,crs);
						for y:=rs to re do
							begin
								crs.H:=GetRowHeight(y)-1;
								crs2:=crs;
								crs2.X:=r.X;
								crs2.W:=r.W;
								r2:=r;
								if lrc_intersect(crs2,r2) then
									begin
										crs2:=crs;
										for x:=cs to ce do
											begin
												crs2.W:=GetColWidth(x)-1;
												crs3:=crs2;
												r2:=r;
												if lrc_intersect(crs3,r2) then vr_recfl(vdiHandle,r2.A2);
												inc(crs2.X,crs2.W+1)
											end
									end;
								inc(crs.Y,crs.H+1)
							end
					end;
				valid:=NextWorkRect(r)
			end;
		vsf_interior(vdiHandle,FIS_HOLLOW);
		vswr_mode(vdiHandle,MD_REPLACE);
		ShowMouse;
		wind_update(END_UPDATE)
	end;


procedure TCalcWindow.DrawCursor;
	var valid: boolean;
	    r,crs: GRECT;

	begin
		if Parms.Cursor.Block then with Parms.Cursor do DrawBlock(RowStart,ColStart,RowEnd,ColEnd)
		else
			begin
				wind_update(BEG_UPDATE);
				HideMouse;
				vswr_mode(vdiHandle,MD_XOR);
				vsf_interior(vdiHandle,FIS_SOLID);
				Cell2VRect(Parms.Cursor.Row,Parms.Cursor.Col,crs);
				valid:=FirstWorkRect(r);
				while valid do
					begin
						if rc_intersect(crs,r) then vr_recfl(vdiHandle,r.A2);
						valid:=NextWorkRect(r)
					end;
				vsf_interior(vdiHandle,FIS_HOLLOW);
				vswr_mode(vdiHandle,MD_REPLACE);
				ShowMouse;
				wind_update(END_UPDATE)
			end
	end;


procedure TCalcWindow.EnableInpline;

	begin
		DeselectAllObjects;
		inpline^.Enable;
		if inpcancel<>nil then inpcancel^.Unhide;
		if inpok<>nil then inpok^.Unhide;
		inpstat:=true
	end;


procedure TCalcWindow.CancelInpline;

	begin
		{ bei Online-Eingabe: alten String wieder eintragen !!! }
		if inpcancel<>nil then inpcancel^.Hide(true);
		if inpok<>nil then inpok^.Hide(true);
		inpline^.Disable;
		SetInpline(GetCell(Parms.Cursor.Row,Parms.Cursor.Col));
		inpstat:=false;
		with Parms.Cursor do DrawCells(Row,Col,Row,Col)
	end;


function TCalcWindow.GetOutputLine(cell: PCell): string;

	begin
		if cell^.Typ<>CTYPE_TEXT then GetOutputLine:=''
		else
			case (cell^.TxtVal.Align and $0f) of
			TA_CENTER:
				GetOutputLine:='^'+cell^.Data.Txt^;
			TA_RIGHT:
				GetOutputLine:='"'+cell^.Data.Txt^
			else
				GetOutputLine:=''''+cell^.Data.Txt^
			end;
	end;


procedure TCalcWindow.SetInpline(cell: PCell);
	var txt: string;

	procedure settxt(s: string);
		var q: integer;
	
		begin
			q:=length(s);
			if q<=54 { ... } then inpline^.SetCursor(q)
			else
				inpline^.SetCursor(0);
			inpline^.SetText(s)
		end;

	begin
		if inpline=nil then exit;
		if cell=nil then
			begin
				if length(inpline^.GetText)>0 then
					begin
						inpline^.SetCursor(0);
						inpline^.Clear
					end;
				exit
			end;
		if cell^.Data.Value=0 then
			begin
				if length(inpline^.GetText)>0 then
					begin
						inpline^.SetCursor(0);
						inpline^.Clear
					end;
				exit
			end;
		case cell^.Typ of
		CTYPE_TEXT:
			begin
				txt:=GetOutputLine(cell);
				if inpline^.GetText<>txt then settxt(txt)
			end;
		CTYPE_CONST:
			begin
				if inpline^.GetText<>cell^.Data.Konst^.Txt^ then settxt(cell^.Data.Konst^.Txt^)
			end;
		CTYPE_FORMULA:
			begin
				txt:=BuildFunction(cell,true);
				if inpline^.GetText<>txt then settxt(txt)
			end
		else
			begin
				if length(inpline^.GetText)>0 then
					begin
						inpline^.SetCursor(0);
						inpline^.Clear
					end
			end
		end
	end;


procedure TCalcWindow.Calculate(clr: boolean);
	var cell  : PCell;
	    q,w   : integer;
	    pe    : PEmbeddedElement;

	begin
		if Sheet=nil then exit;
		BusyMouse;
		if clr then ClearCalcFlags;
		cell:=Sheet;
		for q:=0 to Parms.Rows do
			for w:=0 to Parms.Columns do
				begin
					if cell^.Typ=CTYPE_FORMULA then GetCellValue(cell,false);
					inc(longint(cell),CELLSIZE)
				end;
		pe:=Elements;
		while pe<>nil do
			begin
				pe^.CheckRef;
				pe:=pe^.elNext
			end;
		ArrowMouse
	end;


procedure TCalcWindow.AutoCalculate(clr: boolean);

	begin
		if sheetbuffer.autocalc=bf_Checked then Calculate(clr)
	end;


function TCalcWindow.NewNode(var p: PNode): boolean;

	begin
		new(p);
		if p<>nil then
			begin
				NewNode:=true;
				p^.Typ:=0;
				p^.Count:=0;
				p^.Left.Node:=nil;
				p^.Right.Node:=nil
			end
		else
			NewNode:=false
	end;


procedure TCalcWindow.DeleteNode(var p: PNode);
	var q: integer;

	begin
		if p=nil then exit;
		if p^.Typ<5000 then
			begin
				if p^.Typ>=10 then
					begin
						DeleteNode(p^.Right.Node);
						DeleteNode(p^.Left.Node)
					end
				else
					if p^.Typ=NT_CONST then
						begin
							dispose(p^.Num);
							DisposeStr(p^.Left.Txt)
						end
					else
						if p^.Typ=NT_VARIABLE then DisposeStr(p^.Varb)
						else
							if p^.Typ=NT_STRING then ChrDispose(p^.Chars)
			end
		else
			if p^.Left.List<>nil then
				begin
					for q:=0 to p^.Count-1 do DeleteNode(PNode(p^.Left.List^[q]));
					freemem(p^.Left.List,p^.Count shl 2)
				end;
		dispose(p);
		p:=nil
	end;


procedure TCalcWindow.TranslateCells(rs,cs,re,ce,rdif,cdif: integer; clr: boolean);
	var x,y     : integer;
	    cell    : PCell;
	    q       : longint;
	    inside,
	    inside2,
	    xyinside: boolean;

	function RefInBlock(r,c,flg: integer): boolean;

		begin
			if not(bTst(flg,RF_COLABS)) then
				begin
					inc(c,x);
					if xyinside then dec(c,cdif)
				end;
			if not(bTst(flg,RF_ROWABS)) then
				begin
					inc(r,y);
					if xyinside then dec(r,rdif)
				end;
			RefInBlock:=Between(r,rs,re) and Between(c,cs,ce)
		end;

	procedure TranslateNode(p: PNode);
		var q: integer;

		begin
			if p=nil then exit;
			if p^.Typ<5000 then
				begin
					if p^.Typ>=10 then
						begin
							TranslateNode(p^.Right.Node);
							TranslateNode(p^.Left.Node)
						end
					else
						if p^.Typ=NT_CELL then
							begin
								inside:=RefInBlock(p^.RowRef,p^.ColRef,p^.Right.Flg);
								if bTst(p^.Right.Flg,RF_COLABS) then
									begin
										if inside then inc(p^.ColRef,cdif)
									end
								else
									if xyinside then
										begin
											if not(inside) then dec(p^.ColRef,cdif)
										end
									else
										if inside then inc(p^.ColRef,cdif);
								if bTst(p^.Right.Flg,RF_ROWABS) then
									begin
										if inside then inc(p^.RowRef,rdif)
									end
								else
									if xyinside then
										begin
											if not(inside) then dec(p^.RowRef,rdif)
										end
									else
										if inside then inc(p^.RowRef,rdif)
							end
						else
							if p^.Typ=NT_RANGE then
								begin
									inside:=RefInBlock(p^.Left.RowRef,p^.Left.ColRef,p^.Ref1Flg);
									inside2:=RefInBlock(p^.Right.RowRef,p^.Right.ColRef,p^.Ref2Flg);
									if bTst(p^.Ref1Flg,RF_COLABS) then
										begin
											if inside then inc(p^.Left.ColRef,cdif)
										end
									else
										if xyinside then
											begin
												if not(inside) then dec(p^.Left.ColRef,cdif)
											end
										else
											if inside then inc(p^.Left.ColRef,cdif);
									if bTst(p^.Ref1Flg,RF_ROWABS) then
										begin
											if inside then inc(p^.Left.RowRef,rdif)
										end
									else
										if xyinside then
											begin
												if not(inside) then dec(p^.Left.RowRef,rdif)
											end
										else
											if inside then inc(p^.Left.RowRef,rdif);
									if bTst(p^.Ref2Flg,RF_COLABS) then
										begin
											if inside2 then inc(p^.Right.ColRef,cdif)
										end
									else
										if xyinside then
											begin
												if not(inside2) then dec(p^.Right.ColRef,cdif)
											end
										else
											if inside2 then inc(p^.Right.ColRef,cdif);
									if bTst(p^.Ref2Flg,RF_ROWABS) then
										begin
											if inside2 then inc(p^.Right.RowRef,rdif)
										end
									else
									if xyinside then
										begin
											if not(inside2) then dec(p^.Right.RowRef,rdif)
										end
									else
										if inside2 then inc(p^.Right.RowRef,rdif)
								end
				end
			else
				if p^.Left.List<>nil then
					for q:=0 to p^.Count-1 do TranslateNode(PNode(p^.Left.List^[q]))
		end;

	begin
		if Variables<>nil then
			if Variables^.Count>0 then
				for q:=0 to Variables^.Count-1 do
					with PVariable(Variables^.At(q))^ do
						if Between(RefRow,rs,re) then
							if Between(RefCol,cs,ce) then
								begin
									inc(RefRow,rdif);
									inc(RefCol,cdif)
								end;
		for y:=0 to Parms.Rows do
			begin
				cell:=GetCell(y,0);
				for x:=0 to Parms.Columns do
					begin
						if cell^.Typ=CTYPE_FORMULA then
							begin
								xyinside:=Between(x,cs,ce) and Between(y,rs,re);
								TranslateNode(cell^.Data.Formula^.Func)
							end;
						inc(longint(cell),CELLSIZE)
					end
			end
	end;


function TCalcWindow.BuildFunction(cell: PCell; fnames: boolean): string;
	var txt: string;

	begin
		txt:='='+BuildTree(cell,cell^.Data.Formula^.Func,fnames,0,0);
		if cell^.Data.Formula^.VarDef<>nil then txt:='='+cell^.Data.Formula^.VarDef^+txt;
		BuildFunction:=txt
	end;


function TCalcWindow.BuildTree(cell: PCell; p: PNode; fnames: boolean; rrel,crel: integer): string;

	function getfunc: string;
		var q: longint;

		begin
			if fnames then
				begin
					q:=TexelApp.Functions^.Count-1;
					while q>=0 do
						begin
							if PFunction(TexelApp.Functions^.At(q))^.Opcode=p^.Typ then
								begin
									getfunc:=PFunction(TexelApp.Functions^.At(q))^.Name^;
									exit
								end;
							dec(q)
						end;
					getfunc:=''
				end
			else
				getfunc:=#27+ltoa(p^.Typ)+#27
		end;

	function build5000: string;
		var txt: string;
		    q  : integer;

		begin
			build5000:='';
			if p^.Left.List=nil then exit;
			txt:='';
			for q:=0 to p^.Count-1 do
				if p^.Left.List^[q]<>nil then
					begin
						if length(txt)>0 then txt:=txt+ARGTRENNSEMIKOLON;
						txt:=txt+BuildTree(cell,PNode(p^.Left.List^[q]),fnames,rrel,crel)
					end;
			build5000:=txt
		end;

	function buildref(c,r: integer; flg: integer): string;
		var ar,ac: integer;

		begin
			if bTst(flg,RF_COLABS or RF_ROWABS) then buildref:='$'+GetColumnIndex(c)+'$'+GetRowIndex(r)
			else
				begin
					Cell2RC(cell,ar,ac);
					if (flg and (RF_COLABS or RF_ROWABS))=0 then buildref:=GetColumnIndex(ac+c+crel)+GetRowIndex(ar+r+rrel)
					else
						if bTst(flg,RF_COLABS) then buildref:='$'+GetColumnIndex(c)+GetRowIndex(ar+r+rrel)
						else
							buildref:=GetColumnIndex(ac+c+crel)+'$'+GetRowIndex(r)
				end
		end;
	
	function escapeChars(s: string): string;
		var i: integer;
	
		begin
			i:=1;
			while i<=length(s) do
				begin
					if s[i]='"' then
						begin
							s:=StrPLeft(s,i-1)+'\'+StrPRight(s,length(s)+1-i);
							inc(i)
						end
					else
						if s[i]='\' then
							begin
								s:=StrPLeft(s,i)+StrPRight(s,length(s)+1-i);
								inc(i)
							end;
					inc(i)
				end;
			escapeChars:=s
		end;

	begin
		BuildTree:='';
		if p=nil then exit;
		if p^.Typ>=5000 then BuildTree:=getfunc+'('+build5000+')'
		else
			begin
				if p^.Typ>=1000 then
					begin
						if p^.Right.Node<>nil then BuildTree:=getfunc+'('+BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+ARGTRENNSEMIKOLON+BuildTree(cell,p^.Right.Node,fnames,rrel,crel)+')'
						else
							if p^.Left.Node<>nil then BuildTree:=getfunc+'('+BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+')'
							else
								BuildTree:=getfunc
					end
				else
					case p^.Typ of
					NT_CONST:
						begin
							if p^.Left.Txt=nil then BuildTree:=Val2TxtF(p^.Num^,MAXCIPHERS,0,nil)
							else
								BuildTree:=p^.Left.Txt^;
						end;
					NT_CELL:
						BuildTree:=buildref(p^.ColRef,p^.RowRef,p^.Right.Flg);
					NT_RANGE:
						BuildTree:=buildref(p^.Left.ColRef,p^.Left.RowRef,p^.Ref1Flg)+':'+buildref(p^.Right.ColRef,p^.Right.RowRef,p^.Ref2Flg);
					NT_VARIABLE:
						BuildTree:=p^.Varb^;
					NT_STRING:
						BuildTree:='"'+escapeChars(StrPPas(p^.Chars))+'"';
					NT_KLAMMER:
						BuildTree:='('+BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+')';
{					NT_DEFINE:
						BuildTree:=BuildTree(cell,p^.Right.Node,fnames,rrel,crel); ... }
					NT_PLUS:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'+'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_NAT_PLUS:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+' '+OPS_NATURAL_PLUS+' '+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_MINUS:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'-'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_NAT_MINUS:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+' '+OPS_NATURAL_MINUS+' '+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_MULT:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'*'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_NAT_MULT:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+' '+OPS_NATURAL_MULT+' '+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_DIV:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'/'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_NAT_DIV:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+' '+OPS_NATURAL_DIV+' '+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_POWER:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'^'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_NAT_POWER:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+' '+OPS_NATURAL_POWER+' '+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_NEGATE:
						BuildTree:='-'+BuildTree(cell,p^.Left.Node,fnames,rrel,crel);
					NT_NAT_NEGATE:
						BuildTree:=' '+OPS_NATURAL_MINUS+' '+BuildTree(cell,p^.Left.Node,fnames,rrel,crel);
					NT_PERCENT:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'%';
					NT_EQUAL:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'='+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_GREATER:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'>'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_LESS:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'<'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_GREATEREQUAL:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'>='+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_LESSEQUAL:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'<='+BuildTree(cell,p^.Right.Node,fnames,rrel,crel);
					NT_UNEQUAL:
						BuildTree:=BuildTree(cell,p^.Left.Node,fnames,rrel,crel)+'<>'+BuildTree(cell,p^.Right.Node,fnames,rrel,crel)
					end
			end
	end;


procedure TCalcWindow.NewVariable(ar,ac: integer; const aName: string);
	var pv: PVariable;

	begin
		if length(aName)>0 then
			begin
				if Variables=nil then
					begin
						new(Variables,Init(20,10));
						if Variables<>nil then Variables^.CaseSensitive:=false
					end;
				if Variables<>nil then
					begin
						new(pv);
						if pv<>nil then
							begin
								pv^.Name:=NewStr(aName);
								if pv^.Name=nil then dispose(pv)
								else
									begin
										pv^.RefRow:=ar;
										pv^.RefCol:=ac;
										Variables^.Insert(pv)
									end
							end
					end
			end
	end;


function TCalcWindow.EvalNode(cell: PCell; knoten: PNode): TNumber;
	type pmarray = ^tmarray;
	     tmarray = array [0..maxint] of TNumber;

	var dummy,dummy2,
	    dummy3,dummy4: TNumber;
	    l1,l2,manz   : longint;
	    w,ar,ac,
	    xbis,xvon,
	    yvon,ybis    : integer;
	    node         : PNode;
	    marray       : pmarray;
	    pna          : PIntegerArray;

	function isint(dummy: TNumber): boolean;

		begin
			isint:=(int(dummy)=dummy) and (abs(dummy)<=2147483647.0)
		end;

	procedure getrc(flg,rowref,colref: integer);

		begin
			if bTst(flg,RF_ROWABS or RF_COLABS) then
				begin
					ar:=rowref;
					ac:=colref
				end
			else
				begin
					Cell2RC(cell,ar,ac);
					if (flg and (RF_ROWABS or RF_COLABS))=0 then
						begin
							inc(ar,rowref);
							inc(ac,colref)
						end
					else
						if bTst(flg,RF_ROWABS) then
							begin
								inc(ac,colref);
								ar:=RowRef
							end
						else
							begin
								inc(ar,rowref);
								ac:=ColRef
							end
				end
		end;

	function getrange(node: PNode): boolean;

		begin
			getrc(node^.Ref1Flg,node^.Left.RowRef,node^.Left.ColRef);
			xvon:=ac;
			yvon:=ar;
			getrc(node^.Ref2Flg,node^.Right.RowRef,node^.Right.ColRef);
			if ac<xvon then
				begin
					xbis:=xvon;
					xvon:=ac
				end
			else
				xbis:=ac;
			if ar<yvon then
				begin
					ybis:=yvon;
					yvon:=ar
				end
			else
				ybis:=ar;
			if (yvon<0) or (ybis>Parms.Rows) or (xvon<0) or (xbis>Parms.Columns) then
				begin
					EvalNode:=0.0;
					fnerror:=FE_CELLOUTOFRANGE;
					fnecell:=cell;
					getrange:=true
				end
			else
				getrange:=false
		end;

	function bund: TNumber;
		label _sraus;

		var x,y,q: integer;
		    ret  : longint;
		    zelle: PCell;

		begin
			q:=knoten^.Count;
			if q=0 then ret:=0
			else
				ret:=$ffffffff;
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=EvalNode(cell,node);
									if fnerror<>FE_OK then goto _sraus;
									if not(isint(dummy)) then
										begin
											bund:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell;
											exit
										end;
									ret:=ret and trunc(dummy)
								end
							else
								begin
									if getrange(node) then goto _sraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=Evaluate(zelle);
															if fnerror<>FE_OK then goto _sraus;
															if not(isint(dummy)) then
																begin
																	bund:=0.0;
																	fnerror:=FE_UNDEFINED;
																	fnecell:=cell;
																	exit
																end;
															ret:=ret and trunc(dummy)
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_sraus:
			bund:=ret
		end;

	function boder: TNumber;
		label _sraus;

		var x,y,q: integer;
		    ret  : longint;
		    zelle: PCell;

		begin
			q:=knoten^.Count;
			ret:=0;
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=EvalNode(cell,node);
									if fnerror<>FE_OK then goto _sraus;
									if not(isint(dummy)) then
										begin
											boder:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell;
											exit
										end;
									ret:=ret or trunc(dummy)
								end
							else
								begin
									if getrange(node) then goto _sraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													dummy:=Evaluate(zelle);
													if fnerror<>FE_OK then goto _sraus;
													if not(isint(dummy)) then
														begin
															boder:=0.0;
															fnerror:=FE_UNDEFINED;
															fnecell:=cell;
															exit
														end;
													ret:=ret or trunc(dummy);
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_sraus:
			boder:=ret
		end;

	function beor: TNumber;
		label _sraus;

		var x,y,q: integer;
		    ret  : longint;
		    zelle: PCell;

		begin
			q:=knoten^.Count;
			ret:=0;
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=EvalNode(cell,node);
									if fnerror<>FE_OK then goto _sraus;
									if not(isint(dummy)) then
										begin
											beor:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell;
											exit
										end;
									ret:=ret xor trunc(dummy)
								end
							else
								begin
									if getrange(node) then goto _sraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													dummy:=Evaluate(zelle);
													if fnerror<>FE_OK then goto _sraus;
													if not(isint(dummy)) then
														begin
															beor:=0.0;
															fnerror:=FE_UNDEFINED;
															fnecell:=cell;
															exit
														end;
													ret:=ret xor trunc(dummy);
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_sraus:
			beor:=ret
		end;

	function summe: TNumber;
		label _sraus;

		var x,y,q: integer;
		    zelle: PCell;

		begin
			dummy:=0.0;
			q:=knoten^.Count;
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then dummy:=dummy+EvalNode(cell,node)
							else
								begin
									if getrange(node) then goto _sraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													dummy:=dummy+Evaluate(zelle);
													if fnerror<>FE_OK then goto _sraus;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_sraus:
			summe:=dummy
		end;

	function produkt: TNumber;
		label _praus;

		var x,y,q: integer;
		    zelle: PCell;

		begin
			q:=knoten^.Count;
			if q=0 then dummy:=0.0
			else
				dummy:=1.0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then dummy:=dummy*EvalNode(cell,node)
							else
								begin
									if getrange(node) then goto _praus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy*Evaluate(zelle);
															if fnerror<>FE_OK then goto _praus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_praus:
			produkt:=dummy
		end;

	function oder: TNumber;
		var x,y,q: integer;
		    zelle: PCell;

		begin
			oder:=0.0;
			q:=knoten^.Count;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									if EvalNode(cell,node)<>0.0 then
										begin
											oder:=1.0;
											exit
										end
								end
							else
								begin
									if getrange(node) then exit;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if Evaluate(zelle)<>0.0 then
														begin
															oder:=1.0;
															exit
														end;
													if fnerror<>FE_OK then exit;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end
		end;

	function und: TNumber;
		var x,y,q: integer;
		    zelle: PCell;

		begin
			und:=1.0;
			q:=knoten^.Count;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									if EvalNode(cell,node)=0.0 then
										begin
											und:=0.0;
											exit
										end
								end
							else
								begin
									if getrange(node) then exit;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														if Evaluate(zelle)=0.0 then
															begin
																und:=0.0;
																exit
															end;
													if fnerror<>FE_OK then exit;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end
		end;

	function minimum: TNumber;
		label _mraus;

		var x,y,q: integer;
		    zelle: PCell;
		    neu  : boolean;

		begin
			dummy:=0.0;
			q:=knoten^.Count;
			neu:=true;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy2:=EvalNode(cell,node);
									if neu then
										begin
											dummy:=dummy2;
											neu:=false
										end
									else
										if dummy2<dummy then dummy:=dummy2
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy2:=Evaluate(zelle);
															if neu then
																begin
																	dummy:=dummy2;
																	neu:=false
																end
															else
																if dummy2<dummy then dummy:=dummy2;
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			minimum:=dummy
		end;

	function maximum: TNumber;
		label _mraus;

		var x,y,q: integer;
		    zelle: PCell;
		    neu  : boolean;

		begin
			dummy:=0.0;
			q:=knoten^.Count;
			neu:=true;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy2:=EvalNode(cell,node);
									if neu then
										begin
											dummy:=dummy2;
											neu:=false
										end
									else
										if dummy2>dummy then dummy:=dummy2
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy2:=Evaluate(zelle);
															if neu then
																begin
																	dummy:=dummy2;
																	neu:=false
																end
															else
																if dummy2>dummy then dummy:=dummy2;
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			maximum:=dummy
		end;

	function mdet(rs,breite: integer; pc: PIntegerArray): TNumber;
		label _raus;
		
		var zelle : PCell;
		    subret,
		    mulret,
		    ret   : TNumber;
		    x,q,w : integer;
		    pna   : PIntegerArray;

		begin
			if pc=nil then
				begin
					mdet:=0.0;
					fnerror:=FE_UNDEFINED;
					fnecell:=cell;
					exit
				end;
			if breite=0 then
				begin
					zelle:=GetCell(rs,pc^[0]);
					if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then mdet:=Evaluate(zelle)
					else
						begin
							mdet:=0.0;
							fnerror:=FE_UNDEFINED;
							fnecell:=cell
						end
				end
			else
				begin
					ret:=0.0;
					for x:=0 to breite do
						begin
							getmem(pna,breite shl 1);
							if pna<>nil then
								begin
									w:=0;
									for q:=0 to breite do
										if q<>x then
											begin
												pna^[w]:=pc^[q];
												inc(w)
											end
								end;
							subret:=mdet(rs+1,breite-1,pna);
							if fnerror<>FE_OK then
								begin
									ret:=0.0;
									goto _raus
								end;
							zelle:=GetCell(rs,pc^[x]);
							if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
								begin
									mulret:=Evaluate(zelle);
									if fnerror<>FE_OK then
										begin
											ret:=0.0;
											goto _raus
										end
								end
							else
								begin
									ret:=0.0;
									fnerror:=FE_UNDEFINED;
									fnecell:=cell;
									goto _raus
								end;
							if odd(x) then ret:=ret-mulret*subret
							else
								ret:=ret+mulret*subret
						end;
					_raus:
					mdet:=ret
				end;
			freemem(pc,(breite+1) shl 1)
		end;
	
	procedure freearray;

		begin
			if marray<>nil then
				begin
					freemem(marray,manz*sizeof(TNumber));
					marray:=nil;
					manz:=0
				end
		end;
	
	function getandsortarray(firstalpha: boolean): TNumber;
		var x,y,q,
		    anz,bis: integer;
		    zelle  : PCell;
		    sorted : boolean;

		begin
			getandsortarray:=0.0;
			manz:=0;
			marray:=nil;
			if firstalpha then bis:=1 else bis:=0;
			q:=knoten^.Count;
			Cell2RC(cell,ar,ac);
			while (q>bis) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then inc(manz)
							else
								begin
									if getrange(node) then exit;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then inc(manz);
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			if manz<=0 then exit;
			if firstalpha then
				begin
					node:=PNode(knoten^.Left.List^[0]);
					if node^.Typ=NT_RANGE then exit;
					getandsortarray:=EvalNode(cell,node)
				end;
			getmem(marray,manz*sizeof(TNumber));
			if marray=nil then exit;
			q:=knoten^.Count;
			Cell2RC(cell,ar,ac);
			anz:=0;
			while (q>bis) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									marray^[anz]:=EvalNode(cell,node);
									inc(anz)
								end
							else
								begin
									if getrange(node) then
										begin
											freearray;
											exit
										end;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															marray^[anz]:=Evaluate(zelle);
															inc(anz);
															if fnerror<>FE_OK then
																begin
																	freearray;
																	exit
																end
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			if manz>1 then
				repeat
					sorted:=true;
					for q:=0 to manz-2 do
						if marray^[q]>marray^[q+1] then
							begin
								dummy:=marray^[q];
								marray^[q]:=marray^[q+1];
								marray^[q+1]:=dummy;
								sorted:=false
							end
				until sorted
		end;

	function scriptno(oldval: TNumber; extnum: integer): TNumber;
		var q,qbis,
		    cx,cy : integer;
		    prm   : string;

		begin
			scriptno:=oldval;
			qbis:=knoten^.Count;
			prm:='';
			Cell2RC(cell,ar,ac);
			cx:=ac;
			cy:=ar;
			if extnum<NT_EXTMIN then
				begin
					node:=PNode(knoten^.Left.List^[0]);
					if node=nil then
						begin
							fnerror:=FE_UNDEFINED;
							fnecell:=cell;
							scriptno:=0.0;
							exit
						end;
					if node^.Typ=NT_RANGE then
						begin
							fnerror:=FE_UNDEFINED;
							fnecell:=cell;
							scriptno:=0.0;
							exit
						end;
					dummy:=EvalNode(cell,node);
					if fnerror<>FE_OK then
						begin
							scriptno:=0.0;
							exit
						end;
					if not(isint(dummy)) then
						begin
							fnerror:=FE_UNDEFINED;
							fnecell:=cell;
							scriptno:=0.0;
							exit
						end;
					q:=1
				end
			else
				begin
					dummy:=extnum-10000;
					q:=0
				end;
			while (q<qbis) and (fnerror=FE_OK) do
				begin
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								prm:=prm+' '+TexelApp.Num2Txt(EvalNode(cell,node),MAXCIPHERS,false,false)
							else
								begin
									if getrange(node) then
										begin
											scriptno:=0.0;
											exit
										end;
									prm:=prm+' '+GetColumnIndex(xvon)+GetRowIndex(yvon)+':'+GetColumnIndex(xbis)+GetRowIndex(ybis)
								end
						end;
					inc(q)
				end;
			if fnerror=FE_OK then
				if not(TexelApp.ScriptByNumber(trunc(dummy),GetWindowFileName,GetColumnIndex(cx)+GetRowIndex(cy),prm)) then
					begin
						fnerror:=FE_EXTERN;
						fnecell:=cell;
						scriptno:=0.0
					end
		end;
	
	function quantil(alpha: TNumber): TNumber;
		var k: longint;
	
		begin
			if (marray=nil) or (alpha<=0.0) or (alpha>=1.0) then
				begin
					quantil:=0.0;
					fnerror:=FE_UNDEFINED;
					fnecell:=cell;
					exit
				end;
			dummy:=alpha*manz;
			k:=trunc(dummy);
			if isint(dummy) then quantil:=(marray^[k-1]+marray^[k])/2
			else
				quantil:=marray^[k]
		end;

	function mittelwert: TNumber;
		label _mraus;

		var x,y,q,anz: integer;
		    zelle    : PCell;

		begin
			dummy:=0.0;
			q:=knoten^.Count;
			anz:=0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=dummy+EvalNode(cell,node);
									inc(anz)
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy+Evaluate(zelle);
															inc(anz);
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			if anz>0 then dummy:=dummy/anz;
			mittelwert:=dummy
		end;

	function harmittel: TNumber;
		label _mraus;

		var x,y,q,anz: integer;
		    zelle    : PCell;

		begin
			dummy:=0.0;
			q:=knoten^.Count;
			anz:=0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy2:=EvalNode(cell,node);
									if fnerror<>FE_OK then goto _mraus;
									if dummy2=0.0 then
										begin
											harmittel:=0.0;
											fnerror:=FE_DIVBYZERO;
											fnecell:=cell;
											exit
										end;
									dummy:=dummy+1/dummy2;
									inc(anz)
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy2:=Evaluate(zelle);
															if fnerror<>FE_OK then goto _mraus;
															if dummy2=0.0 then
																begin
																	harmittel:=0.0;
																	fnerror:=FE_DIVBYZERO;
																	fnecell:=cell;
																	exit
																end;
															dummy:=dummy+1/dummy2;
															inc(anz)
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			if dummy<>0 then dummy:=anz/dummy;
			harmittel:=dummy
		end;

	function quadmittel: TNumber;
		label _mraus;

		var x,y,q,anz: integer;
		    zelle    : PCell;

		begin
			dummy:=0.0;
			q:=knoten^.Count;
			anz:=0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=dummy+sqr(EvalNode(cell,node));
									inc(anz)
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy+sqr(Evaluate(zelle));
															inc(anz);
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			if anz>0 then dummy:=sqrt(dummy/anz);
			quadmittel:=dummy
		end;

	function geomittel: TNumber;
		label _mraus;

		var x,y,q,anz: integer;
		    zelle    : PCell;

		begin
			dummy:=1.0;
			q:=knoten^.Count;
			anz:=0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=dummy*EvalNode(cell,node);
									inc(anz)
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy*Evaluate(zelle);
															inc(anz);
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			if fnerror<>FE_OK then geomittel:=0.0
			else
				if anz>1 then
					begin
						dummy2:=1/anz;
						if dummy>0.0 then geomittel:=exp(dummy2*ln(dummy))
						else
							if dummy=0.0 then geomittel:=0.0
							else
								if frac(dummy2)<>0 then
									begin
										geomittel:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									if odd(round(dummy2)) then geomittel:=-exp(dummy2*ln(abs(dummy)))
									else
										geomittel:=exp(dummy2*ln(abs(dummy)))
					end
				else
					if anz=0 then geomittel:=0.0
					else
						geomittel:=dummy
		end;

	function varianz: TNumber;
		label _mraus;

		var x,y,q,anz: integer;
		    zelle    : PCell;

		begin
			dummy2:=mittelwert;
			dummy:=0.0;
			q:=knoten^.Count;
			anz:=0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=dummy+sqr(dummy2-EvalNode(cell,node));
									inc(anz)
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy+sqr(dummy2-Evaluate(zelle));
															inc(anz);
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			if fnerror<>FE_OK then varianz:=0.0
			else
				if anz>1 then varianz:=dummy/(anz-1)
				else
					begin
						varianz:=0.0;
						fnerror:=FE_UNDEFINED;
						fnecell:=cell
					end
		end;

	function varianzn: TNumber;
		label _mraus;

		var x,y,q,anz: integer;
		    zelle    : PCell;

		begin
			dummy2:=mittelwert;
			dummy:=0.0;
			q:=knoten^.Count;
			anz:=0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=dummy+sqr(dummy2-EvalNode(cell,node));
									inc(anz)
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy+sqr(dummy2-Evaluate(zelle));
															inc(anz);
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			if fnerror<>FE_OK then varianzn:=0.0
			else
				if anz>0 then varianzn:=dummy/anz
				else
					begin
						varianzn:=0.0;
						fnerror:=FE_UNDEFINED;
						fnecell:=cell
					end
		end;

	function mittelabw: TNumber;
		label _mraus;

		var x,y,q,anz: integer;
		    zelle    : PCell;

		begin
			dummy2:=mittelwert;
			dummy:=0.0;
			q:=knoten^.Count;
			anz:=0;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then
								begin
									dummy:=dummy+abs(EvalNode(cell,node)-dummy2);
									inc(anz)
								end
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy+abs(Evaluate(zelle)-dummy2);
															inc(anz);
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			if fnerror<>FE_OK then mittelabw:=0.0
			else
				if anz>0 then mittelabw:=dummy/anz
				else
					begin
						mittelabw:=0.0;
						fnerror:=FE_UNDEFINED;
						fnecell:=cell
					end
		end;

	function sumquadabw: TNumber;
		label _mraus;

		var x,y,q: integer;
		    zelle: PCell;

		begin
			dummy2:=mittelwert;
			dummy:=0.0;
			q:=knoten^.Count;
			Cell2RC(cell,ar,ac);
			while (q>0) and (fnerror=FE_OK) do
				begin
					dec(q);
					node:=PNode(knoten^.Left.List^[q]);
					if node<>nil then
						begin
							if node^.Typ<>NT_RANGE then dummy:=dummy+sqr(EvalNode(cell,node)-dummy2)
							else
								begin
									if getrange(node) then goto _mraus;
									for y:=yvon to ybis do
										begin
											zelle:=GetCell(y,xvon);
											for x:=xvon to xbis do
												begin
													if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) then
														begin
															dummy:=dummy+sqr(Evaluate(zelle)-dummy2);
															if fnerror<>FE_OK then goto _mraus
														end;
													inc(longint(zelle),CELLSIZE)
												end
										end
								end
						end
				end;
			_mraus:
			sumquadabw:=dummy
		end;

	function istleer: TNumber;
		var x,y  : integer;
		    zelle: PCell;

		begin
			istleer:=0.0;
			node:=knoten^.Left.Node;
			if node=nil then exit;
			if node^.Typ=NT_CELL then
				begin
					getrc(node^.Right.Flg,node^.RowRef,node^.ColRef);
					if (ar>=0) and (ar<=Parms.Rows) and (ac>=0) and (ac<=Parms.Columns) then
						begin
							zelle:=GetCell(ar,ac);
							if zelle^.Data.Value<>0 then exit
						end
					else
						begin
							fnerror:=FE_CELLOUTOFRANGE;
							fnecell:=cell
						end
				end
			else
				begin
					Cell2RC(cell,ar,ac);
					if getrange(node) then exit;
					for y:=yvon to ybis do
						begin
							zelle:=GetCell(y,xvon);
							for x:=xvon to xbis do
								begin
									if zelle^.Data.Value<>0 then exit;
									inc(longint(zelle),CELLSIZE)
								end
						end
				end;
			istleer:=1.0
		end;

	function isttext: TNumber;
		var x,y  : integer;
		    zelle: PCell;

		begin
			isttext:=0.0;
			node:=knoten^.Left.Node;
			if node=nil then exit;
			if node^.Typ=NT_CELL then
				begin
					getrc(node^.Right.Flg,node^.RowRef,node^.ColRef);
					if (ar>=0) and (ar<=Parms.Rows) and (ac>=0) and (ac<=Parms.Columns) then
						begin
							zelle:=GetCell(ar,ac);
							if zelle^.Typ<>CTYPE_TEXT then exit
						end
					else
						begin
							fnerror:=FE_CELLOUTOFRANGE;
							fnecell:=cell
						end
				end
			else
				begin
					Cell2RC(cell,ar,ac);
					if getrange(node) then exit;
					for y:=yvon to ybis do
						begin
							zelle:=GetCell(y,xvon);
							for x:=xvon to xbis do
								begin
									if zelle^.Typ<>CTYPE_TEXT then exit;
									inc(longint(zelle),CELLSIZE)
								end
						end
				end;
			isttext:=1.0
		end;

	function istzahl: TNumber;
		var x,y  : integer;
		    zelle: PCell;

		begin
			istzahl:=0.0;
			node:=knoten^.Left.Node;
			if node=nil then exit;
			if node^.Typ=NT_CELL then
				begin
					getrc(node^.Right.Flg,node^.RowRef,node^.ColRef);
					if (ar>=0) and (ar<=Parms.Rows) and (ac>=0) and (ac<=Parms.Columns) then
						begin
							zelle:=GetCell(ar,ac);
							if (zelle^.Typ<>CTYPE_CONST) and (zelle^.Typ<>CTYPE_FORMULA) then exit
						end
					else
						begin
							fnerror:=FE_CELLOUTOFRANGE;
							fnecell:=cell
						end
				end
			else
				begin
					Cell2RC(cell,ar,ac);
					if getrange(node) then exit;
					for y:=yvon to ybis do
						begin
							zelle:=GetCell(y,xvon);
							for x:=xvon to xbis do
								begin
									if (zelle^.Typ<>CTYPE_CONST) and (zelle^.Typ<>CTYPE_FORMULA) then exit;
									inc(longint(zelle),CELLSIZE)
								end
						end
				end;
			istzahl:=1.0
		end;

	function anzahl(cnttxt: boolean): TNumber;
		var x,y,c: integer;
		    zelle: PCell;

		begin
			anzahl:=0.0;
			node:=knoten^.Left.Node;
			if node=nil then exit;
			if node^.Typ=NT_CELL then
				begin
					getrc(node^.Right.Flg,node^.RowRef,node^.ColRef);
					if (ar>=0) and (ar<=Parms.Rows) and (ac>=0) and (ac<=Parms.Columns) then
						begin
							zelle:=GetCell(ar,ac);
							if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) or ((zelle^.Typ=CTYPE_TEXT) and cnttxt) then anzahl:=1.0
						end
					else
						begin
							fnerror:=FE_CELLOUTOFRANGE;
							fnecell:=cell
						end
				end
			else
				begin
					c:=0;
					Cell2RC(cell,ar,ac);
					if getrange(node) then exit;
					for y:=yvon to ybis do
						begin
							zelle:=GetCell(y,xvon);
							for x:=xvon to xbis do
								begin
									if (zelle^.Typ=CTYPE_CONST) or (zelle^.Typ=CTYPE_FORMULA) or ((zelle^.Typ=CTYPE_TEXT) and cnttxt) then inc(c);
									inc(longint(zelle),CELLSIZE)
								end
						end;
					anzahl:=c
				end
		end;

	function istfehler: TNumber;
		var x,y  : integer;
		    zelle: PCell;

		begin
			istfehler:=0.0;
			node:=knoten^.Left.Node;
			if node=nil then exit;
			if node^.Typ=NT_CELL then
				begin
					getrc(node^.Right.Flg,node^.RowRef,node^.ColRef);
					if (ar>=0) and (ar<=Parms.Rows) and (ac>=0) and (ac<=Parms.Columns) then
						begin
							zelle:=GetCell(ar,ac);
							if zelle^.Typ<>CTYPE_FORMULA then exit;
							if zelle^.Data.Formula^.Error=FE_OK then exit
						end
					else
						begin
							fnerror:=FE_CELLOUTOFRANGE;
							fnecell:=cell
						end;
					istfehler:=1.0
				end
			else
				begin
					Cell2RC(cell,ar,ac);
					if getrange(node) then exit;
					for y:=yvon to ybis do
						begin
							zelle:=GetCell(y,xvon);
							for x:=xvon to xbis do
								begin
									if zelle^.Typ=CTYPE_FORMULA then
										if zelle^.Data.Formula^.Error<>FE_OK then
											begin
												istfehler:=1.0;
												exit
											end;
									inc(longint(zelle),CELLSIZE)
								end
						end
				end
		end;

	function gda: TNumber;
		var dummy5,p: TNumber;
		    i       : integer;

		begin
			dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
			dummy2:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
			dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
			dummy4:=EvalNode(cell,PNode(knoten^.Left.List^[3]));
			if knoten^.Count<5 then dummy5:=12.0
			else
				dummy5:=EvalNode(cell,PNode(knoten^.Left.List^[4]));
			if fnerror<>FE_OK then gda:=0.0
			else
				if not(isint(dummy3)) or not(isint(dummy4)) or (dummy3<1.0) or (dummy<0.0) or (dummy<dummy2) or (dummy5<0.0) or (dummy5>12.0) then
					begin
						gda:=0.0;
						fnerror:=FE_UNDEFINED;
						fnecell:=cell
					end
				else
					if (dummy4<1.0) or (dummy4>dummy3+1.0) then gda:=0.0
					else
						begin
							p:=dummy2/dummy;
							if p>0.0 then p:=exp(ln(p)/dummy3);
							p:=round((1.0-p)*1000.0)/1000.0;
							i:=round(dummy4);
							dummy2:=dummy;
							if i>0 then
								begin
									dummy2:=dummy*p*dummy5/12.0;
									dummy:=dummy-dummy2;
									dec(i)
								end;
							while i>0 do
								begin
									dummy2:=dummy*p;
									dummy:=dummy-dummy2;
									dec(i)
								end;
							if dummy4>dummy3 then dummy2:=dummy2*(12.0-dummy5)/12.0;
							gda:=dummy2
						end
		end;

	function dda: TNumber;
		var dummy5: TNumber;
		    i     : integer;

		begin
			dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
			dummy2:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
			dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
			dummy4:=EvalNode(cell,PNode(knoten^.Left.List^[3]));
			if knoten^.Count<5 then dummy5:=2.0
			else
				dummy5:=EvalNode(cell,PNode(knoten^.Left.List^[4]));
			if fnerror<>FE_OK then dda:=0.0
			else
				if not(isint(dummy3)) or not(isint(dummy4)) or (dummy3<1.0) or (dummy<0.0) or (dummy<dummy2) then
					begin
						dda:=0.0;
						fnerror:=FE_UNDEFINED;
						fnecell:=cell
					end
				else
					if (dummy4<1.0) or (dummy4>dummy3) then dda:=0.0
					else
						begin
							i:=round(dummy4);
							while (i>0) and (dummy>dummy2) do
								begin
									dummy4:=dummy*dummy5/dummy3;
									dummy:=dummy-dummy4;
									dec(i)
								end;
							if dummy<dummy2 then dda:=dummy4+dummy-dummy2
							else
								dda:=dummy4
						end
		end;

	function getvar: TNumber;
		var varup: string;
		    w    : integer;

		begin
			getvar:=0.0;
			if Variables<>nil then
				if Variables^.Count>0 then
					begin
						varup:=StrPUpper(knoten^.Varb^);
						for w:=Variables^.Count-1 downto 0 do
							with PVariable(Variables^.At(w))^ do
								if varup=StrPUpper(Name^) then
									begin
										if (RefRow>=0) and (RefRow<=Parms.Rows) and (RefCol>=0) and (RefCol<=Parms.Columns) then getvar:=Evaluate(GetCell(RefRow,RefCol))
										else
											begin
												fnerror:=FE_CELLOUTOFRANGE;
												fnecell:=cell
											end;
										exit
									end
					end
		end;

	function ostern(j: longint): TNumber;
		var a,b,c,d,e  : longint;

		begin
			a:=j mod 19;
			b:=j mod 4;
			c:=j mod 7;
			d:=(19*a+24) mod 30;
			e:=2*b+4*c+6*d;
			if j<2100 then e:=(e+5) mod 7
			else
				e:=(e+6) mod 7;
			b:=22+d+e;
			c:=d+e-9;
			if b>31 then
				begin
					l1:=4;
					if c=26 then l2:=19
					else
						if c=25 then
							begin
								if (d=28) and (a>10) then l2:=18
								else
									l2:=c
							end
						else
							l2:=c
				end
			else
				begin
					l1:=3;
					l2:=b
				end;
			ostern:=TexelApp.Date(j,l1,l2,sheetbuffer.exceldate=bf_Checked)
		end;

	function getval: TNumber;
		var zelle: PCell;
		    sval : string;
		    sz   : TNumber;
		    dfrm : integer;

		begin
			getval:=0.0;
			node:=knoten^.Left.Node;
			if node=nil then exit;
			if node^.Typ=NT_CELL then
				begin
					getrc(node^.Right.Flg,node^.RowRef,node^.ColRef);
					if (ar>=0) and (ar<=Parms.Rows) and (ac>=0) and (ac<=Parms.Columns) then
						begin
							zelle:=GetCell(ar,ac);
							if zelle^.Typ=CTYPE_TEXT then
								begin
									if zelle^.Data.Txt<>nil then
										begin
											sval:=zelle^.Data.Txt^;
											if TexelApp.IsDate(sval,sz,sval,dfrm,sheetbuffer.exceldate=bf_Checked) then getval:=sz
											else
												if TexelApp.IsTime(sval,sz,sval,dfrm) then getval:=sz
												else
													getval:=atof(sval)
										end
								end
							else
								getval:=Evaluate(zelle)
						end
				end
			else
				getval:=EvalNode(cell,knoten^.Left.Node)
		end;

	begin
		if fnerror<>FE_OK then EvalNode:=0.0
		else
			with knoten^ do
				begin
					case Typ of
					NT_CONST:
						EvalNode:=Num^;
					NT_CELL:
						begin
							getrc(Right.Flg,RowRef,ColRef);
							if (ar>=0) and (ar<=Parms.Rows) and (ac>=0) and (ac<=Parms.Columns) then EvalNode:=Evaluate(GetCell(ar,ac))
							else
								begin
									EvalNode:=0.0;
									fnerror:=FE_CELLOUTOFRANGE;
									fnecell:=cell
								end
						end;
					NT_VARIABLE:
						EvalNode:=getvar;
					NT_STRING:
						begin
							EvalNode:=0.0; { !!! }
							fnerror:=FE_STRING;
							fnecell:=cell
						end;
					NT_KLAMMER:
						EvalNode:=EvalNode(cell,Left.Node);
					NT_DEFINE:
						EvalNode:=EvalNode(cell,Left.Node);
					NT_EQUAL:
						if EvalNode(cell,Left.Node)=EvalNode(cell,Right.Node) then EvalNode:=1.0
						else
							EvalNode:=0.0;
					NT_GREATER:
						if EvalNode(cell,Left.Node)>EvalNode(cell,Right.Node) then EvalNode:=1.0
						else
							EvalNode:=0.0;
					NT_LESS:
						if EvalNode(cell,Left.Node)<EvalNode(cell,Right.Node) then EvalNode:=1.0
						else
							EvalNode:=0.0;
					NT_GREATEREQUAL:
						if EvalNode(cell,Left.Node)>=EvalNode(cell,Right.Node) then EvalNode:=1.0
						else
							EvalNode:=0.0;
					NT_LESSEQUAL:
						if EvalNode(cell,Left.Node)<=EvalNode(cell,Right.Node) then EvalNode:=1.0
						else
							EvalNode:=0.0;
					NT_UNEQUAL:
						if EvalNode(cell,Left.Node)<>EvalNode(cell,Right.Node) then EvalNode:=1.0
						else
							EvalNode:=0.0;
					NT_NAT_PLUS,
					NT_PLUS:
						EvalNode:=EvalNode(cell,Left.Node)+EvalNode(cell,Right.Node);
					NT_NAT_MINUS,
					NT_MINUS:
						EvalNode:=EvalNode(cell,Left.Node)-EvalNode(cell,Right.Node);
					NT_NAT_MULT,
					NT_MULT:
						EvalNode:=EvalNode(cell,Left.Node)*EvalNode(cell,Right.Node);
					NT_NAT_DIV,
					NT_DIV:
						begin
							dummy:=EvalNode(cell,Right.Node);
							dummy2:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_DIVBYZERO;
										fnecell:=cell
									end
								else
									EvalNode:=dummy2/dummy
						end;
					NT_NAT_POWER,
					NT_POWER:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								begin
									dummy2:=EvalNode(cell,Right.Node);
									if fnerror<>FE_OK then EvalNode:=0.0
									else
										if (dummy<>0.0) or (dummy2<>0.0) then
											begin
												if dummy>0.0 then EvalNode:=exp(dummy2*ln(dummy))
												else
													if dummy=0.0 then EvalNode:=0.0
													else
														if frac(dummy2)<>0 then
															begin
																EvalNode:=0.0;
																fnerror:=FE_UNDEFINED;
																fnecell:=cell
															end
														else
															if odd(round(dummy2)) then EvalNode:=-exp(dummy2*ln(abs(dummy)))
															else
																EvalNode:=exp(dummy2*ln(abs(dummy)))
											end
										else
											begin
												EvalNode:=0.0;
												fnerror:=FE_UNDEFINED;
												fnecell:=cell
											end
								end
						end;
					NT_SUMME:
						EvalNode:=summe;
					NT_PRODUKT:
						EvalNode:=produkt;
					NT_MIN:
						EvalNode:=minimum;
					NT_MAX:
						EvalNode:=maximum;
					NT_UND:
						EvalNode:=und;
					NT_ODER:
						EvalNode:=oder;
					NT_VARIANZ:
						EvalNode:=varianz;
					NT_VARIANZN:
						EvalNode:=varianzn;
					NT_STDABW:
						EvalNode:=sqrt(varianz);
					NT_STDABWN:
						EvalNode:=sqrt(varianzn);
					NT_MITTELABW:
						EvalNode:=mittelabw;
					NT_SUMQUADABW:
						EvalNode:=sumquadabw;
					NT_MITTEL:
						EvalNode:=mittelwert;
					NT_HARMITTEL:
						EvalNode:=harmittel;
					NT_QUADMITTEL:
						EvalNode:=quadmittel;
					NT_GEOMITTEL:
						EvalNode:=geomittel;
					NT_MEDIAN:
						begin
							getandsortarray(false);
							EvalNode:=quantil(0.5);
							freearray
						end;
					NT_QUANTIL:
						begin
							dummy:=getandsortarray(true);
							EvalNode:=quantil(dummy);
							freearray
						end;
					NT_QUARTILUNTEN:
						begin
							getandsortarray(false);
							EvalNode:=quantil(0.25);
							freearray
						end;
					NT_QUARTILOBEN:
						begin
							getandsortarray(false);
							EvalNode:=quantil(0.75);
							freearray
						end;
					NT_QUARTILSABST:
						begin
							getandsortarray(false);
							EvalNode:=quantil(0.75)-quantil(0.25);
							freearray
						end;
					NT_SPANNWEITE:
						begin
							getandsortarray(false);
							if marray<>nil then EvalNode:=marray^[manz-1]-marray^[0]
							else
								EvalNode:=0.0;
							freearray
						end;
					NT_NAT_NEGATE,
					NT_NEGATE:
						EvalNode:=-EvalNode(cell,Left.Node);
					NT_PERCENT:
						EvalNode:=EvalNode(cell,Left.Node)/100.0;
					NT_RND:
						EvalNode:=system.random;
					NT_FEHLER:
						begin
							EvalNode:=0.0;
							fnerror:=FE_ERROR;
							fnecell:=cell
						end;
					NT_SIN:
						EvalNode:=sin(EvalNode(cell,Left.Node));
					NT_COS:
						EvalNode:=cos(EvalNode(cell,Left.Node));
					NT_ARCTAN:
						EvalNode:=arctan(EvalNode(cell,Left.Node));
					NT_ARCTAN2:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								begin
									dummy2:=EvalNode(cell,Right.Node);
									if fnerror<>FE_OK then EvalNode:=0.0
									else
										if (dummy=0.0) then
											begin
												if dummy2=0.0 then
													begin
														EvalNode:=0.0;
														fnerror:=FE_UNDEFINED;
														fnecell:=cell
													end
												else
													begin
														if dummy2<0.0 then EvalNode:=-ev_pihalbe
														else
															EvalNode:=ev_pihalbe
													end
											end
										else
											if dummy>0.0 then EvalNode:=arctan(dummy2/dummy)
											else
												if dummy2>=0.0 then EvalNode:=arctan(dummy2/dummy)+pi
												else
													EvalNode:=arctan(-dummy/dummy2)-ev_pihalbe
								end
						end;
					NT_ARCCOT:
						EvalNode:=ev_pihalbe-arctan(EvalNode(cell,Left.Node));
					NT_ARCSIN:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if abs(dummy)>1.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=arcsin(dummy)
						end;
					NT_ARCCOS:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if abs(dummy)>1.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ev_pihalbe-arcsin(dummy)
						end;
					NT_TAN:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if cos(dummy)=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=sin(dummy)/cos(dummy)
						end;
					NT_COT:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if sin(dummy)=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=cos(dummy)/sin(dummy)
						end;
					NT_ABS:
						EvalNode:=abs(EvalNode(cell,Left.Node));
					NT_FRAC:
						EvalNode:=frac(EvalNode(cell,Left.Node));
					NT_INT:
						EvalNode:=int(EvalNode(cell,Left.Node));
					NT_ROUND:
						EvalNode:=round(EvalNode(cell,Left.Node));
					NT_TRUNC:
						EvalNode:=trunc(EvalNode(cell,Left.Node));
					NT_GERADE:
						begin
							dummy:=abs(EvalNode(cell,Left.Node));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) then EvalNode:=0.0
								else
									if odd(trunc(dummy)) then EvalNode:=0.0
									else
										EvalNode:=1.0
						end;
					NT_UNGERADE:
						begin
							dummy:=abs(EvalNode(cell,Left.Node));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) then EvalNode:=0.0
								else
									if odd(trunc(dummy)) then EvalNode:=1.0
									else
										EvalNode:=0.0
						end;
					NT_EXP:
						EvalNode:=exp(EvalNode(cell,Left.Node));
					NT_SQR:
						EvalNode:=sqr(EvalNode(cell,Left.Node));
					NT_SQRT:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy<0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=sqrt(dummy)
						end;
					NT_LN:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy<=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ln(dummy)
						end;
					NT_LOG10:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy<=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ln(dummy)/ev_ln10
						end;
					NT_LD:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy<=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ln(dummy)/ev_ln2
						end;
					NT_SINH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							EvalNode:=(exp(dummy)-exp(-dummy))/2
						end;
					NT_COSH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							EvalNode:=(exp(dummy)+exp(-dummy))/2
						end;
					NT_TANH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							EvalNode:=(exp(dummy)-exp(-dummy))/(exp(dummy)+exp(-dummy))
						end;
					NT_COTH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=(exp(dummy)+exp(-dummy))/(exp(dummy)-exp(-dummy))
						end;
					NT_ARTANH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if abs(dummy)>=1.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ln((1+dummy)/(1-dummy))/2
						end;
					NT_ARCOTH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if abs(dummy)<=1.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ln((dummy+1)/(dummy-1))/2
						end;
					NT_ARCOSH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if abs(dummy)<1.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ln(dummy+sqrt(sqr(dummy)-1))
						end;
					NT_ARSINH:
						begin
							dummy:=EvalNode(cell,Left.Node);
							EvalNode:=ln(dummy+sqrt(sqr(dummy)+1))
						end;
					NT_LOG:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if Right.Node=nil then dummy2:=10.0
							else
								dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if (dummy<=0.0) or (dummy2<=0.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ln(dummy)/ln(dummy2)
						end;
					NT_GRAD:
						EvalNode:=EvalNode(cell,Left.Node)*ev_rad2grad;
					NT_RAD:
						EvalNode:=EvalNode(cell,Left.Node)*ev_grad2rad;
					NT_VAL:
						EvalNode:=getval;
					NT_SCRIPTNO:
						EvalNode:=scriptno(cell^.Data.Formula^.Value,0);
					NT_BALMER:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) or (dummy<3.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=3.288e15*(0.25-1/sqr(dummy))
						end;
					NT_STUNDE:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								EvalNode:=Num2Hour(dummy)
						end;
					NT_STUNDEN:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								EvalNode:=Num2Hour(dummy)+24*trunc(dummy)
						end;
					NT_MINUTE:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								EvalNode:=Num2Minute(dummy)
						end;
					NT_SEKUNDE:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								EvalNode:=Num2Second(dummy)
						end;
					NT_JAHR:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								EvalNode:=Num2Year(dummy)
						end;
					NT_MONAT:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								EvalNode:=Num2Month(dummy)
						end;
					NT_TAG:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								EvalNode:=Num2Day(dummy)
						end;
					NT_DATUM:
						begin
							dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
							dummy2:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
							dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								begin
									if (dummy>=80.0) and (dummy<=99.0) then dummy:=dummy+1900.0
									else
										if (dummy>=0) and (dummy<=79.0) then dummy:=dummy+2000.0;
									if not(isint(dummy)) or not(isint(dummy2)) or not(isint(dummy3))
									   or (dummy<1900.0) or (dummy>2199.0) or (dummy2<1.0) or (dummy2>12.0) or (dummy3<1.0) or (dummy3>31.0) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
									else
										EvalNode:=TexelApp.Date(trunc(dummy),trunc(dummy2),trunc(dummy3),sheetbuffer.exceldate=bf_Checked)
								end
						end;
					NT_HEUTE:
						EvalNode:=Today;
					NT_JETZT:
						EvalNode:=Now;
					NT_STD1:
						EvalNode:=std1;
					NT_MIN1:
						EvalNode:=min1;
					NT_SEK1:
						EvalNode:=sek1;
					NT_FALSE:
						EvalNode:=0.0;
					NT_TRUE:
						EvalNode:=1.0;
					NT_PI:
						EvalNode:=pi;
					NT_ZEIT:
						begin
							dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
							dummy2:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
							dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) or not(isint(dummy2)) or not(isint(dummy3))
								   or (dummy<0.0) or (dummy>23.0) or (dummy2<0.0) or (dummy2>59.0) or (dummy3<0.0) or (dummy3>59.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=TexelApp.Time(trunc(dummy),trunc(dummy2),trunc(dummy3))
						end;
					NT_WOCHENTAG:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if Right.Node=nil then dummy2:=1.0
							else
								dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy2)) or (dummy2<1.0) or (dummy2>3.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=Weekday(dummy,trunc(dummy2))
						end;
					NT_TAGE:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								begin
									if (dummy>=80.0) and (dummy<=99.0) then dummy:=dummy+1900.0
									else
										if (dummy>=0) and (dummy<=79.0) then dummy:=dummy+2000.0;
									if not(isint(dummy)) or (dummy<1900.0) or (dummy>2199.0) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
									else
										EvalNode:=TexelApp.Days(trunc(dummy),sheetbuffer.exceldate=bf_Checked)
								end
						end;
					NT_SCHALTJAHR:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								begin
									if (dummy>=80.0) and (dummy<=99.0) then dummy:=dummy+1900.0
									else
										if (dummy>=0) and (dummy<=79.0) then dummy:=dummy+2000.0;
									if not(isint(dummy)) or (dummy<1900.0) or (dummy>2199.0) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
									else
										if TexelApp.Days(trunc(dummy),sheetbuffer.exceldate=bf_Checked)=366 then EvalNode:=1.0
										else
											EvalNode:=0.0
								end
						end;
					NT_OSTERN:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								begin
									if (dummy>=80.0) and (dummy<=99.0) then dummy:=dummy+1900.0
									else
										if (dummy>=0) and (dummy<=79.0) then dummy:=dummy+2000.0;
									if not(isint(dummy)) or (dummy<1900.0) or (dummy>2199.0) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
									else
										EvalNode:=ostern(trunc(dummy))
								end
						end;
					NT_FAK:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) or (dummy<0.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									if (dummy>1748.0) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_OVERFLOW;
											fnecell:=cell
										end
									else
										begin
											l1:=trunc(dummy);
											dummy:=1.0;
											while l1>1 do
												begin
													dummy:=int(dummy)*l1;
													dec(l1)
												end;
											EvalNode:=dummy
										end
						end;
					NT_SGN:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if dummy<0.0 then EvalNode:=-1.0
							else
								if dummy>0.0 then EvalNode:=1.0
								else
									EvalNode:=0.0
						end;
					NT_STDNORMVERT:
						EvalNode:=ev_normalfaktor*exp(-sqr(EvalNode(cell,Left.Node))/2.0);
					NT_NORMVERT:
						begin
							dummy2:=EvalNode(cell,PNode(Left.List^[1]));
							dummy3:=EvalNode(cell,PNode(Left.List^[2]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy3<=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=ev_normalfaktor*exp(-sqr(EvalNode(cell,PNode(Left.List^[0]))-dummy2)/(2.0*dummy3))/sqrt(dummy3)
						end;
					NT_EXPVERT:
						begin
							dummy:=EvalNode(cell,Left.Node);
							dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if (dummy<=0.0) or (dummy2<=0.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=dummy2*exp(-dummy2*dummy)
						end;
					NT_WENN:
						begin
							if EvalNode(cell,PNode(Left.List^[0]))=1.0 then
								begin
									if Count<2 then EvalNode:=1.0
									else
										EvalNode:=EvalNode(cell,PNode(Left.List^[1]))
								end
							else
								begin
									if Count<3 then EvalNode:=0.0
									else
										EvalNode:=EvalNode(cell,PNode(Left.List^[2]))
								end
						end;
					NT_WAHL:
						begin
							dummy:=EvalNode(cell,PNode(Left.List^[0]));
							if not(isint(dummy)) then
								begin
									EvalNode:=0.0;
									fnerror:=FE_UNDEFINED;
									fnecell:=cell
								end
							else
								begin
									l1:=trunc(dummy);
									if (l1>0) and (l1<Count) then EvalNode:=EvalNode(cell,PNode(Left.List^[l1]))
									else
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
								end
						end;
					NT_GLEICHVERT:
						begin
							dummy2:=EvalNode(cell,PNode(Left.List^[1]));
							dummy3:=EvalNode(cell,PNode(Left.List^[2]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy2=dummy3 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									begin
										if dummy2>dummy3 then
											begin
												dummy:=dummy2;
												dummy2:=dummy3;
												dummy3:=dummy
											end;
										dummy:=EvalNode(cell,PNode(Left.List^[0]));
										if (dummy>dummy2) and (dummy<dummy3) then EvalNode:=1/(dummy3-dummy2)
										else
											EvalNode:=0.0
									end
						end;
					NT_INTDIV:
						begin
							dummy:=EvalNode(cell,Left.Node);
							dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy2=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_DIVBYZERO;
										fnecell:=cell
									end
								else
									if not(isint(dummy)) or not(isint(dummy2)) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
									else
										EvalNode:=trunc(dummy) div trunc(dummy2)
						end;
					NT_MOD:
						begin
							dummy:=EvalNode(cell,Left.Node);
							dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy2=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_DIVBYZERO;
										fnecell:=cell
									end
								else
									if not(isint(dummy)) or not(isint(dummy2)) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
									else
										EvalNode:=trunc(dummy) mod trunc(dummy2)
						end;
					NT_ROOT:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if Right.Node=nil then dummy2:=2.0
							else
								dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy2=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									begin
										dummy2:=1/dummy2;
										if dummy>0.0 then EvalNode:=exp(dummy2*ln(dummy))
										else
											if dummy=0.0 then EvalNode:=0.0
											else
												if frac(dummy2)<>0 then
													begin
														EvalNode:=0.0;
														fnerror:=FE_UNDEFINED;
														fnecell:=cell
													end
												else
													if dummy2=1.0 then EvalNode:=dummy
													else
														EvalNode:=1/dummy
									end
						end;
					NT_RANDOM:
						begin
							dummy:=EvalNode(cell,Left.Node);
							dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) or (dummy<0) or not(isint(dummy2)) or (dummy2<0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									begin
										l1:=Min(round(dummy),round(dummy2));
										l2:=Max(round(dummy),round(dummy2));
										EvalNode:=system.random(l2+1-l1)+l1
									end
						end;
					NT_SEC:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if cos(dummy)=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=1.0/cos(dummy)
						end;
					NT_COSEC:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if sin(dummy)=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=1.0/sin(dummy)
						end;
					NT_ISTZAHL:
						EvalNode:=istzahl;
					NT_ISTTEXT:
						EvalNode:=isttext;
					NT_ISTLEER:
						EvalNode:=istleer;
					NT_ISTFEHLER:
						EvalNode:=istfehler;
					NT_ANZAHL:
						EvalNode:=anzahl(false);
					NT_ANZAHL2:
						EvalNode:=anzahl(true);
					NT_SPALTEN:
						if knoten^.Left.Node^.Typ=NT_CELL then EvalNode:=1.0
						else
							begin
								Cell2RC(cell,ar,ac);
								if not(getrange(knoten^.Left.Node)) then EvalNode:=xbis+1.0-xvon
							end;
					NT_ZEILEN:
						if knoten^.Left.Node^.Typ=NT_CELL then EvalNode:=1.0
						else
							begin
								Cell2RC(cell,ar,ac);
								if not(getrange(knoten^.Left.Node)) then EvalNode:=ybis+1.0-yvon
							end;
					NT_MDET:
						if knoten^.Left.Node^.Typ=NT_CELL then EvalNode:=EvalNode(cell,knoten^.Left.Node)
						else
							begin
								Cell2RC(cell,ar,ac);
								if getrange(knoten^.Left.Node) then EvalNode:=0.0
								else
									if (ybis-yvon)<>(xbis-xvon) then
										begin
											EvalNode:=0.0;
											fnerror:=FE_UNDEFINED;
											fnecell:=cell
										end
									else
										begin
											getmem(pna,(ybis+1-yvon) shl 1);
											if pna<>nil then
												for l1:=xvon to xbis do pna^[l1-xvon]:=l1;
											EvalNode:=mdet(yvon,ybis-yvon,pna)
										end
							end;
					NT_LIA:
						begin
							dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
							dummy2:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
							dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy3)) or (dummy3<1.0) or (dummy<0.0) or (dummy<dummy2) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=(dummy-dummy2)/dummy3
						end;
					NT_DIGA:
						begin
							dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
							dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
							dummy4:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy3)) or not(isint(dummy4)) or (dummy3<1.0) or (dummy<0.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									if (dummy4<1.0) or (dummy4>dummy3) then EvalNode:=0.0
									else
										EvalNode:=(dummy3+1.0-dummy4)*2.0*dummy/(dummy3*(dummy3+1.0))
						end;
					NT_ADA:
						begin
							dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
							dummy2:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
							dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
							dummy4:=EvalNode(cell,PNode(knoten^.Left.List^[3]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy3)) or not(isint(dummy4)) or (dummy3<1.0) or (dummy<0.0) or (dummy<dummy2) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									if (dummy4<1.0) or (dummy4>dummy3) then EvalNode:=0.0
									else
										EvalNode:=(dummy3+1.0-dummy4)*2.0*(dummy-dummy2)/(dummy3*(dummy3+1.0))
						end;
					NT_GDA:
						EvalNode:=gda;
					NT_DDA:
						EvalNode:=dda;
					NT_RMZ:
						begin
							dummy:=EvalNode(cell,PNode(knoten^.Left.List^[0]));
							dummy2:=EvalNode(cell,PNode(knoten^.Left.List^[1]));
							dummy3:=EvalNode(cell,PNode(knoten^.Left.List^[2]));
							if knoten^.Count<4 then dummy4:=0
							else
								dummy4:=-EvalNode(cell,PNode(knoten^.Left.List^[3]));
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if (dummy<=0.0) or not(isint(dummy2)) or (dummy2<1.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									begin
										dummy2:=1.0/exp(dummy2*ln(dummy+1.0));
										EvalNode:=(dummy4*dummy2-dummy3)*dummy/(1-dummy2)
									end
						end;
					NT_BUND:
						EvalNode:=bund;
					NT_BODER:
						EvalNode:=boder;
					NT_BEOR:
						EvalNode:=beor;
					NT_BSCHIEBR:
						begin
							dummy:=EvalNode(cell,Left.Node);
							dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) or not(isint(dummy2)) or (dummy2<0.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=trunc(dummy) shr trunc(dummy2)
						end;
					NT_BSCHIEBL:
						begin
							dummy:=EvalNode(cell,Left.Node);
							dummy2:=EvalNode(cell,Right.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) or not(isint(dummy2)) or (dummy2<0.0) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=trunc(dummy) shl trunc(dummy2)
						end;
					NT_BNICHT:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if not(isint(dummy)) then
									begin
										EvalNode:=0.0;
										fnerror:=FE_UNDEFINED;
										fnecell:=cell
									end
								else
									EvalNode:=not(trunc(dummy))
						end;
					NT_KEHRWERT:
						begin
							dummy:=EvalNode(cell,Left.Node);
							if fnerror<>FE_OK then EvalNode:=0.0
							else
								if dummy=0.0 then
									begin
										EvalNode:=0.0;
										fnerror:=FE_DIVBYZERO;
										fnecell:=cell
									end
								else
									EvalNode:=1/dummy
						end;
					NT_NICHT:
						if EvalNode(cell,Left.Node)=0.0 then EvalNode:=1.0
						else
							EvalNode:=0.0;
					else
						begin
							if (Typ>=NT_EXTMIN) and (Typ<=NT_EXTMAX) then
								EvalNode:=scriptno(cell^.Data.Formula^.Value,Typ)
							else
								begin
									EvalNode:=0.0;
									fnerror:=FE_OPUNKNOWN;
									fneOp:=Typ;
									fnecell:=cell
								end
						end
					end
				end
	end;


function TCalcWindow.Evaluate(cell: PCell): TNumber;
	var oldval: TNumber;
	    r,c   : integer;

	begin
		if fnerror<>FE_OK then Evaluate:=0.0
		else
			begin
				if bTst(cell^.Flags,CELL_USED) then
					begin
						Evaluate:=0.0;
						fnerror:=FE_CIRCREF;
						fnecell:=cell
					end
				else
					begin
						cell^.Flags:=cell^.Flags or CELL_USED;
						case cell^.Typ of
						CTYPE_FORMULA:
							begin
								if bTst(cell^.Flags,CELL_CALCULATED) then
									begin
										if cell^.Data.Formula^.Error<>FE_OK then
											begin
												Evaluate:=0.0;
												fnerror:=FE_UNDEFINED;
												fnecell:=cell
											end
										else
											Evaluate:=cell^.Data.Formula^.Value
									end
								else
									begin
										oldval:=cell^.Data.Formula^.Value;
										cell^.Data.Formula^.Value:=EvalNode(cell,cell^.Data.Formula^.Func);
										cell^.Flags:=cell^.Flags or CELL_CALCULATED;
										if fnerror=FE_OK then
											begin
												Evaluate:=cell^.Data.Formula^.Value;
												if (cell^.Data.Formula^.Value<>oldval) or (cell^.Data.Formula^.Error<>FE_OK) then
													begin
														cell^.Data.Formula^.Error:=FE_OK;
														Cell2RC(cell,r,c);
														DrawCells(r,c,r,c)
													end
												else
													cell^.Data.Formula^.Error:=FE_OK
											end
										else
											begin
												Evaluate:=0.0;
												cell^.Data.Formula^.Value:=0.0;
												if fnerror<>cell^.Data.Formula^.Error then
													begin
														cell^.Data.Formula^.Error:=shortint(fnerror);
														Cell2RC(cell,r,c);
														DrawCells(r,c,r,c)
													end
												else
													cell^.Data.Formula^.Error:=shortint(fnerror)
											end
									end
							end;
						CTYPE_CONST:
							Evaluate:=cell^.Data.Konst^.Value
						else
							Evaluate:=0.0
						end;
						cell^.Flags:=cell^.Flags and not(CELL_USED)
					end
			end
	end;


function TCalcWindow.GetCellValue(cell: PCell; clr: boolean): TNumber;

	begin
		fnerror:=FE_OK;
		fnecell:=nil;
		if clr then ClearCalcFlags;
		GetCellValue:=Evaluate(cell);
		if fnerror<>FE_OK then
			begin
				if fnecell=nil then fnecell:=cell;
				GetCellValue:=0.0
			end
	end;


function TCalcWindow.Error2Txt(err: shortint): string;

	begin
		case err of
		FE_DIVBYZERO:
			Error2Txt:='#DIV/0';
		FE_UNDEFINED:
			Error2Txt:='#UNDEF';
		FE_CIRCREF:
			Error2Txt:='#CIRCREF';
		FE_CELLOUTOFRANGE:
			Error2Txt:='#CELLRANGE';
		FE_OPUNKNOWN:
			Error2Txt:='#OPCODE?';
		FE_ERROR:
			Error2Txt:='#'+STRING_ERR_ERROR;
		FE_OVERFLOW:
			Error2Txt:='#'+STRING_ERR_OVERFLOW;
		FE_EXTERN:
			Error2Txt:='#EXTERN?';
		FE_STRING:
			Error2Txt:='#STRING';
		FE_OK:
			Error2Txt:='#OK!';
		else
			Error2Txt:='#???';
		end
	end;


procedure TCalcWindow.ChangeCell(cell: PCell; intxt: string; r,c: integer; chgval: boolean);
	label _weiter;

	var vrnd,cclr,
	    oldtclip : boolean;
	    oldfpts  : byte;
	    errcode,
	    cmin,cmax,
	    oldctyp,q: integer;
	    vars,otxt: string;
	    pc       : PConst;
	    pf       : PFormula;
	    pn       : PNode;
	    oldfval,
	    fres     : TNumber;
	    vr       : GRECT;
	    answ     : Pipearray;

	begin
		cclr:=true;
		cmin:=c;
		cmax:=c;
		RowsClearOverflow(r,r,cmin,cmax);
		oldctyp:=cell^.Typ;
		oldtclip:=false;
		case oldctyp of
		CTYPE_CONST:
			oldfpts:=cell^.Data.Konst^.FPts;
		CTYPE_FORMULA:
			begin
				oldfval:=cell^.Data.Formula^.Value;
				oldfpts:=cell^.Data.Formula^.FPts
			end
		else
			begin
				oldfpts:=atol(TexelApp.setupbuffer.floatpoint);
				if oldctyp<>CTYPE_TEXT then chgval:=true
				else
					oldtclip:=bTst(cell^.TxtVal.Flags,TFL_CLIP);
			end
		end;
		vrnd:=FreeCell(cell,false);
		if cell^.Data.Value=0 then
			if length(intxt)>0 then
				begin
					if PParser(parser)^.Parse(intxt,vars,pn,cell,r,c,true,parserrpos,errcode) then
						begin
							new(pf);
							if pf<>nil then
								begin
									pf^.Func:=pn;
									pf^.VarDef:=NewStr(vars);
									if chgval then
										with cell^.TxtVal do
											begin
												Font:=GetFontIndex;
												Size:=GetFontSize;
												if (oldctyp<>CTYPE_CONST) and (oldctyp<>CTYPE_FORMULA) then Align:=(Align and $f0) or TA_RIGHT;
												Flags:=0
											end;
									cell^.Data.Formula:=pf;
									cell^.Typ:=CTYPE_FORMULA;
									pf^.FPts:=oldfpts;
									pf^.Error:=FE_OK;
									if oldctyp=CTYPE_FORMULA then pf^.Value:=oldfval
									else
										pf^.Value:=0.0;
									GetCellValue(cell,true);
									vrnd:=true;
									cclr:=false
								end
						end
					else
						if TexelApp.IsNumber(intxt,fres,otxt,true) then
							begin
								new(pc);
								if pc<>nil then
									begin
										pc^.Value:=fres;
										pc^.FPts:=oldfpts;
										pc^.Txt:=NewStr(otxt);
										if chgval then
											with cell^.TxtVal do
												begin
													Font:=GetFontIndex;
													Size:=GetFontSize;
													if (oldctyp<>CTYPE_CONST) and (oldctyp<>CTYPE_FORMULA) then Align:=(Align and $f0) or TA_RIGHT;
													Flags:=0
												end;
										cell^.Data.Konst:=pc;
										cell^.Typ:=CTYPE_CONST;
										vrnd:=true
									end
							end
						else
							if TexelApp.IsDate(intxt,fres,otxt,q,sheetbuffer.exceldate=bf_Checked) then
								begin
									new(pc);
									if pc<>nil then
										begin
											pc^.Value:=fres;
											pc^.FPts:=oldfpts;
											pc^.Txt:=NewStr(otxt);
											if chgval then
												with cell^.TxtVal do
													begin
														Font:=GetFontIndex;
														Size:=GetFontSize;
														Flags:=0
													end;
											cell^.Format:=q;
											cell^.Data.Konst:=pc;
											cell^.Typ:=CTYPE_CONST;
											vrnd:=true
										end
								end
							else
								if TexelApp.IsTime(intxt,fres,otxt,q) then
									begin
										new(pc);
										if pc<>nil then
											begin
												pc^.Value:=fres;
												pc^.FPts:=oldfpts;
												pc^.Txt:=NewStr(otxt);
												if chgval then
													with cell^.TxtVal do
														begin
															Font:=GetFontIndex;
															Size:=GetFontSize;
															Flags:=0
														end;
												cell^.Format:=q;
												cell^.Data.Konst:=pc;
												cell^.Typ:=CTYPE_CONST;
												vrnd:=true
											end
									end
								else
									begin
										if errcode<>PERR_OK then
											if intxt[1]='=' then
												if TexelApp.setupbuffer.formerr=bf_Checked then
													begin
														Cell2VRect(r,c,vr);
														if vr.Y=0 then graf_mkstate(vr.X,vr.Y,vr.W,vr.H)
														else
															begin
																inc(vr.X,vr.W shr 1);
																inc(vr.Y,vr.H shr 1)
															end;
														answ[0]:=GO_PRIVATE;
														answ[1]:=Application^.apID;
														answ[2]:=0;
														answ[3]:=GOP_FORMERR;
														answ[4]:=vr.X;
														answ[5]:=vr.Y;
														answ[6]:=errcode;
														answ[7]:=0;
														parserrwin:=@self;
														parserrcell:=cell;
														appl_write(Application^.apID,16,@answ)
													end;
										if chgval then
											with cell^.TxtVal do
												begin
													case intxt[1] of
													'''':
														begin
															Align:=(Align and $f0) or TA_LEFT;
															intxt:=StrPRight(intxt,length(intxt)-1);
															if length(intxt)=0 then goto _weiter
														end;
													'^':
														begin
															Align:=(Align and $f0) or TA_CENTER;
															intxt:=StrPRight(intxt,length(intxt)-1);
															if length(intxt)=0 then goto _weiter
														end;
													'"':
														begin
															Align:=(Align and $f0) or TA_RIGHT;
															intxt:=StrPRight(intxt,length(intxt)-1);
															if length(intxt)=0 then goto _weiter
														end
													end;
													Font:=GetFontIndex;
													Size:=GetFontSize;
													if oldtclip then Flags:=TFL_CLIP
													else
														Flags:=0;
												end;
										cell^.Data.Txt:=NewStr(intxt);
										cell^.Typ:=CTYPE_TEXT;
										_weiter:
										vrnd:=true
									end
				end;
		if inpcancel<>nil then inpcancel^.Hide(true);
		if inpok<>nil then inpok^.Hide(true);
		inpline^.Disable;
		RowsCheckOverflow(r,r,cmin,cmax);
		DrawCells(r,cmin,r,cmax);
		if vrnd then
			begin
				SetDirty;
				AutoCalculate(cclr)
			end
	end;


procedure TCalcWindow.CheckToolbarTextFX(cell: PCell);

	begin
		with cell^ do
			begin
				if TxtVal.Size>0 then
					if pfbox<>nil then
						with PFontBox(pfbox)^ do
							begin
								newsize:=TxtVal.Size;
								SetSelection(FontID2Index(TxtVal.Font),true);
								if newsize>=0 then
									begin
										if fsizebox<>nil then fsizebox^.SetSelection(FontSize2Index(newsize),false);
										newsize:=-1
									end
							end;
				if pcbox<>nil then
					begin
						if Interior=FIS_HOLLOW then pcbox^.SetSelection(White,false)
						else
							pcbox^.SetSelection(Color,false)
					end;
				if ptcbox<>nil then ptcbox^.SetSelection(TxtVal.Color,false);
				if ppbox<>nil then
					begin
						if Interior=FIS_SOLID then ppbox^.SetSelection(7,false)
						else
							if Interior=FIS_HOLLOW then ppbox^.SetSelection(0,false)
							else
								if Style=8 then ppbox^.SetSelection(7,false)
								else
									ppbox^.SetSelection(Style,false)
					end;
				if pfett<>nil then
					begin
						if bTst(TxtVal.Effects,TF_THICKENED) then pfett^.Check
						else
							pfett^.Uncheck
					end;
				if pkursiv<>nil then
					begin
						if bTst(TxtVal.Effects,TF_SLANTED) then pkursiv^.Check
						else
							pkursiv^.Uncheck
					end;
				if punter<>nil then
					begin
						if bTst(TxtVal.Effects,TF_UNDERLINED) then punter^.Check
						else
							punter^.Uncheck
					end;
				case (TxtVal.Align and $0f) of
				TA_CENTER:
					begin
						if palignleft<>nil then palignleft^.Uncheck;
						if paligncenter<>nil then paligncenter^.Check;
						if palignright<>nil then palignright^.Uncheck
					end;
				TA_RIGHT:
					begin
						if palignleft<>nil then palignleft^.Uncheck;
						if paligncenter<>nil then paligncenter^.Uncheck;
						if palignright<>nil then palignright^.Check
					end
				else
					begin
						if palignleft<>nil then palignleft^.Check;
						if paligncenter<>nil then paligncenter^.Uncheck;
						if palignright<>nil then palignright^.Uncheck
					end
				end
			end
	end;


procedure TCalcWindow.SetCursorPos(r,c: integer; scrl: boolean);
	var cell : PCell;
	    r1   : LGRECT;
	    sr   : GRECT;
	    nx,ny: longint;

	begin
		DrawCursor;
		DeselectAll;
		DeselectAllObjects;
		if inpstat then
			begin
				inpstat:=false;
				ChangeCell(GetCell(Parms.Cursor.Row,Parms.Cursor.Col),inpline^.GetText,Parms.Cursor.Row,Parms.Cursor.Col,true)
			end;
		with Parms.Cursor do
			begin
				Block:=false;
				OldRow:=Row;
				OldCol:=Col;
				Row:=r;
				Col:=c
			end;
		SetBlock;
		cell:=GetCell(r,c);
		CheckToolbarTextFX(cell);
		SetInpline(cell);
		if scrl then
			begin
				nx:=Scroller^.XPos;
				ny:=Scroller^.YPos;
				Cell2Rect(r,c,r1);
				GetSheetRect(sr);
				lrc_intersect(r1,sr);
				if r1.W<>sr.W then
					begin
						if r1.X=sr.X then inc(nx,r1.W+1-sr.W)
						else
							inc(nx,r1.X-LeftColWidth-Work.X)
					end;
				if r1.H<>sr.H then
					begin
						if r1.Y=sr.Y then inc(ny,r1.H+1-sr.H)
						else
							inc(ny,r1.Y-PaintOffs-TopRowHeight-Work.Y-1)
					end;
				Scroller^.ScrollTo(nx,ny)
			end;
		with cell^ do Flags:=Flags or CELL_SELECTED;
		DrawCursor
	end;


procedure TCalcWindow.SetBlock;
	var s : string;
	    pw: PWindow;

	begin
		with Parms.Cursor do
			if Block then
				begin
					s:=GetColumnIndex(ColStart)+GetRowIndex(RowStart)+':'+GetColumnIndex(ColEnd)+GetRowIndex(RowEnd);
					if (ColStart=0) and (ColEnd=Parms.Columns) then inscol^.Disable
					else
						inscol^.Enable;
					if (RowStart=0) and (RowEnd=Parms.Rows) then insrow^.Disable
					else
						insrow^.Enable
				end
			else
				begin
					s:=GetColumnIndex(Col)+GetRowIndex(Row);
					inscol^.Enable;
					insrow^.Enable
				end;
		dblock^.SetText(s);
		pw:=ChildList;
		while pw<>nil do
			begin
				if pw^.GetClassName=BLOCKWINDCLASS then
					if pw^.Attr.Status=ws_Open then PBlockChangeDialog(pw)^.BlockChanged(s);
				pw:=pw^.Next
			end
	end;


procedure TCalcWindow.ClearCalcFlags;
	var cell: PCell;
	    q,w : integer;

	begin
		cell:=Sheet;
		for q:=0 to Parms.Rows do
			for w:=0 to Parms.Columns do
				begin
					cell^.Flags:=cell^.Flags and not(CELL_CALCULATED);
					inc(longint(cell),CELLSIZE)
				end
	end;


procedure TCalcWindow.Print;

	begin
		if prnt<>nil then prnt^.Work
	end;


procedure TCalcWindow.SetBorderSize;

	begin
		LeftColWidth:=numWidth*trunc(ln(Parms.Rows+2)/ln(10))+((3*numWidth) shr 1);
		with Attr do
			begin
				TopRowHeight:=boxHeight-1;
				VWork.X1:=LeftColWidth+1;
				VWork.Y1:=TopRowHeight+PaintOffs+1
			end;
		SetScrollerRange
	end;


procedure TCalcWindow.SetScrollerRange;
	var q,w,h: longint;

	begin
		if (Scroller=nil) or (PRow=nil) or (PCol=nil) then exit;
		Scroller^.XLine:=wWidth*atol(TexelApp.setupbuffer.stdcolwidth)+1; { ... }
		Scroller^.YLine:=Attr.boxHeight+1; { ... }
		w:=0;
		for q:=0 to Parms.Columns do inc(w,GetColWidth(q));
		h:=1;
		for q:=0 to Parms.Rows do inc(h,GetRowHeight(q));
		Scroller^.SetPageSize;
		Scroller^.SetRange(w,h)
	end;


procedure TCalcWindow.SetPercentSize(pct: integer);

	begin
		Parms.Percent:=pct;
		PercentSize:=pct/100;
		SetFont(GetStdFontIndex,GetStdFontSize);
		SetBorderSize;
		ForceVRedraw
	end;


function TCalcWindow.ColIndex2Nr(indx: string; clip: boolean): integer;
	var q,c: integer;

	begin
		q:=1;
		while (indx[q] in ['A'..'Z']) and (q<=length(indx)) do inc(q);
		if q=2 then c:=ord(indx[1])-65
		else
			if q=3 then c:=ord(indx[1])*26+ord(indx[2])-1729
			else
				if clip then
					begin
						if q=1 then c:=0
						else
							c:=Parms.Columns
					end
				else
					c:=-1;
		if clip then c:=Min(Max(c,0),Parms.Columns);
		ColIndex2Nr:=c
	end;


function TCalcWindow.GetColumnIndex(Nr: integer): string;

	begin
		if Nr<0 then GetColumnIndex:='?'
		else
			if Nr<26 then GetColumnIndex:=chr(65+Nr)
			else
				GetColumnIndex:=chr(64+(Nr div 26))+chr(65+(Nr mod 26))
	end;


function TCalcWindow.GetColumnName(Nr: integer): string;

	begin
		if PColNames<>nil then
			if PColNames^[Nr]<>nil then
				begin
					GetColumnName:=PString(PColNames^[Nr])^;
					exit
				end;
		GetColumnName:=GetColumnIndex(Nr)
	end;


function TCalcWindow.GetRowIndex(Nr: integer): string;

	begin
		if Nr<0 then GetRowIndex:='0'
		else
			GetRowIndex:=ltoa(Nr+1)
	end;


function TCalcWindow.GetWindowFileName: string;

	begin
		GetWindowFileName:=longfile
	end;


procedure TCalcWindow.SetWindowFileName(s: string);
	var p1,p2: pointer;
      pipe : Pipearray;

	begin
		SetTitle(CompressPath(s,76));
		if TexelApp.abruf<>nil then PAbruf(TexelApp.abruf)^.Add(s,true);
		if (s<>longfile) and (length(longfile)>0) then
			if Application^.OLGAManager>=0 then
				begin
					GlobalAlloc(p1,256);
					GlobalAlloc(p2,256);
					if (p1=nil) or (p2=nil) then
						begin
							GlobalFree(p1,256);
							GlobalFree(p2,256)
						end
					else
						begin
							StrPCopy(p1,longfile);
							StrPCopy(p2,s);
							pipe[0]:=OLGA_RENAME;
							pipe[1]:=Application^.apID;
							pipe[2]:=0;
							pipe[3]:=integer(HiWord(p1));
							pipe[4]:=integer(LoWord(p1));
							pipe[5]:=integer(HiWord(p2));
							pipe[6]:=integer(LoWord(p2));
							pipe[7]:=0;
							appl_write(Application^.OLGAManager,16,@pipe);
							TexelApp.UpdateFile(s,-GetOLGAGroup-1)
						end
				end;
		longfile:=s
	end;


procedure TCalcWindow.SetDirty;

	begin
		if not(Dirty) then
			begin
				SetTitle('* '+GetTitle);
				Dirty:=true;
				if abandon<>nil then
					if length(GetWindowFileName)>0 then abandon^.Enable
			end;
		if preview<>nil then PPreview(preview)^.Update(false)
	end;


procedure TCalcWindow.ClearDirty;
	var s: string;

	begin
		if Dirty then
			begin
				Dirty:=false;
				s:=GetTitle;
				if StrPLeft(s,2)='* ' then SetTitle(StrPRight(s,length(s)-2));
				if abandon<>nil then abandon^.Disable
			end
	end;


procedure TCalcWindow.SetFont(fIndex,fSize: integer);
	var cw,dummy: integer;

	begin
		actFont:=vst_font(vdiHandle,fIndex);
		{$IFDEF NVDI5}
		actPoint:=vst_arbpt(vdiHandle,round(fSize*PercentSize),Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
		{$ELSE}
		if Speedo then actPoint:=vst_arbpt(vdiHandle,round(fSize*PercentSize),Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
		else
			actPoint:=vst_point(vdiHandle,round(fSize*PercentSize),Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
		{$ENDIF}
		if vqt_width(vdiHandle,ord('W'),cw,dummy,dummy)=ord('W') then wWidth:=cw
		else
			wWidth:=Attr.charWidth;
		if vqt_width(vdiHandle,ord('9'),cw,dummy,dummy)=ord('9') then numWidth:=cw
		else
			numWidth:=Attr.charWidth
	end;


function TCalcWindow.GetStdFontIndex: integer;
	var dummy: string;

	begin
		if Fonts=nil then GetStdFontIndex:=vqt_name(vdiHandle,1,dummy)
		else
			if (sheetbuffer.font>=0) and (sheetbuffer.font<Fonts^.Count) then GetStdFontIndex:=PFont(Fonts^.At(sheetbuffer.font))^.index
			else
				GetStdFontIndex:=vqt_name(vdiHandle,1,dummy)
	end;


function TCalcWindow.GetStdFontSize: integer;
	var pf: PFont;

	begin
		if Fonts=nil then GetStdFontSize:=10
		else
			if (sheetbuffer.font<0) or (sheetbuffer.font>=Fonts^.Count) then GetStdFontSize:=10
			else
				begin
					pf:=Fonts^.At(sheetbuffer.font);
					if pf^.SizeCount=0 then GetStdFontSize:=4+sheetbuffer.size
					else
						if (sheetbuffer.size<0) or (sheetbuffer.size>=pf^.SizeCount) then GetStdFontSize:=10
						else
							GetStdFontSize:=pf^.Sizes^[pf^.SizeCount-sheetbuffer.size-1]
				end
	end;


function TCalcWindow.GetFontIndex: integer;

	begin
		TransferData(tf_GetData);
		if Fonts=nil then GetFontIndex:=GetStdFontIndex
		else
			if (dtbuffer.font>=0) and (dtbuffer.font<Fonts^.Count) then GetFontIndex:=PFont(Fonts^.At(dtbuffer.font))^.index
			else
				GetFontIndex:=GetStdFontIndex
	end;


function TCalcWindow.GetFontSize: integer;
	var pf: PFont;

	begin
		TransferData(tf_GetData);
		if Fonts=nil then GetFontSize:=GetStdFontSize
		else
			if (dtbuffer.font<0) or (dtbuffer.font>=Fonts^.Count) then GetFontSize:=GetStdFontSize
			else
				begin
					pf:=Fonts^.At(dtbuffer.font);
					if pf^.SizeCount=0 then GetFontSize:=4+dtbuffer.size
					else
						if (dtbuffer.size<0) or (dtbuffer.size>=pf^.SizeCount) then GetFontSize:=GetStdFontSize
						else
							GetFontSize:=pf^.Sizes^[pf^.SizeCount-dtbuffer.size-1]
				end
	end;


function TCalcWindow.FontID2Index(anid: integer): integer;
	var q: integer;

	begin
		FontID2Index:=0;
		if pfbox=nil then exit;
		if pfbox^.List^.Count>0 then
			begin
				anid:=vst_font(vdiHandle,anid);
				for q:=0 to pfbox^.List^.Count-1 do
					with PFont(pfbox^.List^.At(q))^ do
						if Index=anid then
							begin
								FontID2Index:=q;
								break
							end;
				actFont:=vst_font(vdiHandle,GetStdFontIndex)
			end
	end;


function TCalcWindow.FontSize2Index(asize: integer): integer;
	var pf: PFont;
	    q : integer;

	begin
		FontSize2Index:=0;
		if pfbox=nil then exit;
		pf:=PFont(pfbox^.List^.At(pfbox^.GetSelection));
		if pf^.SizeCount=0 then
			begin
				if asize>127 then asize:=127;
				if asize<4 then asize:=4;
				FontSize2Index:=asize-4
			end
		else
			begin
				for q:=pf^.SizeCount-1 downto 0 do
					if asize<=pf^.Sizes^[q] then
						begin
							if asize=pf^.Sizes^[q] then FontSize2Index:=pf^.SizeCount-q-1
							else
								if q<pf^.SizeCount-1 then FontSize2Index:=pf^.SizeCount-q-2;
							exit
						end;
				FontSize2Index:=pf^.SizeCount-1
			end
	end;


function TCalcWindow.FontChanged(OrgID,AnID,ASize,AColor,BackColor,TheEffects,ARotation,ASkew,HorAlign,VertAlign,AWidth,TrackKern: integer; Size31: fix31; PairKern,cWnd: boolean): boolean;
	var rs,cs,re,ce,
	    cmin,cmax,
	    x,y        : integer;
	    cell       : PCell;

	begin
		inherited FontChanged(OrgID,AnID,ASize,AColor,BackColor,TheEffects,ARotation,ASkew,HorAlign,VertAlign,AWidth,TrackKern,Size31,PairKern,cWnd);
		FontChanged:=true;
		if pfbox=nil then exit;
		pfbox^.SetSelection(FontID2Index(AnID),false);
		if PFontBox(pfbox)^.fsizebox<>nil then PFontBox(pfbox)^.fsizebox^.SetSelection(FontSize2Index(ASize),false);
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
		if VertAlign>=0 then
			case VertAlign of
			TVA_TOP:
				VertAlign:=TA_OBEN;
			TVA_CENTER:
				VertAlign:=TA_MITTE;
			TVA_BOTTOM:
				VertAlign:=TA_UNTEN
			end;
		cmin:=cs;
		cmax:=ce;
		RowsClearOverflow(rs,re,cmin,cmax);
		for y:=rs to re do
			begin
				cell:=GetCell(y,cs);
				for x:=cs to ce do
					begin
						if BackColor>=0 then
							begin
								if BackColor=White then
									begin
										cell^.Color:=Black;
										cell^.Style:=8;
										cell^.Interior:=FIS_HOLLOW
									end
								else
									begin
										cell^.Color:=BackColor;
										if cell^.Interior=FIS_HOLLOW then cell^.Interior:=FIS_SOLID
									end
							end;
						with cell^.TxtVal do
							begin
								if AnID<>0 then Font:=AnID;
								if ASize>0 then Size:=Min(Max(ASize,4),127);
								if AColor>=0 then Color:=AColor;
								if TheEffects>=0 then Effects:=TheEffects;
								if ARotation>=0 then Rotat:=ARotation;
								if ASkew>=-1800 then Skew:=ASkew;
								if HorAlign>=0 then Align:=(Align and $f0) or HorAlign;
								if VertAlign>=0 then Align:=(Align and $0f) or VertAlign
							end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		RowsCheckOverflow(rs,re,cmin,cmax);
		SetDirty;
		DrawCells(rs,cmin,re,cmax)
	end;


function clearufsl: longint;

	begin
		callufsl^.dialtyp:=0;
		callufsl^.helpbutton:=0;
		callufsl^.helpfunc:=0;
		clearufsl:=0
	end;


procedure TCalcWindow.FontSelect;
	var fid,fsize,
	    xhandle,
	    vhandle,
	    dummy,
	    ret       : integer;
	    cell      : PCell;
	    titel     : string;
	    xpar      : xFSL_PAR;
	    fntinf    : FONTINFO;
	    fontname  : array [0..39] of char;

	begin
		cell:=GetCell(Parms.Cursor.Row,Parms.Cursor.Col);
		fid:=cell^.TxtVal.Font;
		fsize:=cell^.TxtVal.Size;
		if fid=0 then fid:=PFont(pfbox^.List^.At(pfbox^.GetSelection))^.Index;
		if fsize=0 then fsize:=atol(PFontBox(pfbox)^.fsizebox^.GetText);
		if fsize<4 then fsize:=10;
		if GetCookie('xFSL',longint(callxfsl)) then
			begin
				if callxfsl=nil then exit;
				titel:=TEXELWINDPREFIX+TITLE_FONTSELECTOR+#0;
				with callxfsl^ do
					begin
						if id='xFSL' then
							if revision>=4 then
								begin
									if IsEmptyCell(cell) then vhandle:=vdiHandle
									else
										vhandle:=0;
									fillchar(xpar,sizeof(xFSL_PAR),0);
									fillchar(fntinf,sizeof(FONTINFO),0);
									with fntinf do
										begin
											fontid:=fid;
											fontsize.size:=fsize;
											fontattr:=cell^.TxtVal.Effects;
											fontskew:=cell^.TxtVal.Skew;
											rotation:=cell^.TxtVal.Rotat;
											fontcol:=cell^.TxtVal.Color;
											if cell^.Interior=FIS_HOLLOW then backcol:=White
											else
												backcol:=cell^.Color;
											halign:=cell^.TxtVal.Align and $0f;
											case (cell^.TxtVal.Align and $f0) of
											TA_OBEN:
												valign:=TVA_TOP;
											TA_UNTEN:
												valign:=TVA_BOTTOM
											else
												valign:=TVA_CENTER
											end
										end;
									xpar.par_size:=sizeof(xFSL_PAR);
									xpar.pfi_size:=sizeof(FONTINFO);
									xpar.control:=CC_FAKESTYLE or CC_NOWIDTH or CC_NOKERN;
									xpar.headline:=@titel[1];
									xpar.fontflags:=FF_ALL;
									fontname[0]:=#0;
									fntinf.fontname:=fontname;
									xpar.font:=@fntinf;
							    xhandle:=xfsl_init(nil,nil,0,0,0,vhandle,@xpar);
							    if xhandle>=0 then
							    	begin
							    		repeat
												ret:=xfsl_event(nil,nil,0,0,0,xhandle,nil)
											until (ret=xFS_OK) or (ret=xFS_STOP);
											xfsl_exit(nil,nil,0,0,0,xhandle);
											if ret=xFS_OK then
												with xpar.font^ do
													FontChanged(Application^.apID,fontid,fontsize.size,fontcol,backcol,fontattr,rotation,fontskew,halign,valign,0,0,0,false,false)
										end
									else
										if xfsl_input(nil,nil,0,0,0,vdiHandle,FF_ALL,@titel[1],fid,fsize)=1 then
											FontChanged(Application^.apID,fid,fsize,-1,-1,-1,-1,-32768,-1,-1,0,0,0,false,false);
									exit
								end
					end
			end;
		if TexelApp.fnt_dialog<>nil then
			with AES_pb do
				begin
					control^[0]:=187;
					control^[1]:=7;
					control^[2]:=8;
					control^[3]:=1;
					control^[4]:=0;
					intin^[0]:=FNTS_SNAME or FNTS_SSTYLE or FNTS_SSIZE or FNTS_CHNAME or FNTS_CHSTYLE or FNTS_CHSIZE;
					intin^[1]:=0;
					intin^[2]:=fid;
					intin^[3]:=fsize;
					intin^[4]:=0;
					intin^[5]:=1;
					intin^[6]:=0;
					addrin^[0]:=TexelApp.fnt_dialog;
					_crystal(@AES_pb);
					if intout^[0]=FNTS_OK then
						begin
							if (intout^[1] and (FNTS_SNAME or FNTS_SSTYLE))>0 then fid:=intout^[3];
							if bTst(intout^[1],FNTS_SSIZE) then fsize:=intout^[4];
							FontChanged(Application^.apID,fid,fsize,-1,-1,-1,-1,-32768,-1,-1,0,0,0,false,false)
						end;
					with Application^ do
						begin
							SetSystemFont(vdiHandle,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
							vst_alignment(vdiHandle,TA_LEFT,TA_BASELINE,dummy,dummy);
							vswr_mode(vdiHandle,MD_REPLACE);
							vsl_type(vdihandle,LT_SOLID);
							vsf_perimeter(vdiHandle,PER_ON);
							vsl_color(vdiHandle,Black);
							vsl_ends(vdiHandle,LE_SQUARED,LE_SQUARED);
							vsm_type(vdiHandle,MT_DOT);
							vsm_color(vdiHandle,Black);
							vst_rotation(vdiHandle,0);
							vsf_color(vdiHandle,Black);
							vst_color(vdiHandle,Black);
							vst_effects(vdiHandle,TF_NORMAL);
							vsl_udsty(vdiHandle,$5555);
							vsf_interior(vdiHandle,FIS_HOLLOW);
							vsf_style(vdiHandle,4);
							vsm_height(vdiHandle,1);
							{$IFNDEF NVDI5}
							if SpeedoActive then
							{$ENDIF}
								vst_skew(vdiHandle,0);
							vs_clip(vdiHandle,CLIP_ON,SysInfo.Desktop.A2)
						end;
					exit
				end;
		if GetCookie('UFSL',longint(callufsl)) then
			if callufsl<>nil then
				begin
					supexec(clearufsl);
					with callufsl^ do
						begin
							font_selinit(nil,nil,0,0,0);
							if font_selinput(nil,nil,0,0,0,vdiHandle,Attr.sysFonts+Attr.addFonts,nil,0,fid,fsize)=1 then
								FontChanged(Application^.apID,fid,fsize,-1,-1,-1,-1,-32768,-1,-1,0,0,0,false,false)
						end
				end
	end;


procedure TCalcWindow.Cut;
	var p: PEmbedded;
	    q: integer;

	begin
		if inpstat then inherited Cut
		else
			begin
				p:=FirstSelectedObject;
				if p<>nil then
					begin
						q:=Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_CUT,BUTTON_OBJCELLCANCEL);
						if q=1 then p^.Cut;
						if q<>2 then exit
					end;
				CutCells
			end
	end;


procedure TCalcWindow.Copy;
	var p: PEmbedded;
	    q: integer;

	begin
		if inpstat then inherited Copy
		else
			begin
				p:=FirstSelectedObject;
				if p<>nil then
					begin
						q:=Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_COPY,BUTTON_OBJCELLCANCEL);
						if q=1 then p^.Copy;
						if q<>2 then exit
					end;
				CopyCells
			end
	end;


procedure TCalcWindow.Paste;

	begin
		if inpstat then inherited Paste
		else
			if not(PasteObject) then PasteCells
	end;


procedure TCalcWindow.Delete;
	var p: PEmbedded;
	    q: integer;

	begin
		if inpstat then inherited Delete
		else
			begin
				p:=FirstSelectedObject;
				if p<>nil then
					begin
						q:=Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_DELETE,BUTTON_OBJCELLCANCEL);
						if q=1 then p^.Destroy;
						if q<>2 then exit
					end;
				if clrinh<>nil then clrinh^.HandleMenu(2)
			end
	end;


procedure TCalcWindow.CutCells;

	begin
		CopyCells;
		DeleteCells
	end;


procedure TCalcWindow.CopyCells;
	label _raus,_fehler;

	var header : TTexelHeader;
	    bheader: TBlockHeader;
      buf    : PByteArray;
      res,q,
      dummy,
      lctrl,
      bufsize,
      bufcnt : longint;
      nctrl,
      rs,cs,
      re,ce,
      x,y,
      hdl    : integer;
      rval   : real;
      oldflg,
      l      : byte;
      ret,
      werror : boolean;
      coffs  : word;
      pp     : PParameter;
      pfm    : PFormat;
      cell   : PCell;
      dtxt   : string;

	function bwrite(var buffer; count: longint): boolean;
		var rlen: longint;

		begin
			if count>bufsize then
				begin
					werror:=true;
					bwrite:=true;
					exit
				end;
			bwrite:=false;
			if count<1 then
				begin
					if count=0 then exit;
					if bufcnt>0 then
						begin
							rlen:=fwrite(hdl,bufcnt,buf);
							if rlen<>bufcnt then
								begin
									werror:=true;
									bwrite:=true
								end;
							bufcnt:=0
						end;
					exit
				end;
			if bufcnt+count>bufsize then
				begin
					rlen:=fwrite(hdl,bufcnt,buf);
					if rlen<>bufcnt then
						begin
							werror:=true;
							bwrite:=true
						end;
					bufcnt:=0
				end;
			system.move(buffer,buf^[bufcnt],count);
			inc(bufcnt,count)
		end;

	function savetree(pn: PNode): boolean;
		var q: integer;

		begin
			savetree:=true;
			if pn=nil then
				begin
					if bwrite(nctrl,2) then exit
				end
			else
				begin
					if bwrite(pn^.Typ,2) then exit;
					if pn^.Typ>=5000 then
						begin
							if pn^.Left.List=nil then
								begin
									if bwrite(lctrl,4) then exit
								end
							else
								begin
									if bwrite(pn^.Count,4) then exit;
									for q:=0 to pn^.Count-1 do
										if savetree(pn^.Left.List^[q]) then exit
								end
						end
					else
						if pn^.Typ>=1000 then
							begin
								if savetree(pn^.Left.Node) then exit;
								if savetree(pn^.Right.Node) then exit
							end
						else
							case pn^.Typ of
							NT_NAT_NEGATE,
							NT_NEGATE,
							NT_PERCENT,
							NT_KLAMMER:
								if savetree(pn^.Left.Node) then exit;
							NT_MINUS,
							NT_MULT,
							NT_DIV,
							NT_POWER,
							NT_EQUAL,
							NT_GREATER,
							NT_LESS,
							NT_GREATEREQUAL,
							NT_LESSEQUAL,
							NT_UNEQUAL,
							NT_NAT_PLUS,
							NT_NAT_MINUS,
							NT_NAT_MULT,
							NT_NAT_DIV,
							NT_NAT_POWER,
							NT_PLUS:
								begin
									if savetree(pn^.Left.Node) then exit;
									if savetree(pn^.Right.Node) then exit
								end;
							NT_CELL:
								begin
									if bwrite(pn^.All,4) then exit;
									if bwrite(pn^.Right.Flg,2) then exit
								end;
							NT_RANGE:
								begin
									if bwrite(pn^.Left.All,4) then exit;
									if bwrite(pn^.Right.All,4) then exit;
									if bwrite(pn^.All,4) then exit
								end;
							NT_VARIABLE:
								if bwrite(pn^.Varb^,length(pn^.Varb^)+1) then exit;
							NT_STRING:
								begin
									dtxt:=StrPPas(pn^.Chars);
									if bwrite(dtxt,length(dtxt)+1) then exit;
								end;
							NT_CONST:
								begin
									rval:=pn^.Num^;
									if bwrite(rval,sizeof(real)) then exit;
									if pn^.Left.Txt=nil then
										begin
											l:=0;
											if bwrite(l,1) then exit
										end
									else
										if bwrite(pn^.Left.Txt^,length(pn^.Left.Txt^)+1) then exit
								end
							end
				end;
			savetree:=false
		end;

	function writecell: boolean;
	
		begin
			writecell:=true;
			if bwrite(cell^.Flags,CELLSIZE-4) then exit;
			case cell^.Typ of
			CTYPE_TEXT:
				if bwrite(cell^.Data.Txt^,length(cell^.Data.Txt^)+1) then exit;
			CTYPE_CONST:
				with cell^.Data.Konst^ do
					begin
						rval:=Value;
						if bwrite(rval,sizeof(real)) then exit;
						if bwrite(Txt^,length(Txt^)+1) then exit;
						if bwrite(FPts,1) then exit
					end;
			CTYPE_FORMULA:
				with cell^.Data.Formula^ do
					begin
						rval:=Value;
						if bwrite(rval,sizeof(real)) then exit;
						if bwrite(FPts,1) then exit;
						if bwrite(Error,1) then exit;
						if savetree(Func) then exit;
						if VarDef=nil then
							begin
								l:=0;
								if bwrite(l,1) then exit
							end
						else
							if bwrite(VarDef^,length(VarDef^)+1) then exit;
					end
			end;
			writecell:=false
		end;

	begin
		if Clipboard=nil then exit;
		with Clipboard^ do
			begin
				if not(OpenClipboard(true)) then exit;
				buf:=GetMemBuffer(131072,512,bufsize);
				if buf=nil then goto _raus;
				werror:=false;
				res:=fcreate(GetClipboardFilename+TEXELEXTENSION,0);
				if res<0 then goto _raus;
				hdl:=integer(res);
				bufcnt:=0;
				nctrl:=NT_ENDOFDATA;
				lctrl:=NT_LIST_EMPTY;
				with header do
					begin
						Magic:=TEXELMAGIC;
						Version:=TEXELVER;
						Compatible:=TEXELCOMPAT;
						PackAlgo:=PA_BLOCK;
						Resvd1:=0;
						Resvd2:=0;
						Resvd3:=0;
						Resvd4:=0
					end;
				header.Release:=RELEASE;
				if bwrite(header,sizeof(TTexelHeader)) then goto _fehler;
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
				with bheader do
					begin
						Width:=ce-cs;
						Height:=re-rs;
						ColOffs:=cs;
						RowOffs:=rs;
						Resvd0:=0;
						Resvd1:=0;
						Resvd2:=0;
						Resvd3:=0;
						Resvd4:=0
					end;
				if bwrite(bheader,sizeof(TBlockHeader)) then goto _fehler;
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								oldflg:=cell^.Flags;
								cell^.Flags:=cell^.Flags and CELL_EMPTYMASK;
								ret:=writecell;
								cell^.Flags:=oldflg;
								if ret then goto _fehler;
								inc(longint(cell),CELLSIZE)
							end
					end;
				if Parameter<>nil then coffs:=Parameter^.Count
				else
					coffs:=0;
				if bwrite(coffs,2) then goto _fehler;
				l:=0;
				if coffs>0 then
					for q:=0 to coffs-1 do
						begin
							pp:=Parameter^.At(q);
							if pp^.Name<>nil then
								begin
									if bwrite(pp^.Name^,length(pp^.Name^)+1) then goto _fehler
								end
							else
								if bwrite(l,1) then goto _fehler;
							if pp^.Txt<>nil then
								begin
									if bwrite(pp^.Txt^,length(pp^.Txt^)+1) then goto _fehler
								end
							else
								if bwrite(l,1) then goto _fehler;
							if pp^.Descr<>nil then
								begin
									if bwrite(pp^.Descr^,length(pp^.Descr^)+1) then goto _fehler
								end
							else
								if bwrite(l,1) then goto _fehler
						end;
				if UsrFormats<>nil then coffs:=UsrFormats^.Count
				else
					coffs:=0;
				if bwrite(coffs,2) then goto _fehler;
				l:=0;
				if coffs>0 then
					for q:=0 to coffs-1 do
						begin
							pfm:=UsrFormats^.At(q);
							if bwrite(pfm^.Index,2) then goto _fehler;
							if pfm^.Name<>nil then
								begin
									if bwrite(pfm^.Name^,length(pfm^.Name^)+1) then goto _fehler
								end
							else
								if bwrite(l,1) then goto _fehler
						end;
				coffs:=0;
				if bwrite(coffs,2) then goto _fehler;
				if bwrite(coffs,2) then goto _fehler;
				bwrite(dummy,-1);
				_fehler:
				fclose(hdl);
				if werror then fdelete(GetClipboardFilename+TEXELEXTENSION)
				else
					SetClipboardFormat(SCF_SHEET,'.'+TEXELEXTENSION);
				_raus:
				{ andere Formate? ... }
				if buf<>nil then freemem(buf,bufsize);
				CloseClipboard
			end
	end;


procedure TCalcWindow.PasteCells;

	begin
		InsertFromClipboard(INS_FORMULA,INS_OP_NONE,false,false,false,true)
	end;


procedure TCalcWindow.InsertFromClipboard(what,op: integer; empty,transpose,report,copyalign: boolean);
	label _raus,_fehler;

	var ttxt,
	    utxt,
	    tname,
	    ptxt,
	    tdescr  : string;
	    header  : TTexelHeader;
	    bheader : TBlockHeader;
	    oldfpos,
	    res,q   : longint;
	    cmin,
	    cmax,
	    x,y,i,e,
	    rs,cs,
	    re,ce,
	    crr,crc,
	    errcode,
	    hdl,w   : integer;
	    coffs   : word;
	    cell    : PCell;
	    dcell   : TCell;
	    ocleared,
	    lossy,
	    vrnd,
	    vorh,
	    rerror  : boolean;
	    l,fpt,
	    err     : byte;
	    rtrval,
	    rval    : real;
	    pp      : PParameter;

	function bread(var buffer; count: longint): boolean;
		var len: longint;

		begin
			if fread(hdl,count,@buffer)=count then bread:=false
			else
				begin
					rerror:=true;
					bread:=true
				end
		end;

	function readtree(var node: PNode; alloc: boolean): boolean;
		var op,q : integer;
		    dummy: longint;

		begin
			readtree:=true;
			node:=nil;
			if bread(op,2) then exit;
			if op<>NT_ENDOFDATA then
				begin
					if alloc then
						begin
							if not(NewNode(node)) then exit;
							node^.Typ:=op
						end;
					if op>=5000 then
						begin
							if alloc then
								begin
									if bread(node^.Count,4) then exit;
									if node^.Count<>NT_LIST_EMPTY then
										begin
											getmem(node^.Left.List,node^.Count shl 2);
											if node^.Left.List=nil then exit;
											for q:=0 to node^.Count-1 do
												if readtree(PNode(node^.Left.List^[q]),true) then exit
										end
								end
							else
								begin
									if bread(dummy,4) then exit;
									if dummy<>NT_LIST_EMPTY then
										for q:=0 to dummy-1 do
											if readtree(node,false) then exit;
								end
						end
					else
						if op>=1000 then
							begin
								if alloc then
									begin
										if readtree(node^.Left.Node,true) then exit;
										if readtree(node^.Right.Node,true) then exit
									end
								else
									begin
										if readtree(node,false) then exit;
										if readtree(node,false) then exit
									end
							end
						else
							case op of
							NT_NAT_NEGATE,
							NT_NEGATE,
							NT_PERCENT,
							NT_KLAMMER:
								begin
									if alloc then
										begin
											if readtree(node^.Left.Node,true) then exit;
										end
									else
										if readtree(node,false) then exit;
								end;
							NT_MINUS,
							NT_MULT,
							NT_DIV,
							NT_POWER,
							NT_EQUAL,
							NT_GREATER,
							NT_LESS,
							NT_GREATEREQUAL,
							NT_LESSEQUAL,
							NT_UNEQUAL,
							NT_NAT_PLUS,
							NT_NAT_MINUS,
							NT_NAT_MULT,
							NT_NAT_DIV,
							NT_NAT_POWER,
							NT_PLUS:
								begin
									if alloc then
										begin
											if readtree(node^.Left.Node,true) then exit;
											if readtree(node^.Right.Node,true) then exit
										end
									else
										begin
											if readtree(node,false) then exit;
											if readtree(node,false) then exit
										end
								end;
							NT_CELL:
								begin
									if alloc then
										begin
											if bread(node^.All,4) then exit;
											if bread(node^.Right.Flg,2) then exit
										end
									else
										begin
											if bread(dummy,4) then exit;
											if bread(dummy,2) then exit
										end
								end;
							NT_RANGE:
								begin
									if alloc then
										begin
											if bread(node^.Left.All,4) then exit;
											if bread(node^.Right.All,4) then exit;
											if bread(node^.All,4) then exit
										end
									else
										begin
											if bread(dummy,4) then exit;
											if bread(dummy,4) then exit;
											if bread(dummy,4) then exit
										end
								end;
							NT_VARIABLE:
								begin
									if bread(l,1) then exit;
									if l>0 then
										begin
											if bread(ttxt[1],l) then exit;
											ttxt[0]:=chr(l);
											if alloc then node^.Varb:=NewStr(ttxt)
										end
								end;
							NT_STRING:
								begin
									if bread(l,1) then exit;
									if l>0 then
										if bread(ttxt[1],l) then exit;
									ttxt[0]:=chr(l);
									if alloc then node^.Chars:=ChrNew(ttxt)
								end;
							NT_CONST:
								begin
									if bread(rtrval,sizeof(real)) then exit;
									if alloc then
										begin
											new(node^.Num);
											if node^.Num=nil then exit;
											node^.Num^:=rtrval
										end;
									if bread(l,1) then exit;
									if l>0 then
										begin
											if bread(ttxt[1],l) then exit;
											ttxt[0]:=chr(l);
											if alloc then node^.Left.Txt:=NewStr(ttxt)
										end
								end
							end
				end;
			readtree:=false
		end;

	function readcell(xabs,yabs: integer; alloc: boolean): boolean;
		var nfunc: PNode;

		procedure changecell;

			begin
				vrnd:=true;
				FreeCell(cell,false);
				cell^.Flags:=dcell.Flags or CELL_CHANGED;
				cell^.Format:=dcell.Format
			end;

		procedure setvrnd;

			begin
				vrnd:=true;
				cell^.Flags:=cell^.Flags or CELL_CHANGED
			end;

		procedure constcell(rval: TNumber; ttxt: string);

			begin
				changecell;
				new(cell^.Data.Konst);
				if cell^.Data.Konst<>nil then
					begin
						cell^.Typ:=CTYPE_CONST;
						with cell^.Data.Konst^ do
							begin
								Value:=rval;
								if length(ttxt)=0 then Val2Txt(rval,ttxt,MAXCIPHERS,0,nil);
								Txt:=NewStr(ttxt);
								FPts:=fpt
							end
					end
			end;

		procedure checkfont;

			begin
				if not(bTst(what,INS_FORMAT)) then
					with cell^.TxtVal do
						begin
							if Font=0 then Font:=GetFontIndex;
							if Size=0 then Size:=GetFontSize
						end;
			end;
		
		function emptycelldivnode: boolean;

			begin
				emptycelldivnode:=true;
				changecell;
				new(cell^.Data.Formula);
				if cell^.Data.Formula<>nil then
					begin
						with cell^.Data.Formula^ do
							begin
								Value:=rval;
								FPts:=fpt;
								Error:=FE_OK;
								VarDef:=nil;
								if NewNode(Func) then Func^.Typ:=NT_DIV
								else
									begin
										dispose(cell^.Data.Formula);
										exit
									end
							end;
						cell^.Typ:=CTYPE_FORMULA;
						emptycelldivnode:=false
					end
			end;

		function constnode(var pn: PNode; num: TNumber; nums: string): boolean;

			begin
				constnode:=true;
				if not(NewNode(pn)) then exit;
				new(pn^.Num);
				if pn^.Num=nil then exit;
				pn^.Num^:=num;
				if length(nums)>0 then pn^.Left.Txt:=NewStr(nums);
				pn^.Typ:=NT_CONST;
				constnode:=false
			end;

		function klammernode(var pn: PNode; ln: PNode): boolean;

			begin
				klammernode:=true;
				if not(NewNode(pn)) then exit;
				pn^.Typ:=NT_KLAMMER;
				pn^.Left.Node:=ln;
				klammernode:=false
			end;

		function opnode(op: integer; var pn: PNode; rn: PNode): boolean;
			var nn: PNode;

			begin
				opnode:=true;
				if klammernode(pn,pn) then exit;
				if not(NewNode(nn)) then exit;
				nn^.Typ:=op;
				nn^.Left.Node:=pn;
				nn^.Right.Node:=rn;
				pn:=nn;
				opnode:=false
			end;
		
		function funcnode(op: integer; var pn,rn: PNode): boolean;
			var nn: PNode;

			begin
				funcnode:=true;
				if klammernode(pn,pn) then exit;
				if klammernode(rn,rn) then exit;
				if not(NewNode(nn)) then exit;
				nn^.Typ:=op;
				nn^.Left.Node:=pn;
				nn^.Right.Node:=rn;
				pn:=nn;
				funcnode:=false
			end;
		
		function constopnode(op: integer; var pn: PNode; num: TNumber; nums: string): boolean;
			var nn: PNode;
		
			begin
				constopnode:=true;
				if klammernode(pn,pn) then exit;
				if not(NewNode(nn)) then exit;
				nn^.Typ:=op;
				nn^.Right.Node:=pn;
				pn:=nn;
				if constnode(nn^.Left.Node,num,nums) then exit;
				constopnode:=false
			end;

		function formcellnop(pn: PNode; const vdef: string): boolean;
			var q   : integer;
			    vorh: boolean;

			begin
				formcellnop:=true;
				if pn=nil then exit;
				changecell;
				new(cell^.Data.Formula);
				if cell^.Data.Formula<>nil then
					begin
						with cell^.Data.Formula^ do
							begin
								Value:=rval;
								FPts:=fpt;
								Error:=FE_OK;
								Func:=pn;
								VarDef:=nil
							end;
						if length(vdef)>0 then
							begin
								vorh:=false;
								if Variables<>nil then
									if Variables^.Count>0 then
										begin
											ptxt:=StrPUpper(vdef);
											for q:=0 to Variables^.Count-1 do
												if ptxt=StrPUpper(PVariable(Variables^.At(q))^.Name^) then
													begin
														vorh:=true;
														break
													end
										end;
								if not(vorh) then
									begin
										cell^.Data.Formula^.VarDef:=NewStr(vdef);
										if cell^.Data.Formula^.VarDef<>nil then NewVariable(yabs,xabs,vdef);
									end
							end;
						cell^.Typ:=CTYPE_FORMULA;
						formcellnop:=false
					end
			end;

		begin
			readcell:=true;
			if bread(dcell.Flags,CELLSIZE-4) then exit;
			if alloc then
				begin
					dcell.Flags:=(dcell.Flags and CELL_EMPTYMASK) or (cell^.Flags and CELL_SELECTED);
					dcell.TxtVal.Flags:=dcell.TxtVal.Flags and not(TFL_OVERFLOWMASK);
					if bTst(what,INS_FORMAT) then
						begin
							vrnd:=true;
							cell^.Color:=dcell.Color;
							cell^.Style:=dcell.Style;
							cell^.Interior:=dcell.Interior;
							cell^.Resvd:=dcell.Resvd;
							cell^.Border:=dcell.Border;
							cell^.TxtVal:=dcell.TxtVal
						end
					else
						if copyalign then cell^.TxtVal.Align:=dcell.TxtVal.Align
				end;
			case dcell.Typ of
			CTYPE_TEXT:
				begin
					if bread(l,1) then exit;
					if l>0 then
						begin
							if bread(ttxt[1],l) then exit;
							ttxt[0]:=chr(l);
							if alloc then
								if (what and (INS_FORMULA or INS_VALUE))>0 then
									if (op=INS_OP_NONE) or (cell^.Typ=CTYPE_EMPTY) or (cell^.Typ=CTYPE_TEXT) then
										begin
											if cell^.Typ=CTYPE_EMPTY then checkfont;
											changecell;
											cell^.Data.Txt:=NewStr(ttxt);
											if cell^.Data.Txt<>nil then cell^.Typ:=CTYPE_TEXT
										end
						end
				end;
			CTYPE_CONST:
				begin
					if bread(rval,sizeof(real)) then exit;
					if bread(l,1) then exit;
					if l>0 then
						if bread(ttxt[1],l) then exit;
					ttxt[0]:=chr(l);
					if bread(fpt,1) then exit;
					if alloc then
						if (what and (INS_FORMULA or INS_VALUE))>0 then
							begin
								if op=INS_OP_NONE then
									begin
										if cell^.Typ=CTYPE_EMPTY then checkfont;
										constcell(rval,ttxt)
									end
								{$IFNDEF LITE}
								else
									case cell^.Typ of
									CTYPE_EMPTY:
										begin
											checkfont;
											if op=INS_OP_ADD then constcell(rval,ttxt)
											else
												if op=INS_OP_SUB then constcell(-rval,'')
										end;
									CTYPE_CONST:
										case op of
										INS_OP_ADD:
											constcell(cell^.Data.Konst^.Value+rval,'');
										INS_OP_SUB:
											constcell(cell^.Data.Konst^.Value-rval,'');
										INS_OP_MUL:
											constcell(cell^.Data.Konst^.Value*rval,'');
										INS_OP_DIV:
											if rval=0.0 then
												begin
													rval:=cell^.Data.Konst^.Value;
													if emptycelldivnode then exit;
													if constnode(cell^.Data.Formula^.Func^.Left.Node,rval,'') then exit;
													if constnode(cell^.Data.Formula^.Func^.Right.Node,0.0,'0') then exit;
												end
											else
												constcell(cell^.Data.Konst^.Value/rval,'')
										end;
									CTYPE_FORMULA:
										case op of
										INS_OP_ADD:
											begin
												if opnode(NT_PLUS,cell^.Data.Formula^.Func,nil) then exit;
												if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
												setvrnd
											end;
										INS_OP_SUB:
											begin
												if opnode(NT_MINUS,cell^.Data.Formula^.Func,nil) then exit;
												if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
												setvrnd
											end;
										INS_OP_MUL:
											begin
												if opnode(NT_MULT,cell^.Data.Formula^.Func,nil) then exit;
												if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
												setvrnd
											end;
										INS_OP_DIV:
											begin
												if opnode(NT_DIV,cell^.Data.Formula^.Func,nil) then exit;
												if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
												setvrnd
											end
										end
									end
								{$ENDIF}
							end
				end;
			CTYPE_FORMULA:
				begin
					if bread(rval,sizeof(real)) then exit;
					if bread(fpt,1) then exit;
					if bread(err,1) then exit;
					if readtree(nfunc,alloc) then exit;
					if bread(l,1) then exit;
					if l>0 then
						if bread(ttxt[1],l) then exit;
					ttxt[0]:=chr(l);
					if alloc then
						begin
							if bTst(what,INS_FORMULA) then
								begin
									if op=INS_OP_NONE then
										begin
											if cell^.Typ=CTYPE_EMPTY then checkfont;
											if formcellnop(nfunc,ttxt) then exit;
										end
									{$IFNDEF LITE}
									else
										case cell^.Typ of
										CTYPE_EMPTY:
											begin
												checkfont;
												if op=INS_OP_ADD then
													begin
														if formcellnop(nfunc,'') then exit;
													end
												else
													if op=INS_OP_SUB then
														begin
															if opnode(NT_NEGATE,nfunc,nil) then exit;
															if formcellnop(nfunc,'') then exit;
														end
											end;
										CTYPE_CONST:
											case op of
											INS_OP_ADD:
												begin
													if constopnode(NT_PLUS,nfunc,cell^.Data.Konst^.Value,cell^.Data.Konst^.Txt^) then exit;
													if formcellnop(nfunc,'') then exit;
												end;
											INS_OP_SUB:
												begin
													if constopnode(NT_MINUS,nfunc,cell^.Data.Konst^.Value,cell^.Data.Konst^.Txt^) then exit;
													if formcellnop(nfunc,'') then exit;
												end;
											INS_OP_MUL:
												begin
													if constopnode(NT_MULT,nfunc,cell^.Data.Konst^.Value,cell^.Data.Konst^.Txt^) then exit;
													if formcellnop(nfunc,'') then exit;
												end;
											INS_OP_DIV:
												begin
													if constopnode(NT_DIV,nfunc,cell^.Data.Konst^.Value,cell^.Data.Konst^.Txt^) then exit;
													if formcellnop(nfunc,'') then exit;
												end;
											end;
										CTYPE_FORMULA:
											case op of
											INS_OP_ADD:
												begin
													if funcnode(NT_PLUS,cell^.Data.Formula^.Func,nfunc) then exit;
													setvrnd
												end;
											INS_OP_SUB:
												begin
													if funcnode(NT_MINUS,cell^.Data.Formula^.Func,nfunc) then exit;
													setvrnd
												end;
											INS_OP_MUL:
												begin
													if funcnode(NT_MULT,cell^.Data.Formula^.Func,nfunc) then exit;
													setvrnd
												end;
											INS_OP_DIV:
												begin
													if funcnode(NT_DIV,cell^.Data.Formula^.Func,nfunc) then exit;
													setvrnd
												end
											end
										end
									{$ENDIF}
								end
							else
								if bTst(what,INS_VALUE) then
									begin
										if op=INS_OP_NONE then
											begin
												if cell^.Typ=CTYPE_EMPTY then checkfont;
												constcell(rval,'')
											end
										{$IFNDEF LITE}
										else
											case cell^.Typ of
											CTYPE_EMPTY:
												begin
													checkfont;
													if op=INS_OP_ADD then constcell(rval,'')
													else
														if op=INS_OP_SUB then constcell(-rval,'')
												end;
											CTYPE_CONST:
												case op of
												INS_OP_ADD:
													constcell(cell^.Data.Konst^.Value+rval,'');
												INS_OP_SUB:
													constcell(cell^.Data.Konst^.Value-rval,'');
												INS_OP_MUL:
													constcell(cell^.Data.Konst^.Value*rval,'');
												INS_OP_DIV:
													if rval=0.0 then
														begin
															rval:=cell^.Data.Konst^.Value;
															if emptycelldivnode then exit;
															if constnode(cell^.Data.Formula^.Func^.Left.Node,rval,'') then exit;
															if constnode(cell^.Data.Formula^.Func^.Right.Node,0.0,'0') then exit;
														end
													else
														constcell(cell^.Data.Konst^.Value/rval,'')
												end;
											CTYPE_FORMULA:
												case op of
												INS_OP_ADD:
													begin
														Val2Txt(rval,ttxt,MAXCIPHERS,0,nil);
														if opnode(NT_PLUS,cell^.Data.Formula^.Func,nil) then exit;
														if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
														setvrnd
													end;
												INS_OP_SUB:
													begin
														Val2Txt(rval,ttxt,MAXCIPHERS,0,nil);
														if opnode(NT_MINUS,cell^.Data.Formula^.Func,nil) then exit;
														if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
														setvrnd
													end;
												INS_OP_MUL:
													begin
														Val2Txt(rval,ttxt,MAXCIPHERS,0,nil);
														if opnode(NT_MULT,cell^.Data.Formula^.Func,nil) then exit;
														if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
														setvrnd
													end;
												INS_OP_DIV:
													begin
														Val2Txt(rval,ttxt,MAXCIPHERS,0,nil);
														if opnode(NT_DIV,cell^.Data.Formula^.Func,nil) then exit;
														if constnode(cell^.Data.Formula^.Func^.Right.Node,rval,ttxt) then exit;
														setvrnd
													end
												end
											end
										{$ENDIF}
									end
						end
				end
			else
				if not(empty) then
					if alloc then
						if (op=INS_OP_NONE) or (cell^.Typ=CTYPE_EMPTY) or (cell^.Typ=CTYPE_TEXT) then changecell
			end;
			readcell:=false
		end;

	procedure XChangeFormat(alt,neu: integer);
		var x,y : integer;
		    cell: PCell;

		begin
			if alt<>neu then
				for y:=rs to re do
					begin
						cell:=GetCell(y,cs);
						for x:=cs to ce do
							begin
								if bTst(cell^.Flags,CELL_CHANGED) then
									if cell^.Format=alt then cell^.Format:=neu;
								inc(longint(cell),CELLSIZE)
							end
					end
		end;

	begin
		if Clipboard=nil then exit;
		vrnd:=false;
		ocleared:=false;
		{$IFDEF LITE}
		op:=INS_OP_NONE;
		transpose:=false;
		{$ENDIF}
		with Clipboard^ do
			begin
				if not(OpenClipboard(false)) then exit;
				ttxt:=GetPriorityClipboardFormat(TEXELEXTENSION+'.dif.csv');
				if ttxt=TEXELEXTENSION then
					begin
						rerror:=false;
						res:=fopen(GetClipboardFilename+TEXELEXTENSION,FO_READ);
						if res<0 then goto _raus;
						hdl:=integer(res);
						if bread(header,sizeof(TTexelHeader)) then goto _fehler;
						with header do
							if Magic<>TEXELMAGIC then goto _fehler
							else
								if Compatible<>TEXELCOMPAT then goto _fehler
								else
									if PackAlgo<>PA_BLOCK then goto _fehler;
						if bread(bheader,sizeof(TBlockHeader)) then goto _fehler;
						lossy:=false;
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
									ce:=Col;
									{$IFNDEF LITE}
									if transpose then
										begin
											if bheader.Width>0 then
												begin
													re:=Min(rs+bheader.Width,Parms.Rows);
													if rs+bheader.Width>Parms.Rows then lossy:=true
												end;
											if bheader.Height>0 then
												begin
													ce:=Min(cs+bheader.Height,Parms.Columns);
													if cs+bheader.Height>Parms.Columns then lossy:=true
												end
										end
									else
									{$ENDIF}
										begin
											if bheader.Width>0 then
												begin
													ce:=Min(cs+bheader.Width,Parms.Columns);
													if cs+bheader.Width>Parms.Columns then lossy:=true
												end;
											if bheader.Height>0 then
												begin
													re:=Min(rs+bheader.Height,Parms.Rows);
													if rs+bheader.Height>Parms.Rows then lossy:=true
												end
										end
								end;
						if lossy then
							if Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_CCPCOPY,BUTTON_GOCANCEL)<>1 then goto _fehler;
						if op=INS_OP_NONE then
							if IsBlockUsed(rs,cs,re,ce,1) then goto _fehler;
						cmin:=cs;
						cmax:=ce;
						RowsClearOverflow(rs,re,cmin,cmax);
						ocleared:=true;
						{$IFNDEF LITE}
						if transpose then
							for x:=cs to cs+bheader.Height do
								begin
									if x>ce then
										begin
											for y:=0 to bheader.Width do if readcell(0,0,false) then goto _fehler
										end
									else
										begin
											for y:=rs to rs+bheader.Width do
												if y>re then
													begin
														if readcell(0,0,false) then goto _fehler
													end
												else
													begin
														oldfpos:=fseek(0,hdl,1);
														if oldfpos<0 then goto _fehler;
														crc:=x;
														while crc<=ce do
															begin
																crr:=y;
																while crr<=re do
																	begin
																		if fseek(oldfpos,hdl,0)<0 then goto _fehler;
																		cell:=GetCell(crr,crc);
																		if readcell(crc,crr,true) then goto _fehler;
																		inc(crr,bheader.Width+1);
																	end;
																inc(crc,bheader.Height+1);
															end
													end
										end
								end
						else
						{$ENDIF}
							for y:=rs to rs+bheader.Height do
								begin
									if y>re then
										begin
											for x:=0 to bheader.Width do if readcell(0,0,false) then goto _fehler
										end
									else
										begin
											for x:=cs to cs+bheader.Width do
												if x>ce then
													begin
														if readcell(0,0,false) then goto _fehler
													end
												else
													begin
														oldfpos:=fseek(0,hdl,1);
														if oldfpos<0 then goto _fehler;
														crr:=y;
														while crr<=re do
															begin
																crc:=x;
																while crc<=ce do
																	begin
																		if fseek(oldfpos,hdl,0)<0 then goto _fehler;
																		cell:=GetCell(crr,crc);
																		if readcell(crc,crr,true) then goto _fehler;
																		inc(crc,bheader.Width+1);
																	end;
																inc(crr,bheader.Height+1);
															end
													end
										end
								end;
						if bread(coffs,2) then goto _fehler;
						if coffs>0 then
							begin
								for w:=0 to coffs-1 do
									begin
										if bread(l,1) then goto _fehler;
										if l>0 then
											if bread(tname[1],l) then goto _fehler;
										tname[0]:=chr(l);
										if bread(l,1) then goto _fehler;
										if l>0 then
											if bread(ttxt[1],l) then goto _fehler;
										ttxt[0]:=chr(l);
										if bread(l,1) then goto _fehler;
										if l>0 then
											if bread(tdescr[1],l) then goto _fehler;
										tdescr[0]:=chr(l);
										if bTst(what,INS_FORMULA) then
											begin
												vorh:=false;
												if Parameter^.Count>0 then
													begin
														utxt:=StrPUpper(tname);
														for q:=0 to Parameter^.Count-1 do
															if StrPUpper(PParameter(Parameter^.At(q))^.Name^)=utxt then
																begin
																	vorh:=true;
																	break
																end
													end;
												if not(vorh) then
													begin
														new(pp);
														if pp<>nil then
															begin
																pp^.Value:=atof(ttxt);
																pp^.Name:=NewStr(tname);
																pp^.ListName:=NewStr('  '+tname+' '#0);
																pp^.Txt:=NewStr(ttxt);
																pp^.Descr:=NewStr(tdescr);
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
																	Parameter^.Insert(pp)
															end
													end
											end
									end;
								{$IFNDEF LITE}
								if konstanten<>nil then PKonst(konstanten)^.UpdateList(true);
								{$ENDIF}
							end;
						if bread(coffs,2) then goto _fehler;
						if coffs>0 then
							if (what and (INS_FORMULA or INS_VALUE))>0 then
								for w:=0 to coffs-1 do
									begin
										if bread(i,2) then goto _fehler;
										if bread(l,1) then goto _fehler;
										if l>0 then
											if bread(ttxt[1],l) then goto _fehler;
										ttxt[0]:=chr(l);
										crr:=0;
										if UsrFormats^.Count>0 then
											for q:=0 to UsrFormats^.Count-1 do
												if PFormat(UsrFormats^.At(q))^.Name^=ttxt then
													begin
														crr:=PFormat(UsrFormats^.At(q))^.Index;
														break
													end;
										if crr=0 then crr:=NewNumFormat(ttxt);
										XChangeFormat(i,crr)
									end;
						_fehler:
						fclose(hdl)
					end
				else
					begin
						{ andere Formate... }
						if report then Application^.Alert(@self,1,NOTE,MESSAGE_CLIP_PASTE,BUTTON_OK)
						else
							Application^.Bing
					end;
				_raus:
				CloseClipboard
			end;
		if ocleared then RowsCheckOverflow(rs,re,cmin,cmax);
		if vrnd then
			begin
				SetDirty;
				DrawCells(rs,cmin,re,cmax);
				AutoCalculate(true);
				if not(Parms.Cursor.Block) then
					begin
						cell:=GetCell(Parms.Cursor.Row,Parms.Cursor.Col);
						CheckToolbarTextFX(cell);
						SetInpline(cell)
					end
			end
	end;


procedure TCalcWindow.DeleteCells;
	var x,y,
	    cmin,
	    cmax,
	    rs,re,
	    cs,ce : integer;
	    cell  : PCell;
	    vrnd  : boolean;

	begin
		vrnd:=false;
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
		cmin:=cs;
		cmax:=ce;
		RowsClearOverflow(rs,re,cmin,cmax);
		for y:=rs to re do
			begin
				cell:=GetCell(y,cs);
				for x:=cs to ce do
					begin
						if not(IsEmptyCell(cell)) then
							begin
								FreeCell(cell,true);
								vrnd:=true
							end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		RowsCheckOverflow(rs,re,cmin,cmax);
		if vrnd then
			begin
				SetDirty;
				DrawCells(rs,cmin,re,cmax);
				AutoCalculate(true);
				cell:=GetCell(rs,cs);
				CheckToolbarTextFX(cell);
				SetInpline(cell)
			end
		else
			Application^.Bing
	end;


procedure TCalcWindow.InsertCells(rs,cs,re,ce,dir: integer);
	label _raus;

	var x,y,
	    von,
	    anz,
	    cmin,cmax,
	    rmin,rmax,
	    rdif,
	    cdif     : integer;
	    cell,
	    ocell    : PCell;
	    oldsel   : byte;
	    movesize : boolean;

	procedure blockclear;
	
		begin
			RowsClearOverflow(rmin,rmax,cmin,cmax)
		end;

	begin
		BusyMouse;
		case dir of
		CRS_LEFT:
			begin
				if IsBlockUsed(rs,0,re,ce-cs,0) then goto _raus;
				rmin:=rs;
				rmax:=re;
				cmin:=0;
				cmax:=ce;
				blockclear;
				movesize:=(rs=0) and (re=Parms.Rows);
				FreeBlock(rs,0,re,ce-cs,false);
				if cs>0 then
					begin
						von:=ce+1-cs;
						if movesize then
							for x:=0 to cs-1 do PCol^[x]:=PCol^[von+x];
						for y:=rs to re do
							begin
								cell:=GetCell(y,0);
								ocell:=GetCell(y,von);
								for x:=1 to cs do
									begin
										oldsel:=cell^.Flags and CELL_SELECTED;
										cell^:=ocell^;
										cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
										inc(longint(cell),CELLSIZE);
										inc(longint(ocell),CELLSIZE)
									end
							end
					end;
				rdif:=0;
				cdif:=cs-ce-1;
				ClearBlock(rs,cs,re,ce);
				if movesize then
					if ce>cs then
						for x:=cs to ce-1 do PCol^[x]:=PCol^[ce];
				cs:=0
			end;
		CRS_RIGHT:
			begin
				if IsBlockUsed(rs,Parms.Columns+cs-ce,re,Parms.Columns,0) then goto _raus;
				rmin:=rs;
				rmax:=re;
				cmin:=cs;
				cmax:=Parms.Columns;
				blockclear;
				movesize:=(rs=0) and (re=Parms.Rows);
				FreeBlock(rs,Parms.Columns+cs-ce,re,Parms.Columns,false);
				anz:=Parms.Columns-ce;
				if anz>0 then
					begin
						von:=Parms.Columns+cs-ce-1;
						if movesize then
							for x:=0 to anz-1 do PCol^[Parms.Columns-x]:=PCol^[von-x];
						for y:=rs to re do
							begin
								cell:=GetCell(y,Parms.Columns);
								ocell:=GetCell(y,von);
								for x:=1 to anz do
									begin
										oldsel:=cell^.Flags and CELL_SELECTED;
										cell^:=ocell^;
										cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
										dec(longint(cell),CELLSIZE);
										dec(longint(ocell),CELLSIZE)
									end
							end
					end;
				rdif:=0;
				cdif:=ce+1-cs;
				ClearBlock(rs,cs,re,ce);
				if movesize then
					if ce>cs then
						for x:=cs+1 to ce do PCol^[x]:=PCol^[cs];
				ce:=Parms.Columns
			end;
		CRS_UP:
			begin
				if IsBlockUsed(0,cs,re-rs,ce,0) then goto _raus;
				rmin:=0;
				rmax:=re;
				cmin:=cs;
				cmax:=ce;
				blockclear;
				movesize:=(cs=0) and (ce=Parms.Columns);
				FreeBlock(0,cs,re-rs,ce,false);
				if rs>0 then
					begin
						von:=re+1-rs;
						for y:=0 to rs-1 do
							begin
								cell:=GetCell(y,cs);
								ocell:=GetCell(von+y,cs);
								if movesize then PRow^[y]:=PRow^[von+y];
								for x:=cs to ce do
									begin
										oldsel:=cell^.Flags and CELL_SELECTED;
										cell^:=ocell^;
										cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
										inc(longint(cell),CELLSIZE);
										inc(longint(ocell),CELLSIZE)
									end
							end
					end;
				rdif:=rs-re-1;
				cdif:=0;
				ClearBlock(rs,cs,re,ce);
				if movesize then
					if re>rs then
						for y:=rs to re-1 do PRow^[y]:=PRow^[re];
				rs:=0
			end;
		CRS_DOWN:
			begin
				if IsBlockUsed(Parms.Rows+rs-re,cs,Parms.Rows,ce,0) then goto _raus;
				rmin:=rs;
				rmax:=Parms.Rows;
				cmin:=cs;
				cmax:=ce;
				blockclear;
				movesize:=(cs=0) and (ce=Parms.Columns);
				FreeBlock(Parms.Rows+rs-re,cs,Parms.Rows,ce,false);
				anz:=Parms.Rows-re;
				if anz>0 then
					begin
						von:=Parms.Rows+rs-re-1;
						for y:=0 to anz-1 do
							begin
								cell:=GetCell(Parms.Rows-y,cs);
								ocell:=GetCell(von-y,cs);
								if movesize then PRow^[Parms.Rows-y]:=PRow^[von-y];
								for x:=cs to ce do
									begin
										oldsel:=cell^.Flags and CELL_SELECTED;
										cell^:=ocell^;
										cell^.Flags:=(cell^.Flags and CELL_EMPTYMASK) or oldsel;
										inc(longint(cell),CELLSIZE);
										inc(longint(ocell),CELLSIZE)
									end
							end
					end;
				rdif:=re+1-rs;
				cdif:=0;
				ClearBlock(rs,cs,re,ce);
				if movesize then
					if re>rs then
						for y:=rs+1 to re do PRow^[y]:=PRow^[rs];
				re:=Parms.Rows
			end
		end;
		TranslateCells(rs,cs,re,ce,rdif,cdif,false);
		RowsCheckOverflow(rmin,rmax,cmin,cmax);
		SetDirty;
		if movesize then
			begin
				SetScrollerRange;
				ForceVRedraw
			end
		else
			DrawCells(rmin,cmin,rmax,cmax);
		AutoCalculate(true);
		_raus:
		ArrowMouse
	end;


function TCalcWindow.FreeCell(cell: PCell; clr: boolean): boolean;
	var otxt  : string;
	    q     : longint;
	    oldsel: byte;

	begin
		case cell^.Typ of
		CTYPE_TEXT:
			begin
				DisposeStr(cell^.Data.Txt);
				cell^.Data.Value:=0;
				cell^.Typ:=CTYPE_EMPTY;
				FreeCell:=true
			end;
		CTYPE_CONST:
			begin
				DisposeStr(cell^.Data.Konst^.Txt);
				dispose(cell^.Data.Konst);
				cell^.Data.Value:=0;
				cell^.Typ:=CTYPE_EMPTY;
				FreeCell:=true
			end;
		CTYPE_FORMULA:
			begin
				if cell^.Data.Formula^.VarDef<>nil then
					if Variables<>nil then
						if Variables^.Count>0 then
							begin
								otxt:=StrPUpper(cell^.Data.Formula^.VarDef^);
								for q:=0 to Variables^.Count-1 do
									if otxt=StrPUpper(PVariable(Variables^.At(q))^.Name^) then
										begin
											Variables^.AtFree(q);
											break
										end
							end;
				DisposeStr(cell^.Data.Formula^.VarDef);
				DeleteNode(cell^.Data.Formula^.Func);
				dispose(cell^.Data.Formula);
				cell^.Data.Value:=0;
				cell^.Typ:=CTYPE_EMPTY;
				FreeCell:=true
			end
		else
			FreeCell:=false
		end;
		if clr then
			begin
				oldsel:=cell^.Flags and CELL_SELECTED;
				fillchar(cell^,CELLSIZE,0);
				with cell^ do
					begin
						Flags:=oldsel;
						Color:=Black;
						Style:=8;
						TxtVal.Color:=Black
					end
			end
	end;


function TCalcWindow.FreeBlock(rs,cs,re,ce: integer; clr: boolean): boolean;
	var x,y : integer;
	    vrnd: boolean;
	    cell: PCell;

	begin
		vrnd:=false;
		for y:=rs to re do
			begin
				cell:=GetCell(y,cs);
				for x:=cs to ce do
					begin
						if FreeCell(cell,clr) then vrnd:=true;
						inc(longint(cell),CELLSIZE)
					end
			end;
		FreeBlock:=vrnd
	end;


procedure TCalcWindow.ClearBlock(rs,cs,re,ce: integer);
	var x,y   : integer;
	    cell  : PCell;
	    oldsel: byte;

	begin
		for y:=rs to re do
			begin
				cell:=GetCell(y,cs);
				for x:=cs to ce do
					begin
						oldsel:=cell^.Flags and CELL_SELECTED;
						fillchar(cell^,CELLSIZE,0);
						with cell^ do
							begin
								Flags:=oldsel;
								Color:=Black;
								Style:=8;
								TxtVal.Color:=Black
							end;
						inc(longint(cell),CELLSIZE)
					end
			end
	end;


function TCalcWindow.IsBlockUsed(rs,cs,re,ce,tnum: integer): boolean;
	var x,y : integer;
	    cell: PCell;

	begin
		IsBlockUsed:=false;
		for y:=rs to re do
			begin
				cell:=GetCell(y,cs);
				for x:=cs to ce do
					begin
						if cell^.Data.Value<>0 then
							begin
								if tnum=0 then
									begin
										if Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_BLOCK1,BUTTON_GOCANCEL)<>1 then IsBlockUsed:=true
									end
								else
									begin
										if Application^.Alert(@self,1,WAIT,MESSAGE_WINDOW_BLOCK2,BUTTON_GOCANCEL)<>1 then IsBlockUsed:=true
									end;
								exit
							end;
						inc(longint(cell),CELLSIZE)
					end
			end
	end;


function TCalcWindow.IsEmptyCell(cell: PCell): boolean;

	begin
		IsEmptyCell:=false;
		with cell^ do
			if Typ=0 then
				if Data.Value=0 then
					if Color=Black then
						if Style=8 then
							if Interior=0 then
								if Border.Val1=0 then
									if Border.Val2=0 then
										if Format=0 then
											if (Flags and CELL_EMPTYMASK)=0 then
												with TxtVal do
													if Size=0 then
														if Rotat=0 then
															if Skew=0 then
																if Color=Black then
																	if Effects=0 then
																		if Align=0 then
																			if Flags=0 then IsEmptyCell:=true
	end;


procedure TCalcWindow.Sort(n1,n2,n3,nrs: integer; n1up,n2up,n3up,rows,cse,ebeg,lex,absl,noattr: boolean);
	label _raus,_cweiter,_rweiter;

	var rs,cs,
	    re,ce,
	    anz,q,
	    x,y,w,
	    i,h,
	    v,j,
	    cmin,
	    cmax,
	    dummy : integer;
	    n2offs,
	    n3offs,
	    offs  : longint;
	    p     : PIntegerArray;
	    valid : boolean;
	    acell : TCell;
	    cell2,
	    qcell2,
	    cell,
	    qcell : PCell;
	    qtxt,
	    vtxt  : string;
	    rval,
	    qval,
	    vval  : TNumber;

	procedure check_cellvars(cr,cc,qr,qc: integer);
		var i: integer;

		begin
			if cell^.Typ=CTYPE_FORMULA then
				if cell^.Data.Formula^.VarDef<>nil then
					if Variables<>nil then
						if Variables^.Count>0 then
							begin
								vtxt:=StrPUpper(cell^.Data.Formula^.VarDef^);
								for i:=0 to Variables^.Count-1 do
									with PVariable(Variables^.At(i))^ do
										if vtxt=StrPUpper(Name^) then
											begin
												RefRow:=cr;
												RefCol:=cc;
												break
											end
							end;
			if qcell^.Typ=CTYPE_FORMULA then
				if qcell^.Data.Formula^.VarDef<>nil then
					if Variables<>nil then
						if Variables^.Count>0 then
							begin
								vtxt:=StrPUpper(qcell^.Data.Formula^.VarDef^);
								for i:=0 to Variables^.Count-1 do
									with PVariable(Variables^.At(i))^ do
										if vtxt=StrPUpper(Name^) then
											begin
												RefRow:=qr;
												RefCol:=qc;
												break
											end
							end
		end;

	procedure cellstr(cell: PCell; var txt: string);
		type str2 = string[2];

		procedure subst(s1: char; s2: str2);

			begin
				w:=pos(s1,txt);
				while w>0 do
					begin
						txt:=StrPLeft(txt,w-1)+s2+StrPRight(txt,length(txt)-w);
						w:=pos(s1,txt)
					end
			end;

		begin
			with cell^ do
				case Typ of
				CTYPE_TEXT:
					txt:=Data.Txt^;
				CTYPE_CONST:
					Val2Txt(Data.Konst^.Value,txt,Data.Konst^.FPts,Format,nil);
				CTYPE_FORMULA:
					if Data.Formula^.Error=FE_OK then
						Val2Txt(Data.Formula^.Value,txt,Data.Formula^.FPts,Format,nil)
					else
						txt:=Error2Txt(Data.Formula^.Error);
				else
					txt:=''
				end;
			if lex then
				begin
					subst('„','ae');
					subst('”','oe');
					subst('','ue');
					subst('Ž','Ae');
					subst('™','Oe');
					subst('š','Ue');
					subst('ž','ss');
					subst(' ','a');
					subst('…','a');
					subst('ƒ','a');
					subst('†','a');
					subst('‘','„');
					subst('‚','e');
					subst('Š','e');
					subst('ˆ','e');
					subst('‰','e');
					subst('¡','i');
					subst('','i');
					subst('Œ','i');
					subst('‹','i');
					subst('¢','o');
					subst('•','o');
					subst('“','o');
					subst('£','u');
					subst('—','u');
					subst('–','u');
					subst('¤','n');
					subst('‡','c');
					subst('˜','y');
					subst('’','Ž');
					subst('','E');
					subst('¥','N');
					subst('¶','A')
				end;
			if not(cse) then txt:=StrPUpper(txt)
		end;

	function cellval(cell: PCell; pnum: PNumber): TNumber;

		begin
			with cell^ do
				case Typ of
				CTYPE_CONST:
					rval:=Data.Konst^.Value;
				CTYPE_FORMULA:
					if Data.Formula^.Error=FE_OK then rval:=Data.Formula^.Value
					else
						rval:=0.0;
				else
					rval:=0.0
				end;
			if absl then
				if pnum<>nil then
					if abs(rval)<>abs(pnum^) then
						begin
							rval:=abs(rval);
							pnum^:=abs(pnum^)
						end;
			cellval:=rval
		end;

	function compare: boolean;
		{$IFNDEF LITE}
		label _equal1,_equal2;
		{$ENDIF}

		begin
			compare:=false;
			if cell^.Data.Value=0 then
				begin
					if qcell^.Data.Value=0 then
					{$IFDEF LITE}
						exit;
					{$ELSE}
						goto _equal1;
					{$ENDIF}
					if not(ebeg) then compare:=true
				end
			else
				if qcell^.Data.Value=0 then
					begin
						if ebeg then compare:=true
					end
				else
					begin
						if (cell^.Typ<>CTYPE_TEXT) and (qcell^.Typ<>CTYPE_TEXT) then
							begin
								vval:=cellval(cell,nil);
								qval:=cellval(qcell,@vval);
								if n1up then
									begin
										if qval<vval then
											begin
												compare:=true;
												exit
											end
										else
											if qval>vval then exit
									end
								else
									begin
										if vval<qval then
											begin
												compare:=true;
												exit
											end
										else
											if vval>qval then exit
									end;
								{$IFDEF LITE}
								exit
								{$ELSE}
								goto _equal1
								{$ENDIF}
							end;
						if (nrs>0) then
							begin
								if cell^.Typ<>CTYPE_TEXT then
									begin
										if nrs=2 then compare:=true;
										exit
									end
								else
									if qcell^.Typ<>CTYPE_TEXT then
										begin
											if nrs=1 then compare:=true;
											exit
										end
							end;
						cellstr(cell,vtxt);
						cellstr(qcell,qtxt);
						if n1up then
							begin
								if qtxt<vtxt then
									begin
										compare:=true;
										exit
									end
								else
									if qtxt>vtxt then exit
							end
						else
							begin
								if vtxt<qtxt then
									begin
										compare:=true;
										exit
									end
								else
									if vtxt>qtxt then exit
							end;
						{$IFNDEF LITE}
						{ erste strings gleich }
						_equal1:
						if n2<0 then exit;
						cell2:=PCell(longint(cell)+n2offs);
						qcell2:=PCell(longint(qcell)+n2offs);
						if cell2^.Data.Value=0 then
							begin
								if qcell2^.Data.Value=0 then goto _equal2;
								if not(ebeg) then compare:=true;
								exit
							end
						else
							if qcell2^.Data.Value=0 then
								begin
									if ebeg then compare:=true;
									exit
								end;
						if (cell2^.Typ<>CTYPE_TEXT) and (qcell2^.Typ<>CTYPE_TEXT) then
							begin
								vval:=cellval(cell2,nil);
								qval:=cellval(qcell2,@vval);
								if n2up then
									begin
										if qval<vval then
											begin
												compare:=true;
												exit
											end
										else
											if qval>vval then exit
									end
								else
									begin
										if vval<qval then
											begin
												compare:=true;
												exit
											end
										else
											if vval>qval then exit
									end;
								goto _equal2
							end;
						if (nrs>0) then
							begin
								if cell2^.Typ<>CTYPE_TEXT then
									begin
										if nrs=2 then compare:=true;
										exit
									end
								else
									if qcell2^.Typ<>CTYPE_TEXT then
										begin
											if nrs=1 then compare:=true;
											exit
										end
							end;
						cellstr(cell2,vtxt);
						cellstr(qcell2,qtxt);
						if n2up then
							begin
								if qtxt<vtxt then
									begin
										compare:=true;
										exit
									end
								else
									if qtxt>vtxt then exit
							end
						else
							begin
								if vtxt<qtxt then
									begin
										compare:=true;
										exit
									end
								else
									if vtxt>qtxt then exit
							end;
						{ zweite strings gleich }
						_equal2:
						if n3<0 then exit;
						cell2:=PCell(longint(cell)+n3offs);
						qcell2:=PCell(longint(qcell)+n3offs);
						if cell2^.Data.Value=0 then
							begin
								if qcell2^.Data.Value=0 then exit;
								if not(ebeg) then compare:=true;
								exit
							end
						else
							if qcell2^.Data.Value=0 then
								begin
									if ebeg then compare:=true;
									exit
								end;
						if (cell2^.Typ<>CTYPE_TEXT) and (qcell2^.Typ<>CTYPE_TEXT) then
							begin
								vval:=cellval(cell2,nil);
								qval:=cellval(qcell2,@vval);
								if n3up then
									begin
										if qval<vval then compare:=true
									end
								else
									if vval<qval then compare:=true;
								exit
							end;
						if (nrs>0) then
							begin
								if cell2^.Typ<>CTYPE_TEXT then
									begin
										if nrs=2 then compare:=true;
										exit
									end
								else
									if qcell2^.Typ<>CTYPE_TEXT then
										begin
											if nrs=1 then compare:=true;
											exit
										end
							end;
						cellstr(cell2,vtxt);
						cellstr(qcell2,qtxt);
						if n3up then
							begin
								if qtxt<vtxt then compare:=true
							end
						else
							if vtxt<qtxt then compare:=true;
						{$ENDIF}
					end
		end;

	begin
		{$IFDEF LITE}
		n2:=-1;
		n3:=-1;
		{$ELSE}
		if n2<0 then
			begin
				n2:=n3;
				n2up:=n3up;
				n3:=-1
			end;
		if n1<0 then
			begin
				n1:=n2;
				n1up:=n2up;
				n2:=n3;
				n2up:=n3up;
				n3:=-1
			end;
		{$ENDIF}
		GetBlock(dblock^.GetText,false,rs,cs,re,ce,dummy,dummy);
		if (rows and (cs=ce)) or (not(rows) and (rs=re)) or (n1<0) then
			begin
				Application^.Bing;
				exit
			end;
		BusyMouse;
		if rows then anz:=ce-cs
		else
			anz:=re-rs;
		getmem(p,(anz+1) shl 1);
		if p=nil then goto _raus;
		cmin:=cs;
		cmax:=ce;
		RowsClearOverflow(rs,re,cmin,cmax);
		if rows then
			for q:=0 to anz do p^[q]:=cs+q
		else
			for q:=0 to anz do p^[q]:=rs+q;
		offs:=CELLSIZE*longint(Parms.Columns+1);
		valid:=false;
		if rows then
			begin
				cell:=GetCell(n1,cs);
				if n2>=0 then
					begin
						qcell:=GetCell(n2,cs);
						n2offs:=longint(qcell)-longint(cell)
					end;
				if n3>=0 then
					begin
						qcell:=GetCell(n3,cs);
						n3offs:=longint(qcell)-longint(cell)
					end;
				h:=1;
				repeat
					h:=h*3+1
				until h>(anz+1);
				repeat
					h:=h div 3;
					for i:=h to anz do
						begin
							v:=p^[i];
							j:=i;
							cell:=GetCell(n1,p^[j-h]);
							qcell:=GetCell(n1,v);
							while compare do
								begin
									p^[j]:=p^[j-h];
									dec(j,h);
									if j<h then goto _rweiter;
									cell:=GetCell(n1,p^[j-h])
								end;
							_rweiter:
							p^[j]:=v
						end
				until h=1;
				for x:=0 to anz do
					begin
						q:=p^[x];
						if q<>x+cs then
							begin
								cell:=GetCell(rs,x+cs);
								qcell:=GetCell(rs,q);
								for y:=rs to re do
									begin
										acell:=cell^;
										if noattr then
											begin
												cell^.Data:=qcell^.Data;
												cell^.Flags:=qcell^.Flags;
												cell^.Typ:=qcell^.Typ;
												cell^.Resvd:=qcell^.Resvd;
												cell^.Format:=qcell^.Format;
												qcell^.Data:=acell.Data;
												qcell^.Flags:=acell.Flags;
												qcell^.Typ:=acell.Typ;
												qcell^.Resvd:=acell.Resvd;
												qcell^.Format:=acell.Format;
											end
										else
											begin
												cell^:=qcell^;
												qcell^:=acell
											end;
										check_cellvars(y,x+cs,y,q);
										inc(longint(cell),offs);
										inc(longint(qcell),offs)
									end;
								for w:=x+1 to anz do
									if p^[w]=x+cs then
										begin
											p^[w]:=q;
											break
										end;
								valid:=true
							end
					end
			end
		else
			begin
				cell:=GetCell(rs,n1);
				if n2>=0 then
					begin
						qcell:=GetCell(rs,n2);
						n2offs:=longint(qcell)-longint(cell)
					end;
				if n3>=0 then
					begin
						qcell:=GetCell(rs,n3);
						n3offs:=longint(qcell)-longint(cell)
					end;
				h:=1;
				repeat
					h:=h*3+1
				until h>(anz+1);
				repeat
					h:=h div 3;
					for i:=h to anz do
						begin
							v:=p^[i];
							j:=i;
							cell:=GetCell(p^[j-h],n1);
							qcell:=GetCell(v,n1);
							while compare do
								begin
									p^[j]:=p^[j-h];
									dec(j,h);
									if j<h then goto _cweiter;
									cell:=GetCell(p^[j-h],n1)
								end;
							_cweiter:
							p^[j]:=v
						end
				until h=1;
				for y:=0 to anz do
					begin
						q:=p^[y];
						if q<>y+rs then
							begin
								cell:=GetCell(y+rs,cs);
								qcell:=GetCell(q,cs);
								for x:=cs to ce do
									begin
										acell:=cell^;
										if noattr then
											begin
												cell^.Data:=qcell^.Data;
												cell^.Flags:=qcell^.Flags;
												cell^.Typ:=qcell^.Typ;
												cell^.Resvd:=qcell^.Resvd;
												cell^.Format:=qcell^.Format;
												qcell^.Data:=acell.Data;
												qcell^.Flags:=acell.Flags;
												qcell^.Typ:=acell.Typ;
												qcell^.Resvd:=acell.Resvd;
												qcell^.Format:=acell.Format;
											end
										else
											begin
												cell^:=qcell^;
												qcell^:=acell
											end;
										check_cellvars(y+rs,x,q,x);
										inc(longint(cell),CELLSIZE);
										inc(longint(qcell),CELLSIZE)
									end;
								for w:=y+1 to anz do
									if p^[w]=y+rs then
										begin
											p^[w]:=q;
											break
										end;
								valid:=true
							end
					end
			end;
		freemem(p,(anz+1) shl 1);
		RowsCheckOverflow(rs,re,cmin,cmax);
		if valid then
			begin
				SetDirty;
				DrawCells(rs,cmin,re,cmax);
				AutoCalculate(true)
			end;
		Application^.Bing;
		_raus:
		ArrowMouse
	end;


procedure TCalcWindow.SetBorder(ltyp,lcol,rtyp,rcol,otyp,ocol,utyp,ucol,htyp,hcol,vtyp,vcol,gtyp,gcol: integer);
	var cell : PCell;
	    x,y,
	    rs,re,
	    cs,ce: integer;
	    offs : longint;

	procedure SetCell(cell: PCell; x,y,ltyp,lcol,rtyp,rcol,otyp,ocol,utyp,ucol,htyp,hcol,vtyp,vcol: integer);

		begin
			with cell^.Border do
				begin
					if ltyp>=0 then
						begin
							Left:=(ltyp shl 4) or lcol;
							if (x>0) and ((x=cs) or (rtyp<1)) then
								PCell(longint(cell)-CELLSIZE)^.Border.Right:=(PCell(longint(cell)-CELLSIZE)^.Border.Right and $f0) or lcol
						end;
					if rtyp>=0 then
						begin
							Right:=(rtyp shl 4) or rcol;
							if x<Parms.Columns then
								PCell(longint(cell)+CELLSIZE)^.Border.Left:=(PCell(longint(cell)+CELLSIZE)^.Border.Left and $f0) or rcol
						end;
					if otyp>=0 then
						begin
							Top:=(otyp shl 4) or ocol;
							if (y>0) and ((y=rs) or (utyp<1)) then
								PCell(longint(cell)-offs)^.Border.Bottom:=(PCell(longint(cell)-offs)^.Border.Bottom and $f0) or ocol
						end;
					if utyp>=0 then
						begin
							Bottom:=(utyp shl 4) or ucol;
							if y<Parms.Rows then
								PCell(longint(cell)+offs)^.Border.Top:=(PCell(longint(cell)+offs)^.Border.Top and $f0) or ucol
						end;
					if htyp>=0 then Hor:=(htyp shl 4) or hcol;
					if vtyp>=0 then Vert:=(vtyp shl 4) or vcol
				end
		end;

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
		offs:=CELLSIZE*longint(Parms.Columns+1);
		for y:=rs to re do
			begin
				cell:=GetCell(y,cs);
				for x:=cs to ce do
					begin
						SetCell(cell,x,y,ltyp,lcol,rtyp,rcol,otyp,ocol,utyp,ucol,htyp,hcol,vtyp,vcol);
						inc(longint(cell),CELLSIZE)
					end
			end;
		cell:=GetCell(rs,cs);
		for y:=rs to re do
			begin
				SetCell(cell,cs,y,gtyp,gcol,-1,0,-1,0,-1,0,-1,0,-1,0);
				inc(longint(cell),offs)
			end;
		cell:=GetCell(rs,ce);
		for y:=rs to re do
			begin
				SetCell(cell,ce,y,-1,0,gtyp,gcol,-1,0,-1,0,-1,0,-1,0);
				inc(longint(cell),offs)
			end;
		cell:=GetCell(rs,cs);
		for x:=cs to ce do
			begin
				SetCell(cell,x,rs,-1,0,-1,0,gtyp,gcol,-1,0,-1,0,-1,0);
				inc(longint(cell),CELLSIZE)
			end;
		cell:=GetCell(re,cs);
		for x:=cs to ce do
			begin
				SetCell(cell,x,re,-1,0,-1,0,-1,0,gtyp,gcol,-1,0,-1,0);
				inc(longint(cell),CELLSIZE)
			end;
		SetDirty;
		DrawCells(Max(rs-1,0),Max(cs-1,0),Min(re+1,Parms.Rows),Min(ce+1,Parms.Columns))
	end;


function TCalcWindow.Num2Hour(num: TNumber): integer;

	begin
		if (num<=0.0) or (num>=109573.0) then Num2Hour:=0
		else
			Num2Hour:=trunc(frac(num+TIMEROUND)*24.0)
	end;


function TCalcWindow.Num2Minute(num: TNumber): integer;

	begin
		if (num<=0.0) or (num>=109573.0) then Num2Minute:=0
		else
			Num2Minute:=trunc(frac(frac(num+TIMEROUND)*24.0)*60.0)
	end;


function TCalcWindow.Num2Second(num: TNumber): integer;

	begin
		if (num<=0.0) or (num>=109573.0) then Num2Second:=0
		else
			Num2Second:=trunc(frac(frac(frac(num+TIMEROUND)*24.0)*60.0)*60.0)
	end;


function TCalcWindow.Num2Year(num: TNumber): longint;
	var q,y: longint;
	    d  : integer;

	begin
		y:=1900;
		if (num>0.0) and (num<109573.0) then
			begin
				q:=trunc(num);
				if sheetbuffer.exceldate=bf_Checked then dec(q);
				d:=TexelApp.Days(y,sheetbuffer.exceldate=bf_Checked);
				while q>=d do
					begin
						dec(q,d);
						inc(y);
						d:=TexelApp.Days(y,sheetbuffer.exceldate=bf_Checked)
					end
			end;
		Num2Year:=y
	end;


function TCalcWindow.Num2Month(num: TNumber): integer;
	var q,y: longint;
	    d,m: integer;
	    p  : PIntegerArray;

	begin
		if (num<=0.0) or (num>=109573.0) then Num2Month:=1
		else
			begin
				y:=1900;
				q:=trunc(num);
				if sheetbuffer.exceldate=bf_Checked then dec(q);
				d:=TexelApp.Days(y,sheetbuffer.exceldate=bf_Checked);
				while q>=d do
					begin
						dec(q,d);
						inc(y);
						d:=TexelApp.Days(y,sheetbuffer.exceldate=bf_Checked)
					end;
				if d=366 then p:=@months366
				else
					p:=@months365;
				m:=0;
				while q>=p^[m] do
					begin
						dec(q,p^[m]);
						inc(m)
					end;
				Num2Month:=m+1
			end
	end;


function TCalcWindow.Num2Day(num: TNumber): integer;
	var q,y: longint;
	    d,
	    m,t: integer;
	    p  : PIntegerArray;

	begin
		if (num<=0.0) or (num>=109573.0) then Num2Day:=1
		else
			begin
				y:=1900;
				q:=trunc(num);
				if sheetbuffer.exceldate=bf_Checked then dec(q);
				d:=TexelApp.Days(y,sheetbuffer.exceldate=bf_Checked);
				while q>=d do
					begin
						dec(q,d);
						inc(y);
						d:=TexelApp.Days(y,sheetbuffer.exceldate=bf_Checked)
					end;
				if d=366 then p:=@months366
				else
					p:=@months365;
				m:=0;
				while q>=p^[m] do
					begin
						dec(q,p^[m]);
						inc(m)
					end;
				Num2Day:=q+1
			end
	end;


function TCalcWindow.Today: TNumber;
	var t: longint;

	begin
		t:=gettime;
		Today:=TexelApp.Date(((t shr 25) and $7f)+1980,(t shr 21) and $f,(t shr 16) and $1f,sheetbuffer.exceldate=bf_Checked)
	end;


function TCalcWindow.Now: TNumber;
	var t: longint;

	begin
		t:=gettime;
		Now:=Today+TexelApp.Time((t shr 11) and $1f,(t shr 5) and $3f,(t and $1f) shl 1)
	end;


function TCalcWindow.Weekday(num: TNumber; typ: integer): integer;
	var l,ny  : longint;
	    nm,nd,
	    oldexc: integer;

	begin
		if num>=109573.0 then
			begin
				Weekday:=0;
				exit
			end;
		ny:=Num2Year(num);
		nm:=Num2Month(num);
		nd:=Num2Day(num);
		oldexc:=sheetbuffer.exceldate;
		sheetbuffer.exceldate:=bf_Unchecked;
		l:=TexelApp.CountDays(ny,nm,nd,sheetbuffer.exceldate=bf_Checked) mod 7;
		sheetbuffer.exceldate:=oldexc;
		case typ of
		1:
			if l=6 then Weekday:=1
			else
				Weekday:=l+2;
		2:
			Weekday:=l+1
		else
			Weekday:=l
		end
	end;


function TCalcWindow.DDGetPath: string;

	begin
		DDGetPath:=GetWindowFilename
	end;


procedure TCalcWindow.OLGAGetInfo(OrgID,InfoNr: integer);
	label _fehler,_ende;

	var p    : pointer;
	    pipe : Pipearray;
	    s,t,a: string;
	    hdl,q: integer;
	    dlen,
	    res,l: longint;
	    err  : boolean;
	    hdr  : TOLGAInfHeader;
	    blck : TOLGABlockHeader;
	    dt   : DOSTIME;
	    icn  : ICONBLK;
	    picn : ICONBLKPtr;
	    tp   : PTree;
	    obj  : PObj;

	function bwrite(var buffer; count: longint): boolean;

		begin
			if fwrite(hdl,count,@buffer)<>count then
				begin
					bwrite:=true;
					err:=true
				end
			else
				bwrite:=false
		end;

	function blckwrite: boolean;

		begin
			blckwrite:=bwrite(blck,sizeof(blck))
		end;

	begin
		err:=false;
		s:=CreateUniqueTempFilename(GetTexelTempDir);
		res:=fcreate(s,0);
		if res<0 then exit;
		hdl:=integer(res);
		with hdr do
			begin
				Magic:='OLGA';
				Version:=$0100;
				Skip:=0
			end;
		if bwrite(hdr,sizeof(hdr)) then goto _fehler;
		t:=infobuf.Autor+#0;
		blck.ID:='AUTH';
		blck.Length:=length(t);
		if blckwrite then goto _fehler;
		if bwrite(t[1],length(t)) then goto _fehler;
		t:=infobuf.DocTitle+#0;
		blck.ID:='TITL';
		blck.Length:=length(t);
		if blckwrite then goto _fehler;
		if bwrite(t[1],length(t)) then goto _fehler;
		blck.ID:='REM ';
		with infobuf do blck.Length:=length(Rem1)+length(Rem2)+length(Rem3)+3;
		if blckwrite then goto _fehler;
		t:=infobuf.Rem1+#0;
		if bwrite(t[1],length(t)) then goto _fehler;
		t:=infobuf.Rem2+#0;
		if bwrite(t[1],length(t)) then goto _fehler;
		t:=infobuf.Rem3+#0;
		if bwrite(t[1],length(t)) then goto _fehler;
		a:=StrPTrimF(infobuf.Stichwort);
		t:='';
		q:=pos(',',a);
		while q>0 do
			begin
				t:=t+StrPLeft(a,q-1)+',';
				a:=StrPTrimF(StrPRight(a,length(a)-q));
				q:=pos(',',a)
			end;
		t:=t+a+#0;
		blck.ID:='KEYW';
		blck.Length:=length(t);
		if blckwrite then goto _fehler;
		if bwrite(t[1],length(t)) then goto _fehler;
		blck.ID:='DATE';
		blck.length:=sizeof(DOSTIME);
		if blckwrite then goto _fehler;
		dt.time:=word(infobuf.Last and $ffff);
		dt.date:=word(infobuf.Last shr 16);
		if bwrite(dt,sizeof(DOSTIME)) then goto _fehler;
		tp:=Application^.GetAddr(RTSTART);
		if tp=nil then goto _ende;
		obj:=@tp^[RTSTICON];
		if obj=nil then goto _ende;
		picn:=obj^.ob_spec.icon_blk;
		if picn^.ib_ptext=nil then l:=0
		else
			l:=strlen(picn^.ib_ptext);
		dlen:=((picn^.ib_wicon+7) shr 3)*picn^.ib_hicon;
		blck.ID:='ICON';
		blck.Length:=sizeof(ICONBLK)+(dlen shl 1)+l+1;
		if blckwrite then goto _fehler;
		icn:=picn^;
		icn.ib_pmask:=nil;
		icn.ib_pdata:=nil;
		icn.ib_ptext:=nil;
		if bwrite(icn,sizeof(ICONBLK)) then goto _fehler;
		if bwrite(picn^.ib_pmask^,dlen) then goto _fehler;
		if bwrite(picn^.ib_pdata^,dlen) then goto _fehler;
		if l=0 then
			begin
				if bwrite(l,1) then goto _fehler
			end
		else
			if bwrite(picn^.ib_ptext^,l+1) then goto _fehler;
		_ende:
		blck.ID:=#0#0#0#0;
		blck.Length:=0;
		blckwrite;
		_fehler:
		fclose(hdl);
		if err then exit;
		GlobalAlloc(p,256);
		if p=nil then
			begin
				fdelete(s);
				exit
			end;
		StrPCopy(p,s);
		pipe[0]:=OLGA_INFO;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(p));
		pipe[4]:=integer(LoWord(p));
		pipe[5]:=InfoNr;
		pipe[6]:=0;
		pipe[7]:=0;
		appl_write(OrgID,16,@pipe)
	end;


procedure TCalcWindow.OLGAUpdated(OrgID,SrvID,InfoNr: integer; Link: string);
	var pe: PEmbedded;

	begin
		pe:=Embedded;
		while pe<>nil do
			begin
				if pe^.GetFile=Link then pe^.Update;
				pe:=pe^.Next
			end;
		SetDirty
	end;


procedure TCalcWindow.OLGARenameLink(OrgID: integer; OldLink,NewLink: string);
	var pe: PEmbedded;

	begin
		pe:=Embedded;
		while pe<>nil do
			begin
				if pe^.GetFile=OldLink then pe^.SetFile(NewLink);
				pe:=pe^.Next
			end;
		SetDirty
	end;


procedure TCalcWindow.OLGALinkBroken(OrgID: integer; Link: string);
	var pe: PEmbedded;

	begin
		pe:=Embedded;
		while pe<>nil do
			begin
				if pe^.GetFile=Link then pe^.BreakLink;
				pe:=pe^.Next
			end;
		SetDirty
	end;


procedure TCalcWindow.PRNChanged(Device,Action: integer);

	begin
		if Action<>1 then exit; { ... }
		if prnt=nil then exit;
		if not(PPrint(prnt)^.IsAvailable(false)) then exit;
		if PPrint(prnt)^.GetDevice=Device then
			if preview<>nil then PPreview(preview)^.Update(true)
	end;


function TCalcWindow.NewNumFormat(s: string): integer;
	var pfm: PFormat;

	begin
		NewNumFormat:=0;
		new(pfm);
		if pfm<>nil then
			begin
				pfm^.Name:=NewStr(s);
				pfm^.Group:=1;
				pfm^.Index:=1000+UsrFormats^.Count;
				UsrFormats^.Insert(pfm);
				NewNumFormat:=pfm^.Index;
				SetDirty;
				if attrdialog<>nil then PAttrDialogs(attrdialog)^.ScrollToNumFormatSelection;
			end
	end;


procedure TCalcWindow.DeselectAllObjects;
	var p: PEmbedded;

	begin
		p:=Embedded;
		while p<>nil do
			begin
				p^.Deselect;
				p:=p^.Next
			end
	end;


function TCalcWindow.FirstSelectedObject: PEmbedded;
	var p: PEmbedded;

	begin
		FirstSelectedObject:=nil;
		p:=Embedded;
		while p<>nil do
			begin
				if p^.IsSelected then FirstSelectedObject:=p;
				p:=p^.Next
			end
	end;


procedure TCalcWindow.Embed(poi: POLGAObjectInfo; srvid: integer; ow,oh,x100,y100,dlen: longint; dat: pointer; poabuf: PEmbedBuf; pdb: PDiagrammBuf; xyvalid,prop,embd,drty,istad,prntflg,lckflg: boolean);
	var pe: PEmbedded;
	    r : GRECT;
	    s : string;

	begin
		poi^.ClientData:=0;
		GetSheetRect(r);
		s:=StrPPas(poi^.Filename);
		if (StrPUpper(StrPRight(s,4))='.TAD') or istad then pe:=new(PEmbeddedTAD,Init(@self,poi,s,srvid,r.X,r.Y,0,0,ow,oh,x100,y100,dlen,dat,xyvalid,true,prop,embd,prntflg,lckflg,poabuf,pdb))
		else
			new(pe,Init(@self,poi,s,srvid,r.X,r.Y,0,0,ow,oh,x100,y100,dlen,dat,xyvalid,true,prop,embd,prntflg,lckflg,poabuf));
		if pe<>nil then
			if drty then SetDirty;
		Top
	end;


procedure TCalcWindow.CallID4Server(fname: string);

	begin
		{ ... }
	end;


procedure TCalcWindow.Unembed(srvID: integer);
	var p: PEmbedded;

	begin
		if srvID<0 then exit;
		p:=Embedded;
		while p<>nil do
			begin
				if p^.ServerID=srvID then p^.Unembed;
				p:=p^.Next
			end
	end;


function TCalcWindow.CheckPasteObject(var p: PPopup): boolean;

	begin
		CheckPasteObject:=false;
		p^.Disable(2);
		if Clipboard=nil then exit;
		with Clipboard^ do
			begin
				if not(OpenClipboard(false)) then exit;
				{ ... }
				if Clipboard^.IsClipboardFormatAvailable('tob') then
					begin
						CheckPasteObject:=true;
						p^.Enable(2)
					end;
				CloseClipboard
			end
	end;


function TCalcWindow.PasteObject: boolean;
	label _raus,_fehler;

	var res,dummy,
	    w100,h100: longint;
	    hdl,typ,q: integer;
	    fname    : string;
	    flen     : byte;
	    tci      : TCookieID;
	    oabuf    : TEmbedBuf;
		  cbbuf    : TEmbedCheckBuf;
	    tdb      : TDiagrammBuf;
	    dbvalid,
	    skal,umbr,
	    prntflg,
	    prop,embd: boolean;
	    r        : GRECT;
	    pet      : PEmbeddedText;
	    pei      : PEmbeddedIMG;
	    pecb     : PEmbeddedCheckBox;

	function bread(var buffer; count: longint): boolean;

		begin
			bread:=(fread(hdl,count,@buffer)<>count)
		end;

	begin
		PasteObject:=false;
		if Clipboard=nil then exit;
		if not(Clipboard^.OpenClipboard(false)) then exit;
		if not(Clipboard^.IsClipboardFormatAvailable('tob')) then
			begin
				{ sofort tempor„re Dateien verwenden !!! }
{				if Clipboard^.IsClipboardFormatAvailable('img') then
					begin
						if grafik<>nil then grafik^.Load(Clipboard^.GetClipboardFilename+'img');
						PasteObject:=true
					end
				else if Clipboard^.IsClipboardFormatAvailable('txt') then
					begin
						if textobj<>nil then textobj^.Load(Clipboard^.GetClipboardFilename+'txt');
						PasteObject:=true
					end
				else if Clipboard^.IsClipboardFormatAvailable('asc') then
					begin
						if textobj<>nil then textobj^.Load(Clipboard^.GetClipboardFilename+'asc');
						PasteObject:=true
					end
				else
					begin
						if TexelApp.OLETypes<>nil then
							if TexelApp.OLETypes^.Count>0 then
								for q:=0 to TexelApp.OLETypes^.Count-1 do
									if StrPUpper(POLEType(TexelApp.OLETypes^.At(q))^.Ext)<>'.TXL' then
										if Clipboard^.IsClipboardFormatAvailable(POLEType(TexelApp.OLETypes^.At(q))^.Ext) then
											begin
												EmbedNewObject(CutRightF(Clipboard^.GetClipboardFilename,1)+StrPLower(POLEType(TexelApp.OLETypes^.At(q))^.Ext),0,0,0,0,0,nil,nil,nil,false,false,false,true,false);
												PasteObject:=true;
												exit
											end
					end; !!! }
				goto _raus
			end;
		res:=fopen(Clipboard^.GetClipboardFilename+'tob',FO_READ);
		if res<0 then goto _raus;
		hdl:=integer(res);
		if bread(tci,4) then goto _fehler;
		if tci<>'TXLO' then goto _fehler;
		if bread(typ,2) then goto _fehler;
		if bread(flen,1) then goto _fehler;
		if flen>0 then
			if bread(fname[1],flen) then goto _fehler;
		fname[0]:=chr(flen);
		if bread(dummy,4) then goto _fehler;
		GetSheetRect(r);
		if bread(oabuf,sizeof(oabuf)) then goto _fehler;
		if bread(w100,4) then goto _fehler;
		if bread(h100,4) then goto _fehler;
		if bread(prop,sizeof(boolean)) then goto _fehler;
		if bread(embd,sizeof(boolean)) then goto _fehler;
		if bread(prntflg,sizeof(boolean)) then goto _fehler;
		case typ of
		EMB_TYPE_ID4:
			EmbedNewObject(fname,w100,h100,0,0,0,nil,@oabuf,nil,false,prop,embd,true,false,prntflg,false);
		EMB_TYPE_IMG:
			begin
				if bread(skal,sizeof(boolean)) then goto _fehler;
				new(pei,Init(@self,fname,r.X,r.Y,0,0,w100,h100,0,0,0,nil,false,true,prop,embd,skal,prntflg,false,@oabuf));
				if pei<>nil then SetDirty
			end;
		EMB_TYPE_TEXT:
			begin
				if bread(umbr,sizeof(boolean)) then goto _fehler;
				new(pet,Init(@self,fname,r.X,r.Y,0,0,w100,h100,0,0,0,nil,false,true,prop,embd,umbr,prntflg,false,@oabuf));
				if pet<>nil then SetDirty
			end;
		EMB_TYPE_TAD:
			begin
				if bread(dbvalid,sizeof(boolean)) then goto _fehler;
				if dbvalid then
					begin
						if bread(tdb,sizeof(TDiagrammBuf)) then goto _fehler;
						EmbedNewObject(fname,w100,h100,0,0,0,nil,@oabuf,@tdb,false,prop,embd,true,true,prntflg,false)
					end
				else
					EmbedNewObject(fname,w100,h100,0,0,0,nil,@oabuf,nil,false,prop,embd,true,true,prntflg,false)
			end;
		EMB_TYPE_CHECKBOX:
			begin
				if bread(cbbuf,sizeof(cbbuf)) then goto _fehler;
				new(pecb,Init(@self,r.X,r.Y,0,0,w100,h100,0,0,0,nil,false,true,prop,prntflg,false,@oabuf,@cbbuf));
				if pecb<>nil then SetDirty
			end
		end;
		PasteObject:=true;
		_fehler:
		fclose(hdl);
		_raus:
		Clipboard^.CloseClipboard
	end;


procedure TCalcWindow.EmbedNewObject(fname: string; w100,h100,x100,y100,dlen: longint; dat: pointer; poabuf: PEmbedBuf; pdb: PDiagrammBuf; xyvalid,prop,embd,drty,istad,prntflg,lckflg: boolean);
	var exts,s: string;
	    ret   : longint;
	    q,hdl : integer;
	    P     : PEmbedded;
	    pipe  : Pipearray;
	    pc    : pointer;
	    pc2   : PChar;
	    toi   : PTexelObjectInfo;

	begin
		if Application^.OLGAManager<0 then exit;
		if length(fname)=0 then exit;
		exts:=StrPLeft(GetExtension(fname),4);
		if length(exts)=0 then exit;
		while length(exts)<4 do exts:=exts+#0;
		p:=Embedded;
		while p<>nil do
			begin
				exts:=exts+p^.GetExt(true,false);
				p:=p^.Next
			end;
		GlobalAlloc(pc,256);
		if pc=nil then exit;
		StrPCopy(pc,StrPUpper(exts));
		pipe[0]:=OLGA_ACTIVATE;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(pc));
		pipe[4]:=integer(LoWord(pc));
		pipe[5]:=length(exts) shr 2;
		pipe[6]:=0;
		pipe[7]:=0;
		appl_write(Application^.OLGAManager,16,@pipe);
		evnt_timer(200,0);
		if not(Exist(fname)) then
			if (dlen>0) and (dat<>nil) then
				begin
					s:=GetTexelTempDir+GetFilename(fname,true);
					while Exist(s) do
						s:=GetTexelTempDir+GetFilename(GetTempFilename,false)+GetExtension(fname);
					ret:=fcreate(s,0);
					if ret>=0 then
						begin
							hdl:=integer(ret);
							if fwrite(hdl,dlen,dat)=dlen then fname:=s;
							fclose(hdl)
						end
				end;
		GlobalAlloc(pointer(toi),sizeof(TTexelObjectInfo));
		if toi=nil then exit;
		fillchar(toi^,sizeof(TTexelObjectInfo),0);
		toi^.oi.Filename:=@toi^.fname;
		StrPCopy(toi^.oi.Filename,fname);
		toi^.oi.ClientGEMPB:=@AES_pb;
		toi^.oi.ClientData:=longint(@self);
		toi^.oi.CBLock:=-16000;
		toi^.oi.CBCount:=7;
		toi^.oi.cbColorTable:=@TexelApp.ColorTable;
		toi^.oi.cbClientID:=Application^.apID;
		toi^.oi.cbServerID:=-1;
		toi^.x100:=x100;
		toi^.y100:=y100;
		toi^.w100:=w100;
		toi^.h100:=h100;
		toi^.DataLen:=dlen;
		toi^.Data:=dat;
		if poabuf<>nil then toi^.oabuf:=poabuf^;
		toi^.prop:=prop;
		toi^.embd:=embd;
		toi^.dirty:=drty;
		toi^.xyvalid:=xyvalid;
		toi^.istad:=istad;
		if pdb<>nil then toi^.diabuf:=pdb^
		else
			toi^.diabuf.rb1:=0;
		toi^.prntflg:=prntflg;
		toi^.lckflg:=lckflg;
		pipe[0]:=OLGA_EMBED;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=GetOLGAGroup;
		pipe[4]:=integer(HiWord(toi));
		pipe[5]:=integer(LoWord(toi));
		pc2:=PChar(@pipe[6]);
		for q:=1 to 4 do
			begin
				pc2^:=upchar(exts[q]);
				inc(longint(pc2))
			end;
		appl_write(Application^.OLGAManager,16,@pipe)
	end;


procedure TCalcWindow.SetPercent(prc: real);
	var lp: longint;

	begin
		if prc<(655.36*MINPERCENT) then prc:=655.36*MINPERCENT;
		if prc>(655.36*MAXPERCENT) then prc:=655.36*MAXPERCENT;
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then
			begin
				wnd_prnt_set^.scale:=round(prc);
				with AES_pb do
					begin
						control^[0]:=205;
						control^[1]:=1;
						control^[2]:=1;
						control^[3]:=2;
						control^[4]:=0;
						intin^[0]:=8;
						addrin^[0]:=TexelApp.prnt_dialog;
						addrin^[1]:=wnd_prnt_set;
						_crystal(@AES_pb)
					end
{$IFNDEF WDIALOG}
			end
		else
			begin
				lp:=round(prc/655.36);
				prnbuffer.percent:=ltoa(lp);
				if prnt<>nil then
					if PPrint(prnt)^.ppcb<>nil then
						if PPrint(prnt)^.ppcb^.Edit<>nil then PPrint(prnt)^.ppcb^.Edit^.SetText(ltoa(lp))
{$ENDIF}
			end;
		SetDirty
	end;


function TCalcWindow.GetPercent: real;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then GetPercent:=wnd_prnt_set^.scale
		else
		{$IFDEF WDIALOG}
			GetPercent:=65536.0
		{$ELSE}
			GetPercent:=atol(prnbuffer.percent)*655.36
		{$ENDIF}
	end;


function TCalcWindow.IsNormalPrintArea: boolean;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then
			IsNormalPrintArea:=((prnRangeFlag=1) or ((prnRangeFlag=0) and (length(StrPTrimF(Parms.psbuffer.bereich))=0)))
		else
		{$IFDEF WDIALOG}
			IsNormalPrintArea:=true
		{$ELSE}
			IsNormalPrintArea:=((prnbuffer.alles=bf_Checked) or ((prnbuffer.pblock=bf_Checked) and (length(StrPTrimF(Parms.psbuffer.bereich))=0)))
		{$ENDIF}
	end;


function TCalcWindow.IsBlockPrintArea: boolean;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then
			IsBlockPrintArea:=(prnRangeFlag=0)
		else
		{$IFDEF WDIALOG}
			IsBlockPrintArea:=false
		{$ELSE}
			IsBlockPrintArea:=(prnbuffer.pblock=bf_Checked)
		{$ENDIF}
	end;


function TCalcWindow.GetPageFrom: integer;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then GetPageFrom:=wnd_prnt_set^.first_page
		else
		{$IFDEF WDIALOG}
			GetPageFrom:=0
		{$ELSE}
			GetPageFrom:=atol(prnbuffer.von)
		{$ENDIF}
	end;


function TCalcWindow.GetPageTo: integer;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then GetPageTo:=wnd_prnt_set^.last_page
		else
		{$IFDEF WDIALOG}
			GetPageTo:=9999
		{$ELSE}
			GetPageTo:=atol(prnbuffer.bis)
		{$ENDIF}
	end;


function TCalcWindow.GetMulticopy(hdl: integer): integer;

	begin
		GetMulticopy:=0;
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then
			if hdl<>0 then
				GetMulticopy:=vCopies(hdl,-1);
	end;


function TCalcWindow.GetCopies(hdl: integer): integer;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then
			begin
				GetCopies:=wnd_prnt_set^.no_copies;
				if hdl<>0 then
					if vCopies(hdl,-1)>1 then GetCopies:=1
			end
		else
		{$IFDEF WDIALOG}
			GetCopies:=1
		{$ELSE}
			GetCopies:=atol(prnbuffer.copies)
		{$ENDIF}
	end;


function TCalcWindow.DoFeed: boolean;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then DoFeed:=true
		else
		{$IFDEF WDIALOG}
			DoFeed:=true
		{$ELSE}
			DoFeed:=(prnbuffer.feed=bf_Checked)
		{$ENDIF}
	end;


function TCalcWindow.DoSheet: boolean;

	begin
		if TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set) then DoSheet:=true
		else
		{$IFDEF WDIALOG}
			DoSheet:=true
		{$ELSE}
			DoSheet:=(prnbuffer.sheet=bf_Checked)
		{$ENDIF}
	end;


function TCalcWindow.ClearDispList: boolean;
	var num: integer;

	begin
		if not(TexelApp.ExtPrnSel(wnd_prnt_set,TexelApp.app_prnt_set)) then
		{$IFDEF WDIALOG}
			num:=-1
		{$ELSE}
			num:=prnbuffer.device
		{$ENDIF}
		else
			case wnd_prnt_set^.driver_id of
			11..20:
				num:=DEV_PLOTTER;
			21..30:
				num:=DEV_PRINTER;
			31..40:
				num:=DEV_META;
			41..50:
				num:=DEV_CAMERA;
			51..60:
				num:=DEV_TABLET;
			61..80:
				num:=DEV_MEMORY;
			81..90:
				num:=DEV_FAX;
			91..99:
				num:=DEV_IMG;
			else
				num:=-1
			end;
		ClearDispList:=((num=DEV_PRINTER) or (num=DEV_META) or (num=DEV_PLOTTER) or (num=DEV_CAMERA))
	end;


procedure TCalcWindow.SetTextColor(ntc: integer);
	var cell : PCell;
	    x,y,
	    rs,cs,
	    cmin,
	    cmax,
	    re,ce: integer;

	begin
		if Attr.Status<>ws_Open then exit;
		if (ntc<0) or (ntc>15) then ntc:=Black;
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
		cmin:=cs;
		cmax:=ce;
		RowsClearOverflow(rs,re,cmin,cmax);
		for y:=rs to re do
			begin
				cell:=GetCell(y,cs);
				for x:=cs to ce do
					begin
						cell^.TxtVal.Color:=ntc;
						inc(longint(cell),CELLSIZE)
					end
			end;
		RowsCheckOverflow(rs,re,cmin,cmax);
		SetDirty;
		DrawCells(rs,cmin,re,cmax)
	end;


procedure TCalcWindow.SetCellColor(nc: integer);
	var x,y : integer;
	    cell: PCell;

	begin
		if Attr.Status<>ws_Open then exit;
		if (nc<0) or (nc>15) then nc:=Black;
		with Parms.Cursor do
			if Block then
				begin
					for y:=RowStart to RowEnd do
						begin
							cell:=GetCell(y,ColStart);
							for x:=ColStart to ColEnd do
								begin
									if nc=White then
										begin
											cell^.Color:=Black;
											cell^.Interior:=FIS_HOLLOW;
											cell^.Style:=8
										end
									else
										begin
											cell^.Color:=nc;
											if cell^.Interior=FIS_HOLLOW then cell^.Interior:=FIS_SOLID
										end;
									inc(longint(cell),CELLSIZE)
								end
						end;
					DrawCells(RowStart,ColStart,RowEnd,ColEnd)
				end
			else
				begin
					cell:=GetCell(Row,Col);
					if nc=White then
						begin
							cell^.Color:=Black;
							cell^.Interior:=FIS_HOLLOW;
							cell^.Style:=8
						end
					else
						begin
							cell^.Color:=nc;
							if cell^.Interior=FIS_HOLLOW then cell^.Interior:=FIS_SOLID
						end;
					DrawCells(Row,Col,Row,Col);
					if ppbox<>nil then
						begin
							if nc=White then ppbox^.SetSelection(0,false)
							else
								if cell^.Interior=FIS_SOLID then ppbox^.SetSelection(7,false)
						end
				end;
		SetDirty
	end;


function TCalcWindow.GetHelp(mX,mY: integer): string;

	begin
		if IsIconified then GetHelp:=GetWindowFilename
		else
			begin
				if (mX>=Work.X) and (mY>=Work.Y) then
					if FindObject(mX,mY,false)=OBJ_TOGGLEALL then
						begin
							GetHelp:=BUBBLE_SHEET_TOGGLE;
							exit
						end;
				GetHelp:=inherited GetHelp(mX,mY)
			end
	end;


procedure TCalcWindow.ColorID(OrgID,mX,mY,palIndex: integer);

	begin
		if Between(palIndex,0,15) then SetCellColor(palIndex)
		else
			Application^.Bing
	end;


function TTexelApplication.DemoNervAlert(ende: boolean): boolean;
	var len      : longint;
{$IFDEF DEMO}
	    demostart: PDemoStart;
{$ENDIF}

	begin
		DemoNervAlert:=true;
		if not(ende) then
			begin
				len:=GetFileSize(DataPath+TEXELRSC,0);
				if len>=0 then
					if len<>DEMORSCLEN1 then
						begin
							Alert(nil,0,STOP,MESSAGE_STARTUP_RSCERR,BUTTON_OK);
							exit
						end;
				len:=GetFileSize(DataPath+TEXELRSC2,0);
				if len>=0 then
					if len<>DEMORSCLEN2 then
						begin
							Alert(nil,0,STOP,MESSAGE_STARTUP_RSCERR,BUTTON_OK);
							exit
						end;
			end;
		{$IFDEF DEMO}
		ActivateExtResource;
		new(demostart,Init(nil,'',RTDEMO));
		if demostart<>nil then
			begin
				new(demostart^.pb,Init(demostart,RTDOK,id_OK,true,BUBBLE_EASTEREGG));
				if demostart^.pb<>nil then
					begin
						with demostart^.pb^.ObjAddr^ do ob_flags:=ob_flags and not(DEFAULT);
						demostart^.pb^.Disable;
						demostart^.pb^.SetShortcut(#0)
					end;
				demostart^.ende:=ende;
				demostart^.secs:=11;
				demostart^.HandleModalTimer;
				ExecDialog(demostart)
			end;
		DeactivateExtResource;
		{$ENDIF}
		DemoNervAlert:=false;
	end;


destructor TTexelApplication.Done;

	begin
		{$IFNDEF LITE}
		if savework<>nil then
			if setupbuffer.savework=bf_Checked then savework^.Work;
		{$ENDIF}
		inherited Done;
	end;


procedure TTexelApplication.SetupVDI;
	var dummy: integer;

	begin
		inherited SetupVDI;
		{$IFNDEF NVDI5}
		if SpeedoActive then
		{$ENDIF}
			vst_kern(vdiHandle,0,1,dummy,dummy);
	end;


procedure TTexelApplication.FontID2Index(var index: integer);
	label _weiter;

	var w: integer;

	begin
		index:=vst_font(vdiHandle,index);
		if Fonts<>nil then
			if Fonts^.Count>0 then
				for w:=0 to Fonts^.Count-1 do
					if PFont(Fonts^.At(w))^.index=index then
						begin
							index:=w;
							goto _weiter
						end;
		index:=0;
		_weiter:
		SetSystemFont(vdiHandle,w,w,w,w)
	end;


procedure TTexelApplication.FontSize2Index(fntindx: integer; var index: integer);
	var pf: PFont;
	    q : integer;

	begin
		if Fonts=nil then index:=0
		else
			begin
				pf:=PFont(Fonts^.At(fntindx));
				if pf^.SizeCount=0 then
					begin
						if index>127 then index:=123
						else
							if index<4 then index:=0
							else
								dec(index,4)
					end
				else
					begin
						for q:=pf^.SizeCount-1 downto 0 do
							if index<=pf^.Sizes^[q] then
								begin
									if index=pf^.Sizes^[q] then index:=pf^.SizeCount-q-1
									else
										if q<pf^.SizeCount-1 then index:=pf^.SizeCount-q-2
										else
											index:=0;
									exit
								end;
						index:=pf^.SizeCount-1
					end
			end
	end;


procedure TTexelApplication.InitInstance;
	var psh: PStartupHandler;

	begin
		savework:=nil;
		new(psh,Init(@self));
		if psh=nil then
			begin
				Quit;
				exit
			end;
		fnerror:=FE_OK;
		inherited InitInstance;
		{$IFDEF LITE}
		if pci_serno<1 then
			begin
				Quit;
				exit
			end;
		{$ENDIF}
		dispose(psh,Done)
	end;


procedure TTexelApplication.LoadFile(p: PCalcWindow; s: string);
	var ext: string;
	    q  : integer;

	begin
		{$IFDEF LITE}
		if opennewdoc<>nil then POpen(opennewdoc)^.Load(s)
		{$ELSE}
		ext:=StrPUpper(s);
		if (StrPLeft(ext,7)='HTTP://') or (StrPLeft(ext,6)='FTP://') then
			begin
				if openurl=nil then Bing
				else
					POpenURL(openurl)^.GetURL(s)
			end
		else
			begin
				ext:=GetExtension(ext);
				if ext='.DIF' then
					begin
						if import<>nil then PImport(import)^.LoadDIF(s)
					end
				else if ext='.CSV' then
					begin
						if import<>nil then PImport(import)^.LoadCSV(s)
					end
				else if ext='.XLS' then
					begin
						if import<>nil then PImport(import)^.LoadXLS(s)
					end
				else if ext='.DBF' then
					begin
						if import<>nil then PImport(import)^.ImportDBF(s,nil)
					end
				else if ext='.LDP' then
					begin
						if import<>nil then PImport(import)^.LoadLDW(s)
					end
				else if ext='.SPR' then
					begin
						if import<>nil then PImport(import)^.LoadPsion(s)
					end
				else if StrPLeft(ext,3)='.WK' then
					begin
						if import<>nil then PImport(import)^.Load123(s)
					end
				else
					begin
						if (p<>nil) and (ext<>'.TXL') and (OLETypes<>nil) then
							if OLETypes^.Count>0 then
								for q:=0 to OLETypes^.Count-1 do
									if StrPLeft(ext,4)=POLEType(OLETypes^.At(q))^.Ext then
										begin
											p^.EmbedNewObject(s,0,0,0,0,0,nil,nil,nil,false,false,false,true,false,true,false);
											exit
										end;
						if opennewdoc<>nil then POpen(opennewdoc)^.Load(s)
					end
			end
		{$ENDIF}
	end;


procedure TTexelApplication.InitMainWindow;
	label _tips;

	var q,hdl,
	    anz  : integer;
	    ret  : longint;
	    s,s2 : string;

	function dequote(sq: string): string;
		var i: integer;
	
		begin
			i:=1;
			while i<length(sq) do
				begin
					if sq[i]='''' then
						if sq[i+1]='''' then sq:=StrPLeft(sq,i)+StrPRight(sq,length(sq)-i-1);
					inc(i)
				end;
			dequote:=sq
		end;

	begin
		anz:=0;
		{$IFNDEF LITE}
		ret:=fopen(GetHomeDir(false)+'defaults\'+TEXELWORK,0);
		if ret<0 then ret:=fopen(GetHomeDir(false)+TEXELWORK,0);
		if ret>=0 then
			begin
				hdl:=integer(ret);
				if fread(hdl,2,@anz)<>2 then anz:=0;
				if anz>0 then
					for q:=1 to anz do
						if fread(hdl,256,@s[0])=256 then LoadFile(nil,s);
				fclose(hdl)
			end;
		{$ENDIF}
		if paramcount>0 then
			begin
				q:=1;
				while q<=paramcount do
					begin
						s:=paramstr(q);
						inc(q);
						if length(s)>0 then
							begin
								if s[1]='''' then
									begin
										CutLeft(s,1);
										while q<=paramcount do
											begin
												s2:=paramstr(q);
												inc(q);
												if StrPRight(s2,1)='''' then
													begin
														s:=s+' '+dequote(CutRightF(s2,1));
														LoadFile(nil,s);
														break
													end
												else
													s:=s+' '+dequote(s2);
											end
									end
								else
									LoadFile(nil,s);
							end
					end;
				goto _tips
			end;
		if anz=0 then
			begin
				if setupbuffer.opennew=bf_Checked then
					begin
						if createdoc<>nil then createdoc^.Work
						else
							new(PCalcWindow,Init(nil));
					end
				else
					if setupbuffer.loaddoc=bf_Checked then
						if opennewdoc<>nil then opennewdoc^.Work;
			end;
		_tips:
		if tips<>nil then
			if tipflags.start=bf_Checked then tips^.Work;
	end;


procedure TTexelApplication.Terminate;
	var pipe : Pipearray;
	    ret  : longint;
	    hdl,q: integer;

	begin
		{$IFDEF DEMO}
		DemoNervAlert(true);
		{$ENDIF}
		if abruf<>nil then
			if (PAbruf(abruf)^.Dirty) or (tipflags.start<>oldTipStart) then
				begin
					ret:=fcreate(GetHomeDir(false)+'defaults\'+TEXELHISTORY,0);
					if ret<0 then ret:=fcreate(GetHomeDir(false)+TEXELHISTORY,0);
					if ret>=0 then
						begin
							hdl:=integer(ret);
							fwrite(hdl,2,@PAbruf(abruf)^.Count);
							if PAbruf(abruf)^.Count>0 then
								for q:=PAbruf(abruf)^.Count-1 downto 0 do
									fwrite(hdl,length(PAbruf(abruf)^.Files[q]^)+1,PAbruf(abruf)^.Files[q]);
							fwrite(hdl,sizeof(TTipFlags),@tipflags);
							fclose(hdl)
						end
				end;
		if saveopt<>nil then
			if setupbuffer.saveopt=bf_Checked then saveopt^.Work;
		if WebID>=0 then
			if bTst(CABFlags5,4) then
				begin
					pipe[0]:=CAB_RELEASESTATUS;
					pipe[1]:=apID;
					pipe[2]:=0;
					pipe[3]:=0;
					pipe[4]:=0;
					pipe[5]:=0;
					pipe[6]:=0;
					pipe[7]:=0;
					appl_write(WebID,16,@pipe)
				end;
		if GEMScriptID>=0 then
			begin
				pipe[0]:=GS_QUIT;
				pipe[1]:=apID;
				pipe[2]:=0;
				pipe[3]:=0;
				pipe[4]:=0;
				pipe[5]:=0;
				pipe[6]:=0;
				pipe[7]:=0;
				appl_write(GEMScriptID,16,@pipe)
			end;
		if Fonts<>nil then dispose(Fonts,Done);
		if Functions<>nil then dispose(Functions,Done);
		if Categories<>nil then dispose(Categories,Done);
		if FormCategories<>nil then dispose(FormCategories,Done);
		if Formats<>nil then dispose(Formats,Done);
		if UsrForm<>nil then dispose(UsrForm,Done);
		if app_prnt_set<>nil then
			with AES_pb do
				begin
					control^[0]:=205;
					control^[1]:=1;
					control^[2]:=1;
					control^[3]:=1;
					control^[4]:=0;
					intin^[0]:=6;
					addrin^[0]:=app_prnt_set;
					_crystal(@AES_pb)
				end;
		if prnt_dialog<>nil then
			with AES_pb do
				begin
					control^[0]:=201;
					control^[1]:=0;
					control^[2]:=1;
					control^[3]:=1;
					control^[4]:=0;
					addrin^[0]:=prnt_dialog;
					_crystal(@AES_pb)
				end;
		if fnt_dialog<>nil then
			with AES_pb do
				begin
					control^[0]:=181;
					control^[1]:=1;
					control^[2]:=1;
					control^[3]:=1;
					control^[4]:=0;
					intin^[0]:=0;
					addrin^[0]:=fnt_dialog;
					_crystal(@AES_pb)
				end;
		FreeExtResource;
	end;


procedure TTexelApplication.VAStart(OrgID: integer; Cmd: PChar);

	begin
		inherited VAStart(OrgID,Cmd);
		while Cmd<>nil do LoadFile(nil,GetQuotedName(Cmd));
	end;


procedure TTexelApplication.FileSelected(Window: PWindow; OrgID: integer; Group: byte; Path: string; Files: PChar);
	var p: PChar;

	function getxfname(nr: integer; const extn: string): string;
		var ret: string;

		begin
			ret:=GetQuotedName(Files);
			if length(ret)>0 then
				begin
					LastPath[nr]:=GetPath(ret);
					if length(GetExtension(ret))>1 then ret:=LastPath[nr]+GetFilename(ret,true)
					else
						if length(extn)=0 then ret:=LastPath[nr]+GetFilename(ret,false)
						else
							if ret=StrPUpper(ret) then ret:=LastPath[nr]+GetFilename(ret,false)+'.'+StrPUpper(extn)
							else
								ret:=LastPath[nr]+GetFilename(ret,false)+'.'+extn;
					LastFile[nr]:=GetFilename(ret,true)
				end;
			getxfname:=ret
		end;

	begin
		case Group of
		FSEL_OPEN:
			if opennewdoc<>nil then
				while Files<>nil do POpen(opennewdoc)^.Load(getxfname(0,TEXELEXTENSION));
		FSEL_SAVE:
			if Window<>nil then
				with PCalcWindow(Window)^ do
					if saveas<>nil then PSaveAs(saveas)^.SaveAs(getxfname(0,TEXELEXTENSION),0);
		FSEL_SAVE2:
			if Window<>nil then
				with PCalcWindow(Window)^ do
					if saveas<>nil then PSaveAs(saveas)^.SaveAs(getxfname(0,TEXELEXTENSION),1);
		{$IFNDEF LITE}
		FSEL_EMBED:
			if Window<>nil then
				with PCalcWindow(Window)^ do
					while Files<>nil do EmbedNewObject(getxfname(17,''),0,0,0,0,0,nil,nil,nil,false,false,false,true,false,true,false);
		FSEL_EXPORT:
			if Window<>nil then
				with PCalcWindow(Window)^ do
					if export<>nil then PExport(export)^.SetFile(getxfname(15,''));
		FSEL_DIAGRAM:
			if Window<>nil then
				with PCalcWindow(Window)^ do
					if diagramm<>nil then
						begin
							if Application^.Multitasking then PDiagram(diagramm)^.SetFile(getxfname(19,'cwg'))
							else
								PDiagram(diagramm)^.SetFile(getxfname(19,'tad'))
						end;
		FSEL_LOADIMG:
			if Window<>nil then
				with PCalcWindow(Window)^ do
					if grafik<>nil then
						while Files<>nil do PGrafik(grafik)^.Load(getxfname(14,'img'));
		FSEL_LOADTEXT:
			if Window<>nil then
				with PCalcWindow(Window)^ do
					if textobj<>nil then
						while Files<>nil do PTextObj(textobj)^.Load(getxfname(18,'txt'));
		FSEL_LOADCSV:
			if import<>nil then
				while Files<>nil do PImport(import)^.LoadCSV(getxfname(4,'csv'));
		FSEL_LOADASCII:
			if import<>nil then
				if Files<>nil then PImport(import)^.LoadASCII(getxfname(6,'txt'));
		FSEL_LOADXLS:
			if import<>nil then
				while Files<>nil do PImport(import)^.LoadXLS(getxfname(7,'xls'));
		FSEL_LOADPSION:
			if import<>nil then
				while Files<>nil do PImport(import)^.LoadPsion(getxfname(20,'spr'));
		FSEL_LOADDBF:
			if import<>nil then
				while Files<>nil do PImport(import)^.LoadGDBC(getxfname(12,'dbf'));
		FSEL_LOAD123:
			if import<>nil then
				while Files<>nil do PImport(import)^.Load123(getxfname(10,'wk1'));
		FSEL_LOADLDW:
			if import<>nil then
				while Files<>nil do PImport(import)^.LoadLDW(getxfname(9,'ldp'));
		FSEL_LOADDIF:
			if import<>nil then
				while Files<>nil do PImport(import)^.LoadDIF(getxfname(2,'dif'))
		{$ENDIF}
		end
	end;


procedure TTexelApplication.GetXAccAttr(var XAccAttr: TXAccAttr);
	var feat: string;

	begin
		inherited GetXAccAttr(XAccAttr);
		with XAccAttr do
			begin
				AppTypeMR:='SS';
				if ExtFeatures=nil then feat:=''
				else
					begin
						feat:=ExtFeatures^+#0'X';
						DisposeStr(ExtFeatures)
					end;
				ExtFeatures:=NewStr(feat+'VA'#0'X.TXL'#0'X.CSV'#0'X.TXT'#0'X.XLS'#0'X.DIF'#0'X.DBF'#0'X.ASC');
				GenericName:=NewStr('ASHTEXEL')
			end
	end;


procedure TTexelApplication.GetMenuEntries(var Entries: TMenuEntries);

	begin
		inherited GetMenuEntries(Entries);
		with Entries do
			begin
				Quit.Entry:=RTMQUIT;
				Quit.Title:=RTM2;
				Close.Entry:=RTMCLOSE;
				Close.Title:=RTM2;
				Cut.Entry:=RTMCUT;
				Cut.Title:=RTM3;
				Copy.Entry:=RTMCOPY;
				Copy.Title:=RTM3;
				Paste.Entry:=RTMPASTE;
				Paste.Title:=RTM3;
				Delete.Entry:=RTMDELETE;
				Delete.Title:=RTM3;
				SelectAll.Entry:=RTMSELALL;
				SelectAll.Title:=RTM3
			end
	end;


function TTexelApplication.GetIconTitle: string;

	begin
		GetIconTitle:=StrPUpper(TEXELNAME)
	end;


function TTexelApplication.EscText2Formula(txt: string): string;
	var q,w,c,nr: integer;
	    fkt     : string;
	    pf      : PFunction;

	begin
		q:=pos(#27,txt);
		while q>0 do
			begin
				w:=q+1;
				while txt[w]<>#27 do inc(w);
				nr:=atol(StrPMid(txt,q+1,w-q-1));
				fkt:='@';
				c:=Functions^.Count-1;
				while c>=0 do
					begin
						pf:=PFunction(Functions^.At(c));
						if pf^.Opcode=nr then
							begin
								fkt:=pf^.Name^;
								break
							end;
						dec(c)
					end;
				txt:=StrPLeft(txt,q-1)+fkt+StrPRight(txt,length(txt)-w);
				q:=pos(#27,txt)
			end;
		EscText2Formula:=txt
	end;


function TTexelApplication.Num2Txt(fval: TNumber; fp: byte; cut0,komma: boolean): string;
	label _fertig;

	var vtxt: string;
	    expn: string[7];
	    q   : integer;

	begin
		if fval=0.0 then vtxt:='0'
		else
			begin
				if frac(fval*1e20)=0.0 then str(fval:0:fp,vtxt)
				else
					str(fval,vtxt);
				StrPTrim(vtxt);
				if vtxt='NaN' then goto _fertig;
				q:=pos('E',StrPUpper(vtxt));
				if q>0 then
					begin
						if vtxt[q+1] in ['+','-'] then
							begin
								expn:=StrPRight(vtxt,length(vtxt)-q-1);
								vtxt:=StrPLeft(vtxt,q+1)
							end
						else
							begin
								expn:=StrPRight(vtxt,length(vtxt)-q);
								vtxt:=StrPLeft(vtxt,q)
							end;
						while StrPLeft(expn,1)='0' do expn:=StrPRight(expn,length(expn)-1);
						if length(expn)>0 then expn:=StrPUpper(StrPRight(vtxt,length(vtxt)+1-q))+expn;
						vtxt:=StrPLeft(vtxt,q-1)
					end
				else
					expn:='';
				if pos(DEZTRENNPUNKT,vtxt)>0 then while StrPRight(vtxt,1)='0' do dec(byte(vtxt[0]));
				if StrPRight(vtxt,1)=DEZTRENNPUNKT then dec(byte(vtxt[0]));
				vtxt:=vtxt+expn;
				if length(vtxt)=0 then vtxt:='0'
				else
					if vtxt='-0' then vtxt:='0'
			end;
		if fp>0 then
			if pos('E',vtxt)=0 then
				begin
					q:=pos(DEZTRENNPUNKT,vtxt);
					if q=0 then vtxt:=vtxt+DEZTRENNPUNKT+StrPFill(fp,'0')
					else
						if length(vtxt)-q<fp then vtxt:=vtxt+StrPFill(fp+q-length(vtxt),'0')
				end;
		if cut0 then
			begin
				while StrPRight(vtxt,1)='0' do vtxt:=StrPLeft(vtxt,length(vtxt)-1);
				if StrPRight(vtxt,1)=DEZTRENNPUNKT then vtxt:=StrPLeft(vtxt,length(vtxt)-1);
				if length(vtxt)=0 then vtxt:='0'
			end;
		{$IFNDEF ENGLISH}
		if komma then
			begin
				q:=pos(DEZTRENNPUNKT,vtxt);
				while q>0 do
					begin
						vtxt[q]:=DEZTRENNKOMMA;
						q:=pos(DEZTRENNPUNKT,vtxt)
					end
			end;
		{$ENDIF}
		_fertig:
		Num2Txt:=vtxt
	end;


procedure TTexelApplication.HandleKeybd(Stat,Key: integer);
	label _aufruf;

	var pipe: Pipearray;
	    p   : PWindow;

	begin
		if (Key=S_Help) or (Key=F1) then
			if Stat=K_NORMAL then
				begin
					if HelpAvailable(true) then
						begin
							p:=GetPTopWindow;
							if p<>nil then
								begin
									if p^.IsDialog then
										begin
											PDialog(p)^.Help;
											exit
										end
									{$IFNDEF LITE}
									else
										if p^.GetClassName='SpecialCharactersWindow' then
											begin
												if Exist(DataPath+TEXELHELP) then StrPCopy(helpbuf,DataPath+TEXELHELP+' '+STG_SPECIALCHARS)
												else
													StrPCopy(helpbuf,GUIDES+TEXELHELP+' '+STG_SPECIALCHARS);
												goto _aufruf
											end;
									{$ENDIF}
								end;
							if Exist(DataPath+TEXELHELP) then StrPCopy(helpbuf,DataPath+TEXELHELP)
							else
								StrPCopy(helpbuf,GUIDES+TEXELHELP);
							_aufruf:
							pipe[0]:=VA_START;
							pipe[1]:=apID;
							pipe[2]:=0;
							pipe[3]:=integer(HiWord(helpbuf));
							pipe[4]:=integer(LoWord(helpbuf));
							pipe[5]:=0;
							pipe[6]:=0;
							pipe[7]:=0;
							appl_write(HelpID,16,@pipe)
						end;
					exit
				end;
		inherited HandleKeybd(Stat,Key)
	end;


procedure TTexelApplication.Unembed(srvID: integer);
	var p: PWindow;

	begin
		p:=MainWindow;
		while p<>nil do
			begin
				if p^.GetClassName=TEXELWINDCLASS then PCalcWindow(p)^.Unembed(srvID);
				p:=p^.Next
			end
	end;


procedure TTexelApplication.KommaToPunkt(var s: string);
	var q: integer;

	begin
		q:=pos(DEZTRENNKOMMA,s);
		while q>0 do
			begin
				s[q]:=DEZTRENNPUNKT;
				q:=pos(DEZTRENNKOMMA,s)
			end
	end;


function TTexelApplication.ScriptByNumber(nr: longint; datei,zelle,prm: string): boolean;
	label _direkt;

	var script,
	    scrapp,
	    scripter: string;
	    scrid,q : integer;
	    len     : longint;
	    answ    : ARRAY_8;
	    pc,pc2  : PChar;

	begin
		ScriptByNumber:=false;
		if length(zelle)=0 then exit;
		script:=DataPath+TEXELSCRIPTPATH+ltoa(nr)+'.'+TEXELSCRIPTEXT;
		if not(Exist(script)) then exit;
		scripter:=GetEnv('GEMSCRIPT');
		if length(scripter)=0 then
			begin
				scrid:=appl_find('SCRIPTER');
				goto _direkt
			end;
		scrapp:=StrPUpper(GetFilename(scripter,false));
		if length(scrapp)=0 then exit;
		scrid:=appl_find(scrapp+StrPSpace(8-length(scrapp)));
		if scrid<0 then scrid:=StartApp(scripter,'');
		_direkt:
		if scrid>=0 then
			begin
				if length(datei)=0 then datei:=#1;
				len:=4+1+length(script)+1+length(datei)+1+length(zelle)+1+length(prm)+1;
				GlobalAlloc(pointer(pc),len);
				if pc=nil then exit;
				ScriptByNumber:=true;
				if GEMScriptID<>scrid then
					begin
						answ[0]:=GS_REQUEST;
						answ[1]:=apID;
						answ[2]:=0;
						answ[3]:=integer(HiWord(GSInfo));
						answ[4]:=integer(LoWord(GSInfo));
						answ[5]:=0;
						answ[6]:=0;
						answ[7]:=0;
						appl_write(scrid,16,@answ)
					end;
				pc2:=pc;
				StrPCopy(pc2,'Exec');
				inc(longint(pc2),5);
				StrPCopy(pc2,script);
				inc(longint(pc2),length(script)+1);
				StrPCopy(pc2,datei);
				inc(longint(pc2),length(datei)+1);
				StrPCopy(pc2,zelle);
				inc(longint(pc2),length(zelle)+1);
				if length(prm)>0 then
					begin
						StrPTrim(prm);
						q:=pos(' ',prm);
						while q>0 do
							begin
								StrPCopy(pc2,StrPLeft(prm,q-1));
								inc(longint(pc2),q);
								prm:=StrPRight(prm,length(prm)-q);
								q:=pos(' ',prm)
							end;
						StrPCopy(pc2,prm);
						inc(longint(pc2),length(prm)+1)
					end;
				pc2^:=#0;
				answ[0]:=GS_COMMAND;
				answ[1]:=apID;
				answ[2]:=0;
				answ[3]:=integer(HiWord(pc));
				answ[4]:=integer(LoWord(pc));
				answ[5]:=0;
				answ[6]:=0;
				answ[7]:=0;
				appl_write(scrid,16,@answ)
			end
	end;


procedure TTexelApplication.HandleMesag(Pipe: Pipearray);
	var answ  : Pipearray;
	    poi   : PTexelObjectInfo;
	    err   : boolean;
	    pc,pc2: PChar;
	    plen,
	    len2  : longint;

	procedure BubbleFormErr;
		var txt: string;
		    r,c: integer;

		begin
			if setupbuffer.formerrcell=bf_Checked then
				begin
					with parserrwin^ do
						begin
							Cell2RC(parserrcell,r,c);
							SetCursorPos(r,c,true);
							if parserrcell^.Typ=CTYPE_TEXT then
								if parserrcell^.Data.Txt<>nil then
									begin
										inpline^.SetText(parserrcell^.Data.Txt^);
										if not(inpstat) then EnableInpline;
										inpline^.SetCursor(parserrpos)
									end;
						end
				end;
			case Pipe[6] of
			PERR_NOMEM:
				txt:=PARSERR_NOMEM;
			PERR_INCOMPCHARS:
				txt:=PARSERR_INCOMPCHARS;
			PERR_INCOMPCHARSFUNC:
				txt:=PARSERR_INCOMPCHARSFUNC;
			PERR_COMPINCOMPLETE:
				txt:=PARSERR_COMPINCOMPLETE;
			PERR_SUMMANDMISSING:
				txt:=PARSERR_SUMMANDMISSING;
			PERR_SUBTRAHENDMISSING:
				txt:=PARSERR_SUBTRAHENDMISSING;
			PERR_FAKTORMISSING:
				txt:=PARSERR_FAKTORMISSING;
			PERR_DIVISORMISSING:
				txt:=PARSERR_DIVISORMISSING;
			PERR_POWERMISSING:
				txt:=PARSERR_POWERMISSING;
			PERR_FACTORINVALID:
				txt:=PARSERR_FACTORINVALID;
			PERR_ARGCELLRANGE:
				txt:=PARSERR_ARGCELLRANGE;
			PERR_TOOFEWARGS:
				txt:=PARSERR_TOOFEWARGS;
			PERR_ARGEMPTY:
				txt:=PARSERR_ARGEMPTY;
			PERR_TOOMANYARGS:
				txt:=PARSERR_TOOMANYARGS;
			PERR_KLAMMERZUFEHLT:
				txt:=PARSERR_KLAMMERZUFEHLT;
			PERR_TOKENTOOLONG:
				txt:=PARSERR_TOKENTOOLONG;
			PERR_STRINGNOTTERMINATED:
				txt:=PARSERR_STRINGNOTTERMINATED;
			PERR_COLUMNWRONG:
				txt:=PARSERR_COLUMNWRONG;
			PERR_ROWWRONG:
				txt:=PARSERR_ROWWRONG;
			PERR_RANGEINCOMPLETE:
				txt:=PARSERR_RANGEINCOMPLETE;
			PERR_NUMBERSEXPECTED:
				txt:=PARSERR_NUMBERSEXPECTED;
			PERR_KLAMMERAUFFEHLT:
				txt:=PARSERR_KLAMMERAUFFEHLT;
			PERR_KLAMMERORSEMIKOLON:
				txt:=PARSERR_KLAMMERORSEMIKOLON;
			PERR_ARGNORANGE:
				txt:=PARSERR_ARGNORANGE;
			PERR_OK:
				txt:='';
			else
				txt:='Internal parser error #'+ltoa(Pipe[6]);
			end;
			if length(txt)>0 then Application^.BubbleHelp(Pipe[4],Pipe[5],PARSERR_ERROR+':|'+txt,true,false)
		end;

	begin
		case pipe[0] of
		OLGA_INPLACEUPDATE:
			begin
				poi:=Ptr(word(pipe[4]),word(pipe[5]));
				if poi<>nil then
					if poi^.oi.ClientData<>0 then
						with PEmbedded(poi^.oi.ClientData)^ do
							begin
								SetDirty;
								Redraw
							end
			end;
		OLGA_EMBEDDED:
			begin
				poi:=Ptr(word(pipe[4]),word(pipe[5]));
				if poi<>nil then
					begin
						if (pipe[6]=0) and (pipe[7]=0) then err:=true
						else
							if longint(GetPWindow(pipe[3]))<>poi^.oi.ClientData then err:=true
							else
								err:=false;
						if err then
							begin
								Alert(nil,1,NOTE,MESSAGE_WINDOW_EMBED1+StrPPas(poi^.oi.Filename)+MESSAGE_WINDOW_EMBED2,BUTTON_OK);
								GlobalFree(pointer(poi),sizeof(TTexelObjectInfo))
							end
						else
							begin
								if (poi^.w100>0) and (poi^.h100>0) then
									PCalcWindow(poi^.oi.ClientData)^.Embed(@poi^.oi,pipe[1],poi^.w100,poi^.h100,poi^.x100,poi^.y100,poi^.DataLen,poi^.Data,@poi^.oabuf,@poi^.diabuf,poi^.xyvalid,poi^.prop,poi^.embd,poi^.dirty,poi^.istad,poi^.prntflg,poi^.lckflg)
								else
									PCalcWindow(poi^.oi.ClientData)^.Embed(@poi^.oi,pipe[1],word(pipe[6]),word(pipe[7]),0,0,0,nil,nil,@poi^.diabuf,false,false,false,poi^.dirty,poi^.istad,poi^.prntflg,poi^.lckflg)
							end
					end
			end;
		OLGA_UNEMBED:
			begin
				poi:=Ptr(word(pipe[4]),word(pipe[5]));
				if poi=nil then Unembed(pipe[1])
				else
					if poi^.oi.ClientData<>0 then PEmbedded(poi^.oi.ClientData)^.Unembed
			end;
		OLGA_SERVERTERMINATED:
			Unembed(pipe[3]);
		OLGA_SETTINGS:
			{ ... };
		GS_REQUEST:
			begin
				answ[0]:=GS_REPLY;
				answ[1]:=apID;
				answ[2]:=0;
				answ[3]:=integer(HiWord(GSInfo));
				answ[4]:=integer(LoWord(GSInfo));
				answ[5]:=0;
				answ[6]:=1;
				if (pipe[3]<>0) or (pipe[4]<>0) then
					if PGSInfo(Ptr(word(pipe[3]),word(pipe[4])))^.Version>=$0070 then answ[6]:=0;
				answ[7]:=Pipe[7];
				appl_write(Pipe[1],16,@answ)
			end;
		GS_REPLY:
			begin
				if pipe[6]=0 then GEMScriptID:=pipe[1]
			end;
		GS_QUIT:
			begin
				if pipe[1]=GEMScriptID then GEMScriptID:=-1
			end;
		GS_COMMAND:
			begin
				GSActive:=true;
				if scripthnd=nil then scripthnd:=new(PScriptHandler,Init(nil));
				answ[0]:=GS_ACK;
				answ[1]:=apID;
				answ[2]:=0;
				answ[3]:=Pipe[3];
				answ[4]:=Pipe[4];
				answ[5]:=0;
				answ[6]:=0;
				if scripthnd=nil then answ[7]:=GSACK_ERROR
				else
					answ[7]:=PScriptHandler(scripthnd)^.InterpreteScript(Ptr(word(pipe[3]),word(pipe[4])),answ);
				appl_write(Pipe[1],16,@answ);
				GSActive:=false
			end;
		GS_ACK:
			begin
				pc:=Ptr(word(pipe[3]),word(pipe[4]));
				if pc<>nil then
					begin
						if (Pipe[5]<>0) or (Pipe[6]<>0) then
							begin
								{ Ergebnis auswerten... }
								answ[0]:=GS_ACK;
								answ[1]:=apID;
								answ[2]:=0;
								answ[3]:=0;
								answ[4]:=0;
								answ[5]:=Pipe[5];
								answ[6]:=Pipe[6];
								answ[7]:=0;
								appl_write(Pipe[1],16,@answ)
							end;
						pc2:=pc;
						plen:=1;
						repeat
							len2:=StrLen(pc2)+1;
							inc(plen,len2);
							inc(longint(pc2),len2)
						until pc2^=#0;
						GlobalFree(pointer(pc),plen)
					end
				else
					begin
						pc:=Ptr(word(pipe[5]),word(pipe[6]));
						if pc<>nil then
							begin
								pc2:=pc;
								plen:=1;
								repeat
									len2:=StrLen(pc2)+1;
									inc(plen,len2);
									inc(longint(pc2),len2)
								until pc2^=#0;
								GlobalFree(pointer(pc),plen)
							end
					end
			end;
		GS_MACRO:
			{ ... };
		GO_PRIVATE:
			begin
				case Pipe[3] of
				GOP_ABANDON:
					AbandonFile(PCalcWindow(Ptr(word(Pipe[4]),word(Pipe[5]))));
				GOP_FORMERR:
					BubbleFormErr;
				end
			end;
		DHST_ACK:
			begin
				pc:=Ptr(word(Pipe[3]),word(Pipe[4]));
				GlobalFree(pointer(pc),1024+sizeof(TDHSTInfo))
			end;
		CAB_HELLO:
			begin
				WebID:=Pipe[1];
				CABVersion:=Pipe[3];
				CABFlags4:=Pipe[4];
				CABFlags5:=Pipe[5];
				if bTst(CABFlags5,4) then
					begin
						answ[0]:=CAB_REQUESTSTATUS;
						answ[1]:=apID;
						answ[2]:=0;
						answ[3]:=0;
						answ[4]:=0;
						answ[5]:=0;
						answ[6]:=0;
						answ[7]:=0;
						appl_write(WebID,16,@answ)
					end
			end;
		CAB_EXIT:
			begin
				WebID:=-1;
				if webhelp<>nil then webhelp^.Disable;
				if websupport<>nil then websupport^.Disable;
				if openurl<>nil then
					begin
						openurl^.Disable;
						if openurl^.ADialog<>nil then openurl^.ADialog^.WMClosed
					end
			end;
		CAB_STATUS:
			begin
				if Pipe[3]<>0 then
					begin
						if webhelp<>nil then
							begin
								if bTst(CABFlags4,1) and bTst(CABFlags5,1) then webhelp^.Enable
								else
									webhelp^.Disable
							end;
						if websupport<>nil then
							begin
								if bTst(CABFlags4,16) and bTst(CABFlags5,2) then websupport^.Enable
								else
									websupport^.Disable
							end;
						if openurl<>nil then
							begin
								if bTst(CABFlags5,1) then openurl^.Enable
								else
									begin
										openurl^.Disable;
										if openurl^.ADialog<>nil then openurl^.ADialog^.WMClosed
									end
							end
					end
				else
					begin
						if webhelp<>nil then webhelp^.Disable;
						if websupport<>nil then websupport^.Disable;
						if openurl<>nil then
							begin
								openurl^.Disable;
								if openurl^.ADialog<>nil then openurl^.ADialog^.WMClosed
							end
					end
			end;
		CAB_MAILSENT:
			if Pipe[3]=0 then
				if Pipe[4]<>2 then
					Alert(nil,1,NOTE,MESSAGE_WINDOW_EMAIL,BUTTON_OK);
		end
	end;


procedure TTexelApplication.HandleAV(Pipe: Pipearray);
	var p: PCalcWindow;

	begin
		if pipe[0]=VA_THAT_IZIT then
			if (GetTicks-izitTicks)<100 then
				begin
					p:=PCalcWindow(GetGPWindow(izitWind));
					if p<>nil then
						case pipe[4] of
						VA_OB_TRASHCAN:
							p^.CutCells;
						VA_OB_SHREDDER:
							p^.DeleteCells;
						VA_OB_CLIPBOARD:
							p^.CopyCells;
						end;
				end
	end;


procedure TTexelApplication.HandleTimer;
	label _aus;

	var stgid: integer;
	    la   : LARRAY_2;

	begin
		pwait3(1,la);
		stgid:=appl_find('ST-GUIDE');
		if stgid<>HelpID then
			begin
				HelpID:=stgid;
				if not(HelpAvailable(false)) then
					begin
						if help1<>nil then help1^.Disable;
						if help2<>nil then help2^.Disable;
						if help3<>nil then help3^.Disable;
						if help4<>nil then help4^.Disable;
						if help5<>nil then help5^.Disable
					end
				else
					begin
						if help1<>nil then help1^.Enable;
						if help2<>nil then help2^.Enable;
						if help3<>nil then help3^.Enable;
						if help4<>nil then help4^.Enable;
						if help5<>nil then help5^.Enable
					end
			end;
		if about<>nil then
			begin
				with PAbout(about)^ do
					if ADialog<>nil then
						if ADialog^.Attr.Status=ws_Open then
							if serst<>nil then
								begin
									if mstimer<TEXELTIMER then
										begin
											serst^.SetText(StrPLeft(serscroll,40));
											serscroll:=StrPRight(serscroll,length(serscroll)-1);
											if length(serscroll)<40 then
												begin
													if arraycount<DANKMAX then
														begin
															inc(arraycount);
															serscroll:=serscroll+dank[arraycount]
														end
													else
														goto _aus
												end
										end
									else
										begin
											if tstart=0 then tstart:=((tgettime shr 5)+4+system.random(5)) shl 5
											else
												if tgettime>tstart then mstimer:=200
										end;
									exit
								end;
				if mstimer<>TEXELTIMER then
					begin
						_aus:
						with PAbout(about)^ do
							begin
								serscroll:=dank[0];
								arraycount:=0;
								if ADialog<>nil then
									if serst<>nil then
										serst^.SetText(sertxt);
								tstart:=0
							end;
						mstimer:=TEXELTIMER
					end
			end
	end;


function TTexelApplication.GetMsTimer: longint;

	begin
		GetMsTimer:=mstimer
	end;


function TTexelApplication.GetStdFontIndex: integer;
	var dummy: string;

	begin
		if Fonts=nil then GetStdFontIndex:=vqt_name(vdiHandle,1,dummy)
		else
			if (setupbuffer.stdfont>=0) and (setupbuffer.stdfont<Fonts^.Count) then GetStdFontIndex:=PFont(Fonts^.At(setupbuffer.stdfont))^.index
			else
				GetStdFontIndex:=vqt_name(vdiHandle,1,dummy)
	end;


function TTexelApplication.GetStdFontSize: integer;
	var pf: PFont;

	begin
		if Fonts=nil then GetStdFontSize:=10
		else
			if (setupbuffer.stdfont<0) or (setupbuffer.stdfont>=Fonts^.Count) then GetStdFontSize:=10
			else
				begin
					pf:=Fonts^.At(setupbuffer.stdfont);
					if pf^.SizeCount=0 then GetStdFontSize:=4+setupbuffer.stdfsize
					else
						if (setupbuffer.stdfsize<0) or (setupbuffer.stdfsize>=pf^.SizeCount) then GetStdFontSize:=10
						else
							GetStdFontSize:=pf^.Sizes^[pf^.SizeCount-setupbuffer.stdfsize-1]
				end
	end;


function TTexelApplication.DDReadArgs(dSize: longint; PipeHnd,OrgID,WindID,mX,mY,KStat: integer): boolean;

	begin
		DDReadArgs:=false;
		if ddfiles<>nil then freemem(ddfiles,StrLen(ddfiles)+1);
		getmem(ddfiles,dSize+1);
		if ddfiles<>nil then
			begin
				if fread(PipeHnd,dSize,ddfiles)<>dSize then
					begin
						freemem(ddfiles,dSize+1);
						ddfiles:=nil
					end
				else
					begin
						PChar(longint(ddfiles)+dSize)^:=#0;
						DDReadArgs:=true
					end
			end
		else
			inherited DDReadArgs(dSize,PipeHnd,OrgID,WindID,mX,mY,KStat)
	end;


procedure TTexelApplication.DDFinished(OrgID,WindID,mX,mY,KStat: integer);
	var p: PChar;

	begin
		if ddfiles=nil then exit;
		p:=ddfiles;
		while p<>nil do LoadFile(nil,GetQuotedName(p));
		freemem(ddfiles,StrLen(ddfiles)+1);
		ddfiles:=nil
	end;


function TTexelApplication.DDGetPreferredTypes(WindID: integer): string;

	begin
		DDGetPreferredTypes:='.txt.txl.dif.dbf.csv.asc.img.FLT'
	end;


function TTexelApplication.IsInteger(s: string): boolean;
	var q: integer;

	begin
		if length(s)>0 then
			begin
				IsInteger:=true;
				for q:=1 to length(s) do
					if not(s[q] in ['0'..'9']) then
						begin
							IsInteger:=false;
							exit
						end
			end
		else
			IsInteger:=false
	end;


function TTexelApplication.IsNumber(s: string; var num: TNumber; var nums: string; komma2punkt: boolean): boolean;
	var q : integer;
	    s2: string;
	    vz: string[1];

	begin
		IsNumber:=false;
		StrPTrim(s);
		if (StrPLeft(s,1)='+') or (StrPLeft(s,1)='-') then
			begin
				vz:=s[1];
				s:=StrPRight(s,length(s)-1)
			end
		else
			vz:='';
		s2:=StrPUpper(s);
		if komma2punkt then KommaToPunkt(s2);
		q:=pos(DEZTRENNPUNKT,s2);
		if q>0 then
			begin
				if q=1 then s:='0'+s
				else
					if not(IsInteger(StrPLeft(s2,q-1))) then exit;
				s2:=StrPRight(s2,length(s2)-q)
			end;
		q:=pos('E',s2);
		if q>0 then
			begin
				if not(IsInteger(StrPLeft(s2,q-1))) then exit;
				s2:=StrPRight(s2,length(s2)-q);
				if (StrPLeft(s2,1)='+') or (StrPLeft(s2,1)='-') then s2:=StrPRight(s2,length(s2)-1)
			end;
		if IsInteger(s2) then
			begin
				IsNumber:=true;
				nums:=vz+s;
				num:=atof(vz+s)
			end
	end;


{$IFNDEF LITE}

procedure TScrapDialog.GetWindowClass(var AWndClass: TWndClass);

	begin
		inherited GetWindowClass(AWndClass);
		with AWndClass do Style:=Style or cs_CancelOnClose
	end;


function TScrapDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then PImport(TexelApp.import)^.ImportFromClipboard;
		OK:=valid
	end;


function TScrapDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		if AnIndx=RTSCIMPORT then
			with TexelApp do
				if import<>nil then
					if Clipboard^.OpenClipboard(false) then
						begin
							PImport(import)^.LoadASCII(Clipboard^.GetClipboardFilename+ext);
							Clipboard^.CloseClipboard
						end;
		ExitDlg:=true
	end;


procedure TTexelApplication.SCChanged(OrgID: integer; Bits: word; Ext: string);
	var pb: PButton;

	begin
		if not(bTst(Bits,SCF_SHEET)) then
			begin
				if importscrap<>nil then importscrap^.Destroy;
				exit
			end;
		if importscrap=nil then
			begin
				importscrap:=new(PScrapDialog,Init(nil,TEXELNAME,STG_CLIPBOARD,ICNTITLE_CLIPBOARD,RTSCRAP));
				new(pb,Init(importscrap,RTSCHELP,id_Help,false,BUBBLE_GENERAL_HELP));
				if pb<>nil then
					if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
				new(PButton,Init(importscrap,RTSCIMPORT,id_No,true,BUBBLE_CLIP_IMPORT));
				new(PButton,Init(importscrap,RTSCLOAD,id_OK,true,BUBBLE_CLIP_OK))
			end;
		if importscrap<>nil then
			begin
				if StrPLeft(Ext,1)='.' then PScrapDialog(importscrap)^.ext:=StrPRight(Ext,length(Ext)-1)
				else
					PScrapDialog(importscrap)^.ext:=Ext;
				importscrap^.MakeWindow
			end
	end;

{$ENDIF}


procedure TTexelApplication.PRNChanged(OrgID,Device,Action: integer);
	var p: PWindow;

	begin
		{ Optionen - Einstellungen - Drucker... }
		p:=MainWindow;
		while p<>nil do
			begin
				if p^.GetClassName=TEXELWINDCLASS then PCalcWindow(p)^.PRNChanged(Device,Action);
				p:=p^.Next
			end
	end;


{procedure TTexelApplication.FNTChanged(OrgID: integer);

	begin
	end; ... }


function TTexelApplication.SystemHasPrintDialog: boolean;
	var dummy,out: integer;

	begin
		if appl_xgetinfo(7,out,dummy,dummy,dummy) then SystemHasPrintDialog:=bTst(out,16)
		else
			SystemHasPrintDialog:=false
	end;


function TTexelApplication.ExtPrnSel(var prnt_set: PPRN_SETTINGS; pcopyps: PPRN_SETTINGS): boolean;

	begin
		ExtPrnSel:=false;
		{$IFNDEF WDIALOG}
		if not(UseExtPrn) then exit;
		if SystemHasPrintDialog then
			begin
		{$ENDIF}
				if prnt_dialog=nil then
					begin
						BusyMouse;
						with AES_pb do
							begin
								control^[0]:=200;
								control^[1]:=1;
								control^[2]:=0;
								control^[3]:=0;
								control^[4]:=1;
								intin^[0]:=PDLG_3D;
								_crystal(@AES_pb);
								prnt_dialog:=addrout^[0]
							end;
						ArrowMouse
					end;
				if (prnt_set=nil) and (prnt_dialog<>nil) then
					begin
						BusyMouse;
						with AES_pb do
							begin
								control^[0]:=205;
								control^[1]:=1;
								control^[2]:=0;
								control^[3]:=1;
								control^[4]:=1;
								intin^[0]:=5;
								addrin^[0]:=prnt_dialog;
								_crystal(@AES_pb);
								prnt_set:=addrout^[0]
							end;
						if (prnt_set<>nil) and (pcopyps<>nil) then
							if pcopyps^.magic='pset' then
								begin
									move(pcopyps^,prnt_set^,pcopyps^.len);
									with AES_pb do
										begin
											control^[0]:=205;
											control^[1]:=1;
											control^[2]:=1;
											control^[3]:=2;
											control^[4]:=0;
											intin^[0]:=8;
											addrin^[0]:=prnt_dialog;
											addrin^[1]:=prnt_set;
											_crystal(@AES_pb)
										end
								end;
						ArrowMouse
					end;
				if (prnt_dialog<>nil) and (prnt_set<>nil) then ExtPrnSel:=true;
		{$IFNDEF WDIALOG}
			end
		{$ENDIF}
	end;


function TTexelApplication.NoFontSel: boolean;
	var dummy,out: integer;

	begin
		nofontsel:=true;
		if GetCookie('xFSL',longint(callxfsl)) then
			begin
				if callxfsl=nil then exit;
				with callxfsl^ do
					if id='xFSL' then
						if revision>=4 then
							begin
								nofontsel:=false;
								exit
							end
			end;
		if appl_xgetinfo(7,out,dummy,dummy,dummy) then
			if bTst(out,4) then
				begin
					if fnt_dialog=nil then
						begin
							fnt_titel:=TEXELNAME+' '+VtoS(TEXELVER)+' '+STRING_FONTSELECTION+#0;
							BusyMouse;
							with AES_pb do
								begin
									control^[0]:=180;
									control^[1]:=4;
									control^[2]:=0;
									control^[3]:=2;
									control^[4]:=1;
									intin^[0]:=vdiHandle;
									intin^[1]:=Attr.sysFonts+Attr.addFonts;
									intin^[2]:=FNTS_ALL;
									intin^[3]:=FNTS_3D;
									addrin^[0]:=@fnt_titel[1];
									addrin^[1]:=nil;
									_crystal(@AES_pb);
									fnt_dialog:=addrout^[0]
								end;
							ArrowMouse
						end;
					if fnt_dialog<>nil then
						begin
							NoFontSel:=false;
							exit
						end
				end;
		if GetCookie('UFSL',longint(callufsl)) then
			if callufsl<>nil then nofontsel:=false
	end;


function TTexelApplication.Time2Str(atime: longint): string;
	var ret,dummy: string;

	begin
		dummy:=ltoa((atime shr 16) and $1f);
		if length(dummy)=1 then ret:='0'+dummy
		else
			ret:=dummy;
		dummy:=ltoa((atime shr 21) and $f);
		if length(dummy)=1 then dummy:='0'+dummy;
		ret:=ret+DATETRENNPUNKT+dummy+DATETRENNPUNKT;
		dummy:=ltoa((((atime shr 25) and $7f)+80) mod 100);
		if length(dummy)=1 then dummy:='0'+dummy;
		ret:=ret+dummy+'  '+STRING_INFO_TIMEAT+'  ';
		dummy:=ltoa((atime shr 11) and $1f);
		if length(dummy)=1 then dummy:='0'+dummy;
		ret:=ret+dummy+TIMETRENN;
		dummy:=ltoa((atime shr 5) and $3f);
		if length(dummy)=1 then dummy:='0'+dummy;
		Time2Str:=ret+dummy
	end;


procedure TTexelApplication.FileChanged(const s: string);
	var pipe: Pipearray;

	begin
		if length(s)=0 then exit;
		pipe[1]:=apID;
		pipe[2]:=0;
		pipe[5]:=0;
		pipe[6]:=0;
		pipe[7]:=0;
		if length(s)>2 then
			if s[2]=':' then
				begin
					pipe[0]:=SH_WDRAW;
					pipe[3]:=ord(s[1])-65;
					pipe[4]:=0;
					Broadcast(@pipe,true)
				end;
		if AVServer>=0 then
			if filebuf<>nil then
				begin
					StrPCopy(filebuf,GetPath(s));
					pipe[0]:=AV_PATH_UPDATE;
					pipe[3]:=integer(HiWord(filebuf));
					pipe[4]:=integer(LoWord(filebuf));
					appl_write(AVServer,16,@pipe)
				end
	end;


procedure TTexelApplication.UpdateFile(const s: string; info: integer);
	label _raus;

	var p   : pointer;
	    pipe: Pipearray;

	begin
		if length(s)=0 then exit;
		if OLGAManager<0 then goto _raus;
		GlobalAlloc(p,256);
		if p=nil then goto _raus;
		StrPCopy(p,s);
		pipe[0]:=OLGA_UPDATE;
		pipe[1]:=apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(p));
		pipe[4]:=integer(LoWord(p));
		pipe[5]:=info;
		pipe[6]:=0;
		pipe[7]:=0;
		appl_write(OLGAManager,16,@pipe);
		_raus:
		FileChanged(s)
	end;


procedure TTexelApplication.OLGAGetInfo(OrgID,InfoNr: integer);
	var p: PCalcWindow;

	begin
		p:=PCalcWindow(GetPWindow(-InfoNr-1));
		if p<>nil then p^.OLGAGetInfo(OrgID,InfoNr)
	end;


procedure TTexelApplication.OLGAAck(Pipe: Pipearray);
	var p: pointer;

	begin
		case Pipe[7] of
		OLGA_LINK,
		OLGA_UNLINK,
		OLGA_UPDATE,
		OLGA_ACTIVATE:
			begin
				p:=Ptr(word(Pipe[3]),word(Pipe[4]));
				GlobalFree(p,256)
			end;
		OLGA_INFO:
			begin
				p:=Ptr(word(Pipe[3]),word(Pipe[4]));
				fdelete(StrPPas(p));
				GlobalFree(p,256)
			end;
		OLGA_RENAME:
			begin
				p:=Ptr(word(Pipe[3]),word(Pipe[4]));
				GlobalFree(p,256);
				p:=Ptr(word(Pipe[5]),word(Pipe[6]));
				GlobalFree(p,256)
			end;
		OLGA_START:
			begin
				if pipe[3]=0 then
					begin
						p:=Ptr(word(Pipe[4]),word(Pipe[5]));
						if pipe[6]=0 then
							if StrPUpper(StrPRight(StrPPas(p),4))='.TAD' then fdelete(StrPPas(p));
						GlobalFree(p,256)
					end
				else
					if pipe[6]=0 then
						begin
							if PCookieID(@pipe[4])^='.TAD' then Application^.Alert(nil,1,NOTE,MESSAGE_EMBED_ARTWORX,BUTTON_OK)
							else
								Application^.Alert(nil,1,NOTE,MESSAGE_EMBED_OLGA1+StrPTrimF(PCookieID(@pipe[4])^)+MESSAGE_EMBED_OLGA2,BUTTON_OK)
						end
			end
		end
	end;


procedure TTexelApplication.OLGAInit(OrgID,Msg,Ver,eFlag: integer);
	var pipe: Pipearray;

	begin
		inherited OLGAInit(OrgID,Msg,Ver,eFlag);
		if OLGAManager>=0 then
			begin
				pipe[0]:=OLGA_GETSETTINGS;
				pipe[1]:=apID;
				pipe[2]:=0;
				pipe[3]:=0;
				pipe[4]:=0;
				pipe[5]:=0;
				pipe[6]:=0;
				pipe[7]:=0;
				appl_write(OLGAManager,16,@pipe);
				if OLETypes=nil then
					begin
						new(OLETypes,Init(20,10));
						pipe[0]:=OLGA_GETOBJECTS;
						appl_write(OLGAManager,16,@pipe)
					end
			end
	end;


procedure TTexelApplication.OLEExit(OrgID: integer);
	var p: PWindow;

	begin
		inherited OLEExit(OrgID);
		if OLETypes<>nil then
			begin
				{$IFNDEF LITE}
				p:=MainWindow;
				while p<>nil do
					begin
						if p^.GetClassName=TEXELWINDCLASS then
							with PCalcWindow(p)^ do
								if oleobject<>nil then
									begin
										oleobject^.Disable;
										if oleobject^.ADialog<>nil then
											begin
												dispose(oleobject^.ADialog,Done);
												oleobject^.ADialog:=nil
											end
									end;
						p:=p^.Next
					end;
				{$ENDIF}
				dispose(OLETypes,Done);
				OLETypes:=nil;
			end
	end;


procedure TTexelApplication.OLGAObjects(OrgID,Rest: integer; Ext,Descr: string);
	var pipe: Pipearray;
	    p   : PWindow;
	    pole: POLEType;

	begin
		if OLETypes=nil then
			begin
				new(OLETypes,Init(Rest+10,10));
				if OLETypes=nil then exit
			end;
		{$IFNDEF LITE}
		if OLETypes^.Count=0 then
			begin
				p:=MainWindow;
				while p<>nil do
					begin
						if p^.GetClassName=TEXELWINDCLASS then
							if PCalcWindow(p)^.oleobject<>nil then PCalcWindow(p)^.oleobject^.Enable;
						p:=p^.Next
					end
			end;
		{$ENDIF}
		new(pole);
		if pole<>nil then
			begin
				pole^.Descr:=NewStr('  '+StrPLeft(Descr,38)+#0);
				if pole^.Descr=nil then dispose(pole)
				else
					begin
						pole^.Ext:=Ext;
						OLETypes^.Insert(pole)
					end
			end;
		if Rest>0 then
			begin
				pipe[0]:=OLGA_GETOBJECTS;
				pipe[1]:=apID;
				pipe[2]:=0;
				pipe[3]:=1;
				pipe[4]:=0;
				pipe[5]:=0;
				pipe[6]:=0;
				pipe[7]:=0;
				appl_write(OLGAManager,16,@pipe)
			end
		else
			begin
				new(pole);
				if pole<>nil then
					begin
						pole^.Descr:=NewStr('  '+STRING_ANY+#0);
						if pole^.Descr=nil then dispose(pole)
						else
							begin
								pole^.Ext:='';
								OLETypes^.AtInsert(0,pole)
							end
					end
			end
	end;


function TTexelApplication.LoadExtResource(fnam: string): boolean;

	begin
		LoadExtResource:=false;
		if RscPtr<>RSC_LOADED then exit;
		saveglobal:=GEM_pb.global;
		if rsrc_load(fnam)<>0 then
			begin
				FixResource(Ptr(word(GEM_pb.global[7]),word(GEM_pb.global[8])),FIXRSC,FIX_BBONLY);
				extglobal:=GEM_pb.global;
				LoadExtResource:=true
			end;
		GEM_pb.global:=saveglobal
	end;


procedure TTexelApplication.FreeExtResource;

	begin
		saveglobal:=GEM_pb.global;
		GEM_pb.global:=extglobal;
		rsrc_free;
		GEM_pb.global:=saveglobal
	end;


procedure TTexelApplication.ActivateExtResource;

	begin
		saveglobal:=GEM_pb.global;
		GEM_pb.global:=extglobal;
		ExtResource:=true
	end;


procedure TTexelApplication.DeactivateExtResource;

	begin
		GEM_pb.global:=saveglobal;
		ExtResource:=false
	end;


function TTexelApplication.num2str(s: string): string;
	var ret: string;
	    p  : integer;

	begin
		ret:='';
		StrPTrimF(s);
		while length(s)>0 do
			begin
				p:=pos(',',s);
				if p=0 then
					begin
						ret:=ret+chr(atol(s));
						s:=''
					end
				else
					begin
						ret:=ret+chr(atol(StrPLeft(s,p-1)));
						s:=StrPRight(s,length(s)-p)
					end;
				StrPTrimF(s)
			end;
		num2str:=ret
	end;


function TTexelApplication.XAccText(OrgID: integer; pText: pointer): boolean;
	var pw : PWindow;
	    cnt: integer;

	begin
		XAccText:=false;
		if pText=nil then exit;
		pw:=GetPTopWindow;
		if pw=nil then exit;
		if not(pw^.IsDialog) then exit;
		if PDialog(pw)^.GetClassName=TEXELWINDCLASS then
			with PCalcWindow(pw)^ do
				if (inpline<>nil) and not(inpstat) then
					begin
						if Parms.Cursor.Block then SetCursorPos(Parms.Cursor.Row,Parms.Cursor.Col,true);
						inpline^.Clear;
						EnableInpline
					end;
		cnt:=0;
		while not(PChar(pText)^ in [#0,#10,#13]) and (cnt<255) do
			begin
				PDialog(pw)^.InsertChar(PChar(pText)^);
				inc(cnt);
				inc(longint(pText))
			end;
		XAccText:=true
	end;


function TTexelApplication.HelpAvailable(loadstg: boolean): boolean;
	var s: string;

	begin
		HelpAvailable:=true;
		HelpID:=appl_find('ST-GUIDE');
		if HelpID>=0 then exit;
		s:=GetEnv('STGUIDE');
		if length(s)>0 then
			if Exist(s) then
				begin
					if loadstg then
						begin
							BusyMouse;
							if Exist(DataPath+TEXELHELP) then Application^.StartApp(s,DataPath+TEXELHELP)
							else
								Application^.StartApp(s,GUIDES+TEXELHELP);
							evnt_timer(250,0);
							ArrowMouse;
							HelpID:=appl_find('ST-GUIDE');
							if HelpID>=0 then exit
						end
					else
						exit
				end;
		HelpAvailable:=false
	end;


procedure TTexelApplication.ErrorWindowMemory(p: PWindow);

	begin
		Alert(p,1,STOP,MESSAGE_WINDOW_MEMORY,BUTTON_OK)
	end;


procedure TTexelApplication.InitSheetStructs(var parms: TTexelParms; var shbuf: TSheetBuffer; var dgbuf: TDialogBuffer; var zwbuf: TZielBuf; var dibuf: TDiagrammBuf; var exbuf: TExportBuf;
                                             var srbuf: TSortBuf; var inbuf: TInfoBuf; var fibuf: TFindBuf; var rebuf: TReplaceBuf; var flbuf: TFillBuffer);

	begin
		with parms do
			begin
				Percent:=100;
				psbuffer:=stdpsbuffer;
				Toolbar:=setupbuffer.toolbar;
				with Cursor do
					begin
						Block:=false;
						OldRow:=0;
						OldCol:=0;
						Row:=0;
						Col:=0
					end
			end;
		with shbuf do
			begin
				size:=setupbuffer.stdfsize;
				font:=setupbuffer.stdfont;
				gitter:=bf_Checked;
				autocalc:=setupbuffer.autocalc;
				vorlage:=bf_Unchecked;
				lhor:=bf_Unchecked;
				lvert:=bf_Unchecked;
				lmouse:=bf_Checked;
				llayout:=bf_Checked;
				images:=bf_Checked;
				protect:=bf_Unchecked;
				umbruch:=bf_Checked;
				exceldate:=setupbuffer.exceldate
			end;
		with dgbuf do
			begin
				font:=setupbuffer.stdfont;
				size:=setupbuffer.stdfsize;
				percent:=3;
				color:=White;
				pattern:=0;
				direction:=CRS_DOWN;
				input:='';
				txtcolor:=Black;
				border:=0;
				resvd1:=0;
				resvd2:=0;
				resvd3:=0;
				resvd4:=0
			end;
		with zwbuf do
			begin
				zzelle:='';
				vzelle:='';
				wert:='0';
				iterationen:='100'
			end;
		with dibuf do
			begin
				rb1:=bf_Checked;
				rb2:=bf_Unchecked;
				rb3:=bf_Unchecked;
				rb4:=bf_Unchecked;
				rb5:=bf_Unchecked;
				typLinie:=bf_Checked;
				typBalken:=bf_Unchecked;
				typKreis:=bf_Unchecked;
				Farbe:=bf_Checked;
				Absolut:=bf_Checked;
				xyLinear:=bf_Checked;
				xyFirst:=bf_Unchecked;
				xyAlternate:=bf_Unchecked;
				xyLine:=bf_Unchecked;
				xyPt:=bf_Unchecked;
				xyLinept:=bf_Checked;
				Stapeln:=bf_Unchecked;
				DreiD:=bf_Unchecked;
				Neben:=bf_Checked;
				stilLinie:=0;
				stilPunkt:=5;
				Titel:='';
				Legende:=bf_Checked;
				Border:=bf_Checked;
				nRow:=bf_Unchecked;
				nColumn:=bf_Unchecked;
				Size:=setupbuffer.stdfsize;
				Font:=setupbuffer.stdfont;
				dRows:=bf_Checked;
				dColumns:=bf_Unchecked;
				Ticks:=bf_Checked;
				numTicks:='4';
				alName:='Y';
				alTicks:=bf_Checked;
				alNum:='3';
				alMin:='';
				alMax:='';
				auName:='X';
				auTicks:=bf_Checked;
				auNum:='3';
				auMin:='';
				auMax:='';
				szWidth:='50.0';
				szHeight:='50.0';
				objFilename:=''
			end;
		with exbuf do
			begin
				exporttype:=0;
				clipboard:=bf_Unchecked;
				bereich:=bf_Unchecked;
				htmldoctype:=1;
				htmlsavedt:=bf_Checked;
				htmlcolor:=bf_Checked;
				csvformula:=bf_Unchecked;
				csvvalue:=bf_Checked;
				difformula:=bf_Unchecked;
				difvalue:=bf_Checked;
				difstandard:=bf_Checked;
				difexcel:=bf_Unchecked;
				with ascii do
					begin
						hor:=bf_Checked;
						vert:=bf_Unchecked;
						rctxt:='13,10';
						rcval:=0;
						celltxt:='9';
						cellval:=0;
						texttxt:='34';
						textval:=0;
						quote:=bf_Checked;
						numbers:=0;
						formula:=bf_Unchecked;
						value:=bf_Checked
					end;
				difformat:=bf_Checked;
				csvformat:=bf_Checked;
				asciiformat:=bf_Checked;
				htmlembed:=bf_Unchecked;
				filter:=0;
				htmlnoesc:=bf_Unchecked;
				xlsversion:=0;
				htmlcss:=1;
				texelvers:=0;
				htmlfonts:=bf_Checked;
			end;
		with srbuf do
			begin
				Pop1:=0;
				Up1:=bf_Checked;
				Down1:=bf_Unchecked;
				Pop2:=0;
				Up2:=bf_Checked;
				Down2:=bf_Unchecked;
				Pop3:=0;
				Up3:=bf_Checked;
				Down3:=bf_Unchecked;
				Columns:=bf_Checked;
				Rows:=bf_Unchecked;
				Ins:=bf_Checked;
				Pre:=bf_Unchecked;
				Post:=bf_Unchecked;
				Chars:=bf_Unchecked;
				EmptyPre:=bf_Unchecked;
				EmptyPost:=bf_Checked;
				Lexikal:=bf_Checked;
				Absolut:=bf_Unchecked;
				Attribute:=bf_Unchecked
			end;
		with inbuf do
			begin
				Autor:=GetAuthorName;
				Stichwort:='';
				Rem1:='';
				Rem2:='';
				Rem3:='';
				DocTitle:='';
				{$IFDEF LITE}
				Encrypt:=bf_Unchecked;
				{$ELSE}
				Encrypt:=bf_Checked;
				{$ENDIF}
				Resvd:=0;
				Created:=gettime;
				Last:=gettime;
				Resvd0:=0;
				Used:=1;
				Printed:=0;
				Version:=0;
				Release:=0
			end;
		with fibuf do
			begin
				search:='';
				rows:=bf_Checked;
				columns:=bf_Unchecked;
				cse:=bf_Unchecked;
				complete:=bf_Unchecked;
				formula:=bf_Checked;
				value:=bf_Checked;
				txt:=bf_Checked;
				iform:=bf_Unchecked;
				ival:=bf_Checked;
				vor:=bf_Checked;
				zurueck:=bf_Unchecked;
				resvd:=0
			end;
		with rebuf do
			begin
				search:='';
				replace:='';
				rows:=bf_Checked;
				columns:=bf_Unchecked;
				cse:=bf_Unchecked;
				complete:=bf_Unchecked;
				formula:=bf_Checked;
				value:=bf_Checked;
				txt:=bf_Checked;
				vor:=bf_Checked;
				zurueck:=bf_Unchecked;
				resvd:=0
			end;
		with flbuf do
			begin
				rows:=bf_Checked;
				columns:=bf_Unchecked;
				arithm:=bf_Checked;
				geom:=bf_Unchecked;
				date:=bf_Unchecked;
				cpy:=bf_Unchecked;
				trend:=bf_Unchecked;
				day:=bf_Checked;
				wday:=bf_Unchecked;
				month:=bf_Unchecked;
				year:=bf_Unchecked;
				stepval:='1';
				endval:=''
			end
	end;


procedure TTexelApplication.FilterString(id: integer; var s: string);
	var i,nr: integer;

	begin
		if length(s)>0 then
			begin
				nr:=pkt^.GetImportFilter(nil,nil,0,0,0,id);
				for i:=1 to length(s) do s[i]:=pkt^.ImportChar(nil,nil,0,0,0,nr,s[i])
			end
	end;


procedure TTexelApplication.FilterExportString(id: integer; var s: string);
	var i,nr: integer;

	begin
		if length(s)>0 then
			if InitKeyTab then
				begin
					nr:=pkt^.GetExportFilter(nil,nil,0,0,0,id);
					for i:=1 to length(s) do s[i]:=pkt^.ExportChar(nil,nil,0,0,0,nr,s[i])
				end
	end;


function TTexelApplication.dosmask(s: string): string;
	var i: integer;

	procedure replace(alt,neu: char);
	
		begin
			i:=pos(alt,s);
			while i>0 do
				begin
					s[i]:=neu;
					i:=pos(alt,s)
				end
		end;
	
	begin
		if InitKeyTab then FilterString(KEYTAB_ID_ANSI,s)
		else
			begin
				replace(#228,'„');
				replace(#246,'”');
				replace(#252,'');
				replace(#223,'ž');
				replace(#196,'Ž');
				replace(#214,'™');
				replace(#220,'š');
				replace(#178,#253);
				replace(#179,#254);
				replace(#181,#230)
			end;
		dosmask:=s
	end;


function TTexelApplication.macmask(s: string): string;
	var i: integer;

	procedure replace(alt,neu: char);
	
		begin
			i:=pos(alt,s);
			while i>0 do
				begin
					s[i]:=neu;
					i:=pos(alt,s)
				end
		end;
	
	begin
		if InitKeyTab then FilterString(KEYTAB_ID_MAC,s)
		else
			begin
				replace(#138,'„');
				replace('š','”');
				replace(#159,'');
				replace('€','Ž');
				replace(#133,'™');
				replace('†','š');
				replace(#167,'ž')
			end;
		macmask:=s
	end;


procedure TTexelApplication.AbandonFile(p: PCalcWindow);
	var s: string;

	begin
		if (p=nil) or (opennewdoc=nil) then exit;
		s:=p^.GetWindowFileName;
		if length(s)=0 then exit;
		if not(Exist(s)) then exit;
		if Alert(p,1,WAIT,MESSAGE_WINDOW_ABANDON1+CompressPath(s,78)+MESSAGE_WINDOW_ABANDON2,BUTTON_YESNO)=1 then
			begin
				p^.ClearDirty;
				dispose(p,Done);
				POpen(opennewdoc)^.Load(s)
			end
	end;


procedure TTexelApplication.InitCells(cell: PCell; rmax,cmax: integer);
	var w,q: integer;

	begin
		for q:=0 to rmax-1 do
			for w:=0 to cmax-1 do
				begin
					with cell^ do
						begin
							Color:=Black;
							Style:=8;
							TxtVal.Color:=Black
						end;
					inc(longint(cell),CELLSIZE)
				end
	end;


function TTexelApplication.GetShortCreatorString: string;

	begin
		GetShortCreatorString:='ASH-TEXEL '+VtoS(TEXELVER)+'r'+ltoa(RELEASE)
	end;


function TTexelApplication.GetCreatorString: string;

	begin
		GetCreatorString:='Created using '+GetShortCreatorString
	end;


function TTexelApplication.GetAuthorName: string;
	var s: string;

	begin
		{$IFDEF BETA}
		s:=regname;
		{$ELSE}
		{$IFDEF DEMO}
		s:='';
		{$ELSE}
		{$IFDEF LITE}
		s:='';
		{$ELSE}
		s:=decode_name(ash_name);
		{$ENDIF}
		{$ENDIF}
		{$ENDIF}
		if length(s)=0 then s:=GetEnv('USERNAME');
		GetAuthorName:=s
	end;


function TTexelApplication.IsSchaltjahr(year: integer; exceldate: boolean): boolean;

	begin
		if (year mod 4)=0 then
			begin
				if (year mod 100)=0 then
					begin
						if ((year mod 400)=0) or exceldate then IsSchaltjahr:=true
						else
							IsSchaltjahr:=false
					end
				else
					IsSchaltjahr:=true
			end
		else
			IsSchaltjahr:=false
	end;


function TTexelApplication.Days(year: integer; exceldate: boolean): integer;

	begin
		if IsSchaltjahr(year,exceldate) then Days:=366
		else
			Days:=365
	end;


function TTexelApplication.CountDays(Year: longint; Month,Day: integer; exceldate: boolean): longint;
	var ret,y: longint;
	    m,d  : integer;
	    p    : PIntegerArray;

	begin
		if Year<=1900 then Year:=1900;
		if Month<1 then Month:=1;
		if Month>12 then Month:=12;
		if Day<1 then Day:=1;
		if exceldate then ret:=0
		else
			ret:=-1;
		y:=1900;
		while y<Year do
			begin
				inc(ret,Days(y,exceldate));
				inc(y)
			end;
		if IsSchaltjahr(Year,exceldate) then p:=@months366
		else
			p:=@months365;
		m:=1;
		while m<Month do
			begin
				inc(ret,p^[m-1]);
				inc(m)
			end;
		if Day>p^[m-1] then CountDays:=ret+p^[m-1]
		else
			CountDays:=ret+Day
	end;


function TTexelApplication.Date(Year: longint; Month,Day: integer; exceldate: boolean): TNumber;

	begin
		Date:=CountDays(Year,Month,Day,exceldate)
	end;


function TTexelApplication.IsDate(const s: string; var sz: TNumber; var ret: string; var frm: integer; exceldate: boolean): boolean;
	var l,t,m,j,
	    p1,p2  : integer;
	    sep    : char;

	function checksep(c: char): boolean;
	
		begin
			checksep:=false;
			p1:=pos(c,ret);
			if (p1<2) or (p1>3) then exit;
			p2:=RPos(c,ret);
			if (p2<>l-2) and (p2<>l-4) then exit;
			sep:=c;
			checksep:=true
		end;

	begin
		IsDate:=false;
		ret:=StrPTrimF(s);
		l:=length(ret);
		if (l<6) or (l>10) then exit;
		if not(checksep(DATETRENNPUNKT)) then
			if not(checksep(DATETRENNSLASH)) then exit;
		t:=p2-p1;
		if (t<2) or (t>3) then exit;
		if not(IsInteger(StrPLeft(ret,p1-1))) then exit;
		if not(IsInteger(StrPMid(ret,p1+1,t-1))) then exit;
		if not(IsInteger(StrPRight(ret,l-p2))) then exit;
		if sep=DATETRENNSLASH then
			begin
				m:=atol(StrPLeft(ret,p1-1));
				if (m<1) or (m>12) then exit;
				t:=atol(StrPMid(ret,p1+1,t-1));
				if (t<1) or (t>31) then exit
			end
		else
			begin
				m:=atol(StrPMid(ret,p1+1,t-1));
				if (m<1) or (m>12) then exit;
				t:=atol(StrPLeft(ret,p1-1));
				if (t<1) or (t>31) then exit
			end;
		j:=atol(StrPRight(ret,l-p2));
		if (j>=80) and (j<=99) then inc(j,1900)
		else
			if (j>=0) and (j<=79) then inc(j,2000);
		if (j<1900) or (j>2199) then exit;
		sz:=Date(j,m,t,exceldate);
		if p2=l-4 then frm:=FormStart[3]
		else
			frm:=FormStart[3]+1;
		IsDate:=true
	end;


function TTexelApplication.Time(Hour,Minute,Second: integer): TNumber;

	begin
		Time:=std1*Hour+min1*Minute+sek1*Second
	end;


function TTexelApplication.IsTime(const s: string; var sz: TNumber; var ret: string; var frm: integer): boolean;
	var l,h,m,sec: integer;

	begin
		IsTime:=false;
		ret:=StrPTrimF(s);
		l:=length(ret);
		if (l=4) or (l=7) then
			begin
				if ret[2]<>':' then exit;
				if l=7 then
					begin
						if ret[5]<>':' then exit;
						if not(IsInteger(StrPRight(ret,2))) then exit;
						sec:=atol(StrPRight(ret,2));
						frm:=20
					end
				else
					begin
						sec:=0;
						frm:=19
					end;
				if (sec<0) or (sec>59) then exit;
				if not(IsInteger(StrPLeft(ret,1))) then exit;
				if not(IsInteger(StrPMid(ret,3,2))) then exit;
				h:=atol(StrPLeft(ret,1));
				if (h<0) or (h>23) then exit;
				m:=atol(StrPMid(ret,3,2))
			end
		else
			if (l=5) or (l=8) then
				begin
					if ret[3]<>':' then exit;
					if l=8 then
						begin
							if ret[6]<>':' then exit;
							if not(IsInteger(StrPRight(ret,2))) then exit;
							sec:=atol(StrPRight(ret,2));
							frm:=20
						end
					else
						begin
							sec:=0;
							frm:=19
						end;
					if (sec<0) or (sec>59) then exit;
					if not(IsInteger(StrPLeft(ret,2))) then exit;
					if not(IsInteger(StrPMid(ret,4,2))) then exit;
					h:=atol(StrPLeft(ret,2));
					if (h<0) or (h>23) then exit;
					m:=atol(StrPMid(ret,4,2))
				end
			else
				exit;
		if (m<0) or (m>59) then exit;
		sz:=Time(h,m,sec);
		IsTime:=true
	end;


function TPSDialog.OK: boolean;
	var psd: TPSBuffer;
	    ops: PPSBuffer;
	    but: integer;

	function BlockCorrect(blck: string): boolean;
		var c: integer;

		function cellcorrect(cl: string; nr: integer): boolean;
			var q,w: integer;

			begin
				cellcorrect:=false;
				StrPTrim(cl);
				if length(cl)=0 then exit;
				q:=1;
				while (cl[q] in ['A'..'Z']) and (q<=length(cl)) do inc(q);
				w:=q;
				while (cl[w] in ['0'..'9']) and (w<=length(cl)) do inc(w);
				if w=q then
					if w=1 then exit;
				if w=length(cl)+1 then cellcorrect:=true
			end;

		begin
			blck:=StrPUpper(StrPTrimF(blck));
			if length(blck)=0 then
				begin
					BlockCorrect:=true;
					exit
				end
			else
				BlockCorrect:=false;
			c:=pos(':',blck);
			if c>0 then
				begin
					if cellcorrect(StrPLeft(blck,c-1),1) then
						if cellcorrect(StrPRight(blck,length(blck)-c),2) then BlockCorrect:=true
				end
			else
				if cellcorrect(blck,0) then BlockCorrect:=true
		end;

	begin
		ops:=TransferBuffer;
		TransferBuffer:=@psd;
		TransferData(tf_GetData);
		TransferBuffer:=ops;
		if not(BlockCorrect(psd.bereich)) then
			begin
				Application^.Alert(@self,1,NOTE,MESSAGE_LAYOUT_RANGE,BUTTON_OK);
				OK:=false
			end
		else
			begin
				if ((atof(psd.kopf)<=0.0) and (((psd.hlefton=bf_Checked) and (length(psd.hleft)>0)) or ((psd.hcenteron=bf_Checked) and (length(psd.hmid)>0)) or ((psd.hrighton=bf_Checked) and (length(psd.hright)>0)))) or
				   ((atof(psd.fuss)<=0.0) and (((psd.flefton=bf_Checked) and (length(psd.fleft)>0)) or ((psd.fcenteron=bf_Checked) and (length(psd.fmid)>0)) or ((psd.frighton=bf_Checked) and (length(psd.fright)>0)))) then
					begin
						but:=Application^.Alert(@self,2,NOTE,MESSAGE_LAYOUT_HEADFOOT,BUTTON_OKMINIMALCANCEL);
						if but=2 then MinimalHeadFoot
						else
							if but<>1 then
								begin
									OK:=false;
									exit
								end
					end;
				if inherited OK then
					begin
						OK:=true;
						if Parent^.GetClassName=TEXELWINDCLASS then PCalcWindow(Parent)^.SetDirty
					end
				else
					OK:=false
			end
	end;


procedure TPSDialog.MinimalHeadFoot;
	label _fertig;

	var p         : PCalcWindow;
	    hcell,
	    num,q,hndl: integer;
	    ewrkout,
	    wrkout    : workout_ARRAY;
	    hmin,fmin,
	    yfak      : real;
	    psd       : TPSBuffer;
	    ops       : PPSBuffer;

	begin
		BusyMouse;
		p:=PCalcWindow(Parent);
		ops:=TransferBuffer;
		TransferBuffer:=@psd;
		TransferData(tf_GetData);
		TransferBuffer:=ops;
		hmin:=0.0;
		fmin:=0.0;
		if not(Application^.GDOSActive) then goto _fertig;
		if ((psd.hlefton=bf_Unchecked) or (length(psd.hleft)=0)) and ((psd.hcenteron=bf_Unchecked) or (length(psd.hmid)=0)) and ((psd.hrighton=bf_Unchecked) or (length(psd.hright)=0)) and
		   ((psd.flefton=bf_Unchecked) or (length(psd.fleft)=0)) and ((psd.fcenteron=bf_Unchecked) or (length(psd.fmid)=0)) and ((psd.frighton=bf_Unchecked) or (length(psd.fright)=0)) then goto _fertig;
		if p^.prnt=nil then goto _fertig;
		if not(PPrint(p^.prnt)^.IsAvailable(true)) then goto _fertig;
		num:=PPrint(p^.prnt)^.GetDevice;
		if (num<11) or (num>99) then goto _fertig;
		vOpnwk(num,hndl,wrkout,PPrint(p^.prnt)^.GetPaperSize,'',p^.wnd_prnt_set);
		if hndl<>0 then
			begin
				inc(wrkout[10],vst_load_fonts(hndl,0));
				vq_extnd(hndl,1,ewrkout);
				vst_font(hndl,p^.GetStdFontIndex);
				{$IFDEF NVDI5}
				vst_arbpt(hndl,p^.GetStdFontSize,q,q,q,hcell);
				{$ELSE}
				if p^.Speedo then vst_arbpt(hndl,p^.GetStdFontSize,q,q,q,hcell)
				else
					vst_point(hndl,p^.GetStdFontSize,q,q,q,hcell);
				{$ENDIF}
				vst_unload_fonts(hndl,0);
				v_clswk(hndl);
				case ewrkout[20] of
				1:
					yfak:=longint(ewrkout[22])/longint(100);
				2:
					yfak:=longint(ewrkout[22])/longint(1000);
				3:
					yfak:=longint(ewrkout[22])/longint(10000)
				else
					yfak:=longint(wrkout[4])/longint(10)
				end;
				yfak:=round(yfak*(hcell+1))/100.0;
				if (((psd.hlefton=bf_Checked) and (length(psd.hleft)>0)) or ((psd.hcenteron=bf_Checked) and (length(psd.hmid)>0)) or ((psd.hrighton=bf_Checked) and (length(psd.hright)>0))) then hmin:=yfak;
				if (((psd.flefton=bf_Checked) and (length(psd.fleft)>0)) or ((psd.fcenteron=bf_Checked) and (length(psd.fmid)>0)) or ((psd.frighton=bf_Checked) and (length(psd.fright)>0))) then fmin:=yfak
			end;
		_fertig:
		ed1^.SetText(ftoa(hmin));
		ed2^.SetText(ftoa(fmin));
		ArrowMouse
	end;


function TPSDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		case AnIndx of
		RTPSSET:
			OK;
		RTPSMINIMAL:
			MinimalHeadFoot
		end
	end;


constructor TObjSizeDialog.Init(AParent: PWindow; AEmbed: pointer; ATitle,HypHelp,hdTitle: string; Indx: integer);

	begin
		if not(inherited Init(AParent,ATitle,HypHelp,hdTitle,Indx)) then fail;
		embedobj:=AEmbed
	end;


function TObjSizeDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTOSSET);
		OK:=valid
	end;


function TObjSizeDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=RTOSSET then
			if inherited OK then
				begin
					with PEmbedded(embedobj)^ do
						begin
							Redraw;
							if IsLocked then Application^.Bing
							else
								begin
									XPos_mm100:=round(atof(osbuf.x)*100.0);
									YPos_mm100:=round(atof(osbuf.y)*100.0);
									Width_mm100:=round(atof(osbuf.width)*100.0);
									Height_mm100:=round(atof(osbuf.height)*100.0);
									Redraw
								end
						end;
					PCalcWindow(Parent)^.SetDirty
				end
	end;


procedure TObjAttrBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		if GetCheck=bf_Checked then PObjAttrDialog(Parent)^.pbg^.Disable
		else
			PObjAttrDialog(Parent)^.pbg^.Enable
	end;


constructor TObjAttrDialog.Init(AParent: PWindow; AEmbed: pointer; ATitle,HypHelp,hdTitle: string; Indx,sbt: integer);

	begin
		if not(inherited Init(AParent,ATitle,HypHelp,hdTitle,Indx)) then fail;
		setbtn:=sbt;
		embedobj:=AEmbed
	end;


function TObjAttrDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(setbtn);
		OK:=valid
	end;


function TObjAttrDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=setbtn then
			begin
				TransferData(tf_GetData);
				PEmbedded(embedobj)^.Redraw;
				PCalcWindow(Parent)^.SetDirty
			end
	end;


constructor TProtoEmbedded.Init(otyp: integer; fname: string; fdat: pointer; fdatlen,x,y,w100,h100: longint; const oab: TEmbedBuf; const cbb: TEmbedCheckBuf; pdb: PDiagrammBuf; prp,emb,skl,umb,prnt,lck: boolean);

	begin
		if not(inherited Init) then fail;
		Next:=nil;
		ObjTyp:=otyp;
		FileName:=fname;
		Data:=fdat;
		DataLen:=fdatlen;
		X100:=x;
		Y100:=y;
		Width100:=w100;
		Height100:=h100;
		oabuf:=oab;
		cbbuf:=cbb;
		diabuf:=pdb;
		prop:=prp;
		embd:=emb;
		skal:=skl;
		umbr:=umb;
		prntflg:=prnt;
		lckflg:=lck
	end;


destructor TProtoEmbedded.Done;

	begin
		if diabuf<>nil then freemem(diabuf,sizeof(TDiagrammBuf));
		inherited Done
	end;


procedure TProtoEmbedded.Realize(p: PCalcWindow);

	begin
		case ObjTyp of
		EMB_TYPE_ID4:
			p^.EmbedNewObject(FileName,Width100,Height100,X100,Y100,DataLen,Data,@oabuf,nil,true,prop,embd,false,false,prntflg,lckflg);
		EMB_TYPE_IMG:
			new(PEmbeddedIMG,Init(p,FileName,0,0,0,0,Width100,Height100,X100,Y100,DataLen,Data,true,true,prop,embd,skal,prntflg,lckflg,@oabuf));
		EMB_TYPE_TEXT:
			new(PEmbeddedText,Init(p,FileName,0,0,0,0,Width100,Height100,X100,Y100,DataLen,Data,true,true,prop,embd,umbr,prntflg,lckflg,@oabuf));
		EMB_TYPE_TAD:
			p^.EmbedNewObject(FileName,Width100,Height100,X100,Y100,DataLen,Data,@oabuf,diabuf,true,prop,embd,false,true,prntflg,lckflg);
		EMB_TYPE_CHECKBOX:
			new(PEmbeddedCheckBox,Init(p,0,0,0,0,Width100,Height100,X100,Y100,DataLen,Data,true,true,prop,prntflg,lckflg,@oabuf,@cbbuf));
		end;
		if Next=nil then p^.DeselectAllObjects
		else
			Next^.Realize(p);
		Free
	end;


constructor TEmbedded.Init(AParent: PCalcWindow; poi: POLGAObjectInfo; fName: string; srvid,pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,embd,prntflg,lckflg: boolean; poa: PEmbedBuf);
	var p: PEmbedded;

	begin
		if not(inherited Init) then fail;
		Parent:=AParent;
		if Parent=nil then fail;
		if not(HasFile) then FileName:=nil
		else
			begin
				FileName:=NewStr(fName);
				if FileName=nil then fail
			end;
		objectinfo:=poi;
		objsize:=nil;
		objattr:=nil;
		Data:=dat;
		DataLen:=dlen;
		Prev:=nil;
		Next:=nil;
		selected:=false;
		ServerID:=srvid;
		XPos_mm100:=0;
		YPos_mm100:=0;
		Width_mm100:=0;
		Height_mm100:=0;
		printflag:=true;
		ieactivated:=false;
		with osbuf do
			begin
				x:='';
				y:='';
				width:='';
				height:='';
				prop:=bf_Unchecked;
				sperr:=bf_Unchecked
			end;
		if poa<>nil then
			begin
				oabuf:=poa^;
				embedflag:=embd;
				if prop then SetPropFlag
				else
					ClearPropFlag
			end
		else
			begin
				with oabuf do
					begin
						color:=White;
						trans:=bf_Unchecked;
						border:=bf_Checked
					end;
				if HasFile then
					begin
						embedflag:=false;
						SetPropFlag
					end
				else
					begin
						embedflag:=true;
						if prop then SetPropFlag
						else
							ClearPropFlag
					end
			end;
		if Parent^.Embedded=nil then Parent^.Embedded:=@self
		else
			begin
				p:=Parent^.Embedded;
				while p^.Next<>nil do p:=p^.Next;
				p^.Next:=@self;
				Prev:=p
			end;
		if Parent^.objects<>nil then Parent^.objects^.Enable;
		if objectinfo<>nil then objectinfo^.ClientData:=longint(@self);
		ClearDirtyFlag;
		if prntflg then SetPrintFlag
		else
			ClearPrintFlag;
		if (Data=nil) or (DataLen=0) then CheckLink;
		Link;
		if draw then
			begin
				Parent^.DeselectAllObjects;
				selected:=true
			end;
		Resize(pixx,pixy,pixw,pixh,w100,h100,x100,y100,xyvalid,draw);
		if lckflg then Lock
		else
			Unlock;
		if Parent^.links<>nil then Parent^.links^.AddObject(@self)
	end;


destructor TEmbedded.Done;
	var answ: Pipearray;
	    tmd : string;

	begin
		IEDeactivate;
		if Parent^.links<>nil then Parent^.links^.RemoveObject(@self);
		if objectinfo<>nil then
			begin
				inc(objectinfo^.CBLock);
				if objectinfo^.CBLock>0 then
					if assigned(objectinfo^.CBUnembed) then objectinfo^.CBUnembed(nil,nil,0,0,0,objectinfo);
				dec(objectinfo^.CBLock);
				if ServerID>=0 then
					begin
						answ[0]:=OLGA_ID4UPDATE;
						answ[1]:=Application^.apID;
						answ[2]:=0;
						answ[3]:=0;
						answ[4]:=0;
						answ[5]:=0;
						answ[6]:=0;
						answ[7]:=0;
						appl_write(ServerID,16,@answ)
					end
			end;
		if (Prev=nil) and (Next=nil) then
			begin
				Parent^.Embedded:=nil;
				if Parent^.objects<>nil then Parent^.objects^.Disable
			end
		else
			begin
				if Prev=nil then Parent^.Embedded:=Next
					else Prev^.Next:=Next;
				if Next<>nil then Next^.Prev:=Prev
			end;
		if Data<>nil then freemem(Data,DataLen);
		GlobalFree(pointer(objectinfo),sizeof(TTexelObjectInfo));
		if FileName<>nil then
			begin
				tmd:=GetTexelTempDir;
				if StrPLeft(FileName^,length(tmd))=tmd then fdelete(FileName^)
			end;
		DisposeStr(FileName);
		inherited Done
	end;


function TEmbedded.IsExternal: boolean;

	begin
		IsExternal:=true
	end;


function TEmbedded.HasFile: boolean;

	begin
		HasFile:=true
	end;


function TEmbedded.GetType: integer;

	begin
		GetType:=EMB_TYPE_ID4
	end;


function TEmbedded.Save(hdl: integer; emb: boolean): boolean;
	var dummy: integer;

	begin
		Save:=true;
		dummy:=GetType;
		if bwrite(hdl,2,dummy) then exit;
		if SaveData(hdl,emb) then exit;
		Save:=false
	end;


function TEmbedded.SaveData(hdl: integer; emb: boolean): boolean;
	var dummy: longint;
	    prp  : boolean;

	begin
		SaveData:=true;
		if Filename<>nil then
			begin
				if fwrite(hdl,length(Filename^)+1,Filename)<>length(Filename^)+1 then exit
			end
		else
			begin
				dummy:=0;
				if bwrite(hdl,1,dummy) then exit
			end;
		if emb then dummy:=DataLen
		else
			dummy:=0;
		if bwrite(hdl,4,dummy) then exit;
		if dummy>0 then
			if fwrite(hdl,dummy,Data)<>dummy then exit;
		if bwrite(hdl,sizeof(oabuf),oabuf) then exit;
		if bwrite(hdl,4,Width_mm100) then exit;
		if bwrite(hdl,4,Height_mm100) then exit;
		prp:=IsProportional;
		if bwrite(hdl,sizeof(boolean),prp) then exit;
		if bwrite(hdl,sizeof(boolean),embedflag) then exit;
		prp:=CanPrint;
		if bwrite(hdl,sizeof(boolean),prp) then exit;
		SaveData:=false
	end;


function TEmbedded.GetExt(embed,default: boolean): string;
	var ret: string;

	begin
		if (length(GetFile)=0) and default then ret:=GetDefaultExt
		else
			ret:=GetExtension(GetFile);
		if (length(ret)>0) or not(embed) then
			begin
				ret:=StrPLeft(ret,4);
				while length(ret)<4 do ret:=ret+#0
			end;
		GetExt:=ret
	end;


function TEmbedded.GetDefaultExt: string;

	begin
		GetDefaultExt:=''
	end;


procedure TEmbedded.Link;
	var pipe: Pipearray;
	    pc  : pointer;

	begin
		if length(GetFile)>0 then
			if Application^.OLGAManager>=0 then
				begin
					GlobalAlloc(pc,256);
					if pc<>nil then
						begin
							StrPCopy(pc,GetFile);
							pipe[0]:=OLGA_LINK;
							pipe[1]:=Application^.apID;
							pipe[2]:=0;
							pipe[3]:=integer(HiWord(pc));
							pipe[4]:=integer(LoWord(pc));
							pipe[5]:=Parent^.GetOLGAGroup;
							pipe[6]:=0;
							pipe[7]:=0;
							appl_write(Application^.OLGAManager,16,@pipe)
						end
				end
	end;


procedure TEmbedded.Unlink;
	var pc  : pointer;
	    pipe: Pipearray;

	begin
		if length(GetFile)>0 then
			if Application^.OLGAManager>=0 then
				if not(Application^.Terminating) then
					begin
						GlobalAlloc(pc,256);
						if pc<>nil then
							begin
								StrPCopy(pc,GetFile);
								pipe[0]:=OLGA_UNLINK;
								pipe[1]:=Application^.apID;
								pipe[2]:=0;
								pipe[3]:=integer(HiWord(pc));
								pipe[4]:=integer(LoWord(pc));
								pipe[5]:=Parent^.GetOLGAGroup;
								pipe[6]:=0;
								pipe[7]:=0;
								appl_write(Application^.OLGAManager,16,@pipe)
							end
					end
	end;


procedure TEmbedded.BreakLink;

	begin
		SetFile('');
		{ !!! }
	end;


procedure TEmbedded.CheckLink;
	label _error;

	var res: longint;
	    hdl: integer;

	begin
		if Data<>nil then freemem(Data,DataLen);
		Data:=nil;
		DataLen:=0;
		if length(GetFile)=0 then exit;
		res:=fopen(GetFile,FO_READ);
		if res<0 then exit;
		hdl:=integer(res);
		DataLen:=fseek(0,hdl,2);
		if DataLen<0 then goto _error;
		if fseek(0,hdl,0)<0 then goto _error;
		getmem(Data,DataLen);
		if Data<>nil then
			if fread(hdl,DataLen,Data)<>DataLen then
				begin
					freemem(Data,DataLen);
					Data:=nil;
					DataLen:=0
				end;
		_error:
		fclose(hdl)
	end;


procedure TEmbedded.Update;

	begin
		ClearDirtyFlag;
		CheckLink;
		Redraw
	end;


function TEmbedded.CreateLinkFile: boolean;
	var s  : string;
	    ret: longint;
	    hdl: integer;

	begin
		if Exist(GetFile) then CreateLinkFile:=true
		else
			begin
				CreateLinkFile:=false;
				if (DataLen<=0) or (Data=nil) then exit;
				if length(GetFile)=0 then
					begin
						repeat
							s:=GetTexelTempDir+GetTempFilename;
							if length(GetDefaultExt)>0 then s:=CutRightF(s,4)+GetDefaultExt
						until not(Exist(s))
					end
				else
					begin
						s:=GetTexelTempDir+GetFilename(GetFile,true);
						while Exist(s) do
							s:=GetTexelTempDir+GetFilename(GetTempFilename,false)+GetExtension(GetFile)
					end;
				ret:=fcreate(s,0);
				if ret>=0 then
					begin
						hdl:=integer(ret);
						if fwrite(hdl,DataLen,Data)<>DataLen then
							begin
								fclose(hdl);
								exit
							end
						else
							fclose(hdl);
						Unlink;
						SetFile(s);
						Link;
						CreateLinkFile:=true
					end
			end
	end;


procedure TEmbedded.SetWorkstationValues(dev,colrs: integer; xofs,yofs: longint; xmm100,ymm100,perc,ffak: real; scale,outs: boolean);

	begin
		devID:=dev;
		XOffs:=xofs;
		YOffs:=yofs;
		xmm100fak:=xmm100;
		ymm100fak:=ymm100;
		ScaleIMG:=scale;
		percent:=perc;
		fontfak:=ffak;
		colors:=colrs;
		outscr:=outs
	end;


procedure TEmbedded.Paint(handle: integer; const clip: GRECT; screen: boolean);
	var pxy,ps: ARRAY_4;
	    pxya  : array [0..9] of integer;
	    d     : integer;
	    g     : GRECT;

	begin
		PaintX:=GetPixXPos(screen);
		PaintY:=GetPixYPos(screen);
		PaintW:=GetPixWidth(screen);
		PaintH:=GetPixHeight(screen);
		vsf_perimeter(handle,PER_ON);
		if screen then
			if oabuf.trans=bf_Checked then
				begin
					g.X:=PaintX;
					g.Y:=PaintY;
					g.W:=PaintW;
					g.H:=PaintH;
					if rc_intersect(clip,g) then
						begin
							Parent^.GetBlock(Parent^.dblock^.GetText,false,ps[0],ps[1],ps[2],ps[3],d,d);
							Parent^.DrawBlockRaw(ps[0],ps[1],ps[2],ps[3],g)
						end
				end;
		vswr_mode(handle,MD_REPLACE);
		pxy[0]:=PaintX;
		pxy[1]:=PaintY;
		pxy[2]:=pxy[0]+PaintW-1;
		pxy[3]:=pxy[1]+PaintH-1;
		if oabuf.trans<>bf_Checked then
			begin
				vsf_interior(handle,FIS_SOLID);
				if not(screen) and (oabuf.color>=colors) then vsf_color(handle,Black)
				else
					vsf_color(handle,oabuf.color);
				v_bar(handle,pxy)
			end;
		if (oabuf.border=bf_Checked) or (screen and IsSelected) then
			begin
				vsl_type(handle,LT_SOLID);
				vsl_color(handle,Black);
				vsl_width(handle,1);
				vsl_ends(handle,LE_SQUARED,LE_SQUARED);
				pxya[0]:=pxy[0];
				pxya[1]:=pxy[1];
				pxya[2]:=pxy[2];
				pxya[3]:=pxy[1];
				pxya[4]:=pxy[2];
				pxya[5]:=pxy[3];
				pxya[6]:=pxy[0];
				pxya[7]:=pxy[3];
				pxya[8]:=pxy[0];
				pxya[9]:=pxy[1];
				v_pline(handle,5,pxya)
			end;
		UserPaint(handle,clip,screen);
		vsl_width(handle,1);
		vsl_ends(handle,LE_SQUARED,LE_SQUARED);
		if screen then
			begin
				if IsIEActive then
					begin
						vsl_udsty(handle,$5555);
						vsl_type(handle,LT_USERDEF);
						vsl_color(handle,Black);
						vsl_width(handle,1);
						vsl_ends(handle,LE_SQUARED,LE_SQUARED);
						pxya[0]:=pxy[0];
						pxya[1]:=pxy[1];
						pxya[2]:=pxy[2];
						pxya[3]:=pxy[1];
						pxya[4]:=pxy[2];
						pxya[5]:=pxy[3];
						pxya[6]:=pxy[0];
						pxya[7]:=pxy[3];
						pxya[8]:=pxy[0];
						pxya[9]:=pxy[1];
						v_pline(handle,5,pxya);
						inc(pxya[0]);
						inc(pxya[1]);
						dec(pxya[2]);
						inc(pxya[3]);
						dec(pxya[4]);
						dec(pxya[5]);
						inc(pxya[6]);
						dec(pxya[7]);
						inc(pxya[8]);
						inc(pxya[9]);
						v_pline(handle,5,pxya);
						inc(pxya[0]);
						inc(pxya[1]);
						dec(pxya[2]);
						inc(pxya[3]);
						dec(pxya[4]);
						dec(pxya[5]);
						inc(pxya[6]);
						dec(pxya[7]);
						inc(pxya[8]);
						inc(pxya[9]);
						v_pline(handle,5,pxya);
						vsl_type(handle,LT_SOLID)
					end
				else
					if IsSelected then
						begin
							vs_clip(handle,CLIP_ON,clip.A2);
							vswr_mode(handle,MD_REPLACE);
							vsf_perimeter(handle,PER_ON);
							if IsLocked then
								begin
									vsf_interior(handle,FIS_PATTERN);
									vsf_style(handle,4)
								end
							else
								vsf_interior(handle,FIS_SOLID);
							vsf_color(handle,Black);
							d:=round(8.0*Parent^.PercentSize);
							ps[0]:=pxy[0];
							ps[1]:=pxy[1];
							ps[2]:=pxy[0]+d;
							ps[3]:=pxy[1]+d;
							v_bar(handle,ps);
							ps[0]:=pxy[2]-d;
							ps[1]:=pxy[1];
							ps[2]:=pxy[2];
							ps[3]:=pxy[1]+d;
							v_bar(handle,ps);
							ps[0]:=pxy[2]-d;
							ps[1]:=pxy[3]-d;
							ps[2]:=pxy[2];
							ps[3]:=pxy[3];
							v_bar(handle,ps);
							ps[0]:=pxy[0];
							ps[1]:=pxy[3]-d;
							ps[2]:=pxy[0]+d;
							ps[3]:=pxy[3];
							v_bar(handle,ps);
							if not(IsProportional) then
								begin
									ps[0]:=(pxy[0]+pxy[2]-d) shr 1;
									ps[1]:=pxy[1];
									ps[2]:=ps[0]+d;
									ps[3]:=pxy[1]+d;
									v_bar(handle,ps);
									ps[1]:=pxy[3]-d;
									ps[3]:=pxy[3];
									v_bar(handle,ps);
									ps[0]:=pxy[2]-d;
									ps[1]:=(pxy[1]+pxy[3]-d) shr 1;
									ps[2]:=pxy[2];
									ps[3]:=ps[1]+d;
									v_bar(handle,ps);
									ps[0]:=pxy[0];
									ps[2]:=pxy[0]+d;
									v_bar(handle,ps)
								end;
							vsf_interior(handle,FIS_SOLID)
						end;
				g.X:=PaintX;
				g.Y:=PaintY;
				g.W:=PaintW;
				g.H:=PaintH;
				if rc_intersect(clip,g) then
					begin
						Parent^.GetBlock(Parent^.dblock^.GetText,false,ps[0],ps[1],ps[2],ps[3],d,d);
						Parent^.DrawBlockRaw(ps[0],ps[1],ps[2],ps[3],g)
					end
			end
	end;


procedure TEmbedded.UserPaint(handle: integer; clip: GRECT; screen: boolean);
	label _fehler;

	var cnt,q,
	    odi,os   : integer;
	    psi,pcl  : PGRECT;
	    prc      : longint;

	begin
		if objectinfo=nil then goto _fehler;
		if ServerID<0 then goto _fehler;
		if not(CreateLinkFile) then goto _fehler;
		inc(objectinfo^.CBLock);
		if objectinfo^.CBLock<=0 then goto _fehler;
		if screen or outscr then os:=1
		else
			os:=0;
		if screen then
			begin
				prc:=round(Parent^.PercentSize*10000.0);
				odi:=0
			end
		else
			begin
				prc:=round(percent*10000.0);
				odi:=devID
			end;
		psi:=@PTexelObjectInfo(objectinfo)^.r1;
		psi^.X:=PaintX+1;
		psi^.Y:=PaintY+1;
		psi^.W:=PaintW-2;
		psi^.H:=PaintH-2;
		GRtoA2(psi^);
		if rc_intersect(psi^,clip) then
			begin
				vs_clip(handle,CLIP_ON,clip.A2);
				pcl:=@PTexelObjectInfo(objectinfo)^.r2;
				pcl^:=clip;
				StrPCopy(objectinfo^.Filename,GetFile);
				if assigned(objectinfo^.CBXDraw) then objectinfo^.CBXDraw(nil,nil,0,0,0,objectinfo,os,handle,odi,psi,pcl,Width_mm100*10,Height_mm100*10,prc)
				else
					if assigned(objectinfo^.CBDraw) then objectinfo^.CBDraw(nil,nil,0,0,0,objectinfo,os,handle,odi,psi,pcl)
					else
						begin
							dec(objectinfo^.CBLock);
							goto _fehler
						end
			end;
		dec(objectinfo^.CBLock);
		exit;
		_fehler:
		vsl_color(handle,Red);
		pxya[0]:=PaintX+1;
		pxya[1]:=PaintY+1;
		pxya[2]:=PaintX+PaintW-2;
		pxya[3]:=PaintY+PaintH-2;
		v_pline(handle,2,pxya);
		pxya[1]:=pxya[3];
		pxya[3]:=PaintY+1;
		v_pline(handle,2,pxya)
	end;


procedure TEmbedded.Redraw;
	var r1,r2: GRECT;
	    pipe : Pipearray;

	begin
		Parent^.GetSheetRect(r1);
		with r2 do
			begin
				X:=GetPixXPos(true);
				Y:=GetPixYPos(true);
				W:=GetPixWidth(true);
				H:=GetPixHeight(true)
			end;
		if rc_intersect(r1,r2) then
			begin
				pipe[0]:=WM_REDRAW;
				pipe[1]:=Application^.apID;
				pipe[2]:=0;
				pipe[3]:=Parent^.Attr.gemHandle;
				pipe[4]:=r2.X;
				pipe[5]:=r2.Y;
				pipe[6]:=r2.W;
				pipe[7]:=r2.H;
				appl_write(pipe[1],16,@pipe)
			end
	end;


procedure TEmbedded.Unembed;

	begin
		ServerID:=id_No;
		Redraw
	end;


function TEmbedded.IsVisible(const r: GRECT; screen: boolean): boolean;
	var r2: GRECT;

	begin
		with r2 do
			begin
				X:=GetPixXPos(screen);
				Y:=GetPixYPos(screen);
				W:=GetPixWidth(screen);
				H:=GetPixHeight(screen)
			end;
		IsVisible:=rc_intersect(r,r2)
	end;


procedure TEmbedded.Resize(pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100: longint; xyvalid,draw: boolean);

	begin
		if draw then
			if (Width_mm100>0) and (Height_mm100>0) then Redraw;
		if IsLocked then Application^.Bing
		else
			begin
				if xyvalid then
					begin
						XPos_mm100:=x100;
						YPos_mm100:=y100
					end
				else
					begin
						XPos_mm100:=round((longint(pixx)+Parent^.Scroller^.XPos-Parent^.LeftColWidth-Parent^.Work.X)*longint(Application^.Attr.PixW)/(10.0*Parent^.PercentSize));
						YPos_mm100:=round((longint(pixy)+Parent^.Scroller^.YPos-Parent^.PaintOffs-Parent^.TopRowHeight-Parent^.Work.Y-1)*longint(Application^.Attr.PixH)/(10.0*Parent^.PercentSize))
					end;
				if w100>0 then Width_mm100:=w100
				else
					Width_mm100:=round(longint(pixw-1)*longint(Application^.Attr.PixW)/(10.0*Parent^.PercentSize));
				if h100>0 then Height_mm100:=h100
				else
					Height_mm100:=round(longint(pixh-1)*longint(Application^.Attr.PixH)/(10.0*Parent^.PercentSize));
				{ CELL_INVISIBLE !!! }
				if draw then Redraw;
				with osbuf do
					begin
						x:=ftoa(XPos_mm100/100.0);
						y:=ftoa(YPos_mm100/100.0);
						width:=ftoa(Width_mm100/100.0);
						height:=ftoa(Height_mm100/100.0);
						if objsize<>nil then
							with PObjSizeDialog(objsize)^ do
								begin
									if ed1<>nil then ed1^.SetText(x);
									if ed2<>nil then ed2^.SetText(y);
									if ed3<>nil then ed3^.SetText(width);
									if ed4<>nil then ed4^.SetText(height)
								end
					end
			end
	end;


function TEmbedded.GetPixXPos(screen: boolean): integer;

	begin
		if screen then GetPixXPos:=round(XPos_mm100*10.0*Parent^.PercentSize/longint(Application^.Attr.PixW))+Parent^.LeftColWidth+Parent^.Work.X-Parent^.Scroller^.XPos
		else
			GetPixXPos:=round(XPos_mm100*xmm100fak)-XOffs
	end;


function TEmbedded.GetPixYPos(screen: boolean): integer;

	begin
		if screen then GetPixYPos:=round(YPos_mm100*10.0*Parent^.PercentSize/longint(Application^.Attr.PixH))+Parent^.PaintOffs+Parent^.TopRowHeight+Parent^.Work.Y+1-Parent^.Scroller^.YPos
		else
			GetPixYPos:=round(YPos_mm100*ymm100fak)-YOffs
	end;


function TEmbedded.GetPixWidth(screen: boolean): integer;

	begin
		if screen then GetPixWidth:=round(Width_mm100*10.0*Parent^.PercentSize/longint(Application^.Attr.PixW))+1
		else
			GetPixWidth:=round(Width_mm100*xmm100fak)+1
	end;


function TEmbedded.GetPixHeight(screen: boolean): integer;

	begin
		if screen then GetPixHeight:=round(Height_mm100*10.0*Parent^.PercentSize/longint(Application^.Attr.PixH))+1
		else
			GetPixHeight:=round(Height_mm100*ymm100fak)+1
	end;


function TEmbedded.IsInside(mx,my: integer): boolean;
	var x,y: integer;

	begin
		x:=GetPixXPos(true);
		y:=GetPixYPos(true);
		IsInside:=Between(mx,x,x+GetPixWidth(true)-1) and Between(my,y,y+GetPixHeight(true)-1)
	end;


procedure TEmbedded.DoClick(mX,mY,KStat: integer);

	begin
		Toggle
	end;


procedure TEmbedded.Click(mX,mY,KStat: integer);
	var ms,dummy,
	    fx,fy,el,
	    xo,yo,
	    xdif,ydif,
	    w,h,d,x,y: integer;
	    r        : GRECT;

	begin
		if Parent^.inpstat then
			begin
				Application^.Bing;
				exit
			end;
		if IsIEActive then
			begin
				IESendButton(mX,mY,1,1,KStat);
				exit
			end;
		evnt_timer(10,0);
		graf_mkstate(dummy,dummy,ms,dummy);
		if not(bTst(ms,1)) then DoClick(mX,mY,KStat)
		else
			begin
				wind_update(BEG_UPDATE);
				wind_update(BEG_MCTRL);
				x:=GetPixXPos(true);
				y:=GetPixYPos(true);
				w:=GetPixWidth(true);
				h:=GetPixHeight(true);
				Parent^.GetSheetRect(r);
				el:=-1;
				if IsSelected then
					begin
						d:=round(8.0*Parent^.PercentSize);
						if mX<=x+d then
							begin
								if mY<=y+d then el:=0
								else if mY>=y+h-d then el:=6
								else
									if not(IsProportional) then
										if Between(mY,y+((h-d) shr 1),y+((h+d) shr 1)) then el:=7
							end
						else if mX>=x+w-d then
							begin
								if mY<=y+d then el:=2
								else if mY>=y+h-d then el:=4
								else
									if not(IsProportional) then
										if Between(mY,y+((h-d) shr 1),y+((h+d) shr 1)) then el:=3
							end
						else
							if not(IsProportional) then
								if Between(mX,x+((w-d) shr 1),x+((w+d) shr 1)) then
									begin
										if mY<=y+d then el:=1
										else if mY>=y+h-d then el:=5
									end
					end;
				if el>=0 then
					begin
						d:=round(20.0*Parent^.PercentSize);
						SetMouse(THIN_CROSS,nil);
						pxya[0]:=x;
						pxya[1]:=y;
						pxya[2]:=x+w-1;
						pxya[3]:=y;
						pxya[4]:=pxya[2];
						pxya[5]:=y+h-1;
						pxya[6]:=x;
						pxya[7]:=pxya[5];
						pxya[8]:=x;
						pxya[9]:=y;
						case el of
						0,1:
							begin
								xdif:=x-mX;
								ydif:=y-mY
							end;
						2,3:
							begin
								xdif:=x+w-mX-1;
								ydif:=y-mY
							end;
						4,5:
							begin
								xdif:=x+w-mX-1;
								ydif:=y+h-mY-1
							end;
						6,7:
							begin
								xdif:=x-mX;
								ydif:=y+h-mY-1
							end
						end;
						vswr_mode(Parent^.vdiHandle,MD_XOR);
						vsl_type(Parent^.vdiHandle,LT_USERDEF);
						xo:=mX;
						yo:=mY;
						HideMouse;
						repeat
							mX:=xo;
							mY:=yo;
							case el of
							0:
								begin
									pxya[0]:=mX+xdif;
									if pxya[0]>pxya[2]-d then pxya[0]:=pxya[2]-d;
									if IsProportional then
										begin
											if round(longint(h)*longint(pxya[2]-pxya[0])/longint(w))<d then pxya[0]:=pxya[2]-round(longint(d)*longint(w)/longint(h));
											pxya[1]:=pxya[5]-round(longint(h)*longint(pxya[2]-pxya[0])/longint(w))
										end
									else
										begin
											pxya[1]:=mY+ydif;
											if pxya[1]>pxya[5]-d then pxya[1]:=pxya[5]-d
										end;
									pxya[8]:=pxya[0];
									pxya[9]:=pxya[1];
									pxya[6]:=pxya[0];
									pxya[3]:=pxya[1]
								end;
							1:
								begin
									pxya[1]:=mY+ydif;
									if pxya[1]>pxya[5]-d then pxya[1]:=pxya[5]-d;
									pxya[9]:=pxya[1];
									pxya[3]:=pxya[1]
								end;
							2:
								begin
									pxya[2]:=mX+xdif;
									if pxya[2]<pxya[0]+d then pxya[2]:=pxya[0]+d;
									if IsProportional then
										begin
											if round(longint(h)*longint(pxya[2]-pxya[0])/longint(w))<d then pxya[2]:=round(longint(d)*longint(w)/longint(h))+pxya[0];
											pxya[3]:=pxya[5]-round(longint(h)*longint(pxya[2]-pxya[0])/longint(w))
										end
									else
										begin
											pxya[3]:=mY+ydif;
											if pxya[3]>pxya[5]-d then pxya[3]:=pxya[5]-d
										end;
									pxya[1]:=pxya[3];
									pxya[9]:=pxya[3];
									pxya[4]:=pxya[2]
								end;
							3:
								begin
									pxya[2]:=mX+xdif;
									if pxya[2]<pxya[0]+d then pxya[2]:=pxya[0]+d;
									pxya[4]:=pxya[2]
								end;
							4:
								begin
									pxya[4]:=mX+xdif;
									if pxya[4]<pxya[0]+d then pxya[4]:=pxya[0]+d;
									if IsProportional then
										begin
											if round(longint(h)*longint(pxya[4]-pxya[0])/longint(w))<d then pxya[4]:=round(longint(d)*longint(w)/longint(h))+pxya[0];
											pxya[5]:=pxya[1]+round(longint(h)*longint(pxya[4]-pxya[0])/longint(w))
										end
									else
										begin
											pxya[5]:=mY+ydif;
											if pxya[5]<pxya[1]+d then pxya[5]:=pxya[1]+d
										end;
									pxya[2]:=pxya[4];
									pxya[7]:=pxya[5]
								end;
							5:
								begin
									pxya[5]:=mY+ydif;
									if pxya[5]<pxya[1]+d then pxya[5]:=pxya[1]+d;
									pxya[7]:=pxya[5]
								end;
							6:
								begin
									pxya[6]:=mX+xdif;
									if pxya[6]>pxya[2]-d then pxya[6]:=pxya[2]-d;
									if IsProportional then
										begin
											if round(longint(h)*longint(pxya[2]-pxya[6])/longint(w))<d then pxya[6]:=pxya[2]-round(longint(d)*longint(w)/longint(h));
											pxya[7]:=pxya[1]+round(longint(h)*longint(pxya[2]-pxya[6])/longint(w))
										end
									else
										begin
											pxya[7]:=mY+ydif;
											if pxya[7]<pxya[1]+d then pxya[7]:=pxya[1]+d
										end;
									pxya[8]:=pxya[6];
									pxya[0]:=pxya[6];
									pxya[5]:=pxya[7]
								end;
							7:
								begin
									pxya[6]:=mX+xdif;
									if pxya[6]>pxya[2]-d then pxya[6]:=pxya[2]-d;
									pxya[8]:=pxya[6];
									pxya[0]:=pxya[6]
								end
							end;
							v_pline(Parent^.vdiHandle,5,pxya);
							ShowMouse;
							repeat
								graf_mkstate(xo,yo,ms,dummy)
							until (xo<>mX) or (yo<>mY) or ((ms and 3)<>1);
							HideMouse;
							v_pline(Parent^.vdiHandle,5,pxya)
						until (ms and 3)<>1;
						ShowMouse;
						vsl_type(Parent^.vdiHandle,LT_SOLID);
						vswr_mode(Parent^.vdiHandle,MD_REPLACE);
						if (ms and 3)=0 then
							begin
								Resize(pxya[0],pxya[1],pxya[4]+1-pxya[0],pxya[5]+1-pxya[1],0,0,0,0,false,true);
								Parent^.SetDirty
							end
					end
				else
					begin
						SetMouse(FLAT_HAND,nil);
						if graf_dragbox(w,h,x,y,r.X+2-w,r.Y+2-h,r.W+(w shl 1)-4,r.H+(h shl 1)-4,fx,fy)<>0 then
							begin
								Resize(fx,fy,w,h,0,0,0,0,false,true);
								Parent^.SetDirty
							end
					end;
				LastMouse;
				wind_update(END_MCTRL);
				wind_update(END_UPDATE)
			end
	end;


procedure TEmbedded.DblClick(mX,mY,KStat: integer);
	label _raus;
	
	var callpath,s: string;
	    ret       : longint;
	    hdl,q     : integer;
	    pc        : pointer;
	    pc2       : PChar;
	    pipe      : Pipearray;

	begin
		if IsIEActive then
			begin
				if bTst(Kbshift(-1),K_CTRL) then
					begin
						IEDeactivate;
						Redraw
					end
				else
					begin
						IESendButton(mX,mY,2,1,KStat);
						exit
					end
			end
		else
			if CanUseIE then
				begin
					IEActivate;
					exit
				end;
		callpath:='';
		if Application^.OLGAManager<0 then goto _raus;
		if Exist(GetFile) then callpath:=GetFile
		else
			if (DataLen>0) and (Data<>nil) then
				begin
					if length(GetFile)=0 then
						begin
							repeat
								callpath:=GetTexelTempDir+GetTempFilename;
								if length(GetDefaultExt)>0 then callpath:=CutRightF(callpath,4)+GetDefaultExt
							until not(Exist(callpath))
						end
					else
						callpath:=GetTexelTempDir+GetFilename(GetFile,true);
					ret:=fcreate(callpath,0);
					if ret>=0 then
						begin
							hdl:=integer(ret);
							fwrite(hdl,DataLen,Data);
							fclose(hdl);
							Unlink;
							SetFile(callpath);
							Link
						end
					else
						callpath:=''
				end;
		_raus:
		if length(callpath)=0 then Application^.Bing
		else
			begin
				GlobalAlloc(pc,256);
				if pc<>nil then
					begin
						StrPCopy(pc,callpath);
						pipe[0]:=OLGA_START;
						pipe[1]:=Application^.apID;
						pipe[2]:=0;
						pipe[3]:=OLS_EXTENSION;
						pipe[6]:=integer(HiWord(pc));
						pipe[7]:=integer(LoWord(pc));
						s:=StrPUpper(GetExt(false,true));
						pc2:=PChar(@pipe[4]);
						for q:=1 to 4 do
							begin
								pc2^:=s[q];
								inc(longint(pc2))
							end;
						appl_write(Application^.OLGAManager,16,@pipe)
					end
			end
	end;


procedure TEmbedded.RButton(mX,mY,KStat,Clicks: integer);

	begin
		if IsIEActive then IESendButton(mX,mY,Clicks,2,KStat)
		else
			if Clicks=1 then DoMenu(mX,mY)
	end;


procedure TEmbedded.DoMenu(mX,mY: integer);
	var p: PPopup;

	begin
		TexelApp.ActivateExtResource;
		new(p,Init(Parent,RTPOPUPS2,RTP2OBJECT,id_No));
		TexelApp.DeactivateExtResource;
		if p<>nil then
			begin
				BusyMouse;
				Parent^.CheckPasteObject(p);
				if (Data=nil) or (DataLen<=0) then p^.Disable(5);
				if (Application^.OLGAManager<0) or (not(Exist(GetFile)) and ((DataLen<=0) or (Data=nil))) then p^.Disable(6);
				ArrowMouse;
				if IsEmbedded then p^.Check(11);
				if CanPrint then p^.Check(12);
				HandleMenu(Application^.Popup(p,mX,mY,POP_CENTER))
			end
	end;


procedure TEmbedded.HandleMenu(indx: integer);
	var path,
	    name,
	    ext : string;
	    ret : longint;
	    hdl : integer;
	    pb  : PButton;

	begin
		case indx of
		0:
			Cut;
		1:
			Copy;
		2:
			Paste;
		3:
			if Application^.Alert(Parent,2,WAIT,MESSAGE_EMBED_DELETE,BUTTON_YESNO)=1 then Destroy;
		5:
			begin
				path:='';
				name:='';
				ext:=GetExtension(GetFile);
				if length(ext)=0 then ext:=GetDefaultExt;
				if length(ext)=0 then ext:='.*';
				if FileSelect(Parent,FSELTITLE_OBJECTSAVEAS,'*'+ext,path,name,false) then
					begin
						if Exist(path+name) then
							if Application^.Alert(Parent,1,WAIT,MESSAGE_EMBED_EXIST1+CompressPath(path+name,78)+MESSAGE_EMBED_EXIST2,BUTTON_YESNO)<>1 then exit;
						ret:=fcreate(path+name,0);
						if ret>=0 then
							begin
								hdl:=integer(ret);
								fwrite(hdl,DataLen,Data);
								fclose(hdl)
							end
					end
			end;
		6:
			Edit;
		8:
			begin
				if objsize=nil then
					begin
						TexelApp.ActivateExtResource;
						objsize:=new(PObjSizeDialog,Init(Parent,@self,TEXELWINDPREFIX+TITLE_OBJSIZE,STG_OBJSIZE,ICNTITLE_OBJSIZE,RTOBJSIZE));
						if objsize<>nil then
							begin
								new(PGroupBox,Init(objsize,RTOSSIZE,'',BUBBLE_OBJSIZE_SIZE));
								new(PGroupBox,Init(objsize,RTOSFLAGS,'',BUBBLE_OBJSIZE_FLAGS));
								new(PObjSizeDialog(objsize)^.ed1,Init(objsize,RTOSX,8,BUBBLE_OBJSIZE_X));
								if PObjSizeDialog(objsize)^.ed1<>nil then PObjSizeDialog(objsize)^.ed1^.SetValidator(new(PMinMaxValidator,Init(-999.99,999.99)));
								new(PObjSizeDialog(objsize)^.ed2,Init(objsize,RTOSY,8,BUBBLE_OBJSIZE_Y));
								if PObjSizeDialog(objsize)^.ed2<>nil then PObjSizeDialog(objsize)^.ed2^.SetValidator(new(PMinMaxValidator,Init(-999.99,999.99)));
								new(PObjSizeDialog(objsize)^.ed3,Init(objsize,RTOSWIDTH,8,BUBBLE_OBJSIZE_WIDTH));
								if PObjSizeDialog(objsize)^.ed3<>nil then PObjSizeDialog(objsize)^.ed3^.SetValidator(new(PMinMaxValidator,Init(5.0,999.99)));
								new(PObjSizeDialog(objsize)^.ed4,Init(objsize,RTOSHEIGHT,8,BUBBLE_OBJSIZE_HEIGHT));
								if PObjSizeDialog(objsize)^.ed4<>nil then PObjSizeDialog(objsize)^.ed4^.SetValidator(new(PMinMaxValidator,Init(5.0,999.99)));
								new(PObjSizeDialog(objsize)^.cb1,Init(objsize,RTOSPROP,true,BUBBLE_OBJSIZE_PROP));
								new(PObjSizeDialog(objsize)^.cb2,Init(objsize,RTOSSPERR,true,BUBBLE_OBJSIZE_SPERR));
								new(pb,Init(objsize,RTOSHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(objsize,RTOSCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(objsize,RTOSSET,id_No,true,BUBBLE_GENERAL_OBJSET));
								new(PButton,Init(objsize,RTOSOK,id_OK,true,BUBBLE_GENERAL_OBJSETOK));
								objsize^.TransferBuffer:=@osbuf
							end;
						TexelApp.DeactivateExtResource
					end;
				if objsize<>nil then objsize^.MakeWindow
			end;
		9:
			begin
				if objattr=nil then
					begin
						TexelApp.ActivateExtResource;
						objattr:=new(PObjAttrDialog,Init(Parent,@self,TEXELWINDPREFIX+TITLE_OBJATTR,STG_OBJATTR,ICNTITLE_OBJATTR,RTOBJATTR,RTOASET));
						if objattr<>nil then
							begin
								new(PGroupBox,Init(objattr,RTOABACKGROUND,GROUP_OBJECT_BACKGR,BUBBLE_OBJATTR_BACKGR));
								PObjAttrDialog(objattr)^.pbg:=new(PColorBox,Init(objattr,RTOACOLOR,RTOACOLCYC,RTOACOLTITLE,RTPOPUPS2,RTP2COLOR,RTP2COLSTART,false,false,BUBBLE_OBJATTR_BGCOL));
								new(PObjAttrBox,Init(objattr,RTOATRANS,true,BUBBLE_OBJATTR_TRANS));
								new(PCheckBox,Init(objattr,RTOABORDER,true,BUBBLE_OBJATTR_BORDER));
								new(pb,Init(objattr,RTOAHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(objattr,RTOACANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(PButton,Init(objattr,RTOASET,id_No,true,BUBBLE_GENERAL_OBJSET));
								new(PButton,Init(objattr,RTOAOK,id_OK,true,BUBBLE_GENERAL_OBJSETOK));
								objattr^.TransferBuffer:=@oabuf
							end;
						TexelApp.DeactivateExtResource
					end;
				if objattr<>nil then objattr^.MakeWindow
			end;
		11:
			begin
				if IsEmbedded then ClearEmbedFlag
				else
					SetEmbedFlag
			end;
		12:
			begin
				if CanPrint then ClearPrintFlag
				else
					SetPrintFlag
			end
		end
	end;


procedure TEmbedded.Edit;

	begin
		DblClick(0,0,K_NORMAL)
	end;


function TEmbedded.IsEmbedded: boolean;

	begin
		IsEmbedded:=embedflag
	end;


procedure TEmbedded.SetEmbedFlag;

	begin
		if IsEmbedded then exit;
		embedflag:=true;
		Parent^.SetDirty
	end;


procedure TEmbedded.ClearEmbedFlag;

	begin
		if not(IsEmbedded) then exit;
		embedflag:=false;
		Parent^.SetDirty
	end;


procedure TEmbedded.Select;
	var pe: PEmbedded;
	    p : PCalcWindow;
	    q : integer;

	begin
		if IsSelected then exit;
		if Next<>nil then
			begin
				if Prev=nil then Parent^.Embedded:=Next
					else Prev^.Next:=Next;
				Next^.Prev:=Prev;
				pe:=Parent^.Embedded;
				while pe^.Next<>nil do pe:=pe^.Next;
				pe^.Next:=@self;
				Prev:=pe;
				Next:=nil;
				pe:=Parent^.Embedded;
				while pe<>nil do
					begin
						pe^.Deselect;
						pe:=pe^.Next
					end
			end;
		selected:=true;
		Redraw;
		p:=PCalcWindow(Parent);
		if p^.links<>nil then
			if p^.links^.linklist<>nil then
				if p^.links^.linklist^.Count>0 then
					for q:=0 to p^.links^.linklist^.Count-1 do
						if PLinkData(p^.links^.linklist^.At(q))^.ObjRef=@self then
							begin
								p^.links^.plb^.SetSelection(q);
								p^.links^.plb^.ScrollBar^.SetPosition(q);
								break
							end
	end;


procedure TEmbedded.Deselect;

	begin
		if not(IsSelected) then exit;
		IEDeactivate;
		selected:=false;
		Redraw
	end;


procedure TEmbedded.Toggle;

	begin
		if IsSelected then Deselect
		else
			Select
	end;


function TEmbedded.IsSelected: boolean;

	begin
		IsSelected:=selected
	end;


procedure TEmbedded.Destroy;

	begin
		Parent^.SetDirty;
		if objsize<>nil then objsize^.Free;
		if objattr<>nil then objattr^.Free;
		Unlink;
		Redraw;
		Free
	end;


procedure TEmbedded.Cut;

	begin
		Copy;
		Destroy
	end;


procedure TEmbedded.Copy;
	var res: longint;
	    hdl: integer;
	    msk: word;
	    tci: TCookieID;
	    scs: boolean;
	    ext: string;

	begin
		if Parent^.Clipboard=nil then exit;
		with Parent^.Clipboard^ do
			begin
				if not(OpenClipboard(true)) then exit;
				scs:=false;
				msk:=SCF_INDEF;
				if (Data<>nil) and (DataLen>0) then
					begin
						ext:=StrPLower(GetExtension(GetFile));
						if length(ext)>0 then
							begin
								res:=fcreate(GetClipboardFilename+CutLeftF(ext,1),0);
								if res>=0 then
									begin
										hdl:=integer(res);
										if fwrite(hdl,DataLen,Data)=DataLen then
											begin
												scs:=true;
												if (ext='.txt') or (ext='.asc') then msk:=SCF_TEXT
												else if ext='.img' then msk:=SCF_RASTER
												else if (ext='.cwg') or (ext='.cvg') or (ext='.gem') or (ext='.ai') then msk:=SCF_VECTOR
											end;
										fclose(hdl)
									end
							end
					end;
				res:=fcreate(GetClipboardFilename+'tob',0);
				if res>=0 then
					begin
						hdl:=integer(res);
						tci:='TXLO';
						fwrite(hdl,sizeof(TCookieID),@tci);
						Save(hdl,false);
						fclose(hdl);
						scs:=true;
						ext:='.tob'
					end;
				if scs then SetClipboardFormat(msk,ext);
				CloseClipboard
			end
	end;


procedure TEmbedded.Paste;

	begin
		Parent^.PasteObject
	end;


procedure TEmbedded.SetDirty;

	begin
		embfiledirty:=true
	end;


procedure TEmbedded.ClearDirtyFlag;

	begin
		embfiledirty:=false
	end;


function TEmbedded.IsDirty: boolean;

	begin
		IsDirty:=embfiledirty
	end;


procedure TEmbedded.SetPropFlag;

	begin
		if IsProportional then exit;
		osbuf.prop:=bf_Checked;
		if objsize<>nil then
			if PObjSizeDialog(objsize)^.cb1<>nil then PObjSizeDialog(objsize)^.cb1^.Check;
		Parent^.SetDirty
	end;


procedure TEmbedded.ClearPropFlag;

	begin
		if not(IsProportional) then exit;
		osbuf.prop:=bf_Unchecked;
		if objsize<>nil then
			if PObjSizeDialog(objsize)^.cb1<>nil then PObjSizeDialog(objsize)^.cb1^.Uncheck;
		Parent^.SetDirty
	end;


function TEmbedded.IsProportional: boolean;

	begin
		IsProportional:=(osbuf.prop=bf_Checked)
	end;


procedure TEmbedded.Lock;

	begin
		if IsLocked then exit;
		osbuf.sperr:=bf_Checked;
		if objsize<>nil then
			if PObjSizeDialog(objsize)^.cb2<>nil then PObjSizeDialog(objsize)^.cb2^.Check;
		Parent^.SetDirty
	end;


procedure TEmbedded.Unlock;

	begin
		if not(IsLocked) then exit;
		osbuf.sperr:=bf_Unchecked;
		if objsize<>nil then
			if PObjSizeDialog(objsize)^.cb2<>nil then PObjSizeDialog(objsize)^.cb2^.Uncheck;
		Parent^.SetDirty
	end;


function TEmbedded.IsLocked: boolean;

	begin
		IsLocked:=(osbuf.sperr=bf_Checked)
	end;


procedure TEmbedded.SetPrintFlag;

	begin
		if CanPrint then exit;
		printflag:=true;
		Parent^.SetDirty
	end;


procedure TEmbedded.ClearPrintFlag;

	begin
		if not(CanPrint) then exit;
		printflag:=false;
		Parent^.SetDirty
	end;


function TEmbedded.CanPrint: boolean;

	begin
		CanPrint:=printflag
	end;


procedure TEmbedded.IEActivate;

	begin
		if IsIEActive then exit;
		if not(CanUseIE) then exit;
		objectinfo^.CBIEActivate(nil,nil,0,0,0,objectinfo);
		ieactivated:=true;
		if IsSelected then Redraw
		else
			Select
	end;


procedure TEmbedded.IEDeactivate;

	begin
		if not(IsIEActive) then exit;
		if assigned(objectinfo^.CBIEDeactivate) then objectinfo^.CBIEDeactivate(nil,nil,0,0,0,objectinfo);
		ieactivated:=false
	end;


procedure TEmbedded.IESendButton(X,Y,Clicks,Button,KStat: integer);
	var pipe: Pipearray;
	    pie : POLGAIEInfo;
	    psi : PGRECT;

	begin
		if not(IsIEActive) then exit;
		if objectinfo^.cbServerID<0 then
			begin
				Application^.Bing;
				exit
			end;
		PaintX:=GetPixXPos(true);
		PaintY:=GetPixYPos(true);
		PaintW:=GetPixWidth(true);
		PaintH:=GetPixHeight(true);
		psi:=@PTexelObjectInfo(objectinfo)^.r1;
		psi^.X:=PaintX+1;
		psi^.Y:=PaintY+1;
		psi^.W:=PaintW-2;
		psi^.H:=PaintH-2;
		if (X<psi^.X) or (Y<psi^.Y) then exit;
		pie:=@PTexelObjectInfo(objectinfo)^.ie;
		pie^.len:=sizeof(TOLGAIEInfo);
		pie^.wHandle:=Parent^.Attr.gemHandle;
		pie^.kShift:=KStat;
		pie^.Size:=psi;
		pie^.objectinfo:=objectinfo;
		pipe[0]:=OLGA_IE_BUTTON;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(pie));
		pipe[4]:=integer(LoWord(pie));
		pipe[5]:=X-psi^.X;
		pipe[6]:=Y-psi^.Y;
		pipe[7]:=(Clicks shl 8) or Button;
		appl_write(objectinfo^.cbServerID,16,@pipe)
	end;


function TEmbedded.IsIEActive: boolean;

	begin
		IsIEActive:=ieactivated
	end;


function TEmbedded.CanUseIE: boolean;

	begin
		if objectinfo=nil then CanUseIE:=false
		else
			CanUseIE:=assigned(objectinfo^.CBIEActivate)
	end;


procedure TEmbedded.SetFile(s: string);
	var p   : PCalcWindow;
	    q   : longint;
	    pld : PLinkData;
	    ext,
	    edsc: string;

	begin
		if not(HasFile) then exit;
		DisposeStr(FileName);
		FileName:=NewStr(s);
		p:=PCalcWindow(Parent);
		if p^.links<>nil then
			if p^.links^.linklist<>nil then
				begin
					pld:=nil;
					if p^.links^.linklist^.Count>0 then
						for q:=0 to p^.links^.linklist^.Count-1 do
							if PLinkData(p^.links^.linklist^.At(q))^.ObjRef=@self then
								begin
									pld:=PLinkData(p^.links^.linklist^.At(q));
									break
								end;
					if pld<>nil then
						begin
							DisposeStr(pld^.Descr);
							ext:=StrPUpper(GetExtension(s));
							edsc:='';
							if TexelApp.OLETypes<>nil then
								if TexelApp.OLETypes^.Count>0 then
									for q:=0 to TexelApp.OLETypes^.Count-1 do
										if StrPUpper(POLEType(TexelApp.OLETypes^.At(q))^.Ext)=ext then
											begin
												edsc:=StrPTrimF(POLEType(TexelApp.OLETypes^.At(q))^.Descr^);
												break
											end;
							if length(edsc)=0 then
								begin
									if ext='.IMG' then edsc:=STRING_IMG
									else
										if (ext='.TXT') or (ext='.ASC') then edsc:=STRING_TXT
										else
											edsc:=ext
								end;
							if length(edsc)>25 then edsc:=StrPLeft(edsc,22)+'...';
							pld^.Descr:=NewStr('  '+edsc+StrPSpace(27-length(edsc))+CompressPath(s,40)+#0);
							p^.links^.UpdateList(nil)
						end
				end
	end;


function TEmbedded.GetFile: string;

	begin
		if FileName<>nil then GetFile:=FileName^
		else
			GetFile:=''
	end;


function TEmbedded.bwrite(hdl: integer; count: longint; var buffer): boolean;

	begin
		bwrite:=(fwrite(hdl,count,@buffer)<>count)
	end;


function TEmbeddedStatic.IsExternal: boolean;

	begin
		IsExternal:=false
	end;


function TEmbeddedStatic.GetExt(embed,default: boolean): string;

	begin
		if embed then GetExt:=''
		else
			GetExt:=inherited GetExt(false,default)
	end;


constructor TEmbeddedElement.Init(AParent: PCalcWindow; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,prntflg,lckflg: boolean; poa: PEmbedBuf);
	var p: PEmbeddedElement;

	begin
		if not(inherited Init(AParent,nil,'',id_No,pixx,pixy,pixw,pixh,w100,h100,x100,y100,dlen,dat,xyvalid,draw,prop,true,prntflg,lckflg,poa)) then fail;
		elPrev:=nil;
		elNext:=nil;
		if Parent^.Elements=nil then Parent^.Elements:=@self
		else
			begin
				p:=Parent^.Elements;
				while p^.elNext<>nil do p:=p^.elNext;
				p^.elNext:=@self;
				elPrev:=p
			end
	end;


destructor TEmbeddedElement.Done;

	begin
		if (elPrev=nil) and (elNext=nil) then Parent^.Elements:=nil
		else
			begin
				if elPrev=nil then Parent^.Elements:=elNext
				else
					elPrev^.elNext:=elNext;
				if elNext<>nil then elNext^.elPrev:=elPrev
			end;
		inherited Done
	end;


function TEmbeddedElement.HasFile: boolean;

	begin
		HasFile:=false
	end;


function TEmbeddedElement.GetExt(embed,default: boolean): string;

	begin
		GetExt:=''
	end;


procedure TEmbeddedElement.Link;

	begin
	end;


procedure TEmbeddedElement.Unlink;

	begin
	end;


procedure TEmbeddedElement.BreakLink;

	begin
	end;


procedure TEmbeddedElement.CheckLink;

	begin
	end;


procedure TEmbeddedElement.ClearEmbedFlag;

	begin
	end;


procedure TEmbeddedElement.DblClick(mX,mY,KStat: integer);

	begin
		Toggle
	end;


procedure TEmbeddedElement.CheckRef;

	begin
	end;


procedure TEmbeddedElement.SetRef;

	begin
	end;


procedure TEmbeddedElement.UpdateRefPointer(warn: boolean);

	begin
	end;


function TLink.ExitDlg(AnIndx: integer): boolean;
	var r,c,
	    sel  : integer;
	    x,y  : longint;
	    pld  : PLinkData;
	    p    : PCalcWindow;
	    fp,fn: string;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		sel:=plb^.GetSelection;
		pld:=PLinkData(linklist^.At(sel));
		case AnIndx of
		RTLICHANGE:
			if not(pld^.ObjRef^.HasFile) then Application^.Bing
			else
				begin
					fp:=GetPath(pld^.ObjRef^.GetFile);
					fn:=GetFilename(pld^.ObjRef^.GetFile,true);
					if FileSelect(@self,FSELTITLE_CHANGELINK,'*.*',fp,fn,true) then
						begin
							pld^.ObjRef^.Unlink;
							pld^.ObjRef^.SetFile(fp+fn);
							pld^.ObjRef^.Link;
							p^.SetDirty;
							pld^.ObjRef^.Update
						end
				end;
		RTLIACTIVATE:
			begin
				ExitDlg:=true;
				r:=0;
				c:=0;
				x:=pld^.ObjRef^.XPos_mm100;
				y:=pld^.ObjRef^.YPos_mm100;
				while ((y-p^.PRow^[r])>0) and (r<p^.Parms.Rows) do
					begin
						dec(y,p^.PRow^[r]);
						inc(r)
					end;
				while ((x-p^.PCol^[c])>0) and (c<p^.Parms.Columns) do
					begin
						dec(x,p^.PCol^[c]);
						inc(c)
					end;
				p^.SetCursorPos(r,c,true);
				pld^.ObjRef^.Select
			end;
		RTLIEDIT:
			begin
				ExitDlg:=true;
				pld^.ObjRef^.Edit
			end
		end
	end;


procedure TLink.EndDlg(Indx: integer; DblClick: boolean);

	begin
		inherited EndDlg(Indx,DblClick);
		if DblClick then
			if plb<>nil then
				if plb^.TestIndex(Indx) then
					begin
						ExitDlg(RTLIACTIVATE);
						Cont:=false;
						Result:=RTLIOK;
						Destroy
					end
	end;


procedure TLink.AddObject(pe: PEmbedded);
	var pld : PLinkData;
	    edsc,
	    ext : string;
	    q   : longint;

	begin
		if linklist=nil then exit;
		new(pld);
		if pld=nil then exit;
		ext:=StrPUpper(GetExtension(pe^.GetFile));
		edsc:='';
		if not(pe^.HasFile) then
			begin
				case pe^.GetType of
				EMB_TYPE_CHECKBOX:
					edsc:=STRING_ELM_CHECKBOX;
				end
			end;
		if length(edsc)=0 then
			if TexelApp.OLETypes<>nil then
				if TexelApp.OLETypes^.Count>0 then
					for q:=0 to TexelApp.OLETypes^.Count-1 do
						if StrPUpper(POLEType(TexelApp.OLETypes^.At(q))^.Ext)=ext then
							begin
								edsc:=StrPTrimF(POLEType(TexelApp.OLETypes^.At(q))^.Descr^);
								break
							end;
		if length(edsc)=0 then
			begin
				if ext='.IMG' then edsc:=STRING_IMG
				else
					if (ext='.TXT') or (ext='.ASC') then edsc:=STRING_TXT
					else
						edsc:=ext
			end;
		if length(edsc)>25 then edsc:=StrPLeft(edsc,22)+'...';
		pld^.ObjRef:=pe;
		pld^.Descr:=NewStr('  '+edsc+StrPSpace(27-length(edsc))+CompressPath(pe^.GetFile,40)+#0);
		if pld^.Descr=nil then
			begin
				dispose(pld);
				pld:=nil
			end
		else
			linklist^.Insert(pld);
		UpdateList(pld^.ObjRef)
	end;


procedure TLink.RemoveObject(pe: PEmbedded);
	var q: longint;

	begin
		if linklist=nil then exit;
		if linklist^.Count>0 then
			for q:=0 to linklist^.Count-1 do
				if PLinkData(linklist^.At(q))^.ObjRef=pe then
					begin
						linklist^.AtFree(q);
						break
					end;
		UpdateList(nil);
		if linklist^.Count=0 then
			begin
				PCalcWindow(Parent)^.links:=nil;
				Free
			end
	end;


procedure TLink.UpdateList(pe: PEmbedded);
	var sel,q: integer;

	begin
		if linklist<>nil then
			begin
				sel:=plb^.GetSelection;
				plb^.SetCollection(linklist);
				if pe<>nil then
					if linklist^.Count>0 then
						for q:=0 to linklist^.Count-1 do
							if PLinkData(linklist^.At(q))^.ObjRef=pe then
								begin
									sel:=q;
									break
								end;
				plb^.SetSelection(sel);
				plb^.ScrollBar^.SetPosition(sel)
			end;
		plb^.Work
	end;


{$IFNDEF WDIALOG}

function TPrintDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then
			if Parent^.GetClassName=TEXELWINDCLASS then
				with PCalcWindow(Parent)^ do
					if preview<>nil then PPreview(preview)^.Update(true);
		OK:=valid
	end;


function TPrintDialog.ExitDlg(AnIndx: integer): boolean;
	var num: integer;

	begin
		ExitDlg:=false;
		if not(OK) then exit;
		case AnIndx of
		RTPPRINT:
			begin
				if drvbox=nil then Application^.Alert(@self,1,NOTE,MESSAGE_PRINT_PRINTER,BUTTON_OK)
				else
					begin
						num:=drvbox^.drivers[drvbox^.GetSelection];
						if num<11 then Application^.Alert(@self,1,NOTE,MESSAGE_PRINT_DRIVER,BUTTON_OK)
						else
							if PPrint(PCalcWindow(Parent)^.prnt)^.PrintSheet(num) then
								begin
									with PCalcWindow(Parent)^ do
										if preview<>nil then PPreview(preview)^.Update(true);
									ExitDlg:=true
								end
					end
			end;
		RTPPREVIEW:
			begin
				with PCalcWindow(Parent)^ do
					if preview<>nil then preview^.Work;
			end;
		RTPPAGESETUP:
			begin
				if Parent^.GetClassName=TEXELWINDCLASS then
					begin
						with PCalcWindow(Parent)^ do
							if pagesetup<>nil then pagesetup^.Work
					end
				else
					if TexelApp.options<>nil then POptions(TexelApp.options)^.PageSetup;
			end;
		RTPINFO:
			ShowInfo;
		end
	end;


procedure TPrintDialog.ShowInfo;
	var dummy,txt,
	    colr,fonts,
	    res,psize,
	    rsize,bez,
	    defcol,ea : string;
	    dpix,dpiy,
	    num,q,hndl: integer;
	    ewrkout,
	    wrkout    : workout_ARRAY;
	    pw,ph,
	    rw,rh,
	    xfak,yfak : real;
	    pb        : PButton;

	begin
		if drvinfo=nil then
			begin
				new(drvinfo,Init(@self,TEXELNAME,STG_PRINTERINFO,ICNTITLE_PRINTERINFO,RTPRINTINFO));
				if drvinfo<>nil then
					begin
						new(st1,Init(drvinfo,RTPITITLE,33,true,BUBBLE_PRNINFO_DEVICE));
						new(st2,Init(drvinfo,RTPINAME,27,false,BUBBLE_PRNINFO_FILE));
						new(st3,Init(drvinfo,RTPIGDOS,17,false,BUBBLE_PRNINFO_NUMBER));
						new(st4,Init(drvinfo,RTPIINFO,43,false,BUBBLE_PRNINFO_DESCR));
						new(st5,Init(drvinfo,RTPIIOTYPE,36,false,BUBBLE_PRNINFO_IO));
						new(st6,Init(drvinfo,RTPICOLORS,41,false,BUBBLE_PRNINFO_COLORS));
						new(st7,Init(drvinfo,RTPIDEFCOLORS,20,false,BUBBLE_PRNINFO_MAXCOLOR));
						new(st8,Init(drvinfo,RTPIFONTS,20,false,BUBBLE_PRNINFO_FONTS));
						new(st9,Init(drvinfo,RTPIDPI,33,false,BUBBLE_PRNINFO_DPI));
						new(st10,Init(drvinfo,RTPISIZE,42,false,BUBBLE_PRNINFO_PAPRSIZE));
						new(st11,Init(drvinfo,RTPIPRINTSIZE,42,false,BUBBLE_PRNINFO_PRNTSIZE));
						new(st12,Init(drvinfo,RTPIBEZIER,19,false,BUBBLE_PRNINFO_BEZIER));
						new(pb,Init(drvinfo,RTPIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(drvinfo,RTPIOK,id_OK,true,BUBBLE_GENERAL_CLOSE))
					end
			end;
		if drvinfo<>nil then
			begin
				BusyMouse;
				if devbox<>nil then dummy:=devbox^.GetText
				else
					dummy:='???';
				if st1<>nil then st1^.SetText(STRING_PRNINFO_INFOON+' '+dummy);
				if drvbox<>nil then
					begin
						num:=drvbox^.drivers[drvbox^.GetSelection];
						dummy:=drvbox^.shortnames[drvbox^.GetSelection];
						txt:=drvbox^.longnames[drvbox^.GetSelection]
					end
				else
					begin
						dummy:='???';
						txt:='';
						num:=-1
					end;
				if st2<>nil then st2^.SetText(STRING_PRNINFO_NAME+dummy);
				if st3<>nil then st3^.SetText(STRING_PRNINFO_NUMBER+ltoa(num));
				colr:='';
				ea:='';
				defcol:='';
				fonts:='';
				res:='';
				psize:='';
				rsize:='';
				bez:='';
				if (num>=11) and (num<=99) then
					begin
						vOpnwk(num,hndl,wrkout,paper^.GetSelection,'',PCalcWindow(Parent)^.wnd_prnt_set);
						if hndl<>0 then
							begin
								inc(wrkout[10],vst_load_fonts(hndl,0));
								vq_extnd(hndl,1,ewrkout);
								vst_unload_fonts(hndl,0);
								v_clswk(hndl);
								case wrkout[44] of
								0: ea:=STRING_PRNINFO_OUT;
								1: ea:=STRING_PRNINFO_IN;
								2: ea:=STRING_PRNINFO_IO;
								4: ea:=STRING_PRNINFO_META
								else
									ea:=STRING_PRNINFO_UNKNOWN
								end;
								if wrkout[35]=0 then colr:=STRING_PRNINFO_COLOR1
								else
									if wrkout[39]=0 then colr:=STRING_PRNINFO_COLOR2
									else
										colr:=ltoa(wrkout[39]);
								if (wrkout[13]=0) or (wrkout[35]=0) then defcol:=STRING_NONE
								else
									defcol:=ltoa(wrkout[13]);
								if wrkout[10]=0 then fonts:=STRING_NONE
								else
									fonts:=ltoa(wrkout[10]);
								pw:=longint(wrkout[0])+1.0;
								ph:=longint(wrkout[1])+1.0;
								xfak:=longint(wrkout[3])/longint(10000);
								yfak:=longint(wrkout[4])/longint(10000);
								rw:=pw;
								rh:=ph;
								if ewrkout[20]=0 then
									begin
										dpix:=mm2dpi(wrkout[3]);
										dpiy:=mm2dpi(wrkout[4])
									end
								else
									begin
										dpix:=ewrkout[23];
										dpiy:=ewrkout[24];
										rw:=rw+ewrkout[40]+ewrkout[42];
										rh:=rh+ewrkout[41]+ewrkout[43];
										case ewrkout[20] of
										1:
											begin
												xfak:=longint(ewrkout[21])/100000;
												yfak:=longint(ewrkout[22])/100000
											end;
										2:
											begin
												xfak:=longint(ewrkout[21])/1000000;
												yfak:=longint(ewrkout[22])/1000000
											end;
										3:
											begin
												xfak:=longint(ewrkout[21])/10000000;
												yfak:=longint(ewrkout[22])/10000000
											end
										end
									end;
								pw:=pw*xfak;
								ph:=ph*yfak;
								rw:=rw*xfak;
								rh:=rh*yfak;
								res:=ltoa(dpix)+' x '+ltoa(dpiy)+' dpi'#253;
								str(pw:0:2,psize);
								str(ph:0:2,dummy);
								psize:=psize+' x '+dummy+' cm'#253;
								str(rw:0:2,rsize);
								str(rh:0:2,dummy);
								rsize:=rsize+' x '+dummy+' cm'#253;
								if bTst(ewrkout[28],2) then bez:=STRING_YES
								else
									bez:=STRING_NO
							end
					end;
				if st4<>nil then st4^.SetText(txt);
				if st5<>nil then st5^.SetText(STRING_PRNINFO_TXT1+ea);
				if st6<>nil then st6^.SetText(STRING_PRNINFO_TXT2+colr);
				if st7<>nil then st7^.SetText(STRING_PRNINFO_TXT3+defcol);
				if st8<>nil then st8^.SetText(STRING_PRNINFO_TXT4+fonts);
				if st9<>nil then st9^.SetText(STRING_PRNINFO_TXT5+res);
				if st10<>nil then st10^.SetText(STRING_PRNINFO_TXT6+rsize);
				if st11<>nil then st11^.SetText(STRING_PRNINFO_TXT7+psize);
				if st12<>nil then st12^.SetText(STRING_PRNINFO_TXT8+bez);
				drvinfo^.MakeWindow;
				ArrowMouse
			end
	end;

{$ENDIF}


procedure TElementCBDialog.BlockChanged(blk: string);

	begin
		if pos(':',blk)=0 then
			if GetFocus=RTEACELL then ed^.SetText(blk)
	end;


function TElementCBDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTEASET);
		OK:=valid
	end;


function TElementCBDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx<>RTEASET then exit;
		TransferData(tf_GetData);
		elmcb^.UpdateRefPointer(true);
		elmcb^.Redraw;
		elmcb^.SetRef
	end;


constructor TEmbeddedCheckBox.Init(AParent: PCalcWindow; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,prntflg,lckflg: boolean; poa: PEmbedBuf; pcb: PEmbedCheckBuf);

	begin
		if not(inherited Init(AParent,pixx,pixy,pixw,pixh,w100,h100,x100,y100,dlen,dat,xyvalid,draw,prop,prntflg,lckflg,poa)) then fail;
		objelm:=nil;
		refcell:=nil;
		if pcb<>nil then
			begin
				ocbbuf:=pcb^;
				UpdateRefPointer(false)
			end
		else
			with ocbbuf do
				begin
					Title:=STRING_ELM_CHECKBOX;
					Zelle:='';
					Status:=bf_Unchecked;
					Row:=-1;
					Column:=-1;
					Reserved:=0
				end
	end;


function TEmbeddedCheckBox.GetType: integer;

	begin
		GetType:=EMB_TYPE_CHECKBOX
	end;


function TEmbeddedCheckBox.SaveData(hdl: integer; emb: boolean): boolean;

	begin
		SaveData:=true;
		if inherited SaveData(hdl,emb) then exit;
		if bwrite(hdl,sizeof(ocbbuf),ocbbuf) then exit;
		SaveData:=false
	end;


procedure TEmbeddedCheckBox.UserPaint(handle: integer; clip: GRECT; screen: boolean);
	var rpt,dummy,
	    pxoff,lwd,
	    wchar,hchar,
	    wcell,hcell: integer;
	    extent     : ARRAY_8;
	    pxy,pxy2   : ARRAY_4;
	    r          : GRECT;

	begin
		r.X:=PaintX;
		r.Y:=PaintY;
		r.W:=PaintW;
		r.H:=PaintH;
		if not(rc_intersect(clip,r)) then exit;
		vs_clip(handle,CLIP_ON,r.A2);
		vswr_mode(handle,MD_REPLACE);
		vst_font(handle,Parent^.GetStdFontIndex);
		if screen then
			begin
				rpt:=round(Parent^.GetStdFontSize*Parent^.PercentSize);
				pxoff:=round(2.0*Parent^.PercentSize);
				lwd:=Max(1,round(1.0*Parent^.PercentSize))
			end
		else
			begin
				rpt:=round(Parent^.GetStdFontSize*fontfak*percent);
				pxoff:=round(2.0*fontfak*percent);
				lwd:=Max(1,round(1.0*fontfak*percent))
			end;
		{$IFDEF NVDI5}
		vst_arbpt(handle,rpt,wchar,hchar,wcell,hcell);
		{$ELSE}
		if Parent^.Speedo then vst_arbpt(handle,rpt,wchar,hchar,wcell,hcell)
		else
			vst_point(handle,rpt,wchar,hchar,wcell,hcell);
		{$ENDIF}
		vst_rotation(handle,0);
		vst_effects(handle,TF_NORMAL);
		vst_alignment(handle,TA_LEFT,TA_TOP,dummy,dummy);
		vst_color(handle,Black);
		{$IFDEF NVDI5}
		vqt_f_extent(handle,ocbbuf.Title,extent);
		{$ELSE}
		if Parent^.Speedo then vqt_f_extent(handle,ocbbuf.Title,extent)
		else
			vqt_extent(handle,ocbbuf.Title,extent);
		{$ENDIF}
		pxy[0]:=PaintX+(hchar shr 1);
		pxy[1]:=PaintY+((PaintH-hchar) shr 1);
		pxy[2]:=pxy[0]+hchar;
		pxy[3]:=pxy[1]+hchar;
		vsf_interior(handle,FIS_HOLLOW);
		vsf_perimeter(handle,PER_ON);
		vsf_color(handle,Black);
		v_bar(handle,pxy);
		if ocbbuf.Status=bf_Checked then
			begin
				vsl_width(handle,lwd);
				pxy2[0]:=pxy[0]+pxoff;
				pxy2[1]:=pxy[1]+pxoff;
				pxy2[2]:=pxy[2]-pxoff;
				pxy2[3]:=pxy[3]-pxoff;
				v_pline(handle,2,pxy2);
				pxy2[1]:=pxy[3]-pxoff;
				pxy2[3]:=pxy[1]+pxoff;
				v_pline(handle,2,pxy2);
				vsl_width(handle,1)
			end;
		vswr_mode(handle,MD_TRANS);
		v_gtext(handle,PaintX+(hchar shl 1),PaintY+((PaintH-(extent[5]-extent[3])) shr 1),ocbbuf.Title)
	end;


procedure TEmbeddedCheckBox.DoClick(mX,mY,KStat: integer);

	begin
		if IsSelected then Deselect
		else
			if Parent^.inpstat then Application^.Bing
			else
				begin
						if ocbbuf.Status=bf_Checked then ocbbuf.Status:=bf_Unchecked
					else
						ocbbuf.Status:=bf_Checked;
					Redraw;
					SetRef
				end
	end;


procedure TEmbeddedCheckBox.DoMenu(mX,mY: integer);
	var p  : PPopup;
	    ret: integer;

	begin
		TexelApp.ActivateExtResource;
		new(p,Init(Parent,RTPOPUPS2,RTP2CHECKBOX,id_No));
		TexelApp.DeactivateExtResource;
		if p<>nil then
			begin
				Parent^.CheckPasteObject(p);
				if CanPrint then p^.Check(9);
				ret:=Application^.Popup(p,mX,mY,POP_CENTER);
				case ret of
				5:
					HandleMenu(8);
				6:
					HandleMenu(9);
				7:
					Edit;
				9:
					HandleMenu(12);
				else
					HandleMenu(ret)
				end
			end
	end;


procedure TEmbeddedCheckBox.Edit;
	var pb: PButton;

	begin
		if objelm=nil then
			begin
				TexelApp.ActivateExtResource;
				objelm:=new(PElementCBDialog,Init(Parent,TEXELWINDPREFIX+TITLE_ELEMENTCB,STG_ELEMENTCB,ICNTITLE_ELEMENT,RTELEMENTATTR));
				if objelm<>nil then
					begin
						PElementCBDialog(objelm)^.elmcb:=@self;
						new(PGroupBox,Init(objelm,RTEACHECKBOX,GROUP_ELEMENT_CHECKBOX,BUBBLE_ELM_CHECKBOX));
						new(PEdit,Init(objelm,RTEATITLE,46,BUBBLE_ELM_TITLE));
						new(PElementCBDialog(objelm)^.ed,Init(objelm,RTEACELL,8,BUBBLE_ELM_CELL));
						new(pb,Init(objelm,RTEAHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(objelm,RTEACANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(objelm,RTEASET,id_No,true,BUBBLE_GENERAL_OBJSET));
						new(PButton,Init(objelm,RTEAOK,id_OK,true,BUBBLE_GENERAL_OBJSETOK));
						objelm^.TransferBuffer:=@ocbbuf
					end;
				TexelApp.DeactivateExtResource
			end;
		if objelm<>nil then objelm^.MakeWindow
	end;


procedure TEmbeddedCheckBox.CheckRef;
	var value: TNumber;
	    nstat: integer;

	begin
		if refcell=nil then exit;
		value:=Parent^.GetCellValue(refcell,false);
		if value=0.0 then nstat:=bf_Unchecked
		else
			nstat:=bf_Checked;
		if nstat<>ocbbuf.Status then
			begin
				ocbbuf.Status:=nstat;
				Redraw
			end
	end;


procedure TEmbeddedCheckBox.SetRef;
	var opc: integer;

	begin
		if refcell=nil then
			begin
				Parent^.SetDirty;
				exit
			end;
		if ocbbuf.Status=bf_Checked then opc:=NT_TRUE
		else
			opc:=NT_FALSE;
		refcell^.Format:=74;
		Parent^.ChangeCell(refcell,TexelApp.EscText2Formula('='#27+ltoa(opc)+#27),ocbbuf.Row,ocbbuf.Column,true);
		if not(Parent^.Parms.Cursor.Block) then
			if (ocbbuf.Row=Parent^.Parms.Cursor.Row) then
				if (ocbbuf.Column=Parent^.Parms.Cursor.Col) then
					begin
						Parent^.CheckToolbarTextFX(refcell);
						Parent^.SetInpline(refcell)
					end
	end;


procedure TEmbeddedCheckBox.UpdateRefPointer(warn: boolean);
	var c,q: integer;
	    r  : longint;

	begin
		ocbbuf.Row:=-1;
		ocbbuf.Column:=-1;
		refcell:=nil;
		if length(ocbbuf.Zelle)=0 then exit;
		ocbbuf.Zelle:=StrPUpper(ocbbuf.Zelle);
		c:=Parent^.ColIndex2Nr(ocbbuf.Zelle,false);
		if (c<0) or (c>Parent^.Parms.Columns) then
			begin
				if warn then Application^.Bing;
				exit
			end;
		q:=1;
		while (ocbbuf.Zelle[q] in ['A'..'Z']) and (q<=length(ocbbuf.Zelle)) do inc(q);
		if q>length(ocbbuf.Zelle) then r:=-1
		else
			r:=atol(StrPRight(ocbbuf.Zelle,length(ocbbuf.Zelle)+1-q))-1;
		if (r>=0) and (r<=Parent^.Parms.Rows) then
			begin
				ocbbuf.Row:=r;
				ocbbuf.Column:=c;
				refcell:=Parent^.GetCell(ocbbuf.Row,ocbbuf.Column)
			end
		else
			if warn then Application^.Bing;
	end;


constructor TEmbeddedTAD.Init(AParent: PCalcWindow; poi: POLGAObjectInfo; fName: string; srvid,pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer;
                              xyvalid,draw,prop,embd,prntflg,lckflg: boolean; poa: PEmbedBuf; pdb: PDiagrammBuf);

	begin
		fname:=GetPath(fname)+GetFilename(fname,false)+'.cwg';
		StrPCopy(poi^.Filename,fname);
		if not(inherited Init(AParent,poi,fname,srvid,pixx,pixy,pixw,pixh,w100,h100,x100,y100,dlen,dat,xyvalid,draw,prop,embd,prntflg,lckflg,poa)) then fail;
		if poa=nil then embedflag:=true;
		if pdb<>nil then
			begin
				diabuf:=pdb^;
				dbvalid:=(diabuf.rb1<>0)
			end
		else
			dbvalid:=false
	end;


function TEmbeddedTAD.GetType: integer;

	begin
		GetType:=EMB_TYPE_TAD
	end;


function TEmbeddedTAD.SaveData(hdl: integer; emb: boolean): boolean;

	begin
		SaveData:=true;
		if inherited SaveData(hdl,emb) then exit;
		if bwrite(hdl,sizeof(boolean),dbvalid) then exit;
		if dbvalid then
			if bwrite(hdl,sizeof(TDiagrammBuf),diabuf) then exit;
		SaveData:=false
	end;


procedure TEmbeddedTAD.DoMenu(mX,mY: integer);
	var p  : PPopup;
	    ret: integer;

	begin
		TexelApp.ActivateExtResource;
		new(p,Init(Parent,RTPOPUPS2,RTP2TAD,id_No));
		TexelApp.DeactivateExtResource;
		if p<>nil then
			begin
				BusyMouse;
				Parent^.CheckPasteObject(p);
				if (Data=nil) or (DataLen<=0) then p^.Disable(5);
				if (Application^.OLGAManager<0) or (not(Exist(GetFile)) and ((DataLen<=0) or (Data=nil))) then p^.Disable(6);
				ArrowMouse;
				if not(dbvalid) or (Parent^.diagramm=nil) then p^.Disable(7);
				if IsEmbedded then p^.Check(12);
				if CanPrint then p^.Check(13);
				ret:=Application^.Popup(p,mX,mY,POP_CENTER);
				if ret=7 then
					begin
						Parent^.diagramm^.Work;
						if Parent^.diagramm^.ADialog<>nil then
							begin
								Parent^.diagrammbuf:=diabuf;
								Parent^.diagramm^.ADialog^.TransferData(tf_SetData)
							end
					end
				else
					if ret<7 then HandleMenu(ret)
					else
						HandleMenu(ret-1)
			end
	end;


constructor TEmbeddedIMG.Init(AParent: PCalcWindow; fName: string; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,embd,skal,prntflg,lckflg: boolean; poa: PEmbedBuf);

	begin
		fillchar(srcMFDB,sizeof(srcMFDB),0);
		fd_dlen:=0;
		if not(inherited Init(AParent,nil,fName,id_No,pixx,pixy,pixw,pixh,w100,h100,x100,y100,dlen,dat,xyvalid,draw,prop,embd,prntflg,lckflg,poa)) then fail;
		if (dat<>nil) and (dlen>0) then Decode;
		if poa=nil then
			begin
				oabuf.fcolor:=Black;
				ClearPropFlag;
				skalieren:=true;
			end
		else
			skalieren:=skal
	end;


destructor TEmbeddedIMG.Done;

	begin
		if srcMFDB.fd_addr<>nil then freemem(srcMFDB.fd_addr,fd_dlen);
		inherited Done
	end;


function TEmbeddedIMG.GetDefaultExt: string;

	begin
		GetDefaultExt:='.img'
	end;


function TEmbeddedIMG.GetType: integer;

	begin
		GetType:=EMB_TYPE_IMG
	end;


function TEmbeddedIMG.SaveData(hdl: integer; emb: boolean): boolean;

	begin
		SaveData:=true;
		if inherited SaveData(hdl,emb) then exit;
		if bwrite(hdl,sizeof(boolean),skalieren) then exit;
		SaveData:=false
	end;


procedure TEmbeddedIMG.CheckLink;
	label _error;

	var res: longint;
	    hdl: integer;

	begin
		if Data<>nil then freemem(Data,DataLen);
		Data:=nil;
		DataLen:=0;
		fillchar(srcMFDB,sizeof(srcMFDB),0);
		fd_dlen:=0;
		if length(GetFile)=0 then exit;
		res:=fopen(GetFile,FO_READ);
		if res<0 then exit;
		hdl:=integer(res);
		DataLen:=fseek(0,hdl,2);
		if DataLen<0 then goto _error;
		if fseek(0,hdl,0)<0 then goto _error;
		getmem(Data,DataLen);
		if Data<>nil then
			if fread(hdl,DataLen,Data)<>DataLen then
				begin
					freemem(Data,DataLen);
					Data:=nil;
					DataLen:=0
				end;
		_error:
		fclose(hdl);
		if not(Decode) then
			begin
				if Data<>nil then freemem(Data,DataLen);
				if srcMFDB.fd_addr<>nil then freemem(srcMFDB.fd_addr,fd_dlen);
				Data:=nil;
				DataLen:=0;
				srcMFDB.fd_addr:=nil;
				fd_dlen:=0
			end
	end;


function TEmbeddedIMG.Decode: boolean;
	const MAX_PATTERNS = 8;

	var imgheader: PIMGHeader;
	    line_ptr,
	    rast_ptr,
	    src,dst  : PByte;
	    i,cnt,len,
	    max_pat,
	    l_buflen,
	    bytecols,
	    zeile,vrc: integer;
	    boffs    : longint;
	    wert     : byte;
	    pattern  : array [0..MAX_PATTERNS-1] of byte;

	begin
		Decode:=false;
		if (DataLen<16) or (Data=nil) then exit;
		imgheader:=Data;
		if imgheader^.version<>1 then exit;
		if imgheader^.headlen<8 then exit;
		{ Farbbilder !!! }
		if imgheader^.planes<>1 then exit;
		srcMFDB.fd_w:=imgheader^.sl_width;
		srcMFDB.fd_h:=imgheader^.sl_height;
		srcMFDB.fd_wdwidth:=(imgheader^.sl_width+15) shr 4;
		srcMFDB.fd_stand:=1;
		srcMFDB.fd_nplanes:=1;
		boffs:=srcMFDB.fd_wdwidth shl 1;
		fd_dlen:=longint(srcMFDB.fd_h)*boffs;
		getmem(srcMFDB.fd_addr,fd_dlen);
		if srcMFDB.fd_addr=nil then
			begin
				Decode:=true;
				exit
			end;
		src:=PByte(longint(Data)+(imgheader^.headlen shl 1));
		l_buflen:=(imgheader^.sl_width+7) shr 3;
		max_pat:=min(imgheader^.pat_run,MAX_PATTERNS);
		dst:=srcMFDB.fd_addr;
		zeile:=0;
		while zeile<imgheader^.sl_height do
			begin
				vrc:=1;
				bytecols:=l_buflen;
				line_ptr:=dst;
				while bytecols>0 do
					begin
						wert:=src^;
						inc(longint(src));
						case wert of
						0:
							begin
								wert:=src^;
								inc(longint(src));
								if wert=0 then
									begin
										wert:=src^;
										inc(longint(src));
										if wert=$ff then
											begin
												vrc:=src^;
												inc(longint(src))
											end
									end
								else
									begin
										dec(bytecols,wert*imgheader^.pat_run);
										for i:=0 to max_pat-1 do pattern[i]:=PByte(longint(src)+i)^;
										inc(longint(src),imgheader^.pat_run);
										while wert>0 do
											begin
												for i:=0 to max_pat-1 do
													begin
														line_ptr^:=pattern[i];
														inc(longint(line_ptr))
													end;
												dec(wert)
											end
									end
							end;
						$80:
							begin
								wert:=src^;
								inc(longint(src));
								dec(bytecols,wert);
								while wert>0 do
									begin
										line_ptr^:=src^;
										inc(longint(line_ptr));
										inc(longint(src));
										dec(wert)
									end
							end
						else
							begin
								len:=wert and $7f;
								dec(bytecols,len);
								if bTst(wert,$80) then wert:=$ff else wert:=0;
								while len>0 do
									begin
										line_ptr^:=wert;
										inc(longint(line_ptr));
										dec(len)
									end
							end
						end
					end;
				if vrc>1 then
					for cnt:=1 to vrc-1 do
						begin
							line_ptr:=dst;
							rast_ptr:=PByte(longint(dst)+longint(cnt)*boffs);
							for i:=0 to l_buflen-1 do
								begin
									rast_ptr^:=line_ptr^;
									inc(longint(line_ptr));
									inc(longint(rast_ptr))
								end
						end;
				inc(longint(dst),longint(vrc)*boffs);
				inc(zeile,vrc)
			end;
		colidx[1]:=White;
		imgxy[0]:=0;
		imgxy[1]:=0;
		imgxy[2]:=imgheader^.sl_width-1;
		imgxy[3]:=imgheader^.sl_height-1;
		Decode:=true
	end;


procedure TEmbeddedIMG.UserPaint(handle: integer; clip: GRECT; screen: boolean);
	var r : GRECT;
	    si: boolean;

	begin
		if srcMFDB.fd_addr<>nil then
			begin
				if not(screen) and (oabuf.fcolor>=colors) then colidx[0]:=Black
				else
					colidx[0]:=oabuf.fcolor;
				desMFDB.fd_addr:=nil;
				imgxy[4]:=PaintX+1;
				imgxy[5]:=PaintY+1;
				imgxy[6]:=PaintX+PaintW-2;
				imgxy[7]:=PaintY+PaintH-2;
				if screen then si:=Application^.CanScaleIMG
				else
					si:=ScaleIMG;
				if si and skalieren then
					vrt_cpyfm(handle,integer(word(MD_TRANS) or word($8000)),imgxy,srcMFDB,desMFDB,colidx)
				else
					begin
						r.X:=imgxy[4];
						r.Y:=imgxy[5];
						r.W:=PaintW-2;
						r.H:=PaintH-2;
						if rc_intersect(clip,r) then
							begin
								vs_clip(handle,CLIP_ON,r.A2);
								vrt_cpyfm(handle,MD_TRANS,imgxy,srcMFDB,desMFDB,colidx)
							end
					end
			end
		else
			begin
				vsl_color(handle,Red);
				pxya[0]:=PaintX+1;
				pxya[1]:=PaintY+1;
				pxya[2]:=PaintX+PaintW-2;
				pxya[3]:=PaintY+PaintH-2;
				v_pline(handle,2,pxya);
				pxya[1]:=pxya[3];
				pxya[3]:=PaintY+1;
				v_pline(handle,2,pxya)
			end
	end;


procedure TEmbeddedIMG.DoMenu(mX,mY: integer);
	var p  : PPopup;
	    ret: integer;
	    pb : PButton;

	begin
		TexelApp.ActivateExtResource;
		new(p,Init(Parent,RTPOPUPS2,RTP2IMGOBJECT,id_No));
		TexelApp.DeactivateExtResource;
		if p<>nil then
			begin
				BusyMouse;
				Parent^.CheckPasteObject(p);
				if (Data=nil) or (DataLen<=0) then p^.Disable(5);
				if (Application^.OLGAManager<0) or (not(Exist(GetFile)) and ((DataLen<=0) or (Data=nil))) then p^.Disable(6);
				ArrowMouse;
				if IsEmbedded then p^.Check(11);
				if CanPrint then p^.Check(12);
				if Application^.CanScaleIMG then
					begin
						if skalieren then p^.Check(13)
					end
				else
					p^.Disable(13);
				ret:=Application^.Popup(p,mX,mY,POP_CENTER);
				if ret=9 then
					begin
						if objattr=nil then
							begin
								TexelApp.ActivateExtResource;
								objattr:=new(PObjAttrDialog,Init(Parent,@self,TEXELWINDPREFIX+TITLE_IMGOBJ,STG_IMGOBJ,ICNTITLE_IMGOBJ,RTIMGOBJATTR,RTIOASET));
								if objattr<>nil then
									begin
										new(PGroupBox,Init(objattr,RTIOABACKGROUND,GROUP_OBJECT_BACKGR,BUBBLE_IMGOBJ_BACKGR));
										new(PGroupBox,Init(objattr,RTIOAIMG,GROUP_OBJECT_IMAGE,BUBBLE_IMGOBJ_IMAGE));
										PObjAttrDialog(objattr)^.pbg:=new(PColorBox,Init(objattr,RTIOACOLOR,RTIOACOLCYC,RTIOACOLTITLE,RTPOPUPS2,RTP2COLOR,RTP2COLSTART,false,false,BUBBLE_IMGOBJ_BGCOL));
										new(PObjAttrBox,Init(objattr,RTIOATRANS,true,BUBBLE_IMGOBJ_TRANS));
										new(PCheckBox,Init(objattr,RTIOABORDER,true,BUBBLE_IMGOBJ_BORDER));
										new(PColorBox,Init(objattr,RTIOAICOLOR,RTIOAICOLCYC,RTIOAICOLTITLE,RTPOPUPS2,RTP2COLOR,RTP2COLSTART,false,false,BUBBLE_IMGOBJ_IMGCOL));
										new(pb,Init(objattr,RTIOAHELP,id_Help,false,BUBBLE_GENERAL_HELP));
										if pb<>nil then
											if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
										new(PButton,Init(objattr,RTIOACANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
										new(PButton,Init(objattr,RTIOASET,id_No,true,BUBBLE_GENERAL_OBJSET));
										new(PButton,Init(objattr,RTIOAOK,id_OK,true,BUBBLE_GENERAL_OBJSETOK));
										objattr^.TransferBuffer:=@oabuf
									end;
								TexelApp.DeactivateExtResource
							end;
						if objattr<>nil then objattr^.MakeWindow
					end
				else
					if ret=13 then
						begin
							skalieren:=not(skalieren);
							Redraw;
							Parent^.SetDirty
						end
					else
						HandleMenu(ret)
			end
	end;


constructor TEmbeddedText.Init(AParent: PCalcWindow; fName: string; pixx,pixy,pixw,pixh: integer; w100,h100,x100,y100,dlen: longint; dat: pointer; xyvalid,draw,prop,embd,umbr,prntflg,lckflg: boolean; poa: PEmbedBuf);

	begin
		if not(inherited Init(AParent,nil,fName,id_No,pixx,pixy,pixw,pixh,w100,h100,x100,y100,dlen,dat,xyvalid,draw,prop,embd,prntflg,lckflg,poa)) then fail;
		if poa=nil then
			begin
				with oabuf do
					begin
						fsize:=Parent^.FontSize2Index(Parent^.GetFontSize);
						fid:=Parent^.FontID2Index(Parent^.GetFontIndex);
						fcolor:=Black
					end;
				ClearPropFlag;
				umbruch:=true
			end
		else
			umbruch:=umbr;
		txOffs:=2;
		tyOffs:=2
	end;


function TEmbeddedText.GetDefaultExt: string;

	begin
		GetDefaultExt:='.txt'
	end;


function TEmbeddedText.GetType: integer;

	begin
		GetType:=EMB_TYPE_TEXT
	end;


function TEmbeddedText.SaveData(hdl: integer; emb: boolean): boolean;

	begin
		SaveData:=true;
		if inherited SaveData(hdl,emb) then exit;
		if bwrite(hdl,sizeof(boolean),umbruch) then exit;
		if bwrite(hdl,2,txOffs) then exit;
		if bwrite(hdl,2,tyOffs) then exit;
		SaveData:=false
	end;


procedure TEmbeddedText.CheckLink;
	label _error;

	var res: longint;
	    hdl: integer;

	begin
		if Data<>nil then freemem(Data,DataLen);
		Data:=nil;
		DataLen:=0;
		if length(GetFile)=0 then exit;
		res:=fopen(GetFile,FO_READ);
		if res<0 then exit;
		hdl:=integer(res);
		DataLen:=fseek(0,hdl,2);
		if DataLen<0 then goto _error;
		if fseek(0,hdl,0)<0 then goto _error;
		getmem(Data,DataLen);
		if Data<>nil then
			if fread(hdl,DataLen,Data)<>DataLen then
				begin
					freemem(Data,DataLen);
					Data:=nil;
					DataLen:=0
				end;
		_error:
		fclose(hdl)
	end;


procedure TEmbeddedText.UserPaint(handle: integer; clip: GRECT; screen: boolean);
	label _nochmal;

	var s,sout     : string;
	    rpt,breite,
	    dummy,py,px,
	    q,findx,
	    fsize,
	    wchar,hchar,
	    wcell,hcell: integer;
	    pend       : longint;
	    p          : PChar;
	    c          : char;
	    g          : GRECT;
	    ext        : ARRAY_8;
	    pf         : PFont;

	begin
		if (Data=nil) or (DataLen<=0) then exit;
		g.X:=PaintX+txOffs;
		g.Y:=PaintY+tyOffs;
		breite:=PaintW-(txOffs shl 1);
		g.W:=breite;
		g.H:=PaintH-(tyOffs shl 1);
		if not(rc_intersect(clip,g)) then exit;
		vs_clip(handle,CLIP_ON,g.A2);
		if not(screen) and (oabuf.fcolor>=colors) then vst_color(handle,Black)
		else
			vst_color(handle,oabuf.fcolor);
		if Parent^.Fonts=nil then findx:=vqt_name(handle,1,s)
		else
			if (oabuf.fid>=0) and (oabuf.fid<Parent^.Fonts^.Count) then findx:=PFont(Parent^.Fonts^.At(oabuf.fid))^.index
			else
				findx:=vqt_name(handle,1,s);
		if Parent^.Fonts=nil then fsize:=10
		else
			if (oabuf.fid<0) or (oabuf.fid>=Parent^.Fonts^.Count) then fsize:=10
			else
				begin
					pf:=Parent^.Fonts^.At(oabuf.fid);
					if pf^.SizeCount=0 then fsize:=4+oabuf.fsize
					else
						if (oabuf.fsize<0) or (oabuf.fsize>=pf^.SizeCount) then fsize:=10
						else
							fsize:=pf^.Sizes^[pf^.SizeCount-oabuf.fsize-1]
				end;
		vst_font(handle,findx);
		if screen then rpt:=round(fsize*Parent^.PercentSize)
		else
			rpt:=round(fsize*fontfak*percent);
		{$IFDEF NVDI5}
		vst_arbpt(handle,rpt,wchar,hchar,wcell,hcell);
		{$ELSE}
		if Parent^.Speedo then vst_arbpt(handle,rpt,wchar,hchar,wcell,hcell)
		else
			vst_point(handle,rpt,wchar,hchar,wcell,hcell);
		{$ENDIF}
		vst_rotation(handle,0);
		vst_effects(handle,TF_NORMAL);
		vst_alignment(handle,TA_LEFT,TA_TOP,dummy,dummy);
		vswr_mode(handle,MD_TRANS);
		p:=Data;
		pend:=longint(p)+DataLen-1;
		px:=PaintX+txOffs;
		py:=PaintY+tyOffs;
		s:='';
		while (py<g.Y2) and ((longint(p)<=pend) or (length(s)>0)) do
			begin
				while longint(p)<=pend do
					begin
						c:=p^;
						inc(longint(p));
						if ord(c)>=32 then
							begin
								if length(s)<255 then s:=s+c
							end
						else
							if c=#10 then break
					end;
				if umbruch then
					begin
						sout:=s;
						s:='';
						if length(sout)>0 then
							begin
								_nochmal:
								{$IFDEF NVDI5}
								vqt_real_extent(handle,0,0,sout,ext);
								{$ELSE}
								if Parent^.Speedo then vqt_my_extent(handle,sout,ext)
								else
									vqt_extent(handle,sout,ext);
								{$ENDIF}
								if abs(ext[2]-ext[0])>breite then
									if length(sout)>1 then
										begin
											s:=StrPRight(sout,1)+s;
											CutRight(sout,1);
											goto _nochmal
										end;
								StrPTrim(s);
								if length(s)>0 then
									begin
										q:=length(sout);
										while (sout[q]<>' ') and (q>1) do dec(q);
										if q>1 then
											begin
												s:=StrPRight(sout,length(sout)-q)+s;
												sout:=StrPLeft(sout,q);
												StrPTrim(s)
											end
									end;
								if StrPRight(s,1)='-' then
									begin
										if StrPRight(s,2)=' -' then s:=s+' '
										else
											CutRight(s,1)
									end
								else
									if length(s)>0 then s:=s+' '
							end
					end
				else
					begin
						sout:=s;
						s:=''
					end;
				{$IFDEF NVDI5}
				v_ftext(handle,px,py,sout);
				{$ELSE}
				if Parent^.Speedo then v_ftext(handle,px,py,sout)
				else
					v_gtext(handle,px,py,sout);
				{$ENDIF}
				inc(py,hcell)
			end
	end;


procedure TEmbeddedText.DblClick(mX,mY,KStat: integer);
	var ret: longint;

	begin
		if length(GetFile)>0 then
			if not(Exist(GetFile)) then
				if (Data=nil) and (DataLen<=0) then
					begin
						ret:=fcreate(GetFile,0);
						if ret>=0 then fclose(integer(ret))
					end;
		inherited DblClick(mX,mY,KStat)
	end;


procedure TEmbeddedText.DoMenu(mX,mY: integer);
	var p     : PPopup;
	    ret   : integer;
	    pb    : PButton;
	    fsizes: PStringCollection;
	    pfsb  : PFontSizeBox;
	    pfb   : PFontBox;

	begin
		TexelApp.ActivateExtResource;
		new(p,Init(Parent,RTPOPUPS2,RTP2TXTOBJECT,id_No));
		TexelApp.DeactivateExtResource;
		if p<>nil then
			begin
				BusyMouse;
				Parent^.CheckPasteObject(p);
				if (Data=nil) or (DataLen<=0) then p^.Disable(5);
				if (Application^.OLGAManager<0) or ((length(GetFile)=0) and ((Data=nil) or (DataLen<=0))) then p^.Disable(6);
				ArrowMouse;
				if IsEmbedded then p^.Check(11);
				if CanPrint then p^.Check(12);
				if umbruch then p^.Check(13);
				ret:=Application^.Popup(p,mX,mY,POP_CENTER);
				if ret=13 then
					begin
						umbruch:=not(umbruch);
						Redraw;
						Parent^.SetDirty
					end
				else
					if ret=9 then
						begin
							if objattr=nil then
								begin
									TexelApp.ActivateExtResource;
									objattr:=new(PObjAttrDialog,Init(Parent,@self,TEXELWINDPREFIX+TITLE_TXTOBJ,STG_TXTOBJ,ICNTITLE_TXTOBJ,RTTEXTOBJATTR,RTTOASET));
									if objattr<>nil then
										begin
											new(PGroupBox,Init(objattr,RTTOABACKGROUND,GROUP_OBJECT_BACKGR,BUBBLE_TXTOBJ_BACKGR));
											new(PGroupBox,Init(objattr,RTTOATEXT,GROUP_OBJECT_TEXT,BUBBLE_TXTOBJ_TEXT));
											PObjAttrDialog(objattr)^.pbg:=new(PColorBox,Init(objattr,RTTOACOLOR,RTTOACOLCYC,RTTOACOLTITLE,RTPOPUPS2,RTP2COLOR,RTP2COLSTART,false,false,BUBBLE_TXTOBJ_BGCOL));
											new(PObjAttrBox,Init(objattr,RTTOATRANS,true,BUBBLE_TXTOBJ_TRANS));
											new(PCheckBox,Init(objattr,RTTOABORDER,true,BUBBLE_TXTOBJ_BORDER));
											new(PColorBox,Init(objattr,RTTOATCOLOR,RTTOATCOLCYC,RTTOATCOLTITLE,RTPOPUPS2,RTP2COLOR,RTP2COLSTART,false,false,BUBBLE_TXTOBJ_TXTCOL));
											new(pfb,InitCollection(objattr,RTTOAFONTPOP,RTTOAFONTCYC,RTTOAFONTTITLE,26,Parent^.Fonts,false,false,false,BUBBLE_TXTOBJ_FONTID));
											if pfb<>nil then
												begin
													pfb^.newsize:=-1;
													new(fsizes,Init(130,20));
													new(pfsb,InitCollection(objattr,RTTOASIZEPOP,RTTOASIZECYC,RTTOASIZETITLE,6,fsizes,true,false,false,BUBBLE_TXTOBJ_FONTSIZE));
													pfsb^.setsize:=true;
													pfb^.fsizebox:=pfsb;
													pfb^.Work
												end;
											new(pb,Init(objattr,RTTOAHELP,id_Help,false,BUBBLE_GENERAL_HELP));
											if pb<>nil then
												if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
											new(PButton,Init(objattr,RTTOACANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
											new(PButton,Init(objattr,RTTOASET,id_No,true,BUBBLE_GENERAL_OBJSET));
											new(PButton,Init(objattr,RTTOAOK,id_OK,true,BUBBLE_GENERAL_OBJSETOK));
											objattr^.TransferBuffer:=@oabuf
										end;
									TexelApp.DeactivateExtResource
								end;
							if objattr<>nil then objattr^.MakeWindow
						end
					else
						HandleMenu(ret)
			end
	end;

end.