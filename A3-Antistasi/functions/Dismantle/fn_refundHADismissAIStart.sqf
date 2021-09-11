_actionData set ["_state","disabled"];
private _AISoldier = _actionData get "_selectedObject";

[[_AISoldier]] call A3A_fnc_dismissPlayerGroup;