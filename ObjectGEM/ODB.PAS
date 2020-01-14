{****************************************
 *   O b j e c t G E M   Version 1.50   *
 *   Copyright 1992-97 by Thomas Much   *
 ****************************************
 *             Unit  O D B              *
 ****************************************
 *     Thomas Much, Gerwigstraûe 46,    *
 * 76131 Karlsruhe, Fax (0721) 62 28 21 *
 *          Thomas Much @ KA2           *
 *  Thomas.Much@stud.uni-karlsruhe.de   *
 *  www.uni-karlsruhe.de/~Thomas.Much   *
 ****************************************
 *      erstellt am:        23.05.1994  *
 *      letztes Update am:  03.09.1996  *
 ****************************************}

{
  WICHTIGE ANMERKUNGEN ZUM QUELLTEXT:

	ObjectGEM ist Freeware, d.h. jeder darf die Units verwenden, ohne
	fÅr die damit entwickelten Programme Lizenzen o.Ñ. zahlen zu mÅssen,
	so lange alle Dateien _zusammen_ und _unverÑndert_ (!) weitergegeben
	werden.
	
	Ich freue mich natÅrlich trotzdem Åber kleine Aufmerksamkeiten wie
	Belegexemplare, originelle T-Shirts (L oder XL) sowie grÅnen Tee
	aus Japan :-)

  WICHTIG: Wer den Quelltext verÑndert und dann Probleme beim Compilieren,
  AusfÅhren o.Ñ. hat, kann nicht damit rechnen, daû ich den Fehler suche;
  tritt der Fehler allerdings auch mit dem Original-Quelltext auf, wÅrde
  ich mich Åber eine genaue Fehlerbeschreibung freuen. VerÑnderte Quell-
  texte dÅrfen _nicht_ weitergegeben werden, dies wÑre ein Verstoû gegen
  das Copyright!

  Wer beim Durchstîbern des Textes auf vermeintliche Fehler oder verbesse-
  rungswÅrdige Stellen trifft (von letzterem gibt es sicherlich noch viele),
  kann mir dies gerne mitteilen - ich habe auch ich nichts gegen kostenlos
  zur VerfÅgung gestellte optimierte Routinen (sofern sich jemand die MÅhe
  macht). Wer in anderen Projekten, die nicht in direkter Konkurrenz zu
  ObjectGEM stehen, einzelne Routinen verwenden mîchte, wendet sich bitte
  an mich (ein solcher Austausch sollte kein Problem sein).

  Wer sich auf nicht dokumentierte "implementation"- oder "private"-Eigen-
  schaften verlÑût, darf sich nicht Åber InkompatibilitÑten zu spÑteren
  Versionen wundern; wer meint, eine DokumentationslÅcke entdeckt zu haben,
  kann mir dies gerne mitteilen.

  Kleine Info zum Schluû: Als "default tabsize" verwende ich 2. Wer drei
  Punkte ("...") im Quelltext entdeckt, hat eine Stelle gefunden, an der
  ich z.Z. arbeite ;-)

  "Mîge die OOP mit Euch sein!"
}


{$IFDEF DEBUG}
	{$B+,D+,I-,L+,P-,Q+,R+,S+,T-,V-,X+,Z-}
{$ELSE}
	{$B+,D-,I-,L-,P-,Q-,R-,S-,T-,V-,X+,Z-}
{$ENDIF}

{$IFDEF COPRO}
	{$G+,N-}
{$ELSE}
	{$G-,N-}
{$ENDIF}

unit ODB;

interface

uses

	OTypes,Objects;

type

	PXBase = ^TXBase;

	PXBField = ^TXBField;
	TXBField = object(TObject)
		public
		Parent: PXBase;
		constructor Init(AParent: PXBase; flName: string; flType: char; flLen,flFloat,bOffs: integer);
		destructor Done; virtual;
		function GetName: string;
		function GetType: char;
		function GetLength: integer;
		function GetFloatpt: integer;
		function IsString: boolean;
		function IsNumber: boolean;
		function IsLogical: boolean;
		function IsDate: boolean;
		function IsMemo: boolean;
		function GetString: string;
		function GetNumber: real;
		function GetLogical: integer;
		function GetDate: string;
		function Previous: PXBField;
		function Next: PXBField;
		private
		fldname : string;
		bufoffs,
		fldfloat,
		fldlen  : integer;
		fldtype : char;
		nxt,
		prev   : PXBField
	end;

	TXBase = object(TObject)
		public
		Fields: PXBField;
		constructor Init;
		constructor InitFile(dbFile: string);
		destructor Done; virtual;
		function Open(dbFile:string): boolean;
		procedure Close;
		function IsOpen: boolean;
		function GetFilename: string;
		function GetMaxRecords: longint;
		function GetMaxFields: integer;
		function GetPosition: longint;
		function GotoRecord(Nr: longint): boolean;
		function GotoBeginning: boolean;
		function GotoEnd: boolean;
		function Skip(Delta: longint): boolean;
		function GetRecord: boolean;
		function IsEOF: boolean;
		function HasMemos: boolean;
		private
		dsanz,
		dslen,
		dspos,
		bufsize,
		f0pos,
		feldanz : longint;
		hdl     : integer;
		memos,
		bufvalid,
		openflag: boolean;
		filename: string;
		buf     : PByteArray;
		function bread(buffer: pointer; count: longint): boolean;
		function SwapLong(l: longint): longint;
	end;



