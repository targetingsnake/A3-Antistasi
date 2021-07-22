/*
Maintainer: Caleb Serafin
    Accepts send client connection data updates.

Arguments:
    <STRING> Steam UID.
    <SCALAR> Client ID.
    <OBJECT> Player object.

Return Value:
    <ANY> undefined.

Scope: Clients, Local Arguments, Global Effect
Environment: Any
Public: No
Dependencies:
    <HASHMAP> A3A_CCD_byUID
    <HASHMAP> A3A_CCD_byCID
    <BOOLEAN> A3A_CCDStatistics

Example:
    ["12345678901234567", 5, player, "Bob"] remoteExec ["A3A_fnc_CCD_receiveUpdate",0,"A3A_CCD_U_12345678901234567"];
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_UID","",[""]],
    ["_clientID",-1,[-1]],
    ["_playerObject",objNull,[objNull]],
    ["_name","",[""]]
];

private _notPlayer = !isPlayer _playerObject;
private _emptyUID = _UID isEqualTo "";
private _invalidClientID = _clientID < 2;
private _newPlayer = !(_UID in A3A_CCD_byUID);
private _respawned = _clientID in A3A_CCD_byCID;
private _online = true;


if (_notPlayer || _emptyUID || _invalidClientID) then {
    // Error only if server (since the server will receive it as well.)
    // JIP clients can assume that a player disconnected.
    if (isServer) then {
        Error_3("(%1) (%2) (%3) | Client Connection Data is invalid.", _UID, _clientID,_playerObject);
    };
} else {
    if (_newPlayer) then {
        private _dataStruct = [_UID,_clientID,_playerObject,_name,_online];
        A3A_CCD_byUID set [_UID, _dataStruct];
        A3A_CCD_byCID set [_clientID, _dataStruct];
    } else {
        private _dataStruct = A3A_CCD_byUID get _UID;
        _dataStruct set [0, _UID];
        _dataStruct set [1, _clientID];
        _dataStruct set [2, _playerObject];
        _dataStruct set [3, _name];
        _dataStruct set [4, _online];
    }
};


if (A3A_CCDStatistics) then {
    private _prefix = "CCDStatistics | ("+str _playerObject+") ("+_UID+") ("+str _clientID+") ("+str _online+") | ";
    private _irregularities = [];

    private _bitFlags = [
        _notPlayer,
        _emptyUID,
        _invalidClientID,
        _newPlayer,
        _respawned
    ];
    _irregularities pushBack ("Bit flags (" + (_bitFlags apply { ["0","1"] select _x } joinString "") + ")");

    // If no false errors are logged, this can be implemented to prevent malicious cache poisoning and remove the need to send clientID.
    private _remoteExecOwner = 2 min remoteExecutedOwner;  // Local Host may have a owner of 0
    if (_clientID != _remoteExecOwner) then {
        _irregularities pushBack "RemoteExecutedOwner miss-match client and server ("+str _remoteExecOwner+")";
    };

    // This will give insight to how well defined the player object is on respawn.
    private _owner = owner _playerObject;
    if (_clientID != _owner) then {
        _irregularities pushBack "Owner miss-match ("+str _owner+")";
    };

    // This will give insight to how well defined the steam UID is on respawn or join.
    // If no false errors are logged, this can be implemented to remove the need to send UID.
    private _getPlayerUID = getPlayerUID _playerObject;
    if (_UID != _getPlayerUID) then {
        _irregularities pushBack "SteamUID miss-match ("+_getPlayerUID+")";
    };

    // If no false errors are logged, this can be implemented to remove the need to send name.
    private _nameOf = name _playerObject;
    if (_name != _nameOf) then {
        _irregularities pushBack "Name miss-match ("+_nameOf+")";  // The name is contained in str _playerObject
    };

    private _statistics = _prefix + (_irregularities joinString " | ");
    Info(_statistics);
};
