/*
Maintainer: Caleb Serafin
    Selects top-most textures.
    If an element in the override layer is a not an empty string, it will replace the corresponding base layer element.
    If an empty field is desired, a tag that resolves to nothing should be used ("<t/>").

Arguments:
    <RAGFX> Base layer.
    <RAGFX> Override layer.

Return Value:
    <RAGFX> Final layer.

Scope: Any
Environment: Any
Public: Yes

Example:
    private _finalGFX = [_baseGFX,_overrideGFX] call A3A_fnc_richAction_overlayGFX;
*/
#include "richActionData.hpp"
params [
    ["_baseGFX", [], [ [] ], [RAGFXI_count]],
    ["_overrideGFX", [], [ [] ], [RAGFXI_count]]
];

private _finalGFX = [];
{
    _finalGFX set [_forEachIndex, if (_x isNotEqualTo "") then {
        _x
    } else {
        _baseGraphics #_forEachIndex;
    }];
} forEach _overlayGraphics;
_finalGFX;
