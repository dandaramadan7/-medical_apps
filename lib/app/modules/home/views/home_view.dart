import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/FindUsPage/views/find_us_page_view.dart'; // Import FindUsPage
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/modules/home/views/profile_view.dart';
import 'package:myapp/app/page/home_page.dart';
import 'package:myapp/app/modules/appointment/views/appointment_page.dart';
import 'package:myapp/app/page/ForumPage.dart';

class HomeView extends StatelessWidget {
  final HomeController audioController = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF5FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, Diddy’s!', style: TextStyle(fontSize: 18)),
            Text('How Are you today?', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Fungsi notifikasi di sini
            },
          ),
          IconButton(
            icon: const Icon(Icons.forum), // Ikon forum
            onPressed: () {
              Get.to(ForumPage());
            },
          ),
        ],
        backgroundColor: const Color(0xFFDDF5FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Berita kesehatan
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFA9D6EB),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'News portal \nfor your health',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Be Vietnam Pro'),
                ),
              ),
              const SizedBox(height: 20),

              // Spesialisasi dokter
              const Text(
                'Doctor Speciality',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSpecialityCircle('General'),
                  _buildSpecialityCircle('Neurologic'),
                  _buildSpecialityCircle('Pediatric'),
                  _buildSpecialityCircle('Radiology'),
                ],
              ),
              const SizedBox(height: 20),

              // Rekomendasi dokter
              const Text(
                'Recommendation Doctor',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDoctorCard('Dr. John Doe', 'Cardiologist'),
                  _buildDoctorCard('Dr. Jane Smith', 'Pediatrician'),
                ],
              ),
              const SizedBox(height: 20),

              // Audio relaksasi
              const Text(
                'Relaxing Audio',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Obx(() => Column(
                    children: [
                      Text(
                        audioController.position.value.inMinutes
                                .toString()
                                .padLeft(2, '0') +
                            ':' +
                            (audioController.position.value.inSeconds % 60)
                                .toString()
                                .padLeft(2, '0'),
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () {
                              audioController.playAudio(
                                  "https://firebasestorage.googleapis.com/v0/b/database-3d070.appspot.com/o/audio%2FRelaxing%20Music%20For%20Stress%20Relief.mp3?alt=media");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: audioController.pauseAudio,
                          ),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            onPressed: audioController.stopAudio,
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10),
                            onPressed: () {
                              audioController.seekAudio(
                                  audioController.position.value +
                                      const Duration(seconds: 10));
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: 20),

              // Tombol untuk membuka halaman lokasi (FindUsPage)
              ElevatedButton(
                onPressed: () {
                  Get.to(FindUsPage());  // Menavigasi ke FindUsPage
                },
                child: const Text('Find Us', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.healing),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF151855),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Get.to(HomePage());  // Halaman Utama
          } else if (index == 1) {
            Get.to(FindUsPage());  // Halaman Find Us
          } else if (index == 2) {
            Get.to(ProfileView()); // Halaman Profil
          }
        },
      ),
    );
  }

  Widget _buildSpecialityCircle(String text) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.local_hospital,
              color: Color(0xFF151855),
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDoctorCard(String name, String speciality) {
    return Card(
      child: SizedBox(
        height: 120,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/default_profile.png'),
          ),
          title: Text(name),
          subtitle: Text(speciality),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            // Navigasi ke detail dokter
          },
        ),
      ),
    );
  }
}
