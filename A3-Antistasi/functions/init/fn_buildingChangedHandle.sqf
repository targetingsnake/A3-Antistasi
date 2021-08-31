#define SLEEP_TIME 30

_this spawn
{
	params ["_previousObject", "_newObject", "_isRuin"];

	if (!_isRuin) exitWith {};

	private _ruinType = typeOf _newObject;
	private _ruinPositionW = getPosWorld _newObject;
	private _ruinVectorUp = vectorUp _newObject;
	private _ruinVectorDir = vectorDir _newObject;

	private _buildingID = _newObject getVariable ["buildingID", -1];
	private _buildings = missionNamespace getVariable "destroyedBuildings";

	if (_buildingID == -1) then
	{
		_buildingID = [_previousObject] call RES_fnc_getTerrainID;
		_buildings pushBack [_buildingID, _ruinType, _ruinPositionW, _ruinVectorUp, _ruinVectorDir];
	}
	else
	{
		deleteVehicle _newObject;
		_previousObject = [_ruinPositionW #0, _ruinPositionW #1, 0] nearestObject _buildingID;
		private _id = _buildings findIf { _x #0 == _buildingID };
		_buildings set [_id, [_buildingID, _ruinType, _ruinPositionW, _ruinVectorUp, _ruinVectorDir]];
	};

	sleep SLEEP_TIME;

	_previousObject setDamage [0, false];

	[[[_buildingID, _ruinPositionW]]] remoteExecCall ["A3A_fnc_hideObjects", 0, true];

	private _ruin = _ruinType createVehicle [0, 0, 0];

	_ruin setVectorUp _ruinVectorUp;
	_ruin setVectorDir _ruinVectorDir;
	_ruin setPosWorld _ruinPositionW;

	_ruin setVariable ["buildingID", _buildingID];
};
