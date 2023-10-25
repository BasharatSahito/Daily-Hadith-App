import 'package:flutter/material.dart';

class HadithDetail extends StatefulWidget {
  final int hadithId;
  final String hadithTitle;
  final String arabicHadith;
  final String urduHadith;
  final String englishHadith;
  final String hadithInfo;
  const HadithDetail({
    super.key,
    required this.hadithId,
    required this.hadithTitle,
    required this.arabicHadith,
    required this.urduHadith,
    required this.englishHadith,
    required this.hadithInfo,
  });

  @override
  State<HadithDetail> createState() => _HadithDetailState();
}

class _HadithDetailState extends State<HadithDetail> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detailed Hadith"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.05,
              right: screenWidth * 0.03,
              left: screenWidth * 0.03,
              bottom: screenHeight * 0.05),
          child: Column(
            children: [
              Text(
                widget.hadithInfo.toString(),
                style: TextStyle(
                    fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: screenHeight * .03,
              ),
              Text(
                widget.arabicHadith.toString(),
                style: TextStyle(
                    fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: screenHeight * .03,
              ),
              Divider(thickness: screenWidth * 0.003),
              SizedBox(
                height: screenHeight * .03,
              ),
              Text(
                widget.urduHadith.toString(),
                style: TextStyle(
                    fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: screenHeight * .03,
              ),
              Divider(thickness: screenWidth * 0.003),
              SizedBox(
                height: screenHeight * .03,
              ),
              Text(
                widget.englishHadith.toString(),
                style: TextStyle(
                    fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
