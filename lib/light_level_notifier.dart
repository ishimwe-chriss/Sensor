import 'package:flutter/material.dart';

class LightLevelNotifier extends ChangeNotifier {
  double _lightLevel = 0.0;

  double get lightLevel => _lightLevel;

  void updateLightLevel(double newLevel) {
    _lightLevel = newLevel;
    notifyListeners();
  }
}
