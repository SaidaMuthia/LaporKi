import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PickMapPage extends StatefulWidget {
  final double initialLat;
  final double initialLong;

  const PickMapPage({
    super.key, 
    this.initialLat = -5.147665,
    this.initialLong = 119.432731
  });

  @override
  State<PickMapPage> createState() => _PickMapPageState();
}

class _PickMapPageState extends State<PickMapPage> {
  final MapController _mapController = MapController();
  late LatLng _centerPoint;

  @override
  void initState() {
    super.initState();
    _centerPoint = LatLng(widget.initialLat, widget.initialLong);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geser Peta untuk Memilih"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              // Kembalikan koordinat yang dipilih ke halaman sebelumnya
              Navigator.pop(context, _centerPoint);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerPoint,
              initialZoom: 15.0,
              onPositionChanged: (camera, hasGesture) {
                // Update titik tengah saat peta digeser
                if (hasGesture) {
                  setState(() {
                    _centerPoint = camera.center!;
                  });
                }
              },
            ),
            children: [
              // Layer Peta OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.laporki',
              ),
            ],
          ),
          
          // Pin di Tengah Layar
          const Center(
            child: Icon(Icons.location_on, color: Colors.red, size: 50),
          ),
          
          // Tombol Pilih di Bawah
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _centerPoint);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0055D4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                "Pilih Lokasi Ini\n(${_centerPoint.latitude.toStringAsFixed(5)}, ${_centerPoint.longitude.toStringAsFixed(5)})",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}