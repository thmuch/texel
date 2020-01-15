unit txlang;

interface

const

	{$IFDEF FRENCH}
	{$I lang\francais.inc}
	{$ELSE}
	{$IFDEF ENGLISH}
	{$I lang\english.inc}
	{$ELSE}
	{$I lang\deutsch.inc}
	{$ENDIF}
	{$ENDIF}


implementation

end.