{ texel_g.inc }
{ German include file for Texel 2.0 }
{ 23.11.1997 tm }

const

{ texel.grp }

	GROUP_GENERAL_RANGE     = 'Bereich';
	GROUP_GENERAL_ROWS      = 'Zeilen';

	GROUP_EXPORT_SAVEWITH   = 'Speichern mit';
	GROUP_EXPORT_TYPE       = 'Typ';
	GROUP_EXPORT_DOCTYPE    = 'Dokumenttyp';

	GROUP_LAYOUT_MARGINS    = 'RÑnder';
	GROUP_LAYOUT_CENTER     = 'Zentrierung';
	GROUP_LAYOUT_NUM        = 'Numerierung';
	GROUP_LAYOUT_HEAD       = 'Kopfzeile';
	GROUP_LAYOUT_FOOT       = 'Fuûzeile';
	GROUP_LAYOUT_PRINTWITH  = 'Drucken mit';
	GROUP_LAYOUT_PRINTRANGE = 'Druckbereich';

	GROUP_INFO_FILE         = 'Datei';

	GROUP_DELCELL_FILL      = 'AuffÅllen';

	GROUP_FIND_DIRECTION    = 'Reihenfolge';
	GROUP_FIND_SEARCHIN     = 'Suchen in';
	GROUP_FIND_SEARCHAS     = 'Suchen als';
	GROUP_FIND_FORBACKWARD  = 'Richtung';

	GROUP_REPLACE_DIRECTION = 'Reihenfolge';
	GROUP_REPLACE_REPLIN    = 'Ersetzen in';
	GROUP_REPLACE_FORBACK   = 'Richtung';

	GROUP_INSERT_PASTE      = 'EinfÅgen';
	GROUP_INSERT_OPERATION  = 'Rechenoperation';

	GROUP_DIAGRAM_CHANGE    = 'éndern';
	GROUP_DIAGRAM_AXISLEFT  = 'Achse links';
	GROUP_DIAGRAM_AXISBOTM  = 'Achse unten';
	GROUP_DIAGRAM_DATA      = 'Datenreihen';
	GROUP_DIAGRAM_NAMESIN   = 'Namen in';
	GROUP_DIAGRAM_SIZE      = 'Grîûe';

	GROUP_SHEET_SIZE        = 'Grîûe';
	GROUP_SHEET_RULER       = 'Lineal';
	GROUP_SHEET_GENERAL     = 'Allgemein';

	GROUP_SORT_WHAT         = 'Sortieren von';
	GROUP_SORT_NUMBERS      = 'Zahlen';
	GROUP_SORT_SPACES       = 'Leerzellen';
	GROUP_SORT_SORT1        = 'Sortieren nach';
	GROUP_SORT_SORT2        = 'Anschlieûend nach';
	GROUP_SORT_SORT3        = 'Anschlieûend nach';

	GROUP_TEXT_FX           = 'Effekte';
	GROUP_TEXT_ANGLE        = 'Winkel';
	GROUP_TEXT_ALIGNMENT    = 'Ausrichtung';
	GROUP_TEXT_MISC         = 'Sonstiges';

	GROUP_BORDER_BLOCK      = 'Block';
	GROUP_BORDER_CELLS      = 'Zellen';

	GROUP_OBJECT_BACKGR     = 'Hintergrund';
	GROUP_OBJECT_TEXT       = 'Text';
	GROUP_OBJECT_IMAGE      = 'Grafik';

