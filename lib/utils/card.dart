import 'package:daily_hadees_app/utils/alertbox.dart';
import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  final String urduHadith;
  final String arabicHadith;
  final String englishHadith;
  final String hadithInfo;
  const Cards({
    super.key,
    required this.arabicHadith,
    required this.englishHadith,
    required this.urduHadith,
    required this.hadithInfo,
  });

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final contentFontSize = screenWidth * 0.045;
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Card(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: Column(
          children: [
            widget.arabicHadith.length > 100
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.arabicHadith.toString().substring(0, 200),
                        style: TextStyle(
                            fontSize: contentFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertBox(
                                        hadithInfo:
                                            widget.hadithInfo.toString(),
                                        hadith: widget.arabicHadith.toString());
                                  },
                                );
                              },
                              child: const Text("...More")),
                        ],
                      ),
                    ],
                  )
                : Text(
                    widget.arabicHadith.toString(),
                    style: TextStyle(
                        fontSize: contentFontSize, fontWeight: FontWeight.bold),
                  ),
            Divider(thickness: screenWidth * 0.003),
            SizedBox(height: screenHeight * 0.01),
            widget.urduHadith.length > 100
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.urduHadith.toString().substring(0, 100),
                        style: TextStyle(
                            fontSize: contentFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertBox(
                                        hadithInfo:
                                            widget.hadithInfo.toString(),
                                        hadith: widget.urduHadith.toString());
                                  },
                                );
                              },
                              child: const Text("...More")),
                          TextButton(
                              onPressed: () {},
                              child: const Text("Translate to English")),
                        ],
                      ),
                    ],
                  )
                : Text(
                    widget.urduHadith.toString(),
                    style: TextStyle(
                        fontSize: contentFontSize, fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: screenHeight * 0.001),
            Text(widget.hadithInfo.toString())
          ],
        ),
      )),
    );
  }
}
