/*
Function:
    DCI_fnc_init
Description:
    initates Discord client
Scope:
    private
Environment:
    client
Returns:
    nothing
Examples:
    [] call DCI_fnc_init;
Author: martin
*/

diag_log "DCPR init started";

_DCI_deactiavted = false;
private _productVersionArray = productVersion;
if (_productVersionArray # 6 != "Windows") then {
    _DCI_deactiavted = true;
    diag_log "DCPR no windows detected";
};
if (isDedicated || !hasInterface) then {
    _DCI_deactiavted = true;
    diag_log "DCPR dedicated or no display detected";
};

if (!_DCI_deactiavted) then {
    private _result = "dcpr" callExtension "init";
    diag_log "DCPR init completed";
};
