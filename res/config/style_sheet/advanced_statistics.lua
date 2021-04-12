local ssu = require "stylesheetutil"
local sound = require "soundeffectsutil"

local alpha = 1.0

local landUseColors = {
	{ .525, .847, .345, alpha },
	{ .369, .839, .906, alpha },
	{ .875, .875, .384, alpha },
}

local positiveColor = { .6, .8, 1.0, 1.0 }
local negativeColor = { 1.0, .6, .6, 1.0 }
local warningColor = { 1.0, 1.0, .4, 1.0 }

local hp = 10
local vp = 5

function data()
    local result = {}
    local a = ssu.makeAdder(result)

	a("AVSButtonText", {
		fontSize = 20,
		margin = { 0, 2, 0, 2 },
	})
	
	a("!AVSButtonGamebar", {
		backgroundColor = ssu.makeColor(15, 35, 50),
		borderWidth = { 2, 2, 2, 2 },
		borderColor = ssu.makeColor(192, 192, 192, 96),
		margin = { 0, 10, 0, 5 },
		-- blurRadius = 30,
	})
	a("!AVSButtonGamebar:hover", {
		backgroundColor = ssu.makeColor(50, 70, 90),
		borderColor = ssu.makeColor(255, 255, 255, 128),
	})
	a("!AVSButtonGamebar:active", {
		backgroundColor = ssu.makeColor(110, 122, 132),
		borderColor = ssu.makeColor(255, 255, 255, 128),
		soundEffect1 = sound.get("buttonClick")
	})
	a("!AVSButtonGamebar:disabled", {
		color = ssu.makeColor(128, 128, 128)
	})
	
	
	a("!AVSButton", {
		backgroundColor = ssu.makeColor(255, 255, 255, 15),
		borderColor = ssu.makeColor(0, 0, 0, 150)
	})
	a("!AVSButton:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 70),
	})
	
	a("!AVSToggleButtonExtend", {
		backgroundColor = ssu.makeColor(255, 255, 255, 5),
		-- margin = { 0, 10, 0, 10 },  -- top, right, bottom and left 
		-- padding = { 0, 10, 0, 10 },
	})
	-- a("!AVSButton:hover", {
		-- backgroundColor = ssu.makeColor(255, 255, 255, 70),
	-- })
	
	a("!AVSScriptButton", {
		backgroundColor = ssu.makeColor(255, 255, 255, 75),
	})
	a("!AVSScriptButton:hover", {
		backgroundColor = ssu.makeColor(255, 255, 255, 100),
	})
	
	
	a("!AVSLoadDemandButton", {
		margin = { 10, 10, 10, 10 },
		padding = { 2, 2, 2, 2 },
		gravity = {0.5, 0.5},
	})
	a("!AVSLoadDemandButton TextView", {
		fontSize = 18,
		textTransform = "UPPERCASE",
		gravity = {0.5, 0.5},
	})
	
	
	a("!AVSTabContent", {
		padding = { 0, 10, 0, 0 },
	})
	
	a("!AVSNotesTextfield", {
		margin = { 0, 10, 0, 10 },  -- top, right, bottom and left 
		padding = { 10, 10, 10, 10 },
	})
	
	
	a("!AVSHeading1", {
		fontSize = 20,
		color = positiveColor,
	})
	a("!AVSHeading2", {
		fontSize = 18,
		color = positiveColor,
	})
	a("!AVSHeading3", {
		fontSize = 16,
		color = positiveColor,
	})
	
	a("!AVSWelcome", {
		fontSize = 20,
		color = positiveColor,
		margin = { 20, 20, 20, 20 },
		gravity = {0.5, 0},
	})
	
	a("!AVSVacuumTube", {
		fontSize = 16,
		color = {.6,.9,.4,1},
	})
	
	a("!AVSPlayerName", {
		fontSize = 16,
		color = positiveColor,
	})
	
	a("!AVSCompanyScore", {
		fontSize = 16,
		color = ssu.makeColor(255, 255, 0),
	})
	
	a("!AVS-RESIDENTIAL", {
		color = landUseColors[1],
	})
	
	a("!AVS-COMMERCIAL", {
		color = landUseColors[2],
	})
	
	a("!AVS-INDUSTRIAL", {
		color = landUseColors[3],
	})
	
	a("!AVS-tab-widget-indicator-text", {
		fontSize = 14,
		textTransform = "UPPERCASE",
	})
	
	a("!AVS-toggle-button-group-text", {
		-- fontSize = 14,
		textTransform = "UPPERCASE",
	})
	
	a("!AVS-resource-name-text", {
		-- fontSize = 14,
		textTransform = "UPPERCASE",
	})
	
	a("!AVS-text-info", {
		-- fontSize = 14,
		color = {1,1,1,0.5}
	})
	
	a("!AVSBuild", {
		fontSize = 16,
		-- color = { .6, .8, 1.0, 1.0 }
	})
	
	a("!AVS-text-noto", {
		fontFamily = "Noto/NotoSansMono-Regular.ttf"  -- crash without message if not valid
	})
	
	a("!AVS-checkhook", {
		padding = { vp, hp, vp, hp }
	})
	
	
	a("!AVS-table-header", {
		fontSize = 16,
		-- gravity = {1, 1},
		-- textAlignment = { 0, 0 }
	})
	a("!AVS-table-header-h", {
		color = positiveColor,
		fontSize = 18,
		-- padding = {10,10,10,10}
	})
	a("!AVSHeading2-table-header", {
		fontSize = 18,
		color = positiveColor,
		padding = {10,10,0,10}
	})
	
	-- ??
	a("!AVS-table-item!level0", {
		backgroundColor = ssu.makeColor(0, 255, 255, 20),
	})
	a("!AVS-table-item!level1", {
		backgroundColor = ssu.makeColor(50, 0, 0, 20),
	})
	-- a("!AVS-table-item", {
		-- backgroundColor = ssu.makeColor(255, 255, 255, 5),
	-- })
	
	a("!AVS-table-item!level0!group-label", {
		color = ssu.makeColor(200, 200, 200, 200),
		backgroundColor = ssu.makeColor(255, 255, 255, 50),
	})
	
	-- a("!AVS-table-item!level0, !AVS-table-item!level0 TextView, !AVS-table-item!level1", {
	a("!AVS-table-itemzzzz", {
		gravity = { -1.0, -1.0 },
		textAlignment = { 0, .5 }
		-- textAlignment = { 1.0, .5 }  -- right
	})
	
	
	a("#avs.toolTipContainer.toolTip", {
		backgroundColor = ssu.makeColor(15, 35, 50, 100),
		margin = { 15, 0, 0, 30 },
		gravity = { .0, .0 },
		blurRadius = 4 * 4
	})
	
    return result
end
