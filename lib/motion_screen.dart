import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'motion_notifier.dart';
import 'motion_service.dart';

class MotionScreen extends StatefulWidget {
  @override
  _MotionScreenState createState() => _MotionScreenState();
}

class _MotionScreenState extends State<MotionScreen> {
  final MotionService _motionService = MotionService();

  @override
  void initState() {
    super.initState();
    _motionService.motionStream.listen((motionData) {
      Provider.of<MotionNotifier>(context, listen: false).updateMotionData(motionData);
    });
    _motionService.stepCountStream.listen((stepCount) {
      Provider.of<MotionNotifier>(context, listen: false).updateStepCount(stepCount);
    });
  }

  @override
  void dispose() {
    _motionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motionData = Provider.of<MotionNotifier>(context).motionData;
    final stepCount = Provider.of<MotionNotifier>(context).stepCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Motion Detection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: motionData.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Steps: $stepCount',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
