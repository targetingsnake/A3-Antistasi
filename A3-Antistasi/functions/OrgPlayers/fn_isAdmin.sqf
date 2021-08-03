/*
Maintainer: Caleb Serafin
    Returns whether the specified player is a voted or logged-in admin.
    Only works when local to the player, or from server.

Arguments:
    <OBJECT> Player object.

Return Value:
    <BOOL> If the player is an admin.

Scope: Server & Global Arguments, Local Client & Local Arguments
Environment: Any
Public: Yes

Example:
    player call A3A_fnc_isAdmin;
*/
params [
    ["_player",objNull,[ objNull ]]
];
if (isServer) then {
    admin owner _player > 0;
} else {
    call BIS_fnc_admin > 0;
};
