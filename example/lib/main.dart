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
  int totalSamples = 0;
  WaveformType waveformType = WaveformType.polygon;

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
      "totalSamples": totalSamples != 0 ? totalSamples : 256,
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  ElevatedButton(
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
                    onPressed: () {
                      setState(() {
                        totalSamples = 256;
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
                height: 20,
              ),
              if (waveformType == WaveformType.polygon)
                PolygonWaveformExample(
                  maxDuration: maxDuration,
                  elapsedDuration: elapsedDuration,
                  samples: samples,
                )
              else if (waveformType == WaveformType.rectangle)
                RectangleWaveformExample(
                    maxDuration: maxDuration,
                    elapsedDuration: elapsedDuration,
                    samples: samples)
              else
                SquigglyWaveformExample(
                    maxDuration: maxDuration,
                    elapsedDuration: elapsedDuration,
                    samples: samples),
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
              Column(
                children: [
                  Text(
                    "Update Samples : $totalSamples",
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
                            audioPlayer.fixedPlayer!
                                .seek(Duration(milliseconds: 0));
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
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class SquigglyWaveformExample extends StatelessWidget {
  const SquigglyWaveformExample({
    Key? key,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
  }) : super(key: key);

  final int maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SquigglyWaveform(
        maxDuration: Duration(milliseconds: maxDuration),
        elapsedDuration: elapsedDuration,
        samples: samples,
        height: 300,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class RectangleWaveformExample extends StatelessWidget {
  const RectangleWaveformExample({
    Key? key,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
  }) : super(key: key);

  final int maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: RectangleWaveform(
        maxDuration: Duration(milliseconds: maxDuration),
        elapsedDuration: elapsedDuration,
        samples: samples,
        height: 300,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class PolygonWaveformExample extends StatelessWidget {
  const PolygonWaveformExample({
    Key? key,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
  }) : super(key: key);

  final int maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PolygonWaveform(
        maxDuration: Duration(milliseconds: maxDuration),
        elapsedDuration: elapsedDuration,
        samples: samples,
        height: 300,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

enum WaveformType {
  polygon,
  rectangle,
  squiggly,
}
