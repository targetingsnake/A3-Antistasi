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
Environment: Scheduled/Unscheduled/Any
Public: Yes/No
Dependencies:
    <ARRAY> A3A_richAction_blacklistedAppDumps
    <HASHMAP> A3A_richAction_blacklistedAppDumps

Example:
    private _data = "Hello World";
    [createHashMapFromArray [["appName",str random 1000],[0,_data]], systemTimeUTC, "OverTheRainBow"] call A3A_fnc_richAction_reportAppError;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_RAData", createHashMap, [ A3A_richAction_blankHashMap ]],
    ["_timeOfErrorUTC",[1984,1,22,21,15,0,0],[ [] ], [7]],
    ["_onEventName","", [ "" ]]
];

private _appName = "Unknown App";
private _appLabel = "an unknown app";
if ("appName" in _RAData) then {
    private _appNameUnsafe = _RAData get "appName";
    if (_appNameUnsafe isEqualType "") then {
        _appName = _appNameUnsafe;
        _appLabel = "app '"+_appName+"'";
    };
};


Error_3("Critical error occurred in %1 by event %2 at %3. App terminated.",_appLabel,_onEventName,_timeOfErrorUTC);
if (LogLevel > 2) then {
    if (_appName in A3A_richAction_blacklistedAppDumps) exitWith {
        Debug_1("App's variable dumps have been blacklisted. Scroll up or search for `Dumping variables from %1`",_appLabel);
    };
    A3A_richAction_blacklistedAppDumps pushBack _appName;
    [_RAData,_appLabel] spawn {
        params ["_RAData","_appLabel"];
        Debug("Preparing variables from %1.",_appLabel);
        //private _stringDump = [_RAData,9000000,1e-3] call A3A_fnc_dumpBasic_dump;  // Soon™
        private _stringDump = str _RAData;  // Will throw an error if there is a circular referrence.

        private _charCount = count _stringDump;
        private _maxLineLength = 1000;

        Debug("Dumping variables from %1:",_appLabel);
        private _charPointer = 0;
        while {_charPointer < _charCount} do {
            private _chunk = _stringDump select [_charPointer,_maxLineLength];
            _charPointer = _charPointer + _maxLineLength;
            Debug("~ "+_chunk);
        };
    }
} else {
    Debug("Not Dumping Var States, log level must be debug.");
};

Debug("Dumping Call Stack:");
//assert false;
