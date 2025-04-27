# Setting up your Environment

## Build Flutter plugin of `Breez SDK - Native`

C-Breez depends on [breez_sdk](https://github.com/breez/breez-sdk-greenlight/tree/main/libs/sdk-flutter) plugin of [Breez SDK - Native](https://sdk-doc-greenlight.breez.technology/),
so be sure to follow those instructions first.

After successfully having built the [breez_sdk](https://github.com/breez/breez-sdk-greenlight/tree/main/libs/sdk-flutter) make sure that [breez-sdk-greenlight](https://github.com/breez/breez-sdk-greenlight)
and `c-breez` are side by side like so:

```
breez-sdk-greenlight/
├─ libs/
│  ├─ sdk-bindings/
│  ├─ sdk-core/
│  ├─ sdk-flutter/
c-breez/
├─ android/
├─ ios/
```

## Add Firebase configuration

C-Breez depends on Google Play Services and requires a configured firebase app.

To create your firebase app follow the following link
[create-firebase-project](https://firebase.google.com/docs/android/setup#create-firebase-project).

After creating the app follow the instructions to create the specific
configuration file for your platform:
* For Android - place the `google-services.json` in the `android/app` folder
* For iOS - place the `GoogleService-info.plist` under `ios/Runner` folder

##### Android

```
flutter build apk
```

##### iOS

```
flutter build ios
```

## Test

A testing framework for this project is being developed [here](https://github.com/breez/lntest).

## Integration tests

```
 flutter test integration_test -d <<device id>>
```