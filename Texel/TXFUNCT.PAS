unit txfunct;
{ 1998-07-16 }

interface

uses

	OWindows;


type

	PFunktion = ^TFunktion;
	TFunktion = object(TKeyMenu)
		procedure Work; virtual;
	end;




implementation

uses

	Strings,Gem,
	Objects,OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txmain;


type

	PCategoryBox = ^TCategoryBox;

	PCatFuncBox = ^TCatFuncBox;
	TCatFuncBox = object(TListBox)
		pcb: PCategoryBox;
		procedure Work; virtual;
	end;

	TCategoryBox = object(TListBox)
		fbox  : PCatFuncBox;
		flist : PStringCollection;
		hlpbtn: PButton;
		procedure Work; virtual;
	end;

	PFunktionDialog = ^TFunktionDialog;
	TFunktionDialog = object(TDialog)
		descr1,
		descr2: PStatic;
		fbox  : PCatFuncBox;
		function Help: boolean; virtual;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		function GetIconTitle: string; virtual;
	end;



procedure TCategoryBox.Work;
	var grp,q,sel: integer;

	begin
		if TexelApp.Functions^.Count=0 then exit;
		sel:=GetSelection;
		if sel<0 then exit;
		flist^.FreeAll;
		grp:=PCategory(TexelApp.Categories^.At(sel))^.Group;
		flist^.Sort:=true;
		flist^.CaseSensitive:=false;
		for q:=0 to TexelApp.Functions^.Count-1 do
			if (grp=0) or (PFunction(TexelApp.Functions^.At(q))^.Group=grp) then
				flist^.Insert(NewStr('  '+StrPLeft(PFunction(TexelApp.Functions^.At(q))^.Name^,30)+' '#0));
		fbox^.SetCollection(flist);
		if flist^.Count=0 then
			begin
				hlpbtn^.Disable;
				PFunktionDialog(Parent)^.descr1^.SetText('');
				PFunktionDialog(Parent)^.descr2^.SetText('')
			end
		else
			if not(TexelApp.HelpAvailable(false)) then hlpbtn^.Disable
			else
				hlpbtn^.Enable
	end;


procedure TCatFuncBox.Work;
	var grp,sel,bis,q: integer;

	begin
		if TexelApp.Functions^.Count=0 then exit;
		sel:=pcb^.GetSelection;
		if sel<0 then exit;
		grp:=PCategory(TexelApp.Categories^.At(sel))^.Group;
		bis:=GetSelection;
		for q:=0 to TexelApp.Functions^.Count-1 do
			if (grp=0) or (PFunction(TexelApp.Functions^.At(q))^.Group=grp) then
				begin
					if bis=0 then
						begin
							if PFunction(TexelApp.Functions^.At(q))^.Descr1=nil then PFunktionDialog(Parent)^.descr1^.SetText('')
							else
								PFunktionDialog(Parent)^.descr1^.SetText(PFunction(TexelApp.Functions^.At(q))^.Descr1^);
							if PFunction(TexelApp.Functions^.At(q))^.Descr2=nil then PFunktionDialog(Parent)^.descr2^.SetText('')
							else
								PFunktionDialog(Parent)^.descr2^.SetText(PFunction(TexelApp.Functions^.At(q))^.Descr2^);
							break
						end;
					dec(bis)
				end
	end;


function TFunktionDialog.Help: boolean;
	var hlp : string;
	    pipe: Pipearray;

	begin
		Help:=false;
		hlp:=StrPTrimF(PString(fbox^.List^.At(fbox^.GetSelection))^);
		if (length(hlp)=0) or not(TexelApp.HelpAvailable(true)) then exit;
		if Exist(TexelApp.DataPath+TEXELHELPREF) then StrPCopy(helpbuf,TexelApp.DataPath+TEXELHELPREF+' '''+hlp+'''')
		else
			StrPCopy(helpbuf,GUIDES+TEXELHELPREF+' '''+hlp+'''');
		pipe[0]:=VA_START;
		pipe[1]:=Application^.apID;
		pipe[2]:=0;
		pipe[3]:=integer(HiWord(helpbuf));
		pipe[4]:=integer(LoWord(helpbuf));
		pipe[5]:=0;
		pipe[6]:=0;
		pipe[7]:=0;
		appl_write(TexelApp.HelpID,16,@pipe)
	end;


function TFunktionDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTFNINSERT);
		OK:=valid
	end;


function TFunktionDialog.ExitDlg(AnIndx: integer): boolean;
	var p      : PCalcWindow;
	    txt,inp: string;
	    q,i,w  : integer;
	    tl,tr  : char;

	begin
		ExitDlg:=false;
		if AnIndx=RTFNINSERT then
			begin
				p:=PCalcWindow(Parent);
				if p^.inpline=nil then exit;
				txt:=StrPTrimF(descr1^.GetText);
				q:=pos('(',txt);
				if q>0 then
					begin
						txt:=StrPLeft(txt,q)+')';
						i:=length(txt)-1
					end
				else
					i:=length(txt);
				if p^.inpstat then
					begin
						inp:=StrPTrimF(p^.inpline^.GetText);
						if length(inp)>0 then
							if inp[1]<>'=' then
								begin
									Application^.Bing;
									exit
								end;
						if (length(inp)=0) or (inp='=') then
							begin
								inp:='='+txt;
								p^.inpline^.SetText(inp);
								p^.inpline^.SetCursor(i+1)
							end
						else
							begin
								w:=p^.inpline^.GetCursor;
								if w<1 then Application^.Bing
								else
									begin
										inp:=p^.inpline^.GetText;
										tl:=inp[w];
										if w<length(inp) then tr:=inp[w+1]
										else
											tr:=#0;
										if (tl in [' ','(','+','-','*','/','^',',','=']) and (tr in [#0,' ',')','+','-','*','/','^',',']) then
											begin
												inp:=StrPTrimF(StrPLeft(inp,w)+txt+StrPRight(inp,length(inp)-w));
												p^.inpline^.SetText(inp);
												p^.inpline^.SetCursor(w+i)
											end
										else
											Application^.Bing
									end
							end
					end
				else
					begin
						with p^.Parms.Cursor do if Block then p^.SetCursorPos(Row,Col,true);
						p^.inpline^.SetText('='+txt);
						p^.EnableInpline;
						p^.inpline^.SetCursor(i+1)
					end
			end
	end;


function TFunktionDialog.GetIconTitle: string;

	begin
		GetIconTitle:='FUNKTION'
	end;


procedure TFunktion.Work;
	var pcb: PCategoryBox;

	begin
		if ADialog=nil then
			begin
				ADialog:=new(PFunktionDialog,Init(PCalcWindow(Parent),TEXELWINDPREFIX+TITLE_FUNCTION,RTFUNCTION));
				if ADialog<>nil then
					begin
						new(pcb,Init(ADialog,RTFNCATEGORY,RTFNCATSLID,RTFNCATDEC,RTFNCATINC,TexelApp.Categories,false,BUBBLE_FN_GROUPS));
						if pcb<>nil then
							begin
								new(pcb^.flist,Init(50,20));
								new(pcb^.fbox,Init(ADialog,RTFNFUNCTION,RTFNFUNCSLID,RTFNFUNCDEC,RTFNFUNCINC,pcb^.flist,true,BUBBLE_FN_FUNCTIONS));
								if pcb^.fbox<>nil then pcb^.fbox^.pcb:=pcb;
								new(pcb^.hlpbtn,Init(ADialog,RTFNHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								PFunktionDialog(ADialog)^.fbox:=pcb^.fbox
							end
						else
							PFunktionDialog(ADialog)^.fbox:=nil;
						new(PFunktionDialog(ADialog)^.descr1,Init(ADialog,RTFNDESCR1,64,false,BUBBLE_FN_SYNTAX));
						new(PFunktionDialog(ADialog)^.descr2,Init(ADialog,RTFNDESCR2,85,false,BUBBLE_FN_DESCR));
						new(PButton,Init(ADialog,RTFNCANCEL,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTFNINSERT,id_No,true,BUBBLE_FN_INSERT));
						new(PButton,Init(ADialog,RTFNOK,id_OK,true,BUBBLE_FN_OK));
						if pcb<>nil then pcb^.Work
					end
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;

end.