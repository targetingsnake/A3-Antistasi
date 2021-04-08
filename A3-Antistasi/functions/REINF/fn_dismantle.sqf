/*
Maintainer: Caleb Serafin
    Animates structure dismantling.
    Deletes structure if dismantling was successful (Unit didn't take damage).

Arguments:
    <OBJECT> Structure to dismantle.
    <OBJECT> Unit to animate. objNull to dismantle structure by itself. (default: objNull)
    <SCALAR> serverTime Multiplier (default: 0.5)
    <SCALAR> Build cost return Multiplier. (default: 0)

Return Value:
    <BOOL> true if dismantled. false if prematurely exited.

Scope: Any, Global Arguments, Global Effect
Environment: Scheduled
Public: No
Dependancies:
    <HASHMAP< <STRING>ClassName, <<SCALAR>Time,<SCALAR>Cost>> > A3A_dismantle_structureTimeCostHM (Initialised in A3-Antistasi\functions\REINF\fn_dismantle.sqf)

Example:
    [cursorObject, player, 0.5, 1] spawn A3A_fnc_dismantle;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_structure",objNull,[ objNull ]],
    ["_worker",objNull,[ objNull ]],
    ["_timeMultiplier",1,[ 1 ]],
    ["_costReturnMultiplier",0,[ 0 ]]
];

if (isNull _structure) exitWith {
    Error("Passed structure was null");
    ;
    false;
};
private _useWorker = (!isNull _worker) && {_worker isKindOf "CAManBase"};
private _isPlayer = false;

private _structurePosAGLS = getPos _structure;
private _classname = typeOf _structure;
private _boundingBox = 0 boundingBoxReal _structure;
private _roughHeight = -(_boundingBox#0#2) + _boundingBox#1#2;
private _dismantleRadius = _roughHeight/2 + 3; // The3 meters is allocated for unit movement.
private _fnc_hint = {};

if (_useWorker) then {
    _fnc_hint = {
        params ["_text",["_silent",false]];
        ["Dismantle Info",_text,_silent] remoteExec ["A3A_fnc_customHint",_worker];
    };
    _isPlayer = isPlayer _worker && (_worker getVariable ["owner",_worker] == _worker); // Attempt to handle TV guided AI
    if (!_isPlayer) then {
        _worker doMove _structurePosAGLS
    } else {
        ["Walk to the structure to start dismantling. You have 30 seconds."] call _fnc_hint;
    };

    private _draw3D_cancellationToken = [false];
    A3A_dismantle_Draw3D_args = [_draw3D_cancellationToken,_structurePosAGLS]; // Delete when Arma 2.04 drops
    addMissionEventHandler [
        "Draw3D",
        {
            private _thisArgs = A3A_dismantle_Draw3D_args;      // Delete when Arma 2.04 drops
            if (_thisArgs#0#0) exitWith {
                removeMissionEventHandler ["Draw3D", _thisEventHandler];
            };
            drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", [1,1,1,1], _thisArgs#1, 1,1,0,"Dismantle", 0, 0.05, "PuristaMedium"];
        }/*,    // Uncomment when Arma 2.04 drops
        [_draw3D_cancellationToken,_structurePosAGLS]*/
    ];

    private _timeOut = serverTime + 30;
    waitUntil {
        sleep 1;
        (serverTime > _timeOut) || (_worker distance _structurePosAGLS <= _dismantleRadius);
    };
    _draw3D_cancellationToken set [0,true];

    if (_worker distance _structurePosAGLS > _dismantleRadius) exitWith {
        ["You didn't move to the position, please restart the dismantling process."] call _fnc_hint;
        false;
    };
};

