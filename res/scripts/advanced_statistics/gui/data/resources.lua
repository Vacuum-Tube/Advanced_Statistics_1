local format = require "advanced_statistics/gui/format"
local bgui = require "advanced_statistics/gui/basic"
local guio = require "advanced_statistics/gui/objects"
local guibuilder = require "advanced_statistics/gui/guibuilder"
local log = (require "advanced_statistics/log").logPrefix("window.resources-tab")
local resdata = require "advanced_statistics/script/resdata"
local reslist = require "advanced_statistics/script/reslist"
local _ = function(x) return x end  -- translate not working in onclick, only creating problems...

return {
	icon = "ui/folder.tga",--"ui/folder_open.tga",--"ui/resolution.tga",
	header = false,
	footer = false,
	windowlayout = function() return 
		guio.LoadDemand(function() return 
			guio.Tabwidget("WEST", reslist, function(resstr)
				log(2,"Create resource tab",resstr)
				local res = resdata[resstr]
				return {
	
	resstr=="model" and {
		text = _("Model Types"),
		style = "AVSHeading2"
	},
	resstr=="construction" and {
		text = _("Construction Types"),
		style = "AVSHeading2"
	},
	(resstr=="construction" or resstr=="model") and guio.Table( res.types, {
		resstr=="construction" and function(key) 
			return res.contypes_[key]
		end,
		function(key) 
			return key
		end,
		function(key) 
			return res.counts[key]
		end,
		function(key) 
			return res.counts_vanilla[key]
		end,
		function(key)
			return format.Percent(res.counts[key]/res.counts_vanilla[key],0)
		end,
	},{
		resstr=="construction" and _("Index"),
		_("Type"),
		_("Count"),
		_("Count").." ".._("Vanilla"),
		_("Mod Overload").." %",
	} ),
	
	{	text = _("List"),
		style = "AVSHeading2"
	},
	guio.Table( res.all, {
		function(key)
			return res.index[key]
		end,
		res.icons and function(key)
			return bgui.Icon(res.icons[key])
		end,
		res.names and function(key)
			return res.names[key]
		end,
		res.speed and function(key)
			return format.Speed(res.speed[key])
		end,
		resstr=="cargo" and function(key)
			return format.Weight(res.weight[key]/1e3)
		end,
		resstr=="construction" and function(key)
			return res.type[key]
		end,
		resstr=="model" and function(key)
			return format.Money(res.data[key].price)
		end,
		resstr=="model" and function(key)
			local size = res.data[key].size
			return string.format("%.2f x %.2f x %.2f", size.x, size.y, size.z )
		end,
		resstr=="model" and function(key)
			return string.format("%.3f", res.data[key].volume)
		end,
		resstr=="street" and function(key)
			return guio.CheckHook(res.data[key].visible)
		end,
		resstr=="street" and function(key)
			return guio.CheckHook(res.data[key].country)
		end,
		resstr=="building" and function(key)
			return res.data[key].landuse
		end,
		resstr=="building" and function(key)
			return res.data[key].level
		end,
		res.availability and function(key)
			return res.availability[key].yearFrom or "-"
		end,
		res.availability and function(key)
			return res.availability[key].yearTo or "-"
		end,
		res.visible and function(key)
			return guio.CheckHook(res.visible[key])
		end,
		function(key)
			return key
		end,
	},{
		_("Index"),
		res.icons and _("Icon"),
		res.names and _("Name"),
		res.speed and _("Speed"),
		resstr=="cargo" and _("Weight"),
		resstr=="construction" and _("Construction Type"),
		resstr=="model" and _("Price"),
		resstr=="model" and { text=_("Size").." (m)", tooltip="X, Y, Z"},
		resstr=="model" and _("Volume").. " (m³)",
		resstr=="street" and _("Visible").." (upgrade)",
		resstr=="street" and _("country"),
		resstr=="building" and _("Landuse"),
		resstr=="building" and _("Level"),
		res.availability and _("Year From"),
		res.availability and _("Year To"),
		res.visible and _("Visible"),
		_("Filename"),
	}),
	
	-- "<vfill>",  -- fill bottom to prevent centering
				}
			end, nil, nil,--function() return res	end )
			{
				{
					name = _("All"),
					content = {
						{
							text = _("Resources"),
							style = "AVSHeading1"
						},
						guio.Table( reslist, {
							function(key)
								return { text=key, style="AVS-resource-name-text" }
							end,
							function(key)
								return resdata[key].num
							end,
							function(key)
								return resdata.counts_vanilla[key]
							end,
							function(key)
								return format.Percent(resdata[key].num/resdata.counts_vanilla[key],0)
							end,
						},{
							_("Res Type"),
							_("Count"),
							_("Count").." ".._("Vanilla"),
							_("Mod Overload").." %",
						} )
					}
				}
			},
			nil, false
			)
		end,
		guibuilder.buildCompLayout("BoxV", {
			"Loading may take a while.",
			"Can create many 'Texture load error' warnings in stdout.txt",
		})
		)
	end
}