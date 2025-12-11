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
  final Timestamp? createdAt;

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
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Factory dari Map
  factory Laporan.fromMap(String docId, Map<String, dynamic> data) {
    // Helper format tanggal
    String formatTanggal(dynamic val) {
      if (val is Timestamp) {
        DateTime dt = val.toDate();
        return "${dt.day}-${dt.month}-${dt.year}"; 
      }
      return val?.toString() ?? '-';
    }

    // Helper warna status
    Color getStatusColor(String? status) {
      switch (status) {
        case 'Selesai': return Colors.green;
        case 'Ditolak': return Colors.red;
        case 'Diproses': return Colors.blue;
        default: return Colors.orange; // Baru
      }
    }

    return Laporan(
      id: docId,
      judul: data['judul'] ?? 'Tanpa Judul',
      lokasi: data['lokasi'] ?? '-',
      detailLokasi: data['detailLokasi'] ?? '-',
      deskripsi: data['deskripsi'] ?? '-',
      kategori: data['kategori'] ?? 'Lainnya',
      jenis: data['jenis'] ?? 'Publik',
      pelapor: data['pelapor'] ?? '-',
      status: data['status'] ?? 'Menunggu',
      tanggal: formatTanggal(data['createdAt'] ?? data['tanggal']),
      statusColor: getStatusColor(data['status']),
      imagePath: data['imagePath'] ?? data['foto'] ?? 'assets/images/placeholder.png',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}

// --- 3. Fungsi Helper Fetch (Opsional, jika dipakai di User) ---
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
    return Laporan.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }).toList();
}