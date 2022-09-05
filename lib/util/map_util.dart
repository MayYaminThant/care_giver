import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/hospitals+nearby/@$lat,$long,14z';

    await launchUrl(Uri.parse(googleUrl));
  }
}
