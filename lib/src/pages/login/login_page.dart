import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'piyapongs';
    _passwordController.text = '1234';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Image.asset("assets/images/logo.png"),
          _buildForm()
        ],
      ),
    );
  }

  _buildForm() {
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
                    print(
                        "login :${_usernameController.text}, ${_passwordController.text}");
                  },
                  child: Text("Login")),
              // Register
              OutlinedButton(
                  onPressed: () {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    print("Register: $username, $password");
                  }, child: Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}
