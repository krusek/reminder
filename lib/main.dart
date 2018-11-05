import 'package:flutter/material.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/firestore_provider.dart';
import 'package:reminder/screens/splash.dart';

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
        "/home/": (context) => MyHomePage(title: "blah")
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Text(this.widget.title);
  }
}
