/*
Maintainer: Caleb Serafin
    Selects the current GFX based on state.
    Selects the current frames of the animations.
    Updates the action with appropriate icon and text.
    Render frequency is controlled by RADataI_renderSleep.

Argument: <ARRAY> Rich Action Data

Scope: Clients, Global Arguments, Local Effect
Environment: Any
Public: No

Example:
    _RAData call A3A_fnc_richAction_render;
*/
#include "richActionData.hpp"
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _RAData = _this;
private _state = _RAData # RADataI_state;

if (_state isEqualTo "hidden") exitWith {};
if (_RAData # RADataI_renderSleepUntil > serverTime) exitWith {};
_RAData set [RADataI_renderSleepUntil, serverTime + (_RAData # RADataI_renderSleep)];

_RAData call (_RAData # RADataI_fnc_onRender);

private _currentGFXIndex = switch (_state) do {
    case "disabled": { RADataI_gfx_disabled };
    case "idle": { RADataI_gfx_idle };
    case "progress": { RADataI_gfx_progress };
    default {
        Error("Illegitimate state found in updateText: "+ _state);
        _RAData set [RADataI_state,"idle"];
        RADataI_gfx_idle;
    };
};

private _overrideGFX = +(_RAData # RADataI_gfx_override);
private _currentGFX = _RAData # _currentGFXIndex;
private _finalGFX = [_currentGFX,_overrideGFX] call A3A_fnc_richAction_overlayGFX;
if (_finalGFX findIf {isNil {_x}} != -1) then {
    Error("_finalGFX had nil at index "+ str (_finalGFX findIf {isNil {_x}}) +". _finalGFX: "+ str _finalGFX);
    Error("_currentGFX: "+str _currentGFX);
};
(_finalGFX apply {[_RAData, _x] call A3A_fnc_richAction_selectAnimFrame}) params ["_context","_icon","_contextBackground","_background"];

private _target = _RAData # RADataI_target;
private _actionID = _RAData # RADataI_actionID;
private _menu = (_target actionParams _actionID) #0;  // https://community.bistudio.com/wiki/actionParams

_target setUserActionText [_actionID, _menu, "<t size='3.5' shadow='0'>"+_background+"</t><br/><t font='RobotoCondensedBold'>"+_contextBackground+"</t>","<t size='3.5'>"+_icon+"</t><br/><t font='RobotoCondensedBold'>"+_context+"</t>"];
