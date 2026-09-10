import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';

class HiveBoxes {
  static late Box userBox;
  static late Box seasonBox;

  static Future<void> openAll() async {
    userBox = await Hive.openBox(AppConstants.hiveUserBox);
    seasonBox = await Hive.openBox(AppConstants.hiveSeasonBox);
  }
}
