import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = "";
  bool isLoading = false;

  void onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => error = "");
      return;
    }

    setState(() => isLoading = true);
    try {
      await _auth.registerEmailPassword(email, password);
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
        title: const Text("Sign up to Brew Crew"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              widget.toggleView();
            },
            child: const Text(
              "Sign in",
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
                      onPressed: onSubmit,
                      child: const Text("Register"),
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
