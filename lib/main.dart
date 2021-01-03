import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity/flutter_unity.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UnityViewPage(),
    );
  }
}

class UnityViewPage extends StatefulWidget {
  @override
  _UnityViewPageState createState() => _UnityViewPageState();
}

class _UnityViewPageState extends State<UnityViewPage> {
  UnityViewController unityViewController;
  Color backgroundColor = Colors.white;
  Color contrastColor = Colors.black54;

  double speed = 0;
  double rotation = 0;
  bool showBack = false;
  bool openBlinds = false;
  bool openTrunk = false;

  bool openDFD = false;
  bool openDRD = false;
  bool openPFD = false;
  bool openPRD = false;

  String actualModel = 'Model S';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          actualModel,
          style: TextStyle(color: contrastColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4, color: contrastColor),
            onPressed: () {
              if (backgroundColor == Colors.white) {
                backgroundColor = Colors.black;
                contrastColor = Colors.white;
              } else {
                backgroundColor = Colors.white;
                contrastColor = Colors.black54;
              }
              String colorString = '${backgroundColor.red},${backgroundColor.blue},${backgroundColor.green}';
              unityViewController.send('MainCamera', 'SetBackgroundColor', colorString);
              Future.delayed(const Duration(milliseconds: 50), () {
                setState(() {});
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_horiz,
              color: contrastColor,
            ),
            onSelected: (String result) {
              setState(() {
                actualModel = result;
              });
              unityViewController.send(
                'Init',
                'loadModel',
                result.replaceAll(' ', '').toLowerCase(),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Model S',
                child: Text('Model S'),
              ),
              const PopupMenuItem<String>(
                value: 'Cybertruck',
                child: Text('Cybertruck'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1280 / 720,
              child: UnityView(
                onCreated: onUnityViewCreated,
                onReattached: onUnityViewReattached,
                onMessage: onUnityViewMessage,
              ),
            ),
          ),
          if (actualModel == 'Model S')
            Card(
              color: backgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Text('Rotation'),
                  ),
                  Slider.adaptive(
                    min: 0,
                    max: 100,
                    value: rotation,
                    onChanged: (val) {
                      setState(() {
                        rotation = val;
                      });
                      unityViewController.send(
                        actualModel.replaceAll(' ', ''),
                        'SetRotationSpeed',
                        '${val.toInt()}',
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Divider(),
                  ),
                  Text('Speed'),
                  Slider.adaptive(
                    min: 0,
                    max: 400,
                    value: speed,
                    onChanged: (val) {
                      setState(() {
                        speed = val;
                      });
                      unityViewController.send(
                        actualModel.replaceAll(' ', ''),
                        'SetCarSpeed',
                        '${val.toInt()}',
                      );
                    },
                  ),
                ],
              ),
            ),
          if (actualModel == 'Cybertruck')
            Wrap(
              children: [
                RaisedButton(
                  child: Text(showBack ? 'Show Front' : 'Show Back'),
                  onPressed: () {
                    setState(() {
                      showBack = !showBack;
                    });
                    unityViewController.send(
                      'MainCamera',
                      'showBack',
                      '$showBack',
                    );
                  },
                ),
                RaisedButton(
                  child: Text(openBlinds ? 'Close Blinds' : 'Open Blinds'),
                  onPressed: () {
                    setState(() {
                      openBlinds = !openBlinds;
                    });
                    unityViewController.send(
                      'Cybertruck',
                      'toggle',
                      'blinds,$openBlinds',
                    );
                  },
                ),
                RaisedButton(
                  child: Text(openTrunk ? 'Close Trunk' : 'Open Trunk'),
                  onPressed: () {
                    setState(() {
                      openTrunk = !openTrunk;
                    });
                    unityViewController.send(
                      'Cybertruck',
                      'toggle',
                      'trunkdoor,$openTrunk',
                    );
                  },
                ),
                RaisedButton(
                  child: Text(openDFD ? 'Close DFD' : 'Open DFD'),
                  onPressed: () {
                    setState(() {
                      openDFD = !openDFD;
                    });
                    unityViewController.send(
                      'Cybertruck',
                      'toggle',
                      'driverfrontdoor,$openDFD',
                    );
                  },
                ),
                RaisedButton(
                  child: Text(openDRD ? 'Close DFD' : 'Open DFD'),
                  onPressed: () {
                    setState(() {
                      openDRD = !openDRD;
                    });
                    unityViewController.send(
                      'Cybertruck',
                      'toggle',
                      'driverreardoor,$openDRD',
                    );
                  },
                ),
                RaisedButton(
                  child: Text(openPFD ? 'Close PFD' : 'Open PFD'),
                  onPressed: () {
                    setState(() {
                      openPFD = !openPFD;
                    });
                    unityViewController.send(
                      'Cybertruck',
                      'toggle',
                      'passengerfrontdoor,$openPFD',
                    );
                  },
                ),
                RaisedButton(
                  child: Text(openPRD ? 'Close PRD' : 'Open PRD'),
                  onPressed: () {
                    setState(() {
                      openPRD = !openPRD;
                    });
                    unityViewController.send(
                      'Cybertruck',
                      'toggle',
                      'passengerreardoor,$openPRD',
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  void onUnityViewCreated(UnityViewController controller) {
    debugPrint('onUnityViewCreated');

    setState(() {
      unityViewController = controller;
    });

    controller.send(
      'Init',
      'loadModel',
      actualModel.replaceAll(' ', '').toLowerCase(),
    );
  }

  void onUnityViewReattached(UnityViewController controller) {
    debugPrint('onUnityViewReattached');

    setState(() {
      unityViewController = controller;
    });
  }

  void onUnityViewMessage(UnityViewController controller, String message) {
    debugPrint('onUnityViewMessage');

    debugPrint(message);
  }
}
