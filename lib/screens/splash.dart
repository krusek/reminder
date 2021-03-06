import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/firestore_provider.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("Mealplan")
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context == null) { return; }
    List<Future> futures = List();

    futures.add(Future.delayed(Duration(seconds: 1)));
    futures.add(DatabaseProvider.of(context).loader(context));

    Future.wait(futures).then((_) {
      if (context == null) { return; }
      Navigator.of(context).pushReplacementNamed("/home/"); 
    });
  }
}
