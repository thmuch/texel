unit txprocs;
{ 1998-07-02 }

interface

uses

	OTypes,OWindows,txtypes,txcollec;


function InitKeyTab: boolean;
function arcsin(x: TNumber): TNumber;
procedure LGRtoGR(r1: LGRECT; var r2: GRECT);
procedure LGRtoA2(var r: LGRECT);
procedure LA2toGR(var r: LGRECT);
function llrc_intersect(r1: LGRECT; var r2: LGRECT): boolean;
function lrc_intersect(r1: LGRECT; var r2: GRECT): boolean;
function CreatePassCode(pword: string; var pmask: longint): longint;
function CheckPassWord(pword: string; pcode: longint; var pmask: longint): boolean;
function KeyCorrect(name,key: string): boolean;
procedure DemoAlert(p: PWindow);
procedure ScanFonts(handle,anz: integer; var fcoll: PFontCollection);
procedure ScanConst(const datapath: string; var pcoll: PParameterCollection);
{$IFDEF LITE}
function pci_serno: longint;
{$ENDIF}
{$IFNDEF BETA}
function decode_name(c: PChar): string;
{$ENDIF}


var

	pkt: PKEYT;




implementation

uses

	Strings,Tos,Gem,OProcs,txlang,txtypes,txnewvdi;



function InitKeyTab: boolean;

	begin
		InitKeyTab:=false;
		if GetCookie('KEYT',longint(pkt)) then
			if pkt<>nil then
				if pkt^.Magic='KEYT' then
					if pkt^.Size>=40 then InitKeyTab:=true
	end;


function arcsin(x: TNumber): TNumber;

	begin
		if abs(x)<>1.0 then
			begin
				x:=frac(x);
				arcsin:=arctan(x/sqrt(1-sqr(x)))
			end
		else
			if x=1.0 then arcsin:=ev_pihalbe
			else
				arcsin:=-ev_pihalbe
	end;


procedure LGRtoGR(r1: LGRECT; var r2: GRECT);

	begin
		r2.X:=integer(Max(Min(r1.X,32767),-32768));
		r2.Y:=integer(Max(Min(r1.Y,32767),-32768));
		r2.W:=integer(Max(Min(r1.W,32767),-32768));
		r2.H:=integer(Max(Min(r1.H,32767),-32768));
		GRtoA2(r2)
	end;


procedure LGRtoA2(var r: LGRECT);

	begin
		with r do
			begin
				X1:=X;
				Y1:=Y;
				X2:=X+W-1;
				Y2:=Y+H-1
			end
	end;


procedure LA2toGR(var r: LGRECT);

	begin
		with r do
			begin
				X:=X1;
				Y:=Y1;
				W:=X2+1-X;
				H:=Y2+1-Y
			end
	end;


function llrc_intersect(r1: LGRECT; var r2: LGRECT): boolean;
	var x,y,w,h: longint;

	begin
		x:=Max(r2.X,r1.X);
		y:=Max(r2.Y,r1.Y);
		w:=Min(r2.X+r2.W,r1.X+r1.W);
		h:=Min(r2.Y+r2.H,r1.Y+r1.H);
		r2.X:=x;
		r2.Y:=y;
		r2.W:=w-x;
		r2.H:=h-y;
		if (w>x) and (h>y) then
			begin
				LGRtoA2(r2);
				llrc_intersect:=true
			end
		else
			llrc_intersect:=false
	end;


function lrc_intersect(r1: LGRECT; var r2: GRECT): boolean;
	var x,y,w,h: longint;

	begin
		x:=Max(longint(r2.X),r1.X);
		y:=Max(longint(r2.Y),r1.Y);
		w:=Min(longint(r2.X)+longint(r2.W),r1.X+r1.W);
		h:=Min(longint(r2.Y)+longint(r2.H),r1.Y+r1.H);
		r1.X:=x;
		r1.Y:=y;
		r1.W:=w-x;
		r1.H:=h-y;
		LGRtoGR(r1,r2);
		lrc_intersect:=(w>x) and (h>y)
	end;


{$IFDEF LITE}
function pci_serno: longint;
	var pci  : PPCI;
	    serno: longint;

	begin
		pci_serno:=0;
		if GetCookie('_PCI',longint(pci)) then
			if pci<>nil then
				if ((pci^.version and $ffff0000)=$00010000) then
					if assigned(pci^.get_machine_id) then
						begin
							serno:=pci^.get_machine_id;
							if ((serno and $ff000000)=$01000000) then pci_serno:=(serno and $00ffffff)
						end
	end;
{$ENDIF}


{$IFNDEF BETA}
function decode_name(c: PChar): string;
{$IFDEF LITE}
	begin
		decode_name:='Milan-Benutzer'
	end;
{$ELSE}
	var s: string;
	    q: integer;

	begin
		s:=StrPPas(c);
		if length(s)>0 then
			for q:=1 to length(s) do s[q]:=chr(ord(s[q]) xor 255);
		decode_name:=StrPTrimF(s)
	end;
{$ENDIF}
{$ENDIF}


