


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
private _hashmap0 = createHashMap;
params [
    ["_RAData", _hashmap0, [_hashmap0]],
    ["_menuText", "", [ "" ]]
];
private _menuTextWrapped = "<t color='#FFFFFF' align='left'>" + _menuText + "</t>    <t color='%1' align='right'>" + A3A_richAction_keyName + "     </t>";
// The end spaces prevent the keyName from hanging outside of the box.

_RAData set ["menuText", _menuTextWrapped]
