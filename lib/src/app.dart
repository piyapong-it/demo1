import 'package:demo1/src/bloc/auth/auth_bloc.dart';
import 'package:demo1/src/bloc/counter/counter_bloc.dart';
import 'package:demo1/src/pages/app_routes.dart';
import 'package:demo1/src/pages/home/home_page.dart';
import 'package:demo1/src/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc =
        BlocProvider<CounterBloc>(create: (context) => CounterBloc());
    final authBloc = BlocProvider<AuthBloc>(create: (context) => AuthBloc());

    return MultiBlocProvider(
      providers: [counterBloc, authBloc],
      child: MaterialApp(
        title: "CodeMobiles App",
        routes: AppRoute.all,
        home: _buildInitialPage(),
      ),
    );
  }

  _buildInitialPage() async {
    final prefs = await SharedPreferences.getInstance();
    return LoginPage();
  }
}
