const String SERVER_BASE_URL = String.fromEnvironment(
  'SERVER_BASE_URL',
  defaultValue: '"https://xxx.ngrok-free.app"',
);

const String PASSKEY_RELYING_PARTY_ID = String.fromEnvironment(
  'PASSKEY_RELYING_PARTY_ID',
  defaultValue: 'localhost',
);

const String PASSKEY_RELYING_PARTY_NAME = String.fromEnvironment(
  'PASSKEY_RELYING_PARTY_NAME',
  defaultValue: 'Demo',
);
