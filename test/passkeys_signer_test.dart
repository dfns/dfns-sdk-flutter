import 'package:dfns_sdk_flutter/passkeys_signer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasskeysSigner constructor', () {
    test('builds the relying party from id and name', () {
      final signer = PasskeysSigner(
        relyingPartyId: 'acme.com',
        relyingPartyName: 'Acme',
      );

      expect(signer.relyingParty.id, 'acme.com');
      expect(signer.relyingParty.name, 'Acme');
    });

    test('timeout defaults to null when omitted', () {
      final signer = PasskeysSigner(
        relyingPartyId: 'acme.com',
        relyingPartyName: 'Acme',
      );

      expect(signer.timeout, isNull);
    });

    test('stores the provided timeout', () {
      final signer = PasskeysSigner(
        relyingPartyId: 'acme.com',
        relyingPartyName: 'Acme',
        timeout: 30000,
      );

      expect(signer.timeout, 30000);
    });

    test('throws when the relying party id is empty', () {
      expect(
        () => PasskeysSigner(
          relyingPartyId: '',
          relyingPartyName: 'Acme',
        ),
        throwsArgumentError,
      );
    });

    test('throws when the relying party name is empty', () {
      expect(
        () => PasskeysSigner(
          relyingPartyId: 'acme.com',
          relyingPartyName: '',
        ),
        throwsArgumentError,
      );
    });
  });

  test('defaultWaitTimeout is 60000ms', () {
    expect(defaultWaitTimeout, 60000);
  });
}
