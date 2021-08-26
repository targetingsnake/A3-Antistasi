// TODO UI-update: add header
// Gets classname for vehicle to be used by a HC squad based on squad size

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params [["_squadFormat", []]];

private _vehicleType = "";

// Workaround for vehicle classname squad formats
if (_squadFormat isEqualType "") exitWith {
    // This just gives a quad for now as MG and Mortar teams are the only
    // teams using this format that also uses separate vehicles
    vehSDKBike;
};

if (count _squadFormat == 2) then {
	_vehicleType = vehSDKBike;
} else {
	if (count _squadFormat > 4) then {
		_vehicleType = vehSDKTruck;
	} else {
		_vehicleType = vehSDKLightUnarmed;
	};
};

_vehicleType;
