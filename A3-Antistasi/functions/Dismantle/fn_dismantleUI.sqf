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

private _canGiveAbility = player == theBoss || admin owner player > 0;
if !(_canGiveAbility || player getVariable ["allowedToDeconstruct",""] isEqualTo getPlayerUID player) exitWith {
    [_hintTitle, "You need to get dismantle ability from a commander or admin."] call A3A_fnc_customHint;
    nil;
};
if (!isNil {A3A_dismantleUI_isActive}) exitWith {};
A3A_dismantleUI_isActive = true;

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

private _actionID = player addAction [
    "<t font='PuristaMedium' color='#ff4040' shadow='2' size='2'><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa'/><br/>Exit Dismantle</t>",
    {
        scriptName "fn_dismantleUI.sqf:addAction";
        _this params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments params ["_canGiveAbility"];
        private _structure = cursorObject;

        private _fnc_exit = {
            player removeAction _actionId;
            A3A_dismantleUI_isActive = nil;
        };

        if (isNull _structure) exitWith _fnc_exit;
        if (netId _structure isEqualTo "1:0") exitWith {};// If it is an held weapon or other decal.
        if (_canGiveAbility && isPlayer _structure) exitWith { // Grant/Revoke deconstruction permission
            private _UID = getPlayerUID _structure;
            private _doesTargetHaveAbility = _structure getVariable ["allowedToDeconstruct",""] isEqualTo _UID;
            _structure setVariable ["allowedToDeconstruct",[_UID,nil] select _doesTargetHaveAbility];   // Toggles ability
        };
        if (typeOf _structure in A3A_dismantle_structureTimeCostHM) exitWith {
            private _worker = player;
            if (count groupSelectedUnits player > 0) then {
                _worker = groupSelectedUnits player #0;
            };
            private _workerCantWorkReason = [
                [!([_worker] call A3A_fnc_canFight),"Unit cannot perform rebel activities."],
                [(_worker getVariable ["helping",false]),"Helping someone."],
                [(_worker getVariable ["rearming",false]),"Rearming."],
                [(_worker getVariable ["constructing",false]),"performing construction."]
            ] select {_x#0} apply {_x#1} joinString "<br/>";
            if (count _workerCantWorkReason > 0) exitWith {
                ["Dismantle Info","Unit is busy:<br/>" + _workerCantWorkReason] call A3A_fnc_customHint;
            };
            //_worker setVariable ["constructing",true];

            private _isEngineer = _worker getUnitTrait "engineer";
            private _timeMultiplier = [0.75,0.25] select _isEngineer;
            private _costReturnMultiplier = [0.05,0.25] select _isEngineer;

            if (_worker == player) then {   // Since the player will proceed to dismantle.
                //call _fnc_exit;
                [_structure, _timeMultiplier, _costReturnMultiplier] spawn A3A_fnc_dismantle;
                //[] spawn A3A_fnc_dismantleUI;   // Reopen UI after exit, makes it seems asif it never closed!
            } else {
                [_structure, _timeMultiplier, _costReturnMultiplier] remoteExec ["A3A_fnc_dismantle",_worker];
            };


        };
    },
    [_canGiveAbility],
    69,
    true,
    false
];

addMissionEventHandler [
    "Draw3D",
    {
        scriptName "fn_dismantleUI.sqf:Draw3D";
        _thisArgs params ["_canGiveAbility","_lastStructure","_drawData","_actionID"];

        if (isNil{A3A_dismantleUI_isActive}) exitWith {
            removeMissionEventHandler ["Draw3D", _thisEventHandler];
        };
        private _structure = cursorObject;
        if (_structure != _lastStructure#0) then {
            _drawData resize 0;
            player setUserActionText [_actionID, "Exit Dismantle", "<t font='PuristaMedium' color='#ff4040' shadow='2' size='2'><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa'/><br/>Exit Dismantle</t>"];
            if (isNull _structure || {_structure distance player > 50}) exitWith {};
            if (netId _structure isEqualTo "1:0") exitWith {};// If it is an held weapon or other decal.
            if (_canGiveAbility && isPlayer _structure || _structure isKindOf "CAManBase") exitWith { // Grant/Revoke deconstruction permission
                private _operationMode = "";
                if (_structure getVariable ["allowedToDeconstruct",""] isEqualTo getPlayerUID _structure) then {
                    _operationMode = "revoke";
                    player setUserActionText [_actionID, "Revoke Dismantle Ability", "<t font='PuristaMedium' color='#ff4040' shadow='2' size='2'><img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_passLeadership_ca.paa'/><br/>Revoke Dismantle Ability</t>"];
                } else {
                    _operationMode = "grant";
                    player setUserActionText [_actionID, "Grant Dismantle Ability", "<t font='PuristaMedium' color='#99ff99' shadow='2' size='2'><img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_requestLeadership_ca.paa'/><br/>Grant Dismantle Ability</t>"];
                };
                private _boundingBox = 0 boundingBoxReal _structure;
                private _iconPos = (_structure modelToWorld [0,0,_boundingBox#1#2 * 0.75]);  // Chest position of soldier
                _drawData append [_operationMode,_iconPos];
            };
            if (typeOf _structure in A3A_dismantle_structureTimeCostHM) exitWith {
                private _operationMode = "deconstruct";
                private _boundingBoxMix = matrixTranspose (0 boundingBoxReal _structure select [0,2]);
                private _cubeEdges = A3A_dismantleUI_cubeEdges apply {
                    _x apply { _structure modelToWorldVisual [_boundingBoxMix#0#(_x#0),_boundingBoxMix#1#(_x#1),_boundingBoxMix#2#(_x#2)] };
                };
                private _structurePosAGLS = getPos _structure;
                private _iconPos = [_structurePosAGLS#0,_structurePosAGLS#1,1.72];  // 1.72 is eye height for most humans (Sorry Netherlanders, you gonna have to crook your neck)
                private _iconText = ["Dismantle","Order Unit to Dismantle"] select (count groupSelectedUnits player > 0);
                player setUserActionText [_actionID, _iconText, "<t font='PuristaMedium' color='#ffae00' shadow='2' size='2'><img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/><br/>"+_iconText+"</t>"];
                _drawData append [_operationMode,_cubeEdges,_iconPos];
            };


        };
        _lastStructure set [0,_structure];
        if (count _drawData == 0) exitWith {};
        switch (_drawData#0) do {
            case "grant": { drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_requestLeadership_ca.paa", [0.26,1,0.26,1], _drawData#1, 1,1,0,"", 2, 0.05, "PuristaMedium"]; };
            case "revoke": { drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_passLeadership_ca.paa", [1,0.25,0.25,1], _drawData#1, 1,1,0,"", 2, 0.05, "PuristaMedium"]; };
            case "deconstruct": {
                drawIcon3D ["\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa", [0.98,0.57,0.12,1], _drawData#2, 1,1,0,"" , 2, 0.05, "PuristaMedium"]; // #ffae00
                private _brightOrange = [1,1,0,1]; //[0.98,0.57,0.12,1]; // #ffae00 // Is outside forEach to avoid 11 more allocations.
                {
                    drawLine3D [ _x#0, _x#1, _brightOrange];
                } forEach (_drawData#1);
            };
        };

    },
    [_canGiveAbility,[objNull],[],_actionID] // Object is in a array allowing EH code to overwrite it's value and save.
];
nil;
