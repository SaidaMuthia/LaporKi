import 'package:flutter/material.dart';

// --- HOME ADMIN FRAGMENT (Berbeda dari User) ---
class HomeAdminFragment extends StatelessWidget {
  const HomeAdminFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 1. AppBar Admin
        SliverAppBar(
          pinned: true,
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Hapus panah back
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selamat Bekerja,", style: TextStyle(color: Colors.grey, fontSize: 16)),
              Text("Admin Kota!", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue[50],
                child: const Icon(Icons.admin_panel_settings, color: Color(0xFF005AC2)),
              ),
            ),
          ],
        ),

        // 2. Konten Dashboard Admin
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu Statistik Besar
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF005AC2), Color(0xFF007AD9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Total Laporan Masuk", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                SizedBox(height: 5),
                                Text("1,250", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text("+12 hari ini", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.bar_chart, color: Colors.white, size: 40),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    const Text("Tinjauan Cepat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    // Grid Status (Khusus Admin: Perlu Verifikasi, dll)
                    Row(
                      children: [
                        _buildAdminStatCard("Perlu Verifikasi", "15", Colors.orange.shade50, Colors.orange, Icons.warning_amber_rounded),
                        const SizedBox(width: 10),
                        _buildAdminStatCard("Sedang Diproses", "42", Colors.blue.shade50, Colors.blue, Icons.engineering),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildAdminStatCard("Selesai Bulan Ini", "128", Colors.green.shade50, Colors.green, Icons.task_alt),
                        const SizedBox(width: 10),
                        _buildAdminStatCard("Ditolak/Spam", "5", Colors.red.shade50, Colors.red, Icons.delete_outline),
                      ],
                    ),

                    const SizedBox(height: 25),
                    const Text("Laporan Terbaru Masuk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    
                    // List Singkat Laporan Baru
                    _buildIncomingReportItem("Jalan Berlubang di Jl. Sudirman", "Infrastruktur", "Baru saja"),
                    _buildIncomingReportItem("Lampu Merah Mati Simpang 5", "Dishub", "10 menit lalu"),
                    _buildIncomingReportItem("Sampah Liar di Bantaran Kali", "Lingkungan", "1 jam lalu"),
                    
                    const SizedBox(height: 80), // Padding bawah agar tidak ketutup navbar
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminStatCard(String title, String count, Color bg, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingReportItem(String title, String cat, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.report_problem_outlined, color: Colors.red),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(cat, style: const TextStyle(fontSize: 12, color: Colors.blue)),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time, size: 10, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
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