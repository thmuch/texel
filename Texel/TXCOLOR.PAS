unit txcolor;
{ 1998-07-08 }

interface

uses

	ODialogs;


type

	PColorBox = ^TColorBox;
	TColorBox = object(TComboBox)
		function TestIndex(AnIndx: integer): boolean; virtual;
		procedure Changed(AnIndx: integer; DblClick: boolean); virtual;
		procedure SetValue(Sel: integer); virtual;
		procedure Work; virtual;
	end;

	PTextColorBox = ^TTextColorBox;
	TTextColorBox = object(TColorBox)
		procedure Work; virtual;
	end;




implementation

uses

	txtypes,txmain;



function TColorBox.TestIndex(AnIndx: integer): boolean;

	begin
		if ObjAddr^.ob_head>0 then
			if AnIndx=ObjAddr^.ob_head then
				begin
					TestIndex:=true;
					exit
				end;
		TestIndex:=inherited TestIndex(AnIndx)
	end;


procedure TColorBox.Changed(AnIndx: integer; DblClick: boolean);

	begin
		if ObjAddr^.ob_head>0 then
			if AnIndx=ObjAddr^.ob_head then AnIndx:=ObjIndx;
		inherited Changed(AnIndx,DblClick)
	end;


procedure TColorBox.SetValue(Sel: integer);

	begin
		with ObjAddr^ do
			if (ob_spec.index and $0f)<>Sel then
				begin
					ob_spec.index:=(ob_spec.index and $fffffff0) or Sel;
					Paint
				end
	end;


procedure TColorBox.Work;

	begin
		if PWindow(Parent)^.GetClassName<>TEXELWINDCLASS then exit;
		PCalcWindow(Parent)^.SetCellColor(GetSelection)
	end;


procedure TTextColorBox.Work;

	begin
		PCalcWindow(Parent)^.SetTextColor(GetSelection)
	end;

end.