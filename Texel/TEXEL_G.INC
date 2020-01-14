{ texel_g.inc }
{ German include file for Texel 1.60 }
{ 24.03.1997 tm }

const

{ texel.grp }

	GROUP_GENERAL_RANGE     = 'Bereich';
	GROUP_GENERAL_ROWS      = 'Zeilen';
	
	GROUP_SETUP_DEFDOC      = 'Standarddokument';
	GROUP_SETUP_WINDOW      = 'Fenster';
	GROUP_SETUP_GENERAL     = 'Allgemein';
	GROUP_SETUP_STARTUP     = 'Programmstart';

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
	BUBBLE_GENERAL_OBJSET   = 'Setzt die aktuellen Werte dieses Dialogs beim zugehîrigen Objekt, ohne den Dialog zu verlassen';
	BUBBLE_GENERAL_OBJSETOK = 'Setzt die aktuellen Werte beim zugehîrigen Objekt und verlÑût den Dialog';

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

	BUBBLE_OBJATTR_BGCOL    = 'Legt die Hintergrundfarbe fest';
	
	BUBBLE_IMGOBJ_BGCOL     = 'Legt die Hintergrundfarbe fest';
	BUBBLE_IMGOBJ_IMGCOL    = 'Legt die Farbe der Grafik fest';
	
	BUBBLE_TXTOBJ_BGCOL     = 'Legt die Hintergrundfarbe fest';
	BUBBLE_TXTOBJ_TXTCOL    = 'Legt die Textfarbe fest';

	BUBBLE_INSOBJ_SERVER    = 'Startet alle nîtigen Server nach, falls diese zwischenzeitlich terminiert haben.';
	
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
	
{ texel.msg, text and buttons separated by TAB }

	MESSAGE_GENERAL_RANGE   = 'Bitte geben Sie einen gÅltigen Bereich ein.	  &OK  ';

	MESSAGE_WINDOW_MEMORY   = 'Texel:|Nicht genÅgend Speicher fÅr neues Fenster frei!	  &OK  ';
	MESSAGE_WINDOW_WINDOWS  = 'Kein Fenster mehr verfÅgbar.	  &OK  ';
	MESSAGE_WINDOW_DDMOVE   = 'Der Drag&Drop-Block paût nicht ganz auf das Blatt, es werden nicht alle Zellen verschoben!	 &Weiter |&Abbruch';
	MESSAGE_WINDOW_DDCOPY   = 'Der Drag&Drop-Block paût nicht ganz auf das Blatt, es werden nicht alle Zellen kopiert!	 &Weiter |&Abbruch';
	MESSAGE_WINDOW_CCPCOPY  = 'Der Cut/Copy/Paste-Block paût nicht ganz auf das Blatt, es werden nicht alle Zellen kopiert!	 &Weiter |&Abbruch';

	MESSAGE_NUMFORM_EMPTY   = 'Bitte geben Sie ein Format ein.	  &OK  ';
	MESSAGE_NUMFORM_PARTS   = 'Ein Zahlenformat besteht aus max. 3 Teilen, darf also max. 2 Semikolons enthalten.	  &OK  ';
	MESSAGE_NUMFORM_BRACES  = 'Die Formatangabe enthÑlt falsche Klammerungen.	  &OK  ';

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
	FSELTITLE_IMPORTDBASE   = 'DBASE-III-DATEI IMPORTIEREN';
	FSELTITLE_IMPORTEXCEL   = 'EXCEL-DATEI IMPORTIEREN';
	FSELTITLE_IMPORT123     = '1-2-3-DATEI IMPORTIEREN';
	FSELTITLE_EXPORTFILE    = 'EXPORT-DATEI FESTLEGEN';

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
	TITLE_IMPORT            = 'Importiere Datei';

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
	ICNTITLE_IMPORTASCII    = 'ASCII-IMPORT';

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

{ Alerts }
{ fehlende BubbleHelps (...) }
{ bis Zeile 30708 }
