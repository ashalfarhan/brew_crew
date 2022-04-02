import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => error = "");
      return;
    }

    setState(() => isLoading = true);
    try {
      await _auth.signInEmailPassword(email, password);
      setState(() => isLoading = false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Something wen't wrong";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text("Sign in to Brew Crew"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              widget.toggleView();
            },
            child: const Text(
              "Sign up",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 50.0,
        ),
        child: isLoading
            ? const Loader()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: inputDecoration.copyWith(
                        hintText: "Email",
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your email" : null,
                      onChanged: (value) {
                        setState(() => email = value);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: inputDecoration.copyWith(
                        hintText: "Password",
                      ),
                      validator: (value) => value!.length < 6
                          ? "Enter a password 6+ characters long"
                          : null,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() => password = value);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text("Sign in"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.brown[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
