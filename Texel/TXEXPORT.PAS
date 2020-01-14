unit txexport;
{ 1998-07-18 }

interface

uses

	OTypes,OWindows,
	txtypes;


type

	PExport = ^TExport;
	TExport = object(TKeyMenu)
		{$IFNDEF LITE}
		exflt,
		cmax,
		rmax,
		hdl     : integer;
		bufsize,
		bufcnt,
		res     : longint;
		buf     : PByteArray;
		filename: string;
		lend    : string[2];
		usepkt,
		werror  : boolean;
		function Export(const texbuf: TExportBuf; const fname: string): boolean;
		procedure SetFile(fname: string);
		procedure Work; virtual;
		function InitFile(var fname: string; const texbuf: TExportBuf): boolean;
		procedure ExitFile(bits: word; fname: string; const texbuf: TExportBuf);
		function bwrite(var buffer; count: longint): boolean;
		function writeline(s: string): boolean;
		function writes(s: string): boolean;
		procedure Save123(fname: string; const texbuf: TExportBuf);
		procedure SaveXLS(fname: string; const texbuf: TExportBuf);
		procedure SaveDIF(fname: string; const texbuf: TExportBuf);
		procedure SaveSYLK(fname: string; const texbuf: TExportBuf);
		procedure SaveCSV(fname: string; const texbuf: TExportBuf);
		procedure SaveASCII(fname: string; const texbuf: TExportBuf);
		procedure SaveText(fname: string; const texbuf: TExportBuf);
		procedure SaveRTF(fname: string; const texbuf: TExportBuf);
		procedure SaveLATEX(fname: string; const texbuf: TExportBuf);
		procedure SaveHTML(fname: string; const texbuf: TExportBuf);
		procedure SaveUDO(fname: string; const texbuf: TExportBuf);
		procedure SaveTXL(fname: string; const texbuf: TExportBuf);
		{$ENDIF}
	end;




implementation

{$IFNDEF LITE}

uses

	Strings,Tos,Gem,
	Objects,OProcs,ODialogs,
	txrsc,txlang,txnewvdi,txprocs,txmiscob,txsave,txmain;


type

	PExportCheckBox = ^TExportCheckBox;
	TExportCheckBox = object(TCheckBox)
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
	end;

	PExportBox = ^TExportBox;
	TExportBox = object(TComboBox)
		procedure Work; virtual;
	end;

	PExportDialog = ^TExportDialog;
	TExportDialog = object(TBlockChangeDialog)
		bedt,
		xkey1,
		xkey2,
		rkey1,
		rkey2,
		st   : PStatic;
		pb1,
		pb2,
		pb3  : PButton;
		pcb  : PExportBox;
		pcb2 : PExportFilterBox;
		pecb : PExportCheckBox;
		pg0,
		pg1,
		pg2,
		pg3,
		pg4,
		pg5,
		pg6  : PGroupBox;
		procedure BlockChanged(blk: string); virtual;
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
		procedure CheckButtons;
	end;



procedure TExportCheckBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		PExportDialog(Parent)^.CheckButtons
	end;


procedure TExportBox.Work;

	begin
		PExportDialog(Parent)^.CheckButtons
	end;


procedure TExportDialog.CheckButtons;
	var sel: integer;
	    s  : string;
	    p  : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if pecb^.GetCheck=bf_Checked then
			begin
				pb3^.Disable;
				st^.Disable;
				pb1^.Enable;
				pb2^.Enable
			end
		else
			begin
				pb3^.Enable;
				st^.Enable;
				if length(PExport(p^.export)^.filename)>0 then
					begin
						pb1^.Enable;
						pb2^.Enable
					end
				else
					begin
						pb1^.Disable;
						pb2^.Disable
					end
			end;
		if pcb=nil then exit;
		sel:=pcb^.GetSelection;
		if (sel=1) or (sel=10) or (sel=11) then pcb2^.Disable
		else
			pcb2^.Enable;
		case sel of
		1:
			begin
				pg0^.Hide(false);
				pg1^.Hide(false);
				pg2^.Hide(false);
				pg3^.Hide(false);
				pg4^.Hide(false);
				pg6^.Hide(false);
				if InitKeyTab then
					begin
						xkey1^.Hide(false);
						xkey2^.Hide(false)
					end
				else
					begin
						xkey1^.Unhide;
						xkey2^.Unhide
					end;
				InitFocus;
				pg5^.Unhide
			end;
		3:
			begin
				pg1^.Hide(false);
				pg0^.Hide(false);
				pg3^.Hide(false);
				pg4^.Hide(false);
				pg5^.Hide(false);
				pg6^.Hide(false);
				InitFocus;
				pg2^.Unhide
			end;
		4:
			begin
				pg1^.Hide(false);
				pg2^.Hide(false);
				pg0^.Hide(false);
				pg4^.Hide(false);
				pg5^.Hide(false);
				pg6^.Hide(false);
				InitFocus;
				pg3^.Unhide
			end;
		5:
			begin
				pg1^.Hide(false);
				pg2^.Hide(false);
				pg3^.Hide(false);
				pg0^.Hide(false);
				pg5^.Hide(false);
				pg6^.Hide(false);
				pg4^.Unhide;
				InitFocus
			end;
		8:
			begin
				pg0^.Hide(false);
				pg2^.Hide(false);
				pg3^.Hide(false);
				pg4^.Hide(false);
				pg5^.Hide(false);
				pg6^.Hide(false);
				InitFocus;
				pg1^.Unhide
			end;
		11:
			begin
				pg1^.Hide(false);
				pg0^.Hide(false);
				pg2^.Hide(false);
				pg3^.Hide(false);
				pg4^.Hide(false);
				pg5^.Hide(false);
				InitFocus;
				pg6^.Unhide
			end;
		else
			begin
				pg1^.Hide(false);
				pg2^.Hide(false);
				pg3^.Hide(false);
				pg4^.Hide(false);
				pg5^.Hide(false);
				pg6^.Hide(false);
				if InitKeyTab or (sel<>10) then
					begin
						rkey1^.Hide(false);
						rkey2^.Hide(false)
					end
				else
					begin
						rkey1^.Unhide;
						rkey2^.Unhide
					end;
				InitFocus;
				pg0^.Unhide
			end
		end;
		s:=PExport(p^.export)^.filename;
		if length(GetExtension(s))>0 then
			begin
				s:=GetPath(s)+GetFilename(s,false);
				case sel of
				0:
					s:=s+'.wk1';
				1:
					s:=s+'.xls';
				2:
					s:=s+'.slk';
				3:
					s:=s+'.dif';
				4:
					s:=s+'.csv';
				5,6:
					s:=s+'.txt';
				7:
					s:=s+'.tex';
				8:
					s:=s+'.html';
				9:
					s:=s+'.ui';
				10:
					s:=s+'.rtf';
				11:
					s:=s+'.txl';
				else
					s:=PExport(p^.export)^.filename
				end;
				PExport(p^.export)^.SetFile(s)
			end
	end;


procedure TExportDialog.BlockChanged(blk: string);

	begin
		if bedt<>nil then bedt^.SetText(blk)
	end;


function TExportDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then ExitDlg(RTEXEXPORT);
		OK:=valid
	end;


function TExportDialog.ExitDlg(AnIndx: integer): boolean;
	var p   : PCalcWindow;
	    mask: string;

	begin
		ExitDlg:=false;
		p:=PCalcWindow(Parent);
		case AnIndx of
		RTEXBEDIT:
			WMKeyDown(K_CTRL,Ctrl_B);
		RTEXFILE:
			if p^.export<>nil then
				begin
					if pcb=nil then
						begin
							mask:='*.*';
							TexelApp.LastFile[15]:=''
						end
					else
						begin
							mask:='*.';
							TexelApp.LastFile[15]:=GetFilename(p^.GetWindowFilename,false);
							case pcb^.GetSelection of
							0:
								begin
									mask:=mask+'wk?';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.wk1'
								end;
							1:
								begin
									mask:=mask+'xls';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.xls'
								end;
							2:
								begin
									mask:=mask+'slk';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.slk'
								end;
							3:
								begin
									mask:=mask+'dif';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.dif'
								end;
							4:
								begin
									mask:=mask+'csv';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.csv'
								end;
							5:
								begin
									mask:=mask+'*';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.txt'
								end;
							6:
								begin
									mask:=mask+'txt';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.txt'
								end;
							7:
								begin
									mask:=mask+'tex';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.tex'
								end;
							8:
								begin
									mask:=mask+'html';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.html'
								end;
							9:
								begin
									mask:=mask+'ui';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.ui'
								end;
							10:
								begin
									mask:=mask+'rtf';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.rtf'
								end;
							11:
								begin
									mask:=mask+'txl';
									if length(TexelApp.LastFile[15])>0 then TexelApp.LastFile[15]:=TexelApp.LastFile[15]+'.txl'
								end;
							else
								begin
									mask:=mask+'*';
									TexelApp.LastFile[15]:=''
								end
							end
						end;
					if XFileSelect(p,FSELTITLE_EXPORTFILE,mask,TexelApp.LastPath[15],TexelApp.LastFile[15],1,FSEL_EXPORT,false,false) then PExport(p^.export)^.SetFile(TexelApp.LastPath[15]+TexelApp.LastFile[15])
				end;
		RTEXEXPORT:
			begin
				if p^.export<>nil then
					begin
						TransferData(tf_GetData);
						PExport(p^.export)^.Export(p^.exportbuf,PExport(p^.export)^.filename)
					end
			end
		end
	end;


function TExport.Export(const texbuf: TExportBuf; const fname: string): boolean;
	var sfile: string;
	    p    : PCalcWindow;

	function getxfname(const extn: string): string;
		var ret: string;

		begin
			ret:=fname;
			if length(ret)>0 then
				begin
					TexelApp.LastPath[15]:=GetPath(ret);
					if length(GetExtension(ret))>1 then ret:=TexelApp.LastPath[15]+GetFilename(ret,true)
					else
						if length(extn)=0 then ret:=TexelApp.LastPath[15]+GetFilename(ret,false)
						else
							if ret=StrPUpper(ret) then ret:=TexelApp.LastPath[15]+GetFilename(ret,false)+'.'+StrPUpper(extn)
							else
								ret:=TexelApp.LastPath[15]+GetFilename(ret,false)+'.'+extn;
					TexelApp.LastFile[15]:=GetFilename(ret,true)
				end;
			getxfname:=ret
		end;

	begin
		if not(Between(texbuf.exporttype,0,11)) then
			begin
				Export:=false;
				exit
			end;
		Export:=true;
		p:=PCalcWindow(Parent);
		if texbuf.clipboard=bf_Checked then
			begin
				if p^.Clipboard=nil then exit;
				if not(p^.Clipboard^.OpenClipboard(false)) then exit;
				sfile:=p^.Clipboard^.GetClipboardFilename;
				p^.Clipboard^.CloseClipboard;
				case texbuf.exporttype of
				0:
					Save123(sfile+'wk1',texbuf);
				1:
					SaveXLS(sfile+'xls',texbuf);
				2:
					SaveSYLK(sfile+'slk',texbuf);
				3:
					SaveDIF(sfile+'dif',texbuf);
				4:
					SaveCSV(sfile+'csv',texbuf);
				5:
					SaveASCII(sfile+'txt',texbuf);
				6:
					SaveText(sfile+'txt',texbuf);
				7:
					SaveLATEX(sfile+'tex',texbuf);
				8:
					SaveHTML(sfile+'html',texbuf);
				9:
					SaveUDO(sfile+'ui',texbuf);
				10:
					SaveRTF(sfile+'rtf',texbuf);
				11:
					SaveTXL(sfile+'txl',texbuf)
				end
			end
		else
			case texbuf.exporttype of
			0:
				Save123(getxfname('wk1'),texbuf);
			1:
				SaveXLS(getxfname('xls'),texbuf);
			2:
				SaveSYLK(getxfname('slk'),texbuf);
			3:
				SaveDIF(getxfname('dif'),texbuf);
			4:
				SaveCSV(getxfname('csv'),texbuf);
			5:
				SaveASCII(getxfname('txt'),texbuf);
			6:
				SaveText(getxfname('txt'),texbuf);
			7:
				SaveLATEX(getxfname('tex'),texbuf);
			8:
				SaveHTML(getxfname('html'),texbuf);
			9:
				SaveUDO(getxfname('ui'),texbuf);
			10:
				SaveRTF(getxfname('rtf'),texbuf);
			11:
				SaveTXL(getxfname('txl'),texbuf)
			end
	end;


