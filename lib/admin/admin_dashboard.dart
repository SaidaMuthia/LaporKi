import 'package:flutter/material.dart';
import 'package:laporki/admin/fragments.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const AdminDashboard({super.key, this.userData});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AdminHomePage(userData: widget.userData),
      const LaporanAdminPage(),
      const NotificationFragment(),
      AccountFragment(userData: widget.userData),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // BODY
      body: _pages[_selectedIndex],

      // --- ADMIN NAVBAR (Tanpa FAB Tengah) ---
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        height: 80, 
        padding: EdgeInsets.zero, 
        // Tidak ada shape CircularNotchedRectangle karena tidak ada tombol tengah
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Bagi rata 4 item
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

  // Helper Widget untuk Item Navigasi (Desain SAMA PERSIS dengan User)
  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    final Color activeColor = const Color(0xFF005AC2);
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? activeColor : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : Colors.grey,
              fontSize: 11, 
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}