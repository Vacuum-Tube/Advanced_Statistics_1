local format = require "advanced_statistics/gui/format"
local style = require "advanced_statistics/gui/style"
local guio = require "advanced_statistics/gui/objects"
local a,v,s,o = require "advanced_statistics/adv".sks()

local journal_types = {
	"rail",
	"road",
	"tram",
	"water",
	"air",
	"other",
	"_sum",
}
local jtypes_name = {
	rail = _("RAIL"),
	road = _("ROAD"),
	tram = _("TRAM"),
	air = _("AIR"),
	water = _("WATER"),
	other = _("Other"),
	_sum = _("Total"),
}

local function moneyText(value)
	return {
		text = function(data) return
			format.Money(value(data))
		end,
		style = function(data) return
			style.finance(value(data))
		end 
	}
end

local function ROIText(valueandincome)
	return function(data) 
		local value, income = valueandincome(data)
		if value>-income then
			return format.Percent(value/income, 2)
		else
			return "-"
		end
	end
end

return {
	name = _("Finances"),
	header = false,
	windowlayout = function(updatedata) return {
		{ table = {
			{
				_("Balance"),
				moneyText(function(data) return
					data.account.balance
				end)
			}, {
				_("Loan"),
				{ text = function(data) return
					format.Money(data.account.loan)
				end,
				style = function(data) return
					style.finance(-data.account.loan)
				end }
			}, {
				_("Maximum Loan"),
				{ text = function(data) return
					format.Money(data.account.maximumLoan)
				end,
				-- style = function(data) return
					-- style.finance(data.account.maximumLoan)
				-- end 
				}
			}, {
				_("Total"),
				moneyText(function(data) return
					data.account.total
				end)
			},
		}},
		
		"<hline>",
		{ table = {
			{
				_("Income")..format.str.total,
				moneyText(function(data) return
					data.journal.income._sum
				end)
			}, {
				_("Maintenance")..format.str.total,
				moneyText(function(data) return
					data.journal.maintenance._sum
				end)
			}, {
				_("Acquisition")..format.str.total,
				moneyText(function(data) return
					data.journal.acquisition._sum
				end)
			}, {
				_("ConstructionJournal")..format.str.total,
				moneyText(function(data) return
					data.journal.construction._sum
				end)
			}, {
				_("Interest")..format.str.total,
				moneyText(function(data) return
					data.journal.interest
				end)
			}, {
				_("Other"),
				moneyText(function(data) return
					data.journal.other
				end)
			}, {
				_("Total"),
				moneyText(function(data) return
					data.journal._sum
				end)
			}, {
				_("Total").." ".._("ROI"),
				ROIText(function(data) return
					data.journal._sum, data.journal.income._sum
				end)
			}
		}},
		
		"<hline>",
		guio.Table(journal_types, {
			function(key)
				return jtypes_name[key]
			end,
			function(key)
				return moneyText(function(data) return
					data.income[key]
				end)
			end,
			function(key)
				return moneyText(function(data) return
					key=="_sum" and
					data.maintenance._sum or
					data.maintenance[key]._sum
				end)
			end,
			function(key)
				return moneyText(function(data) return
					key~="_sum" and
					data.maintenance[key].vehicle
				end)
			end,
			function(key)
				return moneyText(function(data) return
					key~="_sum" and
					data.maintenance[key].infrastructure
				end)
			end,
			function(key)
				return moneyText(function(data) return
					data.acquisition[key]
				end)
			end,
			function(key)
				return moneyText(function(data) return
					key=="_sum" and
					data.construction._sum or
					data.construction[key]._sum
				end)
			end,
			function(key)
				return moneyText(function(data) return
					key~="_sum" and
					data.construction[key].station
				end)
			end,
			function(key)
				return moneyText(function(data) return
					key~="_sum" and
					data.construction[key].depot
				end)
			end,
			function(key)
				return moneyText(function(data) return
					key=="rail" and
					data.construction.rail.track or
					key=="road" and
					data.construction.road.street
				end)
			end,
			function(key)
				return key~="_sum" and moneyText(function(data) return
					data.income[key] +
					(key=="_sum" and
					data.maintenance._sum or
					data.maintenance[key]._sum) +
					data.acquisition[key] +
					(key=="_sum" and
					data.construction._sum or
					data.construction[key]._sum)
				end) or "-"
			end,
			function(key)
				return key~="_sum" and key~="other" and ROIText(function(data) return
					data.income[key] +
					(key=="_sum" and
					data.maintenance._sum or
					data.maintenance[key]._sum) +
					data.acquisition[key] +
					(key=="_sum" and
					data.construction._sum or
					data.construction[key]._sum)
				, data.income[key] 
				end) or "-"
			end,
		},{
			"<empty>",
			_("Income"),
			_("Maintenance").."\n".._("Total"),
			_("Maintenance").."\n".._("Vehicles"),
			_("Maintenance").."\n".._("Infrastructure"),
			_("Acquisition"),
			_("ConstructionJournal").."\n".._("Total"),
			_("ConstructionJournal").."\n".._("Stations"),
			_("ConstructionJournal").."\n".._("Depots"),
			_("ConstructionJournal").."\n".._("TRACK").."/".._("STREET"),
			_("Total"),
			_("Total").."\n".._("ROI"),
		},
		function()
			return updatedata().journal
		end),
		
	} end
}