/*  Returns a weighted and balanced vehicle pool for the given side and filter

    Execution on: All

    Scope: External

    Params:
        _side: SIDE : The side for which the vehicle pool should be used
        _filter: ARRAY of STRINGS : The bases classes of units that should be filtered out (for example ["LandVehicle"] or ["Air"])

    Returns:
        _vehiclePool: ARRAY : [vehicleName, weight, vehicleName2, weight2]
*/

params ["_side", ["_filter", []]];
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
private _vehicleSelection = [];

Debug_2("Now searching for attack vehicle pool for %1 with filter %2", _side, _filter);
//In general is Invaders always a bit less chill than the occupants, they will use heavier vehicles more often and earlier
switch (tierWar) do
{
    case (1):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOLightArmed, 15],
                [vehNATOTrucks, 30],
                [vehNATOPatrolHeli, 15],
                [vehNATOAPC, 25],
                [vehNATOTransportHelis, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATTrucks, 35],
                [vehCSATLightArmed, 15],
                [vehCSATPatrolHeli, 15],
                [vehCSATAPC, 25],
                [vehCSATTransportHelis, 15]
            ];
        };
    };
    case (2):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOLightArmed, 40],
                [vehNATOPatrolHeli, 5],
                [vehNATOAPC, 40],
                [vehNATOTransportHelis, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATPatrolHeli, 15],
                [vehCSATAPC, 55],
                [vehCSATTransportHelis, 15],
                [vehCSATAA, 15]
            ];
        };
    };
    case (3):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOPatrolHeli, 15],
                [vehNATOAPC, 55],
                [vehNATOTransportHelis, 15],
                [vehNATOAA, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATPatrolHeli, 5],
                [vehCSATAPC, 64],
                [vehCSATTransportHelis, 15],
                [vehCSATAA, 15],
                [vehCSATAttackHelis, 1]
            ];
        };
    };
    case (4):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOAPC, 64],
                [vehNATOTransportHelis, 20],
                [vehNATOAA, 15],
                [vehNATOAttackHelis, 1]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATAPC, 34],
                [vehCSATTransportHelis, 15],
                [vehCSATAA, 15],
                [vehCSATAttackHelis, 1],
                [vehCSATTank, 25],
                [vehCSATTransportPlanes, 10]
            ];
        };
    };
    case (5):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOAPC, 39],
                [vehNATOTransportHelis, 20],
                [vehNATOAA, 15],
                [vehNATOAttackHelis, 1],
                [vehNATOTank, 25]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATAPC, 34],
                [vehCSATTransportHelis, 10],
                [vehCSATAA, 15],
                [vehCSATAttackHelis, 1],
                [vehCSATTank, 25],
                [vehCSATTransportPlanes, 15]
            ];
        };
    };
    case (6):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOAPC, 39],
                [vehNATOTransportHelis, 10],
                [vehNATOAA, 10],
                [vehNATOAttackHelis, 1],
                [vehNATOTank, 25],
                [vehNATOTransportPlanes, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATAPC, 39],
                [vehCSATTransportHelis, 10],
                [vehCSATAA, 10],
                [vehCSATAttackHelis, 1],
                [vehCSATTank, 25],
                [vehCSATTransportPlanes, 15]
            ];
        };
    };
    case (7):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOAPC, 39],
                [vehNATOTransportHelis, 10],
                [vehNATOAA, 15],
                [vehNATOAttackHelis, 1],
                [vehNATOTank, 20],
                [vehNATOTransportPlanes, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATAPC, 54],
                [vehCSATAA, 10],
                [vehCSATAttackHelis, 1],
                [vehCSATTank, 20],
                [vehCSATTransportPlanes, 15]
            ];
        };
    };
    case (8):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOAPC, 44],
                [vehNATOTransportHelis, 10],
                [vehNATOAA, 5],
                [vehNATOAttackHelis, 1],
                [vehNATOTank, 25],
                [vehNATOTransportPlanes, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATAPC, 44],
                [vehCSATAA, 10],
                [vehCSATAttackHelis, 1],
                [vehCSATTank, 30],
                [vehCSATTransportPlanes, 15]
            ];
        };
    };
    case (9):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOAPC, 44],
                [vehNATOTransportHelis, 10],
                [vehNATOAA, 5],
                [vehNATOAttackHelis, 1],
                [vehNATOTank, 25],
                [vehNATOTransportPlanes, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATAPC, 44],
                [vehCSATAA, 10],
                [vehCSATAttackHelis, 1],
                [vehCSATTank, 30],
                [vehCSATTransportPlanes, 15]
            ];
        };
    };
    case (10):
    {
        if(_side == Occupants) then
        {
            _vehicleSelection =
            [
                [vehNATOAPC, 44],
                [vehNATOTransportHelis, 10],
                [vehNATOAA, 5],
                [vehNATOAttackHelis, 1],
                [vehNATOTank, 25],
                [vehNATOTransportPlanes, 15]
            ];
        };
        if(_side == Invaders) then
        {
            _vehicleSelection =
            [
                [vehCSATAPC, 44],
                [vehCSATAA, 10],
                [vehCSATAttackHelis, 1],
                [vehCSATTank, 30],
                [vehCSATTransportPlanes, 15]
            ];
        };
    };
};

//Use this function to filter out any unwanted elements
_fn_checkElementAgainstFilter =
{
    params ["_element", "_filter"];

    private _passed = true;
    {
        if(_element isKindOf _x) exitWith
        {
            _passed = false;
            Debug_2("%1 didnt passed filter %2", _element, _x);
        };
    } forEach _filter;

    _passed;
};

//Break unit arrays down to single vehicles
private _vehiclePool = [];
{
    if((_x select 0) isEqualType []) then
    {
        private _points = 0;
        private _vehicleCount = count (_x select 0);
        if(_vehicleCount != 0) then
        {
            _points = (_x select 1)/_vehicleCount;
        }
        else
        {
            Error("Found vehicle array with no defined vehicles!");
        };
        {
            if(([_x, _filter] call _fn_checkElementAgainstFilter) && {[_x] call A3A_fnc_vehAvailable}) then
            {
                _vehiclePool pushBack _x;
                _vehiclePool pushBack _points;
            };
        } forEach (_x select 0);
    }
    else
    {
        if(([_x select 0, _filter] call _fn_checkElementAgainstFilter) && {[_x select 0] call A3A_fnc_vehAvailable}) then
        {
            _vehiclePool pushBack (_x select 0);
            _vehiclePool pushBack (_x select 1);
        };
    };
} forEach _vehicleSelection;

Debug_4("For %1 and war level %2 selected units are %3, filter was %4", _side, tierWar, _vehiclePool, _filter);

_vehiclePool;
