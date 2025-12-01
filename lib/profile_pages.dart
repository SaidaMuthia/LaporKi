import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11")),
                  Positioned(bottom: 0, right: 0, child: CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 18, child: const Icon(Icons.camera_alt, size: 18, color: Colors.white))),
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
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text("Simpan Perubahan"),
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
            decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300))),
          ),
        ],
      ),
    );
  }
}