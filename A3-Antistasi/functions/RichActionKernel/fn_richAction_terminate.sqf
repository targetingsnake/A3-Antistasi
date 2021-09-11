/*
Maintainer: Caleb Serafin
    Calculates the logarithmic mean of the arguments.
    Places a marker on the map where Petros is not standing.
    Finally, concludes whether the player will win the next lottery.

Arguments:
    <STRING> The first argument
    <OBJECT> The second argument
    <SCALAR> Float or number in SQF.
    <INTEGER> If the number cannot have fractional values.
    <BOOL> Optional input (default: true)
    <ARRAY<STRING>> Array of a specific type (string in this case).
    <STRING,ANY> A key-pair as compound type, shorthand by omitting ARRAY.
    <CODE|STRING> Optional input with synonymous types, string compiles into code. (default: {true})
    <STRING> Optional singular String input | <ARRAY> Optional Array input (default: [""])
    <CODE<OBJECT,SCALAR,SCALAR,STRING>> Code that takes arguments of an object, a scalar, a scalar, and returns a string.

Return Value:
    <BOOL> If the player will win the next lottery.

Scope: Server/Server&HC/Clients/Any, Local Arguments/Global Arguments, Local Effect/Global Effect
Environment: Scheduled
Public: Yes/No
Dependencies:
    <STRING> A3A_guerFactionName
    <SCALER> LBX_lvl1Price

Example:
    [_RAData] spawn A3A_fnc_richAction_terminate;
*/
#include "config.hpp"
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params ["_RAData"];

private _beenDisposedToken = _RAData get "hasBeenDisposedToken";

_RAData set ["dispose",true];
uiSleep __disposeTimeout;
if (_beenDisposedToken #0) exitWith {};

_RAData spawn {
    private _RAData = _this;
    _RAData call (_RAData get "fnc_onDispose");
    (_RAData get "target") removeAction (_RAData get "actionID");
    localNamespace setVariable [_RAData get "RAIDName",nil];  // Frees hashmap. Note that key will persist in `allVariables localNamespace`, likely an Arma bug.
    (_RAData get "hasBeenDisposedToken") set [0,true];
}
uiSleep __disposeTimeout;
if (_beenDisposedToken #0) exitWith {};

// Does not call app's dispose code as it probably caused a problem.
(_RAData get "target") removeAction (_RAData get "actionID");
localNamespace setVariable [_RAData get "RAIDName",nil];
_beenDisposedToken set [0,true];

