import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shoplite/main.dart';

void main() {
  testWidgets('+ товч тоолуурыг нэмэгдүүлнэ', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopLiteApp());

    expect(find.text('ShopLite — Сагс'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('− товч тоолуурыг хасна, 0-ээс доош орохгүй',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ShopLiteApp());

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('refresh товч тоолуурыг 0 болгоно', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopLiteApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('10 хүрвэл + идэвхгүй болж, анхааруулга гарна',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ShopLiteApp());

    const warning = 'Нэг удаад 10-аас олон бараа захиалах боломжгүй';
    expect(find.text(warning), findsNothing);

    for (var i = 0; i < 10; i++) {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
    }
    expect(find.text('10'), findsOneWidget);
    expect(find.text(warning), findsOneWidget);

    final addButton = tester.widget<FloatingActionButton>(
      find.widgetWithIcon(FloatingActionButton, Icons.add),
    );
    expect(addButton.onPressed, isNull);
  });
}
