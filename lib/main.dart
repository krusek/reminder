import 'package:flutter/material.dart';
import 'package:reminder/data/bloc/firebase_database_bloc.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/firestore_provider.dart';
import 'package:reminder/data/model.dart';
import 'package:reminder/screens/create_reminder_form.dart';
import 'package:reminder/screens/splash.dart';
import 'package:reminder/widgets/agnostic/agnostic_listitem.dart';
import 'package:reminder/widgets/reminder_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firestore_ui/animated_firestore_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => Splash(),
        "/home/": (context) => Scaffold(
                appBar: AppBar(
                  title: Text("Reminders"),
                  backgroundColor: Colors.green,
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return CreateReminderDialog();
                          }
                        );
                      },
                      child: Icon(Icons.add, color: Colors.white)
                    )
                  ],
                ),
                body:MyHomePage()
            )
      },
      builder: (context, navigator) {
        return FirestoreProvider(
          child: DatabaseProvider(
            child: navigator
          )
        );
      }
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context) ;
    if (database is FirebaseDatabaseBloc) {
      return FirebaseReminderList(database: database);
    }
    return StreamBuilder<List<ReminderBase>>(
      stream: database.remindersStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Text("Loading...");
        return ListView(
          children: 
            snapshot.data.map((data) {
              return AgnosticListItem(
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

class FirebaseReminderList extends StatelessWidget {
  const FirebaseReminderList({
    Key key,
    @required this.database,
  }) : super(key: key);

  final FirebaseDatabaseBloc database;

  @override
  Widget build(BuildContext context) {
    return FirestoreAnimatedList(
      query: database.remindersQueryStream,
      itemBuilder: (context, document, animation, _) {
        final data = database.reminder(document: document);
        return Opacity(
          opacity: animation.value,
          child: MaterialButton(
            child: ReminderWidget(reminder: data,),
            onPressed: () {
              final reminder = data.updated(lastEvent: DateTime.now());
              database.update(reminder: reminder);
            },
          ),
        );
      },
    );
  }
}





