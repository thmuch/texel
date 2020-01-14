{ texel_e.inc }
{ English include file for Texel 1.60 }
{ last update kb: 02.08.1997 }
{ Changed email & www }
{ last update tm: 03.08.1997 }

const

{ texel.grp }

	GROUP_GENERAL_RANGE     = 'Range';
	GROUP_GENERAL_ROWS      = 'Rows';
	
	GROUP_SETUP_DEFDOC      = 'Default worksheet';
	GROUP_SETUP_WINDOW      = 'Window';
	GROUP_SETUP_GENERAL     = 'General';
	GROUP_SETUP_STARTUP     = 'Start program';

	GROUP_EXPORT_SAVEWITH   = 'Save with';
	GROUP_EXPORT_TYPE       = 'Type';
	GROUP_EXPORT_DOCTYPE    = 'Document type';

	GROUP_LAYOUT_MARGINS    = 'Margins';
	GROUP_LAYOUT_CENTER     = 'Centre';
	GROUP_LAYOUT_NUM        = 'Number pages';
	GROUP_LAYOUT_HEAD       = 'Header';
	GROUP_LAYOUT_FOOT       = 'Footer';
	GROUP_LAYOUT_PRINTWITH  = 'Print with';
	GROUP_LAYOUT_PRINTRANGE = 'Print range';

	GROUP_INFO_FILE         = 'File';

	GROUP_DELCELL_FILL      = 'Fill';

	GROUP_FIND_DIRECTION    = 'Order';
	GROUP_FIND_SEARCHIN     = 'Search in';
	GROUP_FIND_SEARCHAS     = 'Search as';
	GROUP_FIND_FORBACKWARD  = 'Direction';

	GROUP_REPLACE_DIRECTION = 'Order';
	GROUP_REPLACE_REPLIN    = 'Replace';
	GROUP_REPLACE_FORBACK   = 'Direction';

	GROUP_INSERT_PASTE      = 'Insert';
	GROUP_INSERT_OPERATION  = 'Calculate now';

	GROUP_DIAGRAM_CHANGE    = 'Change';
	GROUP_DIAGRAM_AXISLEFT  = 'Left axis';
	GROUP_DIAGRAM_AXISBOTM  = 'Bottom axis';
	GROUP_DIAGRAM_DATA      = 'Data array';
	GROUP_DIAGRAM_NAMESIN   = 'Names in';
	GROUP_DIAGRAM_SIZE      = 'Size';

	GROUP_SHEET_SIZE        = 'Size';
	GROUP_SHEET_RULER       = 'Ruler';
	GROUP_SHEET_GENERAL     = 'General';

	GROUP_SORT_WHAT         = 'Sorting';
	GROUP_SORT_NUMBERS      = 'Numbers';
	GROUP_SORT_SPACES       = 'Spaces';
	GROUP_SORT_SORT1        = 'Sorting in';
	GROUP_SORT_SORT2        = 'Followed by';
	GROUP_SORT_SORT3        = 'Followed by';

	GROUP_TEXT_FX           = 'Effects';
	GROUP_TEXT_ANGLE        = 'Angle';
	GROUP_TEXT_ALIGNMENT    = 'Alignment';
	GROUP_TEXT_MISC         = 'Miscellaneous';

	GROUP_BORDER_BLOCK      = 'Block';
	GROUP_BORDER_CELLS      = 'Cells';

	GROUP_OBJECT_BACKGR     = 'Background';
	GROUP_OBJECT_TEXT       = 'Text';
	GROUP_OBJECT_IMAGE      = 'Image';

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
	BUBBLE_SETUP_HISTORY    = '';
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
	BUBBLE_SETUP_BACKUP     = '';
	BUBBLE_SETUP_PRINTER    = 'Konfiguriert den Standard-Druckertreiber';

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
	BUBBLE_TOOLBAR_MONEY    = 'Setzt im aktuellen Block das Zahlenformat [Schwarz]{#.##0,00} DM;[Rot]-{#.##0,00} DM';
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
	
	BUBBLE_ABOUT_COPRO      = 'Diese Version von Texel benîtigt einen 68020er oder hîher';
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

	BUBBLE_OBJATTR_BACKGR   = '';
	BUBBLE_OBJATTR_TRANS    = '';
	BUBBLE_OBJATTR_BORDER   = '';
	BUBBLE_OBJATTR_BGCOL    = 'Legt die Hintergrundfarbe fest';
	
	BUBBLE_IMGOBJ_BGCOL     = 'Legt die Hintergrundfarbe fest';
	BUBBLE_IMGOBJ_IMGCOL    = 'Legt die Farbe der Grafik fest';
	BUBBLE_IMGOBJ_BACKGR    = '';
	BUBBLE_IMGOBJ_IMAGE     = '';
	BUBBLE_IMGOBJ_TRANS     = '';
	BUBBLE_IMGOBJ_BORDER    = '';
	
	BUBBLE_TXTOBJ_BGCOL     = 'Legt die Hintergrundfarbe fest';
	BUBBLE_TXTOBJ_TXTCOL    = 'Legt die Textfarbe fest';
	BUBBLE_TXTOBJ_BACKGR    = '';
	BUBBLE_TXTOBJ_TEXT      = '';
	BUBBLE_TXTOBJ_TRANS     = '';
	BUBBLE_TXTOBJ_BORDER    = '';
	BUBBLE_TXTOBJ_FONTID    = '';
	BUBBLE_TXTOBJ_FONTSIZE  = '';

	BUBBLE_INSOBJ_SERVER    = 'Startet alle nîtigen Server nach, falls diese zwischenzeitlich terminiert haben.';
	BUBBLE_INSOBJ_LIST      = '';
	BUBBLE_INSOBJ_INSERT    = '';
	BUBBLE_INSOBJ_OK        = '';
	
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
	
	BUBBLE_EXPORT_FORMULA   = 'Bei Formeln wird die Klartextformel als String gespeichert, bei Konstanten die Zahl ohne Zahlenformat';
	BUBBLE_EXPORT_VALUE     = 'Bei Formeln und Konstanten wird die Zahl im verwendeten Zahlenformat gespeichert';
	BUBBLE_EXPORT_LINEHOR   = 'Zeilen werden in der Datei horizontal (als Zeilen) gespeichert. Dies ist der Normalfall.';
	BUBBLE_EXPORT_LINEVERT  = 'Zeilen werden in der Datei vertikal gespeichert, d.h. Blatt-Spalten werden zu Datei-Zeilen';
	BUBBLE_EXPORT_LINEEND   = 'Gibt an, welche Zeichen am Ende einer Datei-Zeile stehen sollen (normalerweise CR+LF)';
	BUBBLE_EXPORT_CELLDIV   = 'Gibt an, durch welche(s) Zeichen die einzelnen Zellen getrennt werden (Åblich sind Tab, Komma oder Semikolon)';
	BUBBLE_EXPORT_QUOTECHAR = 'Gibt an, ob bzw. welches Zeichen am Anfang und Ende von normalem Klartext steht soll';
	BUBBLE_EXPORT_QUOTING   = 'Bestimmt, ob AnfÅhrungszeichen (Textquote) innerhalb von Texten verdoppelt werden (dies ist fast immer der Fall)';
	BUBBLE_EXPORT_FPOINT    = 'Gibt an, welches Zeichen in der Datei bei Zahlen Vor- und Nachkommastellen trennen soll';
	BUBBLE_EXPORT_EMPTY     = '';
	BUBBLE_EXPORT_HTML      = '';
	BUBBLE_EXPORT_DIF       = '';
	BUBBLE_EXPORT_CSV       = '';
	BUBBLE_EXPORT_ASCII     = '';
	BUBBLE_EXPORT_RTITLE    = '';
	BUBBLE_EXPORT_FORMATS   = '';
	BUBBLE_EXPORT_CLIPBOARD = '';
	BUBBLE_EXPORT_FILE      = '';
	BUBBLE_EXPORT_FILENAME  = '';
	BUBBLE_EXPORT_EXPORT    = '';
	BUBBLE_EXPORT_OK        = '';
	BUBBLE_EXPORT_DOCTYPE   = '';
	BUBBLE_EXPORT_SAVEWITH  = '';
	BUBBLE_EXPORT_DTPOPUP   = '';
	BUBBLE_EXPORT_SAVEDT    = '';
	BUBBLE_EXPORT_COLORS    = '';
	BUBBLE_EXPORT_DIFTYPE   = '';
	BUBBLE_EXPORT_DIFSTAND  = '';
	BUBBLE_EXPORT_DIFMS     = '';
	BUBBLE_EXPORT_ROWS      = '';
	BUBBLE_EXPORT_DIFFORM   = '';
	BUBBLE_EXPORT_CSVFORM   = '';
	BUBBLE_EXPORT_ASCIIFORM = '';
	BUBBLE_EXPORT_EMBED     = '';
	
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
	BUBBLE_PREVIEW_100      = '';
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
	BUBBLE_INFO_ENCRYPT     = '';
	BUBBLE_INFO_PASSWORD    = '';
	
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
	BUBBLE_SORT_ATTR        = '';
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
	
	BUBBLE_DIAGRAM_CHANGE   = '';
	BUBBLE_DIAGRAM_GRPTYPE  = '';
	BUBBLE_DIAGRAM_GRPAXIS  = '';
	BUBBLE_DIAGRAM_GRPDATA  = '';
	BUBBLE_DIAGRAM_GRPLEG   = '';
	BUBBLE_DIAGRAM_GRPOBJ   = '';
	BUBBLE_DIAGRAM_ICON     = '';
	BUBBLE_DIAGRAM_RTYPE    = '';
	BUBBLE_DIAGRAM_RAXIS    = '';
	BUBBLE_DIAGRAM_RDATA    = '';
	BUBBLE_DIAGRAM_RLEG     = '';
	BUBBLE_DIAGRAM_ROBJ     = '';
	BUBBLE_DIAGRAM_LINE     = '';
	BUBBLE_DIAGRAM_BLOCK    = '';
	BUBBLE_DIAGRAM_CIRCLE   = '';
	BUBBLE_DIAGRAM_COLOR    = '';
	BUBBLE_DIAGRAM_VALUE    = '';
	BUBBLE_DIAGRAM_XLINEAR  = '';
	BUBBLE_DIAGRAM_X1DATA   = '';
	BUBBLE_DIAGRAM_XYALT    = '';
	BUBBLE_DIAGRAM_LLINES   = '';
	BUBBLE_DIAGRAM_LPOINTS  = '';
	BUBBLE_DIAGRAM_LBOTH    = '';
	BUBBLE_DIAGRAM_STACK    = '';
	BUBBLE_DIAGRAM_BEHIND   = '';
	BUBBLE_DIAGRAM_SIDE     = '';
	BUBBLE_DIAGRAM_LSTYLE   = '';
	BUBBLE_DIAGRAM_PSTYLE   = '';
	BUBBLE_DIAGRAM_TITLE    = '';
	BUBBLE_DIAGRAM_BORDER   = '';
	BUBBLE_DIAGRAM_NAMES    = '';
	BUBBLE_DIAGRAM_LCOUNT   = '';
	BUBBLE_DIAGRAM_NROW     = '';
	BUBBLE_DIAGRAM_NCOL     = '';
	BUBBLE_DIAGRAM_FONTID   = '';
	BUBBLE_DIAGRAM_FONTSIZE = '';
	BUBBLE_DIAGRAM_DATA     = '';
	BUBBLE_DIAGRAM_DROWS    = '';
	BUBBLE_DIAGRAM_DCOLUMNS = '';
	BUBBLE_DIAGRAM_RTICKS   = '';
	BUBBLE_DIAGRAM_TICKS    = '';
	BUBBLE_DIAGRAM_NUMTICKS = '';
	BUBBLE_DIAGRAM_AXISLEFT = '';
	BUBBLE_DIAGRAM_ALNAME   = '';
	BUBBLE_DIAGRAM_ALSUBT   = '';
	BUBBLE_DIAGRAM_ALSUBNUM = '';
	BUBBLE_DIAGRAM_ALMIN    = '';
	BUBBLE_DIAGRAM_ALMAX    = '';
	BUBBLE_DIAGRAM_AXISBOTM = '';
	BUBBLE_DIAGRAM_ABNAME   = '';
	BUBBLE_DIAGRAM_ABSUBT   = '';
	BUBBLE_DIAGRAM_ABSUBNUM = '';
	BUBBLE_DIAGRAM_ABMIN    = '';
	BUBBLE_DIAGRAM_ABMAX    = '';
	BUBBLE_DIAGRAM_SIZE     = '';
	BUBBLE_DIAGRAM_WIDTH    = '';
	BUBBLE_DIAGRAM_HEIGHT   = '';
	BUBBLE_DIAGRAM_FILE     = '';
	BUBBLE_DIAGRAM_TEMPFILE = '';
	BUBBLE_DIAGRAM_FILENAME = '';
	BUBBLE_DIAGRAM_CREATAD  = '';
	BUBBLE_DIAGRAM_INSERT   = '';
	BUBBLE_DIAGRAM_OK       = '';
	
	BUBBLE_OBJSIZE_SIZE     = '';
	BUBBLE_OBJSIZE_X        = '';
	BUBBLE_OBJSIZE_Y        = '';
	BUBBLE_OBJSIZE_WIDTH    = '';
	BUBBLE_OBJSIZE_HEIGHT   = '';
	
	BUBBLE_URL_EDIT         = '';
	BUBBLE_URL_OPEN         = '';
	BUBBLE_URL_OK           = '';
	
	BUBBLE_PASS_FILE        = '';
	BUBBLE_PASS_EDIT        = '';
	BUBBLE_PASS_CANCEL      = '';
	BUBBLE_PASS_OK          = '';
	
	BUBBLE_CHGPASS_OLD      = '';
	BUBBLE_CHGPASS_NEW      = '';
	BUBBLE_CHGPASS_OK       = '';
	
	BUBBLE_FILL_ROWS        = '';
	BUBBLE_FILL_COLUMNS     = '';
	BUBBLE_FILL_ARITHM      = '';
	BUBBLE_FILL_GEOM        = '';
	BUBBLE_FILL_DATE        = '';
	BUBBLE_FILL_TREND       = '';
	BUBBLE_FILL_COPY        = '';
	BUBBLE_FILL_RDAY        = '';
	BUBBLE_FILL_RWEEKDAY    = '';
	BUBBLE_FILL_RMONTH      = '';
	BUBBLE_FILL_RYEAR       = '';
	BUBBLE_FILL_STEPVAL     = '';
	BUBBLE_FILL_ENDVAL      = '';
	BUBBLE_FILL_CALC        = '';
	BUBBLE_FILL_OK          = '';
	
	BUBBLE_LINK_LIST        = '';
	BUBBLE_LINK_CHANGE      = '';
	BUBBLE_LINK_ACTIVATE    = '';
	BUBBLE_LINK_EDIT        = '';
	
	BUBBLE_FINDVAL_CTARGET  = '';
	BUBBLE_FINDVAL_CVALUE   = '';
	BUBBLE_FINDVAL_TVALUE   = '';
	BUBBLE_FINDVAL_ITERAT   = '';
	BUBBLE_FINDVAL_STATUS   = '';
	BUBBLE_FINDVAL_FIND     = '';
	BUBBLE_FINDVAL_OK       = '';
	
