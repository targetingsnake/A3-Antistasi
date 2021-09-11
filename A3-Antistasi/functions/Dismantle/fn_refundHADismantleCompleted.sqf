
#include "dismantleConfig.hpp"
FIX_LINE_NUMBERS();

_actionData set ["_state","idle"];
_actionData set ["_completionProgress",0];
_actionData get "_lastAnimLifeToken" set [0,false];
player switchMove "";

["<t font='PuristaMedium' color='#ffae00' shadow='2' size='1'> Faction +"+((_actionData get "_structureCost") * COST_RETURN_RATIO toFixed 0)+"€</t>",-1,0.65,3,0.5,-0.75,789] spawn BIS_fnc_dynamicText;
hint "";
