import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap() async {
    String googleUrl = 'https://www.google.com/maps/search/hospitals nearby';

    await launchUrl(Uri.parse(googleUrl));
  }
}
