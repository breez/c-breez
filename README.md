# c-Breez (Breez powered by Greenlight)

c-Breez is a migration of [Breez mobile app](https://github.com/breez/breezmobile) to
the [Greenlight](https://blockstream.com/lightning/greenlight/) infrastructure.

For more details, please check
out [this medium post](https://medium.com/breez-technology/get-ready-for-a-fresh-breez-multiple-apps-one-node-optimal-ux-519c4daf2536)
.

## Build

### Build the lightning_tookit plugin

c-Breez depends on Breez [sdk-flutter](https://github.com/breez/breez-sdk/tree/main/libs/sdk-flutter) plugin,
so be sure to follow those instructions first.

After succesfully having build the sdk-flutter make sure that [breez-sdk](https://github.com/breez/breez-sdk)
and c-breez are side by side like so:

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

## Test

A testing framework for this project is being developed [here](https://github.com/breez/lntest).

## Contributors

### Pre-commit `dart format` with Lefthook

[Lefthook](https://github.com/evilmartians/lefthook) is a Git hooks manager that allows custom logic to be
executed prior to Git commit or push. c-Breez comes with Lefthook configuration (`lefthook.yml`), but it must
be installed first.

### Installation

- Install Lefthook.
  See [installation guide](https://github.com/evilmartians/lefthook/blob/master/docs/install.md).
- Run the following command from project root folder to install hooks:

```sh
$ lefthook install
```

Before you commit your changes, Lefthook will automatically run `dart format`.

### Skipping hooks

Should the need arise to skip `pre-commit` hook, CLI users can use the standard Git option `--no-verify` to skip `pre-commit` hook:

```sh
$ git commit -m "..." --no-verify
```

There currently is no Github Desktop support to skip git-hooks. However, you can run:
```sh
$ lefthook uninstall
```
to clear hooks related to `lefthook.yml` configuration before committing your changes. Do no forget to run `lefthook install` to re-activate `pre-commit` hook.