{ texel.msg }

	BUTTON_OK               = '  &OK  ';
	BUTTON_CANCEL           = '&Cancel';
	BUTTON_OKCANCEL         = '  &OK  |&Cancel';
	BUTTON_GOCANCEL         = ' &Apply |&Cancel';
	BUTTON_YESNO            = '  &Yes  | &No ';
	BUTTON_YESNOCANCEL      = '  &Yes  | &No |&Cancel';
	BUTTON_OBJCELLCANCEL    = '&Object|C&ell|&Cancel';
	BUTTON_FORMDOC          = '&Form|&Document';
	BUTTON_SAVECANCEL       = '&Save|&Cancel';

	MESSAGE_GENERAL_RANGE   = 'Please select a valid range.';
	MESSAGE_GENERAL_MEMORY  = 'TEXEL:|Not enough free memory!';
	MESSAGE_GENERAL_OLGA    = 'OLGA manager not installed.';

	MESSAGE_DEMO_DEMO       = 'This is a Demo version of Texel. Saving is not possible.';
	MESSAGE_DEMO_UNREG      = 'Only registered copies of Texel allow saving.';
	
	MESSAGE_STARTUP_UNREG   = 'TEXEL:|Texel has not been installed/registered correctly.';
	MESSAGE_STARTUP_SCREEN  = 'Texel requires a minimum display of 80x25 characters. Please select a higher resolution or smaller systemfont.';
	MESSAGE_STARTUP_COPRO   = 'TEXEL:|This version of Texel requires a Coprocessor.';
	MESSAGE_STARTUP_BETA    = 'TEXEL:|This Beta version is too old.';
	MESSAGE_STARTUP_FOUND1  = 'TEXEL:|File "';
	MESSAGE_STARTUP_FOUND2  = '" not found.';
	MESSAGE_STARTUP_LOAD1   = 'TEXEL:|Unable to load  "';
	MESSAGE_STARTUP_LOAD2   = '" .';
	MESSAGE_STARTUP_FRM1    = 'TEXEL:|Corrupt "';
	MESSAGE_STARTUP_FRM2    = '" file';

	MESSAGE_WINDOW_MEMORY   = 'Texel:|Insufficient memory for new windows!';
	MESSAGE_WINDOW_WINDOWS  = 'No more windows available.';
	MESSAGE_WINDOW_DDMOVE   = 'The Drag&Drop block is too large for this worksheet, some cells will not be moved!';
	MESSAGE_WINDOW_DDCOPY   = 'The Drag&Drop block is too large for this worksheet, some cells will not be copied!';
	MESSAGE_WINDOW_CCPCOPY  = 'The Cut/Copy/Paste block is too large for this worksheet, some cells will not be copied!';
	MESSAGE_WINDOW_CLOSE1   = 'Worksheet "';
	MESSAGE_WINDOW_CLOSE2   = '" has been changed. Do you want to save the changes?';
	MESSAGE_WINDOW_VAR1     = 'The variable ';
	MESSAGE_WINDOW_VAR2     = ' has already been defined ';
	MESSAGE_WINDOW_VAR3     = ' in the cell.';
	MESSAGE_WINDOW_CUT      = 'Cut object or cell?';
	MESSAGE_WINDOW_COPY     = 'Copy object or cell?';
	MESSAGE_WINDOW_DELETE   = 'Delete object or cell?';
	MESSAGE_WINDOW_BLOCK1   = 'Moving this block may cause loss of formulas, text or numeric data.';
	MESSAGE_WINDOW_BLOCK2   = 'Data in the target range will be overwritten!';
	MESSAGE_WINDOW_EMBED1   = 'An error has occured "';
	MESSAGE_WINDOW_EMBED2   = '" whilst embedding.';
	MESSAGE_WINDOW_EMAIL    = 'An error has occurred whilst sending e-mail to SysSol support.';
	MESSAGE_WINDOW_SIZE     = 'Reducing the worksheet size may cause loss of formula, text or numeric data.';
	MESSAGE_WINDOW_SIZEERR  = 'Cannot change worksheet size (insufficient memory).';

	MESSAGE_NUMFORM_EMPTY   = 'Please select a format.';
	MESSAGE_NUMFORM_PARTS   = 'A number format has up to 3 parts, ie. it can contain up to 2 semicolons.';
	MESSAGE_NUMFORM_BRACES  = 'The format given contains incorrect bracketing.';
	MESSAGE_NUMFORM_DEL1    = 'Delete "';
	MESSAGE_NUMFORM_DEL2    = '" number format?';

	MESSAGE_CLIP_PASTE      = 'The clipboard does not contain suitable data for pasting.';
	MESSAGE_CLIP_IMPORT     = 'The clipboard does not contain any suitable files.';
	
	MESSAGE_EMBED_ARTWORX   = 'Unable to call ArtWorx.';
	MESSAGE_EMBED_OLGA1     = 'Unable to call the OLGA server"';
	MESSAGE_EMBED_OLGA2     = '".';
	MESSAGE_EMBED_DELETE    = 'Confirm deletion of objects?';
	MESSAGE_EMBED_EXIST1    = 'The file "';
	MESSAGE_EMBED_EXIST2    = '" already exists. Overwrite?';
	
	MESSAGE_LAYOUT_RANGE    = 'Please select a valid print range.';
	MESSAGE_LAYOUT_HEADFOOT = 'You have defined a header or footer without defining the print area.';
	
	MESSAGE_DIAGRAM_ROWS    = 'Too few rows selected.';
	MESSAGE_DIAGRAM_COLUMNS = 'Too few column selected.';
	MESSAGE_DIAGRAM_CELLS   = 'Too few cells selected.';
	MESSAGE_DIAGRAM_ROWEVEN = 'Please select an even number of data rows.';
	MESSAGE_DIAGRAM_COLEVEN = 'Please select an even number of data columns.';

	MESSAGE_OPEN_MEMORY1    = 'Unable to load file "';
	MESSAGE_OPEN_MEMORY2    = '" (memory low)';
	MESSAGE_OPEN_EXIST1     = 'File "';
	MESSAGE_OPEN_EXIST2     = '" not found.';
	MESSAGE_OPEN_LOADED1    = 'The file "';
	MESSAGE_OPEN_LOADED2    = '" is already loaded. Load again?';
	MESSAGE_OPEN_FORMAT1    = '"';
	MESSAGE_OPEN_FORMAT2    = '" is not a Texel file.';
	MESSAGE_OPEN_VERSION1   = '"';
	MESSAGE_OPEN_VERSION2   = '" (File version #';
	MESSAGE_OPEN_VERSION3   = ', saved with Texel ';
	MESSAGE_OPEN_VERSION4   = ') is not compatible with this version of Texel.';
	MESSAGE_OPEN_CCP        = 'Cut/Copy/Paste blocks can''t be loaded directly. Please use "Edit/Paste" (Control+V).';
	MESSAGE_OPEN_ALGO1      = '"';
	MESSAGE_OPEN_ALGO2      = '": Unknown Texel compression';
	MESSAGE_OPEN_PASSLEN    = 'The password must have a minimum of 6 characters.';
	MESSAGE_OPEN_PASSWRONG  = 'Wrong password!';
	MESSAGE_OPEN_ERROR1     = 'File "';
	MESSAGE_OPEN_ERROR2     = '" could not be loaded.';
	
	MESSAGE_SAVE_FORMDOC    = 'This worksheet is a template. Save as template or new document?';
	MESSAGE_SAVE_EMBEDDED   = 'An embedded object has not yet been saved in its ID4 server. Save with old object data?';
	MESSAGE_SAVE_MEMORY     = 'Unable to save worksheet (insufficient memory)';
	MESSAGE_SAVE_WPROT      = 'Unable to save worksheet (is the media write protected?)';
	MESSAGE_SAVE_DISKFULL   = 'Unable to save worksheet (disk full?)';                                          

	MESSAGE_SAVEAS_EXIST1   = 'The file "';
	MESSAGE_SAVEAS_EXIST2   = '" already exists. Overwrite?';
	MESSAGE_SAVEAS_NEW1     = 'Accept new filename "';
	MESSAGE_SAVEAS_NEW2     = '" ?';

	MESSAGE_IMPORT_LOAD1    = 'The file "';
	MESSAGE_IMPORT_LOAD2    = '" could not be loaded.';
	MESSAGE_IMPORT_DBSIZE   = 'The data bank is too large. Texel can import a maximum of 16384 sets of data.';
	MESSAGE_IMPORT_MEMORY1  = 'Could not load file "';
	MESSAGE_IMPORT_MEMORY2  = '"  (insufficient memory)';
	MESSAGE_IMPORT_EXIST1   = 'File "';
	MESSAGE_IMPORT_EXIST2   = '" not found.';
	MESSAGE_IMPORT_LOTUS1   = '"';
	MESSAGE_IMPORT_LOTUS2   = '" is not a Lotus 1-2-3 file.';
	MESSAGE_IMPORT_WKS1     = '"';
	MESSAGE_IMPORT_WKS2     = '" is not a WKS/WK1 file.';
	MESSAGE_IMPORT_WKPASS1  = '"';
	MESSAGE_IMPORT_WKPASS2  = '" is encoded and cannot be imported.';
	MESSAGE_IMPORT_WKEMPTY1 = '"';
	MESSAGE_IMPORT_WKEMPTY2 = '" does not contain any data.';
	MESSAGE_IMPORT_EXCEL1   = '"';
	MESSAGE_IMPORT_EXCEL2   = '"|is not a MS-Excel 2.0/3.0/4.0 file.';
	MESSAGE_IMPORT_XLS1     = '"';
	MESSAGE_IMPORT_XLS2     = '" is not a XLS worksheet.';
	MESSAGE_IMPORT_XLPASS1  = '"';
	MESSAGE_IMPORT_XLPASS2  = '" is password protected and cannot be loaded.';
	MESSAGE_IMPORT_XLDATE1  = 'Attention:|"';
	MESSAGE_IMPORT_XLDATE2  = '" contains dates in 1904 format, which is not yet supported by Texel.';

	MESSAGE_EXPORT_EXIST1   = 'The file "';
	MESSAGE_EXPORT_EXIST2   = '" exists already. Overwrite?';
	
	MESSAGE_PRINT_STOP      = 'Stop printing?';
	MESSAGE_PRINT_EMPTY     = 'The print range does not contain any data.';
	MESSAGE_PRINT_DEVICE1   = 'Could not open device driver ';
	MESSAGE_PRINT_DEVICE2   = '.';
	MESSAGE_PRINT_MARGINS   = 'Borders are overlapping or paper size has been exceeded.';
	MESSAGE_PRINT_NEWSHEET  = 'Please insert a new sheet of paper.';
	MESSAGE_PRINT_PRINTER   = 'No printer has been selected.';
	MESSAGE_PRINT_DRIVER    = 'Printer driver not installed.';

	MESSAGE_INFO_PASSWRONG  = 'Old password is wrong!';
	MESSAGE_INFO_PASSLEN    = 'The new password must be empty or must contain at least 6 characters.';
	
	MESSAGE_CONST_EMPTY     = 'Please enter a constant name.';
	MESSAGE_CONST_NAME      = 'Please enter a valid name.';
	MESSAGE_CONST_USED1     = 'The constant name "';
	MESSAGE_CONST_USED2     = '" has already been used.';
	MESSAGE_CONST_VALEMPTY  = 'Please enter the value of the constant.';
	MESSAGE_CONST_VALUE     = 'Please enter a valid value.';
	MESSAGE_CONST_DELETE1   = 'Delete constant "';
	MESSAGE_CONST_DELETE2   = '" ?';
	
	MESSAGE_FINDVAL_CELLREF = 'Target cell and variable cell must be a cell reference.';
	MESSAGE_FINDVAL_FORMULA = 'The target cell must contain a formula.';
	MESSAGE_FINDVAL_NUMBER  = 'The variable cell must be empty or contain a number.';
	MESSAGE_FINDVAL_ERROR   = 'Could not determine the target value correctly.';
	