{ texel.hlp }

	BUBBLE_EASTEREGG       = '"Holland hat schîne Inseln, Heidelberg schîne Tabellenkalkulationen!"';

	BUBBLE_GENERAL_RANGE    = 'Zeigt den aktuellen Block an, auf den die Aktionen dieses Dialogs wirken. Durch Anklicken bzw. mit Control+B kînnen Sie einen neuen Block definieren.';
	BUBBLE_GENERAL_HELP     = 'Ruft die ST-Guide-Onlinehilfe auf. Wenn der ST-Guide nicht installiert ist, ist dieser Button nicht anwÑhlbar.';
	BUBBLE_GENERAL_CANCEL   = 'Schlieût den Dialog, ohne eine Aktion auszufÅhren';
	BUBBLE_GENERAL_SET      = 'Setzt die aktuellen Werte dieses Dialogs im markierten Block, ohne den Dialog zu verlassen';
	BUBBLE_GENERAL_SET2     = 'Setzt die aktuellen Werte, ohne den Dialog zu verlassen';
	BUBBLE_GENERAL_SETOK    = 'Setzt die aktuellen Werte im markierten Bereich und verlÑût den Dialog';
	BUBBLE_GENERAL_OK       = 'öbernimmt die aktuellen Werte und verlÑût den Dialog';
	BUBBLE_GENERAL_OK2      = 'öbernimmt die Einstellungen';
	BUBBLE_GENERAL_OBJSET   = 'Setzt die aktuellen Werte dieses Dialogs beim zugehîrigen Objekt, ohne den Dialog zu verlassen';
	BUBBLE_GENERAL_OBJSETOK = 'Setzt die aktuellen Werte beim zugehîrigen Objekt und verlÑût den Dialog';
	BUBBLE_GENERAL_CLOSE    = 'Schlieût den Dialog';
	
	BUBBLE_SETUP_DEFDOC     = 'Legt grundsÑtzliche Werte fÅr alle ArbeitsblÑtter fest, die beim Anlegen eines neuen Dokuments verwendet werden';
	BUBBLE_SETUP_WINDOW     = 'Bestimmt Eigenschaften von allen ArbeitsblÑttern';
	BUBBLE_SETUP_GENERAL    = 'Bestimmt das globale Verhalten der gesamten Applikation';
	BUBBLE_SETUP_STARTUP    = 'Bestimmt das Programmverhalten beim Start von Texel';
	BUBBLE_SETUP_ROWS       = 'Gibt an, wieviele Zeilen ein neues Blatt standardmÑûig hat (max. 16384)';
	BUBBLE_SETUP_COLUMNS    = 'Gibt an, wieviele Spalten ein neues Blatt standardmÑûig hat (max. 702)';
	BUBBLE_SETUP_COLWIDTH   = 'Die Standardspaltenbreite wird in Zeichen angegeben; sie wird abhÑngig vom verwendeten Zeichensatz entsprechend in Pixel umgerechnet';
	BUBBLE_SETUP_AUTOCALC   = 'Legt fest, ob bei neuen BlÑttern die automatische Neuberechnung standardmÑûig eingeschaltet ist (das sollte eigentlich immer der Fall sein)';
	BUBBLE_SETUP_FONTID     = 'Legt den Standardzeichensatz fest';
	BUBBLE_SETUP_FONTSIZE   = 'Bestimmt die Standardzeichenhîhe';
	BUBBLE_SETUP_SIZERRANGE = 'Bestimmt, welcher Bereich um die Spalten- bzw. Reihentrennungslinien verwendet wird, um die Zellenbreite und -hîhe mit der Maus zu Ñndern';
	BUBBLE_SETUP_FPOINT     = 'Legt die Standardanzahl von Nachkommastellen fÅr jede neu eingegebene Zahl fest';
	BUBBLE_SETUP_HISTORY    = 'Legt fest, wieviele EintrÑge in der Liste des Block-Dialogs (<Control>+<B>) gespeichert werden';
	BUBBLE_SETUP_CRSWRAP    = 'Bestimmt, ob der Cursor auf die gegenÅberliegende Seite des Blattes springt, wenn er Åber den Blattrand hinausbewegt wird';
	BUBBLE_SETUP_XINPUT     = 'Wenn diese Option eingeschaltet ist, werden Tastatureingaben immer an das Fenster unter dem Mauszeiger weitergeleitet (sonst an das oberste Fenster)';
	BUBBLE_SETUP_CLOSER     = 'Wenn dieses KÑstchen angekreuzt ist, entspricht das Schlieûen eines Dialogs dem <Abbruch>-Button, sonst dem <OK>-Button (die Einstellung wird erst beim nÑchsten Start wirksam!)';
	BUBBLE_SETUP_NEW        = 'Hiermit kann beim Programmstart automatisch ein neues Blatt geîffnet werden';
	BUBBLE_SETUP_OPEN       = 'Wenn dieser Button markiert ist, zeigt Texel beim Programmstart eine Dateiauswahlbox an';
	BUBBLE_SETUP_NOTHING    = 'Wenn dieser Button markiert ist, passiert nach dem Laden von Texel gar nichts';
	BUBBLE_SETUP_FULLSIZE   = 'Gibt an, ob BlÑtter nach dem Laden auf volle Bildschirmgrîûe gebracht werden sollen. Bei Groûbildschirmen kann diese Option stîrend sein.';
	BUBBLE_SETUP_BLOCK      = 'Schalten Sie diesen Button ein, falls Sie auf dem Bildschirm nicht das sehen, was Ihr GDOS ausdruckt (die Einstellung wird erst beim nÑchsten Start wirksam!)';
	BUBBLE_SETUP_RECALC     = 'Berechnet ein Blatt nach dem Laden neu (wichtig fÅr Datumsrechnungen). Sollte nur auf langsamen Rechnern ausgeschaltet werden.';
	BUBBLE_SETUP_RTBLOCK    = 'Die Realtime-Blockmarkierung kann auf langsamen Rechnern zu langsam sein, deshalb kann sie hiermit ausgeschaltet werden.';
	BUBBLE_SETUP_BACKUP     = 'Wenn dieser Button markiert ist, wird beim Speichern einer .TXL-Datei eine evtl. schon vorhandene Datei in .BAK umbenannt';
	BUBBLE_SETUP_PRINTER    = 'Konfiguriert den Standard-Druckertreiber';
	BUBBLE_SETUP_TOOLBAR    = 'Legt fest, ob bei neuen ArbeitsblÑttern die Toolbar eingeschaltet ist';
	BUBBLE_SETUP_CURRENCY   = 'Bestimmt, welches WÑhrungsformat der entsprechende Toolbar-Button einstellt';
	BUBBLE_SETUP_OVERFLOW   = 'Bestimmt, ob bei Zahlzellen getestet wird, ob die Zahl aus der Zelle herausragt und die Zahl daher durch Doppelkreuze (###) ersetzt wird. Ausschalten bringt fÅr langsame Rechner Geschwindigkeitsvorteile!';
	BUBBLE_SETUP_BOTTOMLINE = 'Wenn diese Option eingeschaltet ist, lassen auch Fenster mit voller Grîûe am unteren Bildschirmrand Platz fÅr z.B. SMU oder AppLine';

	BUBBLE_INPUT_EMPTY      = 'Die Eingabezeile ist z.Z. leer.';

	BUBBLE_SHEET_TOGGLE     = 'Markiert das gesamte Blatt bzw. - falls bereits ein Block markiert ist - hebt die Blockmarkierung auf';
	
	BUBBLE_BLOCK_EDIT       = 'EnthÑlt nach dem Aufruf den aktuellen Block. Soll dieser nicht geÑndert werden, kann eine leere Zeichenkette eingetragen werden';
	BUBBLE_BLOCK_LIST       = 'Zeigt die bisher markierten Blîcke sowie die Zellvariablen an';
	BUBBLE_BLOCK_OK         = 'VerlÑût den Blockeingabedialog. Wenn der neue Wert eine gÅltige Blockangabe ist, wird die Markierung entsprechend aktualisiert';

	BUBBLE_FNBAR_FONTID     = 'Stellt den in den Zellen verwendeten Zeichensatz ein';
	BUBBLE_FNBAR_FONTSIZE   = 'Bestimmt die Zeichenhîhe';
	BUBBLE_FNBAR_PERCENT    = 'éndert die Darstellungsgrîûe des Blattes';
	BUBBLE_FNBAR_BACKCOLOR  = 'éndert die Farbe des Hintergrundmusters der aktuellen Zelle(n)';
	BUBBLE_FNBAR_PATTERN    = 'éndert das Hintergrundmuster der aktuellen Zelle(n)';
	BUBBLE_FNBAR_AUTOCURSOR = 'Gibt die Richtung des Cursors nach <Return> an (AutoCursor)';
	BUBBLE_FNBAR_BLOCK      = 'Zeigt die aktuelle Markierung (Cursor/Block) an bzw. erlaubt die manuelle Eingabe derselben';
	BUBBLE_FNBAR_CANCEL     = 'Bricht die Texteingabe bei Zellen ab';
	BUBBLE_FNBAR_OK         = 'öbernimmt den Text in die Zelle';
	BUBBLE_FNBAR_TEXTCOLOR  = 'éndert die Textfarbe im aktuellen Block';
	BUBBLE_FNBAR_BORDER     = 'Versieht den aktuellen Block/die aktuelle Zelle mit einem Rahmen';
	BUBBLE_FNBAR_TBONOFF    = 'Schaltet die Toolbar an bzw. aus';
	
	BUBBLE_TOOLBAR_SAVE     = 'Speichert das Kalkulationsblatt';
	BUBBLE_TOOLBAR_PRINT    = 'Druckt das Kalkulationsblatt aus';
	BUBBLE_TOOLBAR_CUT      = 'Schneidet die aktuelle Markierung aus';
	BUBBLE_TOOLBAR_COPY     = 'Kopiert die aktuelle Markierung ins Klemmbrett';
	BUBBLE_TOOLBAR_PASTE    = 'FÅgt den Inhalt des Klemmbretts an der aktuellen Position ein';
	BUBBLE_TOOLBAR_SUM      = 'Aktiviert die zuletzt aktive Zelle und trÑgt in der Eingabezeile die Summenfunktion ein. Wenn ein Block markiert ist, wird dieser Bereich in die Summe eingefÅgt.';
	BUBBLE_TOOLBAR_FN       = 'Ruft den Funktionsmanager auf';
	BUBBLE_TOOLBAR_BOLD     = 'Schaltet bei der aktuellen Markierung Fettschrift ein bzw. aus';
	BUBBLE_TOOLBAR_ITALIC   = 'Schaltet bei der aktuellen Markierung kursive Schrift ein bzw. aus';
	BUBBLE_TOOLBAR_UNDERL   = 'Schaltet bei der aktuellen Markierung Unterstreichung ein bzw. aus';
	BUBBLE_TOOLBAR_LEFT     = 'Richtet den Text im aktuellen Block linksbÅndig aus';
	BUBBLE_TOOLBAR_CENTER   = 'Richtet den Text im aktuellen Block mittig aus';
	BUBBLE_TOOLBAR_RIGHT    = 'Richtet den Text im aktuellen Block rechtsbÅndig aus';
	BUBBLE_TOOLBAR_NUMBER   = 'Setzt im aktuellen Block das Zahlenformat {0,00}';
	BUBBLE_TOOLBAR_DATE     = 'Setzt im aktuellen Block das Zahlenformat [TT].[MM].[JJJJ]';
	BUBBLE_TOOLBAR_MONEY    = 'Setzt im aktuellen Block das in "Optionen - Einstellungen" gewÑhlte WÑhrungs-Zahlenformat';
	BUBBLE_TOOLBAR_PERCENT  = 'Setzt im aktuellen Block das Zahlenformat (100){0}%';
	BUBBLE_TOOLBAR_SORTUP   = 'Sortiert den aktuellen Block nach den (bis zu) ersten drei Spalten aufsteigend';
	BUBBLE_TOOLBAR_SORTDOWN = 'Sortiert den aktuellen Block nach den (bis zu) ersten drei Spalten absteigend';
	BUBBLE_TOOLBAR_FPLUS    = 'Erhîht die Anzahl der Nachkommastellen einer Formel- bzw. Konstantenzelle um eins';
	BUBBLE_TOOLBAR_FMINUS   = 'Vermindert die Anzahl der Nachkommastellen einer Formel- bzw. Konstantenzelle um eins';
	BUBBLE_TOOLBAR_DIAGRAM  = 'Erzeugt aus dem aktuell markierten Block ein Balkendiagramm. <Shift> kehrt Datenzeilen/-spalten um.';
	BUBBLE_TOOLBAR_HOME     = 'Bringt den Cursor zur Zelle A1 (Home)';

	BUBBLE_TEXTATTR_BOLD    = 'Schriftstil fett';
	BUBBLE_TEXTATTR_LIGHT   = 'Schriftstil hell';
	BUBBLE_TEXTATTR_ITALIC  = 'Schriftstil kursiv (Italic)';
	BUBBLE_TEXTATTR_UNDERL  = 'Schriftstil unterstrichen';
	BUBBLE_TEXTATTR_OUTL    = 'Schriftstil umrandet (Outline)';
	BUBBLE_TEXTATTR_SHADOW  = 'Schriftstil schattiert (wird nicht von allen GDOS-Versionen und Bildschirmtreibern unterstÅtzt)';
	BUBBLE_TEXTATTR_ROTAT   = 'Bestimmt den Rotationswinkel des Textes. Bei Bitmapfonts kann dies nur in 90-Grad-Schritten geschehen.';
	BUBBLE_TEXTATTR_SKEW    = 'Legt die SchrÑgstellung (Skew) der Schrift fest (nur mit Vektorfont-GDOS)';
	BUBBLE_TEXTATTR_CLIP    = 'Legt fest, ob Textausgaben am Rand einer Zelle abgeschnitten werden';
	BUBBLE_TEXTATTR_LEFT    = 'LinksbÅndiger Text';
	BUBBLE_TEXTATTR_CENTER  = 'Horizontal zentrierter Text';
	BUBBLE_TEXTATTR_RIGHT   = 'RechtsbÅndiger Text';
	BUBBLE_TEXTATTR_COLOR   = 'Legt die Textfarbe fest';
	BUBBLE_TEXTATTR_CROTAT  = 'Gibt an, ob der Rotationswert beachtet werden soll';
	BUBBLE_TEXTATTR_CSKEW   = 'Gibt an, ob der SchrÑgstellungswert beachtet werden soll';
	BUBBLE_TEXTATTR_CHALIGN = 'Gibt an, ob die horizontale Ausrichtung beachtet werden soll';
	BUBBLE_TEXTATTR_CVALIGN = 'Gibt an, ob die vertikale Ausrichtung beachtet werden soll';
	BUBBLE_TEXTATTR_CCOLOR  = 'Gibt an, ob die Textfarbe beachtet werden soll';
	BUBBLE_TEXTATTR_TOP     = 'Oben ausgerichteter Text';
	BUBBLE_TEXTATTR_MIDDLE  = 'Vertikal zentrierter Text';
	BUBBLE_TEXTATTR_BOTTOM  = 'Unten ausgerichteter Text';
	BUBBLE_TEXTATTR_FXOFF   = 'Schaltet alle Texteffekte aus';
	BUBBLE_TEXTATTR_FXIGNOR = 'Stellt alle Texteffekte auf "nicht beachten"';
	
	BUBBLE_NUMFORM_CATEGORY = 'Zeigt alle verfÅgbaren Gruppen von Zahlenformaten an';
	BUBBLE_NUMFORM_FORMLIST = 'Listet die Zahlenformate abhÑngig von der Auswahl in der Liste links auf';
	BUBBLE_NUMFORM_FORMAT   = 'Zeigt das ausgewÑhlte Zahlenformat in voller LÑnge an';
	BUBBLE_NUMFORM_PREVIEW  = 'Wenn die Zelle links oben im Block eine Zahl enthÑlt, wird auf sie das aktuelle Zahlenformat angewendet und hier angezeigt';
	BUBBLE_NUMFORM_NEW      = 'Erzeugt ein neues, benutzerdefiniertes Zahlenformat';
	BUBBLE_NUMFORM_DELETE   = 'Lîscht das ausgewÑhlte benutzerdefinierte Zahlenformat';
	BUBBLE_NUMFORM_CHANGE   = 'éndert das ausgewÑhlte benutzerdefinierte Zahlenformat';
	
	BUBBLE_ROWSIZE_BLOCK    = 'Diese Zeilen sind z.Z. markiert und kînnen mit OK verÑndert werden';
	BUBBLE_ROWSIZE_HEIGHT   = 'Die neue Zeilenhîhe in mm (Genauigkeit 1/100 mm)';
	BUBBLE_ROWSIZE_OK       = 'Setzt die markierte(n) Zeile(n) auf die angegebene Hîhe und verlÑût den Dialog';

	BUBBLE_COLSIZE_BLOCK    = 'Diese Spalten sind z.Z. markiert und kînnen mit OK verÑndert werden';
	BUBBLE_COLSIZE_WIDTH    = 'Die neue Spaltenbreite in mm (Genauigkeit 1/100 mm)';
	BUBBLE_COLSIZE_OK       = 'Setzt die markierte(n) Spalte(n) auf die angegebene Breite und verlÑût den Dialog';
	
	BUBBLE_COLNAME_SEL      = 'Die ausgewÑhlte Spalte, deren Namen mit OK verÑndert werden kann';
	BUBBLE_COLNAME_OLD      = 'Der alte Spaltenname';
	BUBBLE_COLNAME_NEW      = 'Der neue Spaltenname';
	BUBBLE_COLNAME_OK       = 'Weist der ausgewÑhlten Spalte den neuen Namen zu und verlÑût den Dialog';
	
	BUBBLE_PATTERN_NAME     = 'Der Name der ausgewÑhlten Farbe (fÅr monochrome Auflîsungen)';
	BUBBLE_PATTERN_COLORS   = 'Alle zur VerfÅgung stehenden Farben. Farben, die von der Bildschirmauflîsung nicht angeboten werden, werden schwarz dargestellt.';
	BUBBLE_PATTERN_PATTERN  = 'Die Muster, mit denen die Farben aufgehellt werden kînnen';
	BUBBLE_PATTERN_PREVIEW  = 'Zeigt das mîgliche Ergebnis an';
	
	BUBBLE_BORDER_OUTLINE   = 'Legt den Ñuûeren Rahmen des aktuellen Blocks fest (hat PrioritÑt gegenÅber den einzelnen Kanten)';
	BUBBLE_BORDER_TOP       = 'Legt den Rahmen an der oberen Kante jeder Zelle fest';
	BUBBLE_BORDER_BOTTOM    = 'Legt den Rahmen an der unteren Kante jeder Zelle fest';
	BUBBLE_BORDER_LEFT      = 'Legt den Rahmen an der linken Kante jeder Zelle fest';
	BUBBLE_BORDER_RIGHT     = 'Legt den Rahmen an der rechten Kante jeder Zelle fest';
	BUBBLE_BORDER_HOR       = 'Legt die horizontale Durchstreichung jeder Zelle fest';
	BUBBLE_BORDER_VERT      = 'Legt die vertikale Durchstreichung jeder Zelle fest';
	BUBBLE_BORDER_OCOLOR    = 'Legt die Farbe fÅr den Ñuûeren Blockrahmen fest (hat PrioritÑt gegenÅber den einzelnen Kanten)';
	BUBBLE_BORDER_4COLOR    = 'Legt die Farbe fÅr alle Kanten jeder Zelle fest. Angrenzende Kanten haben spÑter immer die gleiche Farbe!';
	BUBBLE_BORDER_HCOLOR    = 'Legt die Farbe fÅr die horizontale Durchstreichung fest';
	BUBBLE_BORDER_VCOLOR    = 'Legt die Farbe fÅr die vertikale Durchstreichung fest';
	
	BUBBLE_CLIP_IMPORT      = 'Ruft den ASCII-Import fÅr die aktuelle Klemmbrett-Datei auf';
	BUBBLE_CLIP_OK          = 'LÑdt eine DIF- oder CSV-Datei aus dem Klemmbrett';
	
	BUBBLE_ABOUT_OK         = 'Schlieût den "öber..."-Dialog';
	
	BUBBLE_LAYOUT_TMARGIN   = 'Legt den Seitenrand oberhalb der Kopfzeile fest';
	BUBBLE_LAYOUT_BMARGIN   = 'Legt den Seitenrand unterhalb der Fuûzeile fest';
	BUBBLE_LAYOUT_LMARGIN   = 'Legt den linken Seitenrand fest';
	BUBBLE_LAYOUT_RMARGIN   = 'Legt den rechten Seitenrand fest';
	BUBBLE_LAYOUT_HCENTER   = 'Zentriert die Tabelle bzw. den Tabellenausschnitt horizontal auf der Seite abzgl. der RÑnder';
	BUBBLE_LAYOUT_VCENTER   = 'Zentriert die Tabelle bzw. den Tabellenausschnitt vertikal auf der Seite abzgl. der RÑnder';
	BUBBLE_LAYOUT_GRID      = 'Legt fest, ob bei Zellen ohne expliziten Rahmen ein graues bzw. gepunktetes Gitter gedruckt wird';
	BUBBLE_LAYOUT_NUMBERS   = 'Legt fest, ob die Zeilennummern ausgedruckt werden';
	BUBBLE_LAYOUT_NAMES     = 'Legt fest, ob die Spaltennamen ausgedruckt werden';
	BUBBLE_LAYOUT_PRNTRANGE = 'Hier kann eine Bereichsangabe eingetragen werden. Exakt dieser Druckbereich wird ausgedruckt, wenn im Druckdialog der entsprechende Radiobutton angewÑhlt ist';
	BUBBLE_LAYOUT_LHEAD     = 'LinksbÅndiger Text der Kopfzeile';
	BUBBLE_LAYOUT_CHEAD     = 'Mittiger Text der Kopfzeile';
	BUBBLE_LAYOUT_RHEAD     = 'RechtsbÅndiger Text der Kopfzeile';
	BUBBLE_LAYOUT_LFOOT     = 'LinksbÅndiger Text der Fuûzeile';
	BUBBLE_LAYOUT_CFOOT     = 'Mittiger Text der Fuûzeile';
	BUBBLE_LAYOUT_RFOOT     = 'RechtsbÅndiger Text der Fuûzeile';
	BUBBLE_LAYOUT_NUMHOR    = 'Numeriert die Tabellenausschnitte horizontal durch';
	BUBBLE_LAYOUT_NUMVERT   = 'Numeriert die Tabellenausschnitte vertikal durch';
	BUBBLE_LAYOUT_PLHEAD    = 'Legt fest, ob der linksbÅndige Kopfzeilentext gedruckt wird';
	BUBBLE_LAYOUT_PCHEAD    = 'Legt fest, ob der mittige Kopfzeilentext gedruckt wird';
	BUBBLE_LAYOUT_PRHEAD    = 'Legt fest, ob der rechtsbÅndige Kopfzeilentext gedruckt wird';
	BUBBLE_LAYOUT_PLFOOT    = 'Legt fest, ob der linksbÅndige Fuûzeilentext gedruckt wird';
	BUBBLE_LAYOUT_PCFOOT    = 'Legt fest, ob der mittige Fuûzeilentext gedruckt wird';
	BUBBLE_LAYOUT_PRFOOT    = 'Legt fest, ob der rechtsbÅndige Fuûzeilentext gedruckt wird';
	BUBBLE_LAYOUT_POBJECTS  = 'Legt fest, ob eingebettete Objekte ausgedruckt werden';
	BUBBLE_LAYOUT_MHEAD     = 'Gibt an, wieviel Platz fÅr die Kopfzeile freigehalten wird';
	BUBBLE_LAYOUT_MFOOT     = 'Gibt an, wieviel Platz fÅr die Fuûzeile freigehalten wird';
	BUBBLE_LAYOUT_MINIMAL   = 'Berechnet die optimalen Hîhen fÅr Kopf- und Fuûzeile (abhÑngig davon, ob dort Texte gedruckt werden!)';

	BUBBLE_FN_GROUPS        = 'Listet alle verfÅgbaren Funktionsgruppen auf';
	BUBBLE_FN_FUNCTIONS     = 'Listet alle Funktionen auf, die zur in der linken Liste angegebenen Gruppe gehîren';
	BUBBLE_FN_SYNTAX        = 'Gibt die Syntax der angewÑhlten Funktion an';
	BUBBLE_FN_DESCR         = 'Zeigt eine kurze ErlÑuterung zur aktuellen Funktion an. Eine ausfÅhrlichere Beschreibung findet sich in der ST-Guide-Onlinehilfe.';
	BUBBLE_FN_INSERT        = 'FÅgt die aktuelle Funktion an der Cursorposition in der Eingabezeile ein. Wenn dies nicht sinnvoll ist (weil der Cursor an einer falschen Stelle steht), ertînt stattdessen ein Ping!';
	BUBBLE_FN_OK            = 'FÅgt die aktuelle Funktion an der Cursorposition in der Eingabezeile ein. Wenn dies nicht sinnvoll ist (weil der Cursor an einer falschen Stelle steht), ertînt stattdessen ein Ping!'
						                 +' Anschlieûend wird der Dialog geschlossen.';

	BUBBLE_OBJATTR_BACKGR   = 'Bestimmt die Eigenschaften des Objekt-Hintergrunds';
	BUBBLE_OBJATTR_TRANS    = 'Legt fest, ob der Hintergrund des Objekts gezeichnet wird oder ob das Objekt transparent auf den Zellen liegt.';
	BUBBLE_OBJATTR_BORDER   = 'Legt fest, ob die Objektumrandung (schwarze Linie) gezeichnet wird';
	BUBBLE_OBJATTR_BGCOL    = 'Legt die Hintergrundfarbe fest';
	
	BUBBLE_IMGOBJ_BGCOL     = 'Legt die Hintergrundfarbe fest';
	BUBBLE_IMGOBJ_IMGCOL    = 'Legt die Farbe der Grafik fest';
	BUBBLE_IMGOBJ_BACKGR    = 'Bestimmt die Eigenschaften des Objekt-Hintergrunds';
	BUBBLE_IMGOBJ_IMAGE     = 'Bestimmt die Eigenschaften der Grafik (Vordergrund)';
	BUBBLE_IMGOBJ_TRANS     = 'Legt fest, ob der Hintergrund des Objekts gezeichnet wird oder ob das Objekt transparent auf den Zellen liegt.';
	BUBBLE_IMGOBJ_BORDER    = 'Legt fest, ob die Objektumrandung (schwarze Linie) gezeichnet wird';
	
	BUBBLE_TXTOBJ_BGCOL     = 'Legt die Hintergrundfarbe fest';
	BUBBLE_TXTOBJ_TXTCOL    = 'Legt die Textfarbe fest';
	BUBBLE_TXTOBJ_BACKGR    = 'Bestimmt die Eigenschaften des Objekt-Hintergrunds';
	BUBBLE_TXTOBJ_TEXT      = 'Bestimmt die Eigenschaften des Textes (Vordergrund)';
	BUBBLE_TXTOBJ_TRANS     = 'Legt fest, ob der Hintergrund des Objekts gezeichnet wird oder ob das Objekt transparent auf den Zellen liegt.';
	BUBBLE_TXTOBJ_BORDER    = 'Legt fest, ob die Objektumrandung (schwarze Linie) gezeichnet wird';
	BUBBLE_TXTOBJ_FONTID    = 'Bestimmt die Schriftart';
	BUBBLE_TXTOBJ_FONTSIZE  = 'Bestimmt die Schriftgrîûe';

	BUBBLE_INSOBJ_SERVER    = 'Startet alle nîtigen Server nach, falls diese zwischenzeitlich terminiert haben.';
	BUBBLE_INSOBJ_LIST      = 'In dieser Liste sind alle Objekttypen aufgefÅhrt, die eingebettet werden kînnen';
	BUBBLE_INSOBJ_INSERT    = 'Zeigt eine Dateiauswahlbox an, mit der die einzubettende Datei ausgesucht werden kann.';
	BUBBLE_INSOBJ_OK        = 'Zeigt eine Dateiauswahlbox an, mit der die einzubettende Datei ausgesucht werden kann. Anschlieûend wird der Dialog geschlossen.';
	
	BUBBLE_IMPASC_FILE      = 'Der Name der zu importierenden Datei';
	BUBBLE_IMPASC_ROWS      = 'Gibt an, ob die spÑteren Zeilen (im Blatt) in der Datei horizontal oder vertikal gespeichert sind';
	BUBBLE_IMPASC_HOR       = 'Zeilen sind in der Datei horizontal gespeichert (zeilenweise). Dies ist der Normalfall.';
	BUBBLE_IMPASC_VERT      = 'Zeilen sind in der Datei vertikal gespeichert, d.h. die Datei-Zeilen enthalten die Blatt-Spalten.';
	BUBBLE_IMPASC_LINEEND   = 'Gibt an, welche Zeichen am Ende einer Datei-Zeile stehen (normalerweise CR+LF)';
	BUBBLE_IMPASC_CELLDIV   = 'Gibt an, durch welche(s) Zeichen die einzelnen Zellen getrennt sind (Åblich sind Tab, Komma oder Semikolon)';
	BUBBLE_IMPASC_QUOTECHAR = 'Gibt an, ob bzw. welches Zeichen am Anfang und Ende von normalem Klartext steht';
	BUBBLE_IMPASC_QUOTING   = 'Bestimmt, ob AnfÅhrungszeichen (Textquote) innerhalb von Texten verdoppelt sind (dies ist fast immer der Fall)';
	BUBBLE_IMPASC_FPOINT    = 'Gibt an, welches Zeichen in der Datei bei Zahlen Vor- und Nachkommastellen trennt';
	BUBBLE_IMPASC_OK        = 'Importiert die Datei in ein neues Blatt';
	BUBBLE_IMPASC_FILTER    = 'Legt fest, von welchem Betriebssystem der ASCII-Text stammt, um u.a. die Umlaute korrekt importieren zu kînnen. Damit mehr als der "Atari"-Filter zur VerfÅgung steht, muû KEYTAB installiert sein.';

	BUBBLE_IMPDB_SOURCE     = 'Der Name der zu importierenden Datenbank';
	BUBBLE_IMPDB_IMPORT     = 'Nimmt das markierte Feld der Liste links in die zu importierenden Felder rechts auf';
	BUBBLE_IMPDB_IGNORE     = 'Nimmt das markierte Feld der Liste rechts in die Liste der zu ignorierenden Felder links auf';
	BUBBLE_IMPDB_ALL        = 'Importiert alle Felder';
	BUBBLE_IMPDB_NONE       = 'Importiert kein Feld. Dabei werden die Felder wieder so wie in der Datenbank sortiert.';
	BUBBLE_IMPDB_IGNORELIST = 'In dieser Liste stehen die Felder der Datenbank, die beim Import Åbersprungen werden sollen';
	BUBBLE_IMPDB_IMPORTLIST = 'In dieser Liste stehen die Felder der Datenbank, die importiert werden sollen. Die Reihenfolge der Liste wird dabei beachtet.';
	BUBBLE_IMPDB_OK         = 'Importiert die Datenbank in ein neues Blatt';

	BUBBLE_EXPORT_FORMULA   = 'Bei Formeln wird die Klartextformel als String gespeichert, bei Konstanten die Zahl ohne Zahlenformat';
	BUBBLE_EXPORT_VALUE     = 'Bei Formeln und Konstanten wird die Zahl im verwendeten Zahlenformat gespeichert';
	BUBBLE_EXPORT_LINEHOR   = 'Zeilen werden in der Datei horizontal (als Zeilen) gespeichert. Dies ist der Normalfall.';
	BUBBLE_EXPORT_LINEVERT  = 'Zeilen werden in der Datei vertikal gespeichert, d.h. Blatt-Spalten werden zu Datei-Zeilen';
	BUBBLE_EXPORT_LINEEND   = 'Gibt an, welche Zeichen am Ende einer Datei-Zeile stehen sollen (normalerweise CR+LF)';
	BUBBLE_EXPORT_CELLDIV   = 'Gibt an, durch welche(s) Zeichen die einzelnen Zellen getrennt werden (Åblich sind Tab, Komma oder Semikolon)';
	BUBBLE_EXPORT_QUOTECHAR = 'Gibt an, ob bzw. welches Zeichen am Anfang und Ende von normalem Klartext steht soll';
	BUBBLE_EXPORT_QUOTING   = 'Bestimmt, ob AnfÅhrungszeichen (Textquote) innerhalb von Texten verdoppelt werden (dies ist fast immer der Fall)';
	BUBBLE_EXPORT_FPOINT    = 'Gibt an, welches Zeichen in der Datei bei Zahlen Vor- und Nachkommastellen trennen soll';
	BUBBLE_EXPORT_EMPTY     = 'Bei diesem Exportformat gibt es keine weiteren Einstellungsmîglichkeiten';
	BUBBLE_EXPORT_HTML      = 'Die Optionen fÅr den HTML-Export';
	BUBBLE_EXPORT_DIF       = 'Die Optionen fÅr den DIF-Export';
	BUBBLE_EXPORT_CSV       = 'Die Optionen fÅr den CSV-Export';
	BUBBLE_EXPORT_ASCII     = 'Die Optionen fÅr den ASCII-Export';
	BUBBLE_EXPORT_RTITLE    = 'Wenn dieser Button markiert ist, wird der angegebene Bereich exportiert, sonst das ganze Blatt';
	BUBBLE_EXPORT_FORMATS   = 'Mit diesem Popup kann das Exportformat festgelegt werden';
	BUBBLE_EXPORT_CLIPBOARD = 'Wenn dieser Button markiert ist, erfolgt der Export automatisch ins Klemmbrett';
	BUBBLE_EXPORT_FILE      = 'Zeigt eine Dateiauswahlbox an, mit der die Exportdatei festgelegt wird';
	BUBBLE_EXPORT_FILENAME  = 'Zeigt die ausgewÑhlte Exportdatei an (falls eine solche festgelegt wurde)';
	BUBBLE_EXPORT_EXPORT    = 'Exportiert das Blatt';
	BUBBLE_EXPORT_OK        = 'Exportiert das Blatt und schlieût den Dialog';
	BUBBLE_EXPORT_DOCTYPE   = 'Stellt den HTML-Dokumenttyp ein';
	BUBBLE_EXPORT_SAVEWITH  = 'Bestimmt, welche Teile bzw. welche Attribute des Blattes exportiert werden';
	BUBBLE_EXPORT_DTPOPUP   = 'Legt den HTML-Dokumenttyp fest. "3.0" ist Netscape-Standard, "3.2" offizieller W3C-Standard. Im Zweifel sollte man dennoch "3.0" wÑhlen.';
	BUBBLE_EXPORT_SAVEDT    = 'Bestimmt, ob der Dokumenttyp Åberhaupt in der Exportdatei gespeichert wird. Wenn die Tabelle in eine andere HTML-Datei eingebunden wird, ist dies unnîtig.';
	BUBBLE_EXPORT_COLORS    = 'Legt fest, ob die (nicht standardisierten) Farb- und Zeichensatzinformationen in die HTML-Tabelle exportiert werden';
	BUBBLE_EXPORT_DIFTYPE   = 'Wird zur Festlegung des DIF-Typs benîtigt, da M$-Produkte eine andere Zeilen/Spalten-Codierung verwenden als Åblich...';
	BUBBLE_EXPORT_DIFSTAND  = 'Mit dieser Option kann eine Standard-DIF-Datei exportiert werden';
	BUBBLE_EXPORT_DIFMS     = 'Mit dieser Option werden DIF-Dateien exportiert, die von M$-Produkten korrekt importiert werden';
	BUBBLE_EXPORT_ROWS      = 'Legt fest, in welcher Richtung die Zellen exportiert werden';
	BUBBLE_EXPORT_DIFFORM   = 'Legt fest, ob beim Speichern von Werten das Zahlenformat beachtet wird';
	BUBBLE_EXPORT_CSVFORM   = 'Legt fest, ob beim Speichern von Werten das Zahlenformat beachtet wird';
	BUBBLE_EXPORT_ASCIIFORM = 'Legt fest, ob beim Speichern von Werten das Zahlenformat beachtet wird';
	BUBBLE_EXPORT_EMBED     = 'Legt fest, ob die eingebetteten Objekte als <EMBED>-Tags exportiert werden. Die meisten Objekte kînnen allerdings nur mit CAB korrekt angezeigt werden, nicht aber mit dem Netscape Navigator oder M$ Internet Explorer.';
	BUBBLE_EXPORT_FILTER    = 'Legt fest, fÅr welches Betriebssystem die Datei exportiert werden soll, um u.a. die Umlaute korrekt exportieren zu kînnen. Damit mehr als der "Atari"-Filter zur VerfÅgung steht, muû KEYTAB installiert sein.';

	BUBBLE_CLEAR_FILL       = 'FÅllt den gelîschten Bereich mit leeren Zellen auf (identisch mit "Alles lîschen")';
	BUBBLE_CLEAR_LEFT       = 'Verschiebt die Zellen rechts vom ursprÅnglichen Block nach links';
	BUBBLE_CLEAR_RIGHT      = 'Verschiebt die Zellen links vom ursprÅnglichen Block nach rechts';
	BUBBLE_CLEAR_UP         = 'Verschiebt die Zellen unterhalb des ursprÅnglichen Blocks nach oben';
	BUBBLE_CLEAR_DOWN       = 'Verschiebt die Zellen oberhalb des ursprÅnglichen Blocks nach unten';
	BUBBLE_CLEAR_ROW        = 'Erweitert den Block bis zur ersten und letzten Spalte';
	BUBBLE_CLEAR_COLUMN     = 'Erweitert den Block bis zur ersten und letzten Zeile';
	BUBBLE_CLEAR_OK         = 'Lîscht den angegebenen Block und verlÑût den Dialog';
	
	BUBBLE_INSERT_LEFT      = 'Verschiebt die Zellen im markierten Block um die Breite des Blocks nach links';
	BUBBLE_INSERT_RIGHT     = 'Verschiebt die Zellen im markierten Block um die Breite des Blocks nach rechts';
	BUBBLE_INSERT_UP        = 'Verschiebt die Zellen im markierten Block um die Hîhe des Blocks nach oben';
	BUBBLE_INSERT_DOWN      = 'Verschiebt die Zellen im markierten Block um die Hîhe des Blocks nach unten';
	BUBBLE_INSERT_ROW       = 'Erweitert den Block bis zur ersten und letzten Spalte';
	BUBBLE_INSERT_COLUMN    = 'Erweitert den Block bis zur ersten und letzten Zeile';
	BUBBLE_INSERT_OK        = 'Verschiebt den markierten Block (und fÅgt an seiner Stelle leere Zellen ein) und verlÑût den Dialog';
	
	BUBBLE_INSVAL_ALL       = 'Formeln, Zahlen und Attribute werden eingefÅgt';
	BUBBLE_INSVAL_FORMULA   = 'Formeln und Zahlen werden eingefÅgt';
	BUBBLE_INSVAL_VALUE     = 'Es werden nur Zahlen eingefÅgt, bei Formeln wird dafÅr der aktuelle Wert genommen';
	BUBBLE_INSVAL_FORMAT    = 'Es werden nur Attribute Åbertragen';
	BUBBLE_INSVAL_NOTE      = 'Es werden nur Notizen Åbertragen';
	BUBBLE_INSVAL_OPNONE    = 'Die zu kopierenden Zellen ersetzen die Zellen im Zielbereich';
	BUBBLE_INSVAL_OPADD     = 'Die zu kopierenden Zellen werden zu den Zellen im Zielbereich addiert';
	BUBBLE_INSVAL_OPSUB     = 'Die zu kopierenden Zellen werden von den Zellen im Zielbereich abgezogen';
	BUBBLE_INSVAL_OPMUL     = 'Die Zellen im Zielbereich werden mit den zu kopierenden Zellen multipliziert';
	BUBBLE_INSVAL_OPDIV     = 'Die Zellen im Zielbereich werden durch die zu kopierenden Zellen geteilt';
	BUBBLE_INSVAL_EMPTY     = 'Wenn diese Box markiert ist, werden leere Zellen nicht kopiert, lîschen also auch keine Zellen im Zielbereich';
	BUBBLE_INSVAL_TRANSPOSE = 'Wenn diese Option aktiv ist, werden beim Kopieren Zeilen und Spalten vertauscht';
	BUBBLE_INSVAL_INSERT    = 'FÅgt Zellen vom Klemmbrett ein, ohne den Dialog zu verlassen';
	BUBBLE_INSVAL_OK        = 'FÅgt Zellen vom Klemmbrett ein und verlÑût den Dialog';
	
	BUBBLE_PRINT_FILE       = 'Der Dateiname des auszudruckenden Dokuments';
	BUBBLE_PRINT_SHEET      = 'Wenn dieses KÑstchen NICHT angekreuzt ist, wird der Benutzer zum Einlegen neuer Seiten aufgefordert';
	BUBBLE_PRINT_FEED       = 'Ist dieses KÑstchen angekreuzt, wird bei Druckern und Metafiles nach dem Ausdruck ein Seitenvorschub durchgefÅhrt';
	BUBBLE_PRINT_COPIES     = 'Bestimmt, wie oft das Dokument ausgedruckt wird';
	BUBBLE_PRINT_SCALE      = 'Stellt den Vergrîûerungs- bzw. Verkleinerungsfaktor ein';
	BUBBLE_PRINT_DRIVER     = 'Bestimmt einen Treiber fÅr das AusgabegerÑt';
	BUBBLE_PRINT_PRINT      = 'Druckt das Dokument aus';
	BUBBLE_PRINT_DEVICE     = 'Legt das AusgabegerÑt fest';
	BUBBLE_PRINT_BW         = 'Wenn diese Option eingeschaltet ist, werden alle Textfarben (auûer weiû) schwarz gedruckt und alle Hintergrundfarben (auûer schwarz) weiû';
	BUBBLE_PRINT_RANGE      = 'Wird aus "Seite einrichten" Åbernommen. Ist dort kein Bereich eingetragen, ist dieser Punkt identisch mit "Alles".';
	BUBBLE_PRINT_ALL        = 'Druckt das Blatt bis zur am weitesten rechts unten liegenden verwendeten Zellen aus';
	BUBBLE_PRINT_SELECTION  = 'Druckt den aktuell markierten Block aus';
	BUBBLE_PRINT_PAPER      = 'Stellt fÅr Drucker und Images die verwendete Papiergrîûe ein (ab NVDI3)';
	BUBBLE_PRINT_PAGEFROM   = 'Legt fest, ab welcher Seite der gesplitteten Tabelle gedruckt werden soll. Die Numerierung wird in "Seite einrichten" festgelegt.';
	BUBBLE_PRINT_PAGETO     = 'Bestimmt, bis zu welcher Seite der gesplitteten Tabelle gedruckt werden soll. Bei zu groûen Werten hîrt der Druck nach der letzten Seite auf. Ist hier nichts eingetragen, wird nur eine Seite gedruckt.';
	BUBBLE_PRINT_LAYOUT     = 'Ruft den "Seite einrichten"-Dialog auf';
	BUBBLE_PRINT_PREVIEW    = 'Ruft die Seitenansicht auf';
	BUBBLE_PRINT_OK         = 'öbernimmt die Einstellungen (ohne zu drucken)';
	BUBBLE_PRINT_INFO       = 'Zeigt Informationen Åber den GerÑtetreiber an';
	
	BUBBLE_SHFORM_SIZE      = 'Ermîglicht es, die Blattgrîûe nachtrÑglich zu Ñndern';
	BUBBLE_SHFORM_ROWS      = 'Legt die Zeilenanzahl fest (max. 16384)';
	BUBBLE_SHFORM_COLUMNS   = 'Bestimmt die Anzahl der Spalten (max. 702)';
	BUBBLE_SHFORM_FONTID    = 'Stellt den Zeichensatz fÅr die Zeilen- und Spaltenbeschriftungen ein';
	BUBBLE_SHFORM_FONTSIZE  = 'Bestimmt die Zeichenhîhe der Zeilen- und Spaltenbeschriftungen';
	BUBBLE_SHFORM_GRID      = 'Wenn dieses KÑstchen markiert ist, werden auch die einfachen Gitterlinien gezeichnet, sonst nicht';
	BUBBLE_SHFORM_AUTOCALC  = 'Bestimmt, ob das Blatt nach jeder Eingabe neu durchgerechnet werden soll';
	BUBBLE_SHFORM_FORM      = 'Wenn diese Checkbox angekreuzt ist, ist das Blatt eine sog. Vorlage, d.h. es kann nicht mehr versehentlich unter seinem Namen gespeichert werden, sondern'
	                           +' man wird bei jedem Speichern aufgefordert, einen neuen Namen auszuwÑhlen';
	BUBBLE_SHFORM_HRULER    = 'Zeigt unter der Funktionsleiste ein horizontales Millimeter-Lineal an';
	BUBBLE_SHFORM_VRULER    = 'Zeigt links am Fensterrand ein vertikales Millimeter-Lineal an';
	BUBBLE_SHFORM_RMOUSE    = 'Bestimmt, ob im Lineal die Mausposition angezeigt wird';
	BUBBLE_SHFORM_RLAYOUT   = 'Legt fest, ob das Lineal die SeitenumbrÅche des Ausdrucks beachtet';
	BUBBLE_SHFORM_OBJECTS   = 'Gibt an, ob eingebettete Objekte angezeigt werden sollen. Dies kann aus PerformancegrÅnden ausgeschaltet werden';
	BUBBLE_SHFORM_PROTECT   = 'Legt fest, ob die Zellschutzmarkierungen angezeigt werden';
	BUBBLE_SHFORM_BREAK     = 'Legt fest, ob bei manuellen (harten) SeitenumbrÅchen Markierungen angezeigt werden';
	BUBBLE_SHFORM_CURRENT   = 'TrÑgt in den Eingabefeldern die aktuelle Grîûe des Blatts ein';
	BUBBLE_SHFORM_MINIMAL   = 'Berechnet eine minimale Blattgrîûe (bis zur am weitesten rechts unten liegenden verwendeten Zelle)';
	
	BUBBLE_PAGE_NEW         = 'Die neue Seitennummer';
	BUBBLE_PAGE_MAX         = 'So viele Seiten sind insgesamt vorhanden';
	BUBBLE_PAGE_OK          = 'Zeigt die Seite mit der angegebenen Nummer an';
	
	BUBBLE_PREVIEW_PAGE     = 'Zeigt die aktuelle Seite an bzw. ruft (nach Anklicken) einen Dialog zur Eingabe der gewÅnschten Seitennummer auf';
	BUBBLE_PREVIEW_MARGINS  = 'Bestimmt, ob Markierungen fÅr die in "Seite einrichten" festgelegten RÑnder angezeigt werden';
	BUBBLE_PREVIEW_DEC      = 'Vermindert die Seitennummer um eins';
	BUBBLE_PREVIEW_INC      = 'Erhîht die Seitennummer um eins';
	BUBBLE_PREVIEW_PAPER    = 'Ruft den "Papierformat"-Dialog auf. Dies ist nur mîglich, falls der WDIALOG-Druckdialog installiert ist.';
	BUBBLE_PREVIEW_PRINT    = 'Ruft den "Drucken"-Dialog auf';
	BUBBLE_PREVIEW_LAYOUT   = 'Ruft den "Seite einrichten"-Dialog auf';
	BUBBLE_PREVIEW_SCALE    = 'Skaliert das Rechenblatt so, daû es mîglichst gut auf die eingestellte Seitengrîûe paût.';
	BUBBLE_PREVIEW_100      = 'Stellt die Vergrîûerung/Verkleinerung auf 100% zurÅck.';
	BUBBLE_PREVIEW_OK       = 'VerlÑût die Seitenansicht';

	BUBBLE_INFO_FILE        = 'Zeigt den kompletten Dateinamen des Blattes an';
	BUBBLE_INFO_AUTHOR      = 'Hier kann man eintragen, wer dieses Blatt erstellt hat. In "Seite einrichten" kann man darauf in den Kopf- und Fuûzeilen mit #a zugreifen.';
	BUBBLE_INFO_INDEX       = 'Hier kînnen - durch Komma getrennte - Stichworte eingetragen werden, nach denen man in STELLA suchen kann';
	BUBBLE_INFO_REM         = 'beliebige Anmerkungen zum Blatt';
	BUBBLE_INFO_CREATED     = 'Zeigt an, wann das Blatt erzeugt wurde';
	BUBBLE_INFO_LATEST      = 'Zeigt an, wann das Blatt zuletzt geladen wurde';
	BUBBLE_INFO_USED        = 'Zeigt an, wie oft das Blatt geîffnet wurde';
	BUBBLE_INFO_PRINTED     = 'Zeigt an, wie oft das Blatt ausgedruckt wurde. Dieser Wert ist nur korrekt, wenn das Blatt nach jedem Ausdruck gespeichert wird.';
	BUBBLE_INFO_VERSION     = 'Zeigt an, mit welcher Texel-Version die Datei gespeichert wurde';
	BUBBLE_INFO_ENCRYPT     = 'Schaltet die automatische DateiverschlÅsselung ein. Dadurch kann man den Klartext-Dateiinhalt nicht mehr mit einem Diskmonitor ausspÑhen.';
	BUBBLE_INFO_PASSWORD    = 'Ruft einen Dialog auf, mit dem die Datei paûwortgeschÅtzt werden kann';
	
	BUBBLE_FIND_SEARCHFOR   = 'Der Suchbegriff. Wildcards sind z.Z. noch nicht erlaubt';
	BUBBLE_FIND_ROWS        = 'Zeilenweise Suche';
	BUBBLE_FIND_COLUMNS     = 'Spaltenweise Suche';
	BUBBLE_FIND_CASE        = 'Wenn dieses KÑstchen markiert ist, wird zwischen Groû- und Kleinschreibung unterschieden.';
	BUBBLE_FIND_COMPLETE    = 'Wenn dieses KÑstchen markiert ist, muû der Textinhalt komplett mit dem Suchbegriff Åbereinstimmen.';
	BUBBLE_FIND_FORMULA     = 'Bestimmt, ob in Formelzellen gesucht wird';
	BUBBLE_FIND_VALUE       = 'Bestimmt, ob in Konstantenzellen gesucht wird';
	BUBBLE_FIND_TEXT        = 'Bestimmt, ob in normalen Textzellen gesucht wird';
	BUBBLE_FIND_EDIT        = 'Es wird so nach den Zeichenketten gesucht, wie sie in der Eingabezeile eingetragen werden.';
	BUBBLE_FIND_DISPLAY     = 'Es wird so nach den Zeichenketten gesucht, wie sie in den Zellen angezeigt werden.';
	BUBBLE_FIND_TOEND       = 'Sucht vom Cursor in Richtung Blattende';
	BUBBLE_FIND_TOBEGIN     = 'Sucht vom Cursor in Richtung Blattanfang';
	BUBBLE_FIND_FIND        = 'Springt zur nÑchsten Zelle, die die Suchkriterien erfÅllt';
	BUBBLE_FIND_OK          = 'Springt zur nÑchsten gesuchten Zelle und verlÑût den Dialog';
	
	BUBBLE_REPL_SEARCHFOR   = 'Der Suchbegriff. Wildcards sind z.Z. noch nicht erlaubt';
	BUBBLE_REPL_REPLWITH    = 'Durch diese Zeichen wird der Suchbegriff in den gefundenen Zellen ersetzt';
	BUBBLE_REPL_ROWS        = 'Zeilenweises Ersetzen';
	BUBBLE_REPL_COLUMNS     = 'Spaltenweises Ersetzen';
	BUBBLE_REPL_CASE        = 'Wenn dieses KÑstchen markiert ist, wird zwischen Groû- und Kleinschreibung unterschieden.';
	BUBBLE_REPL_COMPLETE    = 'Wenn dieses KÑstchen markiert ist, muû der Textinhalt komplett mit dem Suchbegriff Åbereinstimmen.';
	BUBBLE_REPL_FORMULA     = 'Bestimmt, ob in Formelzellen ersetzt wird';
	BUBBLE_REPL_VALUE       = 'Bestimmt, ob in Konstantenzellen ersetzt wird';
	BUBBLE_REPL_TEXT        = 'Bestimmt, ob in normalen Textzellen ersetzt wird';
	BUBBLE_REPL_TOEND       = 'Ersetzt vom Cursor in Richtung Blattende';
	BUBBLE_REPL_TOBEGIN     = 'Ersetzt vom Cursor in Richtung Blattanfang';
	BUBBLE_REPL_ALL         = 'Ersetzt den Suchbegriff vom Cursor an in Suchrichtung in allen Zellen';
	BUBBLE_REPL_REPLACE     = 'Ersetzt den Suchbegriff in der nÑchsten passenden Zelle';
	BUBBLE_REPL_OK          = 'Ersetzt den Suchbegriff in der nÑchsten passenden Zelle und verlÑût den Dialog';
	
	BUBBLE_CONST_CHGNAME    = 'Wenn diese Checkbox angekreuzt ist, werden die Konstantennamen im Blatt beim éndern ebenfalls geÑndert';
	BUBBLE_CONST_LIST       = 'Zeigt alle fÅr dieses Blatt definierten Konstanten an';
	BUBBLE_CONST_NAME       = 'Der Konstantenname muû mit einem Buchstaben oder dem Unterstrich beginnen';
	BUBBLE_CONST_VALUE      = 'Der Wert der Konstanten (ohne Einheit o.Ñ.)';
	BUBBLE_CONST_DESCR      = 'Ein beliebiger Kommentar zur Konstanten (sollte z.B. die Einheit enthalten)';
	BUBBLE_CONST_NEW        = 'Legt eine neue Konstante mit den eingetragenen Werten an';
	BUBBLE_CONST_CHANGE     = 'éndert die markierte Konstante auf die eingetragenen Werte';
	BUBBLE_CONST_DELETE     = 'Lîscht die markierte Konstante (geht nur, wenn diese benutzerdefiniert ist)';
	
	BUBBLE_SORT_SORT1       = 'Legt die Zeile/Spalte fest, nach der zuerst sortiert wird';
	BUBBLE_SORT_1UP         = 'Sortiert den Block nach Kriterium 1 aufsteigend';
	BUBBLE_SORT_1DOWN       = 'Sortiert den Block nach Kriterium 1 absteigend';
	BUBBLE_SORT_SORT2       = 'Legt die Zeile/Spalte fest, nach der als zweites sortiert wird';
	BUBBLE_SORT_2UP         = 'Sortiert den Block nach Kriterium 2 aufsteigend';
	BUBBLE_SORT_2DOWN       = 'Sortiert den Block nach Kriterium 2 absteigend';
	BUBBLE_SORT_SORT3       = 'Legt die Zeile/Spalte fest, nach der zum Schluû sortiert wird';
	BUBBLE_SORT_3UP         = 'Sortiert den Block nach Kriterium 3 aufsteigend';
	BUBBLE_SORT_3DOWN       = 'Sortiert den Block nach Kriterium 3 absteigend';
	BUBBLE_SORT_COLUMNS     = 'Sortiert wird in den Spalten, die daher auch als Kriterium ausgewÑhlt werden kînnen';
	BUBBLE_SORT_ROWS        = 'Sortiert wird in den Zeilen, die daher auch als Kriterium ausgewÑhlt werden kînnen';
	BUBBLE_SORT_NUMINS      = 'Zahlen werden so zwischen Texten einsortiert, wie es die ASCII-Codierung vorsieht';
	BUBBLE_SORT_NUMPRE      = 'Zahlen werden vor sonstigen Texten einsortiert';
	BUBBLE_SORT_NUMPOST     = 'Zahlen werden nach sonstigen Texten einsortiert';
	BUBBLE_SORT_CASE        = 'Wenn diese Option ausgeschaltet ist, werden Groû- und Kleinbuchstaben beim Sortieren gleichwertig behandelt';
	BUBBLE_SORT_BEGINNING   = 'Komplett leere Zellen werden vor allen anderen Zellen einsortiert';
	BUBBLE_SORT_END         = 'Komplett leere Zellen werden nach allen anderen Zellen einsortiert (das ist meistens am sinnvollsten)';
	BUBBLE_SORT_UMLAUTE     = 'Legt fest, ob Umlaut lexikalisch sortiert werden sollen, d.h. aus Ñ wird ae etc.';
	BUBBLE_SORT_ABS         = 'Legt fest, ob Zahlen ohne Beachtung des Vorzeichens sortiert werden sollen';
	BUBBLE_SORT_ATTR        = 'Legt fest, ob die Zellattribute (Hintergrundfarbe etc.) mitsortiert werden';
	BUBBLE_SORT_SORT        = 'Sortiert den markierten Bereich, ohne den Dialog zu verlassen';
	BUBBLE_SORT_OK          = 'Sortiert den markierten Bereich und verlÑût anschlieûend den Dialog';
	
	BUBBLE_PRNINFO_DEVICE   = 'Das AusgabegerÑt';
	BUBBLE_PRNINFO_FILE     = 'Der Dateiname des Treibers aus ASSIGN.SYS';
	BUBBLE_PRNINFO_NUMBER   = 'Die GDOS-Nummer des Treibers aus ASSIGN.SYS';
	BUBBLE_PRNINFO_DESCR    = 'Zusatzinformationen zum GerÑtetreiber';
	BUBBLE_PRNINFO_IO       = 'Drucker sollten reine AusgabegerÑte sein';
	BUBBLE_PRNINFO_COLORS   = 'Anzahl der auf dem AusgabegerÑt darstellbaren Farben';
	BUBBLE_PRNINFO_MAXCOLOR = 'Anzahl der vordefinierten (=verfÅgbaren) Farben';
	BUBBLE_PRNINFO_FONTS    = 'Anzahl der auf dem AusgabegerÑt verfÅgbaren ZeichensÑtze';
	BUBBLE_PRNINFO_DPI      = 'Auflîsung des AusgabegerÑts (in Punkten pro Zoll)';
	BUBBLE_PRNINFO_PAPRSIZE = 'Blattgrîûe (entspricht z.B. DIN A4 etc.)';
	BUBBLE_PRNINFO_PRNTSIZE = 'Grîûe des Druckbereichs (=verfÅgbare Grîûe), hier sind hardwarebedingte RÑnder bereits abgezogen';
	BUBBLE_PRNINFO_BEZIER   = 'Gibt an, ob das AusgabegerÑt Bezierkurven zeichnen kann';
	
	BUBBLE_HELP_ITEM        = 'Das Stichwort, das der ST-Guide im Texel-Hypertext suchen soll';
	BUBBLE_HELP_SEARCH      = 'Sucht das Stichwort, ohne den Dialog zu verlassen';
	BUBBLE_HELP_OK          = 'Sucht das Stichwort und verlÑût anschlieûend den Dialog';
	
	BUBBLE_DIAGRAM_CHANGE   = 'In diesem Bereich wird die Gruppe der zu verÑndernden Werte ausgewÑhlt';
	BUBBLE_DIAGRAM_GRPTYPE  = 'Hier kann der Diagrammtyp verÑndert werden';
	BUBBLE_DIAGRAM_GRPAXIS  = 'Hier kînnen die Achsen beschriftet werden';
	BUBBLE_DIAGRAM_GRPDATA  = 'Hier kînnen die Datenreihen bestimmt werden';
	BUBBLE_DIAGRAM_GRPLEG   = 'Hier kann die Diagrammlegende bearbeitet werden';
	BUBBLE_DIAGRAM_GRPOBJ   = 'Hier kînnen Objektgrîûe und -datei festgelegt werden';
	BUBBLE_DIAGRAM_RTYPE    = 'Hier kann der Diagrammtyp verÑndert werden';
	BUBBLE_DIAGRAM_RAXIS    = 'Hier kînnen die Achsen beschriftet werden';
	BUBBLE_DIAGRAM_RDATA    = 'Hier kînnen die Datenreihen bestimmt werden';
	BUBBLE_DIAGRAM_RLEG     = 'Hier kann die Diagrammlegende bearbeitet werden';
	BUBBLE_DIAGRAM_ROBJ     = 'Hier kînnen Objektgrîûe und -datei festgelegt werden';
	BUBBLE_DIAGRAM_LINE     = 'Erzeugt Liniendiagramme';
	BUBBLE_DIAGRAM_BLOCK    = 'Erzeugt Balkendiagramme';
	BUBBLE_DIAGRAM_CIRCLE   = 'Erzeugt Kreisdiagramme';
	BUBBLE_DIAGRAM_COLOR    = 'Wenn dieser Button markiert ist, verwenden die Diagramme Farben, sonst s/w-Muster';
	BUBBLE_DIAGRAM_VALUE    = 'Wenn dieser Button markiert ist, wird in jedes Diagrammelement der jeweilige Absolutwert ausgegeben';
	BUBBLE_DIAGRAM_XLINEAR  = 'Erzeugt Liniendiagramme mit festem X-Abstand von 1';
	BUBBLE_DIAGRAM_X1DATA   = 'Die X-Positionen werden aus der ersten Datenreihe ausgelesen. Alle weiteren Reihen werden als Y-Positionen an diesen Stellen interpretiert.';
	BUBBLE_DIAGRAM_XYALT    = 'Die Datenreihen enthalten abwechselnd die X- und Y-Positionen (1. Reihe X, 2. Reihe Y, ...)';
	BUBBLE_DIAGRAM_LLINES   = 'Liniendiagramme bestehen nur aus Linien zwischen den Punkten';
	BUBBLE_DIAGRAM_LPOINTS  = 'Liniendiagramme bestehen nur aus Markierungen an den Punkten';
	BUBBLE_DIAGRAM_LBOTH    = 'Liniendiagramme bestehen aus Markierungen an den Punkten und Linien zwischen diesen';
	BUBBLE_DIAGRAM_STACK    = 'Die Balken einer Reihe werden Åbereinander gezeichnet';
	BUBBLE_DIAGRAM_BEHIND   = 'Die Balken einer Reihe werden hintereinander gezeichnet';
	BUBBLE_DIAGRAM_SIDE     = 'Die Balken einer Reihe werden nebeneinander gezeichnet';
	BUBBLE_DIAGRAM_LSTYLE   = 'Hiermit wird der Linienstil festgelegt';
	BUBBLE_DIAGRAM_PSTYLE   = 'Hiermit wird der Punktstil festgelegt';
	BUBBLE_DIAGRAM_TITLE    = 'Legt den Diagrammtitel fest';
	BUBBLE_DIAGRAM_BORDER   = 'Bestimmt, ob das Diagramm mit einer schwarzen Linie umrahmt wird';
	BUBBLE_DIAGRAM_NAMES    = 'Hier wird festgelegt, ob der Datenbereich Beschriftungen enthÑlt';
	BUBBLE_DIAGRAM_LCOUNT   = 'Legt fest, ob neben dem Diagramm eine Legende angezeigt wird';
	BUBBLE_DIAGRAM_NROW     = 'Legt fest, ob in der ersten Zeile des Datenbereichs Beschriftungen stehen';
	BUBBLE_DIAGRAM_NCOL     = 'Legt fest, ob in der ersten Spalte des Datenbereichs Beschriftungen stehen';
	BUBBLE_DIAGRAM_FONTID   = 'Legt die Schriftart fÅr das Diagramm fest';
	BUBBLE_DIAGRAM_FONTSIZE = 'Legt die Schriftgrîûe fÅr den Diagrammtitel fest. Die Grîûe der anderen Beschriftungen wird aus dieser Angabe errechnet.';
	BUBBLE_DIAGRAM_DATA     = 'Legt die Richtung der Datenreihen fest';
	BUBBLE_DIAGRAM_DROWS    = 'Die Datenreihen befinden sich in den Zeilen';
	BUBBLE_DIAGRAM_DCOLUMNS = 'Die Datenreihen befinden sich in den Spalten';
	BUBBLE_DIAGRAM_RTICKS   = 'Legt die Unterteilung fÅr die linke Achse fest';
	BUBBLE_DIAGRAM_TICKS    = 'Bestimmt, ob die linke Achse unterteilt wird';
	BUBBLE_DIAGRAM_NUMTICKS = 'Gibt an, wie hÑufig die linke Achse unterteilt wird';
	BUBBLE_DIAGRAM_AXISLEFT = 'Legt die Einstellungen fÅr die linke Achse fest';
	BUBBLE_DIAGRAM_ALNAME   = 'Legt die Beschriftung fÅr die linke Achse fest';
	BUBBLE_DIAGRAM_ALSUBT   = 'Bestimmt, ob die linke Achse feinunterteilt wird';
	BUBBLE_DIAGRAM_ALSUBNUM = 'Legt die Anzahl der Feinunterteilungen fÅr die linke Achse fest';
	BUBBLE_DIAGRAM_ALMIN    = 'Legt den Minimalwert der linken Achse fest';
	BUBBLE_DIAGRAM_ALMAX    = 'Legt den Maximalwert der linken Achse fest';
	BUBBLE_DIAGRAM_AXISBOTM = 'Legt die Einstellungen fÅr die untere Achse fest';
	BUBBLE_DIAGRAM_ABNAME   = 'Legt die Beschriftung fÅr die untere Achse fest';
	BUBBLE_DIAGRAM_ABSUBT   = 'Bestimmt, ob die untere Achse feinunterteilt wird';
	BUBBLE_DIAGRAM_ABSUBNUM = 'Legt die Anzahl der Feinunterteilungen fÅr die untere Achse fest';
	BUBBLE_DIAGRAM_ABMIN    = 'Legt den Minimalwert der unteren Achse fest';
	BUBBLE_DIAGRAM_ABMAX    = 'Legt den Maximalwert der unteren Achse fest';
	BUBBLE_DIAGRAM_SIZE     = 'Hier werden die Ausmaûe des Objekts festgelegt';
	BUBBLE_DIAGRAM_WIDTH    = 'Bestimmt die Breite des Objekts mit einer Genauigkeit von 1/100mm';
	BUBBLE_DIAGRAM_HEIGHT   = 'Bestimmt die Hîhe des Objekts mit einer Genauigkeit von 1/100mm';
	BUBBLE_DIAGRAM_FILE     = 'Zeigt eine Dateiauswahlbox an, mit der der Diagrammdateiname festgelegt werden kann';
	BUBBLE_DIAGRAM_TEMPFILE = 'Lîscht den ausgewÑhlten Dateinamen. Texel verwendet dann zum Erzeugen eines Diagramms eine temporÑre Datei.';
	BUBBLE_DIAGRAM_FILENAME = 'Zeigt die ausgewÑhlte Diagrammdatei an, falls eine solche festgelegt wurde';
	BUBBLE_DIAGRAM_CREATAD  = 'Speichert eine TAD-Datei, die manuell in ArtWorx geladen werden kann, um unabhÑngig von Texel ein Diagramm zu erzeugen';
	BUBBLE_DIAGRAM_INSERT   = 'Erzeugt das Diagramm und fÅgt es in das Rechenblatt ein';
	BUBBLE_DIAGRAM_OK       = 'Erzeugt das Diagramm, fÅgt es in das Rechenblatt ein und schlieût den Dialog';
	
	BUBBLE_OBJSIZE_SIZE     = 'Hier kînnen die Ausmaûe des Objekts festgelegt werden';
	BUBBLE_OBJSIZE_FLAGS    = 'Allgemeine Optionen zur GrîûenverÑnderung des Objekts';
	BUBBLE_OBJSIZE_X        = 'Bestimmt die X-Position des Objekts mit einer Genauigkeit von 1/100mm';
	BUBBLE_OBJSIZE_Y        = 'Bestimmt die Y-Position des Objekts mit einer Genauigkeit von 1/100mm';
	BUBBLE_OBJSIZE_WIDTH    = 'Bestimmt die Breite des Objekts mit einer Genauigkeit von 1/100mm';
	BUBBLE_OBJSIZE_HEIGHT   = 'Bestimmt die Hîhe des Objekts mit einer Genauigkeit von 1/100mm';
	BUBBLE_OBJSIZE_SPERR    = 'Hiermit kann das Objekt gegen Grîûen- und PositionsÑnderungen gesperrt werden';
	BUBBLE_OBJSIZE_PROP     = 'Bestimmt, ob die GrîûenÑnderung des Objekts per Maus nur proportional mîglich ist';
	
	BUBBLE_URL_EDIT         = 'Hier wird die URL (also die Web-Adresse) einer Texel-Datei eingetragen, z.B. http://www.uni-karlsruhe.de/~Thomas.Much/Texel/balmer.txl';
	BUBBLE_URL_OPEN         = 'ôffnet die angegebene URL als neues Texel-Rechenblatt, falls die URL auf eine gÅltige Texel-Datei verweist';
	BUBBLE_URL_OK           = 'ôffnet die angegebene URL als neues Texel-Rechenblatt, falls die URL auf eine gÅltige Texel-Datei verweist. Anschlieûend wird der Dialog geschlossen.';
	
	BUBBLE_PASS_FILE        = 'Diese Datei ist paûwortgeschÅtzt';
	BUBBLE_PASS_EDIT        = 'Hier muû das benutzergewÑhlte Paûwort eingetragen werden. Groû-/Kleinschreibung wird berÅcksichtigt!';
	BUBBLE_PASS_CANCEL      = 'Bricht den Ladevorgang ab';
	BUBBLE_PASS_OK          = 'BestÑtigt das Paûwort. Wenn dieses korrekt eingegeben wurde, wird das Blatt geladen.';
	
	BUBBLE_CHGPASS_OLD      = 'Hier muû das alte Paûwort korrekt eingegeben werden, wenn ein solches bereits festgelegt wurde und man dieses Ñndern mîchte. Groû-/Kleinschreibung wird berÅcksichtigt!';
	BUBBLE_CHGPASS_NEW      = 'Hier wird das neue Paûwort eingetragen. Groû-/Kleinschreibung wird berÅcksichtigt!';
	BUBBLE_CHGPASS_OK       = 'éndert das Paûwort bzw. Åbernimmt das neue Paûwort';
	
	BUBBLE_FILL_ROWS        = 'Die Reihe wird in einer Zeile berechnet';
	BUBBLE_FILL_COLUMNS     = 'Die Reihe wird in einer Spalte berechnet';
	BUBBLE_FILL_ARITHM      = 'Berechnet eine arithmetische Reihe (lineare Schritte)';
	BUBBLE_FILL_GEOM        = 'Berechnet eine geometrische Reihe (exponentielle Schritte)';
	BUBBLE_FILL_DATE        = 'Berechnet fortlaufende Datumsangaben';
	BUBBLE_FILL_TREND       = 'Nimmt automatisch eine arithmetische oder geometrische Trendanalyse vor';
	BUBBLE_FILL_COPY        = 'Kopiert den ersten Wert des Blocks, ohne eine Berechnung vorzunehmen';
	BUBBLE_FILL_RDAY        = 'Berechnet die Folge mit Typ "Datum" in TagessprÅngen';
	BUBBLE_FILL_RWEEKDAY    = 'Berechnet die Folge mit Typ "Datum" in WochensprÅngen';
	BUBBLE_FILL_RMONTH      = 'Berechnet die Folge mit Typ "Datum" in MonatssprÅngen';
	BUBBLE_FILL_RYEAR       = 'Berechnet die Folge mit Typ "Datum" in JahressprÅngen';
	BUBBLE_FILL_STEPVAL     = 'Legt die lineare (arithmetische Reihe) oder exponentielle (geometrische Reihe) Schrittweite fest';
	BUBBLE_FILL_ENDVAL      = 'Wenn die Reihe diesen Wert erreicht, wird die weitere Berechnung abgebrochen';
	BUBBLE_FILL_CALC        = 'Berechnet die Reihe';
	BUBBLE_FILL_OK          = 'Berechnet die Reihe und schlieût den Dialog';
	
	BUBBLE_LINK_LIST        = 'In dieser Liste sind alle eingebetteten Objekte mit ihrem Dateityp und -namen aufgefÅhrt';
	BUBBLE_LINK_CHANGE      = 'Zeigt eine Dateiauswahlbox an, mit der die mit dem Objekt verknÅpfte Datei geÑndert werden kann';
	BUBBLE_LINK_ACTIVATE    = 'Aktiviert (markiert) das gewÅnschte Objekt, schlieût den Dialog und springt zu dem Objekt';
	BUBBLE_LINK_EDIT        = 'Ruft einen passenden OLGA-Server auf, mit dem das Objekt bearbeitet werden kann';
	
	BUBBLE_FINDVAL_CTARGET  = 'Die Zielzelle muû eine Formel enthalten, die die verÑnderbare Zelle als Variable enthÑlt. Texel kann dann versuchen, in der verÑnderbaren Zelle einen geeigneten Wert einzutragen,'
	                          +' damit die Formel der Zielzelle den Zielwert ergibt.';
	BUBBLE_FINDVAL_CVALUE   = 'In die verÑnderbare Zelle werden von Texel so lange geeignete Zahlen eingetragen, bis die Formel in der Zielzelle den Zielwert ergibt';
	BUBBLE_FINDVAL_TVALUE   = 'Bestimmt den Zielwert, den die Formel in der Zielzelle ergeben soll';
	BUBBLE_FINDVAL_ITERAT   = 'Dieser Wert gibt an, nach wieviel Versuchen die Suche angebrochen wird, falls keine Lîsung gefunden werden kann';
	BUBBLE_FINDVAL_STATUS   = 'Die Statuszeile teilt mit, ob der Zielwert gefunden werden konnte oder ob ein Fehler aufgetreten ist';
	BUBBLE_FINDVAL_FIND     = 'Sucht den Zielwert';
	BUBBLE_FINDVAL_OK       = 'Sucht den Zielwert und schlieût den Dialog';
	
