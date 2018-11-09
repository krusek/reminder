import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:reminder/data/bloc/database_bloc.dart';
import 'package:reminder/data/model.dart';
import 'package:rxdart/rxdart.dart';

class MemoryDatabaseBloc extends DatabaseBloc {
  final _reminders = List<ReminderBase>();
  Future _loader;
  Future loader(BuildContext context) {
    if (_loader == null) {
      _loader = _load(context);
    }
    return _loader;
  }

  Future _load(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/template.json");
    final result = json.decode(data);
    final List<dynamic> list = result["reminders"];
    list.forEach((data) {
      _reminders.add(Reminder.fromJson(data));
    });
    _reminders.sort((reminder1, reminder2) {
      return reminder1.frequency.dueDate.compareTo(reminder2.frequency.dueDate);
    });
    _remindersChanges.add(_reminders);
    return;
  }

  final _remindersChanges = BehaviorSubject<List<ReminderBase>>();

  // TODO: implement remindersStream
  @override
  Stream<List<ReminderBase>> get remindersStream => _remindersChanges.stream;

  @override
  Future update({ReminderBase reminder}) async {
    _reminders.removeWhere((item) => item.id == reminder.id);
    _reminders.add(reminder);
    _reminders.sort((lhs, rhs) => lhs.frequency.dueDate.compareTo(rhs.frequency.dueDate));
    _remindersChanges.add(_reminders);
  }
}