implementation

uses

	Tos,OProcs;

type

	TDBHEADER = record
		version: byte;
		datum  : array [1..3] of byte;
		records: longint;
		headerb,
		recordb: word;
		reserve: array [0..19] of byte
	end;

	TFELD = record
		fname : array [0..10] of char;
		ftyp  : char;
		dummy1: array [0..3] of byte;
		laenge,
		komma : byte;
		dummy2: array [0..1] of byte;
		id    : byte;
		dummy3: array [0..10] of byte
	end;


{ *** Objekt TXBFIELD *** }

constructor TXBField.Init(AParent: PXBase; flName: string; flType: char; flLen,flFloat,bOffs: integer);
	var p: PXBField;

	begin
		if not(inherited Init) then fail;
		Parent:=AParent;
		if Parent=nil then
			begin
				inherited Done;
				fail
			end;
		nxt:=nil;
		prev:=nil;
		fldname:=flName;
		fldtype:=flType;
		fldlen:=flLen;
		fldfloat:=flFloat;
		bufoffs:=bOffs;
		if Parent^.Fields=nil then Parent^.Fields:=@self
		else
			begin
				p:=Parent^.Fields;
				while p^.nxt<>nil do p:=p^.nxt;
				p^.nxt:=@self;
				prev:=p
			end
	end;


destructor TXBField.Done;

	begin
		if (prev=nil) and (nxt=nil) then Parent^.Fields:=nil
		else
			begin
				if prev=nil then Parent^.Fields:=nxt
					else prev^.nxt:=nxt;
				if nxt<>nil then nxt^.prev:=prev
			end;
		inherited Done
	end;


function TXBField.GetName: string;

	begin
		GetName:=fldname
	end;


function TXBField.GetType: char;

	begin
		GetType:=fldtype
	end;


function TXBField.GetLength: integer;

	begin
		GetLength:=fldlen
	end;


function TXBField.GetFloatpt: integer;

	begin
		GetFloatpt:=fldfloat
	end;


function TXBField.IsString: boolean;

	begin
		IsString:=(GetType='C')
	end;


function TXBField.IsNumber: boolean;

	begin
		IsNumber:=(GetType='N')
	end;


function TXBField.IsLogical: boolean;

	begin
		IsLogical:=(GetType='L')
	end;


function TXBField.IsDate: boolean;

	begin
		IsDate:=(GetType='D')
	end;


function TXBField.IsMemo: boolean;

	begin
		IsMemo:=(GetType='M')
	end;


function TXBField.GetString: string;

	begin
		if not(parent^.bufvalid) then GetString:=''
		else
			if IsString or IsNumber then GetString:=StrPTrimF(StrLPas(@Parent^.buf^[bufoffs],Min(GetLength,255)))
			else
				GetString:=''
	end;


function TXBField.GetNumber: real;

	begin
		if not(IsNumber) or not(Parent^.bufvalid) then GetNumber:=0.0
		else
			GetNumber:=atof(StrLPas(@Parent^.buf^[bufoffs],Getlength))
	end;


function TXBField.GetLogical: integer;

	begin
		if not(IsLogical) or not(Parent^.bufvalid) then GetLogical:=xb_False
		else
			if Parent^.buf^[bufoffs]=ord('?') then GetLogical:=xb_Neutral
			else
				if chr(Parent^.buf^[bufoffs]) in ['t','T','j','J'] then GetLogical:=xb_True
				else
					GetLogical:=xb_False
	end;


function TXBField.GetDate: string;
	var ttxt: string;

	begin
		if not(IsDate) or not(Parent^.bufvalid) then GetDate:=''
		else
			begin
				ttxt:=StrPTrimF(StrLPas(@Parent^.buf^[bufoffs],GetLength));
				if length(ttxt)<>8 then GetDate:=''
				else
					GetDate:=StrPRight(ttxt,2)+'.'+StrPMid(ttxt,5,2)+'.'+StrPLeft(ttxt,4)
			end
	end;


function TXBField.Previous: PXBField;

	begin
		Previous:=prev
	end;


function TXBField.Next: PXBField;

	begin
		Next:=nxt
	end;

{ *** TXBFIELD *** }



{ *** Objekt TXBASE *** }

constructor TXBase.Init;

	begin
		if not(inherited Init) then fail;
		Fields:=nil;
		openflag:=false;
		bufvalid:=false;
		memos:=false;
		filename:='';
		feldanz:=0;
		dsanz:=0;
		dspos:=0;
		buf:=nil
	end;


