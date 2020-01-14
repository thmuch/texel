unit txpsetup;
{ 1998-07-08 }

interface

uses

	OWindows;


type

	PPageSetup = ^TPageSetup;
	TPageSetup = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	OTypes,ODialogs,
	txrsc,txlang,txtypes,txvalida,txmain;



procedure TPageSetup.Work;
	var pe: PEdit;
	    pc: PCheckBox;
	    pb: PButton;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PPSDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_LAYOUT,STG_LAYOUT,ICNTITLE_LAYOUT,RTPAGESETUP));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTPSMARGINS,GROUP_LAYOUT_MARGINS,''));
						new(PGroupBox,Init(ADialog,RTPSCENTER,GROUP_LAYOUT_CENTER,''));
						new(PGroupBox,Init(ADialog,RTPSPRINT,GROUP_LAYOUT_PRINTWITH,''));
						new(PGroupBox,Init(ADialog,RTPSBEREICH,GROUP_LAYOUT_PRINTRANGE,''));
						new(PGroupBox,Init(ADialog,RTPSHEAD,GROUP_LAYOUT_HEAD,''));
						new(PGroupBox,Init(ADialog,RTPSFOOT,GROUP_LAYOUT_FOOT,''));
						new(PGroupBox,Init(ADialog,RTPSNUM,GROUP_LAYOUT_NUM,''));
						new(pe,Init(ADialog,RTPSTOP,9,BUBBLE_LAYOUT_TMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pe,Init(ADialog,RTPSBOTTOM,9,BUBBLE_LAYOUT_BMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pe,Init(ADialog,RTPSLEFT,9,BUBBLE_LAYOUT_LMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(pe,Init(ADialog,RTPSRIGHT,9,BUBBLE_LAYOUT_RMARGIN));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						new(PCheckBox,Init(ADialog,RTPSHCENTER,true,BUBBLE_LAYOUT_HCENTER));
						new(PCheckBox,Init(ADialog,RTPSVCENTER,true,BUBBLE_LAYOUT_VCENTER));
						new(PCheckBox,Init(ADialog,RTPSGITTER,true,BUBBLE_LAYOUT_GRID));
						new(PCheckBox,Init(ADialog,RTPSROWS,true,BUBBLE_LAYOUT_NUMBERS));
						new(PCheckBox,Init(ADialog,RTPSCOLUMNS,true,BUBBLE_LAYOUT_NAMES));
						new(pe,Init(ADialog,RTPSBEDIT,16,BUBBLE_LAYOUT_PRNTRANGE));
						new(pe,Init(ADialog,RTPSHLEFT,42,BUBBLE_LAYOUT_LHEAD));
						new(pe,Init(ADialog,RTPSHMID,42,BUBBLE_LAYOUT_CHEAD));
						new(pe,Init(ADialog,RTPSHRIGHT,42,BUBBLE_LAYOUT_RHEAD));
						new(pe,Init(ADialog,RTPSFLEFT,42,BUBBLE_LAYOUT_LFOOT));
						new(pe,Init(ADialog,RTPSFMID,42,BUBBLE_LAYOUT_CFOOT));
						new(pe,Init(ADialog,RTPSFRIGHT,42,BUBBLE_LAYOUT_RFOOT));
						new(PRadioButton,Init(ADialog,RTPSNUM1,false,BUBBLE_LAYOUT_NUMHOR));
						new(PRadioButton,Init(ADialog,RTPSNUM2,false,BUBBLE_LAYOUT_NUMVERT));
						new(pc,Init(ADialog,RTPSHLEFTON,true,BUBBLE_LAYOUT_PLHEAD));
						new(pc,Init(ADialog,RTPSHCENTERON,true,BUBBLE_LAYOUT_PCHEAD));
						new(pc,Init(ADialog,RTPSHRIGHTON,true,BUBBLE_LAYOUT_PRHEAD));
						new(pc,Init(ADialog,RTPSFLEFTON,true,BUBBLE_LAYOUT_PLFOOT));
						new(pc,Init(ADialog,RTPSFCENTERON,true,BUBBLE_LAYOUT_PCFOOT));
						new(pc,Init(ADialog,RTPSFRIGHTON,true,BUBBLE_LAYOUT_PRFOOT));
						new(PCheckBox,Init(ADialog,RTPSOBJECTS,true,BUBBLE_LAYOUT_POBJECTS));
						new(pe,Init(ADialog,RTPSKOPF,9,BUBBLE_LAYOUT_MHEAD));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						PPSDialog(ADialog)^.ed1:=pe;
						new(pe,Init(ADialog,RTPSFUSS,9,BUBBLE_LAYOUT_MFOOT));
						if pe<>nil then pe^.SetValidator(new(PPosRealValidator,Init));
						PPSDialog(ADialog)^.ed2:=pe;
						new(pb,Init(ADialog,RTPSHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTPSMINIMAL,id_No,true,BUBBLE_LAYOUT_MINIMAL));
						new(PButton,Init(ADialog,RTPSCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTPSSET,id_No,true,BUBBLE_GENERAL_SET2));
						new(PButton,Init(ADialog,RTPSOK,id_OK,true,BUBBLE_GENERAL_OK));
						ADialog^.TransferBuffer:=@PCalcWindow(Parent)^.Parms.psbuffer
					end
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;

end.