// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reminder/data/bloc/database_bloc.dart';
import 'package:reminder/data/bloc/memory_database_bloc.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/model.dart';
import 'package:reminder/device/platform_provider.dart';

import 'package:reminder/main.dart';
import 'package:uuid/uuid.dart';

Future testEveryText(WidgetTester tester, MemoryDatabaseBloc database, Widget app) async {
    await tester.pumpWidget(app);
    expect(find.text("Loading..."), findsOneWidget);
    database.update(reminder: Reminder(
      id: Uuid().v1(),
      title: Uuid().v1(),
      description: Uuid().v1(),
      frequency: Timespan(
        targetTimespan: 100,
        minimumTimespan: 80,
        lastEvent: DateTime.now()
      )
    ));
    await tester.pumpWidget(app);
    expect(find.text("Loading..."), findsNothing);
    expect(find.text("every 0 days"), findsOneWidget);
}

void main() {

  testWidgets('Test iOS reminder list', (WidgetTester tester) async {
    final database = MemoryDatabaseBloc();
    final app = PlatformProvider(platform: TargetPlatform.iOS, child: MaterialApp(home: DatabaseProvider(child: MyHomePage(), bloc: database)));
    await testEveryText(tester, database, app);
  });
  testWidgets('Test Android reminder list', (WidgetTester tester) async {
    final database = MemoryDatabaseBloc();
    final app = PlatformProvider(platform: TargetPlatform.android, child: MaterialApp(home: DatabaseProvider(child: MyHomePage(), bloc: database)));
    await testEveryText(tester, database, app);
  });
}
