import 'package:flutter/material.dart';

// Model data dummy untuk Laporan
class Laporan {
  final String judul;
  final String kategori;
  final String status;
  final String tanggal;
  final Color statusColor;

  Laporan({
    required this.judul,
    required this.kategori,
    required this.status,
    required this.tanggal,
    required this.statusColor,
  });
}

// Data dummy
final List<Laporan> laporanList = [
  Laporan(
    judul: 'Jalan Rusak Parah di Depan SD Inpres Tamalanrea',
    kategori: 'Infrastruktur',
    status: 'Diproses',
    tanggal: '12 Mar',
    statusColor: Colors.orange,
  ),
  Laporan(
    judul: 'Jalan Rusak Parah di Depan SD Inpres Tamalanrea',
    kategori: 'Infrastruktur',
    status: 'Diproses',
    tanggal: '12 Mar',
    statusColor: Colors.orange,
  ),
  Laporan(
    judul: 'Sampah Menumpuk di Depan Pasar Panakukkang',
    kategori: 'Kebersihan',
    status: 'Selesai',
    tanggal: '12 Mar',
    statusColor: Colors.green,
  ),
  Laporan(
    judul: 'Sampah Menumpuk di Depan Pasar Panakukkang',
    kategori: 'Kebersihan',
    status: 'Selesai',
    tanggal: '12 Mar',
    statusColor: Colors.green,
  ),
];

// Admin Dashboard Utama
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor; 

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      
      // 1. AppBar Kustom (Rata Kiri)
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: Colors.transparent, 
        elevation: 0,
        toolbarHeight: 90, 
        
        // Teks Salam di Kiri Atas (Menggunakan Column di dalam title)
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
          // Ikon Lokasi/Logo Kanan Atas
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
      ),
      
      // 2. Body
      body: SingleChildScrollView(
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
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                return LaporanListItem(laporan: laporanList[index]);
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      
      // 3. BottomNavigationBar (Ditempatkan dengan benar, sejajar dengan body)
      bottomNavigationBar: const CustomBottomNavBar(),
      
    ); // Penutup Scaffold
  }
}


// --- Komponen-komponen Terpisah (SummaryCard, SummaryItem, LaporanListItem, CustomBottomNavBar) ---

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
              Icon(
                Icons.description,
                color: Colors.white,
                size: 28,
              ),
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
                  count: 1,
                  label: 'Laporan Baru',
                  color: Color(0xFFFFCC00), // Warna kuning untuk Baru
                  iconColor: Color(0xFFFFCC00),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: SummaryItem(
                  count: 1,
                  label: 'Laporan Diproses',
                  color: Color(0xFFFF9500), // Warna oranye untuk Diproses
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
  final Color color;
  final Color iconColor;

  const SummaryItem({
    super.key,
    required this.count,
    required this.label,
    required this.color,
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

class LaporanListItem extends StatelessWidget {
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
        Icon(
          Icons.circle,
          size: 8,
          color: color,
        ),
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
          // Aksi ketika item laporan ditekan
          debugPrint('Laporan ${laporan.judul} ditekan.');
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
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

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
        currentIndex: 0,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        onTap: (index) {
          // Navigasi admin (sesuaikan dengan rute Anda)
          debugPrint('Admin Navigasi ke index $index');
        },
      ),
    );
  }
}