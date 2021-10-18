/*
Author: Håkon
Description:
    compiles all functions in configFile >> A3A >> CfgFunctions
    used for debug as it allows live editing, slower than defining them in configFile >> CfgFunctions

    runs preInit funcs that are compiled aswell and defines A3A_postInitFuncs for postInit funcs to be run

Arguments: <bool> skip running PreInit after compilation (optional - Default: false)

Return Value: <Bool> compiled

Scope: Any
Environment: Any
Public: Yes
Dependencies:

Example: call A3A_fnc_prepFunctions;

License: MIT License
*/
params [["_skipPreInit", false, [true]]];

private _getHeader = {
    switch (_this) do {
        case -1: {""}; //no header
        case 0: {
            format ["private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then { '%1' } else { _fnc_scriptName };
            scriptName '%1';", _funcName];
        }; //default header
        case 1: {
            private _defaultHeader = format [
                "private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'%1'} else {_fnc_scriptName};
                private _fnc_scriptName = '%1';
                scriptName _fnc_scriptName;"
            , _funcName];

            private _debugMode = uinamespace getVariable ["bis_fnc_initFunctions_debugMode",0];
            if (_debugMode > 0) then {_defaultHeader = _defaultHeader + "private _fnc_scriptMap = if (isNil '_fnc_scriptMap') then {[_fnc_scriptName]} else {_fnc_scriptMap + [_fnc_scriptName]};"};
            if (_debugMode > 1) then {_defaultHeader = _defaultHeader + "textLogFormat ['%1 : %2', _fnc_scriptMap joinString ' >> ', _this];"};

            _defaultHeader;
        }; //debug header
        default {""}; //invalid header value,
    };
};

private _preInitFuncs = [];
private A3A_postInitFuncs = [];
{
    //Tag scope
    private _tag = configName _x;
    if (getText (_x/"tag") isNotEqualTo "") then {_tag = getText (_x/"tag")};
    {
        //Category scope
        private _requiredAddons = getArray (_x/"requiredAddons");
        if (_requiredAddons findIf { !(isClass (configFile/"CfgPatches"/_x)) } > -1) then { continue }; //dependecies missing, skip compilation

        private _path = getText (_x/"file");
        if (_path isEqualTo "") then { _path = "functions\" + configName _x }; //default path resolve, not used in antistasi as addons root is game dir unlike missions which is mission dir + functions

        {
            //Function scope
            private _funcName = configName _x;
            private _func = _tag + "_fnc_" + _funcName;

            private _ext = if (getText (_x/"ext") isNotEqualTo "") then {".sqf"} else {getText (_x/"ext")};
            private _file = _path + "\fn_" + _funcName + _ext;
            if (getText (_x/"file") isNotEqualTo "") then { _file = getText (_x/"file") };

            if (getNumber (_x/"preInit") isEqualTo 1) then { _preInitFuncs pushBackUnique _func };
            if (getNumber (_x/"postInit") isEqualTo 1) then { A3A_postInitFuncs pushBackUnique _func };

            //allways recompiles so ignore that attribute
            //preStart dosnt support live edit and would only trigger on game start anyways so no point in support here either

            private _header = (getNumber (_x/"headerType")) call _getHeader;

            missionNamespace setVariable [ _func, compile (_header + preprocessFileLineNumbers _file) ];
        } forEach ("true" configClasses _x);

    } forEach ("true" configClasses _x);

} forEach ("true" configClasses (configFile/"A3A"/"CfgFunctions"));

if (_skipPreInit) exitWith { true };

{
    call (missionNamespace getVariable _x);
} forEach _preInitFuncs;

true
