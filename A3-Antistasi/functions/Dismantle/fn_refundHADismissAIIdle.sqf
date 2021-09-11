_actionData set ["_state","disabled"];
private _AISoldier = _actionData get "_selectedObject";

if (player isNotEqualTo leader group player) exitWith {
    _topText = "Not Squad Leader";
    _bottomText = "Must be squad leader to dismiss soldiers.";
    _overlayLayers pushBack "_graphics_notSquadLeader";
};

if (_AISoldier isEqualTo Petros) exitWith {

    private _humanResources = server getVariable "hr";
    private _factionCash = server getVariable "resourcesFIA";
    private _petrosHR = round(_humanResources*0.9);
    private _petrosCost = round(_factionCash*0.9);

    _topText = "Dismiss Comrade Petros?";
    _bottomText = "That's treason!" + " -"+(_petrosHR toFixed 0)+"HR, -"+(_petrosCost toFixed 0)+"€";
    _overlayLayers pushBack "_graphics_petros";
};

if (player isNotEqualTo leader group _AISoldier) exitWith {
    _topText = "Different Squad";
    _bottomText = "Can only dismiss your soldiers";
    _overlayLayers pushBack "_graphics_notSquadLeader";
};

if !([_AISoldier] call A3A_fnc_canFight) exitWith {
    _topText = "Soldier Injured";
    _bottomText = "Cannot dismiss suppressed, undercover, or unconscious soldiers.";
    _overlayLayers pushBack "_graphics_injured";
};

// Apparently server is an object or location? No clue honestly. Extracted from A3-Antistasi/REINF/dismissPlayerGroup.sqf
private _cost = server getVariable (_AISoldier getVariable "unitType");

_actionData set ["_state","idle"];
_topText = format [A3A_richAction_pressSpaceTo,"color='#ffae00'","Dismiss Soldier"];
_bottomText = "+1HR, +"+(_cost toFixed 0)+"€";
_overlayLayers pushBack "_graphics_dismissAI";
