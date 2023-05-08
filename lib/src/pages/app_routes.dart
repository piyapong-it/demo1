
import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'loading/loading_page.dart';
import 'login/login_page.dart';
import 'management/management_page.dart';
import 'map/map_page.dart';
import 'sqlite/sqlite_page.dart';

class AppRoute {
  static const home = 'home';
  static const login = 'login';
  static const management = 'management';
  static const map = 'map';
  static const loading = 'loading';
  static const sqlite = 'sqlite';

  static get all => <String, WidgetBuilder>{
        login: (context) => const LoginPage(), // demo how to used widget
        home: (context) => const HomePage(),
        management: (context) => const ManagementPage(),
        map: (context) => const MapPage(),
        loading: (context) => const LoadingPage(),
        sqlite: (context) => const SQLitePage(),
      };
}