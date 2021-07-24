# This is a list of all event types, and the arguments to be passed on event trigger

## **LogisticLoaded**
|Index|Data type|Description|
|-|-|-|
| 0 | Object | The cargo that was loaded
| 1 | Object | The vehicle the cargo was loaded into
| 2 | Bool | If the cargo was instant loaded (vehicle creation)

## **LogisticUnloaded**
|Index|Data type|Description|
|-|-|-|
| 0 | Object | The cargo that was unloaded
| 1 | Object | The vehicle the cargo was unloaded into
| 2 | Bool | If the cargo was instant unloaded (vehicle deletion)
