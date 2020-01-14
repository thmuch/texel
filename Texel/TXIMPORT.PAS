unit tximport;
{ 1999-01-29 }

interface

uses

	Objects,OWindows;


type

	PImport = ^ TImport;
	TImport = object(TSubMenu)
		{$IFNDEF LITE}
		st      : PStatic;
		ascii,
		gdbc    : PDialog;
		quelle,
		filename: string;
		procedure HandleMenu(Indx: integer); virtual;
		procedure LoadGDBC(fname: string);
		procedure ImportDBF(fname: string; fields: PStringCollection);
		procedure LoadPsion(fname: string);
		procedure Load123(fname: string);
		procedure LoadXLS(fname: string);
		procedure LoadLDW(fname: string);
		procedure LoadASCII(fname: string);
		procedure ImportASCII(fname,rctrenn,celltrenn,tquote: string; komma2punkt,hor,quote: boolean; flt: integer);
		procedure LoadCSV(fname: string);
		procedure LoadDIF(fname: string);
		procedure ImportFromClipboard;
		{$ENDIF}
	end;




implementation

{$IFNDEF LITE}

uses

	Strings,Tos,Gem,
	OTypes,OProcs,ODialogs,ODB,
	txrsc,txlang,txtypes,txprocs,txmiscob,txcollec,txload,txmain;


type

	PASCIIImportDialog = ^TASCIIImportDialog;
	TASCIIImportDialog = object(THyperDialog)
		pcb: PComboBox;
		function OK: boolean; virtual;
	end;

	PGDBCDialog = ^TGDBCDialog;
	TGDBCDialog = object(THyperDialog)
		st     : PStatic;
		pb0,
		pb1,pb2,
		pb3,pb4: PButton;
		lb1,lb2: PListBox;
		import : PImport;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure CheckButtons;
		procedure LoadFields(lb: PListBox);
	end;



procedure TImport.HandleMenu(Indx: integer);

	begin
		case Indx of
		0:
			ImportFromClipboard;
		2:
			if XFileSelect(nil,FSELTITLE_IMPORTLDW,'*.ldp',TexelApp.LastPath[9],TexelApp.LastFile[9],0,FSEL_LOADLDW,true,false) then LoadLDW(TexelApp.LastPath[9]+TexelApp.LastFile[9]);
		3:
			if XFileSelect(nil,FSELTITLE_IMPORTDIF,'*.dif',TexelApp.LastPath[2],TexelApp.LastFile[2],0,FSEL_LOADDIF,true,false) then LoadDIF(TexelApp.LastPath[2]+TexelApp.LastFile[2]);
		4:
			if XFileSelect(nil,FSELTITLE_IMPORTCSV,'*.csv',TexelApp.LastPath[4],TexelApp.LastFile[4],0,FSEL_LOADCSV,true,false) then LoadCSV(TexelApp.LastPath[4]+TexelApp.LastFile[4]);
		5:
			if XFileSelect(nil,FSELTITLE_IMPORTASCII,'*.txt',TexelApp.LastPath[6],TexelApp.LastFile[6],1,FSEL_LOADASCII,true,false) then LoadASCII(TexelApp.LastPath[6]+TexelApp.LastFile[6]);
		6:
			if XFileSelect(nil,FSELTITLE_IMPORTDBASE,'*.dbf',TexelApp.LastPath[12],TexelApp.LastFile[12],0,FSEL_LOADDBF,true,false) then LoadGDBC(TexelApp.LastPath[12]+TexelApp.LastFile[12]);
		8:
			if XFileSelect(nil,FSELTITLE_IMPORTEXCEL,'*.xls',TexelApp.LastPath[7],TexelApp.LastFile[7],0,FSEL_LOADXLS,true,false) then LoadXLS(TexelApp.LastPath[7]+TexelApp.LastFile[7]);
		9:
			if XFileSelect(nil,FSELTITLE_IMPORT123,'*.wk?',TexelApp.LastPath[10],TexelApp.LastFile[10],0,FSEL_LOAD123,true,false) then Load123(TexelApp.LastPath[10]+TexelApp.LastFile[10]);
		10:
			if XFileSelect(nil,FSELTITLE_IMPORTPSION,'*.spr',TexelApp.LastPath[20],TexelApp.LastFile[20],0,FSEL_LOADPSION,true,false) then LoadPsion(TexelApp.LastPath[20]+TexelApp.LastFile[20]);
		end
	end;


function TASCIIImportDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then
			if Parent=nil then
				with TexelApp do
					PImport(import)^.ImportASCII(PImport(import)^.filename,
					                    TexelApp.num2str(ascbuf.rcTxt),
					                    TexelApp.num2str(ascbuf.cellTxt),
					                    TexelApp.num2str(ascbuf.textTxt),
					                    StrPTrimF(pcb^.GetText)=DEZTRENNKOMMA,
					                    ascbuf.hor=bf_Checked,
					                    ascbuf.quote=bf_Checked,
					                    ascbuf.filter);
		OK:=valid
	end;


