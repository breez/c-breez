# c-Breez (Breez powered by Greenlight)

c-Breez is a migration of [Breez mobile app](https://github.com/breez/breezmobile) to the [Greenlight](https://blockstream.com/lightning/greenlight/) infrastructure.

For more details, please check out [this medium post](https://medium.com/breez-technology/get-ready-for-a-fresh-breez-multiple-apps-one-node-optimal-ux-519c4daf2536).

## Build

### Build the lightning_tookit plugin

c-Breez depends on lightning_toolkit plugin that exposes a set of API functions written in rust.
If you didn't add any rust code then you can skip this step, otherwise please refer to the plugin [README](https://github.com/breez/c-breez/blob/main/packages/lightning_toolkit/README.md)

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

# Breez SDK

The goal of  the Breez SDK is to enable mobile developers to add Lightning and bitcoin payments to their apps. Applications vary from social apps wanting to add tipping between their users to content creation apps interested in adding bitcoin monetization. The use cases are endless. The advantage of this SDK is that it provides an end-to-end, non-custodial, drop-in solution.
   
The Breez SDK provides the following services:
** Sending payments (via various protocols such as: bolt11, keysend, lnurl-pay, lightning address, etc.)
** Receiving payments (via various protocols such as: bolt11, lnurl-withdraw, etc.)
** Fetching node status (e.g. balance, max allow to pay, max allow to receive, on-chain balance, etc.)
** Connecting to a new or existing node.

The first implementation of the Breez SDK is in dart and some of the logic under the hood is implemented in rust. Ideally all logic would be implemented in rust and have specific binding for each programming language. However, it’s too early to pursue this path, and for now we are interested in the SDK interface. This diagram is a high-level description of the Breez SDK:
![sdk](https://user-images.githubusercontent.com/5394889/174237369-05aad114-4af8-448e-9fbb-ad6adff835a5.png)
### Signer
This module handles everything related to the signing of lightning messages. It is initialized with the user’s seed.
### InputParser
This module parses user input that is related to sending and receiving of payments. It identifies the protocol (lightning, lnurl-pay, lightning address, lnurl-withdraw, btc address, etc.) and the related data. Apps should use this parser to interpret users input, display the details to users and then execute the specific action (pay or receive).
### LightningNode
This is an interface that defines how the SDK interacts with the user’s Lightning node. The interface defines methods to create a new node, connect to an existing node, pay or create invoices. It also provides access to the node’s low-level functionality such as: listing peers, graph information etc. Currently we only have one provider (Greenlight) but we can add more providers in the future.
### BTCSwapper
TBA - ability to send or receive on-chain payments.
### FiatCurrencies
TBA - fiat conversion services.
### LSP
TBA - LSP related services.
