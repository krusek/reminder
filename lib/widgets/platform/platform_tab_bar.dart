
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/widgets/platform/platform_widget.dart';

class PlatformTabBar<T> extends PlatformWidget {
  final Map<T, String> children;
  final T selectedValue;
  final Color accentColor;
  final TabController controller;
  PlatformTabBar({
    this.children,
    this.selectedValue,
    this.accentColor, 
    this.controller
  });

  @override
  Widget buildAndroidWidget(BuildContext context) {
    final tabs = this.children.values.map((w) {
      return Tab(child: Text(w, style: TextStyle(color: Colors.black87)));
    }).toList();
    return TabBar(
      controller: controller,
      tabs: tabs
      // <Widget>[
      //   Tab(child: Text(
      //     "Timespan",
      //     style: TextStyle(color: Colors.black87)
      //   )),
      //   Tab(child: Text("Weekly",
      //     style: TextStyle(color: Colors.black87)
      //   )),
      // ],
    );
  }

  @override
  Widget buildiOSWidget(BuildContext context) {
    final children = this.children.map((t, string) {
      return MapEntry(t, Padding(padding: EdgeInsets.all(8.0), child: Text(string)));
    });
    return CupertinoSegmentedControl<T>(
      children: children,
      groupValue: selectedValue,
      selectedColor: accentColor,
      borderColor: accentColor,
      pressedColor: accentColor.withAlpha(30),
      onValueChanged: (t) {
        controller.index = children.keys.toList().indexOf(t);
      },
    );
  }

}