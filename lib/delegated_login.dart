import 'dart:convert';

import 'package:dfns_sdk_flutter/server.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class DelegatedLogin extends StatefulWidget {
  const DelegatedLogin({
    super.key,
    required this.username,
    required this.callback,
  });

  final String username;
  final Function(String s) callback;

  @override
  State createState() => _DelegatedLoginState();
}

class LoginResponse {
  final String username;
  final String token;

  LoginResponse(
    this.username,
    this.token,
  );

  factory LoginResponse.fromJson(dynamic json) {
    return LoginResponse(
      json['username'] as String,
      json['token'] as String,
    );
  }
}

class _DelegatedLoginState extends State<DelegatedLogin> {
  late TextEditingController _controller;
  String loginResponse = '{}';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.username;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loginUser() async {
    final res = await login(_controller.text);
    final userDetails = LoginResponse.fromJson(jsonDecode(res.body));

    setState(() {
      loginResponse = getPrettyJSONString(jsonDecode(res.body));
    });

    widget.callback(userDetails.token);
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
                  'Delegated Login',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'For this tutorial, the delegated login flow is started on the client side by pressing the "Login EndUser" button. A request is sent to the server and a readonly auth token is returned in the response. This flow does not need users to sign with the WebAuthn credential.'),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                    'This auth token is readonly and needs to be cached and passed along with all requests interacting with the Dfns API. To clearly demonstrate all the necessary components for each step, this example will cache the auth token in the application context and send it back with every sequently request to the server. You should however choose a more secure caching method.'),
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
                    _loginUser();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _loginUser();
                      },
                      child: const Text('Login EndUser')),
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
                        loginResponse,
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
