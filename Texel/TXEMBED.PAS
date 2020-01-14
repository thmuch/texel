unit txembed;
{ 1999-03-07 }

interface

uses

	OWindows;


type

	POLEObject = ^TOLEObject;
	TOLEObject = object(TKeyMenu)
		{$IFNDEF LITE}
		procedure Work; virtual;
		{$ENDIF}
	end;

	PGrafik = ^TGrafik;
	TGrafik = object(TKeyMenu)
		{$IFNDEF LITE}
		procedure Work; virtual;
		procedure Load(fname: string);
		{$ENDIF}
	end;

	PTextObj = ^TTextObj;
	TTextObj = object(TKeyMenu)
		{$IFNDEF LITE}
		procedure Work; virtual;
		procedure Load(fname: string);
		{$ENDIF}
	end;
	
	PObjects = ^TObjects;
	TObjects = object(TSubMenu)
		procedure HandleMenu(Indx: integer); virtual;
	end;

	PInsertDialogElement = ^ TInsertDialogElement;
	TInsertDialogElement = object(TSubMenu)
		{$IFNDEF LITE}
		procedure HandleMenu(Indx: integer); virtual;
		{$ENDIF}
	end;




implementation

uses

	Tos,Gem,
	Objects,OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txmain;

type

	PLinkCollection = ^TLinkCollection;
	TLinkCollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;

	PLinkBox = ^TLinkBox;
	TLinkBox = object(TListBox)
		procedure Work; virtual;
	end;

{$IFNDEF LITE}

	POLEDialog = ^TOLEDialog;
	TOLEDialog = object(THyperDialog)
		trnsbuf: integer;
		plb    : PListBox;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure EndDlg(Indx: integer; DblClick: boolean); virtual;
		procedure Embed;
	end;



procedure TTextObj.Work;

	begin
		if XFileSelect(PCalcWindow(Parent),FSELTITLE_LOADTEXT,'*.txt',TexelApp.LastPath[18],TexelApp.LastFile[18],0,FSEL_LOADTEXT,false,false) then Load(TexelApp.LastPath[18]+TexelApp.LastFile[18])
	end;


procedure TTextObj.Load(fname: string);
	var pe       : PEmbeddedText;
	    p        : PCalcWindow;
	    r        : GRECT;
	    xmin,ymin,
	    xw,yh    : integer;

	begin
		p:=PCalcWindow(Parent);
		p^.GetSheetRect(r);
		if (r.W<40) then
			begin
				xmin:=r.X;
				xw:=50
			end
		else
			begin
				xmin:=r.X+(r.W shr 2);
				xw:=r.W shr 1
			end;
		if (r.H<40) then
			begin
				ymin:=r.Y;
				yh:=50
			end
		else
			begin
				ymin:=r.Y+(r.H shr 2);
				yh:=r.H shr 1
			end;
		new(pe,Init(p,fname,xmin,ymin,xw,yh,0,0,0,0,0,nil,false,true,false,false,false,true,false,nil));
		if pe<>nil then p^.SetDirty
	end;


procedure TGrafik.Work;

	begin
		if XFileSelect(PCalcWindow(Parent),FSELTITLE_LOADIMG,'*.img',TexelApp.LastPath[14],TexelApp.LastFile[14],0,FSEL_LOADIMG,true,false) then Load(TexelApp.LastPath[14]+TexelApp.LastFile[14])
	end;


procedure TGrafik.Load(fname: string);
	var pe       : PEmbeddedIMG;
	    p        : PCalcWindow;
	    r        : GRECT;
	    xmin,ymin,
	    xw,yh,hdl: integer;
	    imgh     : TIMGHeader;
	    res      : longint;
	    notbw    : boolean;

	begin
		p:=PCalcWindow(Parent);
		notbw:=true;
		res:=fopen(fname,FO_READ);
		if res>=0 then
			begin
				hdl:=integer(res);
				if fread(hdl,sizeof(TIMGHeader),@imgh)=sizeof(TIMGHeader) then notbw:=(imgh.version<>1) or (imgh.headlen<8) or (imgh.planes<>1);
				fclose(hdl)
			end;
		if notbw then p^.EmbedNewObject(fname,0,0,0,0,0,nil,nil,nil,false,false,false,true,false,true,false)
		else
			begin
				p^.GetSheetRect(r);
				if (r.W<40) then
					begin
						xmin:=r.X;
						xw:=50
					end
				else
					begin
						xmin:=r.X+(r.W shr 2);
						xw:=r.W shr 1
					end;
				if (r.H<40) then
					begin
						ymin:=r.Y;
						yh:=50
					end
				else
					begin
						ymin:=r.Y+(r.H shr 2);
						yh:=r.H shr 1
					end;
				new(pe,Init(p,fname,xmin,ymin,xw,yh,0,0,0,0,0,nil,false,true,false,false,false,true,false,nil));
				if pe<>nil then p^.SetDirty
			end
	end;


function TOLEDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then Embed;
		OK:=valid
	end;


function TOLEDialog.ExitDlg(AnIndx: integer): boolean;

	begin
		ExitDlg:=false;
		case AnIndx of
		RTOBSERVER:
			PCalcWindow(Parent)^.CallID4Server('');
		RTOBEINFUEGEN:
			if inherited OK then Embed
		end
	end;


procedure TOLEDialog.EndDlg(Indx: integer; DblClick: boolean);

	begin
		inherited EndDlg(Indx,DblClick);
		if DblClick then
			if plb<>nil then
				if plb^.TestIndex(Indx) then
					begin
						OK;
						Cont:=false;
						Result:=RTOBOK;
						Destroy
					end
	end;


procedure TOLEDialog.Embed;
	var ext: string;
	    p  : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		ext:='';
		if trnsbuf>=0 then ext:=POLEType(TexelApp.OLETypes^.At(trnsbuf))^.Ext;
		if length(ext)=0 then ext:='.*';
		if XFileSelect(p,FSELTITLE_OBJECTINSERT,'*'+ext,TexelApp.LastPath[17],TexelApp.LastFile[17],0,FSEL_EMBED,true,false) then p^.EmbedNewObject(TexelApp.LastPath[17]+TexelApp.LastFile[17],0,0,0,0,0,nil,nil,nil,false,false,false,true,false,true,false)
	end;


