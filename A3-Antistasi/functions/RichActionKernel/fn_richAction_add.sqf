/*
Maintainer: Caleb Serafin
    Add an advanced and fast hold action.
    Player can interrupt by tapping the space key, (But still supports backwards use of holding space down then releasing!)
    The parameters after _RAData cannot be changed during runtime. So choose wisely
    addActions arguments extracted from https://community.bistudio.com/wiki/addAction

Arguments:
    <ARRAY> Rich Action Data. Values can be set before the action is created. See A3A_fnc_richAction_newRAData for values you can override. [Default=false]
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
    Dev_actionData = [false,player] call A3A_fnc_richAction_add;
    // Remove hold action
    Dev_actionData set ["_dispose",true];

    // Full list;
    [_RAData,_target,_priority,_keyShortcut,_radius,_showUnconscious,_modelSelection,_modelMemoryPoint] call A3A_fnc_richAction_add;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
private _hashmap0 = createHashMap;
params [
    ["_RAData", false, [false,_hashmap0]],
    ["_target", objNull,[objNull]],
    ["_priority", 1000,[123]],
    ["_keyShortcut", "",[""]],
    ["_radius", 15,[123]],
    ["_showUnconscious", false,[false]],
    ["_modelSelection", "",[""]],
    ["_modelMemoryPoint", "",[""]]
];

if (_target isEqualTo objNull) exitWith {
    Error("_target was objNull");
};

// Rich Action ID is used to store the shared Array used by this instance. This is an alternative to large string code insertion for addAction's conditionShow. It also allows updating it by reference.
private _RAID = -1;
isNil A3A_fnc_richAction_init;
isNil {
    _RAID = A3A_richAction_RAIDCounter;
    A3A_richAction_RAIDCounter = A3A_richAction_RAIDCounter +1;
};

if (_RAData isEqualType false) then {
    _RAData = [] call A3A_fnc_richAction_newRAData;
};

private _RAID_dataName = "A3A_richAction_data_" + str _RAID;
_RAData set ["RAID",_RAID];
_RAData set ["RAIDName",_RAID_dataName];
_RAData set ["target",_target];

localNamespace setVariable [_RAID_dataName,_RAData];
private _bootstrapper = '(localNamespace getVariable "'+_RAID_dataName+'") call A3A_fnc_richAction_idle';

// Add the action
private _actionID = _target addAction ["Error, text not overridden.", A3A_fnc_richAction_startProgress, _RAData, _priority, true, false, _keyShortcut, _bootstrapper, _radius, _showUnconscious, ""];
_RAData set ["actionID",_actionID];

_RAData;
