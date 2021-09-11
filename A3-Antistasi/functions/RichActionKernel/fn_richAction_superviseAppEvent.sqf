/*
Maintainer: Caleb Serafin
    Trys to run the provided event.
    If the app does not return true, reportAppError is called to report it.

Arguments:
    <RAData> Rich Action Data
    <STRING> onEventName

Scope: Clients, Local Arguments, Local Effect
Environment: Unscheduled.
Public: No

Example:
    [_RAData,"fnc_onIdle"] call A3A_fnc_richAction_superviseAppEvent;
*/
#include "config.hpp";
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params [
    "_RAData",
    ["_onEventName","EventNameMissing", [ "" ]]
];

#ifdef __ErrorOnAppTimeout
    private _timeoutKey = (_RAData get "RAID") + ":" + _onEventName;
    A3A_richAction_appStartTimes set [_timeoutKey, [serverTime,_RAData]];
#endif

#ifdef __ErrorOnBadAppReturn
    private _return = _RAData call (_RAData getOrDefault [_onEventName,{false}]);
    if ( isNil {_return} || { _return isNotEqualTo true }) exitWith {
        [_RAData, systemTimeUTC, _onEventName] call A3A_fnc_richAction_reportAppError;
        (_RAData get "dispose") set [0,true];
    };
#else
    _RAData call (_RAData getOrDefault [_onEventName,{}])
#endif

#ifdef __ErrorOnAppTimeout
    A3A_richAction_appStartTimes deleteAt _timeoutKey;
#endif