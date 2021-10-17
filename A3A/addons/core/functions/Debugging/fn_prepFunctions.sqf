/*
Author: Håkon
Description:
    compiles all functions in configFile >> A3A >> CfgFunctions
    used for debug as it allows live editing, slower than defining them in configFile >> CfgFunctions

Arguments: Nil

Return Value: <Bool> compiled

Scope: Any
Environment: Any
Public: Yes
Dependencies:

Example: call A3A_fnc_prepFunctions;

License: MIT License
*/
private _funcsToCompile = [];
{
    private _tag = configName _x;
    {
        private _path = getText (_x/"file");
        {
            private _funcName = configName _x;
            //ToDo: add attributes handling to match cfgFunctions
            _funcsToCompile pushBack [_path + "\fn_" + _funcName + ".sqf", _tag + "_fnc_" + _funcName ];
        } forEach ("true" configClasses _x);
    } forEach ("true" configClasses _x);
} forEach ("true" configClasses (configFile/"A3A"/"CfgFunctions"));

{
    _x params ["_path", "_fnc"];
    missionNamespace setVariable [_fnc, compile preprocessFileLineNumbers _path];
} forEach _funcsToCompile;

//run preInit functions here
true
