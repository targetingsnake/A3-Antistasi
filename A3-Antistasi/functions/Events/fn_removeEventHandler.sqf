/*
Author: Håkon
Description:
    Un-registrers an event handler

Arguments:
0. <Any>    Event type identifier
1. <Scalar
|   Bool>   Handler ID or true to delete all
2. <Bool>   Delete handler globaly

Return Value:
<Bool> Handler deleted

Scope: Any
Environment: Any
Public: Yes
Dependencies:

Example:

License: MIT License
*/
params ["_type", "_id", ["_global", false, [true]]];
if (isNil "_type") exitWith {false};
if (_id isEqualTo -1) exitWith {false};
if (_id isEqualType true && {!_id}) exitWith {false};

if (_global) then {
    [_type, _id] remoteExecCall ["A3A_fnc_removeEventHandlerLocal", 0];
} else {
    [_type, _id] call A3A_fnc_removeEventHandlerLocal;
};
true
