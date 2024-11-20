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
found [here](https://github.com/dfns/dfns-sdk-flutter/tree/m/example). This demo application is to be
used in conjunction with
the demo server in [delegated registration and login tutorial](https://github.com/dfns/dfns-sdk-ts/tree/m/examples/sdk/auth-delegated#mobile-frontend).