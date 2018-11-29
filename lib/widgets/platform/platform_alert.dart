
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/widgets/platform/platform_widget.dart';



class PlatformAlert extends PlatformWidget {
  final title = "Are you sure?";
  final body = "This item is far from being due. Are you sure you want to activate it?";
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        Builder(builder: (context) {
          return FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("OK")
          );
        },),
        Builder(builder: (context) {
          return FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancel")
          );
        },)
      ],
    );
  }

  @override
  Widget buildiOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        Builder(builder: (context) {
          return CupertinoButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("OK")
          );
        },),
        Builder(builder: (context) {
          return CupertinoButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancel")
          );
        },)
      ],
    );
  }
}