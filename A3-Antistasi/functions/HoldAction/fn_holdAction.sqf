/*
Maintainer: Caleb Serafin
    Add an advanced and fast hold action.
    The parameters after shared cannot be changed during runtime. So choose wisely
    addActions arguments extracted from https://community.bistudio.com/wiki/addAction

Arguments:
    <HASHMAP> _shared holdAction data. Values can be set in a hashMap before the action is created. See bottom of function for values you can override. [Default=false]
    <OBJECT> Unit, vehicle or static object. No agents and simple objects!
    <SCALAR> Priority value of the action. Actions will be arranged in descending order according to this value. Can be negative or fraction. Same priorities will be arranged in newest at the bottom. [Default=1.5]
    <STRING> One of the key names defined in bin.pbo (e.g. "moveForward"). Adding shortcut will bind corresponding keyboard key to this action. Shortcut can be tested with inputAction command [Default=""]
    <SCALAR> Maximum 3D distance in meters between the activating unit's eyePos and the object's memoryPoint, selection or position. -1 disables the radius. [Default=15]
    <BOOLEAN> If true will be shown to incapacitated player. See also setUnconscious and lifeState. [Default=false]
    <STRING> object's geometry LOD's named selection [Default=""]
    <STRING> object's memory point. If selection is supplied, memoryPoint is not used [Default=""]

Return Value:
    <HASHMAP> Same reference to _shared.

Scope: Clients, Local Arguments, Local Effect
Environment: Any
Public: Yes
Dependencies:
    <CODE> holdActionInit needs to be finished.

Example:
    // Add hold action
    _shared = [false,player] call A3A_fnc_holdAction;
    // Remove hold action
    _shared set ["_dispose",true];

    // Full list;
    [_shared,_target,_priority,_keyShortcut,_radius,_showUnconscious,_modelSelection,_modelMemoryPoint] call A3A_fnc_holdAction;
*/


#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_shared",false,[false,A3A_const_hashMap]],
    ["_target",objNull,[objNull]],
    ["_priority",1000,[123]],
    ["_keyShortcut","",[""]],
    ["_radius",15,[123]],
    ["_showUnconscious",false,[false]],
    ["_modelSelection","",[""]],
    ["_modelMemoryPoint","",[""]]
];

if (_target isEqualTo objNull) exitWith {
    Error("_target was objNull");
};
// _shared is used to store and track all internal states.
if !(_shared isEqualType A3A_const_hashMap) then {
    _shared = createHashMap;
};

// Process ID is used to store the shareArray used by this instance. This is an alternative to large string code for addAction's conditionShow.
private _PID = A3A_holdAction_PIDCounter;
A3A_holdAction_PIDCounter = A3A_holdAction_PIDCounter +1;
private _PID_sharedName = "A3A_holdAction_shared_" + str _PID;
missionNamespace setVariable [_PID_sharedName,_shared];

//preprocess data
private _textContext = format[A3A_holdAction_holdSpaceTo,"color='#ffae00'",_textMenu];
_textContext = format["<t font='RobotoCondensedBold'>%1</t>",_textContext];
_textMenu = format["<t color='#FFFFFF' align='left'>%1</t>        <t color='#83ffffff' align='right'>%2     </t>",_textMenu,_keyName];

// Selects texture from animation loop or global progress
if (isNil "A3A_fnc_holdAction_textureSelector") then {A3A_fnc_holdAction_textureSelector = {
    params [
        "_shared",
        ["_textureAnimation", "textureSelectorMissingno", ["", []], [2]]
    ];
    if (_textureAnimation isEqualType "") exitWith {_textureAnimation};  // Return immediately if static texture.
    _textureAnimation params [
        ["_duration",0,[ 0 ]],
        ["_textures",[],[ [] ]]
    ];
    private _ratio = if (_duration > 0) then {
        (serverTime / _duration) mod 1;  // Ratio is based on serverTime.
    } else {
        (_shared get "_completionProgress") / (_shared get "_completionGoal");  // Ratio is based on progress percentage
    };
    // The main count textures omitted -1. This makes it act as if there was an extra texture. This allows all texture frames to have the same on screen duration.
    // Basic floor wouldn't show the last frame.
    // Basic ceiling wouldn't show the first frame.
    // Basic round would give the first and last frame half the time compared to middle frames.
    // Additional min is required as ratio can reach 100%.
    private _textureIndex = 0 max floor (count _textures * _ratio) min (count _textures -1);
    private _singleTexture = _textures #(_textureIndex); // The duration is first, so it has to be offset.

    if (isNil {_singleTexture}) then {
        _singleTexture = "Texture Selection Error";
        Error_1("textureSelector: Output Texture was null. _textureAnimation: %1",str _textureAnimation);
    };
    _singleTexture;
};};

