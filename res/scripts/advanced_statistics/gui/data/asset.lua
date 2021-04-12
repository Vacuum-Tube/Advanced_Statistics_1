local format = require "advanced_statistics/gui/format"
local guio = require "advanced_statistics/gui/objects"
local res = require "advanced_statistics/script/res/model"
local a,v,s = require "advanced_statistics/adv".sks()

return {
	name = _("Assets"),
	icon = "ui/icons/construction-menu/filter_tree.tga", --misc
	gamebartext = function(data) return
		tostring(data.counts.sum)
	end,
	-- gamebartooltip = function(data) return
		-- string.format(" ",  )
	-- end,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				_("Count"),
				function(data) return
					format.Number(data.counts.sum)
				end
			},
			a{
				string.format("%s (%s)", _("Count"), _("Groups") ),
				function(data) return
					format.Number(data.counts.num)
				end
			},
			a{
				_("Not").." 'Auto Removable'",
				function(data) return
					string.format("%d  (%s)", data.notautoremove, format.Percent(data.notautoremove/data.counts.num) )
				end
			},
		}},
		
		{ table = {
			{
				{	layout = { type = "BoxH",
					content = {
						{
							icon = "ui/icons/construction-menu/filter_tree.tga",
						}, {
							text = _("Trees")
						}
					}
				}},
				function(data) return
					format.Number(data.models_.tree )
				end
			},{
				{	layout = { type = "BoxH",
					content = {
						{
							-- icon = "ui/icons/construction-menu/filter_rock.tga",
							icon = "ui/advanced_statistics/rock.tga",
						}, {
							text = _("Rocks")
						}
					}
				}},
				function(data) return
					format.Number(data.models_.rock )
				end
			},{
				{	layout = { type = "BoxH",
					content = {
						{
							icon = "ui/advanced_statistics/fences.tga",
						}, {
							text = _("Fences")
						}
					},
				}, tooltip = _("fencesTT"),
				},
				function(data) return
					format.Number(data.models_.fences )
				end
			},{
				{	layout = { type = "BoxH",
					content = {
						{
							icon = "ui/icons/construction-menu/filter_empty.tga",
						}, {
							text = _("Placeholder Cubes")
						}
					}
				}},
				function(data) return
					format.Number(data.models_.cube )
				end
			}
		}},
		
		"<hline>",
		{	text = _("Models"),
			style = "AVSHeading2"
		},
		guio.ResList( function() return updatedata().models end, 
			res.names, 
			function(value)
				return format.Number(value)
			end , true ),
		
	} end
}