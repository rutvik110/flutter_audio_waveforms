import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/load_audio_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int maxDuration;
  late Duration elapsedDuration;
  late AudioCache audioPlayer;
  late List<double> samples;
  double sliderValue = 0;
  int totalSamples = 256;
  WaveformType waveformType = WaveformType.polygon;
  late WaveformCustomizations waveformCustomizations;

  late List<String> audioData;

  List<List<String>> audioDataList = [
    [
      'assets/dm.json',
      '/dance_monkey.mp3',
    ],
    [
      'assets/soy.json',
      '/shape_of_you.mp3',
    ],
    [
      'assets/sp.json',
      '/surface_pressure.mp3',
    ],
  ];

  Future<void> parseData() async {
    audioPlayer.fixedPlayer!.stop();
    final json = await rootBundle.loadString(audioData[0]);
    Map<String, dynamic> audioDataMap = {
      "json": json,
      "totalSamples": totalSamples,
    };
    final samplesData = await compute(loadparseJson, audioDataMap);
    await audioPlayer.load(audioData[1]);
    await audioPlayer.play(audioData[1]);
    // maxDuration in milliseconds
    maxDuration = await audioPlayer.fixedPlayer!.getDuration();
    setState(() {
      samples = samplesData["samples"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioData = audioDataList[0];
    audioPlayer = AudioCache(
      fixedPlayer: AudioPlayer(),
    );

    samples = [];
    maxDuration = 1;
    elapsedDuration = const Duration();
    parseData();
    audioPlayer.fixedPlayer!.onPlayerCompletion.listen((_) {
      setState(() {
        elapsedDuration = Duration(milliseconds: maxDuration);
        sliderValue = 1;
      });
    });
    audioPlayer.fixedPlayer!.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        elapsedDuration = p;
        sliderValue = p.inMilliseconds.toDouble() / maxDuration;
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    waveformCustomizations = WaveformCustomizations(
      height: 300,
      width: MediaQuery.of(context).size.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizedBox = SizedBox(
      height: 10,
      width: 10,
    );
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Flutter Audio Waveforms'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: waveformType != WaveformType.polygon
                        ? Colors.blue
                        : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      totalSamples = 256;
                      waveformType = WaveformType.polygon;
                      parseData();
                    });
                  },
                  child: Text("Polygon"),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: waveformType != WaveformType.rectangle
                        ? Colors.blue
                        : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      totalSamples = 256;
                      waveformCustomizations.borderWidth = 1;
                      waveformType = WaveformType.rectangle;
                      parseData();
                    });
                  },
                  child: Text("Rectangle"),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: waveformType != WaveformType.squiggly
                        ? Colors.blue
                        : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      totalSamples = 256;
                      waveformType = WaveformType.squiggly;
                      parseData();
                    });
                  },
                  child: Text("Squiggly"),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            if (waveformType == WaveformType.polygon)
              PolygonWaveformExample(
                maxDuration: maxDuration,
                elapsedDuration: elapsedDuration,
                samples: samples,
                waveformCustomizations: waveformCustomizations,
              )
            else if (waveformType == WaveformType.rectangle)
              RectangleWaveformExample(
                maxDuration: maxDuration,
                elapsedDuration: elapsedDuration,
                samples: samples,
                waveformCustomizations: waveformCustomizations,
              )
            else
              SquigglyWaveformExample(
                maxDuration: maxDuration,
                elapsedDuration: elapsedDuration,
                samples: samples,
                waveformCustomizations: waveformCustomizations,
              ),
            SizedBox(
              height: 30,
            ),
            Slider(
              value: sliderValue.clamp(0, 1),
              min: 0,
              activeColor: Colors.red,
              max: 1,
              onChangeEnd: (double value) async {
                await audioPlayer.fixedPlayer!.resume();
              },
              onChangeStart: (double value) async {
                await audioPlayer.fixedPlayer!.pause();
              },
              onChanged: (val) {
                setState(() {
                  sliderValue = val;

                  audioPlayer.fixedPlayer!.seek(
                      Duration(milliseconds: (maxDuration * val).toInt()));
                });
              },
            ),
            Slider(
              value: totalSamples.toDouble(),
              min: 0,
              divisions: waveformType == WaveformType.polygon ? 100000 : 1000,
              activeColor: Colors.red,
              max: waveformType == WaveformType.polygon ? 100000 : 1000,
              onChangeEnd: (val) async {
                setState(() {
                  totalSamples = val.toInt();
                });
                parseData();
              },
              onChangeStart: (double value) async {},
              onChanged: (val) {},
            ),
            Text(
              "Samples : $totalSamples",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    audioPlayer.fixedPlayer!.pause();
                  },
                  child: Icon(
                    Icons.pause,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    audioPlayer.fixedPlayer!.resume();
                  },
                  child: Icon(Icons.play_arrow),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sliderValue = 0;
                      audioPlayer.fixedPlayer!.seek(Duration(milliseconds: 0));
                    });
                  },
                  child: Icon(Icons.replay_outlined),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      audioData = audioDataList[0];
                      parseData();
                    });
                  },
                  child: Icon(
                    Icons.music_note,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      audioData = audioDataList[1];
                      parseData();
                    });
                  },
                  child: Icon(
                    Icons.music_note,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      audioData = audioDataList[2];
                      parseData();
                    });
                  },
                  child: Icon(
                    Icons.music_note,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            sizedBox,
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Wrap(
                    children: [
                      Text(
                        "Height",
                        style: TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: waveformCustomizations.height,
                        min: 0,
                        onChanged: (height) {},
                        max: MediaQuery.of(context).size.height / 2,
                        onChangeEnd: (value) {
                          setState(() {
                            waveformCustomizations.height = value;
                          });
                        },
                      ),
                      sizedBox,
                      Text(
                        "Width",
                        style: TextStyle(color: Colors.white),
                      ),
                      Slider(
                        value: waveformCustomizations.width,
                        min: 0,
                        onChanged: (width) {},
                        max: MediaQuery.of(context).size.width,
                        onChangeEnd: (value) {
                          setState(() {
                            waveformCustomizations.width = value;
                          });
                        },
                      ),
                      sizedBox,
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            waveformCustomizations.inactiveGradient = null;
                            waveformCustomizations.inactiveColor =
                                Color.fromRGBO(
                                    Random().nextInt(255),
                                    Random().nextInt(255),
                                    Random().nextInt(255),
                                    1);
                          });
                        },
                        label: Text("Change IA-Color"),
                        icon: Icon(
                          Icons.color_lens,
                        ),
                      ),
                      sizedBox,
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            waveformCustomizations.activeGradient = null;
                            waveformCustomizations.activeColor = Color.fromRGBO(
                                Random().nextInt(255),
                                Random().nextInt(255),
                                Random().nextInt(255),
                                1);
                          });
                        },
                        label: Text("Change A-Color"),
                        icon: Icon(
                          Icons.color_lens,
                        ),
                      ),
                      sizedBox,
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            waveformCustomizations.inactiveGradient =
                                LinearGradient(colors: [
                              Color.fromRGBO(
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  1),
                              Color.fromRGBO(
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  1),
                            ], stops: [
                              0.4,
                              0.6
                            ]);
                          });
                        },
                        label: Text("Change IA-Gradient"),
                        icon: Icon(
                          Icons.color_lens,
                        ),
                      ),
                      sizedBox,
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            waveformCustomizations.activeGradient =
                                LinearGradient(colors: [
                              Color.fromRGBO(
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  1),
                              Color.fromRGBO(
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  Random().nextInt(255),
                                  1),
                            ], stops: [
                              0.4,
                              0.6
                            ]);
                          });
                        },
                        label: Text("Change A-Gradient"),
                        icon: Icon(
                          Icons.color_lens,
                        ),
                      ),
                      sizedBox,
                      Column(
                        children: [
                          Text("Absolute ",
                              style: TextStyle(color: Colors.white)),
                          Switch(
                            inactiveTrackColor: Colors.grey[300],
                            value: waveformCustomizations.absolute,
                            onChanged: (value) {
                              setState(() {
                                waveformCustomizations.absolute = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Invert ",
                              style: TextStyle(color: Colors.white)),
                          Switch(
                            inactiveTrackColor: Colors.grey[300],
                            value: waveformCustomizations.invert,
                            onChanged: (value) {
                              setState(() {
                                waveformCustomizations.invert = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Hide Active Waveform",
                              style: TextStyle(color: Colors.white)),
                          Switch(
                            inactiveTrackColor: Colors.grey[300],
                            value: !waveformCustomizations.showActiveWaveform,
                            onChanged: (value) {
                              setState(() {
                                waveformCustomizations.showActiveWaveform =
                                    !value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Specific Waveform Customizations",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (waveformType == WaveformType.polygon)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Style : ",
                                style: TextStyle(color: Colors.white)),
                            DropdownButton<PaintingStyle>(
                              value: waveformCustomizations.style,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              dropdownColor: Colors.black,
                              iconDisabledColor: Colors.white,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Stroke"),
                                  value: PaintingStyle.stroke,
                                ),
                                DropdownMenuItem(
                                  child: Text("Fill"),
                                  value: PaintingStyle.fill,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  waveformCustomizations.style = value!;
                                });
                              },
                            ),
                          ],
                        )
                      else if (waveformType == WaveformType.rectangle)
                        Wrap(
                          children: [
                            Text("BorderWidth : ",
                                style: TextStyle(color: Colors.white)),
                            Slider(
                                value: waveformCustomizations.borderWidth,
                                onChangeEnd: (value) {
                                  setState(() {
                                    waveformCustomizations.borderWidth = value;
                                  });
                                },
                                onChanged: (value) {}),
                            sizedBox,
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  waveformCustomizations.inactiveBorderColor =
                                      Color.fromRGBO(
                                          Random().nextInt(255),
                                          Random().nextInt(255),
                                          Random().nextInt(255),
                                          1);
                                });
                              },
                              label: Text("Change IA-BorderColor"),
                              icon: Icon(
                                Icons.color_lens,
                              ),
                            ),
                            sizedBox,
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  waveformCustomizations.activeBorderColor =
                                      Color.fromRGBO(
                                          Random().nextInt(255),
                                          Random().nextInt(255),
                                          Random().nextInt(255),
                                          1);
                                });
                              },
                              label: Text("Change A-BorderColor"),
                              icon: Icon(
                                Icons.color_lens,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Text("Stroke Width : ",
                              style: TextStyle(color: Colors.white)),
                          Slider(
                              value: waveformCustomizations.borderWidth,
                              max: 10,
                              onChangeEnd: (value) {
                                setState(() {
                                  waveformCustomizations.borderWidth = value;
                                });
                              },
                              onChanged: (value) {}),
                        ]),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class SquigglyWaveformExample extends StatelessWidget {
  const SquigglyWaveformExample({
    Key? key,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
    required this.waveformCustomizations,
  }) : super(key: key);

  final int maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;
  final WaveformCustomizations waveformCustomizations;

  @override
  Widget build(BuildContext context) {
    return SquigglyWaveform(
      maxDuration: Duration(milliseconds: maxDuration),
      elapsedDuration: elapsedDuration,
      samples: samples,
      height: waveformCustomizations.height,
      width: waveformCustomizations.width,
      inactiveColor: waveformCustomizations.inactiveColor,
      invert: waveformCustomizations.invert,
      absolute: waveformCustomizations.absolute,
      activeColor: waveformCustomizations.activeColor,
      showActiveWaveform: waveformCustomizations.showActiveWaveform,
      strokeWidth: waveformCustomizations.borderWidth,
    );
  }
}

