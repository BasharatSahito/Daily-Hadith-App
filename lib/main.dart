import 'package:daily_hadees_app/pages/hadith_detail_page.dart';
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
          "/hadithdetail": (context) {
            final Map<String, dynamic> args = ModalRoute.of(context)!
                .settings
                .arguments as Map<String, dynamic>;
            int hadithId = args["hadithId"];
            String hadithTitle = args["hadithTitle"];
            String arabicHadith = args["arabicHadith"];
            String urduHadith = args["urduHadith"];
            String englishHadith = args["englishHadith"];
            String hadithInfo = args["hadithInfo"];
            return HadithDetail(
              hadithId: hadithId,
              hadithTitle: hadithTitle,
              arabicHadith: arabicHadith,
              urduHadith: urduHadith,
              englishHadith: englishHadith,
              hadithInfo: hadithInfo,
            );
          }
        },
      ),
    );
  }
}
