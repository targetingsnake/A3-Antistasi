/*
    File: fn_crewTypeForVehicle.sqf
    Author: Spoffy

    Description:
		Guesses the correct crew type for the given vehicle.

    Parameter(s):
		_side - Side of the vehicle [SIDE]
		_vehicle - Vehicle to guess on [OBJECT]

    Returns:
		Unit type [STRING]

    Example(s):
*/

params ["_side", "_vehicle"];

private _sideIndex = [west, east, independent, civilian] find _side;

private _typeX = typeOf _vehicle;

if (_typeX in vehFixedWing)
exitWith {
    [NATOPilot, CSATPilot, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
};

if (_typeX in vehArmor) exitWith {
    [NATOCrew, CSATCrew, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
};

if (_typeX in vehHelis) exitWith {
    [NATOPilot, CSATPilot, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
};

if (_typeX in vehUAVs) exitWith {
    ["B_UAV_AI", "O_UAV_AI", "I_UAV_AI", "C_UAV_AI"] select _sideIndex
};

if (_typeX in vehFIA) exitWith {
    [FIARifleman, FIARifleman, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
};

if (_typeX in vehPoliceCar) exitWith {
    [policeGrunt, policeGrunt, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
};

[NATOGrunt, CSATGrunt, staticCrewTeamPlayer, "C_Man_1"] select _sideIndex