{ fsel titles }

	FSELTITLE_DIAGRAM       = 'NAME CHART FILE';
	FSELTITLE_TAD           = 'NAME TAD FILE';
	FSELTITLE_TADSAVEAS     = 'SAVE TAD FILE AS...';
	FSELTITLE_OBJECTSAVEAS  = 'SAVE OBJECT AS...';
	FSELTITLE_OBJECTINSERT  = 'INSERT OBJECT';
	FSELTITLE_CHANGELINK    = 'CHANGE LINKING...';
	FSELTITLE_LOADTEXT      = 'LOAD ASCII TEXT';
	FSELTITLE_LOADIMG       = 'LOAD IMG GRAPHIC';
	FSELTITLE_OPEN          = 'LOAD TEXEL WORKSHEET';
	FSELTITLE_SAVEFORMASDOC = 'SAVE FORM AS FILE';
	FSELTITLE_IMPORTLDW     = 'IMPORT LDW EXPORT FILE';
	FSELTITLE_IMPORTDIF     = 'IMPORT DIF FILE';
	FSELTITLE_IMPORTCSV     = 'IMPORT CSV FILE';
	FSELTITLE_IMPORTASCII   = 'IMPORT ASCII FILE';
	FSELTITLE_IMPORTDBASE   = 'IMPORT DBASE-III FILE';
	FSELTITLE_IMPORTEXCEL   = 'IMPORT EXCEL FILE';
	FSELTITLE_IMPORT123     = 'IMPORT LOTUS 1-2-3 FILE';
	FSELTITLE_EXPORTFILE    = 'NAME EXPORT FILE';
	FSELTITLE_PRINTMETA     = 'PRINT TO METAFILE...';
	FSELTITLE_PRINTIMG      = 'PRINT TO IMG FILE...';
	FSELTITLE_SAVEAS        = 'SAVE TEXEL WORKSHEET AS...';

