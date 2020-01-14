unit txsave;
{ 1998-07-18 }

interface

uses

	OWindows;


type

	PSave = ^TSave;
	TSave = object(TKeyMenu)
		procedure Work; virtual;
		function Save(fname: string; txlver: integer): boolean;
	end;

	PSaveAs = ^TSaveAs;
	TSaveAs = object(TKeyMenu)
		procedure Work; virtual;
		procedure SaveAs(const fname: string; flag: integer);
	end;




implementation

uses

	Tos,
	OTypes,OProcs,
	txlang,txtypes,txprocs,txmain;



procedure TSave.Work;
	var p    : PCalcWindow;
      fname: string;

	begin
		p:=PCalcWindow(Parent);
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				exit
			end;
		fname:=p^.GetWindowFileName;
		if length(fname)=0 then p^.saveas^.Work
		else
			if p^.sheetbuffer.vorlage=bf_Unchecked then Save(fname,TEXELCOMPAT)
			else
				if Application^.Alert(p,2,WAIT,MESSAGE_SAVE_FORMDOC,BUTTON_FORMDOC)=1 then Save(fname,TEXELCOMPAT)
				else
					if XFileSelect(p,FSELTITLE_SAVEFORMASDOC,'*.'+TEXELEXTENSION,TexelApp.LastPath[0],TexelApp.LastFile[0],1,FSEL_SAVE2,false,p^.closing) then PSaveAs(p^.saveas)^.SaveAs(TexelApp.LastPath[0]+TexelApp.LastFile[0],1)
	end;


