/*
Maintainer: Caleb Serafin
    Starts a garbage collector for each generation.

Scope: All
Environment: Any
Public: No

Example:
    [] call A3A_fnc_keyCache_startGarbageCollectors;
*/
#include "config.hpp"
#include "..\..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

#ifdef __keyCache_unitTestMode
params [["_confirmUnitTest", "", [""]]];
if (_confirmUnitTest isEqualTo "") exitWith { ServerInfo("Standard Insertion Protocol Aborted due to Unit Test Mode Active."); };
if (_confirmUnitTest isNotEqualTo "confirmUnitTest") exitWith { ServerError_1("Unknown Code: %1", _confirmUnitTest); };
#endif
FIX_LINE_NUMBERS()

if (!isNil "A3A_keyCache_startGarbageCollector") exitWith { ServerError("Invoked Twice"); };
A3A_keyCache_garbageCollection = true;

A3A_keyCache_garbageCollectorHandles = [0,1,2] apply {[_x] spawn A3A_fnc_keyCache_garbageCollector;};
