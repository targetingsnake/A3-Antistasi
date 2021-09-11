
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

_actionData get "_lastAnimLifeToken" set [0,false];
player switchMove "";

private _structure = _actionData get "_selectedObject";
if (isServer) then {
    [_structure,player,false] call A3A_fnc_dismantleAssist;
} else {
    // Calculate time remaining and completed joules
    private _totalWatts = _structure getVariable ["A3A_dismantle_watts",0];
    private _joulesRemaining = ((_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime) * _totalWatts;
    _totalWatts = _totalWatts - ([SOLDIER_WATTS,ENGINEER_WATTS] select (player getUnitTrait "engineer"));
    if (_totalWatts <= 0) then {
        _totalWatts = -DECAY_WATTS;
    };
    private _timeRemaining = _joulesRemaining / _totalWatts;

    // Set local variables to allow UI to look consistent when the watts update returns from server.
    _structure setVariable ["A3A_dismantle_eta",serverTime + _timeRemaining];
    _structure setVariable ["A3A_dismantle_watts",_totalWatts];

    [_structure,player,false] remoteExecCall ["A3A_fnc_dismantleAssist",2];
};
