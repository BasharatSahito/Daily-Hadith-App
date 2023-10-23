import 'package:flutter/material.dart';

class PayloadProvider with ChangeNotifier {
  String _payload = "";

  String get payload => _payload;

  void setPayload(String payload) {
    _payload = payload;
    notifyListeners();
  }
}
