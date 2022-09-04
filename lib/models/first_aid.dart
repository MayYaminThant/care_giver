import '../database/tables/first_aid_table.dart';

class FirstAid {
  final int? id;
  final String name;
  final String instruction;
  final String caution;
  final String? photo;

  FirstAid({
    this.id,
    required this.name,
    required this.instruction,
    required this.caution,
    this.photo,
  });

  FirstAid.fromJson(Map<dynamic, dynamic> json)
      : id = json[F_AID],
        name = json[F_NAME],
        instruction = json[F_INSTRUCTION],
        caution = json[F_CAUTION],
        photo = json[F_PHOTO];

  Map<String, dynamic> toJson() => {
        F_AID: id,
        F_NAME: name,
        F_INSTRUCTION: instruction,
        F_CAUTION: caution,
        F_PHOTO: photo,
      };
}