procedure TImport.LoadASCII(fname: string);
	var pib1,
	    pib2: PImportButton;
	    pv  : PValidator;
	    picb: PImportCellBox;
	    pb  : PButton;
	    i   : integer;
	    flt : PStringCollection;

	begin
		filename:=fname;
		if ascii=nil then
			begin
				ascii:=new(PASCIIImportDialog,Init(nil,TEXELWINDPREFIX+TITLE_IMPORTASCII,STG_IMPORTASCII,ICNTITLE_IMPORTASCII,RTASCIIIMPORT));
				if ascii<>nil then
					begin
						new(st,Init(ascii,RTAIDATEI,41,true,BUBBLE_IMPASC_FILE));
						new(PGroupBox,Init(ascii,RTAIROWS,GROUP_GENERAL_ROWS,BUBBLE_IMPASC_ROWS));
						new(pib1,Init(ascii,RTAIHOR,true,BUBBLE_IMPASC_HOR));
						new(pib2,Init(ascii,RTAIVERT,true,BUBBLE_IMPASC_VERT));
						new(pib1^.pircb,Init(ascii,RTAIROWCOL,RTAIRCCYC,RTAIRCTITLE,RTPOPUPS,RTPAIROWCOL,id_No,false,true,BUBBLE_IMPASC_LINEEND));
						pib2^.pircb:=pib1^.pircb;
						if pib1^.pircb<>nil then
							if pib1^.pircb^.Edit<>nil then
								begin
									new(pv,Init);
									if pv<>nil then pv^.Options:=voNotEmpty;
									pib1^.pircb^.Edit^.SetValidator(pv)
								end;
						new(picb,Init(ascii,RTAICELLS,RTAICCYC,RTAICTITLE,RTPOPUPS,RTPAICELLS,id_No,false,true,BUBBLE_IMPASC_CELLDIV));
						if picb<>nil then
							if picb^.Edit<>nil then
								begin
									new(pv,Init);
									if pv<>nil then pv^.Options:=voNotEmpty;
									picb^.Edit^.SetValidator(pv)
								end;
						new(PImportTextBox,Init(ascii,RTAITEXT,RTAITCYC,RTAITTITLE,RTPOPUPS,RTPAITEXT,id_No,false,true,BUBBLE_IMPASC_QUOTECHAR));
						new(PCheckBox,Init(ascii,RTAIQUOTE,true,BUBBLE_IMPASC_QUOTING));
						new(PASCIIImportDialog(ascii)^.pcb,Init(ascii,RTAINUMBER,RTAINCYC,RTAINTITLE,RTPOPUPS,RTPAINUMBERS,id_No,true,false,BUBBLE_IMPASC_FPOINT));
						new(flt,Init(10,5));
						if flt<>nil then
							begin
								flt^.Sort:=false;
								if InitKeyTab then
									for i:=0 to pkt^.GetImportCount do flt^.Insert(NewStr('  '+StrPPas(pkt^.pasGetImportName(nil,nil,0,0,0,i))+' '#0))
								else
									flt^.Insert(NewStr('  Atari '#0))
							end;
						new(PComboBox,InitCollection(ascii,RTAIFILTER,RTAIFCYC,RTAIFTITLE,20,flt,true,true,false,BUBBLE_IMPASC_FILTER));
						new(pb,Init(ascii,RTAIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ascii,RTAIABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ascii,RTAIOK,id_OK,true,BUBBLE_IMPASC_OK));
						ascii^.TransferBuffer:=@TexelApp.ascbuf;
						if TexelApp.ascbuf.hor=bf_Checked then pib1^.Changed(RTAIHOR,false)
						else
							pib2^.Changed(RTAIVERT,false)
					end
			end;
		if ascii<>nil then
			begin
				if st<>nil then st^.SetText(CompressPath(fname,40));
				ascii^.MakeWindow
			end
	end;


function TGDBCDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then import^.ImportDBF(import^.quelle,lb2^.List);
		OK:=valid
	end;


function TGDBCDialog.ExitDlg(AnIndx: integer): boolean;
	var sel: integer;

	begin
		ExitDlg:=false;
		case AnIndx of
		RTGDIMPORT:
			begin
				sel:=lb1^.GetSelection;
				if sel<0 then exit;
				lb2^.List^.Insert(lb1^.List^.At(sel));
				lb1^.List^.AtDelete(sel);
				lb1^.SetCollection(lb1^.List);
				lb2^.SetCollection(lb2^.List);
				lb1^.SetSelection(sel);
				lb2^.SetSelection(lb2^.List^.Count-1);
				CheckButtons
			end;
		RTGDIGNORE:
			begin
				sel:=lb2^.GetSelection;
				if sel<0 then exit;
				lb1^.List^.Insert(lb2^.List^.At(sel));
				lb2^.List^.AtDelete(sel);
				lb1^.SetCollection(lb1^.List);
				lb2^.SetCollection(lb2^.List);
				lb1^.SetSelection(lb1^.List^.Count-1);
				lb2^.SetSelection(sel);
				CheckButtons
			end;
		RTGDALL:
			begin
				while lb1^.List^.Count>0 do
					begin
						lb2^.List^.Insert(lb1^.List^.At(0));
						lb1^.List^.AtDelete(0)
					end;
				lb1^.SetCollection(lb1^.List);
				lb2^.SetCollection(lb2^.List);
				lb2^.SetSelection(lb2^.List^.Count-1);
				CheckButtons
			end;
		RTGDNONE:
			LoadFields(lb1)
		end
	end;


procedure TGDBCDialog.CheckButtons;

	begin
		if lb1^.List^.Count=0 then
			begin
				pb1^.Disable;
				pb3^.Disable
			end
		else
			begin
				pb1^.Enable;
				pb3^.Enable
			end;
		if lb2^.List^.Count=0 then
			begin
				pb2^.Disable;
				pb4^.Disable;
				pb0^.Disable
			end
		else
			begin
				pb2^.Enable;
				pb4^.Enable;
				pb0^.Enable
			end
	end;


procedure TGDBCDialog.LoadFields(lb: PListBox);
	var txt : string;
	    pxb : PXBase;
	    pxbf: PXBField;
	    anz : longint;

	begin
		lb1^.List^.FreeAll;
		lb1^.List^.Sort:=false;
		lb2^.List^.FreeAll;
		lb2^.List^.Sort:=false;
		anz:=0;
		BusyMouse;
		new(pxb,InitFile(import^.quelle));
		if pxb<>nil then
			begin
				anz:=pxb^.GetMaxRecords;
				pxbf:=pxb^.Fields;
				while pxbf<>nil do
					begin
						lb^.List^.Insert(NewStr('  '+StrPLeft(pxbf^.GetName,18)+#0));
						pxbf:=pxbf^.Next
					end;
				dispose(pxb,Done)
			end;
		ArrowMouse;
		if length(import^.quelle)=0 then
			begin
				if st<>nil then st^.SetText(STRING_DB_SOURCE+': ['+STRING_DB_EMPTY+']')
			end
		else
			begin
				txt:='" ('+ltoa(anz)+' '+STRING_DB_RECORDS+')';
				if st<>nil then st^.SetText(STRING_DB_SOURCE+': "'+CompressPath(import^.quelle,52-length(txt))+txt)
			end;
		lb1^.SetCollection(lb1^.List);
		lb2^.SetCollection(lb2^.List);
		CheckButtons
	end;


procedure TImport.LoadGDBC(fname: string);
	var pb: PButton;

	begin
		quelle:=fname;
		if gdbc=nil then
			begin
				TexelApp.ActivateExtResource;
				gdbc:=new(PGDBCDialog,Init(nil,TEXELWINDPREFIX+TITLE_IMPORTGDBC,STG_IMPORTGDBC,ICNTITLE_IMPORTGDBC,RTGDBC));
				if gdbc<>nil then
					begin
						PGDBCDialog(gdbc)^.import:=@self;
						new(PGDBCDialog(gdbc)^.st,Init(gdbc,RTGDSOURCE,63,true,BUBBLE_IMPDB_SOURCE));
						new(PGDBCDialog(gdbc)^.pb1,Init(gdbc,RTGDIMPORT,id_No,true,BUBBLE_IMPDB_IMPORT));
						new(PGDBCDialog(gdbc)^.pb2,Init(gdbc,RTGDIGNORE,id_No,true,BUBBLE_IMPDB_IGNORE));
						new(PGDBCDialog(gdbc)^.pb3,Init(gdbc,RTGDALL,id_No,true,BUBBLE_IMPDB_ALL));
						new(PGDBCDialog(gdbc)^.pb4,Init(gdbc,RTGDNONE,id_No,true,BUBBLE_IMPDB_NONE));
						new(PGDBCDialog(gdbc)^.lb1,Init(gdbc,RTGDIGNORELIST,RTGDIGNSLID,RTGDIGNDEC,RTGDIGNINC,new(PStringCollection,Init(20,10)),true,BUBBLE_IMPDB_IGNORELIST));
						new(PGDBCDialog(gdbc)^.lb2,Init(gdbc,RTGDIMPORTLIST,RTGDIMPSLID,RTGDIMPDEC,RTGDIMPINC,new(PStringCollection,Init(20,10)),true,BUBBLE_IMPDB_IMPORTLIST));
						new(pb,Init(gdbc,RTGDHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(gdbc,RTGDABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PGDBCDialog(gdbc)^.pb0,Init(gdbc,RTGDOK,id_OK,true,BUBBLE_IMPDB_OK))
					end;
				TexelApp.DeactivateExtResource
			end;
		if gdbc<>nil then
			begin
				PGDBCDialog(gdbc)^.LoadFields(PGDBCDialog(gdbc)^.lb2);
				gdbc^.MakeWindow
			end
	end;


procedure TImport.ImportDBF(fname: string; fields: PStringCollection);
	label _raus,_error;

	var pxb      : PXBase;
	    pxbf     : PXBField;
	    pg       : PProgressWindow;
	    dummy,
	    cmax,
	    rmax,
	    loffs,
	    sze,q    : longint;
	    w,ww,sf,
	    dfrm,
	    fldmax,sg: integer;
	    sheet,
	    cell     : PCell;
			prow,
			pcol     : PWordArray;
			pfldindx : PIntegerArray;
			pcolnames: PItemList;
			number   : TNumber;
			ttxt,otxt: string;
			error    : boolean;
			fp       : byte;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		new(pxb,InitFile(fname));
		if pxb=nil then
			begin
				ArrowMouse;
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				exit
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		pfldindx:=nil;
		fldmax:=pxb^.GetMaxFields;
		rmax:=Max(pxb^.GetMaxRecords,2);
		if rmax>16384 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_DBSIZE,BUTTON_OK);
				if pg<>nil then dispose(pg,Done);
				goto _raus
			end;
		if fields<>nil then
			if fields^.Count>0 then fldmax:=fields^.Count;
		getmem(pfldindx,fldmax shl 1);
		if pfldindx=nil then
			begin
				if pg<>nil then dispose(pg,Done);
				TexelApp.ErrorWindowMemory(nil);
				goto _raus
			end;
		for w:=0 to fldmax-1 do pfldindx^[w]:=w;
		if fields<>nil then
			if fields^.Count>0 then
				for w:=0 to fldmax-1 do
					begin
						q:=0;
						pxbf:=pxb^.Fields;
						while pxbf<>nil do
							begin
								if pxbf^.GetName=StrPTrimF(PString(fields^.At(w))^) then break;
								inc(q);
								pxbf:=pxbf^.Next
							end;
						pfldindx^[w]:=q
					end;
		cmax:=Max(fldmax,2);
		getmem(prow,rmax shl 1);
		getmem(pcol,cmax shl 1);
		getmem(pcolnames,cmax shl 2);
		loffs:=cmax*CELLSIZE;
		dummy:=rmax*loffs;
		getmem(sheet,dummy);
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) then
			begin
				if prow<>nil then freemem(prow,rmax shl 1);
				if pcol<>nil then freemem(pcol,cmax shl 1);
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				if pg<>nil then dispose(pg,Done);
				TexelApp.ErrorWindowMemory(nil);
				goto _raus
			end;
		if pg<>nil then pg^.SetMax(pxb^.GetMaxRecords shl 1);
		fillchar(pcolnames^,cmax shl 2,0);
		fillchar(sheet^,dummy,0);
		with TexelApp do
			begin
				vst_font(vdiHandle,GetStdFontIndex);
				{$IFDEF NVDI5}
				vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ELSE}
				if SpeedoActive then vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
				else
					vst_point(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ENDIF}
				if vqt_width(vdiHandle,ord('9'),ww,w,w)<>ord('9') then ww:=Attr.charWidth;
				SetSystemFont(vdiHandle,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
			end;
		sze:=Max(Min(round(longint(ww)*atol(TexelApp.setupbuffer.stdcolwidth)*longint(Application^.Attr.PixW)/10.0),65535),0);
		for q:=0 to cmax-1 do pcol^[q]:=sze;
		TexelApp.InitCells(sheet,rmax,cmax);
		for w:=0 to fldmax-1 do
			begin
				pxbf:=pxb^.GetFieldByNumber(pfldindx^[w]);
				if pxbf<>nil then
					begin
						pcolnames^[w]:=NewStr(pxbf^.GetName);
						pcol^[w]:=Max(Min(round(longint(ww)*longint(pxbf^.GetLength)*longint(Application^.Attr.PixW)/10.0),65535),0)
					end
			end;
		sf:=TexelApp.GetStdFontIndex;
		sg:=TexelApp.GetStdFontSize;
		fp:=atol(TexelApp.setupbuffer.floatpoint);
		error:=false;
		for q:=1 to pxb^.GetMaxRecords do
			begin
				cell:=PCell(longint(sheet)+q*loffs-loffs);
				if not(pxb^.GetRecord) then
					begin
						error:=(q=1);
						goto _error
					end;
				if pg<>nil then pg^.Progress(1);
				for w:=0 to fldmax-1 do
					begin
						pxbf:=pxb^.GetFieldByNumber(pfldindx^[w]);
						if pxbf<>nil then
							case pxbf^.GetType of
							'C':
								begin
									ttxt:=pxbf^.GetString;
									if length(ttxt)>0 then
										begin
											if TexelApp.IsDate(ttxt,number,otxt,dfrm,TexelApp.setupbuffer.exceldate=bf_Checked) then
												begin
													new(cell^.Data.Konst);
													if cell^.Data.Konst<>nil then
														begin
															cell^.Typ:=CTYPE_CONST;
															cell^.Format:=dfrm;
															with cell^.Data.Konst^ do
																begin
																	Txt:=NewStr(otxt);
																	Value:=number;
																	FPts:=fp
																end;
															cell^.TxtVal.Font:=sf;
															cell^.TxtVal.Size:=sg
														end
												end
											else
												if TexelApp.IsTime(ttxt,number,otxt,dfrm) then
													begin
														new(cell^.Data.Konst);
														if cell^.Data.Konst<>nil then
															begin
																cell^.Typ:=CTYPE_CONST;
																cell^.Format:=dfrm;
																with cell^.Data.Konst^ do
																	begin
																		Txt:=NewStr(otxt);
																		Value:=number;
																		FPts:=fp
																	end;
																cell^.TxtVal.Font:=sf;
																cell^.TxtVal.Size:=sg
															end
													end
												else
													begin
														cell^.Data.Txt:=NewStr(ttxt);
														if cell^.Data.Txt<>nil then
															begin
																cell^.Typ:=CTYPE_TEXT;
																cell^.TxtVal.Font:=sf;
																cell^.TxtVal.Size:=sg
															end
													end
										end
								end;
							'N','F':
								begin
									new(cell^.Data.Konst);
									if cell^.Data.Konst<>nil then
										begin
											cell^.Typ:=CTYPE_CONST;
											cell^.TxtVal.Font:=sf;
											cell^.TxtVal.Size:=sg;
											cell^.TxtVal.Align:=TA_RIGHT;
											with cell^.Data.Konst^ do
												begin
													Txt:=NewStr(pxbf^.GetString);
													Value:=pxbf^.GetNumber;
													FPts:=pxbf^.GetFloatpt
												end
										end
								end;
							'L':
								begin
									if pxbf^.GetLogical=xb_True then ttxt:='='+STRING_TRUE
									else
										ttxt:='='+STRING_FALSE;
									new(cell^.Data.Formula);
									if cell^.Data.Formula<>nil then
										begin
											cell^.Typ:=CTYPE_FORMULA;
											with cell^.Data.Formula^ do
												begin
													Value:=0.0;
													FPts:=0;
													Error:=FE_OK;
													VarDef:=NewStr(ttxt);
													Func:=nil;
													cell^.TxtVal.Font:=sf;
													cell^.TxtVal.Size:=sg;
													cell^.TxtVal.Align:=TA_RIGHT
												end
										end
								end;
							'D':
								begin
									ttxt:=pxbf^.GetDate;
									if TexelApp.IsDate(ttxt,number,otxt,dfrm,TexelApp.setupbuffer.exceldate=bf_Checked) then
										begin
											new(cell^.Data.Konst);
											if cell^.Data.Konst<>nil then
												begin
													cell^.Typ:=CTYPE_CONST;
													cell^.Format:=dfrm;
													with cell^.Data.Konst^ do
														begin
															Txt:=NewStr(otxt);
															Value:=number;
															FPts:=fp
														end;
													cell^.TxtVal.Font:=sf;
													cell^.TxtVal.Size:=sg
												end
										end
									else
										begin
											cell^.Data.Txt:=NewStr(ttxt);
											if cell^.Data.Txt<>nil then
												begin
													cell^.Typ:=CTYPE_TEXT;
													cell^.TxtVal.Font:=sf;
													cell^.TxtVal.Size:=sg
												end
										end
								end
							end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		_error:
		if error then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			new(PCalcWindow,InitImport(pg,rmax-1,cmax-1,fname,sheet,prow,pcol,pcolnames,false));
		_raus:
		pxb^.Free;
		if pfldindx<>nil then freemem(pfldindx,fldmax shl 1);
		ArrowMouse
	end;


procedure TImport.LoadPsion(fname: string);
	label _raus,_error,_errmsg;

	var formulas,
	    stack    : PStringCollection;
	    pg       : PProgressWindow;
			prow,
			pcol     : PWordArray;
			pcolnames: PItemList;
	    buf      : PByteArray;
	    bufsize,
	    rmax,cmax,
	    spos,sze,
	    dummy,q,
	    stdcol,
	    res,fcnt : longint;
	    sf,sg,
	    hdl,ww,i : integer;
	    w,rc,cc  : word;
	    sheet,
	    cell     : PCell;
	    pb       : PByte;
	    ttxt     : string;
			ieee64   : double;
			fp       : byte;
	    rec      : record
	    	opcode,
	    	len   : word
	    end;

	function bread(buffer: pointer; count: longint): boolean;

		begin
			if fread(hdl,count,buffer)=count then bread:=false
			else
				begin
					bread:=true;
					res:=-1
				end
		end;
	
	function readrecord: boolean;
	
		begin
			readrecord:=true;
			if bread(@rec,sizeof(rec)) then exit;
			rec.opcode:=swap(rec.opcode);
			rec.len:=swap(rec.len);
			if rec.len>0 then
				begin
					if rec.len>4096 then
						begin
							res:=-1;
							exit
						end;
					if bread(buf,rec.len) then exit
				end;
			readrecord:=false
		end;

	function getword(boffs: integer): word;
	
		begin
			getword:=buf^[boffs] or (buf^[boffs+1] shl 8)
		end;

	function getint(boffs: integer): integer;

		begin
			getint:=getword(boffs)
		end;

	function getcell(r,c: longint): PCell;

		begin
			if (bTst(r,$8000) or bTst(c,$8000)) then getcell:=nil
			else
				getcell:=PCell(longint(sheet)+(r*cmax+c)*CELLSIZE)
		end;

	function getformula: string;
		var foffs,fend,i: integer;
		    fehler      : boolean;
		    txt         : string;

		procedure push(s: string);
		
			begin
				stack^.AtInsert(0,NewStr(s))
			end;
		
		function pop: string;
		
			begin
				if stack^.Count>0 then
					begin
						pop:=PString(stack^.At(0))^;
						stack^.AtFree(0)
					end
				else
					begin
						pop:='';
						fehler:=true
					end
			end;

		begin
			foffs:=3;
			fend:=foffs+buf^[2];
			fehler:=false;
			stack^.FreeAll;
			while (buf^[foffs]<>21) and (foffs<fend) and not(fehler) do
				begin
					case buf^[foffs] of
					1:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')<('+txt+')')
						end;
					2:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')<=('+txt+')')
						end;
					3:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')>('+txt+')')
						end;
					4:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')>=('+txt+')')
						end;
					5:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')<>('+txt+')')
						end;
					6:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')=('+txt+')')
						end;
					7,17:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'+'+txt)
						end;
					8:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'-'+txt)
						end;
					9:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'*'+txt)
						end;
					10:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'/'+txt)
						end;
					11:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'**'+txt)
						end;
					12:
						begin
							inc(foffs);
							push('('+pop+')')
						end;
					13:
						begin
							inc(foffs);
							push('-('+pop+')')
						end;
					14:
						begin
							inc(foffs);
							push(#27+ltoa(NT_NICHT)+#27'('+pop+')')
						end;
					15:
						begin
							inc(foffs);
							txt:=pop;
							push(#27+ltoa(NT_UND)+#27'('+pop+ARGTRENNSEMIKOLON+txt+')')
						end;
					16:
						begin
							inc(foffs);
							txt:=pop;
							push(#27+ltoa(NT_ODER)+#27'('+pop+ARGTRENNSEMIKOLON+txt+')')
						end;
					22:
						begin
							pb:=@ieee64;
							for i:=foffs+8 downto foffs+1 do
								begin
									pb^:=buf^[i];
									inc(longint(pb))
								end;
							push(ftoa(ieee64));
							inc(foffs,9)
						end;
					23:
						begin
							push(ltoa(getint(foffs+1)));
							inc(foffs,3)
						end;
					24:
						begin
							StrMove(@txt[0],@buf^[foffs+1],buf^[foffs+1]+1);
							push('"'+txt+'"');
							inc(foffs,buf^[foffs+1]+2)
						end;
					25:
						begin
							push(#1+chr(buf^[foffs+2])+chr(buf^[foffs+1])+chr(buf^[foffs+4])+chr(buf^[foffs+3]));
							inc(foffs,5)
						end;
					26,131,132,134:
						begin
							push(#1+chr(buf^[foffs+2])+chr(buf^[foffs+1])+chr(buf^[foffs+4])+chr(buf^[foffs+3])+':'#1+chr(buf^[foffs+6])+chr(buf^[foffs+5])+chr(buf^[foffs+8])+chr(buf^[foffs+7]));
							inc(foffs,9)
						end;
					27:
						begin
							inc(foffs);
							push(#27+ltoa(NT_FEHLER)+#27)
						end;
					28:
						begin
							inc(foffs);
							push(#27+ltoa(NT_FALSE)+#27)
						end;
					30:
						begin
							inc(foffs);
							push(#27+ltoa(NT_PI)+#27)
						end;
					31:
						begin
							inc(foffs);
							push(#27+ltoa(NT_RND)+#27)
						end;
					32:
						begin
							inc(foffs);
							push(#27+ltoa(NT_JETZT)+#27)
						end;
					33:
						begin
							inc(foffs);
							push(#27+ltoa(NT_TRUE)+#27)
						end;
					34:
						begin
							inc(foffs);
							push(#27+ltoa(NT_ABS)+#27'('+pop+')')
						end;
					{ !!! }
					115:
						begin
							txt:='';
							if buf^[foffs+1]>0 then
								for i:=1 to buf^[foffs+1] do
									begin
										if length(txt)>0 then txt:=ARGTRENNSEMIKOLON+txt;
										txt:=pop+txt
									end;
							push(#27+ltoa(NT_MAX)+#27'('+txt+')');
							inc(foffs,2)
						end;
					116:
						begin
							txt:='';
							if buf^[foffs+1]>0 then
								for i:=1 to buf^[foffs+1] do
									begin
										if length(txt)>0 then txt:=ARGTRENNSEMIKOLON+txt;
										txt:=pop+txt
									end;
							push(#27+ltoa(NT_MIN)+#27'('+txt+')');
							inc(foffs,2)
						end;
					118:
						begin
							txt:='';
							if buf^[foffs+1]>0 then
								for i:=1 to buf^[foffs+1] do
									begin
										if length(txt)>0 then txt:=ARGTRENNSEMIKOLON+txt;
										txt:=pop+txt
									end;
							push(#27+ltoa(NT_SUMME)+#27'('+txt+')');
							inc(foffs,2)
						end;
					{ !!! }
					123,124,126:
						inc(foffs);
					else
						begin
{							write(buf^[foffs],' (',foffs,'/',fend,'): ');  !!! }
							fehler:=true
						end
					end
				end;
			txt:='='+pop;
			getformula:=txt;
{			if fehler then
				begin
					writeln('>> ',txt,' <<');
					cconin
				end; !!! }
			if fehler then getformula:='='#27+ltoa(NT_FEHLER)+#27
		end;

	function fixrefs(r,c: longint; s: string): string;
		var q    : integer;
		    nr,nc: longint;
		    s3   : string[3];

		procedure check(var l: longint; cmp: longint; offs: integer);
		
			begin
				l:=((ord(s[q+offs]) shl 8) or ord(s[q+offs+1])) and $0000ffff;
				if l=$00008000 then l:=cmp
				else
					if (l>$0000a000) and (l<=$0000bfff) then l:=cmp-($0000c000-l)
					else
						if (l>$00008000) and (l<=$00009fff) then l:=cmp+(l and $00007fff)
						else
							if l>$00001fff then l:=-1;
			end;

		begin
			q:=pos(#1,s);
			while q>0 do
				begin
					check(nc,c,1);
					check(nr,r,3);
					if nc<0 then s3:='?'
					else
						if nc<26 then s3:=chr(65+nc)
						else
							s3:=chr(64+(nc div 26))+chr(65+(nc mod 26));
					s:=StrPLeft(s,q-1)+s3+ltoa(nr+1)+StrPRight(s,length(s)-q-4);
					q:=pos(#1,s)
				end;
			fixrefs:=s
		end;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		pg:=nil;
		formulas:=nil;
		buf:=GetMemBuffer(16384,4096,bufsize);
		new(stack,Init(100,50));
		if (buf=nil) or (stack=nil) then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_IMPORT_MEMORY1+CompressPath(fname,78)+MESSAGE_IMPORT_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		stack^.Sort:=false;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXIST1+CompressPath(fname,78)+MESSAGE_IMPORT_EXIST2,BUTTON_OK);
				goto _raus
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		if bread(buf,22) then goto _error;
		buf^[16]:=0;
		if strcomp(PChar(buf),'SPREADSHEET')<>0 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_PSION1+CompressPath(fname,78)+MESSAGE_IMPORT_PSION2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done);
				fclose(hdl);
				goto _raus
			end;
		spos:=fseek(0,hdl,1);
		if spos<0 then
			begin
				res:=-1;
				goto _error
			end;
		rmax:=2;
		cmax:=2;
		stdcol:=atol(TexelApp.setupbuffer.stdcolwidth);
		sze:=0;
		fcnt:=0;
		while not(readrecord) do
			case rec.opcode of
			1:
				begin
					inc(fcnt);
					inc(sze)
				end;
			2:
				begin
					w:=getword(0);
					if not(bTst(w,$8000)) then
						if w>=cmax then cmax:=w+1;
					w:=getword(2);
					if not(bTst(w,$8000)) then
						if w>=rmax then rmax:=w+1;
					inc(sze)
				end;
			4:
				stdcol:=getword(0);
			end;
		if fseek(0,hdl,1)=GetFileSize(fname,hdl) then res:=0
		else
			goto _error;
		getmem(prow,rmax shl 1);
		getmem(pcol,cmax shl 1);
		getmem(pcolnames,cmax shl 2);
		dummy:=rmax*cmax*CELLSIZE;
		getmem(sheet,dummy);
		new(formulas,Init(fcnt+1,10));
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) or (formulas=nil) then
			begin
				if prow<>nil then freemem(prow,rmax shl 1);
				if pcol<>nil then freemem(pcol,cmax shl 1);
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				if pg<>nil then dispose(pg,Done);
				TexelApp.ErrorWindowMemory(nil);
				fclose(hdl);
				goto _raus
			end;
		formulas^.Sort:=false;
		if pg<>nil then pg^.SetMax(rmax+sze);
		fillchar(pcolnames^,cmax shl 2,0);
		fillchar(sheet^,dummy,0);
		with TexelApp do
			begin
				vst_font(vdiHandle,GetStdFontIndex);
				{$IFDEF NVDI5}
				vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ELSE}
				if SpeedoActive then vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
				else
					vst_point(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ENDIF}
				if vqt_width(vdiHandle,ord('9'),ww,i,i)<>ord('9') then ww:=Attr.charWidth;
				SetSystemFont(vdiHandle,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
			end;
		sze:=Max(Min(round(longint(ww)*stdcol*longint(Application^.Attr.PixW)/7.0),65535),0);
		for q:=0 to cmax-1 do pcol^[q]:=sze;
		TexelApp.InitCells(sheet,rmax,cmax);
		sf:=TexelApp.GetStdFontIndex;
		sg:=TexelApp.GetStdFontSize;
		fp:=atol(TexelApp.setupbuffer.floatpoint);
		if fseek(spos,hdl,0)<0 then
			begin
				res:=-1;
				goto _error
			end;
		while not(readrecord) do
			case rec.opcode of
			1:
				begin
					if pg<>nil then pg^.Progress(1);
					formulas^.Insert(NewStr(getformula))
				end;
			2:
				begin
					if pg<>nil then pg^.Progress(1);
					cc:=getword(0);
					rc:=getword(2);
					cell:=getcell(rc,cc);
					if cell=nil then continue;
					if bTst(buf^[5],$80) then cell^.Flags:=cell^.Flags or CELL_PROTECTED;
					case (buf^[4] and $07) of
					1:
						begin
							new(cell^.Data.Konst);
							if cell^.Data.Konst<>nil then
								begin
									pb:=@ieee64;
									for i:=13 downto 6 do
										begin
											pb^:=buf^[i];
											inc(longint(pb))
										end;
									cell^.Typ:=CTYPE_CONST;
									cell^.TxtVal.Font:=sf;
									cell^.TxtVal.Size:=sg;
									if bTst(buf^[4],$20) then cell^.TxtVal.Align:=TA_LEFT
									else
										cell^.TxtVal.Align:=TA_RIGHT;
									with cell^.Data.Konst^ do
										begin
											Value:=ieee64;
											Txt:=NewStr(ftoa(Value));
											if (buf^[5] and $70)=$70 then FPts:=fp
											else
												FPts:=(buf^[5] and $0f)
										end
								end
						end;
					2:
						if buf^[6]>0 then
							begin
								StrMove(@ttxt[0],@buf^[6],buf^[6]+1);
								cell^.Typ:=CTYPE_TEXT;
								cell^.Data.Txt:=NewStr(ttxt);
								case (buf^[4] and $18) of
								$18:
									cell^.TxtVal.Align:=TA_CENTER;
								$10:
									cell^.TxtVal.Align:=TA_RIGHT;
								else
									cell^.TxtVal.Align:=TA_LEFT
								end;
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg
							end;
					3:
						begin
							new(cell^.Data.Konst);
							if cell^.Data.Konst<>nil then
								begin
									cell^.Typ:=CTYPE_CONST;
									cell^.TxtVal.Font:=sf;
									cell^.TxtVal.Size:=sg;
									if bTst(buf^[4],$20) then cell^.TxtVal.Align:=TA_LEFT
									else
										cell^.TxtVal.Align:=TA_RIGHT;
									with cell^.Data.Konst^ do
										begin
											Value:=getint(6);
											Txt:=NewStr(ltoa(getint(6)));
											FPts:=0
										end
								end
						end;
					5,6:
						begin
							i:=getword(6);
							if (i>=0) and (i<formulas^.Count) then
								begin
									ttxt:=PString(formulas^.At(i))^;
									if (buf^[4] and $07)=6 then ieee64:=0.0
									else
										begin
											pb:=@ieee64;
											for i:=15 downto 8 do
												begin
													pb^:=buf^[i];
													inc(longint(pb))
												end
										end;
									ttxt:=TexelApp.EscText2Formula(fixrefs(rc,cc,ttxt));
									if length(ttxt)>0 then
										begin
											new(cell^.Data.Formula);
											if cell^.Data.Formula<>nil then
												begin
													cell^.Typ:=CTYPE_FORMULA;
													cell^.TxtVal.Font:=sf;
													cell^.TxtVal.Size:=sg;
													if (buf^[4] and $07)=6 then
														begin
															case (buf^[4] and $18) of
															$18:
																cell^.TxtVal.Align:=TA_CENTER;
															$10:
																cell^.TxtVal.Align:=TA_RIGHT;
															else
																cell^.TxtVal.Align:=TA_LEFT;
															end
														end
													else
														if bTst(buf^[4],$20) then cell^.TxtVal.Align:=TA_LEFT
														else
															cell^.TxtVal.Align:=TA_RIGHT;
													with cell^.Data.Formula^ do
														begin
															Value:=ieee64;
															FPts:=fp;
															Error:=FE_OK;
															VarDef:=NewStr(ttxt);
															Func:=nil
														end
												end
										end
								end
						end
					end
				end
			end;
		if fseek(0,hdl,1)=GetFileSize(fname,hdl) then res:=0;
		_error:
		fclose(hdl);
		_errmsg:
		if res<0 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			new(PCalcWindow,InitImport(pg,rmax-1,cmax-1,fname,sheet,prow,pcol,pcolnames,false));
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		if stack<>nil then dispose(stack,Done);
		if formulas<>nil then dispose(formulas,Done);
		ArrowMouse
	end;


procedure TImport.Load123(fname: string);
	label _error,_errmsg,_raus;
	
	const WK_BOF            = $0000;
	      WK_EOF            = $0001;
	      WK_SAVE_RANGE     = $0006;
	      WK_WINDOW1        = $0007;
	      WK_COLUMN_WIDTH_1 = $0008;
	      WK_INTEGER        = $000d;
	      WK_NUMBER         = $000e;
	      WK_LABEL          = $000f;
	      WK_FORMULA        = $0010;
	      WK_WKS_PASSWORD   = $004b;

	var pg       : PProgressWindow;
	    buf      : PByteArray;
	    spos,q,
	    sze,
	    bufsize,
	    dummy,res,
	    stdcol,
	    rmax,cmax: longint;
	    sf,sg,
	    rowoffs,
	    coloffs,
	    colnr,
	    hdl,w,ww : integer;
	    sheet,
	    cell     : PCell;
	    pb       : PByte;
			prow,
			pcol     : PWordArray;
			stack    : PStringCollection;
			pcolnames: PItemList;
			fp       : byte;
			ttxt     : string;
			ieee64   : double;
	    rec      : record
	    	opcode,
	    	len   : word
	    end;

	function bread(buffer: pointer; count: longint): boolean;

		begin
			if fread(hdl,count,buffer)=count then bread:=false
			else
				begin
					bread:=true;
					res:=-1
				end
		end;
	
	function readrecord: boolean;
	
		begin
			readrecord:=true;
			if bread(@rec,sizeof(rec)) then exit;
			rec.opcode:=swap(rec.opcode);
			rec.len:=swap(rec.len);
			if rec.len>0 then
				begin
					if rec.len>4096 then
						begin
							res:=-1;
							exit
						end;
					if bread(buf,rec.len) then exit
				end;
			readrecord:=false
		end;

	function getint(boffs: integer): integer;
	
		begin
			getint:=buf^[boffs] or (buf^[boffs+1] shl 8)
		end;

	function getcell(r,c: longint): PCell;
	
		begin
			getcell:=PCell(longint(sheet)+(r*cmax+c)*CELLSIZE)
		end;

	function GetColumnIndex(hsb,lsb: byte): string;
		var Nr,ofs: integer;

		begin
			if bTst(hsb,$80) then
				begin
					ofs:=coloffs;
					hsb:=hsb and $7f
				end
			else
				ofs:=0;
			Nr:=integer((word(hsb) shl 8) or word(lsb));
			if hsb=0 then
				begin
					if Nr>=128 then dec(Nr,256)
				end
			else
				if Nr>=8192 then dec(Nr,16384);
			inc(Nr,ofs);
			if Nr<0 then GetColumnIndex:='?'
			else
				if Nr<26 then GetColumnIndex:=chr(65+Nr)
				else
					GetColumnIndex:=chr(64+(Nr div 26))+chr(65+(Nr mod 26))
		end;

	function GetRowIndex(hsb,lsb: byte): string;
		var Nr,ofs: integer;

		begin
			if bTst(hsb,$80) then
				begin
					ofs:=rowoffs;
					hsb:=hsb and $7f
				end
			else
				ofs:=0;
			Nr:=integer((word(hsb) shl 8) or word(lsb));
			if Nr>=8192 then dec(Nr,16384);
			inc(Nr,ofs);
			if Nr<0 then GetRowIndex:='0'
			else
				GetRowIndex:=ltoa(Nr+1)
		end;

	function getformula: string;
		var txt,txt2: string;
		    foffs,i : integer;
		    fehler  : boolean;

		procedure push(s: string);
		
			begin
				stack^.AtInsert(0,NewStr(s))
			end;
		
		function pop: string;
		
			begin
				if stack^.Count>0 then
					begin
						pop:=PString(stack^.At(0))^;
						stack^.AtFree(0)
					end
				else
					begin
						pop:='';
						fehler:=true
					end
			end;
	
		begin
			foffs:=15;
			fehler:=false;
			stack^.FreeAll;
			while (buf^[foffs]<>$03) and not(fehler) do
				begin
					case buf^[foffs] of
					$00:
						begin
							pb:=@ieee64;
							for i:=foffs+8 downto foffs+1 do
								begin
									pb^:=buf^[i];
									inc(longint(pb))
								end;
							push(ftoa(ieee64));
							inc(foffs,9)
						end;
					$01:
						begin
							push(GetColumnIndex(buf^[foffs+2],buf^[foffs+1])+GetRowIndex(buf^[foffs+4],buf^[foffs+3]));
							inc(foffs,5)
						end;
					$02:
						begin
							push(GetColumnIndex(buf^[foffs+2],buf^[foffs+1])+GetRowIndex(buf^[foffs+4],buf^[foffs+3])+':'+GetColumnIndex(buf^[foffs+6],buf^[foffs+5])+GetRowIndex(buf^[foffs+8],buf^[foffs+7]));
							inc(foffs,9)
						end;
					$04:
						begin
							inc(foffs);
							push('('+pop+')')
						end;
					$05:
						begin
							push(ltoa(getint(foffs+1)));
							inc(foffs,3)
						end;
					$06:
						begin
							txt:='';
							inc(foffs);
							while buf^[foffs]<>0 do
								begin
									txt:=txt+chr(buf^[foffs]);
									inc(foffs)
								end;
							push(TexelApp.dosmask(txt));
							inc(foffs)
						end;
					$08:
						begin
							inc(foffs);
							push('-('+pop+')')
						end;
					$09:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'+'+txt)
						end;
					$0a:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'-'+txt)
						end;
					$0b:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'*'+txt)
						end;
					$0c:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'/'+txt)
						end;
					$0d:
						begin
							inc(foffs);
							txt:=pop;
							push(pop+'^'+txt)
						end;
					$0e:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')=('+txt+')')
						end;
					$0f:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')<>('+txt+')')
						end;
					$10:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')<=('+txt+')')
						end;
					$11:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')>=('+txt+')')
						end;
					$12:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')<('+txt+')')
						end;
					$13:
						begin
							inc(foffs);
							txt:=pop;
							push('('+pop+')>('+txt+')')
						end;
					$17:
						inc(foffs);
					$21:
						begin
							inc(foffs);
							push(#27+ltoa(NT_ABS)+#27'('+pop+')')
						end;
					$22:
						begin
							inc(foffs);
							push(#27+ltoa(NT_INT)+#27'('+pop+')')
						end;
					$23:
						begin
							inc(foffs);
							push(#27+ltoa(NT_SQRT)+#27'('+pop+')')
						end;
					$24:
						begin
							inc(foffs);
							push(#27+ltoa(NT_LOG10)+#27'('+pop+')')
						end;
					$25:
						begin
							inc(foffs);
							push(#27+ltoa(NT_LN)+#27'('+pop+')')
						end;
					$27:
						begin
							inc(foffs);
							push(#27+ltoa(NT_SIN)+#27'('+pop+')')
						end;
					$28:
						begin
							inc(foffs);
							push(#27+ltoa(NT_COS)+#27'('+pop+')')
						end;
					$29:
						begin
							inc(foffs);
							push(#27+ltoa(NT_TAN)+#27'('+pop+')')
						end;
					$2b:
						begin
							inc(foffs);
							push(#27+ltoa(NT_ARCTAN)+#27'('+pop+')')
						end;
					$2c:
						begin
							inc(foffs);
							push(#27+ltoa(NT_ARCSIN)+#27'('+pop+')')
						end;
					$2d:
						begin
							inc(foffs);
							push(#27+ltoa(NT_ARCCOS)+#27'('+pop+')')
						end;
					$2e:
						begin
							inc(foffs);
							push(#27+ltoa(NT_EXP)+#27'('+pop+')')
						end;
					$3b:
						begin
							inc(foffs);
							txt2:=pop;
							txt:=pop;
							push(#27+ltoa(NT_WENN)+#27'('+pop+ARGTRENNSEMIKOLON+txt+ARGTRENNSEMIKOLON+txt2+')')
						end;
					$3f:
						begin
							inc(foffs);
							push(#27+ltoa(NT_ROUND)+#27'('+pop+')')
						end;
					$50:
						begin
							txt:=#27+ltoa(NT_SUMME)+#27'('+pop;
							i:=buf^[foffs+1];
							if i<1 then fehler:=true;
							inc(foffs,2);
							while i>1 do
								begin
									txt:=txt+ARGTRENNSEMIKOLON+pop;
									dec(i)
								end;
							push(txt+')')
						end;
					$51:
						begin
							if buf^[foffs+1]=1 then
								begin
									inc(foffs,2);
									push(#27+ltoa(NT_MITTEL)+#27'('+pop+')')
								end
							else if buf^[foffs+1]=2 then
								begin
									inc(foffs,2);
									txt:=pop;
									push(#27+ltoa(NT_MITTEL)+#27'('+pop+':'+txt+')')
								end
							else
								fehler:=true
						end;
					$52:
						begin
							if buf^[foffs+1]<>1 then fehler:=true; { ... }
							inc(foffs,2);
							push(#27+ltoa(NT_ANZAHL2)+#27'('+pop+')')
						end;
					$57:
						begin
							if buf^[foffs+1]<>2 then fehler:=true; { ... }
							inc(foffs,2);
							txt:=pop;
							push(#27+ltoa(NT_VARIANZ)+#27'('+pop+':'+txt+')')
						end;
					else
						fehler:=true
					end
				end;
			getformula:='='+pop;
			if fehler then getformula:='='#27+ltoa(NT_FEHLER)+#27
		end;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		pg:=nil;
		buf:=GetMemBuffer(16384,4096,bufsize);
		new(stack,Init(100,50));
		if (buf=nil) or (stack=nil) then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_IMPORT_MEMORY1+CompressPath(fname,78)+MESSAGE_IMPORT_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		stack^.Sort:=false;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXIST1+CompressPath(fname,78)+MESSAGE_IMPORT_EXIST2,BUTTON_OK);
				goto _raus
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		if readrecord then goto _error;
		if (rec.opcode<>WK_BOF) or (rec.len<>2) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOTUS1+CompressPath(fname,78)+MESSAGE_IMPORT_LOTUS2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done);
				fclose(hdl);
				goto _raus
			end;
		w:=swap(PWord(buf)^);
		if (w<$0404) or (w>$0406) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_WKS1+CompressPath(fname,78)+MESSAGE_IMPORT_WKS2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done);
				fclose(hdl);
				goto _raus
			end;
		spos:=fseek(0,hdl,1);
		if spos<0 then
			begin
				res:=-1;
				goto _error
			end;
		rmax:=2;
		cmax:=2;
		sze:=0;
		stdcol:=atol(TexelApp.setupbuffer.stdcolwidth);
		if readrecord then goto _error;
		while rec.opcode<>WK_EOF do
			begin
				case rec.opcode of
				WK_FORMULA,
				WK_LABEL:
					inc(sze);
				WK_WINDOW1:
					stdcol:=getint(6);
				WK_WKS_PASSWORD:
					begin
						Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_WKPASS1+CompressPath(fname,78)+MESSAGE_IMPORT_WKPASS2,BUTTON_OK);
						if pg<>nil then dispose(pg,Done);
						fclose(hdl);
						goto _raus
					end;
				WK_SAVE_RANGE:
					if swap(PInteger(buf)^)=-1 then
						begin
							Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_WKEMPTY1+CompressPath(fname,78)+MESSAGE_IMPORT_WKEMPTY2,BUTTON_OK);
							if pg<>nil then dispose(pg,Done);
							fclose(hdl);
							goto _raus
						end
					else
						begin
							if swap(PWord(longint(buf)+4)^)>=cmax then cmax:=swap(PWord(longint(buf)+4)^)+1;
							if swap(PWord(longint(buf)+6)^)>=rmax then rmax:=swap(PWord(longint(buf)+6)^)+1
						end
				end;
				if readrecord then goto _error
			end;
		getmem(prow,rmax shl 1);
		getmem(pcol,cmax shl 1);
		getmem(pcolnames,cmax shl 2);
		dummy:=rmax*cmax*CELLSIZE;
		getmem(sheet,dummy);
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) then
			begin
				if prow<>nil then freemem(prow,rmax shl 1);
				if pcol<>nil then freemem(pcol,cmax shl 1);
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				if pg<>nil then dispose(pg,Done);
				TexelApp.ErrorWindowMemory(nil);
				fclose(hdl);
				goto _raus
			end;
		if pg<>nil then pg^.SetMax(rmax+sze);
		fillchar(pcolnames^,cmax shl 2,0);
		fillchar(sheet^,dummy,0);
		with TexelApp do
			begin
				vst_font(vdiHandle,GetStdFontIndex);
				{$IFDEF NVDI5}
				vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ELSE}
				if SpeedoActive then vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
				else
					vst_point(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ENDIF}
				if vqt_width(vdiHandle,ord('9'),ww,w,w)<>ord('9') then ww:=Attr.charWidth;
				SetSystemFont(vdiHandle,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
			end;
		sze:=Max(Min(round(longint(ww)*stdcol*longint(Application^.Attr.PixW)/10.0),65535),0);
		for q:=0 to cmax-1 do pcol^[q]:=sze;
		TexelApp.InitCells(sheet,rmax,cmax);
		if fseek(spos,hdl,0)<0 then
			begin
				res:=-1;
				goto _error
			end;
		sf:=TexelApp.GetStdFontIndex;
		sg:=TexelApp.GetStdFontSize;
		fp:=atol(TexelApp.setupbuffer.floatpoint);
		if readrecord then goto _error;
		while rec.opcode<>WK_EOF do
			begin
				case rec.opcode of
				WK_LABEL:
					begin
						if pg<>nil then pg^.Progress(1);
						ttxt:=StrPTrimF(StrPas(@buf^[5]));
						if length(ttxt)>1 then
							begin
								cell:=getcell(getint(3),getint(1));
								cell^.Typ:=CTYPE_TEXT;
								case ttxt[1] of
								'^':
									cell^.TxtVal.Align:=TA_CENTER;
								'"':
									cell^.TxtVal.Align:=TA_RIGHT;
								else
									cell^.TxtVal.Align:=TA_LEFT
								end;
								cell^.Data.Txt:=NewStr(TexelApp.dosmask(StrPRight(ttxt,length(ttxt)-1)));
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg
							end
					end;
				WK_INTEGER:
					begin
						cell:=getcell(getint(3),getint(1));
						new(cell^.Data.Konst);
						if cell^.Data.Konst<>nil then
							begin
								cell^.Typ:=CTYPE_CONST;
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg;
								cell^.TxtVal.Align:=TA_RIGHT;
								with cell^.Data.Konst^ do
									begin
										Value:=getint(5);
										Txt:=NewStr(ltoa(getint(5)));
										FPts:=0
									end
							end
					end;
				WK_NUMBER:
					begin
						cell:=getcell(getint(3),getint(1));
						new(cell^.Data.Konst);
						if cell^.Data.Konst<>nil then
							begin
								pb:=@ieee64;
								for w:=12 downto 5 do
									begin
										pb^:=buf^[w];
										inc(longint(pb))
									end;
								cell^.Typ:=CTYPE_CONST;
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg;
								cell^.TxtVal.Align:=TA_RIGHT;
								with cell^.Data.Konst^ do
									begin
										Value:=ieee64;
										Txt:=NewStr(ftoa(Value));
										FPts:=fp
									end
							end
					end;
				WK_FORMULA:
					begin
						if pg<>nil then pg^.Progress(1);
						rowoffs:=getint(3);
						coloffs:=getint(1);
						cell:=getcell(rowoffs,coloffs);
						pb:=@ieee64;
						for w:=12 downto 5 do
							begin
								pb^:=buf^[w];
								inc(longint(pb))
							end;
						ttxt:=TexelApp.EscText2Formula(getformula);
						if length(ttxt)>0 then
							begin
								new(cell^.Data.Formula);
								if cell^.Data.Formula<>nil then
									begin
										cell^.Typ:=CTYPE_FORMULA;
										cell^.TxtVal.Font:=sf;
										cell^.TxtVal.Size:=sg;
										cell^.TxtVal.Align:=TA_RIGHT;
										with cell^.Data.Formula^ do
											begin
												Value:=ieee64;
												FPts:=fp;
												Error:=FE_OK;
												VarDef:=NewStr(ttxt);
												Func:=nil
											end
									end
							end
					end;
				WK_COLUMN_WIDTH_1:
					begin
						colnr:=getint(0);
						if (colnr>=0) and (colnr<cmax) then
							pcol^[colnr]:=Max(Min(round(longint(ww)*longint(buf^[2])*longint(Application^.Attr.PixW)/10.0),65535),0)
					end;
				{ ... }
				end;
				if readrecord then goto _error
			end;
		_error:
		fclose(hdl);
		_errmsg:
		if res<0 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			new(PCalcWindow,InitImport(pg,rmax-1,cmax-1,fname,sheet,prow,pcol,pcolnames,false));
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		if stack<>nil then dispose(stack,Done);
		ArrowMouse
	end;


procedure TImport.LoadXLS(fname: string);
	label _raus,_errmsg,_error;

	const BIFF_BOF           =  $09;
	      BIFF_EOF           =  $0a;
	      BIFF2_DIMENSIONS   =  $00;
	      BIFF3_DIMENSIONS   = $200;
	      BIFF_DEFCOLWIDTH   =  $55;
	      BIFF_STANDARDWIDTH =  $99;
	      BIFF_COLWIDTH      =  $24;
	      BIFF_COLINFO       =  $7d;
	      BIFF2_DEFROWHEIGHT =  $25;
	      BIFF3_DEFROWHEIGHT = $225;
	      BIFF2_ROW          =  $08;
	      BIFF3_ROW          = $208;
	      BIFF_FILEPASS      =  $2f;
	      BIFF_FILESHARING   =  $5b;
	      BIFF_INTEGER       =  $02;
	      BIFF_RK            = $27e;
	      BIFF2_NUMBER       =  $03;
	      BIFF3_NUMBER       = $203;
	      BIFF2_LABEL        =  $04;
	      BIFF3_LABEL        = $204;
	      BIFF_1904          =  $22;
	      BIFF2_XF           =  $43;
	      BIFF3_XF           = $243;
	      BIFF4_XF           = $443;
	      BIFF_CODEPAGE      =  $42;
	      BIFF2_FORMULA      =  $06;
	      BIFF3_FORMULA      = $206;
	      BIFF4_FORMULA      = $406;
	      BIFF2_ARRAY        =  $21;
	      BIFF3_ARRAY        = $221;
	      BIFF2_BOOLERR      =  $05;
	      BIFF3_BOOLERR      = $205;
	      BIFF_HORPAGEBREAKS =  $1b;

	var buf,xfbuf : PByteArray;
	    bufsize,q,
	    dummy,sze,
	    rmax,cmax,
	    dcw,drh,
	    cdef,rdef,
	    anzxf,
	    xfcnt,
	    xfsize,
	    res,spos  : longint;
	    hdl,w,ww  : integer;
	    www,
	    von,bis,
	    tlast,
	    cpage,
	    typ,len   : word;
	    stdfpts,
	    xlsver    : byte;
	    sheet,cell: PCell;
	    prowflags,
	    pcolflags : PByteArray;
			prow,
			pcol      : PWordArray;
			pcolnames : PItemList;
			ppc       : PParameterCollection;
			ufrm      : PFormatCollection;
			stack     : PStringCollection;
	    parms     : TTexelParms;
	    tsbuf     : TSheetBuffer;
	    tdbuf     : TDialogBuffer;
	    tzwbuf    : TZielBuf;
	    diabuf    : TDiagrammBuf;
	    texbuf    : TExportBuf;
	    srtbuf    : TSortBuf;
	    infbuf    : TInfoBuf;
	    findbuf   : TFindBuf;
	    repbuf    : TReplaceBuf;
	    fillbuf   : TFillBuffer;
	    apwd      : TPassWord;
	    pg        : PProgressWindow;
	    pcom      : PCompoundFile;
	    biff2,
	    biff3,
	    biff4     : boolean;

	function bread(count: longint): boolean;

		begin
			{ pcom beachten !!! }
			bread:=(fread(hdl,count,buf)<>count)
		end;

	function GetLong(offs: longint): longint;

		begin
			GetLong:=(longint(PByte(longint(buf)+offs+3)^) shl 24)+(longint(PByte(longint(buf)+offs+2)^) shl 16)+(longint(PByte(longint(buf)+offs+1)^) shl 8)+longint(PByte(longint(buf)+offs)^)
		end;

	function GetWord(offs: longint): word;

		begin
			GetWord:=(PByte(longint(buf)+offs+1)^ shl 8)+PByte(longint(buf)+offs)^
		end;

	function GetByte(offs: longint): byte;

		begin
			GetByte:=PByte(longint(buf)+offs)^
		end;

	function ReadRecord: boolean;

		begin
			ReadRecord:=true;
			if bread(4) then exit;
			typ:=GetWord(0);
			len:=GetWord(2);
			if len>0 then
				if bread(len) then exit;
			ReadRecord:=false
		end;

	procedure GetCell(r,c: integer);

		begin
			cell:=PCell(longint(sheet)+(longint(r)*longint(cmax)+longint(c))*CELLSIZE)
		end;
	
	function GetFloat(offs: longint): double;
		var dbl: double;
	
		begin
			if GetWord(offs+6)=$ffff then
				begin
					case buf^[offs] of
					0,2:
						begin
							GetFloat:=0.0;
							exit
						end;
					1:
						begin
							if buf^[offs+2]<>0 then GetFloat:=1.0
							else
								GetFloat:=0.0;
							exit
						end
					end
				end;
			PWord(@dbl)^:=GetWord(offs+6);
			PWord(longint(@dbl)+2)^:=GetWord(offs+4);
			PWord(longint(@dbl)+4)^:=GetWord(offs+2);
			PWord(longint(@dbl)+6)^:=GetWord(offs);
			GetFloat:=dbl
		end;

	procedure CellText(r,c: word; t: string);

		begin
			if (r>=rmax) or (c>=cmax) or (length(t)=0) then exit;
			GetCell(r,c);
			cell^.Typ:=CTYPE_TEXT;
			if cpage=$8000 then cell^.Data.Txt:=NewStr(TexelApp.macmask(t))
			else
				cell^.Data.Txt:=NewStr(TexelApp.dosmask(t));
			with cell^.TxtVal do
				begin
					Font:=TexelApp.GetStdFontIndex;
					Size:=TexelApp.GetStdFontSize
				end
		end;

	procedure CellConst(r,c: word; num: real; fpts: byte);
		var pc: PConst;

		begin
			if (r>=rmax) or (c>=cmax) then exit;
			GetCell(r,c);
			new(pc);
			if pc<>nil then
				begin
					pc^.Value:=num;
					pc^.FPts:=fpts;
					pc^.Txt:=NewStr(TexelApp.Num2Txt(num,12,true,true));
					with cell^.TxtVal do
						begin
							Font:=TexelApp.GetStdFontIndex;
							Size:=TexelApp.GetStdFontSize;
							Align:=(Align and $f0) or TA_RIGHT
						end;
					cell^.Data.Konst:=pc;
					cell^.Typ:=CTYPE_CONST
				end
		end;

	procedure CellFormula(r,c: word; num: real; fpts: byte; esctxt: string);
		var pf: PFormula;

		begin
			esctxt:=TexelApp.EscText2Formula(esctxt);
			if (r>=rmax) or (c>=cmax) or (length(esctxt)=0) then exit;
			GetCell(r,c);
			new(pf);
			if pf<>nil then
				begin
					pf^.Value:=num;
					pf^.FPts:=fpts;
					pf^.Error:=FE_OK;
					pf^.VarDef:=NewStr(esctxt);
					pf^.Func:=nil;
					with cell^.TxtVal do
						begin
							Font:=TexelApp.GetStdFontIndex;
							Size:=TexelApp.GetStdFontSize;
							Align:=(Align and $f0) or TA_RIGHT
						end;
					cell^.Data.Formula:=pf;
					cell^.Typ:=CTYPE_FORMULA
				end
		end;

	function GetFormula(offs,lmax: longint): string;
		var fehler: boolean;
		    bend  : longint;
		    txt   : string;
		    i,anz : integer;

		function GetCellRef(rbits: word; cref: integer): string;
			var rref: integer;
			    refs: string[5];

			begin
				rref:=rbits and $3fff;
				rbits:=rbits and $c000;
				if cref<0 then refs:='?'
				else
					if cref<26 then refs:=chr(65+cref)
					else
						refs:=chr(64+(cref div 26))+chr(65+(cref mod 26));
				if not(bTst(rbits,$4000)) then refs:='$'+refs;
				if not(bTst(rbits,$8000)) then refs:=refs+'$';
				GetCellRef:=refs+ltoa(rref+1)
			end;

		procedure push(s: string);
		
			begin
				stack^.AtInsert(0,NewStr(s))
			end;
		
		function pop: string;
		
			begin
				if stack^.Count>0 then
					begin
						pop:=PString(stack^.At(0))^;
						stack^.AtFree(0)
					end
				else
					begin
						pop:='';
						fehler:=true
					end
			end;

		begin
			fehler:=false;
			stack^.FreeAll;
			bend:=offs+lmax;
			while (offs<bend) and not(fehler) do
				case buf^[offs] of
				$03:
					begin
						txt:=pop;
						push(pop+'+'+txt);
						inc(offs)
					end;
				$04:
					begin
						txt:=pop;
						push(pop+'-'+txt);
						inc(offs)
					end;
				$05:
					begin
						txt:=pop;
						push(pop+'*'+txt);
						inc(offs)
					end;
				$06:
					begin
						txt:=pop;
						push(pop+'/'+txt);
						inc(offs)
					end;
				$07:
					begin
						txt:=pop;
						push(pop+'^'+txt);
						inc(offs)
					end;
				$09:
					begin
						txt:=pop;
						push('('+pop+')<('+txt+')');
						inc(offs)
					end;
				$0a:
					begin
						txt:=pop;
						push('('+pop+')<=('+txt+')');
						inc(offs)
					end;
				$0b:
					begin
						txt:=pop;
						push('('+pop+')=('+txt+')');
						inc(offs)
					end;
				$0c:
					begin
						txt:=pop;
						push('('+pop+')>=('+txt+')');
						inc(offs)
					end;
				$0d:
					begin
						txt:=pop;
						push('('+pop+')>('+txt+')');
						inc(offs)
					end;
				$0e:
					begin
						txt:=pop;
						push('('+pop+')<>('+txt+')');
						inc(offs)
					end;
				$11:
					begin
						txt:=pop;
						push(pop+':'+txt);
						inc(offs)
					end;
				$12:
					begin
						push('+('+pop+')');
						inc(offs)
					end;
				$13:
					begin
						push('-('+pop+')');
						inc(offs)
					end;
				$14:
					begin
						push('('+pop+')%');
						inc(offs)
					end;
				$15:
					begin
						push('('+pop+')');
						inc(offs)
					end;
				$16:
					begin
						push('');
						inc(offs)
					end;
				$17:
					begin
						anz:=buf^[offs+1];
						txt[0]:=chr(anz);
						if anz>0 then
							for i:=1 to anz do txt[i]:=chr(buf^[offs+i+1]);
						push('"'+txt+'"');
						inc(offs,2+anz)
					end;
				$19:
					begin
						if buf^[offs+1]=$10 then push(#27+ltoa(NT_SUMME)+#27'('+pop+')')
						else
							if not(buf^[offs+1] in [$01,$02,$08]) then
								begin
{									writeln('spez: ',ltoh(buf^[offs+1],2),' ',ltoh(buf^[offs+2],2)); !!! }
									fehler:=true
								end;
						if biff2 then inc(offs,3)
						else
							begin
								if biff4 then
									if bTst(buf^[offs+1],$40) then inc(offs);
								inc(offs,4)
							end
					end;
				$1c:
					begin
						push(#27+ltoa(NT_FEHLER)+#27);
						inc(offs,2)
					end;
				$1d:
					begin
						if buf^[offs+1]<>0 then push(STRING_TRUE)
						else
							push(STRING_FALSE);
						inc(offs,2)
		 			end;
				$1e:
					begin
						push(ltoa(GetWord(offs+1)));
						inc(offs,3)
					end;
				$1f:
					begin
						push(ftoa(GetFloat(offs+1)));
						inc(offs,9)
					end;
				$24,
				$44:
					begin
						push(GetCellRef(GetWord(offs+1),buf^[offs+3]));
						inc(offs,4)
					end;
				$25,
				$2d:
					begin
						push(GetCellRef(GetWord(offs+1),buf^[offs+5])+':'+GetCellRef(GetWord(offs+3),buf^[offs+6]));
						inc(offs,7)
					end;
				$41:
					begin
						{ Formeln mit fester Anzahl Parameter }
						case buf^[offs+1] of
						$0f:
							push(#27+ltoa(NT_SIN)+#27'('+pop+')');
						$10:
							push(#27+ltoa(NT_COS)+#27'('+pop+')');
						$11:
							push(#27+ltoa(NT_TAN)+#27'('+pop+')');
						$12:
							push(#27+ltoa(NT_ARCTAN)+#27'('+pop+')');
						$13:
							push(#27+ltoa(NT_PI)+#27);
						$14:
							push(#27+ltoa(NT_SQRT)+#27'('+pop+')');
						$15:
							push(#27+ltoa(NT_EXP)+#27'('+pop+')');
						$16:
							push(#27+ltoa(NT_LN)+#27'('+pop+')');
						$17:
							push(#27+ltoa(NT_LOG10)+#27'('+pop+')');
						$18:
							push(#27+ltoa(NT_ABS)+#27'('+pop+')');
						$19:
							push(#27+ltoa(NT_INT)+#27'('+pop+')');
						$1a:
							push(#27+ltoa(NT_SGN)+#27'('+pop+')');
						$27:
							begin
								txt:=pop;
								push(#27+ltoa(NT_MOD)+#27'('+pop+ARGTRENNSEMIKOLON+txt+')')
							end;
						$b8:
							push(#27+ltoa(NT_FAK)+#27'('+pop+')');
						$3f:
							push(#27+ltoa(NT_RND)+#27);
						$61:
							begin
								txt:=pop;
								push(#27+ltoa(NT_ARCTAN2)+#27'('+pop+ARGTRENNSEMIKOLON+txt+')')
							end;
						$62:
							push(#27+ltoa(NT_ARCSIN)+#27'('+pop+')');
						$63:
							push(#27+ltoa(NT_ARCCOS)+#27'('+pop+')');
						$e5:
							push(#27+ltoa(NT_SINH)+#27'('+pop+')');
						$e6:
							push(#27+ltoa(NT_COSH)+#27'('+pop+')');
						$e7:
							push(#27+ltoa(NT_TANH)+#27'('+pop+')');
						$e8:
							push(#27+ltoa(NT_ARSINH)+#27'('+pop+')');
						$e9:
							push(#27+ltoa(NT_ARCOSH)+#27'('+pop+')');
						$ea:
							push(#27+ltoa(NT_ARTANH)+#27'('+pop+')');
						else
							begin
{								writeln('fest: ',ltoh(buf^[offs+1],2));  !!! }
								fehler:=true
							end
						end;
						inc(offs,2)
					end;
				$22,
				$42:
					begin
						{ Formeln mit variabler Anzahl Parameter }
						anz:=buf^[offs+1] and $7f;
						if anz<1 then fehler:=true
						else
							begin
								while anz>1 do
									begin
										txt:=pop;
										push(pop+ARGTRENNSEMIKOLON+txt);
										dec(anz)
									end;
								case (buf^[offs+2] and $7f) of
								$01:
									push(#27+ltoa(NT_WENN)+#27'('+pop+')');
								$04:
									push(#27+ltoa(NT_SUMME)+#27'('+pop+')');
								else
									begin
{										writeln('var.: ',ltoh(buf^[offs+1],2));  !!! }
										fehler:=true
									end
								end
							end;
						inc(offs,3)
					end;
				else
					begin
{						while (offs<bend) do
							begin
								write(ltoh(buf^[offs],2),' ');
								inc(offs)
							end;
						writeln; !!! }
						fehler:=true
					end
				end;
			GetFormula:='='+pop;
			if fehler then GetFormula:='='#27+ltoa(NT_FEHLER)+#27
		end;

	function Long2Real(l: longint): real;
		var nr: real;
		    xp: longint;

		begin
			xp:=(l shr 18) and $000007ff;
			if xp=$07ff then Long2Real:=0.0
			else
				begin
					if xp=0 then nr:=exp(-1022.0*ln(2.0))*(l and $0003ffff)/262144.0
					else
						nr:=exp((xp-1023)*ln(2.0))*(1.0+(l and $0003ffff)/262144.0);
					if bTst(l,$20000000) then Long2Real:=-nr
					else
						Long2Real:=nr
				end
		end;

	function ExcelColor(c,def: integer): integer;

		begin
			case c of
			8:
				ExcelColor:=Black;
			9:
				ExcelColor:=White;
			10:
				ExcelColor:=Red;
			11:
				ExcelColor:=Green;
			12:
				ExcelColor:=Blue;
			13:
				ExcelColor:=Yellow;
			14:
				ExcelColor:=Magenta;
			15:
				ExcelColor:=Cyan;
			16:
				ExcelColor:=LRed;
			17:
				ExcelColor:=LGreen;
			18:
				ExcelColor:=LBlue;
			19:
				ExcelColor:=LYellow;
			20:
				ExcelColor:=LMagenta;
			21:
				ExcelColor:=LCyan;
			22:
				ExcelColor:=LWhite;
			23:
				ExcelColor:=LBlack
			else
				ExcelColor:=def
			end
		end;

	procedure SetXF(xf: longint);
		var xfp: PByteArray;

		procedure GetXFP(xfn: longint; bit: word);
			var nxfn: longint;

			begin
				xfp:=PByteArray(longint(xfbuf)+xfn*xfsize);
				if not(bTst(xfp^[5],bit)) then
					begin
						nxfn:=((longint(xfp^[2]) shr 4) and $000f) or ((longint(xfp^[3]) shl 4) and $0ff0);
						if nxfn<$0fff then
							if xfn<>nxfn then
								if nxfn>=0 then GetXFP(nxfn,bit)
					end
			end;

		begin
{	TBorders = record
		case byte of
			0: (Left,
			    Top,
			    Right,
			    Bottom,
			    Hor,
			    Vert  : byte);
			1: (Val1: integer;
			    Val2: longint)
	end;
	TCell = record
		Data    : TCombiData;
		Flags,
		Typ,
		Color,
		Style,
		Interior,
		Resvd   : byte;
		Format  : integer;
		Border  : TBorders;
		TxtVal  : TTxtVal
	end;
	TTxtVal = record
		Font,
		Size,
		Rotat,
		Skew   : integer;
		Color,
		Effects,
		Align,
		Flags  : byte
	end; ... }
			if xlsver<>4 then exit; { ... }
			GetXFP(xf,128);
			if bTst(xfp^[2],1) then cell^.Flags:=cell^.Flags or CELL_PROTECTED;
			GetXFP(xf,16);
			with cell^.TxtVal do
				begin
					case (xfp^[4] and $30) of
					$00:
						Align:=Align or TA_OBEN;
					$20:
						Align:=Align or TA_UNTEN
					else
						Align:=Align or TA_MITTE
					end;
					case (xfp^[4] and $07) of
					2:
						Align:=Align or TA_CENTER;
					3:
						Align:=Align or TA_RIGHT
					else
						Align:=Align or TA_LEFT
					end
				end;
			GetXFP(xf,64);
			cell^.Color:=ExcelColor(((xfp^[6] shr 6) and $03) or ((xfp^[7] shl 2) and $1c),White);
			if cell^.Color=White then cell^.Color:=Black
			else
				cell^.Interior:=FIS_SOLID; { ... }
			GetXFP(xf,32);
			GetXFP(xf,8);
			GetXFP(xf,4);
			{ ... }
			with cell^.Border do
				begin
					{ ... }
				end;
		end;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		pg:=nil;
		xfbuf:=nil;
		pcom:=nil;
		buf:=GetMemBuffer(16384,4096,bufsize);
		new(stack,Init(100,50));
		if (buf=nil) or (stack=nil) then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_IMPORT_MEMORY1+CompressPath(fname,78)+MESSAGE_IMPORT_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		stack^.Sort:=false;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXIST1+CompressPath(fname,78)+MESSAGE_IMPORT_EXIST2,BUTTON_OK);
				goto _raus
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		if bread(8) then
			begin
				res:=-1;
				goto _error
			end;
		if (GetLong(0)=$e011cfd0) and (GetLong(4)=$e11ab1a1) then
			begin
				pcom:=nil; { !!! }
{				new(pcom,InitHandle(fname,hdl)); !!! }
				if pcom=nil then
					begin
						Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_OLE1+CompressPath(fname,78)+MESSAGE_IMPORT_OLE2,BUTTON_OK);
						fclose(hdl);
						goto _raus
					end;

				{ CompoundFile !!! }

				;res:=-1;goto _error { !!! }
			end;
		xlsver:=buf^[1];
		len:=GetWord(2);
		if (buf^[0]<>BIFF_BOF) or ((xlsver<>$00) and (xlsver<>$02) and (xlsver<>$04)) or (len<4) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXCEL1+CompressPath(fname,78)+MESSAGE_IMPORT_EXCEL2,BUTTON_OK);
				fclose(hdl);
				goto _raus
			end;
		biff2:=(xlsver=$00);
		biff3:=(xlsver=$02);
		biff4:=(xlsver=$04);
		if GetWord(6)<>$10 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_XLS1+CompressPath(fname,78)+MESSAGE_IMPORT_XLS2,BUTTON_OK);
				fclose(hdl);
				goto _raus
			end;
		if len>4 then
			if bread(len-4) then
				begin
					res:=-1;
					goto _error
				end;
		spos:=fseek(0,hdl,1);
		if xlsver=0 then xfsize:=5
		else
			xfsize:=12;
		rmax:=Max(2,atol(TexelApp.setupbuffer.stdrows));
		cmax:=Max(2,atol(TexelApp.setupbuffer.stdcolumns));
		cdef:=0;
		cpage:=0;
		dcw:=atol(TexelApp.setupbuffer.stdcolwidth)*longint(256);
		drh:=255;
		anzxf:=1;
		repeat
			if ReadRecord then
				begin
					res:=-1;
					goto _error
				end;
			case typ of
			BIFF_FILEPASS:
				begin
					Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_XLPASS1+CompressPath(fname,78)+MESSAGE_IMPORT_XLPASS2,BUTTON_OK);
					fclose(hdl);
					goto _raus
				end;
			BIFF_FILESHARING:
				{ ? ... };
			BIFF2_DIMENSIONS,BIFF3_DIMENSIONS:
				begin
					if GetWord(2)>=rmax then rmax:=GetWord(2)+1;
					if GetWord(6)>=cmax then cmax:=GetWord(6)+1
				end;
			BIFF_DEFCOLWIDTH:
				dcw:=longint(GetWord(0))*longint(256);
			BIFF_STANDARDWIDTH:
				dcw:=GetWord(0);
			BIFF2_DEFROWHEIGHT:
				drh:=GetWord(0) and $7fff;
			BIFF3_DEFROWHEIGHT:
				drh:=GetWord(2) and $7fff;
			BIFF2_ROW,BIFF3_ROW:
				if GetWord(4)>=cdef then cdef:=GetWord(4)+1;
			BIFF_1904:
				if GetWord(0)=1 then
					if Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_XLDATE1+CompressPath(fname,78)+MESSAGE_IMPORT_XLDATE2,BUTTON_OKCANCEL)=2 then
						begin
							fclose(hdl);
							goto _raus
						end;
			BIFF2_XF,BIFF3_XF,BIFF4_XF:
				inc(anzxf);
			BIFF_CODEPAGE:
				cpage:=GetWord(0);
			{ ... }
			end
		until typ=BIFF_EOF;
		if pg<>nil then
			begin
				pg^.SetMax(rmax+((rmax shr 2) shl 1));
				pg^.Progress(rmax shr 2)
			end;
		res:=fseek(spos,hdl,0);
		if res<0 then goto _error;
		ScanConst(TexelApp.DataPath,ppc);
		new(ufrm,Init(50,25));
		if ufrm<>nil then ufrm^.Sort:=false;
		if cdef>1 then cmax:=Max(cdef,atol(TexelApp.setupbuffer.stdcolumns));
		getmem(prow,rmax shl 1);
		getmem(pcol,cmax shl 1);
		getmem(pcolnames,cmax shl 2);
		getmem(prowflags,rmax);
		getmem(pcolflags,cmax);
		dummy:=rmax*cmax*CELLSIZE;
		q:=anzxf*xfsize;
		getmem(sheet,dummy);
		getmem(xfbuf,q);
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) or (xfbuf=nil) or (prowflags=nil) or (pcolflags=nil) then
			begin
				if prow<>nil then freemem(prow,rmax shl 1);
				if pcol<>nil then freemem(pcol,cmax shl 1);
				if prowflags<>nil then freemem(prowflags,rmax);
				if pcolflags<>nil then freemem(pcolflags,cmax);
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				TexelApp.ErrorWindowMemory(nil);
				fclose(hdl);
				goto _raus
			end;
		fillchar(xfbuf^,q,0);
		fillchar(pcolnames^,cmax shl 2,0);
		fillchar(pcolflags^,cmax,0);
		fillchar(prowflags^,rmax,0);
		fillchar(sheet^,dummy,0);
		with TexelApp do
			begin
				vst_font(vdiHandle,GetStdFontIndex);
				{$IFDEF NVDI5}
				vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ELSE}
				if SpeedoActive then vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
				else
					vst_point(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ENDIF}
				if vqt_width(vdiHandle,ord('9'),ww,w,w)<>ord('9') then ww:=Attr.charWidth;
				rdef:=longint(Attr.boxHeight)*longint(Application^.Attr.PixH);
				SetSystemFont(vdiHandle,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
			end;
		sze:=round(drh*rdef/2550.0);
		for q:=0 to rmax-1 do prow^[q]:=sze;
		sze:=Max(Min(round(longint(ww)*dcw*longint(Application^.Attr.PixW)/2560.0),65535),0);
		for q:=0 to cmax-1 do pcol^[q]:=sze;
		TexelApp.InitCells(sheet,rmax,cmax);
		with parms do
			begin
				Rows:=rmax-1;
				Columns:=cmax-1;
				ScrlXPos:=0;
				ScrlYPos:=0;
				CurrSize:=SysInfo.Desktop
			end;
		TexelApp.InitSheetStructs(parms,tsbuf,tdbuf,tzwbuf,diabuf,texbuf,srtbuf,infbuf,findbuf,repbuf,fillbuf);
		tsbuf.exceldate:=bf_Checked;
		stdfpts:=atol(TexelApp.setupbuffer.floatpoint);
		tlast:=0;
		xfcnt:=0;
		repeat
			if ReadRecord then
				begin
					res:=-1;
					goto _error
				end;
			case typ of
			BIFF_COLWIDTH:
				begin
					von:=GetByte(0);
					www:=GetWord(2);
					if von<cmax then
						if not(bTst(www,32768)) then
							begin
								bis:=GetByte(1);
								if bis>=cmax then bis:=cmax-1;
								sze:=Max(Min(round(longint(ww)*longint(www)*longint(Application^.Attr.PixW)/2560.0),65535),0);
								for q:=von to bis do pcol^[q]:=sze
							end
				end;
			BIFF_COLINFO:
				begin
					von:=GetWord(0);
					www:=GetWord(4);
					if von<cmax then
						if not(bTst(www,32768)) then
							begin
								bis:=GetWord(2);
								if bis>=cmax then bis:=cmax-1;
								sze:=Max(Min(round(longint(ww)*longint(www)*longint(Application^.Attr.PixW)/2560.0),65535),0);
								for q:=von to bis do pcol^[q]:=sze
							end
				end;
			BIFF2_ROW,BIFF3_ROW:
				begin
					von:=GetWord(6);
					bis:=GetWord(0);
					if bis<rmax then
						if not(bTst(von,32768)) then prow^[bis]:=round(longint(von)*rdef/2550.0)
				end;
			BIFF_INTEGER:
				CellConst(GetWord(0),GetWord(2),GetWord(7),0);
			BIFF2_NUMBER:
				CellConst(GetWord(0),GetWord(2),GetFloat(7),stdfpts);
			BIFF3_NUMBER:
				begin
					CellConst(GetWord(0),GetWord(2),GetFloat(6),stdfpts);
					SetXF(GetWord(4))
				end;
			BIFF_RK:
				begin
					q:=GetLong(6);
					case (q and $00000003) of
					0:
						CellConst(GetWord(0),GetWord(2),Long2Real((q shr 2) and $3fffffff),stdfpts);
					1:
						CellConst(GetWord(0),GetWord(2),Long2Real((q shr 2) and $3fffffff)/100.0,stdfpts);
					2:
						CellConst(GetWord(0),GetWord(2),(q shr 2) and $3fffffff,0);
					3:
						CellConst(GetWord(0),GetWord(2),((q shr 2) and $3fffffff)/100.0,0);
					end;
					SetXF(GetWord(4))
				end;
			BIFF2_FORMULA:
				CellFormula(GetWord(0),GetWord(2),GetFloat(7),stdfpts,GetFormula(17,buf^[16]));
			BIFF3_FORMULA,
			BIFF4_FORMULA:
				begin
					CellFormula(GetWord(0),GetWord(2),GetFloat(6),stdfpts,GetFormula(18,GetWord(16)));
					SetXF(GetWord(4))
				end;
			BIFF2_ARRAY:
{				writeln('BIFF2 Array')  !!! };
			BIFF3_ARRAY:
{				writeln('BIFF3 Array')  !!! };
			BIFF2_LABEL:
				CellText(GetWord(0),GetWord(2),StrLPas(@buf^[8],GetByte(7)));
			BIFF3_LABEL:
				begin
					CellText(GetWord(0),GetWord(2),StrLPas(@buf^[8],GetWord(6)));
					SetXF(GetWord(4))
				end;
			BIFF2_XF:
				begin
					system.move(buf^[0],xfbuf^[xfcnt],5);
					inc(xfcnt,5)
				end;
			BIFF3_XF,BIFF4_XF:
				begin
					system.move(buf^[0],xfbuf^[xfcnt],12);
					inc(xfcnt,12)
				end;
			BIFF2_BOOLERR:
				CellFormula(GetWord(0),GetWord(2),0.0,stdfpts,'='#27+ltoa(NT_FEHLER)+#27);
			BIFF3_BOOLERR:
				begin
					CellFormula(GetWord(0),GetWord(2),0.0,stdfpts,'='#27+ltoa(NT_FEHLER)+#27);
					SetXF(GetWord(4))
				end;
			BIFF_HORPAGEBREAKS:
				begin
					bis:=GetWord(0) shl 1;
					q:=2;
					while q<=bis do
						begin
							von:=GetWord(q);
							if von<rmax then prowflags^[von]:=prowflags^[von] or CRF_UMBRUCH;
							inc(q,2)
						end
				end;
			{ ... }
			end;
			tlast:=typ
		until typ=BIFF_EOF;
		_error:
		fclose(hdl);
		_errmsg:
		if res<0 then Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK)
		else
			begin
				if pg<>nil then pg^.Progress(rmax shr 2);
				if fname=StrPUpper(fname) then fname:=GetPath(fname)+GetFilename(fname,false)+'.'+StrPUpper(TEXELEXTENSION)
				else
					fname:=GetPath(fname)+GetFilename(fname,false)+'.'+TEXELEXTENSION;
				with apwd do
					begin
						Flag:=0;
						Code:=0;
						Mask:=0
					end;
				new(PCalcWindow,InitFile(fname,pg,parms,tdbuf,tsbuf,findbuf,repbuf,fillbuf,tzwbuf,
				                         texbuf,srtbuf,infbuf,diabuf,sheet,prow,pcol,pcolnames,ppc,
				                         ufrm,nil,apwd,nil,pcolflags,prowflags,nil,-1,false,true));
				pg:=nil
			end;
		_raus:
		if pg<>nil then dispose(pg,Done);
		if pcom<>nil then dispose(pcom,Done);
		if buf<>nil then freemem(buf,bufsize);
		if xfbuf<>nil then freemem(xfbuf,anzxf*xfsize);
		if stack<>nil then dispose(stack,Done);
		ArrowMouse
	end;


procedure TImport.LoadLDW(fname: string);
	label _raus,_error,_errmsg;

	var ttxt,otxt : string;
	    sze,
	    lstr,anzr,
	    q,dc,dr,
	    rmax,cmax,
	    bufsize,
	    res,dummy : longint;
	    sf,sg,ww,
	    hdl,e,w   : integer;
	    buf       : PByteArray;
	    sheet,cell: PCell;
			prow,
			pcol      : PWordArray;
			pcolnames : PItemList;
			number    : TNumber;
			isldp     : boolean;
			fp        : byte;
			pg        : PProgressWindow;

	procedure ttxt2rc(indx: string; var r,c: longint);
		var q: integer;

		begin
			r:=0;
			c:=0;
			StrPTrim(indx);
			if length(indx)<2 then exit;
			q:=1;
			while (indx[q] in ['A'..'Z']) and (q<=length(indx)) do inc(q);
			if (q<2) or (q>3) then exit;
			if q=2 then c:=ord(indx[1])-64
			else
				c:=ord(indx[1])*26+ord(indx[2])-1728;
			r:=atol(StrPRight(indx,length(indx)+1-q));
			if Between(r,1,16384) then isldp:=true
			else
				begin
					c:=0;
					r:=0
				end
		end;

	procedure insertcell;
		var formorconst: boolean;
		    dfrm       : integer;
	
		function klammeraffeweg(s: string): string;
			var i: integer;
		
			begin
				i:=pos('@',s);
				while i>0 do
					begin
						s:=StrPLeft(s,i-1)+StrPRight(s,length(s)-i);
						i:=pos('@',s)
					end;
				i:=pos('..',s);
				while i>0 do
					begin
						s:=StrPLeft(s,i-1)+':'+StrPRight(s,length(s)-i-1);
						i:=pos('..',s)
					end;
				i:=pos(',',s);
				while i>0 do
					begin
						s:=StrPLeft(s,i-1)+';'+StrPRight(s,length(s)-i);
						i:=pos(',',s)
					end;
				klammeraffeweg:=s
			end;

		procedure insertformula(cutl: integer);

			begin
				new(cell^.Data.Formula);
				if cell^.Data.Formula<>nil then
					begin
						cell^.Typ:=CTYPE_FORMULA;
						with cell^.Data.Formula^ do
							begin
								Value:=0.0;
								FPts:=fp;
								Error:=FE_OK;
								VarDef:=NewStr('='+klammeraffeweg(StrPRight(ttxt,length(ttxt)-cutl)));
								Func:=nil;
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg;
								cell^.TxtVal.Align:=TA_RIGHT
							end
					end
			end;

		begin
			StrPTrim(ttxt);
			if length(ttxt)=0 then exit;
			w:=pos(':',ttxt);
			if w>0 then
				begin
					formorconst:=false;
					ttxt2rc(StrPLeft(ttxt,w-1),dr,dc);
					if dr<>lstr then
						begin
							lstr:=dr;
							if pg<>nil then pg^.Progress(1)
						end;
					cell:=PCell(longint(sheet)+((dr-1)*cmax+dc-1)*CELLSIZE);
					ttxt:=StrPTrimF(StrPRight(ttxt,length(ttxt)-w));
					if StrPLeft(ttxt,1)='(' then
						begin
							formorconst:=true;
							e:=pos(')',ttxt);
							{ Format... }
							ttxt:=StrPTrimF(StrPRight(ttxt,length(ttxt)-e))
						end;
					if StrPLeft(ttxt,1)='{' then
						begin
							e:=pos('}',ttxt);
							if e=3 then
								if ttxt[2]='F' then cell^.TxtVal.Effects:=cell^.TxtVal.Effects or TF_THICKENED;
							{ Attribute... }
							ttxt:=StrPTrimF(StrPRight(ttxt,length(ttxt)-e))
						end;
					if StrPLeft(ttxt,1)='[' then
						begin
							e:=pos(']',ttxt);
							if e>3 then
								if ttxt[2]='B' then
									pcol^[dc-1]:=Max(Min(round(longint(ww)*atol(StrPMid(ttxt,3,e-3))*longint(Application^.Attr.PixW)/10.0),65535),0);
							ttxt:=StrPTrimF(StrPRight(ttxt,length(ttxt)-e))
						end;
					if length(ttxt)>0 then
						case ttxt[1] of
						'''':
							begin
								if length(ttxt)>1 then
									begin
										cell^.Typ:=CTYPE_TEXT;
										cell^.Data.Txt:=NewStr(StrPRight(ttxt,length(ttxt)-1))
									end;
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg
							end;
						'"':
							begin
								if length(ttxt)>1 then
									begin
										cell^.Typ:=CTYPE_TEXT;
										cell^.Data.Txt:=NewStr(StrPRight(ttxt,length(ttxt)-1))
									end;
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg;
								cell^.TxtVal.Align:=TA_RIGHT
							end;
						'^':
							begin
								if length(ttxt)>1 then
									begin
										cell^.Typ:=CTYPE_TEXT;
										cell^.Data.Txt:=NewStr(StrPRight(ttxt,length(ttxt)-1))
									end;
								cell^.TxtVal.Font:=sf;
								cell^.TxtVal.Size:=sg;
								cell^.TxtVal.Align:=TA_CENTER
							end;
						'+','=','@':
							insertformula(1);
						else
							if TexelApp.IsNumber(ttxt,number,otxt,true) then
								begin
									new(cell^.Data.Konst);
									if cell^.Data.Konst<>nil then
										begin
											cell^.Typ:=CTYPE_CONST;
											cell^.TxtVal.Font:=sf;
											cell^.TxtVal.Size:=sg;
											cell^.TxtVal.Align:=TA_RIGHT;
											with cell^.Data.Konst^ do
												begin
													Txt:=NewStr(otxt);
													Value:=number;
													FPts:=fp
												end
										end
								end
							else
								if TexelApp.IsDate(ttxt,number,otxt,dfrm,TexelApp.setupbuffer.exceldate=bf_Checked) then
									begin
										new(cell^.Data.Konst);
										if cell^.Data.Konst<>nil then
											begin
												cell^.Typ:=CTYPE_CONST;
												cell^.Format:=dfrm;
												with cell^.Data.Konst^ do
													begin
														Txt:=NewStr(otxt);
														Value:=number;
														FPts:=fp
													end;
												cell^.TxtVal.Font:=sf;
												cell^.TxtVal.Size:=sg
											end
									end
								else
									if TexelApp.IsTime(ttxt,number,otxt,dfrm) then
										begin
											new(cell^.Data.Konst);
											if cell^.Data.Konst<>nil then
												begin
													cell^.Typ:=CTYPE_CONST;
													cell^.Format:=dfrm;
													with cell^.Data.Konst^ do
														begin
															Txt:=NewStr(otxt);
															Value:=number;
															FPts:=fp
														end;
													cell^.TxtVal.Font:=sf;
													cell^.TxtVal.Size:=sg
												end
										end
									else
										if formorconst then insertformula(0)
										else
											begin
												cell^.Typ:=CTYPE_TEXT;
												cell^.Data.Txt:=NewStr(ttxt);
												cell^.TxtVal.Font:=sf;
												cell^.TxtVal.Size:=sg
											end
						end
				end;
			ttxt:=''
		end;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		pg:=nil;
		buf:=GetMemBuffer(16384,128,bufsize);
		if buf=nil then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_IMPORT_MEMORY1+CompressPath(fname,78)+MESSAGE_IMPORT_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXIST1+CompressPath(fname,78)+MESSAGE_IMPORT_EXIST2,BUTTON_OK);
				goto _raus
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		cmax:=2;
		rmax:=2;
		ttxt:='';
		anzr:=0;
		lstr:=0;
		isldp:=false;
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for q:=0 to res-1 do
					begin
						if buf^[q]=CR then
							begin
								StrPTrim(ttxt);
								if length(ttxt)>0 then
									begin
										w:=pos(':',ttxt);
										if w>0 then
											begin
												ttxt2rc(StrPLeft(ttxt,w-1),dr,dc);
												if dc>cmax then cmax:=dc;
												if dr>rmax then rmax:=dr;
												if dr<>lstr then
													begin
														lstr:=dr;
														inc(anzr)
													end
											end;
										ttxt:=''
									end
							end
						else
							if buf^[q]>=32 then ttxt:=ttxt+chr(buf^[q])
					end
		until res<>bufsize;
		if res<0 then goto _error;
		StrPTrim(ttxt);
		if length(ttxt)>0 then
			begin
				w:=pos(':',ttxt);
				if w>0 then
					begin
						ttxt2rc(StrPLeft(ttxt,w-1),dr,dc);
						if dc>cmax then cmax:=dc;
						if dr>rmax then rmax:=dr
					end
			end;
		if not(isldp) then
			begin
				fclose(hdl);
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LDP1+CompressPath(fname,78)+MESSAGE_IMPORT_LDP2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done);
				goto _raus
			end;
		res:=fseek(0,hdl,0);
		if res<0 then goto _error;
		getmem(prow,rmax shl 1);
		getmem(pcol,cmax shl 1);
		getmem(pcolnames,cmax shl 2);
		dummy:=rmax*cmax*CELLSIZE;
		getmem(sheet,dummy);
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) then
			begin
				if prow<>nil then freemem(prow,rmax shl 1);
				if pcol<>nil then freemem(pcol,cmax shl 1);
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				if pg<>nil then dispose(pg,Done);
				TexelApp.ErrorWindowMemory(nil);
				fclose(hdl);
				goto _raus
			end;
		if pg<>nil then
			begin
				pg^.SetMax(rmax+(rmax shr 2)+anzr);
				pg^.Progress(rmax shr 2)
			end;
		fillchar(pcolnames^,cmax shl 2,0);
		fillchar(sheet^,dummy,0);
		with TexelApp do
			begin
				vst_font(vdiHandle,GetStdFontIndex);
				{$IFDEF NVDI5}
				vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ELSE}
				if SpeedoActive then vst_arbpt(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
				else
					vst_point(vdiHandle,GetStdFontSize,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight);
				{$ENDIF}
				if vqt_width(vdiHandle,ord('9'),ww,w,w)<>ord('9') then ww:=Attr.charWidth;
				SetSystemFont(vdiHandle,Attr.charWidth,Attr.charHeight,Attr.boxWidth,Attr.boxHeight)
			end;
		sze:=Max(Min(round(longint(ww)*atol(TexelApp.setupbuffer.stdcolwidth)*longint(Application^.Attr.PixW)/10.0),65535),0);
		for q:=0 to cmax-1 do pcol^[q]:=sze;
		TexelApp.InitCells(sheet,rmax,cmax);
		ttxt:='';
		sf:=TexelApp.GetStdFontIndex;
		sg:=TexelApp.GetStdFontSize;
		fp:=atol(TexelApp.setupbuffer.floatpoint);
		lstr:=0;
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for q:=0 to res-1 do
					begin
						if buf^[q]=CR then insertcell
						else
							if buf^[q]>=32 then ttxt:=ttxt+chr(buf^[q])
					end
		until res<>bufsize;
		if res>0 then insertcell;
		_error:
		fclose(hdl);
		_errmsg:
		if res<0 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			new(PCalcWindow,InitImport(pg,rmax-1,cmax-1,fname,sheet,prow,pcol,pcolnames,false));
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		ArrowMouse
	end;


procedure TImport.LoadCSV(fname: string);
	label _raus,_error,_errmsg;

	var res,q,w,dc,
	    dummy,dr,
	    bufsize,
	    anzkomma,
	    anzsemi,
	    dcs,csmax,
	    cmax,rmax : longint;
	    hdl,sf,sg : integer;
	    buf       : PByteArray;
	    ttxt,otxt : string;
	    number    : TNumber;
	    fp        : byte;
	    mscsv,
	    tflag     : boolean;
	    sheet,cell: PCell;
			prow,
			pcol      : PWordArray;
			pcolnames : PItemList;
			pg        : PProgressWindow;

	procedure insertcell;
		var i,dfrm: integer;

		begin
			StrPTrim(ttxt);
			if length(ttxt)>1 then
				begin
					if StrPLeft(ttxt,1)=#34 then
						if StrPRight(ttxt,1)=#34 then
							begin
								ttxt:=StrPMid(ttxt,2,length(ttxt)-2);
							end;
					i:=1;
					while i<length(ttxt) do
						begin
							if ttxt[i]=#34 then
								if ttxt[i+1]=#34 then
									ttxt:=StrPLeft(ttxt,i)+StrPRight(ttxt,length(ttxt)-i-1);
							inc(i)
						end
				end;
			if length(ttxt)=0 then exit;
			cell^.TxtVal.Font:=sf;
			cell^.TxtVal.Size:=sg;
			if ttxt[1]='=' then
				begin
					new(cell^.Data.Formula);
					if cell^.Data.Formula<>nil then
						begin
							cell^.Typ:=CTYPE_FORMULA;
							with cell^.Data.Formula^ do
								begin
									Value:=0.0;
									FPts:=fp;
									Error:=FE_OK;
									VarDef:=NewStr(ttxt);
									Func:=nil;
									cell^.TxtVal.Align:=TA_RIGHT
								end
						end
				end
			else
				if TexelApp.IsNumber(ttxt,number,otxt,mscsv) then
					begin
						new(cell^.Data.Konst);
						if cell^.Data.Konst<>nil then
							begin
								cell^.Typ:=CTYPE_CONST;
								with cell^.Data.Konst^ do
									begin
										Txt:=NewStr(otxt);
										Value:=number;
										FPts:=fp;
										cell^.TxtVal.Align:=TA_RIGHT
									end
							end
					end
				else
					if TexelApp.IsDate(ttxt,number,otxt,dfrm,TexelApp.setupbuffer.exceldate=bf_Checked) then
						begin
							new(cell^.Data.Konst);
							if cell^.Data.Konst<>nil then
								begin
									cell^.Typ:=CTYPE_CONST;
									cell^.Format:=dfrm;
									with cell^.Data.Konst^ do
										begin
											Txt:=NewStr(otxt);
											Value:=number;
											FPts:=fp
										end
								end
						end
					else
						if TexelApp.IsTime(ttxt,number,otxt,dfrm) then
							begin
								new(cell^.Data.Konst);
								if cell^.Data.Konst<>nil then
									begin
										cell^.Typ:=CTYPE_CONST;
										cell^.Format:=dfrm;
										with cell^.Data.Konst^ do
											begin
												Txt:=NewStr(otxt);
												Value:=number;
												FPts:=fp
											end
									end
							end
						else
							begin
								cell^.Typ:=CTYPE_TEXT;
								cell^.Data.Txt:=NewStr(ttxt)
							end;
			ttxt:=''
		end;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		pg:=nil;
		buf:=GetMemBuffer(16384,128,bufsize);
		if buf=nil then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_IMPORT_MEMORY1+CompressPath(fname,78)+MESSAGE_IMPORT_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXIST1+CompressPath(fname,78)+MESSAGE_IMPORT_EXIST2,BUTTON_OK);
				goto _raus
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		dc:=1;
		dcs:=1;
		dr:=1;
		cmax:=2;
		csmax:=2;
		rmax:=2;
		tflag:=false;
		anzkomma:=0;
		anzsemi:=0;
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for q:=0 to res-1 do
					begin
						if buf^[q]=CR then
							begin
								if dc>cmax then cmax:=dc;
								if dcs>csmax then csmax:=dcs;
								inc(dr);
								dc:=1;
								dcs:=1;
								tflag:=false
							end
						else
							if buf^[q]=34 then tflag:=not(tflag)
							else
								if buf^[q]=59 then
									begin
										if not(tflag) then
											begin
												inc(dcs);
												inc(anzsemi)
											end
									end
								else
									if buf^[q]=44 then
										if not(tflag) then 
											begin
												inc(dc);
												inc(anzkomma)
											end
					end
		until res<>bufsize;
		if res<0 then goto _error;
		mscsv:=(anzsemi>anzkomma);
		if dc>cmax then cmax:=dc;
		if dcs>csmax then csmax:=dcs;
		if dr>rmax then rmax:=dr;
		if mscsv then cmax:=csmax;		
		res:=fseek(0,hdl,0);
		if res<0 then goto _error;
		getmem(prow,rmax shl 1);
		getmem(pcol,cmax shl 1);
		getmem(pcolnames,cmax shl 2);
		dummy:=rmax*cmax*CELLSIZE;
		getmem(sheet,dummy);
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) then
			begin
				if prow<>nil then freemem(prow,rmax shl 1);
				if pcol<>nil then freemem(pcol,cmax shl 1);
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				if pg<>nil then dispose(pg,Done);
				TexelApp.ErrorWindowMemory(nil);
				fclose(hdl);
				goto _raus
			end;
		if pg<>nil then
			begin
				pg^.SetMax((rmax shl 1)+(rmax shr 2));
				pg^.Progress(rmax shr 2)
			end;
		fillchar(pcolnames^,cmax shl 2,0);
		fillchar(sheet^,dummy,0);
		TexelApp.InitCells(sheet,rmax,cmax);
		tflag:=false;
		sf:=TexelApp.GetStdFontIndex;
		sg:=TexelApp.GetStdFontSize;
		fp:=atol(TexelApp.setupbuffer.floatpoint);
		dr:=0;
		ttxt:='';
		cell:=sheet;
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for q:=0 to res-1 do
					begin
						if buf^[q]=CR then
							begin
								insertcell;
								inc(dr);
								cell:=PCell(longint(sheet)+dr*cmax*CELLSIZE);
								tflag:=false;
								if pg<>nil then pg^.Progress(1)
							end
						else
							if buf^[q]=34 then
								begin
									tflag:=not(tflag);
									ttxt:=ttxt+#34
								end
							else
								if buf^[q]=44 then
									begin
										if not(tflag) and not(mscsv) then
											begin
												insertcell;
												inc(longint(cell),CELLSIZE)
											end
										else
											ttxt:=ttxt+#44
									end
								else
									if buf^[q]=59 then
										begin
											if not(tflag) and mscsv then
												begin
													insertcell;
													inc(longint(cell),CELLSIZE)
												end
											else
												ttxt:=ttxt+#59
										end
									else
										if buf^[q]>=32 then ttxt:=ttxt+chr(buf^[q])
					end
		until res<>bufsize;
		if res>0 then insertcell;
		_error:
		fclose(hdl);
		_errmsg:
		if res<0 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			new(PCalcWindow,InitImport(pg,rmax-1,cmax-1,fname,sheet,prow,pcol,pcolnames,true));
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		ArrowMouse
	end;


procedure TImport.ImportASCII(fname,rctrenn,celltrenn,tquote: string; komma2punkt,hor,quote: boolean; flt: integer);
	label _raus,_error,_errmsg;

	var res,q,w,dc,
	    dummy,dr,
	    bufsize,
	    loffs,
	    cmax,rmax : longint;
	    rowcolcnt,
	    cellcnt,
	    textcnt,lq,
	    hdl,sf,sg : integer;
	    buf       : PByteArray;
	    ttxt,otxt : string;
	    number    : TNumber;
	    fp        : byte;
	    textvalid,
	    spacevalid,
	    space,
	    usepkt,
	    tflag     : boolean;
	    sheet,cell: PCell;
			prow,
			pcol      : PWordArray;
			pcolnames : PItemList;
			pg        : PProgressWindow;

	procedure insertcell;
		label _txt;

		var i,dfrm: integer;

		begin
			StrPTrim(ttxt);
			if textvalid then
				if length(ttxt)>lq then
					begin
						if StrPLeft(ttxt,lq)=tquote then
							if StrPRight(ttxt,lq)=tquote then
								ttxt:=StrPMid(ttxt,lq+1,length(ttxt)-(lq shl 1));
						if quote then
							begin
								i:=1;
								while i<=(length(ttxt)+1-(lq shl 1)) do
									begin
										if StrPMid(ttxt,i,lq)=tquote then
											if StrPMid(ttxt,i+lq,lq)=tquote then
												begin
													ttxt:=StrPLeft(ttxt,i-1)+StrPRight(ttxt,length(ttxt)+1-i-lq);
													inc(i,lq);
													continue
												end;
										inc(i)
									end
							end
					end;
			i:=1;
			while i<=length(ttxt) do
				begin
					if ord(ttxt[i])<32 then ttxt:=StrPLeft(ttxt,i-1)+StrPRight(ttxt,length(ttxt)-i)
					else
						inc(i)
				end;
			if length(ttxt)=0 then goto _txt;
			cell^.TxtVal.Font:=sf;
			cell^.TxtVal.Size:=sg;
			if ttxt[1]='=' then
				begin
					new(cell^.Data.Formula);
					if cell^.Data.Formula<>nil then
						begin
							cell^.Typ:=CTYPE_FORMULA;
							with cell^.Data.Formula^ do
								begin
									Value:=0.0;
									FPts:=fp;
									Error:=FE_OK;
									VarDef:=NewStr(ttxt);
									Func:=nil;
									cell^.TxtVal.Align:=TA_RIGHT
								end
						end
				end
			else
				if TexelApp.IsNumber(ttxt,number,otxt,komma2punkt) then
					begin
						new(cell^.Data.Konst);
						if cell^.Data.Konst<>nil then
							begin
								cell^.Typ:=CTYPE_CONST;
								with cell^.Data.Konst^ do
									begin
										Txt:=NewStr(otxt);
										Value:=number;
										FPts:=fp;
										cell^.TxtVal.Align:=TA_RIGHT
									end
							end
					end
				else
					if TexelApp.IsDate(ttxt,number,otxt,dfrm,TexelApp.setupbuffer.exceldate=bf_Checked) then
						begin
							new(cell^.Data.Konst);
							if cell^.Data.Konst<>nil then
								begin
									cell^.Typ:=CTYPE_CONST;
									cell^.Format:=dfrm;
									with cell^.Data.Konst^ do
										begin
											Txt:=NewStr(otxt);
											Value:=number;
											FPts:=fp
										end
								end
						end
					else
						if TexelApp.IsTime(ttxt,number,otxt,dfrm) then
							begin
								new(cell^.Data.Konst);
								if cell^.Data.Konst<>nil then
									begin
										cell^.Typ:=CTYPE_CONST;
										cell^.Format:=dfrm;
										with cell^.Data.Konst^ do
											begin
												Txt:=NewStr(otxt);
												Value:=number;
												FPts:=fp
											end
									end
							end
						else
							begin
								cell^.Typ:=CTYPE_TEXT;
								cell^.Data.Txt:=NewStr(ttxt)
							end;
			_txt:
			ttxt:=''
		end;

	begin
		if (length(fname)=0) or (length(rctrenn)=0) or (length(celltrenn)=0) then exit;
		BusyMouse;
		pg:=nil;
		buf:=GetMemBuffer(16384,128,bufsize);
		if buf=nil then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_IMPORT_MEMORY1+CompressPath(fname,78)+MESSAGE_IMPORT_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXIST1+CompressPath(fname,78)+MESSAGE_IMPORT_EXIST2,BUTTON_OK);
				goto _raus
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		dc:=1;
		dr:=1;
		cmax:=2;
		rmax:=2;
		tflag:=false;
		rowcolcnt:=1;
		cellcnt:=1;
		textcnt:=1;
		lq:=length(tquote);
		textvalid:=(lq>0);
		spacevalid:=(celltrenn=' ');
		space:=false;
		usepkt:=InitKeyTab and (flt>=0);
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for q:=0 to res-1 do
					begin
						if usepkt then buf^[q]:=ord(pkt^.ImportChar(nil,nil,0,0,0,flt,chr(buf^[q])));
						if space then
							begin
								if buf^[q]=32 then continue
								else
									space:=false
							end;
						if rctrenn[rowcolcnt]=chr(buf^[q]) then
							begin
								inc(rowcolcnt);
								if rowcolcnt>length(rctrenn) then
									begin
										if hor then
											begin
												if dc>cmax then cmax:=dc;
												inc(dr);
												dc:=1
											end
										else
											begin
												if dr>rmax then rmax:=dr;
												inc(dc);
												dr:=1
											end;
										tflag:=false;
										rowcolcnt:=1;
										cellcnt:=1;
										textcnt:=1
									end
							end
						else
							rowcolcnt:=1;
						if textvalid then
							begin
								if tquote[textcnt]=chr(buf^[q]) then
									begin
										inc(textcnt);
										if textcnt>length(tquote) then
											begin
												tflag:=not(tflag);
												textcnt:=1;
												cellcnt:=1;
												rowcolcnt:=1
											end
									end
								else
									textcnt:=1
							end;
						if celltrenn[cellcnt]=chr(buf^[q]) then
							begin
								inc(cellcnt);
								if cellcnt>length(celltrenn) then
									begin
										if not(tflag) then
											begin
												if hor then inc(dc)
												else
													inc(dr);
												if spacevalid then space:=true;
												rowcolcnt:=1;
												textcnt:=1
											end;
										cellcnt:=1
									end
							end
						else
							cellcnt:=1
					end
		until res<>bufsize;
		if res<0 then goto _error;
		if dr>rmax then rmax:=dr;
		if dc>cmax then cmax:=dc;
		res:=fseek(0,hdl,0);
		if res<0 then goto _error;
		getmem(prow,rmax shl 1);
		getmem(pcol,cmax shl 1);
		getmem(pcolnames,cmax shl 2);
		dummy:=rmax*cmax*CELLSIZE;
		getmem(sheet,dummy);
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) then
			begin
				if prow<>nil then freemem(prow,rmax shl 1);
				if pcol<>nil then freemem(pcol,cmax shl 1);
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				if pg<>nil then dispose(pg,Done);
				TexelApp.ErrorWindowMemory(nil);
				fclose(hdl);
				goto _raus
			end;
		if pg<>nil then
			begin
				if hor then pg^.SetMax((rmax shl 1)+(rmax shr 2))
				else
					pg^.SetMax(rmax+cmax+(rmax shr 2));
				pg^.Progress(rmax shr 2)
			end;
		fillchar(pcolnames^,cmax shl 2,0);
		fillchar(sheet^,dummy,0);
		TexelApp.InitCells(sheet,rmax,cmax);
		tflag:=false;
		sf:=TexelApp.GetStdFontIndex;
		sg:=TexelApp.GetStdFontSize;
		fp:=atol(TexelApp.setupbuffer.floatpoint);
		if hor then
			begin
				dc:=1;
				dr:=0
			end
		else
			begin
				dc:=0;
				dr:=1
			end;
		ttxt:='';
		rowcolcnt:=1;
		cellcnt:=1;
		textcnt:=1;
		space:=false;
		loffs:=cmax*CELLSIZE;
		cell:=sheet;
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for q:=0 to res-1 do
					begin
						if usepkt then buf^[q]:=ord(pkt^.ImportChar(nil,nil,0,0,0,flt,chr(buf^[q])));
						if space then
							begin
								if buf^[q]=32 then continue
								else
									space:=false
							end;
						ttxt:=ttxt+chr(buf^[q]);
						if rctrenn[rowcolcnt]=chr(buf^[q]) then
							begin
								inc(rowcolcnt);
								if rowcolcnt>length(rctrenn) then
									begin
										ttxt:=StrPLeft(ttxt,length(ttxt)-length(rctrenn));
										insertcell;
										if hor then
											begin
												inc(dr);
												dc:=1;
												cell:=PCell(longint(sheet)+dr*loffs)
											end
										else
											begin
												inc(dc);
												dr:=1;
												cell:=PCell(longint(sheet)+dc*CELLSIZE)
											end;
										tflag:=false;
										rowcolcnt:=1;
										cellcnt:=1;
										textcnt:=1;
										if pg<>nil then pg^.Progress(1)
									end
							end
						else
							rowcolcnt:=1;
						if textvalid then
							begin
								if tquote[textcnt]=chr(buf^[q]) then
									begin
										inc(textcnt);
										if textcnt>length(tquote) then
											begin
												tflag:=not(tflag);
												ttxt:=StrPLeft(ttxt,length(ttxt)-length(tquote));
												textcnt:=1;
												cellcnt:=1;
												rowcolcnt:=1
											end
									end
								else
									textcnt:=1
							end;
						if celltrenn[cellcnt]=chr(buf^[q]) then
							begin
								inc(cellcnt);
								if cellcnt>length(celltrenn) then
									begin
										if not(tflag) then
											begin
												ttxt:=StrPLeft(ttxt,length(ttxt)-length(celltrenn));
												insertcell;
												if hor then
													begin
														inc(dc);
														inc(longint(cell),CELLSIZE)
													end
												else
													begin
														inc(dr);
														inc(longint(cell),loffs)
													end;
												if spacevalid then space:=true;
												textcnt:=1;
												rowcolcnt:=1
											end;
										cellcnt:=1
									end
							end
						else
							cellcnt:=1
					end
		until res<>bufsize;
		if res>0 then insertcell;
		_error:
		fclose(hdl);
		_errmsg:
		if res<0 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			new(PCalcWindow,InitImport(pg,rmax-1,cmax-1,fname,sheet,prow,pcol,pcolnames,true));
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		ArrowMouse
	end;


procedure TImport.LoadDIF(fname: string);
	label _errmsg,_raus,_weiter;

	var res,q,w,dc,
	    dummy,dr,e,
	    bufsize,
	    cmax,rmax : longint;
	    hdl,dfrm,
	    si1,si2,
	    sf,sg     : integer;
	    sf2,number: TNumber;
	    buf       : PByteArray;
	    table,
	    ttxt,
	    otxt,
	    s1,s2     : string;
	    fp        : byte;
	    header    : boolean;
	    sheet,cell: PCell;
			prow,
			pcol      : PWordArray;
			pcolnames : PItemList;
			pg        : PProgressWindow;

	procedure split_s1;
		var p: integer;

		begin
			p:=pos(',',s1);
			if p=0 then
				begin
					si1:=0;
					sf2:=0.0
				end
			else
				begin
					si1:=atol(StrPLeft(s1,p-1));
					s2:=StrPRight(s1,length(s1)-p);
					sf2:=atof(s2)
				end
		end;

	procedure split_s2;
		var p: integer;

		begin
			p:=pos(',',s2);
			if p=0 then
				begin
					si1:=0;
					si2:=0
				end
			else
				begin
					si1:=atol(StrPLeft(s2,p-1));
					si2:=atol(StrPRight(s2,length(s2)-p))
				end
		end;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		pg:=nil;
		buf:=GetMemBuffer(16384,128,bufsize);
		if buf=nil then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_IMPORT_MEMORY1+CompressPath(fname,78)+MESSAGE_IMPORT_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_EXIST1+CompressPath(fname,78)+MESSAGE_IMPORT_EXIST2,BUTTON_OK);
				goto _raus
			end;
		new(pg,Init(0,TITLE_IMPORT,fname));
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		table:='';
		ttxt:='';
		s1:='';
		s2:='';
		cmax:=2;
		rmax:=2;
		header:=true;
		pcolnames:=nil;
		repeat
			res:=fread(hdl,bufsize,buf);
			if res>0 then
				for q:=0 to res-1 do
					if buf^[q]=CR then
						begin
							StrPTrim(ttxt);
							if length(ttxt)>0 then
								begin
									if header then
										begin
											if length(s1)=0 then s1:=ttxt
											else
												if length(s2)=0 then s2:=ttxt
												else
													begin
														split_s2;
														if s1='VECTORS' then
															begin
																if table='"EXCEL"' then
																	begin
																		if si2>rmax then rmax:=si2;
																		if pg<>nil then pg^.SetMax(rmax shl 1)
																	end
																else
																	begin
																		if si2>cmax then cmax:=si2;
																		getmem(pcolnames,cmax shl 2);
																		if pcolnames<>nil then fillchar(pcolnames^,cmax shl 2,0)
																	end
															end
														else
															if s1='TUPLES' then
																begin
																	if table='"EXCEL"' then
																		begin
																			if si2>cmax then cmax:=si2;
																			getmem(pcolnames,cmax shl 2);
																			if pcolnames<>nil then fillchar(pcolnames^,cmax shl 2,0)
																		end
																	else
																		begin
																			if si2>rmax then rmax:=si2;
																			if pg<>nil then pg^.SetMax(rmax shl 1)
																		end
																end
															else
																if s1='DATA' then
																	begin
																		header:=false;
																		getmem(prow,rmax shl 1);
																		getmem(pcol,cmax shl 1);
																		dummy:=rmax*cmax*CELLSIZE;
																		getmem(sheet,dummy);
																		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) then
																			begin
																				if prow<>nil then freemem(prow,rmax shl 1);
																				if pcol<>nil then freemem(pcol,cmax shl 1);
																				if pcolnames<>nil then freemem(pcolnames,cmax shl 2);
																				if sheet<>nil then freemem(sheet,dummy);
																				TexelApp.ErrorWindowMemory(nil);
																				fclose(hdl);
																				goto _raus
																			end;
																		fillchar(sheet^,dummy,0);
																		TexelApp.InitCells(sheet,rmax,cmax);
																		sf:=TexelApp.GetStdFontIndex;
																		sg:=TexelApp.GetStdFontSize;
																		fp:=atol(TexelApp.setupbuffer.floatpoint);
																		dr:=-1;
																		dc:=0;
																		cell:=sheet
																	end
																else
																	if s1='LABEL' then
																		begin
																			if pcolnames<>nil then
																				for e:=si1-1 to si1+si2-2 do pcolnames^[e]:=NewStr(StrPMid(ttxt,2,length(ttxt)-2))
																		end
																	else
																		if s1='SIZE' then
																			begin
																				{ ... }
																			end
																		else
																			if s1='TABLE' then table:=ttxt;
														s1:='';
														s2:=''
													end
										end
									else
										begin
											if length(s1)=0 then s1:=ttxt
											else
												begin
													split_s1;
													case si1 of
													-1:
														begin
															if ttxt='EOD' then goto _weiter;
															if ttxt='BOT' then
																begin
																	inc(dr);
																	dc:=0;
																	if dr>=rmax then goto _weiter;
																	cell:=PCell(longint(sheet)+dr*cmax*CELLSIZE);
																	if pg<>nil then pg^.Progress(1)
																end
														end;
													0:
														begin
															if dc<cmax then
																begin
																	if TexelApp.IsDate(s2,number,otxt,dfrm,TexelApp.setupbuffer.exceldate=bf_Checked) then
																		begin
																			new(cell^.Data.Konst);
																			if cell^.Data.Konst<>nil then
																				begin
																					cell^.Typ:=CTYPE_CONST;
																					cell^.Format:=dfrm;
																					with cell^.Data.Konst^ do
																						begin
																							Txt:=NewStr(otxt);
																							Value:=number;
																							FPts:=fp
																						end;
																					cell^.TxtVal.Font:=sf;
																					cell^.TxtVal.Size:=sg
																				end
																		end
																	else
																		if TexelApp.IsTime(s2,number,otxt,dfrm) then
																			begin
																				new(cell^.Data.Konst);
																				if cell^.Data.Konst<>nil then
																					begin
																						cell^.Typ:=CTYPE_CONST;
																						cell^.Format:=dfrm;
																						with cell^.Data.Konst^ do
																							begin
																								Txt:=NewStr(otxt);
																								Value:=number;
																								FPts:=fp
																							end;
																						cell^.TxtVal.Font:=sf;
																						cell^.TxtVal.Size:=sg
																					end
																			end
																		else
																			begin
																				if StrPLeft(s2,1)='(' then
																					if StrPRight(s2,1)=')' then
																						begin
																							s2:='-'+StrPMid(s2,2,length(s2)-2);
																							sf2:=atof(s2)
																						end;
																				new(cell^.Data.Konst);
																				if cell^.Data.Konst<>nil then
																					begin
																						cell^.Typ:=CTYPE_CONST;
																						cell^.TxtVal.Font:=sf;
																						cell^.TxtVal.Size:=sg;
																						cell^.TxtVal.Align:=TA_RIGHT;
																						with cell^.Data.Konst^ do
																							begin
																								Txt:=NewStr(s2);
																								Value:=sf2;
																								FPts:=fp
																							end
																					end
																			end;
																	inc(longint(cell),CELLSIZE)
																end;
															inc(dc)
														end;
													1:
														begin
															if dc<cmax then
																begin
																	if ttxt[2]='=' then
																		begin
																			new(cell^.Data.Formula);
																			if cell^.Data.Formula<>nil then
																				begin
																					cell^.Typ:=CTYPE_FORMULA;
																					cell^.TxtVal.Font:=sf;
																					cell^.TxtVal.Size:=sg;
																					cell^.TxtVal.Align:=TA_RIGHT;
																					with cell^.Data.Formula^ do
																						begin
																							Value:=0.0;
																							FPts:=fp;
																							Error:=FE_OK;
																							VarDef:=NewStr(StrPMid(ttxt,2,length(ttxt)-2));
																							Func:=nil
																						end
																				end
																		end
																	else
																		if length(ttxt)>2 then
																			begin
																				ttxt:=StrPMid(ttxt,2,length(ttxt)-2);
																				if TexelApp.IsDate(ttxt,number,otxt,dfrm,TexelApp.setupbuffer.exceldate=bf_Checked) then
																					begin
																						new(cell^.Data.Konst);
																						if cell^.Data.Konst<>nil then
																							begin
																								cell^.Typ:=CTYPE_CONST;
																								cell^.Format:=dfrm;
																								with cell^.Data.Konst^ do
																									begin
																										Txt:=NewStr(otxt);
																										Value:=number;
																										FPts:=fp
																									end;
																								cell^.TxtVal.Font:=sf;
																								cell^.TxtVal.Size:=sg
																							end
																					end
																				else
																					if TexelApp.IsTime(ttxt,number,otxt,dfrm) then
																						begin
																							new(cell^.Data.Konst);
																							if cell^.Data.Konst<>nil then
																								begin
																									cell^.Typ:=CTYPE_CONST;
																									cell^.Format:=dfrm;
																									with cell^.Data.Konst^ do
																										begin
																											Txt:=NewStr(otxt);
																											Value:=number;
																											FPts:=fp
																										end;
																									cell^.TxtVal.Font:=sf;
																									cell^.TxtVal.Size:=sg
																								end
																						end
																					else
																						begin
																							cell^.Typ:=CTYPE_TEXT;
																							cell^.TxtVal.Font:=sf;
																							cell^.TxtVal.Size:=sg;
																							cell^.Data.Txt:=NewStr(ttxt)
																						end
																			end;
																	inc(longint(cell),CELLSIZE)
																end;
															inc(dc)
														end
													end;
													s1:=''
												end
										end
								end;
							ttxt:=''
						end
					else
						if buf^[q]>=32 then ttxt:=ttxt+chr(buf^[q])
		until res<>bufsize;
		if header then
			begin
				res:=-1;
				if pcolnames<>nil then freemem(pcolnames,cmax shl 2)
			end;
		_weiter:
		fclose(hdl);
		_errmsg:
		if res<0 then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_IMPORT_LOAD1+CompressPath(fname,78)+MESSAGE_IMPORT_LOAD2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			new(PCalcWindow,InitImport(pg,rmax-1,cmax-1,fname,sheet,prow,pcol,pcolnames,true));
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		ArrowMouse
	end;


procedure TImport.ImportFromClipboard;
	var ext: string;

	begin
		if Application^.Clipboard=nil then exit;
		with Application^.Clipboard^ do
			begin
				if not(OpenClipboard(false)) then exit;
				ext:=GetPriorityClipboardFormat('xls.dif.csv.txl.dbf.spr');
				if ext='txl' then POpen(TexelApp.opennewdoc)^.Load(GetClipboardFilename+'txl')
				else
					if ext='dif' then LoadDIF(GetClipboardFilename+'dif')
					else
						if ext='csv' then LoadCSV(GetClipboardFilename+'csv')
						else
							if ext='xls' then LoadXLS(GetClipboardFilename+'xls')
							else
								if ext='dbf' then ImportDBF(GetClipboardFilename+'dbf',nil)
								else
									if ext='spr' then LoadPsion(GetClipboardFilename+'spr')
									else
										Application^.Alert(nil,1,NOTE,MESSAGE_CLIP_IMPORT,BUTTON_OK);
				{ andere Formate... }
				CloseClipboard
			end
	end;

{$ENDIF}

end.