
private _vehicle = _shared get "_selectedObject";

_shared set ["_state","disabled"];
if (_vehicle distance getMarkerPos respawnTeamPlayer > 50) exitWith {
    _topText = "Too Far";
    _bottomText = "Vehicle must be closer than 50m to HQ marker.";
    _overlayLayers pushBack "_graphics_tooFar";
};

if ({isPlayer _x} count crew _vehicle > 0) exitWith {
    _topText = "Vehicle Occupied";
    _bottomText = "Vehicle  must be empty.";
    _overlayLayers pushBack "_graphics_carOccupied";
};

private _ownerUID = _vehicle getVariable ["ownerX",""];
if NOT (_ownerUID isEqualTo "" || (getPlayerUID player isEqualTo _ownerUID) || (player isEqualTo theBoss) || {player call A3A_fnc_isAdmin} ) exitWith {  // Vehicle cannot be sold if owned by another player.
    _topText = "No Authority";
    _bottomText = "Only owner, commander, or admin can sell this vehicle.";
    _overlayLayers pushBack "_graphics_notOwner";
};

private _classname = typeOf _vehicle;
private _cost = call {
    if (_vehicle isKindOf "StaticWeapon") exitWith {100};			// in case rebel static is same as enemy statics
    if (_classname in vehFIA) exitWith { ([_classname] call A3A_fnc_vehiclePrice) / 2 };
    if ((_classname in arrayCivVeh) or (_classname in civBoats) or (_classname in [civBoat,civCar,civTruck])) exitWith {25};
    if ((_classname in vehNormal) or (_classname in vehBoats) or (_classname in vehAmmoTrucks)) exitWith {100};
    if (_classname in [vehCSATPatrolHeli, vehNATOPatrolHeli, civHeli]) exitWith {500};
    if ((_classname in vehAPCs) || (_classname in vehTransportAir) || (_classname in vehUAVs)) exitWith {1000};
    if ((_classname in vehAttackHelis) or (_classname in vehTanks) or (_classname in vehAA) or (_classname in vehMRLS)) exitWith {3000};
    if (_classname in [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA]) exitWith {4000};
    0;
};

_cost = round (_cost * (1-damage _vehicle));

if (_cost == 0) exitWith {
    _topText = "Too Unconventional";
    _bottomText = "Not suitable in our marketplace.";
    _overlayLayers pushBack "_graphics_tooUnconventional";
};

_shared set ["_state","idle"];
_topText = format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Sell Vehicle"];
_bottomText = " +"+(_cost toFixed 0)+"€";
_overlayLayers pushBack "_graphics_sellVehicle";