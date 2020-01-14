unit txnewvdi;
{ 1998-06-26 }

interface

uses

	Gem,OTypes,txtypes;


function vqtExtDevinfo(handle,devid: integer; var devstr,devtitle: string): boolean;
function vqtDevinfo(handle,devid: integer; var devstr,devtitle: string): boolean;
function vqtName(handle,element_num: integer; var name: string; var index: integer): boolean;
function vqtXFntInfo(handle,id,flags: integer; pxfnt: PXFNT_INFO): boolean;
function vs_document_info(handle,typ: integer; s: string): boolean;
procedure vr_transfer_bits(handle: integer; src_bm,dst_bm: PBITMAPPtr; pxyarray: ARRAY_8; mode: integer);
procedure vqt_real_extent(handle,x,y: integer; const calcString: string; var extent: ARRAY_8);
function vOrient(handle,orientation: integer): integer;
function vCopies(handle,copies: integer): integer;
procedure vmCoords(handle,llx,lly,urx,ury: integer);
{$IFNDEF NVDI5}
procedure vqt_my_extent(handle: integer; const calcString: string; var extent: ARRAY_8);
{$ENDIF}



implementation

uses

	Strings,OProcs{$IFNDEF NVDI5},OWindows{$ENDIF};


function vqtExtDevinfo(handle,devid: integer; var devstr,devtitle: string): boolean;
	var dummy: string;

	begin
		{$IFNDEF NVDI5}
		if NVDIVersion<$0300 then vqtExtDevinfo:=false
		else
		{$ENDIF}
			with VDI_pb do
				begin
					control^[0]:=248;
					control^[1]:=0;
					control^[3]:=7;
					control^[5]:=4242;
					control^[6]:=handle;
					intin^[0]:=devid;
					intin^[1]:=integer(HiWord(@dummy[1]));
					intin^[2]:=integer(LoWord(@dummy[1]));
					intin^[3]:=integer(HiWord(@devstr[1]));
					intin^[4]:=integer(LoWord(@devstr[1]));
					intin^[5]:=integer(HiWord(@devtitle[1]));
					intin^[6]:=integer(LoWord(@devtitle[1]));
					vdi(@VDI_pb);
					if intout^[0]=0 then vqtExtDevinfo:=false
					else
						begin
							vqtExtDevinfo:=true;
							devstr[0]:=chr(StrLen(@devstr[1]));
							devtitle[0]:=chr(StrLen(@devtitle[1]))
						end
				end
	end;


function vqtDevinfo(handle,devid: integer; var devstr,devtitle: string): boolean;
	var q: integer;

	begin
		devstr:='';
		devtitle:='';
		vqtDevinfo:=false;
		{$IFNDEF NVDI5}
		if Application^.SpeedoActive then
		{$ENDIF}
			with VDI_pb do
				begin
					control^[0]:=248;
					control^[1]:=0;
					control^[3]:=1;
					control^[5]:=0;
					control^[6]:=handle;
					intin^[0]:=devid;
					vdi(@VDI_pb);
					if (control^[4]<=0) or (intout^[0]=0) then exit;
					vqtDevinfo:=true;
					for q:=0 to control^[4]-1 do devstr:=devstr+chr(intout^[q]);
					devtitle:=StrPPas(@ptsout^[1]);
					StrPTrim(devstr);
					devtitle:=StrPLeft(StrPTrimF(devtitle),42)
				end
	end;


function vqtName(handle,element_num: integer; var name: string; var index: integer): boolean;
	var q: integer;

	begin
		with VDI_pb do
			begin
				control^[0]:=130;
				control^[1]:=0;
				control^[3]:=1;
				control^[6]:=handle;
				intin^[0]:=element_num;
				vdi(@VDI_pb);
				index:=intout^[0];
				name:='';
				q:=1;
				while (q<33) and (intout^[q]<>0) do
					begin
						name:=name+chr(intout^[q]);
						inc(q)
					end;
				StrPTrim(name);
				vqtName:=(control^[4]>=34) and (intout^[33]<>0) {$IFNDEF NVDI5}and Application^.SpeedoActive{$ENDIF};
			end
	end;


