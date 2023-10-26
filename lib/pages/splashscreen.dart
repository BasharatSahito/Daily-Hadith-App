import 'dart:async';
import 'package:daily_hadees_app/services/fetchjsondata.dart';
import 'package:daily_hadees_app/services/payloadprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GetHadith getHadith = GetHadith();

  @override
  void initState() {
    super.initState();
    fetchHadith();
    navigateToScreen();
  }

  List hadithList = [];
  void fetchHadith() async {
    await getHadith.getHadith();
    setState(() {
      hadithList = getHadith.hadithList;
    });
  }

  void navigateToScreen() {
    final payloadProvider =
        Provider.of<PayloadProvider>(context, listen: false);

    bool? payloadBool = payloadProvider.payloadBool;
    int? pendingIndex = payloadProvider.hadithIndex;

    if (payloadBool == true) {
      Timer(const Duration(seconds: 1), () {
        Navigator.pushNamed(context, "/hadithdetail", arguments: {
          'hadithId': hadithList[pendingIndex!].id,
          'hadithTitle': hadithList[pendingIndex].title.toString(),
          'arabicHadith': hadithList[pendingIndex].arabicHadith.toString(),
          'urduHadith': hadithList[pendingIndex].urduHadith.toString(),
          'englishHadith': hadithList[pendingIndex].englishHadith.toString(),
          'hadithInfo': hadithList[pendingIndex].info.toString(),
        });
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "/homepage");
      });
    }
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
