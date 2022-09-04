import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import '../../database/tables/alarm_table.dart';
import '../../models/alarms.dart';
import '../../util/my_date_util.dart';

class AlarmsPage extends StatefulWidget {
  const AlarmsPage({Key? key}) : super(key: key);

  @override
  State<AlarmsPage> createState() => _AlarmsPageState();
}

class _AlarmsPageState extends State<AlarmsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
      ),
      body: _alarmList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final current = DateTime.now();

          Navigator.of(context).push(
            showPicker(
              context: context,
              value: TimeOfDay(hour: current.hour, minute: current.minute),
              onChange: (TimeOfDay value) async {
                await AlarmTable.insert(
                  MyAlarm(
                    alarmTime: DateTime(2022, 1, 1, value.hour, value.minute)
                        .millisecondsSinceEpoch,
                    flag: 1,
                  ),
                );

                final alarm = (await AlarmTable.getAll()).last;

                _createAlarm(
                  id: alarm.id!,
                  hour: value.hour,
                  minute: value.minute,
                );

                setState(() {});
              },
            ),
          );
        },
        tooltip: 'Add New Alarm',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _alarmList() {
    return FutureBuilder<List<MyAlarm>>(
      future: AlarmTable.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          itemCount: (snapshot.data ?? []).length,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 200),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return _alarmTile(snapshot.data![index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        );
      },
    );
  }

  Widget _alarmTile(MyAlarm alarm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                MyDateUtils.alarmDateFormat(
                    DateTime.fromMillisecondsSinceEpoch(alarm.alarmTime)),
              ),
            ),
            Switch(
              value: alarm.flag == 1,
              onChanged: (bool value) async {
                await AlarmTable.update(
                  MyAlarm(
                    id: alarm.id,
                    alarmTime: alarm.alarmTime,
                    flag: value ? 1 : 0,
                  ),
                );

                if (value) {
                  final d = DateTime.fromMillisecondsSinceEpoch(
                    alarm.alarmTime,
                  );

                  _createAlarm(
                    id: alarm.id!,
                    hour: d.hour,
                    minute: d.minute,
                  );
                } else {
                  await _cancelAlarm(alarm.id!);
                }

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createAlarm({
    required final int id,
    required final int hour,
    required final int minute,
  }) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'scheduled',
            title: 'Alarm',
            body: 'Take Medicine',
            wakeUpScreen: true,
            category: NotificationCategory.Alarm,
            criticalAlert: true,
          ),
          schedule: NotificationCalendar(
            hour: hour,
            minute: minute,
            second: 1,
            repeats: true, // for every day
            allowWhileIdle: true, // do background
            preciseAlarm: true, // exactly hour and min
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'close',
              label: 'Close',
              buttonType:
                  ActionButtonType.DisabledAction, // without opening the app
            ),
          ],
        );
      }
    });
  }

  Future<void> _cancelAlarm(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
