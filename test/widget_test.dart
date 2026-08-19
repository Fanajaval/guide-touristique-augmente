import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guide_touristique_augmente/screens/profile_screen.dart';

void main() {
  testWidgets('profile screen shows the favorites entry', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    expect(find.text('Mon profil'), findsOneWidget);
    expect(find.text('Mes favoris'), findsOneWidget);
  });
}
