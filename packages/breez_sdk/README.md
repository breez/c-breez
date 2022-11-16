# lightning_toolkit

A flutter plugin project that wraps a rust library and expose its interface using ffi

## Build

On the rust folder:

```
make init
make all
```

Generated artifacts:

* Android libraries
 >* androi/src/main/jniLibs/arm64-v8a/liblightning_toolkit.so
 >* androi/src/main/jniLibs/armeabi-v7a/liblightning_toolkit.so
 >* androi/src/main/jniLibs/x86/liblightning_toolkit.so
 >* androi/src/main/jniLibs/x86_64/liblightning_toolkit.so
* iOS library
 >* ios/liblightning_toolkit.a
* Bindings header
 >* target/bindings.h

Now that the bindings is generated and the native libraries are built we can generate the dart interface.
We are using [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge) to generate the rust and dart bindings, please refer to the documentation for [prerequisites](http://cjycode.com/flutter_rust_bridge/integrate/deps.html)
This requires an installation of llvm then from the root folder, run the following:

```
flutter_rust_bridge_codegen -r rust/src/binding.rs -d lib/bridge_generated.dart -c ios/Classes/bridge_generated.h --llvm-path=<path to llvm>
```



The rust interface is now exposed in lib/lightning_toolkit.dart
