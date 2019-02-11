## 2.0.0-pre2+1

* Bump protobuf dependency to 0.13.2

## 2.0.0-pre2

* **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 2.0.0-pre1

* The library now uses protobuf internally and will propagate underlying platform errors through the `IAPResponse.status` field. Library users are advised to read the comments in the `IAPResponseStatus` enum and handle each case appropriately. **NOTE**: Previous versions of this plugin would throw exceptions if a IAP operation failed. This has been changed so that all errors are visible in the `IAPResponse.status` field.
* Resolves issue #20.
* Purchases on Android must now be explicitely consumed. Previous versions of the library did this automatically.

## 1.2.2

* [Android] Add subscriptions support
* [Android] Add server verification support
