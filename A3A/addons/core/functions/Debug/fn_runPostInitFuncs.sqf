/*
Author: Håkon
Description:
    Runs the post init functions compiled by prepFunctions

Arguments:Nil

Return Value: <Bool> done

Scope: Any
Environment: Any
Public: No
Dependencies: A3A_postInitFuncs

Example:

License: MIT License
*/
if (isNil "A3A_postInitFuncs" || { !(A3A_postInitFuncs isEqualType []) }) exitWith { false };
{ call (missionNamespace getVariable _x) } forEach A3A_postInitFuncs;

true
