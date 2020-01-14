{*************************************
 *     T E X E L  Version 2.20r0     *
 * Copyright ½1994-98 by Thomas Much *
 *************************************
 *   Thomas Much, Gerwigstraže 46,   *
 * 76131 Karlsruhe, (0721) 62 28 41  *
 *        Thomas Much @ KA2          *
 * Thomas.Much@stud.uni-karlsruhe.de *
 * http://www.uni-karlsruhe.de/~uk48 *
 *************************************
 *  erstellt am:         05.10.1994  *
 *  letztes Update am:   07.03.1999  *
 *************************************}

{       | deutsch   | englisch          | franz”sisch      
	------|-----------|-------------------|------------------
  Beta  | BETA      | BETA ENGLISH      | BETA FRENCH      
  Final |           | ENGLISH           | FRENCH           
  Demo  | BETA DEMO | BETA DEMO ENGLISH | BETA DEMO FRENCH 
  Home  | LITE      | ENGLISH LITE      | FRENCH LITE       }

{$B+,D-,G-,I-,L-,N-,P-,Q-,R-,S-,T-,V-,X+,Z-}

{$M 182272}

{$DEFINE WDIALOG}
{DEFINE NVDI5}

program Texel;

uses

	txtypes,txmain;

begin
	TexelApp.Init(TEXELNAME);
	TexelApp.Run;
	TexelApp.Done;
end.