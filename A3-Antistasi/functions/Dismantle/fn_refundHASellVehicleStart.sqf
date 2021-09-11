private _vehicle = _actionData get "_selectedObject";
[player,_vehicle] remoteExecCall ["A3A_fnc_sellVehicle",2];
_actionData set ["_state","idle"];
