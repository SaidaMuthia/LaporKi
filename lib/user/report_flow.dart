import 'package:flutter/material.dart';

// --- 1. PERMISSION PAGE ---
class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 100, color: Color(0xFF005AC2)),
            const SizedBox(height: 30),
            const Text("Aktifkan Layanan Lokasi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 15),
            const Text("Kami memerlukan izin lokasi agar titik laporan akurat.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraPage())),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005AC2), foregroundColor: Colors.white),
                child: const Text("Izinkan Akses Lokasi"),
              ),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Jangan Izinkan")),
          ],
        ),
      ),
    );
  }
}

// --- 2. CAMERA PAGE ---
class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(child: Text("Camera Preview Here", style: TextStyle(color: Colors.white))),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewImagePage())),
                child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.grey, width: 4))),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- 3. REVIEW IMAGE PAGE ---
class ReviewImagePage extends StatelessWidget {
  const ReviewImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(child: Container(color: Colors.grey, child: const Center(child: Icon(Icons.image, size: 100, color: Colors.white)))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Ulangi"))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SetLocationPage())), child: const Text("Gunakan"))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- 4. SET LOCATION PAGE ---
class SetLocationPage extends StatelessWidget {
  const SetLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atur Lokasi")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(border: Border.all(color: Colors.grey)), child: const Row(children: [Icon(Icons.map), SizedBox(width: 10), Text("Pilih di Peta")])),
            const SizedBox(height: 20),
            TextFormField(maxLines: 3, decoration: const InputDecoration(labelText: "Detail Patokan", border: OutlineInputBorder())),
            const Spacer(),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SetDetailsPage())), child: const Text("Selanjutnya"))),
          ],
        ),
      ),
    );
  }
}

// --- 5. SET DETAILS PAGE ---
class SetDetailsPage extends StatelessWidget {
  const SetDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Laporan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(maxLines: 5, decoration: const InputDecoration(labelText: "Deskripsi Masalah", hintText: "Jelaskan kerusakan...", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            DropdownButtonFormField(items: const [DropdownMenuItem(value: "Infrastruktur", child: Text("Infrastruktur"))], onChanged: (v){}, decoration: const InputDecoration(labelText: "Kategori", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewReportPage())), child: const Text("Tinjau Laporan"))),
          ],
        ),
      ),
    );
  }
}

// --- 6. REVIEW & SUBMIT PAGE ---
class ReviewReportPage extends StatelessWidget {
  const ReviewReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tinjau Laporan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ListTile(title: Text("Lokasi"), subtitle: Text("Jl. Malino, Gowa")),
            const ListTile(title: Text("Kategori"), subtitle: Text("Infrastruktur")),
            const ListTile(title: Text("Deskripsi"), subtitle: Text("Jalan berlubang...")),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Kembali ke Dashboard
                  Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Laporan Berhasil Dikirim!")));
                },
                child: const Text("Kirim Laporan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}