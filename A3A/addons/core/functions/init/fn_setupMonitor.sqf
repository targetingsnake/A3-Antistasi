#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()


Info("Setup monitor started");

// Collect all CfgPatches dependencies so that client knows what's available on server
private _loadedPatches = [];
call {
    private _templates = "true" configClasses (configFile/"A3A"/"Templates");
    private _addonVics = "true" configClasses (configFile/"A3A"/"AddonVics");
    {
        {
            if (isClass (configFile/"CfgPatches"/_x)) then { _loadedPatches pushBackUnique _x };
        } forEach getArray (_x/"requiredAddons");
    } forEach (_templates + _addonVics);
};

// Ignore DLC without equipment and vehicles
// Need the true names from here, so pass it all in
private _loadedDLC = getLoadedModsInfo select {_x#3 and !(_x#1 in ["A3","curator","argo","tacops"])};


private _autoLoadTime = "autoLoadLastGame" call BIS_fnc_getParamValue;
private _autoLoadData = nil;
if (_autoLoadTime >= 0) then
{
    Info("Searching for suitable saves for automatic loading");

    private _saveData = call A3A_fnc_collectSaveData;
    private _index = _saveData findIf {
        isNil {_x get "ended"}
        and _x get "map" == worldName 
        and !isNil {_x get "factions"}
    };
    if (_index == -1) exitWith {
        Info("No usable saves found for automatic loading");
        _autoLoadTime = -1;
    };
    _autoLoadData = _saveData select _index;
    _autoLoadData set ["startType", "load"];
    Info_1("Save ID %1 selected for automatic loading", _autoLoadData get "gameID");
    _autoLoadTime = time + _autoLoadTime;
};


// TODO: move this to initClient?
[localize "STR_A3A_feedback_serverinfo", localize "STR_A3A_feedback_serverinfo_adminwait"] remoteExec ["A3A_fnc_customHint", 0];

// startGame function needs to know setupPlayer for sanity-checking
A3A_setupPlayer = objNull;

private _fnc_validAdmin = {
    admin owner _this == 2 or						// non-voted admin on DS
    {_this isEqualTo player and hasInterface}		// localhost. returns admin owner _this = 0 for some reason
};

// Setup monitor loop
while {isNil "A3A_saveData"} do {
    sleep 1;

    if (isNull A3A_setupPlayer and _autoLoadTime != -1 and time > _autoLoadTime) then {
        [_autoLoadData] call A3A_fnc_startGame;
        _autoLoadTime = -1;
        continue;					// if autoload save wasn't valid then carry on
    };

    if (!isNull A3A_setupPlayer) then {
        // check that they're still admin?
        if (A3A_setupPlayer call _fnc_validAdmin) then { continue };

        Info_1("Player %1 is no longer admin, disabling their setup dialog", name A3A_setupPlayer);

        ["serverClose"] remoteExec ["A3A_fnc_setupDialog", A3A_setupPlayer];
        A3A_setupPlayer = objNull;
    };

    // No-one currently in setup. Go find the admin.
    private _players = allPlayers - entities "HeadlessClient_F";
    private _adminIndex = _players findIf { _x call _fnc_validAdmin };
    if (_adminIndex == -1) then { continue };

    A3A_setupPlayer = _players select _adminIndex;
    Info_1("Player %1 is now admin, sending them the save data", name A3A_setupPlayer);

    // Collect save data. Do this each time so consistency is maintained with deletes
    private _saveData = call A3A_fnc_collectSaveData;
    DebugArray("Save data found:", _saveData);
    ["sendData", [_saveData, _loadedPatches, _loadedDLC]] remoteExec ["A3A_fnc_setupDialog", A3A_setupPlayer];
};

Info("Setup monitor terminated");
