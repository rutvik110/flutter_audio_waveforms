import 'dart:convert';

import 'dart:math' as math;

List<double> loadparseJson(String jsonBody) {
  final data = jsonDecode(jsonBody);
  final List<int> points = List.castFrom<dynamic, int>(data['data']);
  List<int> filteredData = [];
  const int samples = 256;
  final double blockSize = points.length / samples;

  for (int i = 0; i < samples; i++) {
    final double blockStart =
        blockSize * i; // the location of the first sample in the block
    int sum = 0;
    for (int j = 0; j < blockSize; j++) {
      sum = sum +
          points[(blockStart + j).toInt()]
              //TODO: way to change between using .toInt() and .abs()
              .toInt(); // find the sum of all the samples in the block
      //.toabs(); will create waves with only positive values *for rounded waveform
      //toInt() will convert the double to an int with positive/negative values

    }
    filteredData.add((sum / blockSize)
        .round() // take the average of the block and add it to the filtered data
        .toInt()); // divide the sum by the block size to get the average
  }
  final maxNum = filteredData.reduce(math.max);

  final double multiplier = math.pow(maxNum, -1).toDouble();
  print("M+" + multiplier.toString());
  //Needed for having a waveform that ends at the 0 y level
  filteredData.add(0);
  return filteredData.map<double>((e) => (e * multiplier)).toList();
}
