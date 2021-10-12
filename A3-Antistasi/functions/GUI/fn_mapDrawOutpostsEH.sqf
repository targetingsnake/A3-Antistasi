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
        <ARRAY> airportsX
        <ARRAY> resourcesX
        <ARRAY> factories
        <ARRAY> outposts
        <ARRAY> seaports
        <ARRAY> citiesX

    Example:
        _fastTravelMap ctrlAddEventHandler ["Draw","_this call A3A_fnc_mapDrawOutpostsEH"];
*/

#include "..\..\GUI\textures.inc"

params ["_map"];

// Calculate zoom level dependent transparency
private _mapScale = ctrlMapScale _map;
private _fadeStart = 0.5; // Zoom level to start fading out
private _fadeEnd = 0.75; // Zoom level where it's completely transparent
private _alpha = ((1 - ((_mapScale - _fadeStart) / (_fadeEnd - _fadeStart))) max 0) min 1;

// Get marker data
private _outpostIconData = [];
{
    private _marker = _x;
    private _type = _marker call A3A_fnc_getLocationMarkerType;
    private _name = [_marker] call A3A_fnc_getLocationMarkerName;
    private _pos = getMarkerPos _marker;
    private _side = sidesX getVariable [_marker,sideUnknown];
    private _color = [1,0.5,1,1];

    switch (_side) do {
        case (teamPlayer): {
            _color = ["Map", "Independent"] call BIS_fnc_displayColorGet;
        };

        case (Occupants): {
            _color = ["Map", "BLUFOR"] call BIS_fnc_displayColorGet;
        };

        case (Invaders): {
            _color = ["Map", "OPFOR"] call BIS_fnc_displayColorGet;
        };

        case (civilian): {
            _color = ["Map", "Civilian"] call BIS_fnc_displayColorGet;
        };

        case (sideUnknown): {
            _color = ["Map", "Unknown"] call BIS_fnc_displayColorGet;
        };
    };

    private _fadedColor = [_color # 0, _color # 1, _color # 2, _alpha];

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

    _outpostIconData pushBack [_name, _pos, _type, _icon, _color, _fadedColor];
} forEach airportsX + resourcesX + factories + outposts + seaports + citiesX + ["Synd_HQ"];
// TODO UI-update: add user placed roadblocks/outposts to the above list

{
    // Draw icon
    _x params ["_name", "_pos", "_type", "_icon", "_color", "_fadedColor"];
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
    if !(_type isEqualTo "city") then {_color = _fadedColor};
    _map drawIcon [
        "#(rgb,1,1,1)color(0,0,0,0)", // the icon itself is transparent
        _color, // colour
        _pos, // position
        32, // width
        32, // height
        0, // angle
        _name, // text
        2 // shadow (outline if 2)
    ];
} forEach _outpostIconData;
