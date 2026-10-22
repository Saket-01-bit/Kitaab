
import 'package:flutter_test/flutter_test.dart';
import 'package:kitaab_flutter/app.dart';

void main() {
  testWidgets('Kitaab app launches successfully', (tester) async {
    await tester.pumpWidget(const KitaabApp());

    expect(find.text('kitaab.'), findsOneWidget);
    expect(find.text('Every thought\nhas a place.'), findsOneWidget);
  });
}
