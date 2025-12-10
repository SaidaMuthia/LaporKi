import 'package:flutter/material.dart';
// Import Riwayat Tindak Lanjut Screen
import 'riwayat_tindak_lanjut_screen.dart';
// Import Layar Gambar Penuh (Opsional, asumsikan namanya: LihatGambarScreen)
import 'lihat_gambar_screen.dart'; 
import 'laporan_model.dart';

// Model Laporan (Gunakan model yang sama dari laporan_admin_screen.dart)

class DetailLaporanScreen extends StatefulWidget {
  final Laporan laporan;
  const DetailLaporanScreen({super.key, required this.laporan});

  @override
  State<DetailLaporanScreen> createState() => _DetailLaporanScreenState();
}

class _DetailLaporanScreenState extends State<DetailLaporanScreen> {
  // State untuk mengelola Status dan Catatan Tindak Lanjut
  String? _selectedStatus;
  final TextEditingController _catatanController = TextEditingController();

  // Opsi Status
  final List<String> _statusOptions = ['Menunggu', 'Sedang Diproses', 'Selesai', 'Ditolak'];

  @override
  void initState() {
    super.initState();
    // Inisialisasi status awal (misalnya dari data laporan jika sudah ada status)
    _selectedStatus = 'Menunggu'; 
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  // Fungsi untuk navigasi ke riwayat
  void _goToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RiwayatTindakLanjutScreen(),
      ),
    );
  }

  // Fungsi untuk menyimpan tindak lanjut
  void _saveTindakLanjut() {
    final statusBaru = _selectedStatus;
    final catatan = _catatanController.text;

    debugPrint('Status Baru: $statusBaru');
    debugPrint('Catatan: $catatan');

    // Tambahkan logika API call/penyimpanan data di sini
    
    // Tampilkan feedback sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tindak Lanjut berhasil disimpan!')),
    );
    Navigator.pop(context, (route) => MaterialPageRoute(builder: (context) => const RiwayatTindakLanjutScreen()));
  }
  
  // Fungsi untuk menampilkan gambar penuh
  void _viewFullImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LihatGambarScreen(imagePath: widget.laporan.imagePath),
      ),
    );
  }

  // Helper: Widget untuk Detail Info (Lokasi, Deskripsi, Kategori, Jenis)
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
    final laporan = widget.laporan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Laporan'),
        // Tanggal di sebelah kanan App Bar (Detail Laporan.png)
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                laporan.tanggal, // Ganti dengan format tanggal yang sesuai
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // Padding untuk tombol Simpan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Laporan
            GestureDetector(
              onTap: _viewFullImage, // Navigasi ke layar gambar penuh
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    laporan.imagePath, // Ganti dengan NetworkImage jika dari internet
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const Icon(Icons.zoom_out_map, size: 50, color: Colors.white70),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DETAIL LAPORAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(height: 30),

                  // Informasi Laporan
                  _buildDetailInfo('Lokasi Laporan', laporan.lokasi),
                  _buildDetailInfo('Detail Lokasi', laporan.detailLokasi),
                  _buildDetailInfo('Deskripsi Laporan', laporan.deskripsi),
                  _buildDetailInfo('Kategori Laporan', laporan.kategori),
                  _buildDetailInfo('Jenis Laporan', laporan.jenis),
                  
                  // --- Bagian Tindak Lanjut ---
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TINDAK LANJUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      TextButton(
                        onPressed: _goToHistory, // Navigasi ke Riwayat Tindak Lanjut
                        child: const Text('Lihat Riwayat'),
                      ),
                    ],
                  ),
                  
                  // Status Dropdown
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    initialValue: _selectedStatus,
                    hint: const Text('Pilih Status'),
                    items: _statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
                  ),

                  // Catatan (Text Field)
                  const SizedBox(height: 20),
                  const Text('Catatan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _catatanController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan informasi tindak lanjut, langkah yang diambil, atau kendala.',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Tombol Simpan
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveTindakLanjut,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Simpan', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}