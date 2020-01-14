unit txload;
{ 1998-07-19 }

interface

uses

	OWindows;


type

	PAbandon = ^TAbandon;
	TAbandon = object(TKeyMenu)
		procedure Work; virtual;
	end;

	POpen = ^TOpen;
	TOpen = object(TKeyMenu)
		procedure Work; virtual;
		procedure Load(fname: string);
	end;
	
	POpenURL = ^TOpenURL;
	TOpenURL = object(TKeyMenu)
		pb1,
		pb2: PButton;
		procedure Work; virtual;
		procedure GetURL(url: string);
	end;




implementation

uses

	Strings,Tos,Gem,
	OTypes,OProcs,Objects,ODialogs,
	txrsc,txlang,txtypes,txprocs,txcollec,txmiscob,txdhst,txmain;

type

	PURLDialog = ^TURLDialog;
	TURLDialog = object(THyperDialog)
		urlbuf: string;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;



procedure TOpen.Work;

	begin
		if XFileSelect(nil,FSELTITLE_OPEN,'*.'+TEXELEXTENSION,TexelApp.LastPath[0],TexelApp.LastFile[0],0,FSEL_OPEN,true,false) then Load(TexelApp.LastPath[0]+TexelApp.LastFile[0])
	end;


procedure TOpen.Load(fname: string);
	label _raus,_error,_errmsg,_pweiter,_pagain;

	var header    : TTexelHeader;
	    head2     : TTexelHead2;
	    parms     : TTexelParms;
	    tdbuf     : TDialogBuffer;
	    tsbuf     : TSheetBuffer;
	    taebuf    : TExportAscBuf;
	    diabuf    : TDiagrammBuf;
	    texbuf    : TExportBuf;
	    tzwbuf    : TZielBuf;
	    srtbuf    : TSortBuf;
	    infbuf    : TInfoBuf;
	    findbuf   : TFindBuf;
	    repbuf    : TReplaceBuf;
	    fillbuf   : TFillBuffer;
	    buf       : PByteArray;
			l         : byte;
			pdb       : PDiagrammBuf;
			prntflg,
			lckflg,
			skal,umbr,
			prop,embd,
			npredef,
			dbv,
	    rerror    : boolean;
	    bufsize,
	    bufpos,
	    ende,
	    offs,w,q,
	    pmask,dlen,
	    w100,h100,
	    x100,y100,
	    res,dummy : longint;
	    dat       : pointer;
	    objtyp,
	    passmask,
	    prnrange,
	    hdl,i     : integer;
	    npval     : TNumber;
	    bhist     : PStringCollection;
			ppc       : PParameterCollection;
			oldcell,
	    sheet,cell: PCell;
	    prowflags,
	    pcolflags : PByteArray;
			prow,
			pcol      : PWordArray;
			pcolnames : PItemList;
	    coffs     : word;
	    buffer    : array [0..127] of byte;
	    ttxt,tname,
	    tdescr    : string;
			rval      : real;
			pp        : PParameter;
			pfm       : PFormat;
			ufrm      : PFormatCollection;
			pre,pred  : PProtoEmbedded;
			pw        : PWindow;
			pwd       : PDialog;
			ps        : PStatic;
			pg        : PProgressWindow;
			apwd      : TPassWord;
			tb        : string[21];
			oabuf     : TEmbedBuf;
			cbbuf     : TEmbedCheckBuf;
			prnset    : PRN_SETTINGS;
			pprnset   : PPRN_SETTINGS;
			findold   : record
				search,
				replace : string[45];
				rows,
				columns,
				cse,
				complete,
				formula,
				value,
				txt,
				note,
				iform,
				ival    : integer
			end;
			tdold     : record
				font,
				size,
				percent,
				color,
				pattern,
				direction: integer;
				input    : string[55];
				txtcolor,
				border   : integer;
				resvd1,
				resvd2,
				resvd3,
				resvd4   : longint
			end;

	function bfread(var buffer; count: longint): boolean;

		begin
			if fread(hdl,count,@buffer)=count then bfread:=false
			else
				begin
					rerror:=true;
					bfread:=true
				end
		end;

	function bread(var buffer; count: longint): boolean;
		var q,len: longint;

		begin
			bread:=false;
			if count<1 then exit;
			if bufpos+count>res then
				if res=bufsize then
					begin
						len:=bufsize-bufpos;
						if len>0 then move(buf^[bufpos],buf^[0],len);
						res:=fread(hdl,bufsize-len,@buf^[len]);
						if res<0 then
							begin
								rerror:=true;
								bread:=true;
								exit
							end;
						if passmask<>0 then
							for q:=len to bufsize-1 do buf^[q]:=buf^[q] xor system.random(256);
						inc(res,len);
						bufpos:=0
					end;
			if bufpos+count>res then
				begin
					rerror:=true;
					bread:=true
				end
			else
				begin
					move(buf^[bufpos],buffer,count);
					inc(bufpos,count)
				end
		end;

	function readtree(var node: PNode): boolean;
		var op,q: integer;

		begin
			readtree:=true;
			node:=nil;
			if bread(op,2) then exit;
			if op<>NT_ENDOFDATA then
				begin
					new(node);
					if node=nil then exit;
					node^.Typ:=op;
					node^.All:=0;
					node^.Left.Node:=nil;
					node^.Right.Node:=nil;
					if op>=5000 then
						begin
							if bread(node^.Count,4) then exit;
							if node^.Count<>NT_LIST_EMPTY then
								begin
									getmem(node^.Left.List,node^.Count shl 2);
									if node^.Left.List=nil then exit;
									for q:=0 to node^.Count-1 do
										if readtree(PNode(node^.Left.List^[q])) then exit
								end
						end
					else
						if op>=1000 then
							begin
								if readtree(node^.Left.Node) then exit;
								if readtree(node^.Right.Node) then exit
							end
						else
							case op of
							NT_NAT_NEGATE,
							NT_NEGATE,
							NT_PERCENT,
							NT_KLAMMER:
								if readtree(node^.Left.Node) then exit;
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
									if readtree(node^.Left.Node) then exit;
									if readtree(node^.Right.Node) then exit
								end;
							NT_CELL:
								begin
									if bread(node^.All,4) then exit;
									if bread(node^.Right.Flg,2) then exit
								end;
							NT_RANGE:
								begin
									if bread(node^.Left.All,4) then exit;
									if bread(node^.Right.All,4) then exit;
									if bread(node^.All,4) then exit
								end;
							NT_VARIABLE:
								begin
									if bread(l,1) then exit;
									if l>0 then
										begin
											if bread(ttxt[1],l) then exit;
											ttxt[0]:=chr(l);
											node^.Varb:=NewStr(ttxt)
										end
								end;
							NT_STRING:
								begin
									if bread(l,1) then exit;
									if l>0 then
										if bread(ttxt[1],l) then exit;
									ttxt[0]:=chr(l);
									node^.Chars:=ChrNew(ttxt)
								end;
							NT_CONST:
								begin
									if bread(rval,sizeof(real)) then exit;
									new(node^.Num);
									if node^.Num=nil then exit;
									node^.Num^:=rval;
									if bread(l,1) then exit;
									if l>0 then
										begin
											if bread(ttxt[1],l) then exit;
											ttxt[0]:=chr(l);
											node^.Left.Txt:=NewStr(ttxt)
										end
								end
							end
				end;
			readtree:=false
		end;

	function readcell: boolean;

		begin
			readcell:=true;
			if bread(cell^.Flags,CELLSIZE-4) then exit;
			cell^.Data.Value:=0;
			case cell^.Typ of
			CTYPE_TEXT:
				begin
					if bread(l,1) then exit;
					if l>0 then
						begin
							if bread(ttxt[1],l) then exit;
							ttxt[0]:=chr(l);
							cell^.Data.Txt:=NewStr(ttxt)
						end
				end;
			CTYPE_CONST:
				begin
					new(cell^.Data.Konst);
					if cell^.Data.Konst<>nil then
						with cell^.Data.Konst^ do
							begin
								if bread(rval,sizeof(real)) then exit;
								Value:=rval;
								if bread(l,1) then exit;
								if l>0 then
									begin
										if bread(ttxt[1],l) then exit;
										ttxt[0]:=chr(l);
										Txt:=NewStr(ttxt)
									end
								else
									Txt:=nil;
								if bread(FPts,1) then exit
							end
				end;
			CTYPE_FORMULA:
				begin
					new(cell^.Data.Formula);
					if cell^.Data.Formula<>nil then
						with cell^.Data.Formula^ do
							begin
								if bread(rval,sizeof(real)) then exit;
								Value:=rval;
								if bread(l,1) then exit;
								if l>0 then
									if bread(ttxt[1],l) then exit;
								ttxt[0]:=chr(l);
								if bread(FPts,1) then exit;
								if bread(Error,1) then exit;
								VarDef:=NewStr(TexelApp.EscText2Formula(ttxt));
								Func:=nil
							end
				end;
			CTYPE_PARSED:
				begin
					new(cell^.Data.Formula);
					if cell^.Data.Formula=nil then exit;
					with cell^.Data.Formula^ do
						begin
							if bread(rval,sizeof(real)) then exit;
							Value:=rval;
							if bread(FPts,1) then exit;
							if bread(Error,1) then exit;
							if readtree(Func) then exit;
							if bread(l,1) then exit;
							if l>0 then
								begin
									if bread(ttxt[1],l) then exit;
									ttxt[0]:=chr(l);
									VarDef:=NewStr(ttxt)
								end
							else
								VarDef:=nil
						end
				end
			end;
			oldcell:=cell;
			readcell:=false
		end;

	begin
		if length(fname)=0 then exit;
		BusyMouse;
		if TexelApp.abruf<>nil then PAbruf(TexelApp.abruf)^.Add(fname,true);
		pg:=nil;
		bhist:=nil;
		pprnset:=nil;
		pre:=nil;
		buf:=GetMemBuffer(65536,128,bufsize);
		if buf=nil then
			begin
				Application^.Alert(nil,1,STOP,MESSAGE_OPEN_MEMORY1+CompressPath(fname,78)+MESSAGE_OPEN_MEMORY2,BUTTON_OK);
				goto _raus
			end;
		if not(Exist(fname)) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_OPEN_EXIST1+CompressPath(fname,78)+MESSAGE_OPEN_EXIST2,BUTTON_OK);
				goto _raus
			end;
		pw:=Application^.MainWindow;
		while pw<>nil do
			begin
				if pw^.GetClassName=TEXELWINDCLASS then
					if PCalcWindow(pw)^.GetWindowFilename=fname then
						if Application^.Alert(nil,1,WAIT,MESSAGE_OPEN_LOADED1+CompressPath(fname,78)+MESSAGE_OPEN_LOADED2,BUTTON_YESNO)<>1 then goto _raus;
				pw:=pw^.Next
			end;
		rerror:=false;
		res:=fopen(fname,FO_READ);
		if res<0 then goto _errmsg;
		hdl:=integer(res);
		res:=bufsize;
		bufpos:=res;
		passmask:=0;
		if fread(hdl,sizeof(TTexelHeader),@header)<>sizeof(TTexelHeader) then
			begin
				rerror:=true;
				goto _error
			end;
		with header do
			begin
				if Magic<>TEXELMAGIC then
					begin
						Application^.Alert(nil,1,NOTE,MESSAGE_OPEN_FORMAT1+CompressPath(fname,78)+MESSAGE_OPEN_FORMAT2,BUTTON_OK);
						fclose(hdl);
						goto _raus
					end
				else
					if (Compatible<17) or (Compatible>TEXELCOMPAT) then
						begin
							Application^.Alert(nil,1,NOTE,MESSAGE_OPEN_VERSION1+CompressPath(fname,78)+MESSAGE_OPEN_VERSION2+ltoa(Compatible)+MESSAGE_OPEN_VERSION3+VtoS(Version)+MESSAGE_OPEN_VERSION4,BUTTON_OK);
							fclose(hdl);
							goto _raus
						end
					else
						if (PackAlgo<>PA_HORIZONTAL) and (PackAlgo<>PA_VERTICAL) then
							begin
								if PackAlgo=PA_BLOCK then Application^.Alert(nil,1,NOTE,MESSAGE_OPEN_CCP,BUTTON_OK)
								else
									Application^.Alert(nil,1,NOTE,MESSAGE_OPEN_ALGO1+CompressPath(fname,78)+MESSAGE_OPEN_ALGO2+' (#'+ltoa(PackAlgo)+').',BUTTON_OK);
								fclose(hdl);
								goto _raus
							end
			end;
		if fread(hdl,sizeof(TTexelHead2),@head2)<>sizeof(TTexelHead2) then
			begin
				rerror:=true;
				goto _error
			end;
		apwd.Flag:=head2.PassFlag;
		apwd.Code:=head2.PassCode;
		apwd.Mask:=0;
		if head2.PassFlag<>0 then
			begin
				TexelApp.ActivateExtResource;
				_pagain:
				new(pwd,Init(nil,'',RTPASS));
				if pwd<>nil then
					begin
						new(ps,Init(pwd,RTPWFILE,30,true,BUBBLE_PASS_FILE));
						if ps<>nil then ps^.SetText(CompressPath(fname,29));
						new(PPasswordEdit,Init(pwd,RTPWPASS,21,BUBBLE_PASS_EDIT));
						new(PButton,Init(pwd,RTPWABBRUCH,id_Cancel,true,BUBBLE_PASS_CANCEL));
						new(PButton,Init(pwd,RTPWOK,id_OK,true,BUBBLE_PASS_OK));
						tb:='';
						pwd^.TransferBuffer:=@tb;
						if Application^.ExecDialog(pwd)=RTPWOK then
							begin
								if length(tb)<6 then
									begin
										Application^.Alert(nil,1,NOTE,MESSAGE_OPEN_PASSLEN,BUTTON_OK);
										goto _pagain
									end;
								if CheckPassWord(tb,head2.PassCode,pmask) then
									begin
										head2.RSeed:=head2.RSeed xor pmask;
										apwd.Mask:=pmask;
										TexelApp.DeactivateExtResource;
										goto _pweiter
									end
								else
									Application^.Alert(nil,1,STOP,MESSAGE_OPEN_PASSWRONG,BUTTON_CANCEL)
							end;
						TexelApp.DeactivateExtResource;
						fclose(hdl);
						goto _raus
					end
				else
					begin
						TexelApp.DeactivateExtResource;
						rerror:=true;
						goto _error
					end
			end;
		_pweiter:
		if header.Compatible>29 then
			begin
				if bfread(coffs,2) then goto _error;
				pred:=nil;
				if coffs>0 then
					for q:=0 to coffs-1 do
						begin
							if bfread(objtyp,2) then goto _error;
							if bfread(l,1) then goto _error;
							if l>0 then
								if bfread(ttxt[1],l) then goto _error;
							ttxt[0]:=chr(l);
							if bfread(dlen,4) then goto _error;
							if dlen=0 then dat:=nil
							else
								begin
									getmem(dat,dlen);
									if dat=nil then
										begin
											rerror:=true;
											goto _error
										end;
									if bfread(dat^,dlen) then goto _error
								end;
							if bfread(oabuf,sizeof(TEmbedBuf)) then goto _error;
							if bfread(x100,4) then goto _error;
							if bfread(y100,4) then goto _error;
							if bfread(w100,4) then goto _error;
							if bfread(h100,4) then goto _error;
							if bfread(prop,sizeof(boolean)) then goto _error;
							if bfread(embd,sizeof(boolean)) then goto _error;
							prntflg:=true;
							lckflg:=false;
							if header.Compatible>34 then
								begin
									if bfread(prntflg,sizeof(boolean)) then goto _error;
									if bfread(lckflg,sizeof(boolean)) then goto _error
								end;
							skal:=false;
							umbr:=false;
							pdb:=nil;
							case objtyp of
							EMB_TYPE_IMG:
								begin
									if bfread(skal,sizeof(boolean)) then goto _error;
								end;
							EMB_TYPE_TEXT:
								begin
									if bfread(umbr,sizeof(boolean)) then goto _error;
									if bfread(dummy,4) then goto _error
								end;
							EMB_TYPE_TAD:
								begin
									if bfread(dbv,sizeof(boolean)) then goto _error;
									if dbv then
										begin
											new(pdb);
											if pdb=nil then
												begin
													rerror:=true;
													goto _error
												end;
											if bfread(pdb^,sizeof(TDiagrammBuf)) then goto _error
										end
								end;
							EMB_TYPE_CHECKBOX:
								begin
									if bfread(cbbuf,sizeof(TEmbedCheckBuf)) then goto _error;
								end
							end;
							if pre=nil then new(pre,Init(objtyp,ttxt,dat,dlen,x100,y100,w100,h100,oabuf,cbbuf,pdb,prop,embd,skal,umbr,prntflg,lckflg))
							else
								begin
									pred:=pre;
									while pred^.Next<>nil do pred:=pred^.Next;
									new(pred^.Next,Init(objtyp,ttxt,dat,dlen,x100,y100,w100,h100,oabuf,cbbuf,pdb,prop,embd,skal,umbr,prntflg,lckflg))
								end
						end
			end;
		if head2.CryptFlag<>0 then
			begin
				randseed:=head2.RSeed;
				passmask:=1
			end;
		if bread(parms,sizeof(TTexelParms)) then goto _error;
		with parms do
			begin
				if Rows<1 then Rows:=1;
				if Columns<1 then Columns:=1;
				if header.Compatible<37 then Toolbar:=TexelApp.setupbuffer.toolbar
			end;
		ScanConst(TexelApp.DataPath,ppc);
		new(ufrm,Init(50,25));
		getmem(prow,(parms.Rows+1) shl 1);
		getmem(pcol,(parms.Columns+1) shl 1);
		getmem(pcolnames,(parms.Columns+1) shl 2);
		getmem(prowflags,parms.Rows+1);
		getmem(pcolflags,parms.Columns+1);
		dummy:=longint(parms.Rows+1)*longint(parms.Columns+1)*CELLSIZE;
		getmem(sheet,dummy);
		if (prow=nil) or (pcol=nil) or (sheet=nil) or (pcolnames=nil) or (prowflags=nil) or (pcolflags=nil) then
			begin
				if prow<>nil then freemem(prow,(parms.Rows+1) shl 1);
				if pcol<>nil then freemem(pcol,(parms.Columns+1) shl 1);
				if prowflags<>nil then freemem(prowflags,parms.Rows+1);
				if pcolflags<>nil then freemem(pcolflags,parms.Columns+1);
				if pcolnames<>nil then freemem(pcolnames,(parms.Columns+1) shl 2);
				if sheet<>nil then freemem(sheet,dummy);
				TexelApp.ErrorWindowMemory(nil);
				fclose(hdl);
				goto _raus
			end;
		new(pg,Init(parms.Rows+(parms.Rows shr 2)+1,TITLE_OPEN,fname));
		fillchar(pcolnames^,(parms.Columns+1) shl 2,0);
		fillchar(pcolflags^,parms.Columns+1,0);
		fillchar(prowflags^,parms.Rows+1,0);
		fillchar(sheet^,dummy,0);
		TexelApp.InitCells(sheet,parms.Rows+1,parms.Columns+1);
		if header.Compatible<27 then
			begin
				if bread(tdold,sizeof(tdold)) then goto _error;
				tdbuf.font:=tdold.font;
				tdbuf.size:=tdold.size;
				tdbuf.percent:=tdold.percent;
				tdbuf.color:=tdold.color;
				tdbuf.pattern:=tdold.pattern;
				tdbuf.direction:=tdold.direction;
				tdbuf.input:=tdold.input;
				tdbuf.txtcolor:=tdold.txtcolor;
				tdbuf.border:=tdold.border;
				tdbuf.resvd1:=tdold.resvd1;
				tdbuf.resvd2:=tdold.resvd2;
				tdbuf.resvd3:=tdold.resvd3;
				tdbuf.resvd4:=tdold.resvd4
			end
		else
			if bread(tdbuf,sizeof(TDialogBuffer)) then goto _error;
		if header.Compatible<26 then
			begin
				if bread(tsbuf.font,sizeof(TSheetBuffer)-14) then goto _error;
				tsbuf.umbruch:=bf_Checked;
				tsbuf.exceldate:=bf_Unchecked
			end
		else
			if header.Compatible<42 then
				begin
					if bread(tsbuf.font,sizeof(TSheetBuffer)-12) then goto _error;
					tsbuf.exceldate:=bf_Unchecked
				end
			else
				if bread(tsbuf.font,sizeof(TSheetBuffer)-10) then goto _error;
		if header.Compatible<24 then
			begin
				with tzwbuf do
					begin
						zzelle:='';
						vzelle:='';
						wert:='0';
						iterationen:='100'
					end
			end
		else
			if bread(tzwbuf,sizeof(TZielBuf)) then goto _error;
		if header.Compatible<29 then
			begin
				with diabuf do
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
						Size:=TexelApp.setupbuffer.stdfsize;
						Font:=TexelApp.setupbuffer.stdfont;
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
					end
			end
		else
			if bread(diabuf,sizeof(TDiagrammBuf)) then goto _error;
		if header.Compatible<23 then
			begin
				if bread(texbuf.ascii,sizeof(TExportAscBuf)) then goto _error;
				with texbuf do
					begin
						exporttype:=0;
						clipboard:=bf_Unchecked;
						bereich:=bf_Unchecked;
						htmldoctype:=0;
						htmlsavedt:=bf_Checked;
						htmlcolor:=bf_Checked;
						csvformula:=bf_Unchecked;
						csvvalue:=bf_Checked;
						difformula:=bf_Unchecked;
						difvalue:=bf_Checked;
						difstandard:=bf_Checked;
						difexcel:=bf_Unchecked;
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
					end
			end
		else
			if header.Compatible<28 then
				begin
					if bread(texbuf,sizeof(TExportBuf)-20) then goto _error;
					texbuf.difformat:=bf_Checked;
					texbuf.csvformat:=bf_Checked;
					texbuf.asciiformat:=bf_Checked;
					texbuf.htmlembed:=bf_Unchecked;
					texbuf.htmldoctype:=0;
					texbuf.htmlsavedt:=bf_Checked;
					texbuf.filter:=0;
					texbuf.htmlnoesc:=bf_Unchecked;
					texbuf.xlsversion:=0;
					texbuf.htmlcss:=1;
					texbuf.texelvers:=0;
					texbuf.htmlfonts:=bf_Checked;
				end
			else
				if header.Compatible<31 then
					begin
						if bread(texbuf,sizeof(TExportBuf)-14) then goto _error;
						texbuf.htmlembed:=bf_Unchecked;
						texbuf.htmldoctype:=0;
						texbuf.htmlsavedt:=bf_Checked;
						texbuf.filter:=0;
						texbuf.htmlnoesc:=bf_Unchecked;
						texbuf.xlsversion:=0;
						texbuf.htmlcss:=1;
						texbuf.texelvers:=0;
						texbuf.htmlfonts:=bf_Checked;
					end
				else
					if header.Compatible<34 then
						begin
							if bread(texbuf,sizeof(TExportBuf)-12) then goto _error;
							texbuf.filter:=0;
							texbuf.htmlnoesc:=bf_Unchecked;
							texbuf.xlsversion:=0;
							texbuf.htmlcss:=1;
							texbuf.texelvers:=0;
							texbuf.htmlfonts:=bf_Checked;
							if header.Compatible<32 then
								begin
									texbuf.htmldoctype:=0;
									texbuf.htmlsavedt:=bf_Checked
								end
						end
					else
						if header.Compatible<39 then
							begin
								if bread(texbuf,sizeof(TExportBuf)-10) then goto _error;
								texbuf.htmlnoesc:=bf_Unchecked;
								texbuf.xlsversion:=0;
								texbuf.htmlcss:=1;
								texbuf.texelvers:=0;
								texbuf.htmlfonts:=bf_Checked;
							end
						else
							if header.Compatible<40 then
								begin
									if bread(texbuf,sizeof(TExportBuf)-8) then goto _error;
									texbuf.xlsversion:=0;
									texbuf.htmlcss:=1;
									texbuf.texelvers:=0;
									texbuf.htmlfonts:=bf_Checked;
								end
							else
								if header.Compatible<41 then
									begin
										if bread(texbuf,sizeof(TExportBuf)-6) then goto _error;
										texbuf.htmlcss:=1;
										texbuf.texelvers:=0;
										texbuf.htmlfonts:=bf_Checked;
									end
								else
									if header.Compatible<43 then
										begin
											if bread(texbuf,sizeof(TExportBuf)-4) then goto _error;
											texbuf.texelvers:=0;
											texbuf.htmlfonts:=bf_Checked;
										end
									else
										if header.Compatible<45 then
											begin
												if bread(texbuf,sizeof(TExportBuf)-2) then goto _error;
												texbuf.htmlfonts:=bf_Checked;
											end
										else
											if bread(texbuf,sizeof(TExportBuf)) then goto _error;
		if header.Compatible<22 then
			begin
				if bread(srtbuf,sizeof(TSortBuf)-2) then goto _error;
				srtbuf.Attribute:=bf_Unchecked
			end
		else
			if bread(srtbuf,sizeof(TSortBuf)) then goto _error;
		if bread(infbuf,sizeof(TInfoBuf)-4) then goto _error;
		infbuf.Last:=gettime;
		infbuf.Version:=header.Version;
		infbuf.Release:=header.Release;
		inc(infbuf.Used);
		{$IFDEF LITE}
		infbuf.Encrypt:=bf_Unchecked;
		{$ELSE}
		if head2.CryptFlag=0 then infbuf.Encrypt:=bf_Unchecked
		else
			infbuf.Encrypt:=bf_Checked;
		{$ENDIF}
		if header.Compatible<18 then
			begin
				if bread(findold,sizeof(findold)) then goto _error;
				with findbuf do
					begin
						search:=findold.search;
						rows:=findold.rows;
						columns:=findold.columns;
						cse:=findold.cse;
						complete:=findold.complete;
						formula:=findold.formula;
						value:=findold.value;
						txt:=findold.txt;
						iform:=findold.iform;
						ival:=findold.ival;
						vor:=bf_Checked;
						zurueck:=bf_Unchecked;
						resvd:=0
					end;
				with repbuf do
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
					end
			end
		else
			begin
				if bread(findbuf,sizeof(TFindBuf)) then goto _error;
				if bread(repbuf,sizeof(TReplaceBuf)) then goto _error
			end;
		if bread(fillbuf,sizeof(TFillBuffer)) then goto _error;
		if bread(coffs,2) then goto _error;
		while coffs>0 do
			begin
				if bread(buffer,Min(128,coffs)) then goto _error;
				if coffs>128 then dec(coffs,128)
				else
					coffs:=0
			end;
		if bread(prow^,(parms.Rows+1) shl 1) then goto _error;
		if bread(pcol^,(parms.Columns+1) shl 1) then goto _error;
		for q:=0 to parms.Columns do
			begin
				if bread(l,1) then goto _error;
				if l>0 then
					begin
						if bread(ttxt[1],l) then goto _error;
						ttxt[0]:=chr(l);
						pcolnames^[q]:=NewStr(ttxt)
					end
			end;
		if header.Compatible>=25 then
			begin
				if bread(prowflags^,Parms.Rows+1) then goto _error;
				if bread(pcolflags^,Parms.Columns+1) then goto _error
			end;
		if bread(coffs,2) then goto _error;
		oldcell:=nil;
		cell:=sheet;
		if header.PackAlgo=PA_VERTICAL then
			begin
				offs:=longint(parms.Columns+1)*CELLSIZE;
				ende:=longint(sheet)+(longint(parms.Columns+1)*longint(parms.Rows+1)-1)*CELLSIZE;
				while coffs<>65535 do
					begin
						if coffs>32768 then
							for q:=0 to coffs-32769 do
								begin
									cell^:=oldcell^;
									cell^.Flags:=cell^.Flags and CELL_EMPTYMASK;
									inc(longint(cell),offs);
									if longint(cell)>ende then cell:=PCell(longint(sheet)+longint(cell)-ende)
								end
						else
							if coffs>0 then
								for q:=0 to coffs-1 do
									begin
										inc(longint(cell),offs);
										if longint(cell)>ende then cell:=PCell(longint(sheet)+longint(cell)-ende)
									end;
						if readcell then goto _error;
						inc(longint(cell),offs);
						if longint(cell)>ende then cell:=PCell(longint(sheet)+longint(cell)-ende);
						if bread(coffs,2) then goto _error
					end
			end
		else
			while coffs<>65535 do
				begin
					if coffs>32768 then
						for q:=0 to coffs-32769 do
							begin
								cell^:=oldcell^;
								cell^.Flags:=cell^.Flags and CELL_EMPTYMASK;
								inc(longint(cell),CELLSIZE)
							end
					else
						if coffs>0 then inc(longint(cell),longint(coffs)*CELLSIZE);
					if readcell then goto _error;
					inc(longint(cell),CELLSIZE);
					if bread(coffs,2) then goto _error
				end;
		if bread(coffs,2) then goto _error;
		if coffs>0 then
			for q:=0 to coffs-1 do
				begin
					if bread(l,1) then goto _error;
					if l>0 then
						if bread(tname[1],l) then goto _error;
					tname[0]:=chr(l);
					if bread(l,1) then goto _error;
					if l>0 then
						if bread(ttxt[1],l) then goto _error;
					ttxt[0]:=chr(l);
					if bread(l,1) then goto _error;
					if l>0 then
						if bread(tdescr[1],l) then goto _error;
					tdescr[0]:=chr(l);
					if ppc<>nil then
						begin
							npval:=atof(ttxt);
							npredef:=false;
							if ppc^.Count>0 then
								for w:=0 to ppc^.Count-1 do
									if StrPUpper(PParameter(ppc^.At(w))^.Name^)=StrPUpper(tname) then
										begin
											if PParameter(ppc^.At(w))^.Value=npval then npredef:=true;
											ppc^.AtFree(w);
											break
										end;
							new(pp);
							if pp<>nil then
								begin
									pp^.Value:=npval;
									pp^.Name:=NewStr(tname);
									pp^.ListName:=NewStr('  '+tname+' '#0);
									pp^.Txt:=NewStr(ttxt);
									pp^.Descr:=NewStr(tdescr);
									pp^.Predef:=npredef;
									if (pp^.Name=nil) or (pp^.Txt=nil) then
										begin
											DisposeStr(pp^.Name);
											DisposeStr(pp^.ListName);
											DisposeStr(pp^.Txt);
											DisposeStr(pp^.Descr);
											dispose(pp)
										end
									else
										ppc^.Insert(pp)
								end
						end
				end;
		if header.Compatible>18 then
			if ufrm<>nil then
				begin
					ufrm^.Sort:=false;
					if bread(coffs,2) then goto _error;
					if coffs>0 then
						for q:=0 to coffs-1 do
							begin
								if bread(i,2) then goto _error;
								if bread(l,1) then goto _error;
								if l>0 then
									if bread(ttxt[1],l) then goto _error;
								ttxt[0]:=chr(l);
								new(pfm);
								if pfm<>nil then
									begin
										pfm^.Name:=NewStr(ttxt);
										pfm^.Group:=1;
										pfm^.Index:=i;
										ufrm^.Insert(pfm)
									end
							end
				end;
		if header.Compatible>20 then
			begin
				if bread(coffs,2) then goto _error;
				if coffs>0 then
						for q:=0 to coffs-1 do
							begin
								if bread(l,1) then goto _error;
								if l>0 then
									if bread(ttxt[1],l) then goto _error;
								ttxt[0]:=chr(l);
								if bhist=nil then
									begin
										new(bhist,Init(5+atol(TexelApp.setupbuffer.history),10));
										if bhist<>nil then bhist^.Sort:=false
									end;
								if bhist<>nil then bhist^.Insert(NewStr(ttxt))
							end
			end;
		if header.Compatible>32 then
			begin
				if bread(dummy,4) then goto _error;
				if dummy>0 then
					begin
						if bread(prnset,dummy) then goto _error;
						pprnset:=@prnset
					end
			end;
		prnrange:=-1;
		if header.Compatible>35 then
			if bread(prnrange,2) then goto _error;
{		if bread(coffs,2) then goto _error;
		if coffs>0 then
			for q:=0 to coffs-1 do
				begin
					if bread(l,1) then goto _error;
					if l>0 then
						if bread(tname[1],l) then goto _error;
					tname[0]:=chr(l);
					if bread(w,2) then goto _error;
					 ... 
				end;
		if bread(coffs,2) then goto _error; ... }
		_error:
		fclose(hdl);
		_errmsg:
		if rerror or (res<0) then
			begin
				Application^.Alert(nil,1,NOTE,MESSAGE_OPEN_ERROR1+CompressPath(fname,78)+MESSAGE_OPEN_ERROR2,BUTTON_OK);
				if pg<>nil then dispose(pg,Done)
			end
		else
			begin
				if pg<>nil then pg^.Progress(parms.Rows shr 2);
				tsbuf.protect:=bf_Unchecked; { ... }
				TexelApp.FontID2Index(tdbuf.font);
				TexelApp.FontSize2Index(tdbuf.font,tdbuf.size);
				TexelApp.FontID2Index(tsbuf.font);
				TexelApp.FontSize2Index(tsbuf.font,tsbuf.size);
				new(PCalcWindow,InitFile(fname,pg,parms,tdbuf,tsbuf,findbuf,repbuf,
				    fillbuf,tzwbuf,texbuf,srtbuf,infbuf,diabuf,sheet,prow,pcol,pcolnames,ppc,ufrm,pre,
				    apwd,bhist,pcolflags,prowflags,pprnset,prnrange,header.Compatible<TEXELCOMPAT,
				    header.Compatible<38))
			end;
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		ArrowMouse
	end;


function TURLDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		if AnIndx=RTUOPEN then
			begin
				TransferData(tf_GetData);
				if TexelApp.openurl=nil then Application^.Bing
				else
					POpenURL(TexelApp.openurl)^.GetURL(urlbuf)
			end
	end;


function TURLDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTUOPEN);
		OK:=valid
	end;


