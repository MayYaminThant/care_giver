import '../database/tables/hospital_table.dart';

class Hospital {
  final int? id;
  final String hospitalName;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;

  Hospital({
    this.id,
    required this.hospitalName,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Hospital.fromJson(Map<dynamic, dynamic> json)
      : id = json[HS_ID],
        hospitalName = json[HS_NAME],
        phone = json[HS_PHONE],
        address = json[HS_ADDRESS],
        latitude = double.tryParse(json[HS_LATITUDE].toString()) ?? 0,
        longitude = double.tryParse(json[HS_LONGITUDE].toString()) ?? 0;

  Map<String, dynamic> toJson() => {
        HS_ID: id,
        HS_NAME: hospitalName,
        HS_PHONE: phone,
        HS_ADDRESS: address,
        HS_LATITUDE: latitude,
        HS_LONGITUDE: longitude,
      };
}
