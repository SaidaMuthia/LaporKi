import 'package:flutter/material.dart';
import './user/report_detail.dart';
import './profile_pages.dart';

// --- HOME FRAGMENT ---
class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Halo,", style: TextStyle(fontSize: 16, color: Colors.black54)),
                  Text("Rahmat Hidayat!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"), // Placeholder Avatar
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Banner Biru
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                const Icon(Icons.campaign_outlined, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                const Text("Ada Masalah? Laporkan!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("Aduan Anda membantu menciptakan lingkungan yang lebih baik.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/report_permission'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Theme.of(context).primaryColor),
                  child: const Text("BUAT ADUAN BARU"),
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text("Status LaporanKu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              _statusCard("1", "Diproses", Colors.amber),
              const SizedBox(width: 10),
              _statusCard("5", "Selesai", Colors.green),
              const SizedBox(width: 10),
              _statusCard("0", "Ditolak", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
          ],
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