{ window titles }

	TITLE_FONTSELECTOR      = 'Font selector';
	TITLE_TEXTATTR          = 'Text attributes';
	TITLE_NUMFORMAT         = 'Number format';
	TITLE_ROWSIZE           = 'Row height';
	TITLE_COLSIZE           = 'Column width';
	TITLE_COLNAME           = 'Column name';
	TITLE_PATTERN           = 'Fill pattern';
	TITLE_BORDERS           = 'Borders';
	TITLE_ABOUT             = 'About Texel...';
	TITLE_LAYOUT            = 'Edit page layout';
	TITLE_FUNCTION          = 'Insert function';
	TITLE_DIAGRAM           = 'Insert chart';
	TITLE_OBJSIZE           = 'Object size';
	TITLE_OBJATTR           = 'Object attributes';
	TITLE_IMGOBJ            = 'Graphic object attributes';
	TITLE_TXTOBJ            = 'Text object attributes';
	TITLE_INSOBJ            = 'Insert object';
	TITLE_URL               = 'Open URL';
	TITLE_OPEN              = 'Load file';
	TITLE_IMPORTASCII       = 'Import ASCII file';
	TITLE_IMPORT            = 'Importing file';
	TITLE_EXPORT            = 'Export';
	TITLE_FILL              = 'Fill fill range';
	TITLE_LINKS             = 'Linking';
	TITLE_CLEAR             = 'Delete cells';
	TITLE_INSERT            = 'Add cells';
	TITLE_INSVAL            = 'Add contents';
	TITLE_PRINT             = 'Print';
	TITLE_PAPER             = 'Paper format';
	TITLE_SHFORM            = 'Sheet format';
	TITLE_PREVIEW           = 'Print preview';
	TITLE_INFO              = 'Info';
	TITLE_FIND              = 'Find';
	TITLE_REPLACE           = 'Replace';
	TITLE_CONST             = 'Constants';
	TITLE_FINDVAL           = 'Find target value';
	TITLE_SORT              = 'Sort';
	TITLE_SETUP             = 'Setup';
	TITLE_SPECIALCHARS      = 'Special chars';
	TITLE_HELP              = 'Help';

