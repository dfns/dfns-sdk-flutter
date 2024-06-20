import 'package:dfns_sdk_flutter/delegated_login.dart';
import 'package:dfns_sdk_flutter/delegated_registration.dart';
import 'package:dfns_sdk_flutter/wallets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dfns Flutter SDK Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = '';
  String token = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Image(
                    image: AssetImage('images/logo.png'),
                    width: 160,
                    height: 160,
                  ),
                ),

                /// Introduction
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Introduction',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'This tutorial app demonstrates how to use Dfns SDK in the following configuration:\n\n\u2022You have a server and a web single page application.\n\u2022You are not a custodian, and your customers own their wallets.\n\u2022Your customers will use WebAuthn (preferred) or a key credential (discourage as it comes with security risks) credentials to authenticate with Dfns.\n\u2022Your client applications communicates with your server, and does not call the Dfns API directly.\n\u2022Your server communicates with the Dfns API using a service account.',
                    )),

                /// Step 1
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Step 1 - Delegated Registration',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Your customers, either new or existing, must register with Dfns first and have credential(s) in our system in order to own and be able to interact with their blockchain wallets.\n\nThe delegated registration flow allows you to initiate and and complete the registration process on your customers behalf, without them being aware that the wallets infrastructure is powered by Dfns, i.e. they will not receive an registration email from Dfns directly unlike the normal registration process for your employees. Their WebAuthn credentials are still completely under their control.',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DelegatedRegistration(callback: (String s) {
                                setState(() {
                                  username = s;
                                });
                              }),
                            ),
                          );
                        },
                        child: const Text('Go to Delegated Registration')),
                  ),
                ),

                /// Step 2
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Step 2 - Delegated Login',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'The delegated signing flow does not need the end user sign with the WebAuthn credential. The login can be performed on the server side transparent to the end users and obtain a readonly auth token. For example, your server can choose to automatically login the end users upon the completion of delegated registration. In this tutorial, this step is shown as explicit in order to more clearly demonstrate how the interaction works.',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DelegatedLogin(
                                  username: username,
                                  callback: (String s) {
                                    setState(() {
                                      token = s;
                                    });
                                  }),
                            ),
                          );
                        },
                        child: const Text('Go to Delegated Login')),
                  ),
                ),

                /// Step 3
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Step 3 - Wallets',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Once logged in, the end users can use the wallets they own.',
                  ),
                ),
                if (token.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Wallets(
                                  token: token,
                                ),
                              ),
                            );
                          },
                          child: const Text('Go to Wallets')),
                    ),
                  ),
                if (token.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text('⚠️ You need to complete step 1 and 2 first'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
