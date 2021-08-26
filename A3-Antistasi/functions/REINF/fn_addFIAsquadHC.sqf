// Buys and spawns a High Command group for the commander

// TODO UI-update: add header
// TODO UI-update: needs refactoring

params [["_typegroup", []], ["_withBackpack", ""]];

// Check if player is commander
if (player != theBoss) exitWith {
    ["Recruit Squad", "Only the Commander has access to this function"] call A3A_fnc_customHint;
};

// Check if HQ is moving
// Is using the marker alpha really a good way to check this?
if (markerAlpha respawnTeamPlayer == 0) exitWith {
    ["Recruit Squad", "You cannot recruit a new squad while you are moving your HQ"] call A3A_fnc_customHint;
};

// Check if the player has a radio
if (!([player] call A3A_fnc_hasRadio)) exitWith {
    if !(A3A_hasIFA) then {
        ["Recruit Squad", "You need a radio in your inventory to be able to give orders to other squads"] call A3A_fnc_customHint;
    } else {
        ["Recruit Squad", "You need a Radio Man in your group to be able to give orders to other squads"] call A3A_fnc_customHint;
    };
};

// Check for enemies near petros
// TODO UI-update: could probably be replaced with a function, there is one for it somewhere
private _enemyNear = false;
{
	if (((side _x == Invaders) or (side _x == Occupants)) and (_x distance petros < 500) and ([_x] call A3A_fnc_canFight) and !(isPlayer _x)) exitWith {
        _enemyNear = true
    };
} forEach allUnits;

// Check message should probably also be on the flag action/button whichever we end up using
if (_enemyNear) exitWith {
    ["Recruit Squad", "You cannot recruit squads with enemies near your HQ"] call A3A_fnc_customHint;
};

// Exit if any of the following checks are preventing you from buying the squad type
// This could probably also be a separate function
private _exit = false;

if (_typeGroup isEqualType "") then {
	if (_typeGroup == "not_supported") then {
        _exit = true;
        ["Recruit Squad", "The group or vehicle type you requested is not supported in your modset"] call A3A_fnc_customHint;
    };

	if (A3A_hasIFA and ((_typeGroup == SDKMortar) or (_typeGroup == SDKMGStatic)) and !debug) then {
        _exit = true;
        ["Recruit Squad", "The group or vehicle type you requested is not supported in your modset"] call A3A_fnc_customHint;
    };
};

if (A3A_hasRHS) then {
	if (_typeGroup isEqualType objNull) then {
		if (_typeGroup == staticATteamPlayer) then {
            ["Recruit Squad", "AT Trucks are disabled in RHS - GREF"] call A3A_fnc_customHint;
            _exit = true;
        };
	};
};

if (_exit) exitWith {};


private _isInfantry = false;
private _typeVehX = ""; // Vehicle type for the squad, if one is requested
private _costs = 0; // Money costs
private _costHR = 0; // HR costs
private _formatX = []; // Array of the units (types?) in the squad
private _format = "Squd-"; // Name for the squad

// Get faction money and HR
private _hr = server getVariable "hr";
private _resourcesFIA = server getVariable "resourcesFIA";

// Costs calculations, to be moved to a separate function
if (_typeGroup isEqualType []) then {
	{
        // This line has basically no effect at least in vanilla, the two things it selects between are identical
		private _typeUnit = if (random 20 <= skillFIA) then {_x select 1} else {_x select 0};
		_formatX pushBack _typeUnit;
		_costs = _costs + (server getVariable _typeUnit);
        _costHR = _costHR +1
	} forEach _typeGroup;

	if (count _this > 1) then {
		if (_withBackpack == "MG") then {_costs = _costs + ([SDKMGStatic] call A3A_fnc_vehiclePrice)};
		if (_withBackpack == "Mortar") then {_costs = _costs + ([SDKMortar] call A3A_fnc_vehiclePrice)};
	};
	_isInfantry = true;

} else {
	_costs = _costs + (2*(server getVariable staticCrewTeamPlayer)) + ([_typeGroup] call A3A_fnc_vehiclePrice);
	_costHR = 2;

	if ((_typeGroup == SDKMortar) or (_typeGroup == SDKMGStatic)) then {
		_isInfantry = true;
		_formatX = [staticCrewTeamPlayer,staticCrewTeamPlayer];
	} else {
		_costs = _costs + ([vehSDKTruck] call A3A_fnc_vehiclePrice)
	};
};

