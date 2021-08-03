/*
Maintainer: Caleb Serafin
    Animates structure dismantling.
    Deletes structure if dismantling was successful (Unit didn't take damage).
    Script only exits when structure is removed / action cancelled.

Arguments:

Return Value:
    <BOOL> true if dismantled. false if prematurely exited.

Scope: Local, Global Arguments, Global Effect
Environment: Scheduled
Public: No
Dependencies:
    <HASHMAP< <STRING>ClassName, <<SCALAR>Time,<SCALAR>Cost>> > A3A_dismantle_structureJouleCostHM (Initialised in A3-Antistasi\functions\REINF\fn_dismantle.sqf)

Example:
    player setUnitTrait ["engineer",true];
    [] spawn A3A_fnc_dismantle;
*/
#include "..\..\Includes\common.inc"
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

if (isNil {A3A_dismantle_structureJouleCostHM}) then {
    A3A_dismantle_structureJouleCostHM = createHashMapFromArray [
        ["Land_GarbageWashingMachine_F",[60,0]],
        ["Land_JunkPile_F",[60,0]],
        ["Land_Barricade_01_4m_F",[60,0]],
        ["Land_WoodPile_F",[60,0]],
        ["CraterLong_small",[60,0]],
        ["Land_Barricade_01_10m_F",[60,0]],
        ["Land_WoodPile_large_F",[60,0]],
        ["Land_BagFence_01_long_green_F",[60,0]],
        ["Land_SandbagBarricade_01_half_F",[60,0]],
        ["Land_Tyres_F",[100,0]],
        ["Land_TimberPile_01_F",[100,0]],
        ["Land_BagBunker_01_small_green_F",[60,100]],
        ["Land_PillboxBunker_01_big_F",[120,300]]
    ];
};
if (isNil {A3A_refund_sellableVehicles}) then {
    A3A_refund_sellableVehicles = [];
    A3A_refund_sellableVehicles append vehFIA;
    A3A_refund_sellableVehicles append arrayCivVeh;
    A3A_refund_sellableVehicles append civBoats;
    A3A_refund_sellableVehicles append [civBoat,civCar,civTruck];
    A3A_refund_sellableVehicles append vehNormal;
    A3A_refund_sellableVehicles append vehBoats;
    A3A_refund_sellableVehicles append vehAmmoTrucks;
    A3A_refund_sellableVehicles append [vehCSATPatrolHeli, vehNATOPatrolHeli, civHeli];
    A3A_refund_sellableVehicles append vehTransportAir;
    A3A_refund_sellableVehicles append vehUAVs;
    A3A_refund_sellableVehicles append vehAttackHelis;
    A3A_refund_sellableVehicles append vehTanks;
    A3A_refund_sellableVehicles append vehAA;
    A3A_refund_sellableVehicles append [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA];
};
private _shared = createHashMapFromArray [
    ["_idleNextCodeRunTime",0],
    ["_selectedObject",objNull],
    ["_structureCost",0],  // Needs to be saved if structure removal propagated before completionCode.
    ["_structureJoules",0],  // Needs to be saved if structure removal propagated before completionCode.
    ["_structureRadius",0],  // BoundingBox requests aren't free.
    ["_lastAnimLifeToken",[false]]
];

private _codeIdle = {
    if ((_shared get "_idleNextCodeRunTime") > serverTime) exitWith {};
    _shared set ["_idleNextCodeRunTime", serverTime + 1/4];

    private _selectedObject = cursorObject;
    _shared set ["_selectedObject",_selectedObject];
    _shared set ["_state","idle"];
    private _overlayLayers = _shared get "_overlayLayers";
    _overlayLayers resize 0;

    private _topText = "Error: Top text not inserted.";
    private _bottomText = "Error: Bottom text not inserted.";

    private _refundType = _selectedObject call A3A_fnc_refundIdentifyRefundType;
    _shared set ["_refundType",_refundType];
    switch (_refundType) do {
        case ("authorisePlayer"): {
        };
        case ("dismantle"): {
            [] call A3A_fnc_refundHADismantleIdle;
        };
        case ("sellVehicle"): {
            [] call A3A_fnc_refundHASellVehicleIdle;
        };
        case ("dismissAI"): {
            [] call A3A_fnc_refundHADismissAIIdle;
        };
        case ("exit"): {
            _overlayLayers pushBack "_graphics_exit";
        };
    };
    if (isNil{Dev_BRSize}) then {
        Dev_BRSize = 1;
    };
    (_shared get "_graphics_idle") set [1,
        A3A_holdAction_standardSpacer + "<t font='PuristaMedium' size='1.8'>" + _topText + "</t><br/>" +
        "<t font='RobotoCondensed' size='1.2' valign='top'>" + _bottomText + "</t>"
    ];    // The invisible engineer text makes the numbers centers
};

