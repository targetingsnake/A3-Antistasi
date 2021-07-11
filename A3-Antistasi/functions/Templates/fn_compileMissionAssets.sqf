/*
Author: Håkon
Description:
    Generates a list off all assets used by the factions, replaces old global variables like vehAttack

Arguments:
0. <>

Return Value:
<>

Scope: Server,Server/HC,Clients,Any
Environment: Scheduled/unscheduled/Any
Public: Yes/No
Dependencies:

Example:

License: MIT License
*/
#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
#define OccAndInv(VAR) (FactionGetOrDefault(occ, VAR, []) + FactionGet(inv, VAR, []));

A3A_faction_all = createHashMap;
#define setVar(VAR, VALUE) A3A_faction_all set [VAR, VALUE arrayIntersect VALUE];

private _vehPolice = OccAndInv("vehiclesPolice");
setVar("vehiclesPolice", _vehPolice);

private _vehNormal =
OccAndInv("vehiclesNormal")
+ OccAndInv("vehiclesCargoTrucks")

vehNATONormal + vehCSATNormal + vehNATOCargoTrucks;
_vehNormal append [vehFIACar,vehFIATruck,vehFIAArmedCar,vehPoliceCar,vehNATOBike,vehCSATBike];
_vehNormal append [vehSDKTruck,vehSDKLightArmed,vehSDKAT,vehSDKBike,vehSDKRepair];
setVar("vehiclesNormal", _vehNormal);

private _vehBoats = [vehNATOBoat,vehNATORBoat,vehCSATBoat,vehCSATRBoat,vehSDKBoat];
setVar("vehBoats", _vehBoats);

private _vehAttack = vehNATOAttack + vehCSATAttack;
setVar("vehAttack", _vehAttack);

private _vehPlanes = (vehNATOAir + vehCSATAir + [vehSDKPlane]);
setVar("vehPlanes", _vehPlanes);

private _vehAttackHelis = vehCSATAttackHelis + vehNATOAttackHelis;
setVar("vehAttackHelis", _vehAttackHelis);

private _vehHelis = vehNATOTransportHelis + vehCSATTransportHelis + vehAttackHelis + [vehNATOPatrolHeli,vehCSATPatrolHeli];
setVar("vehHelis", _vehHelis);

private _vehFixedWing = [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA,vehSDKPlane] + vehNATOTransportPlanes + vehCSATTransportPlanes;
setVar("vehFixedWing", _vehFixedWing);

private _vehUAVs = [vehNATOUAV,vehCSATUAV,vehNATOUAVSmall,vehCSATUAVSmall];
setVar("vehUAVs", _vehUAVs);

private _vehAmmoTrucks = [vehNATOAmmoTruck,vehCSATAmmoTruck];
setVar("vehAmmoTrucks", _vehAmmoTrucks);

private _vehAPCs = vehNATOAPC + vehCSATAPC;
setVar("vehAPCs", _vehAPCs);

private _vehTanks = [vehNATOTank,vehCSATTank];
setVar("vehTanks", _vehTanks);

private _vehTrucks = vehNATOTrucks + vehCSATTrucks + [vehSDKTruck,vehFIATruck];
setVar("vehTrucks", _vehTrucks);

private _vehAA = [vehNATOAA,vehCSATAA];
setVar("vehAA", _vehAA);

private _vehMRLS = [vehCSATMRLS, vehNATOMRLS];
setVar("vehMRLS", _vehMRLS);

private _vehArmor = [vehTanks,vehAA,vehMRLS] + vehAPCs;
setVar("vehArmor", _vehArmor);

private _vehTransportAir = vehNATOTransportHelis + vehCSATTransportHelis + vehNATOTransportPlanes + vehCSATTransportPlanes;
setVar("vehTransportAir", _vehTransportAir);

private _vehFastRope = ["O_Heli_Light_02_unarmed_F","B_Heli_Transport_01_camo_F","RHS_UH60M_d","UK3CB_BAF_Merlin_HC3_18_GPMG_DDPM_RM","UK3CB_BAF_Merlin_HC3_18_GPMG_Tropical_RM","RHS_Mi8mt_vdv","RHS_Mi8mt_vv","RHS_Mi8mt_Cargo_vv"];
setVar("vehFastRope", _vehFastRope);

private _vehUnlimited = vehNATONormal + vehCSATNormal + [vehNATORBoat,vehNATOPatrolHeli,vehCSATRBoat,vehCSATPatrolHeli,vehNATOUAV,vehNATOUAVSmall,NATOMG,NATOMortar,vehCSATUAV,vehCSATUAVSmall,CSATMG,CSATMortar];
setVar("vehUnlimited", _vehUnlimited);

private _vehFIA = [vehSDKBike,vehSDKAT,vehSDKLightArmed,SDKMGStatic,vehSDKLightUnarmed,vehSDKTruck,vehSDKBoat,SDKMortar,staticATteamPlayer,staticAAteamPlayer,vehSDKRepair];
setVar("vehFIA", _vehFIA);

private _vehCargoTrucks = (vehTrucks + vehNATOCargoTrucks) select { [_x] call A3A_fnc_logistics_getVehCapacity > 1 };
setVar("vehCargoTrucks", _vehCargoTrucks);