procedure TExport.SetFile(fname: string);
	var p: PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		filename:=fname;
		if ADialog<>nil then
			with PExportDialog(ADialog)^ do
				begin
					if st<>nil then st^.SetText(CompressPath(filename,19));
					if (length(filename)>0) or (p^.exportbuf.clipboard=bf_Checked) then
						begin
							pb1^.Enable;
							pb2^.Enable
						end
					else
						begin
							pb1^.Disable;
							pb2^.Disable
						end
				end
	end;


procedure TExport.Work;
	var pb  : PButton;
	    pc  : PCheckBox;
	    pv  : PValidator;
	    picb: PImportCellBox;
	    pib1,
	    pib2: PImportButton;
	    flt : PStringCollection;
	    pcb1: PHTMLDocTypeBox;
	    pcb2: PComboBox;
	    i   : integer;
	    p   : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				TexelApp.ActivateExtResource;
				ADialog:=new(PExportDialog,Init(p,TEXELWINDPREFIX+TITLE_EXPORT,STG_EXPORT,ICNTITLE_EXPORT,RTEXPORT));
				if ADialog<>nil then
					begin
						new(PExportDialog(ADialog)^.pg0,Init(ADialog,RTEXEMPTY,'',BUBBLE_EXPORT_EMPTY));
						new(PExportDialog(ADialog)^.pg1,Init(ADialog,RTEXHTML,'',BUBBLE_EXPORT_HTML));
						new(PExportDialog(ADialog)^.pg2,Init(ADialog,RTEXDIF,'',BUBBLE_EXPORT_DIF));
						new(PExportDialog(ADialog)^.pg3,Init(ADialog,RTEXCSV,'',BUBBLE_EXPORT_CSV));
						new(PExportDialog(ADialog)^.pg4,Init(ADialog,RTEXASCII,'',BUBBLE_EXPORT_ASCII));
						new(PExportDialog(ADialog)^.pg5,Init(ADialog,RTEXXLS,'',BUBBLE_EXPORT_XLS));
						new(PExportDialog(ADialog)^.pg6,Init(ADialog,RTEXTEXEL,'',BUBBLE_EXPORT_TEXEL));
						new(PGroupBox,Init(ADialog,RTEXBEREICH,'',BUBBLE_GENERAL_RANGE));
						new(PExportDialog(ADialog)^.bedt,Init(ADialog,RTEXBEDIT,16,false,BUBBLE_GENERAL_RANGE));
						new(PExportDialog(ADialog)^.pcb,Init(ADialog,RTEXFORMPOP,RTEXFORMCYC,RTEXFORMAT,RTPOPUPS2,RTP2EXPORT,id_No,true,false,BUBBLE_EXPORT_FORMATS));
						new(PExportDialog(ADialog)^.pecb,Init(ADialog,RTEXCLIPBOARD,true,BUBBLE_EXPORT_CLIPBOARD));
						new(pc,Init(ADialog,RTEXBTITLE,true,BUBBLE_EXPORT_RTITLE));
						if pc<>nil then pc^.Disable; { !!! }
						new(PExportDialog(ADialog)^.pb3,Init(ADialog,RTEXFILE,id_No,true,BUBBLE_EXPORT_FILE));
						new(PExportDialog(ADialog)^.st,Init(ADialog,RTEXFILENAME,20,false,BUBBLE_EXPORT_FILENAME));
						new(pb,Init(ADialog,RTEXHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTEXABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PExportDialog(ADialog)^.pb1,Init(ADialog,RTEXEXPORT,id_No,true,BUBBLE_EXPORT_EXPORT));
						new(PExportDialog(ADialog)^.pb2,Init(ADialog,RTEXOK,id_OK,true,BUBBLE_EXPORT_OK));
						new(PGroupBox,Init(ADialog,RTEXHTMLDTYPE,GROUP_EXPORT_DOCTYPE,BUBBLE_EXPORT_DOCTYPE));
						new(PGroupBox,Init(ADialog,RTEXHTMLEXPWITH,GROUP_EXPORT_SAVEWITH,BUBBLE_EXPORT_SAVEWITH));
						new(pcb1,Init(ADialog,RTEXHTMLDOCTYPE,RTEXHTMLDTCYC,RTEXHTMLDTTITLE,RTPOPUPS2,RTP2HTML,id_No,false,false,BUBBLE_EXPORT_DOCTYPE));
						new(PCheckBox,Init(ADialog,RTEXHTMLSAVEDT,true,BUBBLE_EXPORT_SAVEDT));
						new(PCheckBox,Init(ADialog,RTEXHTMLCOLORS,true,BUBBLE_EXPORT_COLORS));
						new(PGroupBox,Init(ADialog,RTEXCSVINHALT,GROUP_EXPORT_SAVEWITH,BUBBLE_EXPORT_SAVEWITH));
						new(PRadioButton,Init(ADialog,RTEXCSVFORMELN,true,BUBBLE_EXPORT_FORMULA));
						new(PRadioButton,Init(ADialog,RTEXCSVWERTE,true,BUBBLE_EXPORT_VALUE));
						new(PGroupBox,Init(ADialog,RTEXDIFINHALT,GROUP_EXPORT_SAVEWITH,BUBBLE_EXPORT_SAVEWITH));
						new(PRadioButton,Init(ADialog,RTEXDIFFORMELN,true,BUBBLE_EXPORT_FORMULA));
						new(PRadioButton,Init(ADialog,RTEXDIFWERTE,true,BUBBLE_EXPORT_VALUE));
						new(PGroupBox,Init(ADialog,RTEXDIFTYPE,GROUP_EXPORT_TYPE,BUBBLE_EXPORT_DIFTYPE));
						new(PRadioButton,Init(ADialog,RTEXDIFSTANDARD,true,BUBBLE_EXPORT_DIFSTAND));
						new(PRadioButton,Init(ADialog,RTEXDIFEXCEL,true,BUBBLE_EXPORT_DIFMS));
						new(PGroupBox,Init(ADialog,RTEXASCIIROWS,GROUP_GENERAL_ROWS,BUBBLE_EXPORT_ROWS));
						new(pib1,Init(ADialog,RTEXASCIIHOR,true,BUBBLE_EXPORT_LINEHOR));
						new(pib2,Init(ADialog,RTEXASCIIVER,true,BUBBLE_EXPORT_LINEVERT));
						new(PGroupBox,Init(ADialog,RTEXASCIIINHALT,GROUP_EXPORT_SAVEWITH,BUBBLE_EXPORT_SAVEWITH));
						new(pib1^.pircb,Init(ADialog,RTEXASCIIROWCOL,RTEXASCIIRCCYC,RTEXASCIIRCTITLE,RTPOPUPS2,RTP2EXROWCOL,id_No,false,true,BUBBLE_EXPORT_LINEEND));
						pib2^.pircb:=pib1^.pircb;
						if pib1^.pircb<>nil then
							if pib1^.pircb^.Edit<>nil then
								begin
									new(pv,Init);
									if pv<>nil then pv^.Options:=voNotEmpty;
									pib1^.pircb^.Edit^.SetValidator(pv)
								end;
						new(picb,Init(ADialog,RTEXASCIICELLS,RTEXASCIICCYC,RTEXASCIICTITLE,RTPOPUPS2,RTP2EXCELLS,id_No,false,true,BUBBLE_EXPORT_CELLDIV));
						if picb<>nil then
							if picb^.Edit<>nil then
								begin
									new(pv,Init);
									if pv<>nil then pv^.Options:=voNotEmpty;
									picb^.Edit^.SetValidator(pv)
								end;
						new(PImportTextBox,Init(ADialog,RTEXASCIITEXT,RTEXASCIITCYC,RTEXASCIITTITLE,RTPOPUPS2,RTP2EXTEXT,id_No,false,true,BUBBLE_EXPORT_QUOTECHAR));
						new(PCheckBox,Init(ADialog,RTEXASCIIQUOTE,true,BUBBLE_EXPORT_QUOTING));
						new(PComboBox,Init(ADialog,RTEXASCIINUMBER,RTEXASCIINCYC,RTEXASCIINTITLE,RTPOPUPS2,RTP2EXNUMBERS,id_No,true,false,BUBBLE_EXPORT_FPOINT));
						new(PRadioButton,Init(ADialog,RTEXASCIIFORMELN,true,BUBBLE_EXPORT_FORMULA));
						new(PRadioButton,Init(ADialog,RTEXASCIIWERTE,true,BUBBLE_EXPORT_VALUE));
						new(PCheckBox,Init(ADialog,RTEXDIFFORMAT,true,BUBBLE_EXPORT_DIFFORM));
						new(PCheckBox,Init(ADialog,RTEXCSVFORMAT,true,BUBBLE_EXPORT_CSVFORM));
						new(PCheckBox,Init(ADialog,RTEXASCIIFORMAT,true,BUBBLE_EXPORT_ASCIIFORM));
						new(PCheckBox,Init(ADialog,RTEXHTMLEMBED,true,BUBBLE_EXPORT_EMBED));
						new(flt,Init(10,5));
						if flt<>nil then
							begin
								flt^.Sort:=false;
								if InitKeyTab then
									for i:=0 to pkt^.GetExportCount do flt^.Insert(NewStr('  '+StrPPas(pkt^.pasGetExportName(nil,nil,0,0,0,i))+' '#0))
								else
									flt^.Insert(NewStr('  Atari '#0))
							end;
						new(PExportDialog(ADialog)^.pcb2,InitCollection(ADialog,RTEXFILTER,RTEXFCYC,RTEXFTITLE,12,flt,true,true,false,BUBBLE_EXPORT_FILTER));
						new(PCheckBox,Init(ADialog,RTEXHTMLESCAPES,true,BUBBLE_EXPORT_ESCAPES));
						new(PGroupBox,Init(ADialog,RTEXXLSVERSION,GROUP_EXPORT_XLSVER,BUBBLE_EXPORT_XLSVER));
						new(PComboBox,Init(ADialog,RTEXXLSVERNUM,RTEXXLSVERCYC,RTEXXLSVERTITLE,RTPOPUPS2,RTP2XLS,id_no,false,false,BUBBLE_EXPORT_XLSVER));
						new(pcb2,Init(ADialog,RTEXHTMLCSS,RTEXHTMLCSSCYC,RTEXHTMLCSSTITLE,RTPOPUPS2,RTP2CSS,id_no,false,false,BUBBLE_EXPORT_CSS));
						pcb1^.css:=pcb2;
						new(PExportDialog(ADialog)^.xkey1,Init(ADialog,RTEXXLSKEYTAB1,37,false,BUBBLE_EXPORT_KEYTAB));
						new(PExportDialog(ADialog)^.xkey2,Init(ADialog,RTEXXLSKEYTAB2,35,false,BUBBLE_EXPORT_KEYTAB));
						new(PExportDialog(ADialog)^.rkey1,Init(ADialog,RTEXRTFKEYTAB1,37,false,BUBBLE_EXPORT_KEYTAB));
						new(PExportDialog(ADialog)^.rkey2,Init(ADialog,RTEXRTFKEYTAB2,35,false,BUBBLE_EXPORT_KEYTAB));
						new(PGroupBox,Init(ADialog,RTEXTEXELVER,GROUP_EXPORT_TEXELVER,BUBBLE_EXPORT_TEXELVER));
						new(PComboBox,Init(ADialog,RTEXTEXELVERNUM,RTEXTEXELVERCYC,RTEXTEXELVERTTL,RTPOPUPS2,RTP2TEXEL,id_no,false,false,BUBBLE_EXPORT_TEXELVER));
						new(PCheckBox,Init(ADialog,RTEXHTMLFONTS,true,BUBBLE_EXPORT_FONTS));
						ADialog^.TransferBuffer:=@p^.exportbuf;
						if p^.exportbuf.ascii.hor=bf_Checked then pib1^.Changed(RTEXASCIIHOR,false)
						else
							pib2^.Changed(RTEXASCIIVER,false);
						SetFile('')
					end;
				TexelApp.DeactivateExtResource
			end;
		if ADialog<>nil then
			begin
				PExportDialog(ADialog)^.bedt^.SetText(StrPTrimF(p^.dblock^.GetText));
				ADialog^.MakeWindow;
				PExportDialog(ADialog)^.CheckButtons
			end
	end;


function TExport.InitFile(var fname: string; const texbuf: TExportBuf): boolean;
	var cell: PCell;
	    fn2 : string;
	    q,w : integer;
	    p   : PCalcWindow;

	begin
		InitFile:=false;
		if length(fname)=0 then exit;
		p:=PCalcWindow(Parent);
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				exit
			end;
		if texbuf.clipboard=bf_Checked then
			begin
				if p^.Clipboard=nil then exit;
				if not(p^.Clipboard^.OpenClipboard(true)) then exit;
				fname:=GetExtension(fname);
				fname:=p^.Clipboard^.GetClipboardFilename+StrPRight(fname,length(fname)-1)
			end
		else
			if Exist(fname) then
				if Application^.Alert(p,1,WAIT,MESSAGE_EXPORT_EXIST1+CompressPath(fname,78)+MESSAGE_EXPORT_EXIST2,BUTTON_YESNO)<>1 then exit;
		buf:=GetMemBuffer(16384,4096,bufsize);
		if buf=nil then exit;
		BusyMouse;
		cell:=p^.Sheet;
		rmax:=-1;
		cmax:=-1;
		for q:=0 to p^.Parms.Rows do
			for w:=0 to p^.Parms.Columns do
				begin
					if cell^.Data.Value<>0 then
						begin
							if q>rmax then rmax:=q;
							if w>cmax then cmax:=w;
						end
					else
						if p^.PColNames^[w]<>nil then
							if w>cmax then cmax:=w;
					inc(longint(cell),CELLSIZE)
				end;
		if rmax<1 then rmax:=1;
		if cmax<1 then cmax:=1;
		if TexelApp.setupbuffer.bak=bf_Checked then
			if Exist(fname) then
				begin
					fn2:=GetBackupFilename(fname);
					if Exist(fn2) then fdelete(fn2);
					frename(fname,fn2);
					TexelApp.UpdateFile(fn2,0)
				end;
		res:=fcreate(fname,0);
		if res<0 then
			begin
				freemem(buf,bufsize);
				ArrowMouse;
				exit
			end;
		hdl:=integer(res);
		bufcnt:=0;
		werror:=false;
		lend:=#13#10;
		exflt:=texbuf.filter;
		usepkt:=InitKeyTab and (exflt>=0);
		InitFile:=true
	end;


procedure TExport.ExitFile(bits: word; fname: string; const texbuf: TExportBuf);
	var p: PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if texbuf.clipboard=bf_Checked then
			begin
				p^.Clipboard^.SetClipboardFormat(bits,GetExtension(fname));
				if Between(texbuf.exporttype,2,10) then
					if StrPUpper(GetExtension(fname))<>'.TXT' then
						CopyFile(fname,p^.Clipboard^.GetClipboardFilename+'txt');
				p^.Clipboard^.CloseClipboard
			end
		else
			TexelApp.UpdateFile(fname,0)
	end;


function TExport.bwrite(var buffer; count: longint): boolean;
	var rlen: longint;

	procedure exfilter;
		var i: longint;
	
		begin
			for i:=0 to bufcnt-1 do buf^[i]:=ord(pkt^.ExportChar(nil,nil,0,0,0,exflt,chr(buf^[i])))
		end;

	begin
		if count>bufsize then
			begin
				werror:=true;
				bwrite:=true;
				exit
			end;
		bwrite:=false;
		if count<1 then
			begin
				if count=0 then exit;
				if bufcnt>0 then
					begin
						if usepkt then exfilter;
						rlen:=fwrite(hdl,bufcnt,buf);
						if rlen<>bufcnt then
							begin
								werror:=true;
								bwrite:=true
							end;
						bufcnt:=0
					end;
				exit
			end;
		if bufcnt+count>bufsize then
			begin
				if usepkt then exfilter;
				rlen:=fwrite(hdl,bufcnt,buf);
				if rlen<>bufcnt then
					begin
						werror:=true;
						bwrite:=true
					end;
				bufcnt:=0
			end;
		move(buffer,buf^[bufcnt],count);
		inc(bufcnt,count)
	end;


function TExport.writeline(s: string): boolean;

	begin
		if bwrite(s[1],length(s)) then
			begin
				writeline:=true;
				exit
			end;
		if bwrite(lend[1],2) then
			begin
				writeline:=true;
				exit
			end;
		writeline:=false
	end;


function TExport.writes(s: string): boolean;

	begin
		if bwrite(s[1],length(s)) then writes:=true
		else
			writes:=false
	end;


procedure TExport.Save123(fname: string; const texbuf: TExportBuf);

	begin
		{ ... }
	end;


procedure TExport.SaveXLS(fname: string; const texbuf: TExportBuf);
	label _ende;

	const BIT_BIFF5        = $0008;
	      BIT_BIFF4        = $0004;
	      BIT_BIFF3        = $0002;
	      
	      BOF              = $0900;
	      BOF_BIFF5        = BOF or BIT_BIFF5;
	      BOF_BIFF4        = BOF or BIT_BIFF4;
	      BOF_BIFF3        = BOF or BIT_BIFF3;

	      BIFF_EOF         = $0a00;

	      DIMENSIONS       = $0000;
	      DIMENSIONS_BIFF4 = DIMENSIONS or BIT_BIFF3;
	      DIMENSIONS_BIFF3 = DIMENSIONS or BIT_BIFF3;
	      
	      LABEL_BIFF       = $0400;
	      LABEL_BIFF3      = LABEL_BIFF or BIT_BIFF3;
	      LABEL_BIFF4      = LABEL_BIFF or BIT_BIFF3;
	      
	      BIFF_CODEPAGE    = $4200;
	      
	      BIFF_NUMBER      = $0300;
	      BIFF3_NUMBER     = BIFF_NUMBER or BIT_BIFF3;
	      BIFF4_NUMBER     = BIFF_NUMBER or BIT_BIFF3;

	      BIFF_FORMULA     = $0600;
	      BIFF3_FORMULA    = BIFF_FORMULA or BIT_BIFF3;
	      BIFF4_FORMULA    = BIFF_FORMULA or BIT_BIFF4;
	      BIFF5_FORMULA    = BIFF_FORMULA;

	      DOCTYPE_XLS      = $1000;
	      DOCTYPE_XLC      = $2000;
	      DOCTYPE_XLM      = $4000;
	      DOCTYPE_XLW      = $0001;

	      FRM_CELL         =   $44;
	      FRM_RANGE        =   $25;
	      FRM_FIXPARM      =   $41;
	      FRM_VARPARM      =   $42;
	      
	      MAXFORMLEN       =   255;

	var cwrd,
	    rwrd,
	    cwrd2,
	    rwrd2,
	    q,w,i  : integer;
	    cell   : PCell;
	    formlen,
	    hdrlen : longint;
	    hdr    : array [0..6] of word;
	    attr   : array [0..7] of byte;
	    s      : string;
	    dbl    : double;
	    pb     : PByte;
	    formbuf: array [0..MAXFORMLEN] of byte;
	    p      : PCalcWindow;

	function cell2formula: boolean;
		var error: boolean;

		procedure buildxlform(p: PNode);
			var i,anz: integer;

			begin
				if error then exit;
				if p=nil then error:=true
				else
					if p^.Typ>=5000 then
						begin
							if p^.Left.List=nil then anz:=0
							else
								begin
									anz:=p^.Count;
									for i:=0 to anz-1 do
										if p^.Left.List^[i]<>nil then
											begin
												buildxlform(PNode(p^.Left.List^[i]));
												if error then exit
											end
								end;
							if (anz<1) or (anz>$7f) or (formlen>MAXFORMLEN-3) then
								begin
									error:=true;
									exit
								end;
							formbuf[formlen]:=FRM_VARPARM;
							inc(formlen);
							formbuf[formlen]:=anz;
							inc(formlen);
							case p^.Typ of
							NT_WENN:
								begin
									formbuf[formlen]:=$01;
									inc(formlen);
								end;
							NT_SUMME:
								begin
									formbuf[formlen]:=$04;
									inc(formlen);
								end;
							else
								error:=true
							end
						end
					else
						case p^.Typ of
						NT_CONST:
							begin
								if formlen>MAXFORMLEN-9 then error:=true
								else
									begin
										formbuf[formlen]:=$1f;
										inc(formlen);
										dbl:=p^.Num^;
										pb:=@dbl;
										for i:=0 to 7 do
											begin
												formbuf[formlen+7-i]:=pb^;
												inc(longint(pb))
											end;
										inc(formlen,8)
									end
							end;
						NT_KLAMMER:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$15;
										inc(formlen)
									end
							end;
						NT_NAT_PLUS,
						NT_PLUS:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$03;
										inc(formlen)
									end
							end;
						NT_NAT_MINUS,
						NT_MINUS:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$04;
										inc(formlen)
									end
							end;
						NT_NAT_MULT,
						NT_MULT:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$05;
										inc(formlen)
									end
							end;
						NT_NAT_DIV,
						NT_DIV:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$06;
										inc(formlen)
									end
							end;
						NT_NAT_POWER,
						NT_POWER:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$07;
										inc(formlen)
									end
							end;
						NT_NAT_NEGATE,
						NT_NEGATE:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$13;
										inc(formlen)
									end
							end;
						NT_PERCENT:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$14;
										inc(formlen)
									end
							end;
						NT_EQUAL:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$0b;
										inc(formlen)
									end
							end;
						NT_GREATER:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$0d;
										inc(formlen)
									end
							end;
						NT_LESS:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$09;
										inc(formlen)
									end
							end;
						NT_GREATEREQUAL:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$0c;
										inc(formlen)
									end
							end;
						NT_LESSEQUAL:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$0a;
										inc(formlen)
									end
							end;
						NT_UNEQUAL:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-1 then error:=true
								else
									begin
										formbuf[formlen]:=$0e;
										inc(formlen)
									end
							end;
						NT_CELL:
							begin
								if formlen>MAXFORMLEN-4 then error:=true
								else
									begin
										rwrd:=p^.RowRef;
										if not(bTst(p^.Right.Flg,RF_ROWABS)) then inc(rwrd,q);
										cwrd:=p^.ColRef;
										if not(bTst(p^.Right.Flg,RF_COLABS)) then inc(cwrd,w);
										if (cwrd>$ff) or (rwrd>$3fff) then error:=true
										else
											begin
												if not(bTst(p^.Right.Flg,RF_COLABS)) then rwrd:=rwrd or $4000;
												if not(bTst(p^.Right.Flg,RF_ROWABS)) then rwrd:=rwrd or $8000;
												formbuf[formlen]:=FRM_CELL;
												inc(formlen);
												formbuf[formlen]:=lo(rwrd);
												inc(formlen);
												formbuf[formlen]:=hi(rwrd);
												inc(formlen);
												formbuf[formlen]:=cwrd;
												inc(formlen)
											end
									end
							end;
						NT_RANGE:
							begin
								if formlen>MAXFORMLEN-7 then error:=true
								else
									begin
										rwrd:=p^.Left.RowRef;
										if not(bTst(p^.Ref1Flg,RF_ROWABS)) then inc(rwrd,q);
										cwrd:=p^.Left.ColRef;
										if not(bTst(p^.Ref1Flg,RF_COLABS)) then inc(cwrd,w);
										rwrd2:=p^.Right.RowRef;
										if not(bTst(p^.Ref2Flg,RF_ROWABS)) then inc(rwrd2,q);
										cwrd2:=p^.Right.ColRef;
										if not(bTst(p^.Ref2Flg,RF_COLABS)) then inc(cwrd2,w);
										if (cwrd>$ff) or (rwrd>$3fff) or (cwrd2>$ff) or (rwrd2>$3fff) then error:=true
										else
											begin
												if not(bTst(p^.Ref1Flg,RF_COLABS)) then rwrd:=rwrd or $4000;
												if not(bTst(p^.Ref1Flg,RF_ROWABS)) then rwrd:=rwrd or $8000;
												if not(bTst(p^.Ref2Flg,RF_COLABS)) then rwrd2:=rwrd2 or $4000;
												if not(bTst(p^.Ref2Flg,RF_ROWABS)) then rwrd2:=rwrd2 or $8000;
												formbuf[formlen]:=FRM_RANGE;
												inc(formlen);
												formbuf[formlen]:=lo(rwrd);
												inc(formlen);
												formbuf[formlen]:=hi(rwrd);
												inc(formlen);
												formbuf[formlen]:=lo(rwrd2);
												inc(formlen);
												formbuf[formlen]:=hi(rwrd2);
												inc(formlen);
												formbuf[formlen]:=cwrd;
												inc(formlen);
												formbuf[formlen]:=cwrd2;
												inc(formlen)
											end
									end
							end;
						NT_FEHLER:
							begin
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=$1c;
										inc(formlen);
										formbuf[formlen]:=0;
										inc(formlen)
									end
							end;
						NT_SIN:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$0f;
										inc(formlen)
									end
							end;
						NT_COS:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$10;
										inc(formlen)
									end
							end;
						NT_TAN:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$11;
										inc(formlen)
									end
							end;
						NT_ARCTAN:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$12;
										inc(formlen)
									end
							end;
						NT_PI:
							begin
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$13;
										inc(formlen)
									end
							end;
						NT_RND:
							begin
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$3f;
										inc(formlen)
									end
							end;
						NT_SQRT:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$14;
										inc(formlen)
									end
							end;
						NT_EXP:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$15;
										inc(formlen)
									end
							end;
						NT_LN:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$16;
										inc(formlen)
									end
							end;
						NT_LOG10:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$17;
										inc(formlen)
									end
							end;
						NT_ABS:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$18;
										inc(formlen)
									end
							end;
						NT_INT:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$19;
										inc(formlen)
									end
							end;
						NT_SGN:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$1a;
										inc(formlen)
									end
							end;
						NT_FAK:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$b8;
										inc(formlen)
									end
							end;
						NT_ARCSIN:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$62;
										inc(formlen)
									end
							end;
						NT_ARCCOS:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$63;
										inc(formlen)
									end
							end;
						NT_SINH:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$e5;
										inc(formlen)
									end
							end;
						NT_COSH:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$e6;
										inc(formlen)
									end
							end;
						NT_TANH:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$e7;
										inc(formlen)
									end
							end;
						NT_ARSINH:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$e8;
										inc(formlen)
									end
							end;
						NT_ARCOSH:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$e9;
										inc(formlen)
									end
							end;
						NT_ARTANH:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$ea;
										inc(formlen)
									end
							end;
						NT_MOD:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$27;
										inc(formlen)
									end
							end;
						NT_ARCTAN2:
							begin
								buildxlform(p^.Left.Node);
								if error then exit;
								buildxlform(p^.Right.Node);
								if error then exit;
								if formlen>MAXFORMLEN-2 then error:=true
								else
									begin
										formbuf[formlen]:=FRM_FIXPARM;
										inc(formlen);
										formbuf[formlen]:=$61;
										inc(formlen)
									end
							end;
						else
							error:=true
						end
			end;

		begin
			error:=false;
			formlen:=0;
			buildxlform(cell^.Data.Formula^.Func);
			cell2formula:=not(error)
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		hdr[0]:=BOF;
		hdr[1]:=$0400;
		hdr[2]:=0;
		hdr[3]:=DOCTYPE_XLS;
		hdr[4]:=0;
		hdrlen:=8;
{		case texbuf.xlsversion of
		1:
			begin
				hdr[0]:=BOF_BIFF3;
				hdr[1]:=$0600;
				hdrlen:=10
			end;
		2:
			begin
				hdr[0]:=BOF_BIFF4;
				hdr[1]:=$0600;
				hdrlen:=10
			end;
		3:
			begin
				hdr[0]:=BOF_BIFF5;
				hdr[1]:=$0600;
				hdr[2]:=$0500;
				hdrlen:=10
			end
		end; ... }
		if bwrite(hdr,hdrlen) then goto _ende;
		hdr[0]:=BIFF_CODEPAGE;
		hdr[1]:=swap(2);
		hdr[2]:=swap($8000); { Mac }
		if bwrite(hdr,6) then goto _ende;
		hdr[0]:=DIMENSIONS;
		hdr[1]:=swap(8);
		hdr[2]:=0;
		hdr[3]:=swap(rmax);
		hdr[4]:=0;
		hdr[5]:=swap(cmax);
		hdr[6]:=0;
		hdrlen:=12;
{		case texbuf.xlsversion of
		1:
			begin
				hdr[0]:=DIMENSIONS_BIFF3;
				hdr[1]:=swap(10);
				hdrlen:=14
			end;
		2:
			begin
				hdr[0]:=DIMENSIONS_BIFF4;
				hdr[1]:=swap(10);
				hdrlen:=14
			end
		end; ... }
		if bwrite(hdr,hdrlen) then goto _ende;
		{ Spaltenbreiten !!! }
		{ Zeilenhîhen !!! }
		{ Attribute !!! }
		for q:=0 to rmax do
			begin
				cell:=p^.GetCell(q,0);
				for w:=0 to cmax do
					begin
						case cell^.Typ of
						CTYPE_TEXT:
							begin
								if cell^.Data.Txt=nil then s:=''
								else
									s:=cell^.Data.Txt^;
								hdr[0]:=LABEL_BIFF;
								hdr[1]:=swap(8+length(s));
								hdr[2]:=swap(q);
								hdr[3]:=swap(w);
								if bwrite(hdr,8) then goto _ende;
								attr[0]:=0;
								attr[1]:=0;
								attr[2]:=0;
								attr[3]:=length(s);
								if bwrite(attr,4) then goto _ende;
								if length(s)>0 then
									begin
										TexelApp.FilterExportString(KEYTAB_ID_MAC,s);
										if bwrite(s[1],length(s)) then goto _ende
									end
							end;
						CTYPE_CONST:
							begin
								hdr[0]:=BIFF_NUMBER;
								hdr[1]:=swap(15);
								hdr[2]:=swap(q);
								hdr[3]:=swap(w);
								if bwrite(hdr,8) then goto _ende;
								attr[0]:=0;
								attr[1]:=0;
								attr[2]:=0;
								if bwrite(attr,3) then goto _ende;
								dbl:=cell^.Data.Konst^.Value;
								pb:=@dbl;
								for i:=0 to 7 do
									begin
										attr[7-i]:=pb^;
										inc(longint(pb))
									end;
								if bwrite(attr,8) then goto _ende
							end;
						CTYPE_FORMULA:
							begin
								if cell2formula then
									begin
										hdr[0]:=BIFF_FORMULA;
										hdr[1]:=swap(17+formlen);
										hdr[2]:=swap(q);
										hdr[3]:=swap(w);
										if bwrite(hdr,8) then goto _ende;
										attr[0]:=0;
										attr[1]:=0;
										attr[2]:=0;
										if bwrite(attr,3) then goto _ende;
										dbl:=cell^.Data.Formula^.Value;
										pb:=@dbl;
										for i:=0 to 7 do
											begin
												attr[7-i]:=pb^;
												inc(longint(pb))
											end;
										if bwrite(attr,8) then goto _ende;
										attr[0]:=3;
										attr[1]:=formlen;
										if bwrite(attr,2) then goto _ende;
										if bwrite(formbuf,formlen) then goto _ende;
									end
								else
									begin
										hdr[0]:=BIFF_NUMBER;
										hdr[1]:=swap(15);
										hdr[2]:=swap(q);
										hdr[3]:=swap(w);
										if bwrite(hdr,8) then goto _ende;
										attr[0]:=0;
										attr[1]:=0;
										attr[2]:=0;
										if bwrite(attr,3) then goto _ende;
										dbl:=cell^.Data.Formula^.Value;
										pb:=@dbl;
										for i:=0 to 7 do
											begin
												attr[7-i]:=pb^;
												inc(longint(pb))
											end;
										if bwrite(attr,8) then goto _ende
									end
							end
						else
							begin
								{ Attribute? !!! }
							end
						end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		hdr[0]:=BIFF_EOF;
		hdr[1]:=0;
		if bwrite(hdr,4) then goto _ende;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_SHEET,fname,texbuf)
	end;


procedure TExport.SaveDIF(fname: string; const texbuf: TExportBuf);
	label _ende;

	var q,w : integer;
	    cell: PCell;
	    p   : PCalcWindow;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		if writeline('TABLE') then goto _ende;
		if writeline('0,1') then goto _ende;
		if texbuf.difstandard=bf_Checked then
			begin
				if writeline('"'+GetFileName(p^.GetWindowFilename,true)+'"') then goto _ende;
				if writeline('VECTORS') then goto _ende;
				if writeline('0,'+ltoa(cmax+1)) then goto _ende;
				if writeline('""') then goto _ende;
				if writeline('TUPLES') then goto _ende;
				if writeline('0,'+ltoa(rmax+1)) then goto _ende
			end
		else
			begin
				if writeline('"EXCEL"') then goto _ende;
				if writeline('VECTORS') then goto _ende;
				if writeline('0,'+ltoa(rmax+1)) then goto _ende;
				if writeline('""') then goto _ende;
				if writeline('TUPLES') then goto _ende;
				if writeline('0,'+ltoa(cmax+1)) then goto _ende
			end;
		if writeline('""') then goto _ende;
		for q:=0 to cmax do
			if p^.PColNames^[q]<>nil then
				begin
					if writeline('LABEL') then goto _ende;
					if writeline(ltoa(q+1)+',1') then goto _ende;
					if writeline('"'+PString(p^.PColNames^[q])^+'"') then goto _ende
				end;
		if writeline('DATA') then goto _ende;
		if writeline('0,0') then goto _ende;
		if writeline('""') then goto _ende;
		for q:=0 to rmax do
			begin
				cell:=p^.GetCell(q,0);
				if writeline('-1,0') then goto _ende;
				if writeline('BOT') then goto _ende;
				for w:=0 to cmax do
					begin
						case cell^.Typ of
						CTYPE_TEXT:
							begin
								if writeline('1,0') then goto _ende;
								if writeline('"'+cell^.Data.Txt^+'"') then goto _ende
							end;
						CTYPE_CONST:
							if (texbuf.difformula=bf_Checked) or (texbuf.difformat<>bf_Checked) then
								begin
									if writeline('0,'+TexelApp.Num2Txt(cell^.Data.Konst^.Value,MAXCIPHERS,false,false)) then goto _ende;
									if writeline('V') then goto _ende
								end
							else
								if cell^.Format=0 then
									begin
										if writeline('0,'+TexelApp.Num2Txt(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,false,false)) then goto _ende;
										if writeline('V') then goto _ende
									end
								else
									begin
										if writeline('1,0') then goto _ende;
										if writeline('"'+p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil)+'"') then goto _ende
									end;
						CTYPE_FORMULA:
							begin
								if texbuf.difformula=bf_Checked then
									begin
										if writeline('1,0') then goto _ende;
										if writeline('"'+p^.BuildFunction(cell,true)+'"') then goto _ende
									end
								else
									if (cell^.Format=0) or (texbuf.difformat<>bf_Checked) then
										begin
											if writeline('0,'+TexelApp.Num2Txt(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,false,false)) then goto _ende;
											if writeline('V') then goto _ende
										end
									else
										begin
											if writeline('1,0') then goto _ende;
											if writeline('"'+p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil)+'"') then goto _ende
										end
							end
						else
							begin
								if writeline('1,0') then goto _ende;
								if writeline('""') then goto _ende
							end
						end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		if writeline('-1,0') then goto _ende;
		if writeline('EOD') then goto _ende;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_SHEET,fname,texbuf)
	end;


procedure TExport.SaveSYLK(fname: string; const texbuf: TExportBuf);
	label _ende;

	var q,w,e,w2: integer;
	    cell    : PCell;
	    p       : PCalcWindow;

	function xform(frm: string; ro,co: integer): string;

		begin
			frm:=StrPRight(frm,length(frm)-1);
			{ A1 - > R[]C[]... }
			xform:=frm
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		if writeline('ID;PTexel '+VtoS(TEXELVER)) then goto _ende;
		if writeline('B;Y'+ltoa(rmax+1)+';X'+ltoa(cmax+1)) then goto _ende;
		if writes('O;L') then goto _ende;
		if p^.sheetbuffer.autocalc=bf_Unchecked then
			begin
				if writeline(';M') then goto _ende
			end
		else
			if writeline('') then goto _ende;
		w:=round(p^.GetColWidth(0)*2.0/(p^.wWidth*p^.PercentSize));
		q:=1;
		e:=1;
		while q<=cmax do
			begin
				w2:=round(p^.GetColWidth(q)*2.0/(p^.wWidth*p^.PercentSize));
				if w<>w2 then
					begin
						if writeline('F;W'+ltoa(e)+' '+ltoa(q)+' '+ltoa(w)) then goto _ende;
						e:=q+1;
						w:=w2
					end;
				inc(q)
			end;
		if e<>q then
			if writeline('F;W'+ltoa(e)+' '+ltoa(q)+' '+ltoa(w)) then goto _ende;
		e:=-1;
		for q:=0 to rmax do
			begin
				cell:=p^.GetCell(q,0);
				for w:=0 to cmax do
					begin
						if cell^.Data.Value<>0 then
							begin
								if writes('C;') then goto _ende;
								if e<>q then
									begin
										if writes('Y'+ltoa(q+1)+';') then goto _ende;
										e:=q
									end;
								if writes('X'+ltoa(w+1)+';K') then goto _ende;
								case cell^.Typ of
								CTYPE_TEXT:
									if writeline('"'+cell^.Data.Txt^+'"') then goto _ende;
								CTYPE_CONST:
									if writeline(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil)) then goto _ende;
								CTYPE_FORMULA:
									if writeline(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil)) then goto _ende
									{,';E',xform(cell^.Data.Formula^.Txt^,q,w) ... }
								end
							end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		if writeline('E') then goto _ende;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_SHEET,fname,texbuf)
	end;


