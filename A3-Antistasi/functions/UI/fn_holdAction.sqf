/*
Maintainer: Caleb Serafin
    Add a hold action.
    The first 7 parameters cannot be changed during runtime.

Arguments:

Return Value:
    <HASHMAP> _shared.

Scope: Server/Server&HC/Clients/Any, Local Arguments/Global Arguments, Local Effect/Global Effect
Environment: Scheduled/Unscheduled/Any
Public: Yes/No
Dependencies:
    <CODE >holdActionInit needs to be finished.

Example:
    [player] call A3A_fnc_holdAction; // _shared
*/


#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_target",objNull,[objNull]],
    ["_priority",1000,[123]],
    ["_keyShortcut","",[""]],
    ["_radius",15,[123]],
    ["_showUnconscious",false,[false]],
    ["_modelSelection","",[""]],
    ["_modelMemoryPoint","",[""]],

    ["_shared",false,[false,A3A_const_hashMap]],
    ["_codeIdle",{},[{}]],
    ["_codeStart",{ _shared set ["_progressSleep",0.125]; _shared set ["_completionTotal",55]; },[{}]],
    ["_codeProgress",{ _shared set ["_completionProgress",(_shared get "_completionProgress")+1]; },[{}]],
    ["_codeCompleted",{ _shared call A3A_fnc_holdAction_dispose },[{}]],
    ["_codeInterrupted",{ _shared set ["_completionProgress",0]; },[{}]]
];

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

if (isNil "bis_fnc_holdAction_running") then {bis_fnc_holdAction_running = false;};     // bis hold action is reused to keep sync and compatibility
if (isNil "bis_fnc_holdAction_animationIdleFrame") then {bis_fnc_holdAction_animationIdleFrame = 0;};

