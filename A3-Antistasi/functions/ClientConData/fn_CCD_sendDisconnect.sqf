/*
Maintainer: Caleb Serafin
    Broadcasts client connection data disconnection.
    Includes SteamUID and clientID as well.
    Can start from client or server
    Will also update the local cache.
    Will overwrite the sendUpdate JIP ID.

Arguments:
    <STRING> Leaving player's Steam UID.

Return Value:
    <ANY> undefined.

Scope: Server/Client, Local Arguments, Global Effect
Environment: Any
Public: No
Dependencies:

Example:
    ["12345678901234567"] call A3A_fnc_CCD_sendDisconnect;
*/
params [
    ["_UID","",[""]]
];

if !(_UID in A3A_CCD_byUID) exitWith {
    ServerError_1("UID not found in A3A_CCD_byUID (%1)", _UID);
};
(A3A_CCD_byUID get _UID) params ["_","_clientID","_player","_name","_online"];

private _JIPID = "A3A_CCD_U" + _UID;

[_UID, _clientID, _playerObject, _name] remoteExec ["A3A_fnc_CCD_recieveDisconnect",-_clientID,_JIPID];
[_UID, _clientID, _playerObject, _name] call A3A_fnc_CCD_recieveDisconnect];
