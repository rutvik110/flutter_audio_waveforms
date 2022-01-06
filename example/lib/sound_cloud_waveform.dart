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

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Audio Waveforms',
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
  late int totalSamples;

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
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Change this value to number of audio samples you want.
    // Values between 256 and 1024 are good for showing [RectangleWaveform] and [SquigglyWaveform]
    // While the values above them are good for showing [PolygonWaveform]
    totalSamples = 512;
    audioData = audioDataList[0];
    audioPlayer = AudioCache(
      fixedPlayer: AudioPlayer(),
    );

    samples = [];
    maxDuration = const Duration(milliseconds: 1000);
    elapsedDuration = const Duration();
    parseData();
    audioPlayer.fixedPlayer!.onPlayerCompletion.listen((_) {
      setState(() {
        elapsedDuration = maxDuration;
      });
    });
    audioPlayer.fixedPlayer!.onAudioPositionChanged
        .listen((Duration timeElapsed) {
      setState(() {
        elapsedDuration = timeElapsed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 30,
      width: 30,
    );
    const minoractiveColor = Color(0xFFffbf99);
    const minorinactiveColor = Color(0xFFE1DFDF);
    const borderColor = Color(0xFFEBEBEB);
    return Scaffold(
      backgroundColor: borderColor,
      appBar: AppBar(
        title: const Text('SoundCloud Waveform'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RectangleWaveform(
            maxDuration: maxDuration,
            elapsedDuration: elapsedDuration,
            samples: samples,
            height: 100,
            absolute: true,
            borderWidth: 0.5,
            inactiveBorderColor: borderColor,
            width: MediaQuery.of(context).size.width,
            inactiveColor: Colors.white,
            activeBorderColor: borderColor,
            activeGradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFFff3701),
                Color(0xFFff6d00),
              ],
              stops: [
                0,
                0.3,
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
          RectangleWaveform(
            maxDuration: maxDuration,
            elapsedDuration: elapsedDuration,
            samples: samples,
            height: 50,
            width: MediaQuery.of(context).size.width,
            absolute: true,
            invert: true,
            borderWidth: 0.5,
            inactiveBorderColor: borderColor,
            activeBorderColor: borderColor,
            activeColor: minoractiveColor,
            inactiveColor: minorinactiveColor,
          ),
          // sizedBox,
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
              sizedBox,
              ElevatedButton(
                onPressed: () {
                  audioPlayer.fixedPlayer!.resume();
                },
                child: const Icon(Icons.play_arrow),
              ),
              sizedBox,
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    audioPlayer.fixedPlayer!
                        .seek(const Duration(milliseconds: 0));
                  });
                },
                child: const Icon(Icons.replay_outlined),
              ),
            ],
          )
        ],
      ),
    );
  }
}
