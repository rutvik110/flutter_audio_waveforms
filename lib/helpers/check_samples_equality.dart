import 'package:collection/collection.dart';

bool Function(List<double> list1, List<double> list2) checkforSamplesEquality =
    const ListEquality<double>().equals;
