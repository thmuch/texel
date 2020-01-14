unit txcollec;
{ 1998-07-15 }

interface

uses

	Objects;


type

	PVariableCollection = ^TVariableCollection;
	TVariableCollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;

	PParameterCollection = ^TParameterCollection;
	TParameterCollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;

	PFontCollection = ^TFontCollection;
	TFontCollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;

	PFunctionCollection = ^TFunctionCollection;
	TFunctionCollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;

	PCategoryCollection = ^TCategoryCollection;
	TCategoryCollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;

	PFormatCollection = ^TFormatCollection;
	TFormatCollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;

	POLECollection = ^TOLECollection;
	TOLECollection = object(TStringCollection)
		function KeyOf(Item: pointer): pointer; virtual;
		procedure FreeItem(Item: pointer); virtual;
	end;




implementation

uses

	OProcs,txtypes;



function TParameterCollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=PParameter(Item)^.ListName
	end;


procedure TParameterCollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(PParameter(Item)^.Name);
				DisposeStr(PParameter(Item)^.ListName);
				DisposeStr(PParameter(Item)^.Txt);
				DisposeStr(PParameter(Item)^.Descr);
				dispose(PParameter(Item))
			end
	end;


function TFontCollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=PFont(Item)^.Name
	end;


procedure TFontCollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(PFont(Item)^.Name);
				if PFont(Item)^.SizeCount>0 then freemem(PFont(Item)^.Sizes,PFont(Item)^.SizeCount shl 1);
				Dispose(PFont(Item))
			end
	end;


function TFunctionCollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=PFunction(Item)^.Name
	end;


procedure TFunctionCollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(PFunction(Item)^.Name);
				DisposeStr(PFunction(Item)^.Descr1);
				DisposeStr(PFunction(Item)^.Descr2);
				dispose(PFunction(Item))
			end
	end;


function TCategoryCollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=PCategory(Item)^.Name
	end;


procedure TCategoryCollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(PCategory(Item)^.Name);
				dispose(PCategory(Item))
			end
	end;


function TFormatCollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=PFormat(Item)^.Name
	end;


procedure TFormatCollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(PFormat(Item)^.Name);
				dispose(PFormat(Item))
			end
	end;


function TOLECollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=POLEType(Item)^.Descr
	end;


procedure TOLECollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(POLEType(Item)^.Descr);
				dispose(POLEType(Item))
			end
	end;


function TVariableCollection.KeyOf(Item: pointer): pointer;

	begin
		if Item=nil then KeyOf:=nil
		else
			KeyOf:=PVariable(Item)^.Name
	end;


procedure TVariableCollection.FreeItem(Item: pointer);

	begin
		if Item<>nil then
			begin
				DisposeStr(PVariable(Item)^.Name);
				dispose(PVariable(Item))
			end
	end;

end.