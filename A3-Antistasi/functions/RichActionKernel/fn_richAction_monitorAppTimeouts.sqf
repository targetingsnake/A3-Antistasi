/*
Maintainer: Caleb Serafin
    Checks that all apps have finished their execution without crashing.
    If an unfinished app is detected, then the action is terminated.

Scope: Clients, Local Effect
Environment: Scheduled
Public: No
Dependencies:
    <HASHMAP> A3A_richAction_appStartTimes

Example:
    [] spawn A3A_fnc_richAction_monitorAppTimeouts;
*/
#include "config.hpp"
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

if (!canSuspend) exitWith {Error("Must run in scheduled enviroment.");};
#ifndef __ErrorOnAppTimeout
    if (true) exitWith {};
#endif

private _checkDuration = 5 * 60;

while {true} do {
    private _timeoutExpiry = serverTime - __appTimeout;
    {
        if (_y#0 < _timeoutExpiry) then {
            [_y#1,systemTimeUTC,_x] spawn {
                params ["_RAData","_systemTimeUTC","_RAIDAndEventName"];
                [_RAData] call A3A_fnc_richAction_terminate;
                [_RAData, _systemTimeUTC, _RAIDAndEventName] call A3A_fnc_richAction_reportAppError;
            }
        };
    } forEach A3A_richAction_appStartTimes;
    sleep _checkDuration;
};