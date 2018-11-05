import 'package:flutter/widgets.dart';

abstract class DatabaseBloc {
  Future loader(BuildContext context);
}