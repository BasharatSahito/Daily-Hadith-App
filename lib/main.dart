import 'package:daily_hadees_app/pages/homepage.dart';
import 'package:daily_hadees_app/pages/splashscreen.dart';
import 'package:daily_hadees_app/services/payloadprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PayloadProvider())],
      child: MaterialApp(
        title: 'Daily Hadith',
        debugShowCheckedModeBanner: false,
        initialRoute: "/splashscreen",
        routes: {
          "/splashscreen": (context) => const SplashScreen(),
          "/homepage": (context) => const HomePage(),
        },
      ),
    );
  }
}