function CreatePassCode(pword: string; var pmask: longint): longint;
	var q  : integer;
	    ret: longint;

	begin
		pmask:=0;
		CreatePassCode:=0;
		if length(pword)=0 then exit;
		ret:=0;
		for q:=1 to length(pword) do
			begin
				ret:=(((ret shl 6) xor ((ret shr 24) and $000ff000)) xor ord(pword[q]));
				pmask:=(((pmask shl 5) xor ((pmask shr 22) and $0000ff00)) xor ord(pword[q]))
			end;
		CreatePassCode:=ret
	end;


function CheckPassWord(pword: string; pcode: longint; var pmask: longint): boolean;

	begin
		CheckPassWord:=(CreatePassCode(pword,pmask)=pcode)
	end;


function KeyCorrect(name,key: string): boolean;
{$IFDEF BETA}
	var compkey: string;
	    q,l    : integer;

	function c2s(b1,b2: byte): string;
		var b: byte;

		begin
			b:=((b1+13) mod 256) xor ((b2+37) mod 256);
			c2s:=chr((b and 15)+65)+chr(((b shr 3) and 15)+65)
		end;

	begin
		KeyCorrect:=false;
		if length(name)<3 then exit;
		if length(key)<4 then exit;
		if length(key)<length(name) then exit;
		if gettime<BUILT then exit;
		if gettime>EXPIRE then exit;
		compkey:='';
		if odd(length(name)) then name:=name+name[2];
		l:=length(name);
		for q:=1 to (l shr 1) do compkey:=compkey+c2s(ord(name[q]),ord(name[l+q-q]));
		KeyCorrect:=(key=compkey) and not(KeyCorrect('',''));
		{$IFDEF DEMO}
		KeyCorrect:=false
		{$ENDIF}
	end;
{$ELSE}
{$IFDEF LITE}
	var dummy: longint;

	begin
		KeyCorrect:=(GetCookie('_MIL',dummy) and (pci_serno<>0))
	end;
{$ELSE}
	label _raus;

	var s: string;

	begin
		KeyCorrect:=false;
		if StrPPas(ash_name)=StrPFill(30,'n') then goto _raus;
		if StrPPas(ash_firma)=StrPFill(30,'f') then exit;
		if StrPPas(ash_serno)=StrPFill(10,'s') then goto _raus;
		if (length(name)>0) or (length(key)>0) then exit;
		if (length(decode_name(ash_name))=0) and (length(decode_name(ash_firma))=0) then goto _raus;
		s:=decode_name(ash_serno);
		if length(s)<>10 then exit;
		if StrPLeft(s,2)<>'27' then goto _raus;
		if s[9]<>'0' then exit;
		if StrPRight(s,8)='00000000' then goto _raus;
		KeyCorrect:=((atol(StrPMid(s,3,6)) and 5)=(ord(s[10])-48)) and not(KeyCorrect('a','B'));
		exit;
		_raus:
		KeyCorrect:=false
	end;
{$ENDIF}
{$ENDIF}


procedure DemoAlert(p: PWindow);

	begin
		if Application=nil then exit;
		{$IFDEF DEMO}
		Application^.Alert(p,1,NOTE,MESSAGE_DEMO_DEMO,BUTTON_OK)
		{$ELSE}
		{$IFDEF LITE}
		Application^.Alert(p,1,NOTE,MESSAGE_DEMO_MILAN,BUTTON_OK)
		{$ELSE}
		Application^.Alert(p,1,NOTE,MESSAGE_DEMO_UNREG,BUTTON_OK)
		{$ENDIF}
		{$ENDIF}
	end;


