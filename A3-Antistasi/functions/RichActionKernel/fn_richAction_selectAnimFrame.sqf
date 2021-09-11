/*
Maintainer: Caleb Serafin
    Selects texture from animation loop or global progress.
    The animation can choose to loop at the specified duration, or be selected based on completion ratio.
    The frames are selected evenly, each frame will have the same visible time.

Arguments:
    <SCALAR> Rich Action completion ratio.
    <RAAnim> Rich Action Animation

Return Value:
    <STRING> The current frame to display.

Environment: Any
Public: Yes

Example:
    [0.80,"Hello World"] call A3A_fnc_richAction_selectAnimFrame; // "Hello World"
    [0.80,[7,["Never","gonna","give","you","up","Never","gonna","let","you","down","Never","gonna","run","around","and","desert","you"]]] call A3A_fnc_richAction_selectAnimFrame; // Might give you "up"
    [0.7499,[0,["First Quarter","Second Quarter","Third Quarter","Forth Quarter"]]] call A3A_fnc_richAction_selectAnimFrame; // "Third Quarter"
    [0.75,[0,["First Quarter","Second Quarter","Third Quarter","Forth Quarter"]]] call A3A_fnc_richAction_selectAnimFrame; // "Forth Quarter"
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_completionRatio",0 ,[ 0 ]],
    ["_RAAnim", "selectAnimTexture_missing", ["", []], [2]]
];

if (_RAAnim isEqualType "") exitWith {_RAAnim};  // Return immediately if static texture.

_RAAnim params [
    ["_duration",0,[ 0 ]],
    ["_textures",[],[ [] ]]
];

private _ratio = if (_duration > 0) then {
    (serverTime / _duration) mod 1;
} else {
    _completionRatio;
};
// The main count textures omitted -1. This makes it act as if there was an extra texture. This allows all texture frames to have the same on screen duration.
// Basic floor wouldn't show the last frame.
// Basic ceiling wouldn't show the first frame.
// Basic round would give the first and last frame half the time compared to middle frames.
// Additional min is required to prevent the ratio picking an out-of-bound element.
private _frameIndex = 0 max (floor (count _textures * _ratio)) min (count _textures -1);
private _frame = _textures #(_frameIndex); // The duration is first, so it has to be offset.

if (isNil {_frame} || {!(_frame isEqualType "")}) then {
    _frame = "selectAminFrame error";
    private _abridgedAnimString = (_RAAnim#1) apply {str _x} apply {_x select [(count _x -24) max 0,  16]} joinString ",";  // The select range should be the part of the text that contains the image name.
    Error_4("Output Texture was non-string. ratio: %1; serverTime: %2; abridged _RAAnims: [%3;[%4]]", str _completionRatio, str serverTime, str (_RAAnim#0), _abridgedAnimString);
};
_frame;
