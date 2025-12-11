import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'riwayat_tindak_lanjut_screen.dart';
import 'lihat_gambar_screen.dart'; 
import 'laporan_model.dart';

class DetailLaporanScreen extends StatefulWidget {
  final Laporan laporan;
  const DetailLaporanScreen({super.key, required this.laporan});

  @override
  State<DetailLaporanScreen> createState() => _DetailLaporanScreenState();
}

class _DetailLaporanScreenState extends State<DetailLaporanScreen> {
  String? _selectedStatus;
  final TextEditingController _catatanController = TextEditingController();
  bool _isLoading = false;

  // Status opsi
  final List<String> _statusOptions = ['Menunggu', 'Diproses', 'Selesai', 'Ditolak'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.laporan.status; 
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _goToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RiwayatTindakLanjutScreen(laporan: widget.laporan),
      ),
    );
  }

  void _viewFullImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LihatGambarScreen(imagePath: widget.laporan.imagePath),
      ),
    );
  }

  // LOGIKA UTAMA SINKRONISASI
  Future<void> _saveTindakLanjut() async {
    setState(() => _isLoading = true);

    try {
      // UPDATE Status Laporan di Database Utama
      await FirebaseFirestore.instance.collection('laporan').doc(widget.laporan.id).update({
        'status': _selectedStatus,
        'catatan_terakhir': _catatanController.text,
      });

      // BUAT NOTIFIKASI UNTUK USER
      await FirebaseFirestore.instance.collection('notifications').add({
        'to_user': widget.laporan.pelapor,
        'title': 'Status Laporan Diperbarui',
        'body': 'Laporan "${widget.laporan.judul}" statusnya berubah menjadi $_selectedStatus.',
        'laporan_id': widget.laporan.id,
        'is_read': false,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'status_update',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status berhasil diperbarui & Notifikasi dikirim ke User!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  // Helper Widget Detail Info
  Widget _buildDetailInfo(String title, String content, {bool isLocked = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(content, style: const TextStyle(fontSize: 16, color: Colors.black87))),
              if (isLocked) const Padding(padding: EdgeInsets.only(left: 8.0), child: Icon(Icons.lock_outline, size: 20, color: Colors.grey)),
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
        title: const Text('Detail Laporan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(laporan.tanggal, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Laporan
            GestureDetector(
              onTap: _viewFullImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cek apakah URL atau Asset
                  laporan.imagePath.startsWith('http')
                      ? Image.network(laporan.imagePath, width: double.infinity, height: 250, fit: BoxFit.cover)
                      : Image.asset(laporan.imagePath, width: double.infinity, height: 250, fit: BoxFit.cover),
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

                  _buildDetailInfo('Lokasi Laporan', laporan.lokasi),
                  _buildDetailInfo('Detail Lokasi', laporan.detailLokasi),
                  _buildDetailInfo('Deskripsi Laporan', laporan.deskripsi),
                  _buildDetailInfo('Kategori Laporan', laporan.kategori),
                  _buildDetailInfo('Jenis Laporan', laporan.jenis),
                  
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TINDAK LANJUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      TextButton(onPressed: _goToHistory, child: const Text('Lihat Riwayat')),
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
                    value: _selectedStatus,
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

                  const SizedBox(height: 20),
                  const Text('Catatan Admin', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _catatanController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan catatan untuk user (misal: "Tim sudah meluncur ke lokasi")',
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
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(0, -2))]),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveTindakLanjut,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0055D4),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: _isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Simpan & Update Status', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}