procedure ScanFonts(handle,anz: integer; var fcoll: PFontCollection);
	var q,w,asked,
	    got,dval : integer;
	    nfnt     : string;
	    outl     : boolean;
	    fsiz     : array [0..127] of integer;
	    pfnt     : PFont;
	    xfntinfo : XFNT_INFO;

	begin
		BusyMouse;
		new(fcoll,Init(50,50));
		if fcoll<>nil then
			begin
				fcoll^.CaseSensitive:=false;
				if anz>0 then
					for q:=1 to anz do
						begin
							new(pfnt);
							if pfnt<>nil then
								begin
									outl:=vqtName(handle,q,nfnt,pfnt^.Index);
									xfntinfo.size:=sizeof(XFNT_INFO);
									if vqtXFntInfo(handle,pfnt^.Index,1,@xfntinfo) then nfnt:=StrPTrimF(StrPas(xfntinfo.font_name));
									pfnt^.Sizes:=nil;
									if outl then pfnt^.SizeCount:=0
									else
										begin
											pfnt^.SizeCount:=0;
											vst_font(handle,pfnt^.Index);
											asked:=999;
											got:=asked;
											while (got<=asked) and (pfnt^.SizeCount<=127) do
												begin
													asked:=got-1;
													got:=vst_point(handle,asked,dval,dval,dval,dval);
													fsiz[pfnt^.SizeCount]:=got;
													inc(pfnt^.SizeCount)
												end;
											if pfnt^.SizeCount=128 then pfnt^.SizeCount:=0
											else
												begin
													dec(pfnt^.SizeCount);
													getmem(pfnt^.Sizes,pfnt^.SizeCount shl 1);
													if pfnt^.Sizes=nil then pfnt^.SizeCount:=0
													else
														for w:=0 to pfnt^.SizeCount-1 do pfnt^.Sizes^[w]:=fsiz[w]
												end
										end;
									pfnt^.Name:=NewStr('  '+nfnt+' '#0);
									fcoll^.Insert(pfnt)
								end
						end
			end;
		SetSystemFont(handle,q,q,q,q);
		ArrowMouse
	end;


procedure ScanConst(const datapath: string; var pcoll: PParameterCollection);
	label _raus,_weiter;

	var pp         : PParameter;
	    ttxt,cname,
	    ctxt,cdescr: string;
	    buf        : PByteArray;
	    res,w,
	    bufsize    : longint;
	    q,hdl      : integer;

	begin
		new(pcoll,Init(20,10));
		if pcoll=nil then exit;
		pcoll^.Sort:=false;
		buf:=GetMemBuffer(16384,128,bufsize);
		if buf=nil then exit;
		BusyMouse;
		if Exist(datapath+TEXELVAL) then
			begin
				res:=fopen(datapath+TEXELVAL,FO_READ);
				if res<0 then goto _weiter;
				hdl:=integer(res);
				ttxt:='';
				repeat
					res:=fread(hdl,bufsize,buf);
					if res>0 then
						for w:=0 to res-1 do
							if buf^[w]=CR then
								begin
									StrPTrim(ttxt);
									if length(ttxt)>0 then
										if not(ttxt[1] in [';','#']) then
											begin
												new(pp);
												if pp<>nil then
													begin
														cdescr:='';
														q:=pos(' ',ttxt);
														if q>0 then
															begin
																cname:=StrPLeft(ttxt,q-1);
																ttxt:=StrPTrimF(StrPRight(ttxt,length(ttxt)-q));
																q:=pos(' ',ttxt);
																if q>0 then
																	begin
																		ctxt:=StrPLeft(ttxt,q-1);
																		cdescr:=StrPTrimF(StrPRight(ttxt,length(ttxt)-q))
																	end
																else
																	ctxt:=ttxt;
																pp^.Value:=atof(ctxt);
																pp^.Name:=NewStr(cname);
																pp^.ListName:=NewStr('  '+cname+' '#0);
																pp^.Txt:=NewStr(ctxt);
																pp^.Descr:=NewStr(cdescr);
																pp^.Predef:=true;
																if (pp^.Name=nil) or (pp^.Txt=nil) then
																	begin
																		DisposeStr(pp^.Name);
																		DisposeStr(pp^.ListName);
																		DisposeStr(pp^.Txt);
																		DisposeStr(pp^.Descr);
																		dispose(pp)
																	end
																else
																	pcoll^.Insert(pp)
															end
														else
															dispose(pp)
													end
											end;
									ttxt:=''
								end
							else
								if buf^[w]>=32 then ttxt:=ttxt+chr(buf^[w])
				until res<>bufsize;
				fclose(hdl)
			end;
		_weiter:
		if Exist(datapath+TEXELUSRVAL) then
			begin
				res:=fopen(datapath+TEXELUSRVAL,FO_READ);
				if res<0 then goto _raus;
				hdl:=integer(res);
				ttxt:='';
				repeat
					res:=fread(hdl,bufsize,buf);
					if res>0 then
						for w:=0 to res-1 do
							if buf^[w]=CR then
								begin
									StrPTrim(ttxt);
									if length(ttxt)>0 then
										if not(ttxt[1] in [';','#']) then
											begin
												new(pp);
												if pp<>nil then
													begin
														cdescr:='';
														q:=pos(' ',ttxt);
														if q>0 then
															begin
																cname:=StrPLeft(ttxt,q-1);
																ttxt:=StrPTrimF(StrPRight(ttxt,length(ttxt)-q));
																q:=pos(' ',ttxt);
																if q>0 then
																	begin
																		ctxt:=StrPLeft(ttxt,q-1);
																		cdescr:=StrPTrimF(StrPRight(ttxt,length(ttxt)-q))
																	end
																else
																	ctxt:=ttxt;
																pp^.Value:=atof(ctxt);
																pp^.Name:=NewStr(cname);
																pp^.ListName:=NewStr('  '+cname+' '#0);
																pp^.Txt:=NewStr(ctxt);
																pp^.Descr:=NewStr(cdescr);
																pp^.Predef:=true;
																if (pp^.Name=nil) or (pp^.Txt=nil) then
																	begin
																		DisposeStr(pp^.Name);
																		DisposeStr(pp^.ListName);
																		DisposeStr(pp^.Txt);
																		DisposeStr(pp^.Descr);
																		dispose(pp)
																	end
																else
																	pcoll^.Insert(pp)
															end
														else
															dispose(pp)
													end
											end;
									ttxt:=''
								end
							else
								if buf^[w]>=32 then ttxt:=ttxt+chr(buf^[w])
				until res<>bufsize;
				fclose(hdl)
			end;
		_raus:
		freemem(buf,bufsize);
		ArrowMouse
	end;


begin
	pkt:=nil;
end.