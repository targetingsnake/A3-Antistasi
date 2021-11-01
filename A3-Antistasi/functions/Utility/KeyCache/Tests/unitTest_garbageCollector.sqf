
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



Dev_timedPromotionTestHandle = [_fnc_reporter,_reporterContext] spawn {
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
    [_reporterContext, "Timed Promotion<br/>Test Started"] call _fnc_reporter;

    private _timeout = serverTime + 0.020;
    private _passedTest = false;

    //// Assert
    waitUntil {
        _passedTest = "Test123" in _gen1TopBucket;
        _passedTest || _timeout <= serverTime
    };
    if (_passedTest) then {
        [_reporterContext, "Timed Promotion<br/>Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Timed Promotion<br/>Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    terminate _GCHandle;
    call compileScript [A3A_keyCache_unitTest_directoryPath+"unitTestUtility_revertInit.sqf"];
};



Dev_basicDeletionTestHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];
    "confirmUnitTest" call A3A_fnc_keyCache_init;

    private _keyCache_DB = createHashMap;
    localNamespace setVariable ["A3A_keyCache_DB", _keyCache_DB];
    _keyCache_DB set ["Test123", [
        "value",
        100,
        0
    ]];

    A3A_keyCache_GC_gen0NewestBucket = [];

    A3A_keyCache_GC_generations = [
        [  // Gen0
            [A3A_keyCache_GC_gen0NewestBucket],
            A3A_keyCache_GC_gen0NewestBucket,
            0.001,
            1,
            0
        ]
    ];
    private _GCHandle = [0] spawn A3A_fnc_keyCache_garbageCollector;
    uiSleep 1;
    "Test123" call A3A_fnc_keyCache_registerForGC;
    [_reporterContext, "Basic Deletion<br/>Test Started"] call _fnc_reporter;

    private _timeout = serverTime + 30;
    private _passedTest = false;

    //// Assert
    waitUntil {
        _passedTest = !("Test123" in _keyCache_DB);
        _passedTest || _timeout <= serverTime
    };
    if (_passedTest) then {
        [_reporterContext, "Basic Deletion<br/>Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Basic Deletion<br/>Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    terminate _GCHandle;
    call compileScript [A3A_keyCache_unitTest_directoryPath+"unitTestUtility_revertInit.sqf"];
};



Dev_shortFpsStressTestHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];

    private _fpsLog = [];
    private _fnc_logFPS = {
        params ["_group","_details"];
        _fpsLog pushBack [serverTime, _group, _details, diag_fps, (count _keyCache_DB) toFixed 0];
        [_reporterContext, "Short FPS Stress Test<br/>" + _group + "<br/>" + _details] call _fnc_reporter
    };

    "confirmUnitTest" call A3A_fnc_keyCache_init;
    A3A_keyCache_GC_generations #0 set [2,10];
    A3A_keyCache_GC_generations #1 set [2,30];
    A3A_keyCache_GC_generations #2 set [2,90];

    private _keyCache_DB = localNamespace getVariable ["A3A_keyCache_DB", nil];
    ["GivingGCsIdleTime", ""] call _fnc_logFPS;

    "confirmUnitTest" call A3A_fnc_keyCache_startGarbageCollectors;
    // Ensure that all GCs are in idle state.
    uiSleep 10;
    ["BaselineTaken", ""] call _fnc_logFPS;


    private _amountOfMillionStressItems = 5;
    private _stressItemTotal = "/"+ (_amountOfMillionStressItems toFixed 1) +" Million";
    private _randomTTLsWeighted = [5,0.75, 15,0.20, 45,0.05];
    for "_j" from 0 to 10*_amountOfMillionStressItems-1 step 1 do {
        for "_k" from 0 to 100000-1 step 10000 do {
            for "_l" from _k to _k + 10000-1 do {
                private _name = (str _j) + (_l toFixed 0);
                private _TTL = selectRandomWeighted _randomTTLsWeighted;
                _keyCache_DB set [_name, [nil,A3A_keyCache_defaultTTL,serverTime + _TTL]];
                _name call A3A_fnc_keyCache_registerForGC;
            };
            //uiSleep 0.01; Processed at max speed anyway.
        };
        ["StressItem", (_j/10 toFixed 1)+_stressItemTotal] call _fnc_logFPS;
    };

    private _timeResolution = 5;
    private _waitTime = 80;
    private _endTime = serverTime + _waitTime;
    waitUntil {
        ["PostStressWatch", ((_endTime - serverTime) toFixed 0) + " sec remaining"] call _fnc_logFPS;
        _endTime <= serverTime || {uiSleep _timeResolution; false};
    };
    //// Assert
    private _passedTest = count _keyCache_DB == 0;
    if (_passedTest) then {
        ["TestPassed","Data copied to clipboard"] call _fnc_logFPS;
    } else {
        ["TestFailed","Data copied to clipboard"] call _fnc_logFPS;
    };
    copyToClipboard str _fpsLog;

    //// Clean Up
    call compileScript [A3A_keyCache_unitTest_directoryPath+"unitTestUtility_revertInit.sqf"];
    call compileScript [A3A_keyCache_unitTest_directoryPath+"unitTestUtility_revertStartGarbageCollectors.sqf"];
};

