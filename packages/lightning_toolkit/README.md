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
This requires an installation of llvm, change the path to our local llvm in the fficonfig.yaml file and then run:

```
dart run ffigen . --config=fficonfig.yaml
```

The rust interface is now exposed in lib/bindings.dart
To expose a new function from the plugin a corresponding function needed to be added to the lib/lightning_toolkit.dart