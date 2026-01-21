import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:basics/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nzcfspjsihfqmdcitbxy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56Y2ZzcGpzaWhmcW1kY2l0Ynh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc1NzkwODIsImV4cCI6MjA4MzE1NTA4Mn0.lwjVfeJKft-8r6BWu49aTcNzy8wOCfAQ1gev34JFUto',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
