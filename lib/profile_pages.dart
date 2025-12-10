import 'package:flutter/material.dart';

// ==========================================
// 1. EDIT PROFIL PAGE
// ==========================================
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50, 
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11")
                  ),
                  Positioned(
                    bottom: 0, 
                    right: 0, 
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor, 
                      radius: 18, 
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white)
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildField("Nama Lengkap", "Rahmat Hidayat"),
            _buildField("Email", "rahmat.hidayat@email.com"),
            _buildField("Nomor Telepon", "081234567890"),
            _buildField("Alamat", "Jl. Perintis Kemerdekaan No. 10"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, 
                  foregroundColor: Colors.white, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: const Text("Simpan Perubahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String initialVal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialVal,
            decoration: InputDecoration(
              filled: true, 
              fillColor: Colors.grey.shade50, 
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), 
                borderSide: BorderSide(color: Colors.grey.shade300)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), 
                borderSide: BorderSide(color: Colors.grey.shade300)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. TENTANG APLIKASI PAGE
// ==========================================
class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tentang Aplikasi", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Logo Icon (Mirip desain gambar)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.location_on, // Icon Pin Lokasi
                size: 100,
                color: Color(0xFF0091EA), // Warna Biru cerah sesuai gambar
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Versi Beta 1.0",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "LaporKi’ adalah aplikasi aduan masyarakat Kota Makassar yang menyediakan layanan pelaporan dan informasi yang dapat disampaikan warga lalu ditindaklanjuti oleh Pemerintah.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const Spacer(),
            const Text(
              "© 2025 LaporKi’ Team. All rights reserved.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. KEBIJAKAN PRIVASI PAGE
// ==========================================
class KebijakanPrivasiPage extends StatelessWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kebijakan Privasi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kebijakan Privasi ini menjelaskan bagaimana aplikasi LaporKi’ mengumpulkan, menggunakan, dan melindungi data pribadi pengguna dalam layanan pelaporan masyarakat Kota Makassar.",
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            
            _buildSectionTitle("1. Pengumpulan Data"),
            _buildSectionBody(
              "Aplikasi mengumpulkan beberapa jenis data, termasuk:\n"
              "• Data Akun: nama, email, nomor telepon, dan informasi profil lainnya.\n"
              "• Data Laporan: foto, deskripsi, lokasi kejadian, dan waktu pelaporan.\n"
              "• Data Lokasi: lokasi perangkat saat pengguna memilih titik lokasi laporan.\n"
              "• Data Teknis: informasi perangkat dan aktivitas penggunaan aplikasi untuk keperluan peningkatan layanan."
            ),

            _buildSectionTitle("2. Penggunaan Data"),
            _buildSectionBody(
              "Data yang dikumpulkan digunakan untuk:\n"
              "• Memproses dan meneruskan laporan kepada instansi terkait.\n"
              "• Menampilkan riwayat dan status laporan pengguna.\n"
              "• Mengirim notifikasi terkait perkembangan laporan.\n"
              "• Meningkatkan kualitas, keamanan, dan kinerja aplikasi."
            ),

            _buildSectionTitle("3. Berbagi Data"),
            _buildSectionBody(
              "Pa’Lapor tidak menjual atau membagikan data pribadi kepada pihak lain, kecuali:\n"
              "• Kepada instansi pemerintah atau petugas resmi yang menangani laporan.\n"
              "• Jika diwajibkan oleh hukum atau permintaan aparat berwenang."
            ),

            _buildSectionTitle("4. Keamanan Data"),
            _buildSectionBody(
              "Kami menerapkan langkah-langkah keamanan yang wajar untuk melindungi data pengguna dari akses, perubahan, atau penyalahgunaan yang tidak sah. Namun, tidak ada sistem yang sepenuhnya bebas dari risiko."
            ),

            _buildSectionTitle("5. Hak Pengguna"),
            _buildSectionBody(
              "Pengguna memiliki hak untuk:\n"
              "• Mengakses dan memperbarui data profil.\n"
              "• Menghapus akun beserta seluruh data yang terkait.\n"
              "• Menghubungi tim pengembang apabila terdapat pertanyaan terkait privasi."
            ),

            _buildSectionTitle("6. Perubahan Kebijakan"),
            _buildSectionBody(
              "Kebijakan Privasi dapat diperbarui sewaktu-waktu. Setiap perubahan penting akan diinformasikan melalui aplikasi."
            ),

            _buildSectionTitle("7. Kontak"),
            _buildSectionBody(
              "Untuk pertanyaan atau permintaan terkait data pribadi, silakan menghubungi tim pengembang melalui email yang tersedia pada halaman aplikasi."
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. SYARAT DAN KETENTUAN PAGE
// ==========================================
class SyaratKetentuanPage extends StatelessWidget {
  const SyaratKetentuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Syarat dan Ketentuan", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Syarat dan Ketentuan ini mengatur penggunaan aplikasi LaporKi’, layanan pelaporan masyarakat Kota Makassar. Dengan menggunakan aplikasi ini, Anda dianggap telah membaca, memahami, dan menyetujui seluruh ketentuan di bawah ini.",
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("1. Penggunaan Layanan"),
            _buildSectionBody(
              "• Pengguna wajib menggunakan aplikasi secara bertanggung jawab dan sesuai dengan tujuan yaitu pelaporan masalah lingkungan, fasilitas umum, dan keamanan di Kota Makassar.\n"
              "• Informasi yang disampaikan dalam laporan harus benar, sesuai fakta, dan tidak mengandung unsur fitnah, provokasi, atau pelanggaran hukum."
            ),

            _buildSectionTitle("2. Akun Pengguna"),
            _buildSectionBody(
              "• Pengguna wajib menjaga kerahasiaan akun dan password.\n"
              "• Setiap aktivitas yang dilakukan melalui akun pengguna merupakan tanggung jawab pengguna sepenuhnya.\n"
              "• Aplikasi berhak menonaktifkan atau menghapus akun yang terbukti melakukan penyalahgunaan layanan."
            ),

            _buildSectionTitle("3. Konten Laporan"),
            _buildSectionBody(
              "• Foto, deskripsi, dan data lokasi yang dikirimkan harus relevan dengan laporan dan tidak melanggar privasi pihak lain.\n"
              "• Pengguna dilarang mengunggah konten yang mengandung kekerasan, SARA, pornografi, atau informasi palsu.\n"
              "• Laporan yang masuk dapat diteruskan kepada instansi terkait untuk keperluan penanganan."
            ),

            _buildSectionTitle("4. Hak dan Kewajiban Pengembang"),
            _buildSectionBody(
              "• Pengembang berhak memperbarui fitur, membatasi akses, atau menghentikan layanan untuk pemeliharaan atau alasan tertentu.\n"
              "• Pengembang tidak bertanggung jawab atas kerugian yang timbul akibat kesalahan input pengguna, gangguan jaringan, atau penggunaan aplikasi di luar ketentuan."
            ),

            _buildSectionTitle("5. Hak Pengguna"),
            _buildSectionBody(
              "• Pengguna berhak mengakses, memperbarui, atau menghapus akun kapan saja melalui menu pengaturan.\n"
              "• Pengguna berhak mengajukan masukan dan pengaduan terkait layanan aplikasi."
            ),

            _buildSectionTitle("6. Batasan Tanggung Jawab"),
            _buildSectionBody(
              "• Aplikasi Pa’Lapor berfungsi sebagai media pelaporan, bukan sebagai penentu keputusan akhir penanganan masalah.\n"
              "• Tindak lanjut laporan sepenuhnya menjadi kewenangan instansi pemerintah atau petugas berwenang."
            ),

            _buildSectionTitle("7. Perubahan Syarat dan Ketentuan"),
            _buildSectionBody(
              "Syarat dan Ketentuan ini dapat diperbarui sewaktu-waktu. Perubahan akan diberlakukan setelah diumumkan melalui aplikasi."
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets untuk Teks (Biar Rapi) ---

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}

Widget _buildSectionBody(String content) {
  return Text(
    content,
    style: const TextStyle(
      fontSize: 14,
      color: Colors.black87,
      height: 1.6, // Spasi antar baris biar enak dibaca
    ),
    textAlign: TextAlign.justify,
  );
}