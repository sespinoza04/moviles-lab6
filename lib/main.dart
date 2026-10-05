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
      title: 'Login Perfil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
