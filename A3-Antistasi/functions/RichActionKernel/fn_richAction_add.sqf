/*
Maintainer: Caleb Serafin
    Add an advanced and fast hold action.
    Player can interrupt by tapping the space key, (But still supports backwards use of holding space down then releasing!)
    The parameters after _RAData cannot be changed during runtime. So choose wisely
    addActions arguments extracted from https://community.bistudio.com/wiki/addAction

Arguments:
    <ARRAY> Rich Action Data. Values can be set before the action is created. See richActionData.hpp Public for values you can override. [Default=false]
    <OBJECT> Unit, vehicle or static object. No agents and simple objects!
    <SCALAR> Priority value of the action. Actions will be arranged in descending order according to this value. Can be negative or fraction. Same priorities will be arranged in newest at the bottom. [Default=1.5]
    <STRING> One of the key names defined in bin.pbo (e.g. "moveForward"). Adding shortcut will bind corresponding keyboard key to this action. Shortcut can be tested with inputAction command [Default=""]
    <SCALAR> Maximum 3D distance in meters between the activating unit's eyePos and the object's memoryPoint, selection or position. -1 disables the radius. [Default=15]
    <BOOLEAN> If true will be shown to incapacitated player. See also setUnconscious and lifeState. [Default=false]
    <STRING> object's geometry LOD's named selection [Default=""]
    <STRING> object's memory point. If selection is supplied, memoryPoint is not used [Default=""]

Return Value:
    <ARRAY> Same reference to _RAData.

Scope: Clients, Local Arguments, Local Effect
Environment: Any
Public: Yes
Dependencies:
    <CODE> A3A_fnc_richAction_init needs to be finished.

Example:
    // Add hold action
    Dev_actionData = [false,player] call A3A_fnc_richAction;
    // Remove hold action
    Dev_actionData set ["_dispose",true];

    // Full list;
    [_RAData,_target,_priority,_keyShortcut,_radius,_showUnconscious,_modelSelection,_modelMemoryPoint] call A3A_fnc_richAction;
*/
#define __defineNewFunctions
#include "richActionData.hpp"
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_RAData",false,[ false,[] ], [RADataI_count]],
    ["_target",objNull,[objNull]],
    ["_priority",1000,[123]],
    ["_keyShortcut","",[""]],
    ["_radius",15,[123]],
    ["_showUnconscious",false,[false]],
    ["_modelSelection","",[""]],
    ["_modelMemoryPoint","",[""]]
];

if (_target isEqualTo objNull) exitWith {
    Error("_target was objNull");
};

// Rich Action ID is used to store the shared Array used by this instance. This is an alternative to large string code insertion for addAction's conditionShow. It also allows updating it by reference.
private _RAID = -1;
isNil {
    _RAID = A3A_richAction_RAIDCounter;
    A3A_richAction_RAIDCounter = A3A_richAction_RAIDCounter +1;
};

if (_RAData isEqualType false) then {
    _RAData = new_RAData;
};

private _RAID_dataName = "A3A_richAction_data_" + str _RAID;
_RAData set [RADataI_RAID,_RAID];
_RAData set [RADataI_RAIDName,_RAID_dataName];
_RAData set [RADataI_target,_target];

localNamespace setVariable [_RAID_dataName,_RAData];
private _bootstrapper = "(localNamespace getVariable "+_RAID_dataName+") call A3A_fnc_richAction_bootstrapper;";

// Add the action
private _actionID = _target addAction ["Error, text not overridden.", A3A_fnc_richAction_onClick, _RAData, _priority, true, false, _keyShortcut, _bootstrapper, _radius, _showUnconscious, ""];
_RAData set [RADataI_actionID,_actionID];


/*
_RAData insert [
    // Read only variables.
    ["_RAID",_RAID],
    ["_target",_target],
    ["_actionID",_actionID],

    ["_dispose",false],  // Disposal variable, deletes action.
    ["_refresh",false],  // Hides and shows the action when the user starts. This is needed to prevent the action from fading out while the holdAction is still in progress.
    ["_idleSleepUntil",0] // Do not set, used for determining when to come out of sleep.
];
*/

private _insertIfEmpty = [
    // Visibility and progress settings
    ["_state","idle"],   // hidden, disabled, idle, progress
    ["_overlayLayers",[]],  // Names of graphics that will replace any provided fields. ie ["_graphics_techno"]
    ["_autoInterrupt",true],
    ["_completionProgress",0],
    ["_completionGoal",1],

    // Custom set events
    ["_codeIdle",{
        if (_RAData get "_completionProgress" > 0) then {
            _RAData set ["_completionProgress",((_RAData get "_completionProgress") -1/16) max 0];  // Rate will be double due to higher tick rate.
            if (_RAData get "_completionProgress" <= 0) then {
                _RAData get "_graphics_idle" set [3, [2,A3A_richAction_texturesOrbitSegments]];
            };
        };
    }],
    ["_codeStart",{ _RAData set ["_progressSleep",1/16]; _RAData set ["_completionGoal",9.75]; }],
    ["_codeProgress",{ _RAData set ["_completionProgress",(_RAData get "_completionProgress")+1/16]; }],
    ["_codeCompleted",{ _RAData set ["_dispose",true]; }],
    ["_codeInterrupted",{ _RAData set ["_idleSleep",1/16]; _RAData get "_graphics_idle" set [3, [0,A3A_richAction_texturesClockwiseCombined]]; }],

    ["_idleSleep",0.01], // little faster than 60Hz.
    ["_progressSleep",0.01], // little faster than 60Hz.

    // Default Text and image animations.
    ["_graphics_idle",[
        "<t align='left'>A3A Hold Action</t>   <t color='#ffae00' align='right'>" + A3A_richAction_keyName + "     </t>",  // Menu Text  // Those right are required to prevent the text from hanging ut of the menu.
        A3A_richAction_standardSpacer+(format [A3A_richAction_pressSpaceTo,"color='#ffae00'","Commence The Reckoning"])+"<br/>Must survive for 9¾ seconds.",  // On-screen Context Text
        A3A_richAction_iconIdle,  // Icon
        [2,A3A_richAction_texturesOrbitSegments]  // 12 Frames.  // Background
    ]],
    ["_graphics_disabled",[
        nil /*Load from idle*/,  // Menu Text
        nil /*Load from idle*/,  // On-screen Context Text
        A3A_richAction_iconDisabled,  // Icon
        [4,A3A_richAction_texturesRingBreath]  // 60 Frames.  // Background
    ]],
    ["_graphics_progress",[
        nil /*Load from idle*/,  // Menu Text
        [0,["Started.","Good Progress.","Almost There.","You can Taste It!"]],  // On-screen Context Text
        A3A_richAction_iconProgress,  // Icon
        [0,A3A_richAction_texturesClockwiseCombined]   // 55 Frames. // Background
    ]]
];
{
    if !((_x#0) in _RAData) then {
        _RAData set _x;
    };
} forEach _insertIfEmpty;


_RAData;
