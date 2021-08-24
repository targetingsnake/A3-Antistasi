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

Example:
    player addAction ["Jump!", A3A_fnc_richAction_onClick, _RAData];
*/
#include "richActionData.hpp"
params ["_target", "_caller", "_actionId", "_RAData"];

// progress can only start from idle, otherwise it's disabled or already running
if ((_RAData # RADataI_state) isNotEqualTo "idle") exitWith {};
_RAData set [RADataI_state,"progress"];
_RAData spawn {
    private _RAData = _this;

    {inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "NextAction"];  //disable player's action menu

    _RAData call (_RAData # RADataI_fnc_onStart);

    private _interruptToken = [false];
    if ((_RAData # RADataI_state) isEqualTo "progress") then {  // May have been changed by RADataI_fnc_onStart, so it will not refresh or register interruptToken if cancelled.
        _RAData set [RADataI_refresh,true];
        _interruptToken spawn {
            // Wait a second for the key to be released from when the user started the action.
            // If the user holds the key down, thinking it's a BIS hold action, it will add the interrupt as normal and fire on keyUp.
            uiSleep 1;
            A3A_richAction_interruptToken = _this;
        }
    };

    while {(_RAData # RADataI_state) isEqualTo "progress"} do {
        _RAData call (_RAData # RADataI_fnc_onProgress);
        _RAData call A3A_fnc_richAction_render;

        if (_RAData # RADataI_completionRatio >= 1) exitWith {
            _RAData set [RADataI_state,"idle"];
            _RAData call (_RAData # RADataI_fnc_onComplete);
        };

        if (_interruptToken #0) exitWith {
            _RAData set [RADataI_state,"idle"];
            _RAData call (_RAData # RADataI_fnc_onInterrupt);
        };

        uiSleep (_RAData # RADataI_progressSleep);
    };

    {inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];  //enable player's action menu
};