function TSave.Save(fname: string; txlver: integer): boolean;
{ Werte fr txlver: 33 (1.6), 38 (2.0), 43 (2.1) oder TEXELCOMPAT  // todo: 20 (1.1), 30 (1.5) }
	label _unreg,_raus;
{$IFNDEF DEMO}
	label _elmnext;
{$ENDIF}

	var p        : PCalcWindow;
      fn2,dtxt : string;
      buf      : PByteArray;
      res,dummy,
      packsize,
      hsize,
      vsize,
      lctrl,
      bufsize,
      bufcnt   : longint;
      passmask,
      nctrl,
      objtyp,
      hdl,q    : integer;
      header   : TTexelHeader;
      head2    : TTexelHead2;
      l        : byte;
      embdirty,
      werror,
      prp,
      test     : boolean;
      oldtb    : pointer;
      newtb    : TDialogBuffer;
      newsb    : TSheetBuffer;
      coffs    : word;
      ps       : PString;
	    pp       : PParameter;
	    pfm      : PFormat;
	    pf       : PFont;
	    rval     : real;
	    cell,
	    oldcell  : PCell;
	    pe       : PEmbedded;

	function IsCellEqual: boolean;

		begin
			IsCellEqual:=false;
			if cell^.Data.Value=0 then
				with oldcell^ do
					if Data.Value=0 then
						if Typ=cell^.Typ then
							if Color=cell^.Color then
								if Style=cell^.Style then
									if Interior=cell^.Interior then
										if Border.Val1=cell^.Border.Val1 then
											if Border.Val2=cell^.Border.Val2 then
												if Format=cell^.Format then
													if (Flags and CELL_EMPTYMASK)=(cell^.Flags and CELL_EMPTYMASK) then
														if cell^.TxtVal.Flags=0 then
															with TxtVal do
																if Flags=0 then
																	if Font=cell^.TxtVal.Font then
																		if Size=cell^.TxtVal.Size then
																			if Rotat=cell^.TxtVal.Rotat then
																				if Skew=cell^.TxtVal.Skew then
																					if Color=cell^.TxtVal.Color then
																						if Effects=cell^.TxtVal.Effects then
																							if Align=cell^.TxtVal.Align then IsCellEqual:=true
		end;

	function bfwrite(var buffer; count: longint): boolean;

		begin
			if fwrite(hdl,count,@buffer)=count then bfwrite:=false
			else
				begin
					werror:=true;
					bfwrite:=true
				end
		end;

	function bwrite(var buffer; count: longint): boolean;
		var q,rlen: longint;
		    pb    : PByte;

		begin
			if test then
				begin
					bwrite:=false;
					inc(packsize,count);
					exit
				end;
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
							if passmask<>0 then
								begin
									pb:=PByte(buf);
									for q:=0 to bufcnt-1 do
										begin
											pb^:=pb^ xor system.random(256);
											inc(longint(pb))
										end
								end;
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
					if passmask<>0 then
						begin
							pb:=PByte(buf);
							for q:=0 to bufcnt-1 do
								begin
									pb^:=pb^ xor system.random(256);
									inc(longint(pb))
								end
						end;
					rlen:=fwrite(hdl,bufcnt,buf);
					if rlen<>bufcnt then
						begin
							werror:=true;
							bwrite:=true
						end;
					bufcnt:=0
				end;
			move(buffer,buf^[bufcnt],count);
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
					if txlver<44 then
						if pn^.Typ=NT_STRING then
							begin
								q:=NT_FEHLER;
								if bwrite(q,2) then exit;
								if savetree(nil) then exit;
								if savetree(nil) then exit;
								savetree:=false;
								exit
							end;
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
			if bwrite(coffs,2) then exit;
			case cell^.Typ of
			CTYPE_TEXT:
				begin
					if bwrite(cell^.Flags,CELLSIZE-4) then exit;
					if bwrite(cell^.Data.Txt^,length(cell^.Data.Txt^)+1) then exit
				end;
			CTYPE_CONST:
				begin
					if bwrite(cell^.Flags,CELLSIZE-4) then exit;
					with cell^.Data.Konst^ do
						begin
							rval:=Value;
							if bwrite(rval,sizeof(real)) then exit;
							if bwrite(Txt^,length(Txt^)+1) then exit;
							if bwrite(FPts,1) then exit
						end
				end;
			CTYPE_FORMULA:
				begin
					cell^.Typ:=CTYPE_PARSED;
					if bwrite(cell^.Flags,CELLSIZE-4) then
						begin
							cell^.Typ:=CTYPE_FORMULA;
							exit
						end;
					cell^.Typ:=CTYPE_FORMULA;
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
								if bwrite(VarDef^,length(VarDef^)+1) then exit
						end
				end
{				with cell^.Data.Formula^ do
					begin
						rval:=Value;
						if bwrite(rval,sizeof(real)) then exit;
						fn2:=p^.BuildFunction(cell,false);
						if bwrite(fn2,length(fn2)+1) then exit;
						if bwrite(FPts,1) then exit;
						if bwrite(Error,1) then exit
					end ... }
			else
				if bwrite(cell^.Flags,CELLSIZE-4) then exit
			end;
			writecell:=false;
			oldcell:=cell;
			coffs:=32768
		end;

	function pack_hor: boolean;
		label _write,_nextcell;
		var c: longint;

		begin
			pack_hor:=true;
			packsize:=0;
			cell:=p^.Sheet;
			oldcell:=nil;
			coffs:=0;
			for c:=0 to longint(p^.Parms.Rows)*longint(p^.Parms.Columns)+longint(p^.Parms.Rows)+longint(p^.Parms.Columns) do
				begin
					if p^.IsEmptyCell(cell) then
						begin
							if coffs>=32767 then
								begin
									if coffs=32768 then coffs:=1
									else
										goto _write
								end
							else
								inc(coffs)
						end
					else
						begin
							if coffs>=32768 then
								begin
									if IsCellEqual then
										begin
											if coffs=65534 then goto _write
											else
												begin
													inc(coffs);
													goto _nextcell
												end
										end
									else
										if coffs=32768 then coffs:=0
								end;
							_write:
							if writecell then exit
						end;
					_nextcell:
					inc(longint(cell),CELLSIZE)
				end;
			if coffs>32768 then
				begin
					if coffs=32769 then coffs:=0
					else
						dec(coffs);
					cell:=oldcell;
					if writecell then exit
				end;
			pack_hor:=false
		end;

	function pack_ver: boolean;
		label _write,_nextcell;
		var x,y,offs: longint;
		    ooc     : PCell;

		begin
			pack_ver:=true;
			packsize:=0;
			oldcell:=nil;
			offs:=longint(p^.Parms.Columns+1)*CELLSIZE;
			ooc:=p^.Sheet;
			coffs:=0;
			for x:=0 to longint(p^.Parms.Columns) do
				begin
					cell:=ooc;
					for y:=0 to longint(p^.Parms.Rows) do
						begin
							if p^.IsEmptyCell(cell) then
								begin
									if coffs>=32767 then
										begin
											if coffs=32768 then coffs:=1
											else
												goto _write
										end
									else
										inc(coffs)
								end
							else
								begin
									if coffs>=32768 then
										begin
											if IsCellEqual then
												begin
													if coffs=65534 then goto _write
													else
														begin
															inc(coffs);
															goto _nextcell
														end
												end
											else
												if coffs=32768 then coffs:=0
										end;
									_write:
									if writecell then exit
								end;
							_nextcell:
							inc(longint(cell),offs)
						end;
					inc(longint(ooc),CELLSIZE)
				end;
			if coffs>32768 then
				begin
					if coffs=32769 then coffs:=0
					else
						dec(coffs);
					cell:=oldcell;
					if writecell then exit
				end;
			pack_ver:=false
		end;

	begin
		p:=PCalcWindow(Parent);
		Save:=false;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				exit
			end;
		{$IFDEF LITE}
		if (p^.Parms.Rows>=MAXLINES) or (p^.Parms.Columns>=MAXCOLUMNS) then
			begin
				Application^.Alert(p,1,NOTE,MESSAGE_HOME_SAVE1+ltoa(MAXLINES)+MESSAGE_HOME_SAVE2+ltoa(MAXCOLUMNS)+MESSAGE_HOME_SAVE3,BUTTON_OK);
				exit
			end;
		{$ENDIF}
		buf:=nil;
		embdirty:=false;
		pe:=p^.Embedded;
		while pe<>nil do
			begin
				if pe^.IsDirty then
					begin
						embdirty:=true;
						break
					end;
				pe:=pe^.Next
			end;
		if embdirty then
			if Application^.Alert(p,1,WAIT,MESSAGE_SAVE_EMBEDDED,BUTTON_SAVECANCEL)<>1 then goto _raus;
		BusyMouse;
		buf:=GetMemBuffer(131072,512,bufsize);
		if buf=nil then
			begin
				Application^.Alert(p,1,STOP,MESSAGE_SAVE_MEMORY,BUTTON_OK);
				goto _raus
			end;
		werror:=false;
		if TexelApp.setupbuffer.bak=bf_Checked then
			if Exist(fname) then
				begin
					fn2:=GetBackupFilename(fname);
					if Exist(fn2) then fdelete(fn2);
					frename(fname,fn2);
					TexelApp.UpdateFile(fn2,0)
				end;
		res:=fcreate(fname,0);
		if res<0 then
			begin
				Application^.Alert(p,1,STOP,MESSAGE_SAVE_WPROT,BUTTON_OK);
				goto _raus
			end;
		hdl:=integer(res);
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _unreg
			end;
		{$IFDEF LITE}
		if (p^.Parms.Rows>=MAXLINES) or (p^.Parms.Columns>=MAXCOLUMNS) then goto _unreg;
		{$ENDIF}
		{$IFNDEF DEMO}
		test:=true;
		pack_hor;
		hsize:=packsize;
		pack_ver;
		vsize:=packsize;
		test:=false;
		bufcnt:=0;
		nctrl:=NT_ENDOFDATA;
		lctrl:=NT_LIST_EMPTY;
		passmask:=0;
		with header do
			begin
				Magic:=TEXELMAGIC;
				Version:=TEXELVER;
				Compatible:=txlver;
				if hsize>vsize then PackAlgo:=PA_VERTICAL
				else
					PackAlgo:=PA_HORIZONTAL;
				Resvd1:=0;
				Resvd2:=0;
				Resvd3:=0;
				Resvd4:=0
			end;
		header.Release:=RELEASE;
		if bwrite(header,sizeof(TTexelHeader)) then goto _unreg;
		fillchar(head2,sizeof(head2),0);
		if p^.infobuf.Encrypt=bf_Checked then head2.CryptFlag:=1;
		head2.RSeed:=randseed xor p^.PassWord.Mask;
		head2.PassFlag:=p^.PassWord.Flag;
		head2.PassCode:=p^.PassWord.Code;
		if bwrite(head2,sizeof(TTexelHead2)) then goto _unreg;
		bwrite(dummy,-1);
		coffs:=0;
		pe:=p^.Embedded;
		while pe<>nil do
			begin
				if (pe^.GetType<>EMB_TYPE_CHECKBOX) or (txlver>=43) then inc(coffs);
				pe:=pe^.Next
			end;
		if bfwrite(coffs,2) then goto _unreg;
		if coffs>0 then
			begin
				pe:=p^.Embedded;
				while pe<>nil do
					begin
						objtyp:=pe^.GetType;
						if (objtyp=EMB_TYPE_CHECKBOX) and (txlver<43) then goto _elmnext;
						if bfwrite(objtyp,2) then goto _unreg;
						dtxt:=pe^.GetFile;
						if bfwrite(dtxt,length(dtxt)+1) then goto _unreg;
						if pe^.IsEmbedded then dummy:=pe^.DataLen
						else
							dummy:=0;
						if bfwrite(dummy,4) then goto _unreg;
						if dummy>0 then
							if bfwrite(pe^.Data^,dummy) then goto _unreg;
						if bfwrite(pe^.oabuf,sizeof(pe^.oabuf)) then goto _unreg;
						if bfwrite(pe^.XPos_mm100,4) then goto _unreg;
						if bfwrite(pe^.YPos_mm100,4) then goto _unreg;
						if bfwrite(pe^.Width_mm100,4) then goto _unreg;
						if bfwrite(pe^.Height_mm100,4) then goto _unreg;
						prp:=pe^.IsProportional;
						if bfwrite(prp,sizeof(boolean)) then goto _unreg;
						prp:=pe^.IsEmbedded;
						if bfwrite(prp,sizeof(boolean)) then goto _unreg;
						if txlver>34 then
							begin
								prp:=pe^.CanPrint;
								if bfwrite(prp,sizeof(boolean)) then goto _unreg;
								prp:=pe^.IsLocked;
								if bfwrite(prp,sizeof(boolean)) then goto _unreg;
							end;
						case objtyp of
						EMB_TYPE_IMG:
							begin
								if bfwrite(PEmbeddedIMG(pe)^.skalieren,sizeof(boolean)) then goto _unreg;
							end;
						EMB_TYPE_TEXT:
							begin
								if bfwrite(PEmbeddedText(pe)^.umbruch,sizeof(boolean)) then goto _unreg;
								if bfwrite(PEmbeddedText(pe)^.txOffs,2) then goto _unreg;
								if bfwrite(PEmbeddedText(pe)^.tyOffs,2) then goto _unreg
							end;
						EMB_TYPE_TAD:
							begin
								if bfwrite(PEmbeddedTAD(pe)^.dbvalid,sizeof(boolean)) then goto _unreg;
								if PEmbeddedTAD(pe)^.dbvalid then
									if bfwrite(PEmbeddedTAD(pe)^.diabuf,sizeof(TDiagrammBuf)) then goto _unreg
							end;
						EMB_TYPE_CHECKBOX:
							begin
								if bfwrite(PEmbeddedCheckBox(pe)^.ocbbuf,sizeof(TEmbedCheckBuf)) then goto _unreg;
							end
						end;
						_elmnext:
						pe:=pe^.Next
					end
			end;
		if p^.infobuf.Encrypt=bf_Checked then passmask:=1;
		oldtb:=p^.TransferBuffer;
		p^.TransferBuffer:=@newtb;
		p^.TransferData(tf_GetData);
		p^.TransferBuffer:=oldtb;
		p^.GetRealCurr(p^.Parms.CurrSize);
		p^.Parms.ScrlXPos:=p^.Scroller^.XPos;
		p^.Parms.ScrlYPos:=p^.Scroller^.YPos;
		if p^.Class.ToolbarTree<>nil then p^.Parms.Toolbar:=bf_Checked
		else
			p^.Parms.Toolbar:=bf_Unchecked;
		newtb.border:=0; { ... }
		newtb.resvd1:=0;
		newtb.resvd2:=0;
		newtb.resvd3:=0;
		newtb.resvd4:=0;
		newtb.font:=p^.GetFontIndex;
		newtb.size:=p^.GetFontSize;
		newsb:=p^.sheetbuffer;
		newsb.font:=p^.GetStdFontIndex;
		newsb.size:=p^.GetStdFontSize;
		if bwrite(p^.Parms,sizeof(TTexelParms)) then goto _unreg;
		if bwrite(newtb,sizeof(TDialogBuffer)) then goto _unreg;
		if txlver<42 then
			begin
				if bwrite(newsb.font,sizeof(TSheetBuffer)-12) then goto _unreg;
			end
		else
			if bwrite(newsb.font,sizeof(TSheetBuffer)-10) then goto _unreg;
		if bwrite(p^.zwbuf,sizeof(TZielBuf)) then goto _unreg;
		if bwrite(p^.diagrammbuf,sizeof(TDiagrammBuf)) then goto _unreg;
		if txlver<34 then
			begin
				if bwrite(p^.exportbuf,sizeof(TExportBuf)-12) then goto _unreg;
			end
		else
			if txlver<39 then
				begin
					if bwrite(p^.exportbuf,sizeof(TExportBuf)-10) then goto _unreg;
				end
			else
				if txlver<44 then
					begin
						if bwrite(p^.exportbuf,sizeof(TExportBuf)-2) then goto _unreg;
					end
				else
					if bwrite(p^.exportbuf,sizeof(TExportBuf)) then goto _unreg;
		if bwrite(p^.sortbuf,sizeof(TSortBuf)) then goto _unreg;
		if bwrite(p^.infobuf,sizeof(TInfoBuf)-4) then goto _unreg;
		if bwrite(p^.findbuf,sizeof(TFindBuf)) then goto _unreg;
		if bwrite(p^.replacebuf,sizeof(TReplaceBuf)) then goto _unreg;
		if bwrite(p^.fillbuf,sizeof(TFillBuffer)) then goto _unreg;
		coffs:=0;
		if bwrite(coffs,2) then goto _unreg;
		if bwrite(p^.PRow^,(p^.Parms.Rows+1) shl 1) then goto _unreg;
		if bwrite(p^.PCol^,(p^.Parms.Columns+1) shl 1) then goto _unreg;
		l:=0;
		for q:=0 to p^.Parms.Columns do
			begin
				if p^.PColNames^[q]<>nil then
					begin
						if bwrite(PString(p^.PColNames^[q])^,length(PString(p^.PColNames^[q])^)+1) then goto _unreg
					end
				else
					if bwrite(l,1) then goto _unreg
			end;
		if bwrite(p^.PRowFlags^,p^.Parms.Rows+1) then goto _unreg;
		if bwrite(p^.PColFlags^,p^.Parms.Columns+1) then goto _unreg;
		if header.PackAlgo=PA_VERTICAL then
			begin
				if pack_ver then goto _unreg
			end
		else
			if pack_hor then goto _unreg;
		coffs:=65535;
		if bwrite(coffs,2) then goto _unreg;
		if p^.Parameter<>nil then coffs:=p^.Parameter^.Count
		else
			coffs:=0;
		if bwrite(coffs,2) then goto _unreg;
		l:=0;
		if coffs>0 then
			for q:=0 to coffs-1 do
				begin
					pp:=p^.Parameter^.At(q);
					if pp^.Name<>nil then
						begin
							if bwrite(pp^.Name^,length(pp^.Name^)+1) then goto _unreg
						end
					else
						if bwrite(l,1) then goto _unreg;
					if pp^.Txt<>nil then
						begin
							if bwrite(pp^.Txt^,length(pp^.Txt^)+1) then goto _unreg
						end
					else
						if bwrite(l,1) then goto _unreg;
					if pp^.Descr<>nil then
						begin
							if bwrite(pp^.Descr^,length(pp^.Descr^)+1) then goto _unreg
						end
					else
						if bwrite(l,1) then goto _unreg
				end;
		if p^.UsrFormats<>nil then coffs:=p^.UsrFormats^.Count
		else
			coffs:=0;
		if bwrite(coffs,2) then goto _unreg;
		l:=0;
		if coffs>0 then
			for q:=0 to coffs-1 do
				begin
					pfm:=p^.UsrFormats^.At(q);
					if bwrite(pfm^.Index,2) then goto _unreg;
					if pfm^.Name<>nil then
						begin
							if bwrite(pfm^.Name^,length(pfm^.Name^)+1) then goto _unreg
						end
					else
						if bwrite(l,1) then goto _unreg
				end;
		if p^.BlockHistory<>nil then coffs:=p^.BlockHistory^.Count
		else
			coffs:=0;
		if bwrite(coffs,2) then goto _unreg;
		l:=0;
		if coffs>0 then
			for q:=0 to coffs-1 do
				begin
					ps:=p^.BlockHistory^.At(q);
					if ps<>nil then
						begin
							if bwrite(ps^,length(ps^)+1) then goto _unreg
						end
					else
						if bwrite(l,1) then goto _unreg
				end;
		dummy:=0;
		if p^.wnd_prnt_set<>nil then
			if p^.wnd_prnt_set^.magic='pset' then dummy:=p^.wnd_prnt_set^.len;
		if bwrite(dummy,4) then goto _unreg;
		if dummy>0 then
			if bwrite(p^.wnd_prnt_set^,dummy) then goto _unreg;
		if txlver>35 then
			if bwrite(p^.prnRangeFlag,2) then goto _unreg;
		coffs:=p^.pfbox^.List^.Count;
		if bwrite(coffs,2) then goto _unreg;
		l:=0;
		if coffs>0 then
			for q:=0 to coffs-1 do
				begin
					pf:=PFont(p^.pfbox^.List^.At(q));
					if pf^.Name<>nil then
						begin
							fn2:=StrPTrimF(pf^.Name^);
							if bwrite(fn2,length(fn2)+1) then goto _unreg
						end
					else
						if bwrite(l,1) then goto _unreg;
					if bwrite(pf^.Index,2) then goto _unreg
				end;
		coffs:=0;
		if bwrite(coffs,2) then goto _unreg;
		coffs:=0;
		if bwrite(coffs,2) then goto _unreg;
		if bwrite(coffs,2) then goto _unreg;
		bwrite(dummy,-1);
		p^.infobuf.Version:=TEXELVER;
		p^.infobuf.Release:=RELEASE;
		Save:=true;
		TexelApp.UpdateFile(fname,-p^.GetOLGAGroup-1);
		{$ENDIF}
		_unreg:
		fclose(hdl);
		if werror then
			begin
				fdelete(fname);
				Application^.Alert(p,1,STOP,MESSAGE_SAVE_DISKFULL,BUTTON_OK)
			end
		else
			begin
				p^.ClearDirty;
			end;
		_raus:
		if buf<>nil then freemem(buf,bufsize);
		ArrowMouse
	end;


procedure TSaveAs.Work;
	var fname: string;

	begin
		fname:='';
		if XFileSelect(PCalcWindow(Parent),FSELTITLE_SAVEAS,'*.'+TEXELEXTENSION,TexelApp.LastPath[0],fname,1,FSEL_SAVE,false,PCalcWindow(Parent)^.closing) then
			begin
				TexelApp.LastFile[0]:=fname;
				SaveAs(TexelApp.LastPath[0]+TexelApp.LastFile[0],0)
			end
	end;


procedure TSaveAs.SaveAs(const fname: string; flag: integer);
	var p      : PCalcWindow;
	    oldname: string;

	begin
		if length(fname)=0 then exit;
		p:=PCalcWindow(Parent);
		if Exist(fname) then
			begin
				if p^.closing then
					begin
						p^.alertret:=Application^.Alert(p,1,WAIT,MESSAGE_SAVEAS_EXIST1+CompressPath(fname,78)+MESSAGE_SAVEAS_EXIST2,BUTTON_YESNOCANCEL);
						if p^.alertret<>1 then exit
					end
				else
					if Application^.Alert(p,1,WAIT,MESSAGE_SAVEAS_EXIST1+CompressPath(fname,78)+MESSAGE_SAVEAS_EXIST2,BUTTON_YESNO)<>1 then exit
			end;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				exit
			end;
		oldname:=p^.GetWindowFilename;
		if flag=1 then
			begin
				p^.sheetbuffer.vorlage:=bf_Unchecked;
				if PSave(p^.save)^.Save(fname,TEXELCOMPAT) then
					begin
						if Application^.Alert(p,1,WAIT,MESSAGE_SAVEAS_NEW1+CompressPath(fname,78)+MESSAGE_SAVEAS_NEW2,BUTTON_YESNO)=1 then p^.SetWindowFileName(fname)
						else
							p^.sheetbuffer.vorlage:=bf_Checked
					end
				else
					p^.sheetbuffer.vorlage:=bf_Checked;
			end
		else
			if p^.sheetbuffer.vorlage=bf_Checked then
				begin
					if length(oldname)=0 then
						begin
							if PSave(p^.save)^.Save(fname,TEXELCOMPAT) then p^.SetWindowFileName(fname)
						end
					else
						begin
							if Application^.Alert(p,2,WAIT,MESSAGE_SAVE_FORMDOC,BUTTON_FORMDOC)=2 then p^.sheetbuffer.vorlage:=bf_Unchecked;
							if PSave(p^.save)^.Save(fname,TEXELCOMPAT) then
								begin
									if Application^.Alert(p,1,WAIT,MESSAGE_SAVEAS_NEW1+CompressPath(fname,78)+MESSAGE_SAVEAS_NEW2,BUTTON_YESNO)=1 then p^.SetWindowFileName(fname)
									else
										p^.sheetbuffer.vorlage:=bf_Checked
								end
							else
								p^.sheetbuffer.vorlage:=bf_Checked;
						end
				end
			else
				if PSave(p^.save)^.Save(fname,TEXELCOMPAT) then
					begin
						if length(oldname)=0 then p^.SetWindowFileName(fname)
						else
							if Application^.Alert(p,1,WAIT,MESSAGE_SAVEAS_NEW1+CompressPath(fname,78)+MESSAGE_SAVEAS_NEW2,BUTTON_YESNO)=1 then p^.SetWindowFileName(fname)
					end
	end;

end.