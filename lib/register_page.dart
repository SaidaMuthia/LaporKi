import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _showPass = false;
  bool _showConfirmPass = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final nik = _nikController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password tidak cocok')));
      return;
    }
    if (nik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NIK wajib diisi')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final user = await AuthController().registerUser(email, pass, name, nik);
      try {
        await user.updateDisplayName(name);
        await user.reload();
      } catch (_) {}
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil')));
      
      // Pindah ke Login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));

    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";
      if (e.code == 'email-already-in-use') message = "Email sudah terdaftar";
      if (e.code == 'weak-password') message = "Password terlalu lemah";
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF005AC2);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Buat Akun",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                // TAB SWITCH
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xffe6ecfa),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text("Login",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text("Daftar",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // NAME FIELD
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama Lengkap",
                    filled: true,
                    fillColor: const Color(0xfff0f0f0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 15),

                // NIK FIELD
                TextFormField(
                  controller: _nikController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Masukkan NIK",
                    filled: true,
                    fillColor: const Color(0xfff0f0f0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'NIK wajib diisi' : null,
                ),
                const SizedBox(height: 15),

                // EMAIL FIELD
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
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email tidak boleh kosong';
                    final regex = RegExp(r'^[\w.+-]+@[\w.-]+\.[a-zA-Z]{2,}$');
                    if (!regex.hasMatch(v.trim())) return 'Email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPass,
                  decoration: InputDecoration(
                    hintText: "Masukkan Kata Sandi",
                    filled: true,
                    fillColor: const Color(0xfff0f0f0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: Icon(_showPass ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
                    if (v.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // CONFIRM PASSWORD
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_showConfirmPass,
                  decoration: InputDecoration(
                    hintText: "Konfirmasi Kata Sandi",
                    filled: true,
                    fillColor: const Color(0xfff0f0f0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: Icon(_showConfirmPass ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showConfirmPass = !_showConfirmPass),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Konfirmasi password tidak boleh kosong' : null,
                ),

                const SizedBox(height: 10),

                // CHECKBOX & LUPA PASSWORD
                Row(
                  children: [
                    Checkbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v ?? false)),
                    const Text("Ingat Saya"),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Lupa Kata Sandi?", style: TextStyle(color: Colors.blue)),
                    )
                  ],
                ),

                const SizedBox(height: 15),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isLoading ? null : registerUser,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Daftar", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text("Masuk",
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}