import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class FindUsController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  // Fungsi untuk mendapatkan lokasi pengguna
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Mengecek apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika layanan tidak aktif, tampilkan pesan kesalahan
      print("Location services are disabled.");
      return;
    }

    // Mengecek apakah izin lokasi diberikan
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print("Location permission denied.");
        return;
      }
    }

    // Mendapatkan posisi pengguna
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude.value = position.latitude;
    longitude.value = position.longitude;
  }
}