procedure TExport.SaveCSV(fname: string; const texbuf: TExportBuf);
	label _ende;

	var q,w,
	    bis : integer;
	    cell: PCell;
	    p   : PCalcWindow;

	function toquote(s: string): string;
		var q: integer;

		begin
			q:=1;
			while q<=length(s) do
				begin
					if s[q]='"' then
						begin
							s:=StrPLeft(s,q)+StrPRight(s,length(s)+1-q);
							inc(q)
						end;
					inc(q)
				end;
			toquote:=s
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		for q:=0 to rmax do
			begin
				cell:=p^.GetCell(q,0);
				bis:=-1;
				for w:=0 to cmax do
					begin
						if cell^.Data.Value<>0 then bis:=w;
						inc(longint(cell),CELLSIZE)
					end;
				if bis>=0 then
					begin
						cell:=p^.GetCell(q,0);
						for w:=0 to cmax do
							begin
								if w>0 then
									if writes(CSVTRENN) then goto _ende;
								case cell^.Typ of
								CTYPE_TEXT:
									if writes('"'+toquote(cell^.Data.Txt^)+'"') then goto _ende;
								CTYPE_CONST:
									if (texbuf.csvformula=bf_Checked) or (texbuf.csvformat<>bf_Checked) then
										begin
											if writes(p^.Val2TxtF(cell^.Data.Konst^.Value,MAXCIPHERS,0,nil)) then goto _ende;
										end
									else
										if cell^.Format=0 then
											begin
												if writes(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,0,nil)) then goto _ende;
											end
										else
											if writes('"'+toquote(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil))+'"') then goto _ende;
								CTYPE_FORMULA:
									begin
										if texbuf.csvformula=bf_Checked then
											begin
												if writes('"'+toquote(p^.BuildFunction(cell,true))+'"') then goto _ende
											end
										else
											if (cell^.Format=0) or (texbuf.csvformat<>bf_Checked) then
												begin
													if writes(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,0,nil)) then goto _ende;
												end
											else
												if writes('"'+toquote(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil))+'"') then goto _ende
									end
								end;
								inc(longint(cell),CELLSIZE)
							end
					end;
				if writeline('') then goto _ende
			end;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_DBASE or SCF_SHEET,fname,texbuf)
	end;


