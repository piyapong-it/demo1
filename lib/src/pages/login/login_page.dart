import 'package:flutter/material.dart';

import 'widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  int count = 0;



  @override
  Widget build(BuildContext context) {
    print("CALL");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset("assets/images/logo.png"),
            LoginForm(defaultUsername: 'admin', defaultPassword: '1234')
          ],
        ),
      ),
    );
  }

}
