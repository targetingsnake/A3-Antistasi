class CfgFunctions {
	class DCI {
		class init {
			file = QPATHTOFOLDER(functions\init);
			class init {
				preStart = 1;
			};
			class initVars {};
		};
		class StateChange {
			file = QPATHTOFOLDER(functions\StateChange);	
			class missionStarted {
				postInit = 1;
			};
		};
	};
};
