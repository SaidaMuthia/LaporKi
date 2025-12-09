import 'package:flutter/material.dart';
import './auth/auth_pages.dart';
import './user/user_dashboard.dart';
import './user/report_flow.dart';

void main() {
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
        primaryColor: const Color(0xFF005AC2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005AC2),
          primary: const Color(0xFF005AC2),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Background agak abu terang
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
        '/': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const UserDashboard(),
        '/report_permission': (context) => const LocationPermissionPage(),
      },
    );
  }
}