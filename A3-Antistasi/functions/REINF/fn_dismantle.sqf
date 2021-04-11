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
    <HASHMAP< <STRING>ClassName, <<SCALAR>Time,<SCALAR>Cost>> > A3A_dismantle_structureTimeCostHM (Initialised in A3-Antistasi\functions\REINF\fn_dismantle.sqf)

Example:
    [] spawn A3A_fnc_dismantle;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

if (isNil {A3A_dismantle_structureTimeCostHM}) then {
    A3A_dismantle_structureTimeCostHM = createHashMapFromArray [
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
private _sharedDataMap = createHashMapFromArray [
    ["_completionPercent",0],
    ["_damageState",true],
    ["_dismantleRadius",1],
    ["_idleHintText",""],
    ["_inProgress",false],
    ["_object",objNull],
    ["_roughHeight",1],
    ["_nextSetPosTime",-1],
    ["_simulationState",true],
    ["_startTime",-1],
    ["_cost",0],
    ["_duration",0],
    ["_initialPosAGLS",[0,0,0]]
];
A3A_dismantle_sharedDataMap = _sharedDataMap;

/*
// The output text of these functions will be parsed as structured text for the icon. However, there are private variables that we can fiddle with.
_iconIdle bis_fnc_holdAction_showIcon: (current scope)
    _target, _actionID, _title, _icon, _texSet, TEXTURES_PROGRESS (compiles to bis_fnc_holdAction_texturesProgress), _frame, _hint
*/
/* For _iconIdle
bis_fnc_holdAction_animationTimerCode: (1 scope up)
    _eval, bis_fnc_holdAction_animationIdleTime, bis_fnc_holdAction_animationIdleFrame, bis_fnc_holdAction_running
*/
//preprocess data
if (isNil {A3A_dismantle_idleHintText}) then {
    private _keyNameRaw = actionKeysNames ["Action",1,"Keyboard"];
    private _keyName = _keyNameRaw select [1,count _keyNameRaw - 2];
    private _buttonHint = format[localize "STR_A3_HoldKeyTo","<t color='#fc911e'>"+_keyName+"</t>","Dismantle"];//STR_A3_HoldKeyTo: Hold %1 to %2
    A3A_dismantle_idleHintText = "<t font='PuristaMedium' shadow='2' size='1.5'>" + _buttonHint + "</t><br/><t size='1.2' valign='top'>";
};
//prepare progress textures
if (isNil {A3A_dismantle_holdAction_texturesProgress}) then {
    A3A_dismantle_holdAction_texturesProgress = [];
    for "_i" from 0 to 24 do {
        A3A_dismantle_holdAction_texturesProgress pushBack ("<img size='3' shadow='0' color='#fc911e' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_"+str _i+"_ca.paa'/>");
    };
};

private _iconIdle = {
    if !(typeOf cursorObject in A3A_dismantle_structureTimeCostHM) exitWith {
        "<img size='3' color='#ffffff' image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>"
    };
    (A3A_dismantle_structureTimeCostHM get (typeOf cursorObject)) params [["_duration",1],["_cost",0]]; // Should already have an entry if this is displaying

    private _isEngineer = player getUnitTrait "engineer";
    _duration = ceil (_duration * ([0.75,0.25] select _isEngineer));
    _cost = ceil (_cost * ([0.05,0.25] select _isEngineer));

    A3A_dismantle_sharedDataMap set ["_duration",_duration];
    A3A_dismantle_sharedDataMap set ["_object",cursorObject];


    private _engineerBonusText = ["","<t size='0.9' valign='middle'>  *Engineer Bonus</t>"] select _isEngineer;
    _hint = A3A_dismantle_idleHintText + "<t color='#00000000'>"+_engineerBonusText+"</t>"+str _duration+"s "+str _cost+"€<t color='#cccccc'>"+_engineerBonusText+"</t></t>"; // The invisible engineer text makes the numbers centers

    "<img size='3' color='#ffffff' image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/>";
};
/* For _iconProgress
_codeInit:  (1st call, 1 scope up)
    _target(argument target), _caller, _actionID,
    _arguments(shared), _title, _iconIdle, _iconProgress _condProgress, _codeProgress, _codeCompleted, _codeInterrupted, _duration, _removeCompleted
    _condProgressCode
_codeInit:  (2nd call, 1 scope up) (Diff from top)
    _target(argument target), _caller, _actionID,
    _arguments(shared), _title, _iconIdle, _codeProgress, _codeCompleted, _codeInterrupted, _removeCompleted
    _frame, _stepDuration
_codeInit:  (3rd call, 1 scope up) (Diff from top)
    (Same access as above, just a later single executions)
*/
private _iconProgress = {
    private _sharedDataMap = _arguments#0;

    private _startTime = _sharedDataMap get "_startTime";
    private _duration = _sharedDataMap get "_duration";
    private _completionPercent = ((serverTime - _startTime) / _duration) min 1;
    _sharedDataMap set ["_completionPercent",_completionPercent];

    _texSet = A3A_dismantle_holdAction_texturesProgress;

    "<img size='3' color='#ffffff' image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/><br/>"+
    "<t font='PuristaMedium' shadow='2' size='2' color='#fc911e' valign='top'><t color='#00000000'>s</t>"+(((1 - _completionPercent)*_duration) toFixed 0)+"<t color='#ffffff'>s</t></t>"; // The invisible s makes the numbers centers
};

[
    player,                                            // Object the action is attached to
    "Dismantle",                                        // Title of the action
    _iconIdle,    // Idle icon shown on screen
    _iconProgress,    // Progress icon shown on screen
    'A3A_dismantle_sharedDataMap get "_inProgress" || {(typeOf cursorObject in A3A_dismantle_structureTimeCostHM) && (player distance (A3A_dismantle_sharedDataMap get "_initialPosAGLS") < A3A_dismantle_sharedDataMap get "_dismantleRadius")}',                        // Condition for the action to be shown
    '',                        // Condition for the action to progress //
    {                                                    // Code executed when action starts
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        _sharedDataMap set ["_inProgress", true];
        _duration = _sharedDataMap get "_duration";    // This is defined in holdAction's parent scope
        _arguments set [20,_duration];    // duration is pulled in params when the code runs.

        private _structure = _sharedDataMap get "_object";
        player setVariable ["constructing",true];  // Re-using constructing Keeps compatibility with the rest of the system.
        player disableCollisionWith _structure;
        player playMoveNow selectRandom medicAnims;

        _sharedDataMap set ["_simulationState",simulationEnabled _structure];
        _sharedDataMap set ["_damageState",isDamageAllowed _structure];
        _sharedDataMap set ["_initialPosAGLS",getPos _structure];
        _structure enableSimulation false;
        _structure allowDamage false;
        _sharedDataMap set ["_startTime",serverTime];


        private _boundingBox = 0 boundingBoxReal cursorObject;
        private _roughHeight = -(_boundingBox#0#2) + _boundingBox#1#2;
        _sharedDataMap set ["_boundingBox",_boundingBox];
        _sharedDataMap set ["_roughHeight",_roughHeight];
        private _dismantleRadius = (_boundingBox#2)/2 + 3; // The3 meters is allocated for unit movement.
        _sharedDataMap set ["_roughHeight",_roughHeight];


    },
    {                                                    // Code executed on every progress tick
        params ["_target", "_caller", "_actionId", "_arguments", "_progress", "_maxProgress"];
        private _sharedDataMap = _arguments#0;
        if (medicAnims findIf {animationState player == _x} == -1) then {
            player playMoveNow selectRandom medicAnims;
        };

        if (_sharedDataMap get "_nextSetPosTime" < serverTime) then {
            //_sharedDataMap set ["_nextSetPosTime",serverTime + ([4,1] select (_duration < 10))];
            (_sharedDataMap get "_object") setPos ([0,0,-(_sharedDataMap get "_roughHeight")] vectorMultiply (_sharedDataMap get "_completionPercent") vectorAdd (_sharedDataMap get "_initialPosAGLS"));
        };


    },
    {                                                   // Code executed on completion
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        _sharedDataMap set ["_inProgress", false];
        player switchMove "";
        player setVariable ["constructing",false];

        private _structure = _sharedDataMap get "_object";
        if (_structure in staticsToSave) then {
            staticsToSave deleteAt (staticsToSave find _structure);
            publicVariable "staticsToSave"
        };
        deleteVehicle _structure;

        private _structureCost = _sharedDataMap get "_cost";
        if (_structureCost > 0) then {
            [0, _structureCost] remoteExec ["A3A_fnc_resourcesFIA",2];
        };
        ["<t font='PuristaMedium' color='#fc911e' shadow='2' size='1'> +"+(_structureCost toFixed 0)+"€</t>",-1,0.65,3,0.5,-1,789] spawn BIS_fnc_dynamicText;
    },
    {                                                    // Code executed on interrupted
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        _sharedDataMap set ["_inProgress", false];
        private _structure = _sharedDataMap get "_object";
        _structure setPos (_sharedDataMap get "_initialPosAGLS");    // Needs to reset due to move animation.
        _structure enableSimulation (_sharedDataMap get "_simulationState");
        _structure allowDamage (_sharedDataMap get "_damageState");
        player enableCollisionWith _structure;

        player switchMove "";
        player setVariable ["constructing",false];
    },
    [_sharedDataMap],                                                    // Arguments passed to the scripts as _this select 3 params ["_a0","_a1","_a2","_a3","_a4","_a5","_a6","_a7","_a8","_a9","_target","_title","_iconIdle","_iconProgress","_condShow","_condProgress","_codeStart","_codeProgress","_codeCompleted","_codeInterrupted","_duration","_removeCompleted"];
    69,                                                    // Action duration [s]
    70,                                                    // Priority
    false,                                                // Remove on completion
    false                                                // Show in unconscious state
] call BIS_fnc_holdActionAdd;


true;
