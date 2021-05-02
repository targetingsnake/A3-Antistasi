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

params ["_structure","_watts"];
private _filename = "Foo\fn_dismantleAddAssist.sqf";

_watts = _watts + _structure getVariable ["A3A_dismantle_watts",0];
_structure setVariable ["A3A_dismantle_watts",_watts,true];

private _joulesRemaining = A3A_dismantle_sharedDataMap get "_joulesRemaining";
private _timeLeft = ceil (_joulesRemaining / _watts);    // This is defined in holdAction's parent scope
_structure setVariable ["A3A_dismantle_eta",serverTime + _timeLeft,true];
