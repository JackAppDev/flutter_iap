## 2.0.0

* The library now uses protobuf internally and will propagate underlying platform errors through the `IAPResponse.status` field. Library users are advised to read the comments in the `IAPResponseStatus` enum and handle each case appropriately.
* Resolves issue #20.

## 1.2.2

* [Android] Add subscriptions support
* [Android] Add server verification support
