import 'package:flutter/material.dart';

class AlertBox extends StatefulWidget {
  final String hadithInfo;
  final String hadith;
  const AlertBox({super.key, required this.hadith, required this.hadithInfo});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.05; // Adjust this factor as needed
    final contentFontSize = screenWidth * 0.04; // Adjust this factor as needed
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text(
            widget.hadithInfo,
            style:
                TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
          ),
          content: Text(
            widget.hadith,
            style: TextStyle(
                fontSize: contentFontSize, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
