--local 
avs = {
	script = require "advanced_statistics/script",
	gui = require "advanced_statistics/gui",
	datalist = require "advanced_statistics/datalist",
	thread = require "advanced_statistics/thread",
	log = require "advanced_statistics/log",
	package = require "advanced_statistics/package",
	strings = require "advanced_statistics/strings",
}

avs.log(1,"Loaded advanced_statistics/main")--,"Thread:",avs.thread.getCurrentThread())
avs.log(2,"Data Types:")
avs.log.logTab(2,avs.datalist)

return avs