class RectangleWaveformExample extends StatelessWidget {
  const RectangleWaveformExample({
    Key? key,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
    required this.waveformCustomizations,
  }) : super(key: key);

  final int maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;
  final WaveformCustomizations waveformCustomizations;

  @override
  Widget build(BuildContext context) {
    return RectangleWaveform(
      maxDuration: Duration(milliseconds: maxDuration),
      elapsedDuration: elapsedDuration,
      samples: samples,
      height: waveformCustomizations.height,
      width: waveformCustomizations.width,
      inactiveColor: waveformCustomizations.inactiveColor,
      inactiveGradient: waveformCustomizations.inactiveGradient,
      invert: waveformCustomizations.invert,
      absolute: waveformCustomizations.absolute,
      activeColor: waveformCustomizations.activeColor,
      activeGradient: waveformCustomizations.activeGradient,
      showActiveWaveform: waveformCustomizations.showActiveWaveform,
      borderWidth: waveformCustomizations.borderWidth,
      activeBorderColor: waveformCustomizations.activeBorderColor,
      inactiveBorderColor: waveformCustomizations.inactiveBorderColor,
    );
  }
}

class PolygonWaveformExample extends StatelessWidget {
  const PolygonWaveformExample({
    Key? key,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
    required this.waveformCustomizations,
  }) : super(key: key);

