import 'package:flutter/material.dart';
// import 'package:laporki/admin/laporan_admin_page.dart';
import 'package:laporki/admin/laporan_model.dart';
import 'package:laporki/admin/detail_laporan_screen.dart';

// --- 2. ADMIN HOME PAGE (KONTEN BERANDA) ---

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil 4 laporan terbaru untuk tampilan beranda
    final List<Laporan> latestLaporan = laporanList.take(4).toList();
    
    // UBAH STRUKTUR DISINI: Gunakan CustomScrollView agar bisa pakai SliverAppBar
    return CustomScrollView(
      slivers: [
        // --- 1. BAGIAN APP BAR (HEADER) ---
        SliverAppBar(
          pinned: true, // Agar header tetap nempel saat discroll
          toolbarHeight: 90, 
          backgroundColor: Colors.white, 
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false, // Hilangkan tombol back

          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo,", 
                  style: TextStyle(color: Colors.grey, fontSize: 16)
                ), 
                Text(
                  "Admin Kota!", // Teks khusus Admin
                  style: TextStyle(
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
                // Ikon diganti 'location_city' biar sedikit beda nuansa adminnya
                child: const Icon(Icons.location_city, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),

        // --- 2. BAGIAN ISI KONTEN ---
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Tidak perlu SizedBox di awal karena toolbarHeight sudah tinggi
                    
                    // Ringkasan Laporan Hari Ini (SummaryCard)
                    const SummaryCard(),
                    
                    const SizedBox(height: 25),
                    const Text(
                      'Laporan Terbaru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Daftar Laporan
                    ListView.builder(
                      shrinkWrap: true, // Wajib ada karena di dalam ScrollView
                      physics: const NeverScrollableScrollPhysics(), // Scroll ikut induknya
                      itemCount: latestLaporan.length,
                      itemBuilder: (context, index) {
                        return LaporanListItem(laporan: latestLaporan[index]);
                      },
                    ),
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
}

// --- 3. KOMPONEN LAINNYA (TETAP SAMA SEPERTI SEBELUMNYA) ---

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
                'Rangkuman Laporan',
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
                  count: 5, // Data Dummy
                  label: 'Laporan Baru',
                  iconColor: Color(0xFFFFCC00), 
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: SummaryItem(
                  count: 2, // Data Dummy
                  label: 'Diproses',
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
  // State untuk mengontrol tampilan pop-up filter
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
      ),
      body: Stack( // Gunakan Stack agar Pop-up filter bisa muncul di atas konten lain
        children: [
          // Konten Utama (Search Bar dan List Laporan)
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

          // Pop-up Filter (Hanya ditampilkan jika _showFilter = true)
          if (_showFilter)
            Positioned(
              top: 70, // Sesuaikan posisi di bawah search bar
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
            onPressed: onFilterPressed, // Panggil fungsi toggle filter
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
            Row(
              children: const [
                Expanded(child: FilterDropdown(label: 'Kategori')),
                SizedBox(width: 10),
                Expanded(child: FilterDropdown(label: 'Status')),
              ],
            ),
            const SizedBox(height: 15),

            // Filter Tanggal
            Row(
              children: [
                const Expanded(
                  child: FilterTanggal(label: 'Tanggal'),
                ),
                // Tombol kalender berada di dalam FilterTanggal
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Bersihkan Filter
            TextButton(
              onPressed: () {
                // Logika bersihkan filter
                onClose(); // Tutup pop-up setelah dibersihkan
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
// Laporan List Item (Disalin dari admin_dashboard.dart, sedikit dimodifikasi)
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
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12")), 
            const SizedBox(height: 15),
            const Text("Admin Utama", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("admin@laporki.go.id", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _menuItem(context, icon: Icons.person_outline, title: "Edit Profil"),
            _menuItem(context, icon: Icons.lock_outline, title: "Ganti Kata Sandi"),
            _menuItem(context, icon: Icons.settings_outlined, title: "Pengaturan Sistem"),
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