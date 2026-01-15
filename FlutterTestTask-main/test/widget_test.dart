import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_assignment/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  Finder findAddTapTarget() {
    return find.text('Add');
  }

  Future<void> addTodo(WidgetTester tester, String text) async {
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, text);
    await tester.pump();

    final addTapTarget = findAddTapTarget();
    expect(addTapTarget, findsOneWidget);

    await tester.tap(addTapTarget);
    await tester.pumpAndSettle();
  }

  testWidgets('Adds a todo and shows it in the list', (tester) async {
    await pumpApp(tester);

    await addTodo(tester, 'Buy milk');

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('No todos yet. Add some!'), findsNothing);
  });

  testWidgets('Does not add empty todo', (tester) async {
  await pumpApp(tester);

  final textField = find.byType(TextField);
  expect(textField, findsOneWidget);

  await tester.enterText(textField, '   ');
  await tester.pump();

  final addTapTarget = find.text('Add');
  expect(addTapTarget, findsOneWidget);

  await tester.tap(addTapTarget);
  await tester.pumpAndSettle();

  expect(find.byType(ListTile), findsNothing);
  expect(find.text('No todos yet. Add some!'), findsOneWidget);
});


  testWidgets('Does not allow duplicate todos (shows SnackBar)', (tester) async {
    await pumpApp(tester);

    await addTodo(tester, 'Buy milk');
    expect(find.text('Buy milk'), findsOneWidget);

    await addTodo(tester, 'buy milk');

    expect(find.text('Buy milk'), findsOneWidget);

    expect(find.text('Todo already exists'), findsOneWidget);
  });

  testWidgets('Toggles todo completion when checkbox tapped', (tester) async {
    await pumpApp(tester);

    await addTodo(tester, 'Study Flutter');

    final textBefore = tester.widget<Text>(find.text('Study Flutter'));
    expect(textBefore.style?.decoration, isNot(TextDecoration.lineThrough));

    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);

    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    final textAfter = tester.widget<Text>(find.text('Study Flutter'));
    expect(textAfter.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('Deletes todo when delete icon tapped', (tester) async {
    await pumpApp(tester);

    await addTodo(tester, 'Throw trash');
    expect(find.text('Throw trash'), findsOneWidget);

    final deleteButton = find.byIcon(Icons.delete);
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Throw trash'), findsNothing);
    expect(find.text('No todos yet. Add some!'), findsOneWidget);
  });
}
