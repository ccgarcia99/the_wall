import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text field controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confrimPasswordController = TextEditingController();

  // sign up function
  void signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: ((context) => const Center(
            child: CircularProgressIndicator(),
          )),
    );

    // make sure that passwords match
    if (passwordTextController.text != confrimPasswordController.text) {
      // pop loading circle
      Navigator.pop(context);
      // show error
      displayMessage("Passwords don't match!");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      // display error message
      displayMessage(e.code);
    }
  }

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
                    Icons.person,
                    size: 100,
                  ),
                  const SizedBox(height: 30),
                  // name textfield
                  MyTextField(
                      controller: nameTextController,
                      hintText: 'Enter your full name',
                      obscureText: false),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  MyTextField(
                      controller: confrimPasswordController,
                      hintText: 'Confrim your password',
                      obscureText: true),
                  const SizedBox(height: 30),
                  // sign in button
                  MyButton(onTap: signUp, text: 'Register!'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Log-in!',
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
