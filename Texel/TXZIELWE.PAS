unit txzielwe;
{ 1998-07-05 }

interface

uses

	OWindows;

type

	PZielwert = ^TZielwert;
	TZielwert = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Gem,
	OTypes,OProcs,
	txrsc,txlang,txtypes,txmain;


{$IFNDEF LITE}
type

	PZielwertDialog = ^TZielwertDialog;
	TZielwertDialog = object(TBlockChangeDialog)
		ed1,
		ed2: PEdit;
		st : PStatic;
		procedure BlockChanged(blk: string); virtual;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;



procedure TZielwertDialog.BlockChanged(blk: string);

	begin
		if pos(':',blk)>0 then exit;
		if GetFocus=RTZWZZELLE then ed1^.SetText(blk)
		else
			if GetFocus=RTZWVZELLE then ed2^.SetText(blk)
	end;


function TZielwertDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTZWSUCHEN);
		OK:=valid
	end;


function TZielwertDialog.ExitDlg(AnIndx: integer): boolean;
	label _nochmal,_fehler;

	var p              : PCalcWindow;
	    zrs,zcs,zre,zce,
	    vrs,vcs,vre,vce,
	    kstat,key,
	    dummy,ret      : integer;
	    itanz,itmax    : longint;
	    v1,v2,valid    : boolean;
	    x0,x1,x2,
	    f0,f1,nenner,
	    zwert          : TNumber;
	    zcell,vcell    : PCell;
	    pc             : PConst;
	    err            : string;
	    pipe           : Pipearray;

	function f(x: TNumber): TNumber;

		begin
			vcell^.Data.Konst^.Value:=x;
			f:=p^.GetCellValue(zcell,true)-zwert
		end;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTZWSUCHEN:
			begin
				TransferData(tf_GetData);
				v1:=p^.GetBlock(p^.zwbuf.zzelle,false,zrs,zcs,zre,zce,dummy,dummy);
				v2:=p^.GetBlock(p^.zwbuf.vzelle,false,vrs,vcs,vre,vce,dummy,dummy);
				if not(v1) or not(v2) or (zrs<>zre) or (zcs<>zce) or (vrs<>vre) or (vcs<>vce) then
					begin
						Application^.Alert(p,1,NOTE,MESSAGE_FINDVAL_CELLREF,BUTTON_OK);
						exit
					end;
				zwert:=atof(p^.zwbuf.wert);
				itmax:=atol(p^.zwbuf.iterationen);
				zcell:=p^.GetCell(zrs,zcs);
				if zcell^.Typ<>CTYPE_FORMULA then
					begin
						Application^.Alert(p,1,NOTE,MESSAGE_FINDVAL_FORMULA,BUTTON_OK);
						exit
					end;
				vcell:=p^.GetCell(vrs,vcs);
				if (vcell^.Typ=CTYPE_TEXT) or (vcell^.Typ=CTYPE_FORMULA) then
					begin
						Application^.Alert(p,1,NOTE,MESSAGE_FINDVAL_NUMBER,BUTTON_OK);
						exit
					end;
				if vcell^.Typ=CTYPE_CONST then DisposeStr(vcell^.Data.Konst^.Txt)
				else
					begin
						new(pc);
						if pc=nil then exit;
						pc^.Value:=0.0;
						pc^.FPts:=atol(TexelApp.setupbuffer.floatpoint);
						pc^.Txt:=nil;
						with vcell^.TxtVal do
							begin
								Font:=p^.GetFontIndex;
								Size:=p^.GetFontSize;
								Align:=(Align and $f0) or TA_RIGHT;
								Flags:=0
							end;
						vcell^.Data.Konst:=pc;
						vcell^.Typ:=CTYPE_CONST
					end;
				BusyMouse;
				err:='';
				if st<>nil then st^.SetText(STRING_FINDVAL_STATUS+': '+STRING_FINDVAL_SEARCH);
				x0:=-1.0;
				x1:=2.0;
				valid:=false;
				_nochmal:
				f0:=f(x0);
				f1:=f(x1);
				if abs(f1-f0)<1e-11 then
					begin
						if abs(x1-x0)>0.1 then
							begin
								x0:=x0/2.0;
								x1:=x1/1.8;
								goto _nochmal
							end
						else
							begin
								err:='('+STRING_FINDVAL_INTERVAL+')';
								goto _fehler
							end
					end;
				valid:=true;
				itanz:=0;
				repeat
					if (itanz mod 10)=0 then
						begin
							ret:=evnt_multi(MU_TIMER or MU_KEYBD,0,0,0,0,0,0,0,0,0,0,0,0,0,pipe,1,0,dummy,dummy,dummy,kstat,key,dummy);
							if bTst(ret,MU_KEYBD) then
								if kstat=K_NORMAL then
									if key=S_Esc then
										begin
											err:='('+STRING_FINDVAL_CANCEL+')';
											valid:=false;
											break
										end
						end;
					inc(itanz);
					if itanz>itmax then
						begin
							err:='('+STRING_FINDVAL_ITERAT+')';
							valid:=false;
							break
						end;
					nenner:=f1-f0;
					if abs(nenner)<1e-11 then
						begin
							err:='('+STRING_FINDVAL_NOSOLUTN+')';
							valid:=false;
							break
						end;
					x2:=x1-(x1-x0)*f1/nenner;
					x0:=x1;
					x1:=x2;
					f0:=f1;
					f1:=f(x2)
				until abs(x1-x0)<1e-11;
				_fehler:
				vcell^.Data.Konst^.Value:=x1;
				vcell^.Data.Konst^.Txt:=NewStr(ftoa(x1));
				p^.AutoCalculate(true);
				p^.DrawCells(vrs,vcs,vre,vce);
				ArrowMouse;
				if not(valid) then
					begin
						if st<>nil then st^.SetText(STRING_FINDVAL_STATUS+': '+STRING_FINDVAL_ERROR+' '+err);
						Application^.Alert(p,1,NOTE,MESSAGE_FINDVAL_ERROR,BUTTON_OK)
					end
				else
					if abs(f1)>1e-9 then
						begin
							if st<>nil then st^.SetText(STRING_FINDVAL_STATUS+': '+STRING_FINDVAL_ERROR);
							Application^.Alert(p,1,NOTE,MESSAGE_FINDVAL_ERROR,BUTTON_OK)
						end
					else
						if st<>nil then st^.SetText(STRING_FINDVAL_STATUS+': '+STRING_FINDVAL_OK)
			end
		end
	end;

