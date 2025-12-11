import 'package:flutter/material.dart';

// Gunakan ValueNotifier untuk menyimpan status indeks BottomNavBar saat ini
final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);