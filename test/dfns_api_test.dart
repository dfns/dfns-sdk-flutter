import 'package:dfns_sdk_flutter/dfns_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RelyingParty', () {
    test('constructor wires fields', () {
      final rp = RelyingParty('acme.com', 'Acme');

      expect(rp.id, 'acme.com');
      expect(rp.name, 'Acme');
    });

    test('fromJson parses fields', () {
      final rp = RelyingParty.fromJson({'id': 'acme.com', 'name': 'Acme'});

      expect(rp.id, 'acme.com');
      expect(rp.name, 'Acme');
    });
  });

  group('UserInformation', () {
    test('fromJson parses fields', () {
      final user = UserInformation.fromJson({
        'id': 'us-1234',
        'displayName': 'Alice',
        'name': 'alice@acme.com',
      });

      expect(user.id, 'us-1234');
      expect(user.displayName, 'Alice');
      expect(user.name, 'alice@acme.com');
    });
  });

  group('SupportedCredentialKinds', () {
    test('fromJson parses string lists', () {
      final kinds = SupportedCredentialKinds.fromJson({
        'firstFactor': ['Fido2', 'Key'],
        'secondFactor': ['Totp'],
      });

      expect(kinds.firstFactor, ['Fido2', 'Key']);
      expect(kinds.secondFactor, ['Totp']);
    });

    test('fromJson handles empty lists', () {
      final kinds = SupportedCredentialKinds.fromJson({
        'firstFactor': <String>[],
        'secondFactor': <String>[],
      });

      expect(kinds.firstFactor, isEmpty);
      expect(kinds.secondFactor, isEmpty);
    });
  });

  group('AuthenticatorSelectionCriteria', () {
    test('fromJson parses all fields', () {
      final criteria = AuthenticatorSelectionCriteria.fromJson({
        'authenticatorAttachment': 'platform',
        'residentKey': 'required',
        'requireResidentKey': true,
        'userVerification': 'required',
      });

      expect(criteria.authenticatorAttachment, 'platform');
      expect(criteria.residentKey, 'required');
      expect(criteria.requireResidentKey, true);
      expect(criteria.userVerification, 'required');
    });

    test('fromJson allows null authenticatorAttachment', () {
      final criteria = AuthenticatorSelectionCriteria.fromJson({
        'authenticatorAttachment': null,
        'residentKey': 'preferred',
        'requireResidentKey': false,
        'userVerification': 'preferred',
      });

      expect(criteria.authenticatorAttachment, isNull);
      expect(criteria.requireResidentKey, false);
    });
  });

  group('PublicKeyCredentialParameters', () {
    test('fromJson parses type and alg', () {
      final params = PublicKeyCredentialParameters.fromJson({
        'type': 'public-key',
        'alg': -7,
      });

      expect(params.type, 'public-key');
      expect(params.alg, -7);
    });
  });

  group('PublicKeyCredentialDescriptor', () {
    test('fromJson parses type and id', () {
      final descriptor = PublicKeyCredentialDescriptor.fromJson({
        'type': 'public-key',
        'id': 'cred-1',
      });

      expect(descriptor.type, 'public-key');
      expect(descriptor.id, 'cred-1');
    });
  });

  group('AllowCredentials', () {
    test('fromJson parses nested descriptors', () {
      final allow = AllowCredentials.fromJson({
        'webauthn': [
          {'type': 'public-key', 'id': 'wa-1'},
        ],
        'key': [
          {'type': 'public-key', 'id': 'key-1'},
          {'type': 'public-key', 'id': 'key-2'},
        ],
      });

      expect(allow.webauthn, hasLength(1));
      expect(allow.webauthn.first.id, 'wa-1');
      expect(allow.key, hasLength(2));
      expect(allow.key[1].id, 'key-2');
    });
  });

  group('UserRegistrationChallenge', () {
    test('fromJson parses a representative registration challenge', () {
      final challenge = UserRegistrationChallenge.fromJson({
        'temporaryAuthenticationToken': 'tat-1',
        'user': {
          'id': 'us-1234',
          'displayName': 'Alice',
          'name': 'alice@acme.com',
        },
        'supportedCredentialKinds': {
          'firstFactor': ['Fido2'],
          'secondFactor': ['Totp'],
        },
        'otpUrl': 'https://otp.example',
        'challenge': 'challenge-value',
        'authenticatorSelection': {
          'authenticatorAttachment': 'platform',
          'residentKey': 'required',
          'requireResidentKey': true,
          'userVerification': 'required',
        },
        'attestation': 'none',
        'pubKeyCredParams': [
          {'type': 'public-key', 'alg': -7},
          {'type': 'public-key', 'alg': -257},
        ],
        'excludeCredentials': [
          {'type': 'public-key', 'id': 'excl-1'},
        ],
      });

      expect(challenge.temporaryAuthenticationToken, 'tat-1');
      expect(challenge.user.displayName, 'Alice');
      expect(challenge.supportedCredentialKinds.firstFactor, ['Fido2']);
      expect(challenge.otpUrl, 'https://otp.example');
      expect(challenge.challenge, 'challenge-value');
      expect(challenge.authenticatorSelection.residentKey, 'required');
      expect(challenge.attestation, 'none');
      expect(challenge.pubKeyCredParams, hasLength(2));
      expect(challenge.pubKeyCredParams[1].alg, -257);
      expect(challenge.excludeCredentials, hasLength(1));
      expect(challenge.excludeCredentials.first.id, 'excl-1');
    });
  });

  group('Fido2AttestationData', () {
    test('round-trips through toJson/fromJson', () {
      final original = Fido2AttestationData('att-data', 'client-data', 'cred-1');
      final restored = Fido2AttestationData.fromJson(original.toJson());

      expect(restored.attestationData, 'att-data');
      expect(restored.clientData, 'client-data');
      expect(restored.credId, 'cred-1');
    });

    test('toJson produces the expected shape', () {
      final data = Fido2AttestationData('att-data', 'client-data', 'cred-1');

      expect(data.toJson(), {
        'attestationData': 'att-data',
        'clientData': 'client-data',
        'credId': 'cred-1',
      });
    });
  });

  group('Fido2Attestation', () {
    test('round-trips through toJson/fromJson', () {
      final original = Fido2Attestation(
        Fido2AttestationData('att-data', 'client-data', 'cred-1'),
        'Fido2',
      );
      final restored = Fido2Attestation.fromJson(original.toJson());

      expect(restored.credentialKind, 'Fido2');
      expect(restored.credentialInfo.attestationData, 'att-data');
      expect(restored.credentialInfo.credId, 'cred-1');
    });

    test('toJson nests credentialInfo', () {
      final attestation = Fido2Attestation(
        Fido2AttestationData('att-data', 'client-data', 'cred-1'),
        'Fido2',
      );

      expect(attestation.toJson(), {
        'credentialInfo': {
          'attestationData': 'att-data',
          'clientData': 'client-data',
          'credId': 'cred-1',
        },
        'credentialKind': 'Fido2',
      });
    });
  });

  group('SupportedCredentialKinds2', () {
    test('fromJson parses fields', () {
      final kind = SupportedCredentialKinds2.fromJson({
        'kind': 'Fido2',
        'factor': 'first',
        'requiresSecondFactor': false,
      });

      expect(kind.kind, 'Fido2');
      expect(kind.factor, 'first');
      expect(kind.requiresSecondFactor, false);
    });
  });

  group('UserActionChallenge', () {
    test('fromJson parses a representative user-action challenge', () {
      final challenge = UserActionChallenge.fromJson({
        'attestation': 'none',
        'userVerification': 'required',
        'externalAuthenticationUrl': 'https://auth.example',
        'challenge': 'challenge-value',
        'challengeIdentifier': 'ci-1',
        'supportedCredentialKinds': [
          {'kind': 'Fido2', 'factor': 'first', 'requiresSecondFactor': false},
        ],
        'allowCredentials': {
          'webauthn': [
            {'type': 'public-key', 'id': 'wa-1'},
          ],
          'key': <Map<String, dynamic>>[],
        },
      });

      expect(challenge.attestation, 'none');
      expect(challenge.userVerification, 'required');
      expect(challenge.externalAuthenticationUrl, 'https://auth.example');
      expect(challenge.challenge, 'challenge-value');
      expect(challenge.challengeIdentifier, 'ci-1');
      expect(challenge.supportedCredentialKinds, hasLength(1));
      expect(challenge.supportedCredentialKinds.first.kind, 'Fido2');
      expect(challenge.allowCredentials.webauthn.first.id, 'wa-1');
      expect(challenge.allowCredentials.key, isEmpty);
    });
  });

  group('Fido2AssertionData', () {
    test('round-trips through toJson/fromJson', () {
      final original = Fido2AssertionData(
        'client-data',
        'cred-1',
        'signature',
        'auth-data',
        'user-handle',
      );
      final restored = Fido2AssertionData.fromJson(original.toJson());

      expect(restored.clientData, 'client-data');
      expect(restored.credId, 'cred-1');
      expect(restored.signature, 'signature');
      expect(restored.authenticatorData, 'auth-data');
      expect(restored.userHandle, 'user-handle');
    });
  });

  group('Fido2Assertion', () {
    test('round-trips through toJson/fromJson', () {
      final original = Fido2Assertion(
        'Fido2',
        Fido2AssertionData(
          'client-data',
          'cred-1',
          'signature',
          'auth-data',
          'user-handle',
        ),
      );
      final restored = Fido2Assertion.fromJson(original.toJson());

      expect(restored.kind, 'Fido2');
      expect(restored.credentialAssertion.signature, 'signature');
      expect(restored.credentialAssertion.userHandle, 'user-handle');
    });
  });

  group('UserActionAssertion', () {
    test('round-trips through toJson/fromJson', () {
      final original = UserActionAssertion(
        'ci-1',
        Fido2Assertion(
          'Fido2',
          Fido2AssertionData(
            'client-data',
            'cred-1',
            'signature',
            'auth-data',
            'user-handle',
          ),
        ),
      );
      final restored = UserActionAssertion.fromJson(original.toJson());

      expect(restored.challengeIdentifier, 'ci-1');
      expect(restored.firstFactor.kind, 'Fido2');
      expect(restored.firstFactor.credentialAssertion.credId, 'cred-1');
    });

    test('toJson nests the first-factor assertion', () {
      final assertion = UserActionAssertion(
        'ci-1',
        Fido2Assertion(
          'Fido2',
          Fido2AssertionData(
            'client-data',
            'cred-1',
            'signature',
            'auth-data',
            'user-handle',
          ),
        ),
      );

      expect(assertion.toJson(), {
        'challengeIdentifier': 'ci-1',
        'firstFactor': {
          'kind': 'Fido2',
          'credentialAssertion': {
            'clientData': 'client-data',
            'credId': 'cred-1',
            'signature': 'signature',
            'authenticatorData': 'auth-data',
            'userHandle': 'user-handle',
          },
        },
      });
    });
  });
}
