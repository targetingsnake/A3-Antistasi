/*
Function: A3A_fnc_setupFactionsTab
    Handles the initialization and tab switching on the setup dialog.
    This function should only be called from setupDialog onLoad and control activation EHs.
Author: John Jordan (jaj22)

Environment: Scheduled for onLoad, sendData and serverClose modes. Unscheduled for everything else.

Arguments:
    <STRING> Mode, e.g. "onLoad", "switchTab"
    <ARRAY<ANY>> Array of params for the mode when applicable. Params for specific modes are documented in the modes.


Modes:
    - update does nothing
    - factionSelected called no new item selectionNames
    - fillFactions fills faction tab with the factions
    - getFactions getter for selected items in tab

Return Value:
    on mode getFactions - returns array of selected items in dialog in form [_factions, _addons, _dlc]

*/

#include "..\..\dialogues\ids.inc"
#include "..\..\dialogues\defines.hpp"
#include "..\..\dialogues\textures.inc"
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params ["_mode", "_params"];

Debug_1("setupFactionsTab called with mode %1", _mode);

private _display = findDisplay A3A_IDD_SETUPDIALOG;
private _worldName = toLower worldName;

if (isNil "A3A_setup_loadedPatches") exitWith { Error("No patch data. Load order fuckup?") };

// Input: faction config, output: true/false
private _fnc_factionLoaded = {
    getArray (_this/"requiredAddons") findIf { !(_x in A3A_setup_loadedPatches) } == -1
};
// local version: getArray (_x/"requiredAddons") findIf { !(isClass (configFile/"CfgPatches"/_x)) } != -1;

