unit txdhst;
{ 1998-07-03 }

interface

uses

	OTypes,OWindows;


type

	PAbruf = ^TAbruf;
	TAbruf = object(TSubMenu)
		cpw,
		cph,
		Count: integer;
		Dirty: boolean;
		Files: array [0..9] of PString;
		constructor Init(AParent: PEventObject; mNum,popTree,popIndex: integer);
		procedure HandleMenu(Indx: integer); virtual;
		procedure Add(fname: string; dodhst: boolean);
	end;




implementation

uses

	Strings,Gem,
	OProcs,
	txtypes,txmain;



constructor TAbruf.Init(AParent: PEventObject; mNum,popTree,popIndex: integer);

	begin
		if not(inherited Init(AParent,mNum,popTree,popIndex)) then fail;
		Disable;
		Count:=0;
		Dirty:=false;
		fillchar(Files,sizeof(Files),0);
		with Popup^.PopTree^[ROOT] do
			begin
				cpw:=ob_width div 40;
				cph:=ob_height div 10
			end
	end;


procedure TAbruf.HandleMenu(Indx: integer);

	begin
		if (Indx<0) or (Indx>=Count) or (TexelApp.opennewdoc=nil) then exit;
		if Files[Indx]<>nil then TexelApp.LoadFile(nil,Files[Indx]^)
	end;


procedure TAbruf.Add(fname: string; dodhst: boolean);
	label _dhst;
	
	var ps      : PString;
	    q,w,ml  : integer;
	    dhstid  : longint;
	    pipe    : Pipearray;
	    dhstinfo: PDHSTInfo;
	    oldfname: string;

	begin
		if length(fname)=0 then exit;
		CorrectPath(fname);
		oldfname:=fname;
		ps:=NewStr(fname);
		if ps=nil then goto _dhst;
		Dirty:=true;
		if Count>0 then
			begin
				ml:=-1;
				fname:=StrPUpper(fname);
				for q:=0 to Count-1 do
					if StrPUpper(Files[q]^)=fname then
						begin
							ml:=q;
							break
						end;
				if ml>=0 then
					begin
						DisposeStr(Files[ml]);
						if ml<9 then
							for q:=ml to 8 do Files[q]:=Files[q+1];
						dec(Count);
						Files[9]:=nil
					end
			end;
		if Count=10 then DisposeStr(Files[9]);
		for q:=9 downto 1 do Files[q]:=Files[q-1];
		Files[0]:=ps;
		if Count<10 then inc(Count);
		ml:=0;
		for q:=0 to Count-1 do
			if length(Files[q]^)>ml then ml:=length(Files[q]^);
		if ml>37 then ml:=37;
		with Popup^ do
			begin
				PopTree^[ROOT].ob_height:=cph*Count;
				PopTree^[ROOT].ob_width:=cpw*(ml+3);
				w:=PopTree^[ROOT].ob_head;
				for q:=0 to Count-1 do
					begin
						PopTree^[w].ob_flags:=PopTree^[w].ob_flags and not(HIDETREE);
						PopTree^[w].ob_width:=PopTree^[ROOT].ob_width;
						StrPCopy(PopTree^[w].ob_spec.free_string,'  '+CompressPath(Files[q]^,ml)+' ');
						w:=PopTree^[w].ob_next
					end;
				if Count<10 then
					for q:=Count to 9 do
						begin
							PopTree^[w].ob_flags:=PopTree^[w].ob_flags or HIDETREE;
							w:=PopTree^[w].ob_next
						end
			end;
		Enable;
		_dhst:
		if dodhst and (Application^.apPath<>nil) then
			if GetCookie('DHST',dhstid) then
				begin
					dhstid:=dhstid and $0000ffff;
					if dhstid>=0 then
						begin
							GlobalAlloc(pointer(dhstinfo),1024+sizeof(TDHSTInfo));
							if dhstinfo<>nil then
								begin
									dhstinfo^.AppName:=PChar(longint(dhstinfo)+sizeof(TDHSTInfo));
									dhstinfo^.AppPath:=PChar(longint(dhstinfo)+sizeof(TDHSTInfo)+256);
									dhstinfo^.DocName:=PChar(longint(dhstinfo)+sizeof(TDHSTInfo)+512);
									dhstinfo^.DocPath:=PChar(longint(dhstinfo)+sizeof(TDHSTInfo)+768);
									strpcopy(dhstinfo^.AppName,TEXELNAME);
									strpcopy(dhstinfo^.AppPath,Application^.apPath^+TEXELAPPNAME);
									strpcopy(dhstinfo^.DocName,GetFilename(oldfname,true));
									strpcopy(dhstinfo^.DocPath,oldfname);
									pipe[0]:=DHST_ADD;
									pipe[1]:=Application^.apID;
									pipe[2]:=0;
									pipe[3]:=integer(HiWord(dhstinfo));
									pipe[4]:=integer(LoWord(dhstinfo));
									pipe[5]:=0;
									pipe[6]:=0;
									pipe[7]:=0;
									appl_write(dhstid,16,@pipe)
								end
						end
				end
	end;

end.