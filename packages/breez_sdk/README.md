# breez-sdk-bindings

This project provides bindings for breez_sdk to various languages.
Currently supported languges are kotlin, swift and dart.
For dart currenty the [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge) to generate the bindings.
For kotlin & swift we are using [uniffi](https://github.com/mozilla/uniffi-rs)
 
## Build

At the root folder:

```
make init
```

### swift

```
make swift-ios
```

This will generate all the artifacts needed to for an iOS app to start writing code that uses breez sdk in swift.
All files are generated in the bindings/swift-ios folder.
We also provides the same binding for mac os by running the following command:

```
make swift-darwing
```
The above will generate the artifacts in the bindings/swift-darwin folder.

### kotlin
TODO

### dart
TODO