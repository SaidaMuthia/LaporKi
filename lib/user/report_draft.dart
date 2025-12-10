import 'dart:io';

class ReportDraft {
  File? imageFile;
  String? imageUrl; // For web or after upload
  double? latitude;
  double? longitude;
  String? address;
  String? detailLokasi;
  String? judul;
  String? deskripsi;
  String? kategori;
  String? jenis;
  DateTime? createdAt;

  ReportDraft({
    this.imageFile,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.address,
    this.detailLokasi,
    this.judul,
    this.deskripsi,
    this.kategori,
    this.jenis,
    this.createdAt,
  });

  Map<String, dynamic> toMap({required String pelapor, required String status}) {
    return {
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'detailLokasi': detailLokasi,
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'jenis': jenis,
      'pelapor': pelapor,
      'status': status,
      'createdAt': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}
