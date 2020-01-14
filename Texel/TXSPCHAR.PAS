unit txspchar;
{ 1998-07-06 }

interface

uses

	OWindows,OStdWnds;


type

	PSpecialChars = ^TSpecialChars;
	TSpecialChars = object(TKeyMenu)
		specialchars: PSpecialCharactersWindow;
		constructor Init(AParent: PEventObject; Stat,Key,mNum,tNum: integer);
		procedure Work; virtual;
	end;




implementation

{$IFNDEF LITE}
uses

	txrsc,txlang,txtypes;
{$ENDIF}



constructor TSpecialChars.Init(AParent: PEventObject; Stat,Key,mNum,tNum: integer);

	begin
		inherited Init(AParent,Stat,Key,mNum,tNum);
		specialchars:=nil
	end;


procedure TSpecialChars.Work;

	begin
		{$IFNDEF LITE}
		if specialchars=nil then
			begin
				new(specialchars,Init(nil,TEXELWINDPREFIX+TITLE_SPECIALCHARS));
				if specialchars<>nil then specialchars^.LoadIcon(new(PIcon,Init(specialchars,RTICONS,RTICALC,0,0,false,false,'','')))
			end;
		if specialchars<>nil then specialchars^.MakeWindow
		{$ENDIF}
	end;

end.