procedure TExport.SaveRTF(fname: string; const texbuf: TExportBuf);
	label _ende;
	
	var fstdsize,
	    merged,
	    q,w     : integer;
	    cellx   : longint;
	    cell    : PCell;
	    xfntinfo: XFNT_INFO;
	    rgb     : ARRAY_3;
	    s       : string;
	    p       : PCalcWindow;

	function vdito255(i: integer): longint;
		var l: longint;
	
		begin
			vdito255:=round((longint(i)*longint(255))/longint(1000))
		end;
	
	function rtfmask(s: string): string;
		var i,nr : integer;
		    usekt: boolean;

		procedure quotesi;
		
			begin
				s:=StrPLeft(s,i-1)+'\'+s[i]+StrPRight(s,length(s)-i);
				inc(i)
			end;
	
		begin
			if length(s)>0 then
				begin
					i:=1;
					if InitKeyTab then
						begin
							nr:=pkt^.GetExportFilter(nil,nil,0,0,0,KEYTAB_ID_ANSI);
							usekt:=true
						end
					else
						usekt:=false;
					while i<=length(s) do
						begin
							if s[i] in ['\','{','}'] then quotesi
							else
								begin
									if usekt then s[i]:=pkt^.ExportChar(nil,nil,0,0,0,nr,s[i]);
									if (s[i]<#32) or (s[i]>#127) then
										begin
											s:=StrPLeft(s,i-1)+'\'''+HexArray[(ord(s[i]) shr 4) and $0f]+HexArray[ord(s[i]) and $0f]+StrPRight(s,length(s)-i);
											inc(i,3)
										end
								end;
							inc(i)
						end;
				end;
			rtfmask:=s
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		fstdsize:=p^.GetStdFontSize shl 1;
		if writeline('{\rtf1\ansi\deff0{\fonttbl{\f0\fnil Times;}}') then goto _ende;
		if writeline('{\colortbl;') then goto _ende;
		for q:=0 to 15 do
			begin
				if vq_color(p^.vdiHandle,q,0,rgb)<>-1 then
					begin
						if writes('\red'+ltoa(vdito255(rgb[0]))) then goto _ende;
						if writes('\green'+ltoa(vdito255(rgb[1]))) then goto _ende;
						if writes('\blue'+ltoa(vdito255(rgb[2]))) then goto _ende;
					end;
				if q=15 then
					begin
						if writeline(';}') then goto _ende
					end
				else
					if writeline(';') then goto _ende;
			end;
		if writeline('{\info') then goto _ende;
		s:=StrPTrimF(p^.infobuf.DocTitle);
		if length(s)=0 then s:=p^.GetWindowFilename;
		if writeline('{\title '+rtfmask(s)+'}') then goto _ende;
		if writeline('{\comment '+rtfmask(TexelApp.GetCreatorString)+'}') then goto _ende;
		if writeline('{\author '+rtfmask(p^.infobuf.Autor)+'}') then goto _ende;
		if writeline('{\keywords '+rtfmask(p^.infobuf.Stichwort)+'}') then goto _ende;
		s:=p^.infobuf.Rem1;
		if (length(s)>0) and (length(p^.infobuf.Rem2)>0) then s:=s+'; ';
		s:=s+p^.infobuf.Rem2;
		if (length(s)>0) and (length(p^.infobuf.Rem3)>0) then s:=s+'; ';
		s:=s+p^.infobuf.Rem3;
		if writeline('{\doccomm '+rtfmask(s)+'}}') then goto _ende;
		cellx:=1800;
		for w:=0 to cmax do inc(cellx,round(p^.GetColWidth_mm100(w)*1.44/2.54)+150);
		if writeline('\paperw'+ltoa(cellx)+'\paperh15840\margl900\margr900\margt720\margb720\pgnstart1\pgndec\widowctrl') then goto _ende;
		if writeline('\doctype0\viewkind5\viewscale'+ltoa(p^.Parms.Percent)) then goto _ende;
		if writeline('\sectd') then goto _ende;
		if writeline('\plain') then goto _ende;
		for q:=0 to rmax do
			begin
				if writeline('\trowd\trgaph70\trleft-70\trrh'+ltoa(round(p^.GetRowHeight_mm100(q)*1.44/2.54)+70)) then goto _ende;
				cellx:=0;
				merged:=0;
				cell:=p^.GetCell(q,0);
				for w:=0 to cmax do
					begin
						if merged=1 then
							begin
								if bTst(cell^.TxtVal.Flags,TFL_TEXTFROMRIGHT) then
									begin
										if writes('\clmrg') then goto _ende;
									end
								else
									merged:=2
							end;
						if merged=3 then
							begin
								if bTst(cell^.TxtVal.Flags,TFL_TEXTFROMLEFT) then
									begin
										if writes('\clmrg') then goto _ende
									end
								else
									merged:=0
							end;
						if merged=0 then
							case cell^.Typ of
							CTYPE_EMPTY:
								if bTst(cell^.TxtVal.Flags,TFL_TEXTFROMRIGHT) then
									begin
										if writes('\clmgf') then goto _ende;
										merged:=1
									end;
							CTYPE_TEXT:
								if bTst(cell^.TxtVal.Flags,TFL_TEXT2RIGHT) then
									begin
										if writes('\clmgf') then goto _ende;
										merged:=3
									end
							end;
						if merged=2 then
							begin
								if cell^.Typ=CTYPE_TEXT then
									begin
										if writes('\clmrg') then goto _ende;
										merged:=3
									end
								else
									merged:=0
							end;
						case (cell^.TxtVal.Align and $f0) of
						TA_OBEN:
							if writes('\clvertalt') then goto _ende;
						TA_UNTEN:
							if writes('\clvertalb') then goto _ende;
						else
							if writes('\clvertalc') then goto _ende;
						end;
						inc(cellx,round(p^.GetColWidth_mm100(w)*1.44/2.54)+70);
						if writes('\cellx'+ltoa(cellx)) then goto _ende;
						inc(longint(cell),CELLSIZE)
					end;
				if writeline('') then goto _ende;
				cell:=p^.GetCell(q,0);
				merged:=0;
				for w:=0 to cmax do
					begin
						if merged=1 then
							if not(bTst(cell^.TxtVal.Flags,TFL_TEXTFROMRIGHT)) then merged:=2;
						if merged=3 then
							if not(bTst(cell^.TxtVal.Flags,TFL_TEXTFROMLEFT)) then merged:=0;
						if merged=0 then
							case cell^.Typ of
							CTYPE_EMPTY:
								if bTst(cell^.TxtVal.Flags,TFL_TEXTFROMRIGHT) then merged:=1;
							CTYPE_TEXT:
								if bTst(cell^.TxtVal.Flags,TFL_TEXT2RIGHT) then merged:=3;
							end;
						if merged=2 then
							begin
								if cell^.Typ=CTYPE_TEXT then merged:=3
								else
									merged:=0
							end;
						if (merged=0) or (cell^.Typ<>CTYPE_EMPTY) then
							begin
								if writes('\pard\intbl') then goto _ende;
								if writes('\f0') then goto _ende;
								if cell^.TxtVal.Size<=0 then
									begin
										if writes('\fs'+ltoa(fstdsize)) then goto _ende;
									end
								else
									if writes('\fs'+ltoa(cell^.TxtVal.Size shl 1)) then goto _ende;
								if cell^.TxtVal.Color=White then
									begin
										if writes('\cf0') then goto _ende;
									end
								else
									if writes('\cf'+ltoa(cell^.TxtVal.Color+1)) then goto _ende;
								if writes('\cb0') then goto _ende;
								case (cell^.TxtVal.Align and $0f) of
								TA_CENTER:
									if writes('\qc') then goto _ende;
								TA_RIGHT:
									if writes('\qr') then goto _ende;
								else
									if writes('\ql') then goto _ende;
								end;
								if bTst(cell^.TxtVal.Effects,TF_THICKENED) then
									if writes('\b') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_SLANTED) then
									if writes('\i') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_UNDERLINED) then
									if writes('\ul') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_OUTLINED) then
									if writes('\outl') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_SHADOWED) then
									if writes('\shad') then goto _ende;
								if writes(' ') then goto _ende;
								case cell^.Typ of
								CTYPE_TEXT:
									if writes(rtfmask(cell^.Data.Txt^)) then goto _ende;
								CTYPE_CONST:
									if writes(rtfmask(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil))) then goto _ende;
								CTYPE_FORMULA:
									if writes(rtfmask(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil))) then goto _ende
								end;
								if bTst(cell^.TxtVal.Effects,TF_SHADOWED) then
									if writes('\shad0') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_OUTLINED) then
									if writes('\outl0') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_UNDERLINED) then
									if writes('\ul0') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_SLANTED) then
									if writes('\i0') then goto _ende;
								if bTst(cell^.TxtVal.Effects,TF_THICKENED) then
									if writes('\b0') then goto _ende;
								if writeline('\cell') then goto _ende;
							end;
						inc(longint(cell),CELLSIZE)
					end;
				if writeline('\row') then goto _ende
			end;
		if writeline('}') then goto _ende;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_TEXT,fname,texbuf)
	end;