private _codeStart = {
    private _refundType = _shared get "_refundType";
    switch (_refundType) do {
        case ("authorisePlayer"): {
        };
        case ("dismantle"): {
            _shared set ["_codeProgress",A3A_fnc_refundHADismantleProgress];
            _shared set ["_codeCompleted",A3A_fnc_refundHADismantleCompleted];
            _shared set ["_codeInterrupted",A3A_fnc_refundHADismantleInterrupted];
            [] call A3A_fnc_refundHADismantleStart;
        };
        case ("sellVehicle"): {
            [] call A3A_fnc_refundHASellVehicleStart;
        };
        case ("dismissAI"): {
            [] call A3A_fnc_refundHADismissAIStart;
        };
        case ("exit"): {
            _shared set ["_dispose",true];
            _shared set ["_state","idle"];
        };
    };
};

_shared insert [
    // Visibility and progress settings
    ["_state","idle"],   // hidden, disabled, idle, progress
    ["_overlayLayers",[]],
    ["_autoInterrupt",true],
    ["_completionProgress",0],
    ["_completionGoal",420],

    // Custom set events
    ["_codeIdle",_codeIdle],
    ["_codeStart",_codeStart],
    ["_codeProgress",{}],
    ["_codeCompleted",{}],
    ["_codeInterrupted",{}],

    ["_idleSleep", 1/15],
    ["_progressSleep", 1/15],

    // Default Text and image animations.
    ["_graphics_idle",[
        "<t align='left'>Refund Menu</t>   <t color='#ffae00' align='right'>" + A3A_holdAction_keyName + "     </t>",  // Menu Text
        A3A_holdAction_standardSpacer + "Error: Text Not Inserted",  // On-screen Context Text
        A3A_holdAction_iconIdle,  // Icon
        [1,A3A_holdAction_texturesOrbitSegments]  //  12 Frames.  // Background
    ]],
    ["_graphics_disabled",[
        nil,
        nil,
        nil,
        [4,A3A_holdAction_texturesRingBreath]  //  60 Frames.  // Background
    ]],
    ["_graphics_progress",[
        nil /*Load from idle*/,  // Menu Text
        A3A_holdAction_standardSpacer + "Error: Text Not Inserted",  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>",  // Icon
        [0,A3A_holdAction_texturesClockwise apply {"<t color='#ffae00'>"+_x+"</t>"}]  //  25 Frames.  // Background
    ]],
    ["_graphics_dismantle",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>",  // Icon
        nil   // Background
    ]],
    ["_graphics_exit",[
        nil,  // Menu Text
        A3A_holdAction_standardSpacer + "<t font='PuristaMedium' size='1.8'>"+(format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Exit"]) + "</t><br/><t font='PuristaMedium' size='1.2' valign='top'>No Dismantlable Selected.</t>",  // On-screen Context Text
        "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa'/>",  // Icon
        [4,A3A_holdAction_texturesRingBreath]  //  60 Frames. // Background
    ]],
    ["_graphics_tooFar",[
        nil /*Load from idle*/,  // Menu Text
        A3A_holdAction_standardSpacer + "<t font='PuristaMedium' size='1.8'>Go closer</t>",  // On-screen Context Text
        "<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_needsAuthorisation",[
        nil,
        nil,
        nil,
        nil
    ]],
    ["_graphics_showProgress",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        nil,  // Icon
        [0,A3A_holdAction_texturesClockwise apply {"<t color='#ffae00'>"+_x+"</t>"}]  // Background
    ]],
    ["_graphics_dismantleContinue",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>",  // Icon
        nil  //  25 Frames. // Background
    ]],
    ["_graphics_dismantleAssist",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\meet_ca.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_carOccupied",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='functions\Dismantle\images\holdAction_carOccupied.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_notOwner",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_passLeadership_ca.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_tooUnconventional",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='functions\Dismantle\images\holdAction_notCar.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_sellVehicle",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_notSquadLeader",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_passLeadership_ca.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_petros",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='functions\Dismantle\images\holdAction_petros.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_injured",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa'/>",  // Icon
        nil  // Background
    ]],
    ["_graphics_dismissAI",[
        nil,  // Menu Text
        nil,  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>",  // Icon
        nil  // Background
    ]]
];

[
    _shared,
    player,
    69,
    "",
    -1,
    false,
    "",
    ""
] call A3A_fnc_holdAction;

true;
