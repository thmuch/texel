program TexelKey;

var

	name,key: string;
	f       : text;
	q,l     : integer;


function c2s(b1,b2: byte): string;
	var b: byte;

	begin
		b:=((b1+13) mod 256) xor ((b2+37) mod 256);
		c2s:=chr((b and 15)+65)+chr(((b shr 3) and 15)+65)
	end;


begin
	clrscr;
	write('Name: ');
	readln(name);
	if length(name)<2 then halt;
	assign(f,'TEXELKEY.TXT');
	rewrite(f);
	writeln(f,'Hallo Betatester(in),');
	writeln(f,'fr Texel ab Version 0.10 wird ein Schlssel ben”tigt,');
	writeln(f,'damit einige Programmfunktionen nicht gesperrt sind');
	writeln(f,'(z.B. Speichern ab Version 0.11).');
	writeln(f,'Damit Du Texel weiterhin uneingeschr„nkt nutzen kannst,');
	writeln(f,'mužt Du nur folgende Zeilen an das Ende Deiner TEXEL.INF');
	writeln(f,'kopieren. Viel Spaž!');
	writeln(f);
	writeln(f,'----------schnipp--------------------------------------');
	writeln(f);
	writeln(f,'[Beta]');
	writeln(f,'Name=',name);
	if odd(length(name)) then name:=name+name[2];
	l:=length(name);
	key:='';
	for q:=1 to (l shr 1) do key:=key+c2s(ord(name[q]),ord(name[l+q-q]));
	writeln(f,'Key=',key);
	writeln(f);
	writeln(f,'----------schnapp--------------------------------------');
	writeln(f);
	writeln(f,'(Diese Nachricht wurde maschinell erzeugt)');
	close(f)
end.