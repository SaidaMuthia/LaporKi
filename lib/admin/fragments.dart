import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Pastikan path import ini sesuai dengan project Anda
import 'package:laporki/admin/laporan_model.dart';
import 'package:laporki/admin/detail_laporan_screen.dart';
import 'package:laporki/profile_pages.dart'; 

// ===============================================
// 1. ADMIN HOME FRAGMENT (DASHBOARD)
// ===============================================
class AdminHomePage extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const AdminHomePage({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    // Stream User Data untuk Nama di Header
    final user = FirebaseAuth.instance.currentUser;
    
    return StreamBuilder<DocumentSnapshot>(
      stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots() : null,
      builder: (context, userSnapshot) {
        String nama = userData?['nama_lengkap'] ?? 'Admin';
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final data = userSnapshot.data!.data() as Map<String, dynamic>;
          nama = data['nama_lengkap'] ?? nama;
        }

        // Stream Laporan Utama
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('laporan').orderBy('createdAt', descending: true).snapshots(),
          builder: (context, snapshot) {
            List<Laporan> laporanList = [];
            if (snapshot.hasData) {
              laporanList = snapshot.data!.docs.map((doc) {
                return _mapToLaporan(doc.id, doc.data() as Map<String, dynamic>);
              }).toList();
            }

            final List<Laporan> latestLaporan = laporanList.take(5).toList();

            return CustomScrollView(
              slivers: [
                // Header / AppBar
                SliverAppBar(
                  pinned: true,
                  toolbarHeight: 80,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Selamat Datang,", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text(nama, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0055D4).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.admin_panel_settings, color: Color(0xFF0055D4), size: 24),
                      ),
                    ),
                  ],
                ),

                // Konten Dashboard
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kartu Ringkasan
                          SummaryCard(laporanList: laporanList),
                          const SizedBox(height: 25),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Laporan Terbaru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              if (laporanList.isNotEmpty)
                                TextButton(onPressed: (){
                                  // Navigasi opsional ke tab laporan (jika pakai Controller tab)
                                }, child: const Text("Lihat Semua")),
                            ],
                          ),
                          const SizedBox(height: 10),

                          if (!snapshot.hasData)
                            const Center(child: CircularProgressIndicator())
                          else if (latestLaporan.isEmpty)
                            const Center(child: Text("Belum ada laporan masuk.", style: TextStyle(color: Colors.grey)))
                          else
                            Column(children: latestLaporan.map((l) => _buildLaporanItem(context, l)).toList()),
                          
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            );
          },
        );
      }
    );
  }
}

// ===============================================
// 2. LAPORAN ADMIN FRAGMENT (FILTER)
// ===============================================
class LaporanAdminPage extends StatefulWidget {
  const LaporanAdminPage({super.key});

  @override
  State<LaporanAdminPage> createState() => _LaporanAdminPageState();
}

class _LaporanAdminPageState extends State<LaporanAdminPage> {
  bool _showFilter = false;
  String _searchQuery = "";

  void _toggleFilter() {
    setState(() => _showFilter = !_showFilter);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kelola Laporan", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF0055D4),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF0055D4),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Semua"),
              Tab(text: "Baru"),
              Tab(text: "Diproses"),
              Tab(text: "Selesai"),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                _LaporanListStream(filterStatus: null, searchQuery: _searchQuery),
                _LaporanListStream(filterStatus: 'Baru', searchQuery: _searchQuery),
                _LaporanListStream(filterStatus: 'Diproses', searchQuery: _searchQuery),
                _LaporanListStream(filterStatus: 'Selesai', searchQuery: _searchQuery),
              ],
            ),
            
            // Search Bar
            Positioned(
              top: 10, left: 16, right: 16,
              child: SearchAndFilterBar(
                onFilterPressed: _toggleFilter,
                onSearchChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              ),
            ),

            if (_showFilter)
              Positioned(
                top: 70, right: 16, left: 16,
                child: FilterPopupCard(onClose: _toggleFilter),
              ),
          ],
        ),
      ),
    );
  }
}

