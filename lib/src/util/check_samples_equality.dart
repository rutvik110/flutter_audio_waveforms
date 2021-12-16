import 'package:collection/collection.dart';

/// Checks for new and old samples equality to decide whether to process samples
/// again or not when samples are updated.
bool Function(List<double> list1, List<double> list2) checkforSamplesEquality =
    const ListEquality<double>().equals;