{ texel.msg }

	BUTTON_OK               = '  &OK  ';
	BUTTON_CANCEL           = '&Abbruch';
	BUTTON_OKCANCEL         = '  &OK  |&Abbruch';
	BUTTON_OKMINIMALCANCEL  = '  &OK  |&Minimal|&Abbruch';
	BUTTON_GOCANCEL         = ' &Weiter |&Abbruch';
	BUTTON_YESNO            = '  &Ja  | &Nein ';
	BUTTON_YESNOCANCEL      = '  &Ja  | &Nein |&Abbruch';
	BUTTON_OBJCELLCANCEL    = '&Objekt|&Zellen|&Abbruch';
	BUTTON_FORMDOC          = '&Vorlage|&Dokument';
	BUTTON_SAVECANCEL       = '&Speichern|&Abbruch';

	MESSAGE_GENERAL_RANGE   = 'Bitte geben Sie einen gÅltigen Bereich ein.';
	MESSAGE_GENERAL_MEMORY  = 'TEXEL:|Zu wenig freier Speicher!';
	MESSAGE_GENERAL_OLGA    = 'Kein OLGA-Manager installiert.';

	MESSAGE_DEMO_DEMO       = 'Dies ist die Demoversion von Texel. Jegliches Speichern ist nicht mîglich.';
	MESSAGE_DEMO_UNREG      = 'Diese Texel-Version ist nicht registriert, das Speichern ist daher nicht mîglich.';
	
	MESSAGE_STARTUP_UNREG   = 'TEXEL:|Texel wurde nicht korrekt installiert/registriert.';
	MESSAGE_STARTUP_SCREEN  = 'Texel benîtigt eine Auflîsung von mind. 80x25 Zeichen. Bitte wÑhlen sie eine hîhere Auflîsung oder einen kleineren Systemfont.';
	MESSAGE_STARTUP_BETA    = 'TEXEL:|Diese Betaversion ist zu alt.';
	MESSAGE_STARTUP_FOUND1  = 'TEXEL:|Datei "';
	MESSAGE_STARTUP_FOUND2  = '" nicht gefunden.';
	MESSAGE_STARTUP_LOAD1   = 'TEXEL:|Datei "';
	MESSAGE_STARTUP_LOAD2   = '" konnte nicht geladen werden.';
	MESSAGE_STARTUP_FRM1    = 'TEXEL:|Datei "';
	MESSAGE_STARTUP_FRM2    = '" fehlerhaft';

	MESSAGE_WINDOW_MEMORY   = 'Texel:|Nicht genÅgend Speicher fÅr neues Fenster frei!';
	MESSAGE_WINDOW_WINDOWS  = 'Kein Fenster mehr verfÅgbar.';
	MESSAGE_WINDOW_DDMOVE   = 'Der Drag&Drop-Block paût nicht ganz auf das Blatt, es werden nicht alle Zellen verschoben!';
	MESSAGE_WINDOW_DDCOPY   = 'Der Drag&Drop-Block paût nicht ganz auf das Blatt, es werden nicht alle Zellen kopiert!';
	MESSAGE_WINDOW_CCPCOPY  = 'Der Cut/Copy/Paste-Block paût nicht ganz auf das Blatt, es werden nicht alle Zellen kopiert!';
	MESSAGE_WINDOW_CLOSE1   = 'Blatt "';
	MESSAGE_WINDOW_CLOSE2   = '" wurde verÑndert. Wollen Sie die énderungen speichern?';
	MESSAGE_WINDOW_VAR1     = 'Die Variable ';
	MESSAGE_WINDOW_VAR2     = ' ist bereits in Zelle ';
	MESSAGE_WINDOW_VAR3     = ' definiert.';
	MESSAGE_WINDOW_CUT      = 'Objekt oder Zellen ausschneiden?';
	MESSAGE_WINDOW_COPY     = 'Objekt oder Zellen kopieren?';
	MESSAGE_WINDOW_DELETE   = 'Objekt oder Zellen lîschen?';
	MESSAGE_WINDOW_BLOCK1   = 'Beim Verschieben gehen Formel-, Text- oder Zahlendaten verloren.';
	MESSAGE_WINDOW_BLOCK2   = 'Im Zielbereich werden Daten Åberschrieben!';
	MESSAGE_WINDOW_EMBED1   = 'Beim Einbetten von "';
	MESSAGE_WINDOW_EMBED2   = '" ist ein Fehler aufgetreten.';
	MESSAGE_WINDOW_EMAIL    = 'Beim Versenden der EMail an den ASH-Texel-Support ist ein Fehler aufgetreten.';
	MESSAGE_WINDOW_SIZE     = 'Bei der Verkleinerung des Blattes gehen Formel-, Text- oder Zahlendaten verloren.';
	MESSAGE_WINDOW_SIZEERR  = 'Blattgrîûe kann nicht verÑndert werden (Speichermangel).';
	MESSAGE_WINDOW_ABANDON1 = 'énderungen in Datei "';
	MESSAGE_WINDOW_ABANDON2 = '" verwerfen?';

	MESSAGE_NUMFORM_EMPTY   = 'Bitte geben Sie ein Format ein.';
	MESSAGE_NUMFORM_PARTS   = 'Ein Zahlenformat besteht aus max. 3 Teilen, darf also max. 2 Semikolons enthalten.';
	MESSAGE_NUMFORM_BRACES  = 'Die Formatangabe enthÑlt falsche Klammerungen.';
	MESSAGE_NUMFORM_DEL1    = 'Zahlenformat "';
	MESSAGE_NUMFORM_DEL2    = '" lîschen?';

	MESSAGE_CLIP_PASTE      = 'Im Klemmbrett befinden sich keine passenden Daten, die eingefÅgt werden kînnen.';
	MESSAGE_CLIP_IMPORT     = 'Keine passende Datei im Klemmbrett vorhanden.';
	
	MESSAGE_EMBED_ARTWORX   = 'ArtWorx konnte nicht aufgerufen werden.';
	MESSAGE_EMBED_OLGA1     = 'Der OLGA-"';
	MESSAGE_EMBED_OLGA2     = '"-Server konnte nicht aufgerufen werden.';
	MESSAGE_EMBED_DELETE    = 'Objekt wirklich lîschen?';
	MESSAGE_EMBED_EXIST1    = 'Die Datei "';
	MESSAGE_EMBED_EXIST2    = '" existiert bereits. öberschreiben?';
	
	MESSAGE_LAYOUT_RANGE    = 'Bitte geben Sie einen gÅltigen Druckbereich ein.';
	MESSAGE_LAYOUT_HEADFOOT = 'Sie haben eine Kopf- bzw. Fuûzeile definiert, ohne den entsprechenden Rand festzulegen.';
	
	MESSAGE_DIAGRAM_ROWS    = 'Zu wenig Zeilen markiert.';
	MESSAGE_DIAGRAM_COLUMNS = 'Zu wenig Spalten markiert.';
	MESSAGE_DIAGRAM_CELLS   = 'Zu wenig Zellen markiert.';
	MESSAGE_DIAGRAM_ROWEVEN = 'Bitte markieren Sie eine gerade Anzahl Datenzeilen.';
	MESSAGE_DIAGRAM_COLEVEN = 'Bitte markieren Sie eine gerade Anzahl Datenspalten.';

	MESSAGE_OPEN_MEMORY1    = 'Datei "';
	MESSAGE_OPEN_MEMORY2    = '" konnte nicht geladen werden (Speichermangel)';
	MESSAGE_OPEN_EXIST1     = 'Datei "';
	MESSAGE_OPEN_EXIST2     = '" nicht gefunden.';
	MESSAGE_OPEN_LOADED1    = 'Die Datei "';
	MESSAGE_OPEN_LOADED2    = '" befindet sich bereits im Speicher. Nochmal laden?';
	MESSAGE_OPEN_FORMAT1    = '"';
	MESSAGE_OPEN_FORMAT2    = '" ist keine Texel-Datei.';
	MESSAGE_OPEN_VERSION1   = '"';
	MESSAGE_OPEN_VERSION2   = '" (Dateiversion #';
	MESSAGE_OPEN_VERSION3   = ', gespeichert mit Texel ';
	MESSAGE_OPEN_VERSION4   = ') ist nicht zu dieser Texel-Version kompatibel.';
	MESSAGE_OPEN_CCP        = 'Cut/Copy/Paste-Blîcke kînnen nicht direkt geladen werden. Bitte verwenden Sie "Bearbeiten - EinfÅgen" (Control+V).';
	MESSAGE_OPEN_ALGO1      = '"';
	MESSAGE_OPEN_ALGO2      = '": Unbekanntes Texel-Packverfahren';
	MESSAGE_OPEN_PASSLEN    = 'Das Paûwort muû mind. 6 Zeichen lang sein.';
	MESSAGE_OPEN_PASSWRONG  = 'Falsches Paûwort!';
	MESSAGE_OPEN_ERROR1     = 'Datei "';
	MESSAGE_OPEN_ERROR2     = '" konnte nicht geladen werden.';
	
	MESSAGE_SAVE_FORMDOC    = 'Das Blatt ist eine Vorlage. Speichern als Vorlage oder als neues Dokument?';
	MESSAGE_SAVE_EMBEDDED   = 'Ein eingebettetes Objekt wurde in seinem ID4-Server noch nicht gespeichert. Trotz evtl. alter Objektdaten speichern?';
	MESSAGE_SAVE_MEMORY     = 'Das Blatt konnte nicht gespeichert werden (Speichermangel)';
	MESSAGE_SAVE_WPROT      = 'Das Blatt konnte nicht gespeichert werden (DatentrÑger schreibgeschÅtzt?)';
	MESSAGE_SAVE_DISKFULL   = 'Das Blatt konnte nicht gespeichert werden (DatentrÑger voll?)';

	MESSAGE_SAVEAS_EXIST1   = 'Die Datei "';
	MESSAGE_SAVEAS_EXIST2   = '" existiert bereits. öberschreiben?';
	MESSAGE_SAVEAS_NEW1     = 'Neuen Dateinamen "';
	MESSAGE_SAVEAS_NEW2     = '" Åbernehmen?';

	MESSAGE_IMPORT_LOAD1    = 'Datei "';
	MESSAGE_IMPORT_LOAD2    = '" konnte nicht geladen werden.';
	MESSAGE_IMPORT_DBSIZE   = 'Die Datenbank ist zu groû. Texel kann z.Z. maximal 16384 DatensÑtze importieren.';
	MESSAGE_IMPORT_MEMORY1  = 'Datei "';
	MESSAGE_IMPORT_MEMORY2  = '" konnte nicht geladen werden (Speichermangel)';
	MESSAGE_IMPORT_EXIST1   = 'Datei "';
	MESSAGE_IMPORT_EXIST2   = '" nicht gefunden.';
	MESSAGE_IMPORT_LOTUS1   = '"';
	MESSAGE_IMPORT_LOTUS2   = '" ist keine Lotus-1-2-3-Datei.';
	MESSAGE_IMPORT_WKS1     = '"';
	MESSAGE_IMPORT_WKS2     = '" ist keine WKS/WK1-Datei.';
	MESSAGE_IMPORT_WKPASS1  = '"';
	MESSAGE_IMPORT_WKPASS2  = '" ist verschlÅsselt und kann deshalb nicht importiert werden.';
	MESSAGE_IMPORT_WKEMPTY1 = '"';
	MESSAGE_IMPORT_WKEMPTY2 = '" enthÑlt keine Daten.';
	MESSAGE_IMPORT_EXCEL1   = '"';
	MESSAGE_IMPORT_EXCEL2   = '"|ist keine MS-Excel-2.0/3.0/4.0-Datei.';
	MESSAGE_IMPORT_XLS1     = '"';
	MESSAGE_IMPORT_XLS2     = '" ist kein XLS-Kalkulationsblatt.';
	MESSAGE_IMPORT_XLPASS1  = '"';
	MESSAGE_IMPORT_XLPASS2  = '" ist passwortgeschÅtzt und kann daher nicht geladen werden.';
	MESSAGE_IMPORT_XLDATE1  = 'Achtung:|"';
	MESSAGE_IMPORT_XLDATE2  = '" enthÑlt Datumsangaben im 1904-Format, das Texel nicht unterstÅtzt.';

	MESSAGE_EXPORT_EXIST1   = 'Die Datei "';
	MESSAGE_EXPORT_EXIST2   = '" existiert bereits. öberschreiben?';
	
	MESSAGE_PRINT_STOP      = 'Ausdruck abbrechen?';
	MESSAGE_PRINT_EMPTY     = 'Der Druckbereich enthÑlt keine Daten.';
	MESSAGE_PRINT_DEVICE1   = 'Konnte GerÑtetreiber ';
	MESSAGE_PRINT_DEVICE2   = ' nicht îffnen.';
	MESSAGE_PRINT_MARGINS   = 'Die RÑnder Åberschneiden sich oder ragen Åber den Blattrand hinaus.';
	MESSAGE_PRINT_NEWSHEET  = 'Bitte legen Sie eine neue Seite ein.';
	MESSAGE_PRINT_PRINTER   = 'Es ist kein Drucker definiert.';
	MESSAGE_PRINT_DRIVER    = 'Es ist kein Druckertreiber installiert.';

	MESSAGE_INFO_PASSWRONG  = 'Altes Paûwort falsch!';
	MESSAGE_INFO_PASSLEN    = 'Das neue Paûwort muû entweder leer oder aber mind. 6 Zeichen lang sein.';
	
	MESSAGE_CONST_EMPTY     = 'Bitte geben Sie einen Konstantennamen ein.';
	MESSAGE_CONST_NAME      = 'Bitte geben Sie einen korrekten Namen ein.';
	MESSAGE_CONST_USED1     = 'Der Konstantenname "';
	MESSAGE_CONST_USED2     = '" ist bereits vergeben.';
	MESSAGE_CONST_VALEMPTY  = 'Bitte geben Sie den Wert der Konstanten ein.';
	MESSAGE_CONST_VALUE     = 'Bitte geben Sie einen korrekten Wert ein.';
	MESSAGE_CONST_DELETE1   = 'Konstante "';
	MESSAGE_CONST_DELETE2   = '" lîschen?';
	
	MESSAGE_FINDVAL_CELLREF = 'Zielzelle und verÑnderbare Zelle mÅssen eine Zellreferenz sein.';
	MESSAGE_FINDVAL_FORMULA = 'Die Zielzelle muû eine Formel enthalten.';
	MESSAGE_FINDVAL_NUMBER  = 'Die verÑnderbare Zelle muû eine Zahl enthalten oder leer sein.';
	MESSAGE_FINDVAL_ERROR   = 'Der Zielwert konnte nicht korrekt bestimmt werden.';
	

