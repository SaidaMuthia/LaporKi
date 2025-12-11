import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laporki/fragments.dart'; // Pastikan import ini ada
import 'report_draft.dart';
import 'report_flow.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  final ReportDraft _draft = ReportDraft();
  
  // Variabel untuk menyimpan data user
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Ambil data saat dashboard dibuka
  }

  // Fungsi mengambil data user dari Firestore berdasarkan UID login
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users') // Pastikan nama koleksi di Firebase Anda 'users'
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _userData = doc.data() as Map<String, dynamic>;
            // Pastikan email juga masuk (kadang di firestore tidak disimpan, jadi ambil dari Auth)
            if (_userData != null && !_userData!.containsKey('email')) {
              _userData!['email'] = user.email;
            }
          });
        }
      } catch (e) {
        debugPrint("Gagal mengambil data user: $e");
      }
    }
  }

  // Logika navigasi halaman dengan mengirim data _userData
  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomeFragment(userData: _userData); // Kirim data ke Home
      case 1:
        return const LaporankuFragment();
      case 2:
        return const NotificationFragment();
      case 3:
        return AccountFragment(userData: _userData); // Kirim data ke Akun
      default:
        return HomeFragment(userData: _userData);
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) { // Index tombol tengah (Buat Laporan)
       // Logika tombol tengah tetap sama
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationPermissionPage(draft: _draft)),
      );
    } else {
      setState(() {
        _selectedIndex = index > 2 ? index - 1 : index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Panggil fungsi helper untuk menampilkan halaman
      body: _getSelectedPage(_selectedIndex), 
      
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, "Beranda", 0),
              _buildNavItem(Icons.assignment, "LaporanKu", 1),
              const SizedBox(width: 48), // Spasi untuk FAB
              _buildNavItem(Icons.notifications, "Notifikasi", 2), // Index internal 2
              _buildNavItem(Icons.person, "Akun", 3), // Index internal 3
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2), // 2 adalah index tombol tengah
        backgroundColor: const Color(0xFF0055D4),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    // Penyesuaian index karena ada FAB di tengah
    int targetIndex = index > 1 ? index + 1 : index; 
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(targetIndex),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF0055D4) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0055D4) : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}