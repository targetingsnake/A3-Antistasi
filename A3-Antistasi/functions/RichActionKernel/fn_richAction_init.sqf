/*
Maintainer: Caleb Serafin
    Creates runtime conversion of key-names to indices (No macro needed.)
    Creates localised text for key instructions.
    Creates the onKeyUp EH for the interrupt.

Return: <NIL> | <BOOLEAN> - First initialisation. | Already initialised.

Scope: Local Effect
Environment: Unscheduled
Public: Yes

Example:
    class richAction_init { preInit = 1 };

    isNil A3A_fnc_richAction_init;
*/
#include "config.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

if !(isNil{A3A_richAction_init_complete}) exitWith { false };
if (canSuspend) exitWith { Error("Init must be synchronous!") };

A3A_richAction_blankHashMap = createHashMap;

A3A_richAction_interruptToken = [false];
[] spawn {
    // Only fires interrupt on keyUp.
    // If the user holds the key down, thinking it's a BIS hold action, it will interrupt as expected.
    waitUntil {uiSleep 0.5; !isNull (findDisplay 46)};
    findDisplay 46 displayAddEventHandler ["KeyUp",{
        //params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
        if (_this #1 == DIK_SPACE) then {
            A3A_richAction_interruptToken set [0,true];
        };
        false;
    }];
};

// Initialise the Rich Action ID counter
A3A_richAction_RAIDCounter = 0;

// Used to blacklist further dumps of the same app.
A3A_richAction_blacklistedAppDumps = [];

// Used for logging running apps
A3A_richAction_appStartTimes = createHashMap;

// Localised Action text
private _keyNameRaw = actionKeysNames ["Action",1,"Keyboard"];
A3A_richAction_keyName = _keyNameRaw select [1,count _keyNameRaw - 2]; // We are trimming the outer quotes.
private _localisedPressTo = "Press %1 to %2";  // localize "STR_A3_HoldKeyTo" = "Hold %1 to %2"
A3A_richAction_pressSpaceTo = format [_localisedPressTo, "<t %1>" + A3A_richAction_keyName + "</t>", "%2"];       // A3A_richAction_pressSpaceTo: "Hold space to %2", %1 is text attributes for key

// Inserted between icon and text, when not in progress
A3A_richAction_standardSpacer = "<t font='RobotoCondensed' size='0.5'> <br/></t>";  // No brake space.


#ifdef __ErrorOnAppTimeout
    [] spawn A3A_fnc_richAction_monitorAppTimeouts;
#endif

A3A_richAction_init_complete = true;
nil;
