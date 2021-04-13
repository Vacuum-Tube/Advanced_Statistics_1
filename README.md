# Advanced Statistics
 
This is the codebase for my Transport Fever 2 Mod: https://steamcommunity.com/sharedfiles/filedetails/?id=2454731512

## Structure
I can just roughly explain the structure of this mod. For details you can ask me.

The mod is basically a gamescript which is split into 2 parts: Script and Gui.
The main calculations are executed in the script thread (update, 5x per second). All data is stored in state and passed to the Gui Thread where the data is displayed.
Every (pseudo) entity type has a own script file (where the data of this type is read from the game) and a own gui file (which defines the layout of the data tab). The gui programming uses some basic gui creation helpers (basic.lua) as well as a gui generator (guibuilder.lua) for the simple and flexible way of defining large amounts of (semi-)static data.

## Contribute
I am open to any ideas, suggestions and pull requests. 
Eventually ask me about how to proceed if you are going to make bigger changes before a pull request.

## Concepts
While developing this mod, I extended my knowledge about Lua, the game itself and its scripting and gui interface.
With this mod, I created some helper files, which might be interesting for other modders.
- Level Logger
- List util for counting and values
- Error Handling (catching, stdout write and error window)
- Guibuilder (easy definition of gui layouts)
- Reloader (useful for direct change testing)

## Contact
You can report bugs on "Issues". For general discussions use "Discussions".
You can also comment on Steam or [transportfever.net](https://www.transportfever.net/wsc/index.php?user/29264-vacuumtube/)
