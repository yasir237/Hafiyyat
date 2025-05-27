import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hafiyyat/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Uygulamayı yükle
    await tester.pumpWidget(const HafiyyatApp());

    // 0 sayısının göründüğünü kontrol et
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // + ikonuna tıkla
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Sayacın 1 olduğunu kontrol et
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
