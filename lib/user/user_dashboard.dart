import 'package:flutter/material.dart';
import 'package:laporki/fragments.dart';
import './report_flow.dart'; // <-- BARU: Import alur laporan

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserDashboard(),
  ));
}

// ==========================================
// 1. UTAMA: USER DASHBOARD (NAVIGASI)
// ==========================================
class UserDashboard extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const UserDashboard({super.key, this.userData});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0; // Index halaman aktif

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeFragment(userData: widget.userData),
      const LaporankuFragment(),
      const NotificationFragment(),
      AccountFragment(userData: widget.userData),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung lebar layar untuk proporsi tombol navbar
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth / 5; 

    return Scaffold(
      backgroundColor: Colors.white,
      
      // BODY: Menampilkan halaman sesuai index yang dipilih
      body: _pages[_selectedIndex],

      // --- TOMBOL TENGAH (FAB) ---
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            // FIX: Navigasi ke halaman izin lokasi (awal alur laporan)
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const LocationPermissionPage())
            );
          },
          backgroundColor: const Color(0xFF005AC2), // Warna Biru Tema
          shape: const CircleBorder(),
          elevation: 4.0,
          child: const Icon(Icons.add_a_photo_outlined, size: 32, color: Colors.white),
        ),
      ),
      
      // Lokasi FAB di tengah dock
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Membuat lekukan
        notchMargin: 10.0, 
        color: Colors.white,
        elevation: 10,
        height: 80, // Tinggi navbar
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // KIRI (Beranda & Riwayat)
            Expanded(child: _buildNavItem(icon: Icons.home_rounded, label: "Beranda", index: 0)),
            Expanded(child: _buildNavItem(icon: Icons.assignment_rounded, label: "Laporanku", index: 1)),

            // TENGAH (Space Kosong untuk FAB)
            SizedBox(width: buttonWidth * 0.8), 

            // KANAN (Notifikasi & Akun)
            Expanded(child: _buildNavItem(icon: Icons.notifications_rounded, label: "Notifikasi", index: 2)),
            Expanded(child: _buildNavItem(icon: Icons.person_rounded, label: "Akun", index: 3)),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Item Navigasi
  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    final Color activeColor = const Color(0xFF005AC2);
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? activeColor : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : Colors.grey,
              fontSize: 11, 
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}