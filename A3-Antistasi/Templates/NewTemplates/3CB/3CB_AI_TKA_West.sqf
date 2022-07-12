//////////////////////////
//   Side Information   //
//////////////////////////

["name", "TKA West"] call _fnc_saveToTemplate;
["spawnMarkerName", "TKA West Support corridor"] call _fnc_saveToTemplate;

["flag", "Flag_TKA_B_Army"] call _fnc_saveToTemplate;
["flagTexture", "UK3CB_Factions\addons\UK3CB_Factions_TKA\Flag\tka_flag_co.paa"] call _fnc_saveToTemplate;
["flagMarkerType", "UK3CB_MARKER_TKA_B_Army"] call _fnc_saveToTemplate;

//////////////////////////
//       Vehicles       //
//////////////////////////

["ammobox", "B_supplyCrate_F"] call _fnc_saveToTemplate;
["surrenderCrate", "Box_IND_Wps_F"] call _fnc_saveToTemplate; //Changeing this from default will require you to define logistics attachement offset for the box type
["equipmentBox", "Box_NATO_Equip_F"] call _fnc_saveToTemplate; //Changeing this from default will require you to define logistics attachement offset for the box type

["vehiclesBasic", ["B_Quadbike_01_F"]] call _fnc_saveToTemplate;
["vehiclesLightUnarmed", ["UK3CB_TKA_B_Hilux_Closed", "UK3CB_TKA_B_Hilux_Open", "UK3CB_TKA_B_M1025", "UK3CB_TKA_B_M998_2DR", "UK3CB_TKA_B_SUV_Armoured"]] call _fnc_saveToTemplate;
["vehiclesLightArmed", ["UK3CB_TKA_B_Hilux_Pkm", "UK3CB_TKA_B_Hilux_Dshkm", "UK3CB_TKA_B_M1025_M2", "UK3CB_TKA_B_M1025_MK19",
"UK3CB_TKA_B_MaxxPro_M2", "UK3CB_TKA_B_MaxxPro_MK19", "UK3CB_TKA_B_Hilux_GMG", "UK3CB_TKA_B_SUV_Armed"]] call _fnc_saveToTemplate;
["vehiclesTrucks", ["UK3CB_TKA_B_Ural_Open", "UK3CB_TKA_B_Ural", "UK3CB_TKA_B_Kamaz_Open", "UK3CB_TKA_B_Kamaz_Closed"]] call _fnc_saveToTemplate;
["vehiclesCargoTrucks", ["UK3CB_TKA_B_Ural_Recovery"]] call _fnc_saveToTemplate;
["vehiclesAmmoTrucks", ["UK3CB_TKA_B_Ural_Ammo", "UK3CB_TKA_B_Kamaz_Ammo"]] call _fnc_saveToTemplate;
["vehiclesRepairTrucks", ["UK3CB_TKA_B_Ural_Repair", "UK3CB_TKA_B_Kamaz_Repair"]] call _fnc_saveToTemplate;
["vehiclesFuelTrucks", ["UK3CB_TKA_B_Kamaz_Fuel", "UK3CB_TKA_B_Ural_Fuel"]] call _fnc_saveToTemplate;
["vehiclesMedical", ["UK3CB_TKA_B_M113_AMB"]] call _fnc_saveToTemplate;
["vehiclesAPCs", ["UK3CB_TKA_B_M113_M240", "UK3CB_TKA_B_M113_M2", "UK3CB_TKA_B_M113_MK19", "UK3CB_TKA_B_M1117"]] call _fnc_saveToTemplate;
["vehiclesTanks", ["UK3CB_TKA_B_T72A", "UK3CB_TKA_B_T72B", "UK3CB_TKA_B_T72BM", "UK3CB_TKA_B_T55"]] call _fnc_saveToTemplate;
["vehiclesAA", ["UK3CB_TKA_B_ZsuTank", "UK3CB_TKA_B_Ural_Zu23"]] call _fnc_saveToTemplate;

["vehiclesTransportBoats", ["UK3CB_TKA_B_RHIB"]] call _fnc_saveToTemplate;
["vehiclesGunBoats", ["UK3CB_TKA_B_RHIB_Gunboat"]] call _fnc_saveToTemplate;
["vehiclesAmphibious", ["UK3CB_TKA_B_M113_M240", "UK3CB_TKA_B_M113_M2", "UK3CB_TKA_B_M113_MK19"]] call _fnc_saveToTemplate;

["vehiclesPlanesCAS", ["UK3CB_TKA_B_Su25SM_CAS", "UK3CB_TKA_B_MIG21_AT"]] call _fnc_saveToTemplate;
["vehiclesPlanesAA", ["UK3CB_TKA_B_L39_PYLON", "UK3CB_TKA_B_MIG21_AA"]] call _fnc_saveToTemplate;
["vehiclesPlanesTransport", ["UK3CB_TKA_B_C130J"]] call _fnc_saveToTemplate;

["vehiclesHelisLight", ["UK3CB_TKA_B_UH1H", "UK3CB_TKA_B_UH1H_M240", "UK3CB_TKA_B_Bell412_Utility"]] call _fnc_saveToTemplate;
["vehiclesHelisTransport", ["UK3CB_TKA_B_UH1H", "UK3CB_TKA_B_UH1H_M240", "UK3CB_TKA_B_Bell412_Utility", "UK3CB_TKA_B_Mi8AMT", "UK3CB_TKA_B_Mi8"]] call _fnc_saveToTemplate;
["vehiclesHelisAttack", ["UK3CB_TKA_B_UH1H_GUNSHIP", "UK3CB_TKA_B_Mi8AMTSh", "UK3CB_TKA_B_Mi_24P", "UK3CB_TKA_B_Mi_24V", "UK3CB_TKA_B_Bell412_Armed", "UK3CB_TKA_B_Bell412_Armed_AT"]] call _fnc_saveToTemplate;

