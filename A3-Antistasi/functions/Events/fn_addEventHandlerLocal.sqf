/*
Author: Håkon
Description:
    Handles registrering an event handler on the local machine

Arguments:
0. <Any>    Event type identifier
1. <Code
| String>   Code to execute or function name
2. <Bool>   Global (optional)
3. <Any>    Any extra arguments to be passed to the handler execution (optional)
4. <Bool>   Execute handler localy where event was triggered

Return Value: <Nil>

Scope: Any
Environment: unscheduled
Public: No
Dependencies:

Example:

License: MIT License
*/
params ["_eventType", "_function", "_addGlobal", "_exstraArguments", "_execLocaly", "_id"];

if (isNil "A3A_EventHandlers") then {A3A_EventHandlers = createHashmap};
private _events = if !(_eventType in A3A_EventHandlers) then {
    A3A_EventHandlers set [_eventType, createHashMap];
};

(A3A_EventHandlers get _eventType) set [_id ,[_function, _exstraArguments, _addGlobal, _execLocaly]];
