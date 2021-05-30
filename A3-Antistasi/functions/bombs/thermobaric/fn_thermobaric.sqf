/*
Author: Bob Murphy
    Spawns thermobaric fire and damage at target location.

Arguments:
    <POS3|POS2> AGL centre of effect.
    <STRING> CancellationTokenUUID. Provisioning for implementation of cancellationTokens (Default = "");

Return Value:
    <BOOL> true if normal operation. false if something is invalid.

Scope: Same Server/HC, Global Arguments, Global Effect
Environment: Scheduled
Public: Yes.
*/

private _filename = "functions\bombs\fn_thermobaric.sqf";

params [
    ["_pos",[],[ [] ], [2,3]],
    ["_cancellationTokenUUID","",[ "" ]]
];
if (!isServer) exitWith {false};
if ((count _pos) isEqualTo 2) then {
    _pos pushBack 0;
};

private _startTime = serverTime;
private _endTime = _startTime + 90;
private _thermobaricRadius = 60;

private _thermobaricID = -2;
private _storageNamespace = locationNull;
isNil {
    _thermobaricID = [localNamespace,"A3A_thermobaricRegister","IDCounter",-1] call A3A_fnc_getNestedObject;
    _thermobaricID = _thermobaricID + 1;
    [localNamespace,"A3A_thermobaricRegister","IDCounter",_thermobaricID] call A3A_fnc_setNestedObject;
    _storageNamespace = [localNamespace,"A3A_thermobaricRegister",str _thermobaricID,"active",true] call A3A_fnc_setNestedObject;
};

playSound3D ["a3\sounds_f\weapons\explosion\expl_big_3.wss",_pos, false, AGLToASL _pos, 5, 0.6, 3000];   // Isn't actually audible at 3km, by 500m it's competing with footsteps.
[_pos,_endTime,_cancellationTokenUUID] spawn {
    params ["_pos","_endTime","_canTokUUID"];

    private _fnc_cancelRequested = { false; };// Future provisioning for implementation of cancellationTokens.
    private _audioDuration = 8.3; // audio is 8.538 seconds, subtract possible server->client latency
    private _audioEndTime = _endTime - _audioDuration;

    while {serverTime < _audioEndTime && !([_canTokUUID] call _fnc_cancelRequested)} do {
        playSound3D ["a3\sounds_f\sfx\fire1_loop.wss",_pos, false, AGLToASL _pos, 5, 0.7, 3000];   // Isn't actually audible at 3km, by 500m it's competing with footsteps.
        uiSleep _audioDuration;
    };
};

{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_pos,["tree","bush","small tree"],_thermobaricRadius]);

private _fnc_cancelRequested = { false; };// Future provisioning for implementation of cancellationTokens.
while {_endTime > serverTime && !([_cancellationTokenUUID] call _fnc_cancelRequested)} do {

    // Particles
    private _allRenderers = allPlayers;
    //_allRenderers = _allRenderers select {(_x distance2D _pos) < 1500};  // Turn on if optimisation is required (A good way to show progress to your boss without doing any work!)
    isNil {  // Run in unscheduled scope to prevent parallel filtering.
        _allRenderers = _allRenderers select {
            !isNull _x &&
            {!(getPlayerUID _x isEqualTo "")} &&
            {!(_storageNamespace getVariable [getPlayerUID _x, false])}
        };    // Per thermobaric as every effect needs to be rendered.
        { _storageNamespace setVariable [getPlayerUID _x, true]; } forEach _allRenderers;
    };
    { [_pos, _startTime,_cancellationTokenUUID] remoteExec ["A3A_fnc_thermobaricParticles",_x]; } forEach _allRenderers;


    // Damage
    private _victims = (_pos nearObjects ["All", _thermobaricRadius]);  // The particle system is hardcoded. Radius appears 20-40m depending on wind.
	private _victimsFar = (_pos nearObjects ["All", _thermobaricRadius * 2])
	_victimsFar = _victimsFar - _victims
	private _crew = [];
    { _crew append crew _x; } forEach _victims;
    _victims append _crew;
    isNil {  // Run in unscheduled scope to prevent parallel filtering.
        _victims = _victims select { !isNull _x && {(_x getVariable ["A3A_thermobaric_processing",0]) < serverTime}};    // Global to avoid double damage.
        { _x setVariable ["A3A_thermobaric_processing",serverTime + 30]; } forEach _victims;
    };
    {
        private _owner = owner _x;
        if (_owner isEqualTo 0) then { _owner = 2; };
        [_x, true,_cancellationTokenUUID] remoteExecCall ["A3A_fnc_thermobaricDamage",_owner];
    } forEach _victims;

    uiSleep 5;
};

deleteLocation _storageNamespace;
true;
