/*
Maintainer: DoomMetal
    Draws map markers to map controls

Arguments:
    None

Return Value:
    None

Scope: Internal
Environment: Unscheduled
Public: No
Dependencies:
    <ARRAY> markersX // TODO UI-update: Probably needs update on merge

Example:
    _fastTravelMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawOutpostsEH"];
*/

#include "..\..\GUI\textures.inc"

params ["_map"];

// Get marker data
private _outpostIconData = [];
{
  private _marker = _x;
  private _type = _marker call A3A_fnc_getLocationMarkerType;
  private _name = markerText _marker;
  private _pos = getMarkerPos _marker;
  private _color = [0.1,0.7,0.1,1];

  private _icon = switch (_type) do {
    case ("hq"): {
      A3A_missionRootPath + A3A_Icon_Map_HQ;
    };

    case ("city"): {
      A3A_missionRootPath + A3A_Icon_Map_City;
    };

    case ("factory"): {
      A3A_missionRootPath + A3A_Icon_Map_Factory;
    };

    case ("resource"): {
      A3A_missionRootPath + A3A_Icon_Map_Resource;
    };

    case ("seaport"): {
      A3A_missionRootPath + A3A_Icon_Map_Seaport;
    };

    case ("airport"): {
      A3A_missionRootPath + A3A_Icon_Map_Airport;
    };

    case ("outpost"): {
      A3A_missionRootPath + A3A_Icon_Map_Outpost;
    };

    default {
      "\A3\ui_f\data\Map\Markers\Military\flag_CA.paa";
    };
  };

  _outpostIconData pushBack [_name, _pos, _icon, _color];
} forEach markersX;

{
  // Draw icon
  _x params ["_name", "_pos", "_icon", "_color"];
  _map drawIcon [
    _icon, // texture
    _color,
    _pos,
    32, // width
    32, // height
    0, // angle
    "", // text
    0 // shadow (outline if 2)
  ];

  // Draw text
  _map drawIcon [
    "#(rgb,1,1,1)color(0,0,0,0)", // transparent
    _color, // colour
    _pos, // position
    32, // width
    32, // height
    0, // angle
    _name, // text
    2 // shadow (outline if 2)
  ];
} forEach _outpostIconData;
