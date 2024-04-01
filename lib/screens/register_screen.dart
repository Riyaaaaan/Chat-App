import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmpwController = TextEditingController();
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) {
    final _auth = AuthService();
    if (_pwController.text == _confirmpwController.text) {
      try {
        _auth.signUpwithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            //welcome
            Text(
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            //email txt
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),
            //pw txt
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 10),
            //confirm pw txt
            MyTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmpwController,
            ),

            const SizedBox(height: 25),
            //login btn
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),

            const SizedBox(height: 25),

            //register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
