# Dfns Flutter SDK Example

This example showcases the Dfns Flutter SDK.

### Configuration

In the `./lib/constants.dart` set the following values,

Necessary environment variables are

- `SERVER_BASE_URL` = either `http://localhost:8000` or the public url if using ngrok or equivalent to expose online (eg `https://xxxx.ngrok-free.app`)
- `DFNS_APP_ID`  = Dfns Application ID (grab one in Dfns Dashboard: `Settings` > `Applications`)
- `PASSKEY_RELYING_PARTY_ID` = the passkey relying party id, aka, the domain to which you have associated your app for passkeys to work ((Read more [here](https://developer.apple.com/documentation/Xcode/supporting-associated-domains) for IOS and [here](https://developer.android.com/identity/sign-in/credential-manager#add-support-dal) for Android)). We advise using the root domain (eg. `acme.com`, not `app.acme.com`) for more passkey flexibility (so that passkey is re-usable on subdomains). During development on localhost, you can set it to `localhost`. On Dfns dashboard, make sure the relying party you use (for the passkey config) is whitelisted in your Dfns organisation (check dashboard setting).
- `PASSKEY_RELYING_PARTY_NAME` = A string representing the name of the relying party, aka, your company name (e.g. "Acme"). The user will be presented with that name when creating or using a passkey.

### Run

```sh
flutter run \
  --dart-define=SERVER_BASE_URL="http://localhost:8000" \
  --dart-define=DFNS_APP_ID="ap-xxxx-xxxx-xxxxxxxxx" \
  --dart-define=PASSKEY_RELYING_PARTY_ID="localhost" \
  --dart-define=PASSKEY_RELYING_PARTY_NAME="Demo"
```
