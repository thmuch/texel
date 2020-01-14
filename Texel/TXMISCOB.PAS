unit txmiscob;
{ 1998-08-12 }

interface

uses

	OWindows,ODialogs;


type

	PProgressWindow = ^TProgressWindow;
	TProgressWindow = object(TDialog)
		public
		constructor Init(AMax: longint; Titel,Datei: string);
		function GetStyle: integer; virtual;
		procedure SetupWindow; virtual;
		procedure MakeWindow; virtual;
		procedure Progress(anz: longint);
		procedure SetMax(AMax: longint);
		private
		count,
		maxanz: longint;
		pc1,
		pc2   : PControl;
	end;
	
	PInputEdit = ^TInputEdit;
	TInputEdit = object(TScrollEdit)
		constructor Init(AParent: PDialog; AnIndx,ATextLen: integer);
		function IsHelpAvailable: boolean; virtual;
		function GetHelp: string; virtual;
	end;

	PDirectionBox = ^TDirectionBox;
	TDirectionBox = object(TComboBox)
		procedure SetValue(Sel: integer); virtual;
	end;

	PBlockBox = ^TBlockBox;
	TBlockBox = object(TListBox)
		ed: PEdit;
		procedure Work; virtual;
	end;

	PBlockDialog = ^TBlockDialog;
	TBlockDialog = object(TDialog)
		pbb: PBlockBox;
		procedure EndDlg(Indx: integer; DblClick: boolean); virtual;
	end;

	PPreviewBox = ^TPreviewBox;
	TPreviewBox = object(TCheckBox)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;

	PSortBox = ^TSortBox;
	TSortBox = object(TComboBox)
		procedure SetText(ATextString: string); virtual;
	end;

{$IFNDEF LITE}
	PImportBox = ^TImportBox;
	TImportBox = object(TComboBox)
		function CreatePopup: boolean; virtual;
	end;

	PImportRowColBox = ^TImportRowColBox;
	TImportRowColBox = object(TImportBox)
		procedure SetValue(Sel: integer); virtual;
	end;

	PImportButton = ^TImportButton;
	TImportButton = object(TRadioButton)
		pircb: PImportRowColBox;
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;

	PImportCellBox = ^TImportCellBox;
	TImportCellBox = object(TImportBox)
		procedure SetValue(Sel: integer); virtual;
	end;

	PImportTextBox = ^TImportTextBox;
	TImportTextBox = object(TImportBox)
		procedure SetValue(Sel: integer); virtual;
	end;

	PExportFilterBox = ^TExportFilterBox;	
	TExportFilterBox = object(TComboBox)
		procedure SetValue(Sel: integer); virtual;
	end;

	PHTMLDocTypeBox = ^THTMLDocTypeBox;
	THTMLDocTypeBox = object(TComboBox)
		css: PComboBox;
		procedure Work; virtual;
	end;
{$ENDIF}

{$IFNDEF WDIALOG}
	PPrintPercBox = ^TPrintPercBox;
	TPrintPercBox = object(TComboBox)
		procedure SetValue(Sel: integer); virtual;
	end;

	PDriverBox = ^TDriverBox;
	TDriverBox = object(TComboBox)
		drvcnt    : integer;
		drivers   : array [0..24] of integer;
		shortnames: array [0..24] of string[13];
		longnames : array [0..24] of string[43]
	end;
{$ENDIF}

{$IFDEF DEMO}
	PDemoStart = ^TDemoStart;
	TDemoStart = object(TDialog)
		ende: boolean;
		secs: integer;
		pb  : PButton;
		function GetModalTimer: longint; virtual;
		procedure HandleModalTimer; virtual;
	end;
{$ENDIF}




implementation

uses

	Gem,OTypes,OProcs,txrsc,txlang,txprocs;


constructor TProgressWindow.Init(AMax: longint; Titel,Datei: string);
	var st: PStatic;

	begin
		if not(inherited Init(nil,'',RTPROGRESS)) then fail;
		SetMax(AMax);
		new(st,Init(@self,RTPGACTION,17,false,''));
		if st<>nil then st^.SetText(Titel);
		new(st,Init(@self,RTPGFILE,43,false,''));
		if st<>nil then st^.SetText(CompressPath(Datei,42));
		new(pc1,Init(@self,RTPGBACK,''));
		if Application^.Attr.Colors<=LWhite then
			if pc1<>nil then
				pc1^.ObjAddr^.ob_spec.index:=(pc1^.ObjAddr^.ob_spec.index and $ffffff0f) or $10;
		new(pc2,Init(@self,RTPGDONE,''));
		if pc2<>nil then
			pc2^.ObjAddr^.ob_width:=0;
		MakeWindow
	end;


function TProgressWindow.GetStyle: integer;

	begin
		GetStyle:=0
	end;


procedure TProgressWindow.SetupWindow;

	begin
		inherited SetupWindow;
		Attr.ExStyle:=(Attr.ExStyle and not(ws_ex_TryModeless)) or ws_ex_Modeless
	end;


procedure TProgressWindow.MakeWindow;

	begin
		Create;
		OpenWindow;
		WMRedraw(Work.X,Work.Y,Work.W,Work.H)
	end;


procedure TProgressWindow.Progress(anz: longint);
	var nw: integer;

	begin
		inc(count,anz);
		if count>maxanz then count:=maxanz;
		if (pc2=nil) or (pc1=nil) or (maxanz<=0) then exit;
		nw:=round(count*longint(pc1^.ObjAddr^.ob_width)/maxanz);
		if nw<>pc2^.ObjAddr^.ob_width then
			begin
				pc2^.ObjAddr^.ob_width:=nw;
				pc2^.Paint
			end
	end;


