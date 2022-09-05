import '../../database/tables/hospital_table.dart';
import '../../models/hospital.dart';
import '../../util/location_util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../util/map_util.dart';

class SearchHospitalPage extends StatefulWidget {
  const SearchHospitalPage({Key? key}) : super(key: key);

  @override
  State<SearchHospitalPage> createState() => _SearchHospitalPageState();
}

class _SearchHospitalPageState extends State<SearchHospitalPage> {
  List<Hospital> _hospitals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Hospital>>(
            future: HospitalTable.getAll(),
            builder: (context, historySnap) {
              if (historySnap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              return FutureBuilder<MyLocation>(
                future: LocationUtils.currentLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  _hospitals = historySnap.data!;

                  final markers = _hospitals
                      .map((e) => Marker(
                            markerId: MarkerId(e.hospitalName),
                            position: LatLng(
                              e.latitude,
                              e.longitude,
                            ),
                            infoWindow: InfoWindow(
                              title: e.hospitalName,
                            ),
                          ))
                      .toSet();

                  List<TableRow> tableRows = [];

                  historySnap.data!.sort(((a, b) {
                    final val1 = Geolocator.distanceBetween(
                      a.latitude,
                      a.longitude,
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    );
                    final val2 = Geolocator.distanceBetween(
                      b.latitude,
                      b.longitude,
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    );

                    return (val1 - val2).toInt();
                  }));

                  final maxLength = historySnap.data!.length > 3
                      ? 3
                      : historySnap.data!.length;

                  for (var i = 0; i < maxLength; i++) {
                    Hospital hospital = historySnap.data![i];
                    tableRows.add(
                      TableRow(
                        children: [
                          _tableChildRow(hospital.hospitalName),
                          _tableChildRow(hospital.phone),
                          _tableChildRow(hospital.address),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(snapshot.data!.latitude,
                                snapshot.data!.longitude),
                            zoom: 14.4746,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          markers: markers,
                        ),
                      ),
                      Container(
                        height: 180,
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          child: Table(border: TableBorder.all(), children: [
                            TableRow(children: [
                              _tableHeaderRow('Hospital'),
                              _tableHeaderRow('Phone'),
                              _tableHeaderRow('Address'),
                            ]),
                            ...tableRows,
                          ]),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MapUtils.openMap();
        },
        child: const Icon(Icons.search),
      ),
    );
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

  Widget _tableChildRow(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        name,
      ),
    );
  }
}
