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

diag_log "DCRP state changed to in mission";

private _command = "missionstart";

[] call DCI_fnc_initVars;
private _productVersionArray = productVersion;
if (_productVersionArray # 6 != "Windows") then {
    DCI_deactiavted = true;
    diag_log "DCPR no windows detected";
};
if (isDedicated || !hasInterface) then {
    DCI_deactiavted = true;
    diag_log "DCPR dedicated or no display detected";
};

if (DCI_deactiavted) exitWith {
	diag_log "DCPR deactiavted";
};

private _roleDescription = roleDescription player;
private _typeName = [configFile >> "CfgVehicles" >> typeOf player] call BIS_fnc_displayName;

if (_roleDescription == "" && _typeName == "") exitWith {
	diag_log "DCRP no role description detected should be game main menu";
	private _result = "dcpr" callExtension "menu";
};

if (_roleDescription == "") then {
	_roleDescription = _typeName;
};

_command = _command + "@@@" + serverName;
_command = _command + "@@@1";
_command = _command + "@@@" + briefingName;
_command = _command + "@@@" + _roleDescription;
private _slotNumber = playableSlotsNumber independent + playableSlotsNumber west + playableSlotsNumber east;
_command = _command + "@@@" + str _slotNumber ;
private _playerCount = playersNumber independent + playersNumber west + playersNumber east;
_command = _command + "@@@" + str _playerCount;


private _result = "dcpr" callExtension _command;