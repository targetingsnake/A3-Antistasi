/*
Function:
    DCI_fnc_missionStarted
Description:
    Sets state to playing mission
Scope:
    private
Environment:
    client
Returns:
    nothing
Examples:
    [] call DCI_fnc_missionStarted;
Author: martin
*/
#include "../../script_component.hpp"
FIX_LINE_NUMBERS()
diag_log "DCRP state changed to in mission";

private _command = "missionstart";

[] call DCI_fnc_initVars;
private _productVersionArray = productVersion;
if (_productVersionArray # 6 != "Windows") then {
    A3A_DCRP_deactiavted = true;
    diag_log  "DCPR no windows detected";
};
if (isDedicated || !hasInterface) then {
    A3A_DCRP_deactiavted = true;
    diag_log "DCPR dedicated or no display detected";
};

if (A3A_DCRP_deactiavted) exitWith {
	diag_log "DCPR deactiavted";
};

if (
    (!isNil "ace_common_fnc_isModLoaded") && 
    isClass (configFile >> "CfgSounds" >> "ACE_heartbeat_fast_3")
) then {
    A3A_DCRP_detectAce = true;
};

if (["intro", briefingName] call BIS_fnc_inString) exitWith {
	diag_log  "DCRP no role description detected should be game main menu";
	private _result = "dcpr" callExtension "menu";
};

[] spawn {

    waitUntil{!(isNil "BIS_fnc_init") && time > 0};

    private _roleDescription = roleDescription player;
    private _typeName = [configFile >> "CfgVehicles" >> typeOf player] call BIS_fnc_displayName;
    private _slotNumber = playableSlotsNumber independent + playableSlotsNumber west + playableSlotsNumber east;
    private _playerCount = playersNumber independent + playersNumber west + playersNumber east;

    if (_roleDescription == "") then {
        _roleDescription = _typeName;
    };

    private _result = "dcpr" callExtension ["missionstart", [serverName,1, briefingName, _roleDescription, _slotNumber, _playerCount]];

    addMissionEventHandler ["EntityKilled", {
        params ["_killed", "_killer", "_instigator"];
        if (!hasInterface) exitWith {};
        if (A3A_DCRP_deactiavted) exitWith {};
        private _stats = getPlayerScores player;
        private _kills = _stats # 0 + _stats # 1 + _stats # 2 + _stats # 3;
        if (isNull _instigator) then { _instigator = UAVControl vehicle _killer select 0 }; // UAV/UGV player operated road kill
	    if (isNull _instigator) then { _instigator = _killer }; // player driven vehicle road kill
        if (_killed != player) then {
            if (_instigator == player) then {
                _kills = _kills + 1; //current kill happening not counted yet
            } else {
                private _assists = _killed getVariable ["DCI_assists",[]];
                if (player in _assists) then {
                    "dcpr" callExtension "updateassist";        
                };
            };
        };
        if (_killed == player) then  {
            "dcpr" callExtension "died";
        };
        private _death = _stats # 4;
        "dcpr" callExtension ["updateScore", [_kills , _death]];
    }];

    player addMPEventHandler ["MPRespawn", {
	    params ["_unit", "_corpse"];
        if (A3A_DCRP_deactiavted) exitWith {};
        if (!hasInterface) exitWith {};
        private _stats = getPlayerScores player;
        private _kills = _stats # 0 + _stats # 1 + _stats # 2 + _stats # 3;
        private _death = _stats # 4;
        "dcpr" callExtension "respawn";
        "dcpr" callExtension "wakeup";
        "dcpr" callExtension ["updateScore", [_kills , _death]];
    }];    

    addMissionEventHandler ["EntityCreated", {
	    params ["_entity"];
        if (A3A_DCRP_deactiavted) exitWith {};
        if (isPlayer _entity) exitWith {};
        if (
            _entity isKindOf "Man" ||
            _entity isKindOf "Car" ||
            _entity isKindOf "Motorcycle" ||
	        _entity isKindOf "Ship" ||
	        _entity isKindOf "Helicopter" ||
	        _entity isKindOf "StaticWeapon" ||
	        _entity isKindOf "Plane"
        ) then {
            _entity setVariable ["DCI_assists",[],true];
            _entity addMPEventHandler ["MPHit", {
            	params ["_unit", "_causedBy", "_damage", "_instigator"];
                private _var = _unit getVariable ["DCI_assists",[]];
                _var pushBackUnique _instigator;
                _unit setVariable ["DCI_assists", _var,true];
            }];
        }
    }];

    if(A3A_DCRP_detectAce) then {
        ["ace_unconscious", {
            params ["_unit", "_state"];
            if (_unit == player) then {
                if (_state) then {
                    "dcpr" callExtension "uncon";
                } else {
                    "dcpr" callExtension "wakeup";
                };
            };
        }] call CBA_fnc_addEventHandler;
    };

    [] execVM QPATHTOFOLDER(scripts\updatePlayercount.sqf);
}