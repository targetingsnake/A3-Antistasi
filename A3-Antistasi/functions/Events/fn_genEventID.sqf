/*
Author: Håkon
Description:
    Generates a id for use with adding event handlers

Arguments: <Nil>

Return Value:
<Scalar> Handler ID

Scope: Server,Server/HC,Clients,Any
Environment: Scheduled/unscheduled/Any
Public: Yes/No
Dependencies:

Example:

License: MIT License
*/
if (!isServer) exitWith {-1};
if (isNil "A3A_EventID") then {A3A_EventID = -1};
A3A_EventID = (A3A_EventID +1) % 1e7;
A3A_EventID
