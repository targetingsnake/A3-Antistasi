/*
Maintainer: Caleb Serafin
    On click which activates when action called.

Arguments:
    <OBJECT> target: the object which the action is assigned to                     [not-required]
    <OBJECT> caller: the unit that activated the action                             [not-required]
    <SCALAR> actionID: activated action's ID (same as addAction's return value)     [not-required]
    <ARRAY> Rich Action Data

Return Value:
    <BOOL> If the player will win the next lottery.

Scope: Clients, Global Arguments, Local Effect
Environment: Any
Public: No
Dependancies:
    <HASHMAP> A3A_richAction_blankHashMap

Example:
    player addAction ["Jump!", A3A_fnc_richAction_startProgress, _RAData];
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params ["_target", "_caller", "_actionId", "_RAData"];

// progress can only start from idle, otherwise it's disabled or already running
if ((_RAData get "state") isNotEqualTo "idle") exitWith {};
_RAData set ["state","progress"];

_RAData call (_RAData get "fnc_onStart");
// State may have been changed by fnc_onStart, so it will not continue with progress if set back to idle.
if ((_RAData get "state") isNotEqualTo "progress") exitWith {};

_RAData spawn {
    private _RAData = _this;
    {inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "NextAction"];  //disable player's action menu

    private _interruptToken = [false];
    _RAData set ["refresh",true];
    _interruptToken spawn {
        // Wait a second for the key to be released from when the user started the action.
        // If the user holds the key down, thinking it's a BIS hold action, it will add the interrupt as normal and fire on keyUp.
        uiSleep 1;
        A3A_richAction_interruptToken set [0, true];
        A3A_richAction_interruptToken = _this;
    };

    while {(_RAData get "state") isEqualTo "progress"} do {
        _RAData call (_RAData get "fnc_onProgress");

        if ((_RAData get "disposeToken") #0) exitWith {
            _RAData set ["state","idle"];
        };

        if (_RAData get "completionRatio" >= 1) exitWith {
            _RAData set ["state","idle"];
            _RAData call (_RAData get "fnc_onComplete");
        };

        if (_interruptToken #0) exitWith {
            _RAData set ["state","idle"];
            _RAData call (_RAData get "fnc_onInterrupt");
        };
        // Delay by the specified time, but interrupt if dispose is set.
        private _sleepEndTime = serverTime + (_RAData get "progressSleep");
        waitUntil {
            if ((_RAData get "disposeToken") #0) exitWith {true};
            _RAData call A3A_fnc_richAction_render;
            uiSleep 0.01;
            _sleepEndTime - serverTime <= 0;
        };
    };

    {inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];  //enable player's action menu
};
