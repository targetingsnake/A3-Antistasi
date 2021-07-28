/*
Maintainer: Caleb Serafin
    First sets up localisd text for key instructions.
    Then creates some animation packs that can be used.

Scope: Local Effect
Environment: Any
Public: No

Example:
    class holdActionInit { preInit = 1 };
*/

// Initialise the PID counter
A3A_holdAction_PIDCounter = 0;

// Localised Action text
private _keyNameRaw = actionKeysNames ["Action",1,"Keyboard"];
A3A_holdAction_keyName = _keyNameRaw select [1,count _keyNameRaw - 2]; // We are trimming the outer quotes.   // STR_A3_HoldKeyTo: "Hold %1 to %2"
A3A_holdAction_holdSpaceTo = format [localize "STR_A3_HoldKeyTo", "<t %1>" + A3A_holdAction_keyName + "</t>", "%2"];       // A3A_holdAction_holdSpaceTo: "Hold space to %2", %1 is text attributes for key

// Create blank haspMap for type comparisons.
A3A_const_hashMap = createHashMap;

/*
    Creates default texture and icon packs.
    NB: Make a copy before modifying the textures during mission.
    hold action will wrap them with img shadow and colour `"<t size='3' shadow='0' color='#ffffffff'></t>`.
    There are no in or out textures, these must be included into the progress.
*/
// Outer Ring to blank transition. 4 Frames.
A3A_holdAction_texturesOuterRingToBlank = [];
for "_i" from 0 to 3 do {
    A3A_holdAction_texturesOuterRingToBlank pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_"+str _i+"_ca.paa'/>");
};
A3A_holdAction_texturesOuterRingToBlankReverse = +A3A_holdAction_texturesOuterRingToBlank;
reverse A3A_holdAction_texturesOuterRingToBlankReverse;

// Outer Ring to Clockwise with thin base ring transition. 5 Frames.
A3A_holdAction_texturesOuterRingToRing = [
    "<img color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/>",   // Colour is forced to keep it consistent if there is an outer xml colour change.
    "<img color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_1_ca.paa'/>",
    "<img color='#ffffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_2_ca.paa'/>",
    "<img color='#88ffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress2\progress_0_ca.paa'/>",
    "<img color='#bbffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress2\progress_0_ca.paa'/>"
];
A3A_holdAction_texturesOuterRingToRingReverse = +A3A_holdAction_texturesOuterRingToRing;
reverse A3A_holdAction_texturesOuterRingToRingReverse;

// Thin ring with breathing effect. 12 Frames.
A3A_customHint_hexChars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];    // required for A3A_fnc_shader_ratioToHex
A3A_holdAction_texturesRingBreath = [];
for "_i" from 0 to 11 do {
    private _alpha = (sin((_i/11) * 360) * 0.25) + 0.75;
    A3A_holdAction_texturesRingBreath pushBack ("<img color='#" + ([_alpha] call A3A_fnc_shader_ratioToHex) + "ffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\in\in_0_ca.paa'/>");
};
A3A_holdAction_texturesRingBreathReverse = +A3A_holdAction_texturesRingBreath;
reverse A3A_holdAction_texturesRingBreathReverse;

// Two halves of 3 segments orbit. 12 Frames.
A3A_holdAction_texturesOrbitSegments = [];
for "_i" from 0 to 11 do {
    A3A_holdAction_texturesOrbitSegments pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\idle\idle_"+str _i+"_ca.paa'/>");
};
A3A_holdAction_texturesOrbitSegmentsReverse = +A3A_holdAction_texturesOrbitSegments;
reverse A3A_holdAction_texturesOrbitSegmentsReverse;

// Segments appearing Clockwise. 25 Frames.
A3A_holdAction_texturesClockwise = [];
for "_i" from 0 to 24 do {
    A3A_holdAction_texturesClockwise pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_"+str _i+"_ca.paa'/>");
};
A3A_holdAction_texturesClockwiseReverse = +A3A_holdAction_texturesClockwise;
reverse A3A_holdAction_texturesClockwiseReverse;

// All 24 Segments fading out. 12 Frames.
A3A_holdAction_texturesSegmentsFade = [];
for "_i" from 0 to 24 do {
    A3A_holdAction_texturesSegmentsFade pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_"+str _i+"_ca.paa'/>");
};
A3A_holdAction_texturesSegmentsFadeReverse = +A3A_holdAction_texturesSegmentsFade;
reverse A3A_holdAction_texturesSegmentsFadeReverse;

// Segments appearing Clockwise with thin base ring. 25 Frames.
A3A_holdAction_texturesClockwiseRing = [];
for "_i" from 0 to 24 do {
    A3A_holdAction_texturesClockwiseRing pushBack ("<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress2\progress_"+str _i+"_ca.paa'/>");
};
A3A_holdAction_texturesClockwiseRingReverse = +A3A_holdAction_texturesClockwiseRing;
reverse A3A_holdAction_texturesClockwiseRingReverse;

// Long combination of clockwise segments, transition, clockwise with small ring. 55 Frames
A3A_holdAction_texturesClockwiseCombined = A3A_holdAction_texturesClockwise + A3A_holdAction_texturesOuterRingToRing + A3A_holdAction_texturesClockwiseRing;
A3A_holdAction_texturesClockwiseCombinedReverse = +A3A_holdAction_texturesClockwiseCombined;
reverse A3A_holdAction_texturesClockwiseCombinedReverse;

/// Default Icons
A3A_holdAction_iconDisabled = "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_passLeadership_ca.paa'/>";
A3A_holdAction_iconIdle = "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa'/>";
A3A_holdAction_iconProgress = "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa'/>";

// holdAction_connect fading out. 12 Frames.
A3A_holdAction_iconProgressFadeOut = [];    // 12 Frames.
for "_i" from 0 to 11 do {
    private _alpha = cos((_i/11) * 360);
    A3A_holdAction_iconProgressFadeOut pushBack ("<img color='#" + ([_alpha] call A3A_fnc_shader_ratioToHex) + "ffffff' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_connect_ca.paa'/>");
};
A3A_holdAction_iconProgressFadeOutReverse = +A3A_holdAction_iconProgressFadeOut;
reverse A3A_holdAction_iconProgressFadeOutReverse;