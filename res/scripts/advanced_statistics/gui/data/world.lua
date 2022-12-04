local format = require "advanced_statistics/gui/format"
local style = require "advanced_statistics/gui/style"
local guio = require "advanced_statistics/gui/objects"
local a,v,s,o = require "advanced_statistics/adv".sks()


return {
	name = _("World"),
	header = false,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				_("Map Size"),
				function(data)
					local size = data.worldSize
					return string.format("%s  x  %s  =  %s²", format.Length(size.x),  format.Length(size.y),  format.Length(size.x*size.y) )
				end
			},{
				_("Terrain Tiles"),
				function(data)
					local size = data.terrainInfo.size
					return string.format("%d  x  %d  =  %d %s", size.x,  size.y, size.x*size.y, _("Tiles") )
				end
			},
		}},
		
		"<hline>",
		{	text = _("Terrain"),
			style = "AVSHeading2"
		},
		{ table = {
			{
				_("Terrain Height")..format.str.min,
				function(data) return 
					format.Length(data.terrainInfo.heightMin)
				end
			},{
				_("Terrain Height")..format.str.av,
				function(data) return 
					format.Length(data.terrainInfo.heightAv)
				end
			},{
				_("Terrain Height")..format.str.max,
				function(data) return 
					format.Length(data.terrainInfo.heightMax)
				end
			},{
				_("Water Level"),
				function(data) return 
					format.Length(data.terrainInfo.waterLevel)
				end
			},{
				_("Offset Z"),
				function(data) return 
					format.Length(data.terrainInfo.offsetZ)
				end
			},
		}},
		{ table = {
			{
				_("Resolution").." X/Y",
				function(data) return 
					string.format("%f m", data.terrainInfo.resolution)
				end
			},{
				_("Resolution").." Z",
				function(data) return 
					string.format("%f m", data.terrainInfo.resolutionZ)
				end
			},
		}},
		
		"<hline>",
		{	text = _("Water"),
			style = "AVSHeading2"
		},
		{ table = {
			-- {
				-- string.format("%s %s", _("Count"), _("WaterMesh Entities") ),
				-- function(data) return 
					-- data.waterInfo.numWaterMeshes
				-- end
			-- },
			{
				{ text=string.format("%s (%s)", _("Area"), _("inaccurate")),
					tooltip=_("waterAreaTT")
				},
				function(data) return 
					string.format("%s²", format.Length(data.waterInfo.waterArea))
				end
			},
			{
				{	text=string.format("%s (%s) %s ", _("Area"), _("inaccurate"), _("relative")),
					tooltip=_("waterAreaTT")
				},
				function(data) 
					local mapsize = data.worldSize
					return format.Percent(data.waterInfo.waterArea/(mapsize.x*mapsize.y), 2)
				end
			},
		}},
		
		
	} end
}