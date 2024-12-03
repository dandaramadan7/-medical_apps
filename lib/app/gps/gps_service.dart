import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class GpsService extends GetxController {
  var currentLocation = Rx<Position?>(null);
  var currentAddress = Rx<String>("");

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
  }

  // Mengecek izin lokasi
  Future<void> checkPermissions() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      getCurrentLocation();
    } else {
      print("Permission denied");
    }
  }

  // Mendapatkan lokasi pengguna
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation.value = position;

    // Mendapatkan alamat dari latitude dan longitude
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    currentAddress.value =
        "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";
  }

  // Membuka Google Maps
  Future<void> openGoogleMaps() async {
    if (currentLocation.value != null) {
      final url =
          'https://www.google.com/maps?q=${currentLocation.value!.latitude},${currentLocation.value!.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print("Could not open Google Maps");
      }
    }
  }
}