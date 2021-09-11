
// Settings, can be commented out/uncommented.
#define __ErrorOnBadAppReturn
#define __ErrorOnAppTimeout
#define __ErrorOnCorruptedRAData

// Constants, must be defined.
#define __appTimeout 0.100
#define __disposeTimeout 1

// Utility macros.
#define __passThrough(X) X
#define __sharp __passThrough(#)
#define __RA_fixLineNumbers() __sharp##line __LINE__ __FILE__
