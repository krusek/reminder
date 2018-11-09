import 'package:flutter/material.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/firestore_provider.dart';
import 'package:reminder/data/model.dart';
import 'package:reminder/screens/splash.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => Splash(),
        "/home/": (context) => MyHomePage()
      },
      builder: (context, navigator) {
        return FirestoreProvider(
          child: DatabaseProvider(
            child: Scaffold(
              appBar: AppBar(
                title: Text("Reminders"),
                backgroundColor: Colors.green,
              ),
              body:navigator
          )
          )
        );
      }
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return StreamBuilder<List<ReminderBase>>(
      stream: database.remindersStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Text("Loading...");
        return AnimatedList(
          initialItemCount: snapshot.data.length,
          itemBuilder: (context, ix, animation) {
            final data = snapshot.data[ix];
            return MaterialButton(
                key: Key(data.id),
                child: ReminderWidget(reminder: data,),
                onPressed: () {
                  final reminder = data.updated(lastEvent: DateTime.now());
                  database.update(reminder: reminder);
                },
              );
          },
          // children: 
          //   snapshot.data.map((data) {
          //     return MaterialButton(
          //       key: Key(data.id),
          //       child: ReminderWidget(reminder: data,),
          //       onPressed: () {
          //         final reminder = data.updated(lastEvent: DateTime.now());
          //         database.update(reminder: reminder);
          //       },
          //     );
          //   }).toList()
        );
      },
    );
  }

  String relative(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }
}

class ReminderWidget extends StatelessWidget {
  final ReminderBase reminder;
  ReminderWidget({this.reminder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            reminder.title,
            style: TextStyle(
              color: Colors.black87,
              //fontWeight: FontWeight.w600,
              fontSize: 16.0,
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              reminder.description,
              style: TextStyle(
                color: Colors.black54,
                //fontWeight: FontWeight.w400,
                fontSize: 15.0,),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: <Widget>[
                AbsoluteFrequence(frequency: reminder.frequency,),
                Expanded(child: Container()),
                FrequencyRemaining(frequency: reminder.frequency,)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AbsoluteFrequence extends StatelessWidget {
  final Frequency frequency;
  AbsoluteFrequence({Key key, this.frequency}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration days = Duration();
    if (frequency is Timespan) {
      final timespan = frequency as Timespan;
      days = Duration(seconds: timespan.targetTimespan);
    }
    int d = days.inDays;
    return Text("every $d days",
      style: TextStyle(
        color: Colors.black54,
        //fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
    );
  }

}

class FrequencyRemaining extends StatelessWidget {
  final Frequency frequency;
  FrequencyRemaining({Key key, this.frequency}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration days = Duration();
    if (frequency is Timespan) {
      final timespan = frequency as Timespan;
      days = frequency.lastEvent.difference(DateTime.now()) + Duration(seconds: timespan.targetTimespan);
    }
    int d = days.inDays;
    Color color;
    if (d > 15) {
      color = Colors.green;
    } else if (d > 7) {
      color = Colors.orange;
    } else if (d > 4) {
      color = Colors.deepOrange;
    } else {
      color = Colors.red;
    }
    return Text("due in $d days",
      style: TextStyle(
        color: color,
        //fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
    );
  }

}