{$ENDIF}


procedure TZielwert.Work;
	var pb: PButton;

	begin
		{$IFNDEF LITE}
		if ADialog=nil then
			begin
				TexelApp.ActivateExtResource;
				ADialog:=new(PZielwertDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_FINDVAL,STG_FINDVAL,ICNTITLE_FINDVAL,RTZIELWERT));
				if ADialog<>nil then
					begin
						new(PZielwertDialog(ADialog)^.ed1,Init(ADialog,RTZWZZELLE,8,BUBBLE_FINDVAL_CTARGET));
						new(PZielwertDialog(ADialog)^.ed2,Init(ADialog,RTZWVZELLE,8,BUBBLE_FINDVAL_CVALUE));
						new(PEdit,Init(ADialog,RTZWWERT,16,BUBBLE_FINDVAL_TVALUE));
						new(PEdit,Init(ADialog,RTZWITERATIONEN,7,BUBBLE_FINDVAL_ITERAT));
						new(PZielwertDialog(ADialog)^.st,Init(ADialog,RTZWSTATUS,41,false,BUBBLE_FINDVAL_STATUS));
						new(pb,Init(ADialog,RTZWHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTZWABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTZWSUCHEN,id_No,true,BUBBLE_FINDVAL_FIND));
						new(PButton,Init(ADialog,RTZWOK,id_OK,true,BUBBLE_FINDVAL_OK));
						ADialog^.TransferBuffer:=@PCalcWindow(Parent)^.zwbuf
					end;
				TexelApp.DeactivateExtResource
			end;
		if ADialog<>nil then
			begin
				if PZielwertDialog(ADialog)^.st<>nil then PZielwertDialog(ADialog)^.st^.SetText(STRING_FINDVAL_STATUS+':');
				ADialog^.MakeWindow
			end
		{$ENDIF}
	end;

end.