{ fsel titles }

	FSELTITLE_DIAGRAM       = 'DIAGRAMM-DOKUMENT FESTLEGEN';
	FSELTITLE_TAD           = 'TAD-DATEI FESTLEGEN';
	FSELTITLE_TADSAVEAS     = 'TAD-DATEI SPEICHERN ALS...';
	FSELTITLE_OBJECTSAVEAS  = 'OBJEKT SICHERN ALS...';
	FSELTITLE_OBJECTINSERT  = 'OBJEKT EINFöGEN';
	FSELTITLE_CHANGELINK    = 'VERKNöPFUNG éNDERN...';
	FSELTITLE_LOADTEXT      = 'ASCII-TEXT LADEN';
	FSELTITLE_LOADIMG       = 'IMG-GRAFIK LADEN';
	FSELTITLE_OPEN          = 'TEXEL-BLATT LADEN';
	FSELTITLE_SAVEFORMASDOC = 'VORLAGE ALS DOKUMENT SPEICHERN';
	FSELTITLE_IMPORTLDW     = 'LDW-AUSSPULDATEI IMPORTIEREN';
	FSELTITLE_IMPORTDIF     = 'DIF-DATEI IMPORTIEREN';
	FSELTITLE_IMPORTCSV     = 'CSV-DATEI IMPORTIEREN';
	FSELTITLE_IMPORTASCII   = 'ASCII-DATEI IMPORTIEREN';
	FSELTITLE_IMPORTDBASE   = 'DBASE-DATEI IMPORTIEREN';
	FSELTITLE_IMPORTEXCEL   = 'EXCEL-DATEI IMPORTIEREN';
	FSELTITLE_IMPORT123     = '1-2-3-DATEI IMPORTIEREN';
	FSELTITLE_EXPORTFILE    = 'EXPORT-DATEI FESTLEGEN';
	FSELTITLE_PRINTMETA     = 'AUSDRUCK IN METAFILE...';
	FSELTITLE_PRINTIMG      = 'AUSDRUCK IN IMG-DATEI...';
	FSELTITLE_SAVEAS        = 'TEXEL-BLATT SICHERN ALS...';

