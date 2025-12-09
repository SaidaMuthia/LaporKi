import 'package:flutter/material.dart';
import 'package:laporki/user/report_flow.dart'; // Pastikan path benar
import 'package:laporki/fragments.dart'; // Import halaman fragment

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;

  // Daftar Halaman
  final List<Widget> _pages = [
    const HomeFragment(),       
    const LaporankuFragment(),    
    const NotificationFragment(), 
    const AccountFragment(),    
  ];

  @override
  void initState() {
    super.initState();
    // --- SOLUSI FAB TERBANG ---
    // Setiap kali halaman ini dibuka (misal setelah kirim laporan),
    // kita paksa hapus SnackBar agar tombol biru TIDAK terdorong ke atas.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kita gunakan LayoutBuilder untuk memastikan proporsi tombol pas di semua layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth / 5; // Bagi 5 area (4 menu + 1 tombol tengah)

    return Scaffold(
      // Tubuh halaman
      body: _pages[_currentIndex],

      // --- TOMBOL TENGAH (FAB) ---
      floatingActionButton: SizedBox(
        height: 70, 
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LocationPermissionPage()),
            );
          },
          backgroundColor: const Color(0xFF005AC2), // Warna Biru Tema
          shape: const CircleBorder(),
          elevation: 4.0,
          child: const Icon(Icons.add_a_photo_outlined, size: 32, color: Colors.white),
        ),
      ),
      
      // Lokasi tombol di tengah dock
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- NAVIGATION BAR ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Lekukan di belakang tombol biru
        notchMargin: 10.0, 
        color: Colors.white,
        elevation: 10,
        height: 70,
        padding: EdgeInsets.zero, // Hapus padding bawaan agar Expanded bekerja full
        child: Row(
          children: [
            // --- KIRI (Beranda & Riwayat) ---
            // Gunakan Expanded agar lebar tombol SAMA PERSIS (Simetris)
            Expanded(
              child: _buildNavItem(icon: Icons.home_rounded, label: "Beranda", index: 0),
            ),
            Expanded(
              child: _buildNavItem(icon: Icons.history_rounded, label: "Riwayat", index: 1),
            ),

            // --- TENGAH (Space untuk Tombol Biru) ---
            // Kita berikan lebar fix yang sama dengan tombol lain agar simetris
            SizedBox(width: buttonWidth * 0.8), // Sedikit lebih kecil dari buttonWidth agar ikon menu tidak terlalu jauh

            // --- KANAN (Notifikasi & Akun) ---
            Expanded(
              child: _buildNavItem(icon: Icons.notifications_rounded, label: "Notifikasi", index: 2),
            ),
            Expanded(
              child: _buildNavItem(icon: Icons.person_rounded, label: "Akun", index: 3),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper Item Navigasi (Disederhanakan untuk Simetris)
  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _currentIndex == index;
    final Color activeColor = const Color(0xFF005AC2);
    
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      // Efek ripple saat diklik tetap bulat/kotak sesuai selera, disini default
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
              fontSize: 11, // Ukuran font disamakan agar tidak ada yang "kelebaran"
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}