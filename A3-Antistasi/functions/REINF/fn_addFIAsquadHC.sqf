/*
Maintainer: DoomMetal
    Recruits and spawns a High Command group for the commander.

Arguments:
    <ARRAY>/<STRING> Type of high command group to be recruited, can be either an array of loadouts or a vehicle classname.
    <STRING> Classname for the vehicle type for the group if one is to be purchased. Empty string means no vehicle.

Return Value:
    Nothing

Scope: Clients, Local Arguments, Local Effect
Environment: Scheduled
Public: Yes
Dependencies:
    None

Example:
    [groupsSDKSquad, vehSDKTruck] spawn A3A_fnc_addFIAsquadHC

Rewrite notes:
    The old _withBackpack param has been removed due to the squads that used no longer working
    The squads in question are the Mortar and MG Squads (not to be confused with the 2-man teams of the same type, they still work)
    These will need to be rewritten before being added back in
    Vehicle type selection has been moved to the UI since it decides there whether or not to include one in a checkbox
    as opposed to the old way where it gave a second yes/no prompt asking for it.
    This particular function has no check for if the vehicle can actually hold the entire group,
    that functionality has been moved to A3A_fnc_getHCSquadVehicleType.
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params [["_typeGroup", []], ["_typeVehX", ""]];

// Check if player is commander
if (player != theBoss) exitWith {
    [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_commander_only"] call A3A_fnc_customHint;
};

// Check if HQ is moving
// Is using the marker alpha really a good way to check this?
if (markerAlpha respawnTeamPlayer == 0) exitWith {
    [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_moving_hq"] call A3A_fnc_customHint;
};

// Check if the player has a radio
if (!([player] call A3A_fnc_hasRadio)) exitWith {
    if !(A3A_hasIFA) then {
        [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_no_radio"] call A3A_fnc_customHint;
    } else {
        [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_no_radio_man"] call A3A_fnc_customHint;
    };
};

// Check for enemies near petros
// TODO: This could probably be replaced with a function
private _enemyNear = false;
{
	if (((side _x == Invaders) or (side _x == Occupants)) and (_x distance petros < 500) and ([_x] call A3A_fnc_canFight) and !(isPlayer _x)) exitWith {
        _enemyNear = true
    };
} forEach allUnits;

// Check message should probably also be on the flag action/button whichever we end up using
if (_enemyNear) exitWith {
    [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_enemies_near"] call A3A_fnc_customHint;
};

// Exit if any of the following checks are preventing you from buying the squad type
// This could probably also be a separate function
private _exit = false;

if (_typeGroup isEqualType "") then {
	if (_typeGroup == "not_supported") then {
        _exit = true;
        [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_unsupported_modset"] call A3A_fnc_customHint;
    };

	if (A3A_hasIFA and ((_typeGroup == SDKMortar) or (_typeGroup == SDKMGStatic)) and !debug) then {
        _exit = true;
        [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_unsupported_modset"] call A3A_fnc_customHint;
    };
};

if (A3A_hasRHS) then {
	if (_typeGroup isEqualType objNull) then {
		if (_typeGroup == staticATteamPlayer) then {
            [localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_at_disabled_rhsgref"] call A3A_fnc_customHint;
            _exit = true;
        };
	};
};

if (_exit) exitWith {};


private _isInfantry = false;
private _formatX = []; // Array of the units (types?) in the squad
private _format = "Squd-"; // Name for the squad

// Get faction money and HR
private _hr = server getVariable "hr";
private _resourcesFIA = server getVariable "resourcesFIA";

if (_typeGroup isEqualType []) then {
	{
		private _typeUnit = _x select 0;
		_formatX pushBack _typeUnit;
	} forEach _typeGroup;
	_isInfantry = true;
} else {

	if ((_typeGroup == SDKMortar) or (_typeGroup == SDKMGStatic)) then {
		_isInfantry = true;
		_formatX = [staticCrewTeamPlayer,staticCrewTeamPlayer];
	};
};

// Costs
([_typeGroup, _typeVehX] call A3A_fnc_getHCSquadPrice) params ["_costs", "_costHR"];

// Can't buy static squads with IFA
// Currently disabled, needs to be rewritten along with the MG/Mortar squads
/* if ((_withBackpack != "") and A3A_hasIFA) exitWith {
    [localize "STR_antistasi_recruit_squad_hint_title", "Your current modset doesn't support packing/unpacking static weapons"] call A3A_fnc_customHint;
}; */

// Not enough HR
if (_hr < _costHR) then {
    _exit = true;
    [localize "STR_antistasi_recruit_squad_hint_title", format [localize "STR_antistasi_recruit_squad_hint_insufficient_hr",_costHR]] call A3A_fnc_customHint;
};

// Not enough money
if (_resourcesFIA < _costs) then {
    _exit = true;
    [localize "STR_antistasi_recruit_squad_hint_title", format [localize "STR_antistasi_recruit_squad_hint_insufficient_money",_costs]] call A3A_fnc_customHint;
};

if (_exit) exitWith {};

[- _costHR, - _costs] remoteExec ["A3A_fnc_resourcesFIA",2];

private _pos = getMarkerPos respawnTeamPlayer;

private _road = [_pos] call A3A_fnc_findNearestGoodRoad;
private _roadDirection = _road call A3A_fnc_getRoadDirection;


// Actual spawning and init begins here
// This section is left mostly untouched apart from formatting

_bypassAI = false; // If this gets set to true A3A_fnc_attackDrillAI gets run on the group
private _groupX = grpNull;
private _truckX = objNull;

if (_isInfantry) then {
    // Infantry squads, array type

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
        // Old withbackpck stuff for MG and Mortar squads, needs rewrite
		/* if (_withBackpack == "MG") then {
			((units _groupX) select ((count (units _groupX)) - 2)) addBackpackGlobal supportStaticsSDKB2;
			((units _groupX) select ((count (units _groupX)) - 1)) addBackpackGlobal MGStaticSDKB;
			_format = "SqMG-";
		} else {
			if (_withBackpack == "Mortar") then {
				((units _groupX) select ((count (units _groupX)) - 2)) addBackpackGlobal supportStaticsSDKB3;
				((units _groupX) select ((count (units _groupX)) - 1)) addBackpackGlobal MortStaticSDKB;
				_format = "SqMort-";
			};
  	    }; */
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
    // Vehicles classname type (AA/AT vehicles, mortar/MG teams)

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
[localize "STR_antistasi_recruit_squad_hint_title", format [localize "STR_antistasi_recruit_squad_spawn_message", groupID _groupX]] call A3A_fnc_customHint;
if (!_isInfantry) exitWith {};
if !(_bypassAI) then {_groupX spawn A3A_fnc_attackDrillAI};

// The rest of this only needs to run if you specified a vehicle
if (_typeVehX isEqualTo "") exitWith {};

// TODO: make this use the correct vehicle type for findEmptyPosition?
_pos = position _road findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
private _purchasedVehicle = _typeVehX createVehicle _pos;
_purchasedVehicle setDir _roadDirection;
[_purchasedVehicle, teamPlayer] call A3A_fnc_AIVEHinit;
[_purchasedVehicle] spawn A3A_fnc_vehDespawner;
_groupX addVehicle _purchasedVehicle;
_purchasedVehicle setVariable ["owner",_groupX,true];

leader _groupX assignAsDriver _purchasedVehicle;
{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _groupX;
[localize "STR_antistasi_recruit_squad_hint_title", localize "STR_antistasi_recruit_squad_hint_vehicle_purchased"] call A3A_fnc_customHint;
petros directSay "SentGenBaseUnlockVehicle";
