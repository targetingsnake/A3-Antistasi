params ["_marker", "_unit", "_unitIndex", ["_stockUp", false]];

/*  Adds the given units to the list of troups that needs to be reinforced
*   For _stockUp == false
*     Params:
*       _marker: STRING : The name of the marker
*       _units: STRING: The name of the unit
*       _unitIndex: NUMBER: A number determining where the unit has to be, format YYX, with YY are the group id and X is the position (0 = vehicle, 1 = crew, 2 = group)
*   For _stockUp == true
*     Params:
*       _marker: STRING : The name of the marker
*       _units: ARRAY: An array containing ["vehicleName", [CrewArray], [GroupArray]]
*       _unitIndex: IGNORED
*
*   Returns:
*     Nothing
*/

if (isNil "_marker") exitWith {diag_log "AddReinforcements: No marker given!"};
if (isNil "_unit") exitWith {diag_log "AddReinforcements: No units given!"};

private ["_unitType", "_groupID", "_reinforcements", "_reinfCount", "_element", "_countGarrison"];

if(!_stockUp) then
{
  //A unit has been KIA
  _unitType = _unitIndex % 10;
  _groupID = floor (_unitIndex / 10);

  //Get needed data
  _reinforcements = [_marker] call A3A_fnc_getNeededReinforcements;
  _reinfCount = count _reinforcements;

  //Check if element is already there
  if((_reinfCount - 1) < _groupID) then
  {
    //Element and maybe further elements not in it, adding them
    for "_i" from (_reinfCount - 1) to _groupID do
    {
      _reinforcements pushBack ["", [], []];
    };
  };

  //Adding unit to element
  _element = _reinforcements select _groupID;
  hint (str _element);
  if(_unitType != 0) then
  {
    //Adding unit
    (_element select _unitType) pushBack _unit;
  }
  else
  {
    //Setting vehicle
    _element set [0, _unit];
  };
  _reinforcements set [_groupID, _element];

  //Setting new reinforcements
  garrison setVariable [format ["%1_requested", _marker], _reinforcements, true];
}
else
{
  //The AI wants to improve the units needed on this marker
  if (!(_unit isEqualType []) || {count _unit != 3}) exitWith
  {
    diag_log format ["AddReinforcements: Given units do not match format, input was %1", str _unit];
  };
  _countGarrison = count ([_marker] call A3A_fnc_getGarrison);
  _reinforcements = [_marker] call A3A_fnc_getNeededReinforcements;
  _reinfCount = count _reinforcements;
  for "_i" from _reinfCount to (_countGarrison - 1) do
  {
    _reinforcements pushBack ["", [], []];
  };
  _reinforcements pushBack _unit;
  garrison setVariable [format ["%1_requested", _marker], _reinforcements, true];

  //Update reinforcement priority
  [_marker] call A3A_fnc_updateReinfState;
};
