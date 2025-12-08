import 'package:flutter/material.dart';
import 'package:laporki/user/report_flow.dart'; // Import alur laporan
import 'package:laporki/fragments.dart'; // Import halaman-halaman (Home, History, dll)
import 'package:laporki/profile_pages.dart'; // Import halaman profil jika terpisah

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;

  // Daftar Halaman untuk Tab Bar
  final List<Widget> _pages = [
    const HomeFragment(),       // Index 0: Beranda
    const LaporankuFragment(),    // Index 1: Riwayat Laporan
    const NotificationFragment(), // Index 2: Notifikasi
    const AccountFragment(),    // Index 3: Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai index yang dipilih
      body: _pages[_currentIndex],

      // 1. TOMBOL LAPOR (Tengah & Biru)
      floatingActionButton: SizedBox(
        height: 70, // Ukuran tombol lebih besar
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            // Aksi: Buka halaman Laporan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LocationPermissionPage()),
            );
          },
          backgroundColor: const Color(0xFF0055D4), // Warna Biru Utama
          shape: const CircleBorder(), // Bentuk bulat sempurna
          elevation: 4.0,
          // Icon Kamera/Tambah Laporan
          child: const Icon(Icons.add_a_photo_outlined, size: 32, color: Colors.white),
        ),
      ),
      
      // 2. Posisi Tombol: Di tengah & menempel di dock bawah
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 3. NAVIGATION BAR (BottomAppBar)
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Membuat lekukan untuk tombol
        notchMargin: 10.0, // Jarak antara tombol dan bar
        color: Colors.white,
        elevation: 10,
        height: 70, // Tinggi Navbar
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // --- KIRI ---
            _buildNavItem(icon: Icons.home_rounded, label: "Beranda", index: 0),
            _buildNavItem(icon: Icons.history_rounded, label: "LaporanKu", index: 1),

            // SPASI KOSONG DI TENGAH (Untuk tempat tombol biru)
            const SizedBox(width: 40),

            // --- KANAN ---
            _buildNavItem(icon: Icons.notifications_rounded, label: "Notifikasi", index: 2),
            _buildNavItem(icon: Icons.person_rounded, label: "Akun", index: 3),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk membuat item navigasi agar kodenya rapi
  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _currentIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0055D4) : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF0055D4) : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}