/*
Maintainer: Caleb Serafin
    Adds or removed help for dismantling a structure.
    Variables are calculated and broadcast from single machine to avoid race conditions.

Arguments:
    <OBJECT> The structure being disassembled.
    <SCALAR> The amount of watts to add (negative to remove)

Scope: Dismantling Client, Global Effect
Environment: Unscheduled
Public: No

Example:
    [_structure,2] remoteExecCall ["A3A_fnc_dismantleAddAssist",_dismantler];
*/

params ["_structure","_addWatts"];
private _filename = "Foo\fn_dismantleAddAssist.sqf";

private _timeLeft = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
private _watts = _structure getVariable ["A3A_dismantle_watts",0];
private _joulesRemaining = _timeLeft * _watts;

_watts = _addWatts + _watts;
_timeLeft = ceil (_joulesRemaining / _watts);

_structure setVariable ["A3A_dismantle_watts",_watts,true];
_structure setVariable ["A3A_dismantle_eta",serverTime + _timeLeft,true];
