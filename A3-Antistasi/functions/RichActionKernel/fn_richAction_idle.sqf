/*
Maintainer: Caleb Serafin
    Bootstrapper that is executed on action condition check.
    It allows animations and processing during idle (or hidden, disabled).

Argument:  <ARRAY> Rich Action Data

Return Value: <BOOL> Rich Action visibility.

Scope: Clients, Global Arguments, Local Effect
Environment: Any
Public: No
Dependancies:
    <HASHMAP> A3A_richAction_blankHashMap

Example:
    private _bootstrapper = "(localNamespace getVariable "+_RAID_dataName+") call A3A_fnc_richAction_idle;";
    player addAction ["Jump!", A3A_fnc_richAction_startProgress, _RAData, nil, nil, nil, nil, _bootstrapper];
*/
private _RAData = _this;

if ((_RAData get "disposeToken") #0) exitWith {
    [_RAData,"fnc_onDispose"] call A3A_fnc_richAction_superviseAppEvent;
    (_RAData get "target") removeAction (_RAData get "actionID");
    localNamespace setVariable [_RAData get "RAIDName",nil]; // Frees hashmap. Note that key will persist in `allVariables localNamespace`, likely an Arma bug.
    (_RAData get "disposed") set [0,true];
    true;   // makes it visible to expose any errors if it is not removed.
};

private _state = _RAData get "state";
if (_state isEqualTo "progress") exitWith {
    if (_RAData get "refresh") then {
        _RAData set ["refresh",false];
        false;
    } else {
        true
    };
};

if ((_RAData get "idleSleepUntil") <= serverTime) then {
    _RAData set ["idleSleepUntil", serverTime + (_RAData get "idleSleep")];
    [_RAData,"fnc_onIdle"] call A3A_fnc_richAction_superviseAppEvent;
};
_RAData call A3A_fnc_richAction_render;

private _state = _RAData get "state";  // Fetch state again in case it changed.
_state isNotEqualTo "hidden";  // Final return controls action visibility
