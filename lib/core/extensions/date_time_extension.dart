import 'package:easy_localization/easy_localization.dart';

extension OrderDateFormatting on DateTime {
  String get orderTimestamp => DateFormat('EEE, dd MMM yyyy, hh:mm a').format(this);
}
