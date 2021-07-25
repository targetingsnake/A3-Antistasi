# This is a list of all event types, and the arguments to be passed on event trigger

## **LogisticLoading, LogisticUnloading, LogisticLoaded, LogisticUnloaded**
|Index|Data type|Description|
|-|-|-|
| 0 | Object | The cargo that was loaded
| 1 | Object | The vehicle the cargo was loaded into
| 2 | Bool | If the cargo was instant loaded (vehicle creation)
| 3 | Any | Additiona arguments passed trough addEventHandler