function vqtXFntInfo(handle,id,flags: integer; pxfnt: PXFNT_INFO): boolean;

	begin
		{$IFNDEF NVDI5}
		if NVDIVersion<$0302 then vqtXFntInfo:=false
		else
		{$ENDIF}
			with VDI_pb do
				begin
					control^[0]:=229;
					control^[1]:=0;
					control^[3]:=1;
					control^[5]:=0;
					control^[6]:=handle;
					intin^[0]:=flags;
					intin^[1]:=id;
					intin^[2]:=0;
					intin^[3]:=integer(HiWord(pxfnt));
					intin^[4]:=integer(LoWord(pxfnt));
					vdi(@VDI_pb);
					vqtXFntInfo:=(intout^[0]<>0)
				end
	end;


function vs_document_info(handle,typ: integer; s: string): boolean;
	var q: integer;

	begin
		vs_document_info:=false;
		{$IFNDEF NVDI5}
		if NVDIVersion<>0 then
		{$ENDIF}
			if length(s)>0 then
				begin
					s:=StrPLeft(s,intin_max-1);
					with VDI_pb do
						begin
							control^[0]:=5;
							control^[1]:=0;
							control^[3]:=length(s)+1;
							control^[5]:=2103;
							control^[6]:=handle;
							intin^[0]:=typ;
							for q:=1 to length(s) do intin^[q]:=ord(s[q]);
							vdi(@VDI_pb);
							vs_document_info:=(intout^[0]<>0)
						end
				end
	end;


procedure vr_transfer_bits(handle: integer; src_bm,dst_bm: PBITMAPPtr; pxyarray: ARRAY_8; mode: integer);
	var q: integer;

	begin
		with VDI_pb do
			begin
				control^[0]:=170;
				control^[1]:=4;
				control^[3]:=4;
				control^[5]:=0;
				control^[6]:=handle;
				control^[7]:=integer(HiWord(src_bm));
				control^[8]:=integer(LoWord(src_bm));
				control^[9]:=integer(HiWord(dst_bm));
				control^[10]:=integer(LoWord(dst_bm));
				control^[11]:=0;
				control^[12]:=0;
				intin^[0]:=mode;
				intin^[1]:=0;
				intin^[2]:=0;
				intin^[3]:=0;
				for q:=0 to 7 do ptsin^[q]:=pxyarray[q];
				vdi(@VDI_pb)
			end
	end;


procedure vqt_real_extent(handle,x,y: integer; const calcString: string; var extent: ARRAY_8);
	var q,len: integer;

	begin
		len:=length(calcString);
		with VDI_pb do
			begin
				control^[0]:=240;
				control^[1]:=1;
				control^[3]:=len;
				control^[5]:=4200;
				control^[6]:=handle;
				ptsin^[0]:=x;
				ptsin^[1]:=y;
				if len>0 then
					for q:=1 to len do intin^[q-1]:=ord(calcString[q]);
				vdi(@VDI_pb);
				for q:=0 to 7 do extent[q]:=ptsout^[q]
			end
	end;


{$IFNDEF NVDI5}

procedure vqt_my_extent(handle: integer; const calcString: string; var extent: ARRAY_8);

	begin
		if NVDIVersion>=$0300 then vqt_real_extent(handle,0,0,calcString,extent)
		else
			vqt_f_extent(handle,calcString,extent)
	end;

{$ENDIF}


function vOrient(handle,orientation: integer): integer;

	begin
		with VDI_pb do
			begin
				control^[0]:=5;
				control^[1]:=0;
				control^[3]:=1;
				control^[4]:=0;
				control^[5]:=27;
				control^[6]:=handle;
				intin^[0]:=orientation
			end;
		vdi(@VDI_pb);
		if VDI_pb.control^[4]=1 then vOrient:=VDI_pb.intout^[0]
		else
			vOrient:=0
	end;


function vCopies(handle,copies: integer): integer;

	begin
		with VDI_pb do
			begin
				control^[0]:=5;
				control^[1]:=0;
				control^[3]:=1;
				control^[4]:=0;
				control^[5]:=28;
				control^[6]:=handle;
				intin^[0]:=copies
			end;
		vdi(@VDI_pb);
		if VDI_pb.control^[4]=1 then vCopies:=VDI_pb.intout^[0]
		else
			vCopies:=0
	end;


procedure vmCoords(handle,llx,lly,urx,ury: integer);

	begin
		with VDI_pb do
			begin
				control^[0]:=5;
				control^[1]:=0;
				control^[3]:=5;
				control^[5]:=99;
				control^[6]:=handle;
				intin^[0]:=1;
				intin^[1]:=llx;
				intin^[2]:=lly;
				intin^[3]:=urx;
				intin^[4]:=ury
			end;
		vdi(@VDI_pb)
	end;

end.