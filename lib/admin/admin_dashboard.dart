import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laporki/admin/fragments.dart';
import 'package:laporki/services/notification_service.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const AdminDashboard({super.key, this.userData});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _adminData;

  @override
  void initState() {
    super.initState();
    _fetchAdminData();

    NotificationService().subscribeToAdminTopic();
  }

  Future<void> _fetchAdminData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          if (mounted) {
            setState(() {
              _adminData = doc.data() as Map<String, dynamic>;
              if (_adminData != null && !_adminData!.containsKey('email')) {
                _adminData!['email'] = user.email;
              }
            });
          }
        }
      } catch (e) {
        debugPrint("Error fetch admin data: $e");
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AdminHomePage(userData: _adminData), 
      const LaporanAdminPage(),
      const NotificationFragment(),
      AccountFragment(userData: _adminData),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        height: 70, 
        padding: EdgeInsets.zero, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _buildNavItem(icon: Icons.home_rounded, label: "Beranda", index: 0)),
            Expanded(child: _buildNavItem(icon: Icons.assignment_rounded, label: "Laporan", index: 1)),
            Expanded(child: _buildNavItem(icon: Icons.notifications_rounded, label: "Notifikasi", index: 2)),
            Expanded(child: _buildNavItem(icon: Icons.person_rounded, label: "Akun", index: 3)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    final Color activeColor = const Color(0xFF005AC2);
    
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? activeColor : Colors.grey, size: 26),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? activeColor : Colors.grey, fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
}