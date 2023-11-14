import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  final int hadithId;
  final int hadithIndex;
  final String hadithTitle;
  final String arabicHadith;
  final String urduHadith;
  final String englishHadith;
  final String hadithInfo;
  const Cards({
    super.key,
    required this.hadithId,
    required this.hadithIndex,
    required this.hadithTitle,
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
    final contentFontSize = screenWidth * 0.05;
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/hadithdetail", arguments: {
            'hadithId': widget.hadithId,
            'hadithTitle': widget.hadithTitle,
            'arabicHadith': widget.arabicHadith,
            'urduHadith': widget.urduHadith,
            'englishHadith': widget.englishHadith,
            'hadithInfo': widget.hadithInfo,
          });
        },
        child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Hadith ${widget.hadithIndex}",
                      style: TextStyle(
                          fontSize: contentFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  widget.arabicHadith.length > 200
                      ? Text(
                          widget.arabicHadith.toString().substring(0, 200),
                          style: TextStyle(
                              fontSize: contentFontSize,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          widget.arabicHadith.toString(),
                          style: TextStyle(
                              fontSize: contentFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "..Read the complete hadith",
                    style: TextStyle(
                        fontSize: contentFontSize * .8,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Divider(thickness: screenWidth * 0.003),
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(height: screenHeight * 0.001),
                  Center(
                      child: Text(
                    widget.hadithInfo.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ))
                ],
              ),
            )),
      ),
    );
  }
}
