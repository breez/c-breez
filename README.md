# c-Breez (Breez powered by Greenlight)

c-Breez is a migration of [Breez mobile app](https://github.com/breez/breezmobile) to the [Greenlight](https://blockstream.com/lightning/greenlight/) infrastructure.

For more details, please check out [this medium post](https://medium.com/breez-technology/get-ready-for-a-fresh-breez-multiple-apps-one-node-optimal-ux-519c4daf2536).

## Build

### Build the lightning_tookit plugin

c-Breez depends on lightning_toolkit plugin that exposes a set of API functions written in rust.
If you didn't add any rust code then you can skip this step, otherwise please refer to the plugin [README](https://github.com/breez/c-breez/tree/main/packages/breez_sdk/README.md)

### Android

```
flutter build apk
```

### iOS

```
flutter build ios
```

## Run

```
flutter run
```
## Tests
A testing framework for this project is being developed [here](https://github.com/breez/lntest).