procedure TExport.SaveLATEX(fname: string; const texbuf: TExportBuf);
	label _ende;

	var q,w,i: integer;
	    cell : PCell;
	    p    : PCalcWindow;

	function texmask(s: string): boolean;

		function replace(c: char; r: string): string;
			var s2: string;

			begin
				s2:='';
				i:=pos(c,s);
				while i>0 do
					begin
						s2:=s2+StrPLeft(s,i-1)+r;
						s:=StrPRight(s,length(s)-i);
						i:=pos(c,s)
					end;
				s:=s2+s
			end;

		begin
			texmask:=true;
			replace('"','""');
			replace('#','\#');
			replace('$','\$');
			replace('&','\&');
			replace('_','\_');
			replace('%','\%');
			replace('{','\{');
			replace('}','\}');
			replace('›','\S');
			replace(#189,'\copyright');
			replace(#188,'\P');
			replace(#156,'\pounds');
			{ Akzente etc. ... }
			replace('Ñ','"a');
			replace('î','"o');
			replace('Å','"u');
			replace('é','"A');
			replace('ô','"O');
			replace('ö','"U');
			replace('û','"s');
			replace('~','$\sim$');
			if writes(s) then exit;
			texmask:=false
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		if writeline('\begin{tabular}{*{'+ltoa(cmax+1)+'}{|c}|} \hline') then goto _ende;
		for q:=0 to rmax do
			begin
				cell:=p^.GetCell(q,0);
				for w:=0 to cmax do
					begin
						if w>0 then
							if writes(' & ') then goto _ende;
						case cell^.Typ of
						CTYPE_TEXT:
							if texmask(cell^.Data.Txt^) then goto _ende;
						CTYPE_CONST:
							if texmask(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil)) then goto _ende;
						CTYPE_FORMULA:
							if texmask(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil)) then goto _ende
						end;
						inc(longint(cell),CELLSIZE)
					end;
				if writeline(' \\ \hline') then goto _ende
			end;
		if writeline('\end{tabular}') then goto _ende;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_TEXT,fname,texbuf)
	end;


