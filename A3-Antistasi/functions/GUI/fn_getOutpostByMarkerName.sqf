// Placeholder?, do not merge
// param 0: STR - Marker
// Returns: [Marker name (STR), Garrison (Array <int>)]]

params ["_marker"];

_outpost = [];
{
  if (_x  isEqualTo _marker) then {
    _outpost = _x;
  };
} forEach markersX;
_outpost;
