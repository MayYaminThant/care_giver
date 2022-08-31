import 'package:care_giver/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyMainCareDiver());
}

class MyMainCareDiver extends StatefulWidget {
  const MyMainCareDiver({Key? key}) : super(key: key);

  @override
  State<MyMainCareDiver> createState() => _MyMainCareDiverState();
}

class _MyMainCareDiverState extends State<MyMainCareDiver> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: LoginPage()),
      debugShowCheckedModeBanner: false,
    );
  }
}