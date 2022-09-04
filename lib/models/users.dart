import '../database/tables/user_table.dart';

class MyUser {
  final int? id;
  final String name;
  final String contact;
  final String password;

  MyUser({
    this.id,
    required this.name,
    required this.contact,
    required this.password,
  });

  MyUser.fromJson(Map<dynamic, dynamic> json)
      : id = json[U_ID],
        name = json[U_NAME],
        contact = json[U_CONTACT],
        password = json[U_PASSWORD];

  Map<String, dynamic> toJson() => {
        U_ID: id,
        U_NAME: name,
        U_CONTACT: contact,
        U_PASSWORD: password,
      };
}
