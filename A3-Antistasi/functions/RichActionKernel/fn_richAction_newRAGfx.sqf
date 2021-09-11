/*
Maintainer: Caleb Serafin
    Returns a new instance of Rich Action Graphics.
Arguments:
    <MAP> Fields to override default values. (Default = nil)
Return Value:
    <HASHMAP>, this structure from now on is <RAGfx>
Public: Yes
Example:
    [] call A3A_fnc_richAction_newRAGfx;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
private _newRAGfx = createHashMapFromArray [
    ["context",""],
    ["icon",""],
    ["contextBackground",""],
    ["iconBackground",""]
];
if !(isNil {_this}) then {
    if !(_this isEqualType []) exitWith {
        Error_1("Passed fields are not type <ARRAY>, but type of <%1>.",typeName _this);
    };
    _newRAGfx insert _this;
};
_newRAGfx;
