import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth untuk fallback email
// Pastikan path import ini sesuai
import 'package:laporki/admin/laporan_model.dart'; 
import 'package:laporki/user/report_detail.dart'; 
import 'package:laporki/profile_pages.dart';
import 'package:laporki/user/report_flow.dart'; 

// --- HOME FRAGMENT ---
class HomeFragment extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const HomeFragment({super.key, this.userData});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<Laporan> _laporanList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
  }

  // Logika Fetch Data Laporan
  Future<void> _fetchLaporan() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('laporan')
          .orderBy('createdAt', descending: true)
          .limit(10) 
          .get();

      List<Laporan> list = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Laporan(
          id: doc.id,
          judul: data['judul'] ?? 'Tanpa Judul',
          lokasi: data['lokasi'] ?? '-',
          detailLokasi: data['detailLokasi'] ?? '-',
          deskripsi: data['deskripsi'] ?? '-',
          kategori: data['kategori'] ?? 'Lainnya',
          jenis: data['jenis'] ?? 'Publik',
          pelapor: data['pelapor'] ?? '-',
          status: data['status'] ?? 'Menunggu',
          tanggal: _formatDate(data['createdAt'], data['tanggal']),
          statusColor: _getStatusColor(data['status']),
          imagePath: data['imagePath'] ?? data['foto'] ?? 'assets/images/placeholder.png',
        );
      }).toList();

      if (mounted) {
        setState(() {
          _laporanList = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatDate(dynamic createdAt, dynamic tanggalManual) {
    if (createdAt != null && createdAt is Timestamp) {
      return DateFormat('dd MMM yyyy').format(createdAt.toDate());
    }
    return tanggalManual?.toString() ?? '-';
  }

  Color _getStatusColor(String? status) {
    if (status == 'Selesai') return Colors.green;
    if (status == 'Ditolak') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    // SINKRONISASI NAMA DI SINI
    // Mengambil nama_lengkap dari database, jika null pakai 'User'
    final String nama = widget.userData?['nama_lengkap'] ?? 'User';
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false, 
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo,", style: TextStyle(color: Colors.grey, fontSize: 16)),
              // Nama user tampil di sini
              Text("$nama!", style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBanner(context),
                  const SizedBox(height: 20),
                  const Text("Status LaporanKu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildStatusRow(_laporanList),
                  const SizedBox(height: 20),
                  const Text("Laporan Terbaru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  if (_loading) 
                    const Center(child: CircularProgressIndicator())
                  else if (_laporanList.isEmpty)
                    const Center(child: Text("Belum ada laporan terbaru.", style: TextStyle(color: Colors.grey)))
                  else
                    Column(children: _laporanList.take(3).map((l) => _buildLaporanItem(context, l)).toList()),
                            
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // ... (Widget _buildBanner, _buildStatusRow, _buildStatusCard, _buildLaporanItem SAMA PERSIS SEPERTI SEBELUMNYA) ...
  // Copy dari kode sebelumnya agar tidak kepanjangan di sini, desain tetap sama.
  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0052CC), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const Icon(Icons.campaign, color: Colors.white, size: 48),
          const SizedBox(height: 10),
          const Text("Ada Masalah? Laporkan!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          const Text("Aduan Anda membantu menciptakan lingkungan yang lebih baik.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationPermissionPage())),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, minimumSize: const Size.fromHeight(40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: const Text("BUAT ADUAN BARU", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildStatusRow(List<Laporan> list) {
    int diproses = list.where((l) => l.status == 'Diproses' || l.status == 'Menunggu').length;
    int selesai = list.where((l) => l.status == 'Selesai').length;
    int ditolak = list.where((l) => l.status == 'Ditolak').length;
    return Row(
      children: [
        _buildStatusCard("Diproses", diproses, Colors.orange.shade50, Colors.orange, Icons.cached),
        _buildStatusCard("Selesai", selesai, Colors.green.shade50, Colors.green.shade700, Icons.check_circle_outline),
        _buildStatusCard("Ditolak", ditolak, Colors.red.shade50, Colors.red.shade700, Icons.cancel_outlined),
      ],
    );
  }

  Widget _buildStatusCard(String title, int count, Color bg, Color iconColor, IconData icon) {
    return Expanded(
      child: Card(
        color: bg, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, color: iconColor, size: 24), Text("$count", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]),
              const SizedBox(height: 5), Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaporanItem(BuildContext context, Laporan laporan) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReportDetailPage(laporan: laporan)));
      },
      child: Card(
        elevation: 2, margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(laporan.judul, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)), child: Text(laporan.kategori, style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 8),
                        Text("• ${laporan.status}", style: TextStyle(color: laporan.statusColor, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text("• ${laporan.tanggal}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
class LaporankuFragment extends StatefulWidget {
  const LaporankuFragment({super.key});

  @override
  State<LaporankuFragment> createState() => _LaporankuFragmentState();
}

class _LaporankuFragmentState extends State<LaporankuFragment> {
  // ... (Logika Laporanku sama persis seperti sebelumnya) ...
  // Saya persingkat di sini agar muat, gunakan kode LaporankuFragment dari jawaban sebelumnya
  // Intinya: Logic fetch data + TabBar UI
  List<Laporan> _laporanList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLaporanku();
  }

  Future<void> _fetchLaporanku() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('laporan').orderBy('createdAt', descending: true).get();
      List<Laporan> list = snapshot.docs.map((doc) {
         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
         return Laporan(
          id: doc.id,
          judul: data['judul'] ?? 'Tanpa Judul',
          lokasi: data['lokasi'] ?? '-',
          detailLokasi: data['detailLokasi'] ?? '-',
          deskripsi: data['deskripsi'] ?? '-',
          kategori: data['kategori'] ?? 'Lainnya',
          jenis: data['jenis'] ?? 'Publik',
          pelapor: data['pelapor'] ?? '-',
          status: data['status'] ?? 'Menunggu',
          tanggal: _formatDate(data['createdAt'], data['tanggal']),
          statusColor: _getStatusColor(data['status']),
          imagePath: data['imagePath'] ?? data['foto'] ?? 'assets/images/placeholder.png',
        );
      }).toList();
      if (mounted) setState(() { _laporanList = list; _loading = false; });
    } catch (e) { if (mounted) setState(() => _loading = false); }
  }

  String _formatDate(dynamic createdAt, dynamic tanggalManual) {
    if (createdAt != null && createdAt is Timestamp) return DateFormat('dd MMM yyyy').format(createdAt.toDate());
    return tanggalManual?.toString() ?? '-';
  }
  Color _getStatusColor(String? status) {
    if (status == 'Selesai') return Colors.green;
    if (status == 'Ditolak') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LaporanKu"),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [Tab(text: "Semua"), Tab(text: "Diproses"), Tab(text: "Selesai"), Tab(text: "Ditolak")],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildReportList(context, _laporanList),
                  _buildReportList(context, _laporanList.where((l) => l.status == 'Diproses' || l.status == 'Menunggu').toList()),
                  _buildReportList(context, _laporanList.where((l) => l.status == 'Selesai').toList()),
                  _buildReportList(context, _laporanList.where((l) => l.status == 'Ditolak').toList()),
                ],
              ),
      ),
    );
  }
  
  Widget _buildReportList(BuildContext context, List<Laporan> list) {
    if (list.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text("Belum ada laporan.", style: TextStyle(color: Colors.grey))));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final item = list[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportDetailPage(laporan: item))),
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
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)), child: Text(item.kategori, style: const TextStyle(color: Colors.blue, fontSize: 10))),
                    Text(item.tanggal, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(children: [Icon(Icons.circle, size: 10, color: item.statusColor), const SizedBox(width: 5), Text(item.status, style: TextStyle(color: item.statusColor, fontWeight: FontWeight.bold, fontSize: 12))]),
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
      appBar: AppBar(title: const Text("Notifikasi"), automaticallyImplyLeading: false),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          return ListTile(
            tileColor: i == 0 ? Colors.blue[50] : Colors.white,
            leading: CircleAvatar(backgroundColor: Colors.blue[100], child: const Icon(Icons.notifications, color: Colors.blue)),
            title: const Text("Laporan Anda Sedang Diproses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text("Laporan mengenai jalan rusak sedang ditinjau.", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
            trailing: const Text("2j lalu", style: TextStyle(fontSize: 10, color: Colors.grey)),
          );
        },
      ),
    );
  }
}

// --- ACCOUNT FRAGMENT ---
class AccountFragment extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const AccountFragment({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    // SINKRONISASI DATA AKUN DI SINI
    final String nama = userData?['nama_lengkap'] ?? 'User';
    final String email = userData?['email'] ?? FirebaseAuth.instance.currentUser?.email ?? 'user@email.com';

    return Scaffold(
      appBar: AppBar(title: const Text("Akun Saya"), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11")),
            const SizedBox(height: 15),
            
            // Nama user tampil di sini
            Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            
            // Email user tampil di sini
            Text(email, style: const TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 30),
            
            _menuItem(context, icon: Icons.person_outline, title: "Edit Profil", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()))),
            _menuItem(context, icon: Icons.info_outline, title: "Tentang Aplikasi", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TentangAplikasiPage()))),
            _menuItem(context, icon: Icons.privacy_tip_outlined, title: "Kebijakan Privasi", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KebijakanPrivasiPage()))),
            _menuItem(context, icon: Icons.description_outlined, title: "Syarat dan Ketentuan", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SyaratKetentuanPage()))),
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