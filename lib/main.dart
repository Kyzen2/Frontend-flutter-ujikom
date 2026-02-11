import 'package:flutter/material.dart';
import 'package:ujikomaplikasi/page/splashscreen.dart';
import 'package:ujikomaplikasi/page/muridview.dart';
import 'package:ujikomaplikasi/page/login.dart';
import 'package:ujikomaplikasi/page/guruview.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
