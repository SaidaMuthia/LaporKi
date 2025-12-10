import 'package:flutter/material.dart';

// Model Riwayat
class RiwayatItem {
  final String aktor; // 'Admin 1' atau 'Sistem'
  final String aksi;
  final String tanggal;

  RiwayatItem({required this.aktor, required this.aksi, required this.tanggal});
}

// Data Dummy Riwayat
final List<RiwayatItem> dummyHistory = [
  RiwayatItem(
    aktor: 'Admin 1',
    aksi: 'Telah berkoordinasi dengan kepolisian setempat. Kasus ditangani oleh Polsek.',
    tanggal: '2025-11-13',
  ),
  RiwayatItem(
    aktor: 'Sistem',
    aksi: 'Laporan diterima.',
    tanggal: '2025-11-13',
  ),
  // Tambahkan riwayat lain
];

class RiwayatTindakLanjutScreen extends StatelessWidget {
  const RiwayatTindakLanjutScreen({super.key});

  // Helper: Card untuk setiap item riwayat
  Widget _buildHistoryCard(RiwayatItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aktor (Admin/Sistem)
          SizedBox(
            width: 80,
            child: Text(
              item.aktor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: item.aktor == 'Sistem' ? Colors.green.shade700 : Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Aksi dan Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.aksi, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  item.tanggal,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Riwayat Tindak Lanjut'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyHistory.length,
        itemBuilder: (context, index) {
          return _buildHistoryCard(dummyHistory[index]);
        },
      ),
    );
  }
}