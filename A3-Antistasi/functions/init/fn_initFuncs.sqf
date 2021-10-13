scriptName "initFuncs.sqf";
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
Info("initFuncs started");

[] call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
[] call compile preprocessFileLineNumbers "vcomai\Functions\VCM_Functions\fn_VcomInit.sqf";
boxX call jn_fnc_arsenal_init;

Info("initFuncs completed");
