return {
	-- {  --api.type.enum.Carrier
	  -- AIR = 3,
	  -- RAIL = 1,
	  -- ROAD = 0,
	  -- TRAM = 2,
	  -- WATER = 4
	-- },
	carriers = {  -- reverse
		"ROAD",
		"RAIL",
		"TRAM",
		"AIR",
		"WATER",
	},
	carriersAll = {  -- sorted for gui
		"ALL", 
		"RAIL",
		"ROAD",
		"TRAM",
		"WATER",
		"AIR",
	},
	icons = {
		ROAD	= "ui/icons/construction-menu/filter_bus.tga",
		RAIL		= "ui/icons/construction-menu/filter_train.tga",
		TRAM	= "ui/icons/construction-menu/filter_tram.tga",
		AIR		= "ui/icons/construction-menu/filter_plane.tga",
		WATER	= "ui/icons/construction-menu/filter_ship.tga",
		ALL		= "ui/icons/construction-menu/filter_all.tga",
	},
	-- transportModes = {  -- api.type.enum.TransportMode
	  -- AIRCRAFT = 9,
	  -- BUS = 3,
	  -- CAR = 2,
	  -- CARGO = 1,
	  -- ELECTRIC_TRAIN = 8,
	  -- ELECTRIC_TRAM = 6,
	  -- PERSON = 0,
	  -- SHIP = 10,
	  -- SMALL_AIRCRAFT = 11,
	  -- SMALL_SHIP = 12,
	  -- TRAIN = 7,
	  -- TRAM = 5,
	  -- TRUCK = 4,
	-- },
	transportModes = {
		"PERSON",
		"CARGO",
		"CAR",
		"BUS",
		"TRUCK",
		"TRAM",
		"ELECTRIC_TRAM",
		"TRAIN",
		"ELECTRIC_TRAIN",
		"AIRCRAFT",
		"SHIP",
		"SMALL_AIRCRAFT",
		"SMALL_SHIP",
	},
	transportModesLine = {
		"ALL",
		-- "PERSON",
		-- "CARGO",
		-- "CAR",
		"BUS",
		"TRUCK",
		"TRAM",
		"ELECTRIC_TRAM",
		"TRAIN",
		"ELECTRIC_TRAIN",
		"AIRCRAFT",
		"SHIP",
		"SMALL_AIRCRAFT",
		"SMALL_SHIP",
	},
}