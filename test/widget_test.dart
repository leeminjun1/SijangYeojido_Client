// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:sijangyeojido_client/main.dart';

void main() {
  testWidgets('앱 스모크 테스트 (MainScaffold 렌더링)', (WidgetTester tester) async {
    await tester.pumpWidget(const SijangYeojidoApp());
    await tester.pumpAndSettle();

    // Bottom navigation labels should exist.
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('내 주변'), findsOneWidget);
    expect(find.text('예약'), findsOneWidget);
    expect(find.text('마이'), findsOneWidget);

    // Switch tabs without crashing.
    await tester.tap(find.text('예약'));
    await tester.pumpAndSettle();
    expect(find.text('예약'), findsWidgets);

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    expect(find.text('마이'), findsWidgets);
  });
}
