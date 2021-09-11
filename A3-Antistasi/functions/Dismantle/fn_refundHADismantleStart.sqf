
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

private _structure = _actionData get "_selectedObject";

// Get and save structure data
(A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_structureJoules",1],["_structureCost",0]];
private _boundingSphereDiameter = (2 boundingBox _structure)#2;
private _dismantleRadius = _boundingSphereDiameter/2 * 1.5 + 3;
_actionData set ["_structureJoules",_structureJoules];
_actionData set ["_structureCost",_structureCost];
_actionData set ["_structureRadius",_dismantleRadius];

// Player animation
_actionData get "_lastAnimLifeToken" set [0,false];
private _animLifeToken = [true];
_actionData set ["_lastAnimLifeToken",_animLifeToken];
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
    private _totalWatts = (_activeWatts max 0) + [SOLDIER_WATTS,ENGINEER_WATTS] select (player getUnitTrait "engineer");
    private _timeRemaining = _joulesRemaining / _totalWatts;
    //systemChat ("START _timeRemaining: "+(_timeRemaining toFixed 0)+"_joulesRemaining: "+(_joulesRemaining toFixed 0));
    _joulesCompleted = _structureJoules - _joulesRemaining;

    // Set local variables to allow UI to look consistent when the watts update returns from server.
    _structure setVariable ["A3A_dismantle_eta",serverTime + _timeRemaining];
    _structure setVariable ["A3A_dismantle_watts",_totalWatts];
    [_structure,player,true] remoteExecCall ["A3A_fnc_dismantleAssist",2];
};

_actionData set ["_completionProgress",_joulesCompleted];
_actionData set ["_completionGoal",_structureJoules];
