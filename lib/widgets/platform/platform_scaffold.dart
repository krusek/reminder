import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/data/bloc/firebase_database_bloc.dart';
import 'package:reminder/widgets/platform/platform_widget.dart';
import 'package:reminder/widgets/reminder_widget.dart';

class PlatformScaffold extends PlatformWidget {
  final Widget child;
  final String title;
  PlatformScaffold({this.child, this.title});

  @override
  Widget buildiOSWidget(BuildContext context) {
      
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        actionsForegroundColor: Colors.green,
        middle: title != null ? Text(title) : null,
        trailing: Builder(
          builder: (ctx) {
            return GestureDetector(
              child: Icon(Icons.add, color: Colors.green),
              onTap: () {
                Navigator.pushNamed(ctx, "/create/");
              },
            );
          }
        ),
      ),
      child: child
    );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title != null ? Text(title) : null,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
                Navigator.pushNamed(context, "/create/");
            },
          )
        ],
      ),
      body: this.child
    );
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