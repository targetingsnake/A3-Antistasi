/*
Maintainer: Caleb Serafin
    First sets up localisd text for key instructions.
    Then creates some animation packs that can be used.

Scope: Local Effect
Environment: Any
Public: No

Example:
    class richAction_init { preInit = 1 };
*/
#define __provideRADataKeys
#include "richActionData.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS();

private _DataKeysAndIndices = __RADataKeys;
private _GFXKeysAndIndices = __RAGFXKeys;
{
    _x set [1, _forEachIndex];
} forEach _DataKeysAndIndices;
{
    _x set [1, _forEachIndex];
} forEach _GFXKeysAndIndices;
A3A_richAction_keysToDataI = createHashMapFromArray _DataKeysAndIndices;
A3A_richAction_KeysToGFXI = createHashMapFromArray _GFXKeysAndIndices;

A3A_richAction_interruptToken = [false];
[] spawn {
    // Only fires interrupt on keyUp.
    // If the user holds the key down, thinking it's a BIS hold action, it will interrupt as expected.
    findDisplay 46 displayAddEventHandler ["KeyUp",{
        params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
        if (_key == DIK_SPACE) then {
            A3A_richAction_interruptToken set [0,true];
        };
        false;
    }];
}

// Initialise the PID counter
A3A_richAction_PIDCounter = 0;

// Localised Action text
private _keyNameRaw = actionKeysNames ["Action",1,"Keyboard"];
A3A_richAction_keyName = _keyNameRaw select [1,count _keyNameRaw - 2]; // We are trimming the outer quotes.
private _localisedPressTo = "Press %1 to %2";  // localize "STR_A3_HoldKeyTo" = "Hold %1 to %2"
A3A_richAction_pressSpaceTo = format [_localisedPressTo, "<t %1>" + A3A_richAction_keyName + "</t>", "%2"];       // A3A_richAction_pressSpaceTo: "Hold space to %2", %1 is text attributes for key

// Inserted between icon and text, when not in progress
A3A_richAction_standardSpacer = "<t font='RobotoCondensed' size='0.5'> <br/></t>";  // No brake space.
