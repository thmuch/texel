unit txvalida;
{ 1998-07-02 }

interface

uses

	OWindows;


type

	PPosRealValidator = ^TPosRealValidator;
	TPosRealValidator = object(TValidator)
		procedure Error; virtual;
		function IsValid(s: string): boolean; virtual;
		function IsValidInput(var s: string; SuppressFill: boolean): boolean; virtual;
	end;

	PMinMaxValidator = ^TMinMaxValidator;
	TMinMaxValidator = object(TValidator)
		MinVal,
		MaxVal: real;
		constructor Init(mnv,mxv: real);
		procedure Error; virtual;
		function IsValid(s: string): boolean; virtual;
		function IsValidInput(var s: string; SuppressFill: boolean): boolean; virtual;
	end;

	PPosMaxValidator = ^TPosMaxValidator;
	TPosMaxValidator = object(TMinMaxValidator)
		constructor Init(mxv: real);
	end;




implementation

uses

	OTypes,OProcs,txlang;



constructor TMinMaxValidator.Init(mnv,mxv: real);

	begin
		if not(inherited Init) then fail;
		MinVal:=mnv;
		MaxVal:=mxv
	end;


procedure TMinMaxValidator.Error;

	begin
		if Application<>nil then
			with Application^ do
				begin
					if (Attr.Country=FRG) or (Attr.Country=SWG) then
						Alert(Window,1,NOTE,' Wert nicht im Bereich von ('+ftoa(MinVal)+','+ftoa(MaxVal)+')',BUTTON_OK)
					else
						Alert(Window,1,NOTE,' Value not in range ('+ftoa(MinVal)+','+ftoa(MaxVal)+')',BUTTON_OK)
			end
	end;


function TMinMaxValidator.IsValid(s: string): boolean;
	var r: real;

	begin
		StrPTrim(s);
		if inherited IsValid(s) then
			begin
				r:=atof(s);
				IsValid:=(r>MinVal) and (r<MaxVal)
			end
		else
			IsValid:=false
	end;


function TMinMaxValidator.IsValidInput(var s: string; SuppressFill: boolean): boolean;
	var r: real;

	begin
		if inherited IsValidInput(s,SuppressFill) then
			begin
				r:=atof(s);
				IsValidInput:=(r>MinVal) and (r<MaxVal)
			end
		else
			IsValidInput:=false
	end;


constructor TPosMaxValidator.Init(mxv: real);

	begin
		if not(inherited Init(0.0,mxv)) then fail
	end;


procedure TPosRealValidator.Error;

	begin
		if Application<>nil then
			with Application^ do
				begin
					if (Attr.Country=FRG) or (Attr.Country=SWG) then
						Alert(Window,1,NOTE,' Wert darf nicht negativ sein.',BUTTON_OK)
					else
						Alert(Window,1,NOTE,' Value must not be negative.',BUTTON_OK)
			end
	end;


function TPosRealValidator.IsValid(s: string): boolean;

	begin
		StrPTrim(s);
		if inherited IsValid(s) then IsValid:=(atof(s)>=0.0)
		else
			IsValid:=false
	end;


function TPosRealValidator.IsValidInput(var s: string; SuppressFill: boolean): boolean;

	begin
		if inherited IsValidInput(s,SuppressFill) then IsValidInput:=(atof(s)>=0.0)
		else
			IsValidInput:=false
	end;

end.