// lib/login_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import dari root lib/
import 'onboarding_page.dart';
import 'register_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// Jika Anda menggunakan Color di model, ini juga perlu:
import 'package:flutter/material.dart';

// --- 1. DEFINISI KELAS UTAMA (StatefulWidget) ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// --- 2. DEFINISI KELAS STATE ---
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- 3. FUNGSI LOGIN DENGAN PENGECEKAN ROLE ---
  Future<void> _loginUser() async {
    // 0. Validasi Form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau Password tidak valid")),
      );
      return;
    }

    // Tampilkan Loading
    if (!mounted) return;
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Login ke Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Ambil Data Role dari Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      
      // Tutup Loading
      if (!mounted) return;
      Navigator.pop(context); 

      if (userDoc.exists) {
        String role = userDoc.get('role'); // Ambil field 'role'

        // 3. Cek Role dan Arahkan (Menggunakan Named Routes)
        if (role == 'admin') {
          // Navigasi ke rute admin yang terdaftar di main.dart
          Navigator.pushReplacementNamed(context, '/admin'); 
        } else {
          // Navigasi ke rute dashboard user yang terdaftar di main.dart
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Berhasil!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data user tidak ditemukan di database.")),
        );
      }

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup Loading jika error
      
      String errorMessage = "Login Gagal";
      if (e.code == 'user-not-found') errorMessage = "Akun tidak ditemukan";
      else if (e.code == 'wrong-password') errorMessage = "Password salah";
      else if (e.code == 'invalid-credential') errorMessage = "Kredensial tidak valid";
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup Loading jika error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // --- 4. VALIDATOR ---
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Silakan masukkan email Anda';
    final regex = RegExp(r'^[\w.+-]+@[\w.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return 'Silakan masukkan email yang valid';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Silakan masukkan kata sandi Anda';
    if (value.length < 6) return 'Kata sandi minimal 6 karakter';
    return null;
  }

  // --- 5. WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF005AC2);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingPage()), 
            )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selamat Datang",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // TAB LOGIN - REGISTER
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xffe6ecfa),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text("Masuk",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text("Daftar",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // EMAIL
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Masukkan Email",
                      filled: true,
                      fillColor: const Color(0xfff0f0f0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                    ),
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 15),

                  // PASSWORD
                  TextFormField(
                    obscureText: !_showPassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Masukkan Kata Sandi",
                      filled: true,
                      fillColor: const Color(0xfff0f0f0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    validator: _passwordValidator,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                ),
                const Text("Ingat Saya"),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text("Lupa Kata Sandi?",
                      style: TextStyle(color: Colors.blue)),
                )
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _loginUser, 
                child: const Text("Masuk",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text("Buat Akun",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}