import 'dart:async';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class APage extends StatefulWidget {
  const APage({super.key});

  @override
  State<APage> createState() => _APageState();
}

class _APageState extends State<APage> {
  final DateTime _timeNow = DateTime.now();

  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  String _latitude = '0';
  String _longitude = '0';
  bool _locationEnabled = false;

  void _startAccelerometer() {
    _streamSubscriptions.add(
      accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerValues = <double>[event.x, event.y, event.z];
        });
      })
    );
  }

  void _startMagnetometer() {
    _streamSubscriptions.add(
        magnetometerEvents.listen((MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        })
    );
  }

  void _startGyroscope() {
    _streamSubscriptions.add(
        gyroscopeEvents.listen((GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        })
    );
  }

  Future<void> _checkLocationEnabled({bool fromLocationSetting = false}) async {
    if(!fromLocationSetting) {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      setState(() {
        _locationEnabled = enabled;
      });

      if (!enabled) {
        _showLocationDialog();
      }
      else {
        _getCurrentLocation();
      }
    }
    else {
      setState(() {
        _locationEnabled = true;
      });
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
        setState(() => {
          _latitude = position.latitude.toString(),
          _longitude = position.longitude.toString()
        });
      }).catchError((e) {
        debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _showLocationDialog() async {
    bool result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enable Location'),
            content: const Text('Please enable location services to continue.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false) ;
                  },
                  child: const Text('CANCEL')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('OK')),
            ],
          );
        });
    if (result) {
      Geolocator.openLocationSettings().then((_) {
        setState(() {
          _checkLocationEnabled(fromLocationSetting: true);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startAccelerometer();
    _startGyroscope();
    _startMagnetometer();
    _checkLocationEnabled();
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
    final accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope = _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final magnetometer = _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                'Waktu sekarang: ${_timeNow.toString()}',
                style: const TextStyle(
                  fontSize: 16
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                'Tanggal: ${DateTime(_timeNow.year, _timeNow.month, _timeNow.day).toString().replaceAll("00:00:00.000", "")}',
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                'Accelerometer: $accelerometer',
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                'Gyroscope: $gyroscope',
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                'Magnetometer: $magnetometer',
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: _locationEnabled ?
              Text(
                'GPS Coordinate -> Latitude: $_latitude, Longitude: $_longitude',
                style: const TextStyle(
                    fontSize: 16
                ),
              ) : const Text(
                'Location services disabled.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            StreamBuilder(
              stream: BatteryInfoPlugin().androidBatteryInfoStream,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Battery Level: ${snapshot.data?.batteryLevel}%',
                      style: const TextStyle(
                          fontSize: 16
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              }
            ),
          ],
        ),
      ),
    );
  }

}