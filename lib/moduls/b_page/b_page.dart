import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BPage extends StatefulWidget {
  const BPage({super.key});

  @override
  State<BPage> createState() => _BPageState();
}

class _BPageState extends State<BPage> {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String _crudTitle = '';
  String _crudDatetime = '';
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.codename': build.version.codename,
      'manufacturer': build.manufacturer,
      'model': build.model,
    };
  }

  Future<void> _initPlatformState() async {
    var deviceData = <String, dynamic>{};

    if(defaultTargetPlatform == TargetPlatform.android) {
      deviceData = _readAndroidBuildData( await _deviceInfoPlugin.androidInfo );
    }

    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Column(
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: ListView(
              children: _deviceData.keys.map(
                    (String property) {
                  return Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          property,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: Text(
                              '${_deviceData[property]}',
                              style: const TextStyle(
                                  fontSize: 16
                              ),
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                  );
                },
              ).toList(),
            ),
          ),

            // Form(
            //   key: _formKey,
            //   child: Column(
            //     children: [
            //       TextFormField(
            //         decoration: const InputDecoration(
            //           labelText: 'Enter title',
            //           border: OutlineInputBorder(),
            //         ),
            //         onChanged: (text) {
            //           setState(() {
            //             _crudTitle = text;
            //           });
            //         },
            //       ),
            //       TextFormField(
            //         initialValue: DateTime.now().toString(),
            //         decoration: const InputDecoration(
            //           labelText: 'Datetime now',
            //           border: OutlineInputBorder(),
            //         ),
            //         onChanged: (text) {
            //           setState(() {
            //             _crudDatetime = text;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // )
          // ],
        // ),
      ),
    );
  }

}