import 'package:demo1/src/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/counter/counter_bloc.dart';
import '../../../models/user.dart';
import '../../app_routes.dart';

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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case LoginStatus.success:
            Navigator.pushReplacementNamed(context, AppRoute.home);
            break;
          case LoginStatus.failed:
            _showAlert(state.dialogMessage, context);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Username
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Username',
                    labelText: 'Username',
                    icon: Icon(Icons.email),
                  ),
                ),
                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Password',
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                ),
                // Login button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                        onPressed: state.status == LoginStatus.fetching
                            ? null
                            : () {
                                final username = _usernameController.text;
                                final password = _passwordController.text;
                                context.read<AuthBloc>().add(AuthEventLogin(User(username, password)));
                              },
                        child: Text("Login"));
                  },
                ),
                // Login button
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
                    OutlinedButton(
                      onPressed: () => context.read<CounterBloc>().add(CounterEventRemove()),
                      child: Icon(Icons.remove),
                    ),
                    BlocBuilder<CounterBloc, CounterState>(
                      builder: (context, state) {
                        return Text(
                          "${state.count1} : ${state.count2}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    OutlinedButton(
                      onPressed: () => context.read<CounterBloc>().add(CounterEventAdd()),
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
                // Set Button
                TextButton(
                  onPressed: () => context.read<CounterBloc>().add(CounterEventSet1(0)),
                  child: Text("Set1"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
 void _showAlert(String dialogMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dialogMessage),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}