import 'package:flutter/material.dart';
import 'package:laporki/admin/laporan_model.dart'; // Import Model
import 'package:laporki/admin/riwayat_tindak_lanjut_screen.dart'; // Import Riwayat
import 'package:laporki/admin/lihat_gambar_screen.dart'; // Import Lihat Gambar

class ReportDetailPage extends StatelessWidget {
  final Laporan laporan; // Menerima data laporan

  const ReportDetailPage({super.key, required this.laporan});

  // Fungsi navigasi ke layar gambar penuh (Sama seperti Admin)
  void _viewFullImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LihatGambarScreen(imagePath: laporan.imagePath),
      ),
    );
  }

  // Fungsi navigasi ke Riwayat (Aksi tombol bawah)
  void _goToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RiwayatTindakLanjutScreen(),
      ),
    );
  }

  // Helper: Widget untuk Detail Info (Sama persis dengan desain Admin)
  Widget _buildDetailInfo(String title, String content, {bool isLocked = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              if (isLocked) 
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.lock_outline, size: 20, color: Colors.grey),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                laporan.tanggal,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Padding bottom agar konten tidak tertutup tombol floating di bawah
        padding: const EdgeInsets.only(bottom: 100), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Laporan (Desain Sama)
            GestureDetector(
              onTap: () => _viewFullImage(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    laporan.imagePath,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                    ),
                  ),
                  const Icon(Icons.zoom_out_map, size: 50, color: Colors.white70),
                ],
              ),
            ),
            
            // 2. Informasi Detail
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge Besar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: laporan.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: laporan.statusColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      "Status: ${laporan.status}",
                      style: TextStyle(
                        color: laporan.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('DETAIL LAPORAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(height: 30),

                  // Informasi Laporan (Read Only)
                  _buildDetailInfo('Judul Laporan', laporan.judul),
                  _buildDetailInfo('Lokasi Laporan', laporan.lokasi),
                  _buildDetailInfo('Detail Lokasi', laporan.detailLokasi),
                  _buildDetailInfo('Deskripsi Laporan', laporan.deskripsi),
                  _buildDetailInfo('Kategori Laporan', laporan.kategori),
                  _buildDetailInfo('Jenis Laporan', laporan.jenis),
                  
                  // Tidak ada dropdown status & input catatan karena ini User
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 3. Tombol Bawah: LIHAT RIWAYAT (Bukan Simpan)
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _goToHistory(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005AC2), // Warna Primary
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Lihat Riwayat Tindak Lanjut', 
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }
}