procedure TExport.SaveASCII(fname: string; const texbuf: TExportBuf);
	label _ende;

	var q,w,art,lq: integer;
	    loffs     : longint;
	    cell      : PCell;
	    rctrenn,
	    celltrenn,
	    tquote    : string;
	    numtrenn  : char;
	    hor,quote,
	    formula   : boolean;
	    p         : PCalcWindow;

	function toquote(s: string): string;
		var q: integer;

		begin
			if quote then
				if lq>0 then
					begin
						q:=1;
						if StrPMid(s,q,lq)=tquote then
							begin
								s:=StrPLeft(s,q+lq-1)+StrPRight(s,length(s)+1-q);
								inc(q,lq shl 1)
							end
						else
							inc(q)
					end;
			toquote:=s
		end;

	function tonum(s: string): string;
		var q: integer;

		begin
			if numtrenn<>DEZTRENNPUNKT then
				begin
					q:=pos(DEZTRENNPUNKT,s);
					while q>0 do
						begin
							s[q]:=numtrenn;
							q:=pos(DEZTRENNPUNKT,s)
						end
				end;
			tonum:=s
		end;

	function writecell: boolean;
	
		begin
			writecell:=true;
			if w>0 then
				if writes(celltrenn) then exit;
			case cell^.Typ of
			CTYPE_TEXT:
				if writes(tquote+toquote(cell^.Data.Txt^)+tquote) then exit;
			CTYPE_CONST:
				if formula or (texbuf.asciiformat<>bf_Checked) then
					begin
						if writes(tonum(TexelApp.Num2Txt(cell^.Data.Konst^.Value,MAXCIPHERS,false,false))) then exit;
					end
				else
					if cell^.Format=0 then
						begin
							if writes(tonum(TexelApp.Num2Txt(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,false,false))) then exit;
						end
					else
						if writes(tquote+toquote(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil))+tquote) then exit;
			CTYPE_FORMULA:
				begin
					if formula then
						begin
							if writes(tquote+toquote(p^.BuildFunction(cell,true))+tquote) then exit
						end
					else
						if (cell^.Format=0) or (texbuf.asciiformat<>bf_Checked) then
							begin
								if writes(tonum(TexelApp.Num2Txt(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,false,false))) then exit;
							end
						else
							if writes(tquote+toquote(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil))+tquote) then exit
				end
			end;
			writecell:=false
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		rctrenn:=TexelApp.num2str(texbuf.ascii.rcTxt);
		celltrenn:=TexelApp.num2str(texbuf.ascii.cellTxt);
		tquote:=TexelApp.num2str(texbuf.ascii.textTxt);
		if texbuf.ascii.numbers=1 then numtrenn:=DEZTRENNKOMMA
		else
			numtrenn:=DEZTRENNPUNKT;
		hor:=(texbuf.ascii.hor=bf_Checked);
		quote:=(texbuf.ascii.quote=bf_Checked);
		formula:=(texbuf.ascii.formula=bf_Checked);
		lq:=length(tquote);
		if hor then
			for q:=0 to rmax do
				begin
					cell:=p^.GetCell(q,0);
					for w:=0 to cmax do
						begin
							if writecell then goto _ende;
							inc(longint(cell),CELLSIZE)
						end;
					if writes(rctrenn) then goto _ende
				end
		else
			begin
				loffs:=CELLSIZE*longint(p^.Parms.Columns+1);
				for q:=0 to cmax do
					begin
						cell:=p^.GetCell(0,q);
						for w:=0 to rmax do
							begin
								if writecell then goto _ende;
								inc(longint(cell),loffs)
							end;
						if writes(rctrenn) then goto _ende
					end
			end;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_DBASE or SCF_TEXT or SCF_SHEET,fname,texbuf)
	end;


procedure TExport.SaveText(fname: string; const texbuf: TExportBuf);
	label _ende,_raus;

	var q,w : integer;
	    cell: PCell;
	    pc  : PIntegerArray;
	    p   : PCalcWindow;

	function writecell(const ct: string; col: integer): boolean;
		var h: integer;

		begin
			writecell:=true;
			case (cell^.TxtVal.Align and $0f) of
			TA_RIGHT:
				if writes(StrPSpace(pc^[col]-length(ct))+ct+' ') then exit;
			TA_CENTER:
				begin
					h:=(pc^[col]-length(ct)) shr 1;
					if writes(StrPSpace((pc^[col]-length(ct))-h)+ct+StrPSpace(h+1)) then exit
				end
			else
				if writes(ct+StrPSpace(pc^[col]+1-length(ct))) then exit
			end;
			writecell:=false
		end;

	procedure checkcell(cl,col: integer);

		begin
			if cl>pc^[col] then pc^[col]:=cl
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		getmem(pc,(cmax+1) shl 1);
		if pc=nil then goto _ende;
		{$IFNDEF DEMO}
		for w:=0 to cmax do pc^[w]:=round(p^.GetColWidth(w)/(p^.wWidth*p^.PercentSize));
		for q:=0 to rmax do
			begin
				cell:=p^.GetCell(q,0);
				for w:=0 to cmax do
					begin
						case cell^.Typ of
						CTYPE_TEXT:
							checkcell(length(cell^.Data.Txt^),w);
						CTYPE_CONST:
							checkcell(length(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil)),w);
						CTYPE_FORMULA:
							checkcell(length(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil)),w)
						end;
						inc(longint(cell),CELLSIZE)
					end
			end;
		for q:=0 to rmax do
			begin
				cell:=p^.GetCell(q,0);
				for w:=0 to cmax do
					begin
						case cell^.Typ of
						CTYPE_TEXT:
							if writecell(cell^.Data.Txt^,w) then goto _raus;
						CTYPE_CONST:
							if writecell(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil),w) then goto _raus;
						CTYPE_FORMULA:
							if writecell(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil),w) then goto _raus;
						else
							if writecell('',w) then goto _raus
						end;
						inc(longint(cell),CELLSIZE)
					end;
				if writeline('') then goto _raus
			end;
		bwrite(q,-1);
		{$ENDIF}
		_raus:
		freemem(pc,(cmax+1) shl 1);
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_TEXT,fname,texbuf)
	end;