["vehiclesArtillery", [
["UK3CB_TKA_B_BM21", ["rhs_mag_m21of_1"]]
]] call _fnc_saveToTemplate;

["uavsAttack", ["B_UAV_02_dynamicLoadout_F"]] call _fnc_saveToTemplate;
["uavsPortable", ["B_UAV_01_F"]] call _fnc_saveToTemplate;

//Config special vehicles
["vehiclesMilitiaLightArmed", ["UK3CB_TKM_B_Hilux_Dshkm", "UK3CB_TKM_B_Hilux_Pkm", "UK3CB_TKM_B_Datsun_Pkm"]] call _fnc_saveToTemplate;
["vehiclesMilitiaTrucks", ["UK3CB_TKM_B_V3S_Open", "UK3CB_TKM_B_V3S_Closed"]] call _fnc_saveToTemplate;
["vehiclesMilitiaCars", ["UK3CB_TKM_B_LR_Closed", "UK3CB_TKM_B_LR_Open", "UK3CB_TKM_B_Hilux_Open", "UK3CB_TKM_B_Datsun_Open"]] call _fnc_saveToTemplate;

["vehiclesPolice", ["UK3CB_TKP_B_Hilux_Open", "UK3CB_TKP_B_Hilux_Closed", "UK3CB_TKP_B_LandRover_Open", "UK3CB_TKP_B_LandRover_Closed", "UK3CB_TKP_B_Offroad", "UK3CB_TKP_B_Lada_Police"]] call _fnc_saveToTemplate;

["staticMGs", ["RHS_M2StaticMG_WD"]] call _fnc_saveToTemplate;
["staticAT", ["RHS_TOW_TriPod_WD"]] call _fnc_saveToTemplate;
["staticAA", ["RHS_Stinger_AA_pod_WD"]] call _fnc_saveToTemplate;
["staticMortars", ["RHS_M252_WD"]] call _fnc_saveToTemplate;

