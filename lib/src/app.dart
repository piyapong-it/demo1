import 'package:demo1/src/bloc/auth/auth_bloc.dart';
import 'package:demo1/src/bloc/counter/counter_bloc.dart';
import 'package:demo1/src/bloc/home/home_bloc.dart';
import 'package:demo1/src/bloc/management/management_bloc.dart';
import 'package:demo1/src/pages/app_routes.dart';
import 'package:demo1/src/pages/home/home_page.dart';
import 'package:demo1/src/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'bloc/management/management_bloc.dart';
import 'constants/network_api.dart';
import 'pages/loading/loading_page.dart';
import 'package:logger/logger.dart';

final navigatorState = GlobalKey<NavigatorState>();
final formatCurrency = NumberFormat('#,###.000');
final formatNumber = NumberFormat('#,###');

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    colors: true,
  ),
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc =
        BlocProvider<CounterBloc>(create: (context) => CounterBloc());
    final authBloc = BlocProvider<AuthBloc>(create: (context) => AuthBloc());
    final homeBloc = BlocProvider<HomeBloc>(create: (context) => HomeBloc());
    final managementBloc = BlocProvider<ManagementBloc>(create: (context) => ManagementBloc());

    return MultiBlocProvider(
      providers: [counterBloc, authBloc, homeBloc, managementBloc],
      child: MaterialApp(
        title: "CodeMobiles App",
        routes: AppRoute.all,
        home: _buildInitialPage(),
        navigatorKey: navigatorState,
      ),
    );
  }

  _buildInitialPage() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingPage();
        }

        // Check if previous state passed authentication?
        final prefs = snapshot.data!;
        final token = prefs.getString(NetworkAPI.token);
        return token == null ? LoginPage() : HomePage();
      },
    );
  }
}
