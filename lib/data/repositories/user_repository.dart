import 'package:uuid/uuid.dart';

import '../../domain/user/user.dart';
import '../local/hive/hive_boxes.dart';

class UserRepository {
  static const _key = 'preferences';

  UserPreferences getPreferences() {
    final raw = HiveBoxes.userBox.get(_key);
    if (raw == null) {
      return UserPreferences(id: const Uuid().v4());
    }
    return UserPreferences.fromMap(Map<dynamic, dynamic>.from(raw as Map));
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    await HiveBoxes.userBox.put(_key, prefs.toMap());
  }

  Future<void> clear() async {
    await HiveBoxes.userBox.clear();
  }
}
