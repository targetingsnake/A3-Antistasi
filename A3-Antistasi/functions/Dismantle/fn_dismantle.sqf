/*
Maintainer: Caleb Serafin
    Animates structure dismantling.
    Deletes structure if dismantling was successful (Unit didn't take damage).
    Script only exits when structure is removed / action cancelled.

Arguments:
    <OBJECT> Structure to dismantle.
    <SCALAR> Build Time Multiplier (default: 0.75)
    <SCALAR> Build cost return Multiplier. (default: 0)

Return Value:
    <BOOL> true if dismantled. false if prematurely exited.

Scope: Local, Global Arguments, Global Effect
Environment: Scheduled
Public: No
Dependencies:
    <HASHMAP< <STRING>ClassName, <<SCALAR>Time,<SCALAR>Cost>> > A3A_dismantle_structureJouleCostHM (Initialised in A3-Antistasi\functions\REINF\fn_dismantle.sqf)

Example:
    [] spawn A3A_fnc_dismantle;
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

if (isNil {A3A_dismantle_structureJouleCostHM}) then {
    A3A_dismantle_structureJouleCostHM = createHashMapFromArray [
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
private _sharedDataMap = createHashMapFromArray [
    ["_inProgress",false],
    ["_object",objNull],
    ["_simpleObject",objNull],
    ["_roughHeight",1],
    ["_joules",0],
    ["_joulesRemaining",0],
    ["_dismantleRadius",69],
    ["_assistMode",false],
    ["_timeOfLastWork",serverTime]
];
A3A_dismantle_sharedDataMap = _sharedDataMap;

// We change the colour of the key name to orange. The text is aligned up so it is closer to the icon.
if (isNil {A3A_dismantle_holdSpaceTo}) then {
    private _keyNameRaw = actionKeysNames ["Action",1,"Keyboard"];
    private _keyName = _keyNameRaw select [1,count _keyNameRaw - 2]; // We are trimming the outer quotes.
    A3A_dismantle_holdSpaceTo = format ["<t font='PuristaMedium' shadow='2' size='1.5'>" + localize "STR_A3_HoldKeyTo" + "</t>", "<t color='#fc911e'>"+_keyName+"</t>", "%1"];// STR_A3_HoldKeyTo: "Hold %1 to %2"    // A3A_dismantle_holdSpaceTo: "Hold space to %1"
};
// We change the colour of the outside bars to orange
if (isNil {A3A_dismantle_holdAction_texturesProgress}) then {
    A3A_dismantle_holdAction_texturesProgress = [];
    for "_i" from 0 to 24 do {
        A3A_dismantle_holdAction_texturesProgress pushBack ("<img size='3' shadow='0' color='#fc911e' image='\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_"+str _i+"_ca.paa'/>");
    };
};

/*
// The output text of these functions will be parsed as structured text for the icon. However, there are private variables that we can fiddle with.
_iconIdle bis_fnc_holdAction_showIcon: (current scope)
    _target, _actionID, _title, _icon, _texSet, TEXTURES_PROGRESS (compiles to bis_fnc_holdAction_texturesProgress), _frame, _hint
*/
/* Only for _iconIdle
    bis_fnc_holdAction_animationTimerCode: (1 scope up)
        _eval, bis_fnc_holdAction_animationIdleTime, bis_fnc_holdAction_animationIdleFrame, bis_fnc_holdAction_running
*/
private _iconIdle = {
    _hint = "";
    A3A_dismantle_sharedDataMap set ["_assistMode",false];
    if !(typeOf cursorObject in A3A_dismantle_structureJouleCostHM) exitWith {
        "<img size='3' color='#ffffff' image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa'/><br/>"+
        "<br/>"+
        format [A3A_dismantle_holdSpaceTo,"Exit Dismantle"] + "<br/>" +
        "<t size='1.2' valign='top'>No Dismantlable Object Selected.</t>"
    };

    if (cursorObject isNotEqualTo (A3A_dismantle_sharedDataMap getOrDefault ["_object",objNull])) then { // If it is the same object, no need to re-calculate the radius cache.
        private _boundingBox = 0 boundingBoxReal cursorObject;
        A3A_dismantle_sharedDataMap set ["_dismantleRadius",(_boundingBox#2)/2 + 3]; // The bonus 3 meters is allocated for unit movement.
    };

    if !(player distance cursorObject < (A3A_dismantle_sharedDataMap get "_dismantleRadius")) exitWith {
        "<img size='3' color='#ffffff' image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_search_ca.paa'/><br/>"+
        "<br/>"+
        "<t font='PuristaMedium' shadow='2' size='1.5'>Go closer</t>";
    };

    private _isEngineer = player getUnitTrait "engineer";
    private _engineerBonusText = ["","<t size='0.9' valign='middle'>  *Engineer Bonus</t>"] select _isEngineer;
    private _inputWatts = [1.34,4] select _isEngineer;

    if !(isNull (cursorObject getVariable ["A3A_dismantler",objNull])) exitWith {
        A3A_dismantle_sharedDataMap set ["_assistMode",true];

        private _timeLeft = (cursorObject getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
        private _watts = cursorObject getVariable ["A3A_dismantle_watts",0];
        private _joulesRemaining = _timeLeft * _watts;

        _timeLeft = _joulesRemaining / (_watts + _inputWatts);

        "<img size='3' color='#ffffff' image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\meet_ca'/><br/>"+
        "<br/>"+
        format [A3A_dismantle_holdSpaceTo,"Assist <t color='#fc911e'>" + name (cursorObject getVariable ["A3A_dismantler",objNull]) + "</t>"] + "<br/>" +
        "<t size='1.2' valign='top'><t color='#00000000'>"+_engineerBonusText+"</t>"+str _timeLeft+"s<t color='#cccccc'>"+_engineerBonusText+"</t></t>";    // The invisible engineer text makes the numbers centers
    };

    (A3A_dismantle_structureJouleCostHM get (typeOf cursorObject)) params [["_joules",1],["_costReturn",0]];

    private _timeLeft = ceil (_joules / _inputWatts);
    _costReturn = ceil (_costReturn * ([0.05,0.25] select _isEngineer));

    A3A_dismantle_sharedDataMap set ["_object",cursorObject];

    "<img size='3' color='#ffffff' image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/><br/>"+
    "<br/>"+
    format [A3A_dismantle_holdSpaceTo,"Dismantle"] + "<br/>" +
    "<t size='1.2' valign='top'><t color='#00000000'>"+_engineerBonusText+"</t>"+str _timeLeft+"s "+str _costReturn+"€<t color='#cccccc'>"+_engineerBonusText+"</t></t>"    // The invisible engineer text makes the numbers centers

};
/*
_iconIdle bis_fnc_holdAction_showIcon: (current scope)
    _target, _actionID, _title, _icon, _texSet, TEXTURES_PROGRESS (compiles to bis_fnc_holdAction_texturesProgress), _frame, _hint
*/
/* Only for _iconProgress
    _codeInit:  (1st call, 1 scope up)
        _target(argument target), _caller, _actionID,
        _arguments(shared), _title, _iconIdle, _iconProgress _condProgress, _codeProgress, _codeCompleted, _codeInterrupted, _duration, _removeCompleted
        _condProgressCode
    _codeInit:  (2nd call, 1 scope up) (Diff from top)
        _target(argument target), _caller, _actionID,
        _arguments(shared), _title, _iconIdle, _codeProgress, _codeCompleted, _codeInterrupted, _removeCompleted
        _frame, _stepDuration
    _codeInit:  (3rd call, 1 scope up) (Diff from top)
        (Same access as above, just a later single executions)
*/
private _iconProgress = {
    private _sharedDataMap = _arguments#0;
    private _structure = _sharedDataMap get "_object";

    /// Progress and Time Calculation ///
    (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_costReturn",0]];
    private _watts = _structure getVariable ["A3A_dismantle_watts",0];
    private _joulesRemaining = _sharedDataMap get "_joulesRemaining";
    private _timeLeft = 0;

    _timeLeft = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
    _joulesRemaining = _timeLeft * _watts;
    /* if (A3A_dismantle_sharedDataMap get "_assistMode") then {   // Work out time from public vars. It is not accurate, nor it does not need to be.
        _timeLeft = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
        _joulesRemaining = _timeLeft * _watts;
    } else {                                                    // Work out time from joules left counter, this is consistent and won't become inaccurate when others assist.
        private _timeOfLastWork = _sharedDataMap get "_timeOfLastWork";
        private _deltaTime = serverTime - _timeOfLastWork;
        _sharedDataMap set ["_timeOfLastWork",serverTime];
        _joulesRemaining = _joulesRemaining - (_deltaTime * _watts);
        _sharedDataMap set ["_joulesRemaining",_joulesRemaining];
        _timeLeft = ceil (_joulesRemaining / _watts);
    }; */

    private _completionPercent = 1 - (_joulesRemaining / _joules);
    //_frame = ceil (_completionPercent * 24) min 24; // The hold action progress icons have 25 frames.
    //Info("_frame set to " + str _frame);
    //Info("_completionPercent set to " + str _completionPercent);
    if (_frame == 24) then {    // Last frame, this step duration is used for the final animation
        _stepDuration = (_joules / _watts) / 24;
    } else {
        _stepDuration = _timeLeft / (24 - _frame); // We can short step durations this to get high frequency animation updates. The displayed frame will not be affected as it is over written.
    };
    //_timeStart = time - ((_frame - 1) * _stepDuration);   // BIS hold action uses time
    //Info("_stepDuration set to " + str _stepDuration);
    //Info("_timeStart set to " + str _timeStart);

    /// Physical Animations ///
    if (medicAnims findIf {animationState player == _x} == -1) then {
        player playMoveNow selectRandom medicAnims;
    };
    (_sharedDataMap get "_simpleObject") setPos ([0,0,-(_sharedDataMap get "_roughHeight")] vectorMultiply _completionPercent vectorAdd getPos (_sharedDataMap get "_object"));

    /// UI Animations ///
    _texSet = A3A_dismantle_holdAction_texturesProgress;

    "<img size='3' color='#ffffff' image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\holdAction_market_ca.paa'/><br/>"+
    "<t font='PuristaMedium' shadow='2' size='2' color='#fc911e' valign='top'><t color='#00000000'>s</t>"+(_timeLeft toFixed 0)+"<t color='#ffffff'>s</t></t>"; // The invisible s makes the numbers centers
};

[
    player,                                            // Object the action is attached to
    "Dismantle",                                        // Title of the action
    _iconIdle,    // Idle icon shown on screen
    _iconProgress,    // Progress icon shown on screen
    'true',                        // Condition for the action to be shown
    'player distance (A3A_dismantle_sharedDataMap get "_object") < A3A_dismantle_sharedDataMap get "_dismantleRadius"',                        // Condition for the action to progress //
    {                                                    // Code executed when action starts
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;
        private _structure = _sharedDataMap get "_object";

        if !(A3A_dismantle_sharedDataMap get "_inProgress" || (typeOf _structure in A3A_dismantle_structureJouleCostHM)) exitWith {   // Will display the exit text when no object is selected.
            player removeAction _actionId;
        };
        if !(player distance _structure < _sharedDataMap get "_dismantleRadius") exitWith {}; // Progress condition is only checked after init.

        _sharedDataMap set ["_inProgress", true];

        private _isEngineer = player getUnitTrait "engineer";
        private _watts = [1.34,4] select _isEngineer;

        private _simpleObject = createSimpleObject [typeOf _structure, getPosASL _structure, true];
        player disableCollisionWith _simpleObject;
        _sharedDataMap set ["_simpleObject",_simpleObject];
        private _boundingBox = 0 boundingBoxReal _structure;
        private _roughHeight = -(_boundingBox#0#2) + _boundingBox#1#2;
        _sharedDataMap set ["_boundingBox",_boundingBox];
        _sharedDataMap set ["_roughHeight",_roughHeight];

        player playMoveNow selectRandom medicAnims;

        if (A3A_dismantle_sharedDataMap get "_assistMode") exitWith {
            [_structure,_watts] remoteExecCall ["A3A_fnc_dismantleAddAssist",_structure getVariable ["A3A_dismantler",objNull]]; // Variables are calculated and broadcast from single machine to avoid race conditions.
        };

        (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_costReturn",0]];
        private _timeLeft = ceil (_joules / _watts);    // This is defined in holdAction's parent scope
        _structure setVariable ["A3A_dismantle_eta",serverTime + _timeLeft,true];
        _structure setVariable ["A3A_dismantler",player,true];
        _structure setVariable ["A3A_dismantle_watts",_watts,true];

        _sharedDataMap set ["_joulesRemaining",_joules];
        _sharedDataMap set ["_timeOfLastWork",serverTime];
    },
    {},                                                    // Code executed on every progress tick (All progress code is contained in the icon.)
    {                                                   // Code executed on completion
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;

        A3A_dismantle_sharedDataMap set ["_assistMode",false];
        deleteVehicle (_sharedDataMap get "_simpleObject");
        _sharedDataMap set ["_inProgress", false];
        player switchMove "";
        if (A3A_dismantle_sharedDataMap get "_assistMode") exitWith {};

        private _structure = _sharedDataMap get "_object";
        if (_structure in staticsToSave) then {
            staticsToSave deleteAt (staticsToSave find _structure);
            publicVariable "staticsToSave"
        };
        deleteVehicle _structure;
        (A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_costReturn",0]];
        if (_costReturn > 0) then {
            private _isEngineer = player getUnitTrait "engineer";
            _costReturn = _costReturn * ([0.05,0.25] select _isEngineer);
            [0, _costReturn] remoteExec ["A3A_fnc_resourcesFIA",2];
        };
        ["<t font='PuristaMedium' color='#fc911e' shadow='2' size='1'> +"+(_costReturn toFixed 0)+"€</t>",-1,0.65,3,0.5,-0.75,789] spawn BIS_fnc_dynamicText;
        hint "";
    },
    {                                                    // Code executed on interrupted
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _sharedDataMap = _arguments#0;


        A3A_dismantle_sharedDataMap set ["_assistMode",false];
        deleteVehicle (_sharedDataMap get "_simpleObject");
        _sharedDataMap set ["_inProgress", false];
        player switchMove "";
        if (A3A_dismantle_sharedDataMap get "_assistMode") exitWith {
            private _isEngineer = player getUnitTrait "engineer";
            private _watts = [1.34,4] select _isEngineer;
            [_structure,-_watts] remoteExecCall ["A3A_fnc_dismantleAddAssist",_structure getVariable ["A3A_dismantler",objNull]]; // Variables are calculated and broadcast from single machine to avoid race conditions.
        };

        private _structure = _sharedDataMap get "_object";
        _structure setVariable ["A3A_dismantle_eta",nil,true];
        _structure setVariable ["A3A_dismantler",nil,true];
        _structure setVariable ["A3A_dismantle_watts",nil,true];

    },
    [_sharedDataMap],                                        // Arguments passed to the scripts as _this select 3 params ["_a0","_a1","_a2","_a3","_a4","_a5","_a6","_a7","_a8","_a9","_target","_title","_iconIdle","_iconProgress","_condShow","_condProgress","_codeStart","_codeProgress","_codeCompleted","_codeInterrupted","_duration","_removeCompleted"];
    420,                                                      // Action duration [s]
    69,                                                    // Priority
    false,                                                // Remove on completion
    false                                                // Show in unconscious state
] call BIS_fnc_holdActionAdd;


true;
