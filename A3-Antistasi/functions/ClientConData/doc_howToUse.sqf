/*
== GENERAL INFORMATION ===
Acronym "CCD" is an initialisation of "Client Connection Data".
Pronounced "See-See-Dee"

=== KEY INFORMATION AND CODE PATTERN PRACTICES ===
1. These hashmaps are for translating UID or ClientID into a current player object. (A3A_CCD_byUID, A3A_CCD_byCID)
2. You do not need to interact with any CCD functions.
3. Use or comment the variables names directly (A3A_CCD_byUID, A3A_CCD_byCID), so implementations of it can be traced and updated for maintenance.

=== DATA LAYOUT ===
All hashmap values share the same data
[
    <STRING> _UID           Steam ID of player.
    <SCALAR> _clientID      Client ID, IDs are sequential, starting from 2 and ascending.
    <OBJECT> _playerObject  Last known live object controlled by player. Do not assume alive or human or non-null.
    <STRING> _name          Last known name this player connected with. Useful if a player's name is needed after they disconnect.
    <BOOL> _online          Last known online status about client. Eventually gets cleared bby server if client crashes out.
]

1. Items are not cleared off this list. Therefore, you can keep a reference of a CCD, and it will be updated until sever closure.
2. Data about disconnected clients will be maintained for JIP clients. Trying to remove a JIP queue item will result in it being nulled rather than removed. Therefore, might as well keep the data.
3. When a player reconnects, he will have a different clientID.
4. ONLY ON SERVER: A player's old client ID in A3A_CCD_byCID will still be linked to the new struct. This allows back checking of old owner IDs. This technique only works if the local machine could capture clientID history.

There is no need to reference players by another value. Therefore name, player, and it's volatile friends will not be considered as hashmap keys.


=== EXAMPLES ===*/
// To get player object from stored UID:
private _uid = "12345678901234567";
private _player = A3A_CCD_byUID getOrDefault [uid, [nil,nil,objNull]] select 2;


// To expose all data by cursorObject's owner;
(A3A_CCD_byCID getOrDefault [owner cursorObject, ["",-1,objNull,"",false]]) params ["_uid","_clientID","_player","_name","_online"];

// How to use an always updated CCD in a long running loop.
private _uid = "12345678901234567";
private _clientConnectionData = A3A_CCD_byUID get _uid;
if (isNil {_clientConnectionData}) exitWith {};

_clientConnectionData spawn {
    while {true} do {
        _this params ["_uid","_clientID","_player","_name","_online"];
        if (!_online) exitWith {
            hint (_name + " disconnected");
        };
        if (alive _player) then {
            if (isPlayer _player) then {
                hint (_name + " is at " + str getPos _player);
            } else {
                private _remotePlayer = leader _player;
                hint (_name + " is remote controlling " + name _remotePlayer + " at " + str getPos _remotePlayer);
            };
        } else {
            hint (_name + " is sleeping.");
        }
        uiSleep 15;
    };
};