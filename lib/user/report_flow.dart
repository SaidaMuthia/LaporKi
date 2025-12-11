import 'package:flutter/material.dart';
import 'package:laporki/user/user_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'report_draft.dart';
// Import yang diperlukan untuk ReportDetailPage dan Laporan Model
import 'package:laporki/admin/laporan_model.dart'; // <--- PASTIKAN PATH INI BENAR
import 'package:laporki/user/report_detail.dart'; // <--- PASTIKAN PATH INI BENAR
// Import lainnya
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:latlong2/latlong.dart';
import 'pick_map_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// --- 1. PERMISSION PAGE ---
class LocationPermissionPage extends StatelessWidget {
  final ReportDraft? draft;
  const LocationPermissionPage({super.key, this.draft});

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraPage(draft: draft ?? ReportDraft()),
                    ),
                  );
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
class CameraPage extends StatefulWidget {
  final ReportDraft draft;
  const CameraPage({super.key, required this.draft});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? _imageFile;
  bool _loading = false;

  Future<void> _takePicture() async {
    setState(() => _loading = true);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _imageFile = pickedFile);
      widget.draft.imageFile = File(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReviewImagePage(draft: widget.draft),
        ),
      );
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Camera Preview", style: TextStyle(color: Colors.white)),
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
                  onTap: _takePicture,
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
  final ReportDraft draft;
  const ReviewImagePage({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          draft.imageFile != null
              ? Image.file(
                  draft.imageFile!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Center(child: Text("Tidak ada gambar", style: TextStyle(color: Colors.white))),
          
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SetLocationPage(draft: draft),
                        ),
                      );
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
class SetLocationPage extends StatefulWidget {
  final ReportDraft draft;
  const SetLocationPage({super.key, required this.draft});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  final _detailLokasiController = TextEditingController();
  String? _address;
  double? _latitude;
  double? _longitude;
  bool _loading = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak.')));
      setState(() => _loading = false);
      return;
    }
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;
    final placemarks = await placemarkFromCoordinates(_latitude!, _longitude!);
    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      _address = "${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
    } else {
      _address = "Lokasi tidak ditemukan";
    }
    setState(() {});
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _detailLokasiController.dispose();
    super.dispose();
  }

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
            // 2. Tombol Pilih Lewat Peta (BARU)
            InkWell(
              onTap: () async {
                // Buka halaman peta, tunggu hasilnya (latlong)
                final LatLng? result = await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const PickMapPage())
                );

                // Jika user memilih lokasi
                if (result != null) {
                  setState(() => _loading = true);
                  
                  // Simpan koordinat
                  _latitude = result.latitude;
                  _longitude = result.longitude;

                  // Convert koordinat ke Alamat (Geocoding)
                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(_latitude!, _longitude!);
                    if (placemarks.isNotEmpty) {
                      final p = placemarks.first;
                      _address = "${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}";
                    } else {
                      _address = "Alamat tidak ditemukan";
                    }
                  } catch (e) {
                    _address = "Gagal memuat alamat";
                  }

                  setState(() => _loading = false);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.map_outlined, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_address ?? "Pilih Lewat Peta", style: const TextStyle(color: Colors.black87)),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Detail Tambahan Lokasi", style: TextStyle(fontWeight: FontWeight.w500)),
            const Text("(Nama gedung, patokan, keadaan sekitar, dll.)", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _detailLokasiController,
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
                  widget.draft.detailLokasi = _detailLokasiController.text;
                  widget.draft.address = _address;
                  widget.draft.latitude = _latitude;
                  widget.draft.longitude = _longitude;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SetDetailsPage(draft: widget.draft),
                    ),
                  );
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
class SetDetailsPage extends StatefulWidget {
  final ReportDraft draft;
  const SetDetailsPage({super.key, required this.draft});

  @override
  State<SetDetailsPage> createState() => _SetDetailsPageState();
}

class _SetDetailsPageState extends State<SetDetailsPage> {
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String? _kategori;
  String? _jenis;

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

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
              controller: _judulController,
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
              controller: _deskripsiController,
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
              value: _kategori,
              decoration: const InputDecoration(),
              hint: const Text("Pilih kategori"),
              items: const [
                DropdownMenuItem(value: "Infrastruktur", child: Text("Infrastruktur")),
                DropdownMenuItem(value: "Kebersihan", child: Text("Kebersihan")),
              ],
              onChanged: (val) => setState(() => _kategori = val),
            ),
            const SizedBox(height: 20),
            const Text("Jenis Laporan", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _jenis,
              decoration: const InputDecoration(),
              hint: const Text("Pilih jenis"),
              items: const [
                DropdownMenuItem(value: "Publik", child: Text("Publik")),
                DropdownMenuItem(value: "Privat", child: Text("Privat")),
              ],
              onChanged: (val) => setState(() => _jenis = val),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.draft.judul = _judulController.text;
                  widget.draft.deskripsi = _deskripsiController.text;
                  widget.draft.kategori = _kategori;
                  widget.draft.jenis = _jenis;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReviewReportPage(draft: widget.draft),
                    ),
                  );
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

