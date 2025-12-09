import 'package:flutter/material.dart';
import './user/report_detail.dart';
import './profile_pages.dart';

// --- ENUM STATUS ---
enum StatusLaporan { diproses, selesai, ditolak, lainnya }

// --- HOME FRAGMENT ---
class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy
    final List<Map<String, dynamic>> daftarLaporan = const [
      { 'judul': "Jalan Rusak Parah di Depan SD Inpres Tamalanrea", 'kategori': 'Infrastruktur', 'status': StatusLaporan.diproses, 'tanggal': '12 Mar', },
      { 'judul': "Sampah Menumpuk di Depan Pasar Panakukkang", 'kategori': 'Kebersihan', 'status': StatusLaporan.selesai, 'tanggal': '12 Mar', },
      { 'judul': "Tumpahan Oli di Jalan Raya", 'kategori': 'Lainnya', 'status': StatusLaporan.ditolak, 'tanggal': '12 Mar', },
    ];

    return CustomScrollView(
      slivers: [
        // 1. AppBar Kustom (Sliver)
        SliverAppBar(
          pinned: true, 
          toolbarHeight: 80, 
          backgroundColor: Colors.white, 
          elevation: 0,
          centerTitle: false, // <--- PERUBAHAN: Menambahkan ini agar title rata kiri
          title: const Column( 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Halo,", style: TextStyle(color: Colors.grey, fontSize: 16)), // Warna abu
              Text("Nama User!", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)), // Ukuran besar
            ],
          ),
          actions: [ 
            Padding(
              padding: const EdgeInsets.only(right: 20.0), 
              child: Container( // Placeholder Logo/Icon
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, 
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on, // Icon Placeholder Logo
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),

        // 2. Konten List
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Pengaduan
                    _buildBanner(context),
                    
                    const SizedBox(height: 20),
                    
                    // Status LaporanKu
                    const Text("Status LaporanKu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    // Tiga Kartu Status
                    Row(
                      children: [
                        _buildStatusCard("Diproses", 1, Colors.orange.shade50, Colors.orange, Icons.cached),
                        _buildStatusCard("Selesai", 5, Colors.green.shade50, Colors.green.shade700, Icons.check_circle_outline),
                        _buildStatusCard("Ditolak", 0, Colors.red.shade50, Colors.red.shade700, Icons.cancel_outlined),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Laporan Terbaru
                    const Text("Laporan Terbaru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // List Laporan
                    Column(
                      children: daftarLaporan.map((laporan) => _buildLaporanItem(laporan)).toList(),
                    ),
                    
                    // Tambahan spasi di bawah agar tidak tertutup FAB
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0052CC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(Icons.campaign, color: Colors.white, size: 48),
          const SizedBox(height: 10),
          const Text("Ada Masalah? Laporkan!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          const Text("Aduan Anda membantu menciptakan lingkungan yang lebih baik.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () { debugPrint("BUAT ADUAN BARU diklik!"); },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, 
              minimumSize: const Size.fromHeight(40), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            ),
            child: const Text("BUAT ADUAN BARU", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, int count, Color backgroundColor, Color iconColor, IconData icon) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        color: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaporanItem(Map<String, dynamic> laporan) {
    final String judul = laporan['judul'];
    final String kategori = laporan['kategori'];
    final String tanggal = laporan['tanggal'];
    final StatusLaporan status = laporan['status'];
    
    Color statusColor;
    String statusText;
    Color tagBaseColor;

    switch (status) {
      case StatusLaporan.diproses: statusColor = Colors.orange; statusText = "Diproses"; break;
      case StatusLaporan.selesai: statusColor = Colors.green; statusText = "Selesai"; break;
      default: statusColor = Colors.red; statusText = "Ditolak"; break;
    }
    
    if (kategori == 'Kebersihan') {
      tagBaseColor = Colors.deepPurple;
    } else if (kategori == 'Lainnya') {
      tagBaseColor = Colors.grey;
    } else {
      tagBaseColor = Colors.blue;
    }

    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(judul, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: tagBaseColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text(kategori, style: TextStyle(color: tagBaseColor, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text("• $statusText", style: TextStyle(color: statusColor, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text("• $tanggal", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// --- LAPORANKU FRAGMENT ---
class LaporankuFragment extends StatelessWidget {
  const LaporankuFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LaporanKu"),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Semua"),
              Tab(text: "Diproses"),
              Tab(text: "Selesai"),
              Tab(text: "Ditolak"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReportList(context), // Semua
            _buildReportList(context, filter: "Diproses"),
            _buildReportList(context, filter: "Selesai"),
            _buildReportList(context, filter: "Ditolak"),
          ],
        ),
      ),
    );
  }

  Widget _buildReportList(BuildContext context, {String? filter}) {
    // Dummy Data
    final reports = [
      {"title": "Jalan Rusak Parah", "status": "Diproses", "color": Colors.amber, "cat": "Infrastruktur"},
      {"title": "Sampah Menumpuk", "status": "Selesai", "color": Colors.green, "cat": "Kebersihan"},
      {"title": "Lampu Jalan Mati", "status": "Ditolak", "color": Colors.red, "cat": "Infrastruktur"},
    ];

    final filtered = filter == null ? reports : reports.where((r) => r['status'] == filter).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (ctx, i) {
        final item = filtered[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportDetailPage())),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                      child: Text(item['cat'] as String, style: const TextStyle(color: Colors.blue, fontSize: 10)),
                    ),
                    Text("12 Mar 2024", style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: item['color'] as Color),
                    const SizedBox(width: 5),
                    Text(item['status'] as String, style: TextStyle(color: item['color'] as Color, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- NOTIFICATION FRAGMENT ---
class NotificationFragment extends StatelessWidget {
  const NotificationFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          return ListTile(
            tileColor: i == 0 ? Colors.blue[50] : Colors.white, // Highlight unread
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.notifications, color: Colors.blue),
            ),
            title: const Text("Laporan Anda Sedang Diproses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text("Laporan mengenai jalan rusak di Jl. Merpati sedang ditinjau oleh petugas.", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
            trailing: const Text("2j lalu", style: TextStyle(fontSize: 10, color: Colors.grey)),
          );
        },
      ),
    );
  }
}

// --- ACCOUNT FRAGMENT ---
class AccountFragment extends StatelessWidget {
  const AccountFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Akun Saya")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11")),
            const SizedBox(height: 15),
            const Text("Rahmat Hidayat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("rahmat.hidayat@email.com", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _menuItem(context, icon: Icons.person_outline, title: "Edit Profil", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()))),
            _menuItem(context, icon: Icons.lock_outline, title: "Ganti Kata Sandi"),
            _menuItem(context, icon: Icons.settings_outlined, title: "Pengaturan"),
            _menuItem(context, icon: Icons.help_outline, title: "Pusat Bantuan"),
            const Divider(),
            _menuItem(context, icon: Icons.logout, title: "Keluar", color: Colors.red, onTap: () => Navigator.pushReplacementNamed(context, '/login')),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, {required IconData icon, required String title, Color color = Colors.black, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color)),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}