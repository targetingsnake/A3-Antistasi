/*
Example of direct use of the rich action kernel.
call compileScript ["functions\RichActionAPI\doc_demo_shareNapalm.sqf"];
*/
private _RAData = [] call A3A_fnc_richAction_newRAData;
private _appStore = [30,0];
// _appStore params ["_duration","_endTime"];
_RAData set ["appStore", _appStore];

_RAData set ["idleSleep", 1e7];
_RAData set ["progressSleep", 4];
_RAData set ["renderSleep", 0.06];

_RAData set ["fnc_onRender", {
    _RAData = _this;

    if (_RAData get "state" isEqualTo "progress") then {
        _RAData get "appStore" params ["_duration","_endTime"];
        _RAData set ["completionRatio", 1-((_endTime - serverTime) / _duration)];
    };
}];

_RAData set ["fnc_onStart", {
    _RAData = _this;
    _appStore = _RAData get "appStore";
    _appStore params ["_duration","_endTime"];

    _appStore set [1, serverTime + _duration];
    _RAData set ["completionRatio", 0];
}];
_RAData set ["fnc_onProgress", {
    {
        playSound3D ["a3\sounds_f\characters\human-sfx\P08\SoundInjured_Max_4.wss" ,vehicle _x, false, getPosASL vehicle _x, 1.75, 1, 25];
    } forEach (playableUnits select {_x distance player <= 25});
}];

_RAData set ["fnc_onComplete", {
    playSound3D ["a3\sounds_f\weapons\explosion\expl_big_3.wss",vehicle player, false, getPosASL player, 10, 0.6, 200];
    playSound3D ["a3\sounds_f\sfx\fire1_loop.wss",vehicle player, false, getPosASL player, 10, 0.7, 125];

    private _fnc_shuffle = {
        private _array = +_this;  // NB: needs to be copied as this array is modified.
        private _shuffledArray = [];
        for "_m" from count _array to 1 step -1 do {
            private _i = floor (random _m);
            _shuffledArray pushBack (_array deleteAt _i);
        };
        _shuffledArray;
    };

    private _nearPlayers = playableUnits select {_x distance player <= 25};
    _nearPlayers = _nearPlayers call _fnc_shuffle;
    private _half = floor (count _nearPlayers / 2);

    private _duplicateRAData = +_RAData;
    _duplicateRAData set ["state", "idle"];
    { [_duplicateRAData,_x,42] remoteExec ["A3A_fnc_richAction_add",_x] } forEach (_nearPlayers select [0,_half]);

    { _x setDamage 1; } forEach (_nearPlayers select [_half,_half +1]);

    _RAData get "disposeToken" set [0, true];
}];

_RAData get "gfx_idle" insert [
    ["icon","<img image='\a3\missions_f_oldman\Data\img\HoldActions\holdAction_follow_stop_ca.paa'/>"],
    ["iconBackground",[3.0,A3A_richAction_texturesRingBreath]]
];
_RAData get "gfx_progress" insert [
    ["context",[0,["Step 2: Ask About Weather","Step 3: Give Hug","Step 4: Don't Let Go","Step 5: Become Napalm"]]],
    ["icon","<img image='\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_passLeadership_ca.paa'/>"],
    ["iconBackground",[0,A3A_richAction_texturesClockwise]]
];

[_RAData, "idle", "Share Napalm", "Step 1: Find Players"] call A3A_fnc_richAction_setContext;
[_RAData,"Share Napalm"] call A3A_fnc_richAction_setMenu;

[_RAData,player,42] call A3A_fnc_richAction_add;
