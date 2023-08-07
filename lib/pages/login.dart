// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/button.dart';
import 'package:the_wall/components/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign-in method
  void signIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: ((context) => const Center(
            child: CircularProgressIndicator(),
          )),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      //display error message
      displayMessage(e.code);
    }
  }

  // display error message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  //logo
                  const Icon(
                    Icons.comment,
                    size: 100,
                  ),
                  const SizedBox(height: 30),
                  // welcome back flair
                  const Text('Welcome back! you\'ve been missed.'),
                  const SizedBox(height: 30),
                  // email textfield
                  MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      obscureText: false),
                  const SizedBox(height: 20),
                  // password textfield
                  MyTextField(
                      controller: passwordTextController,
                      hintText: 'Password',
                      obscureText: true),
                  const SizedBox(height: 30),
                  // sign in button
                  MyButton(
                    onTap: signIn,
                    text: 'Sign-in!',
                  ),
                  const SizedBox(height: 20),
                  // go to register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member yet?'),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
