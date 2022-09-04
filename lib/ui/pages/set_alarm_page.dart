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

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
