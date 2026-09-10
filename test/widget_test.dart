import 'package:flutter_test/flutter_test.dart';

import 'package:playverse/presentation/app/playverse_app.dart';

void main() {
  testWidgets(
    'PLAYVERSE inicia correctamente',
    (tester) async {
      await tester.pumpWidget(
        const PlayVerseApp(),
      );

      // La aplicación debe iniciar correctamente.
      expect(
        find.text('PLAYVERSE'),
        findsOneWidget,
      );

      // Debe existir una acción para comenzar la experiencia.
      expect(
        find.text('COMENZAR'),
        findsOneWidget,
      );
    },
  );
}