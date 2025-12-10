import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String tanggal;
  final Color statusColor; 
  final String imagePath;
  final Timestamp? createdAt; // Tambahkan untuk kompatibilitas Firestore (opsional)

  Laporan({
    required this.id,
    required this.judul,
    required this.lokasi,
    required this.detailLokasi,
    required this.deskripsi,
    required this.kategori,
    required this.jenis,
    required this.pelapor,
    required this.status,
    required this.tanggal,
    required this.statusColor,
    required this.imagePath,
    this.createdAt,
  });

  // **********************************************
  // PERBAIKAN: TAMBAHKAN METODE toMap() DI SINI
  // **********************************************
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'lokasi': lokasi,
      'detailLokasi': detailLokasi,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'jenis': jenis,
      'pelapor': pelapor,
      'status': status,
      'tanggal': tanggal, 
      'imagePath': imagePath,
      // Gunakan createdAt yang sudah ada atau Timestamp.now() jika objek baru
      'createdAt': createdAt ?? Timestamp.now(), 
      // statusColor (Color) tidak dimasukkan karena bukan tipe data Firestore
    };
  }
}

// Data Dummy Laporan
final List<Laporan> laporanList = [
  Laporan(
    id: 'LP-003',
    judul: 'Jalan Berlubang Parah di Depan SMA 8 Gowa',
    lokasi: 'Jl. Maino No. Km. 6, Romang Lompoa, Kec. Bontomarannu, Kabupaten Gowa',
    detailLokasi: 'Trotoar di depan Balai Kota',
    deskripsi: 'Jalan berlubang cukup dalam di depan Toko Sinar Jaya menyebabkan kendaraan sering melambat dan hampir terjadi kecelakaan.',
    kategori: 'Infrastruktur',
    jenis: 'Publik',
    pelapor: 'Ahmad S.',
    status: 'Baru',
    tanggal: '2025-11-14',
    statusColor: Colors.blue.shade700,
    imagePath: 'assets/images/jalan_rusak.png', // Ganti dengan path aset gambar Anda
  ),
  // ... Tambahkan data laporan lainnya jika diperlukan
];

Future<List<Laporan>> fetchLaporanList({String? userEmail, String? status}) async {
  // PENTING: Gunakan 'createdAt' untuk pengurutan yang aman di Firestore
  Query query = FirebaseFirestore.instance.collection('laporan').orderBy('createdAt', descending: true);
  if (userEmail != null) {
    query = query.where('pelapor', isEqualTo: userEmail);
  }
  if (status != null) {
    query = query.where('status', isEqualTo: status);
  }
  final snapshot = await query.get();
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    final statusData = data['status'] ?? 'Baru';
    final Timestamp? createdAt = data['createdAt'] as Timestamp?;

    // Perbaikan: Ambil tanggal dari Timestamp dengan aman
    String formattedDate = '';
    if (createdAt != null) {
      formattedDate = createdAt.toDate().toLocal().toString().substring(0, 10);
    } else {
      formattedDate = data['tanggal'] ?? 'N/A';
    }

    return Laporan(
      id: data['id'] ?? doc.id,
      judul: data['judul'] ?? '',
      lokasi: data['lokasi'] ?? data['address'] ?? '',
      detailLokasi: data['detailLokasi'] ?? data['detail_lokasi'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      kategori: data['kategori'] ?? '',
      jenis: data['jenis'] ?? '',
      pelapor: data['pelapor'] ?? '',
      status: statusData,
      tanggal: formattedDate,
      statusColor: _getStatusColor(statusData),
      imagePath: data['imagePath'] ?? '',
      createdAt: createdAt,
    );
  }).toList();
}

Color _getStatusColor(String? status) {
  switch (status) {
    case 'Baru': 
    case 'Dilaporkan': 
    case 'Menunggu': 
      return Colors.blue.shade700;
    case 'Diproses': 
      return Colors.orange.shade700;
    case 'Selesai': 
      return Colors.green.shade700;
    case 'Ditolak': 
      return Colors.red.shade700;
    default: 
      return Colors.grey;
  }
}