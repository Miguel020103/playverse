import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/local/hive/hive_boxes.dart';
import 'presentation/app/playverse_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await HiveBoxes.openAll();

  runApp(
    const ProviderScope(
      child: PlayVerseApp(),
    ),
  );
}
