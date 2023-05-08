import 'package:flutter/material.dart';

class SQLitePage extends StatefulWidget {
  const SQLitePage({super.key});

  @override
  State<SQLitePage> createState() => _SQLitePageState();
}

class _SQLitePageState extends State<SQLitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLitePage"),
      ),
      body: SizedBox(),
    );
  }
}