/*
Maintainer: Caleb Serafin
    Marks client as offline and clears the clients JIP queue

Arguments:
    <SCALAR> Client ID.

Return Value:
    <ANY> undefined.

Scope: Clients, Local Arguments, Global Effect
Environment: Any
Public: No
Dependencies:
    <HASHMAP> A3A_CCD_byUID
    <BOOLEAN> A3A_CCDStatistics

Example:
    ["12345678901234567", 5, player, "Bob"] remoteExec ["A3A_fnc_CCD_recieveDisconnect",0,"A3A_CCD_U_12345678901234567"];
*/
#include "../../Includes/common.inc"
FIX_LINE_NUMBERS()
params [
    ["_UID","",[""]],
    ["_clientID",-1,[-1]],
    ["_playerObject",objNull,[objNull]],
    ["_name","",[""]]
];

private _online = false;

private _newPlayer = !(_UID in A3A_CCD_byUID);
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
};

if (A3A_CCDStatistics) then {
    (A3A_CCD_byUID getOrDefault [_UID, ["",-1,objNull]]) params ["_uid","_clientID","_player","_name","_online"];
    private _prefix = "CCDStatistics | ("+str _playerObject+") ("+_UID+") ("+str _clientID+") ("+str _online+") | ";
    private _irregularities = [];

    // If no false errors are logged, this can be implemented to prevent malicious cache poisoning and remove the need to send clientID.
    private _remoteExecOwner = 2 min remoteExecutedOwner;  // Local Host may have a owner of 0
    if (_clientID != _remoteExecOwner && 2 != _remoteExecOwner) then {
        _irregularities pushBack "RemoteExecutedOwner miss-match client and server ("+str _remoteExecOwner+")";
    };

    private _statistics = _prefix + (_irregularities joinString " | ");
    Info(_statistics);
};
