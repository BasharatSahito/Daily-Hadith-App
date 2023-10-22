import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, "/homepage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: FractionallySizedBox(
      widthFactor: 0.6, // Adjust the width factor as needed
      child: Image(
        image: AssetImage("assets/logo.png"),
        fit: BoxFit.contain, // Maintain the aspect ratio
      ),
    )));
  }
}
