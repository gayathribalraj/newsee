import 'package:flutter/material.dart';

class DraftEventNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

final draftEventNotifier = DraftEventNotifier();
