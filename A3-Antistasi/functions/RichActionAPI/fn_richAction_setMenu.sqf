


/*
Maintainer: Caleb Serafin
    Easy interface to supply rich action menu text.
    Text formatting should handled here to make sure that it is always consistent.
    Each word  should be capitalised.
    Action key as appended to far right of the text.

Arguments:
    <ARRAY> Rich action data
    <STRING> Menu text.

Scope: Any, Global Arguments, Local Effect
Environment: Any
Public: Yes
Dependencies:
    Must run after the action is created!
    <STRING> A3A_richAction_keyName

Example:
    [_RAData, "Rich Action"] call A3A_fnc_richAction_setMenu;
*/
#include "richActionData.hpp"
params [
    ["_RAData",[],[ [] ], [RADataI_count]],
    ["_menuText", "", [ "" ]]
];

private _menuTextWrapped = "<t color='#FFFFFF' align='left'>" + _menuText + "</t>    <t color='#83ffffff' align='right'>" + A3A_richAction_keyName + "     </t>";  // The end spaces prevent the keyName from hanging outside of the box.

private _target = _RAData # RADataI_target;
private _actionID = _RAData # RADataI_actionID;
private _actionParams = _target actionParams _actionID;  // https://community.bistudio.com/wiki/actionParams
private _contextForeground = _actionParams #10;
private _contextBackground = _actionParams #11;

_target setUserActionText [_actionID, _menuTextWrapped, _contextBackground, _contextForeground];
