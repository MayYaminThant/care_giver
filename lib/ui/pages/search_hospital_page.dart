import 'package:care_giver/util/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchHospitalPage extends StatefulWidget {
  const SearchHospitalPage({Key? key}) : super(key: key);

  @override
  State<SearchHospitalPage> createState() => _SearchHospitalPageState();
}

class _SearchHospitalPageState extends State<SearchHospitalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<MyLocation>(
                  future: LocationUtils.currentLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data != null) {
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(snapshot.data!.latitude,
                              snapshot.data!.longitude),
                          zoom: 14.4746,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ),
          Container(
            height: 180,
            padding: const EdgeInsets.all(16.0),
            child: getNearestHospital(),
          ),
        ],
      ),
    );
  }

  Table getNearestHospital() {
    List<TableRow> tableRows = [];
    for (var i = 0; i < 3; i++) {
      tableRows.add(
        TableRow(
          children: [
            _tableHeaderRow('1'),
            _tableHeaderRow('2'),
            _tableHeaderRow('3'),
          ],
        ),
      );
    }
    return Table(border: TableBorder.all(), children: [
      TableRow(children: [
        _tableHeaderRow('Hospital'),
        _tableHeaderRow('Phone'),
        _tableHeaderRow('Address'),
      ]),
      ...tableRows,
    ]);
  }

  Widget _tableHeaderRow(String name) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
