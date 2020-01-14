unit txnew;
{ 1998-07-19 }

interface

uses

	OWindows,
	txtypes;


type

	PNew = ^TNew;
	TNew = object(TKeyMenu)
		public
		procedure Work; virtual;
		procedure CheckMenuEntry;
		private
		procedure CreateNewSheet;
	end;




implementation

uses

	OTypes,ODialogs,
	txrsc,txlang,txmain;


type

	PSmallInfoDialog = ^TSmallInfoDialog;
	TSmallInfoDialog = object(THyperDialog)
		tsi: TSmallInfo;
		function OK: boolean; virtual;
	end;



procedure TNew.Work;

	begin
		if TexelApp.setupbuffer.infodial=bf_Checked then CreateNewSheet
		else
			new(PCalcWindow,Init(nil));
	end;


procedure TNew.CheckMenuEntry;
	var s: string;
	    i: integer;

	begin
		s:=GetText;
		if length(s)<6 then exit;
		i:=3;
		while not(s[i] in [' ','.']) do
			begin
				inc(i);
				if i>length(s) then exit;
			end;
		if i+2>length(s) then exit;
		if TexelApp.setupbuffer.infodial=bf_Checked then
			begin
				s[i]:='.';
				s[i+1]:='.';
				s[i+2]:='.'
			end
		else
			begin
				s[i]:=' ';
				s[i+1]:=' ';
				s[i+2]:=' '
			end;
		SetText(s)
	end;


procedure TNew.CreateNewSheet;
	var pb: PButton;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PSmallInfoDialog,Init(nil,TEXELWINDPREFIX+TITLE_NEW,STG_NEW,ICNTITLE_NEW,RTSMALLINFO));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTSIEDIT,'',''));
						new(PEdit,Init(ADialog,RTSIAUTOR,51,BUBBLE_SINFO_AUTHOR));
						new(PEdit,Init(ADialog,RTSISTICHWORT,51,BUBBLE_INFO_INDEX));
						new(PEdit,Init(ADialog,RTSIREM1,51,BUBBLE_INFO_REM));
						new(PEdit,Init(ADialog,RTSIREM2,51,BUBBLE_INFO_REM));
						new(PEdit,Init(ADialog,RTSIREM3,51,BUBBLE_INFO_REM));
						new(PEdit,Init(ADialog,RTSIREM4,51,BUBBLE_INFO_TITLE));
						new(pb,Init(ADialog,RTSIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTSIABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTSIOK,id_OK,true,BUBBLE_SINFO_OK));
						ADialog^.TransferBuffer:=@PSmallInfoDialog(ADialog)^.tsi
					end
			end;
		if ADialog<>nil then
			begin
				with PSmallInfoDialog(ADialog)^.tsi do
					begin
						Autor:=TexelApp.GetAuthorName;
						Stichwort:='';
						Rem1:='';
						Rem2:='';
						Rem3:='';
						DocTitle:=''
					end;
				ADialog^.MakeWindow
			end
	end;


function TSmallInfoDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then new(PCalcWindow,Init(@tsi));
		OK:=valid
	end;

end.