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
  final Color statusColor; // <-- Tambahkan statusColor di model
  final String imagePath;    // <-- Tambahkan untuk imagePath

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
  });
}

// File: lib/admin/laporan_admin_page.dart (Tambahkan setelah Laporan class)

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
  //   Laporan(
  //     id: 'LP-001',
  //     judul: 'Penumpukkan Sampah di Pasar',
  //     lokasi: 'Jl. Makassar',
  //     detailLokasi: 'Dekat terminal lama',
  //     deskripsi: 'Sampah menumpuk sudah 3 hari, menimbulkan bau tidak sedap.',
  //     kategori: 'Kebersihan',
  //     jenis: 'Publik',
  //     pelapor: 'Citra H.',
  //     status: 'Selesai',
  //     tanggal: '2025-10-09',
  //     statusColor: Colors.green.shade700,
  //     imagePath: 'assets/images/sampah_menumpuk.png',
  //   ),
  //   // ... Tambahkan data laporan lainnya
];

Future<List<Laporan>> fetchLaporanList({String? userEmail, String? status}) async {
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
    return Laporan(
      id: data['id'] ?? doc.id,
      judul: data['judul'] ?? '',
      lokasi: data['lokasi'] ?? data['address'] ?? '',
      detailLokasi: data['detail_lokasi'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      kategori: data['kategori'] ?? '',
      jenis: data['jenis'] ?? '',
      pelapor: data['pelapor'] ?? '',
      status: data['status'] ?? '',
      tanggal: (data['createdAt'] != null) ? DateTime.parse(data['createdAt']).toLocal().toString().substring(0, 10) : '',
      statusColor: _getStatusColor(data['status']),
      imagePath: data['imagePath'] ?? '',
    );
  }).toList();
}

Color _getStatusColor(String? status) {
  switch (status) {
    case 'Menunggu': return Colors.blue.shade700;
    case 'Diproses': return Colors.orange.shade700;
    case 'Selesai': return Colors.green.shade700;
    case 'Ditolak': return Colors.red.shade700;
    default: return Colors.grey;
  }
}