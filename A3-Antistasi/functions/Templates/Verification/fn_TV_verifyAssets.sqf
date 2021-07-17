#include "..\..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params ["_faction", "_side", "_templatePath"];

//===========|
// Functions |
//===========|
private _printInvalidReasons = {
    //todo: make print function
};
private _validClassCaseSensitive = {
    params ["_cfg", "_class", ["_entry", ""]];
    if !(_class isEqualType "") exitWith {
        _invalidReasons pushBack ("Entry: "+ _entry + " | Invalid data type: "+ str _class + " | Data type: "+ typeName _class + " | Expected: String");
        false;
    };
    if !(isClass (configFile/_cfg/_class) && configName (configFile/_cfg/_class) isEqualTo _class) exitWith {
        _invalidReasons pushBack ( if (isClass (configFile/_cfg/_class)) then {
            "Entry: "+ _entry + " | Bad case on classname: "+_class+", expected: "+ configName (configFile/_cfg/_class)
        } else {
            "Entry: "+ _entry + " | Invalid classname: "+_class+" | Classname should be from config "+_cfg
        });
        false;
    };
    true;
};

//these functions hack the parent scope for the variables; _y, _entry
private _validateArrayOfClasses = {
    if !(_y isEqualType []) exitWith { _invalidReasons pushBack ("Entry "+_entry+" is not an array, This entry should be an array of vehicle class names.") };
    { ["CfgVehicles", _x, _entry] call _validClassCaseSensitive } forEach _y;
};

private _validateSingleClass = {
    if !(_y isEqualType "") exitWith { _invalidReasons pushBack ("Entry "+_entry+" is not a string, This entry should be a vehicle class name.") };
    ["CfgVehicles", _y, _entry] call _validClassCaseSensitive;
};

private _validateString = {
    if !(_y isEqualType "") then { _invalidReasons pushBack ("Entry "+_entry+" is not a string.") };
};

private _validateMagazine = {
    if !(_y isEqualType "") exitWith { _invalidReasons pushBack ("Entry "+_entry+" is not a string, This entry should be a magazine class name.") };
    ["CfgMagazines", _y, _entry] call _validClassCaseSensitive;
};

private _validateArrayMagazines = {
    if !(_y isEqualType []) exitWith { _invalidReasons pushBack ("Entry "+_entry+" is not an array, This entry should be an array of magazine class names.")};
    { ["CfgMagazines", _x, _entry] call _validClassCaseSensitive } forEach _y;
};

private _validateMagazinesHM = {
    //hm of key: Vehicle class, Value: Array of magazine classes
    if !(_y isEqualType createHashmap) exitWith { _invalidReasons pushBack ("Entry "+_entry+" is not a hashmap, This entry should be a hashmap of vehicles and there corresponding magazine classes.") };
    {
        ["CfgVehicles", _x, _entry] call _validClassCaseSensitive;
        call _validateArrayMagazines;
    } forEach _y;
};

private _validateWeaightedArray = {
    if !(_y isEqualType []) exitWith { _invalidReasons pushBack ("Entry "+_entry+" is not an array, This entry should be an weighted array.") };
    for "_i" from 0 to count _y-2 step 2 do {
        if !(
            (_y#_i) isEqualType ""
            && (_y#(_i+1)) isEqualType 0
        ) exitWith { _invalidReasons pushBack ("Entry "+_entry+" is not in propper weighted array format, expected an array in format [<String> Class, <Scalar> Weight, ...]") };
        ["CfgVehicles", _y#_i, _entry] call _validClassCaseSensitive;
    };
};

private _handleUniqueCases = { //handles unique name cases that the stored value is...
    switch _entry do {
        //string
        case "name";
        case "spawnMarkerName";
        case "flag";
        case "flagTexture";
        case "flagMarkerType": _validateString;

        //vehicle class name
        case "ammobox";
        case "surrenderCrate";
        case "equipmentBox": _validateSingleClass;

        //array of vehicle class names
        case "uavsAttack";
        case "uavsPortable": _validateArrayOfClasses;

        //magazine class
        case "mortarMagazineHE";
        case "mortarMagazineSmoke": _validateMagazine;

        //array of magazine class names
        case "minefieldAT";
        case "minefieldAPERS": _validateArrayMagazines;

        //truly unique cases
        case "magazines": _validateMagazinesHM;

        default { Info("Entry: "+_entry+" is lacking validation") };
    };
};

//=======================|
// Process template data |
//=======================|
{
    private _invalidReasons = [];
    _x params ["_entry"];
    switch true do {

        case ("vehicles" in _entry): _validateArrayOfClasses;

        case ("vehicle" in _entry): _validateSingleClass;

        case ("static" in _entry): {
            if (_side in [west, east]) then _validateArrayOfClasses else _validateSingleClass;
        };

        default _handleUniqueCases;

    };
    call _printInvalidReasons;
} forEach _faction;
