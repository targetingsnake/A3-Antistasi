/*
Maintainer: DoomMetal
    Handles controls on the Request Mission dialog.
    // TODO UI-update: This might not need to be this complicated unless we're changing the dialog to be dynamic

Arguments:
    <STRING> Mode
    <ARRAY<ANY>> Array of params for the mode when applicable. Params for specific modes are documented in the modes.

Return Value:
    Nothing

Scope: Clients, Local Arguments, Local Effect
Environment: Scheduled for control changes / Unscheduled for update
Public: No
Dependencies:
    None

Example:
    ["missionButtonClicked"] call A3A_fnc_requestMissionDialog;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params[["_mode",""], ["_params",[]]];

switch (_mode) do
{
  case ("missionButtonClicked"):
  {
    // Params: 1 : Mission type (AS, DES etc...)
    Trace("Request mission button clicked");

    // TODO UI-update: Check for member / commander etc
    // if (([player] call A3A_fnc_isMember) or (not(isPlayer theBoss))) then {};

    if (count _params != 1) exitWith {Error("Invalid parameter count for missionButtonClicked. Got %1, expected 1", count _params)};
    private _missionType = _params select 0;

    // TODO UI-update: Replace with [""MISSIONTYPE"", clientOwner] remoteExec [""A3A_fnc_missionRequest"", 2]
    switch (_missionType) do
    {
      case ("AS"):
      {
        hint "Placeholder: Requesting Assasination mission";
      };

      case ("CONVOY"):
      {
        hint "Placeholder: Requesting Convoy Ambush mission";
      };

      case ("DES"):
      {
        hint "Placeholder: Requesting Destroy mission";
      };

      case ("CON"):
      {
        hint "Placeholder: Requesting Conquest mission";
      };

      case ("LOG"):
      {
        hint "Placeholder: Requesting Logistics mission";
      };

      case ("SUPP"):
      {
        hint "Placeholder: Requesting Support mission";
      };

      case ("RES"):
      {
        hint "Placeholder: Requesting Rescue mission";
      };

      default {
        Error_1("Mission type does not exist: %1", _type);
      };
    };

  };

  default {
      // Log error if attempting to call a mode that doesn't exist
      Error_1("Request Mission dialog mode does not exist: %1", _mode);
  };
};
