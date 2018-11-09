import 'package:flutter/widgets.dart';
import 'package:reminder/data/model.dart';

abstract class DatabaseBloc {
  Future loader(BuildContext context);

  Stream<List<ReminderBase>> get remindersStream;
  Future update({ReminderBase reminder});
}