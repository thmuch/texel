unit txparse;
{ 1999-02-28 }

interface

uses

	OWindows,txtypes;


type

	PParser = ^TParser;
	TParser = object(TEvent)
		function Parse(s: string; var svar: string; var baum: PNode; acell: PCell; ar,ac: integer; varerr: boolean; var errpos: longint; var errcode: integer): boolean;
	end;




implementation

uses

	Strings,
	OTypes,OProcs,
	txlang,txmain;


const

	MAXBUFLEN        = 255;  { nie kleiner als 255 }
	MAXTOKENLEN      = 255;  { nie kleiner als 255 }
	
	CHR_EOS          =  #0;
	CHR_SP           = #32;

	TT_UNKNOWN       =   0;
	TT_RELOP         =   1;
	TT_PLUSMINUS     =   2;
	TT_MULTOP        =   3;
	TT_EXPONENT      =   4;
	TT_PROZENT       =   5;
	TT_KLAMMERAUF    =   6;
	TT_KLAMMERZU     =   7;
	TT_SEMIKOLON     =   8;
	TT_ZELLE         =   9;
	TT_FUNKTION      =  10;
	TT_KONSTANTE     =  11;
	TT_VARIABLE      =  12;
	TT_ZAHL          =  13;
	TT_STRING        =  14;
	TT_BEREICH       =  15;
	TT_AUSRUFUNGSZ   =  16;
	TT_ECKLAMMERAUF  =  17;
	TT_ECKLAMMERZU   =  18;
	TT_ENDOFFORMULA  =  42;

	TST_EMPTY        =   0;
	TST_PLUS         =  -1;
	TST_MINUS        =  -2;
	TST_MULT         =  -3;
	TST_DIV          =  -4;
	TST_EQUAL        =  -5;
	TST_UNEQUAL      =  -6;
	TST_LESS         =  -7;
	TST_LESSEQUAL    =  -8;
	TST_GREATER      =  -9;
	TST_GREATEREQUAL = -10;
	TST_NAT_EXP      = -11;
	TST_EXP          = -12;
	TST_NAT_MULT     = -13;
	TST_NAT_DIV      = -14;
	TST_NAT_PLUS     = -15;
	TST_NAT_MINUS    = -16;
	
	PERR_INTERNAL1   =   1;
	PERR_INTERNAL2   =   2;
	PERR_INTERNAL3   =   3;


var

	buffer: array [0..MAXBUFLEN+1] of char;
	token : array [0..MAXTOKENLEN+1] of char;