Dev_longFpsStressTestHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];

    private _fpsLog = [];
    private _fnc_logFPS = {
        params ["_group","_details"];
        _fpsLog pushBack [serverTime, _group, _details, diag_fps, (count _keyCache_DB) toFixed 0];
        [_reporterContext, "Long FPS Stress Test<br/>" + _group + "<br/>" + _details] call _fnc_reporter
    };

    "confirmUnitTest" call A3A_fnc_keyCache_init;
    A3A_keyCache_GC_generations #0 set [2,10];
    A3A_keyCache_GC_generations #1 set [2,30];
    A3A_keyCache_GC_generations #2 set [2,90];

    private _keyCache_DB = localNamespace getVariable ["A3A_keyCache_DB", nil];
    ["GivingGCsIdleTime", ""] call _fnc_logFPS;

    "confirmUnitTest" call A3A_fnc_keyCache_startGarbageCollectors;
    // Ensure that all GCs are in idle state.
    uiSleep 10;
    ["BaselineTaken", ""] call _fnc_logFPS;


    private _amountOfMillionStressItems = 68;
    private _stressItemTotal = "/"+ (_amountOfMillionStressItems toFixed 1) +" Million";
    private _randomTTLsWeighted = [5,0.75, 15,0.20, 45,0.05];
    for "_j" from 0 to 10*_amountOfMillionStressItems -1 step 1 do {
        for "_k" from 0 to 100000-1 step 10000 do {
            for "_l" from _k to _k + 10000-1 do {
                private _name = (str _j) + (_l toFixed 0);
                private _TTL = selectRandomWeighted _randomTTLsWeighted;
                _keyCache_DB set [_name, [nil,A3A_keyCache_defaultTTL,serverTime + _TTL]];
                _name call A3A_fnc_keyCache_registerForGC;
            };
            //uiSleep 0.01; Processed at max speed anyway.
        };
        ["StressItem", (_j/10 toFixed 1)+_stressItemTotal] call _fnc_logFPS;
    };

    private _timeResolution = 5;
    private _waitTime = 180;
    private _endTime = serverTime + _waitTime;
    waitUntil {
        ["PostStressWatch", ((_endTime - serverTime) toFixed 0) + " sec remaining"] call _fnc_logFPS;
        _endTime <= serverTime || {uiSleep _timeResolution; false};
    };
    //// Assert
    private _passedTest = count _keyCache_DB == 0;
    if (_passedTest) then {
        ["TestPassed","Data copied to clipboard"] call _fnc_logFPS;
    } else {
        ["TestFailed","Data copied to clipboard"] call _fnc_logFPS;
    };
    copyToClipboard str _fpsLog;

    //// Clean Up
    call compileScript [A3A_keyCache_unitTest_directoryPath+"unitTestUtility_revertInit.sqf"];
    call compileScript [A3A_keyCache_unitTest_directoryPath+"unitTestUtility_revertStartGarbageCollectors.sqf"];
};
