/*
Maintainer: Caleb Serafin
    Returns a new instance of Rich Action Data.
Arguments:
    <MAP> Fields to override default values. (Default = nil)
Return Value:
    <HASHMAP>, but this specific structure will be refereed to as <RAData>
Public: Yes
Example:
    [] call A3A_fnc_richAction_newRAData;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
private _newRAData = createHashMapFromArray [
    // Public Read, Private Write
    ["RAID",-1],
    ["RAIDName",""],
    ["target",objNull],
    ["actionID",-1],
    ["refresh",false],
    ["idleSleepUntil",0],
    ["renderSleepUntil",0],
    ["errorCounter",0],
    ["hasBeenDisposedToken",[false]],

    // Public Read & Write
    // App Settings
    ["appName","No Name Brand"],
    ["appStore",nil],
    ["appDevelopmentMode",false],  // Will display statistics during runtime.
    ["errorResponse","terminate"],  // "terminate", "tryReinstall", "tryIgnore"
    ["fallbackRAData",[]],  // Used when tryReinstall error response is called.
    ["fallbackAppStore",[]],  // Used when tryReinstall error response is called.

    // States
    ["dispose",[false]],
    ["state","idle"],
    ["completionRatio",0],

    // Sleeps
    ["idleSleep",0.5],
    ["progressSleep",0.01],
    ["renderSleep",0.07],

    // App Events
    ["fnc_onRender",{true}],
    ["fnc_onIdle",{true}],
    ["fnc_onStart",{true}],
    ["fnc_onProgress",{true}],
    ["fnc_onInterrupt",{true}],
    ["fnc_onComplete",{true}],
    ["fnc_onDispose",{true}],

    // Graphics
    ["menuText","Error: menuText not overriden!"],
    ["gfx_idle",[["context","Idle Gfx"]] call A3A_fnc_richAction_newRAGfx],
    ["gfx_disabled",[["context","Disabled Gfx"]] call A3A_fnc_richAction_newRAGfx],
    ["gfx_progress",[["context","Progress Gfx"]] call A3A_fnc_richAction_newRAGfx],
    ["gfx_override",[["context","Override Gfx"]] call A3A_fnc_richAction_newRAGfx]
];
if !(isNil {_this}) then {
    if !(_this isEqualType []) exitWith {
        Error_1("Passed arguments are not type <ARRAY>, but type of <%1>.",typeName _this);
    };
    _newRAData insert _this;
};
_newRAData;
