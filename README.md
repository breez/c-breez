# c-Breez (Breez powered by Greenlight)

c-Breez is a migration of [Breez mobile app](https://github.com/breez/breezmobile) to the [Greenlight](https://blockstream.com/lightning/greenlight/) infrastructure.

For more details, please check out [this medium post](https://medium.com/breez-technology/get-ready-for-a-fresh-breez-multiple-apps-one-node-optimal-ux-519c4daf2536).

## Build

### Build the lightning_tookit plugin
c-Breez depends on Breez [sdk-flutter](https://github.com/breez/breez-sdk/tree/main/libs/sdk-flutter) plugin, so be sure to follow those instructions first.

After succesfully having build the sdk-flutter make sure that [breez-sdk](https://github.com/breez/breez-sdk) and c-breez are side by side like so:

```
breez-sdk/
├─ libs/
│  ├─ sdk-flutter/
├─ tools/
├─ LICENSE
├─ README.md
c-breez/
├─ android/
├─ conf/
├─ ios/

```
### android

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
## Test
A testing framework for this project is being developed [here](https://github.com/breez/lntest).
