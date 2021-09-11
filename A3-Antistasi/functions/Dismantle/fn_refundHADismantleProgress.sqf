
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

private _structure = _actionData get "_selectedObject";

if (_structure isEqualTo objNull) exitWith {  // Structure was deleted by host before completion on client.
    _actionData set ["_completionProgress",_actionData get "_structureJoules"];
};

if (player distance _structure > (_actionData get "_structureRadius")) exitWith {
    _actionData call (_actionData get "_codeInterrupted");
    _actionData set ["_state","disabled"];
};

/// Progress and Time Calculation ///
private _timeRemaining = (_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime;
private _joulesRemaining = _timeRemaining * (_structure getVariable ["A3A_dismantle_watts",0]);
//systemChat ("PROGRESS _timeRemaining: "+(_timeRemaining toFixed 0)+"_joulesRemaining: "+(_joulesRemaining toFixed 0));
_actionData set ["_completionProgress",(_actionData get "_structureJoules") - _joulesRemaining];

private _graphics_progress = _actionData get "_graphics_progress";
// No line-break, positioned right under the icon.
_graphics_progress set [1,"<t font='PuristaMedium' shadow='2' size='2' color='#ffae00' valign='top'><t color='#00000000'>s</t>"+(_timeRemaining toFixed 0)+"<t color='#ffffff'>s</t></t>"];
