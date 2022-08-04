//////////////////////////
//   Side Information   //
//////////////////////////

["name", "Bundeswehr"] call _fnc_saveToTemplate;
["spawnMarkerName", "NATO support corridor"] call _fnc_saveToTemplate;

["flag", "flag_germany"] call _fnc_saveToTemplate;
["flagTexture", "\A3\ui_f\data\map\markers\flags\Germany_ca.paa"] call _fnc_saveToTemplate;
["flagMarkerType", "flag_germany"] call _fnc_saveToTemplate;

//////////////////////////
//       Vehicles       //
//////////////////////////

["ammobox", "B_supplyCrate_F"] call _fnc_saveToTemplate;     //Don't touch or you die a sad and lonely death!
["surrenderCrate", "Box_IND_Wps_F"] call _fnc_saveToTemplate; //Changeing this from default will require you to define logistics attachement offset for the box type
["equipmentBox", "Box_NATO_Equip_F"] call _fnc_saveToTemplate; //Changeing this from default will require you to define logistics attachement offset for the box type

["vehiclesBasic", ["gm_ge_army_k125"]] call _fnc_saveToTemplate;
["vehiclesLightUnarmed", ["gm_ge_army_iltis_cargo", "gm_dk_army_typ1200_cargo"]] call _fnc_saveToTemplate;
["vehiclesLightArmed", ["gm_ge_army_iltis_milan", "gm_ge_army_iltis_mg3"]] call _fnc_saveToTemplate; //this line determines light and armed vehicles -- Example: ["vehiclesLightArmed", ["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"]] -- Array, can contain multiple assets
["vehiclesTrucks", ["gm_ge_army_u1300l_cargo", "gm_ge_army_u1300l_container", "gm_ge_army_kat1_451_cargo", "gm_ge_army_kat1_451_container"]] call _fnc_saveToTemplate;
["vehiclesCargoTrucks", ["gm_ge_army_kat1_454_cargo", "gm_ge_army_u1300l_container", "gm_ge_army_kat1_452_container", "gm_ge_army_kat1_451_container"]] call _fnc_saveToTemplate;
["vehiclesAmmoTrucks", ["gm_ge_army_kat1_454_reammo", "gm_ge_army_kat1_451_reammo"]] call _fnc_saveToTemplate;
["vehiclesRepairTrucks", ["gm_ge_army_u1300l_repair", "gm_ge_army_bpz2a0", "gm_dk_army_bpz2a0", "gm_ge_army_fuchsa0_engineer", "gm_dk_army_m113a1dk_engineer"]] call _fnc_saveToTemplate;
["vehiclesFuelTrucks", ["gm_ge_army_kat1_451_refuel"]] call _fnc_saveToTemplate;
["vehiclesMedical", ["gm_ge_army_u1300l_medic", "gm_ge_army_m113a1g_medic", "gm_dk_army_m113a1dk_medic"]] call _fnc_saveToTemplate;
["vehiclesTanks", ["gm_ge_army_Leopard1a1", "gm_ge_army_Leopard1a1a1", "gm_ge_army_Leopard1a1a2", "gm_ge_army_Leopard1a3", "gm_ge_army_Leopard1a3a1", "gm_ge_army_Leopard1a5", "gm_dk_army_Leopard1a3", "gm_ge_army_bibera0", "gm_dk_army_bibera0"]] call _fnc_saveToTemplate;
["vehiclesAA", ["gm_ge_army_gepard1a1"]] call _fnc_saveToTemplate;

["vehiclesAPCs", ["gm_ge_army_fuchsa0_reconnaissance", "gm_ge_army_m113a1g_apc_milan", "gm_ge_army_luchsa1", "gm_ge_army_luchsa2", "gm_dk_army_m113a1dk_apc"]] call _fnc_saveToTemplate;
["vehiclesLightAPCs", ["gm_ge_army_m113a1g_apc", "gm_ge_army_m113a1g_command", "gm_ge_army_fuchsa0_command", "gm_dk_army_m113a1dk_command"]] call _fnc_saveToTemplate;            //this line determines light APCs
["vehiclesIFVs", ["gm_ge_army_marder1a2", "gm_ge_army_marder1a1a", "gm_ge_army_marder1a1plus", "gm_dk_army_m113a2dk"]] call _fnc_saveToTemplate;                //this line determines IFVs


