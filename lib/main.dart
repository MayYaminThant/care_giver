import 'package:care_giver/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

import 'database/tables/user_table.dart';
import 'models/users.dart';

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
  void initState() {
    super.initState();
    checkAndAddAdminUser();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: LoginPage()),
      debugShowCheckedModeBanner: false,
    );
  }

  void checkAndAddAdminUser() async {
    const String username = 'admin';
    const String password = 'admin';
    bool isExistUser = await UserTable.checkUserIsExist(username, password);
    if (!isExistUser) {
      UserTable.insert(MyUser(
          name: username,
          contact: 'info@talentexperts.com.mm',
          password: password));
    }
  }
}
