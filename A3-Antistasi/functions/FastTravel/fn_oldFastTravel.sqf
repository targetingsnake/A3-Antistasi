/*
Maintainer: DoomMetal
    Teleports a a unit, group or high command group to a selected location.

Arguments:
    None

Return Value:
    None

Scope: Clients, Global Effect
Environment: Any
Public: Yes
Dependencies:
    <ARRAY> markersX
    <STRING> respawnTeamPlayer
	<BOOL> limitedFT
	<ARRAY> airportsX
	<SIDE> Occupants
	<SIDE> Invaders
	<ARRAY> forcedSpawn

Example:
    [] call A3A_fnc_fastTravel;
*/

private ["_roads","_pos","_positionX","_groupX"];

_canFastTravel = [] call A3A_fnc_canFastTravel;

if !(_canFastTravel#0) exitWith {["Fast Travel", "Can't fast travel!" + "<br/><br/>" + _canFastTravel#1] call A3A_fnc_customHint;};

_markersX = markersX + [respawnTeamPlayer];

// High Command groups
private _isHighCommandGroup = false;
if (count hcSelected player == 1) then {_groupX = hcSelected player select 0; _isHighCommandGroup = true} else {_groupX = group player};

private _checkForPlayer = false;
if ((!_isHighCommandGroup) and limitedFT) then {_checkForPlayer = true};
private _boss = leader _groupX;

if ((_boss != player) and (!_isHighCommandGroup)) then {_groupX = player};

// Pre-map checks done

positionTel = [];

/* _hcShownBar = hcShownBar;
if (_hcShownBar || _isHighCommandGroup) then {hcShowBar false}; */

// This is not needed because position selection is moved to the UI
/* if (_isHighCommandGroup) then {hcShowBar false};
["Fast Travel", "Click on the zone you want to travel"] call A3A_fnc_customHint;
if (!visibleMap) then {openMap true};
onMapSingleClick "positionTel = _pos;";
waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
onMapSingleClick "";
_positionTel = positionTel; */

// *VERY* rudimentary position validation :/
// This is already done in a better way with the UI update so this check is no longer needed
if (count _positionTel > 0) then
{
    // Find nearest marker to clicked position on map
	_base = [_markersX, _positionTel] call BIS_Fnc_nearestPosition;

    // Moved to fn_canFastTravelToLocation
	if (_checkForPlayer and ((_base != "SYND_HQ") and !(_base in airportsX))) exitWith {
        ["Fast Travel", "Player groups are only allowed to Fast Travel to HQ or Airbases"] call A3A_fnc_customHint;
    };

    // Moved to fn_canFastTravelToLocation
	if ((sidesX getVariable [_base,sideUnknown] == Occupants) or (sidesX getVariable [_base,sideUnknown] == Invaders)) exitWith {
        ["Fast Travel", "You cannot Fast Travel to an enemy controlled zone"] call A3A_fnc_customHint; openMap [false,false]
    };

    // Moved to fn_canFastTravelToLocation despite it being commented out, just in case...
	//if (_base in outpostsFIA) exitWith {hint "You cannot Fast Travel to roadblocks and watchposts"; openMap [false,false]};

    // Moved to fn_canFastTravelToLocation
	if ([getMarkerPos _base,500] call A3A_fnc_enemyNearCheck) exitWith {
        ["Fast Travel", "You cannot Fast Travel to an area under attack or with enemies in the surrounding"] call A3A_fnc_customHint;
        openMap [false,false];
    };

    // If distance between clicked position and nearest marker to that position is less than 50
    // This is already done by getting the marker instead of clicked map position so this check is no longer needed
	if (_positionTel distance getMarkerPos _base < 50) then {

        // Get a random position 10m from the selected marker
		_positionX = [getMarkerPos _base, 10, random 360] call BIS_Fnc_relPos;
        // Get the distance between group leader and the random position / 200, this is used for time, not distance?
		_distanceX = round (((position _boss) distance _positionX)/200);

        // This was commented out before
		/* if (!_isHighCommandGroup) then {
            disableUserInput true;
            cutText ["Fast traveling, please wait","BLACK",2];
            sleep 2;
        } else {
            hcShowBar false;
            hcShowBar true;
            hint format ["Moving group %1 to destination",groupID _groupX];
            sleep _distanceX;
        }; */

		_forcedX = false;

        // SP shit, probably not needed anymore
		/* if (!isMultiplayer) then {
            if (not(_base in forcedSpawn)) then {
                _forcedX = true;
                forcedSpawn = forcedSpawn + [_base]
            };
        }; */

		if (!_isHighCommandGroup) then {
			disableUserInput true;
            cutText [format ["Fast traveling, travel time: %1s , please wait", _distanceX],"BLACK",1];
            sleep 1;
		} else {
			hcShowBar false;
			hcShowBar true;
			["Fast Travel", format ["Moving group %1 to destination",groupID _groupX]] call A3A_fnc_customHint;
			sleep _distanceX;
		};

		if (!_isHighCommandGroup) then {
			_timePassed = 0;
			while {_timePassed < _distanceX} do {
				cutText [format ["Fast traveling, travel time: %1s , please wait", (_distanceX - _timePassed)],"BLACK",0.0001];
				sleep 1;
				_timePassed = _timePassed + 1;
			};
		};

		// _exit = false; // Not used ?

		if (limitedFT) then {
			_vehicles = [];
			{
                if (vehicle _x != _x) then {
                    _vehicles pushBackUnique (vehicle _x)
                };
            } forEach units _groupX;

			{
                if ((vehicle _x) in _vehicles) exitWith {
                    _checkForPlayer = true;
                };
            } forEach (call A3A_fnc_playableUnits);
		};

		if (_checkForPlayer and ((_base != "SYND_HQ") and !(_base in airportsX))) exitWith {
            ["Fast Travel", format ["%1 Fast Travel has been cancelled because some player has boarded their vehicle and the destination is not HQ or an Airbase",groupID _groupX]] call A3A_fnc_customHint;
        };

        // Loop through all units in the group
		{
			_unit = _x;
			if ((!isPlayer _unit) or (_unit == player)) then {
				//_unit hideObject true;
				_unit allowDamage false;
				if (_unit != vehicle _unit) then {
					if (driver vehicle _unit == _unit) then {
						sleep 3;

                        // Replace with BIS_fnc_nearestRoad
						/* _radiusX = 10;
						while {true} do {
							_roads = _positionX nearRoads _radiusX;
							if (count _roads > 0) exitWith {};
							_radiusX = _radiusX + 10;
						};
						_road = _roads select 0; */

						_pos = position _road findEmptyPosition [10,100,typeOf (vehicle _unit)];
						vehicle _unit setPos _pos;
					};
					if ((vehicle _unit isKindOf "StaticWeapon") and (!isPlayer (leader _unit))) then {
						_pos = _positionX findEmptyPosition [10,100,typeOf (vehicle _unit)];
						vehicle _unit setPosATL _pos;
					};
				} else {
					if (!(_unit getVariable ["incapacitated",false])) then {
						_positionX = _positionX findEmptyPosition [1,50,typeOf _unit];
						_unit setPosATL _positionX;
						if (isPlayer leader _unit) then {
							_unit setVariable ["rearming",false]
						};
						_unit doWatch objNull;
						_unit doFollow leader _unit;
					} else {
						_positionX = _positionX findEmptyPosition [1,50,typeOf _unit];
						_unit setPosATL _positionX;
					};
				};
			};
			//_unit hideObject false;
		} forEach units _groupX;

		//if (!_isHighCommandGroup) then {sleep _distanceX};

		if (!_isHighCommandGroup) then {
            disableUserInput false;
            cutText ["You arrived to destination","BLACK IN",1];
        } else {
            ["Fast Travel", format ["Group %1 arrived to destination",groupID _groupX]] call A3A_fnc_customHint;
        };

        // More leftover SP shit?
		/* if (_forcedX) then {
            forcedSpawn = forcedSpawn - [_base]
        }; */

		sleep 5;
		{_x allowDamage true} forEach units _groupX;
	} else {
		["Fast Travel", "You must click near marker under your control"] call A3A_fnc_customHint;
	};
};
// if (_hcShownBar) then {hcShowBar true};
openMap false;
