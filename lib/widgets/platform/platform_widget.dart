import 'package:flutter/widgets.dart';
import 'package:reminder/device/platform_provider.dart';

abstract class PlatformWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final platform = PlatformProvider.of(context);
    switch (platform) {
      case TargetPlatform.android:
      return buildAndroidWidget(context);
      case TargetPlatform.iOS:
      return buildiOSWidget(context);
      case TargetPlatform.fuchsia:
      return buildFuchsiaWidget(context);
    }
    return null;
  }

  Widget buildAndroidWidget(BuildContext context);
  Widget buildiOSWidget(BuildContext context);
  Widget buildFuchsiaWidget(BuildContext context) {
    return buildAndroidWidget(context);
  }
}