{ window titles }

	TITLE_FONTSELECTOR      = 'Fontauswahl';
	TITLE_TEXTATTR          = 'Textattribute';
	TITLE_NUMFORMAT         = 'Zahlenformat';
	TITLE_ROWSIZE           = 'Zeilenhîhe';
	TITLE_COLSIZE           = 'Spaltenbreite';
	TITLE_COLNAME           = 'Spaltenname';
	TITLE_PATTERN           = 'Muster';
	TITLE_BORDERS           = 'Rahmen';
	TITLE_ABOUT             = 'öber Texel...';
	TITLE_LAYOUT            = 'Seite einrichten';
	TITLE_FUNCTION          = 'Funktion einfÅgen';
	TITLE_DIAGRAM           = 'Diagramm einfÅgen';
	TITLE_OBJSIZE           = 'Objektgrîûe';
	TITLE_OBJATTR           = 'Objektattribute';
	TITLE_IMGOBJ            = 'Grafikobjektattribute';
	TITLE_TXTOBJ            = 'Textobjektattribute';
	TITLE_INSOBJ            = 'Objekt einfÅgen';
	TITLE_URL               = 'URL îffnen';
	TITLE_OPEN              = 'Lade Datei';
	TITLE_IMPORTASCII       = 'Import';
	TITLE_IMPORTGDBC        = 'dBase-Import';
	TITLE_IMPORT            = 'Importiere Datei';
	TITLE_EXPORT            = 'Export';
	TITLE_FILL              = 'Reihe berechnen';
	TITLE_LINKS             = 'VerknÅpfungen';
	TITLE_CLEAR             = 'Zellen lîschen';
	TITLE_INSERT            = 'Zellen einfÅgen';
	TITLE_INSVAL            = 'Inhalte einfÅgen';
	TITLE_PRINT             = 'Drucken';
	TITLE_PAPER             = 'Papierformat';
	TITLE_SHFORM            = 'Blattformat';
	TITLE_PREVIEW           = 'Seitenansicht';
	TITLE_INFO              = 'Info';
	TITLE_FIND              = 'Suchen';
	TITLE_REPLACE           = 'Ersetzen';
	TITLE_CONST             = 'Konstanten';
	TITLE_FINDVAL           = 'Zielwertsuche';
	TITLE_SORT              = 'Sortieren';
	TITLE_SETUP             = 'Einstellungen';
	TITLE_SPECIALCHARS      = 'Sonderzeichen';
	TITLE_HELP              = 'Hilfe';

