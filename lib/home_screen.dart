import 'package:flutter/material.dart';
import 'motion_screen.dart';
import 'light_level_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MotionScreen()),
                );
              },
              child: Text('Go to Motion Screen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LightLevelScreen()),
                );
              },
              child: Text('Go to Light Level Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
