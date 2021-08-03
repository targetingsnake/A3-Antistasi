/*
Maintainer: Caleb Serafin
    Adds or removed help for dismantling a structure.
    Variables are calculated and broadcast from single machine to avoid race conditions.

Arguments:
    <OBJECT> The structure being disassembled.
    <OBJECT> The unit sent to assist. Can be human or AI.
    <BOOLEAN> Add or removed this unit's assistance.

Scope: Server, Global Effect
Environment: Unscheduled
Public: No

Example:
    [_structure,player,true] remoteExecCall ["A3A_fnc_dismantleAssist",2];
*/
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

params [
    ["_structure",objNull,[objNull]],
    ["_unit",objNull,[objNull]],
    ["_add",true,[true]]
];

if (_structure isEqualTo objNull) exitWith {};  // If structure was removed by the time a request went to server.

private _helpers = _structure getVariable ["A3A_dismantle_helpers",[]];
if (_add && {_unit in _helpers} || (!_add) && {!(_unit in _helpers)}) exitWith {};
if (_add) then {
    _helpers pushback _unit;
} else {
    _helpers deleteAt (_helpers find _unit);
};
_structure setVariable ["A3A_dismantle_helpers",_helpers];

private _timeLeft = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
private _watts = _structure getVariable ["A3A_dismantle_watts",0];
private _joulesRemaining = _timeLeft * _watts;
if (_watts == 0) then {
    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_structureCost",0]];
    _joulesRemaining = _joules;
};

private _additionalWatts = ([-1,1] select _add) * ([SOLDIER_WATTS,ENGINEER_WATTS] select (_unit getUnitTrait "engineer"));
_watts = _additionalWatts + (_watts max 0);
if (_watts <= 0) then {
    _watts = -DECAY_WATTS;
};
_timeLeft = _joulesRemaining / _watts;

//systemChat ("ADD ASSIST _watts: "+(_watts toFixed 0)+"_timeLeft: "+(_timeLeft toFixed 0));
_structure setVariable ["A3A_dismantle_watts",_watts,true];
_structure setVariable ["A3A_dismantle_eta",serverTime + _timeLeft,true];

if !(_structure getVariable ["A3A_dismantle_hasHost",false]) then {
    _structure setVariable ["A3A_dismantle_hasHost",true];
    [_structure] spawn A3A_fnc_dismantleHost;
};