procedure TExport.SaveHTML(fname: string; const texbuf: TExportBuf);
	label _ende;

	var q,w,vqc,
	    fsize,
	    walt,
	    fstdsize: integer;
	    cell2,
	    cell    : PCell;
	    rgb     : ARRAY_3;
	    colors,
	    fntnames,
	    escapes,
	    one,
	    css1,
	    attr1,
	    html40,
	    html30,
	    html32  : boolean;
	    pe      : PEmbedded;
	    sf,se   : string;
	    xfntinfo: XFNT_INFO;
	    p       : PCalcWindow;

	function htmlmask(s: string): boolean;
		var s2: string;
		    i : integer;

		function replace(c: char; r: string): string;

			begin
				s2:='';
				i:=pos(c,s);
				while i>0 do
					begin
						s2:=s2+StrPLeft(s,i-1)+r;
						s:=StrPRight(s,length(s)-i);
						i:=pos(c,s)
					end;
				s:=s2+s
			end;

		begin
			htmlmask:=true;
			if escapes then
				begin
					replace('&','&amp;');
					replace('<','&lt;');
					replace('>','&gt;');
					replace('"','&quot;')
				end;
			replace('Ñ','&auml;');
			replace('î','&ouml;');
			replace('Å','&uuml;');
			replace('é','&Auml;');
			replace('ô','&Ouml;');
			replace('ö','&Uuml;');
			replace('û','&szlig;');
			replace(#173,'&iexcl;');
			replace(#155,'&cent;');
			replace(#156,'&pound;');
			replace(#157,'&yen;');
			replace(#185,'&uml;');
			replace(#189,'&copy;');
			replace(#170,'&not;');
			replace(#190,'&reg;');
			replace(#248,'&deg;');
			replace(#241,'&plusmn;');
			replace(#253,'&sup2;');
			replace(#254,'&sup3;');
			replace(#230,'&micro;');
			replace(#188,'&para;');
			replace(#250,'&middot;');
			replace(#146,'&AElig;');
			replace(#182,'&Agrave;');
			replace(#143,'&Aring;');
			replace(#183,'&Atilde;');
			replace(#128,'&Ccedil;');
			replace(#144,'&Eacute;');
			replace(#165,'&Ntilde;');
			replace(#178,'&Oslash;');
			replace(#184,'&Otilde;');
			replace(#160,'&aacute;');
			replace(#131,'&acirc;');
			replace(#145,'&aelig;');
			replace(#133,'&agrave;');
			replace(#134,'&aring;');
			replace(#176,'&atilde;');
			replace(#135,'&ccedil;');
			replace(#130,'&eacute;');
			replace(#136,'&ecirc;');
			replace(#138,'&egrave;');
			replace(#137,'&euml;');
			replace(#161,'&iacute;');
			replace(#140,'&icirc;');
			replace(#141,'&igrave;');
			replace(#139,'&iuml;');
			replace(#164,'&ntilde;');
			replace(#162,'&oacute;');
			replace(#147,'&ocirc;');
			replace(#149,'&ograve;');
			replace(#179,'&oslash;');
			replace(#177,'&otilde;');
			replace(#163,'&uacute;');
			replace(#150,'&ucirc;');
			replace(#151,'&ugrave;');
			replace(#152,'&yuml;');
			replace('›','&sect;');
			replace(#186,'&acute;');
			replace(#255,'&macr;');
			replace(#174,'&laquo;');
			replace('|','&brvbar;');
			replace(#193,'&Aacute;');
			replace(#194,'&Acirc;');
			replace(#208,'&ETH;');
			replace(#202,'&Ecirc;');
			replace(#200,'&Egrave;');
			replace(#203,'&Euml;');
			replace(#205,'&Iacute;');
			replace(#206,'&Icirc;');
			replace(#204,'&Igrave;');
			replace(#207,'&Iuml;');
			replace(#211,'&Oacute;');
			replace(#212,'&Ocirc;');
			replace(#210,'&Ograve;');
			replace(#222,'&THORN;');
			replace(#218,'&Uacute;');
			replace(#219,'&Ucirc;');
			replace(#217,'&Ugrave;');
			replace(#240,'&eth;');
			if writes(s) then exit;
			htmlmask:=false
		end;

	function rgb2hex(st: integer): string;

		function int2hex(i: longint): string;

			begin
				if Between(st,1,6) then inc(i,((1000-i)*(7-st)) div 7);
				int2hex:=StrPRight(ltoh((i*255) div 1000,2),2)
			end;

		begin
			rgb2hex:='#'+StrPUpper(int2hex(rgb[0])+int2hex(rgb[1])+int2hex(rgb[2]))
		end;

	function rgb2rgb(st: integer): string;

		function int2int(i: longint): longint;

			begin
				if Between(st,1,6) then inc(i,((1000-i)*(7-st)) div 7);
				int2int:=(i*255) div 1000
			end;

		begin
			rgb2rgb:='rgb('+ltoa(int2int(rgb[0]))+','+ltoa(int2int(rgb[1]))+','+ltoa(int2int(rgb[2]))+')'
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		colors:=(texbuf.htmlcolor=bf_Checked);
		fntnames:=(texbuf.htmlfonts=bf_Checked);
		escapes:=(texbuf.htmlnoesc=bf_Unchecked);
		html30:=(texbuf.htmldoctype=0);
		html32:=(texbuf.htmldoctype=1);
		html40:=(texbuf.htmldoctype=2);
		css1:=html40 and (texbuf.htmlcss=1);
		fstdsize:=p^.GetStdFontSize;
		if texbuf.htmlsavedt=bf_Checked then
			begin
				if html40 then
					begin
						if css1 then
							begin
								if writeline('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN"') then goto _ende;
								if writeline('  "http://www.w3.org/TR/REC-html40/strict.dtd">') then goto _ende
							end
						else
							begin
								if writeline('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"') then goto _ende;
								if writeline('  "http://www.w3.org/TR/REC-html40/loose.dtd">') then goto _ende
							end
					end
				else if html32 then
					begin
						if writeline('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">') then goto _ende;
					end
				else
					if writeline('<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 3.0//EN">') then goto _ende;
			end;
		if not(html40) then
			if writeline('<HTML>') then goto _ende;
		if html30 then
			if writeline('<HEAD>') then goto _ende;
		if writes('<TITLE>') then goto _ende;
		se:=StrPTrimF(p^.infobuf.DocTitle);
		if length(se)=0 then se:=p^.GetWindowFilename;
		if htmlmask(se) then goto _ende;
		if writeline('</TITLE>') then goto _ende;
		if texbuf.htmlsavedt=bf_Checked then
			begin
				if writeline('<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=iso-8859-1">') then goto _ende;
				se:=StrPTrimF(p^.infobuf.Autor);
				if length(se)>0 then
					begin
						if writes('<META NAME="AUTHOR" CONTENT="') then goto _ende;
						if htmlmask(se) then goto _ende;
						if writeline('">') then goto _ende;
					end
			end;
		if writes('<META NAME="GENERATOR" CONTENT="') then goto _ende;
		if htmlmask(TexelApp.GetShortCreatorString) then goto _ende;
		if writeline('">') then goto _ende;
		if html30 then
			begin
				if writeline('</HEAD>') then goto _ende;
				if writeline('<BODY>') then goto _ende
			end;
		if writeline('') then goto _ende;
		if writes('<TABLE') then goto _ende;
		if p^.Parms.psbuffer.gitter=bf_Checked then
			if writes(' BORDER') then goto _ende;
		if html40 then
			begin
				if writes(' COLS="') then goto _ende;
				if p^.Parms.psbuffer.rows=bf_Checked then
					begin
						if writes(ltoa(cmax+2)) then goto _ende
					end
				else
					if writes(ltoa(cmax+1)) then goto _ende;
				if writes('"') then goto _ende
			end;
		if writeline('>') then goto _ende;
		if p^.Parms.psbuffer.columns=bf_Checked then
			begin
				if html40 then
					if writeline('<THEAD>') then goto _ende;
				if writeline('  <TR>') then goto _ende;
				if p^.Parms.psbuffer.rows=bf_Checked then
					begin
						if writes('    <TH>') then goto _ende;
						if html30 then
							begin
								if writeline('</TH>') then goto _ende
							end
						else
							if writeline('') then goto _ende
					end;
				for w:=0 to cmax do
					begin
						if writes('    <TH>') then goto _ende;
						if htmlmask(p^.GetColumnName(w)) then goto _ende;
						if html30 then
							begin
								if writeline('</TH>') then goto _ende
							end
						else
							if writeline('') then goto _ende
					end;
				if html30 then
					if writeline('  </TR>') then goto _ende
			end;
		if html40 then
			if writeline('<TBODY>') then goto _ende;
		for q:=0 to rmax do
			begin
				if writeline('  <TR>') then goto _ende;
				if writes('    ') then goto _ende;
				if p^.Parms.psbuffer.rows=bf_Checked then
					begin
						if html30 then
							begin
								if writeline('<TH>'+p^.GetRowIndex(q)+'</TH>') then goto _ende
							end
						else
							if writeline('<TH>'+p^.GetRowIndex(q)) then goto _ende;
						if writes('    ') then goto _ende
					end;
				w:=0;
				repeat
					walt:=w;
					cell:=p^.GetCell(q,w);
					if cell^.Typ=CTYPE_EMPTY then
						if bTst(cell^.TxtVal.Flags,TFL_TEXTFROMRIGHT) then
							begin
								cell2:=cell;
								while bTst(cell2^.TxtVal.Flags,TFL_TEXTFROMRIGHT) do
									begin
										inc(w);
										inc(longint(cell2),CELLSIZE)
									end;
								cell:=cell2
							end;
					if cell^.Typ=CTYPE_TEXT then
						if bTst(cell^.TxtVal.Flags,TFL_TEXT2RIGHT) then
							begin
								cell2:=PCell(longint(cell)+CELLSIZE);
								while bTst(cell2^.TxtVal.Flags,TFL_TEXTFROMLEFT) do
									begin
										inc(w);
										inc(longint(cell2),CELLSIZE)
									end
							end;
					if writes('<TD') then goto _ende;
					if cell^.Typ<>CTYPE_EMPTY then
						begin
							if w>walt then
								if writes(' COLSPAN='+ltoa(w+1-walt)) then goto _ende;
							if not(css1) then
								begin
									case (cell^.TxtVal.Align and $0f) of
									TA_CENTER:
										if writes(' ALIGN=CENTER') then goto _ende;
									TA_RIGHT:
										if writes(' ALIGN=RIGHT') then goto _ende
									end;
									case (cell^.TxtVal.Align and $f0) of
									TA_OBEN:
										if writes(' VALIGN=TOP') then goto _ende;
									TA_UNTEN:
										if writes(' VALIGN=BOTTOM') then goto _ende
									end
								end
						end;
					if css1 then
						begin
							if writes(' STYLE="') then goto _ende;
							attr1:=false;
							if colors then
								begin
									if cell^.Interior=FIS_HOLLOW then
										begin
											if writes('background-color: rgb(255,255,255)') then goto _ende;
											attr1:=true
										end
									else
										if vq_color(p^.vdiHandle,cell^.Color,0,rgb)<>-1 then
											begin
												if cell^.Interior=FIS_SOLID then
													begin
														if writes('background-color: '+rgb2rgb(0)) then goto _ende;
														attr1:=true
													end
												else
													begin
														if writes('background-color: '+rgb2rgb(cell^.Style)) then goto _ende;
														attr1:=true
													end
											end
								end;
							if cell^.Typ<>CTYPE_EMPTY then
								begin
									if attr1 then
										if writes('; ') then goto _ende;
									if writes('text-align: ') then goto _ende;
									case (cell^.TxtVal.Align and $0f) of
									TA_CENTER:
										if writes('center') then goto _ende;
									TA_RIGHT:
										if writes('right') then goto _ende;
									else
										if writes('left') then goto _ende;
									end;
									if writes('; vertical-align: ') then goto _ende;
									case (cell^.TxtVal.Align and $f0) of
									TA_OBEN:
										if writes('top') then goto _ende;
									TA_UNTEN:
										if writes('bottom') then goto _ende;
									else
										if writes('middle') then goto _ende;
									end;
									if colors then
										begin
											vqc:=vq_color(p^.vdiHandle,cell^.TxtVal.Color,0,rgb);
											if vqc<>-1 then
												if writes('; color: '+rgb2rgb(0)) then goto _ende;
											if fntnames then
												begin
													xfntinfo.size:=sizeof(XFNT_INFO);
													if vqtXFntInfo(p^.vdiHandle,cell^.TxtVal.Font,6,@xfntinfo) then
														begin
															if StrLen(xfntinfo.family_name)>0 then
																if writes('; font-family: '''+StrPas(xfntinfo.family_name)+'''') then goto _ende;
															if StrLen(xfntinfo.style_name)>0 then
																begin
																	if stricomp(xfntinfo.style_name,'roman')=0 then
																		begin
																			if writes('; font-style: normal') then goto _ende;
																		end
																	else
																		if writes('; font-style: '+StrPLower(StrPas(xfntinfo.style_name))) then goto _ende;
																end;
														end;
													if writes('; font-size: '+ltoa(cell^.TxtVal.Size)+'pt') then goto _ende;
												end
										end
								end;
							if writes('"') then goto _ende
						end;
					if not(colors) or css1 then
						begin
							if writes('>') then goto _ende
						end
					else
						if cell^.Interior=FIS_HOLLOW then
							begin
								if writes(' BGCOLOR=#FFFFFF>') then goto _ende
							end
						else
							if vq_color(p^.vdiHandle,cell^.Color,0,rgb)=-1 then
								begin
									if writes('>') then goto _ende
								end
							else
								if cell^.Interior=FIS_SOLID then
									begin
										if writes(' BGCOLOR='+rgb2hex(0)+'>') then goto _ende
									end
								else
									if writes(' BGCOLOR='+rgb2hex(cell^.Style)+'>') then goto _ende;
					if cell^.Typ=CTYPE_EMPTY then
						begin
							if colors and not(css1) then
								if writes('&nbsp;') then goto _ende;
						end
					else
						begin
							if colors and not(css1) then
								begin
									if writes('<FONT') then goto _ende;
									vqc:=vq_color(p^.vdiHandle,cell^.TxtVal.Color,0,rgb);
									if vqc<>-1 then
										if writes(' COLOR='+rgb2hex(0)) then goto _ende;
									if fntnames then
										begin
											fsize:=((cell^.TxtVal.Size-fstdsize) shr 1);
											if fsize<>0 then
												begin
													if writes(' SIZE=') then goto _ende;
													if fsize>=0 then
														if writes('+') then goto _ende;
													if writes(ltoa(Min(7,Max(-7,fsize)))) then goto _ende;
												end;
											xfntinfo.size:=sizeof(XFNT_INFO);
											if vqtXFntInfo(p^.vdiHandle,cell^.TxtVal.Font,1,@xfntinfo) then
												if writes(' FACE="'+StrPTrimF(StrPas(xfntinfo.font_name))+'"') then goto _ende;
										end;
									if writes('>') then goto _ende
								end;
							if bTst(cell^.TxtVal.Effects,TF_THICKENED) then
								if writes('<B>') then goto _ende;
							if bTst(cell^.TxtVal.Effects,TF_SLANTED) then
								if writes('<I>') then goto _ende;
							if bTst(cell^.TxtVal.Effects,TF_UNDERLINED) then
								if not(html40) then
									if writes('<U>') then goto _ende;
							case cell^.Typ of
							CTYPE_TEXT:
								if htmlmask(cell^.Data.Txt^) then goto _ende;
							CTYPE_CONST:
								if htmlmask(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil)) then goto _ende;
							CTYPE_FORMULA:
								if htmlmask(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil)) then goto _ende
							end;
							if bTst(cell^.TxtVal.Effects,TF_UNDERLINED) then
								if not(html40) then
									if writes('</U>') then goto _ende;
							if bTst(cell^.TxtVal.Effects,TF_SLANTED) then
								if writes('</I>') then goto _ende;
							if bTst(cell^.TxtVal.Effects,TF_THICKENED) then
								if writes('</B>') then goto _ende;
							if colors and not(css1) then
								if vqc<>-1 then
									if writes('</FONT>') then goto _ende;
						end;
					if html30 then
						begin
							if writeline('</TD>') then goto _ende
						end
					else
						if writeline('') then goto _ende;
					if w<cmax then
						if writes('    ') then goto _ende;
					inc(w)
				until w>cmax;
				if html30 then
					if writeline('  </TR>') then goto _ende
			end;
		if writeline('</TABLE>') then goto _ende;
		if writeline('') then goto _ende;
		if texbuf.htmlembed=bf_Checked then
			begin
				pe:=p^.Embedded;
				one:=false;
				while pe<>nil do
					begin
						sf:=pe^.GetFile;
						if length(sf)>0 then
							begin
								if not(one) then
									if writeline('<BR>') then goto _ende;
								se:=StrPUpper(GetExtension(sf));
								if (se='.GIF') or (se='.JPG') then
									begin
										if writeline('<IMG SRC='+sf+'>') then goto _ende
									end
								else
									begin
										if writeline('<EMBED SRC='+sf+' WIDTH='+ltoa(pe^.GetPixWidth(true))+' HEIGHT='+ltoa(pe^.GetPixHeight(true))+'>') then goto _ende
									end;
								one:=true
							end;
						pe:=pe^.Next
					end;
				if one then
					if writeline('') then goto _ende;
			end;
		if html30 then
			if writeline('</BODY>') then goto _ende;
		if not(html40) then
			if writeline('</HTML>') then goto _ende;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_TEXT,fname,texbuf)
	end;


procedure TExport.SaveUDO(fname: string; const texbuf: TExportBuf);
	label _ende;

	var q,w : integer;
	    cell: PCell;
	    p   : PCalcWindow;
	    ts  : string;

	function udomask(s: string): boolean;

		begin
			udomask:=true;
			{ ... }
			if writes(s) then exit;
			udomask:=false
		end;

	begin
		p:=PCalcWindow(Parent);
		if not(InitFile(fname,texbuf)) then exit;
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				goto _ende
			end;
		{$IFNDEF DEMO}
		if p^.Parms.psbuffer.columns=bf_Checked then rmax:=Min(254,rmax)
		else
			rmax:=Min(255,rmax);
		if p^.Parms.psbuffer.rows=bf_Checked then cmax:=Min(30,cmax)
		else
			cmax:=Min(31,cmax);
		ts:=StrPTrimF(p^.infobuf.DocTitle);
		if length(ts)=0 then ts:=p^.GetWindowFilename;
		if writeline('!table_caption '+ts) then goto _ende;
		if writes('!begin_table [') then goto _ende;
		if p^.Parms.psbuffer.gitter=bf_Checked then
			begin
				if p^.Parms.psbuffer.rows=bf_Checked then
					if writes('|c') then goto _ende;
				for w:=0 to cmax do
					if writes('|l') then goto _ende;
				if writeline('|] !hline') then goto _ende
			end
		else
			begin
				if p^.Parms.psbuffer.rows=bf_Checked then
					if writes('c') then goto _ende;
				if writeline(StrPFill(cmax+1,'l')+']') then goto _ende
			end;
		if p^.Parms.psbuffer.columns=bf_Checked then
			begin
				if p^.Parms.psbuffer.rows=bf_Checked then
					if writes(' !! ') then goto _ende;
				for w:=0 to cmax do
					begin
						if udomask(p^.GetColumnName(w)) then goto _ende;
						if w<cmax then
							if writes(' !! ') then goto _ende
					end;
				if writeline('') then goto _ende
			end;
		for q:=0 to rmax do
			begin
				if p^.Parms.psbuffer.rows=bf_Checked then
					if writes(p^.GetRowIndex(q)+' !! ') then goto _ende;
				cell:=p^.GetCell(q,0);
				for w:=0 to cmax do
					begin
						case cell^.Typ of
						CTYPE_TEXT:
							if udomask(cell^.Data.Txt^) then goto _ende;
						CTYPE_CONST:
							if udomask(p^.Val2TxtF(cell^.Data.Konst^.Value,cell^.Data.Konst^.FPts,cell^.Format,nil)) then goto _ende;
						CTYPE_FORMULA:
							if udomask(p^.Val2TxtF(cell^.Data.Formula^.Value,cell^.Data.Formula^.FPts,cell^.Format,nil)) then goto _ende
						end;
						if w<cmax then
							if writes(' !! ') then goto _ende;
						inc(longint(cell),CELLSIZE)
					end;
				if writeline('') then goto _ende
			end;
		if p^.Parms.psbuffer.gitter=bf_Checked then
			if writeline('!hline') then goto _ende;
		if writeline('!end_table') then goto _ende;
		bwrite(q,-1);
		{$ENDIF}
		_ende:
		fclose(hdl);
		freemem(buf,bufsize);
		ArrowMouse;
		ExitFile(SCF_TEXT,fname,texbuf)
	end;


procedure TExport.SaveTXL(fname: string; const texbuf: TExportBuf);
	label _raus;
	
	var p: PCalcWindow;

	begin
		if length(fname)=0 then exit;
		p:=PCalcWindow(Parent);
		if not(KeyCorrect(regname,regkey)) then
			begin
				DemoAlert(p);
				exit
			end;
		BusyMouse;
		if texbuf.clipboard=bf_Checked then
			begin
				if p^.Clipboard=nil then goto _raus;
				if not(p^.Clipboard^.OpenClipboard(true)) then goto _raus;
				fname:=GetExtension(fname);
				fname:=p^.Clipboard^.GetClipboardFilename+StrPRight(fname,length(fname)-1)
			end
		else
			if Exist(fname) then
				if Application^.Alert(p,1,WAIT,MESSAGE_EXPORT_EXIST1+CompressPath(fname,78)+MESSAGE_EXPORT_EXIST2,BUTTON_YESNO)<>1 then goto _raus;
		{$IFNDEF DEMO}
		case texbuf.texelvers of
		0:
			PSave(p^.save)^.Save(fname,33); { 1.6 }
		1:
			PSave(p^.save)^.Save(fname,38); { 2.0 }
		2:
			PSave(p^.save)^.Save(fname,43); { 2.1 }
		else
			{ 1.5 = 30, 1.1 = 20 }
			PSave(p^.save)^.Save(fname,TEXELCOMPAT);
		end;
		{$ENDIF}
		if texbuf.clipboard=bf_Checked then
			begin
				p^.Clipboard^.SetClipboardFormat(SCF_SHEET,GetExtension(fname));
				p^.Clipboard^.CloseClipboard
			end;
		_raus:
		ArrowMouse
	end;

{$ENDIF}

end.