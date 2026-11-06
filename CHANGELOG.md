# Changelog

## 1.0.0

First GA release.

- **Breaking:** `PasskeysSigner.register()` is renamed `create()`, to match the other DFNS SDKs.
- `PasskeysSigner` throws an `ArgumentError` when the relying party id or name is empty.
- Web is declared as a supported platform, next to iOS and Android.
- Requires `passkeys` 2.3.0 or later (the signer uses `preferImmediatelyAvailableCredentials`).
- Unit tests and CI. Example app builds on current Flutter.

## 0.0.6 (2025-06-13)

- Deprecate appplications (read more [here](https://docs.dfns.co/d/guides/applications-depreaction))

## 0.0.5 (2024-11-20)

- Force relying party to be specified on the PasskeysSigner