// Updates the action with appropriate icon and text.
if (isNil "A3A_fnc_holdAction_updateGraphics") then {A3A_fnc_holdAction_updateGraphics = {
    private _shared = _this;
    private _state = _shared get "_state";

    if (_state isEqualTo "hidden") exitWith {};
    if !(_state in ["hidden","disabled","idle","progress"]) then {
        Error("Illegitimate state found in updateText: "+ _state);
        _shared set ["_state","idle"];
        _state = "idle";
    };

    private _graphicsAnimations = +(_shared get ("_graphics_"+_state));
    // If there is at least 1 nil, load defaults.
    if (_graphicsAnimations findIf {isNil{_x}} != -1) then {
        private _graphicsIdleAnimations = _shared get "_graphics_idle";
        _graphicsAnimations params [["_menuAnim",_graphicsIdleAnimations#0],["_contextAnim",_graphicsIdleAnimations#1],["_iconAnim",_graphicsIdleAnimations#2],["_backgroundAnim",_graphicsIdleAnimations#3]];
        _graphicsAnimations = [_menuAnim,_contextAnim,_iconAnim,_backgroundAnim];
    };
    (_graphicsAnimations apply {[_shared, _x] call A3A_fnc_holdAction_textureSelector}) params ["_menu","_context","_icon","_background"];
    (_shared get "_target") setUserActionText [_shared get "_actionID", _menu, "<t size='3' shadow='0'>"+_background+"</t>","<t size='3'>"+_icon+"</t><br/><t font='RobotoCondensedBold'>"+_context+"</t>"];
};};

// On click which activates when action called
if (isNil "A3A_fnc_holdAction_onClick") then {A3A_fnc_holdAction_onClick = {
    params ["_target", "_caller", "_actionId", "_shared"];
    // progress can only start from idle, otherwise it's disabled or already running
    if ((_shared get "_state") isNotEqualTo "idle") exitWith {};
    _shared set ["_caller",_caller];
    _shared set ["_state","progress"];
    _shared set ["_refresh",true];
    _this spawn {
        params ["_target","_caller","_actionID","_shared"];
        //disable player's action menu
        {inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "NextAction"];
        _shared call (_shared get "_codeStart");
        while {(_shared get "_state") isEqualTo "progress"} do {
            _shared call (_shared get "_codeProgress");
            _shared call A3A_fnc_holdAction_updateGraphics;
            uiSleep (_shared get "_progressSleep");
            if (_shared get "_autoInterrupt" && {(inputAction "Action" < 0.5 && inputAction "ActionContext" < 0.5)}) exitWith {
                _shared set ["_state","idle"];
                _shared call (_shared get "_codeInterrupted");
            };
            if (_shared get "_completionProgress" >= _shared get "_completionGoal") exitWith {
                _shared call (_shared get "_codeCompleted");    // Will stay on progress state. codeCompleted will decide to reset or dispose.
            };
        };

        //enable player's action menu
        {inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];
    };
};};

// Bootstrapper that is executed on action condition check.
if (isNil "A3A_fnc_holdAction_bootstrapper") then {A3A_fnc_holdAction_bootstrapper = {
    private _shared = _this;

    if (_shared get "_dispose") exitWith {
        (_shared get "_target") removeAction (_shared get "_actionID");
        missionNamespace setVariable [(_shared get "_PID_sharedName"),nil]; // Frees hashmap
        true;   // makes it visible to expose any errors if it is not removed.
    };
    private _state = _shared get "_state";
    if (_state isEqualTo "progress") exitWith {
        if (_shared get "_refresh") then {
            _shared set ["_refresh",false];
            false;
        } else {
            true
        };
    };
    if (serverTime < (_shared get "_idleSleepUntil")) exitWith { _state isNotEqualTo "hidden" };
    _shared set ["_idleSleepUntil",serverTime + (_shared get "_idleSleep")];

    _shared call (_shared get "_codeIdle");
    _shared call A3A_fnc_holdAction_updateGraphics;  // For idle animations. Will not run if state is hidden
    _state isNotEqualTo "hidden";
};};

// Allow animation and processing during idle
private _bootstrapper = _PID_sharedName+' call A3A_fnc_holdAction_bootstrapper;';

// Add the action
private _actionID = _target addAction ["Error, menuText not overridden.", A3A_fnc_holdAction_onClick, _shared, _priority, true, false, _keyShortcut, _bootstrapper, _radius, _showUnconscious, ""];

_shared insert [
    // Read only variables.
    ["_PID",_PID],
    ["_PID_sharedName",_PID_sharedName],
    ["_target",_target],
    ["_caller",objNull],
    ["_actionID",_actionID],
    ["_priority",_priority],
    ["_keyShortcut",_keyShortcut],
    ["_radius",_radius],
    ["_showUnconscious",_showUnconscious],
    ["_modelSelection",_modelSelection],
    ["_modelMemoryPoint",_modelMemoryPoint],

    ["_dispose",false],  // Disposal variable, deletes action.
    ["_refresh",false],  // Hides and shows the action when the user starts. This is needed to prevent the action from fading out while the holdAction is still in progress.
    ["_idleSleepUntil",0] // Do not set, used for determining when to come out of sleep.
];

private _insertIfEmpty = [
    // Visibility and progress settings
    ["_state","idle"],   // hidden, disabled, idle, progress
    ["_autoInterrupt",true],
    ["_completionProgress",0],
    ["_completionGoal",1],

    // Custom set events
    ["_codeIdle",{
        if (_shared get "_completionProgress" > 0) then {
            _shared set ["_completionProgress",((_shared get "_completionProgress") -1/16) max 0];  // Rate will be double due to higher tick rate.
            if (_shared get "_completionProgress" <= 0) then {
                _shared get "_graphics_idle" set [3, [2,A3A_holdAction_texturesOrbitSegments]];
            };
        };
    }],
    ["_codeStart",{ _shared set ["_progressSleep",1/16]; _shared set ["_completionGoal",9.75]; }],
    ["_codeProgress",{ _shared set ["_completionProgress",(_shared get "_completionProgress")+1/16]; }],
    ["_codeCompleted",{ _shared set ["_dispose",true]; }],
    ["_codeInterrupted",{ _shared set ["_idleSleep",1/16]; _shared get "_graphics_idle" set [3, [0,A3A_holdAction_texturesClockwiseCombined]]; }],

    ["_idleSleep",0.01], // little faster than 60Hz.
    ["_progressSleep",0.01], // little faster than 60Hz.

    // Default Text and image animations.
    ["_graphics_idle",[
        "<t align='left'>A3A Hold Action</t>        <t color='#ffae00' align='right'>" + A3A_holdAction_keyName + "     </t>",  // Menu Text
        "<br/>"+(format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Commence The Reckoning"])+"<br/>Must survive for 9¾ seconds.",  // On-screen Context Text
        A3A_holdAction_iconIdle,  // Icon
        [2,A3A_holdAction_texturesOrbitSegments] // Background
    ]],
    ["_graphics_disabled",[
        nil /*Load from idle*/,  // Menu Text
        nil /*Load from idle*/,  // On-screen Context Text
        A3A_holdAction_iconDisabled,  // Icon
        [2,A3A_holdAction_texturesRingBreath]  // Background
    ]],
    ["_graphics_progress",[
        nil /*Load from idle*/,  // Menu Text
        [0,["Started.","Good Progress.","Almost There.","You can Taste It!"]],  // On-screen Context Text
        A3A_holdAction_iconProgress,  // Icon
        [0,A3A_holdAction_texturesClockwiseCombined]  // Background
    ]]
];
{
    if !((_x#0) in _shared) then {
        _shared set _x;
    };
} forEach _insertIfEmpty;
_shared;
