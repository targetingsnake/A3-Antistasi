// Example of how to avoid macros if debug console execution is required.
// call compileScript ["functions\RichActionAPI\doc_demo_jump.sqf"];

isNil A3A_fnc_richAction_init;

private _RAData = [] call A3A_fnc_richAction_newRAData;
private _appStore = [2,0];
// _appStore params ["_coolDownDuration","_coolDownEndTime"];
_RAData set ["appStore", _appStore];

_RAData set ["fnc_onIdle", {
    _RAData = _this;

    private _state = _RAData get "state";
    if (_state isEqualTo "disabled") then {
        _RAData get "appStore" params ["_coolDownDuration","_coolDownEndTime"];

        private _completionRatio = 1-((_coolDownEndTime - serverTime) / _coolDownDuration);
        _RAData set ["completionRatio", _completionRatio];

        if (_completionRatio >= 1) then {
            _RAData set ["state","idle"];
            _RAData set ["idleSleep", 0.5];
        };
    };
}];

_RAData set ["fnc_onStart", {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _appStore params ["_coolDownDuration","_coolDownEndTime"];;

    _appStore set [1, serverTime + _coolDownDuration];
    _RAData set ["completionRatio", 0];
    _RAData set ["state", "disabled"];
    _RAData set ["idleSleep", 0.01];

    player setVelocityModelSpace (velocityModelSpace player vectorAdd [0,0,5]);
    player say3D ["a3\sounds_f\characters\human-sfx\P05\SoundInjured_Max_3.wss", 25, 1, false];
}];

[_RAData, "idle", "Jump", "Experience of a lifetime."] call A3A_fnc_richAction_setContext;
[_RAData, "disabled", "Recharging"] call A3A_fnc_richAction_setContext;
[_RAData,"Jump"] call A3A_fnc_richAction_setMenu;

_RAData get "gfx_idle" insert [
    ["icon","<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_takeOff2_ca.paa'/>"],
    ["iconBackground",[4.0,A3A_richAction_texturesRingBreath]]
];
_RAData get "gfx_disabled" insert [
    ["icon","<img image='\a3\ui_f_oldman\Data\IGUI\Cfg\HoldActions\refuel_ca.paa'/>"],
    ["iconBackground",[0,A3A_richAction_texturesClockwise]]
];

[_RAData,player,42] call A3A_fnc_richAction_add;
