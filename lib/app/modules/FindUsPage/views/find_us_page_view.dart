import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Package untuk mengambil lokasi
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Package untuk membuka aplikasi lainnya seperti Google Maps

class FindUsPage extends StatefulWidget {
  const FindUsPage({Key? key}) : super(key: key);

  @override
  _FindUsPageState createState() => _FindUsPageState();
}

class _FindUsPageState extends State<FindUsPage> {
  String _latitude = '0.0';
  String _longitude = '0.0';
  String _message = 'Titik Koordinat Anda Sekarang';
  List<Map<String, String>> nearbyHospitals = [];

  // Daftar rumah sakit terdekat yang ditambahkan secara manual
  final List<Map<String, String>> hospitalList = [
    {"name": "Rumah Sakit Universitas Muhammadiyah Malang", "address": "Jl. Raya Tlogomas No. 45", "latitude": "-7.926004", "longitude": "112.599248"},
    {"name": "UMM Medical Centre", "address": "Jl. Bendungan Sutami No. 318", "latitude": "-7.958015", "longitude": "112.613329"},
    {"name": "Poliklinik UMM", "address": "Jl. Raya Tlogomas No. 246", "latitude": "-7.921412", "longitude": "112.595901"},
  ];

  // Fungsi untuk mendapatkan lokasi
  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _message = 'Location services are disabled.';
      });
      return;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _message = 'Location permissions are denied';
        });
        return;
      }
    }

    // Cek izin lokasi permanen
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _message = 'Location permissions are permanently denied';
      });
      return;
    }

    // Ambil lokasi
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      _message = 'Latitude: $_latitude, Longitude: $_longitude';
    });
  }

  // Fungsi untuk menampilkan daftar rumah sakit terdekat
  void _findNearbyHospitals() {
    setState(() {
      nearbyHospitals = hospitalList; // Menampilkan rumah sakit dari list yang telah disiapkan
    });
  }

  // Fungsi untuk membuka lokasi rumah sakit di Google Maps
  void _openGoogleMaps(String latitude, String longitude) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Us')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Cari Lokasi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _findNearbyHospitals,
              child: const Text('Cari Rumah Sakit Terdekat'),
            ),
            const SizedBox(height: 20),
            if (nearbyHospitals.isNotEmpty)
              Column(
                children: nearbyHospitals.map((hospital) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(hospital['name'] ?? 'Unknown'),
                      subtitle: Text(hospital['address'] ?? 'No address'),
                      trailing: IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: () {
                          // Mengambil latitude dan longitude dari hospital yang dipilih
                          String latitude = hospital['latitude'] ?? '0.0';
                          String longitude = hospital['longitude'] ?? '0.0';
                          // Membuka Google Maps dengan koordinat rumah sakit
                          _openGoogleMaps(latitude, longitude);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
