unit txrsc;
{ 1999-03-07 }

interface

const

	DEMORSCLEN1 = 63146;
	DEMORSCLEN2 = 46634;

	{$IFDEF FRENCH}
	{$I texel_f.i}
	{$I texel2_f.i}
	{$ELSE}
	{$IFDEF ENGLISH}
	{$I texel_e.i}
	{$I texel2_e.i}
	{$ELSE}
	{$I texel.i}
	{$I texel2.i}
	{$ENDIF}
	{$ENDIF}


implementation

end.