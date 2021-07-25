/*
Maintainer: Caleb Serafin
    Calculates the logarithmic mean of the arguments.
    Places a marker on the map where Petros is not standing.
    Finally, concludes whether the player will win the next lottery.

Arguments:
    <SCALAR> Leash radius, cannot be changed.
    <ARRAY<POS>> Position of leash centre. | <ARRAY<OBJECT>> Object to attach leash centre to. Both fields are encapsulated in an array.
    <ARRAY<BOOL>> Set token to true to display, set to false to hide.
    <ARRAY<BOOL>> Set token to false to keep alive, set to true to dispose and destroy (Latency of 0 to 15 seconds).

Return Value:
    <BOOL> If the player will win the next lottery.

Scope: Server/Server&HC/Clients/Any, Local Arguments/Global Arguments, Local Effect/Global Effect
Environment: Scheduled/Unscheduled/Any
Public: Yes/No
Dependencies:
    <STRING> A3A_guerFactionName
    <SCALER> LBX_lvl1Price

Example:
    DEV_dispose = [false];
    DEV_centre = [getMarkerPos respawnTeamPlayer];
    [3000,DEV_centre,[true],DEV_dispose] spawn A3A_fnc_playerLeashBoundary;
    DEV_dispose set [0,true];
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
params [
    ["_leashRadius",100,[ 100 ]],
    ["_ref_leashCentre",[[0,0,0]],[ [] ], [1]],
    ["_ref_visibilityToken",[], [ [] ],[1]],
    ["_ref_disposeToken",[], [ [] ],[1]]
];

// EDIT CONSTANTS HERE //
  // Code assumes the width is the objects X-axis. However, if an object with a different orientation is used:
  //    Modify bound box to take a diagonal slice at given angle (If not 90).
  //    Add the given angle to setDir
private _objectClass = "VR_Billboard_01_F";    // "UserTexture10m_F"
private _objectYaw = 0;
private _objectPitch = 180;
private _objectRoll = 0;
private _heightGoal = 200;  // Also affects object width. Therefore, it will be rounded to accommodate a perfect circumference division.
private _widthGoal = 2000;  // Number of border objects will be rounded up to exceed this width. Not actual width, but is rough arc circumference.
private _barrierBuriedRatio = 0.15;  // How much of the border is in the ground. Hides the base of the VR Billboard, and prevents gaps on hilly terrain.
//      THANK YOU      //

if (!canSuspend) exitWith {
    Error("Called in unscheduled environment. Please use spawn [];");
};
if (_leashRadius <= 0) exitWith {
    Error_1("Leash Radius was not above zero: %1",_leashRadius);
};
if (_ref_visibilityToken isEqualTo []) exitWith {
    Error("Visibility Token was malformed. It should be an array with a single boolean.");
};
if (_ref_disposeToken isEqualTo []) exitWith {
    Error("Dispose Token was malformed. It should be an array with a single boolean.");
};

private _sampleObject = createSimpleObject [_objectClass, [0,0,0], true];;
private _boundBox =  0 boundingBoxReal (_sampleObject);
deleteVehicle _sampleObject;
private _objectWidth = abs ((_boundBox #0#0) - (_boundBox #1#0));
private _objectHeight = abs ((_boundBox #0#2) - (_boundBox #1#2));

private _objectsScaleModifier = _heightGoal / ((1 - _barrierBuriedRatio) * _objectHeight);

// Modify scale goal to ensure that the circumference can be divided into a whole number of parts.
private _azimuthShift = 2 * atan (0.5 * _objectWidth * _objectsScaleModifier / _leashRadius);
private _circleDivisions = round (360 / _azimuthShift);
_azimuthShift =  360 / _circleDivisions;
_objectsScaleModifier = 1 / ((0.5 * _objectWidth) / (_leashRadius * tan (_azimuthShift / 2)));

private _objectWidthFinal = _objectWidth * _objectsScaleModifier;
private _objectHeightFinal = _objectHeight * _objectsScaleModifier;
private _objectsToSpawn = ceil (_widthGoal / _objectWidthFinal) min _circleDivisions;

private _lastLeashCentre = objNull;
private _leashPost = createSimpleObject ["a3\weapons_f\empty.p3d", [0,0,0], true];
_borderObjects = [];
_borderObjects resize _objectsToSpawn;
_borderObjects = _borderObjects apply {
    private _barrier =  createSimpleObject [_objectClass, [0,0,0], true];
    _barrier;
};
DEV_borderObjects = _borderObjects;

private _fnc_sleepMultiTokenInterrupt = {
    params ["_duration","_latency","_ref_tokens"];
    private _originalValues = _ref_tokens apply {+_x};
    private _sleepEndTime = serverTime + _duration;
    while {_sleepEndTime > serverTime} do {
        if (_originalValues isNotEqualTo _ref_tokens) exitWith {};
        uiSleep (_latency min (_sleepEndTime - serverTime));
    };
};

while {!(_ref_disposeToken #0)} do {
    if (_ref_visibilityToken #0) then {
        // Check if objects were already shown.
        if (isObjectHidden (_borderObjects#0)) then {
            { _x hideObject false } forEach _borderObjects;
        };

        // Skip if at same position or object.
        if ((_ref_leashCentre#0) isNotEqualTo _lastLeashCentre) then {
            _lastLeashCentre = _ref_leashCentre#0;
            if (_lastLeashCentre isEqualType objNull) then {
                _leashPost setPos getPos _lastLeashCentre;
                _leashPost attachTo [_lastLeashCentre,[0,0,0]];
            } else {
                detach _leashPost;
                _leashPost setPos _lastLeashCentre;
            };
        };

        private _playerAzimuth = _leashPost getDir player;
        // Round azimuth to circumference division to stop barrier from shifting slightly. Making them appear stationary.
        // Note, this technique causes some jolts when facing directly north.
        _playerAzimuth = _azimuthShift * round (_playerAzimuth / _azimuthShift);
        private _startAzimuth = _playerAzimuth - (0.5 * (_objectsToSpawn - 1) *_azimuthShift);
        {
            private _azimuth = _startAzimuth + (_forEachIndex * _azimuthShift);
            private _barrierPos = _leashPost getPos [_leashRadius,_azimuth];
            _barrierPos = [_barrierPos#0, _barrierPos#1, (0.5-_barrierBuriedRatio) * _objectHeightFinal];  // Sinks it in the ground.
            //systemChat format ["Border Pos magnitude is %1",vectorMagnitude (_leashPost worldToModel _barrierPos)];

            _x attachTo [_leashPost, _leashPost worldToModel _barrierPos];
            private _yaw = _objectYaw + _azimuth;
            private _pitch = _objectPitch + 0;
            private _roll = _objectRoll + 0;
            _x setVectorDirAndUp [
                [sin _yaw * cos _pitch, cos _yaw * cos _pitch, sin _pitch],
                [[sin _roll, -sin _pitch, cos _roll * cos _pitch], -_yaw] call BIS_fnc_rotateVector2D
            ];
                        _x setObjectScale _objectsScaleModifier;    // Must be reset after attachTo & setVectorDirAndUp
        } forEach _borderObjects;
    } else {
        // Check if objects were already hidden.
        if !(isObjectHidden (_borderObjects#0)) then {
            { _x hideObject true } forEach _borderObjects;
        };
    };
    [15,3,[_ref_visibilityToken,_ref_disposeToken]] call _fnc_sleepMultiTokenInterrupt;  // Long update interview is allowed due to long border width and attachTo for mobile leash centres.
};
