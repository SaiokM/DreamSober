import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/components/my_button.dart';
import 'package:dreamsober/components/textfield_mail.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  static String route = "/forgot_pw/";

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  // Dispose of resources and perform cleanup tasks before the widget is removed from the tree
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  //Method for password rest
  Future passwordReset() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Send password reset email using FirebaseAuth
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      // pop the loading circle
      Navigator.pop(context);

      // Show success dialog with a message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'Password reset link sent! Check your email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      // Show error dialog with the exception message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              e.message.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(215, 204, 200, 1),
      appBar: AppBar(
        title: const Text("Reset your password"),
        backgroundColor: Colors.brown[900],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter your Email and we will send you a password reset link',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(height: 15),

          // email textfield
          MailTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          const SizedBox(height: 15),

          // Reset password button
          MyButton(
            text: 'Reset Password',
            onTap: passwordReset,
          ),
        ],
      ),
    );
  }
}
