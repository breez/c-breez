![Build Android workflow](https://github.com/breez/c-breez/actions/workflows/build-android.yml/badge.svg)
![Build iOS workflow](https://github.com/breez/c-breez/actions/workflows/build-ios.yml/badge.svg)
![CI workflow](https://github.com/breez/c-breez/actions/workflows/CI.yml/badge.svg)

# c-Breez (Breez powered by Greenlight)

<img align="right" width="112" height="42" title="Breez logo"
     src="./src/images/logo-color.svg">

c-Breez is a migration of [Breez mobile app](https://github.com/breez/breezmobile) to
the [Greenlight](https://blockstream.com/lightning/greenlight/) infrastructure.

📖 [Read the introduction post](https://medium.com/breez-technology/get-ready-for-a-fresh-breez-multiple-apps-one-node-optimal-ux-519c4daf2536)

<p align="center">
  <a href="https://blockstream.com/lightning/greenlight/">
  <img src="./src/images/drawer_footer.png" alt="Powered by Breez SDK & Greenlight" width="396" height="60"></a>
</p>

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
├─ ios/

```

### Add firebase config files
c-breez depends on google services and requires a configured firebase app.

To create your firebase app follow the following link
[create-firebase-project](https://firebase.google.com/docs/android/setup#create-firebase-project).

After creating the app follow the instructions to create the specific 
configuration file for your platform:
* For android - place the google-services.json in the andrpod/app folder
* For iOS - place the GoogleService-info.plist under ios/Runner folder

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

## Integration tests

 ```
 flutter test integration_test -d <<device id>>
 ```

___

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
to clear hooks related to `lefthook.yml` configuration before committing your changes.

Do no forget to run `lefthook install` to re-activate `pre-commit` hook.

```sh
$ lefthook install
```
