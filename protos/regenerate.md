# Prepare

## On Mac
```
brew install protobuf swift-protobuf
pub global activate protoc_plugin
```

# Regenerate

*Android* will pick up the protobuf configuration automatically.
Dart & Swift classes need to be generated manually.

```
protoc --plugin=$HOME/.pub-cache/bin/protoc-gen-dart --dart_out=../lib/gen flutter_iap.proto &&
protoc --swift_out=../ios/Classes/ flutter_iap.proto
```