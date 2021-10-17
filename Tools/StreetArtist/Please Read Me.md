# 🚀 Quick Start Guide
0.  Run Arma 3.
1.  Make an empty mp-mission on any map (community or official) with just one player.
2.  Save and close the editor.
3.  Locate the folder `A3-Antistasi\Tools\StreetArtist\`.
4.  Copy Everything in this folder (includes: /Collections/; /functions/; /description.ext; /functions.hpp; /NG_importGUI.hpp)
5.  Paste into the folder of the mp mission you created. Usually in `C:\Users\User\Documents\Arma 3 - Other Profiles\YOUR_ARMA_NAME\mpmissions\MISSION_NAME.MAP\`
6.  Start host LAN multiplayer.
7.  Run and join the mission.
8.  Press `Esc` on your keyboard to open debug console.
9.  Paste `[] spawn A3A_fnc_NG_main` into big large debug window.
10.  Click the button `Local Exec`.
11. Exit Debug Console, look down, and open map.
12. Wait for it to start drawing markers.
13. Open a new file.
14. Paste into the new file.
15. Save.

<br/>
<br/>

See [Steet Artist Editor](https://github.com/official-antistasi-community/A3-Antistasi/wiki/Street-Artist-Editor) for A3-Antistasi navGrid Guidelines (and GIFs!).<br/>
***
***

# 🗺 Generate navGridDB & open the StreetArtist Editor
Executing `[] spawn A3A_fnc_NG_main` will run with default settings.<br/>
Looking down gives the best performance during this process. You can lower render distance if it helps.<br/>
However, you may need to tweak some arguments depending on the simplification level required for the map.<br/>
### ⚙ A3A_fnc_NG_main Arguments:
1.  <SCALAR> Max drift is how far the simplified line segment can stray from the road in metres. (Default = 50)
2.  <SCALAR> Junctions are only merged if within this distance from each other. (Default = 15)
3.  <BOOLEAN> True to automatically start the StreetArtist Editor. (Default = true)

To run with default and not edit use `[nil,nil,false] spawn A3A_fnc_NG_main;`<br/>
Max drift is not the only thing that affects road simplification: It will only simplify if the nearestTerrainObject from its position will still return one of it's neighbouring roads. This prevents virtual convoys that are trying to spawn vehicles from jumping to another nearby road because that is the closest navGrid node.<br/>

### 🔄 Multiple Simplification Iterations
Sometimes a map's roads might be complex and messay. As a tempory solution you can increase the simplification steps to cut down a few nodes and connections. Before running `A3A_fnc_NG_main` Set the variable `A3A_NGSA_generation_simplifyLoops = 5;` or a smaller number. More than 5 loops ussually don't make any impact on the nav grid.<br/>
This is complimented well by increasing the junction merge distance to `20` metres. Note that if the junction merge distance is too large, urban areas might have intersections merge (But this can be fixed in the StreetArtist Editor).
### ☢ Data Model Assertions
If you discover a map that causes StreetArtist to produce errors and corrupted data, well done! If you want to fix the problem yourself, great! You can set `A3A_NGSA_navRoad_assert = true;` and `A3A_NGSA_navRoadHM_assert = true;` before running `A3A_fnc_NG_main`. This will ussually take 10x longer to run, but it will show you where data corruption first appears.

# ✏ Directly open the StreetArtist Editor
## 📥 Import Exising navGridDB
If you have already generated a navGridDB before loading the world and you do not want to regenerate it again: you can use the import function to load it into Arma 3 for viewing or editing.

1. Local exec `[] spawn A3A_fnc_NGSA_main` in the debug console.
2. Press `Continue` to close debug console. (If you press `Esc`, you will close the import dialogue!)
3. Switch to real-life and open the navGridDB file and Copy everything.
4. Switch to Arma 3 and paste it into the editBox and press the the import button.<br/>

## 🏜 Start Fresh from a Empty Grid

1. Local exec `[true] spawn A3A_fnc_NGSA_main` in the debug console.

# 🔎 Further Reading
See [Steet Artist Editor](https://github.com/official-antistasi-community/A3-Antistasi/wiki/Street-Artist-Editor) for A3-Antistasi navGrid Guidelines (and GIFs!).<br/>
You can find further satisfying and accurate documentation on all sorts of things by looking into the headers of files in `./functions/StreetArtist/`.

<br/>
<br/>

***

![Unit_traits_hint](https://i.imgur.com/wAMAYlX.png)
