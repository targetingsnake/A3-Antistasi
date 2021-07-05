/*
Maintainer: Caleb Serafin
    Declares CCD Hashmaps.
    Will add statistic logging event handlers.

Arguments:

Return Value:
    <ANY> Undefined.

Scope: All, Local Arguments, Local Effect
Environment: Any
Public: No
Dependencies:
    <BOOLEAN> A3A_CCDStatistics
    <HASHMAP> A3A_CCD_byUID
    <HASHMAP> A3A_CCD_byCID

Example:
    [] call A3A_fnc_CDD_init;
*/
#include "../../Includes/common.inc"
FIX_LINE_NUMBERS()

A3A_CCD_byUID = createHashMap;
A3A_CCD_byCID = createHashMap;

if (isServer) then {
    addMissionEventHandler ["PlayerConnected", {
        params ["_id", "_UID", "_name", "_jip", "_clientID", "_idstr"];
        if (!A3A_CCDStatistics) exitWith {
            removeMissionEventHandler _thisEventHandler;
        };
        Info("CCDStatistics | (n/a) (%1) (%2) | Player joined (%3) (n/a) | JIP (%4)",_UID,_clientID,_name,_jip);
    }];
    addMissionEventHandler ["EntityRespawned", {
        params ["_entity", "_corpse"];
        if (!A3A_CCDStatistics) exitWith {
            removeMissionEventHandler _thisEventHandler;
        };
        private _clientID = owner _entity;
        private _UID = getPlayerUID _entity;
        Info("CCDStatistics | (n/a) (%1) (%2) | Player respawned (%3) (n/a) | JIP (%4)",_UID,_clientID,_corpse,_jip);
    }];
    addMissionEventHandler ["PlayerDisconnected", {
        params ["_id", "_UID", "_name", "_jip", "_owner", "_idstr"];

        if (A3A_CCDStatistics) then {
            Info("CCDStatistics | (n/a) (%1) (%2) | Player disconnected (%3) (n/a) | JIP (%4)",_UID,_clientID,_name,_jip);
        };

        [_UID] spawn {
            params ["_UID"];
            (A3A_CCD_byUID get _UID) params ["_","_clientID","_player","_name","_online"];
            if !(_online) exitWith {};
            if (A3A_CCDStatistics) then {
                private _timeOut = serverTime + 15;
                private _startTime = serverTime;
                while {serverTime < _timeOut && !_online} do {
                    Info_3("(n/a) (%1) (%2) (n/a) | Waiting on player disconnect broadcast, (%3) sec", _UID, str _clientID, str (serverTime - _startTime));
                    uiSleep 5;
                };
            } else {
                uiSleep 15;
            };
            if !(_online) exitWith {};

            _timeout = "(n/a) ("+_UID+") ("+str _clientID+") (n/a) | Player disconnect not broadcast, likely crashed";
            Error_2("(n/a) (%1) (%2) (n/a) | Player disconnect not broadcast, likely crashed", _UID, str _clientID);
            [_UID] call A3A_fnc_CCD_sendDisconnect;
        };
    }];
};
