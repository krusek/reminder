import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/firestore_provider.dart';
import 'package:reminder/data/model.dart';
import 'package:reminder/device/platform_provider.dart';
import 'package:reminder/screens/create_reminder_form.dart';
import 'package:reminder/screens/splash.dart';
import 'package:reminder/widgets/platform/platform_listitem.dart';
import 'package:reminder/widgets/platform/platform_scaffold.dart';
import 'package:reminder/widgets/reminder_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() => runApp(new MyApp());

final TargetPlatform platform = null; // TargetPlatform.android;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      platform: platform,
      child: App(
        routes: {
          "/": (context) => PlatformScaffold(child: Splash()),
          "/create/": (context) => PlatformScaffold(title: "Create", child: CreateReminderForm()),
          "/home/": (context) =>  PlatformScaffold(title: "Reminders", child: MyHomePage())
        },
        builder: (context, navigator) {
          return FirestoreProvider(
            child: DatabaseProvider(
              child: navigator
            )
          );
        }
      ),
    );
  }
}

class App extends StatelessWidget {
  final Map<String, WidgetBuilder> routes;
  final TransitionBuilder builder;
  App({this.routes, this.builder});

  @override
  Widget build(BuildContext context) {
    if (PlatformProvider.of(context) == TargetPlatform.iOS) {
      return CupertinoApp(
        color: Colors.green,
        title: 'Reminder',
        routes: routes,
        builder: builder
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green
        ),
        routes: routes,
        builder: builder,
      );
    }
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context) ;

    return StreamBuilder<List<ReminderBase>>(
      stream: database.remindersStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Text("Loading...");
        return ListView(
          children: 
            snapshot.data.map((data) {
              return PlatformListItem(
                child: ReminderWidget(reminder: data,),
                onPressed: () {
                  final reminder = data.updated(lastEvent: DateTime.now());
                  database.update(reminder: reminder);
                },
              );
            }).toList()
        );
      },
    );
  }

  String relative(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }
}



