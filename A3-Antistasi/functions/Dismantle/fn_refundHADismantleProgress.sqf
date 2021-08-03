
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

private _structure = _shared get "_selectedObject";

if (_structure isEqualTo objNull) exitWith {  // Structure was deleted by host before completion on client.
    _shared set ["_completionProgress",_shared get "_structureJoules"];
};

if (player distance _structure > (_shared get "_structureRadius")) exitWith {
    _shared call (_shared get "_codeInterrupted");
    _shared set ["_state","disabled"];
};

/// Progress and Time Calculation ///
private _timeRemaining = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
private _joulesRemaining = _timeRemaining * (_structure getVariable ["A3A_dismantle_watts",0]);
//systemChat ("PROGRESS _timeRemaining: "+(_timeRemaining toFixed 0)+"_joulesRemaining: "+(_joulesRemaining toFixed 0));
_shared set ["_completionProgress",(_shared get "_structureJoules") - _joulesRemaining];

private _graphics_progress = _shared get "_graphics_progress";
// No line-break, positioned right under the icon.
_graphics_progress set [1,"<t font='PuristaMedium' shadow='2' size='2' color='#ffae00' valign='top'><t color='#00000000'>s</t>"+(_timeRemaining toFixed 0)+"<t color='#ffffff'>s</t></t>"];