["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] call _fnc_saveToTemplate;
["vehiclesGunBoats", ["B_Boat_Armed_01_minigun_F"]] call _fnc_saveToTemplate;
["vehiclesAmphibious", ["B_T_APC_Wheeled_01_cannon_F"]] call _fnc_saveToTemplate;

["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] call _fnc_saveToTemplate;
["vehiclesPlanesAA", ["B_Plane_Fighter_01_F"]] call _fnc_saveToTemplate;
["vehiclesPlanesTransport", ["gm_ge_airforce_do28d2"]] call _fnc_saveToTemplate;

["vehiclesHelisLight", ["gm_ge_army_bo105m_vbh", "gm_ge_army_bo105p1m_vbh", "gm_ge_army_bo105p1m_vbh_swooper"]] call _fnc_saveToTemplate;
["vehiclesHelisTransport", ["gm_ge_army_ch53gs", "gm_ge_army_ch53g"]] call _fnc_saveToTemplate;
["vehiclesHelisAttack", ["gm_ge_army_bo105p_pah1", "gm_ge_army_bo105p_pah1a1"]] call _fnc_saveToTemplate;

["vehiclesArtillery", ["gm_ge_army_kat1_463_mlrs", "gm_ge_army_m109g", "gm_dk_army_m109"]] call _fnc_saveToTemplate;
["magazines", createHashMapFromArray [
["gm_ge_army_kat1_463_mlrs", ["gm_36Rnd_mlrs_110mm_he_dm21"]],
["gm_ge_army_kat1_463_mlrs", ["gm_36Rnd_mlrs_110mm_icm_dm602"]],
["gm_ge_army_kat1_463_mlrs", ["gm_36Rnd_mlrs_110mm_smoke_dm15"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_he_dm111"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_he_dm21"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_he_m107"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_he_m795"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_icm_dm602"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_smoke_dm105"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_smoke_m110"]],
["gm_ge_army_m109g", ["gm_20Rnd_155mm_smoke_m116"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_he_dm111"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_he_dm21"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_he_m107"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_he_m795"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_icm_dm602"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_smoke_dm105"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_smoke_m110"]],
["gm_dk_army_m109", ["gm_20Rnd_155mm_smoke_m116"]]
]] call _fnc_saveToTemplate;

//

["uavsAttack", ["B_UAV_02_CAS_F"]] call _fnc_saveToTemplate;
["uavsPortable", ["B_UAV_01_F"]] call _fnc_saveToTemplate;

//Config special vehicles - militia vehicles are mostly used in the early game, police cars are being used by troops around cities -- Example:
["vehiclesMilitiaLightArmed", ["gm_ge_army_iltis_mg3"]] call _fnc_saveToTemplate;
["vehiclesMilitiaTrucks", ["gm_ge_army_u1300l_cargo"]] call _fnc_saveToTemplate;
["vehiclesMilitiaCars", ["gm_ge_army_iltis_cargo"]] call _fnc_saveToTemplate;

["vehiclesPolice", ["gm_ge_pol_typ1200"]] call _fnc_saveToTemplate;

["staticMGs", ["gm_ge_army_mg3_aatripod"]] call _fnc_saveToTemplate;
["staticAT", ["gm_ge_army_milan_launcher_tripod"]] call _fnc_saveToTemplate;
["staticAA", ["B_static_AA_F"]] call _fnc_saveToTemplate;
["staticMortars", ["B_Mortar_01_F"]] call _fnc_saveToTemplate;

["mortarMagazineHE", "8Rnd_82mm_Mo_shells"] call _fnc_saveToTemplate; //this line determines available HE-shells for the static mortars - !needs to be comtible with the mortar! -- Example: ["mortarMagazineHE", "8Rnd_82mm_Mo_shells"] - ENTER ONLY ONE OPTION
["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] call _fnc_saveToTemplate; //this line determines smoke-shells for the static mortar - !needs to be comtible with the mortar! -- Example: ["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] - ENTER ONLY ONE OPTION

//Minefield definition
["minefieldAT", ["gm_minestatic_at_dm21", "gm_minestatic_at_dm1233"]] call _fnc_saveToTemplate;
["minefieldAPERS", ["gm_minestatic_ap_dm31"]] call _fnc_saveToTemplate;

/////////////////////
///  Identities   ///
/////////////////////

["voices", ["gm_voice_male_deu_01","gm_voice_male_deu_02","gm_voice_male_deu_03","gm_voice_male_deu_04","gm_voice_male_deu_05","gm_voice_male_deu_06","gm_voice_male_deu_07","gm_voice_male_deu_08","gm_voice_male_deu_09"]] call _fnc_saveToTemplate;
["faces", ["gm_face_whiteHead_01","gm_face_whiteHead_02","gm_WhiteHead_01_camo_01","gm_WhiteHead_01_camo_02",
"gm_WhiteHead_02_camo_01","gm_WhiteHead_02_camo_02","gm_WhiteHead_03_camo_01","gm_WhiteHead_03_camo_02","gm_WhiteHead_04_camo_01",
"gm_WhiteHead_04_camo_02","gm_WhiteHead_05_camo_01","gm_WhiteHead_05_camo_02","gm_WhiteHead_06_camo_01","gm_WhiteHead_06_camo_02",
"gm_WhiteHead_07_camo_01","gm_WhiteHead_07_camo_02","gm_WhiteHead_08_camo_01","gm_WhiteHead_08_camo_02","gm_WhiteHead_09_camo_01",
"gm_WhiteHead_09_camo_02","gm_WhiteHead_10_camo_01","gm_WhiteHead_10_camo_02","gm_WhiteHead_11_camo_01","gm_WhiteHead_11_camo_02",
"gm_WhiteHead_12_camo_01", "gm_WhiteHead_12_camo_02", "gm_WhiteHead_13_camo_01", "gm_WhiteHead_13_camo_02",
"gm_WhiteHead_14_camo_01", "gm_WhiteHead_14_camo_02", "gm_WhiteHead_15_camo_01", "gm_WhiteHead_15_camo_02",
"gm_WhiteHead_16_camo_01", "gm_WhiteHead_16_camo_02", "gm_WhiteHead_17_camo_01", "gm_WhiteHead_17_camo_02",
"gm_WhiteHead_18_camo_01", "gm_WhiteHead_18_camo_02", "gm_WhiteHead_19_camo_01", "gm_WhiteHead_19_camo_02",
"gm_WhiteHead_20_camo_01", "gm_WhiteHead_20_camo_02", "gm_WhiteHead_21_camo_01", "gm_WhiteHead_21_camo_02"]] call _fnc_saveToTemplate;
["sfVoices", ["gm_voice_male_deu_01","gm_voice_male_deu_02","gm_voice_male_deu_03","gm_voice_male_deu_04"]] call _fnc_saveToTemplate;

//////////////////////////
//       Loadouts       //
//////////////////////////

private _loadoutData = call _fnc_createLoadoutData;
_loadoutData set ["slRifles", []];
_loadoutData set ["rifles", []];
_loadoutData set ["carbines", []];
_loadoutData set ["grenadeLaunchers", []];
_loadoutData set ["SMGs", []];
_loadoutData set ["machineGuns", []];
_loadoutData set ["marksmanRifles", []];
_loadoutData set ["sniperRifles", []];

_loadoutData set ["lightATLaunchers", [
["gm_m72a3_oli", "", "", "", ["gm_1Rnd_66mm_heat_m72a3"], [], ""]]];
_loadoutData set ["ATLaunchers", [["gm_pzf44_2_oli", "", "", "gm_feroz2x17_pzf44_2_blk", ["gm_1Rnd_44x537mm_heat_dm32_pzf44_2"], [], ""],
["gm_pzf44_2_des", "", "", "gm_feroz2x17_pzf44_2_des", ["gm_1Rnd_44x537mm_heat_dm32_pzf44_2"], [], ""],
["gm_pzf44_2_win", "", "", "gm_feroz2x17_pzf44_2_win", ["gm_1Rnd_44x537mm_heat_dm32_pzf44_2"], [], ""]]];
_loadoutData set ["missileATLaunchers", [
["gm_pzf84_oli", "", "", "gm_feroz2x17_pzf84_blk", ["gm_1Rnd_84x245mm_ILLUM_DM16_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM32_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM22_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM22_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM12_carlgustaf"], [], ""],
["gm_pzf84_des", "", "", "gm_feroz2x17_pzf84_des", ["gm_1Rnd_84x245mm_ILLUM_DM16_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM32_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM22_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM22_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM12_carlgustaf"], ""],
["gm_pzf84_win", "", "", "gm_feroz2x17_pzf84_win", ["gm_1Rnd_84x245mm_ILLUM_DM16_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM32_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM22_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM22_carlgustaf", "gm_1Rnd_84x245mm_heat_t_DM12_carlgustaf"], ""],
["gm_pzf3_blk""", "", "", ["gm_1Rnd_60mm_heat_dm22_pzf3", "gm_1Rnd_60mm_heat_dm32_pzf3", "gm_1Rnd_60mm_heat_dm12_pzf3"], [], ""],
["gm_p2a1_launcher_blk""", "", "", ["gm_1Rnd_2650mm_potato_dm11"], [], ""]
]];
_loadoutData set ["AALaunchers", [
["gm_fim43_oli", "", "", "", ["gm_1Rnd_70mm_he_m585_fim43"], [], ""]
]];
_loadoutData set ["sidearms", []];

_loadoutData set ["ATMines", ["gm_mine_at_dm21", "gm_mine_at_dm1233"]];
_loadoutData set ["APMines", ["gm_mine_ap_dm31"]];
_loadoutData set ["lightExplosives", ["DemoCharge_Remote_Mag"]];
_loadoutData set ["heavyExplosives", ["gm_explosive_petn_charge"]];

_loadoutData set ["antiTankGrenades", []];
_loadoutData set ["antiInfantryGrenades", ["gm_handgrenade_frag_dm51", "gm_handgrenade_frag_dm51a1"]];
_loadoutData set ["smokeGrenades", ["gm_smokeshell_wht_dm25"]];
_loadoutData set ["signalsmokeGrenades", ["gm_smokeshell_grn_dm21", "gm_smokeshell_red_dm23", "gm_smokeshell_yel_dm26", "gm_smokeshell_org_dm32"]];

//Basic equipment. Shouldn't need touching most of the time.
//Mods might override this, or certain mods might want items removed (No GPSs in WW2, for example)
_loadoutData set ["maps", ["ItemMap"]];
_loadoutData set ["watches", ["gm_watch_kosei_80"]];
_loadoutData set ["compasses", ["gm_ge_army_conat2"]];
_loadoutData set ["radios", ["ItemRadio"]];
_loadoutData set ["gpses", ["ItemGPS"]];
_loadoutData set ["NVGs", ["NVGoggles_INDEP"]];
_loadoutData set ["binoculars", ["gm_df7x40_blk", "gm_df7x40_oli", "gm_df7x40_des", "gm_df7x40_win"]];
_loadoutData set ["rangefinders", ["Rangefinder"]];

_loadoutData set ["uniforms", []];
_loadoutData set ["vests", []];
_loadoutData set ["Hvests", []];
_loadoutData set ["glVests", []];
_loadoutData set ["backpacks", []];
_loadoutData set ["longRangeRadios", []];
_loadoutData set ["helmets", []];
_loadoutData set ["slHat", ["H_Beret_02"]];
_loadoutData set ["sniHats", ["H_Booniehat_wdl"]];

//Item *set* definitions. These are added in their entirety to unit loadouts. No randomisation is applied.
_loadoutData set ["items_medical_basic", ["BASIC"] call A3A_fnc_itemset_medicalSupplies]; //this line defines the basic medical loadout for vanilla
_loadoutData set ["items_medical_standard", ["STANDARD"] call A3A_fnc_itemset_medicalSupplies]; //this line defines the standard medical loadout for vanilla
_loadoutData set ["items_medical_medic", ["MEDIC"] call A3A_fnc_itemset_medicalSupplies]; //this line defines the medic medical loadout for vanilla
_loadoutData set ["items_miscEssentials", [] call A3A_fnc_itemset_miscEssentials];

//Unit type specific item sets. Add or remove these, depending on the unit types in use.
private _slItems = ["Laserbatteries", "Laserbatteries", "Laserbatteries"];
private _eeItems = ["gm_repairkit_01", "MineDetector"];
private _mmItems = [];

if (A3A_hasACE) then {
    _slItems append ["ACE_microDAGR", "ACE_DAGR"];
    _eeItems append ["ACE_Clacker", "ACE_DefusalKit"];
    _mmItems append ["ACE_RangeCard", "ACE_ATragMX", "ACE_Kestrel4500"];
};

_loadoutData set ["items_squadLeader_extras", _slItems];
_loadoutData set ["items_rifleman_extras", []];
_loadoutData set ["items_medic_extras", []];
_loadoutData set ["items_grenadier_extras", []];
_loadoutData set ["items_explosivesExpert_extras", _eeItems];
_loadoutData set ["items_engineer_extras", _eeItems];
_loadoutData set ["items_lat_extras", []];
_loadoutData set ["items_at_extras", []];
_loadoutData set ["items_aa_extras", []];
_loadoutData set ["items_machineGunner_extras", []];
_loadoutData set ["items_marksman_extras", _mmItems];
_loadoutData set ["items_sniper_extras", _mmItems];
_loadoutData set ["items_police_extras", []];
_loadoutData set ["items_crew_extras", []];
_loadoutData set ["items_unarmed_extras", []];

//TODO - ACE overrides for misc essentials, medical and engineer gear

///////////////////////////////////////
//    Special Forces Loadout Data    //
///////////////////////////////////////

private _sfLoadoutData = _loadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_sfLoadoutData set ["uniforms", ["gm_xx_uniform_soldier_bdu_nogloves_80_wdl", "gm_xx_uniform_soldier_bdu_80_wdl", "gm_xx_uniform_soldier_bdu_rolled_80_wdl"]];
_sfLoadoutData set ["vests", ["gm_ge_vest_armor_90_rifleman_flk", "gm_ge_vest_armor_90_leader_flk", "gm_ge_vest_armor_90_machinegunner_flk", "gm_ge_vest_armor_90_medic_flk"]];
_sfLoadoutData set ["backpacks", ["gm_ge_army_backpack_90_flk"]];
_sfLoadoutData set ["helmets", ["gm_dk_headgear_m96_cover_wdl"]];
_sfLoadoutData set ["sniHats", ["gm_ge_headgear_beret_bdx_specop"]];
_sfLoadoutData set ["binoculars", ["Laserdesignator_03"]];

_sfLoadoutData set ["rifles", [
["gm_g36a1_blk", "muzzle_snds_M", "", "", ["gm_30Rnd_556x45mm_B_DM11_g36_blk", "gm_30Rnd_556x45mm_B_DM11_g36_blk", "gm_30Rnd_556x45mm_B_T_DM21_g36_blk"], [], ""],
["gm_g36a1_des", "muzzle_snds_M", "", "", ["gm_30Rnd_556x45mm_B_DM11_g36_des", "gm_30Rnd_556x45mm_B_DM11_g36_des", "gm_30Rnd_556x45mm_B_T_DM21_g36_des"], [], ""],
["gm_g3a3_des", "muzzle_snds_B", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""],
["gm_g3a3_blk", "muzzle_snds_B", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""]
]];

_sfLoadoutData set ["carbines", [
["gm_g3a4_blk", "muzzle_snds_B", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], [], ""]
]];

_sfLoadoutData set ["grenadeLaunchers", [
["gm_hk69a1_blk", "", "", "", ["1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "UGL_FlareGreen_F", "UGL_FlareCIR_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "UGL_FlareYellow_F", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell"], [], ""],
["gm_g3a3_des", "muzzle_snds_B", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""],
["gm_g3a3_blk", "muzzle_snds_B", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""]
]];
_sfLoadoutData set ["SMGs", [
["gm_mp2a1_blk", "", "", "", ["gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM51_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk"], [], ""],
["gm_mp5a2_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""],
["gm_mp5a3_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""],
["gm_mp5sd2_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""],
["gm_mp5sd3_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""]
]];
_sfLoadoutData set ["machineGuns", [
["gm_mg3_blk", "", "", "", ["gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn"], [], ""],
["gm_mg3_des", "", "", "", ["gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn"], [], ""],
["gm_lmgm62_blk", "", "", "", ["gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn"], [], ""]
]];
_sfLoadoutData set ["marksmanRifles", [
["gm_g3a3_dmr_blk", "muzzle_snds_B", "acc_pointer_IR", "gm_feroz24_blk", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], [], "bipod_01_F_blk"],
["gm_g3a3_dmr_des", "muzzle_snds_B", "acc_pointer_IR", "gm_feroz24_des", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], [], "bipod_01_F_blk"]
]];
_sfLoadoutData set ["sniperRifles", [
["srifle_LRR_F", "", "", "optic_LRPS", [], [], ""],
["srifle_LRR_camo_F", "", "", "optic_LRPS", [], [], ""],
["srifle_DMR_02_camo_F", "muzzle_snds_338_green", "", "optic_AMS_khk", [], [], "bipod_01_F_mtp"]
]];
_sfLoadoutData set ["sidearms", [
["gm_p1_blk", "", "", "", ["gm_8Rnd_9x19mm_B_DM51_p1_blk", "gm_8Rnd_9x19mm_B_DM11_p1_blk"], [], ""]
]];

/////////////////////////////////
//    Military Loadout Data    //
/////////////////////////////////

private _militaryLoadoutData = _loadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_militaryLoadoutData set ["uniforms", ["gm_ge_uniform_soldier_90_flk", "gm_ge_uniform_soldier_rolled_90_flk"]];
_militaryLoadoutData set ["vests", ["gm_ge_vest_armor_90_flk", "gm_ge_vest_armor_90_leader_flk", "gm_ge_vest_armor_90_officer_flk", "gm_ge_vest_armor_90_rifleman_flk"]];
_militaryLoadoutData set ["Hvests", ["gm_ge_vest_armor_90_machinegunner_flk", "gm_ge_vest_armor_90_medic_flk"]];
_militaryLoadoutData set ["glVests", ["gm_ge_vest_armor_90_demolition_flk"]];
_militaryLoadoutData set ["backpacks", ["gm_ge_army_backpack_90_flk", "gm_dk_army_backpack_73_oli", "gm_ge_army_backpack_80_oli", "gm_ge_backpack_sem35_oli"]];
_militaryLoadoutData set ["helmets", ["gm_ge_headgear_m62", "gm_ge_headgear_m62_net", "gm_ge_headgear_m92_flk", "gm_ge_headgear_m92_glasses_flk"]];
_militaryLoadoutData set ["binoculars", ["Laserdesignator_03"]];

_militaryLoadoutData set ["slRifles", [
["gm_g36a1_blk", "", "", "", ["gm_30Rnd_556x45mm_B_DM11_g36_blk", "gm_30Rnd_556x45mm_B_DM11_g36_blk", "gm_30Rnd_556x45mm_B_T_DM21_g36_blk"], [], ""],
["gm_g36a1_des", "", "", "", ["gm_30Rnd_556x45mm_B_DM11_g36_des", "gm_30Rnd_556x45mm_B_DM11_g36_des", "gm_30Rnd_556x45mm_B_T_DM21_g36_des"], [], ""],
["gm_c7a1_blk", "", "", "gm_c79a1_blk", ["gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_M193_stanag_gry", "gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_T_M196_stanag_gry", "gm_30Rnd_556x45mm_B_T_M856_stanag_gry"], [], ""]
]];
_militaryLoadoutData set ["rifles", [
["gm_g3a3_des", "", "acc_pointer_IR", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""],
["gm_g3a3_blk", "", "acc_pointer_IR", "", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""],
["gm_g3a3_des", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""],
["gm_g3a3_blk", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""],
["gm_c7a1_blk", "", "", "gm_c79a1_blk", ["gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_M193_stanag_gry", "gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_T_M196_stanag_gry", "gm_30Rnd_556x45mm_B_T_M856_stanag_gry"], [], ""],
["gm_m16a1_blk", "", "", "", ["gm_20Rnd_556x45mm_B_M855_stanag_gry", "gm_20Rnd_556x45mm_B_M855_stanag_gry", "gm_20Rnd_556x45mm_B_M193_stanag_gry", "gm_20Rnd_556x45mm_B_M855_stanag_gry", "gm_20Rnd_556x45mm_B_T_M196_stanag_gry", "gm_20Rnd_556x45mm_B_T_M856_stanag_gry"], [], ""]
]];
_militaryLoadoutData set ["carbines", [
["gm_g3a4_blk", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], [], ""],
["gm_gvm75carb_oli", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], [], ""],
["gm_g3a4_des", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], [], ""]
]];
_militaryLoadoutData set ["grenadeLaunchers", [
["gm_hk69a1_blk", "", "", "", ["1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "UGL_FlareGreen_F", "UGL_FlareCIR_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "UGL_FlareYellow_F", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell"], [], ""],
["gm_g3a3_des", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""],
["gm_g3a3_blk", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], ["gm_1rnd_67mm_heat_dm22a1_g3"], ""]
]];
_militaryLoadoutData set ["SMGs", [
["gm_mp2a1_blk", "", "", "", ["gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM51_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk"], [], ""],
["gm_mp5a2_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""],
["gm_mp5a3_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""]
]];
_militaryLoadoutData set ["machineGuns", [
["gm_mg3_blk", "", "", "", ["gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn"], [], ""],
["gm_mg3_des", "", "", "", ["gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn"], [], ""],
["gm_lmgm62_blk", "", "", "", ["gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn"], [], ""]
]];
_militaryLoadoutData set ["marksmanRifles", [
["gm_g3a3_dmr_blk", "", "acc_pointer_IR", "gm_feroz24_blk", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], [], "bipod_01_F_blk"],
["gm_g3a3_dmr_des", "", "acc_pointer_IR", "gm_feroz24_des", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], [], "bipod_01_F_blk"]
]];
_militaryLoadoutData set ["sniperRifles", [
["srifle_LRR_F", "", "", "optic_SOS", [], [], ""],
["srifle_LRR_F", "", "", "optic_LRPS", [], [], ""]
]];
_militaryLoadoutData set ["sidearms", [
["gm_p1_blk", "", "", "", ["gm_8Rnd_9x19mm_B_DM51_p1_blk", "gm_8Rnd_9x19mm_B_DM11_p1_blk"], [], ""],
["gm_p2a1_blk", "", "", "", ["gm_1Rnd_265mm_flare_multi_red_gc", "gm_1Rnd_265mm_flare_single_red_gc", "gm_1Rnd_265mm_flare_single_wht_gc", "gm_1Rnd_265mm_flare_single_yel_DM10", "gm_1Rnd_265mm_flare_single_grn_DM11", "gm_1Rnd_265mm_flare_single_red_DM13", "gm_1Rnd_265mm_flare_single_wht_DM15", "gm_1Rnd_265mm_flare_para_yel_DM16", "gm_1Rnd_265mm_flare_multi_yel_DM20", "gm_1Rnd_265mm_flare_multi_grn_DM21", "gm_1Rnd_265mm_flare_multi_red_DM23", "gm_1Rnd_265mm_flare_multi_nbc_DM47", "gm_1Rnd_265mm_flare_multi_wht_DM25", "gm_1Rnd_265mm_smoke_single_blk_gc", "gm_1Rnd_265mm_smoke_single_blu_gc", "gm_1Rnd_265mm_smoke_single_yel_gc", "gm_1Rnd_265mm_smoke_single_yel_DM19", "gm_1Rnd_265mm_smoke_single_org_DM22", "gm_1Rnd_265mm_smoke_single_vlt_DM24", "gm_1Rnd_265mm_flare_single_grn_gc"], [], ""]
]];
///////////////////////////////
//    Police Loadout Data    //
///////////////////////////////

private _policeLoadoutData = _loadoutData call _fnc_copyLoadoutData;

_policeLoadoutData set ["uniforms", ["gm_ge_pol_uniform_suit_80_grn", "gm_ge_pol_uniform_blouse_80_blk"]];
_policeLoadoutData set ["vests", ["gm_ge_pol_vest_80_wht", "gm_ge_army_vest_80_belt", "gm_ge_army_vest_80_mp_wht"]];
_policeLoadoutData set ["helmets", ["gm_ge_pol_headgear_cap_80_grn", "gm_ge_pol_headgear_cap_80_wht"]];

_policeLoadoutData set ["SMGs", [
["gm_mp2a1_blk", "", "", "", ["gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM51_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk"], [], ""],
["gm_mp5a2_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""],
["gm_mp5a3_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""]
]];
_policeLoadoutData set ["sidearms", [["gm_p1_blk", "", "", "", ["gm_8Rnd_9x19mm_B_DM51_p1_blk", "gm_8Rnd_9x19mm_B_DM11_p1_blk"], [], ""]]];

////////////////////////////////
//    Militia Loadout Data    //
////////////////////////////////

private _militiaLoadoutData = _loadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_militiaLoadoutData set ["uniforms", ["gm_ge_army_uniform_soldier_80_ols", "gm_ge_army_uniform_soldier_80_oli", "gm_ge_army_uniform_soldier_gloves_80_ols", "gm_ge_army_uniform_soldier_parka_80_ols", "gm_ge_army_uniform_soldier_parka_80_oli", "gm_dk_army_uniform_soldier_84_m84", "gm_dk_army_uniform_soldier_84_oli"]];
_militiaLoadoutData set ["vests", ["gm_ge_army_vest_80_belt", "gm_ge_vest_90_demolition_flk", "gm_ge_vest_90_leader_flk", "gm_ge_vest_90_machinegunner_flk", "gm_ge_vest_90_medic_flk", "gm_ge_vest_90_officer_flk", "gm_ge_vest_90_rifleman_flk", "gm_ge_army_vest_80_demolition", "gm_ge_army_vest_80_leader", "gm_ge_army_vest_80_leader_smg", "gm_ge_army_vest_80_machinegunner", "gm_dk_army_vest_54_machinegunner", "gm_ge_army_vest_80_medic", "gm_ge_army_vest_80_rifleman", "gm_dk_army_vest_54_rifleman", "gm_ge_army_vest_80_rifleman_smg"]];
_militiaLoadoutData set ["backpacks", ["gm_ge_army_backpack_80_oli", "gm_ge_backpack_satchel_80_blk", "gm_ge_backpack_satchel_80_san"]];
_militiaLoadoutData set ["helmets", ["gm_dk_headgear_m52_oli", "gm_dk_headgear_m52_net_oli", "gm_ge_bgs_headgear_m35_53_blk", "gm_ge_bgs_headgear_m35_53_net_blk"]];

_militiaLoadoutData set ["rifles", [
["gm_c7a1_blk", "", "", "gm_c79a1_blk", ["gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_M193_stanag_gry", "gm_30Rnd_556x45mm_B_M855_stanag_gry", "gm_30Rnd_556x45mm_B_T_M196_stanag_gry", "gm_30Rnd_556x45mm_B_T_M856_stanag_gry"], [], ""]
]];
_militiaLoadoutData set ["carbines", [
["gm_gvm75carb_oli", "", "", "", ["gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM41_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_DM111_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_des", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_des", "gm_20Rnd_762x51mm_B_T_DM21_g3_des","gm_20Rnd_762x51mm_AP_DM151_g3_des"], [], ""]
]];
_militiaLoadoutData set ["grenadeLaunchers", [
["gm_hk69a1_blk", "", "", "", ["1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "1Rnd_HE_Grenade_shell", "UGL_FlareGreen_F", "UGL_FlareCIR_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "UGL_FlareYellow_F", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell", "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell"], [], ""]
]];
_militiaLoadoutData set ["SMGs", [
["gm_mp2a1_blk", "", "", "", ["gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM11_mp2_blk", "gm_32Rnd_9x19mm_B_DM51_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk", "gm_32Rnd_9x19mm_AP_DM91_mp2_blk"], [], ""],
["gm_mp5a2_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""],
["gm_mp5a3_blk", "", "", "", ["gm_30Rnd_9x19mm_AP_DM91_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk","gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM11_mp5a3_blk", "gm_30Rnd_9x19mm_B_DM51_mp5a3_blk"], [], ""]
]];
_militiaLoadoutData set ["machineGuns", [
["gm_lmgm62_blk", "", "", "", ["gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A1_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21A2_mg3_grn", "gm_120Rnd_762x51mm_B_T_DM21_mg3_grn"], [], ""]
]];
_militiaLoadoutData set ["marksmanRifles", [
["gm_g3a3_dmr_blk", "", "acc_pointer_IR", "gm_feroz24_blk", ["gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM41_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_DM111_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A1_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21A2_g3_blk", "gm_20Rnd_762x51mm_B_T_DM21_g3_blk","gm_20Rnd_762x51mm_AP_DM151_g3_blk"], [], "bipod_01_F_blk"]
]];
_militiaLoadoutData set ["sidearms", [["gm_p1_blk", "", "", "", ["gm_8Rnd_9x19mm_B_DM51_p1_blk", "gm_8Rnd_9x19mm_B_DM11_p1_blk"], [], ""]]];
//////////////////////////
//    Misc Loadouts     //
//////////////////////////


private _crewLoadoutData = _militaryLoadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_crewLoadoutData set ["uniforms", ["gm_ge_army_uniform_crew_80_oli", "gm_ge_army_uniform_crew_90_flk"]];
_crewLoadoutData set ["vests", ["gm_ge_vest_90_crew_flk", "gm_ge_vest_armor_90_crew_flk", "gm_ge_army_vest_80_bag", "gm_ge_army_vest_80_crew", "gm_dk_army_vest_54_crew"]];
_crewLoadoutData set ["helmets", ["gm_ge_headgear_headset_crew_oli", "gm_ge_headgear_crewhat_80_blk", "gm_ge_headgear_beret_crew_red_antiair", "gm_ge_headgear_beret_crew_blk_antitank", "gm_ge_headgear_beret_crew_blk_armor", "gm_ge_headgear_beret_crew_blk_armorrecon", "gm_ge_headgear_beret_crew_red_artillery"]];


private _pilotLoadoutData = _militaryLoadoutData call _fnc_copyLoadoutData;
_pilotLoadoutData set ["uniforms", ["gm_ge_pol_uniform_pilot_grn", "gm_ge_pol_uniform_pilot_rolled_grn", "gm_ge_army_uniform_pilot_oli", "gm_ge_army_uniform_pilot_rolled_oli", ]];
_pilotLoadoutData set ["vests", ["gm_ge_vest_90_crew_flk", "gm_ge_army_vest_80_bag", "gm_ge_army_vest_80_crew", "gm_dk_army_vest_54_crew"]];
_pilotLoadoutData set ["helmets", ["gm_ge_headgear_sph4_oli"]];





/////////////////////////////////
//    Unit Type Definitions    //
/////////////////////////////////


private _squadLeaderTemplate = {
    ["slHat"] call _fnc_setHelmet;
    [["Hvests", "vests"] call _fnc_fallback] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;

    ["backpacks"] call _fnc_setBackpack;

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
    [["Hvests", "vests"] call _fnc_fallback] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    ["backpacks"] call _fnc_setBackpack;
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
    [["glVests", "vests"] call _fnc_fallback] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;
    ["backpacks"] call _fnc_setBackpack;

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
    ["backpacks"] call _fnc_setBackpack;

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
    ["backpacks"] call _fnc_setBackpack;

    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    [["lightATLaunchers", "ATLaunchers"] call _fnc_fallback] call _fnc_setLauncher;
    //TODO - Add a check if it's disposable.
    ["launcher", 3] call _fnc_addMagazines;

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
    ["backpacks"] call _fnc_setBackpack;

    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    [selectRandom ["ATLaunchers", "missileATLaunchers"]] call _fnc_setLauncher;
    //TODO - Add a check if it's disposable.
    ["launcher", 3] call _fnc_addMagazines;

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
    ["backpacks"] call _fnc_setBackpack;

    [selectRandom ["rifles", "carbines"]] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

    ["AALaunchers"] call _fnc_setLauncher;
    //TODO - Add a check if it's disposable.
    ["launcher", 3] call _fnc_addMagazines;

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

private _marksmanTemplate= {
    ["sniHats"] call _fnc_setHelmet;
    ["vests"] call _fnc_setVest;
    ["uniforms"] call _fnc_setUniform;


    ["marksmanRifles"] call _fnc_setPrimary;
    ["primary", 6] call _fnc_addMagazines;

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


    ["sniperRifles"] call _fnc_setPrimary;
    ["primary", 7] call _fnc_addMagazines;

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


    ["SMGs"] call _fnc_setPrimary;
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

["other", [["Pilot", _crewTemplate]], _pilotLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
//The following lines are determining the loadout for the unit used in the "kill the official" mission
["other", [["Official", _squadLeaderTemplate]], _militaryLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
//The following lines are determining the loadout for the AI used in the "kill the traitor" mission
["other", [["Traitor", _traitorTemplate]], _militaryLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
//The following lines are determining the loadout for the AI used in the "Invader Punishment" mission
["other", [["Unarmed", _UnarmedTemplate]], _militaryLoadoutData] call _fnc_generateAndSaveUnitsToTemplate;
