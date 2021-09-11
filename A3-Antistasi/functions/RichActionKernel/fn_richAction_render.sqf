/*
Maintainer: Caleb Serafin
    Selects the current gfx based on state.
    Selects the current frames of the animations.
    Updates the action with appropriate icon and text.
    Render frequency is controlled by __RADataI_renderSleep.

Argument: <ARRAY> Rich Action Data

Scope: Clients, Global Arguments, Local Effect
Environment: Any
Public: No

Example:
    _RAData call A3A_fnc_richAction_render;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _RAData = _this;
private _state = _RAData get "state";

if (_state isEqualTo "hidden") exitWith {};
if (_RAData get "renderSleepUntil" > serverTime) exitWith {};
_RAData set ["renderSleepUntil", serverTime + (_RAData get "renderSleep")];

_RAData call (_RAData get "fnc_onRender");

if !(("gfx_"+_state) in _RAData) then {
    Error("Illegitimate state found in updateText: "+ _state);
    _state = "idle";
    _RAData set ["state","_state"];
};

private _currentGfx = _RAData get ("gfx_"+_state);
private _overrideGfx = _RAData get "gfx_override";
private _finalGfx = [_currentGfx,_overrideGfx] call A3A_fnc_richAction_overlayGfx;

["context","icon","contextBackground","iconBackground"]
    apply {[_RAData get "completionRatio", _finalGfx get _x] call A3A_fnc_richAction_selectAnimFrame}
    params ["_context","_icon","_contextBackground","_iconBackground"];

private _target = _RAData get "target";
private _actionID = _RAData get "actionID";
private _menuText = format[_RAData get "menuText",["#ffae00","#838383"] select (_state isEqualTo "disabled")];

_target setUserActionText [_actionID, _menuText, "<t size='3.5' shadow='0'>"+_iconBackground+"</t><br/><t font='RobotoCondensedBold'>"+_contextBackground+"</t>","<t size='3.5'>"+_icon+"</t><br/><t font='RobotoCondensedBold'>"+_context+"</t>"];
