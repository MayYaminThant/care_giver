import '../database/tables/alarm_table.dart';

class MyAlarm {
  final int? id;
  final int alarmTime;
  final int flag;

  MyAlarm({
    this.id,
    required this.alarmTime,
    required this.flag,
  });

  MyAlarm.fromJson(Map<dynamic, dynamic> json)
      : id = json[AL_ID],
        alarmTime = json[AL_TIME],
        flag = json[AL_FLAG];

  Map<String, dynamic> toJson() => {
        AL_ID: id,
        AL_TIME: alarmTime,
        AL_FLAG: flag,
      };
}
