import 'package:flutter/material.dart';
import 'package:flutter_pad_1/constants/app_theme.dart';
import 'package:flutter_pad_1/providers/auth_provider.dart';
import 'package:flutter_pad_1/screens/sign_in_screen.dart';

class PasswordResetScreen extends StatelessWidget {
  PasswordResetScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final AuthenticationProvider _authHelper = AuthenticationProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 37),
            infoMessage(),
            SizedBox(height: 11),
            SignInTextField(controller: _emailController, hintText: 'Email'),
            SizedBox(height: 19),
            SignInElevatedButton(
              onPressed: () {
                _authHelper.sendPasswordResetEmail(_emailController.text);
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Center(
                    child: AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      titleTextStyle: TextStyle(fontSize: 16),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        SizedBox(height: 28),
                        Center(
                          child: Text(
                            'Please check your email, Thank you!.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignInScreen()),
                                (route) => false, // Clears all previous routes
                              );
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              buttonName: 'Reset password',
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            )
          ],
        ),
      ),
    );
  }

  Widget infoMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Enter your email\nwe will send you a link to reset password',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class SignInTextField extends StatelessWidget {
  const SignInTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 268,
      height: 38,
      child: TextField(
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF737373),
        ),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDBDBDB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDBDBDB)),
          ),
          filled: true,
          fillColor: Color(0xFFFAFAFA),
          hoverColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF737373),
          ),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}

class SignInElevatedButton extends StatelessWidget {
  const SignInElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
  });

  final Function() onPressed;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 268,
      height: 38,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