// Split factions by side and priority-sort
if (isNil {_display getVariable "validFactions"}) then
{
    private _fnc_prioritySort = {
        params ["_factions"];
        private _factionSort = [];
        {
            private _priority = getNumber (_x/"priority") + 0.01*_forEachIndex;
            private _maps = getArray (_x/"maps");
            if (count _maps > 0) then { _priority = _priority + ([-2, 2] select (_worldName in _maps)) };
            if !(_x call _fnc_factionLoaded) then { _priority = _priority - 100 };
            _factionSort pushBack [_priority, _x];
        } forEach _factions;

        _factionSort sort false;
        _factionSort apply { _x#1 };
    };

    // prep the valid factions for current modset
    private _factions = [[], [], [], []];
    private _factTypeHM = createHashMapFromArray [["Occ", 0], ["Inv", 1], ["Reb", 2], ["Civ", 3]];
    {
        if (getText (_x/"side") == "") then { continue };
        private _factIndex = _factTypeHM get getText (_x/"side");
        (_factions select _factIndex) pushBack _x;
    } forEach ("true" configClasses (A3A_SETUP_CONFIGFILE/"A3A"/"Templates"));

    _factions = _factions apply { [_x] call _fnc_prioritySort };
    _display setVariable ["validFactions", _factions];

    // Fill the addon vics
    private _addonTable = _display displayCtrl A3A_IDC_SETUP_ADDONVICSBOX;
    private _checkCtrls = [];
    {
        private _textCtrl = _display ctrlCreate ["A3A_Text_Small", -1, _addonTable];
        _textCtrl ctrlSetPosition [GRID_W*4, count _checkCtrls*GRID_H*4, GRID_W*28, GRID_H*4];
        _textCtrl ctrlCommit 0;
        if !(_x call _fnc_factionLoaded) then { _textCtrl ctrlSetTextColor A3A_COLOR_TEXT_DARKER_SQF };
        _textCtrl ctrlSetText getText (_x/"displayName");
        _textCtrl ctrlSetTooltip getText (_x/"description");

        private _checkCtrl = _display ctrlCreate ["A3A_Checkbox", -1, _addonTable];
        _checkCtrl ctrlSetPosition [0, count _checkCtrls*GRID_H*4, GRID_W*4, GRID_H*4];
        _checkCtrl ctrlCommit 0;
        _checkCtrl ctrlEnable (_x call _fnc_factionLoaded);				// disable if requirement failed
        _checkCtrl setVariable ["name", configName _x];
        _checkCtrls pushBack _checkCtrl;

    } forEach ("true" configClasses (A3A_SETUP_CONFIGFILE/"A3A"/"AddonVics"));
    _addonTable setVariable ["checkCtrls", _checkCtrls];

    // Fill the DLC
    // Fetch these automatically but remove DLC without equipment and vehicles
    //private _loadedDLC = getLoadedModsInfo select {_x#3 and !(_x#1 in ["A3","curator","argo","tacops"])};
    private _dlcTable = _display displayCtrl A3A_IDC_SETUP_DLCBOX;
    _checkCtrls = [];
    {
        private _textCtrl = _display ctrlCreate ["A3A_Text_Small", -1, _dlcTable];
        _textCtrl ctrlSetPosition [GRID_W*4, count _checkCtrls*GRID_H*4, GRID_W*28, GRID_H*4];
        _textCtrl ctrlCommit 0;
        _textCtrl ctrlSetText _x#0;

        private _checkCtrl = _display ctrlCreate ["A3A_Checkbox", -1, _dlcTable];
        _checkCtrl ctrlSetPosition [0, count _checkCtrls*GRID_H*4, GRID_W*4, GRID_H*4];
        _checkCtrl ctrlCommit 0;
        _checkCtrl setVariable ["name", _x#1];
        _checkCtrls pushBack _checkCtrl;

    } forEach A3A_setup_loadedDLC;
    _dlcTable setVariable ["checkCtrls", _checkCtrls];
};

switch (_mode) do
{
    case ("update"): {};			// Don't hide anything here, nothing to do

    case ("factionSelected"):
    {
        _params params ["_listbox", "_rowIndex"];
        if (_rowIndex == -1) exitWith {};
        if (_listbox lbData _rowIndex != "") then {
            _listBox setVariable ["lastSel", _rowIndex];
        } else {
            _listbox lbSetCurSel (_listbox getVariable ["lastSel", 0]);
        };
    };

    case ("fillFactions"):
    {
        _params params ["_isSaveChange"];

        private _fnc_fillListBox = {
            params ["_listboxIDC", "_factions", "_selected"];
            Debug_1("fillListBox called with %1 selected", _selected);
            private _listbox = _display displayCtrl _listboxIDC;
            if (_selected == "") then { _selected = _listBox lbData lbCurSel _listBox };		// remember previous faction selected
            _listBox lbSetCurSel -1;
            lbClear _listBox;
            {
                private _index = _listBox lbAdd getText(_x/"name");
                if (_x call _fnc_factionLoaded) then {
                    _listBox lbSetPicture [_index, getText(_x/"flagTexture")];
                    _listBox lbSetPictureRight [_index, getText(_x/"logo")];
                    _listBox lbSetData [_index, configName _x];
                    if (_selected == configName _x) then { _listBox lbSetCurSel (lbSize _listBox - 1) };
                } else {
                    _listBox lbSetPicture [_index, "a3\data_f\flags\flag_white_dmg_co.paa"];
                    _listBox lbSetPictureColor [_index, [1,1,1,0.3]];
                    _listBox lbSetColor [_index, A3A_COLOR_TEXT_DARKER_SQF];
                    _listBox lbSetSelectColor [_index, A3A_COLOR_TEXT_DARKER_SQF];
                };
            } forEach _factions;
            if (lbCurSel _listBox == -1) then { _listBox lbSetCurSel 0 };				// Should always exist
        };

        // Fetch valid factions and filter based on checkboxes
        private _factions = +(_display getVariable "validFactions");
        if (!cbChecked (_display displayCtrl A3A_IDC_SETUP_IGNORECAMOCHECK)) then {
            _factions = _factions apply { _x select { getArray (_x/"climate") isEqualTo [] or A3A_climate in getArray (_x/"climate") } };
        };
        private _missingFactions = _factions apply { _x select { !(_x call _fnc_factionLoaded) } };
        _factions = _factions apply { _x select { _x call _fnc_factionLoaded } };

        if (cbChecked (_display displayCtrl A3A_IDC_SETUP_SWITCHENEMYCHECK)) then {
            _factions = [_factions#1, _factions#0, _factions#2, _factions#3];
        };
        if (cbChecked (_display displayCtrl A3A_IDC_SETUP_ANYENEMYCHECK)) then {
            _factions = [_factions#0 + _factions#1, _factions#1 + _factions#0, _factions#2, _factions#3];
        };

        // Add saved factions if valid
        // configNames of the occ/inv/reb/civ factions, written by setupLoadgameTab
        (_display getVariable "savedFactions") params ["_savedFactions", "_savedAddons", "_savedDLC"];
        Debug_3("Saved factions: %1 Addons: %2 DLC: %3", _savedFactions, _savedAddons, _savedDLC);

        private _failedFactions = [];
        {
            _sfact = A3A_SETUP_CONFIGFILE/"A3A"/"Templates"/_x;
            if !(isClass _sfact) then { Info_1("Bad saved faction name %1", _x); _failedFactions pushBack _x };
            if !(_sfact call _fnc_factionLoaded) then { Info_1("Saved faction %1 not loadable", _x); _failedFactions pushBack _x };
            _factions#_forEachIndex pushBackUnique _sfact;				// does nothing if already in list
        } forEach _savedFactions;

        if (_failedFactions isNotEqualTo []) then {
            private _msg = "Couldn't load factions from save:";
            { _msg = _msg + endl + _x } forEach _failedFactions;
            ["Setup", _msg] spawn A3A_fnc_customHint;
        };

        // Add the non-loadable factions back in
        if (cbChecked (_display displayCtrl A3A_IDC_SETUP_SHOWMISSINGCHECK)) then {
            { _x append _missingFactions#_forEachIndex } forEach _factions;
        };

        if (_savedFactions isEqualTo []) then { _savedFactions = ["", "", "", ""] };
        [A3A_IDC_SETUP_OCCUPANTSLISTBOX, _factions#0, _savedFactions#0] call _fnc_fillListBox;
        [A3A_IDC_SETUP_INVADERSLISTBOX, _factions#1, _savedFactions#1] call _fnc_fillListBox;
        [A3A_IDC_SETUP_REBELSLISTBOX, _factions#2, _savedFactions#2] call _fnc_fillListBox;
        [A3A_IDC_SETUP_CIVILIANSLISTBOX, _factions#3, _savedFactions#3] call _fnc_fillListBox;

        if !(_isSaveChange) exitWith {};        // Don't reset dlc/addons on checkbox changes

        // Should now set the addonvics & DLC tickboxes according to the save data
        private _addonCtrls = (_display displayCtrl A3A_IDC_SETUP_ADDONVICSBOX) getVariable "checkCtrls";
        private _dlcCtrls = (_display displayCtrl A3A_IDC_SETUP_DLCBOX) getVariable "checkCtrls";
        { _x cbSetChecked false } forEach _addonCtrls + _dlcCtrls;

        {
            private _addon = _x;
            private _index = _addonCtrls findIf { _x getVariable "name" == _addon };
            if (_index == -1) then { Error_1("Addon vics template %1 not found", _x); continue };
            if !(ctrlEnabled (_addonCtrls#_index)) then { Error_1("Addon vics template %1 not loaded", _x); continue };
            (_addonCtrls#_index) cbSetChecked true;
        } forEach _savedAddons;

        {
            private _dlc = _x;
            private _index = _dlcCtrls findIf { _x getVariable "name" == _dlc };
            if (_index == -1) then { Error_1("DLC %1 not loaded", _x); continue };
            (_dlcCtrls#_index) cbSetChecked true;
        } forEach _savedDLC;
    };


    case ("getFactions"):
    {
        private _factions = [A3A_IDC_SETUP_OCCUPANTSLISTBOX, A3A_IDC_SETUP_INVADERSLISTBOX, A3A_IDC_SETUP_REBELSLISTBOX, A3A_IDC_SETUP_CIVILIANSLISTBOX] apply {
            private _factCtrl = _display displayCtrl _x;
            _factCtrl lbData lbCurSel _factCtrl;
        };

        private _addons = [];
        {
            if (cbChecked _x) then { _addons pushBack (_x getVariable "name") };
        } forEach ((_display displayCtrl A3A_IDC_SETUP_ADDONVICSBOX) getVariable "checkCtrls");

        private _dlc = [];
        {
            if (cbChecked _x) then { _dlc pushBack (_x getVariable "name") };
        } forEach ((_display displayCtrl A3A_IDC_SETUP_DLCBOX) getVariable "checkCtrls");

        [_factions, _addons, _dlc];
    };

    default {
        Error_1("Called with unknown mode %1", _mode);
    };
};
