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
        private statistics = "CCDStatistics | (n/a) ("+_UID+") ("+str _clientID+") | Player joined ("+_name+") (n/a) | JIP ("+str _jip+")";
        Info(statistics);
    }];
    addMissionEventHandler ["EntityRespawned", {
        params ["_entity", "_corpse"];
        if (!A3A_CCDStatistics) exitWith {
            removeMissionEventHandler _thisEventHandler;
        };
        private _clientID = owner _entity;
        private _UID = getPlayerUID _entity;
        private statistics = "CCDStatistics | ("+str _entity+") ("+_UID+") ("+str _clientID+") (n/a) | Player respawned ("+str _corpse+")";
        Info(statistics);
    }];
    addMissionEventHandler ["PlayerDisconnected", {
        params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
        if (!A3A_CCDStatistics) exitWith {
            removeMissionEventHandler _thisEventHandler;
        };
        private statistics = "CCDStatistics | (n/a) ("+_UID+") ("+str _clientID+") (n/a) | Player disconnected ("+_name+") | JIP ("+str _jip+")";
        Info(statistics);
    }];
};
