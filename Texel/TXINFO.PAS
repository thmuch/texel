unit txinfo;
{ 1998-07-19 }

interface

uses

	OWindows;


type

	PInfo = ^TInfo;
	TInfo = object(TKeyMenu)
		public
		procedure Work; virtual;
		private
		st0,
		st1,
		st2,
		st3,
		st4,
		st6: PStatic;
	end;




implementation

uses

	OTypes,OProcs,ODialogs,
	txrsc,txlang,txtypes,txprocs,txmain;


type

	PInfoDialog = ^TInfoDialog;
	TInfoDialog = object(THyperDialog)
		function OK: boolean; virtual;
		function ExitDlg(AnIndx: integer): boolean; virtual;
	end;



function TInfoDialog.OK: boolean;
	var valid: boolean;

	begin
		valid:=inherited OK;
		if valid then PCalcWindow(Parent)^.SetDirty;
		OK:=valid
	end;


function TInfoDialog.ExitDlg(AnIndx: integer): boolean;
{$IFNDEF LITE}
	label _pagain;

	var p    : PDialog;
	    pe   : PPasswordEdit;
	    pcw  : PCalcWindow;
	    dummy: longint;
	    tb   : record
	    	oldpw,
	    	newpw,
	    	checkpw: string[21]
	    end;
{$ENDIF}

	begin
		ExitDlg:=false;
		{$IFNDEF LITE}
		if AnIndx=RTIPASSWORD then
			begin
				pcw:=PCalcWindow(Parent);
				TexelApp.ActivateExtResource;
				_pagain:
				new(p,Init(@self,'',RTCHGPASS));
				if p<>nil then
					begin
						new(pe,Init(p,RTCPOLD,21,BUBBLE_CHGPASS_OLD));
						if pcw^.PassWord.Flag=0 then
							if pe<>nil then pe^.Disable;
						new(PPasswordEdit,Init(p,RTCPNEW,21,BUBBLE_CHGPASS_NEW));
						new(PPasswordEdit,Init(p,RTCPCHECK,21,BUBBLE_CHGPASS_CHECK));
						new(PButton,Init(p,RTCPABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						new(PButton,Init(p,RTCPOK,id_OK,true,BUBBLE_CHGPASS_OK));
						with tb do
							begin
								oldpw:='';
								newpw:='';
								checkpw:=''
							end;
						p^.TransferBuffer:=@tb;
						if Application^.ExecDialog(p)=RTCPOK then
							begin
								if pcw^.PassWord.Flag<>0 then
									if not(CheckPassWord(tb.oldpw,pcw^.PassWord.Code,dummy)) then
										begin
											Application^.Alert(@self,1,NOTE,MESSAGE_INFO_PASSWRONG,BUTTON_OK);
											goto _pagain
										end;
								if (length(tb.newpw)>0) and (length(tb.newpw)<6) then
									begin
										Application^.Alert(@self,1,NOTE,MESSAGE_INFO_PASSLEN,BUTTON_OK);
										goto _pagain
									end;
								if tb.newpw<>tb.checkpw then
									begin
										Application^.Alert(@self,1,NOTE,MESSAGE_INFO_PASSNEQ,BUTTON_OK);
										goto _pagain
									end;
								if length(tb.newpw)>0 then
									begin
										pcw^.PassWord.Flag:=1;
										pcw^.PassWord.Code:=CreatePassCode(tb.newpw,pcw^.PassWord.Mask)
									end
								else
									begin
										pcw^.PassWord.Flag:=0;
										pcw^.PassWord.Code:=0;
										pcw^.PassWord.Mask:=0
									end;
								pcw^.SetDirty
							end
					end;
				TexelApp.DeactivateExtResource
			end
		{$ENDIF}
	end;


procedure TInfo.Work;
	var p : PCalcWindow;
	    t : string;
	    pb: PButton;
	    pc: PCheckBox;

	begin
		p:=PCalcWindow(Parent);
		if ADialog=nil then
			begin
				ADialog:=new(PInfoDialog,Init(p,TEXELWINDPREFIX+TITLE_INFO,STG_INFO,ICNTITLE_INFO,RTINFO));
				if ADialog<>nil then
					begin
						new(PGroupBox,Init(ADialog,RTIFILE,GROUP_INFO_FILE,''));
						new(PGroupBox,Init(ADialog,RTIEDIT,'',''));
						new(PGroupBox,Init(ADialog,RTITIME,'',''));
						new(PGroupBox,Init(ADialog,RTIINFO,'',''));
						new(st0,Init(ADialog,RTIFNAME,64,false,BUBBLE_INFO_FILE));
						new(PEdit,Init(ADialog,RTIAUTOR,51,BUBBLE_INFO_AUTHOR));
						new(PEdit,Init(ADialog,RTISTICHWORT,51,BUBBLE_INFO_INDEX));
						new(PEdit,Init(ADialog,RTIREM1,51,BUBBLE_INFO_REM));
						new(PEdit,Init(ADialog,RTIREM2,51,BUBBLE_INFO_REM));
						new(PEdit,Init(ADialog,RTIREM3,51,BUBBLE_INFO_REM));
						new(PEdit,Init(ADialog,RTIREM4,51,BUBBLE_INFO_TITLE));
						new(pc,Init(ADialog,RTIENCRYPT,true,BUBBLE_INFO_ENCRYPT));
						new(st1,Init(ADialog,RTICREATE,33,false,BUBBLE_INFO_CREATED));
						new(st2,Init(ADialog,RTILAST,32,false,BUBBLE_INFO_LATEST));
						new(st3,Init(ADialog,RTIUSED,18,false,BUBBLE_INFO_USED));
						new(st4,Init(ADialog,RTIPRINTED,18,false,BUBBLE_INFO_PRINTED));
						new(st6,Init(ADialog,RTITEXEL,31,false,BUBBLE_INFO_VERSION));
						new(pb,Init(ADialog,RTIHELP,id_Help,false,BUBBLE_GENERAL_HELP));
						if pb<>nil then
							if not(TexelApp.HelpAvailable(false)) then pb^.Disable;
						new(PButton,Init(ADialog,RTIOK,id_OK,true,BUBBLE_GENERAL_OK));
						new(pb,Init(ADialog,RTIPASSWORD,id_No,true,BUBBLE_INFO_PASSWORD));
						{$IFDEF LITE}
						if pb<>nil then pb^.Disable;
						if pc<>nil then pc^.Disable;
						{$ENDIF}
						new(PButton,Init(ADialog,RTIABBRUCH,id_Cancel,true,BUBBLE_GENERAL_CANCEL));
						ADialog^.TransferBuffer:=@p^.infobuf
					end
			end;
		if ADialog<>nil then
			begin
				t:=p^.GetWindowFilename;
				if length(t)=0 then t:=p^.GetRawIconTitle;
				if st0<>nil then st0^.SetText(CompressPath(t,63));
				if st1<>nil then st1^.SetText(STRING_INFO_CREATED+TexelApp.Time2Str(p^.infobuf.Created)+' h');
				if st2<>nil then st2^.SetText(STRING_INFO_LATEST+TexelApp.Time2Str(p^.infobuf.Last)+' h');
				if st3<>nil then st3^.SetText(STRING_INFO_USED+ltoa(p^.infobuf.Used)+' x');
				if st4<>nil then st4^.SetText(STRING_INFO_PRINTED+ltoa(p^.infobuf.Printed)+' x');
				if st6<>nil then
					begin
						if p^.infobuf.Version=0 then st6^.Clear
						else
							if p^.infobuf.Release=0 then st6^.SetText(STRING_INFO_SAVEDWITH+' '+TEXELNAME+' '+VtoS(p^.infobuf.Version))
							else
								st6^.SetText(STRING_INFO_SAVEDWITH+' '+TEXELNAME+' '+VtoS(p^.infobuf.Version)+'r'+ltoa(p^.infobuf.Release))
					end;
				ADialog^.MakeWindow
			end
	end;

end.