  final int maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;
  final WaveformCustomizations waveformCustomizations;

  @override
  Widget build(BuildContext context) {
    return PolygonWaveform(
      maxDuration: Duration(milliseconds: maxDuration),
      elapsedDuration: elapsedDuration,
      samples: samples,
      height: waveformCustomizations.height,
      width: waveformCustomizations.width,
      inactiveColor: waveformCustomizations.inactiveColor,
      inactiveGradient: waveformCustomizations.inactiveGradient,
      invert: waveformCustomizations.invert,
      absolute: waveformCustomizations.absolute,
      activeColor: waveformCustomizations.activeColor,
      activeGradient: waveformCustomizations.activeGradient,
      showActiveWaveform: waveformCustomizations.showActiveWaveform,
      style: waveformCustomizations.style,
    );
  }
}

enum WaveformType {
  polygon,
  rectangle,
  squiggly,
}

class WaveformCustomizations {
  WaveformCustomizations({
    required this.height,
    required this.width,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.blue,
    this.activeGradient,
    this.inactiveGradient,
    this.style = PaintingStyle.stroke,
    this.showActiveWaveform = true,
    this.absolute = false,
    this.invert = false,
    this.borderWidth = 1.0,
    this.activeBorderColor = Colors.white,
    this.inactiveBorderColor = Colors.white,
  });

  double height;
  double width;
  Color inactiveColor;
  Gradient? inactiveGradient;
  bool invert;
  bool absolute;
  Color activeColor;
  Gradient? activeGradient;
  bool showActiveWaveform;
  PaintingStyle style;
  double borderWidth;
  Color activeBorderColor;
  Color inactiveBorderColor;
}
