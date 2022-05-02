import 'dart:developer' as dev;

import 'package:audioplayers/audioplayers.dart';
import 'package:example/load_audio_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:scidart/numdart.dart' as numdart;
// import 'package:flutter_voice_processor/flutter_voice_processor.dart';
import 'package:scidart/scidart.dart' as scidart;

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
  late Duration maxDuration;
  late Duration elapsedDuration;
  late AudioCache audioPlayer;
  late List<double> samples;
  late numdart.ArrayComplex frequencies;
  double sliderValue = 0;
  double widthMultipier = 1;
  ScrollController scrollController = ScrollController();
  int totalSamples = 38795;

  int frameLength = 100;
  int sampleRate = 48000;
  // late VoiceProcessor _voiceProcessor;

  late List<String> audioData;

  List<List<String>> audioDataList = [
    [
      'assets/dm.json',
      'dance_monkey.mp3',
    ],
    [
      'assets/soy.json',
      'shape_of_you.mp3',
    ],
    [
      'assets/sp.json',
      'surface_pressure.mp3',
    ],
  ];

  Future<void> parseData() async {
    final json = await rootBundle.loadString(audioData[0]);
    Map<String, dynamic> audioDataMap = {
      "json": json,
      "totalSamples": totalSamples,
    };
    final samplesData = await compute(loadparseJson, audioDataMap);
    await audioPlayer.load(audioData[1]);
    await audioPlayer.play(audioData[1]);
    // maxDuration in milliseconds
    await Future.delayed(const Duration(milliseconds: 200));

    int maxDurationInmilliseconds =
        await audioPlayer.fixedPlayer!.getDuration();

    maxDuration = Duration(milliseconds: maxDurationInmilliseconds);
    setState(() {
      samples = samplesData["samples"];
      final numdart.ArrayComplex arrayComplex = numdart.ArrayComplex(samples
          .map<numdart.Complex>((e) => numdart.Complex(
                real: e,
              ))
          .toList());
      final frquenceyList = scidart.fft(
        arrayComplex,
        n: 256,
      );

      frquenceyList.removeWhere(
        (element) => element.real < 0,
      );
      frequencies = frquenceyList;
      dev.log(frquenceyList.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    audioPlayer = AudioCache(
      fixedPlayer: AudioPlayer(),
    );
    audioData = audioDataList[0];

    samples = List.generate(256, (index) => 0);
    parseData();
    // _voiceProcessor = VoiceProcessor.getVoiceProcessor(frameLength, sampleRate);
    // _voiceProcessor.addListener((buffer) {
    //   final newsamples = List.from(buffer).map<double>((sample) {
    //     sample as int;
    //     return sample.toDouble();
    //   }).toList();

    //   if (newsamples.reduce(max) > 250) {
    //     setState(() {
    //       final numdart.ArrayComplex arrayComplex =
    //           numdart.ArrayComplex(newsamples
    //               .map<numdart.Complex>((e) => numdart.Complex(
    //                     real: e,
    //                   ))
    //               .toList());
    //       final frquenceyList =
    //           scidart.fft(arrayComplex, n: 10000, normalization: true);

    //       // frquenceyList.removeWhere(
    //       //     (element) => element.real < 0 || element.imaginary < 0);
    //       dev.log(frquenceyList.toString());
    //       samples.addAll(newsamples);
    //     });
    //   } else {
    //     samples.add(0);
    //     setState(() {});

    //     // setState(() {
    //     //   //   samples = List.generate(256, (index) => 0);
    //     // });
    //   }
    // });

    // maxDuration = const Duration(milliseconds: 1000);

    // elapsedDuration = const Duration();
    // parseData();
    // audioPlayer.fixedPlayer!.onPlayerCompletion.listen((_) {
    //   setState(() {
    //     elapsedDuration = maxDuration;
    //   });
    // });
    // audioPlayer.fixedPlayer!.onAudioPositionChanged.listen((Duration p) {
    //   setState(() {
    //     elapsedDuration = p;
    //     //     scrollController.jumpTo(scrollController.position.maxScrollExtent *
    //     //          (elapsedDuration.inMilliseconds / maxDuration.inMilliseconds));
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
                painter: FrequencyDistributionPainter(frequencies: frequencies),
                size: Size(MediaQuery.of(context).size.width, 500)),
            CurvedPolygonWaveform(
              samples:
                  samples.sublist(samples.length - 100, samples.length - 1),
              height: 100,
              //    borderWidth: 0,
              width: MediaQuery.of(context).size.width,
              showActiveWaveform: false,
              // style: PaintingStyle.fill,
              // inactiveGradient: LinearGradient(
              //   colors: [
              //     Colors.blue,
              //     Colors.orange,
              //     Colors.yellow,
              //   ],
              //   stops: [0.3, 0.6, 0.9],
              // ),
            ),

            // Container(
            //   height: 100,
            //   width: MediaQuery.of(context).size.width,
            //   color: Colors.red,
            // ),
            // Slider(
            //   value: sliderValue.clamp(0, 1),
            //   min: 0,
            //   activeColor: Colors.red,
            //   max: 1,
            //   onChangeEnd: (double value) async {
            //     await audioPlayer.fixedPlayer!.resume();
            //   },
            //   onChangeStart: (double value) async {
            //     await audioPlayer.fixedPlayer!.pause();
            //   },
            //   onChanged: (val) {
            //     scrollController
            //         .jumpTo(scrollController.position.maxScrollExtent * val);
            //     setState(() {
            //       sliderValue = val;
            //       print(widthMultipier);
            //       audioPlayer.fixedPlayer!.seek(Duration(
            //           milliseconds:
            //               (maxDuration.inMilliseconds * val).toInt()));
            //     });
            //   },
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           widthMultipier--;
            //         });
            //       },
            //       child: Icon(
            //         Icons.remove,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 20,
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           widthMultipier++;
            //           //50
            //         });
            //       },
            //       child: Icon(Icons.add),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () async {
            //         final bool hasPermissions =
            //             await _voiceProcessor.hasRecordAudioPermission() ??
            //                 false;
            //         try {
            //           if (hasPermissions) {
            //             await _voiceProcessor.start();
            //           } else {
            //             print("Recording permission not granted");
            //           }
            //         } on PlatformException catch (ex) {
            //           print("Failed to start recorder: " + ex.toString());
            //         }
            //       },
            //       child: const Icon(Icons.mic),
            //     ),
            //     const SizedBox(
            //       width: 20,
            //     ),
            //     ElevatedButton(
            //       onPressed: () async {
            //         await _voiceProcessor.stop();
            //       },
            //       child: const Icon(Icons.stop_circle),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    audioPlayer.fixedPlayer!.pause();
                  },
                  child: const Icon(
                    Icons.pause,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    audioPlayer.fixedPlayer!.resume();
                  },
                  child: const Icon(Icons.play_arrow),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sliderValue = 0;
                      audioPlayer.fixedPlayer!
                          .seek(const Duration(milliseconds: 0));
                    });
                  },
                  child: const Icon(Icons.replay_outlined),
                ),
              ],
            )
          ],
        ));
  }
}

class FrequencyDistributionPainter extends CustomPainter {
  FrequencyDistributionPainter({required this.frequencies});
  numdart.ArrayComplex frequencies;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    for (var i = 0; i < frequencies.length; i++) {
      canvas.drawRect(
          Rect.fromLTWH((50 * i).toDouble(), size.height / 2, 50,
              -frequencies[i].real * 1000),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