private _structureTimeCost = A3A_dismantle_structureTimeCostHM getOrDefault [_classname,[60,0]];
private _structureTime = (_structureTimeCost#0 * _timeMultiplier) max 0.1;
private _structureCost = _structureTimeCost#1 * _costReturnMultiplier;

private _timeOut = serverTime + _structureTime;
private _animation_cancellationToken = [false];

if (_useWorker) then {
    _worker setVariable ["constructing",true];  // Re-using constructing Keeps compatibility with the rest of the system.
    if (!_isPlayer) then {
        {_worker disableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
    };
    _worker playMoveNow selectRandom medicAnims;
    _worker disableCollisionWith _structure;

    A3A_dismantle_workerAnim_args = [_animation_cancellationToken]; // Delete when Arma 2.04 drops
    _worker addEventHandler [
        "AnimDone",
        {
            private _thisArgs = A3A_dismantle_workerAnim_args;     // Delete when Arma 2.04 drops
            private _worker = _this#0;
            if (_thisArgs#0#0) exitWith {
                _worker removeEventHandler ["AnimDone",_thisEventHandler];
                _worker switchMove "";
            };
            _worker playMoveNow selectRandom medicAnims;
        }/*,    // Uncomment when Arma 2.04 drops
        [_animation_cancellationToken]*/
    ];
};
private _simulationState = simulationEnabled _structure;
private _damageState = isDamageAllowed _structure;
_structure enableSimulation false;
_structure allowDamage false;

[_animation_cancellationToken,_structure,[0,0,-_roughHeight],_structureTime] spawn {
    params ["_animation_cancellationToken","_structure","_fullMoveVector","_duration"];
    private _initialPos = getPos _structure;
    private _startTime = serverTime;
    while {!(_animation_cancellationToken#0)} do {
        private _completionPercent = ((serverTime - _startTime) / _duration) min 1;
        _structure setPos (_fullMoveVector vectorMultiply _completionPercent vectorAdd _initialPos);
        uiSleep 2;
    };
};

private _startTime = serverTime;
waitUntil  {
    uiSleep 2;
    ["Dismantled "+(((serverTime - _startTime) / _structureTime * 100) min 100  toFixed 0)+"%<br/>"+((_startTime + _structureTime - serverTime) max 0 toFixed 0)+" seconds left.",true] call _fnc_hint;
    (
        (serverTime >= _timeOut) ||
        _useWorker && {
            !([_worker] call A3A_fnc_canFight) ||
            (_worker getVariable ["helping",false]) ||
            (_worker getVariable ["rearming",false]) ||
            !(_worker getVariable ["constructing",false]) ||
            (_worker distance _structurePosAGLS > (_dismantleRadius + 1))
        }
    )
};
_animation_cancellationToken set [0,true];
if (_useWorker) then {
    _worker switchMove "";
    _worker setVariable ["constructing",false];
    if (!_isPlayer) then {
        {_worker enableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
        _worker doFollow leader _worker;
    };
};

if (serverTime < _timeOut) exitWith {
    _structure setPos _structurePosAGLS;    // Needs to reset due to move animation.
    _structure enableSimulation _simulationState;
    _structure allowDamage _damageState;
    private _reason = "";
    if (_useWorker) then {
        _worker enableCollisionWith _structure;
        _reason = [
            [!([_worker] call A3A_fnc_canFight),"You cannot perform rebel activities."],
            [(_worker getVariable ["helping",false]),"You starting helping someone."],
            [(_worker getVariable ["rearming",false]),"You starting rearming."],
            [!(_worker getVariable ["constructing",false]),"You being fired from construction."],
            [(_worker distance _structurePosAGLS > (_dismantleRadius + 1)),"You drifted too far away."]
        ] select {_x#0} apply {_x#1} joinString "<br/>";
    };
    ["Dismantling abandoned:<br/>" + _reason] call _fnc_hint;
    false;
};

if (_structure in staticsToSave) then {
    staticsToSave deleteAt (staticsToSave find _structure);
    publicVariable "staticsToSave"
};
deleteVehicle _structure;

if (_structureCost > 0) then {
    [0, _structureCost] remoteExec ["A3A_fnc_resourcesFIA",2];
};
["Structure dismantled."] call _fnc_hint;
true;