// Selects texture from animation loop or global progress
if (isNil "A3A_fnc_holdAction_textureSelector") then {A3A_fnc_holdAction_textureSelector = {
    params ["_shared","_textures"];

    if (_textures isEqualType "") exitWith {_textures;};
    if (count _textures < 2) exitWith { ErrorArray("textureSelector: textures was less than 2 items.", _textures); };
    if !((_textures#0) isEqualType 0) exitWith { ErrorArray("textureSelector: textures' first element is not scalar.",_textures); };

    private _ratio = switch (true) do {
        case (_transitionEnd >= serverTime): {  // Transitions get priority
            private _transitionStart = _shared get "_transitionStart";
            (serverTime - _transitionStart) / ((_shared get "_transitionEnd") - _transitionStart);
        };
        case ((_shared get "_state") isEqualTo "progress" || _shared get "_showProgressInIdle"): {  // Progress
            (_shared get "_completionProgress") / (_shared get "_completionTotal");
        };
        default {   // Loop
            private _duration = _textures#0;
            private _animationStartTime = _shared get "_animationStartTime";
            ((serverTime - _animationStartTime) / _duration) mod 1;
        };
    };
    _ratio = 0 max _ratio min 1;
    private _textureIndex = (ceil ((count _textures -1) * _ratio)) max 1;  // Allows the first frame to be visible
    private _singleTexture = _textures # (_textureIndex); // The duration is first, so it has to be offset.

    if (isNil {_singleTexture}) then {
        _singleTexture = "Texture Selection Error";
        Error_3("textureSelector: Output Texture was null. _textures: %1, _ratio: %2, _textureIndex: %3",_textures,_ratio,_textureIndex);
    };
    _singleTexture;
};};

// Will wait for transition to finish
if (isNil "A3A_fnc_holdAction_dispose") then {A3A_fnc_holdAction_dispose = {
    private _shared = _this;
};};

// Updates the action with appropriate icon and text.
if (isNil "A3A_fnc_holdAction_updateText") then {A3A_fnc_holdAction_updateText = {
    private _shared = _this;
    private _state = _shared get "_state";
    private _prevState = _shared get "_prevState";
    _shared set ["_prevState",_state];

    switch (_state) do {
        case "progress": {if (_prevState isNotEqualTo "progress") then {
            [_shared,_shared get "_transTexture_progress"] call A3A_fnc_holdAction_transition;
        }};
        case "idle": {switch (_shared get "_prevState") do {
            case "hidden": { [_shared,_shared get "_transTexture_shown"] call A3A_fnc_holdAction_transition; };
            case "disabled": { [_shared,_shared get "_transTexture_enabled"] call A3A_fnc_holdAction_transition; };
            case "progress": { [_shared,_shared get "_transTexture_interrupted"] call A3A_fnc_holdAction_transition; }
        }};
        case "hidden": {if (_prevState isNotEqualTo "hidden") then {
            [_shared,_shared get "_transTexture_hidden"] call A3A_fnc_holdAction_transition;
        }};
        case "disabled": {if (_prevState isNotEqualTo "disabled") then {
            [_shared,_shared get "_transTexture_disabled"] call A3A_fnc_holdAction_transition;
        }};
        case "disposing": {if (_prevState isNotEqualTo "disposing") then {
            private _transitionEnd = [_shared,_shared get "_transTexture_disposing"] call A3A_fnc_holdAction_transition;
            [_shared,_transitionEnd] spawn {
                params ["_shared","_transitionEnd"];
                waitUntil {serverTime > _transitionEnd;};   // Needs to wait for transition to finish before deletion.
                _shared set ["_dispose",true];
            }
        }};
    };

    private _transitionEnd = _shared get "_transitionEnd";
    if (_state isEqualTo "hidden" && _transitionEnd < serverTime) exitWith {};
    if !(_state in ["hidden","disabled","idle","progress","disposing"]) exitWith {Error("Invalid state present in updateText: "+ _state)};

    private _texture = if (_transitionEnd >= serverTime) then {
        [_shared,_shared get "_transitionTextures"] call A3A_fnc_holdAction_textureSelector;
    } else {
        [_shared,_shared get ("_texture_"+_state)] call A3A_fnc_holdAction_textureSelector;
    };
    if (isNil {_texture}) then {
        _texture = "texturemissingno";
        Error_2("updateText: Texture was null. In transition: %1, state: %2",(_transitionEnd >= serverTime),_state);
    };
    private _icon = [_shared,_shared getOrDefault ["_icon_"+_state,"iconmissingno<br/>"]] call A3A_fnc_holdAction_textureSelector;
    private _text = [(_shared getOrDefault ["_text_context","<br/>textcontextmissingno"]),""] select (_state isEqualTo "hidden");
    (_shared get "_target") setUserActionText [_shared get "_actionID", _shared getOrDefault ["_text_menu", "textmenumissingno"], "<t size='3' shadow='0'>"+_texture+"</t>","<t size='3'>"+_icon+"</t><br/><t font='RobotoCondensedBold'>"+_text+"</t>"];
};};

// Transitions will overwrite any display state.
if (isNil "A3A_fnc_holdAction_transition") then {A3A_fnc_holdAction_transition = {  // Returns end of transition time.
    params ["_shared","_textures"];
    if (count _textures == 0) exitWith {};  // If it is empty it is not to be played.
    if (count _textures < 2) exitWith { ErrorArray("transition: textures was less than 2 items.", _textures); };
    if !((_textures#0) isEqualType 0) exitWith { ErrorArray("transition: textures' first element is not scalar.",_textures); };
    _shared set ["_transitionTextures",_textures];
    _shared set ["_transitionStart",serverTime];
    _shared set ["_transitionEnd",serverTime + (_textures#0)];
    serverTime + (_textures#0);
};};

// On click which activates when action called
if (isNil "A3A_fnc_holdAction_onClick") then {A3A_fnc_holdAction_onClick = {
    params ["_target", "_caller", "_actionId", "_shared"];
    // progress can only start from idle, otherwise it's disabled or already running
    if ((_shared get "_state") isNotEqualTo "idle") exitWith {};
    _shared set ["_state","progress"];

    _this spawn {
        params ["_target","_caller","_actionID","_shared"];

        //disable player's action menu
        {inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "NextAction"];

        _shared call (_shared get "_codeStart");

        while {(_shared get "_state") isEqualTo "progress" && {_shared get "_completionProgress" >= _shared get "_completionTotal"}} do {
            _shared call (_shared get "_codeProgress");
            _shared call A3A_fnc_holdAction_updateText;
            uiSleep (_shared get "_progressSleep");
            if (_shared get "_autoInterrupt" && {(inputAction "Action" < 0.5 && inputAction "ActionContext" < 0.5)}) exitWith {
                _shared call (_shared get "_codeInterrupted");
                _shared set ["_state","idle"];
            };
            if (_shared get "_completionProgress" >= _shared get "_completionTotal") exitWith {
                _shared call (_shared get "_codeCompleted");    // Will stay on progress.
            };
        };

        //enable player's action menu
        {inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];
    };
};};

// Bootstrapper that is executed on action condition check.
if (isNil "A3A_fnc_holdAction_bootstrapper") then {A3A_fnc_holdAction_bootstrapper = {
    private _shared = _this;
    private _state = _shared get "_state";

    if (_shared get "_dispose") exitWith {
        (_shared get "_target") removeAction (_shared get "_actionID");
        missionNamespace setVariable [(_shared get "_PID_sharedName"),nil]; // Frees hashmap
        true;   // makes it visible to expose any errors if it is not removed.
    };

    _shared call A3A_fnc_holdAction_updateText;
    if (_state isEqualTo "disposing") exitWith {true};   // No user code will executing during dispose animation

    _shared call (_shared get "_codeIdle");
    (_shared get "_state") isNotEqualTo "hidden"; // Sets visibility.
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
    ["_caller",_caller],
    ["_actionID",_actionID],
    ["_priority",_priority],
    ["_keyShortcut",_keyShortcut],
    ["_radius",_radius],
    ["_showUnconscious",_showUnconscious],
    ["_modelSelection",_modelSelection],
    ["_modelMemoryPoint",_modelMemoryPoint],

    // Disposal variable
    ["_dispose",false],
    ["_autoCompletion",true],
    ["_autoInterrupt",true],

    // Custom set events
    ["_codeIdle",_codeIdle],
    ["_codeStart",_codeStart],
    ["_codeProgress",_codeProgress],
    ["_codeCompleted",_codeCompleted],
    ["_codeInterrupted",_codeInterrupted],

    ["_progressSleep",0.01], // little faster than 60Hz. Should be 1 frame.

    // Default Text
    ["_text_menu","<t align='left'>A3A Hold Action</t>        <t color='#ffae00' align='right'>" + A3A_holdAction_keyName + "     </t>"],
    ["_text_context","<br/>"+(format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Commence The Reckoning"])+"<br/>Must survive for 24s"],

    // Default UI textures and icons
    ["_icon_hidden",""], // Shown during transition
    ["_icon_disabled",A3A_holdAction_iconDisabled],
    ["_icon_idle",A3A_holdAction_iconIdle],
    ["_icon_progress",A3A_holdAction_iconProgress],
    ["_icon_disposing",A3A_holdAction_iconDisabled],

    ["_texture_disabled",+A3A_holdAction_texturesRingBreath],
    ["_texture_disabled",+A3A_holdAction_texturesRingBreath],
    ["_texture_idle",+A3A_holdAction_texturesOrbitSegments],
    ["_texture_progress",+A3A_holdAction_texturesClockwiseCombined],
    ["_texture_disposing",""], // Unused, overridden by transition

    ["_transTexture_shown",+A3A_holdAction_texturesBlankToOuterRing],
    ["_transTexture_hidden",+A3A_holdAction_texturesOuterRingToBlank],
    ["_transTexture_enabled",""],
    ["_transTexture_disabled",""],
    ["_transTexture_progress",+A3A_holdAction_texturesOuterRingToBlank],
    ["_transTexture_interrupted",+A3A_holdAction_texturesOuterRingToBlank],
    ["_transTexture_disposing",[2] + (A3A_holdAction_texturesAntiClockwise select [1,99])],

    ["_graphics_idle",[
        // Menu
        // Context
        // Icon
        // Background
    ]]



    // Visibility and progress settings
    ["_showProgressInIdle",false],
    ["_state","idle"],   // hidden, disabled, idle, progress, disposing
    ["_prevState","hidden"],   // Used for to idle transitions only
    ["_completionProgress",0],
    ["_completionTotal",1],
    ["_animationStartTime",0],

    ["_transitionTextures","transitiontexturemissingno"],     // Is set when transition is called
    ["_transitionStart",1],
    ["_transitionEnd",2]

];
_shared;
