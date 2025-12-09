import 'package:flutter/material.dart';
import 'package:laporki/admin/laporan_admin_page.dart';
import 'package:laporki/admin/laporan_model.dart';

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

// --- LAPORAN ADMIN FRAGMENT (Manajemen Laporan) ---
class LaporanAdminFragment extends StatelessWidget {
  const LaporanAdminFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manajemen Laporan"),
          automaticallyImplyLeading: false, // Hapus panah back
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color(0xFF005AC2),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF005AC2),
            tabs: [
              Tab(text: "Masuk"),
              Tab(text: "Diproses"),
              Tab(text: "Selesai"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(status: "Menunggu"),
            _buildList(status: "Diproses"),
            _buildList(status: "Selesai"),
          ],
        ),
      ),
    );
  }

  Widget _buildList({required String status}) {
    // Dummy Data Admin
    final reports = List.generate(5, (index) => {
      "title": "Laporan Contoh #$index",
      "desc": "Deskripsi singkat masalah yang dilaporkan oleh warga...",
      "loc": "Kec. Tamalanrea",
      "date": "12 Mar"
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final item = reports[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200)
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                      child: Text("Infrastruktur", style: TextStyle(color: Colors.blue[800], fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Text(item['date']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(item['desc']!, style: const TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(item['loc']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () { /* Buka Detail Admin */ },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005AC2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                        child: const Text("Tindak Lanjut", style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    )
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


// --- NOTIFICATION FRAGMENT (SAMA PERSIS DENGAN USER) ---
class NotificationFragment extends StatelessWidget {
  const NotificationFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          return ListTile(
            tileColor: i == 0 ? Colors.blue[50] : Colors.white,
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.notifications, color: Colors.blue),
            ),
            title: const Text("Sistem Admin Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text("Ada laporan baru yang memerlukan verifikasi segera.", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
            trailing: const Text("Baru saja", style: TextStyle(fontSize: 10, color: Colors.grey)),
          );
        },
      ),
    );
  }
}

// --- ACCOUNT FRAGMENT (SAMA PERSIS DENGAN USER) ---
class AccountFragment extends StatelessWidget {
  const AccountFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun Admin"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12")), // Gambar beda dikit biar tau ini admin
            const SizedBox(height: 15),
            const Text("Admin Utama", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("admin@laporki.go.id", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _menuItem(context, icon: Icons.person_outline, title: "Edit Profil"),
            _menuItem(context, icon: Icons.lock_outline, title: "Ganti Kata Sandi"),
            _menuItem(context, icon: Icons.settings_outlined, title: "Pengaturan Sistem"),
            const Divider(),
            _menuItem(context, icon: Icons.logout, title: "Keluar", color: Colors.red, onTap: () {
               // Logika logout admin
               Navigator.pushReplacementNamed(context, '/login'); 
            }),
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