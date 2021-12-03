import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/load_audio_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/polygon_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/rectangle_waveform/rectangle_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/squiggly_waveform/active_inactive_waveform_painter.dart';
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

  Future<void> parseData() async {
    final jsonString = await rootBundle.loadString('assets/sp.json');
    final dataPoints = await compute(loadparseJson, jsonString);
    await audioPlayer.load('/surface_pressure.mp3');
    await audioPlayer.play('/surface_pressure.mp3');
    maxDuration = await audioPlayer.fixedPlayer!.getDuration();
    setState(() {
      samples = dataPoints;
    });
    log('samples: $samples');
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
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  //   color: Colors.white,
                  child: SquigglyWaveform(
                    maxDuration: Duration(milliseconds: maxDuration),
                    elapsedDuration: elapsedDuration,
                    samples: samples,
                    height: 100,
                    showActiveWaveform: false,
                    width: MediaQuery.of(context).size.width,
                    // activeGradient: const LinearGradient(
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //     colors: [
                    //       Color(0xFFff3400),
                    //       Color(0xFFff6d00),
                    //     ],
                    //     stops: [
                    //       0,
                    //       1,
                    //     ]),
                  ),
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
                  //    await audioPlayer.fixedPlayer!.resume();
                },
                onChanged: (val) {
                  setState(() {
                    sliderValue = val;
                    audioPlayer.fixedPlayer!.seek(
                        Duration(milliseconds: (maxDuration * val).toInt()));
                  });
                },
              ),
            ],
          ),
        ));
  }
}
