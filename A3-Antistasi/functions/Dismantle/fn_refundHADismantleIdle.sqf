
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

private _structure = _shared get "_selectedObject";
private _canGiveRefundAuthorisation = player call A3A_fnc_refundCanGiveAuthorisation;
private _hasAuthorisation = _canGiveAuthorisation || localNamespace getVariable ["A3A_hasRefundAuthorisation",false];

// Runs within scope of _codeIdle
private _isEngineer = player getUnitTrait "engineer";
private _engineerBonusText = ["","<t size='0.9' valign='middle'>  *Engineer Bonus</t>"] select _isEngineer;
private _inputWatts = [SOLDIER_WATTS,ENGINEER_WATTS] select _isEngineer;

(A3A_dismantle_structureJouleCostHM get (typeOf _structure)) params [["_joules",420],["_structureCost",0]];
private _activeWatts = _structure getVariable ["A3A_dismantle_watts",0];
private _potentialTimeRemaining = 0;

if (_activeWatts != 0) then {
    private _joulesRemaining = ((_structure getVariable ["A3A_dismantle_eta",serverTime]) - serverTime) * _activeWatts;
    _potentialTimeRemaining = _joulesRemaining / ((_activeWatts max 0) + _inputWatts);

    _shared set ["_completionProgress",_joules - _joulesRemaining];
    _shared set ["_completionGoal",_joules];
    _overlayLayers pushBack "_graphics_showProgress";
    _overlayLayers pushBack (["_graphics_dismantleContinue","_graphics_dismantleAssist"] select (_activeWatts > 0));
    private _actionText = ["Continue Dismantle","Assist Dismantle"] select (_activeWatts > 0);
    _topText = format [A3A_holdAction_holdSpaceTo,"color='#ffae00'",_actionText];
} else {
    _topText = format [A3A_holdAction_holdSpaceTo,"color='#ffae00'","Dismantle"];
    _potentialTimeRemaining = _joules / _inputWatts;
};
_bottomText = "<t color='#00000000'>"+_engineerBonusText+"</t>"+(_potentialTimeRemaining toFixed 0)+"s "+(_structureCost * COST_RETURN_RATIO toFixed 0)+"€<t color='#cccccc'>"+_engineerBonusText+"</t>";

private _boundingSphereDiameter = (2 boundingBox _structure)#2;
private _dismantleRadius = _boundingSphereDiameter/2 * 1.5 + 3;
if (player distance _structure > _dismantleRadius) then {
    _shared set ["_state","disabled"];
    _overlayLayers pushBack "_graphics_tooFar";
    _topText = "Go Closer";
} else {
    _overlayLayers pushBack "_graphics_dismantle";
}
