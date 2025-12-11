import 'package:flutter/material.dart';
import 'package:laporki/admin/laporan_model.dart'; 

class RiwayatTindakLanjutScreen extends StatelessWidget {
  final Laporan? laporan;

  const RiwayatTindakLanjutScreen({super.key, this.laporan});

  @override
  Widget build(BuildContext context) {
    // Ambil data status & tanggal dari laporan
    final String status = laporan?.status ?? 'Menunggu';
    final String tanggalLapor = laporan?.tanggal ?? '-';

    // --- LOGIKA TIMELINE ---
    // Kita susun urutannya dari BAWAH (Awal) ke ATAS (Terbaru)
    // Tapi di ListView, kita render dari index 0, jadi kita susun urutan tampilannya (Terbaru di Atas)
    
    List<Map<String, dynamic>> timelineItems = [];

    // 1. Item Paling Bawah (Selalu Ada): LAPORAN DITERIMA
    // Ini item 'dasar' yang muncul saat laporan baru dibuat
    Map<String, dynamic> itemDiterima = {
      "judul": "Laporan Diterima",
      "deskripsi": "Laporan Anda telah berhasil terkirim dan tercatat di sistem kami. Menunggu konfirmasi admin.",
      "tanggal": tanggalLapor,
      "icon": Icons.assignment_turned_in_outlined,
      "color": Colors.blue,
      "isActive": true,
    };

    // 2. Item Tengah: DIPROSES / DITINDAKLANJUTI
    Map<String, dynamic> itemDiproses = {
      "judul": "Sedang Ditindaklanjuti",
      "deskripsi": "Laporan Anda sedang ditangani oleh petugas lapangan/dinas terkait.",
      "tanggal": "Dalam Proses",
      "icon": Icons.engineering_outlined,
      "color": Colors.orange,
      "isActive": true,
    };

    // 3. Item Atas: SELESAI / DITOLAK
    Map<String, dynamic> itemSelesai = {
      "judul": "Laporan Selesai",
      "deskripsi": "Masalah telah selesai ditangani. Terima kasih atas partisipasi Anda.",
      "tanggal": "Selesai",
      "icon": Icons.check_circle_outline,
      "color": Colors.green,
      "isActive": true,
    };

    Map<String, dynamic> itemDitolak = {
      "judul": "Laporan Ditolak",
      "deskripsi": "Mohon maaf, laporan tidak dapat dilanjutkan (Data tidak valid/Duplikat).",
      "tanggal": "Ditolak",
      "icon": Icons.cancel_outlined,
      "color": Colors.red,
      "isActive": true,
    };

    // --- MENYUSUN LIST TAMPILAN ---
    // Logic: Status yang lebih tinggi mencakup status di bawahnya
    
    if (status == 'Selesai') {
      timelineItems.add(itemSelesai);
      timelineItems.add(itemDiproses);
      timelineItems.add(itemDiterima);
    } else if (status == 'Ditolak') {
      timelineItems.add(itemDitolak);
      timelineItems.add(itemDiterima);
    } else if (status == 'Diproses') {
      timelineItems.add(itemDiproses);
      timelineItems.add(itemDiterima);
    } else {
      // Default: Status 'Baru'
      timelineItems.add(itemDiterima);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Tindak Lanjut"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Singkat
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Pantau terus perkembangan laporan Anda di halaman ini secara berkala.",
                      style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Timeline List
            Expanded(
              child: ListView.builder(
                itemCount: timelineItems.length,
                itemBuilder: (context, index) {
                  final item = timelineItems[index];
                  final bool isLastItem = index == timelineItems.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Bagian Kiri: Garis & Icon ---
                      Column(
                        children: [
                          // Icon Lingkaran
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: item['color'].withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: item['color'], width: 2),
                            ),
                            child: Icon(item['icon'], color: item['color'], size: 20),
                          ),
                          // Garis Penghubung (Kecuali item terakhir)
                          if (!isLastItem)
                            Container(
                              width: 2,
                              height: 60, // Jarak antar item
                              color: Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // --- Bagian Kanan: Teks ---
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['judul'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['tanggal'],
                                style: TextStyle(
                                  color: Colors.grey.shade500, 
                                  fontSize: 12
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['deskripsi'],
                                style: TextStyle(
                                  color: Colors.grey.shade700, 
                                  fontSize: 14,
                                  height: 1.4
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}