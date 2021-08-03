/*
Maintainer: Caleb Serafin
    Returns whether the specified player can give refund authorisation.
    Only works when local to the player, or from server.

Arguments:
    <OBJECT> Player object.

Return Value:
    <BOOL> If the player can deconstruct buildings.

Scope: Server & Global Arguments, Local Client & Local Arguments
Environment: Any
Public: Yes

Example:
    player call A3A_fnc_refundCanGiveAuthorisation;
*/
params [
    ["_player",objNull,[ objNull ]]
];

(player isEqualTo theBoss) || {player call A3A_fnc_isAdmin} || {[player] call A3A_fnc_isMember};
