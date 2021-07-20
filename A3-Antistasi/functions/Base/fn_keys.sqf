_handled = false;
if (player getVariable ["incapacitated",false]) exitWith {_handled};
if (player getVariable ["owner",player] != player) exitWith {_handled};
_key = _this select 1;
if (_key == 21) then {
    // Main dialog / Y-menu
	if (isNil"garageVeh") then {
		closedialog 0; // TODO UI-Update check if this can be removed
		if (!dialog) then {createDialog "A3A_MainDialog";};
	};
} else {
    // Non-ACE earplugs
	if (_key == 207) then {
		if (!A3A_hasACEhearing) then {
			if (soundVolume <= 0.5) then {
				0.5 fadeSound 1;
				["Ear Plugs", "You've taken out your ear plugs.", true] call A3A_fnc_customHint;
			} else {
				0.5 fadeSound 0.1;
				["Ear Plugs", "You've inserted your ear plugs.", true] call A3A_fnc_customHint;
			};
		};
	};
};
_handled
