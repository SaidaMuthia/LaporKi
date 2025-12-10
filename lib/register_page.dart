import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Database

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 1. Siapkan Controller untuk membaca inputan
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController(); // TAMBAHAN UNTUK NIK
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false; // Untuk loading spinner

  // FUNGSI UNTUK MENDAFTAR
  Future<void> _registerUser() async {
    // Validasi input kosong
    if (_namaController.text.isEmpty || 
        _nikController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom (termasuk NIK) wajib diisi!")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama!")),
      );
      return;
    }

    setState(() => _isLoading = true); // Mulai Loading

    try {
      // LANGKAH 1: Buat Akun di Authentication (Email & Pass)
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid; // Ambil UID unik dari Firebase

      // LANGKAH 2: Simpan Data Detail ke Firestore (Sesuai Request Anda)
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': _emailController.text.trim(),
        'nama_lengkap': _namaController.text.trim(),
        'nik': _nikController.text.trim(), // Data NIK dari input
        'password': _passwordController.text.trim(), // (Catatan: Sebaiknya jangan simpan password text asli di DB demi keamanan, tapi ini sesuai request Anda)
        'photoUrl': '', // Kosongkan dulu atau isi link default
        'role': 'user', // Default role adalah user
        'createdAt': FieldValue.serverTimestamp(), // Timestamp otomatis server
      });

      // Jika sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi Berhasil! Silakan Login.")),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      }

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Eror: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false); // Stop Loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Daftar Akun")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text("Buat Akun Baru", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // INPUT NAMA LENGKAP
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),

            // INPUT NIK (Tambahan Sesuai Request Database)
            TextFormField(
              controller: _nikController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "NIK",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 15),

            // INPUT EMAIL
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),

            // INPUT PASSWORD
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Kata Sandi",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // KONFIRMASI PASSWORD
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Ulangi Kata Sandi",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),

            // TOMBOL DAFTAR
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerUser, // Panggil fungsi di sini
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005AC2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Daftar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}