--local 
avs = {
	script = require "advanced_statistics/script",
	gui = require "advanced_statistics/gui",
	datalist = require "advanced_statistics/datalist",
	thread = require "advanced_statistics/thread",
	log = require "advanced_statistics/log",
	package = require "advanced_statistics/package",
	strings = require "advanced_statistics/strings",
	info = require "advanced_statistics/info",
}

avs.log(1,"Loaded advanced_statistics/main ", string.format("%s %d.%d", ("Version"), avs.info.version.major, avs.info.version.minor) )--,"Thread:",avs.thread.getCurrentThread())
avs.log(2,"Data Types:")
avs.log.logTab(2,avs.datalist)

return avs