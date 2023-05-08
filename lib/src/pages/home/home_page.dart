import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Column(
        children: [
          Text("TAP"),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, "login");
          }, child: Text("GO")),
          SizedBox(),
        ],
      ),
    );
  }
}