import 'dart:convert';

import 'package:dfns_sdk_flutter/dfns_api.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

const int defaultWaitTimeout = 60000;

class PasskeysSigner {
  /**
   * The relying party identifies your application to users, when users create/use passkeys. (Read more [here](https://www.w3.org/TR/webauthn-2/#relying-party)).
   * - id: The relying party identifier is a valid domain string identifying the WebAuthn Relying Party.
   * In other words, its the domain your application is running on, which will be tied to the passkeys that users create.
   * We advise to use the root domain, not the full domain (eg `acme.com`, not `app.acme.com` nor `foo.app.acme.com`), that way, passkeys created
   * by your users can be re-used on other subdomains (eg. on `foo.acme.com` and `bar.acme.com`) in the future. Read more [here](https://developer.mozilla.org/en-US/docs/Web/API/PublicKeyCredentialCreationOptions#rp).
   * - name: A string representing the name of the relying party (e.g. "Acme"). This is the name the user will be presented with when creating or validating a WebAuthn operation.
   */
  final RelyingPartyType relyingParty;

  /**
   * Timeout to use for navigotor.credentials calls. That's the time after which if user did not successfully
   * select and use his passkey, an error will be thrown by webauthn client. Read more [here](https://developer.mozilla.org/en-US/docs/Web/API/PublicKeyCredentialCreationOptions#timeout).
   * */
  final int? timeout;

  PasskeysSigner(
      {required String relyingPartyId,
      required String relyingPartyName,
      this.timeout})
      : relyingParty =
            RelyingPartyType(id: relyingPartyId, name: relyingPartyName) {}

  Future<Fido2Attestation> register(UserRegistrationChallenge challenge) async {
    final registerResponse = await PasskeyAuthenticator().register(
      RegisterRequestType(
        challenge: challenge.challenge,
        relyingParty: this.relyingParty,
        user: UserType(
          displayName: challenge.user.displayName,
          name: challenge.user.name,
          id: base64UrlEncode(utf8.encode(challenge.user.id)),
        ),
        authSelectionType: AuthenticatorSelectionType(
          authenticatorAttachment:
              challenge.authenticatorSelection.authenticatorAttachment ??
                  'platform',
          requireResidentKey:
              challenge.authenticatorSelection.requireResidentKey,
          residentKey: challenge.authenticatorSelection.residentKey,
          userVerification: challenge.authenticatorSelection.userVerification,
        ),
        pubKeyCredParams: List<PubKeyCredParamType>.from(
          challenge.pubKeyCredParams.map(
            (e) => PubKeyCredParamType(
              type: e.type,
              alg: e.alg,
            ),
          ),
        ),
        timeout: this.timeout ?? defaultWaitTimeout,
        attestation: challenge.attestation,
        excludeCredentials: List<CredentialType>.from(
          challenge.excludeCredentials.map(
            (e) => CredentialType(
              type: e.type,
              id: e.id,
              transports: [],
            ),
          ),
        ),
      ),
    );

    return Fido2Attestation(
      Fido2AttestationData(
        registerResponse.attestationObject,
        registerResponse.clientDataJSON,
        registerResponse.rawId,
      ),
      'Fido2',
    );
  }

  Future<Fido2Assertion> sign(UserActionChallenge challenge) async {
    final fido2Assertion = await PasskeyAuthenticator().authenticate(
      AuthenticateRequestType(
        relyingPartyId: this.relyingParty.id,
        challenge: challenge.challenge,
        timeout: this.timeout ?? defaultWaitTimeout,
        userVerification: challenge.userVerification,
        allowCredentials:
            List<CredentialType>.from(challenge.allowCredentials.webauthn.map(
          (e) => CredentialType(
            type: e.type,
            id: e.id,
            transports: [],
          ),
        )),
        mediation: MediationType.Required,
      ),
    );

    return Fido2Assertion(
      'Fido2',
      Fido2AssertionData(
        fido2Assertion.clientDataJSON,
        fido2Assertion.rawId,
        fido2Assertion.signature,
        fido2Assertion.authenticatorData,
        fido2Assertion.userHandle,
      ),
    );
  }
}
