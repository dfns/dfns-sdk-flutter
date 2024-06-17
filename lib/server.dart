import 'dart:convert';

import 'package:dfns_sdk_flutter/constants.dart';
import 'package:dfns_sdk_flutter/datamodel/dfns_api.dart';
import 'package:dfns_sdk_flutter/wallets.dart';
import 'package:http/http.dart' as http;

Future<UserRegistrationChallenge> registerInit(String username) async {
  final res = await makeRequest('/register/init', {
    'appId': appId,
    'username': username,
  });

  return UserRegistrationChallenge.fromJson(
    jsonDecode(res.body),
  );
}

Future<http.Response> registerComplete(
  String appId,
  Fido2Attestation fido2Attestation,
  String temporaryAuthenticationToken,
) {
  print("ASDASDA");
  print(appId);
  return makeRequest('/register/complete', {
    'appId': appId,
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

Future<InitSignatureResponse> initSignature(
  String message,
  String walletId,
  String appId,
  String authToken,
) async {
  final res = await makeRequest('/wallets/signatures/init', {
    'message': message,
    'walletId': walletId,
    'appId': appId,
    'authToken': authToken,
  });

  return InitSignatureResponse.fromJson(jsonDecode(res.body));
}

Future<http.Response> getWallets(String username, String token) {
  return makeRequest('/wallets/list', {
    'appId': appId,
    'authToken': token,
  });
}

Future<http.Response> completeSignature(
  String walletId,
  String appId,
  String authToken,
  InitSignatureRequestBody requestBody,
  UserActionAssertion signedChallenge,
) async {
  return makeRequest('/wallets/signatures/complete', {
    'walletId': walletId,
    'appId': appId,
    'authToken': authToken,
    'requestBody': requestBody.toJson(),
    'signedChallenge': signedChallenge.toJson(),
  });
}

Future<http.Response> makeRequest(String path, Map<String, dynamic> body) {
  return http.post(
    Uri.parse("$baseUrl$path"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(body),
  );
}
