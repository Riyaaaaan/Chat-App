import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/home_screen.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is looged in
          if (snapshot.hasData) {
            return HomePage();
          }
          //user is not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
