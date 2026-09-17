import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_cricket/main.dart';

void main() {
  testWidgets('six balls are played, then restart resets the game',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MiniCricketApp());

    expect(find.byKey(const Key('runs_value')), findsOneWidget);
    expect(find.text('Bat'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);

    for (int i = 0; i < 6; i++) {
      await tester.tap(find.byKey(const Key('bat_restart_button')));
      await tester.pump();
    }

    expect(find.text('Restart'), findsOneWidget);
    expect(find.text('0'), findsWidgets);

    await tester.tap(find.byKey(const Key('bat_restart_button')));
    await tester.pump();

    expect(find.text('Bat'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });
}
