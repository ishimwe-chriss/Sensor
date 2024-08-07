import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart';

class MotionService {
  final StreamController<List<double>> _motionController = StreamController<List<double>>();
  final StreamController<int> _stepCounterController = StreamController<int>();
  final NotificationService _notificationService = NotificationService();

  bool _motionDetected = false;
  int _stepCount = 0;
  double _previousMagnitude = 0;
  DateTime _lastStepTime = DateTime.now();

  MotionService() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      final motionData = [event.x, event.y, event.z];
      _motionController.add(motionData);
      _detectSteps(motionData);
      _detectMotion(motionData);
    });
  }

  Stream<List<double>> get motionStream => _motionController.stream;
  Stream<int> get stepCountStream => _stepCounterController.stream;

  void _detectMotion(List<double> motionData) {
    if (!_motionDetected && motionData.any((element) => element.abs() > 2)) {
      _motionDetected = true;
      _notificationService.showNotification('Motion Detected', 'Significant motion detected by accelerometer.');
      Timer(Duration(seconds: 5), () => _motionDetected = false); // reset detection state after 5 seconds
    }
  }

  void _detectSteps(List<double> motionData) {
    double magnitude = sqrt(motionData[0] * motionData[0] + motionData[1] * motionData[1] + motionData[2] * motionData[2]);
    double delta = magnitude - _previousMagnitude;
    _previousMagnitude = magnitude;

    // Add a minimum time interval between steps to reduce false positives
    DateTime now = DateTime.now();
    if (delta.abs() > 1.5 && now.difference(_lastStepTime).inMilliseconds > 300) { // Adjust threshold and time interval
      _stepCount++;
      _lastStepTime = now;
      _stepCounterController.add(_stepCount);
    }
  }

  void dispose() {
    _motionController.close();
    _stepCounterController.close();
  }
}
