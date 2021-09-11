/*
Maintainer: Caleb Serafin
    Adds a rich action, interrupted by taping or releasing space.
    Syntax and functionality imitates BIS_fnc_holdActionAdd.
    Likely performance impact due to shim layer. (Unmeasured)

Arguments:
    0: <OBJECT> - object action is attached to
    1: <STRING> - action title text shown in action menu
    2: <STRING> | <CODE> - idle icon shown on screen; if CODE is used the code needs to return the path to icon
    3: <STRING> | <CODE> - progress icon shown on screen; if CODE is used the code needs to return the path to icon
    4: <STRING> - condition for the action to be shown; special variables passed to the script code are _target (unit to which action is attached to) and _this (caller/executing unit)
    5: <STRING> - condition for action to progress; if false is returned action progress is halted; arguments passed into it are: _target, _caller, _id, _arguments
    6: <CODE> - code executed on start; arguments passed into it are [target, caller, ID, arguments]
        0: <OBJECT> - target (_this select 0) - the object which the action is assigned to
        1: <OBJECT> - caller (_this select 1) - the unit that activated the action
        2: <SCALAR> - ID (_this select 2) - ID of the activated action (same as ID returned by addAction)
        3: <ARRAY> - arguments (_this select 3) - arguments given to the script if you are using the extended syntax
    7: <CODE> - code executed on every progress tick; arguments [target, caller, ID, arguments, currentProgress]; max progress is always 24
    8: <CODE> - code executed on completion; arguments [target, caller, ID, arguments]
    9: <CODE> - code executed on interrupted; arguments [target, caller, ID, arguments]
    10: <ARRAY> - arguments passed to the scripts
    11: <SCALAR> - action duration; how much time it takes to complete the action
    12: <SCALAR> - priority; actions are arranged in descending order according to this value
    13: <BOOL> - remove on completion (default: true)
    14: <BOOL> - show in unconscious state (default: false)
    15: <BOOL> - show on screen; if false action needs to be selected from action menu to appear on screen (default: true)

Return Value:
    <SCALAR> - Action ID, can be used for removal or referencing from other functions.

Scope: Clients, Global Arguments, Local Effect
Environment: Any
Public: Yes
Dependencies:
    <STRING> A3A_guerFactionName
    <SCALER> LBX_lvl1Price

Example:
    [_target,_title,_iconIdle,_iconProgress,_condShow,_condProgress,_codeStart,_codeProgress,_codeCompleted,_codeInterrupted,_arguments,_duration,_priority,_removeCompleted,_showUnconscious] call A3A_fnc_createAsBISHA;
*/
params
[
    ["_target",objNull,[objNull]],
    ["_title","MISSING TITLE",[""]],
    ["_iconIdle","\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",["",{}]],
    ["_iconProgress","\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",["",{}]],
    ["_condShow","true",[""]],
    ["_condProgress","true",[""]],
    ["_codeStart",{},[{}]],
    ["_codeProgress",{},[{}]],
    ["_codeCompleted",{},[{}]],
    ["_codeInterrupted",{},[{}]],
    ["_arguments",[],[[]]],
    ["_duration",10,[123]],
    ["_priority",1000,[123]],
    ["_removeCompleted",true,[true]],
    ["_showUnconscious",false,[true]],
    ["_showWindow",true,[true]]
];

#define AppStoreI_shim 0
#define AppStoreI_fakeActionID 1
#define AppStoreI_endTime 2
#define AppStoreI_fnc_iconIdle 3
#define AppStoreI_fnc_iconProgress 4
#define AppStoreI_count 5

#define BISHAShim_a0 0
#define BISHAShim_a1 1
#define BISHAShim_a2 2
#define BISHAShim_a3 3
#define BISHAShim_a4 4
#define BISHAShim_a5 5
#define BISHAShim_a6 6
#define BISHAShim_a7 7
#define BISHAShim_a8 8
#define BISHAShim_a9 9
#define BISHAShim_target 10
#define BISHAShim_title 11
#define BISHAShim_iconIdle 12
#define BISHAShim_iconProgress 13
#define BISHAShim_condShow 14
#define BISHAShim_condProgress 15
#define BISHAShim_codeStart 16
#define BISHAShim_codeProgress 17
#define BISHAShim_codeCompleted 18
#define BISHAShim_codeInterrupted 19
#define BISHAShim_duration 20
#define BISHAShim_removeCompleted 21
#define BISHAShim_count 22

