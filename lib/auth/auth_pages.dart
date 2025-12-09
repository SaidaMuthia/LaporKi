import 'package:flutter/material.dart';
import 'package:laporki/user/user_dashboard.dart'; // Pastikan path ini benar

// --- ONBOARDING PAGE ---
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005AC2), // Warna primary
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Selamat Datang di\nLaporKi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.location_city, size: 80, color: Color(0xFF005AC2)),
            ),
            const SizedBox(height: 40),
            const Text(
              'Suara Ta\' Didengar\nMasalah Ta\' Ditindak',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const LoginPage())
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Mulai Sekarang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- LOGIN PAGE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const OnboardingPage())
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selamat Datang", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTabToggle(context, isLogin: true),
            const SizedBox(height: 30),
            TextFormField(
              decoration: _inputDecoration("Masukkan Email"),
            ),
            const SizedBox(height: 15),
            TextFormField(
              obscureText: _obscureText,
              decoration: _inputDecoration("Masukkan Kata Sandi").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(value: false, onChanged: (v) {}),
                const Text("Ingat Saya"),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text("Lupa Kata Sandi?")),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const UserDashboard())
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005AC2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Masuk", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun? "),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const RegisterPage())
                  ),
                  child: const Text("Buat Akun", style: TextStyle(color: Color(0xFF005AC2), fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- REGISTER PAGE ---
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;         // Untuk password
  bool _obscureConfirmText = true;  // Untuk konfirmasi password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const OnboardingPage())
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Buat Akun", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTabToggle(context, isLogin: false),
            const SizedBox(height: 30),
            TextFormField(decoration: _inputDecoration("Masukkan Nama Lengkap")),
            const SizedBox(height: 15),
            TextFormField(decoration: _inputDecoration("Masukkan Email")),
            const SizedBox(height: 15),
            
            // Password Field
            TextFormField(
              obscureText: _obscureText,
              decoration: _inputDecoration("Masukkan Kata Sandi").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Konfirmasi Password Field (SUDAH DIPERBAIKI)
            TextFormField(
              obscureText: _obscureConfirmText, // Gunakan variabel khusus konfirmasi
              decoration: _inputDecoration("Konfirmasi Kata Sandi").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirmText = !_obscureConfirmText),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Daftar Berhasil!")));
                   Navigator.pushReplacement(
                     context, 
                     MaterialPageRoute(builder: (context) => const LoginPage())
                   );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005AC2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Daftar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginPage())
                  ),
                  child: const Text("Masuk", style: TextStyle(color: Color(0xFF005AC2), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
Widget _buildTabToggle(BuildContext context, {required bool isLogin}) {
  return Container(
    height: 50,
    decoration: BoxDecoration(color: const Color(0xffE6ECFA), borderRadius: BorderRadius.circular(25)),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isLogin ? null : () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const LoginPage())
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: isLogin ? BoxDecoration(color: const Color(0xFF005AC2), borderRadius: BorderRadius.circular(25)) : null,
              child: Text("Masuk", style: TextStyle(color: isLogin ? Colors.white : Colors.black54, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: !isLogin ? null : () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const RegisterPage())
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: !isLogin ? BoxDecoration(color: const Color(0xFF005AC2), borderRadius: BorderRadius.circular(25)) : null,
              child: Text("Daftar", style: TextStyle(color: !isLogin ? Colors.white : Colors.black54, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    ),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF5F7FA),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );
}