// Can't buy static squads with IFA
if ((_withBackpack != "") and A3A_hasIFA) exitWith {
    ["Recruit Squad", "Your current modset doesn't support packing/unpacking static weapons"] call A3A_fnc_customHint;
};

// Not enough HR
if (_hr < _costHR) then {
    _exit = true;
    ["Recruit Squad", format ["You do not have enough HR for this request (%1 required)",_costHR]] call A3A_fnc_customHint;
};

// Not enough money
if (_resourcesFIA < _costs) then {
    _exit = true;
    ["Recruit Squad", format ["You do not have enough money for this request (%1 € required)",_costs]] call A3A_fnc_customHint;
};

if (_exit) exitWith {};

[- _costHR, - _costs] remoteExec ["A3A_fnc_resourcesFIA",2];

private _pos = getMarkerPos respawnTeamPlayer;

private _road = [_pos] call A3A_fnc_findNearestGoodRoad;
private _roadDirection = _road call A3A_fnc_getRoadDirection;


// Actual spawning and init begins hereish

_bypassAI = false; // If this gets set to true A3A_fnc_attackDrillAI gets run on the group
private _groupX = grpNull;
private _truckX = objNull;

if (_isInfantry) then {
    // Infantry squads

    // Sets the spawn position for the squad, random position 30m from HQ pos
	_pos = [(getMarkerPos respawnTeamPlayer), 30, random 360] call BIS_Fnc_relPos;
	if (_typeGroup isEqualType []) then {
        // Create a group for the squad
		_groupX = [_pos, teamPlayer, _formatX,true] call A3A_fnc_spawnGroup;
        // Check group type
		if (_typeGroup isEqualTo groupsSDKmid) then {_format = "Tm-"};
		if (_typeGroup isEqualTo groupsSDKAT) then {_format = "AT-"};
		if (_typeGroup isEqualTo groupsSDKSniper) then {_format = "Snpr-"};
		if (_typeGroup isEqualTo groupsSDKSentry) then {_format = "Stry-"};
		if (_withBackpack == "MG") then {
			((units _groupX) select ((count (units _groupX)) - 2)) addBackpackGlobal supportStaticsSDKB2;
			((units _groupX) select ((count (units _groupX)) - 1)) addBackpackGlobal MGStaticSDKB;
			_format = "SqMG-";
		} else {
			if (_withBackpack == "Mortar") then {
				((units _groupX) select ((count (units _groupX)) - 2)) addBackpackGlobal supportStaticsSDKB3;
				((units _groupX) select ((count (units _groupX)) - 1)) addBackpackGlobal MortStaticSDKB;
				_format = "SqMort-";
			};
  	    };
	} else {
		_groupX = [_pos, teamPlayer, _formatX,true] call A3A_fnc_spawnGroup;
		_groupX setVariable ["staticAutoT",false,true];
		if (_typeGroup == SDKMortar) then {_format = "Mort-"};
		if (_typeGroup == SDKMGStatic) then {_format = "MG-"};
		[_groupX,_typeGroup] spawn A3A_fnc_MortyAI;
		_bypassAI = true;
	};
	_format = format ["%1%2",_format,{side (leader _x) == teamPlayer} count allGroups];
	_groupX setGroupIdGlobal [_format];
} else {
    // Vehicles ?

	// workaround for weird bug where AI vehicles with attachments refuse to drive when placed close to road objects
	_pos = position _road vectorAdd [4 * (sin _roadDirection), 4 * (cos _roadDirection), 0];
	_pos = _pos findEmptyPosition [0, 40, vehSDKTruck];

	if (_typeGroup == staticAAteamPlayer) then
	{
		private _vehType = if (vehSDKAA != "not_supported") then {vehSDKAA} else {vehSDKTruck};
		_truckX = createVehicle [_vehType, _pos, [], 0, "NONE"];
		_truckX setDir _roadDirection;

		_groupX = createGroup teamPlayer;
		private _driver = [_groupX, staticCrewTeamPlayer, _pos, [], 5, "NONE"] call A3A_fnc_createUnit;
		private _gunner = [_groupX, staticCrewTeamPlayer, _pos, [], 5, "NONE"] call A3A_fnc_createUnit;
		_driver moveInDriver _truckX;
		_driver assignAsDriver _truckX;

		if (vehSDKAA == "not_supported") then
		{
			private _lpos = _pos vectorAdd [0,0,1000];
			private _launcher = createVehicle [staticAAteamPlayer, _lpos, [], 0, "CAN_COLLIDE"];
			_launcher attachTo [_truckX, [0,-2.2,0.3]];
			_launcher setVectorDirAndUp [[0,-1,0], [0,0,1]];
			_gunner moveInGunner _launcher;
			_gunner assignAsGunner _launcher;
//			[_launcher] call A3A_fnc_AIVEHinit;			// don't need separate despawn/killed handlers
		} else {
			_gunner moveInGunner _truckX;
			_gunner assignAsGunner _truckX;
		};
	} else {
		private _veh = [_pos, _roadDirection,_typeGroup, teamPlayer] call A3A_fnc_spawnVehicle;
		_truckX = _veh select 0;
		_groupX = _veh select 2;
	};

	if (_typeGroup == vehSDKAT) then {_groupX setGroupIdGlobal [format ["M.AT-%1",{side (leader _x) == teamPlayer} count allGroups]]};
	if (_typeGroup == staticAAteamPlayer) then {_groupX setGroupIdGlobal [format ["M.AA-%1",{side (leader _x) == teamPlayer} count allGroups]]};

	driver _truckX action ["engineOn", _truckX];
	[_truckX, teamPlayer] call A3A_fnc_AIVEHinit;
	[_truckX] spawn A3A_fnc_vehDespawner;
	_bypassAI = true;
};

