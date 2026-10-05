import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const ProfileLoginApp());
}

class ProfileLoginApp extends StatelessWidget {
  const ProfileLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nova ID',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE85D3F),
          primary: const Color(0xFFE85D3F),
          secondary: const Color(0xFF1F7A5C),
          surface: const Color(0xFFFFFBF5),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF3E6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF20352F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
