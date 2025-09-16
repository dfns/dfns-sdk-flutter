import 'dart:convert';

import 'package:dfns_sdk_flutter/dfns_api.dart';
import 'package:dfns_sdk_flutter/passkeys_signer.dart';
import 'package:dfns_sdk_flutter_example/constants.dart';
import 'package:dfns_sdk_flutter_example/server.dart';
import 'package:dfns_sdk_flutter_example/utils.dart';
import 'package:flutter/material.dart';

class Wallets extends StatefulWidget {
  const Wallets({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State createState() => _WalletsState();
}

class _WalletsState extends State<Wallets> {
  final passkeysSigner = PasskeysSigner(
      relyingPartyId: PASSKEY_RELYING_PARTY_ID,
      relyingPartyName: PASSKEY_RELYING_PARTY_NAME);

  String walletId = '';
  String wallets = '';
  late TextEditingController _messageToSign;
  late TextEditingController _amount;
  late TextEditingController _dest;
  String signResponse = '{}';
  String transferResponse = '{}';

  void getData() async {
    final resp = await getWallets(widget.token);
    final tempWallets = List<Wallet>.from(
      jsonDecode(resp.body)['items'].map(
        (e) => Wallet.fromJson(e),
      ),
    );

    setState(() {
      wallets = getPrettyJSONString(jsonDecode(resp.body)['items']);
      walletId = tempWallets[0].id;
    });
  }

  @override
  void initState() {
    super.initState();
    _messageToSign = TextEditingController();
    _dest = TextEditingController();
    _amount = TextEditingController();

    getData();
  }

  @override
  void dispose() {
    _messageToSign.dispose();
    _dest.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _signMessage() async {
    final initRes = await initSignature(
      _messageToSign.text,
      walletId,
      widget.token,
    );

    final fido2Assertion = await passkeysSigner.sign(initRes.challenge);
    final userActionAssertion = UserActionAssertion(
      initRes.challenge.challengeIdentifier,
      fido2Assertion,
    );

    final completeResponse = await completeSignature(
      walletId,
      widget.token,
      initRes.requestBody,
      userActionAssertion,
    );

    setState(() {
      signResponse = getPrettyJSONString(jsonDecode(completeResponse.body));
    });
  }

   void _transferAssets() async {
    final initRes = await initTransfer(
      _amount.text,
      walletId,
      _dest.text,
      widget.token
    );

    final fido2Assertion = await passkeysSigner.sign(initRes.challenge);
    final userActionAssertion = UserActionAssertion(
      initRes.challenge.challengeIdentifier,
      fido2Assertion,
    );

    final completeResponse = await completeTransfer(
      walletId,
      widget.token,
      initRes.requestBody,
      userActionAssertion,
    );

    setState(() {
      transferResponse = getPrettyJSONString(jsonDecode(completeResponse.body));
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
                    'Use wallets to broadcast transactions will require the end users to sign a challenge each time to authorize the action.'),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'Transfer assets:'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _dest,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.wallet),
                    labelText: 'Destination',
                    border: OutlineInputBorder(),
                  ),
                  
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.money),
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _transferAssets();
                      },
                      child: const Text('Transfer ETH')),
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
                        transferResponse,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'Sign your own transaction:'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _messageToSign,
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