class _LaporanListStream extends StatelessWidget {
  final String? filterStatus;
  final String searchQuery;
  const _LaporanListStream({this.filterStatus, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // TIPS: Gunakan order manual jika query complex belum diindex
    Query query = FirebaseFirestore.instance.collection('laporan');
    if (filterStatus != null) {
      query = query.where('status', isEqualTo: filterStatus);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState("Tidak ada data laporan.");
        }

        // 1. Ambil Data
        var docs = snapshot.data!.docs;

        // 2. Sorting Manual (CreatedAt Descending)
        // Ini menghindari error "Missing Index" di Firestore
        docs.sort((a, b) {
          final t1 = a['createdAt'] as Timestamp?;
          final t2 = b['createdAt'] as Timestamp?;
          if (t1 == null || t2 == null) return 0;
          return t2.compareTo(t1); // Descending (Terbaru di atas)
        });

        // 3. Filter Search (Lokal)
        final filteredDocs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final judul = (data['judul'] ?? '').toString().toLowerCase();
          return judul.contains(searchQuery);
        }).toList();

        if (filteredDocs.isEmpty) return _buildEmptyState("Laporan tidak ditemukan.");

        return ListView.builder(
          padding: const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 16),
          itemCount: filteredDocs.length,
          itemBuilder: (ctx, i) {
            final doc = filteredDocs[i];
            final laporan = _mapToLaporan(doc.id, doc.data() as Map<String, dynamic>);
            return _buildLaporanItem(context, laporan);
          },
        );
      },
    );
  }
}

// ===============================================
// 3. NOTIFICATION FRAGMENT (PERBAIKAN FITUR)
// ===============================================
class NotificationFragment extends StatelessWidget {
  const NotificationFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi Laporan Masuk"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // PERBAIKAN: Hapus orderBy di query ini untuk menghindari error Index.
        // Kita hanya filter status 'Baru', lalu sort manual di bawah.
        stream: FirebaseFirestore.instance
            .collection('laporan')
            .where('status', isEqualTo: 'Baru') 
            .snapshots(),
        builder: (context, snapshot) {
          // Handle Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Handle Kosong
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState("Tidak ada laporan baru.");
          }

          // Handle Data & Sorting Manual
          final docs = snapshot.data!.docs;
          docs.sort((a, b) {
             // Sorting berdasarkan createdAt (Terbaru di atas)
             final t1 = a['createdAt'] as Timestamp?;
             final t2 = b['createdAt'] as Timestamp?;
             if (t1 == null && t2 == null) return 0;
             if (t1 == null) return 1; 
             if (t2 == null) return -1;
             return t2.compareTo(t1); 
          });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final laporan = _mapToLaporan(doc.id, data);

