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

# Breez SDK

The Breez SDK enables mobile developers to integrate Lightning and bitcoin payments into their apps with a very shallow learning curve. The use cases are endless – from social apps that want to integrate tipping between users to content-creation apps interested in adding bitcoin monetization. Crucially, this SDK is an end-to-end, non-custodial, drop-in solution powered by Greenlight, a built-in LSP, on-chain interoperability, third-party fiat on-ramps, and other services users and operators need.
   
The Breez SDK provides the following services:
* Sending payments (via various protocols such as: bolt11, keysend, lnurl-pay, lightning address, etc.)
* Receiving payments (via various protocols such as: bolt11, lnurl-withdraw, etc.)
* Fetching node status (e.g. balance, max allow to pay, max allow to receive, on-chain balance, etc.)
* Connecting to a new or existing node.

This diagram is a high-level description of the Breez SDK:
![sdk](https://user-images.githubusercontent.com/5394889/174237369-05aad114-4af8-448e-9fbb-ad6adff835a5.png)

Youcan watch a basic demo here: https://twitter.com/Breez_Tech/status/1602650230088151040?s=20&t=w7Ej2oXjZ0hsXiwZV8K4SA

### Signer
This module handles everything related to the signing of lightning messages. It is initialized with the user’s seed.
### InputParser
This module parses user input that is related to sending and receiving of payments. It identifies the protocol (lightning, lnurl-pay, lightning address, lnurl-withdraw, btc address, etc.) and the related data. Apps should use this parser to interpret users input, display the details to users and then execute the specific action (pay or receive).
### LightningNode
This is an interface that defines how the SDK interacts with the user’s Lightning node. The interface defines methods to create a new node, connect to an existing node, pay or create invoices. It also provides access to the node’s low-level functionality such as: listing peers, graph information etc. Currently we only have one provider (Greenlight) but we can add more providers in the future.
### BTCSwapper
This module provides the ability to send or receive on-chain payments via submarine swaps. Send to a BTC address is done by a reverse submarine swap and receive by a regular submarine swap. It includes refund functionality as well.
### FiatCurrencies
This module provides fiat currencies conversion services and fiat on-ramp service (via MoonPay).
### LSP
This module provides the interface of interacting with one or more LSPs.
