/*
Maintainer: Caleb Serafin
    Bootstrapper that is executed on action condition check.
    It allows animations and processing during idle (or hidden, disabled).

Argument:  <ARRAY> Rich Action Data

Return Value: <BOOL> Rich Action visibility.

Scope: Clients, Global Arguments, Local Effect
Environment: Any
Public: No

Example:
    private _bootstrapper = "(localNamespace getVariable "+_RAID_dataName+") call A3A_fnc_richAction_bootstrapper;";
    player addAction ["Jump!", A3A_fnc_richAction_onClick, _RAData, nil, nil, nil, nil, _bootstrapper];
*/
#include "richActionData.hpp"
private _RAData = _this;

if (_RAData # RADataI_dispose) exitWith {
    (_RAData # RADataI_target) removeAction (_RAData # RADataI_actionID);
    localNamespace setVariable [_RAData # RADataI_RAIDName,nil]; // Frees hashmap. Note that key will persist in `allVariables localNamespace`, likely an Arma bug.
    true;   // makes it visible to expose any errors if it is not removed.
};

private _state = _RAData # RADataI_state;
if (_state isEqualTo "progress") exitWith {
    if (_RAData # RADataI_refresh) then {
        _RAData set [RADataI_refresh,false];
        false;
    } else {
        true
    };
};

if ((_RAData # RADataI_idleSleepUntil) <= serverTime) then {
    _RAData set [RADataI_idleSleepUntil, serverTime + (_RAData # RADataI_idleSleep)];
    _RAData call (_RAData # RADataI_fnc_onIdle);
};
_RAData call A3A_fnc_richAction_render;
_state isNotEqualTo "hidden";  // Final return controls ation visibility
