//Repairs a destroyed building.
//Parameter can either be the ruin of a building, or the building itself buried underneath the ruins.
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
if (!isServer) exitWith { Error("Server-only function miscalled") };

params [["_target", objNull]];

if (isNull _target) exitWith { false };

if !(_target isKindOf "Ruins") exitWith { false };

private _buildingID = _target getVariable ["buildingID", -1];

if (buildingID == -1) exitWith { false };

private _building = (position _target) nearestObject _buildingID;

deleteVehicle _target;
_building hideObjectGlobal false;
_building enableSimulationGlobal true;

{
	if (_x #0 == _buildingID) then
	{
		destroyedBuildings deleteAt _forEachIndex;
		break;
	};
} forEach destroyedBuildings;

true;