// --- 6. REVIEW & SUBMIT PAGE (DIUBAH MENJADI STATEFUL) ---
class ReviewReportPage extends StatefulWidget {
  final ReportDraft draft;
  const ReviewReportPage({super.key, required this.draft});

  @override
  State<ReviewReportPage> createState() => _ReviewReportPageState();
}

class _ReviewReportPageState extends State<ReviewReportPage> {
  bool _isLoading = false;

  // Fungsi manual kirim notif dari HP User ke HP Admin
  Future<void> _sendPushNotificationToAdmin(String judul, String kategori) async {
    try {
      // GANTI DENGAN SERVER KEY DARI FIREBASE CONSOLE -> PROJECT SETTINGS -> CLOUD MESSAGING
      // (Jika pakai FCM v1 API, caranya agak beda butuh OAuth, ini contoh Legacy API)
      const String serverKey = "AAAA.... (Kunci Server Anda)"; 
      
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$judul - $kategori',
              'title': 'Laporan Baru Masuk!',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': '/topics/admin_notif', // Kirim ke topik admin
          },
        ),
      );
      debugPrint("Push notif dikirim ke admin");
    } catch (e) {
      debugPrint("Gagal kirim push notif: $e");
    }
  }

  Future<void> _submitReport(BuildContext context) async {
    setState(() => _isLoading = true);
    

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anda harus login.')));
        setState(() => _isLoading = false);
      }
      return;
    }
    
    final pelapor = user.email ?? user.uid;
    
    try {
      // 1. Tentukan ID Laporan baru
      final docRef = FirebaseFirestore.instance.collection('laporan').doc();
      final laporanId = docRef.id;
      
      // Catatan: Logika upload gambar ke Firebase Storage diabaikan di sini 
      // untuk fokus pada data passing, namun harus diimplementasikan secara riil.
      String? imageUrl = widget.draft.imageFile != null ? 'path/to/uploaded/image.jpg' : null; 
      
      // 2. Buat objek Laporan lengkap (Asumsi: Anda punya Laporan Model yang bisa di-import)
      final newLaporan = Laporan(
        id: laporanId,
        judul: widget.draft.judul ?? '',
        lokasi: widget.draft.address ?? 'Lokasi tidak tersedia',
        detailLokasi: widget.draft.detailLokasi ?? '',
        deskripsi: widget.draft.deskripsi ?? '',
        kategori: widget.draft.kategori ?? '',
        jenis: widget.draft.jenis ?? '',
        pelapor: pelapor,
        status: 'Menunggu',
        tanggal: DateTime.now().toString().substring(0, 10), // Format tanggal sederhana
        statusColor: const Color(0xFF005AC2), // Warna status 'Baru'
        imagePath: imageUrl ?? (widget.draft.imageFile?.path ?? 'assets/images/placeholder.png'),
      );

      // 3. Simpan ke Firestore
      // Asumsi: Laporan Model memiliki metode toMap() yang sesuai
      final dataToSave = newLaporan.toMap(); 
      await docRef.set(dataToSave);

      // --- TAMBAHKAN INI ---
      // Kirim push notif ke Admin
      _sendPushNotificationToAdmin(widget.draft.judul ?? 'Laporan', widget.draft.kategori ?? 'Umum');
      
      // 4. Sukses: Navigasi ke Halaman Laporan Terkirim (ReportSentPage)
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ReportSentPage(newLaporan: newLaporan)), 
          (route) => route.isFirst, // Kembali ke root (Dashboard)
        );
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengirim laporan: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
              child: widget.draft.imageFile != null 
                ? Image.file(
                    widget.draft.imageFile!, // Tampilkan gambar dari draft
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    "https://via.placeholder.com/600x300", // Placeholder jika tidak ada file
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
            ),
            const SizedBox(height: 20),

            // Item-item Review (FIXED: Menggunakan data dari draft)
            _buildReviewItem("Judul Laporan", widget.draft.judul ?? '-'),
            _buildReviewItem("Lokasi Laporan", widget.draft.address ?? '-'),
            _buildReviewItem("Detail Lokasi Laporan", widget.draft.detailLokasi ?? '-'),
            _buildReviewItem("Deskripsi Laporan", widget.draft.deskripsi ?? '-'),
            _buildReviewItem("Kategori Laporan", widget.draft.kategori ?? '-'),
            _buildReviewItem("Jenis Laporan", widget.draft.jenis ?? '-'),

            const SizedBox(height: 20),
            
            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _submitReport(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Laporan"),
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

// --- 7. LAPORAN TERKIRIM (ReportSentPage) - BARU ---
class ReportSentPage extends StatelessWidget {
  final Laporan newLaporan;
  
  const ReportSentPage({super.key, required this.newLaporan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Laporan Terkirim'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              const Text(
                'Laporan Berhasil Dikirim!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Terima kasih telah berpartisipasi. Petugas kami akan segera menindaklanjuti laporan Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // TOMBOL TINJAU LAPORAN DIPERBAIKI: Navigasi ke detail laporan yang baru
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetailPage(laporan: newLaporan), // <-- Meneruskan objek laporan yang baru
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0055D4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Tinjau Laporan Saya'),
                ),
              ),
              
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    // Kembali ke dashboard (rute pertama)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Kembali ke Beranda', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}