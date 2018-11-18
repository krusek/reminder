import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlatformProvider extends StatefulWidget {
  final Widget child;
  final TargetPlatform platform;
  PlatformProvider({this.child, this.platform});

  @override
  State<PlatformProvider> createState() {
    return new _PlatformProviderState(platform: platform);
  }

  static TargetPlatform of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_PlatformProvider) as _PlatformProvider).platform;
  }
}

class _PlatformProviderState extends State<PlatformProvider> {
  TargetPlatform platform;
  _PlatformProviderState({this.platform});

  @override
  Widget build(BuildContext context) {
    if (platform == null) platform = Theme.of(context).platform;
    return _PlatformProvider(child: this.widget.child, platform: this.platform);
  }
}

class _PlatformProvider extends InheritedWidget {
  final TargetPlatform platform;
  _PlatformProvider({this.platform, Widget child}): super(child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}