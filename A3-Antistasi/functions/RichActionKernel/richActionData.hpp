// #include "..\RichAction\richActionData.hpp"
// If within RichAction #include "richActionData.hpp"

#ifdef __defineNewFunctions
    private __keys = [];
    #define __addElement(NAME, DEFAULT) __keys pushBack [#NAME, DEFAULT];
    #define __saveKeysTo(VARNAME) private VARNAME = +__keys;
#else
    #define __addElement(NAME, DEFAULT)
    #define __saveKeysTo(VARNAME)
#endif


/// Indices of items in a rich action graphics effect <RAGFX> ///
/*

    RAAnim formats:
    1. <STRING> "static text".
    2. <ARRAY> [loopDuration,["text 1","text 2"]]
*/
// The following are type of <RAAnim>
__COUNTER_RESET__
#define RAGFXI_context __COUNTER__
    __addElement("context","");
#define RAGFXI_icon __COUNTER__
    __addElement("icon","");
#define RAGFXI_contextBackground __COUNTER__
    __addElement("contextBackground","");
#define RAGFXI_iconBackground __COUNTER__
    __addElement("iconBackground","");
#define RAGFXI_count __COUNTER__
    __saveKeysTo(__RAGFXKeys);

#ifdef __defineNewFunctions
    #define new_RAGFX (__RAGFXKeys apply { _x select 1 })
#endif




/// Indices of data fields ///
__COUNTER_RESET__
/// Public Fields ///
// <ANY>
#define RADataI_appStore __COUNTER__
    __addElement("appStore", nil);

/// Read-Only Fields ///
// <SCALAR>
#define RADataI_RAID __COUNTER__
    __addElement("RAID", -1);
// <STRING>
#define RADataI_RAIDName __COUNTER__
    __addElement("RAIDName", "");
// <OBJECT>
#define RADataI_target __COUNTER__
    __addElement("target", objNull);
// <SCALAR>
#define RADataI_actionID __COUNTER__
    __addElement("actionID", -1);

// <BOOLEAN>
#define RADataI_dispose __COUNTER__
    __addElement("dispose", false);
// <BOOLEAN>
#define RADataI_refresh __COUNTER__
    __addElement("refresh", false);
// The following are type of <SCALAR>
#define RADataI_idleSleepUntil __COUNTER__
    __addElement("idleSleepUntil", 0);
#define RADataI_renderSleepUntil __COUNTER__
    __addElement("renderSleepUntil", 0);

/// Public Fields ///
// The following are type of <SCALAR>
#define RADataI_idleSleep __COUNTER__
    __addElement("idleSleep", 0.01);
#define RADataI_progressSleep __COUNTER__
    __addElement("progressSleep", 0.01);
#define RADataI_renderSleep __COUNTER__
    __addElement("renderSleep", 0.01);

// <STRING>
#define RADataI_state __COUNTER__
    __addElement("state", "idle");
// <SCALAR>
#define RADataI_completionRatio __COUNTER__
    __addElement("completionRatio", 0);

/*
    Event Params:
    private _appStore = _this # RADataI_appStore;  // Will always be at index 0.
*/
// The following are type of <CODE>
#define RADataI_fnc_onRender __COUNTER__
    __addElement("fnc_onRender", {});
#define RADataI_fnc_onIdle __COUNTER__
    __addElement("fnc_onIdle", {});
#define RADataI_fnc_onStart __COUNTER__
    __addElement("fnc_onStart", {});
#define RADataI_fnc_onProgress __COUNTER__
    __addElement("fnc_onProgress", {});
#define RADataI_fnc_onInterrupt __COUNTER__
    __addElement("fnc_onInterrupt", {});
#define RADataI_fnc_onComplete __COUNTER__
    __addElement("fnc_onComplete", {} );

// <STRING>
#define RADataI_menuText __COUNTER__
    __addElement("menuText", "Rich Action");

// The following are type of <RAGFX>
#define RADataI_gfx_idle __COUNTER__
    __addElement("gfx_idle", new_RAGFX);
#define RADataI_gfx_disabled __COUNTER__
    __addElement("gfx_disabled", new_RAGFX);
#define RADataI_gfx_progress __COUNTER__
    __addElement("gfx_progress", new_RAGFX);
#define RADataI_gfx_override __COUNTER__
    __addElement("gfx_override", new_RAGFX);

// <SCALAR>
#define RADataI_count __COUNTER__
    __saveKeysTo(__RADataKeys);

#ifdef __defineNewFunctions
    #define new_RAData (__RADataKeys apply { _x select 1 })
#endif
