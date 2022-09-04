import 'package:care_giver/database/tables/hospital_table.dart';
import 'package:care_giver/models/hospital.dart';
import 'package:care_giver/util/location_util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<MyLocation>(
            future: LocationUtils.currentLocation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                return Column(
                  children: [
                    Expanded(
                        child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            snapshot.data!.latitude, snapshot.data!.longitude),
                        zoom: 14.4746,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    )),
                    Container(
                      height: 180,
                      margin: const EdgeInsets.only(top: 16),
                      child: getNearestHospital(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget getNearestHospital(currentLatitude, currentLongitude) {
    return FutureBuilder<List<Hospital>>(
        future: HospitalTable.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            List<TableRow> tableRows = [];

            snapshot.data!.sort(((a, b) {
              final val1 = Geolocator.distanceBetween(
                a.latitude.toDouble(),
                a.longitude.toDouble(),
                currentLatitude,
                currentLatitude,
              );
              final val2 = Geolocator.distanceBetween(
                b.latitude.toDouble(),
                b.longitude.toDouble(),
                currentLatitude,
                currentLatitude,
              );

              return (val1 - val2).toInt();
            }));

            for (var i = 0; i < 3; i++) {
              Hospital hospital = snapshot.data!.elementAt(i);
              tableRows.add(
                TableRow(
                  children: [
                    _tableChildRow(hospital.hospitalName),
                    _tableChildRow(hospital.phone),
                    _tableChildRow(hospital.address),
                    // _tableHeaderRow(Geolocator.distanceBetween(
                    //   hospital.latitude.toDouble(),
                    //   hospital.longitude.toDouble(),
                    //   currentLatitude,
                    //   currentLatitude,
                    // ).toString()),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              child: Table(border: TableBorder.all(), children: [
                TableRow(children: [
                  _tableHeaderRow('Hospital'),
                  _tableHeaderRow('Phone'),
                  _tableHeaderRow('Address'),
                  // _tableHeaderRow('Distance'),
                ]),
                ...tableRows,
              ]),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
