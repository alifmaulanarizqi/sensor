import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartData {
  _ChartData(this.index, this.x, this.y, this.z);

  final int index;
  final double x;
  final double y;
  final double z;
}

class CPage extends StatefulWidget {
  const CPage({super.key});

  @override
  State<CPage> createState() => _CPageState();
}

class _CPageState extends State<CPage> {
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<_ChartData> _accelerometerChartData = [];
  List<_ChartData> _gyrometerChartData = [];
  List<_ChartData> _magnetometerChartData = [];

  void _startAccelerometer() {
    _streamSubscriptions.add(
        accelerometerEvents.listen((AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = [event.x, event.y, event.z];
            _addChartData(_accelerometerValues!, 'accelerometer');
          });
        })
    );
  }

  void _startMagnetometer() {
    _streamSubscriptions.add(
        magnetometerEvents.listen((MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
            _addChartData(_magnetometerValues!, 'magnetometer');
          });
        })
    );
  }

  void _startGyroscope() {
    _streamSubscriptions.add(
        gyroscopeEvents.listen((GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
            _addChartData(_gyroscopeValues!, 'gyrometer');
          });
        })
    );
  }

  void _addChartData(List<double> values, String sensor) {
    if(sensor == 'accelerometer') {
      if (_accelerometerChartData.length >= 100) {
        _accelerometerChartData.removeAt(0);
      }
      _accelerometerChartData.add(_ChartData(
        _accelerometerChartData.length,
        values[0],
        values[1],
        values[2],
      ));
    }
    else if(sensor == 'gyrometer') {
      if (_gyrometerChartData.length >= 100) {
        _gyrometerChartData.removeAt(0);
      }
      _gyrometerChartData.add(_ChartData(
        _gyrometerChartData.length,
        values[0],
        values[1],
        values[2],
      ));
    }
    else {
      if (_magnetometerChartData.length >= 100) {
        _magnetometerChartData.removeAt(0);
      }
      _magnetometerChartData.add(_ChartData(
        _magnetometerChartData.length,
        values[0],
        values[1],
        values[2],
      ));
    }
  }

  Widget _displayChart({required String legendTitle, required List<_ChartData> data}) {
    return Container(
      width: 400,
      height: 300,
      margin: const EdgeInsets.fromLTRB(8, 16, 6, 0),
      child: SfCartesianChart(
        legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            title: LegendTitle(text: '$legendTitle', textStyle: const TextStyle(fontSize: 16))
        ),
        primaryXAxis: NumericAxis(),
        series: <LineSeries<_ChartData, int>>[
          LineSeries<_ChartData, int>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.index,
              yValueMapper: (_ChartData data, _) => data.x,
              color: Colors.red,
              name: 'X'
          ),
          LineSeries<_ChartData, int>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.index,
              yValueMapper: (_ChartData data, _) => data.y,
              color: Colors.blue,
              name: 'Y'
          ),
          LineSeries<_ChartData, int>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.index,
              yValueMapper: (_ChartData data, _) => data.z,
              color: Colors.green,
              name: 'Z'
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startAccelerometer();
    _startGyroscope();
    _startMagnetometer();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _displayChart(legendTitle: 'Accelerometer', data: _accelerometerChartData),
            _displayChart(legendTitle: 'Gyrometer', data: _gyrometerChartData),
            _displayChart(legendTitle: 'Magnetometer', data: _magnetometerChartData),
          ],
        ),
      ),
    );
  }

}