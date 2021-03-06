----------------------------------------------------------------------------
-- IlarosNavi
-- Modul für deutsche Texte
----------------------------------------------------------------------------

if ( GetLocale() == "deDE" ) then

IlarosNaviLocals = {
    ["%d yards"] = "%d Meter",
    ["%s yards away"] = "%s Meter entfernt",
    ["Accept waypoints from guild and party members"] = "Erlaube Zielpunkte von Gilden- und Gruppenmitgliedern",
    ["Allow control-right clicking on map to create new waypoint"] = "STRG-Rechtsklick auf Karte setzt neuen Zielpunkt",
    ["Alpha"] = "Tansparenz",
    ["Announce new waypoints when they are added"] = "Neue Zielpunkte ansagen, wenn sie gesetzt werden",
    ["Are you sure you would like to remove ALL IlarosNavi waypoints?"] = "Bist du sicher, dass du ALLE Zielpunkte l\195\182schen willst?",
    ["Arrow colors"] = "Pfeilfarben",
    ["Arrow display"] = "Pfeilanzeige",
    ["Ask for confirmation on \"Remove All\""] = "Best\195\164tigung f\195\188r \"Alle Zielpunkte l\195\182schen\"",
    ["Automatically set a waypoint when I die"] = "Zielpunktpfeil automatisch setzen, wenn du stirbst",
    ["Automatically set to next closest waypoint"] = "Zielpunktpfeil automatisch auf n\195\164chsten Zielpunkt setzen",
    ["Automatically set waypoint arrow"] = "Zielpunktpfeil automatisch setzen",
    ["Background color"] = "Hintergrundfarbe",
    ["Bad color"] = "falsche Richtung",
    ["Block height"] = "H\195\182he",
    ["Block width"] = "Breite",
    ["Border color"] = "Rahmenfarbe",
    ["Clear waypoint distance"] = "Zielpunkt l\195\182schen bei",
    ["Clear waypoint from crazy arrow"] = "Zielffeil ausblenden",
    ["Controls the frequency of updates for the coordinate LDB feed."] = "Steuert die Geschwindigeit des Koordinaten-LDB-Feeds.",
    ["Controls the frequency of updates for the crazy arrow LDB feed."] = "Steuert die Geschwindigeit des Zielpunktpfeil-LDB-Feeds.",
    ["Coordinate Accuracy"] = "Koordinatengenauigkeit",
    ["Coordinate Block"] = "Koordinatenbox",
    ["Coordinate feed accuracy"] = "Koordinatengenauigkeit",
    ["Coordinate feed throttle"] = "Koordinaten-Feed-Geschwindigkeit",
    ["Coordinates can be displayed as simple XX, YY coordinate, or as more precise XX.XX, YY.YY.  This setting allows you to control that precision"] = "Koordinaten k\195\182nnen einfach als XX,YY oder pr\195\164ziser mit bis zu zwei Nachkommastellen angezeigt werden. Mit dieser Einstellung wird die Pr\195\164zision gesteuert.",
    ["Crazy Arrow feed throttle"] = "Zielpunktpfeil-Feed-Geschwindigkeit",
    ["Create note modifier"] = "Kombinationstaste",
    ["Ctrl+Right Click To Add a Waypoint"] = "Klick Ctrl+Rechts, um einen Zielpunkt hinzuzuf\195\188gen",
    ["Cursor Coordinates"] = "Cursorkoordinaten",
    ["Cursor coordinate accuracy"] = "Koordinatengenauigkeit",
    ["Data Feed Options"] = "Data-Feed-Optionen",
    ["Disable all mouse input"] = "Mauseingaben komplett deaktivieren",
    ["Disables the crazy taxi arrow for mouse input, allowing all clicks to pass through"] = "Deaktiviert alle Mauseingaben f\195\188r den Zielpunktpfeil, so dass Klicks durchgehen.",
    ["Display Settings"] = "Anzeigeeinstellungen",
    ["Display waypoints from other zones"] = "Zielpunkte aus anderen Zonen anzeigen",
    ["Enable automatic quest objective waypoints"] = "Automatische Quest-Zielpunkte aktivieren",
    ["Enable coordinate block"] = "Koordinatenbox aktivieren",
    ["Enable floating waypoint arrow"] = "Verschiebbaren Zielpunktpfeil aktivieren",
    ["Enable minimap waypoints"] = "Minikarten-Zielpunkte aktivieren",
    ["Enable mouseover tooltips"] = "Maus-Tooltips aktivieren",
    ["Enable quest objective click integration"] = "Questziel-Klickintegration aktivieren",
    ["Enable showing cursor coordinates"] = "Cursorkoordinaten aktivieren",
    ["Enable showing player coordinates"] = "Spielerkoordinaten aktivieren",
    ["Enable the right-click contextual menu"] = "Rechtsklick-Kontext-Men\195\188 aktivieren",
    ["Enable world map waypoints"] = "Weltkarten-Zielpunkte aktivieren",
    ["Enables a floating block that displays your current position in the current zone"] = "Aktiviert eine verschiebbare Infobox, welche die aktuelle Position in der aktuellen Zone anzeigt.",
    ["Enables a menu when right-clicking on a waypoint allowing you to clear or remove waypoints"] = "Aktiviert bei Rechtsklick auf einen Zielpunkt ein Men\195\188, womit Zielpunkte gel\195\182scht werden k\195\182nnen.",
    ["Enables a menu when right-clicking on the waypoint arrow allowing you to clear or remove waypoints"] = "Aktiviert bei Rechtsklick auf den Zielpunktpfeil ein Men\195\188, womit Zielpunkte gel\195\182scht werden k\195\182nnen.",
    ["Enables the automatic setting of quest objective waypoints based on which objective is closest to your current location.  This setting WILL override the setting of manual waypoints."] = "Aktiviert das automatische Setzen von Quest-Zielpunkten basierend auf der Entfernung zur aktuellen Position. Diese Einstellung hat VORRANG vor den Einstellungen f\195\188r manuelle Zielpunkte.",
    ["Enables the setting of waypoints when modified-clicking on quest objectives"] = "Aktiviert wenn beim Halten einer Kombinationstaste auf das Questziel geklickt wird.",
    ["Font size"] = "Schriftgr\195\182\195\159e",
    ["Found %d possible matches for zone %s.  Please be more specific"] = "%d m\195\182gliche Ziele f\195\188r Zone %s gefunden. Sei bitte genauer",
    ["Found multiple matches for zone '%s'.  Did you mean: %s"] = "Mehrere Ziele f\195\188r Zone '%s' gefunden. Meintest du: %s",
    ["Good color"] = "korrekte Richtung",
    ["IlarosNavi"] = "IlarosNavi",
    ["IlarosNavi can announce new waypoints to the default chat frame when they are added"] = "IlarosNavi kann neue Zielpunkte an den Standard-Chat senden, wenn sie hinzugef\195\188gt werden.",
    ["IlarosNavi can automatically set a waypoint when you die, guiding you back to your corpse"] = "IlarosNavi kann automatisch einen Zielpunkt setzen, wenn du stirbst, um dich so zu deiner Leicher zu leiten.",
    ["IlarosNavi can be configured to set waypoints for the quest objectives that are shown in the watch frame and on the world map.  These options can be used to configure these options."] = "IlarosNavi kann so konfiguriert werden, dass Zielpunkte auf die Questziele gesetzt werden, die in der Questverfolgung und auf der Weltkarte angezeigt werden. Diese Optionen k\195\182nnen genutzt werden, um die Questverfolgung zu konfigurieren.",
    ["IlarosNavi can display a tooltip containing information abouto waypoints, when they are moused over.  This setting toggles that functionality"] = "IlarosNavi kann Tooltips mit Informationen zu den Zielpunkten anzeigen, wenn die Maus sich dar\195\188ber befindet. Diese Einstellung schaltet diese Funktion ein oder aus.",
    ["IlarosNavi can display multiple waypoint arrows on the minimap.  These options control the display of these waypoints"] = "IlarosNavi kann mehrere Zielpunktpfeile in der Minikarte anzeigen. Diese Optionen steuern die Anzeige dieser Zielpunkte.",
    ["IlarosNavi can display multiple waypoints on the world map.  These options control the display of these waypoints"] = "IlarosNavi kann mehrere Zielpunktpfeile in der Weltkarte anzeigen. Diese Optionen steuern die Anzeige dieser Zielpunkte.",
    ["IlarosNavi can hide waypoints in other zones, this setting toggles that functionality"] = "IlarosNavi kann Zielpunkte in anderen Zonen verstecken. Diese Einstellung schaltet diese Funktion ein oder aus.",
    ["IlarosNavi is a simple navigation assistant"] = "IlarosNavi ist ein einfacher Navigationsassistent.",
    ["IlarosNavi is capable of providing data sources via LibDataBroker, which allows them to be displayed in any LDB compatible display.  These options enable or disable the individual feeds, but will only take effect after a reboot."] = "IlarosNavi ist in der Lage, Daten mittels LibDataBroker zu liefern, die in jeder LDB-kompatiblen Anzeige dargestellt werden k\195\182nnen. Diese Optionen aktivieren oder deaktivieren diese individuellen Feeds, wozu aber ein Neustart notwendig ist.",
    ["IlarosNavi provides an arrow that can be placed anywhere on the screen.  Similar to the arrow in \"Crazy Taxi\" it will point you towards your next waypoint"] = "IlarosNavi stellt einen Pfeil bereit, der \195\188berall auf dem Bildschirm plziert werden kann. Er zeigt die Richtung zum n\195\164chsten Zielpunkt.",
    ["IlarosNavi provides you with a floating coordinate display that can be used to determine your current position.  These options can be used to enable or disable this display, or customize the block's display."] = "IlarosNavi stellt eine Koordinatenbox bereit, welche die aktuelle Position anzeigt. Mit diesen Einstellungen k\195\182nnen die Funktion ein- und ausgeschaltet und die Darstellung ge\195\164ndert werden.",
    ["IlarosNavi waypoint"] = "IlarosNavi-Zielpunkt",
    ["IlarosNavi Waypoint Arrow"] = "IlarosNavi-Zielpunktpfeil",
    ["IlarosNavi's saved variables are organized so you can have shared options across all your characters, while having different sets of waypoints for each.  These options sections allow you to change the saved variable configurations so you can set up per-character options, or even share waypoints between characters"] = "IlarosNavis gespeicherte Einstellungen sind so organisiert, dass du gemeinsame Optionen f\195\188r all deine Charakter, aber unterschiedliche Zielpunkte f\195\188r jeden haben kannst. Dieser Einstellungsabschnitt erlaubt es, die gespeicherten Konfigurationen pro Charakter festzulegen oder Zielpunkte zu teilen.",
    ["Lock coordinate block"] = "Koordinatenbox fixieren",
    ["Lock waypoint arrow"] = "Zielpunktpfeil fixieren",
    ["Locks the coordinate block so it can't be accidentally dragged to another location"] = "Fixiert die Koordinatenbox, so dass sie nicht versehentlich verschoben werden kann.",
    ["Locks the waypoint arrow, so it can't be moved accidentally"] = "Fixiert den Zielpunktpfeil, so dass er nicht versehentlich verschoben werden kann.",
    ["Middle color"] = "seitliche Richtung",
    ["Minimap"] = "Minikarte",
    ["My Corpse"] = "Meine Leiche",
    ["No"] = "Nein",
    ["Options profile"] = "Einstellungsprofil",
    ["Options that alter the coordinate block"] = "Einstellungen der Koordinatenbox",
    ["Options that alter quest objective integration"] = "Einstellungen zur Questverfolgung",
    ["Play a sound when arriving at a waypoint"] = "Tonsignal bei Erreichen des Ziels abspielen",
    ["Player Coordinates"] = "Spielerkoordinaten",
    ["Player coordinate accuracy"] = "Koordinatengenauigkeit",
    ["Profile Options"] = "Profil-Einstellungen",
    ["Prompt before accepting sent waypoints"] = "Nachfragen, bevor Zielpunkte gesendet werden",
    ["Provide a LDB data source for coordinates"] = "LDB-Datenquelle f\195\188r Koordinaten bereitstellen",
    ["Provide a LDB data source for the crazy-arrow"] = "LDB-Datenquelle f\195\188r Zielpunktpfeil bereitstellen",
    ["Quest Objectives"] = "Questziele",
    ["Remove all waypoints"] = "Alle Zielpunkte l\195\182schen",
    ["Remove all waypoints from this zone"] = "Alle Zielpunkte f\195\188r diese Zone l\195\182schen",
    ["Remove waypoint"] = "Zielpunkt l\195\182schen",
    ["Reset Position"] = "Position zur\195\188cksetzen",
    ["Resets the position of the coordinate block if its been dragged off screen"] = "Setzt die Position der Koordinatenbox zur\195\188ck, wenn sie vom Bildschirm gezogen wurde.",
    ["Resets the position of the waypoint arrow if its been dragged off screen"] = "Setzt die Position des Zielpunktpfeils zur\195\188ck, wenn er vom Bildschirm gezogen wurde.",
    ["Save new waypoints until I remove them"] = "Neue Zielpunkte speichern, bis du sie l\195\182schst",
    ["Save profile for IlarosNavi waypoints"] = "Gespeicherte Profile f\195\188r IlarosNavi-Zielpunkte",
    ["Save this waypoint between sessions"] = "Zielpunkt zwischen den Sitzungen speichern",
    ["Saved profile for IlarosNavi options"] = "Gespeicherte Profile f\195\188r IlarosNavi-Einstellungen",
    ["Scale"] = "Skalierung",
    ["Send to battleground"] = "An Schlachtfeld senden",
    ["Send to guild"] = "An Gilde senden",
    ["Send to party"] = "An Gruppe senden",
    ["Send to raid"] = "An Schlachtzug senden",
    ["Send waypoint to"] = "Sende Zielpunkt an",
    ["Set as waypoint arrow"] = "Als Zielpunktpfeil setzen",
    ["set waypoint modifier"] = "Kombinationstaste",
    ["Show estimated time to arrival"] = "Gesch\195\164tze Ankunftszeit anzeigen",
    ["Shows an estimate of how long it will take you to reach the waypoint at your current speed"] = "Zeigt eine Sch\195\164tzung, wie lange du mit der aktuellen Geschwindigkeit brauchen wirst, um den Zielpunkt zu erreichen.",
    ["The color to be displayed when you are halfway between the direction of the active waypoint and the completely wrong direction"] = "Die Farbe des Pfeils, wenn die Blickrichtung seitlich zur Zielrichtung zeigt.",
    ["The color to be displayed when you are moving in the direction of the active waypoint"] = "Die Farbe des Pfeils, wenn die Blickrichtung zum Zielpunkt zeigt.",
    ["The color to be displayed when you are moving in the opposite direction of the active waypoint"] = "Die Farbe des Pfeils, wenn die Blickrichtung in die dem Zielpunkt entgegengesetzte Richtung zeigt.",
    ["The display of the coordinate block can be customized by changing the options below."] = "Die Anzeige der Koordinatenbox kann mit den folgenden Einstellungen ge\195\164ndert werden.",
    ["The floating waypoint arrow can change color depending on whether or nor you are facing your destination.  By default it will display green when you are facing it directly, and red when you are facing away from it.  These colors can be changed in this section.  Setting these options to the same color will cause the arrow to not change color at all"] = "Der bewegliche Zielpunktpfeil \195\164ndert seine Farbe in Abh\195\164ngikeit von der Blickrichtung zum Zielpunkt. Standardm\195\164\195\159ig ist er gr\195\188n, wenn du direkt zum Zielpunkt blickst, und rot in entgegengesetzter Richtung. Diese Farben k\195\182nnen hier eingestellt werden. Werden alle Farben auf den gleichen Wert gesetzt, \195\164ndert der Pfeil seine Farbe nicht.",
    ["There were no waypoints to remove in %s"] = "Es waren keine Zielpunkte zum L\195\182schen in %s da",
    ["These options let you customize the size and opacity of the waypoint arrow, making it larger or partially transparent, as well as limiting the size of the title display."] = "Mit diesen Optionen k\195\182nnen Gr\195\182\195\159e und Transparenz des Zielpunktfeils angepasst werden. Dadurch wird auch die Gr\195\182\195\159e der Titelanzeige begrenzt.",
    ["This option will not remove any waypoints that are currently set to persist, but only effects new waypoints that get set"] = "Das Ausschalten dieser Option l\195\182scht keine Zielpunkte, die fixiert wurden, sondern betrifft nur neu gesetzte Zielpunkte.",
    ["This option will toggle whether or not you are asked to confirm removing all waypoints.  If enabled, a dialog box will appear, requiring you to confirm removing the waypoints"] = "Diese Option bestimmt, ob du gefragt wirst, wenn du alle Zielpunkte l\195\182schen willst. Wenn sie aktiviert ist, erscheint eine Dialogbox, die eine Best\195\164tigung des L\195\182schvorgangs fordert.",
    ["This setting allows you to change the opacity of the title text, making it transparent or opaque"] = "Diese Einstellung erlaubt es, die Tansparenz des Titeltexts zu \195\164ndern und ihn durchscheinend oder deckend zu machen.",
    ["This setting allows you to change the opacity of the waypoint arrow, making it transparent or opaque"] = "Diese Einstellung erlaubt es, die Tansparenz des Zielpunktpfeils zu \195\164ndern und ihn durchscheinend oder deckend zu machen.",
    ["This setting allows you to change the scale of the waypoint arrow, making it larger or smaller"] = "Diese Einstellung erlaubt es, die Skalierung des Zielpunktpfeils zu \195\164ndern und ihn gr\195\182\195\159er oder kleiner zu machen.",
    ["This setting allows you to specify the maximum height of the title text.  Any titles that are longer than this height (in game pixels) will be truncated."] = "Diese Einstellung erlaubt es, die maximale H\195\182he (in Pixeln) des Titeltexts festzulegen. Titel, die diese H\195\182he \195\188berschreiten, werden abgeschnitten.",
    ["This setting allows you to specify the maximum width of the title text.  Any titles that are longer than this width (in game pixels) will be wrapped to the next line."] = "Diese Einstellung erlaubt es, die maximale Breite (in Pixeln) des Titeltexts festzulegen. Titel, die diese L\195\164nge \195\188berschreiten, werden auf die n\195\164chste Zeile umgebrochen.",
    ["This setting allows you to specify the scale of the title text."] = "Diese Einstellung erlaubt es, die Skalierung des Titeltexts festzulegen.",
    ["This setting changes the modifier used by IlarosNavi when right-clicking on a quest objective POI to create a waypoint"] = "Diese Einstellung \195\164ndert die Kombinationstaste, mit der mit Rechtsklick auf ein Questziel Zielpunkte erzeugt werden k\195\182nnen.",
    ["This setting changes the modifier used by IlarosNavi when right-clicking on the world map to create a waypoint"] = "Diese Einstellung \195\164ndert die Kombinationstaste, mit der mit Rechtsklick auf die Karte Zielpunkte erzeugt werden k\195\182nnen.",
    ["This setting will control the distance at which the waypoint arrow switches to a downwards arrow, indicating you have arrived at your destination"] = "Diese Einstellung steuert, bei welcher Entfernung sich der Zielpunktpfeil vom Richtungspfeil zum Abw\195\164rtspfeil wandelt, um anzuzeigen, dass du dein Ziel erreicht hast.",
    ["Title Alpha"] = "Titel-Transparenz",
    ["Title Height"] = "Titel-H\195\182he",
    ["Title Scale"] = "Titel-Skalierung",
    ["Title Width"] = "Titel-Breite",
    ["Unknown distance"] = "Unbekannte Entfernung",
    ["Unknown waypoint"] = "Unbekannter Zielpunkt",
    ["Wayback"] = "R\195\188ckweg",
    ["Waypoint Arrow"] = "Zielpunktpfeil",
    ["Waypoint from %s"] = "Zielpunkt von %s",
    ["Waypoint Options"] = "Zielpunkt-Optionen",
    ["Waypoints can be automatically cleared when you reach them.  This slider allows you to customize the distance in yards that signals your \"arrival\" at the waypoint.  A setting of 0 turns off the auto-clearing feature\n\nChanging this setting only takes effect after reloading your interface."] = "Zielpunkte k\195\182nnen automatisch gel\195\182scht werden, wenn sie erreicht wurden. Dieser Regler stellt die Entfernung in Metern ein, bei der der Zielpunkt als \"erreicht\" gilt.  Eine 0 als Einstellung schaltet die automatische Zielpunktl\195\182schung aus.\n\n\195\132nderungen werden erst nach einem Neuladen des Interfaces wirksam.",
    ["Waypoints profile"] = "Zielpunktprofil",
    ["When a new waypoint is added, IlarosNavi can automatically set the new waypoint as the \"Crazy Arrow\" waypoint."] = "Wurde ein neuer Zielpunkt hinzugef\195\188gt, kann IlarosNavi automatisch den Zielpunktpfeil darauf richten.",
    ["When the current waypoint is cleared (either by the user or automatically) and this option is set, IlarosNavi will automatically set the closest waypoint in the current zone as active waypoint."] = "Wenn der aktuelle Zielpunkt gel\195\182scht wird (automatisch oder manuell) und diese Option ist gesetzt, wird IlarosNavi automatisch den n\195\164chsten Zielpunkt in dieser Zone aktivieren.",
    ["When you 'arrive' at a waypoint (this distance is controlled by the 'Arrival Distance' setting in this group) a sound can be played to indicate this.  You can enable or disable this sound using this setting."] = "Wenn du an einem Zielpunkt 'ankommst' (die Entfernung wird durch die Einstellung 'Entfernung zum Ziel' gesteuert) kann ein Tonsignal abgespielt werden, um dies anzuzeigen. Mit dieser Einstellung wird es aktiviert oder deaktiviert.",
    ["World Map"] = "Weltkarte",
    ["Yes"] = "Ja",
    ["\"Arrival Distance\""] = "\"Entfernung zum Ziel\"",
    ["|cffffff78IlarosNavi |r/Navi |cffffff78Usage:|r"] = "|cffffff78IlarosNavi |r/Navi |cffffff78Benutzung:|r",
    ["|cffffff78/Navi <x> <y> [desc]|r - Adds a waypoint at x,y with descrtiption desc"] = "|cffffff78/Navi <x> <y> [desc]|r - setzt einen Zielpunkt bei x,y mit Beschreibung 'desc'",
    ["|cffffff78/Navi <zone> <x> <y> [desc]|r - Adds a waypoint at x,y in zone with description desc"] = "|cffffff78/Navi <zone> <x> <y> [desc]|r - setzt einen Zielpunkt bei x,y in Zone 'zone' mit Beschreibung 'desc'",
    ["|cffffff78/Navi reset all|r - Resets all waypoints"] = "|cffffff78/Navi reset all|r - l\195\182scht alle Zielpunkte",
    ["|cffffff78/Navi reset <zone>|r - Resets all waypoints in zone"] = "|cffffff78/Navi reset <zone>|r - l\195\182scht alle Zielpunkte in Zone 'zone'",

--Fehlermeldungen

    ["unknown argument"] = "unbekanntes Argument",
    ["invalid input"] = "ung\195\188ltige Eingabe",
    ["'%s' - expected 'on', 'off' or 'default', or no argument to toggle."] = "'%s' - erwartet 'on', 'off' oder 'default' oder kein Argument, um umzuschalten.",
    ["'%s' - expected 'on' or 'off', or no argument to toggle."] = "'%s' - erwartet 'on' der 'off' oder kein Argument, um umzuschalten.",
    ["expected number"] = "Zahl erwartet",
    ["must be equal to or higher than %s"] = "muss gleich oder gr\195\182\195\159er als %s sein",
    ["must be equal to or lower than %s"] = "muss gleich oder kleiner als %s sein",
    ["unknown selection"] = "unbekannte Auswahl",
    ["'%s' - expected 'RRGGBBAA' or 'r g b a'."] = "'%s' - erwartet 'RRGGBBAA' oder 'r g b a'.",
    ["'%s' - values must all be either in the range 0..1 or 0..255."] = "'%s' - Werte m\195\188ssen alle entweder im Bereich 0..1 oder 0..255 liegen.",
    ["'%s' - expected 'RRGGBB' or 'r g b'."] = "'%s' - erwartet 'RRGGBB' oder 'r g b'.",
    ["'%s' - values must all be either in the range 0-1 or 0-255."] = "'%s' - Werte m\195\188ssen alle entweder im Bereich 0-1 oder 0-255 liegen.",
    ["'%s' - Invalid Keybinding."] = "'%s' - Ung\195\188ltige Tastenzuweisung.",
    ["Options for |cffffff78"] = "Optionen f\195\188r |cffffff78",
    ["|r (multiple possible):"] = "|r (mehrere m\195\182glich):",

}

    -- Chat-Benachrichtigungen
    NaviText_FName       = "|cffffff00IlarosNavi für Tec's Ilaros WoW|r"
    NaviText_FVer        = "|cffffff00Version %s|r"

    NaviText_HWorld      = "|cffffff78IlarosNavi:|r Alle Weltkartenkoordinaten wurden ausgeblendet."
    NaviText_SWorld      = "|cffffff78IlarosNavi:|r Alle Weltkartenkoordinaten wurden eingeblendet."
    NaviText_HCursor     = "|cffffff78IlarosNavi:|r Cursorkoordinaten auf der Weltkarte wurden ausgeblendet."
    NaviText_SCursor     = "|cffffff78IlarosNavi:|r Cursorkoordinaten auf der Weltkarte wurden eingeblendet."
    NaviText_HWPlayer    = "|cffffff78IlarosNavi:|r Spielerkoordinaten auf der Weltkarte wurden ausgeblendet."
    NaviText_SWPlayer    = "|cffffff78IlarosNavi:|r Spielerkoordinaten auf der Weltkarte wurden eingeblendet."
    NaviText_HPortrait   = "|cffffff78IlarosNavi:|r Alle Portraitkoordinaten wurden ausgeblendet."
    NaviText_SPortrait   = "|cffffff78IlarosNavi:|r Alle Portraitkoordinaten wurden eingeblendet."
    NaviText_HAParty     = "|cffffff78IlarosNavi:|r Alle Gruppenportraitkoordinaten wurden ausgeblendet."
    NaviText_SAParty     = "|cffffff78IlarosNavi:|r Alle Gruppenportraitkoordinaten wurden eingeblendet."
    NaviText_HPlayer     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des Spielers wurden ausgeblendet."
    NaviText_SPlayer     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des Spielers wurden eingeblendet."
    NaviText_HParty1     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des ersten Mitspielers wurden ausgeblendet."
    NaviText_SParty1     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des ersten Mitspielers wurden eingeblendet."
    NaviText_HParty2     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des zweiten Mitspielers wurden ausgeblendet."
    NaviText_SParty2     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des zweiten Mitspielers wurden eingeblendet."
    NaviText_HParty3     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des dritten Mitspielers wurden ausgeblendet."
    NaviText_SParty3     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des dritten Mitspielers wurden eingeblendet."
    NaviText_HParty4     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des vierten Mitspielers wurden ausgeblendet."
    NaviText_SParty4     = "|cffffff78IlarosNavi:|r Portraitkoordinaten des vierten Mitspielers wurden eingeblendet."
    NaviText_WPSet       = "|cffffff78IlarosNavi:|r Zielpunkt %sbei %s in %s gesetzt."
    NaviText_WPUnset     = "|cffffff78IlarosNavi:|r Zielpunkt %sbei %0.2f, %0.2f in %s gelöscht."
    NaviText_WPUnsetAll  = "|cffffff78IlarosNavi:|r Alle Zielpunkte gelöscht."
    NaviText_WPUnsetZone = "|cffffff78IlarosNavi:|r Alle Zielpunkte in %s gelöscht."
    NaviText_WPUnsetNo   = "|cffffff78IlarosNavi:|r Keine Zielpunkte in %s gefunden."
    NaviText_WPSent      = "|cffffff78IlarosNavi:|r Zielpunkt '%s' in Zone %s wurde von %s gesendet."


    -- Chat-Hilfetexte
    NaviText_SLASH1 = "|cffff38ffIlarosNavi-Kommandos:|r"
