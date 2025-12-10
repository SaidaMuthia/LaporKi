import 'package:flutter/material.dart';
import 'package:laporki/admin/laporan_model.dart';
import 'package:laporki/admin/detail_laporan_screen.dart';
// 1. Import halaman profil (Tentang, Privasi, Syarat)
import 'package:laporki/profile_pages.dart'; 

// --- 2. ADMIN HOME PAGE (KONTEN BERANDA) ---

class AdminHomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const AdminHomePage({super.key, this.userData});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Laporan> _laporanList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
  }

  Future<void> _fetchLaporan() async {
    final list = await fetchLaporanList();
    setState(() {
      _laporanList = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String nama = widget.userData?['nama_lengkap'] ?? 'Admin';
    final List<Laporan> latestLaporan = _laporanList.take(4).toList();
    return CustomScrollView(
      slivers: [
        // --- 1. BAGIAN APP BAR (HEADER) ---
        SliverAppBar(
          pinned: true, 
          toolbarHeight: 90, 
          backgroundColor: Colors.white, 
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false, 

          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Halo,", 
                  style: TextStyle(color: Colors.grey, fontSize: 16)
                ), 
                Text(
                  nama.isNotEmpty ? nama : "$nama!", 
                  style: const TextStyle(
                    color: Colors.black, 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold
                  )
                ), 
              ],
            ),
          ),
          actions: [ 
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10.0), 
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, 
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_city, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),

        // --- 2. BAGIAN ISI KONTEN ---
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SummaryCard(laporanList: _laporanList),
                  const SizedBox(height: 25),
                  const Text('Laporan Terbaru', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
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
            ),
          ]),
        ),
      ],
    );
  }
}

// --- 3. KOMPONEN LAINNYA ---

class SummaryCard extends StatelessWidget {
  final List<Laporan> laporanList;
  const SummaryCard({super.key, required this.laporanList});

  @override
  Widget build(BuildContext context) {
    int baru = laporanList.where((l) => l.status == 'Menunggu').length;
    int diproses = laporanList.where((l) => l.status == 'Diproses').length;
    int selesai = laporanList.where((l) => l.status == 'Selesai').length;
    int ditolak = laporanList.where((l) => l.status == 'Ditolak').length;
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
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.description, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              const Text('Rangkuman Laporan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(child: SummaryItem(count: baru, label: 'Laporan Baru', iconColor: const Color(0xFFFFCC00))),
              const SizedBox(width: 15),
              Expanded(child: SummaryItem(count: diproses, label: 'Diproses', iconColor: const Color(0xFFFF9500))),
              const SizedBox(width: 15),
              Expanded(child: SummaryItem(count: selesai, label: 'Selesai', iconColor: Colors.green)),
              const SizedBox(width: 15),
              Expanded(child: SummaryItem(count: ditolak, label: 'Ditolak', iconColor: Colors.red)),
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
  final Color iconColor; 

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
class LaporanAdminPage extends StatefulWidget {
  const LaporanAdminPage({super.key});

  @override
  State<LaporanAdminPage> createState() => _LaporanAdminPageState();
}

class _LaporanAdminPageState extends State<LaporanAdminPage> {
  bool _showFilter = false;

  void _toggleFilter() {
    setState(() {
      _showFilter = !_showFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false, // Hilangkan tombol back
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchAndFilterBar(onFilterPressed: _toggleFilter),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: laporanList.length,
                  itemBuilder: (context, index) {
                    return LaporanListItem(laporan: laporanList[index]);
                  },
                ),
              ),
            ],
          ),

          if (_showFilter)
            Positioned(
              top: 70, 
              right: 16,
              left: 16,
              child: FilterPopupCard(
                onClose: _toggleFilter,
              ),
            ),
        ],
      ),
    );
  }
}

// ===============================================
// Search Bar dan Ikon Filter
// ===============================================
class SearchAndFilterBar extends StatelessWidget {
  final VoidCallback onFilterPressed;

  const SearchAndFilterBar({super.key, required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari ID atau Judul Laporan',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                prefixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
            onPressed: onFilterPressed, 
          ),
        ],
      ),
    );
  }
}

// ===============================================
// Pop-up Card Filter
// ===============================================
class FilterPopupCard extends StatelessWidget {
  final VoidCallback onClose;

  const FilterPopupCard({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filter Laporan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            
            // Filter Dropdowns
            const Row(
              children: [
                Expanded(child: FilterDropdown(label: 'Kategori')),
                SizedBox(width: 10),
                Expanded(child: FilterDropdown(label: 'Status')),
              ],
            ),
            const SizedBox(height: 15),

            // Filter Tanggal
            const Row(
              children: [
                Expanded(
                  child: FilterTanggal(label: 'Tanggal'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Bersihkan Filter
            TextButton(
              onPressed: () {
                onClose(); 
              },
              child: const Text('Bersihkan Filter', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================
// Dropdown Filter Reusable
// ===============================================
class FilterDropdown extends StatelessWidget {
  final String label;

  const FilterDropdown({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }
}

// ===============================================
// Filter Tanggal Reusable
// ===============================================
class FilterTanggal extends StatelessWidget {
  final String label;

  const FilterTanggal({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

// ===============================================
// Laporan List Item
// ===============================================
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailLaporanScreen(laporan: laporan),
            ),
          );
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
                      laporan.id,
                      style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
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
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${laporan.pelapor} - ${laporan.tanggal}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
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

// --- NOTIFICATION FRAGMENT ---
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

// --- ACCOUNT FRAGMENT (UPDATED FOR ADMIN) ---
class AccountFragment extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const AccountFragment({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final String nama = userData?['nama_lengkap'] ?? 'Pengguna';
    return Scaffold(
      appBar: AppBar(
        title: Text(userData?['role'] == 'admin' ? "Akun Admin": "Akun Saya"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12")), 
            const SizedBox(height: 15),
            Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            // --- MENU ITEM DISESUAIKAN UNTUK ADMIN ---
            // Mengarah ke halaman yang sama dengan User untuk konsistensi konten
            _menuItem(context, icon: Icons.person_outline, title: "Edit Profil", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
            }),
            _menuItem(context, icon: Icons.info_outline, title: "Tentang Aplikasi", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TentangAplikasiPage()));
            }),
            _menuItem(context, icon: Icons.privacy_tip_outlined, title: "Kebijakan Privasi", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const KebijakanPrivasiPage()));
            }),
            _menuItem(context, icon: Icons.description_outlined, title: "Syarat dan Ketentuan", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SyaratKetentuanPage()));
            }),
            
            const Divider(),
            
            _menuItem(context, icon: Icons.logout, title: "Keluar", color: Colors.red, onTap: () {
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