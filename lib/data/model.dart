abstract class ReminderBase {
  String get path;
  String get id;
  String get title;
  String get description;
  Frequency get frequency;

  ReminderBase updated({DateTime lastEvent});
  Map<String,dynamic> toJson();
}

class Reminder extends ReminderBase {
  final String path;
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
    this.path,
    this.id,
    this.title,
    this.description,
    this.frequency
  });

  Reminder.fromJson(Map<String, dynamic> json) :
    this.path = json["path"],
    this.id = json["id"],
    this.title = json["title"],
    this.description = json["description"],
    this.frequency = Frequency.fromJson(json["frequency"]);
  
  Map<String,dynamic> toJson() {
    return {
      "path": this.path,
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