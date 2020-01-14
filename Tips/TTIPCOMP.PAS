program TexelTipCompiler;

uses

	Tos,OProcs;

var

	fin     : text;
	dummy,
	ins,outs: string;
	outhdl,
	lcount  : integer;
	res     : longint;

begin
	assign(fin,'tips.txt');
	res:=fcreate('Texel.tip',0);
	if res<0 then exit;
	outhdl:=integer(res);
	reset(fin);
	outs:='';
	lcount:=0;
	while not(eof(fin)) do
		begin
			readln(fin,ins);
			StrPTrim(ins);
			if length(ins)>0 then
				begin
					outs:=outs+StrPLeft(ins,50)+'|';
					inc(lcount)
				end;
			if (length(ins)=0) or (lcount=5) then
				begin
					if length(outs)>1 then
						begin
							fillchar(dummy,256,0);
							dummy:=CutRightF(outs,1);
							fwrite(outhdl,256,@dummy)
						end;
					outs:='';
					lcount:=0
				end
		end;
	if length(outs)>1 then
		begin
			fillchar(dummy,256,0);
			dummy:=CutRightF(outs,1);
			fwrite(outhdl,256,@dummy)
		end;
	fclose(outhdl);
	close(fin);
end.