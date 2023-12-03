function data()
return {
	en = {
		mod_name = "Advanced Statistics",
		mod_desc = [[
This mod will show you additional statistics and extensive information in the game.
It can be added/removed every time.

[Description also available in game]

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
[*]Financial total statistics?
[/list]
If you like statistics, this mod is right for you.

Also useful as tool to find out filenames of objects and for modders.


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
I have tested the mod extensively, but I can't exclude possible bugs. That's why I included an error handler to prevent the game from crashing. In such a case, a window will be displayed. But all information is also written into the [u][url=https://www.transportfever2.com/wiki/doku.php?id=gamemanual:gamefilelocations ]stdout txt[/url][/u].
[u][b]If an error occurs, please do the following:[/b][/u] [olist]
[*]In the mod settings, set Log Level to 2
[*]Reproduce the error
[*]Send me stdout file
[/olist]
[img]https://raw.githubusercontent.com/Vacuum-Tube/Advanced_Statistics_1/main/pictures/loglevel2.png[/img]

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
		waterAreaTT = "This in general underestimates the real water area",
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
		freedataTT = [[
Will remove the data from state. (to prevent big state size, in order to avoid possible game issue on exit)
If you want to continue, don't reactivate script, reload instead.]],
		
	},
	
	
	zh_CN = {
		mod_name = "Advanced Statistics",
		mod_desc = [[
This mod will show you additional statistics and extensive information in the game.
It can be added/removed every time.

[Description also available in game]

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
[*]Financial total statistics?
[/list]
If you like statistics, this mod is right for you.

Also useful as tool to find out filenames of objects and for modders.


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
I have tested the mod extensively, but I can't exclude possible bugs. That's why I included an error handler to prevent the game from crashing. In such a case, a window will be displayed. But all information is also written into the [u][url=https://www.transportfever2.com/wiki/doku.php?id=gamemanual:gamefilelocations ]stdout txt[/url][/u].
[u][b]If an error occurs, please do the following:[/b][/u] [olist]
[*]In the mod settings, set Log Level to 2
[*]Reproduce the error
[*]Send me stdout file
[/olist]
[img]https://raw.githubusercontent.com/Vacuum-Tube/Advanced_Statistics_1/main/pictures/loglevel2.png[/img]

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
现在是${date}，你的银行账户有${balance}。

地图中共有${towns}座城镇和${industries}座产业，
总人口数为${persons}。

你的运输公司在${lines}条线路上共经营着${vehicles}辆载具，
你的铁路网长度为${tracklength} (${percelectrified}电气化)，
你拥有的道路长度为${streetlength}。

你在这个存档一共游玩了${gametime}。

现在的时间是:  ${realtime}
]],
		["Welcome back"] = "欢迎回来",
		
		RESIDENTIAL = "居民区",
		COMMERCIAL = "商业区",
		INDUSTRIAL = "产业区",
		ALL = "全部",
		ROAD = "公路",
		RAIL = "铁路",
		TRAM = "有轨车辆",
		AIR = "空运",
		WATER = "水运",
		PERSON = "人口",
		CARGO = "货物",
		CAR = "私家车",
		BUS = "公共汽车",
		TRUCK = "卡车",
		ELECTRIC_TRAM = "有轨电车",
		TRAIN = "火车",
		ELECTRIC_TRAIN = "电力火车",
		AIRCRAFT = "大型飞机",
		SHIP = "大型船舶",
		SMALL_AIRCRAFT = "小型飞机",
		SMALL_SHIP = "小型船舶",
		TRACK = "轨道",
		STREET = "街道",
		Capacities = "容量",
		
		EN_ROUTE = "在路途上",
		AT_TERMINAL = "在站点中",
		GOING_TO_DEPOT = "正在回送",
		IN_DEPOT = "在库中",
		SIGNAL = "标准信号机",
		ONE_WAY_SIGNAL = "单行道信号机",
		WAYPOINT = "路径点",
		
		Load = "加载",
		
		welcome = "欢迎",
		program = "程序",
		settings = "设置",
		info = "信息",
		
		Global = "全局",
		View = "视野内",
		Radius = "半径内",
		
		Average = "平均",
		Min = "最小",
		Max = "最大",
		Sum = "总和",
		Total = "总计",
		
		Notes = "记录",
		NotesTFHint = "记录，备忘清单，...",
		NotesTFTT = "你可以在这里写下备忘录，小贴士，等等。",
		
		["Program Startup"] = "游戏启动",
		programStartTT = "本次游戏程序启动时间",
		["Game Load"] = "游戏读取",
		gameLoadTT = "游戏初始化时间，比按下启动按钮稍迟",
		["Game Start"] = "游戏开始",
		gameStartTT = "GUI初始化时间",
		Now = "当前时间",
		["Program Time"] = "启动时间",
		["Game Time"] = "游戏时间",
		["Loading Time"] = "读取时间",
		loadingTimeTT = "从游戏初始化到游戏开始的时间",
		["Release Notes"] = "更新日志",
		
		Datatype = "统计项",
		SetDatatypeTT = [[
游戏包含不同类型的实体。
本模组会分别读取并统计这些实体的数据。]],
		Runtime = "运行耗时",
		SetRuntimeTT = [[
数据计算是在游戏/脚本线程中以每秒5次的频率(200ms)执行的。
由于需要遍历所有对象，有些计算可能耗时较长。
时间取决于实体类型和游戏中/视野中的对象数量。
如果所有计算更新的总和耗时超过200ms，游戏将会开始卡顿。
你也可以在debug模式下控制这一设置。(debug模式开，2x AltGr+i，后者)]],
		Run = "运行",
		SetRunTT = [[
总的来说，只有在对应选项卡被选择时，才会执行统计计算程序。
你可以在此决定某项统计数据是否总是应被计算。
这将会保持快捷栏的数据不断更新。
不要启用太多耗时较长的选项，这会导致游戏延迟。
在游戏早期你可以比在后期启用更多的计算。]],
		Always = "总是",
		["Game bar"] = "快捷栏",
		SetGamebarTT = [[在游戏快捷栏中显示简要信息。]],
		["Last Update"] = "上次更新",
		["Free Data"] = "释放数据",
		freedataTT = [[
将会清除当前数据，以防止过大的数据容量导致退出游戏时出错。
如果你想要继续，不要重新启用脚本，按下“重新加载”按钮。]],
		Active = "启用",
		Deactivated = "禁用",
		showWindowSet = "游戏开始时显示窗口",
		gamebarInsertSet = "在游戏快捷栏左侧放置按钮",
		gamebarInsertSetTT = "否则放到右侧",
		hideGameInfoSet = "隐藏游戏数据",
		hideGameInfoSetTT = "“已运输”数据(在GAME选项卡中显示)",
		advadvTT = "显示更多数据元素",
		startSoundSet = "启动音效提示",
		startSoundSetTT = [[
在游戏加载后播放音效。
第一个声音表示GUI初始化完成，第二个表示统计数据窗口初始化完成。]],
		Reload = "重新加载",
		
		["Donate"] = "赞助",
		["Thank You"] = "谢谢",
		
		["Game Information"] = "游戏信息",
		Name = "名称",
		["Company Score"] = "公司得分",
		["Game Difficulty"] = "游戏难度",
		Sandbox = "沙盒模式",
		["No Costs"] = "无花费",
		Simulation = "模拟",
		gametimeTT = "由暂停/开始控制的游戏内时间",
		["Update Count"] = "更新总数",
		["Simulation Speed"] = "模拟速度",
		gametimeTotTT = "包括暂停时间在内的游戏内时间",
		["Tick Count"] = "游戏刻总数",
		["Game Date"] = "游戏日期",
		["Milliseconds per day"] = "每游戏日毫秒数",
		["Transported Passengers"] = "已运送旅客数",
		["Transported Cargo"] = "已运送货物数",
		
		World = "世界",
		["Map Size"] = "地图大小",
		["Terrain Tiles"] = "地形图格",
		Tiles = "图格",
		Terrain = "地形",
		["Terrain Height"] = "海拔",
		["Water Level"] = "海平面",
		["Offset Z"] = "Z轴深度",
		Resolution = "分辨率",
		Area = "面积",
		inaccurate = "不准确",
		waterAreaTT = "大体上低估总水域面积",
		relative = "比例",

		Other = "其他",
		Finances = "经济",
		Balance = "预算",
		Loan = "贷款",
		["Maximum Loan"] = "最大贷款",
		Income = "收入",
		Maintenance = "维护花费",
		Acquisition = "购置花费",
		ConstructionJournal = "建设花费",
		Interest = "利息",
		ROI = "投资回报率",
		Infrastructure = "基础设施",
		
		Towns = "城镇",
		Count = "总数",
		Development = "发展",
		Size = "大小",
		TownSizeTT = "城镇的“大小”是指三种区域数量的平均值",
		["Growth Factor"] = "增长倍率",
		GrowthFactorTT = "当前人口容量与基础值的比值",
		["Growth Tendency"] = "增长率",
		["Size Factor"] = "尺寸倍率",
		Reachability = "通达度",
		ReachabilityTT = [[这一数据与可行的目的地点的数量有关。
最大值大约是商业区和产业区总数的均值，
该值被作为分母(如果土地使用平均分布的话)。)]],
		Car = "私人交通",
		Line = "公共交通",
		["Cargo Supply"] = "供给",
		supplied = "得到供应",
		partially = "部分",
		completely = "完全",
		["Traffic Rating"] = "交通状况",
		
		["Auto Upgrade"] = "自动升级",
		Upgrading = "升级中",
		Downgrading = "降级中",
		Production = "产能",
		Shipping = "进货",
		Transport = "出货",
		Produced = "已生产",
		Shipped = "已运输",
		Consumed = "已消费",
		List = "详情",
		
		Lines = "线路",
		Inactive = "非活动",
		Fare = "运费",
		General = "总体",
		FareTT = "全局运费数值 (?) (api.engine.system.simEntityAtVehicleSystem.getFare)",
		Frequency = "频率",
		Rate = "吞吐量",
		Stops = "停靠点",
		["Ticket Price"] = "票价",
		Transported = "已运输",
		All = "全部",
		["Transport Modes"] = "运输方式",
		
		Vehicles = "载具",
		Status = "状态",
		Stopped = "已停止",
		Waiting = "等待中",
		VehicleWaitingTT = "不在任何站点中且速度为0",
		["Doors Open"] = "已开门",
		["Never Doors Opened"] = "从未开门",
		["Current Speed"] = "当前速度",
		Condition = "状况",
		Age = "年数",
		["Last Doors Open"] = "最近开门",
		Latest = "最近",
		Oldest = "最早",
		["Vehicle Parts"] = "节数",
		Models = "模型",
		
		Stations = "站点",
		Groups = "组合站点",
		StationGroupTT = "组合站点是在道路两侧的单一站点(如公交车站/有轨电车站)的集合",
		["Transport Samples"] = "交通样本",
		TransportSamplesTT = "我也不知道这是啥，不过它和客运站点与人口目的地点有关。",
		["Waiting Cargo"] = "等候运输",
		Loaded = "已装载",
		Unloaded = "已卸载",
		
		Depots = "库场",
		["Last Used"] = "上次使用",
		["Never Used"] = "从未使用",
		
		["Town Buildings"] = "城镇建筑",
		Destinations = "目的地点",
		Buildings = "建筑物",
		Employed = "受雇",
		Vacant = "空置",
		Height = "高度",
		Depth = "深度",
		Parcels = "地块",
		
		Constructions = "建筑物",
		["Person Capacity"] = "人口容量",
		["Particle Emitters"] = "粒子排放",
		["Build Cost"] = "建筑花费",
		["Maintenance Cost"] = "维护花费",		
		
		Assets = "物品",
		Not = "非",
		Trees = "树",
		Rocks = "岩石",
		Fences = "围栏",
		fencesTT = "雪球栅栏",
		["Placeholder Cubes"] = "占位符方块",
		
		Segments = "路段",
		edgeLengthTT = "由于估算，可能与总部的统计图表有差异",
		["Bus Lane"] = "公交专用道",
		Tram = "车辆轨道",
		["Tram Electric"] = "电化轨道",
		Bridge = "桥梁",
		Tunnel = "隧道",
		["Player Owned"] = "玩家所有权",
		["Speed Limit"] = "最大速度",
		["Curve Speed Limit"] = "曲线限速",
		["Curve Radius"] = "曲线半径",		
		Segment = "路段",
		Slope = "坡度",
		Types = "类型",
		
		Isolated = "尽头",
		Connected = "连续",
		Crossing = "交叉",
		["Traffic Lights"] = "信号灯",
		["Double Slip Switches"] = "复式交分道岔",
		Nodes = "节点",
		["Node Degree"] = "节点连接数",
		NodeDegreeTT = "一个节点/路口的通道数量",
		["Traffic Light Preference"] = "信号灯外观",
		Preference = "外观",
		["Traffic Light State"] = "信号灯状态",
		State = "状态",
		
		Persons = "人口",
		PersonCountAllTT = [[被模拟的总人数。
他们并非都同时在地图上行动，实际上也不都有目的地点。
但是他们几乎都会有寻路计算。
在建筑中的人口数：总人数 - 可见人数 - 载具中人数。]],
		Visible = "可见",
		PersonCountVisTT = [[在旅途中的行人/私家车的数量，包括在路上和站点中的]],
		["Moving"] = "移动中",
		["At terminal"] = "站点中",
		["in Vehicles"] = "载具中",
		["Move Mode"] = "出行方式",
		Walk = "步行",
		["and"] = "和",
		Only = "仅",
		None = "无",
		["Current Destination"] = "当前目的地",
		["Number of different Towns"] = "目的地分布的城市数",
		DifTownsCountTT = "Persons can have their destinations in 1, 2 or 3 different towns",
		Town = "城镇",
		["all same"] = "均在同一城市",
		["two equal"] = "在两个城市",
		["all different"] = "都在不同城市",
		["Waiting Time"] = "等待时间",
		Terminal = "站点",
		["Last Destination Update"] = "上次目的地点更新",
		
		["Cargo Entities"] = "货物实体",
		["At stock"] = "库存中",
		CargoVisibleTT = [[只包括站点和工厂库存中的可见货物。
这一数值低于货物的总数，因为载具上的没有被计算。
不过本页下部有那部分的数量。]],
		["Current Travel Time"] = "当前运行时间",
		["Travel Time"] = "运行时间",
		["Vehicle Loading"] = "载具装载",
		["Vehicles with Cargo"] = "运输载具数",
		
		Animals = "动物",
		
		Signals = "信号机",
		Off = "关",
		On = "开",
		Activation = "启动",
		["Last Activated"] = "上次启动",
		["Never Activated"] = "从未启动",
		
		["Railroad Crossings"] = "铁路道口",
		Open = "开启",
		Closed = "关闭",
		Opening = "开启中",
		
		Resources = "资产",
		["Res Type"] = "资产类型",
		Vanilla = "原版",
		["Mod Overload"] = "模组覆盖",
		Index = "编号",
		Icon = "图标",
		Speed = "限速",
		["Year From"] = "起始时间",
		["Year To"] = "结束时间",
		Filenames = "文件名",
		country = "地区",
		Weight = "重量",
		Volume = "体积",
		["Construction Type"] = "建筑类型",
		Landuse = "土地使用",
		
		["Base Config"] = "基础配置",
		
		--general = "general",
		--Settings = "设置",		
		--Both = "都",
		--States = "状态",
		--More = "更多",
		--Growth = "增长",
		--Model = "模型",
		--Availability = "可用性",
		--["On the way"] = "On the way",
		--["Cargo Types"] = "Cargo Types",
		--["Cargo Loading"] = "Cargo Loading",
		--RadiusViewTT = "Click to update",
		
		
	},
	
	
	de = {
		mod_desc = [[
Diese Mod zeigt dir erweiterte Statistiken und umfassende Informationen im Spiel an.
Sie kann jederzeit hinzugefügt/entfernt werden.

[Beschreibung auch im Spiel verfügbar]

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
[*]Finanzielle gesamte Statistiken?
[/list]
Wenn du Statistiken magst, dann ist diese Mod das Richtige für dich.

Außerdem nützlich als Tool zum Rausfinden von Dateinamen von Objekten sowie für Modder.


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
Ich habe die Mod ausführlichst getestet, kann aber mögliche Fehler nicht ausschließen. Deswegen habe ich einen Error Handler eingebaut, damit das Spiel nicht abstürzt. In einem solchen Fall wird ein Fenster angezeigt. Alle Informationen werden aber auch in die [u][url=https://www.transportfever2.com/wiki/doku.php?id=gamemanual:gamefilelocations ]stdout txt[/url][/u] geschrieben. 
[u][b]Bei einem Fehler bitte Folgendes machen:[/b][/u] [olist]
[*]In den Mod-Einstellungen das Log Level auf 2 setzen
[*]Den Fehler reproduzieren
[*]Mir die stdout schicken
[/olist]
[img]https://raw.githubusercontent.com/Vacuum-Tube/Advanced_Statistics_1/main/pictures/loglevel2.png[/img]

[h2]Hintergrund[/h2]
Dieses Projekt ist mit Abstand die größte und aufwändigste Mod, die ich für Transport Fever 2 erstellt habe.
Die ersten Ideen begannen bereits vor einem Jahr. Die im Spiel verfügbaren Statistiken waren mir einfach nicht umfangreich genug. Es begann also damit, einzelne Werte wie die Spielzeit, die Gesamteinwohnerzahl und weitere Daten zu Städten und Industrien grafisch anzuzeigen.
Mit der Zeit wurde das Projekt immer größer, da ich auch Informationen der anderen Entity Typen (Fahrzeuge, Assets, Personen, Gleise...) auswerten wollte. Außerdem kamen mit dem Modding Update letzten Sommer noch mehr Möglichkeiten hinzu.
Mit der Zeit lernte ich viel über das Spiel, die (Gui-)Modding Schnittstelle und das Programmieren mit Lua dazu. Somit blieb der nächste Schritt immer gering und machte es möglich, noch mehr Informationen kompakt und flexibel hinzuzufügen. Das fertige Ergebnis schien immer nah, aber durch den Umfang (alles interessante aus dem Spiel auszulesen was geht) und viele Details zog sich das Projekt sehr in die Länge, was ich anfangs unterschätzt habe. 
Um einen Eindruck von der Größe des Projekts zu bekommen: Es besteht aus 87 Skript-Dateien.


[h2]Danksagung[/h2]
Obwohl ich bei der Entwicklung auf einige technische Schwierigkeiten gestoßen bin, möchte ich Urban Games für den Support und die Modding Möglichkeiten danken.
Ein großes Danke geht an eis_os und CommonAPI2, dessen Konsole und Inspektor-Tools bei der Entwicklung äußerst hilfreich waren.
Desweiteren bedanke ich mich für die nützlichen Kommentare der Beta-Tester.


[h2]Code und Weiterentwicklung[/h2]
Der Quellcode zur Mod ist auf GitHub verfügbar: https://github.com/Vacuum-Tube/Advanced_Statistics_1
Ich habe auch zahlreiche Ideen für die Weiterentwicklung. Allerdings brauche ich jetzt erstmal eine Pause vom Programmieren.

]],
		mod_desc_paypal = [[Wenn Du meine Mod Entwicklung unterstützen möchtest, würde ich mich über eine Spende freuen]],
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
		STREET = "Straßen",
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
		Acquisition = "Käufe/Verkäufe",
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
		Finances = "Finanzen",
		Infrastructure = "Infrastruktur",
		Opening = "Am Öffnen",
		World = "Welt",
		Resolution = "Auflösung",
		Area = "Fläche",
		Switch = "Weiche",
		relative = "relativ",
		inaccurate = "ungenau",
		
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
		["Terrain Height"] = "Gelände Höhe",
		["Water Level"] = "Wasser Höhe",
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
	},
	
	
	ru = {
 
		welcome_text = [[
Сегодня ${date} и ваш баланс составляет ${balance}.
 
На карте находятся ${towns} города(-ов) и ${industries} предприятия(-й).
Количество смоделированных людей ${persons}.
 
Ваша транспортная компания владеет ${vehicles} транспортными средствами на ${lines} линиях.
Длина вашей железнодорожной сети составляет ${tracklength} (${percelectrified} электрифицированно).
Длина улиц, принадлежащих игроку, составляет ${streetlength}.
 
На этой карте вы играли ${gametime}.
 
Реальное время сейчас:  ${realtime}
]],
 
		RESIDENTIAL = "Жилые здания",
		COMMERCIAL = "Коммерческие",
		INDUSTRIAL = "Промышленные",
		ALL = "Все",
		ROAD = "Авто",
		RAIL = "Ж/д",
		TRAM = "Трамвай",
		AIR = "Авиа",
		WATER = "Водные",
		TRACK = "Ж/д",
		STREET = "Улицы",
		EN_ROUTE = "На линиях",
		AT_TERMINAL = "На станциях",
		GOING_TO_DEPOT = "По дороге в депо",
		IN_DEPOT = "В депо",
		SIGNAL = "Стандартный сигнал",
		ONE_WAY_SIGNAL = "Односторонний сигнал",
		WAYPOINT = "Путевая точка",
 
		Settings = "Настройки",
		settings = "Настройки",
		welcome = "Добро пожаловать",
		program = "Программа",
		Now = "Сейчас",
		All = "Все",
		None = "Нет",
		Both = "Оба",
		Only = "Только",
		Always = "Всегда",
		State = "Статус",
		Not = "Нет",
		More = "Больше",
		Count = "Всего",
		Groups = "Группы",
		Size = "Размер",
		Average = "В среднем",
		Sum = "Сумма",
		Total = "Суммарно",
		List = "Список",
		On = "Вкл",
		Off = "Выкл",
		Notes = "Заметки",
		Balance = "Состояние счёта",
		Loan = "Кредит",
		Income = "Доходы",
		Maintenance = "Техобслуживание",
		Acquisition = "Новая техника",
		ConstructionJournal = "Строительство",
		Vehicles = "Транспорт",
		Trees = "Деревья",
		Rocks = "Камни",
		Condition = "Состояние",
		Age = "Возраст",
		Walk = "Пешком",
		Car = "Автомобиль",
		Line = "Общественный транспорт",
		Lines = "Линии",
		Fare = "Цена билета",
		Open = "Открыт",
		Closed = "Закрыт",
		Latest = "Самое новое",
		Oldest = "Самое старое",
		Capacities = "Вместимость",
		Buildings = "Здания",
		Height = "Высота",
		Reachability = "Доступность",
		Destinations = "Направления",
		Town = "Город",
		Towns = "Города",
		supplied = "обеспечены",
		partially = "частично",
		completely = "полностью",
		Other = "Другой",
		Types = "Типы",
		Transported = "Перевезено",
		Frequency = "Интервал",
		Slope = "Уклон",
		Production = "Производство",
		Shipping = "Доставка",
		Produced = "Произведено",
		Shipped = "Отгружено",
		Consumed = "Переработано",
		Bridge = "Мост",
		Tunnel = "Туннель",
		Model = "Модель",
		Models = "Модели",
		Inactive = "Неактивно",
		Segments = "Сегмент",
		Constructions = "Конструкции",
		Stations = "Станции",
		Signals = "Сигналы",
		Persons = "Люди",
		Animals = "Животные",
		Connected = "Соединённые",
		Isolated = "Изолированные",
		Crossing = "Переезды",
		Vacant = "Свободно рабочих мест",
		Employed = "Занятые рабочие места",
		Fences = "Заборы",
		Stopped = "Остановлено",
		Availability = "Доступность",
		Visible = "Видимый",
		Waiting = "Ожидающие",
		Stops = "Остановки",
		Loaded = "Загружено",
		Unloaded = "Разгружено",
		Activation = "Активность",
		Finances = "Финансы",
		Infrastructure = "Инфраструктура",
 
		["Welcome back"] = "С возвращением",
		["Program Startup"] = "Запуск программы",
		["Game Load"] = "Начало загрузки карты",
		["Game Start"] = "Карта загружена",
		["Map Size"] = "Размер карты",
		["Game Time"] = "В игре",
		["Game Date"] = "Дата игры",
		["Loading Time"] = "Время загрузки",
		["Last Update"] = "Последнее обновление",
		["Game Information"] = "Информация об игре",
		["Transported Passengers"] = "Перевезено пассажиров",
		["Transported Cargo"] = "Перевезено грузов",
		["Company Score"] = "Рейтинг компании",
		["Game Difficulty"] = "Сложность игры",
		["Simulation Speed"] = "Скорость моделирования",
		["Milliseconds per day"] = "Миллисекунд в дне",
		["Maximum Loan"] = "Максимальный кредит",
		["Current Speed"] = "Текущая скорость",
		["Move Mode"] = "Способ передвижения",
		["Current Destination"] = "Текущее направление",
		["and"] = "и",
		["Last Activated"] = "Последнее срабатывание",
		["Never Activated"] = "Никогда не срабатывал",
		["Last Used"] = "Последнее использование",
		["Never Used"] = "Никогда не использовался",
		["Growth Factor"] = "Фактор роста",
		["Particle Emitters"] = "Источники дыма",
		["On the way"] = "В пути",
		["Cargo Supply"] = "Доставка грузов",
		["Cargo Types"] = "Типы грузов",
		["Ticket Price"] = "Цена билета",
		["Vehicle Parts"] = "Количество Вагонов/Локомотивов",
		["Cargo Entities"] = "Типы грузов",
		["Cargo Loading"] = "Загруженные грузы",
		["Vehicle Loading"] = "Загруженность транспорта",
		["Vehicles with Cargo"] = "Загруженный транспорт",
		["Last Destination Update"] = "Последнее обновление направления",
		["Number of different Towns"] = "Количество городов с пунктами назначения",
		["all same"] = "все в одном",
		["two equal"] = "два в одном",
		["all different"] = "все в разных",
		["Speed Limit"] = "Ограничение скорости",
		["Curve Speed Limit"] = "Ограничение скорости на изгибах",
		["Curve Radius"] = "Радиус изгиба",
		["Bus Lane"] = "Автобусный маршрут",
		["Tram Electric"] = "Электротрамвай",
		["Player Owned"] = "Собственность игрока",
		["Travel Time"] = "Время в пути",
		["Current Travel Time"] = "Текущее время в пути",
		["Double Slip Switches"] = "Двойная стрелка",
		["Traffic Lights"] = "Светофоры",
		["Waiting Cargo"] = "Ожидающие грузы",
		["At stock"] = "На складе",
		["At terminal"] = "На терминале",
		["Moving"] = "В пути",--"В дороге",
		["in Vehicles"] = "в транспортных средствах",
		["Waiting Time"] = "Время ожидания",
		["Build Cost"] = "Стоимость строительства",
		["Maintenance Cost"] = "Стоимость техобслуживания",
		["Railroad Crossings"] = "Ж/д переезды",
		["Town Buildings"] = "Городские здания",
		["Person Capacity"] = "Вместимость",
		["Placeholder Cubes"] = "Кубики-заполнители",
		["Thank You"] = "Спасибо",
 
		NotesTFHint = "Заметки, ToDo, ...",
		NotesTFTT = "Вы можете использовать это поле для личных заметок, списков задач и т. п.",
		gamebarInsertSet = "Вставить слева в игровую панель",
		gamebarInsertSetTT = "В противном случае добавить справа",
		hideGameInfoSet = "Скрыть Gameinfo",
		advadvTT = "Просмотр дополнительных данных",
		showWindowSet = "Показать окно при запуске",
		startSoundSet = "Звуковые уведомления при запуске",
		ConstructionJournal = "Строительство",  -- имеет разные значения в игре...
		gameLoadTT = "Инициализация gamescript, немного позже нажатия кнопки загрузки",
		loadingTimeTT = "Время от инициализации скрипта до начала игры",
		programStartTT = "Запуск приложения",
		gameStartTT = "Инициализация графического интерфейса пользователя",
		gametimeTT = "Внутреннее игровое время, которое контролируется непосредственно с помощью паузы/перемотки вперёд",
		gametimeTotTT = "Как указано выше, за исключением того, что это также включает в себя время паузы",
		TownSizeTT = "'Размер' городов определяется как (RES+COM+IND)/3",
		GrowthFactorTT = "Ratio between current capacities and base values",
		PersonCountVisTT = [[Количество видимых лиц/автомобилей, которые в данный момент находятся в пути (двигаются и находятся на терминале).
Статистика включает в себя данные только от этих людей.]],
		PersonCountAllTT = [[Количество всех лиц, которые моделируются.
Не все они движутся по карте одновременно, и в конечном итоге не все из них даже имеют пункты назначения.
Но поиск пути, вероятно, происходит для всех них.
Количество людей в зданиях должно быть: Все - Видимые - в транспортных средствах]],
		DifTownsCountTT = "У людей могут быть пункты назначения в 1, 2 или 3 разных городах",
		CargoVisibleTT = [[Видимые грузовые объекты включают в себя только грузовые модели на станционных терминалах и промышленных складах.
К сожалению, это также означает, что количество не соответствует общему количеству грузовых единиц, потому что они суммируются с одной более крупной моделью.
Груз в транспортных средствах включен не здесь, а ниже и содержит нужное количество единиц.]],
		fencesTT = "Заборы от Snowball",
		edgeLengthTT = "Отклонение от HQ Statistics может произойти из-за аппроксимации",
		NodeDegreeTT = "Количество прилегающих улиц/путей в узле/перекрёстке",
		StationGroupTT = "Группы станций объединяют отдельные станции, такие как автобусная/трамвайная станция с обеих сторон",
		TransportSamplesTT = "Я не знаю точно, что это такое, но это как-то связано с пассажирскими станциями и местами назначения людей",
		ReachabilityTT = [[Эти значения связаны с общим количеством доступных пунктов назначения.
Максимум, вероятно, составляет: (Capacities.COM+Capacities.IND) / 2 
который будет примерно равен 'Общему размеру' (если землепользование распределено равномерно)]],
		VehicleWaitingTT = "Скорость равна 0 и не остановлен или на терминале",
		RadiusViewTT = "Нажмите, чтобы обновить",
		startSoundSetTT = [[Воспроизведение звука после загрузки игры. 
Первый звук указывает на guiInit (начало черного экрана), второй – на инициализацию графического интерфейса окна статистики.]],
		SetDatatypeTT = [[
Игра состоит из сущностей разных типов. 
Этот мод структурирован путем чтения и суммирования данных отдельно от этих типов (псевдо) сущностей.]],
		SetRuntimeTT = [[
Расчёт выполняется в потоке игры/скрипта, который выполняется 5 раз в секунду (200 мс). 
Некоторые вычисления могут занять некоторое время из-за итерации по всем объектам. 
Продолжительность зависит от типа объекта и количества объектов в игре или в текущем представлении.
Если все вычисления обновления игры превышают 200 мс, симуляция игры начинает 'заикаться'. 
Вы также можете управлять этим с помощью окна отладки (режим отладки включен, 2x AltGr+i, нижний)]],
		SetRunTT = [[
Как правило, вычисления для статистики выполняются только в том случае, если выбрана соответствующая вкладка данных.
Здесь вы можете выбрать, всегда ли будет рассчитываться определенный тип данных. 
Это позволит поддерживать значения игровой панели в актуальном состоянии. 
Но не активируйте слишком много из них с длительным временем выполнения, это приведет к задержкам моделирования.
В ранней игре вы можете активировать больше, чем в поздней.]],
		SetGamebarTT = [[Показывает краткую информацию в игровой панели.]],
		freedataTT = [[
Удалить данные из состояния. (для предотвращения большого размера данных, чтобы избежать возможных игровых проблем при выходе)
Если вы хотите продолжить, не активируйте скрипт повторно, а перезагрузите его.]],
	},
	
	
}
end