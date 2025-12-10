import 'package:flutter/material.dart';

class Laporan {
  final String id;
  final String judul;
  final String lokasi;
  final String detailLokasi; 
  final String deskripsi;
  final String kategori;
  final String jenis; 
  final String pelapor;
  final String status;
  final Timestamp tanggal; // Ganti String menjadi Timestamp
  final String imagePath;
  final String pelaporId;

  // Status Color sekarang menjadi getter yang dihitung
  Color get statusColor => Laporan.determineStatusColor(status);

  Laporan({
    required this.id,
    required this.judul,
    required this.lokasi,
    required this.detailLokasi,
    required this.deskripsi,
    required this.kategori,
    required this.jenis,
    required this.pelaporId,
    required this.status,
    required this.tanggal,
    required this.imagePath,
    required this.pelapor,
    // StatusColor TIDAK diperlukan lagi di constructor
  });

// 1. Helper Function untuk Menentukan Warna Status
  static Color determineStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baru': // Sesuaikan dengan 'Baru' atau 'Menunggu' dari data Anda
      case 'menunggu':
        return Colors.blue.shade700;
      case 'dalam proses':
        return Colors.orange.shade700;
      case 'selesai':
        return Colors.green.shade700;
      case 'ditolak':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  // 2. Factory Constructor untuk konversi dari Firestore Document
  factory Laporan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    // Menangani Timestamp (di Firestore biasanya bernama 'createdAt' atau 'tanggal')
    final timestamp = data?['createdAt'] as Timestamp? ?? Timestamp.now();
    
    return Laporan(
      id: doc.id, // Menggunakan Document ID Firestore sebagai ID Laporan
      judul: data?['judul'] ?? 'Tidak ada Judul',
      lokasi: data?['lokasi'] ?? '',
      detailLokasi: data?['detailLokasi'] ?? '',
      deskripsi: data?['deskripsi'] ?? '',
      kategori: data?['kategori'] ?? '',
      jenis: data?['jenis'] ?? '',
      pelaporId: data?['pelaporId'] ?? 'unknown', // Pastikan menggunakan ID
      status: data?['status'] ?? 'Baru',
      tanggal: timestamp, 
      imagePath: data?['imagePath'] ?? '',
    );
  }

  // 3. Tambahkan toMap jika Anda perlu mengirim data Laporan kembali ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'lokasi': lokasi,
      'detailLokasi': detailLokasi,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'jenis': jenis,
      'pelaporId': pelaporId,
      'status': status,
      'createdAt': tanggal, // Gunakan nama field Firestore
      'imagePath': imagePath,
    };
  }
}


// Data Dummy Laporan
// final List<Laporan> laporanList = [
//   Laporan(
//     id: 'LP-003',
//     judul: 'Jalan Berlubang Parah di Depan SMA 8 Gowa',
//     lokasi: 'Jl. Maino No. Km. 6, Romang Lompoa, Kec. Bontomarannu, Kabupaten Gowa',
//     detailLokasi: 'Trotoar di depan Balai Kota',
//     deskripsi: 'Jalan berlubang cukup dalam di depan Toko Sinar Jaya menyebabkan kendaraan sering melambat dan hampir terjadi kecelakaan.',
//     kategori: 'Infrastruktur',
//     jenis: 'Publik',
//     pelapor: 'Ahmad S.',
//     status: 'Baru',
//     tanggal: '2025-11-14',
//     statusColor: Colors.blue.shade700,
//     imagePath: 'assets/images/jalan_rusak.png', // Ganti dengan path aset gambar Anda
//   ),




// ];