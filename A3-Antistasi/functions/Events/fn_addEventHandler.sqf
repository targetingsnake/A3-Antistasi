/*
Author: Håkon
Description:
    Registrers an event handler

Arguments:
0. <Any>    Event type identifier
1. <Code
| String>   Code or function name
2. <Bool>   Global (optional - Default: true)
3. <Any>    Any extra arguments to be passed to the handler execution (optional - Default: nil)
4. <Bool>   Execute handler localy where event was triggered (optional - Default: true)

Return Value: <Scalar> Event handler id, -1 if not added

Scope: Server
Environment: unscheduled
Public: Yes
Dependencies:

Example:

License: MIT License
*/
if (!isServer) exitWith {-1};
params ["_eventType", ["_function", "", ["", {}]], ["_addGlobal", true, [true]], "_exstraArguments", ["_execLocaly", true, [true]]];

if (isNil "_eventType") exitWith {-1};
if (_function isEqualType "" && {isNil _function}) exitWith {-1};

private _id = call A3A_fnc_genEventID;
if (!_addGlobal) exitWith { [_eventType, _function, _addGlobal, _exstraArguments, _execLocaly, _id] call A3A_fnc_addEventHandlerLocal };
[_eventType, _function, _addGlobal, _exstraArguments, _execLocaly, _id] remoteExecCall ["A3A_fnc_addEventHandlerLocal", 0];
_id