procedure TOpenUrl.Work;
	var pb: PButton;

	begin
		if ADialog=nil then
			begin
				TexelApp.ActivateExtResource;
				ADialog:=new(PURLDialog,Init(nil,TEXELWINDPREFIX+TITLE_URL,STG_URL,ICNTITLE_URL,RTURL));
				if ADialog<>nil then
					begin
						new(PEdit,Init(ADialog,RTUURL,68,BUBBLE_URL_EDIT));
						new(pb,Init(ADialog,RTUHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTUABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(pb1,Init(ADialog,RTUOPEN,id_No,true,BUBBLE_URL_OPEN));
						new(pb2,Init(ADialog,RTUOK,id_OK,true,BUBBLE_URL_OK));
						PURLDialog(ADialog)^.urlbuf:='';
						ADialog^.TransferBuffer:=@PURLDialog(ADialog)^.urlbuf
					end;
				TexelApp.DeactivateExtResource
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;


procedure TOpenURL.GetURL(url: string);
	var pipe: Pipearray;

	begin
		StrPTrim(url);
		if (length(url)=0) or (TexelApp.WebID<0) or (GetState<>bf_Enabled) then Application^.Bing
		else
			begin
				StrPCopy(helpbuf,url);
				pipe[0]:=CAB_VIEW;
				pipe[1]:=Application^.apID;
				pipe[2]:=0;
				pipe[3]:=integer(HiWord(helpbuf));
				pipe[4]:=integer(LoWord(helpbuf));
				pipe[5]:=0;
				pipe[6]:=0;
				pipe[7]:=0;
				appl_write(TexelApp.WebID,16,@pipe)
			end
	end;


procedure TAbandon.Work;
	var pipe: ARRAY_8;
	    p   : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		pipe[0]:=GO_PRIVATE;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=GOP_ABANDON;
		pipe[4]:=integer(HiWord(p));
		pipe[5]:=integer(LoWord(p));
		appl_write(Application^.apID,16,@pipe)
	end;

end.