/*
Maintainer: Caleb Serafin
    Selects top-most textures.
    If an element in the override layer is a not an empty string, it will replace the corresponding base layer element.
    If an empty field is desired, a tag that resolves to nothing should be used ("<t/>").

Arguments:
    <RAGfx> Base layer.
    <RAGfx> Override layer.

Return Value:
    <RAGfx> Final layer.

Scope: Any
Environment: Any
Public: Yes

Example:
    private _finalGfx = [_baseGfx,_overrideGfx] call A3A_fnc_richAction_overlayGfx;
*/
private _hashmap0 = createHashMap;
params [
    ["_baseGfx", _hashmap0, [_hashmap0]],
    ["_overrideGfx", _hashmap0, [_hashmap0]]
];
private _finalGfx = +_baseGfx;
_finalGfx merge _overrideGfx;
_finalGfx;
