unit txsort;
{ 1998-07-07 }

interface

uses

	OWindows;


type

	PSort = ^TSort;
	TSort = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Gem,
	Objects,OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txmiscob,txmain;


type

	PSortButton = ^TSortButton;
	TSortButton = object(TRadioButton)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;

	PSortDialog = ^TSortDialog;
	TSortDialog = object(TBlockChangeDialog)
		bedt: PStatic;
		pcb1,
		pcb2,
		pcb3: PSortBox;
		rb1 : PSortButton;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function OK: boolean; virtual;
		procedure BlockChanged(blk: string); virtual;
		procedure ScanValues;
	end;



procedure TSortButton.Changed(AnIndx: integer; DblClick: boolean);

	begin
		inherited Changed(AnIndx,DblClick);
		PSortDialog(Parent)^.ScanValues
	end;


procedure TSortDialog.ScanValues;
	var p    : PCalcWindow;
	    rs,cs,
	    re,ce,
	    q,
	    dummy: integer;

	begin
		p:=PCalcWindow(Parent);
		if (pcb1=nil) or (pcb2=nil) or (pcb3=nil) then exit;
		if (pcb1^.Popup=nil) or (pcb2^.Popup=nil) or (pcb3^.Popup=nil) then exit;
		if pcb1^.Popup^.List=nil then exit;
		pcb1^.Popup^.List^.FreeAll;
		pcb1^.Popup^.List^.Sort:=false;
		pcb1^.Popup^.List^.Insert(NewStr('  ('+STRING_NOTHING+') '#0));
		pcb1^.ChangeAlways:=true;
		pcb2^.ChangeAlways:=true;
		pcb3^.ChangeAlways:=true;
		p^.GetBlock(bedt^.GetText,false,rs,cs,re,ce,dummy,dummy);
		if rb1^.GetCheck=bf_Checked then
			for q:=cs to ce do
				if p^.pcolnames^[q]=nil then pcb1^.Popup^.List^.Insert(NewStr('  '+STRING_COL+' '+p^.GetColumnName(q)+' '#0))
				else
					pcb1^.Popup^.List^.Insert(NewStr('  '+STRING_COL+' '+p^.GetColumnIndex(q)+', "'+p^.GetColumnName(q)+'" '#0))
		else
			for q:=rs to re do
				pcb1^.Popup^.List^.Insert(NewStr('  '+STRING_ROW+' '+p^.GetRowIndex(q)+' '#0));
		pcb1^.Popup^.SetCollection(pcb1^.Popup^.List);
		pcb2^.Popup^.SetCollection(pcb1^.Popup^.List);
		pcb3^.Popup^.SetCollection(pcb1^.Popup^.List);
		pcb1^.SetSelection(pcb1^.GetSelection,true);
		pcb2^.SetSelection(pcb2^.GetSelection,true);
		pcb3^.SetSelection(pcb3^.GetSelection,true)
	end;


function TSortDialog.ExitDlg(AnIndx: integer): boolean;
	var p       : PCalcWindow;
	    nrs,
	    n1,n2,n3,
	    offs    : integer;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTSRBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTSRSORT:
			begin
				TransferData(tf_GetData);
				with p^ do
					with sortbuf do
						begin
							if Ins=bf_Checked then nrs:=0
							else
								if Pre=bf_Checked then nrs:=1
								else
									nrs:=2;
							if Rows=bf_Checked then
								begin
									if Parms.Cursor.Block then offs:=Parms.Cursor.RowStart
									else
										offs:=Parms.Cursor.Row
								end
							else
								begin
									if Parms.Cursor.Block then offs:=Parms.Cursor.ColStart
									else
										offs:=Parms.Cursor.Col
								end;
							if Pop1=0 then n1:=-1
							else
								n1:=Pop1+offs-1;
							if Pop2=0 then n2:=-1
							else
								n2:=Pop2+offs-1;
							if Pop3=0 then n3:=-1
							else
								n3:=Pop3+offs-1;
							Sort(n1,n2,n3,nrs,Up1=bf_Checked,Up2=bf_Checked,Up3=bf_Checked,Rows=bf_Checked,
							     Chars=bf_Checked,EmptyPre=bf_Checked,Lexikal=bf_Checked,Absolut=bf_Checked,
							     Attribute=bf_Checked)
						end
			end
		end
	end;


procedure TSortDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk);
		ScanValues
	end;


function TSortDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTSRSORT);
		OK:=valid
	end;


procedure TSort.Work;
	var psc      : PStringCollection;
	    pb       : PButton;
	    rb21,rb22,
	    rb31,rb32: PRadioButton;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PSortDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_SORT,STG_SORT,ICNTITLE_SORT,RTSORT));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTSRSORT1,GROUP_SORT_SORT1,''));
						new(PGroupBox,Init(ADialog,RTSRSORT2,GROUP_SORT_SORT2,''));
						new(PGroupBox,Init(ADialog,RTSRSORT3,GROUP_SORT_SORT3,''));
						new(PGroupBox,Init(ADialog,RTSRBEREICH,GROUP_GENERAL_RANGE,BUBBLE_GENERAL_RANGE));
						new(PGroupBox,Init(ADialog,RTSRDIRECTION,GROUP_SORT_WHAT,''));
						new(PGroupBox,Init(ADialog,RTSRNUMBERS,GROUP_SORT_NUMBERS,''));
						new(PGroupBox,Init(ADialog,RTSREMPTY,GROUP_SORT_SPACES,''));
						psc:=new(PStringCollection,Init(20,10)); 
						new(PSortDialog(ADialog)^.pcb1,InitCollection(ADialog,RTSR1POPUP,RTSR1CYC,id_No,15,psc,true,false,false,BUBBLE_SORT_SORT1));
						new(PRadioButton,Init(ADialog,RTSR1UP,true,BUBBLE_SORT_1UP));
						new(PRadioButton,Init(ADialog,RTSR1DOWN,true,BUBBLE_SORT_1DOWN));
						new(PSortDialog(ADialog)^.pcb2,InitCollection(ADialog,RTSR2POPUP,RTSR2CYC,id_No,15,psc,false,false,false,BUBBLE_SORT_SORT2));
						new(rb21,Init(ADialog,RTSR2UP,true,BUBBLE_SORT_2UP));
						new(rb22,Init(ADialog,RTSR2DOWN,true,BUBBLE_SORT_2DOWN));
						new(PSortDialog(ADialog)^.pcb3,InitCollection(ADialog,RTSR3POPUP,RTSR3CYC,id_No,15,psc,false,false,false,BUBBLE_SORT_SORT3));
						new(rb31,Init(ADialog,RTSR3UP,true,BUBBLE_SORT_3UP));
						new(rb32,Init(ADialog,RTSR3DOWN,true,BUBBLE_SORT_3DOWN));
						{$IFDEF LITE}
						if rb21<>nil then rb21^.Disable;
						if rb22<>nil then rb22^.Disable;
						if rb31<>nil then rb31^.Disable;
						if rb32<>nil then rb32^.Disable;
						with PSortDialog(ADialog)^ do
							begin
								if pcb2<>nil then pcb2^.Disable;
								if pcb3<>nil then pcb3^.Disable
							end;
						{$ENDIF}
						new(PSortDialog(ADialog)^.rb1,Init(ADialog,RTSRCOLUMNS,true,BUBBLE_SORT_COLUMNS));
						new(PSortButton,Init(ADialog,RTSRROWS,true,BUBBLE_SORT_ROWS));
						new(PRadioButton,Init(ADialog,RTSRINSERT,true,BUBBLE_SORT_NUMINS));
						new(PRadioButton,Init(ADialog,RTSRPRE,true,BUBBLE_SORT_NUMPRE));
						new(PRadioButton,Init(ADialog,RTSRPOST,true,BUBBLE_SORT_NUMPOST));
						new(PCheckBox,Init(ADialog,RTSRCASE,true,BUBBLE_SORT_CASE));
						new(PRadioButton,Init(ADialog,RTSRBEGINNING,true,BUBBLE_SORT_BEGINNING));
						new(PRadioButton,Init(ADialog,RTSREND,true,BUBBLE_SORT_END));
						new(PCheckBox,Init(ADialog,RTSRUMLAUTE,true,BUBBLE_SORT_UMLAUTE));
						new(PCheckBox,Init(ADialog,RTSRABS,true,BUBBLE_SORT_ABS));
						new(PCheckBox,Init(ADialog,RTSRATTRIBUTE,true,BUBBLE_SORT_ATTR));
						new(PSortDialog(ADialog)^.bedt,Init(ADialog,RTSRBEDIT,16,false,BUBBLE_GENERAL_RANGE));
						new(pb,Init(ADialog,RTSRHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTSRABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTSRSORT,id_No,true,BUBBLE_SORT_SORT));
						new(PButton,Init(ADialog,RTSROK,id_OK,true,BUBBLE_SORT_OK));
						ADialog^.TransferBuffer:=@PCalcWindow(Parent)^.sortbuf
					end
			end;
		if ADialog<>nil then
			begin
				PSortDialog(ADialog)^.bedt^.SetText(StrPTrimF(PCalcWindow(Parent)^.dblock^.GetText));
				ADialog^.MakeWindow;
				PSortDialog(ADialog)^.ScanValues
			end
	end;

end.