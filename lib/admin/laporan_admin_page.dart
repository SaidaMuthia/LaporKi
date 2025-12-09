// lib/admin/laporan_admin_page.dart

import 'package:flutter/material.dart';
import 'laporan_model.dart';
import 'detail_laporan_screen.dart';

// ===============================================
// Halaman Utama Laporan Admin
// ===============================================
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