["mortarMagazineHE", "rhs_12Rnd_m821_HE"] call _fnc_saveToTemplate;
["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] call _fnc_saveToTemplate;

//Minefield definition
["minefieldAT", ["rhsusf_mine_M19"]] call _fnc_saveToTemplate;
["minefieldAPERS", ["rhsusf_mine_m14"]] call _fnc_saveToTemplate;

//////////////////////////
//       Loadouts       //
//////////////////////////

private _loadoutData = call _fnc_createLoadoutData;
_loadoutData setVariable ["slRifles", []];
_loadoutData setVariable ["rifles", []];
_loadoutData setVariable ["carbines", []];
_loadoutData setVariable ["grenadeLaunchers", []];
_loadoutData setVariable ["SMGs", []];
_loadoutData setVariable ["machineGuns", []];
_loadoutData setVariable ["marksmanRifles", []];
_loadoutData setVariable ["sniperRifles", []];

_loadoutData setVariable ["lightATLaunchers", ["rhs_weap_M136","rhs_weap_M136_hedp","rhs_weap_M136_hp"]];
_loadoutData setVariable ["ATLaunchers", [
["rhs_weap_maaws", "", "", "rhs_optic_maaws", ["rhs_mag_maaws_HEAT", "rhs_mag_maaws_HEDP"], [], ""],
["rhs_weap_maaws", "", "", "rhs_optic_maaws", ["rhs_mag_maaws_HEAT", "rhs_mag_maaws_HE"], [], ""],
["rhs_weap_maaws", "", "", "rhs_optic_maaws", ["rhs_mag_maaws_HE", "rhs_mag_maaws_HEDP"], [], ""]
]];
_loadoutData setVariable ["AALaunchers", [
["rhs_weap_fim92", "", "", "", ["rhs_fim92_mag"], [], ""]
]];
_loadoutData setVariable ["sidearms", [
["rhsusf_weap_m1911a1", "", "", "", [], [""], ""],
["rhsusf_weap_m9", "", "", "", [], [], ""]
]];

_loadoutData setVariable ["ATMines", ["rhs_mine_M19_mag"]];
_loadoutData setVariable ["APMines", ["rhsusf_mine_m14_mag"]];
_loadoutData setVariable ["lightExplosives", ["rhsusf_m112_mag", "DemoCharge_Remote_Mag"]];
_loadoutData setVariable ["heavyExplosives", ["rhsusf_m112x4_mag", "SatchelCharge_Remote_Mag"]];

_loadoutData setVariable ["antiInfantryGrenades", ["rhs_mag_m67"]];
_loadoutData setVariable ["antiTankGrenades", []];
_loadoutData setVariable ["smokeGrenades", ["rhs_mag_an_m8hc", "rhs_grenade_anm8_mag"]];
_loadoutData setVariable ["signalsmokeGrenades", ["rhs_mag_m18_green", "rhs_mag_m18_purple", "rhs_mag_m18_red", "rhs_mag_m18_yellow"]];

//Basic equipment. Shouldn't need touching most of the time.
//Mods might override this, or certain mods might want items removed (No GPSs in WW2, for example)
_loadoutData setVariable ["maps", ["ItemMap"]];
_loadoutData setVariable ["watches", ["ItemWatch"]];
_loadoutData setVariable ["compasses", ["ItemCompass"]];
_loadoutData setVariable ["radios", ["ItemRadio"]];
_loadoutData setVariable ["gpses", ["ItemGPS"]];
_loadoutData setVariable ["NVGs", ["rhsusf_ANPVS_14"]];
_loadoutData setVariable ["binoculars", ["Binocular"]];
_loadoutData setVariable ["rangefinders", ["rhsusf_bino_lerca_1200_black"]];

_loadoutData setVariable ["uniforms", []];
_loadoutData setVariable ["vests", []];
_loadoutData setVariable ["slVests", []];
_loadoutData setVariable ["glVests", []];
_loadoutData setVariable ["backpacks", []];
_loadoutData setVariable ["slBackpacks", ["UK3CB_B_I_Alice_Radio_Backpack"]];
_loadoutData setVariable ["engBackpacks", ["UK3CB_TKA_O_B_ENG_Tan"]]; // Both engineer and explosivesExpert
_loadoutData setVariable ["medBackpacks", ["UK3CB_B_Alice_Med_K"]];
_loadoutData setVariable ["atBackpacks", ["B_Carryall_cbr"]];
_loadoutData setVariable ["backpacks", []];
_loadoutData setVariable ["longRangeRadios", []];
_loadoutData setVariable ["helmets", []];
_loadoutData setVariable ["slHat", ["UK3CB_TKA_B_H_Beret"]];
_loadoutData setVariable ["sniHats", ["UK3CB_TKA_B_H_BoonieHat_WDL"]];

//Item *set* definitions. These are added in their entirety to unit loadouts. No randomisation is applied.
_loadoutData setVariable ["items_medical_basic", ["BASIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData setVariable ["items_medical_standard", ["STANDARD"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData setVariable ["items_medical_medic", ["MEDIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData setVariable ["items_miscEssentials", [] call A3A_fnc_itemset_miscEssentials];

//Unit type specific item sets. Add or remove these, depending on the unit types in use.
private _slItems = ["Laserbatteries", "Laserbatteries", "Laserbatteries"];
private _eeItems = ["ToolKit", "MineDetector"];
private _mmItems = [];

if (A3A_hasACE) then {
    _slItems append ["ACE_microDAGR", "ACE_DAGR"];
    _eeItems append ["ACE_Clacker", "ACE_DefusalKit"];
    _mmItems append ["ACE_RangeCard", "ACE_ATragMX", "ACE_Kestrel4500"];
};

_loadoutData setVariable ["items_squadLeader_extras", _slItems];
_loadoutData setVariable ["items_rifleman_extras", []];
_loadoutData setVariable ["items_medic_extras", []];
_loadoutData setVariable ["items_grenadier_extras", []];
_loadoutData setVariable ["items_explosivesExpert_extras", _eeItems];
_loadoutData setVariable ["items_engineer_extras", _eeItems];
_loadoutData setVariable ["items_lat_extras", []];
_loadoutData setVariable ["items_at_extras", []];
_loadoutData setVariable ["items_aa_extras", []];
_loadoutData setVariable ["items_machineGunner_extras", []];
_loadoutData setVariable ["items_marksman_extras", _mmItems];
_loadoutData setVariable ["items_sniper_extras", _mmItems];
_loadoutData setVariable ["items_police_extras", []];
_loadoutData setVariable ["items_crew_extras", []];
_loadoutData setVariable ["items_unarmed_extras", []];

//TODO - ACE overrides for misc essentials, medical and engineer gear

///////////////////////////////////////
//    Special Forces Loadout Data    //
///////////////////////////////////////

private _sfLoadoutData = _loadoutData call _fnc_copyLoadoutData;
_sfLoadoutData setVariable ["uniforms", ["UK3CB_TKA_B_U_CombatUniform_01_DES_MARPAT", "UK3CB_TKA_B_U_CombatUniform_Shortsleeve_01_DES_MARPAT",
"UK3CB_TKA_B_U_CombatUniform_02_DES_MARPAT", "UK3CB_TKA_B_U_CombatUniform_Shortsleeve_02_DES_MARPAT"]];
_sfLoadoutData setVariable ["helmets", ["rhsusf_opscore_ut", "rhsusf_opscore_ut_pelt", "rhsusf_opscore_ut_pelt_cam", "H_Booniehat_tan"]];
_sfLoadoutData setVariable ["sniHats", ["H_Booniehat_khk_hs"]];
_sfLoadoutData setVariable ["vests", ["UK3CB_ANP_B_V_GA_LITE_TAN"]];
_sfLoadoutData setVariable ["slVests", ["UK3CB_ANP_B_V_GA_HEAVY_TAN"]];
_sfLoadoutData setVariable ["glVests", ["UK3CB_ANP_B_V_GA_HEAVY_TAN"]];
_sfLoadoutData setVariable ["backpacks", ["B_AssaultPack_cbr", "B_Kitbag_cbr"]];
_sfLoadoutData setVariable ["slBackpacks", ["UK3CB_B_I_Backpack_Radio_Chem"]];
_sfLoadoutData setVariable ["medBackpacks", ["UK3CB_B_Backpack_Med"]];
_sfLoadoutData setVariable ["NVGs", ["rhsusf_ANPVS_15"]];
_sfLoadoutData setVariable ["binoculars", ["Laserdesignator"]];
//["Weapon", "Muzzle", "Rail", "Sight", [], [], "Bipod"];

_sfLoadoutData setVariable ["slRifles", [
["UK3CB_M16A3", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_ACOG_RMR", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["UK3CB_M16A3", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_su230_mrds", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["rhs_weap_ak74mr", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_ACOG_RMR", ["rhs_30Rnd_545x39_7N22_AK"], [], "rhsusf_acc_rvg_blk"],
["rhs_weap_ak74mr", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_su230_mrds", ["rhs_30Rnd_545x39_7N22_AK"], [], "rhsusf_acc_grip1"],
["rhs_weap_ak74mr_gp25", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_ACOG_RMR", ["rhs_30Rnd_545x39_7N22_AK"], ["rhs_VOG25", "rhs_VOG25", "rhs_VG40TB", "rhs_VG40OP_white"], ""],
["rhs_weap_ak74mr_gp25", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_su230_mrds", ["rhs_30Rnd_545x39_7N22_AK"], ["rhs_VOG25", "rhs_VOG25", "rhs_VG40TB", "rhs_VG40OP_white"], ""],
["rhs_weap_m4a1_blockII_bk", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_ACOG_RMR", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["rhs_weap_m4a1_blockII_bk", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_su230a_mrds_c", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["rhs_weap_m4a1_m203s", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_ACOG_RMR", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""],
["rhs_weap_m4a1_m203s", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_su230a_mrds_c", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""]
]];

_sfLoadoutData setVariable ["rifles", [
["UK3CB_M16A3", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_g33_xps3", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["UK3CB_M16A3", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_compm4", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["rhs_weap_ak74mr", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_g33_xps3", ["rhs_30Rnd_545x39_7N22_AK"], [], "rhsusf_acc_rvg_blk"],
["rhs_weap_ak74mr", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_compm4", ["rhs_30Rnd_545x39_7N22_AK"], [], "rhsusf_acc_grip1"],
["rhs_weap_m4a1_d", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_g33_xps3_tan", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["rhs_weap_m4a1_d", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_compm4", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""]
]];
_sfLoadoutData setVariable ["carbines", [
["rhs_weap_aks74n_2", "rhs_acc_dtk4short", "rhs_acc_perst1ik", "rhs_acc_pkas", ["rhs_30Rnd_545x39_7N22_AK"], [], ""],
["rhs_weap_aks74n_2", "rhs_acc_dtk4short", "rhs_acc_perst1ik", "rhs_acc_1p63", ["rhs_30Rnd_545x39_7N22_AK"], [], ""],
["rhs_weap_m4a1_blockII_bk", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_g33_xps3_tan", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""],
["rhs_weap_m4a1_blockII_bk", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_compm4", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], [], ""]
]];
_sfLoadoutData setVariable ["grenadeLaunchers", [
["rhs_weap_ak74mr_gp25", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_g33_xps3", ["rhs_30Rnd_545x39_7N22_AK"], ["rhs_VOG25", "rhs_VOG25", "rhs_VG40TB", "rhs_VG40OP_white"], ""],
["rhs_weap_ak74mr_gp25", "rhs_acc_dtk4short", "rhs_acc_perst1ik_ris", "rhsusf_acc_compm4", ["rhs_30Rnd_545x39_7N22_AK"], ["rhs_VOG25", "rhs_VOG25", "rhs_VG40TB", "rhs_VG40OP_white"], ""],
["rhs_weap_akmn_gp25_npz", "rhs_acc_pbs1", "", "rhsusf_acc_g33_xps3", ["rhs_30Rnd_762x39mm_89"], ["rhs_VOG25", "rhs_VOG25", "rhs_VG40TB", "rhs_VG40OP_white"], ""],
["rhs_weap_akmn_gp25_npz", "rhs_acc_pbs1", "", "rhsusf_acc_compm4", ["rhs_30Rnd_762x39mm_89"], ["rhs_VOG25", "rhs_VOG25", "rhs_VG40TB", "rhs_VG40OP_white"], ""],
["rhs_weap_m4a1_m203s", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_g33_xps3_tan", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""],
["rhs_weap_m4a1_m203s", "rhsusf_acc_rotex5_grey", "", "rhsusf_acc_compm4", ["rhs_mag_30Rnd_556x45_Mk262_Stanag"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""]
]];
_sfLoadoutData setVariable ["SMGs", [
["UK3CB_MP5SD5", "", "", "rhsusf_acc_compm4", ["UK3CB_MP5_30Rnd_9x19_Magazine"], [], ""],
["UK3CB_MP5SD5", "", "", "rhsusf_acc_eotech_xps3", ["UK3CB_MP5_30Rnd_9x19_Magazine"], [], ""],
["UK3CB_MP5SD5", "", "", "rhsusf_acc_g33_xps3", ["UK3CB_MP5_30Rnd_9x19_Magazine"], [], ""],
["UK3CB_MP5SD5", "", "", "rhsusf_acc_g33_T1", ["UK3CB_MP5_30Rnd_9x19_Magazine"], [], ""]
]];
_sfLoadoutData setVariable ["machineGuns", [
["rhs_weap_m240G", "rhsusf_acc_ARDEC_M240", "", "rhsusf_acc_ELCAN", ["rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""],
["rhs_weap_m240G", "rhsusf_acc_ARDEC_M240", "", "rhsusf_acc_su230", ["rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""],
["rhs_weap_m240G", "rhsusf_acc_ARDEC_M240", "", "rhsusf_acc_g33_xps3", ["rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""],
["rhs_weap_m240G", "rhsusf_acc_ARDEC_M240", "", "rhsusf_acc_ACOG_RMR", ["rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""],
["rhs_weap_m249_light_L", "rhsusf_acc_nt4_black", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_g33_xps3", ["rhsusf_100Rnd_556x45_M995_soft_pouch"], [], "rhsusf_acc_kac_grip_saw_bipod"],
["rhs_weap_m249_light_L", "rhsusf_acc_nt4_black", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_compm4", ["rhsusf_100Rnd_556x45_M995_soft_pouch"], [], "rhsusf_acc_kac_grip_saw_bipod"],
["rhs_weap_m249_light_L", "rhsusf_acc_nt4_black", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_su230", ["rhsusf_100Rnd_556x45_M995_soft_pouch"], [], "rhsusf_acc_kac_grip_saw_bipod"],
["rhs_weap_m249_light_L", "rhsusf_acc_nt4_black", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_su230_mrds", ["rhsusf_100Rnd_556x45_M995_soft_pouch"], [], "rhsusf_acc_kac_grip_saw_bipod"],
["rhs_weap_m249_light_L", "rhsusf_acc_nt4_black", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_ACOG_RMR", ["rhsusf_100Rnd_556x45_M995_soft_pouch"], [], "rhsusf_acc_kac_grip_saw_bipod"]
]];
_sfLoadoutData setVariable ["marksmanRifles", [
["rhs_weap_m14ebrri", "rhsusf_acc_aac_762sdn6_silencer", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_M8541", ["rhsusf_20Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_bipod"],
["rhs_weap_m14ebrri", "rhsusf_acc_aac_762sdn6_silencer", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_LEUPOLDMK4", ["rhsusf_20Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_bipod"],
["rhs_weap_m14ebrri", "rhsusf_acc_aac_762sdn6_silencer", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_premier_mrds", ["rhsusf_20Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_bipod"]
]];
_sfLoadoutData setVariable ["sniperRifles", [
["rhs_weap_m40a5", "", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_M8541", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"],
["rhs_weap_m40a5", "", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_premier", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"],
["rhs_weap_m40a5", "", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_LEUPOLDMK4", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"],
["rhs_weap_m24sws", "rhsusf_acc_m24_silencer_black", "", "rhsusf_acc_M8541", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"],
["rhs_weap_m24sws", "rhsusf_acc_m24_silencer_black", "", "rhsusf_acc_premier", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"],
["rhs_weap_m24sws", "rhsusf_acc_m24_silencer_black", "", "rhsusf_acc_LEUPOLDMK4", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"]
]];
_sfLoadoutData setVariable ["sidearms", [
["UK3CB_CZ75", "rhsusf_acc_omega9k", "", "", ["UK3CB_CZ75_9_20Rnd"], [], ""],
["UK3CB_BHP", "rhsusf_acc_omega9k", "", "", ["UK3CB_BHP_9_13Rnd"], [], ""]
]];

/////////////////////////////////
//    Military Loadout Data    //
/////////////////////////////////

private _militaryLoadoutData = _loadoutData call _fnc_copyLoadoutData;
_militaryLoadoutData setVariable  ["uniforms", [
"UK3CB_TKA_B_U_CombatUniform_02_WDL", "UK3CB_TKA_B_U_CombatUniform_Shortsleeve_02_WDL",
"UK3CB_TKA_B_U_CombatUniform_Shortsleeve_01_WDL", "UK3CB_TKA_B_U_CombatUniform_01_WDL"
]];
_militaryLoadoutData setVariable ["helmets", ["UK3CB_TKA_B_H_WDL"]];
_militaryLoadoutData setVariable ["vests", ["UK3CB_TKA_B_V_GA_LITE_WDL"]];
_militaryLoadoutData setVariable ["slVests", ["UK3CB_TKA_B_V_GA_HEAVY_WDL"]];
_militaryLoadoutData setVariable ["glVests", ["UK3CB_TKA_B_V_GA_HEAVY_WDL"]];
_militaryLoadoutData setVariable ["backpacks", ["UK3CB_TKA_B_B_ASS", "UK3CB_TKA_B_B_RIF", "UK3CB_TKA_O_B_RIF_Tan"]];

_militaryLoadoutData setVariable ["binoculars", ["Laserdesignator"]];

_militaryLoadoutData setVariable ["slRifles", [
["UK3CB_M16A3", "", "", "rhsusf_acc_ACOG", ["UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_RT"], [], ""],
["UK3CB_M16A3", "", "", "rhsusf_acc_ACOG_RMR", ["UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_RT"], [], ""],
["rhs_weap_ak74m", "rhs_acc_dtk3", "rhs_acc_perst1ik", "rhs_acc_1p29", [], [], ""],
["rhs_weap_ak74m", "rhs_acc_dtk3", "rhs_acc_perst1ik", "rhs_acc_1p78", [], [], ""]
]];
_militaryLoadoutData setVariable ["rifles", [
["UK3CB_M16A3", "", "", "rhsusf_acc_eotech_xps3", ["UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_RT"], [], ""],
["UK3CB_M16A3", "", "", "rhsusf_acc_compm4", ["UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_RT"], [], ""],
["rhs_weap_ak74m", "rhs_acc_dtk3", "rhs_acc_perst1ik", "rhs_acc_pkas", [], [], ""],
["rhs_weap_ak74m", "rhs_acc_dtk3", "rhs_acc_perst1ik", "rhs_acc_1p63", [], [], ""],
["rhs_weap_akmn", "rhs_acc_dtkakm", "rhs_acc_perst1ik", "rhs_acc_pkas", [], [], ""],
["rhs_weap_akmn", "rhs_acc_dtkakm", "rhs_acc_perst1ik", "rhs_acc_1p63", [], [], ""]
]];
_militaryLoadoutData setVariable ["carbines", [
["rhs_weap_aks74n_2", "rhs_acc_dtk1983", "rhs_acc_perst1ik", "rhs_acc_pkas", [], [], ""],
["rhs_weap_aks74n_2", "rhs_acc_dtk1983", "rhs_acc_perst1ik", "rhs_acc_1p63", [], [], ""]
]];
_militaryLoadoutData setVariable ["grenadeLaunchers", [
["rhs_weap_ak74m_gp25", "rhs_acc_ak5", "", "rhs_acc_pkas", [], ["rhs_VOG25", "rhs_VOG25", "rhs_VOG25P", "rhs_VG40OP_white"], ""],
["rhs_weap_ak74m_gp25", "rhs_acc_ak5", "", "rhs_acc_1p63", [], ["rhs_VOG25", "rhs_VOG25", "rhs_VOG25P", "rhs_VG40OP_white"], ""],
["UK3CB_M16A2_UGL", "", "", "rhsusf_acc_eotech_xps3", ["UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_RT"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""],
["UK3CB_M16A2_UGL", "", "", "rhsusf_acc_compm4", ["UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_R", "UK3CB_M16_30rnd_556x45_RT"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""]
]];
_militaryLoadoutData setVariable ["SMGs", [
["UK3CB_MP5A2", "", "", "rhsusf_acc_compm4", ["UK3CB_MP5_30Rnd_9x19_Magazine"], [], ""],
["UK3CB_MP5A2", "", "", "rhsusf_acc_eotech_xps3", ["UK3CB_MP5_30Rnd_9x19_Magazine"], [], ""]
]];
_militaryLoadoutData setVariable ["machineGuns", [
["rhs_weap_m249_light_S", "rhsusf_acc_SFMB556", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_eotech_552", ["rhsusf_200rnd_556x45_mixed_box"], [], "rhsusf_acc_kac_grip_saw_bipod"],
["rhs_weap_m249_light_S", "rhsusf_acc_SFMB556", "rhsusf_acc_anpeq15side_bk", "rhsusf_acc_ELCAN", ["rhsusf_200rnd_556x45_mixed_box"], [], "rhsusf_acc_kac_grip_saw_bipod"],
["rhs_weap_m240G", "rhsusf_acc_ARDEC_M240", "", "rhsusf_acc_ELCAN", ["rhsusf_100Rnd_762x51_m80a1epr", "rhsusf_100Rnd_762x51_m80a1epr", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""],
["rhs_weap_m240G", "rhsusf_acc_ARDEC_M240", "", "rhsusf_acc_eotech_552", ["rhsusf_100Rnd_762x51_m80a1epr", "rhsusf_100Rnd_762x51_m80a1epr", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""],
["UK3CB_M60", "", "", "", ["rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""],
["UK3CB_M60", "", "", "", ["rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m61_ap", "rhsusf_100Rnd_762x51_m62_tracer"], [], ""]
]];
_militaryLoadoutData setVariable ["marksmanRifles", [
["UK3CB_M14DMR_Railed", "", "", "rhsusf_acc_ACOG_RMR", ["UK3CB_M14_20rnd_762x51"], [], ""],
["UK3CB_M14DMR_Railed", "", "", "rhsusf_acc_ACOG", ["UK3CB_M14_20rnd_762x51"], [], ""]
]];
_militaryLoadoutData setVariable ["sniperRifles", [
["rhs_weap_m24sws", "", "", "rhsusf_acc_LEUPOLDMK4", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"],
["rhs_weap_m24sws", "", "", "rhsusf_acc_M8541", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"],
["rhs_weap_m24sws", "", "", "rhsusf_acc_LEUPOLDMK4_2", ["rhsusf_5Rnd_762x51_m993_Mag"], [], "rhsusf_acc_harris_swivel"]
]];

///////////////////////////////
//    Police Loadout Data    //
///////////////////////////////

private _policeLoadoutData = _loadoutData call _fnc_copyLoadoutData;

_policeLoadoutData setVariable ["uniforms", ["UK3CB_TKP_B_U_CombatUniform_TAN", "UK3CB_TKP_B_U_QRF_CombatUniform_TAN", "UK3CB_TKP_B_U_QRF_CombatUniform_Shortsleeve_TAN"]];
_policeLoadoutData setVariable ["vests", ["UK3CB_TKP_B_V_TacVest_Tan"]];
_policeLoadoutData setVariable ["helmets", ["UK3CB_TKP_B_H_Patrolcap_TAN"]];

_policeLoadoutData setVariable ["shotGuns", [
["rhs_weap_M590_8RD", "", "", "", ["rhsusf_8Rnd_00Buck", "rhsusf_8Rnd_Slug"], [], ""],
["rhs_weap_M590_5RD", "", "", "", ["rhsusf_5Rnd_00Buck", "rhsusf_5Rnd_Slug"], [], ""]
]];
_policeLoadoutData setVariable ["SMGs", [
["UK3CB_MP5", "", "", "", ["UK3CB_MP5_30Rnd_Magazine"], [""], ""],
["rhsusf_weap_MP7A2", "", "rhsusf_acc_wmx_bk", "rhsusf_acc_eotech_xps3", [], [], ""]
]];
_policeLoadoutData setVariable ["sidearms", [
["rhsusf_weap_glock17g4", "", "", "", ["rhsusf_mag_17Rnd_9x19_FMJ"], [""], ""]
]];

////////////////////////////////
//    Militia Loadout Data    //
////////////////////////////////

private _militiaLoadoutData = _loadoutData call _fnc_copyLoadoutData;
_militiaLoadoutData setVariable ["uniforms", [
"UK3CB_TKA_B_U_CombatUniform_01_WDL", "UK3CB_TKA_B_U_CombatUniform_Shortsleeve_01_WDL",
"UK3CB_TKA_B_U_CombatUniform_02_WDL", "UK3CB_TKA_B_U_CombatUniform_Shortsleeve_02_WDL"]];
_militiaLoadoutData setVariable ["vests", ["UK3CB_V_Chestrig_OLI", "UK3CB_ADA_B_V_TacVest_WDL"]];
_militiaLoadoutData setVariable ["backpacks", ["UK3CB_B_Alice_K"]];
_militiaLoadoutData setVariable ["helmets", [
"UK3CB_TKA_B_H_Patrolcap_OFF_WDL", "UK3CB_CW_US_B_LATE_H_PASGT_01_WDL"]];

_militiaLoadoutData setVariable ["rifles", [
["UK3CB_G3A3_RIS", "", "", "", ["UK3CB_G3_20rnd_762x51_G", "UK3CB_G3_20rnd_762x51_G", "UK3CB_G3_20rnd_762x51_GT"], [], ""],
["UK3CB_HK33KA2_RIS", "", "", "", ["UK3CB_HK33_30rnd_556x45_G", "UK3CB_HK33_30rnd_556x45_G", "UK3CB_HK33_30rnd_556x45_YT"], [], ""],
["UK3CB_M16A2", "", "", "", ["rhs_mag_30Rnd_556x45_M855_Stanag", "rhs_mag_30Rnd_556x45_M855_Stanag", "rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Red"], [], ""]
]];
_militiaLoadoutData setVariable ["grenadeLaunchers", [
["UK3CB_G3KA4_GL", "", "", "", ["UK3CB_G3_20rnd_762x51_G", "UK3CB_G3_20rnd_762x51_G", "UK3CB_G3_20rnd_762x51_GT"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""],
["UK3CB_HK33KA2_RIS_GL", "", "", "", ["UK3CB_HK33_30rnd_556x45_G", "UK3CB_HK33_30rnd_556x45_G", "UK3CB_HK33_30rnd_556x45_YT"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""],
["UK3CB_M16A2_UGL", "", "", "", ["rhs_mag_30Rnd_556x45_M855_Stanag", "rhs_mag_30Rnd_556x45_M855_Stanag", "rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Red"], ["rhs_mag_M441_HE", "rhs_mag_M441_HE", "rhs_mag_M433_HEDP", "rhs_mag_m714_White"], ""]
]];
_militiaLoadoutData setVariable ["SMGs", [
"UK3CB_MP5"
]];
_militiaLoadoutData setVariable ["carbines", [
["UK3CB_M16_Carbine", "", "", "", ["rhs_mag_30Rnd_556x45_M855_Stanag", "rhs_mag_30Rnd_556x45_M855_Stanag", "rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Red"], [], ""]
]];
_militiaLoadoutData setVariable ["machineGuns", [
["UK3CB_M60", "", "", "", ["UK3CB_M60_100rnd_762x51_G", "UK3CB_M60_100rnd_762x51_G", "UK3CB_M60_100rnd_762x51_GT"], [], ""]
]];
_militiaLoadoutData setVariable ["marksmanRifles", [
["UK3CB_G3SG1", "", "", "uk3cb_optic_STANAGZF_G3", [], [], ""]
]];
_militiaLoadoutData setVariable ["sniperRifles", [
["UK3CB_G3SG1_RIS", "", "", "rhsusf_acc_LEUPOLDMK4_2", [], [], ""]
]];
_militiaLoadoutData setVariable ["lightATLaunchers", ["rhs_weap_m72a7"]];
_militiaLoadoutData setVariable ["ATLaunchers", [
["rhs_weap_maaws", "", "", "", ["rhs_mag_maaws_HEAT", "rhs_mag_maaws_HE", "rhs_mag_maaws_HEDP"], [], ""]
]];

//////////////////////////
//    Misc Loadouts     //
//////////////////////////

private _crewLoadoutData = _militaryLoadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_crewLoadoutData setVariable ["uniforms", ["UK3CB_TKA_B_U_CrewUniform_WDL"]];
_crewLoadoutData setVariable ["vests", ["UK3CB_ADA_B_V_TacVest_KHK"]];
_crewLoadoutData setVariable ["helmets", ["H_HelmetCrew_I", "UK3CB_H_Crew_Cap"]];

//The following lines are determining the loadout of the pilots
private _pilotLoadoutData = _militaryLoadoutData call _fnc_copyLoadoutData;
_pilotLoadoutData setVariable ["uniforms", ["UK3CB_TKA_B_U_H_Pilot_DES"]];
_pilotLoadoutData setVariable ["vests", ["UK3CB_V_Pilot_Vest"]];
_pilotLoadoutData setVariable ["helmets", ["UK3CB_H_Pilot_Helmet"]];


/////////////////////////////////
//    Unit Type Definitions    //
/////////////////////////////////
//These define the loadouts for different unit types.
//For example, rifleman, grenadier, squad leader, etc.
//In 95% of situations, you *should not need to edit these*.
//Almost all factions can be set up just by modifying the loadout data above.
//However, these exist in case you really do want to do a lot of custom alterations.

private _squadLeaderTemplate = {
    ["slHat"] call _fnc_setHelmet;
    [["slVests", "vests"] call _fnc_fallback] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;

    [["slBackpacks", "backpacks"] call _fnc_fallback] call _fnc_setBackpack;

    [["slRifles", "rifles"] call _fnc_fallback] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;
    ["primary", 4] call _fnc_addAdditionalMuzzleMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_squadLeader_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 2] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;
    ["signalsmokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["gpses"] call _fnc_addGPS;
    ["binoculars"] call _fnc_addBinoculars;
    ["NVGs"] call _fnc_addNVGs;
};

private _riflemanTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;


    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_rifleman_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 2] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _medicTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    [["medBackpacks", "backpacks"] call _fnc_fallback] call _fnc_setBackpack;
      [selectRandom ["carbines", "SMGs"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_medic"] call _fnc_addItemSet;
    ["items_medic_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _grenadierTemplate = {
    ["helmets"] call _fnc_setHelmet;
    [["glVests", "vests"] call _fnc_fallback] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    ["backpacks"] call _fnc_setBackpack;

    ["grenadeLaunchers"] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;
    ["primary", 10] call _fnc_addAdditionalMuzzleMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_grenadier_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 4] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _explosivesExpertTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    [["engBackpacks", "backpacks"] call _fnc_fallback] call _fnc_setBackpack;

    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;


    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_explosivesExpert_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;

    ["lightExplosives", 2] call _fnc_addItem;
    if (random 1 > 0.5) then {["heavyExplosives", 1] call _fnc_addItem;};
    if (random 1 > 0.5) then {["atMines", 1] call _fnc_addItem;};
    if (random 1 > 0.5) then {["apMines", 1] call _fnc_addItem;};

    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 1] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _engineerTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    [["engBackpacks", "backpacks"] call _fnc_fallback] call _fnc_setBackpack;

    [selectRandom ["carbines", "SMGs"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_engineer_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;

    if (random 1 > 0.5) then {["lightExplosives", 1] call _fnc_addItem;};

    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _latTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    [["atBackpacks", "backpacks"] call _fnc_fallback] call _fnc_setBackpack;

    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    [["lightATLaunchers", "ATLaunchers"] call _fnc_fallback] call _fnc_setLauncher;
    //TODO - Add a check if it's disposable.
    ["launcher", 2] call _fnc_addMagazines;
    ["launcher", 2] call _fnc_addAdditionalMuzzleMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_lat_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 1] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _atTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    [["atBackpacks", "backpacks"] call _fnc_fallback] call _fnc_setBackpack;

    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    [["ATLaunchers", "lightATLaunchers"] call _fnc_fallback] call _fnc_setLauncher;
    ["launcher", 2] call _fnc_addAdditionalMuzzleMagazines;
    //TODO - Add a check if it's disposable.
    ["launcher", 2] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_at_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 1] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _aaTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    [["atBackpacks", "backpacks"] call _fnc_fallback] call _fnc_setBackpack;

    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    ["AALaunchers"] call _fnc_setLauncher;
    //TODO - Add a check if it's disposable.
    ["launcher", 2] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_aa_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _machineGunnerTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    ["backpacks"] call _fnc_setBackpack;

    ["machineGuns"] call _fnc_setPrimary;
    ["primary", 4] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_machineGunner_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["NVGs"] call _fnc_addNVGs;
};

private _marksmanTemplate = {
    ["sniHats"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;


    ["marksmanRifles"] call _fnc_setPrimary;
    ["primary", 4] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_marksman_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["rangefinders"] call _fnc_addBinoculars;
    ["NVGs"] call _fnc_addNVGs;
};

private _sniperTemplate = {
    ["sniHats"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    ["backpacks"] call _fnc_setBackpack;

    ["sniperRifles"] call _fnc_setPrimary;
    ["primary", 4] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_sniper_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["antiInfantryGrenades", 1] call _fnc_addItem;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["rangefinders"] call _fnc_addBinoculars;
    ["NVGs"] call _fnc_addNVGs;
};

private _policeTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;


    [selectRandom ["SMGs", "shotGuns"]] call _fnc_setPrimary;
    ["primary", 3] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_police_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["smokeGrenades", 1] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
};

private _crewTemplate = {
    ["helmets"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;

    [selectRandom ["carbines", "SMGs"]] call _fnc_setPrimary;
    ["primary", 3] call _fnc_addMagazines;

    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;

    ["items_medical_basic"] call _fnc_addItemSet;
    ["items_crew_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["smokeGrenades", 2] call _fnc_addItem;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
    ["gpses"] call _fnc_addGPS;
    ["NVGs"] call _fnc_addNVGs;
};

private _unarmedTemplate = {
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;

    ["items_medical_basic"] call _fnc_addItemSet;
    ["items_unarmed_extras"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;

    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["radios"] call _fnc_addRadio;
};

private _traitorTemplate = {
    call _unarmedTemplate;
    ["sidearms"] call _fnc_setHandgun;
    ["handgun", 2] call _fnc_addMagazines;
};

////////////////////////////////////////////////////////////////////////////////////////
//  You shouldn't touch below this line unless you really really know what you're doing.
//  Things below here can and will break the gamemode if improperly changed.
////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////
//  Special Forces Units   //
/////////////////////////////
private _prefix = "SF";
private _unitTypes = [
    ["SquadLeader", _squadLeaderTemplate],
    ["Rifleman", _riflemanTemplate],
    ["Medic", _medicTemplate, [["medic", true]]],
    ["Engineer", _engineerTemplate, [["engineer", true]]],
    ["ExplosivesExpert", _explosivesExpertTemplate, [["explosiveSpecialist", true]]],
    ["Grenadier", _grenadierTemplate],
    ["LAT", _latTemplate],
    ["AT", _atTemplate],
    ["AA", _aaTemplate],
    ["MachineGunner", _machineGunnerTemplate],
    ["Marksman", _marksmanTemplate],
    ["Sniper", _sniperTemplate]
];

[_prefix, _unitTypes, _sfLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;

/*{
    params ["_name", "_loadoutTemplate"];
    private _loadouts = [_sfLoadoutData, _loadoutTemplate] call _fnc_buildLoadouts;
    private _finalName = _prefix + _name;
    [_finalName, _loadouts] call _fnc_saveToTemplate;
} forEach _unitTypes;
*/

///////////////////////
//  Military Units   //
///////////////////////
private _prefix = "military";
private _unitTypes = [
    ["SquadLeader", _squadLeaderTemplate],
    ["Rifleman", _riflemanTemplate],
    ["Medic", _medicTemplate, [["medic", true]]],
    ["Engineer", _engineerTemplate, [["engineer", true]]],
    ["ExplosivesExpert", _explosivesExpertTemplate, [["explosiveSpecialist", true]]],
    ["Grenadier", _grenadierTemplate],
    ["LAT", _latTemplate],
    ["AT", _atTemplate],
    ["AA", _aaTemplate],
    ["MachineGunner", _machineGunnerTemplate],
    ["Marksman", _marksmanTemplate],
    ["Sniper", _sniperTemplate]
];

[_prefix, _unitTypes, _militaryLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;

////////////////////////
//    Police Units    //
////////////////////////
private _prefix = "police";
private _unitTypes = [
    ["SquadLeader", _policeTemplate],
    ["Standard", _policeTemplate]
];

[_prefix, _unitTypes, _policeLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;

////////////////////////
//    Militia Units    //
////////////////////////
private _prefix = "militia";
private _unitTypes = [
    ["SquadLeader", _squadLeaderTemplate],
    ["Rifleman", _riflemanTemplate],
    ["Medic", _medicTemplate, [["medic", true]]],
    ["Engineer", _engineerTemplate, [["engineer", true]]],
    ["ExplosivesExpert", _explosivesExpertTemplate, [["explosiveSpecialist", true]]],
    ["Grenadier", _grenadierTemplate],
    ["LAT", _latTemplate],
    ["AT", _atTemplate],
    ["AA", _aaTemplate],
    ["MachineGunner", _machineGunnerTemplate],
    ["Marksman", _marksmanTemplate],
    ["Sniper", _sniperTemplate]
];

[_prefix, _unitTypes, _militiaLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;

//////////////////////
//    Misc Units    //
//////////////////////

//The following lines are determining the loadout of vehicle crew
["other", [["Crew", _crewTemplate]], _crewLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
//The following lines are determining the loadout of the pilots
["other", [["Pilot", _crewTemplate]], _pilotLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
//The following lines are determining the loadout for the unit used in the "kill the official" mission
["other", [["Official", _squadLeaderTemplate]], _militaryLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
//The following lines are determining the loadout for the AI used in the "kill the traitor" mission
["other", [["Traitor", _traitorTemplate]], _militaryLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
//The following lines are determining the loadout for the AI used in the "Invader Punishment" mission
["other", [["Unarmed", _UnarmedTemplate]], _militaryLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
