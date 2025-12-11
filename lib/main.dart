import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'services/notification_service.dart';
import 'onboarding_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import './user/user_dashboard.dart';
import './user/report_flow.dart';
import 'admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
 );

  // --- TAMBAHKAN INI ---
  final notificationService = NotificationService();
  await notificationService.init();
  // ---------------------

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LaporKi',
      theme: ThemeData(
        // ... (Theme Data tetap sama) ...
        primaryColor: const Color(0xFF005AC2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005AC2),
          primary: const Color(0xFF005AC2),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => UserDashboard(),
        // '/report_permission': (context) => LocationPermissionPage(),
        '/admin': (context) => const AdminDashboard(),
      },
    );
  }
}