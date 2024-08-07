import 'package:flutter/foundation.dart';

class MotionNotifier extends ChangeNotifier {
  List<double> _motionData = [0.0, 0.0, 0.0];
  int _stepCount = 0;

  List<double> get motionData => _motionData;
  int get stepCount => _stepCount;

  void updateMotionData(List<double> newMotionData) {
    _motionData = newMotionData;
    notifyListeners();
  }

  void updateStepCount(int newStepCount) {
    _stepCount = newStepCount;
    notifyListeners();
  }
}