{ icon window titles }

	ICNTITLE_TEXTATTR       = 'TEXTATTRIBUTE';
	ICNTITLE_NUMFORMAT      = 'ZAHLENFORMAT';
	ICNTITLE_ROWSIZE        = 'ZEILENHôHE';
	ICNTITLE_COLSIZE        = 'SPALTENBREITE';
	ICNTITLE_COLNAME        = 'SPALTENNAME';
	ICNTITLE_PATTERN        = 'MUSTER';
	ICNTITLE_BORDERS        = 'RAHMEN';
	ICNTITLE_CLIPBOARD      = 'KLEMMBRETT';
	ICNTITLE_ABOUT          = 'öBER...';
	ICNTITLE_LAYOUT         = 'LAYOUT';
	ICNTITLE_DIAGRAM        = 'DIAGRAMM';
	ICNTITLE_OBJSIZE        = 'OBJEKTGRôSSE';
	ICNTITLE_OBJATTR        = 'OBJEKTATTRIBUTE';
	ICNTITLE_IMGOBJ         = 'GRAFIKOBJEKTATTRIBUTE';
	ICNTITLE_TXTOBJ         = 'TEXTOBJEKTATTRIBUTE';
	ICNTITLE_INSOBJ         = 'OBJEKT';
	ICNTITLE_URL            = 'URL';
	ICNTITLE_IMPORTASCII    = 'IMPORT';
	ICNTITLE_IMPORTGDBC     = 'IMPORT';
	ICNTITLE_EXPORT         = 'EXPORT';
	ICNTITLE_FILL           = 'AUSFöLLEN';
	ICNTITLE_LINKS          = 'LINKS';
	ICNTITLE_CLEAR          = 'ZELLEN LôSCHEN';
	ICNTITLE_INSERT         = 'ZELLEN EINFöGEN';
	ICNTITLE_INSVAL         = 'INHALTE EINFöGEN';
	ICNTITLE_PRINT          = 'DRUCKEN';
	ICNTITLE_SHFORM         = 'BLATTFORMAT';
	ICNTITLE_PREVIEW        = 'PREVIEW';
	ICNTITLE_INFO           = 'INFO';
	ICNTITLE_FIND           = 'SUCHEN';
	ICNTITLE_REPLACE        = 'ERSETZEN';
	ICNTITLE_CONST          = 'KONSTANTEN';
	ICNTITLE_FINDVAL        = 'ZIELWERT';
	ICNTITLE_SORT           = 'SORTIEREN';
	ICNTITLE_SETUP          = 'SETUP';
	ICNTITLE_SETUPPRINTER   = 'DRUCKER-SETUP';
	ICNTITLE_SETUPLAYOUT    = 'LAYOUT-SETUP';
	ICNTITLE_PRINTERINFO    = 'DRUCKER-INFO';
	ICNTITLE_HELP           = 'HILFE';

