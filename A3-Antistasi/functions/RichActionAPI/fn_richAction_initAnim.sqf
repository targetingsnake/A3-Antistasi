/*
Maintainer: Caleb Serafin
    Creates default icons and animation packs that can be used.
    NB: If you want to modify one, remember to make a copy.
    rich action will wrap them with img shadow and colour `"<t size='3.5' shadow='0' color='#ffffffff'></t>`.

Scope: Local Effect
Environment: Any
Public: No

Example:
    class richAction_initAnim { preInit = 1 };

    isNil A3A_fnc_richAction_initAnim;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
if !(isNil{A3A_richAction_initAnim_complete}) exitWith { false };
if (canSuspend) exitWith { Error("Init must be synchronous!"); };
A3A_richAction_initAnim_complete = true;


// Outer Ring to blank transition. 4 Frames.
A3A_richAction_texturesOuterRingToBlank = [];
for "_i" from 0 to 3 do {
    A3A_richAction_texturesOuterRingToBlank pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_"+str _i+"_ca.paa'/>");
};
A3A_richAction_texturesOuterRingToBlankReverse = +A3A_richAction_texturesOuterRingToBlank;
reverse A3A_richAction_texturesOuterRingToBlankReverse;


// Outer Ring to Clockwise with thin base ring transition. 5 Frames.
A3A_richAction_texturesOuterRingToRing = [
    "<img color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/>",   // Colour is forced to keep it consistent if there is an outer xml colour change.
    "<img color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_1_ca.paa'/>",
    "<img color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_2_ca.paa'/>",
    "<img color='#88ffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress2\progress_0_ca.paa'/>",
    "<img color='#bbffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress2\progress_0_ca.paa'/>"
];
A3A_richAction_texturesOuterRingToRingReverse = +A3A_richAction_texturesOuterRingToRing;
reverse A3A_richAction_texturesOuterRingToRingReverse;


// Thin ring with breathing effect. 60 Frames. Recommended duration of 3.5 to 4.5 seconds (Aligns with calm breath cycle).
A3A_customHint_hexChars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];    // required for A3A_fnc_shader_ratioToHex
A3A_richAction_texturesRingBreath = [];
for "_i" from 0 to 59 do {
    // the last frame is clipped off to avoid a double full transparent when used in a equal-frame-time loop (Like the one used in A3A_fnc_richAction_add).
    private _alpha = sin((_i/(59+1)) * 360) * 0.45 + 0.55;
    A3A_richAction_texturesRingBreath pushBack ("<img color='#" + ([_alpha] call A3A_fnc_shader_ratioToHex) + "ffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/>");
};
// Sine wave is already symmetrical, no reversed version.


// Two halves of 3 segments orbit. 12 Frames.
A3A_richAction_texturesOrbitSegments = [];
for "_i" from 0 to 11 do {
    A3A_richAction_texturesOrbitSegments pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\idle\idle_"+str _i+"_ca.paa'/>");
};
A3A_richAction_texturesOrbitSegmentsReverse = +A3A_richAction_texturesOrbitSegments;
reverse A3A_richAction_texturesOrbitSegmentsReverse;


// All 24 Segments fading out. 12 Frames.
A3A_richAction_texturesSegmentsFade = [];
for "_i" from 0 to 24 do {
    A3A_richAction_texturesSegmentsFade pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_"+str _i+"_ca.paa'/>");
};
A3A_richAction_texturesSegmentsFadeReverse = +A3A_richAction_texturesSegmentsFade;
reverse A3A_richAction_texturesSegmentsFadeReverse;


// Segments appearing Clockwise. 25 Frames.
A3A_richAction_texturesClockwise = [];
for "_i" from 0 to 24 do {
    A3A_richAction_texturesClockwise pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_"+str _i+"_ca.paa'/>");
};
A3A_richAction_texturesClockwiseReverse = +A3A_richAction_texturesClockwise;
reverse A3A_richAction_texturesClockwiseReverse;


// Segments appearing Clockwise with thin base ring. 25 Frames.
A3A_richAction_texturesClockwiseRing = [];
for "_i" from 0 to 24 do {
    A3A_richAction_texturesClockwiseRing pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress2\progress_"+str _i+"_ca.paa'/>");
};
A3A_richAction_texturesClockwiseRingReverse = +A3A_richAction_texturesClockwiseRing;
reverse A3A_richAction_texturesClockwiseRingReverse;


/// Default Icons
A3A_richAction_iconDisabled = "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_passLeadership_ca.paa'/>";
A3A_richAction_iconIdle = "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa'/>";
A3A_richAction_iconProgress = "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa'/>";

