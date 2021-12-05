import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/load_audio_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/polygon_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/rectangle_waveform/rectangle_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/squiggly_waveform/squiggly_waveform.dart';

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
  double widthMultipier = 1;
  ScrollController scrollController = ScrollController();

  Future<void> parseData() async {
    final jsonString = await rootBundle.loadString('assets/dm.json');
    final dataPoints = await compute(loadparseJson, jsonString);
    await audioPlayer.load('/dance_monkey.mp3');
    await audioPlayer.play('/dance_monkey.mp3');
    maxDuration = await audioPlayer.fixedPlayer!.getDuration();
    setState(() {
      samples = dataPoints;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      });
    });
    audioPlayer.fixedPlayer!.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        elapsedDuration = p;
        scrollController.jumpTo(scrollController.position.maxScrollExtent *
            (elapsedDuration.inMilliseconds / maxDuration));
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
              SizedBox(
                height: 100,
                child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    RectangleWaveform(
                      maxDuration: Duration(milliseconds: maxDuration),
                      elapsedDuration: elapsedDuration,

                      samples: samples,
                      height: 100,
                      width: MediaQuery.of(context).size.width * widthMultipier,
                      absolute: true,
                      invert: false,
                      showActiveWaveform: false,
                      activeBorderColor: Colors.transparent,
                      inactiveBorderColor: Colors.transparent,
                      // style: PaintingStyle.fill,
                      activeGradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.yellow,
                            Colors.red,
                            Colors.green,
                          ],
                          stops: [
                            0.3,
                            0.5,
                            0.7,
                          ]),
                      // inactiveGradient: LinearGradient(
                      //     begin: Alignment.centerLeft,
                      //     end: Alignment.centerRight,
                      //     colors: [
                      //       Colors.yellow,
                      //       Colors.red,
                      //       Colors.green,
                      //     ],
                      //     stops: [
                      //       0.3,
                      //       0.5,
                      //       0.7,
                      //     ]),
                    ),
                  ],
                ),
              ),
              // Container(
              //   height: 100,
              //   width: MediaQuery.of(context).size.width,
              //   color: Colors.red,
              // ),
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
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent * val);
                  setState(() {
                    sliderValue = val;
                    print(widthMultipier);
                    audioPlayer.fixedPlayer!.seek(
                        Duration(milliseconds: (maxDuration * val).toInt()));
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widthMultipier--;
                      });
                    },
                    child: Icon(
                      Icons.remove,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widthMultipier++;
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
