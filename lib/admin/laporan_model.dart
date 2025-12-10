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