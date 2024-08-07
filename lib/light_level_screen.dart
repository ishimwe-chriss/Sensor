import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'light_level_notifier.dart';
import 'light_level_service.dart';

class LightLevelScreen extends StatefulWidget {
  @override
  _LightLevelScreenState createState() => _LightLevelScreenState();
}

class _LightLevelScreenState extends State<LightLevelScreen> {
  final LightLevelService _lightLevelService = LightLevelService();

  @override
  void initState() {
    super.initState();
    _lightLevelService.getLightLevelStream().listen((lightLevel) {
      Provider.of<LightLevelNotifier>(context, listen: false).updateLightLevel(lightLevel);
      adjustLights(lightLevel);
    });
  }

  void adjustLights(double lightLevel) {
    if (lightLevel < 10) {
      // Simulate turning on the lights
      print('Turning on the lights...');
    } else if (lightLevel > 100) {
      // Simulate turning off the lights
      print('Turning off the lights...');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightLevel = Provider.of<LightLevelNotifier>(context).lightLevel;
    double bulbOpacity = (100 - lightLevel) / 100;
    bulbOpacity = bulbOpacity.clamp(0.0, 1.0);

    Color backgroundColor;
    if (lightLevel < 10) {
      backgroundColor = Colors.white;
    } else if (lightLevel > 100) {
      backgroundColor = Colors.black;
    } else {
      backgroundColor = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Light Level Sensor'),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Current light level:',
                style: TextStyle(color: backgroundColor == Colors.black ? Colors.white : Colors.black),
              ),
              Text(
                '$lightLevel',
                style: TextStyle(
                  color: backgroundColor == Colors.black ? Colors.white : Colors.black,
                  fontSize: 32,
                ),
              ),
              if (lightLevel < 10)
                Text(
                  'It\'s too dark! Turning on the lights...',
                  style: TextStyle(color: Colors.red),
                ),
              if (lightLevel > 100)
                Text(
                  'It\'s bright enough! Turning off the lights...',
                  style: TextStyle(color: Colors.green),
                ),
              SizedBox(height: 20),
              AnimatedOpacity(
                opacity: bulbOpacity,
                duration: Duration(milliseconds: 500),
                child: Image.asset(
                  'lib/assets/bulb.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
