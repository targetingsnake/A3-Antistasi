#include "common_includes.hpp"

//Extra config needed if we build VCOM as an addon, rather than integrate it into a mission.
#ifndef USE_VCOM_IN_MISSION
#include "BIS_AddonInfo.hpp"
class CfgPatches
{
	class VCOM_AI
	{
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
		author[]= {"Genesis"};
	};
};

#endif


class CfgFunctions
{
	class VCOMlaunch
	{
		class VCOM_Initialization
		{
			class Init
			{
				file = STRINGIFY(VCOM_PREFIX\VcomInit.sqf);
				#ifndef USE_VCOM_IN_MISSION
				postInit = 1;
				#endif
			};
		};

	};
	#include "cfgFunctions.hpp"
};


class Extended_PreInit_EventHandlers {
	VCM_CBASettings = call compile preprocessFileLineNumbers STRINGIFY(VCOM_PREFIX\Functions\VCM_Functions\fn_CBASettings.sqf);
};


class CfgRemoteExec
{
	// List of script functions allowed to be sent from client via remoteExec
	class Functions
	{
		mode = 2;
		jip = 1;

		class vcm_serverask { allowedTargets = 0;jip = 1; };
		class VCM_PublicScript { allowedTargets = 0;jip = 1; };
		class BIS_fnc_debugConsoleExec { allowedTargets = 0;jip = 1; };
		class SpawnScript { allowedTargets = 0;jip = 1; };
		class enableSimulationGlobal { allowedTargets = 0;jip = 1; };
		class VCM_fnc_KnowAbout { allowedTargets = 0;jip = 1; };

	};


};
