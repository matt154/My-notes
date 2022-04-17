import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late String _msg;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _msg = "";
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: "Enter Email"),
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: "Enter Password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                _msg = "Register sussesfully";
    
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  var subMsg = e.message;
                  _msg = 'weak password. $subMsg';
                } else if (e.code == 'email-already-in-use') {
                  _msg = 'email allready in use';
                } else if (e.code == 'invalid-email') {
                  _msg = 'invalid email';
                } else {
                  devtools.log(e.code);
                }
              }
              setState(() {});
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text("Already registered? Login here!")),
          Text(
            _msg,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
