/*
Maintainer: Caleb Serafin
    Easy interface to supply rich action context text.
    Text formatting should handled here to make sure that it is always consistent.
    Provides 3 levels, title/Action, subtitle, details where each level is smaller than last.
    Each word of Title should be capitalised.
    Details are not quick to read, but longer text can be accepted due to small size.

    Special formats applied:
        When setting idle text, the title will be wrapped with "Press space to _title".
        When setting progress, the standard spacer is removed to signify that the text coupled closely with the user's action.

Arguments:
    <ARRAY> Rich action data
    <INTEGER> Which Graphics effect to modify, recommend using macros __RADataI_gfx_idle", __RADataI_gfx_disabled", __RADataI_gfx_progress", __RADataI_gfx_override
    <STRING> The title or action.
    <STRING> A subtitle.            (default = "")
    <STRING> Further details.       (default = "")

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes
Dependencies:
    <STRING> A3A_richAction_standardSpacer
    <STRING> A3A_richAction_pressSpaceTo

Example:
    [_RAData, __RADataI_gfx_idle", "Sell Vehicle", "Rebels will receive 25€"] call A3A_fnc_richAction_setContext;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS();
private _hashmap0 = createHashMap;
params [
    ["_RAData", _hashmap0, [_hashmap0]],
    ["_gfxState", "idle", [""]],
    ["_title","", [""]],
    ["_subtitle","", [""]],
    ["_details","", [""]]
];

if !(("gfx_"+_gfxState) in _RAData) exitWith {
    Error_1("%1 is not a valid gfx state.",_gfxState);
};

isNil A3A_fnc_richAction_init;

if (_gfxState isEqualTo "idle") then {  // _wrap title with instruction
    _title = format [A3A_richAction_pressSpaceTo,"color='#ffae00'",_title];
};

private _spacer = if (_gfxState isEqualTo "progress") then {""} else {A3A_richAction_standardSpacer};  // Bring closer if progress

private _context = (
    _spacer +
    "<t shadow='2'>"+
        "<t font='PuristaMedium' size='1.8' valign='bottom'>" + _title + "</t><br/>" +
        "<t font='RobotoCondensed' size='1.2' valign='top'>" + _subtitle + "</t>"+
        "<t font='RobotoCondensed' size='1.0' valign='top'>" + _details + "</t>" +
    "</t>"
);

_RAData get ("gfx_"+_gfxState) set ["context",_context];
