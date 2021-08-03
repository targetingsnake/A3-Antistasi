params ["_object"];

private _classname = typeOf _object;
if (_classname in A3A_dismantle_structureJouleCostHM) exitWith {"dismantle"};
if (_classname in A3A_refund_sellableVehicles || (_object isKindOf "StaticWeapon")) exitWith {"sellVehicle"};
if ((!isPlayer _object) && (_object isKindOf "CAMan")) exitWith {"dismissAI"};
if (isPlayer _object) exitWith {["exit","authorisePlayer"] select (membershipEnabled && (player call A3A_fnc_refundCanGiveAuthorisation))}; // No need to authorise and unauthorise players if everyone gets it by default.

"exit";
