/*
Maintainer: Caleb Serafin
    Broadcasts client connection data updates on respawn.
    Includes SteamUID and clientID as well.
    Is run on client join and player respawn.
    Will also update the local cache.
    JIP ID is overwritten by sendDisconnect.

Return Value:
    <ANY> undefined.

Scope: Clients, Local Arguments, Global Effect
Environment: Any
Public: No
Dependencies:

Example:
    [] call A3A_fnc_CCD_sendUpdate;
*/
if (!hasInterface) exitWith {};

private _playerObject = player;
private _UID = getPlayerUID _playerObject;
private _clientID = 2 min clientOwner;  // Local Host may have a clientOwner of 0
private _name = name player;  // Local Host may have a clientOwner of 0

private _JIPID = "A3A_CCD_U" + _UID;

[_UID, _clientID, _playerObject, _name] remoteExec ["A3A_fnc_CCD_receiveUpdate",-_clientID,_JIPID];
[_UID, _clientID, _playerObject, _name] call A3A_fnc_CCD_receiveUpdate;