{ icon window titles }

	ICNTITLE_TEXTATTR       = 'TEXT ATTRIBUTES';
	ICNTITLE_NUMFORMAT      = 'NUMBER FORMAT';
	ICNTITLE_ROWSIZE        = 'ROW HEIGHT';
	ICNTITLE_COLSIZE        = 'COLUMN WIDTH';
	ICNTITLE_COLNAME        = 'COLUMN NAME';
	ICNTITLE_PATTERN        = 'FILL PATTERN';
	ICNTITLE_BORDERS        = 'BORDERS';
	ICNTITLE_CLIPBOARD      = 'CLIPBOARD';
	ICNTITLE_ABOUT          = 'ABOUT...';
	ICNTITLE_LAYOUT         = 'LAYOUT';
	ICNTITLE_DIAGRAM        = 'CHART';
	ICNTITLE_OBJSIZE        = 'OBJECT SIZE';
	ICNTITLE_OBJATTR        = 'OBJECT ATTRIBUTES';
	ICNTITLE_IMGOBJ         = 'GRAPHIC OBJECT ATTRIBUTES';
	ICNTITLE_TXTOBJ         = 'TEXT OBJECT ATTRIBUTES';
	ICNTITLE_INSOBJ         = 'OBJECT';
	ICNTITLE_URL            = 'URL';
	ICNTITLE_IMPORTASCII    = 'IMPORT ASCII';
	ICNTITLE_EXPORT         = 'EXPORT';
	ICNTITLE_FILL           = 'FILL';
	ICNTITLE_LINKS          = 'LINKS';
	ICNTITLE_CLEAR          = 'CLEAR CELLS';
	ICNTITLE_INSERT         = 'INSERT CELLS';
	ICNTITLE_INSVAL         = 'INSERT CONTENTS';
	ICNTITLE_PRINT          = 'PRINT';
	ICNTITLE_SHFORM         = 'WORKSHEET FORMAT';
	ICNTITLE_PREVIEW        = 'PREVIEW';
	ICNTITLE_INFO           = 'INFO';
	ICNTITLE_FIND           = 'FIND';
	ICNTITLE_REPLACE        = 'REPLACE';
	ICNTITLE_CONST          = 'CONSTANTS';
	ICNTITLE_FINDVAL        = 'TARGET VALUE';
	ICNTITLE_SORT           = 'SORTING';
	ICNTITLE_SETUP          = 'SETUP';
	ICNTITLE_SETUPPRINTER   = 'PRINTER SETUP';
	ICNTITLE_SETUPLAYOUT    = 'LAYOUT SETUP';
	ICNTITLE_PRINTERINFO    = 'PRINTER INFO';
	ICNTITLE_HELP           = 'HELP';

