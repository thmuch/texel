unit txfill;
{ 1998-07-03 }

interface

uses

	OWindows;


type

	PFill = ^ TFill;
	TFill = object(TSubMenu)
		reihe: PDialog;
		procedure HandleMenu(Indx: integer); virtual;
	end;




implementation

uses

	Gem,
	OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txmain;


type

	PDateButton = ^TDateButton;
	TDateButton = object(TRadioButton)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;

	PTrendButton = ^TTrendButton;
	TTrendButton = object(TCheckBox)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;

	PFillDialog = ^TFillDialog;
	TFillDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		ed1,
		ed2 : PEdit;
		rb5,
		rb6,
		rb7,
		rb8 : PRadioButton;
		rb1,
		rb2,
		rb3,
		rb4 : PDateButton;
		ptb : PTrendButton;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
	end;



procedure TDateButton.Changed(AnIndx: integer; DblClick: boolean);
	var p: PFillDialog;
	    q: integer;

	begin
		p:=PFillDialog(Parent);
		if AnIndx=RTRDATE then
			begin
				p^.rb5^.Enable;
				p^.rb6^.Enable;
				p^.rb7^.Enable;
				p^.rb8^.Enable
			end
		else
			begin
				q:=p^.rb5^.GetCheck;
				p^.rb5^.Disable;
				p^.rb5^.SetCheck(q);
				q:=p^.rb6^.GetCheck;
				p^.rb6^.Disable;
				p^.rb6^.SetCheck(q);
				q:=p^.rb7^.GetCheck;
				p^.rb7^.Disable;
				p^.rb7^.SetCheck(q);
				q:=p^.rb8^.GetCheck;
				p^.rb8^.Disable;
				p^.rb8^.SetCheck(q)
			end;
		if AnIndx=RTRCOPY then
			begin
				p^.ed1^.Disable;
				p^.ed2^.Disable
			end
		else
			if p^.ptb^.GetCheck=bf_Unchecked then
				begin
					p^.ed1^.Enable;
					p^.ed2^.Enable
				end
	end;


procedure TTrendButton.Changed(AnIndx: integer; DblClick: boolean);
	var p: PFillDialog;

	begin
		p:=PFillDialog(Parent);
		if GetCheck=bf_Checked then
			begin
				p^.ed1^.Disable;
				p^.ed2^.Disable;
				if p^.rb3^.GetCheck=bf_Checked then
					begin
						p^.rb3^.Uncheck;
						p^.rb1^.Check;
						p^.rb1^.Changed(RTRARITHM,false)
					end
				else
					if p^.rb4^.GetCheck=bf_Checked then
						begin
							p^.rb4^.Uncheck;
							p^.rb1^.Check
						end;
				p^.rb3^.Disable;
				p^.rb4^.Disable
			end
		else
			begin
				p^.ed1^.Enable;
				p^.ed2^.Enable;
				p^.rb3^.Enable;
				p^.rb4^.Enable
			end
	end;


function TFillDialog.ExitDlg(AnIndx: integer): boolean;
	var p: PCalcWindow;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTRBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTRCALC:
			begin
				{ ... }
				Application^.Bing
			end
		end
	end;


procedure TFillDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk)
	end;


function TFillDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTRCALC);
		OK:=valid
	end;


procedure TFill.HandleMenu(Indx: integer);
	var p : PCalcWindow;
	    pb: PButton;

	begin
		p:=PCalcWindow(Parent);
		case Indx of
		0:
			{ ... };
		1:
			{ ... };
		2:
			{ ... };
		3:
			{ ... };
		5:
			begin
				if reihe=nil then
					begin
						reihe:=new(PFillDialog,Init(p,TEXELWINDPREFIX+TITLE_FILL,STG_FILL,ICNTITLE_FILL,RTREIHE));
						if reihe<>nil then
							begin
								new(PGroupBox,Init(reihe,RTRBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
								new(PGroupBox,Init(reihe,RTRWHERE,'Reihe in',''));
								new(PGroupBox,Init(reihe,RTRTYPE,'Typ',''));
								new(PGroupBox,Init(reihe,RTRTIME,'Zeiteinheit',''));
								new(PGroupBox,Init(reihe,RTRSTEP,'',''));
								new(PFillDialog(reihe)^.bedt,Init(reihe,RTRBEDIT,16,false,BUBBLE_GENERAL_RANGE));
								new(PRadioButton,Init(reihe,RTRROWS,true,BUBBLE_FILL_ROWS));
								new(PRadioButton,Init(reihe,RTRCOLUMNS,true,BUBBLE_FILL_COLUMNS));
								new(PFillDialog(reihe)^.rb1,Init(reihe,RTRARITHM,true,BUBBLE_FILL_ARITHM));
								new(PFillDialog(reihe)^.rb2,Init(reihe,RTRGEOM,true,BUBBLE_FILL_GEOM));
								new(PFillDialog(reihe)^.rb3,Init(reihe,RTRDATE,true,BUBBLE_FILL_DATE));
								new(PFillDialog(reihe)^.rb4,Init(reihe,RTRCOPY,true,BUBBLE_FILL_COPY));
								new(PFillDialog(reihe)^.ptb,Init(reihe,RTRTREND,true,BUBBLE_FILL_TREND));
								new(PFillDialog(reihe)^.rb5,Init(reihe,RTRDAY,true,BUBBLE_FILL_RDAY));
								new(PFillDialog(reihe)^.rb6,Init(reihe,RTRWEEKDAY,true,BUBBLE_FILL_RWEEKDAY));
								new(PFillDialog(reihe)^.rb7,Init(reihe,RTRMONTH,true,BUBBLE_FILL_RMONTH));
								new(PFillDialog(reihe)^.rb8,Init(reihe,RTRYEAR,true,BUBBLE_FILL_RYEAR));
								new(PFillDialog(reihe)^.ed1,Init(reihe,RTRSTEPVAL,13,BUBBLE_FILL_STEPVAL));
								new(PFillDialog(reihe)^.ed2,Init(reihe,RTRENDVAL,13,BUBBLE_FILL_ENDVAL));
								new(pb,Init(reihe,RTRHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(PButton,Init(reihe,RTRABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
								new(pb,Init(reihe,RTRCALC,id_No,true,BUBBLE_FILL_CALC));
								if pb<>nil then pb^.Disable; { ... }
								new(pb,Init(reihe,RTROK,id_OK,true,BUBBLE_FILL_OK));
								if pb<>nil then pb^.Disable; { ... }
								reihe^.TransferBuffer:=@p^.fillbuf
							end
					end;
				if reihe<>nil then
					begin
						PFillDialog(reihe)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
						if p^.fillbuf.date=bf_Checked then PFillDialog(reihe)^.rb3^.Changed(RTRDATE,false)
						else
							PFillDialog(reihe)^.rb3^.Changed(-1,false);
						reihe^.MakeWindow;
						PFillDialog(reihe)^.ptb^.Changed(RTRTREND,false)
					end
			end
		end
	end;

end.