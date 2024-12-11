import 'dart:convert';

import 'package:dfns_sdk_flutter/dfns_api.dart';
import 'package:dfns_sdk_flutter_example/constants.dart';
import 'package:http/http.dart' as http;

Future<UserRegistrationChallenge> registerInit(String username) async {
  final res = await makeRequest('/register/init', {
    'appId': DFNS_APP_ID,
    'username': username,
  });

  return UserRegistrationChallenge.fromJson(
    jsonDecode(res.body),
  );
}

Future<http.Response> registerComplete(
  Fido2Attestation fido2Attestation,
  String temporaryAuthenticationToken,
) {
  return makeRequest('/register/complete', {
    'appId': DFNS_APP_ID,
    'signedChallenge': {
      'firstFactorCredential': fido2Attestation.toJson(),
    },
    'temporaryAuthenticationToken': temporaryAuthenticationToken,
  });
}

Future<http.Response> login(String username) async {
  return makeRequest('/login', {
    'username': username,
  });
}

class Wallet {
  final String id;
  final String network;

  Wallet(
    this.id,
    this.network,
  );

  factory Wallet.fromJson(dynamic json) {
    return Wallet(
      json['id'] as String,
      json['network'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'network': network,
      };
}

class InitSignatureRequestBody {
  final String kind;
  final String message;

  InitSignatureRequestBody(
    this.kind,
    this.message,
  );

  factory InitSignatureRequestBody.fromJson(dynamic json) {
    return InitSignatureRequestBody(
      json['kind'] as String,
      json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'message': message,
      };
}

class InitSignatureResponse {
  final InitSignatureRequestBody requestBody;
  final UserActionChallenge challenge;

  InitSignatureResponse(
    this.requestBody,
    this.challenge,
  );

  factory InitSignatureResponse.fromJson(dynamic json) {
    return InitSignatureResponse(
      InitSignatureRequestBody.fromJson(json['requestBody']),
      UserActionChallenge.fromJson(json['challenge']),
    );
  }
}

Future<InitSignatureResponse> initSignature(
  String message,
  String walletId,
  String authToken,
) async {
  final res = await makeRequest('/wallets/signatures/init', {
    'message': message,
    'walletId': walletId,
    'appId': DFNS_APP_ID,
    'authToken': authToken,
  });

  return InitSignatureResponse.fromJson(jsonDecode(res.body));
}

Future<http.Response> getWallets(String token) {
  return makeRequest('/wallets/list', {
    'appId': DFNS_APP_ID,
    'authToken': token,
  });
}

Future<http.Response> completeSignature(
  String walletId,
  String authToken,
  InitSignatureRequestBody requestBody,
  UserActionAssertion signedChallenge,
) async {
  return makeRequest('/wallets/signatures/complete', {
    'walletId': walletId,
    'appId': DFNS_APP_ID,
    'authToken': authToken,
    'requestBody': requestBody.toJson(),
    'signedChallenge': signedChallenge.toJson(),
  });
}

Future<http.Response> makeRequest(String path, Map<String, dynamic> body) {
  return http.post(
    Uri.parse("$SERVER_BASE_URL$path"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(body),
  );
}
