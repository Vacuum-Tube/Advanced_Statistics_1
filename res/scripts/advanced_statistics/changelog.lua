return [[
1.18  2023-06-19
- Display 3-degree track nodes as "Switch"
- Check for multiline resource names to prevent displaying bug

1.17  2023-03-03
- Fix rare issue leading to unreadable mission state file

1.16  2023-02-11
- Correct text for difficulty 'very hard'

1.15  2023-02-04
- Fix crash on Reload (related to UI destroy on callback)

1.14  2022-12-04
- Add new tab 'world'
- Add info of terrain and water (area is not accurate due to weird self-intersecting polygons)

1.13  2022-10-14
- Fix/Workaround crash for weird stations (e.g. created by Freestyle Mod if combined cargo/person)

1.12  2022-04-02
- Add new con. type WATER_WAYPOINT (spring update)

1.11  2022-02-01
- Fix modelRep issue when models are removed from savegame (api.res.modelRep.getAll not working correctly!)
- Fix Translate issues (Translate still buggy in Callback Events!)
- CommonAPI Modmanager: Show mod name properly

1.10  2021-09-17
- Stabilized, workarounds for some of the errors (not 100% resolved)

1.9  2021-07-13
- Improve fallback for mysterious errors
- Supplied towns: consider towns without cargo needs; redefine completely to 75%
- Add sound effect to donate button

1.8  2021-07-02
- Minor changes

1.7  2021-06-21
- Adjust to new con. type TRACK_CONSTRUCTION (resources)
- Adjust to new railroad crossing state
- Add more logs and error handling

1.6  2021-05-27
- Transportfever.net Release

1.5  2021-05-21
- Add total carrier values to finances tab
- Add free data button, to reduce state size

1.4  2021-05-17
- New finances tab
- Warning message for placeholder cubes
- Set default Log Level back to 1

1.3  2021-04-18
- Add russian translation
- Improve error logs

1.2  2021-04-13
- Extend Log messages
 
1.1  2021-04-12
- Add steam mod link
- Fix api.engine.util.getTransportedData not available (old game version)
- Set up GitHub repository
- Add changelog view

1.0  2021-04-12
Release
]]