import 'package:flutter/material.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Laporan")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Laporan
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(image: NetworkImage("https://via.placeholder.com/600x400"), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Jalan Rusak Parah di Depan SD Inpres", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Expanded(child: Text("Jl. Malino No.Km.6, Gowa", style: TextStyle(color: Colors.grey[600]))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Lubang besar di tengah jalan sangat membahayakan pengendara motor, terutama saat malam hari.", style: TextStyle(height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 30),
                  
                  const Text("Riwayat Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  // Timeline Mockup
                  _timelineItem("Laporan Diterima", "Laporan berhasil dikirim ke sistem.", "12 Mar 2024, 08:00", isActive: true, isLast: false),
                  _timelineItem("Sedang Diproses", "Petugas sedang melakukan verifikasi ke lokasi.", "12 Mar 2024, 10:30", isActive: true, isLast: false),
                  _timelineItem("Selesai", "Perbaikan telah selesai dilakukan.", "-", isActive: false, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(String title, String desc, String time, {required bool isActive, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 15, height: 15, decoration: BoxDecoration(color: isActive ? Colors.blue : Colors.grey[300], shape: BoxShape.circle)),
            if (!isLast) Container(width: 2, height: 60, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }
}