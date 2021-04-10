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
private _structureTime = (_structureTimeCost#0 * _timeMultiplier) max 0.1;
private _structureCost = _structureTimeCost#1 * _costReturnMultiplier;

private _sharedDataMap = createHashMapFromArray [
    ["_actionID",-1],
    ["_complete",false],
    ["_damageState",true],
    ["_holdActionID",-1],
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
    A3A_dismantle_holdAction_inProgress = "";
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

private _holdActionID = [
    player,                                            // Object the action is attached to
    "<t font='PuristaMedium' color='#fc911e' shadow='2' size='2'>Dismantle ("+(_structureTime toFixed 0)+"s)</t>",                                        // Title of the action
    "\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa",    // Idle icon shown on screen
    "\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa",    // Progress icon shown on screen
    "A3A_dismantle_holdAction_inProgress isEqualTo """+_structureName+""" || str cursorObject isEqualTo """+_structureName+"""",                        // Condition for the action to be shown
    "A3A_dismantle_holdAction_inProgress isEqualTo """+_structureName+""" || _caller distance cursorObject < "+(_dismantleRadius toFixed 0),                        // Condition for the action to progress
    {                                                    // Code executed when action starts
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        A3A_dismantle_holdAction_inProgress = _sharedDataMap get "_structureName";
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
        private _startTime = _sharedDataMap get "_startTime";
        private _structurePosAGLS = _sharedDataMap get "_structurePosAGLS";
        private _structureTime = _sharedDataMap get "_structureTime";

        private _completionPercent = ((serverTime - _startTime) / _structureTime) min 1;
        if (_sharedDataMap get "_nextSetPosTime" < serverTime) then {
            private _structure = _sharedDataMap get "_structure";
            _sharedDataMap set ["_nextSetPosTime",serverTime + 2];
            _structure setPos ([0,0,-(_sharedDataMap get "_roughHeight")] vectorMultiply _completionPercent vectorAdd _structurePosAGLS);
        };
        ["<t font='PuristaMedium' color='#fc911e' shadow='2' size='1'> "+(((1 - _completionPercent) * _structureTime) toFixed 0)+"s</t>",-1,0.65,20,0,0,789] spawn BIS_fnc_dynamicText;


    },
    {                                                   // Code executed on completion
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        A3A_dismantle_holdAction_inProgress = "";
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
        ["",-1,0.5,1,0,0,789] spawn BIS_fnc_dynamicText;
    },
    {                                                    // Code executed on interrupted
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        A3A_dismantle_holdAction_inProgress = "";
        private _structure = _sharedDataMap get "_structure";
        _structure setPos (_sharedDataMap get "_structurePosAGLS");    // Needs to reset due to move animation.
        _structure enableSimulation (_sharedDataMap get "_simulationState");
        _structure allowDamage (_sharedDataMap get "_damageState");
        player enableCollisionWith _structure;

        player switchMove "";
        player setVariable ["constructing",false];
        ["",-1,0.5,1,0,0,789] spawn BIS_fnc_dynamicText;
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
