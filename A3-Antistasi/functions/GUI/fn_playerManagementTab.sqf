/*
Maintainer: DoomMetal
    Handles updating and controls on the Player Management tab of the Main dialog.

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
    ["update"] call A3A_fnc_playerManagementTab;
*/

#include "..\..\GUI\ids.inc"
#include "..\..\GUI\defines.hpp"
#include "..\..\GUI\textures.inc"
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params[["_mode","onLoad"], ["_params",[]]];

switch (_mode) do
{
  case ("update"):
  {
    Trace("Updating Player Management tab");
    // Show back button
    private _display = findDisplay A3A_IDD_MAINDIALOG;
    private _backButton = _display displayCtrl A3A_IDC_MAINDIALOGBACKBUTTON;
    _backButton ctrlRemoveAllEventHandlers "MouseButtonClick";
    _backButton ctrlAddEventHandler ["MouseButtonClick", {
      ["switchTab", ["admin"]] call A3A_fnc_mainDialog;
    }];
    _backButton ctrlShow true;

    private _listBox = _display displayCtrl A3A_IDC_ADMINPLAYERLIST;
    lbClear _listBox;
    {
      private _name = name _x;
      private _isMember = _x getVariable "isMember";
      private _fakePlayerUID = _x getVariable "fakePlayerUID";
      private _distance = format["%1 m", floor (player distance _x)];

      private _index = _listBox lnbAddRow [_name, _distance, _fakePlayerUID];
      if (_isMember) then {
        _listBox lnbSetColor [[_index,0], [0.2,0.6,0.2,1]];
      } else {
        _listBox lnbSetColor [[_index,0], [0.7,0.7,0.7,1]];
      };
    } forEach fakePlayers;

    _listBox lnbSetCurSelRow 0;
    ["playerLbSelectionChanged"] spawn A3A_fnc_playerManagementTab;
  };

  // Player Management
  case ("playerLbSelectionChanged"):
  {
    // Needs scheduled environment

    private _display = findDisplay A3A_IDD_MAINDIALOG;
    private _listBox = _display displayCtrl A3A_IDC_ADMINPLAYERLIST;
    private _index = lnbCurSelRow _listBox;
    private _addButton = _display displayCtrl A3A_IDC_ADDMEMBERBUTTON;
    private _removeButton = _display displayCtrl A3A_IDC_REMOVEMEMBERBUTTON;
    private _player = fakePlayers select _index;
    if (_player getVariable "isMember") then {
      _addButton ctrlShow false;
      _removeButton ctrlShow true;
    } else {
      _addButton ctrlShow true;
      _removeButton ctrlShow false;
    };
  };

  // Debug cases, to be removed/changed when merging
  case ("adminAddMember"):
  {
    private _display = findDisplay A3A_IDD_MAINDIALOG;
    private _listBox = _display displayCtrl A3A_IDC_ADMINPLAYERLIST;
    private _index = lbCurSel _listBox;
    _listBox lnbSetColor [[_index,0], [0.2,0.6,0.2,1]];
    fakePlayers select _index setVariable ["isMember", true];
    ["playerLbSelectionChanged"] spawn A3A_fnc_playerManagementTab;
  };

  case ("adminRemoveMember"):
  {
    private _display = findDisplay A3A_IDD_MAINDIALOG;
    private _listBox = _display displayCtrl A3A_IDC_ADMINPLAYERLIST;
    private _index = lbCurSel _listBox;
    _listBox lnbSetColor [[_index,0], [0.7,0.7,0.7,1]];
    fakePlayers select _index setVariable ["isMember", false];
    ["playerLbSelectionChanged"] spawn A3A_fnc_playerManagementTab;
  };

  default {
      // Log error if attempting to call a mode that doesn't exist
      Error_1("Player management tab mode does not exist: %1", _mode);
  };
};