procedure TProgressWindow.SetMax(AMax: longint);

	begin
		maxanz:=AMax;
		count:=0
	end;


{$IFNDEF LITE}

function TImportBox.CreatePopup: boolean;

	begin
		CreatePopup:=inherited CreatePopup;
		if Popup<>nil then Popup^.AutoCheck:=false
	end;


procedure TImportRowColBox.SetValue(Sel: integer);

	begin
		if Popup=nil then exit;
		case Sel of
		0:
			SetText('13,10');
		1:
			SetText('13');
		2:
			SetText('10')
		else
			SetText('')
		end
	end;


procedure TImportCellBox.SetValue(Sel: integer);

	begin
		if Popup=nil then exit;
		case Sel of
		0:
			SetText('9');
		1:
			SetText('32');
		2:
			SetText('44');
		3:
			SetText('59')
		else
			SetText('')
		end
	end;


procedure TImportTextBox.SetValue(Sel: integer);

	begin
		if Popup=nil then exit;
		case Sel of
		0:
			SetText('34');
		1:
			SetText('39')
		else
			SetText('')
		end
	end;


procedure TImportButton.Changed(AnIndx: integer; DblClick: boolean);
	var txt: string;

	begin
		if Parent^.Parent=nil then
			begin
				if AnIndx=RTAIHOR then txt:=STRING_ROWDIV+':'#0
				else
					txt:=STRING_COLDIV+':'#0
			end
		else
			begin
				if AnIndx=RTEXASCIIHOR then txt:=STRING_ROWDIV+':'#0
				else
					txt:=STRING_COLDIV+':'#0
			end;
		pircb^.SetTitle(txt)
	end;


procedure THTMLDocTypeBox.Work;

	begin
		if css<>nil then
			begin
				if GetSelection=2 then css^.Enable
				else
					css^.Disable
			end
	end;


procedure TExportFilterBox.SetValue(Sel: integer);

	begin
		if InitKeyTab then
			if pkt^.Size>=64 then
				begin
					SetText(StrPPas(PChar(pkt^.GetExportShortName(nil,nil,0,0,0,Sel))));
					exit
				end;
		inherited SetValue(Sel)
	end;

{$ENDIF}


{$IFNDEF WDIALOG}

procedure TPrintPercBox.SetValue(Sel: integer);
	var dummy: string;

	begin
		if Popup=nil then exit;
		dummy:=StrPTrimF(Popup^.GetText(Sel));
		SetText(StrPLeft(dummy,length(dummy)-1))
	end;

{$ENDIF}


procedure TPreviewBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		inherited Changed(AnIndx,DblClick);
		Parent^.ForceVRedraw
	end;


procedure TSortBox.SetText(ATextString: string);
	var q: integer;

	begin
		q:=pos(',',ATextString);
		if q>0 then ATextString:=StrPRight(ATextString,length(ATextString)-q-1);
		inherited SetText(StrPLeft(StrPTrimF(ATextString),15))
	end;


procedure TBlockBox.Work;
	var s  : string;
	    sel: integer;

	begin
		if List=nil then exit;
		if List^.Count=0 then exit;
		if ed<>nil then
			begin
				sel:=GetSelection;
				if sel<0 then exit;
				s:=StrPTrimF(PString(List^.At(sel))^);
				sel:=RPos(' ',s);
				if sel>0 then s:=StrPRight(s,length(s)-sel);
				ed^.SetText(s)
			end
	end;


procedure TDirectionBox.SetValue(Sel: integer);
	var ch: longint;

	begin
		case Sel of
		0,8:
			ch:=47;
		1:
			ch:=1;
		2,6:
			ch:=92;
		3:
			ch:=4;
		5:
			ch:=3;
		7:
			ch:=2
		else
			ch:=45
		end;
		with ObjAddr^ do
			begin
				ob_spec.index:=(ob_spec.index and $00ffffff) or (ch shl 24);
				Paint
			end
	end;


constructor TInputEdit.Init(AParent: PDialog; AnIndx,ATextLen: integer);

	begin
		if not(inherited Init(AParent,AnIndx,ATextLen,'')) then fail
	end;


function TInputEdit.IsHelpAvailable: boolean;

	begin
		IsHelpAvailable:=true
	end;


function TInputEdit.GetHelp: string;
	var txt: string;

	begin
		txt:=GetText;
		if length(txt)=0 then txt:=BUBBLE_INPUT_EMPTY
		else
			txt:='"'+txt+'"';
		if GetState=bf_Disabled then txt:=txt+' (Tab)';
		GetHelp:=txt
	end;


procedure TBlockDialog.EndDlg(Indx: integer; DblClick: boolean);

	begin
		inherited EndDlg(Indx,DblClick);
		if DblClick then
			if pbb^.TestIndex(Indx) then
				begin
					OK;
					Cont:=false;
					Result:=RTBOK
				end
	end;


{$IFDEF DEMO}

function TDemoStart.GetModalTimer: longint;

	begin
		GetModalTimer:=1000
	end;


procedure TDemoStart.HandleModalTimer;

	begin
		dec(secs);
		if pb<>nil then
			begin
				if secs>0 then pb^.SetText(STRING_DEMO_STILL+ltoa(secs)+STRING_DEMO_SECONDS+'...')
				else
					if secs=0 then
						begin
							pb^.Enable;
							if ende then pb^.SetText(STRING_DEMO_QUIT)
							else
								pb^.SetText(STRING_DEMO_START);
						end
			end
	end;

{$ENDIF}

end.