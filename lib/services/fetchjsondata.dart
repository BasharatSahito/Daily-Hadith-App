import 'dart:convert';
import 'package:daily_hadees_app/Models/hadithmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class GetHadith {
  // Fetching the Hadith from Hadith.JSON into hadithList
  List<HadithModel> hadithList = [];
  Future<void> getHadith() async {
    try {
      String jsonString = await rootBundle.loadString("assets/hadiths.json");
      List<dynamic> jsonResponse = jsonDecode(jsonString);
      List<HadithModel> loadedHadith = jsonResponse
          .map((dynamic data) => HadithModel.fromJson(data))
          .toList();
      hadithList = loadedHadith;
    } catch (e) {
      if (kDebugMode) {
        print("Error Fetching Data");
      }
    }
  }
}