NaviText_SLASH2 = "-- Weltkartenkoordinaten --"
NaviText_SLASH3 = "-- Portraitkoordinaten --"
NaviText_SLASH4 = "Cursor: "
NaviText_SLASH5 = "Spieler: "
NaviText_SLASH6 = "-- Wegpunkte --"

NaviText_WMON   = "|cffff78ff/Navi a|r - Alle Koordinaten auf der Weltkarte aus"
NaviText_WMOFF  = "|cffff78ff/Navi a|r - Alle Koordinaten auf der Weltkarte ein"
NaviText_WMCON  = "|cffff78ff/Navi c|r - Cursorkoordinaten auf der Weltkarte aus"
NaviText_WMCOFF = "|cffff78ff/Navi c|r - Cursorkoordinaten auf der Weltkarte ein"
NaviText_WMPON  = "|cffff78ff/Navi s|r - Spielerkoordinaten auf der Weltkarte aus"
NaviText_WMPOFF = "|cffff78ff/Navi s|r -- Spielerkoordinaten auf der Weltkarte ein"
NaviText_APON   = "|cff78ffff/Navi p|r - alle Portraitkoordinaten aus"
NaviText_APOFF  = "|cff78ffff/Navi p|r - alle Portraitkoordinaten ein"
NaviText_YPON   = "|cff78ffff/Navi p0|r - alle Spielerkoordinaten aus"
NaviText_YPOFF  = "|cff78ffff/Navi p0|r - alle Spielerkoordinaten ein"
NaviText_APMON  = "|cff78ffff/Navi g|r - alle Gruppen-Portrait-Koordinaten aus"
NaviText_APMOFF = "|cff78ffff/Navi g|r - alle Gruppen-Portrait-Koordinaten ein"
NaviText_P1ON   = "|cff78ffff/Navi p1|r - erste Gruppenkoordinaten aus"
NaviText_P1OFF  = "|cff78ffff/Navi p1|r - erste Gruppenkoordinaten ein"
NaviText_P2ON   = "|cff78ffff/Navi p2|r - zweite Gruppenkoordinaten aus"
NaviText_P2OFF  = "|cff78ffff/Navi p2|r - zweite Gruppenkoordinaten ein"
NaviText_P3ON   = "|cff78ffff/Navi p3|r - dritte Gruppenkoordinaten aus"
NaviText_P3OFF  = "|cff78ffff/Navi p3|r - dritte Gruppenkoordinaten ein"
NaviText_P4ON   = "|cff78ffff/Navi p4|r - vierte Gruppenkoordinaten aus"
NaviText_P4OFF  = "|cff78ffff/Navi p4|r - vierte Gruppenkoordinaten ein"
NaviText_VER    = "|cffffff78/Navi v|r - Versionsinformation"
NaviText_OPT    = "|cffffff78/Navi k|r - Konfigurationsfenster öffnen"
NaviText_WAY1   = "|cffffff78/Navi n|r - Zielpfeil auf nächsten Zielpunkt richten"
NaviText_WAY2   = "|cffffff78/Navi h|r - Zielpunkt am aktuellen Ort erzeugen"
NaviText_WAY3   = "|cffffff78/Navi [zone] <x> <y> [name]|r - Zielpunkt bei x,y in Zone 'zone' mit Name 'name' erzeugen, Zone und Name sind optional"
NaviText_WAY4   = "|cffffff78/Navi reset all|r - alle Zielpunkte l\195\182schen"
NaviText_WAY5   = "|cffffff78/Navi reset <zone>|r - alle Zielpunkte in Zone 'zone' löschen"

    -- Konfigurationsfenster
    -- Hauptfenster
    NaviText_WMOP       = "Weltkarten-Koordinaten:"
    NaviText_WMOP1      = "Spielerkoordinaten anzeigen"
    NaviText_WMOP2      = "Cursoroordinaten anzeigen"
    NaviText_PTOP       = "Portraitkoordinaten:"
    NaviText_PTP        = "Koordinaten unter Spielerportrait anzeigen"
    NaviText_PTG1       = "Koordinaten f\195\188r Gruppenmitglied 1 anzeigen"
    NaviText_PTG2       = "Koordinaten f\195\188r Gruppenmitglied 2 anzeigen"
    NaviText_PTG3       = "Koordinaten f\195\188r Gruppenmitglied 3 anzeigen"
    NaviText_PTG4       = "Koordinaten f\195\188r Gruppenmitglied 4 anzeigen"
    NaviText_MOP        = "Genauigkeit:"
    NaviText_SDCD       = "Dezimale der Koordinaten (gilt nicht für Koordinatenbox)"
    NaviText_HINT       = "Im Chat eingeben:\n\n|cffffff78/Navi|r für Kommando-Übersicht\n|cffffff78/Navi k|r für dieses Konfigurationsfenster"
    -- allgemeine Einstellungen
    NaviText_GOPT       = "Allgemeine Einstellungen"

setmetatable(IlarosNaviLocals, {__index=function(t,k) rawset(t, k, k); return k; end})

end

