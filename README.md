# Dfns Flutter SDK

Welcome, builders 👋🔑 This repo holds Dfns Flutter SDK. Useful links:

- [Dfns Website](https://www.dfns.co)
- [Dfns API Docs](https://docs.dfns.co)

## Requirements

Minimum device requirements are driven by passkey support:

- **Android 9 (API 28) or later**, with a screen lock set and a Google account. On Android 13 and below, passkeys come from Google Play services.
- **iOS 15.0 or later.** On iOS 15 passkeys were a developer preview. They are enabled by default from **iOS 16**, which is the practical minimum for production use. The device needs a passcode and iCloud Keychain.
- **Web:** a browser with WebAuthn passkey support.
- **Domain association.** The relying party domain must serve an `apple-app-site-association` file (iOS) and a Digital Asset Links file (Android) that match your app.

Desktop platforms are not supported.

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

```dart
final passkeysSigner = PasskeysSigner(
  relyingPartyId: 'acme.com',
  relyingPartyName: 'Acme',
);
```

#### Create

```dart
final fido2Attestation = await passkeysSigner.create(challenge);
```

#### Sign

```dart
final fido2Assertion = await passkeysSigner.sign(challenge);
```

## DfnsDemo

A demo application using the SDK can be
found [here](https://github.com/dfns/dfns-sdk-flutter/tree/m/example). This demo application is to be
used in conjunction with
the demo server in [delegated registration and login tutorial](https://github.com/dfns/dfns-sdk-ts/tree/m/examples/sdk/auth-delegated#mobile-frontend).
