/*
Author: Håkon
Description:
    Executes eventhandlers for the triggered event

Arguments:
0. <Any> Event type
1. <Array> Event arguments

Return Value: <Bool> Event handled

Scope: Any
Environment: Any
Public: Yes
Dependencies:

Example:

License: MIT License
*/
params ["_event", ["_arguments", []]];
if (isNil "_event") exitWith {false};

_execHandler = {
    //local event
    if (!_addGlobal || _execLocaly) exitWith { (_arguments + [_extraArguments]) call _function };

    //global event
    if (_function isEqualType "") then {
        [_arguments + [_extraArguments]] remoteExecCall [_function, 0];
    } else {
        [_function, [_arguments + [_extraArguments]] ] remoteExecCall ["call", 0];
    };
};

{
    _y params ["_function", "_extraArguments", "_addGlobal", "_execLocaly"];
    call _execHandler
} forEach (A3A_EventHandlers getOrDefault [_event, []]);

true;