function TParser.Parse(s: string; var svar: string; var baum: PNode; acell: PCell; ar,ac: integer; varerr: boolean; var errpos: longint; var errcode: integer): boolean;
	var p           : PCalcWindow;
	    lasttoken,
		  source      : PChar;
		  tokenflg1,
		  tokenflg2,
		  tokentype,
		  tokensubtype: integer;
		  ftxt,bvar   : string;
		  error       : boolean;
		  tokenrow1,
		  tokencol1,
		  tokenrow2,
		  tokencol2   : longint;
		  tokenpf     : PFunction;
		  tokenpp     : PParameter;
		  tokenvr     : PVariable;

	procedure setError(code: integer);

		begin
			errcode:=code;
			errpos:=longint(lasttoken)-longint(@buffer[0]);
			error:=(code<>PERR_OK)
		end;

	procedure tpGetNextToken;

		procedure tokenSkipWhitespace;

			begin
				while source^=CHR_SP do inc(longint(source));
			end;
	
		function tokenSepOp: boolean;
		
			begin
				if source^='(' then
					begin
						inc(longint(source));
						tokentype:=TT_KLAMMERAUF;
						tokenSepOp:=true;
						exit
					end;
				if source^=')' then
					begin
						inc(longint(source));
						tokentype:=TT_KLAMMERZU;
						tokenSepOp:=true;
						exit
					end;
				if source^=';' then
					begin
						inc(longint(source));
						tokentype:=TT_SEMIKOLON;
						tokenSepOp:=true;
						exit
					end;
				if source^='!' then
					begin
						inc(longint(source));
						tokentype:=TT_AUSRUFUNGSZ;
						tokenSepOp:=true;
						exit
					end;
				if source^='^' then
					begin
						inc(longint(source));
						tokentype:=TT_EXPONENT;
						tokensubtype:=TST_EXP;
						tokenSepOp:=true;
						exit
					end;
				if source^='%' then
					begin
						inc(longint(source));
						tokentype:=TT_PROZENT;
						tokenSepOp:=true;
						exit
					end;
				if source^='*' then
					begin
						inc(longint(source));
						tokentype:=TT_MULTOP;
						tokensubtype:=TST_MULT;
						tokenSepOp:=true;
						exit
					end;
				if source^='/' then
					begin
						inc(longint(source));
						tokentype:=TT_MULTOP;
						tokensubtype:=TST_DIV;
						tokenSepOp:=true;
						exit
					end;
				if source^='+' then
					begin
						inc(longint(source));
						tokentype:=TT_PLUSMINUS;
						tokensubtype:=TST_PLUS;
						tokenSepOp:=true;
						exit
					end;
				if source^='-' then
					begin
						inc(longint(source));
						tokentype:=TT_PLUSMINUS;
						tokensubtype:=TST_MINUS;
						tokenSepOp:=true;
						exit
					end;
				if source^='=' then
					begin
						inc(longint(source));
						tokentype:=TT_RELOP;
						tokensubtype:=TST_EQUAL;
						tokenSepOp:=true;
						exit
					end;
				if source^='>' then
					begin
						inc(longint(source));
						tokentype:=TT_RELOP;
						if source^='=' then
							begin
								inc(longint(source));
								tokensubtype:=TST_GREATEREQUAL
							end
						else
							tokensubtype:=TST_GREATER;
						tokenSepOp:=true;
						exit
					end;
				if source^='<' then
					begin
						inc(longint(source));
						tokentype:=TT_RELOP;
						if source^='=' then
							begin
								inc(longint(source));
								tokensubtype:=TST_LESSEQUAL
							end
						else
							if source^='>' then
								begin
									inc(longint(source));
									tokensubtype:=TST_UNEQUAL
								end
							else
								tokensubtype:=TST_LESS;
						tokenSepOp:=true;
						exit
					end;
				if source^='[' then
					begin
						inc(longint(source));
						tokentype:=TT_ECKLAMMERAUF;
						tokenSepOp:=true;
						exit
					end;
				if source^=']' then
					begin
						inc(longint(source));
						tokentype:=TT_ECKLAMMERZU;
						tokenSepOp:=true;
						exit
					end;
				tokenSepOp:=false
			end;

		function tokenString: boolean;
			var tidx: integer;
			
			function addChar: boolean;
			
				begin
					token[tidx]:=source^;
					inc(longint(source));
					inc(tidx);
					if tidx<=MAXTOKENLEN then addChar:=false
					else
						begin
							setError(PERR_TOKENTOOLONG);
							addChar:=true
						end
				end;

			begin
				if source^='"' then
					begin
						tokenString:=true;
						tokentype:=TT_STRING;
						inc(longint(source));
						tidx:=0;
						while source^<>CHR_EOS do
							begin
								if source^='"' then
									begin
										inc(longint(source));
										token[tidx]:=CHR_EOS;
										exit
									end;
								if source^='\' then
									begin
										inc(longint(source));
										if (source^='"') or (source^='\') then
											if addChar then exit;
									end
								else
									if addChar then exit;
							end;
						setError(PERR_STRINGNOTTERMINATED)
					end
				else
					tokenString:=false
			end;

		function tokenCell: boolean;
			var src : PChar;
			    flg1,
			    flg2: integer;
			    swp : longint;

			procedure checkAbs(var tr,tc: longint; flg: integer);
			
				begin
					if not(bTst(flg,RF_COLABS)) then dec(tc,ac);
					if not(bTst(flg,RF_ROWABS)) then dec(tr,ar);
				end;

			function scanCell(var tr,tc: longint; var flg: integer): boolean;
				label _cellerr;
				
				var mustbecell: boolean;
				    old       : PChar;
			
				begin
					scanCell:=false;
					tr:=0;
					tc:=-1;
					if src^='$' then
						begin
							mustbecell:=true;
							flg:=RF_COLABS;
							inc(longint(src))
						end
					else
						begin
							mustbecell:=false;
							flg:=0
						end;
					old:=src;
					while src^ in Buchstabe do
						begin
							tc:=(tc+1)*26+ord(upcase(src^))-ord('A');
							inc(longint(src))
						end;
					if (old=src) or (longint(src)-longint(old)>2) then
						begin
							if mustbecell then
								begin
									setError(PERR_COLUMNWRONG);
									goto _cellerr
								end
							else
								exit;
						end;
					if src^='$' then
						begin
							mustbecell:=true;
							flg:=flg or RF_ROWABS;
							inc(longint(src))
						end;
					old:=src;
					while src^ in DezZiffer do
						begin
							tr:=tr*10+ord(src^)-ord('0');
							inc(longint(src))
						end;
					if (old=src) or (longint(src)-longint(old)>5) or (src^ in VarNameSet) then
						begin
							if mustbecell then
								begin
									setError(PERR_ROWWRONG);
									goto _cellerr
								end
							else
								exit;
						end;
					dec(tr);
					_cellerr:
					scanCell:=true
				end;

			begin
				src:=source;
				if scanCell(tokenrow1,tokencol1,tokenflg1) then
					begin
						tokentype:=TT_ZELLE;
						tokenCell:=true;
						if not(error) then
							begin
								if src^=':' then
									begin
										tokentype:=TT_BEREICH;
										inc(longint(src));
										if scanCell(tokenrow2,tokencol2,flg2) then
											begin
												flg1:=tokenflg1;
												tokenflg1:=0;
												tokenflg2:=0;
												if tokencol1>tokencol2 then
													begin
														swp:=tokencol1;
														tokencol1:=tokencol2;
														tokencol2:=swp;
														if bTst(flg2,RF_COLABS) then tokenflg1:=tokenflg1 or RF_COLABS;
														if bTst(flg1,RF_COLABS) then tokenflg2:=tokenflg2 or RF_COLABS;
													end
												else
													begin
														if bTst(flg1,RF_COLABS) then tokenflg1:=tokenflg1 or RF_COLABS;
														if bTst(flg2,RF_COLABS) then tokenflg2:=tokenflg2 or RF_COLABS;
													end;
												if tokenrow1>tokenrow2 then
													begin
														swp:=tokenrow1;
														tokenrow1:=tokenrow2;
														tokenrow2:=swp;
														if bTst(flg2,RF_ROWABS) then tokenflg1:=tokenflg1 or RF_ROWABS;
														if bTst(flg1,RF_ROWABS) then tokenflg2:=tokenflg2 or RF_ROWABS;
													end
												else
													begin
														if bTst(flg1,RF_ROWABS) then tokenflg1:=tokenflg1 or RF_ROWABS;
														if bTst(flg2,RF_ROWABS) then tokenflg2:=tokenflg2 or RF_ROWABS;
													end;
												checkAbs(tokenrow1,tokencol1,tokenflg1);
												checkAbs(tokenrow2,tokencol2,tokenflg2);
											end
										else
											setError(PERR_RANGEINCOMPLETE);
									end
								else
									checkAbs(tokenrow1,tokencol1,tokenflg1);
							end;
						source:=src
					end
				else
					tokenCell:=false;
			end;

		function tokenIdentifier: boolean;
			var tidx: integer;

			function isOperator: boolean;

				begin
					if stricomp(token,OPS_NATURAL_PLUS)=0 then
						begin
							tokentype:=TT_PLUSMINUS;
							tokensubtype:=TST_NAT_PLUS;
							isOperator:=true
						end
					else if stricomp(token,OPS_NATURAL_MINUS)=0 then
						begin
							tokentype:=TT_PLUSMINUS;
							tokensubtype:=TST_NAT_MINUS;
							isOperator:=true
						end
					else if stricomp(token,OPS_NATURAL_MULT)=0 then
						begin
							tokentype:=TT_MULTOP;
							tokensubtype:=TST_NAT_MULT;
							isOperator:=true
						end
					else if stricomp(token,OPS_NATURAL_DIV)=0 then
						begin
							tokentype:=TT_MULTOP;
							tokensubtype:=TST_NAT_DIV;
							isOperator:=true
						end
					else if stricomp(token,OPS_NATURAL_POWER)=0 then
						begin
							tokentype:=TT_EXPONENT;
							tokensubtype:=TST_NAT_EXP;
							isOperator:=true
						end
					else
						isOperator:=false;
				end;
			
			function isFunction: boolean;
				var q: integer;

				begin
					ftxt:=StrPUpper(StrPas(token));
					q:=TexelApp.Functions^.Count-1;
					while q>=0 do
						begin
							tokenpf:=PFunction(TexelApp.Functions^.At(q));
							if ftxt=StrPUpper(tokenpf^.Name^) then
								begin
									tokentype:=TT_FUNKTION;
									isFunction:=true;
									exit
								end;
							dec(q)
						end;
					isFunction:=false
				end;

			function isConst: boolean;
				var q: integer;

				begin
					if p^.Parameter<>nil then
						begin
							ftxt:=StrPUpper(StrPas(token));
							q:=p^.Parameter^.Count-1;
							while q>=0 do
								begin
									tokenpp:=PParameter(p^.Parameter^.At(q));
									if ftxt=StrPUpper(tokenpp^.Name^) then
										begin
											tokentype:=TT_KONSTANTE;
											isConst:=true;
											exit
										end;
									dec(q)
								end
						end;
					isConst:=false
				end;
			
			procedure checkVar;
				var q: integer;
			
				begin
					tokenvr:=nil;
					if p^.Variables<>nil then
						if p^.Variables^.Count>0 then
							begin
								ftxt:=StrPUpper(StrPas(token));
								for q:=0 to p^.Variables^.Count-1 do
									with PVariable(p^.Variables^.At(q))^ do
										if ftxt=StrPUpper(Name^) then
											begin
												StrPCopy(token,Name^);
												tokenvr:=PVariable(p^.Variables^.At(q));
												exit
											end
							end
				end;

			begin
				if source^ in VarNameFirst then
					begin
						tokenIdentifier:=true;
						tokentype:=TT_VARIABLE;
						tidx:=0;
						while source^ in VarNameSet do
							begin
								if tidx>=MAXTOKENLEN then
									begin
										setError(PERR_TOKENTOOLONG);
										break
									end;
								token[tidx]:=source^;
								inc(longint(source));
								inc(tidx)
							end;
						token[tidx]:=CHR_EOS;
						if not(error) then
							if not(isFunction) then
								if not(isOperator) then
									if not(isConst) then checkVar;
					end
				else
					tokenIdentifier:=false;
			end;

		function tokenNumber: boolean;
			label _again,_numerr;

			var src,old  : PChar;
			    stat,tidx: integer;

			begin
				tokenNumber:=false;
				src:=source;
				if src^ in Dezimaltrenner then
					begin
						token[0]:='0';
						token[1]:=src^;
						inc(longint(src));
						tidx:=2;
						stat:=1
					end
				else
					begin
						tidx:=0;
						stat:=0
					end;
				_again:
				if stat=2 then
					if src^ in Vorzeichen then
						begin
							if tidx>=MAXTOKENLEN then
								begin
									setError(PERR_TOKENTOOLONG);
									goto _numerr
								end;
							token[tidx]:=src^;
							inc(longint(src));
							inc(tidx)
						end;
				old:=src;
				while src^ in DezZiffer do
					begin
						if tidx>=MAXTOKENLEN then
							begin
								setError(PERR_TOKENTOOLONG);
								goto _numerr
							end;
						token[tidx]:=src^;
						inc(longint(src));
						inc(tidx)
					end;
				if old=src then
					begin
						if stat=0 then exit
						else
							begin
								setError(PERR_NUMBERSEXPECTED);
								goto _numerr
							end
					end;
				if stat=0 then
					begin
						if src^ in Dezimaltrenner then
							begin
								token[tidx]:=src^;
								inc(longint(src));
								inc(tidx);
								stat:=1;
								goto _again
							end
						else
							if src^ in Exponent then
								begin
									token[tidx]:='E';
									inc(longint(src));
									inc(tidx);
									stat:=2;
									goto _again
								end
					end
				else
					if stat=1 then
						if src^ in Exponent then
							begin
								token[tidx]:='E';
								inc(longint(src));
								inc(tidx);
								stat:=2;
								goto _again
							end;
				_numerr:
				token[tidx]:=CHR_EOS;
				tokentype:=TT_ZAHL;
				source:=src;
				tokenNumber:=true
			end;

		begin
			token[0]:=CHR_EOS;
			lasttoken:=source;
			tokenSkipWhitespace;
			if source^=CHR_EOS then tokentype:=TT_ENDOFFORMULA
			else
				begin
					if tokenSepOp then exit;
					if tokenCell then exit;
					if tokenIdentifier then exit;
					if tokenNumber then exit;
					if tokenString then exit;
					tokentype:=TT_UNKNOWN;
					tokensubtype:=TST_EMPTY
				end
		end;

	function tpGetRangeOrCell(var baum: PNode; both: boolean): boolean;

		begin
			if both then
				if tokentype=TT_ZELLE then
					begin
						tpGetRangeOrCell:=true;
						if p^.NewNode(baum) then
							begin
								baum^.Typ:=NT_CELL;
								baum^.ColRef:=tokencol1;
								baum^.RowRef:=tokenrow1;
								baum^.Right.Flg:=tokenflg1;
								tpGetNextToken
							end
						else
							setError(PERR_NOMEM);
						exit
					end;
			if tokentype=TT_BEREICH then
				begin
					tpGetRangeOrCell:=true;
					if p^.NewNode(baum) then
						begin
							baum^.Typ:=NT_RANGE;
							baum^.Left.ColRef:=tokencol1;
							baum^.Left.RowRef:=tokenrow1;
							baum^.Right.ColRef:=tokencol2;
							baum^.Right.RowRef:=tokenrow2;
							baum^.Ref1Flg:=tokenflg1;
							baum^.Ref2Flg:=tokenflg2;
							tpGetNextToken
						end
					else
						setError(PERR_NOMEM);
				end
			else
				tpGetRangeOrCell:=false;
		end;
	
	procedure tpVergleich(var baum: PNode); forward;

	procedure tpFaktor(var baum: PNode);
		var pn: PNode;
		
		procedure scanFunction;
			label _nextarg;

			var pf: PFunction;
			
			function increaseList: boolean;
				var pil: PItemList;
				    i  : integer;

				begin
					getmem(pil,(baum^.Count+1) shl 2);
					if pil=nil then
						begin
							increaseList:=false;
							setError(PERR_NOMEM)
						end
					else
						begin
							increaseList:=true;
							if baum^.Count>0 then
								begin
									for i:=0 to baum^.Count-1 do pil^[i]:=baum^.Left.List^[i];
									freemem(baum^.Left.List,baum^.Count shl 2)
								end;
							pil^[baum^.Count]:=nil;
							inc(baum^.Count);
							baum^.Left.List:=pil
						end
				end;

			begin
				pf:=tokenpf;
				if pf^.ArgMin=0 then
					begin
						if p^.NewNode(baum) then
							begin
								baum^.Typ:=pf^.Opcode;
								tpGetNextToken
							end
						else
							setError(PERR_NOMEM);
						exit
					end;
				tpGetNextToken;
				if error then exit;
				if tokentype<>TT_KLAMMERAUF then
					begin
						setError(PERR_KLAMMERAUFFEHLT);
						exit
					end;
				tpGetNextToken;
				if error then exit;
				if bTst(pf^.ArgFlags,FFL_FIXARGS) then
					begin
						if pf^.ArgMin=1 then
							begin
								if bTst(pf^.ArgFlags,FFL_RANGEONLY) then
									begin
										if not(tpGetRangeOrCell(baum,true)) then
											begin
												setError(PERR_ARGCELLRANGE);
												exit
											end;
										if error then exit;
										if tokentype=TT_KLAMMERZU then
											begin
												if p^.NewNode(pn) then
													begin
														pn^.Typ:=pf^.Opcode;
														pn^.Left.Node:=baum;
														baum:=pn;
														tpGetNextToken
													end
												else
													setError(PERR_NOMEM);
											end
										else
											setError(PERR_KLAMMERZUFEHLT);
									end
								else
									begin
										tpVergleich(baum);
										if error then exit;
										if tokentype=TT_KLAMMERZU then
											begin
												if p^.NewNode(pn) then
													begin
														pn^.Typ:=pf^.Opcode;
														pn^.Left.Node:=baum;
														baum:=pn;
														tpGetNextToken
													end
												else
													setError(PERR_NOMEM);
											end
										else
											setError(PERR_KLAMMERZUFEHLT);
									end
							end
						else
							begin
								tpVergleich(baum);
								if error then exit;
								if p^.NewNode(pn) then
									begin
										pn^.Typ:=pf^.Opcode;
										pn^.Left.Node:=baum;
										baum:=pn;
										if tokentype=TT_SEMIKOLON then
											begin
												tpGetNextToken;
												if error then exit;
												tpVergleich(pn^.Right.Node);
												if error then exit;
											end
										else
											if bTst(pf^.ArgFlags,FFL_SECONDFIX) then
												begin
													setError(PERR_TOOFEWARGS);
													exit
												end;
										if tokentype=TT_KLAMMERZU then tpGetNextToken
										else
											setError(PERR_KLAMMERZUFEHLT);
									end
								else
									setError(PERR_NOMEM);
							end
					end
				else
					begin
						if p^.NewNode(baum) then
							begin
								baum^.Typ:=pf^.Opcode;
								baum^.Count:=0;
								_nextarg:
								if tokentype=TT_SEMIKOLON then
									begin
										setError(PERR_ARGEMPTY);
										exit
									end;
								if not(increaseList) then exit;
								if tpGetRangeOrCell(PNode(baum^.Left.List^[baum^.Count-1]),false) then
									begin
										if error then exit;
										if bTst(pf^.ArgFlags,FFL_NORANGE) then
											begin
												setError(PERR_ARGNORANGE);
												exit
											end
									end
								else
									begin
										tpVergleich(PNode(baum^.Left.List^[baum^.Count-1]));
										if error then exit;
									end;
								if tokentype=TT_SEMIKOLON then
									begin
										tpGetNextToken;
										if error then exit;
										goto _nextarg;
									end
								else
									if tokentype<>TT_KLAMMERZU then
										begin
											setError(PERR_KLAMMERORSEMIKOLON);
											exit
										end;
								if baum^.Count<pf^.ArgMin then
									begin
										setError(PERR_TOOFEWARGS);
										exit
									end
								else
									if baum^.Count>pf^.ArgMax then
										begin
											setError(PERR_TOOMANYARGS);
											exit
										end;
								tpGetNextToken
							end
						else
							setError(PERR_NOMEM);
					end
			end;

		begin
			if error then exit;
			case tokentype of
			TT_FUNKTION:
				scanFunction;
			TT_KLAMMERAUF:
				begin
					tpGetNextToken;
					if error then exit;
					tpVergleich(baum);
					if error then exit;
					if tokentype=TT_KLAMMERZU then
						begin
							if p^.NewNode(pn) then
								begin
									pn^.Typ:=NT_KLAMMER;
									pn^.Left.Node:=baum;
									baum:=pn;
									tpGetNextToken
								end
							else
								setError(PERR_NOMEM);
						end
					else
						setError(PERR_KLAMMERZUFEHLT);
				end;
			TT_ZELLE:
				begin
					if p^.NewNode(baum) then
						begin
							baum^.Typ:=NT_CELL;
							baum^.ColRef:=tokencol1;
							baum^.RowRef:=tokenrow1;
							baum^.Right.Flg:=tokenflg1;
							tpGetNextToken
						end
					else
						setError(PERR_NOMEM);
				end;
			TT_KONSTANTE:
				begin
					if p^.NewNode(baum) then
						begin
							baum^.Typ:=NT_CONST;
							new(baum^.Num);
							if baum^.Num<>nil then
								begin
									baum^.Num^:=tokenpp^.Value;
									baum^.Left.Txt:=NewStr(tokenpp^.Name^);
									tpGetNextToken
								end
							else
								begin
									dispose(baum);
									baum:=nil;
									setError(PERR_NOMEM)
								end
						end
					else
						setError(PERR_NOMEM);
				end;
			TT_VARIABLE:
				begin
					if p^.NewNode(baum) then
						begin
							baum^.Typ:=NT_VARIABLE;
							baum^.Varb:=NewStr(StrPas(token));
							if baum^.Varb<>nil then tpGetNextToken
							else
								begin
									dispose(baum);
									baum:=nil;
									setError(PERR_NOMEM)
								end
						end
					else
						setError(PERR_NOMEM);
				end;
			TT_ZAHL:
				begin
					if p^.NewNode(baum) then
						begin
							baum^.Typ:=NT_CONST;
							new(baum^.Num);
							if baum^.Num<>nil then
								begin
									ftxt:=StrPas(token);
									baum^.Num^:=atof(ftxt);
									baum^.Left.Txt:=NewStr(ftxt);
									tpGetNextToken
								end
							else
								begin
									dispose(baum);
									baum:=nil;
									setError(PERR_NOMEM)
								end
						end
					else
						setError(PERR_NOMEM);
				end;
			TT_STRING:
				begin
					if p^.NewNode(baum) then
						begin
							baum^.Typ:=NT_STRING;
							baum^.Chars:=ChrNew(StrPas(token));
							tpGetNextToken
						end
					else
						setError(PERR_NOMEM);
				end;
			else
				setError(PERR_FACTORINVALID);
			end
		end;

	procedure tpVorzFaktor(var baum: PNode);
		var pn : PNode;
		    tst: integer;

		begin
			if error then exit;
			if tokentype=TT_PLUSMINUS then
				begin
					tst:=tokensubtype;
					tpGetNextToken;
					if error then exit;
				end
			else
				tst:=TST_EMPTY;
			tpFaktor(baum);
			if error then exit;
			if (tst=TST_MINUS) or (tst=TST_NAT_MINUS) then
				begin
					if p^.NewNode(pn) then
						begin
							if tst=TST_NAT_MINUS then pn^.Typ:=NT_NAT_NEGATE
							else
								pn^.Typ:=NT_NEGATE;
							pn^.Left.Node:=baum;
							baum:=pn
						end
					else
						setError(PERR_NOMEM);
				end
		end;
	
	procedure tpProzent(var baum: PNode);
		var pn: PNode;
	
		begin
			if error then exit;
			tpVorzFaktor(baum);
			if error then exit;
			if tokentype=TT_PROZENT then
				begin
					if p^.NewNode(pn) then
						begin
							pn^.Typ:=NT_PERCENT;
							pn^.Left.Node:=baum;
							baum:=pn;
							tpGetNextToken
						end
					else
						setError(PERR_NOMEM);
				end
		end;
	
	procedure tpPotenz(var baum: PNode);
		var pn: PNode;

		begin
			if error then exit;
			tpProzent(baum);
			if error then exit;
			while tokentype=TT_EXPONENT do
				begin
					if p^.NewNode(pn) then
						begin
							if tokensubtype=TST_NAT_EXP then pn^.Typ:=NT_NAT_POWER
							else
								pn^.Typ:=NT_POWER;
							pn^.Left.Node:=baum;
							baum:=pn;
							tpGetNextToken;
							if error then exit;
							pn:=nil;
							tpProzent(pn);
							if error then
								begin
									if errcode=PERR_FACTORINVALID then errcode:=PERR_POWERMISSING;
									exit
								end;
							baum^.Right.Node:=pn
						end
					else
						begin
							setError(PERR_NOMEM);
							exit
						end
				end
		end;
	
	procedure tpProdukt(var baum: PNode);
		var pn: PNode;
	
		begin
			if error then exit;
			tpPotenz(baum);
			if error then exit;
			while tokentype=TT_MULTOP do
				begin
					if p^.NewNode(pn) then
						begin
							case tokensubtype of
							TST_MULT:
								pn^.Typ:=NT_MULT;
							TST_DIV:
								pn^.Typ:=NT_DIV;
							TST_NAT_MULT:
								pn^.Typ:=NT_NAT_MULT;
							TST_NAT_DIV:
								pn^.Typ:=NT_NAT_DIV;
							else
								begin
									setError(PERR_INTERNAL3);
									exit
								end
							end;
							pn^.Left.Node:=baum;
							baum:=pn;
							tpGetNextToken;
							if error then exit;
							pn:=nil;
							tpPotenz(pn);
							if error then
								begin
									if errcode=PERR_FACTORINVALID then
										begin
											if (baum^.Typ=NT_MULT) or (baum^.Typ=NT_NAT_MULT) then errcode:=PERR_FAKTORMISSING
											else
												errcode:=PERR_DIVISORMISSING;
										end;
									exit
								end;
							baum^.Right.Node:=pn
						end
					else
						begin
							setError(PERR_NOMEM);
							exit
						end
				end
		end;

	procedure tpSumme(var baum: PNode);
		var pn: PNode;

		begin
			if error then exit;
			tpProdukt(baum);
			if error then exit;
			while tokentype=TT_PLUSMINUS do
				begin
					if p^.NewNode(pn) then
						begin
							case tokensubtype of
							TST_PLUS:
								pn^.Typ:=NT_PLUS;
							TST_MINUS:
								pn^.Typ:=NT_MINUS;
							TST_NAT_PLUS:
								pn^.Typ:=NT_NAT_PLUS;
							TST_NAT_MINUS:
								pn^.Typ:=NT_NAT_MINUS;
							else
								begin
									setError(PERR_INTERNAL1);
									exit
								end
							end;
							pn^.Left.Node:=baum;
							baum:=pn;
							tpGetNextToken;
							if error then exit;
							pn:=nil;
							tpProdukt(pn);
							if error then
								begin
									if errcode=PERR_FACTORINVALID then
										begin
											if (baum^.Typ=NT_PLUS) or (baum^.Typ=NT_NAT_PLUS) then errcode:=PERR_SUMMANDMISSING
											else
												errcode:=PERR_SUBTRAHENDMISSING;
										end;
									exit
								end;
							baum^.Right.Node:=pn
						end
					else
						begin
							setError(PERR_NOMEM);
							exit
						end
				end
		end;

	procedure tpVergleich(var baum: PNode);
		var pn: PNode;

		begin
			if error then exit;
			tpSumme(baum);
			if error then exit;
			while tokentype=TT_RELOP do
				begin
					if p^.NewNode(pn) then
						begin
							case tokensubtype of
							TST_EQUAL:
								pn^.Typ:=NT_EQUAL;
							TST_UNEQUAL:
								pn^.Typ:=NT_UNEQUAL;
							TST_LESS:
								pn^.Typ:=NT_LESS;
							TST_LESSEQUAL:
								pn^.Typ:=NT_LESSEQUAL;
							TST_GREATER:
								pn^.Typ:=NT_GREATER;
							TST_GREATEREQUAL:
								pn^.Typ:=NT_GREATEREQUAL;
							else
								begin
									setError(PERR_INTERNAL2);
									exit
								end
							end;
							pn^.Left.Node:=baum;
							baum:=pn;
							tpGetNextToken;
							if error then exit;
							pn:=nil;
							tpSumme(pn);
							if error then
								begin
									if errcode=PERR_FACTORINVALID then errcode:=PERR_COMPINCOMPLETE;
									exit
								end;
							baum^.Right.Node:=pn
						end
					else
						begin
							setError(PERR_NOMEM);
							exit
						end
				end
		end;

	procedure tpFormel(var baum: PNode);
		var oldsrc: PChar;
		    pvr   : PVariable;

		begin
			if (tokentype<>TT_RELOP) or (tokensubtype<>TST_EQUAL) or error then
				begin
					setError(PERR_OK);
					exit
				end;
			oldsrc:=source;
			tpGetNextToken;
			if error then exit;
			if tokentype=TT_VARIABLE then
				begin
					bvar:=StrPas(token);
					pvr:=tokenvr;
					tpGetNextToken;
					if (tokentype<>TT_RELOP) or (tokensubtype<>TST_EQUAL) or error then
						begin
							setError(PERR_OK);
							bvar:='';
							source:=oldsrc
						end
					else
						if pvr<>nil then
							begin
								if varerr then
									begin
										Application^.Alert(p,1,NOTE,MESSAGE_WINDOW_VAR1+StrPUpper(bvar)+MESSAGE_WINDOW_VAR2+p^.GetColumnIndex(pvr^.RefCol)+p^.GetRowIndex(pvr^.RefRow)+MESSAGE_WINDOW_VAR3,BUTTON_OK);
										exit
									end
								else
									bvar:='';
							end;
					tpGetNextToken;
					if error then exit;
				end;
			tpVergleich(baum);
			if error then exit;
			if tokentype<>TT_ENDOFFORMULA then
				begin
					if tokentype=TT_KLAMMERAUF then setError(PERR_INCOMPCHARSFUNC)
					else
						setError(PERR_INCOMPCHARS);
				end;
		end;

	begin
		Parse:=false;
		p:=PCalcWindow(Parent);
		baum:=nil;
		svar:='';
		bvar:='';
		StrPCopy(buffer,s);
		source:=buffer;
		lasttoken:=source;
		setError(PERR_OK);
		tpGetNextToken;
		tpFormel(baum);
		if error then p^.DeleteNode(baum)
		else
			if baum<>nil then
				begin
					if length(bvar)>0 then
						begin
							p^.NewVariable(ar,ac,bvar);
							svar:=bvar
						end;
					Parse:=true
				end
	end;

end.