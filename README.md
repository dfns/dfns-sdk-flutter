# Dfns Flutter SDK

Welcome, builders 👋🔑 This repo holds Dfns Flutter SDK. Useful links:

- [Dfns Website](https://www.dfns.co)
- [Dfns API Docs](https://docs.dfns.co)

## BETA Warning

:warning: **Attention: This project is currently in BETA.**

This means that while we've worked hard to ensure its functionality there may still be bugs,
performance issues, or unexpected behavior.

## Installation

`flutter pub add dfns_sdk_flutter`

## Concepts

### `PasskeysSigner`

All state-changing requests made to the Dfns API need to be cryptographically signed by credentials
registered with the User.

> **Note:** To be more precise, it's not the request itself that needs to be signed, but rather a "
> User Action Challenge" issued by Dfns. For simplicity, we refer to this process as "request
> signing".

This request signature serves as cryptographic proof that only authorized entities are making the
request. Without it, the request would result in an Unauthorized error.
While implementing a Flutter application your backend server will have to communicate with the DFNS API
to retrieve this challenge and pass it to your application, `PasskeysSigner` will be used to
register and authenticate a user.

#### Register

```
final fido2Attestation = await PasskeysSigner.register(challenge);
```

#### Sign

```
final fido2Assertion = await PasskeysSigner.sign(initRes.challenge);
```

## DfnsDemo

A demo application using the SDK can be
found [here](https://github.com/dfns/dfns-sdk-kotlin/tree/main/app). This demo application is to be
used in conjunction with
the [delegated registration and login tutorial](https://github.com/dfns/dfns-sdk-ts/tree/m/examples/sdk/auth-delegated#mobile-frontend).
It is a replacement for the `Android` and `iOS` sections, you should read and execute all instruction written
above this section to get this demo running.

#### Prerequisites (iOS)

To run the demo application on an iOS device, you must have an `Application` for iOS. To create
a
new `Application`, go
to `Dfns Dashboard` > `Settings` > `Org Settings` > `Applications` > `New Application`, and enter
the following information

- Name, choose any name, for example `Dfns Tutorial iOS`
- Application Type, leave as the default `Default Application`
- Relying Party, set to the domain you associated with the app, e.g. `panda-new-kit.ngrok-free.app`
- Origin, set to the full url of the domain, e.g. `https://panda-new-kit.ngrok-free.app`

After the `Application` is created, copy and save the `App ID`,
e.g. `ap-39abb-5nrrm-9k59k0u3jup3vivo`.

#### Prerequisites (Android)

To run the demo application on an Android device, you must have an `Application` for Android. To create
a
new `Application`, go
to `Dfns Dashboard` > `Settings` > `Org Settings` > `Applications` > `New Application`, and enter
the following information

- Name, choose any name, for example `Dfns Tutorial Android`
- Application Type, leave as the default `Default Application`
- Relying Party, set to the domain you associated with the app, e.g. `panda-new-kit.ngrok-free.app`
- Origin, set to the full url of the domain, e.g. `https://panda-new-kit.ngrok-free.app`

After the `Application` is created, copy and save the `App ID`,
e.g. `ap-39abb-5nrrm-9k59k0u3jup3vivo`.