{[_x] call A3A_fnc_FIAinit} forEach units _groupX;
theBoss hcSetGroup [_groupX];
petros directSay "SentGenReinforcementsArrived";
["Recruit Squad", format ["Group %1 at your command.<br/><br/>Groups are managed from the High Command bar (Default: CTRL+SPACE)<br/><br/>If the group gets stuck, use the AI Control feature to make them start moving. Mounted Static teams tend to get stuck (solving this is WiP)<br/><br/>To assign a vehicle for this group, look at some vehicle, and use Vehicle Squad Mngmt option in Y menu", groupID _groupX]] call A3A_fnc_customHint;
if (!_isInfantry) exitWith {};
if !(_bypassAI) then {_groupX spawn A3A_fnc_attackDrillAI};

// Set vehicle type based on squad size
// Currently has no check for if the vehicle actually has enough space
if (count _formatX == 2) then {
	_typeVehX = vehSDKBike;
} else {
	if (count _formatX > 4) then {
		_typeVehX = vehSDKTruck;
	} else {
		_typeVehX = vehSDKLightUnarmed;
	};
};

// Vehicle price
_costs = [_typeVehX] call A3A_fnc_vehiclePrice;
if (_costs > server getVariable "resourcesFIA") exitWith {};

// TODO UI-update: this used to create "veh_query" dialog, aka "add vehicle?", this has been moved to a checkbox in the squad recruit dialog instead

// Possible solutions:
// Make this take an extra param with the vehicle type?
// OR
// Make dialog set vehQuery
// And then skip all this commented out stuff ?
/* sleep 1;

disableSerialization;

private _display = findDisplay 100;

if (str (_display) != "no display") then {
	private _ChildControl = _display displayCtrl 104;
	_ChildControl  ctrlSetTooltip format ["Buy a vehicle for this squad for %1 €",_costs];
	_ChildControl = _display displayCtrl 105;
	_ChildControl  ctrlSetTooltip "Barefoot Infantry";
};

waitUntil {(!dialog) or (!isNil "vehQuery")};
if ((!dialog) and (isNil "vehQuery")) exitWith {}; */

vehQuery = nil;

// TODO UI-update: make this use the correct vehicle type for findEmptyPosition
_pos = position _road findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
private _purchasedVehicle = _typeVehX createVehicle _pos;
_purchasedVehicle setDir _roadDirection;
[_purchasedVehicle, teamPlayer] call A3A_fnc_AIVEHinit;
[_purchasedVehicle] spawn A3A_fnc_vehDespawner;
_groupX addVehicle _purchasedVehicle;
_purchasedVehicle setVariable ["owner",_groupX,true];

// Deducting cost (for vehicle?)
[0, - _costs] remoteExec ["A3A_fnc_resourcesFIA",2];
leader _groupX assignAsDriver _purchasedVehicle;
{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _groupX;
["Recruit Squad", "Vehicle Purchased"] call A3A_fnc_customHint;
petros directSay "SentGenBaseUnlockVehicle";