constructor TXBase.InitFile(dbFile: string);

	begin
		if not(Init) then fail;
		if not(Open(dbFile)) then fail
	end;


destructor TXBase.Done;

	begin
		Close;
		inherited Done
	end;


function TXBase.Open(dbFile: string): boolean;
	label _error;

	var res : longint;
	    bpos,
	    q   : integer;
	    kopf: TDBHEADER;
	    feld: TFELD;

	begin
		Open:=false;
		Close;
		if length(dbFile)=0 then exit;
		res:=fopen(dbFile,FO_READ);
		if res<0 then exit;
		hdl:=integer(res);
		buf:=GetMemBuffer(4096,4096,bufsize);
		if buf=nil then goto _error;
		if bread(@kopf,sizeof(kopf)) then goto _error;
		if (kopf.version<>$03) and (kopf.version<>$83) then goto _error;
		memos:=(kopf.version=$83);
		dsanz:=SwapLong(kopf.records);
		dslen:=swap(kopf.recordb);
		feldanz:=((swap(kopf.headerb)-1) div 32)-1;
		if not(Between(feldanz,1,128)) then goto _error;
		bpos:=1;
		for q:=1 to feldanz do
			begin
				if bread(@feld,sizeof(feld)) then goto _error;
				new(PXBField,Init(@self,StrLPas(feld.fname,11),feld.ftyp,feld.laenge,feld.komma,bpos));
				inc(bpos,feld.laenge)
			end;
		if bread(buf,1) then goto _error;
		if buf^[0]<>$0d then goto _error;
		f0pos:=fseek(0,hdl,1);
		if f0pos<0 then goto _error;
		dspos:=0;
		filename:=dbFile;
		openflag:=true;
		Open:=true;
		exit;
		_error:
		while Fields<>nil do Fields^.Free;
		if buf<>nil then
			begin
				freemem(buf,bufsize);
				buf:=nil
			end;
		feldanz:=0;
		memos:=false;
		dsanz:=0;
		fclose(hdl)
	end;


procedure TXBase.Close;

	begin
		if not(IsOpen) then exit;
		fclose(hdl);
		while Fields<>nil do Fields^.Free;
		if buf<>nil then
			begin
				freemem(buf,bufsize);
				buf:=nil
			end;
		filename:='';
		feldanz:=0;
		dsanz:=0;
		dspos:=0;
		bufvalid:=false;
		memos:=false;
		openflag:=false
	end;


function TXBase.IsOpen: boolean;

	begin
		IsOpen:=openflag
	end;


function TXBase.GetFilename: string;

	begin
		GetFilename:=filename
	end;


function TXBase.GetMaxRecords: longint;

	begin
		GetMaxRecords:=dsanz
	end;


function TXBase.GetMaxFields: integer;

	begin
		GetMaxFields:=feldanz
	end;


function TXBase.GetPosition: longint;

	begin
		GetPosition:=dspos
	end;


function TXBase.GotoRecord(Nr: longint): boolean;
	var ret: longint;

	begin
		if not(IsOpen) then
			begin
				GotoRecord:=false;
				exit
			end;
		if Nr<0 then Nr:=0
		else
			if Nr>GetMaxRecords then Nr:=GetmaxRecords;
		ret:=fseek(f0pos+Nr*dslen,hdl,0);
		if ret<0 then GotoRecord:=false
		else
			begin
				dspos:=Nr;
				GotoRecord:=true
			end
	end;


function TXBase.GotoBeginning: boolean;

	begin
		GotoBeginning:=GotoRecord(0)
	end;


function TXBase.GotoEnd: boolean;

	begin
		GotoEnd:=GotoRecord(GetMaxRecords)
	end;


function TXBase.Skip(Delta: longint): boolean;

	begin
		if Delta=0 then Skip:=true
		else
			Skip:=GotoRecord(GetPosition+Delta)
	end;


function TXBase.GetRecord: boolean;

	begin
		if not(IsOpen) then GetRecord:=false
		else
			if bread(buf,dslen) then
				begin
					bufvalid:=false;
					GetRecord:=false
				end
			else
				begin
					inc(dspos);
					bufvalid:=true;
					GetRecord:=true
				end
	end;


function TXBase.IsEOF: boolean;

	begin
		IsEOF:=(dspos>=GetMaxRecords)
	end;


function TXBase.HasMemos: boolean;

	begin
		HasMemos:=memos
	end;

{ private }


function TXBase.bread(buffer: pointer; count: longint): boolean;

	begin
		bread:=(fread(hdl,count,buffer)<>count)
	end;


function TXBase.SwapLong(l: longint): longint;

	begin
		SwapLong:=longint(swap(HiWord(pointer(l)))) or (longint(swap(LoWord(pointer(l)))) shl 16)
	end;

{ *** TXBASE *** }

end.