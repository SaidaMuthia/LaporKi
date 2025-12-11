import 'package:flutter/material.dart';

class LihatGambarScreen extends StatelessWidget {
  final String imagePath;
  const LihatGambarScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Lihat Gambar', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}