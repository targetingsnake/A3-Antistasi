/*
Maintainer: Caleb Serafin
    Animates structure dismantling.
    Deletes structure if dismantling was successful (Unit didn't take damage).
    Script only exits when structure is removed / action cancelled.

Arguments:
    <OBJECT> Structure to dismantle.
    <SCALAR> Build Time Multiplier (default: 0.75)
    <SCALAR> Build cost return Multiplier. (default: 0)

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
FIX_LINE_NUMBERS()

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
    ["_prevStructure",objNull],
    ["_simpleObject",objNull],
    ["_roughHeight",1],
    ["_lastAnimLifeToken",[false]],
    ["_assistMode",false],
    ["_completionLostPerSecond",0],
    ["_completionExpiryTime",serverTime]
];

private _codeIdle = {
    _shared set ["_state","idle"];
    private _graphics_idle = _shared get "_graphics_idle";
    private _structure =  cursorObject;
    _shared set ["_structure",_structure];

    if (_shared get "_completionProgress" > 0) then {
        private _newCompletion = (_shared get "_completionLostPerSecond") * ((_shared get "_completionExpiryTime") - serverTime);
        _newCompletion = _newCompletion max 0;
        _shared set ["_completionProgress",_newCompletion];  // Rate will be double due to higher tick rate.
        if (_shared get "_completionProgress" <= 0) then {
            _shared get "_graphics_idle" set [3, [2,A3A_holdAction_texturesOrbitSegments]];
            _shared get "_graphics_disabled" set [3, [2,A3A_holdAction_texturesRingBreath]];
        } else {
            _shared get "_graphics_idle" set [3,(_shared get "_graphics_progress")#3];
            _shared get "_graphics_disabled" set [3,(_shared get "_graphics_progress")#3];
        }
    };

    if !(typeOf _structure in A3A_dismantle_structureJouleCostHM) exitWith {
        _graphics_idle set [1,"<t font='PuristaMedium' size='1.8'>"+(format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Exit"]) + "</t><br/><t font='PuristaMedium' size='1.2' valign='top'>No Object Selected.</t>"];
        _graphics_idle set [2,"<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa'/>"];
    };

    private _boundingSphereDiameter = (2 boundingBox _structure)#2;
    private _dismantleRadius = _boundingSphereDiameter/2 * 1.5 + 3;
    if (player distance _structure > _dismantleRadius) exitWith {
        _shared set ["_state","disabled"];
    };

    private _isEngineer = player getUnitTrait "engineer";
    private _engineerBonusText = ["","<t size='0.9' valign='middle'>  *Engineer Bonus</t>"] select _isEngineer;
    private _inputWatts = [1.34,4] select _isEngineer;

    if !(isNull (_structure getVariable ["A3A_dismantler",objNull])) exitWith {
        _shared set ["_assistMode",true];
        private _timeLeft = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
        private _watts = _structure getVariable ["A3A_dismantle_watts",0];
        private _joulesRemaining = _timeLeft * _watts;
        _timeLeft = _joulesRemaining / (_watts + _inputWatts);
        _graphics_idle set [1,
            ("<t font='PuristaMedium' size='1.8'>"+format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Assist " + name (_structure getVariable ["A3A_dismantler",objNull])]) + "</t><br/>" +
            "<t font='PuristaMedium' size='1.2' valign='top'><t color='#00000000'>"+_engineerBonusText+"</t>"+str _timeLeft+"s<t color='#cccccc'>"+_engineerBonusText+"</t></t>"
        ];    // The invisible engineer text makes the numbers centers
        _graphics_idle set [2,"<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\meet_ca'/>"];
    };


    _shared set ["_prevStructure",_structure];
    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_costReturn",0]];
    _shared set ["_completionGoal",_joules];
    private _timeLeft = ceil (_joules / _inputWatts);
    _costReturn = ceil (_costReturn * ([0.05,0.25] select _isEngineer));
    _graphics_idle set [1,
        ("<t font='PuristaMedium' size='1.8'>"+format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Dismantle"]) + "</t><br/>" +
    "<t font='PuristaMedium' size='1.2' valign='top'><t color='#00000000'>"+_engineerBonusText+"</t>"+str _timeLeft+"s "+str _costReturn+"€<t color='#cccccc'>"+_engineerBonusText+"</t></t>"
    ];    // The invisible engineer text makes the numbers centers
    _graphics_idle set [2,"<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>"];
    if (_structure isNotEqualTo (_shared get "_prevStructure")) exitWith {
    };
};

private _codeStart = {
    private _structure = _shared get "_structure";

    if !(typeOf _structure in A3A_dismantle_structureJouleCostHM) exitWith {   // Will display the exit text when no object is selected.
        _shared set ["_dispose",true];
        _shared set ["_state","disabled"];
    };

    private _isEngineer = player getUnitTrait "engineer";
    private _watts = [1.34,4] select _isEngineer;

    private _simpleObject = createSimpleObject [typeOf _structure, getPosASL _structure, true];
    //player disableCollisionWith _simpleObject;
    _shared set ["_simpleObject",_simpleObject];
    private _boundingBox = 0 boundingBoxReal _structure;
    private _roughHeight = -(_boundingBox#0#2) + _boundingBox#1#2;
    _shared set ["_boundingBox",_boundingBox];
    _shared set ["_roughHeight",_roughHeight];

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

    if (_shared get "_assistMode") exitWith {
        [_structure,_watts] remoteExecCall ["A3A_fnc_dismantleAddAssist",_structure getVariable ["A3A_dismantler",objNull]]; // Variables are calculated and broadcast from single machine to avoid race conditions.
    };

    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_costReturn",0]];
    private _timeLeft = ceil ((_joules - (_shared get "_completionProgress")) / _watts);
    _structure setVariable ["A3A_dismantle_eta",serverTime + _timeLeft,true];
    _structure setVariable ["A3A_dismantler",player,true];
    _structure setVariable ["A3A_dismantle_watts",_watts,true];

    _shared set ["_completionGoal",_joules];
};

private _codeProgress = {
    private _structure = _shared get "_structure";

    private _boundingSphereDiameter = (2 boundingBox _structure)#2;
    private _dismantleRadius = _boundingSphereDiameter/2 * 1.5 + 3;
    if (player distance _structure > _dismantleRadius) exitWith {
        _shared call (_shared get "_codeInterrupted");
        _shared set ["_state","disabled"];
    };

    /// Progress and Time Calculation ///
    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_costReturn",0]];
    private _watts = _structure getVariable ["A3A_dismantle_watts",0];
    private _timeLeft = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
    private _joulesRemaining = _timeLeft * _watts;

    _shared set ["_completionProgress",_joules - _joulesRemaining];
    private _completionPercent = (_joules - _joulesRemaining) / _joules;
    (_shared get "_simpleObject") setPos ([0,0,-(_shared get "_roughHeight")] vectorMultiply _completionPercent vectorAdd getPos (_shared get "_structure"));

    private _graphics_progress = _shared get "_graphics_progress";
    _graphics_progress set [1,"<t font='PuristaMedium' shadow='2' size='2' color='#ffae00' valign='top'><t color='#00000000'>s</t>"+(_timeLeft toFixed 0)+"<t color='#ffffff'>s</t></t>"];
};

private _codeComplete = {
    _shared set ["_assistMode",false];
    _shared set ["_state","idle"];
    _shared set ["_completionProgress",0];
    _shared get "_lastAnimLifeToken" set [0,false];

    deleteVehicle (_shared get "_simpleObject");
    player switchMove "";
    if (_shared get "_assistMode") exitWith {};

    private _structure = _shared get "_structure";
    if (_structure in staticsToSave) then {
        staticsToSave deleteAt (staticsToSave find _structure);
        publicVariable "staticsToSave"
    };
    deleteVehicle _structure;
    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_costReturn",0]];
    if (_costReturn > 0) then {
        private _isEngineer = player getUnitTrait "engineer";
        _costReturn = _costReturn * ([0.05,0.25] select _isEngineer);
        [0, _costReturn] remoteExec ["A3A_fnc_resourcesFIA",2];
    };
    ["<t font='PuristaMedium' color='#ffae00' shadow='2' size='1'> +"+(_costReturn toFixed 0)+"€</t>",-1,0.65,3,0.5,-0.75,789] spawn BIS_fnc_dynamicText;
    hint "";
};

private _codeInterrupted = {
    _shared set ["_assistMode",false];
    private _completionLostPerSecond = 4;
    _shared set ["_completionLostPerSecond",_completionLostPerSecond];
    _shared set ["_completionExpiryTime",serverTime + (_shared get "_completionProgress") / _completionLostPerSecond];
    _shared get "_lastAnimLifeToken" set [0,false];

    deleteVehicle (_shared get "_simpleObject");
    player switchMove "";
    if (_shared get "_assistMode") exitWith {
        private _isEngineer = player getUnitTrait "engineer";
        private _watts = [1.34,4] select _isEngineer;
        [_structure,-_watts] remoteExecCall ["A3A_fnc_dismantleAddAssist",_structure getVariable ["A3A_dismantler",objNull]]; // Variables are calculated and broadcast from single machine to avoid race conditions.
    };

    private _structure = _shared get "_structure";
    _structure setVariable ["A3A_dismantle_eta",nil,true];
    _structure setVariable ["A3A_dismantler",nil,true];
    _structure setVariable ["A3A_dismantle_watts",nil,true];
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

    ["_idleSleep",1/8],
    ["_progressSleep",1/8],

    // Default Text and image animations.
    ["_graphics_idle",[
        "<t align='left'>Dismantler</t>        <t color='#ffae00' align='right'>" + A3A_holdAction_keyName + "     </t>",  // Menu Text
        "Error: Text Not Inserted",  // On-screen Context Text
        A3A_holdAction_iconIdle,  // Icon
        [2,A3A_holdAction_texturesOrbitSegments] // Background
    ]],
    ["_graphics_disabled",[
        nil /*Load from idle*/,  // Menu Text
        "<t font='PuristaMedium' size='1.8'>Go closer</t>",  // On-screen Context Text
        "<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa'/>",  // Icon
        [2,A3A_holdAction_texturesRingBreath]  // Background
    ]],
    ["_graphics_progress",[
        nil /*Load from idle*/,  // Menu Text
        "Error: Text Not Inserted",  // On-screen Context Text
        "<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>",  // Icon
        [0,A3A_holdAction_texturesClockwise apply {"<t color='#ffae00'>"+_x+"</t>"}]  // Background
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
