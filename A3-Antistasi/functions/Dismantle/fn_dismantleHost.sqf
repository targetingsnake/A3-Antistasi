params [
    ["_structure",objNull, [objNull]]
];

(A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",1],["_structureCost",0]];
private _watts = 0;
waitUntil {
    _watts = _structure getVariable ["A3A_dismantle_watts",0];
    private _joulesRemaining = ((_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime) * _watts;
    private _exit = if (_watts > 0) then {
        _joulesRemaining <= 0;
    } else {
        _joulesRemaining >= _joules;
    };
    //systemChat ("HOST _watts: "+(_watts toFixed 0)+"_joulesRemaining: "+(_joulesRemaining toFixed 0));
    if (!_exit) then {
        uiSleep 1;
    };
    _exit;
};

if (_watts > 0) then {
    if (_structure in staticsToSave) then {
        staticsToSave deleteAt (staticsToSave find _structure);
        publicVariable "staticsToSave"
    };
    deleteVehicle _structure;
    if (_structureCost > 0) then {
        _structureCost = _structureCost * 0.25;
        [0, _structureCost] call A3A_fnc_resourcesFIA;
    };

    // Dismantle Finished
} else {
    // Dismantle Cancelled

    _structure setVariable ["A3A_dismantle_hasHost",nil];
    _structure setVariable ["A3A_dismantle_watts",nil];
    _structure setVariable ["A3A_dismantle_eta",nil];
};