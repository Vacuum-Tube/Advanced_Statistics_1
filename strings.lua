function data()
return {
	en = {
		mod_name = "Advanced Statistics",
		mod_desc = [[
This mod will show you additional statistics and extensive information in the game.
It can be added/removed every time.

[Description also in game]

Did you ever wanted to know...
[list]
[*]How long you played on a savegame (real/game time)?
[*]More summarized information about towns (Reachability, Cargo Supply)?
[*]More summarized information about industries (Levels, Production)?
[*]How many persons there are really simulated?
[*]Which people are walking, driving or using lines?
[*]For how long people have been waiting at a station?
[*]How much cargo is on its way or waiting at stations?
[*]The employment rate of town buildings?
[*]How many person capacities there are at a certain area (incl. person magnets)?
[*]How many vehicles are waiting or stopped?
[*]How long the (player owned) street network is?
[*]What percentage of the tracks are electrified?
[*]Which track types you used and where?
[*]Information about street/track speed, curve radius and slope?
[*]How many traffic lights there are in a town?
[*]How many trees there are on the map?
[*]How many additional street/track/bridge types, models, etc. there are with mods?
[/list]
If you like statistics, this mod is right for you.


[h2]Structure[/h2]
The statistics are contained in a window that is displayed at startup.
They are read from the game sorted by entity types, evaluated and displayed in a tabwidget. Additionally there is general information about the game and application.

For each tab/datatype, a short info can be displayed in the game bar. A click opens the corresponding tab directly. In addition, there is a button in the game bar on the far right to open the window.

Eventually, the mass of information may seem overwhelming at first. I tried to present all relevant and interesting data as compactly and clearly as possible. Nevertheless, you have to deal with it a bit and try it out to understand the different values.
Some elements have tooltips (hold cursor on them) with additional explanations.
For experienced users there is a setting for even more data.


[h2]Selection[/h2]
There are 3 ways to specify which items are included in the statistics (for most types): [list]
[*][b]Global -[/b] All objects of this type on the whole map
[*][b]View -[/b] All objects in the current view (white circle)
[*][b]Radius -[/b] All objects in the white circle (radius changeable)
[/list]

[h2]Calculations[/h2]
Because of the numerous calculations and iteration over all objects in the game, the calculation time is significant. Therefore, the runtimes are displayed to keep track of them.
Normally the statistics are only updated when the corresponding tab is selected/visible.
To keep the values in the gamebar up to date, you can also activate the permanent background execution in the settings. However, this is only possible to a limited extent, depending on data type and savegame progress.
If the total runtime exceeds 200ms, this leads to lagging in the simulation. This can also be controlled with the debug window (debug mode on, 2x AltGr+i, the lower one).


[h2]Problems/Bugs[/h2]
I have tested the mod extensively, but I can't exclude possible bugs. That's why I included an error handler to prevent the game from crashing. In such a case, a window will be displayed. 
But all information is also written into the [u][url=https://www.transportfever2.com/wiki/doku.php?id=gamemanual:gamefilelocations ]stdout txt[/url][/u]. In that case, please set the log level to 2 in the mod settings, reproduce the error and send me the stdout file.


[h2]Background[/h2]
This project is by far the biggest and most elaborate mod I have created for Transport Fever 2.
The first ideas started already a year ago. The statistics available in the game were just not sufficient enough for me. So it started with graphically displaying single values like game time, total population and other data about towns and industries.
With the time the project became bigger and bigger, because I also wanted to include information of the other entity types (vehicles, assets, people, tracks...). Also, with the modding update last summer, even more possibilities were available.
With time I learned a lot about the game, the (gui) modding interface and programming with Lua. So the next step always remained small and made it possible to add even more information in a compact and flexible way. The finished result always seemed close, but due to the volume (to extract everything interesting from the game what's possible) and many details, the project dragged on very long, which I underestimated in the beginning. 
To get an impression of the size of the project: It consists of 87 script files.


[h2]Acknowledgements[/h2]
Although I encountered some technical issues during development, I would like to thank Urban Games for the support and the modding possibilities.
A big thanks goes to eis_os and CommonAPI2, whose console and inspector tools were very useful during development.
Furthermore, I would like to thank the beta testers for the useful comments.


[h2]Code and future development[/h2]
The source code of this mod is available on GitHub: https://github.com/Vacuum-Tube/Advanced_Statistics_1
I have some ideas for the future. Anyway, I need a break from programming now.

]],
		mod_desc_paypal = [[If you like to support my mod development, you can donate here]],
		mod_desc_discussion = [[
If you have feedback, suggestions, bugs, crashes or questions about the stats itself, please use the appropriate subforum below.
]],

		welcome_text = [[
Today is the ${date} and your account balance is ${balance}.

There are ${towns} Towns and ${industries} Industries on this map.
The number of simulated Persons is ${persons}.

Your transport company owns ${vehicles} Vehicles on ${lines} Lines.
The length of your rail network is ${tracklength} (${percelectrified} electrified).
The length of your owned streets is ${streetlength}.

You have played ${gametime} on this savegame.

The real time is now:  ${realtime}
]],

		RESIDENTIAL = "Residential",
		COMMERCIAL = "Commercial",
		INDUSTRIAL = "Industrial",
		
		ALL = "All",
		ROAD = "Road",
		RAIL = "Rail",
		TRAM = "Tram",
		AIR = "Air",
		WATER = "Water",
		TRACK = "Track",
		STREET = "Street",
		
		EN_ROUTE = "En route",
		AT_TERMINAL = "At terminal",
		GOING_TO_DEPOT = "Going to depot",
		IN_DEPOT = "In depot",
		
		SIGNAL = "Standard Signal",
		ONE_WAY_SIGNAL = "One-way Signal",
		WAYPOINT = "Waypoint",
		
		ConstructionJournal = "Construction",  -- has different meanings in the game...
		NotesTFHint = "Notes, ToDo, ...",
		NotesTFTT = "You can use this for personal notes, ToDo Lists, etc.",
		gameLoadTT = "Initialization of gamscript, a bit later than pressing Load Button",
		loadingTimeTT = "Time from Script Initialization till Game Start",
		programStartTT = "Start of the application",
		gameStartTT = "Gui Initialization",
		gametimeTT = "Internal Game time that is controlled directly with Pause/Forward",
		gametimeTotTT = "As above except that this also includes pause times",
		TownSizeTT = "The 'size' of towns is defined as (RES+COM+IND)/3",
		GrowthFactorTT = "Ratio between current capacities and base values",
		PersonCountVisTT = [[Number of visible persons/cars that are currently on their way (moving and at terminal).
The stats only includes data from these persons.]],
		PersonCountAllTT = [[Number of all persons that are simulated.
Not all of them are moving on the map at the same time and eventually not all of them even have destinations.
But the path searching probably takes place for all of them.
The number of persons at buildings should be: All - Visible - in Vehicles]],
		DifTownsCountTT = "Persons can have their destinations in 1, 2 or 3 different towns",
		CargoVisibleTT = [[Visible cargo entities includes only cargo models at station terminals and industry stocks.
Unfortunately, this also means that the number doesn't match the total amount of cargo units because they are summarized with one bigger model.
The cargo in vehicles is not included here but below and contains the right amount of units.]],
		fencesTT = "Fences from Snowball",
		edgeLengthTT = "Deviation from HQ Statistics may occur because of an approximation",
		NodeDegreeTT = "Number of adjacent streets/tracks at a node/crossing",
		FareTT = "Global Fare Value (?) (api.engine.system.simEntityAtVehicleSystem.getFare)",
		StationGroupTT = "Station Groups combine single Stations like bus/tram station at both sides",
		TransportSamplesTT = "I don't know exactly what this is but it has something to do with passenger stations and person destinations",
		ReachabilityTT = [[The values are related to the total number of available destinations.
The maximum is probably: (Capacities.COM+Capacities.IND) / 2 
which will be about 'Total Size' (if landuse is evenly distributed)]],
		VehicleWaitingTT = "Speed is 0 and not stopped or at terminal",
		RadiusViewTT = "Click to update",
		gamebarInsertSet = "Insert left in Gamebar",
		gamebarInsertSetTT = "Otherwise add right",
		hideGameInfoSet = "Hide Gameinfo",
		hideGameInfoSetTT = "The 'Transported' data (instead visible in game tab)",
		advadvTT = "Show additional data elements",
		showWindowSet = "Show window at start",
		startSoundSet = "Startup Sound Notifications",
		startSoundSetTT = [[Play Sound after the game has loaded. 
The first sound indicates guiInit (the start of the black screen), the second one the gui initialisation of the statistics window.]],
		SetDatatypeTT = [[
The game consists of entities of different types. 
This mod is structured by reading and summarizing the data seperatly of those entity (pseudo) types.]],
		SetRuntimeTT = [[
The calculation is executed in the game/script thread, which runs 5 times per second (200 ms). 
Some calculations may take a while because of the iteration over all objects. 
The duration depends on the entity type and the number of objects in the game or in the current view.
If all game update calculations exceed 200 ms, the game simulation starts to stutter. 
You can also control this with the debug window (debug mode on, 2x AltGr+i, the lower)]],
		SetRunTT = [[
In general, the calculations for the statistics are only executed if the corresponding data tab is selected.
Here you can select, if a specific data type shall be calculated always. 
This will keep the game bar values up to date. 
But don't activate too many ones with long execution times, this will lead to simulation lags.
In the early game you can activate more than in the late game.]],
		SetGamebarTT = [[This shows short information in the game bar.]],
		
	},
	
	
	
	de = {
		mod_desc = [[
Diese Mod zeigt dir erweiterte Statistiken und umfassende Informationen im Spiel an.
Sie kann jederzeit hinzugefügt/entfernt werden.

[Beschreibung auch im Spiel]

Du wolltest schon immer wissen... 
[list]
[*]Wie lange du an einem Savegame spielst (Echtzeit/Spielzeit)?
[*]Mehr zusammengefasste Informationen über Städte (Erreichbarkeit, Güterversorgung)?
[*]Mehr zusammengefasste Informationen über Industrien (Levels, Produktion)?
[*]Wie viele Personen wirklich simuliert werden?
[*]Welche Personen laufen, fahren Auto oder benutzen Linien?
[*]Wie lange die Leute schon an einer Station warten?
[*]Wie viel Güter unterwegs sind oder an Stationen warten?
[*]Wie hoch die Arbeitslosenquote der Stadtgebäude ist?
[*]Wie viele Personenkapazitäten in einem bestimmten Bereich sind (inkl. Personenmagneten)?
[*]Wieviele Fahrzeuge gerade warten oder gestoppt sind?
[*]Wie lang das (spielereigene) Straßennetz ist?
[*]Wieviel Prozent der Gleise elektrifiziert sind?
[*]Welche Gleistypen wo verwendet wurden?
[*]Informationen zu Straßen/Gleis Geschwindigkeit, Kurvenradius und Steigung?
[*]Wie viele Ampeln es in einer Stadt gibt?
[*]Wie viele Bäume auf der Karte sind?
[*]Wieviele zusätzlichen Straßen-/Gleis-/Brückentypen, Modelle, etc. es gibt mit Mods?
[/list]
Wenn du Statistiken magst, dann ist diese Mod das Richtige für dich.


[h2]Aufbau[/h2]
Die Statistiken sind in einem Fenster enthalten, welches beim Start angezeigt wird.
Diese werden nach Entity Typen sortiert aus dem Spiel ausgelesen, ausgewertet und in einem Tabwidget angezeigt. Zusätzlich sind dort allgemeine Informationen zum Spiel und Programm vorhanden.

Für jeden Tab/Datentyp kann eine Kurzinfo in der Game Bar (Spielleiste unten) angezeigt werden. Ein Klick öffnet direkt den zugehörigen Tab. Zusätzlich befindet sich in der Game Bar ganz rechts ein Button zum Öffnen des Fensters.

Eventuell kann die Masse an Informationen anfangs überfordernd wirken. Ich habe versucht, alle relevanten und interessanten Werte möglichst kompakt und übersichtlich darzustellen. Man muss sich trotzdem etwas damit befassen und ausprobieren, um die verschiedenen Daten zu verstehen.
Einige Elemente besitzen Tooltips (Cursor drauf halten) mit zusätzlichen Erklärungen.
Für erfahrene Nutzer gibt es eine Einstellung für noch mehr Daten.


[h2]Auswahl[/h2]
Es gibt 3 Möglichkeiten anzugeben, welche Objekte in die Statistik mit einfließen (bei den meisten Typen): [list]
[*][b]Global -[/b] Alle Objekte dieses Typs auf der gesamten Karte
[*][b]Ansicht -[/b] Alle Objekte in der aktuellen Ansicht (weißer Kreis)
[*][b]Radius -[/b] Alle Objekte im weißen Kreis (Radius änderbar)
[/list]

[h2]Berechnungen[/h2]
Wegen der zahlreichen Berechnungen und Iteration über alle Objekte im Spiel, ist die Rechendauer nicht unerheblich. Daher werden die Laufzeiten angezeigt, um diese im Blick zu behalten.
Normalerweise werden die Statistiken nur aktualisiert, wenn der entsprechende Tab sichtbar ist.
Damit die Werte in der Gamebar aktuell bleiben, kann man in den Einstellungen auch die dauerhafte Ausführung im Hintergrund aktivieren. Das ist aber je nach Datentyp und Größe des Spielstands nur begrenzt möglich.
Übersteigt die Gesamtlaufzeit 200ms, führt das in der Simulation zum Ruckeln. Dies lässt sich auch mit dem Debug Fenster kontrollieren (Debug Modus an, 2x AltGr+i, das untere).


[h2]Probleme/Bugs[/h2]
Ich habe die Mod ausführlichst getestet, kann aber mögliche Fehler nicht ausschließen. Deswegen habe ich einen Error Handler eingebaut, damit das Spiel nicht abstürzt. In einem solchen Fall wird ein Fenster angezeigt. 
Alle Informationen werden aber auch in die [u][url=https://www.transportfever2.com/wiki/doku.php?id=gamemanual:gamefilelocations ]stdout txt[/url][/u] geschrieben. Diese bräuchte ich in dem Fall. Bitte dann in den Mod Einstellungen das Log Level auf 2 setzen und den Fehler reproduzieren.


[h2]Hintergrund[/h2]
Dieses Projekt ist mit Abstand die größte und aufwändigste Mod, die ich für Transport Fever 2 erstellt habe.
Die ersten Ideen begannen bereits vor einem Jahr. Die im Spiel verfügbaren Statistiken waren mir einfach nicht umfangreich genug. Es begann also damit, einzelne Werte wie die Spielzeit, die Gesamteinwohnerzahl und weitere Daten zu Städten und Industrien grafisch anzuzeigen.
Mit der Zeit wurde das Projekt immer größer, da ich auch Informationen der anderen Entity Typen (Fahrzeuge, Assets, Personen, Gleise...) auswerten wollte. Außerdem kamen mit dem Modding Update letzten Sommer noch mehr Möglichkeiten hinzu.
Mit der Zeit lernte ich viel über das Spiel, die (Gui-)Modding Schnittstelle und das Programmieren mit Lua dazu. Somit blieb der nächste Schritt immer gering und machte es möglich, noch mehr Informationen kompakt und flexibel hinzuzufügen. Das fertige Ergebnis schien immer nah, aber durch den Umfang (alles interessante aus dem Spiel auszulesen was geht) und viele Details zog sich das Projekt sehr in die Länge, was ich anfangs unterschätzt habe. 
Um einen Eindruck von der Größe des Projekts zu bekommen: Es besteht aus 87 Skript-Dateien.


[h2]Danksagung[/h2]
Obwohl ich bei der Entwicklung auf einige technische Schwierigkeiten gestoßen bin, möchte ich Urban Games für den Support und die Modding Möglichkeiten danken.
Ein großes Danke geht an eis_os und CommonAPI2, dessen Konsole und Inspektor Tools bei der Entwicklung äußerst hilfreich waren.
Desweiteren bedanke ich mich für die nützlichen Kommentare der Beta-Tester.


[h2]Code und Weiterentwicklung[/h2]
Der Quellcode zur Mod ist auf GitHub verfügbar: https://github.com/Vacuum-Tube/Advanced_Statistics_1
Ich habe auch zahlreiche Ideen für die Weiterentwicklung. Allerdings brauche ich jetzt erstmal eine Pause vom Programmieren.

]],
		mod_desc_paypal = [[Wenn du meine Mod Entwicklung unterstützen möchtest, würde ich mich über eine Spende freuen]],
		mod_desc_discussion = [[
Für Feedback, Vorschläge, Bugs, Crashes oder Fragen zu den Statistiken selbst, bitte das entsprechende Diskussionsforum hier drunter benutzen.
]],

		welcome_text = [[
Heute ist der ${date} und dein Kontostand beträgt ${balance}.

Auf der Karte befinden sich ${towns} Städte und ${industries} Industrien.
Die Anzahl der simulierten Personen ist ${persons}.

Dein Transport Unternehmen besitzt ${vehicles} Fahrzeuge auf ${lines} Linien.
Die Länge deines Schienennetzes beträgt ${tracklength} (${percelectrified} elektrifiziert).
Die Länge der spielereigenen Straßen ist ${streetlength}.

Du hast ${gametime} auf diesem Spielstand gespielt.

Die echte Zeit ist jetzt:  ${realtime}
]],
		
		RESIDENTIAL = "Wohngebäude",
		COMMERCIAL = "Geschäfte",
		INDUSTRIAL = "Industrie",
		ALL = "Alle",
		ROAD = "Straße",
		RAIL = "Schiene",
		TRAM = "Tram",
		AIR = "Luft",
		WATER = "Wasser",
		TRACK = "Gleise",
		STREET = "Straße",
		EN_ROUTE = "Unterwegs",
		AT_TERMINAL = "An Terminal",
		GOING_TO_DEPOT = "Auf dem Weg zum Depot",
		IN_DEPOT = "Im Depot",
		SIGNAL = "Standard Signal",
		ONE_WAY_SIGNAL = "Einweg Signal",
		WAYPOINT = "Wegpunkt",
		
		General = "Allgemein",
		general = "Allgemein",
		Settings = "Einstellungen",
		settings = "Einstellungen",
		welcome = "Willkommen",
		program = "Programm",
		info = "Info",
		Now = "Jetzt",
		All = "Alle",
		None = "Keine",
		Both = "Beide",
		Only = "Nur",
		Always = "Immer",
		State = "Status",
		States = "Status",
		Runtime = "Laufzeit",
		Run = "Ausführen",
		Not = "Nicht",
		More = "Mehr",
		Count = "Anzahl",
		Groups = "Gruppen",
		Size = "Größe",
		Average = "Durchschnitt",
		Sum = "Summe",
		Total = "Gesamt",
		Active = "Aktiv",
		Deactivated = "Deaktiviert",
		List = "Liste",
		On = "An",
		Off = "Aus",
		Notes = "Notizen",
		Balance = "Kontostand",
		Loan = "Kredit",
		Income = "Einnahmen",
		Maintenance = "Unterhalt",
		Acquisition = "Eigentum",
		ConstructionJournal = "Bauinvestitionen",
		Interest = "Zinsen",
		Vehicles = "Fahrzeuge",
		Trees = "Bäume",
		Rocks = "Steine",
		Condition = "Zustand",
		Age = "Alter",
		Walk = "Laufen",
		Car = "Auto",
		Line = "Linie",
		Lines = "Linien",
		Fare = "Ticketpreis",
		Open = "Offen",
		Closed = "Geschlossen",
		Latest = "Neustes",
		Oldest = "Ältestes",
		Growth = "Wachstum",
		Capacities = "Kapazitäten",
		Buildings = "Gebäude",
		Depth = "Tiefe",
		Height = "Höhe",
		Development = "Entwicklung",
		Reachability = "Erreichbarkeit",
		Destinations = "Ziele",
		Town = "Stadt",
		Towns = "Städte",
		supplied = "beliefert",
		partially = "teilweise",
		completely = "komplett",
		Other = "Andere",
		View = "Ansicht",
		Types = "Typen",
		Transported = "Transportiert",
		Frequency = "Frequenz",
		Slope = "Steigung",
		Production = "Produktion",
		Shipping = "Versand",
		Produced = "Produziert",
		Shipped = "Versendet",
		Consumed = "Konsumiert",
		Bridge = "Brücke",
		Tunnel = "Tunnel",
		Model = "Modell",
		Models = "Modelle",
		Inactive = "Inaktiv",
		Segments = "Segmente",
		Constructions = "Konstruktionen",
		Stations = "Stationen",
		Signals = "Signale",
		Persons = "Personen",
		Animals = "Tiere",
		Connected = "Verbunden",
		Isolated = "Isoliert",
		Crossing = "Kreuzung",
		Vacant = "Unbesetzt",
		Employed = "Angestellt",
		Fences = "Zäune",
		Stopped = "Gestoppt",
		Availability = "Verfügbarkeit",
		Filenames = "Dateinamen",
		Visible = "Sichtbar",
		Waiting = "Warten",
		Stops = "Haltestellen",
		Loaded = "Geladen",
		Unloaded = "Entladen",
		Activation = "Aktivierung",
		
		["Welcome back"] = "Willkommen zurück",
		["Program Startup"] = "Program Start",
		["Game Load"] = "Spiel Laden",
		["Game Start"] = "Spiel Start",
		["Map Size"] = "Kartengröße",
		["No Costs"] = "Keine Kosten",
		["Program Time"] = "Programzeit",
		["Game Time"] = "Spielzeit",
		["Game Date"] = "Spieldatum",
		["Loading Time"] = "Ladezeit",
		["Last Update"] = "Letztes Update",
		["Game Information"] = "Spiel Informationen",
		["Transported Passengers"] = "Transportierte Passagiere",
		["Transported Cargo"] = "Transportierte Güter",
		["Company Score"] = "Unternehmen Punktzahl",
		["Game Difficulty"] = "Spiel Schwierigkeit",
		["Simulation Speed"] = "Simulation Geschwindigkeit",
		["Milliseconds per day"] = "Millisekunden pro Tag",
		["Maximum Loan"] = "Maximaler Kredit",
		["Current Speed"] = "Aktuelle Geschwindigkeit",
		["Move Mode"] = "Bewegungsart",
		["Current Destination"] = "Aktuelles Ziel",
		["and"] = "und",
		["Last Activated"] = "Zuletzt aktiviert",
		["Never Activated"] = "Nie aktiviert",
		["Last Used"] = "Zuletzt benutzt",
		["Never Used"] = "Nie benutzt",
		["Growth Factor"] = "Wachstumsfaktor",
		["Particle Emitters"] = "Rauchquellen",
		["On the way"] = "Unterwegs",
		["Cargo Supply"] = "Güterversorgung",
		["Cargo Types"] = "Gütertypen",
		["Ticket Price"] = "Ticketpreis",
		["Vehicle Parts"] = "Anzahl Waggons/Lokomotiven",
		["Cargo Entities"] = "Güter Einheiten",
		["Cargo Loading"] = "Güter Beladung",
		["Vehicle Loading"] = "Fahrzeug Beladung",
		["Vehicles with Cargo"] = "Fahrzeuge mit Ladung",
		["Last Destination Update"] = "Letztes Ziel Update",
		["Number of different Towns"] = "Anzahl unterschiedlicher Städte",
		["all same"] = "alle gleich",
		["two equal"] = "zwei gleich",
		["all different"] = "alle unterschiedlich",
		["Speed Limit"] = "Geschwindigkeitsbegrenzung",
		["Curve Speed Limit"] = "Geschwindigkeitsbegrenzung Kurve",
		["Curve Radius"] = "Kurvenradius",
		["Bus Lane"] = "Busspur",
		["Tram Electric"] = "Tram Elektrisch",
		["Player Owned"] = "Spielereigentum",
		["Travel Time"] = "Reisedauer",
		["Current Travel Time"] = "Aktuelle Reisedauer",
		["Double Slip Switches"] = "Doppelkreuzweichen",
		["Traffic Lights"] = "Ampeln",
		["Waiting Cargo"] = "Wartende Güter",
		["At stock"] = "Im Lager",
		["At terminal"] = "An Terminal",
		["Moving"] = "In Bewegung",--"Unterwegs",
		["in Vehicles"] = "in Fahrzeugen",
		["Waiting Time"] = "Wartezeit",
		["Build Cost"] = "Baukosten",
		["Maintenance Cost"] = "Wartungskosten",
		["Railroad Crossings"] = "Bahnübergänge",
		["Town Buildings"] = "Stadtgebäude",
		["Person Capacity"] = "Personenkapazität",
		["Placeholder Cubes"] = "Platzhalter Würfel",
		["Donate"] = "Spenden",
		["Thank You"] = "Danke",
		
		NotesTFHint = "Notizen, ToDo, ...",
		NotesTFTT = "Du kannst dieses Feld für persönliche Notizen, ToDo Listen, etc. benutzen",
		gamebarInsertSet = "In Gamebar links einfügen",
		gamebarInsertSetTT = "Andernfalls rechts hinzufügen",
		hideGameInfoSet = "Gameinfo ausblenden",
		hideGameInfoSetTT = "Die Daten zu 'Transportiert' (sind stattdessen im Game tab)",
		advadvTT = "Zusätzliche Daten anzeigen",
		showWindowSet = "Fenster beim Start anzeigen",
		startSoundSet = "Sound Benachrichtigungen beim Start",
	}
}
end