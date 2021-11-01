
private _reporterContext = [];
private _fnc_reporter = {
    params ["_context","_text"];
    ["UnitTest KeyCache-GC", _text] call A3A_fnc_customHint;
    diag_log text ((systemTimeUTC call A3A_fnc_systemTime_format_S) + " | UnitTest | GarbageCollector | " + _text);
};
A3A_keyCache_unitTest_directoryPath = "functions\Utility\KeyCache\Tests\";


Dev_basicPromotionTestHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];
    "confirmUnitTest" call A3A_fnc_keyCache_init;

    private _keyCache_DB = createHashMap;
    localNamespace setVariable ["A3A_keyCache_DB", _keyCache_DB];
    _keyCache_DB set ["Test123", [
        "value",
        100,
        serverTime + 100
    ]];

    A3A_keyCache_GC_gen0NewestBucket = [];
    private _gen1TopBucket = [];

    //  _x params ["_allBuckets","_newestBucket","_totalPeriod","_bucketsAmount","_promotedGeneration"];  // <ARRAY>, <ARRAY>, <SCALAR>, <SCALAR>, <SCALAR>
    A3A_keyCache_GC_generations = [
        [  // Gen0
            [A3A_keyCache_GC_gen0NewestBucket],
            A3A_keyCache_GC_gen0NewestBucket,
            0.001,
            1,
            1
        ],
        [  // Gen1
            [_gen1TopBucket],
            _gen1TopBucket,
            999,
            1,
            1
        ]
    ];
    private _GCHandle = [0] spawn A3A_fnc_keyCache_garbageCollector;
    uiSleep 1;
    "Test123" call A3A_fnc_keyCache_registerForGC;
    [_reporterContext, "Basic Promotion<br/>Test Started"] call _fnc_reporter;


    private _timeout = serverTime + 30;
    private _passedTest = false;

    //// Assert
    waitUntil {
        _passedTest = "Test123" in _gen1TopBucket;
        _passedTest || _timeout <= serverTime
    };
    if (_passedTest) then {
        [_reporterContext, "Basic Promotion<br/>Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Basic Promotion<br/>Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    terminate _GCHandle;
    call compileScript [A3A_keyCache_unitTest_directoryPath+"unitTestUtility_revertInit.sqf"];
};