{ ST-Guide nodes }

	STG_CALCWINDOW          = 'Rechenfenster';
	STG_TEXTATTR            = 'Textattribute-Dialog';
	STG_NUMFORMAT           = 'Zahlenformate-Dialog';
	STG_ROWSIZE             = 'Zeilenhîhe-Dialog';
	STG_COLSIZE             = 'Spaltenbreite-Dialog';
	STG_COLNAME             = 'Spaltennamen-Dialog';
	STG_PATTERN             = 'Muster-Dialog';
	STG_BORDERS             = 'Rahmen-Dialog';
	STG_SPECIALCHARS        = 'Sonderzeichen-Fenster';
	STG_CLIPBOARD           = 'Klemmbrett-geÑndert-Dialog';
	STG_ABOUT               = 'öber-Dialog';
	STG_LAYOUT              = 'Seite einrichten-Dialog';
	STG_DIAGRAM             = 'Diagramm einfÅgen-Dialog';
	STG_OBJSIZE             = 'Objektgrîûe-Dialog';
	STG_OBJATTR             = 'Objektattribute-Dialog';
	STG_IMGOBJ              = 'Grafikobjektattribute-Dialog';
	STG_TXTOBJ              = 'Textobjektattribute-Dialog';
	STG_INSOBJ              = 'Objekt einfÅgen-Dialog';
	STG_URL                 = 'URL îffnen-Dialog';
	STG_IMPORTASCII         = 'ASCII-Import-Dialog';
	STG_IMPORTGDBC          = 'dBase-Import-Dialog';
	STG_EXPORT              = 'Export-Dialog';
	STG_FILL                = 'Reihe-AusfÅllen-Dialog';
	STG_LINKS               = 'VerknÅpfungen-Dialog';
	STG_CLEAR               = 'Zellen lîschen-Dialog';
	STG_INSERT              = 'Zellen-einfÅgen-Dialog';
	STG_INSVAL              = 'Inhalte-einfÅgen-Dialog';
	STG_PRINT               = 'Drucken-Dialog';
	STG_SHFORM              = 'Blattformat-Dialog';
	STG_PREVIEW             = 'Seitenansicht';
	STG_INFO                = 'Tabellen-Informations-Dialog';
	STG_FIND                = 'Suchen-Dialog';
	STG_REPLACE             = 'Ersetzen-Dialog';
	STG_CONST               = 'Konstanten-Dialog';
	STG_FINDVAL             = 'Zielwertsuche-Dialog';
	STG_SORT                = 'Sortieren-Dialog';
	STG_SETUP               = 'Einstellungen-Dialog';
	STG_PRINTERINFO         = 'Drucker-Informations-Dialog';
	STG_HELP                = 'Hilfe-Stichwort';