if (isNil {A3A_fnc_setRADataFromShim}) then {A3A_fnc_setRADataFromShim = {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _BISHAShim = _appStore # AppStoreI_shim;

    [_RAData, _BISHAShim # BISHAShim_title] call A3A_fnc_richAction_setMenu;

    private _iconIdle = _BISHAShim # BISHAShim_iconIdle;
    if (_iconIdle isEqualType {}) then {
        _appStore set [AppStoreI_fnc_iconIdle, _iconIdle];
    } else {
        _appStore set [AppStoreI_fnc_iconIdle, {}];
        _RAData get "gfx_idle" set ["icon", _iconIdle];
    };

    private _iconProgress = _BISHAShim # BISHAShim_iconProgress;
    if (_iconProgress isEqualType {}) then {
        _appStore set [AppStoreI_fnc_iconProgress, _iconProgress];
    } else {
        _appStore set [AppStoreI_fnc_iconProgress, {}];
        _RAData get "gfx_progress" set ["icon", _iconProgress];
    };

    _RAData set ["progressSleep", (_BISHAShim # BISHAShim_duration)/24];
    _RAData set ["renderSleep", 0.065 min ((_BISHAShim # BISHAShim_duration)/24)];
};};


// If string, wrap with imagine information.
if (_iconIdle isEqualType "") then {
    _iconIdle = (format["<img size='3.5' color='#ffffff' image='%1'/>",_iconIdle]);
};
if (_iconProgress isEqualType "") then {
    _iconProgress = (format["<img size='3.5' color='#ffffff' image='%1'/>",_iconProgress]);
};

private _BISHAShim_subAppStore = +_arguments;
_BISHAShim_subAppStore resize 10;
private _BISHAShim = _BISHAShim_subAppStore + [_target,_title,_iconIdle,_iconProgress,_condShow,_condProgress,_codeStart,_codeProgress,_codeCompleted,_codeInterrupted,_duration,_removeCompleted];

private _RAData = [] call A3A_fnc_richAction_newRAData;
private _appStore = [_BISHAShim,-1,0,{},{}];
_RAData set ["appStore", _appStore];

_RAData set ["idleSleep", 0.065];
_RAData set ["progressSleep", _duration/24];
_RAData set ["renderSleep", 0.065 min (_duration/24)];

private _fnc_onRender = {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _BISHAShim = _appStore # AppStoreI_shim;

    if !(_appStore # AppStoreI_fakeActionID in actionIDs player) exitWith {
        _RAData get "disposeToken" set [0, true];
    };

    private _state = _RAData get "state";

    private _fnc_icon = _appStore # [AppStoreI_fnc_iconIdle,AppStoreI_fnc_iconProgress] select (_state isEqualTo "progress");
    if (_fnc_icon isEqualType {}) then {
        private _iconTexture = _BISHAShim call _fnc_icon;
        _BISHAShim call A3A_fnc_setRADataFromShim;
        _RAData get "gfx_override" set ["icon",_iconTexture];
    } else {
        _RAData get "gfx_override" set ["icon",""];
    }
};
private _fnc_onIdle = {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _BISHAShim = _appStore # AppStoreI_shim;

    private _show = [_RAData get "target",player] call compile (_BISHAShim # BISHAShim_condShow);
    _RAData set ["state", ["hidden","idle"] select _show];
};
private _fnc_onStart = {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _BISHAShim = _appStore # AppStoreI_shim;

    _BISHAShim call (_BISHAShim # BISHAShim_codeStart);
    _BISHAShim call A3A_fnc_setRADataFromShim;

    _appStore set [AppStoreI_endTime, serverTime + (_BISHAShim # BISHAShim_duration)];
    _RAData set ["completionRatio", 0];
};
private _fnc_onProgress = {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _BISHAShim = _appStore # AppStoreI_shim;

    private _pause = !([_RAData get "target",player,_BISHAShim,_appStore # AppStoreI_fakeActionID] call compile (_BISHAShim # BISHAShim_condProgress));

    if (_pause) then {
        private _duration = _BISHAShim # BISHAShim_duration;
        private _completionRatio = _RAData get "completionRatio";
        private _endTime = serverTime + (1 - _completionRatio) * _duration;
        _appStore set [AppStoreI_endTime, _endTime];
    } else {
        _BISHAShim call (_BISHAShim # BISHAShim_codeProgress);
        _BISHAShim call A3A_fnc_setRADataFromShim;

        private _duration = _BISHAShim # BISHAShim_duration;
        private _endTime = _appStore # AppStoreI_endTime;
        private _completionRatio = 1 - ((_endTime - serverTime) / _duration);
        _RAData set ["completionRatio", _completionRatio];
    };
};
private _fnc_onInterrupt = {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _BISHAShim = _appStore # AppStoreI_shim;

    _BISHAShim call (_BISHAShim # BISHAShim_codeInterrupted);
    _BISHAShim call A3A_fnc_setRADataFromShim;

    _RAData set ["completionRatio", 0];
};
private _fnc_onComplete = {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _BISHAShim = _appStore # AppStoreI_shim;

    _BISHAShim call (_BISHAShim # BISHAShim_codeCompleted);
    _BISHAShim call A3A_fnc_setRADataFromShim;

    _RAData set ["completionRatio", 0];
    if (_BISHAShim # BISHAShim_removeCompleted) then {
        _RAData get "disposeToken" set [0, true];
    };
};
private _fnc_onDispose = {
    _RAData = _this;
    _appStore = _RAData get "appStore";

    (_RAData get "target") removeAction (_appStore # AppStoreI_fakeActionID);
};
_RAData set ["fnc_onRender",_fnc_onRender];
_RAData set ["fnc_onIdle",_fnc_onIdle];
_RAData set ["fnc_onStart",_fnc_onStart];
_RAData set ["fnc_onProgress",_fnc_onProgress];
_RAData set ["fnc_onInterrupt",_fnc_onInterrupt];
_RAData set ["fnc_onComplete",_fnc_onComplete];
_RAData set ["fnc_onDispose",_fnc_onDispose];

isNil A3A_fnc_richAction_initAnim;
private _gfx_idle = [] call A3A_fnc_richAction_newRAGfx;
private _gfx_progress = [] call A3A_fnc_richAction_newRAGfx;
_gfx_idle set ["contextBackground", [4.5,A3A_richAction_texturesRingBreath]];
_gfx_progress set ["contextBackground", [0,A3A_richAction_texturesClockwise]];
_RAData set ["gfx_idle",_gfx_idle];
_RAData set ["gfx_progress",_gfx_progress];

_RAData call A3A_fnc_setRADataFromShim;

// Add a fake action. On removal, the dispose flag will be set will be called.
private _fakeActionID = _target addAction ["Error: should not be visible", {}, _arguments, 0, true, false, "", "false", 15];
_appStore set [AppStoreI_fakeActionID,_fakeActionID];

[_RAData,_target,_priority,nil,nil,_showUnconscious,nil,nil] call A3A_fnc_richAction_add;

_fakeActionID
