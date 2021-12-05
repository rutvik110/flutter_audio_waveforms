import 'package:audioplayers/audioplayers.dart';
import 'package:example/load_audio_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              // Padding(
              //     padding: const EdgeInsets.all(0.0),
              //     child: Container(
              //         color: Colors.white24,
              //         child: SquigglyWaveform(
              //           maxDuration: Duration(milliseconds: maxDuration),
              //           elapsedDuration: elapsedDuration,
              //           samples: samples,
              //           height: 500,
              //           width: MediaQuery.of(context).size.width,
              //           absolute: true,
              //           invert: false,
              //         ))),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  //   color: Colors.white24,
                  child: SquigglyWaveform(
                    maxDuration: Duration(milliseconds: maxDuration),
                    elapsedDuration: elapsedDuration,
                    samples: samples,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    // absolute: false,
                    // invert: false,
                    // borderWidth: 1,
                    // activeBorderColor: Colors.blue,
                    // activeGradient: LinearGradient(
                    //     begin: Alignment.centerLeft,
                    //     end: Alignment.centerRight,
                    //     colors: [
                    //       Colors.blue,
                    //       Colors.yellow,
                    //       Colors.blue,
                    //     ],
                    //     stops: [
                    //       0.3,
                    //       0.5,
                    //       0.7,
                    //     ]),
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
