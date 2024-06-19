import 'dart:convert';

import 'package:dfns_sdk_flutter/datamodel/dfns_api.dart';
import 'package:dfns_sdk_flutter/passkeys_signer.dart';
import 'package:dfns_sdk_flutter/server.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'utils.dart';

class Wallets extends StatefulWidget {
  const Wallets({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State createState() => _WalletsState();
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

class _WalletsState extends State<Wallets> {
  String walletId = '';
  String wallets = '';
  late TextEditingController _controller;
  String signResponse = '{}';

  void getData() async {
    final resp = await getWallets(appId, widget.token);
    final _wallets = List<Wallet>.from(
      jsonDecode(resp.body)['items'].map(
        (e) => Wallet.fromJson(e),
      ),
    );

    setState(() {
      wallets = getPrettyJSONString(jsonDecode(resp.body)['items']);
      walletId = _wallets[0].id;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    getData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _signMessage() async {
    final initRes = await initSignature(
      _controller.text,
      walletId,
      appId,
      widget.token,
    );

    final fido2Assertion = await PasskeysSigner.sign(initRes.challenge);
    final userActionAssertion = UserActionAssertion(
      initRes.challenge.challengeIdentifier,
      fido2Assertion,
    );

    final completeResponse = await completeSignature(
      walletId,
      appId,
      widget.token,
      initRes.requestBody,
      userActionAssertion,
    );

    setState(() {
      signResponse = getPrettyJSONString(jsonDecode(completeResponse.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'End User Wallets',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'The Ethereum testnet wallet created for the end user during registration is listed below. Listing wallets only needs the readonly auth token. End users won\'t be prompted to use their WebAuthn credentials.'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        wallets,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'Use wallets to broadcast transactions will require the end users to sign a challenge each time to authorize the action. For this tutorial, because new wallets do not have any native tokens to pay for gas fees, we won\'t be able to broadcast any transactions to chain. Instead, we will sign an arbitrary message that can be used as proof the end user is the owner of the private key secured by Dfns.'),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'Enter a message in the input box and press the "Sign Message" button. You will see a WebAuthn prompt asking for authorization to perform the action. Once granted, the tutorial makes a request to Dfns MPC signers and gets a signature hash. Optionally you can use etherscan to verify this signature hash matches the wallet address.'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Enter your message',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (String value) async {
                    _signMessage();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _signMessage();
                      },
                      child: const Text('Sign Message')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        signResponse,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