procedure TOLEObject.Work;
	var p : PCalcWindow;
	    pb: PButton;

	begin
		if TexelApp.OLETypes=nil then exit;
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				TexelApp.ActivateExtResource;
				ADialog:=new(POLEDialog,Init(p,TEXELWINDPREFIX+TITLE_INSOBJ,STG_INSOBJ,ICNTITLE_INSOBJ,RTOBJECT));
				if ADialog<>nil then
					begin
						new(POLEDialog(ADialog)^.plb,Init(ADialog,RTOBLIST,RTOBSLID,RTOBUP,RTOBDOWN,TexelApp.OLETypes,false,BUBBLE_INSOBJ_LIST));
						new(pb,Init(ADialog,RTOBSERVER,id_No,true,BUBBLE_INSOBJ_SERVER));
						if pb<>nil then pb^.Disable; { !!! }
						new(pb,Init(ADialog,RTOBHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTOBABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(ADialog,RTOBEINFUEGEN,id_No,true,BUBBLE_INSOBJ_INSERT));
						new(PButton,Init(ADialog,RTOBOK,id_OK,true,BUBBLE_INSOBJ_OK));
						POLEDialog(ADialog)^.trnsbuf:=0;
						ADialog^.TransferBuffer:=@POLEDialog(ADialog)^.trnsbuf
					end;
				TexelApp.DeactivateExtResource
			end;
		if ADialog<>nil then ADialog^.MakeWindow
	end;


procedure TInsertDialogElement.HandleMenu(Indx: integer);
	var p          : PCalcWindow;
	    pec        : PEmbeddedCheckBox;
	    r          : GRECT;
	    extent     : ARRAY_8;
	    dummy,
	    wchar,hchar,
	    wcell,hcell,
	    xmin,ymin,
	    xw,yh,rpt  : integer;

	begin
		p:=PCalcWindow(Parent);
		case Indx of
		0:
			{ ... };
		1:
			begin
				p^.GetSheetRect(r);
				vst_font(p^.vdiHandle,p^.GetStdFontIndex);
				rpt:=round(p^.GetStdFontSize*p^.PercentSize);
				{$IFDEF NVDI5}
				vst_arbpt(p^.vdiHandle,rpt,wchar,hchar,wcell,hcell);
				{$ELSE}
				if p^.Speedo then vst_arbpt(p^.vdiHandle,rpt,wchar,hchar,wcell,hcell)
				else
					vst_point(p^.vdiHandle,rpt,wchar,hchar,wcell,hcell);
				{$ENDIF}
				vst_rotation(p^.vdiHandle,0);
				vst_effects(p^.vdiHandle,TF_NORMAL);
				vst_alignment(p^.vdiHandle,TA_LEFT,TA_TOP,dummy,dummy);
				{$IFDEF NVDI5}
				vqt_f_extent(p^.vdiHandle,STRING_ELM_CHECKBOX,extent);
				{$ELSE}
				if p^.Speedo then vqt_f_extent(p^.vdiHandle,STRING_ELM_CHECKBOX,extent)
				else
					vqt_extent(p^.vdiHandle,STRING_ELM_CHECKBOX,extent);
				{$ENDIF}
				xw:=((extent[2]-extent[0])*3) shr 1;
				yh:=hcell shl 1;
				xmin:=r.X+((r.W-xw) shr 1);
				ymin:=r.Y+((r.H-yh) shr 1);
				new(pec,Init(p,xmin,ymin,xw,yh,0,0,0,0,0,nil,false,true,false,true,false,nil,nil));
				if pec<>nil then p^.SetDirty
			end;
		2:
			{ ... };
		end
	end;

{$ENDIF}


procedure TObjects.HandleMenu(Indx: integer);
	var p : PCalcWindow;
	    pe: PEmbedded;
	    pb: PButton;

	begin
		p:=PCalcWindow(Parent);
		case Indx of
		0:
			begin
				pe:=p^.Embedded;
				while pe<>nil do
					begin
						pe^.SetEmbedFlag;
						pe:=pe^.Next
					end
			end;
		1:
			begin
				pe:=p^.Embedded;
				while pe<>nil do
					begin
						pe^.ClearEmbedFlag;
						pe:=pe^.Next
					end
			end;
		3:
			begin
				pe:=p^.Embedded;
				while pe<>nil do
					begin
						if not(pe^.IsLocked) then
							begin
								pe^.Lock;
								pe^.Redraw
							end;
						pe:=pe^.Next
					end
			end;
		4:
			begin
				pe:=p^.Embedded;
				while pe<>nil do
					begin
						if pe^.IsLocked then
							begin
								pe^.Unlock;
								pe^.Redraw
							end;
						pe:=pe^.Next
					end
			end;
		6:
			begin
				pe:=p^.Embedded;
				while pe<>nil do
					begin
						pe^.SetPrintFlag;
						pe:=pe^.Next
					end
			end;
		7:
			begin
				pe:=p^.Embedded;
				while pe<>nil do
					begin
						pe^.ClearPrintFlag;
						pe:=pe^.Next
					end
			end;
		9:
			begin
				if p^.links=nil then
					begin
						TexelApp.ActivateExtResource;
						new(p^.links,Init(p,TEXELWINDPREFIX+TITLE_LINKS,STG_LINKS,ICNTITLE_LINKS,RTLINKS));
						if p^.links<>nil then
							begin
								p^.links^.linklist:=new(PLinkCollection,Init(20,10));
								p^.links^.plb:=new(PLinkBox,Init(p^.links,RTLILIST,RTLISLID,RTLIDEC,RTLIINC,p^.links^.linklist,true,BUBBLE_LINK_LIST));
								new(pb,Init(p^.links,RTLIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
								if pb<>nil then
									if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
								new(p^.links^.pb1,Init(p^.links,RTLICHANGE,id_No,true,BUBBLE_LINK_CHANGE));
								new(p^.links^.pb2,Init(p^.links,RTLIACTIVATE,id_No,true,BUBBLE_LINK_ACTIVATE));
								new(p^.links^.pb3,Init(p^.links,RTLIEDIT,id_No,true,BUBBLE_LINK_EDIT));
								new(PButton,Init(p^.links,RTLIOK,id_OK,true,BUBBLE_GENERAL_CLOSE));
								if p^.links^.linklist<>nil then
									begin
										pe:=p^.Embedded;
										while pe<>nil do
											begin
												p^.links^.AddObject(pe);
												pe:=pe^.Next
											end
									end
							end;
						TexelApp.DeactivateExtResource
					end;
				if p^.links<>nil then
					begin
						pe:=p^.FirstSelectedObject;
						p^.links^.MakeWindow;
						p^.links^.UpdateList(pe)
					end
			end
		end
	end;


procedure TLinkBox.Work;
	var p  : PLink;
	    sel: integer;

	begin
		p:=PLink(Parent);
		if p^.linklist=nil then
			begin
				p^.pb1^.Disable;
				p^.pb2^.Disable;
				p^.pb3^.Disable;
				exit
			end;
		sel:=GetSelection;
		if (sel<0) or (sel>=p^.linklist^.Count) then
			begin
				p^.pb1^.Disable;
				p^.pb2^.Disable;
				p^.pb3^.Disable
			end
		else
			begin
				if PLinkData(p^.linklist^.At(sel))^.ObjRef^.HasFile then p^.pb1^.Enable
				else
					p^.pb1^.Disable;
				p^.pb2^.Enable;
				p^.pb3^.Enable
			end
	end;


function TLinkCollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=PLinkData(Item)^.Descr
	end;


procedure TLinkCollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(PLinkData(Item)^.Descr);
				dispose(PLinkData(Item))
			end
	end;

end.