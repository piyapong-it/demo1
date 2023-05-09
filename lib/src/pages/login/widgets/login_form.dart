import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  LoginForm({required this.defaultUsername, this.defaultPassword, super.key});
  String? defaultUsername;
  String? defaultPassword;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _usernameController.text = defaultUsername ?? "";
    _passwordController.text = defaultPassword ?? "";

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30),
      child: Card(
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username
              TextField(
                obscureText: true,
                controller: _usernameController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'UserName',
                    icon: Icon(Icons.email)),
                // keyboardType: TextInputType.emailAddress,
              ),
              // SizedBox(10),
              // password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Password',
                    icon: Icon(Icons.lock)),
                keyboardType: TextInputType.number,
              ),
              // login button
              ElevatedButton(
                  onPressed: () {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    print("Login: $username, $password");
                  },
                  child: Text("Login")),
              // Register
              OutlinedButton(
                  onPressed: () {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    print("Register: $username, $password");
                  },
                  child: Text("Register")),
              // Demo Bloc with counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(onPressed: () {}, child: Icon(Icons.remove)),
                  Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
                  OutlinedButton(onPressed: () {}, child: Icon(Icons.add)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
