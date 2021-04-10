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
    [cursorObject, player, 0.5, 1] spawn A3A_fnc_dismantle;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_structure",objNull,[ objNull ]],
    ["_timeMultiplier",0.75,[ 0.75 ]],
    ["_costReturnMultiplier",0,[ 0 ]]
];

if (isNull _structure) exitWith {
    Error("Passed structure was null");
    ;
    false;
};

private _structureName = str _structure;
if (isNil {A3A_dismantle_Draw3D_args}) then {
    A3A_dismantle_Draw3D_args = createHashMap
};
if (_structureName in A3A_dismantle_Draw3D_args) exitWith {};
private _structurePosAGLS = getPos _structure;
private _structureMarkerPosAGLS = [_structurePosAGLS#0,_structurePosAGLS#1,1.72];   // 1.72 is eye height for most humans (Sorry Netherlanders, you gonna have to crook your neck)
A3A_dismantle_Draw3D_args set [_structureName,_structureMarkerPosAGLS];

["Dismantle Info","You have been assigned a structure to dismantle. A HUD marker will lead you to it."] call A3A_fnc_customHint;

private _classname = typeOf _structure;
private _boundingBox = 0 boundingBoxReal _structure;
private _roughHeight = -(_boundingBox#0#2) + _boundingBox#1#2;
private _dismantleRadius = (_boundingBox#2)/2 + 3; // The3 meters is allocated for unit movement.

private _structureTimeCost = A3A_dismantle_structureTimeCostHM getOrDefault [_classname,[60,0]];
private _structureTime = ceil (_structureTimeCost#0 * _timeMultiplier);
private _structureCost = ceil (_structureTimeCost#1 * _costReturnMultiplier);

private _sharedDataMap = createHashMapFromArray [
    ["_actionID",-1],
    ["_complete",false],
    ["_damageState",true],
    ["_dismantleRadius",_dismantleRadius],
    ["_holdActionID",-1],
    ["_idleHintText",""],
    ["_roughHeight",_roughHeight],
    ["_nextSetPosTime",-1],
    ["_simulationState",true],
    ["_startTime",-1],
    ["_structure",_structure],
    ["_structureCost",_structureCost],
    ["_structureName",_structureName],
    ["_structureTime",_structureTime],
    ["_structurePosAGLS",_structurePosAGLS]
];

if (isNil {A3A_dismantle_holdAction_IDs}) then {
    A3A_dismantle_holdAction_IDs = createHashMap;
};
if (isNil {A3A_dismantle_holdAction_inProgress}) then {
    A3A_dismantle_holdAction_inProgress = false;
};

if (isNil {A3A_dismantle_Draw3D_online}) then {
    A3A_dismantle_Draw3D_online = true;

    A3A_dismantle_addAction_ID = player addAction [
        "<t font='PuristaMedium' color='#ff4040' shadow='2' size='2'><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa'/><br/>Cancel all dismantle tasks.</t>",
        {
            scriptName "fn_dismantle.sqf:addAction";
            _this params ["_target", "_caller", "_actionId", "_arguments"];

            {
                A3A_dismantle_Draw3D_args deleteAt _x;
            } forEach +(keys A3A_dismantle_Draw3D_args);
            {
                [player, _x] call BIS_fnc_holdActionRemove;
                A3A_dismantle_holdAction_IDs deleteAt _x;
            } forEach +(keys A3A_dismantle_holdAction_IDs);
        },
        nil,
        69,
        true,
        false
    ];
    player setUserActionText [A3A_dismantle_addAction_ID,"Cancel Dismantle Tasks","<t font='PuristaMedium' color='#ff4040' shadow='2' size='2'><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa'/><br/>Cancel all dismantle tasks.</t>"];
    addMissionEventHandler [
        "Draw3D",
        {
            private _Draw3D_args = A3A_dismantle_Draw3D_args;
            if (count keys _Draw3D_args == 0) exitWith {
                removeMissionEventHandler ["Draw3D", _thisEventHandler];
                player removeAction A3A_dismantle_addAction_ID;
                A3A_dismantle_Draw3D_online = nil;
            };
            {
                drawIcon3D ["\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa", [0.98,0.57,0.12,1], _Draw3D_args get _x, 1,1,0,"Dismantle", 2, 0.05, "PuristaMedium", "center", true];
            } forEach _Draw3D_args;
        }
    ];
};
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
if (isnil {A3A_dismantle_idleHintText}) then {
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
    (A3A_dismantle_structureTimeCostHM get (typeOf cursorObject)) params [["_time",1],["_cost",0]]; // Should already have an entry if this is displaying

    private _isEngineer = player getUnitTrait "engineer";
    _time = ceil (_time * ([0.75,0.25] select _isEngineer));
    _cost = ceil (_cost * ([0.05,0.25] select _isEngineer));
    private _engineerBonusText = ["","<t size='0.9' valign='middle'>  *Engineer Bonus</t>"] select _isEngineer;
    _hint = A3A_dismantle_idleHintText + "<t color='#00000000'>"+_engineerBonusText+"</t>"+str _time+"s "+str _cost+"€<t color='#cccccc'>"+_engineerBonusText+"</t></t>"; // The invisible engineer text makes the numbers centers

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
    private _structureTime = _sharedDataMap get "_structureTime";
    private _completionPercent = ((serverTime - _startTime) / _structureTime) min 1;

    _texSet = A3A_dismantle_holdAction_texturesProgress;

    "<img size='3' color='#ffffff' image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/><br/>"+
    "<t font='PuristaMedium' shadow='2' size='2' color='#fc911e' valign='top'><t color='#00000000'>s</t>"+(((1 - _completionPercent)*_structureTime) toFixed 0)+"<t color='#ffffff'>s</t></t>"; // The invisible s makes the numbers centers
};

private _holdActionID = [
    player,                                            // Object the action is attached to
    "Dismantle",                                        // Title of the action
    _iconIdle,    // Idle icon shown on screen
    _iconProgress,    // Progress icon shown on screen
    'A3A_dismantle_holdAction_inProgress || {typeOf cursorObject in A3A_dismantle_structureTimeCostHM}',                        // Condition for the action to be shown
    'A3A_dismantle_holdAction_inProgress || {_caller distance cursorObject < '+(2 toFixed 0)+'}',                        // Condition for the action to progress //_dismantleRadius
    {                                                    // Code executed when action starts
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        A3A_dismantle_holdAction_inProgress = true;
        private _structure = _sharedDataMap get "_structure";
        player setVariable ["constructing",true];  // Re-using constructing Keeps compatibility with the rest of the system.
        player disableCollisionWith _structure;
        player playMoveNow selectRandom medicAnims;

        _sharedDataMap set ["_simulationState",simulationEnabled _structure];
        _sharedDataMap set ["_damageState",isDamageAllowed _structure];
        _structure enableSimulation false;
        _structure allowDamage false;
        _sharedDataMap set ["_startTime",serverTime];
    },
    {                                                    // Code executed on every progress tick
        params ["_target", "_caller", "_actionId", "_arguments", "_progress", "_maxProgress"];
        private _sharedDataMap = _arguments#0;
        if (medicAnims findIf {animationState player == _x} == -1) then {
            player playMoveNow selectRandom medicAnims;
        };

        if (_sharedDataMap get "_nextSetPosTime" < serverTime) then {
            private _startTime = _sharedDataMap get "_startTime";
            private _structurePosAGLS = _sharedDataMap get "_structurePosAGLS";
            private _structureTime = _sharedDataMap get "_structureTime";
            private _completionPercent = ((serverTime - _startTime) / _structureTime) min 1;
            private _structure = _sharedDataMap get "_structure";
            _sharedDataMap set ["_nextSetPosTime",serverTime + 4];
            _structure setPos ([0,0,-(_sharedDataMap get "_roughHeight")] vectorMultiply _completionPercent vectorAdd _structurePosAGLS);
        };


    },
    {                                                   // Code executed on completion
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        A3A_dismantle_holdAction_inProgress = false;
        player switchMove "";
        player setVariable ["constructing",false];

        private _structure = _sharedDataMap get "_structure";
        if (_structure in staticsToSave) then {
            staticsToSave deleteAt (staticsToSave find _structure);
            publicVariable "staticsToSave"
        };
        deleteVehicle _structure;

        private _structureCost = _sharedDataMap get "_structureCost";
        if (_structureCost > 0) then {
            [0, _structureCost] remoteExec ["A3A_fnc_resourcesFIA",2];
        };
        A3A_dismantle_Draw3D_args deleteAt (_sharedDataMap get "_structureName");
        ["<t font='PuristaMedium' color='#fc911e' shadow='2' size='1'> +"+(_structureCost toFixed 0)+"€</t>",-1,0.65,3,0.5,-1,789] spawn BIS_fnc_dynamicText;
    },
    {                                                    // Code executed on interrupted
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        A3A_dismantle_holdAction_inProgress = false;
        private _structure = _sharedDataMap get "_structure";
        _structure setPos (_sharedDataMap get "_structurePosAGLS");    // Needs to reset due to move animation.
        _structure enableSimulation (_sharedDataMap get "_simulationState");
        _structure allowDamage (_sharedDataMap get "_damageState");
        player enableCollisionWith _structure;

        player switchMove "";
        player setVariable ["constructing",false];
    },
    [_sharedDataMap],                                                    // Arguments passed to the scripts as _this select 3 params ["_a0","_a1","_a2","_a3","_a4","_a5","_a6","_a7","_a8","_a9","_target","_title","_iconIdle","_iconProgress","_condShow","_condProgress","_codeStart","_codeProgress","_codeCompleted","_codeInterrupted","_duration","_removeCompleted"];
    _structureTime,                                                    // Action duration [s]
    70,                                                    // Priority
    true,                                                // Remove on completion
    false                                                // Show in unconscious state
] call BIS_fnc_holdActionAdd;
A3A_dismantle_holdAction_IDs set [_holdActionID,_holdActionID];

//completion code

waitUntil {
    sleep 0.25;
    _sharedDataMap get "_complete";
};
true;
