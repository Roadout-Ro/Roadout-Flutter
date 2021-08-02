import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMapInGoogleMaps(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openMapInAppleMaps(double latitude, double longitude) async {
    String appleUrl = 'http://maps.apple.com/?ll=$latitude,$longitude&dirflg=d';
    if (await canLaunch(appleUrl)) {
      await launch(appleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openMapInWaze(double latitude, double longitude) async {
    String wazeUrl = 'https://www.waze.com/ul?ll=$latitude%2C-$longitude&navigate=yes&zoom=15';
    if (await canLaunch(wazeUrl)) {
      await launch(wazeUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

}
