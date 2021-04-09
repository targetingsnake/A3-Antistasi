/*
Maintainer: Caleb Serafin
    Authenticates that the local machine can order deconstructions.
    Starts the destruction selector dialogue.
    Checks if the select object can eb deconstructed.
    Checks if an AI engineer is selected for job, otherwise it assigns to the player.

Return Value:
    <nil> Expected to be run from an event.

Scope: Clients
Environment: Scheduled
Public: Yes

Example:
    [] spawn A3A_fnc_dismantleUI; // nil
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _hintTitle = "Dismantle Info";

private _isAuthoriser = player == theBoss || admin owner player > 0;
if !(_isAuthoriser || player getVariable ["allowedToDeconstruct",""] isEqualTo getPlayerUID player) exitWith {
    [_hintTitle, "You need to get deconstruction ability from a commander or admin."] call A3A_fnc_customHint;
    nil;
};

if (isNil {A3A_dismantle_structureTimeCostHM}) then {
    A3A_dismantle_structureTimeCostHM = createHashMapFromArray [
        ["Land_GarbageWashingMachine_F",[60,0]],
        ["Land_JunkPile_F",[60,0]],
        ["Land_Barricade_01_4m_F",[60,0]],
        ["Land_WoodPile_F",[60,0]],
        ["CraterLong_small",[60,0]],
        ["Land_Barricade_01_10m_F",[60,0]],
        ["Land_WoodPile_large_F",[60,0]],
        ["Land_BagFence_01_long_green_F",[60,0]],
        ["Land_SandbagBarricade_01_half_F",[60,0]],
        ["Land_Tyres_F",[100,0]],
        ["Land_TimberPile_01_F",[100,0]],
        ["Land_BagBunker_01_small_green_F",[60,100]],
        ["Land_PillboxBunker_01_big_F",[120,300]]
    ];
};
if (isNil {A3A_dismantleUI_cubeEdges}) then {
    A3A_dismantleUI_cubeEdges = [
        [[0,0,0],[1,0,0]],
        [[0,0,0],[0,1,0]],
        [[0,0,0],[0,0,1]],

        [[0,1,1],[1,1,1]],
        [[0,1,1],[0,0,1]],
        [[0,1,1],[0,1,0]],

        [[1,0,1],[0,0,1]],
        [[1,0,1],[1,1,1]],
        [[1,0,1],[1,0,0]],

        [[1,1,0],[0,1,0]],
        [[1,1,0],[1,0,0]],
        [[1,1,0],[1,1,1]]
    ];
};

private _highlight_cancellationToken = [false];
A3A_dismantleUI_highlight_args = [_highlight_cancellationToken,_isAuthoriser,objNull,[]]; // Delete when Arma 2.04 drops
addMissionEventHandler [
    "Draw3D",
    {
        private _thisArgs = A3A_dismantleUI_highlight_args;      // Delete when Arma 2.04 drops
        _thisArgs params ["_highlight_cancellationToken","_isAuthoriser","_lastStructure","_drawData"];
        if (_highlight_cancellationToken#0) exitWith {
            removeMissionEventHandler ["Draw3D", _thisEventHandler];
        };
        private _structure = cursorObject;
        if (_structure != _lastStructure) then {
            _drawData resize 0;
            if (isNull _structure) exitWith {};
            if (_isAuthoriser && isPlayer _structure) exitWith { // Give deconstruction permission
                _drawData pushBack "icon";
            };
            private _className = typeOf _structure;
            //if !(_className in A3A_dismantle_structureTimeCostHM) exitWith {};
            _drawData pushBack "frame";

            private _boundingBoxMix = matrixTranspose (0 boundingBoxReal _structure select [0,2]);
            _drawData pushBack (
                A3A_dismantleUI_cubeEdges apply {
                    _x apply { _structure modelToWorldVisual [_boundingBoxMix#0#(_x#0),_boundingBoxMix#1#(_x#1),_boundingBoxMix#2#(_x#2)] };
                }
            );
        };
        _thisArgs set [2,_structure]; // _lastStructure
        if (count _drawData == 0) exitWith {};
        if (_drawData#0 isEqualTo "icon") exitWith {
            drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", [1,1,1,1], getPos _structure, 1,1,0,"Grant Deconstruction Ability", 0, 0.05, "PuristaMedium"];
        };
        private _brightOrange = [1,1,0,1]; //[0.98,0.57,0.12,1]; // #fc911e // Is outside forEach to avoid 11 more allocations.
        {
            drawLine3D [ _x#0, _x#1, _brightOrange];
        } forEach (_drawData#1);

    }/*,    // Uncomment when Arma 2.04 drops
    [_highlight_cancellationToken,_isAuthoriser,objNull,[]]*/
];

private _timeOut = serverTime + 30;
waitUntil {
    sleep 1;
    (serverTime > _timeOut);
};
_highlight_cancellationToken set [0,true];

nil;
