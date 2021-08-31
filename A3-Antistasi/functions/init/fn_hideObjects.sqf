params ["_ruins"];

private ["_building", "_ruinPosW"];

{
	_ruinPosW = _x #2;
	_building = [_ruinPosW #0, _ruinPosW #1] nearestObject (_x #0);
	_building hideObject true;
	_building enableSimulation false;
} forEach _ruins;
