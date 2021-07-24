/*
Author: Håkon
Description:
    Handles un-registrering an event handler on the local machine

Arguments:
0. <Any>    Event type identifier
1. <Scalar> Handler ID

Return Value:
<Bool> Handler deleted

Scope: Any
Environment: Any
Public: No
Dependencies:

Example:

License: MIT License
*/
params ["_type",["_id", -1, [0, true]]];

if (isNil "A3A_EventHandlers") exitWith {false};
if (isNil "_type") exitWith {false};
if (_id isEqualType true) exitWith {
    if (_id) then {A3A_EventHandlers deleteAt _type};
    _id
};

private _eventHandlers = A3A_EventHandlers getOrDefault [_type, createHashMap];
(A3A_EventHandlers get _type) deleteAt _id;
true;
