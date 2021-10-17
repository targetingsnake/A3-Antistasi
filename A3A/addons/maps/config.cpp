#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3A_core"};
        author = AUTHOR;
        authors[] = { AUTHORS };
        authorUrl = "";
        VERSION_CONFIG;
    };
};

class A3A
{
    class NavGrid
    {
        altis = "\x\A3A\addons\maps\Antistasi_Altis.Altis\Navigation\altisNavGrid.sqf";
        tem_anizay = "\x\A3A\addons\maps\Antistasi_Anizay.tem_anizay\Navigation\tem_anizayNavGrid.sqf";
        cam_lao_nam = "\x\A3A\addons\maps\Antistasi_CamLaoNam.cam_lao_nam\Navigation\cam_lao_namNavGrid.sqf";
        chernarus_summer = "\x\A3A\addons\maps\Antistasi_Chernarus.chernarus_summer\Navigation\chernarus_summerNavGrid.sqf";
        chernarus_winter = "\x\A3A\addons\maps\Antistasi_ChernarusWinter.chernarus_winter\Navigation\chernarus_winterNavGrid.sqf";
        kunduz = "\x\A3A\addons\maps\Antistasi_Kunduz.Kunduz\Navigation\kunduzNavGrid.sqf";
        enoch = "\x\A3A\addons\maps\Antistasi_Livonia.Enoch\Navigation\enochNavGrid.sqf";
        malden = "\x\A3A\addons\maps\Antistasi_Malden.Malden\Navigation\maldenNavGrid.sqf";
        sara = "\x\A3A\addons\maps\Antistasi_Sahrani.sara\Navigation\saraNavGrid.sqf";
        stratis = "\x\A3A\addons\maps\Antistasi_Stratis.Stratis\Navigation\stratisNavGrid.sqf";
        takistan = "\x\A3A\addons\maps\Antistasi_Takistan.takistan\Navigation\takistanNavGrid.sqf";
        tembelan = "\x\A3A\addons\maps\Antistasi_Tembelan_Island.Tembelan\Navigation\tembelanNavGrid.sqf";
        vt7 = "\x\A3A\addons\maps\Antistasi_Virolahti.vt7\Navigation\vt7NavGrid.sqf";
        tanoa = "\x\A3A\addons\maps\Antistasi_WotP.Tanoa\Navigation\tanoaNavGrid.sqf";
    };
};

class CfgMissions
{
    class MPMissions
    {
        class Antistasi_Altis
        {
            briefingName = $STR_antistasi_mission_info_altis_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Altis.Altis";
        };
        class Antistasi_Anizay
        {
            briefingName = $STR_antistasi_mission_info_anizay_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Anizay.tem_anizay";
        };
        class Antistasi_CamLaoNam
        {
            briefingName = $STR_antistasi_mission_info_camlaonam_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_CamLaoNam.cam_lao_nam";
        };
        class Antistasi_Chernarus
        {
            briefingName = $STR_antistasi_mission_info_cherna_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Chernarus.chernarus_summer";
        };
        class Antistasi_ChernarusWinter
        {
            briefingName = $STR_antistasi_mission_info_chernawinter_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_ChernarusWinter.chernarus_winter";
        };
        class Antistasi_Kunduz
        {
            briefingName = $STR_antistasi_mission_info_kunduz_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Kunduz.Kunduz";
        };
        class Antistasi_Livonia
        {
            briefingName = $STR_antistasi_mission_info_livonia_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Livonia.Enoch";
        };
        class Antistasi_Malden
        {
            briefingName = $STR_antistasi_mission_info_malden_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Malden.Malden";
        };
        class Antistasi_Sahrani
        {
            briefingName = $STR_antistasi_mission_info_sahrani_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Sahrani.sara";
        };
        class Antistasi_Stratis
        {
            briefingName = $STR_antistasi_mission_info_stratis_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Stratis.Stratis";
        };
        class Antistasi_Takistan
        {
            briefingName = $STR_antistasi_mission_info_takistan_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Takistan.takistan";
        };
        class Antistasi_Tembelan_Island
        {
            briefingName = $STR_antistasi_mission_info_tembelan_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Tembelan_Island.Tembelan";
        };
        class Antistasi_Virolahti
        {
            briefingName = $STR_antistasi_mission_info_virolahti_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_Virolahti.vt7";
        };
        class Antistasi_WotP
        {
            briefingName = $STR_antistasi_mission_info_tanoa_mapname_text;
            directory = "x\A3A\addons\maps\Antistasi_WotP.Tanoa";
        };
    };
};
