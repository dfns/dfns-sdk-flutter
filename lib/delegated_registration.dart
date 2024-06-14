import 'dart:convert';

import 'package:dfns_sdk_flutter/constants.dart';
import 'package:dfns_sdk_flutter/datamodel/dfns_api.dart';
import 'package:dfns_sdk_flutter/server.dart';
import 'package:flutter/material.dart';

import 'passkeys_signer.dart';
import 'utils.dart';

class DelegatedRegistration extends StatefulWidget {
  const DelegatedRegistration({super.key, required this.callback});

  final Function(String s) callback;

  @override
  State createState() => _DelegatedRegistrationState();
}

class _DelegatedRegistrationState extends State<DelegatedRegistration> {
  late TextEditingController _controller;
  String registrationResponse = '{}';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _registerUser() async {
    final challenge = await registerInit(_controller.text);

    final fido2Attestation = await PasskeysSigner.register(challenge);

    final completeResponse = await registerComplete(
      appId,
      fido2Attestation,
      challenge.temporaryAuthenticationToken,
    );

    setState(() {
      registrationResponse =
          getPrettyJSONString(jsonDecode(completeResponse.body));
    });

    widget.callback(_controller.text);
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
                  'Delegated Registration',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'For this tutorial, you will register a Dfns EndUser, and this is where the registration flow starts. However, in your final app, the flow may be different and the username might come from your internal system.'),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'After registration, the new end user will have an Ethereum testnet wallet and assigned the system permission, `DfnsDefaultEndUserAccess`, that grants the end user full access to their wallets.'),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'Enter the email as the username you are registering, and hit the "Register EndUser" button.'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (String value) async {
                    _registerUser();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _registerUser();
                      },
                      child: const Text('Register User')),
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
                        registrationResponse,
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
