import 'dart:async';
import 'package:flutter/services.dart';

class LightLevelService {
  static const EventChannel _lightSensorChannel =
  EventChannel('com.example.light_sensor/ambient_light');

  Stream<double> getLightLevelStream() {
    return _lightSensorChannel
        .receiveBroadcastStream()
        .map((event) => event as double);
  }
}
