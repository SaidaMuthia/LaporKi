import 'package:flutter/material.dart';
import 'package:laporki/user/user_dashboard.dart';

// --- 1. PERMISSION PAGE ---
class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Aktifkan Layanan\nLokasi",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Ilustrasi Icon Lokasi
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade50,
              ),
              child: const Icon(
                Icons.location_on,
                size: 60,
                color: Color(0xFF0055D4),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Kami memerlukan izin lokasi agar Anda dapat menentukan titik pengaduan dengan lebih akurat.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Izinkan Akses Lokasi"),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0055D4)),
                  foregroundColor: const Color(0xFF0055D4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Jangan Izinkan"),
              ),
            ),
            const SizedBox(height: 20),
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
          // Placeholder Kamera (Background)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Menggunakan placeholder gambar jalan rusak dari contoh
                image: NetworkImage("https://via.placeholder.com/400x800"), 
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
            child: const Center(child: Text("Camera Preview", style: TextStyle(color: Colors.white))),
          ),
          
          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Ambil Gambar",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_off, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Footer Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Thumbnail
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade800,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.image, color: Colors.white),
                ),
                
                // Shutter Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewImagePage()));
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.transparent,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                // Switch Camera
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
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
      body: Stack(
        children: [
          // Gambar Full Screen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://via.placeholder.com/400x800"), // Ganti dengan path file asli nanti
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Header Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "Tinjau Gambar",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 48), // Balancing space
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Ulangi", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SetLocationPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055D4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Gunakan", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
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
      appBar: AppBar(
        title: const Text("Atur Lokasi Laporan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Lokasi Laporan", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {}, // Buka Peta
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.location_on_outlined, color: Color(0xFF0055D4)),
                    SizedBox(width: 10),
                    Text("Pilih lokasi", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text("Detail Tambahan Lokasi", style: TextStyle(fontWeight: FontWeight.w500)),
            const Text("(Nama gedung, patokan, keadaan sekitar, dll.)", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Contoh: Trotoar di depan Balai Kota",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SetDetailsPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Selanjutnya"),
              ),
            ),
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
      appBar: AppBar(
        title: const Text("Atur Detail Laporan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Judul Laporan", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "Ketik judul di sini...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Deskripsi Laporan", style: TextStyle(fontWeight: FontWeight.w500)),
            const Text("Kamu bisa tulis deskripsi masalah, waktu kejadian, dan detail lain yang diperlukan.", 
              style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Ketik dengan detail, jelas, dan padat...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Kategori Laporan", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(),
              hint: const Text("Pilih kategori"),
              items: const [
                DropdownMenuItem(value: "Infrastruktur", child: Text("Infrastruktur")),
                DropdownMenuItem(value: "Kebersihan", child: Text("Kebersihan")),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 20),

            const Text("Jenis Laporan", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(),
              hint: const Text("Pilih jenis"),
              items: const [
                DropdownMenuItem(value: "Publik", child: Text("Publik")),
                DropdownMenuItem(value: "Privat", child: Text("Privat")),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewReportPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Selanjutnya"),
              ),
            ),
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
      appBar: AppBar(
        title: const Text("Tinjau Laporan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://via.placeholder.com/600x300", 
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Item-item Review
            _buildReviewItem("Judul Laporan", "Jalan Berlubang Parah di Depan SMA 8 Gowa"),
            _buildReviewItem("Lokasi Laporan", "Jl. Malino No.Km.6, Romang Lompoa, Kec. Bontomarannu, Kabupaten Gowa, Sulawesi Selatan 92171, Indonesia"),
            _buildReviewItem("Detail Lokasi Laporan", "Trotoar di depan Balai Kota"),
            _buildReviewItem("Deskripsi Laporan", "Jalan berlubang cukup dalam di depan Toko Sinar Jaya, menyebabkan kendaraan sering melambat dan hampir terjadi kecelakaan. Mohon segera dilakukan perbaikan sebelum menimbulkan bahaya lebih besar."),
            _buildReviewItem("Kategori Laporan", "Infrastruktur"),
            _buildReviewItem("Jenis Laporan", "Privat"),

            const SizedBox(height: 20),
            
            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi Kirim Data
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Laporan Terkirim!")));
                  
                  // 🚨 PERBAIKAN UTAMA DI SINI 🚨
                  // Gunakan pushAndRemoveUntil untuk menghapus semua halaman sebelumnya (kamera, form, dll)
                  // Ini membuat UserDashboard menjadi halaman 'root' baru, sehingga tidak ada tombol back.
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const UserDashboard()), 
                    (route) => false // Return false artinya hapus semua rute sebelumnya
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Kirim Laporan"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.lock_outline, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}