{ startup}

	STARTUP_INF             = 'DATEI "TEXEL.INF" LADEN';
	STARTUP_PATHS           = 'ZUGRIFFSPFADE LADEN';
	STARTUP_STRUCTS         = 'STRUKTUREN INITIALISIEREN';
	STARTUP_HISTORY         = 'ABRUF-DATEIEN LADEN';
	STARTUP_MENUS           = 'MENöS EINRICHTEN';
	STARTUP_DAT             = 'DATEI "TEXEL.DAT" LADEN';
	STARTUP_USRDAT          = 'DATEI "TEXELUSR.DAT" LADEN';
	STARTUP_FRM             = 'DATEI "TEXEL.FRM" LADEN';
	STARTUP_USRFRM          = 'DATEI "TEXELUSR.FRM" LADEN';
	STARTUP_PRINTDIAL       = 'DRUCKDIALOG INITIALISIEREN';
	STARTUP_FINISH          = 'ARBEITSUMGEBUNG EINRICHTEN';

{ misc }

	STRING_ROW              = 'Zeile';
	STRING_ROWTO            = 'bis';
	STRING_COL              = 'Spalte';
	STRING_COLTO            = 'bis';
	STRING_NONAME           = 'unbenannt';
	STRING_ALL              = 'Alle';
	STRING_STANDARD         = 'Standard';
	STRING_FONTSELECTION    = 'Fontauswahl!';
	STRING_ANY              = 'beliebig';
	STRING_TEMPORARYFILE    = 'temporÑre Datei';
	STRING_IMG              = 'GEM Bitimage Rastergrafik';
	STRING_TXT              = 'ASCII-Text';
	STRING_ROWDIV           = 'Zeilen&trenner';
	STRING_COLDIV           = 'Spalten&trenner';
	STRING_TRUE             = 'Wahr';
	STRING_FALSE            = 'Falsch';
	STRING_DEVICE           = 'GerÑt';
	STRING_PRINTPAGE        = 'SEITE AUSDRUCKEN...';
	STRING_COPY             = 'Exemplar';
	STRING_PAGE             = 'Seite';
	STRING_BUILDPAGE        = 'SEITE AUFBAUEN...';
	STRING_PAGEOF           = 'von';
	STRING_NODRIVER         = 'Treiber?';
	STRING_WRONGMARGINS     = 'Rand?';
	STRING_PAGEEMPTY        = 'Leer!';
	STRING_NOTHING          = 'nichts';
	STRING_DEFAULTPRINTER   = 'Standard-Drucker';
	STRING_NODRIVER2        = 'Kein Treiber verfÅgbar!';
	STRING_NONE             = 'keine';
	STRING_YES              = 'ja';
	STRING_NO               = 'nein';
	STRING_DEMOVERSION      = 'Demoversion';

	STRING_DB_SOURCE        = 'Quelle';
	STRING_DB_RECORDS       = 'DatensÑtze';
	STRING_DB_EMPTY         = 'leer';

	STRING_ERR_ERROR        = 'FEHLER';
	STRING_ERR_OVERFLOW     = 'öBERLAUF';
	
	STRING_INFO_CREATED     = 'erîffnet am  ';
	STRING_INFO_LATEST      = 'zuletzt am  ';
	STRING_INFO_USED        = 'benutzt:   ';
	STRING_INFO_PRINTED     = 'gedruckt:  ';
	STRING_INFO_SAVEDWITH   = 'gespeichert mit';
	STRING_INFO_TIMEAT      = 'um';
	
	STRING_FINDVAL_INTERVAL = 'kein Startintervall';
	STRING_FINDVAL_CANCEL   = 'Abbruch';
	STRING_FINDVAL_ITERAT   = 'Iterationen?';
	STRING_FINDVAL_NOSOLUTN = 'keine Lîsung';
	STRING_FINDVAL_STATUS   = 'Status';
	STRING_FINDVAL_SEARCH   = 'Suchen... (Abbruch mit <Esc>)';
	STRING_FINDVAL_ERROR    = 'Fehler';
	STRING_FINDVAL_OK       = 'OK.';
	
	STRING_PRNINFO_INFOON   = 'Informationen Åber';
	STRING_PRNINFO_NAME     = 'Name:         ';
	STRING_PRNINFO_NUMBER   = 'GDOS-Nummer:  ';
	STRING_PRNINFO_OUT      = 'reines AusgabegerÑt';
	STRING_PRNINFO_IN       = 'reines EingabegerÑt';
	STRING_PRNINFO_IO       = 'Ein- und AusgabegerÑt';
	STRING_PRNINFO_META     = 'Metafile-Ausgabe';
	STRING_PRNINFO_UNKNOWN  = 'unbekannt';
	STRING_PRNINFO_COLOR1   = 'Farbdruck nicht mîglich';
	STRING_PRNINFO_COLOR2   = 'kontinuierliche Verteilung';
	STRING_PRNINFO_TXT1     = 'E/A-Typ:      ';
	STRING_PRNINFO_TXT2     = 'Farben:       ';
	STRING_PRNINFO_TXT3     = 'def. Farben:  ';
	STRING_PRNINFO_TXT4     = 'ZeichensÑtze: ';
	STRING_PRNINFO_TXT5     = 'Auflîsung:    ';
	STRING_PRNINFO_TXT6     = 'Papiergrîûe:  ';
	STRING_PRNINFO_TXT7     = 'Druckbereich: ';
	STRING_PRNINFO_TXT8     = 'B'#130'ziers:      ';
	
	STRING_WEB_SUPPORT      = 'mailto:VRitzhaupt@aol.com';
	STRING_WEB_HOMEPAGE     = 'http://members.aol.com/ashinfo';
	STRING_WEB_MAILDEF1     = 'Hallo ASH-Texel-Support,';
	STRING_WEB_MAILDEF2     = 'ich habe folgende Frage zu';
	STRING_WEB_MAILDATEOF   = 'vom';
	STRING_WEB_MAILDEF3     = 'Viele Gruesse,';
	STRING_WEB_MAILSUBJECT  = 'Frage zu';
