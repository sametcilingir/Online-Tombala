import 'package:tombala/utils/constants/duration_constants.dart';




extension DurationExtension on DurationConstants {
  Duration get durationLow =>
       Duration(milliseconds: low);
  Duration get durationMedium =>
       Duration(milliseconds: medium);
  Duration get durationHigh =>
       Duration(milliseconds: high);
}
