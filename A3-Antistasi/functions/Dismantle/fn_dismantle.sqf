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
private _shared = createHashMapFromArray [
    ["_structure",objNull],
    ["_structureCost",0],  // Needs to be saved if structure removal propagated before completionCode.
    ["_structureJoules",0],  // Needs to be saved if structure removal propagated before completionCode.
    ["_structureRadius",0],  // BoundingBox requests aren't free.
    ["_roughHeight",1],
    ["_lastAnimLifeToken",[false]],
    ["_completionLostPerSecond",0],
    ["_completionExpiryTime",serverTime]
];

private _codeIdle = {
    private _structure = cursorObject;
    _shared set ["_structure",_structure];

    // Reset background to non-progress type.
    private _graphics_idle = _shared get "_graphics_idle";
    _graphics_idle set [3, [2,A3A_holdAction_texturesOrbitSegments]];
    _shared get "_graphics_disabled" set [3, [2,A3A_holdAction_texturesRingBreath]];

    if !(typeOf _structure in A3A_dismantle_structureJouleCostHM) exitWith {
        _shared set ["_state","idle"];
        _graphics_idle set [1,"<t font='PuristaMedium' size='1.8'>"+(format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Exit"]) + "</t><br/><t font='PuristaMedium' size='1.2' valign='top'>No Dismantlable Selected.</t>"];
        _graphics_idle set [2,"<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa'/>"];
    };

    private _boundingSphereDiameter = (2 boundingBox _structure)#2;
    private _dismantleRadius = _boundingSphereDiameter/2 * 1.5 + 3;
    if (player distance _structure > _dismantleRadius) exitWith {
        _shared set ["_state","disabled"];
    };
    _shared set ["_state","idle"];

    private _isEngineer = player getUnitTrait "engineer";
    private _engineerBonusText = ["","<t size='0.9' valign='middle'>  *Engineer Bonus</t>"] select _isEngineer;
    private _inputWatts = [REBEL_WATTS,ENGINEER_WATTS] select _isEngineer;

    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_structureCost",0]];
    _shared set ["_completionGoal",_joules];

    private _activeWatts = _structure getVariable ["A3A_dismantle_watts",0];
    if (_activeWatts != 0) exitWith {
        private _actionText = ["Continue Dismantle","Assist Dismantle"] select (_activeWatts > 0);
        private _icon = ["<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>","<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\meet_ca'/>"] select (_activeWatts > 0);

        private _joulesRemaining = ((_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime) * _activeWatts;
        private _potentialTimeRemaining = _joulesRemaining / ((_activeWatts max 0) + _inputWatts);

        _graphics_idle set [1,
            ("<t font='PuristaMedium' size='1.8'>"+format [A3A_holdAction_holdSpaceTo,"color='#ffae00'",_actionText]) + "</t><br/>" +
            "<t font='PuristaMedium' size='1.2' valign='top'><t color='#00000000'>"+_engineerBonusText+"</t>"+(_potentialTimeRemaining toFixed 0)+"s "+(_structureCost * COST_RETURN_RATIO toFixed 0)+"€<t color='#cccccc'>"+_engineerBonusText+"</t></t>"
        ];    // The invisible engineer text makes the numbers centers
        _graphics_idle set [2,_icon];

        _shared set ["_completionProgress",_joules - _joulesRemaining];
        _shared set ["_completionGoal",_joules];
        _graphics_idle set [3,(_shared get "_graphics_progress")#3];
        _shared get "_graphics_disabled" set [3,(_shared get "_graphics_progress")#3];
    };

    if (_activeWatts == 0) exitWith {
        _graphics_idle set [1,
            ("<t font='PuristaMedium' size='1.8'>"+format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Dismantle"]) + "</t><br/>" +
            "<t font='PuristaMedium' size='1.2' valign='top'><t color='#00000000'>"+_engineerBonusText+"</t>"+(_joules / _inputWatts toFixed 0)+"s "+(_structureCost * COST_RETURN_RATIO toFixed 0)+"€<t color='#cccccc'>"+_engineerBonusText+"</t></t>"
        ];    // The invisible engineer text makes the numbers centers
        _graphics_idle set [2,"<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>"];
    };
};

private _codeStart = {
    private _structure = _shared get "_structure";

    // Will display the exit text when no object is selected. Therefore, this will exit.
    if !(typeOf _structure in A3A_dismantle_structureJouleCostHM) exitWith {
        _shared set ["_dispose",true];
        _shared set ["_state","disabled"];
    };

    // Get and save structure data
    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_structureJoules",1],["_structureCost",0]];
    private _boundingSphereDiameter = (2 boundingBox _structure)#2;
    private _dismantleRadius = _boundingSphereDiameter/2 * 1.5 + 3;
    _shared set ["_structureJoules",_structureJoules];
    _shared set ["_structureCost",_structureCost];
    _shared set ["_structureRadius",_dismantleRadius];

    // Player animation
    _shared get "_lastAnimLifeToken" set [0,false];
    private _animLifeToken = [true];
    _shared set ["_lastAnimLifeToken",_animLifeToken];
    player playMoveNow selectRandom medicAnims;
    private _animEHID = player addEventHandler [
        "AnimDone",
        {
            private _animLifeToken = localNamespace getVariable ["A3A_dismantle_animLifeToken_" + str _thisEventHandler,[false]];
            if !(_animLifeToken#0) exitWith {
                player removeEventHandler ["AnimDone",_thisEventHandler];
            };
            params ["_unit", "_anim"];
            if (medicAnims findIf {_anim == _x} != -1) then {
                player playMoveNow selectRandom medicAnims;
            };
        }
    ];
    localNamespace setVariable ["A3A_dismantle_animLifeToken_" + str _animEHID,_animLifeToken];


    private _joulesCompleted = 0;
    if (isServer) then {
        [_structure,player,true] call A3A_fnc_dismantleAssist;
        _joulesCompleted = _structureJoules - ((_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime) * (_structure getVariable ["A3A_dismantle_watts",0]);
    } else {
        // Calculate time remaining and completed joules
        // Check if it's already networked.
        private _activeWatts = _structure getVariable ["A3A_dismantle_watts",0];
        private _joulesRemaining = _structureJoules;
        if (_activeWatts != 0) then {
            _joulesRemaining = ((_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime) * _activeWatts;
        };
        private _totalWatts = (_activeWatts max 0) + [REBEL_WATTS,ENGINEER_WATTS] select (player getUnitTrait "engineer");
        private _timeRemaining = _joulesRemaining / _totalWatts;
        //systemChat ("START _timeRemaining: "+(_timeRemaining toFixed 0)+"_joulesRemaining: "+(_joulesRemaining toFixed 0));
        _joulesCompleted = _structureJoules - _joulesRemaining;

        // Set local variables to allow UI to look consistent when the watts update returns from server.
        _structure setVariable ["A3A_dismantle_eta",serverTime + _timeRemaining];
        _structure setVariable ["A3A_dismantle_watts",_totalWatts];
        [_structure,player,true] remoteExecCall ["A3A_fnc_dismantleAssist",2];
    };

    _shared set ["_completionProgress",_joulesCompleted];
    _shared set ["_completionGoal",_structureJoules];
};

private _codeProgress = {
    private _structure = _shared get "_structure";

    if (_structure isEqualTo objNull) exitWith {  // Structure was deleted by host before completion on client.
        _shared set ["_completionProgress",_shared get "_structureJoules"];
    };

    if (player distance _structure > (_shared get "_structureRadius")) exitWith {
        _shared call (_shared get "_codeInterrupted");
        _shared set ["_state","disabled"];
    };

    /// Progress and Time Calculation ///
    private _timeRemaining = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
    private _joulesRemaining = _timeRemaining * (_structure getVariable ["A3A_dismantle_watts",0]);
    //systemChat ("PROGRESS _timeRemaining: "+(_timeRemaining toFixed 0)+"_joulesRemaining: "+(_joulesRemaining toFixed 0));
    _shared set ["_completionProgress",(_shared get "_structureJoules") - _joulesRemaining];

    private _graphics_progress = _shared get "_graphics_progress";
    _graphics_progress set [1,"<t font='PuristaMedium' shadow='2' size='2' color='#ffae00' valign='top'><t color='#00000000'>s</t>"+(_timeRemaining toFixed 0)+"<t color='#ffffff'>s</t></t>"];
};

private _codeComplete = {
    _shared set ["_state","idle"];
    _shared set ["_completionProgress",0];
    _shared get "_lastAnimLifeToken" set [0,false];
    player switchMove "";

    ["<t font='PuristaMedium' color='#ffae00' shadow='2' size='1'> Faction +"+((_shared get "_structureCost") * COST_RETURN_RATIO toFixed 0)+"€</t>",-1,0.65,3,0.5,-0.75,789] spawn BIS_fnc_dynamicText;
    hint "";
};

private _codeInterrupted = {
    _shared set ["_assistMode",false];
    _shared get "_lastAnimLifeToken" set [0,false];
    player switchMove "";

    private _structure = _shared get "_structure";
    if (isServer) then {
        [_structure,player,false] call A3A_fnc_dismantleAssist;
    } else {
        // Calculate time remaining and completed joules
        private _totalWatts = _structure getVariable ["A3A_dismantle_watts",0];
        private _joulesRemaining = ((_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime) * _totalWatts;
        _totalWatts = _totalWatts - ([REBEL_WATTS,ENGINEER_WATTS] select (player getUnitTrait "engineer"));
        if (_totalWatts <= 0) then {
            _totalWatts = -DECAY_WATTS;
        };
        private _timeRemaining = _joulesRemaining / _totalWatts;

        // Set local variables to allow UI to look consistent when the watts update returns from server.
        _structure setVariable ["A3A_dismantle_eta",serverTime + _timeRemaining];
        _structure setVariable ["A3A_dismantle_watts",_totalWatts];

        [_structure,player,false] remoteExecCall ["A3A_fnc_dismantleAssist",2];
    };
};

_shared insert [
    // Visibility and progress settings
    ["_state","idle"],   // hidden, disabled, idle, progress
    ["_autoInterrupt",true],
    ["_completionProgress",0],
    ["_completionGoal",420],

    // Custom set events
    ["_codeIdle",_codeIdle],
    ["_codeStart",_codeStart],
    ["_codeProgress",_codeProgress],
    ["_codeCompleted",_codeComplete],
    ["_codeInterrupted",_codeInterrupted],

    ["_idleSleep", 1/6],
    ["_progressSleep", 1/6],

    // Default Text and image animations.
    ["_graphics_idle",[
        "<t align='left'>Dismantler</t>        <t color='#ffae00' align='right'>" + A3A_holdAction_keyName + "     </t>",  // Menu Text
        "Error: Text Not Inserted",  // On-screen Context Text
        A3A_holdAction_iconIdle,  // Icon
        [2,A3A_holdAction_texturesOrbitSegments]  //  12 Frames.  // Background
    ]],
    ["_graphics_disabled",[
        nil /*Load from idle*/,  // Menu Text
        "<t font='PuristaMedium' size='1.8'>Go closer</t>",  // On-screen Context Text
        "<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa'/>",  // Icon
        [2,A3A_holdAction_texturesRingBreath]  //  12 Frames.  // Background
    ]],
    ["_graphics_progress",[
        nil /*Load from idle*/,  // Menu Text
        "Error: Text Not Inserted",  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>",  // Icon
        [0,A3A_holdAction_texturesClockwise apply {"<t color='#ffae00'>"+_x+"</t>"}]  //  25 Frames.  // Background
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
