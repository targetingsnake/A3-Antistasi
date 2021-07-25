//Attempt to figure out our current ace medical target;
if (A3A_hasACE) then {
currentAceTarget = objNull;
	["ace_interactMenuOpened", {
		//player setVariable ["lastMenuOpened", "INTERACT"];
		currentAceTarget = ace_interact_menu_selectedTarget;
	}] call CBA_fnc_addEventHandler;

	["ace_medicalMenuOpened", {
		//player setVariable ["lastMenuOpened", "MEDICAL"];
		currentAceTarget = param [1];
	}] call CBA_fnc_addEventHandler;
};

#define UC_Break_Radius 30
["LogisticLoading", {
    params ["_cargo", "_vehicle", "_instant", "_extraArguments"];
    if (_instant) exitWith {};

    switch (typeOf _cargo) do {
        case NATOAmmoBox;
        case CSATAmmoBox: {
            //report vehicle
            reportedVehs pushBack _vehicle;
            publicVariable "reportedVehs";

            //break undercover for nearby players
            {
                _x setCaptive false;
            } forEach (allPlayers inAreaArray [_vehicle, UC_Break_Radius,UC_Break_Radius,0,false,UC_Break_Radius]);
        };
    };
}] call A3A_fnc_addEventHandler;
