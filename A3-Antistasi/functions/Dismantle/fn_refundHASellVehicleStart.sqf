private _vehicle = _shared get "_selectedObject";
[player,_vehicle] remoteExecCall ["A3A_fnc_sellVehicle",2];
_shared set ["_state","idle"];
