// Recommended to init preJIP.
// call A3A_fnc_keyCache_init;
#include "config.hpp"
#include "..\..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

#ifdef __keyCache_unitTestMode
    params [["_confirmUnitTest", "", [""]]];
    if (_confirmUnitTest isEqualTo "") exitWith { ServerInfo("Standard Insertion Protocol Aborted due to Unit Test Mode Active."); };
    if (_confirmUnitTest isNotEqualTo "confirmUnitTest") exitWith { ServerError_1("Unknown Code: %1", _confirmUnitTest); };
#endif
FIX_LINE_NUMBERS()

if (!isNil "A3A_keyCache_init") exitWith { ServerError("Invoked Twice"); };
A3A_keyCache_init = true;


private _keyCache_DB = createHashMap;
localNamespace setVariable ["A3A_keyCache_DB", _keyCache_DB];


A3A_keyCache_defaultTTL = 120;
if (isServer) then {
    // A little longer to ensure that the client's translations go stale before the server.
    A3A_keyCache_defaultTTL = 1.20 * A3A_keyCache_defaultTTL;
};

A3A_keyCache_GC_minSpanSize = 10;  // Minimum items in each chunk.

//  _x params ["_allBuckets","_newestBucket","_totalPeriod","_bucketsAmount","_promotedGeneration"];  // <ARRAY>, <ARRAY>, <SCALAR>, <SCALAR>, <SCALAR>
A3A_keyCache_GC_generations = [
    [  // Gen0
        [],
        [],
        2*A3A_keyCache_defaultTTL,
        3,
        1
    ],
    [  // Gen1
        [],
        [],
        5*A3A_keyCache_defaultTTL,
        3,
        2
    ],
    [  // Gen2
        [],
        [],
        12.5*A3A_keyCache_defaultTTL,
        1,
        2
    ]
];

{
    _x params ["_allBuckets","_newestBucket","_totalPeriod","_bucketsAmount","_promotedGeneration"];

    for "_c" from 1 to _bucketsAmount do {
        _allBuckets pushBack [];
    };
    _x set [1, _allBuckets #(_bucketsAmount -1)];
} forEach A3A_keyCache_GC_generations;

A3A_keyCache_GC_gen0NewestBucket = A3A_keyCache_GC_generations#0#1;
