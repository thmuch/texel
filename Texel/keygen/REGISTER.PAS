program Register;

{$E .TOS}

uses

	Tos;

label

	_raus;

var

	start,
	anz,
	ret  : longint;
	hdl  : integer;
	buf  : char;
	answ : string;


function code_name(s: string): string;
	var q: integer;

	begin
		if length(s)>0 then
			for q:=1 to length(s) do s[q]:=chr(ord(s[q]) xor 255);
		code_name:=s+#0
	end;


begin
	ret:=fopen('TEXEL.APP',FO_RW);
	if ret<0 then exit;
	hdl:=integer(ret);
	fseek(240000,hdl,0);
	start:=-1;
	while fread(hdl,1,@buf)=1 do
		begin
			if buf='n' then
				begin
					if start>=0 then
						begin
							inc(anz);
							if anz=30 then
								begin
									answ:=code_name('Texel-Team');
									fseek(start,hdl,0);
									fwrite(hdl,length(answ),@answ[1]);
									answ:=code_name('');
									fseek(start+32,hdl,0);
									fwrite(hdl,length(answ),@answ[1]);
									answ:=code_name('2700000404');
									fseek(start+64,hdl,0);
									fwrite(hdl,length(answ),@answ[1]);
									writeln('Texel wurde korrekt registriert.');
									goto _raus
								end;
						end
					else
						begin
							start:=fseek(0,hdl,1)-1;
							anz:=1
						end
				end
			else
				start:=-1;
		end;
	_raus:
	fclose(hdl);
end.