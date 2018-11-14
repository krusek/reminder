import 'package:flutter/material.dart';

abstract class ReminderBase {
  String get id;
  String get title;
  String get description;
  Frequency get frequency;

  ReminderBase updated({DateTime lastEvent});
  Map<String,dynamic> toJson();
}

class Reminder extends ReminderBase {
  final String id;
  final String title;
  final String description;
  final Frequency frequency;

  Reminder updated({DateTime lastEvent}) {
    final frequency = this.frequency.updated(lastEvent: lastEvent);
    return Reminder(
      id: id,
      title: title,
      description: description,
      frequency: frequency
    );
  }

  Reminder({
    this.id,
    this.title,
    this.description,
    this.frequency
  });

  Reminder.fromJson(Map<String, dynamic> json) :
    this.id = json["id"],
    this.title = json["title"],
    this.description = json["description"],
    this.frequency = Frequency.fromJson(json["frequency"]);
  
  Map<String,dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "description": this.description,
      "frequency": this.frequency.toJson(),
    };
  }
}

abstract class Frequency {
  DateTime get lastEvent;
  DateTime get dueDate;
  Frequency();
  Map<String,dynamic> toJson();
  Frequency updated({DateTime lastEvent});
  static Frequency fromJson(dynamic json) {
    if (json["type"] == Timespan.type) return Timespan.fromJson(json);
    if (json["type"] == DaysFrequency.type) return DaysFrequency.fromJson(json);
    return null;
  }
}

class Timespan extends Frequency {
  final int targetTimespan;
  final int minimumTimespan;
  final DateTime lastEvent;

  Timespan updated({DateTime lastEvent}) {
    return Timespan(
      lastEvent: lastEvent, 
      targetTimespan: this.targetTimespan, 
      minimumTimespan: this.minimumTimespan
    );
  }

  DateTime get dueDate {
    return lastEvent.add(Duration(seconds: targetTimespan));
  }

  static String get type => "timespan";

  Timespan({this.targetTimespan, this.minimumTimespan, this.lastEvent});

  Timespan.fromJson(dynamic json):
    this.targetTimespan = json["target_timespan"],
    this.minimumTimespan = json["minimum_timespan"],
    this.lastEvent = DateTime.parse(json["last_event"]);

  Map<String,dynamic> toJson() {
    return {
      "type": "timespan",
      "target_timespan": this.targetTimespan,
      "minimum_timespan": this.minimumTimespan,
      "last_event": this.lastEvent.toIso8601String(),
    };
  }
}

enum DayOfWeek {
  sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

class DaysFrequency extends Frequency {
  // TODO: implement dueDate
  @override
  DateTime get dueDate {
    final dates = this.days.map(_dueDateForDay).toList();
    dates.sort((lhs, rhs) => lhs.compareTo(rhs));
    return dates.first;
  }

  final int _firstDayOfWeek = 0;
  DateTime _dueDateForDay(DayOfWeek day) {
    final weekday = lastEvent.weekday;
    final searchday = DayOfWeek.values.indexOf(day);

    int difference = searchday - weekday;
    if (difference <= 0) difference += 7;
    return lastEvent.add(Duration(days: difference));
  }

  final DateTime lastEvent;
  final List<DayOfWeek> days;

  static String get type => "days";

  DaysFrequency.fromJson(dynamic json) :
    this.lastEvent = DateTime.parse(json["last_event"]),
    this.days = json["days"].map((ix) => DayOfWeek.values[ix]).toList().cast<DayOfWeek>();

  @override
  Map<String, dynamic> toJson() {
    final days = this.days.map((day) => DayOfWeek.values.indexOf(day)).toList();
    return {
      "days": days,
      "last_event": this.lastEvent
    };
  }

  DaysFrequency({
    this.days,
    this.lastEvent,
  });

  @override
  Frequency updated({DateTime lastEvent}) {
    return DaysFrequency(days: this.days, lastEvent: lastEvent);
  }
}