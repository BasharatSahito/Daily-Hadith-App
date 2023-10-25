import 'package:flutter/material.dart';

class PayloadProvider with ChangeNotifier {
  bool? _payloadBool;

  bool? get payloadBool => _payloadBool;

  void setPayload(bool payloadBool) {
    _payloadBool = payloadBool;
    notifyListeners();
  }

  int? _payloadIndex;

  int? get payloadIndex => _payloadIndex;

  void setPayloadIndex(payloadIndex) {
    _payloadIndex = payloadIndex;
    notifyListeners();
  }

  int? _hadithIndex;

  int? get hadithIndex => _hadithIndex;

  void setHadithIndex(int hadithIndex) {
    _hadithIndex = hadithIndex;
    notifyListeners();
  }
}