{ ST-Guide nodes }

	STG_CALCWINDOW          = 'Calculation window';
	STG_TEXTATTR            = 'Text attribute dialog';
	STG_NUMFORMAT           = 'Number format dialog';
	STG_ROWSIZE             = 'Row height dialog';
	STG_COLSIZE             = 'Column width dialog';
	STG_COLNAME             = 'Column name dialog';
	STG_PATTERN             = 'Fill pattern dialog';
	STG_BORDERS             = 'Borders dialog';
	STG_SPECIALCHARS        = 'Special characters window';
	STG_CLIPBOARD           = 'Clipboard changed dialog';
	STG_ABOUT               = 'About dialog';
	STG_LAYOUT              = 'Page layout dialog';
	STG_DIAGRAM             = 'Insert chart dialog';
	STG_OBJSIZE             = 'Object size dialog';
	STG_OBJATTR             = 'Object attribute dialog';
	STG_IMGOBJ              = 'Graphic object attribute dialog';
	STG_TXTOBJ              = 'Text object attribute dialog';
	STG_INSOBJ              = 'Object insert dialog';
	STG_URL                 = 'Open URL dialog';
	STG_IMPORTASCII         = 'ASCII Import dialog';
	STG_EXPORT              = 'Export dialog';
	STG_FILL                = 'Row fill dialog';
	STG_LINKS               = 'Linking dialog';
	STG_CLEAR               = 'Delete cells dialog';
	STG_INSERT              = 'Insert cells dialog';
	STG_INSVAL              = 'Insert contents dialog';
	STG_PRINT               = 'Print dialog';
	STG_SHFORM              = 'Sheet format dialog';
	STG_PREVIEW             = 'Preview';
	STG_INFO                = 'Table Info dialog';
	STG_FIND                = 'Find dialog';
	STG_REPLACE             = 'Replace dialog';
	STG_CONST               = 'Constants dialog';
	STG_FINDVAL             = 'Find target value dialog';
	STG_SORT                = 'Sort dialog';
	STG_SETUP               = 'Setup dialog';
	STG_PRINTERINFO         = 'Printer info dialog';
	STG_HELP                = 'Subject help';

