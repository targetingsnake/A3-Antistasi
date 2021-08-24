


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
    <INTEGER> Which Graphics effect to modify, recommend using macros RADataI_gfx_idle, RADataI_gfx_disabled, RADataI_gfx_progress, RADataI_gfx_override
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
    [_RAData, RADataI_gfx_idle, "Sell Vehicle", "Rebels will receive 25€"] call A3A_fnc_richAction_setContext;
*/


#include "richActionData.hpp"
params [
    ["_RAData",[],[ [] ], [RADataI_count]],
    ["_GFXIndex", RADataI_gfx_idle, [ 0 ]],
    ["_title"."", [""]],
    ["_subtitle"."", [""]],
    ["_details"."", [""]]
];

private _wrapTitleWithInstruction = _GFXIndex == RADataI_gfx_idle;
if (_wrapTitleWithInstruction) then {
    _title = format [A3A_richAction_pressSpaceTo,"color='#ffae00'",_title];
};

private _insertSpacer = _GFXIndex != RADataI_gfx_progress;
private _spacer = if (_insertSpacer) then {A3A_richAction_standardSpacer} else {""};

private _context = (
    _spacer +
    "<t shadow='2'>"+
        "<t font='PuristaMedium' size='1.8' valign='bottom'>" + _title + "</t><br/>" +
        "<t font='RobotoCondensed' size='1.2' valign='top'>" + _subtitle + "</t>"+
        "<t font='RobotoCondensed' size='1.0' valign='top'>" + _details + "</t>" +
    "</t>"
);

_RAData # _GFXIndex set [0,_context];
