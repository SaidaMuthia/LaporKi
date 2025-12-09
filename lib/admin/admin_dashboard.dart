import 'package:flutter/material.dart';
import 'admin_state.dart'; 
// Import model data tunggal
import 'laporan_model.dart'; 
// Import Halaman Admin
import 'laporan_admin_page.dart';
import 'notifikasi_admin_page.dart'; 
import 'akun_admin_page.dart'; 
import 'laporan_admin_page.dart';

// --- 1. ADMIN DASHBOARD UTAMA (CONTROLLER) ---

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  final List<Widget> _pages = const [
    AdminHomePage(),         // 0: Beranda
    LaporanAdminPage(),      // 1: Laporan
    NotifikasiAdminPage(),   // 2: Notifikasi 
    AkunAdminPage(),         // 3: Akun 
  ];

  // Widget untuk AppBar kustom yang hanya muncul di Halaman Beranda
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return AppBar(
      automaticallyImplyLeading: false, 
      backgroundColor: Colors.transparent, 
      elevation: 0,
      toolbarHeight: 90, 
      
      title: Padding(
        padding: const EdgeInsets.only(left: 0, top: 20.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: const [
            Text(
              'Halo,', 
              style: TextStyle(
                color: Colors.black54, 
                fontSize: 24,
              ),
            ),
            Text(
              'Nama Admin!', 
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      centerTitle: false, 
      titleSpacing: 16.0, 

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 10.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor, 
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined, 
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndexNotifier,
      builder: (context, currentIndex, child) {
        return Scaffold(
          // Hanya tampilkan AppBar kustom di halaman Beranda (index 0)
          appBar: currentIndex == 0 
              ? _buildCustomAppBar(context) 
              : null,
          
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
          
          // IndexedStack menampilkan halaman sesuai index
          body: IndexedStack(
            index: currentIndex,
            children: _pages,
          ),
          
          // Bottom Navigation Bar
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex, 
            onTap: (index) {
              selectedIndexNotifier.value = index; // Update index
            },
          ),
        );
      },
    );
  }
}

// --- 2. ADMIN HOME PAGE (KONTEN BERANDA) ---

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil 4 laporan terbaru untuk tampilan beranda
    final List<Laporan> latestLaporan = laporanList.take(4).toList(); 
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20), 
          
          // Ringkasan Laporan Hari Ini (SummaryCard)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SummaryCard(),
          ),
          
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Laporan Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          
          // Daftar Laporan
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: latestLaporan.length,
            itemBuilder: (context, index) {
              return LaporanListItem(laporan: latestLaporan[index]);
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// --- 3. KOMPONEN LAINNYA (SummaryCard, LaporanListItem, CustomBottomNavBar) ---

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.description, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'Rangkuman Laporan Hari Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: SummaryItem(
                  count: 1, // Ganti dengan logika penghitungan data riil
                  label: 'Laporan Baru',
                  iconColor: Color(0xFFFFCC00), 
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: SummaryItem(
                  count: 1, // Ganti dengan logika penghitungan data riil
                  label: 'Laporan Diproses',
                  iconColor: Color(0xFFFF9500), 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final int count;
  final String label;
  final Color iconColor; // Hapus properti 'color' yang tidak terpakai

  const SummaryItem({
    super.key,
    required this.count,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Text(
            '$count',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// LaporanListItem ini menggunakan model Laporan dari laporan_model.dart.
// Note: Widget ini seharusnya hanya menampilkan judul, kategori, status, dan tanggal di Beranda,
// tapi saya menggunakan versi lengkapnya agar konsisten dengan file Laporan Admin Anda.

class LaporanListItem extends StatelessWidget {
  // FINAL PENTING: Pindahkan semua required parameter ke constructor.
  final Laporan laporan;

  const LaporanListItem({super.key, required this.laporan});

  Widget _buildCategoryBadge(String kategori, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        kategori,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 5),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          debugPrint('Laporan ${laporan.judul} ditekan. (Navigasi ke Detail)');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      laporan.judul,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        _buildCategoryBadge(laporan.kategori, context),
                        const SizedBox(width: 12),
                        _buildStatusBadge(laporan.status, laporan.statusColor),
                        const SizedBox(width: 12),
                        Text(
                          '• ${laporan.tanggal}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override 
  Widget build(BuildContext context) { 
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: currentIndex, 
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: 'Akun'),
        ],
        onTap: onTap, 
      ),
    );
  }
}