{ misc }

	STRING_ROW              = 'Row';
	STRING_ROWTO            = 'to';
	STRING_COL              = 'Column';
	STRING_COLTO            = 'to';
	STRING_NONAME           = 'untitled';
	STRING_ALL              = 'All';
	STRING_STANDARD         = 'Standard';
	STRING_FONTSELECTION    = 'Font selection!';
	STRING_ANY              = 'any';
	STRING_TEMPORARYFILE    = 'Temporary file';
	STRING_IMG              = 'GEM bit image raster graphic';
	STRING_TXT              = 'ASCII text';
	STRING_ROWDIV           = 'Row&separator';
	STRING_COLDIV           = 'Column&separator';
	STRING_TRUE             = 'True';
	STRING_FALSE            = 'False';
	STRING_DEVICE           = 'Device';
	STRING_PRINTPAGE        = 'PRINTING PAGE...';
	STRING_COPY             = 'Copy';
	STRING_PAGE             = 'Page';
	STRING_BUILDPAGE        = 'BUILDING PAGE...';
	STRING_PAGEOF           = 'of';
	STRING_NODRIVER         = 'Driver?';
	STRING_WRONGMARGINS     = 'Margin?';
	STRING_PAGEEMPTY        = 'Empty!';
	STRING_NOTHING          = 'nothing';
	STRING_DEFAULTPRINTER   = 'Default printer';
	STRING_NODRIVER2        = 'No driver available!';
	STRING_NONE             = 'none';
	STRING_YES              = 'yes';
	STRING_NO               = 'no';
	STRING_DEMOVERSION      = 'Demo version';

	STRING_ERR_ERROR        = 'ERROR';
	STRING_ERR_OVERFLOW     = 'OVERFLOW';
	
	STRING_INFO_CREATED     = 'Created on  ';
	STRING_INFO_LATEST      = 'Changed on  ';
	STRING_INFO_USED        = 'Used:   ';
	STRING_INFO_PRINTED     = 'Printed:  ';
	STRING_INFO_SAVEDWITH   = 'Saved with';
	STRING_INFO_TIMEAT      = 'at';
	
	STRING_FINDVAL_INTERVAL = 'No start interval';
	STRING_FINDVAL_CANCEL   = 'Cancel';
	STRING_FINDVAL_ITERAT   = 'Iterations?';
	STRING_FINDVAL_NOSOLUTN = 'No result';
	STRING_FINDVAL_STATUS   = 'Status';
	STRING_FINDVAL_SEARCH   = 'Searching... (Exit with  <Esc>)';
	STRING_FINDVAL_ERROR    = 'Error';
	STRING_FINDVAL_OK       = 'OK.';
	
	STRING_PRNINFO_INFOON   = 'Information on';
	STRING_PRNINFO_NAME     = 'Name:         ';
	STRING_PRNINFO_NUMBER   = 'GDOS number:  ';
	STRING_PRNINFO_OUT      = 'Print only device';
	STRING_PRNINFO_IN       = 'Scanning only device';
	STRING_PRNINFO_IO       = 'In and output device';
	STRING_PRNINFO_META     = 'Metafile output';
	STRING_PRNINFO_UNKNOWN  = 'unknown';
	STRING_PRNINFO_COLOR1   = 'Colour printing not possible';
	STRING_PRNINFO_COLOR2   = 'Even distribution';
	STRING_PRNINFO_TXT1     = 'E/A type:      ';
	STRING_PRNINFO_TXT2     = 'Colours:       ';
	STRING_PRNINFO_TXT3     = 'Def. colours:  ';
	STRING_PRNINFO_TXT4     = 'Character sets: ';
	STRING_PRNINFO_TXT5     = 'Resolution:    ';
	STRING_PRNINFO_TXT6     = 'Paper size:  ';
	STRING_PRNINFO_TXT7     = 'Printable area: ';
	STRING_PRNINFO_TXT8     = 'B'#130'ziers:      ';
	
	STRING_WEB_SUPPORT      = 'mailto:stsoft-support@system-solutions.co.uk';
	STRING_WEB_HOMEPAGE     = 'http://www.system-solutions.co.uk/cafe';
	STRING_WEB_MAILDEF1     = 'Dear System Solutions Texel Support,';
	STRING_WEB_MAILDEF2     = 'I have the following question about';
	STRING_WEB_MAILDATEOF   = 'Dated:';
	STRING_WEB_MAILDEF3     = 'Yours faithfully,';
	STRING_WEB_MAILSUBJECT  = 'Question about';