              // Helper Time Ago
              String timeStr = "Baru saja";
              if (data['createdAt'] != null) {
                 final dt = (data['createdAt'] as Timestamp).toDate();
                 final diff = DateTime.now().difference(dt);
                 if (diff.inMinutes < 60) timeStr = "${diff.inMinutes}m lalu";
                 else if (diff.inHours < 24) timeStr = "${diff.inHours}j lalu";
                 else timeStr = DateFormat('dd MMM').format(dt);
              }

              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailLaporanScreen(laporan: laporan))),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                    boxShadow: [
                      BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_active, color: Color(0xFF0055D4)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Laporan Baru Masuk!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text("${laporan.judul} - ${laporan.kategori}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(timeStr, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ===============================================
// 4. ACCOUNT FRAGMENT
// ===============================================
class AccountFragment extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const AccountFragment({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots() : null,
      builder: (context, snapshot) {
        String nama = userData?['nama_lengkap'] ?? 'Admin';
        String email = user?.email ?? userData?['email'] ?? 'admin@laporki.com';

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          nama = data['nama_lengkap'] ?? nama;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Akun Saya"), 
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50, 
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"), 
                ),
                const SizedBox(height: 15),
                Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

// ===============================================
// HELPER FUNCTIONS & WIDGETS
// ===============================================

Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
        const SizedBox(height: 10),
        Text(message, style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );
}

Widget _buildLaporanItem(BuildContext context, Laporan laporan) {
  return InkWell(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailLaporanScreen(laporan: laporan))),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                        child: Text(laporan.kategori, style: const TextStyle(color: Color(0xFF0055D4), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      Text(laporan.tanggal, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(laporan.judul, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: laporan.statusColor),
                      const SizedBox(width: 5),
                      Text(laporan.status, style: TextStyle(color: laporan.statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    ),
  );
}

class SummaryCard extends StatelessWidget {
  final List<Laporan> laporanList;
  const SummaryCard({super.key, required this.laporanList});
  @override
  Widget build(BuildContext context) {
    int baru = laporanList.where((l) => l.status == 'Baru').length;
    int diproses = laporanList.where((l) => l.status == 'Diproses').length;
    int selesai = laporanList.where((l) => l.status == 'Selesai').length;
    int ditolak = laporanList.where((l) => l.status == 'Ditolak').length;
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(children: [
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.description, color: Colors.white, size: 28), SizedBox(width: 8), Text('Rangkuman', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(child: SummaryItem(count: baru, label: 'Baru', iconColor: const Color(0xFFFFCC00))),
          Flexible(child: SummaryItem(count: diproses, label: 'Proses', iconColor: const Color(0xFFFF9500))),
          Flexible(child: SummaryItem(count: selesai, label: 'Selesai', iconColor: Colors.green)),
          Flexible(child: SummaryItem(count: ditolak, label: 'Ditolak', iconColor: Colors.red)),
        ]),
      ]),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final int count; final String label; final Color iconColor;
  const SummaryItem({super.key, required this.count, required this.label, required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
    ]);
  }
}

class SearchAndFilterBar extends StatelessWidget {
  final VoidCallback onFilterPressed;
  final Function(String) onSearchChanged;
  const SearchAndFilterBar({super.key, required this.onFilterPressed, required this.onSearchChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
      child: Row(children: [
        Expanded(child: TextField(onChanged: onSearchChanged, decoration: const InputDecoration(hintText: 'Cari Judul Laporan', border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero, prefixIcon: Icon(Icons.search, color: Colors.grey)))),
        IconButton(icon: Icon(Icons.filter_list, color: Theme.of(context).primaryColor), onPressed: onFilterPressed)
      ]),
    );
  }
}

class FilterPopupCard extends StatelessWidget {
  final VoidCallback onClose;
  const FilterPopupCard({super.key, required this.onClose});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Filter Laporan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 10), TextButton(onPressed: onClose, child: const Text('Tutup'))
      ])),
    );
  }
}

Laporan _mapToLaporan(String id, Map<String, dynamic> data) {
  String formatDate(dynamic val) { if (val is Timestamp) return DateFormat('dd MMM yyyy').format(val.toDate()); return val?.toString() ?? '-'; }
  Color getStatusColor(String? status) { if (status == 'Selesai') return Colors.green; if (status == 'Ditolak') return Colors.red; if (status == 'Diproses') return Colors.blue; return Colors.orange; }
  return Laporan(
    id: id,
    judul: data['judul'] ?? 'Tanpa Judul',
    lokasi: data['lokasi'] ?? '-',
    detailLokasi: data['detailLokasi'] ?? '-',
    deskripsi: data['deskripsi'] ?? '-',
    kategori: data['kategori'] ?? 'Lainnya',
    jenis: data['jenis'] ?? 'Publik',
    pelapor: data['pelapor'] ?? '-',
    status: data['status'] ?? 'Baru',
    tanggal: formatDate(data['createdAt'] ?? data['tanggal']),
    statusColor: getStatusColor(data['status']),
    imagePath: data['imagePath'] ?? data['foto'] ?? 'assets/images/placeholder.png',
    createdAt: data['createdAt'] as Timestamp?, // Mengisi field timestamp
  );
} 