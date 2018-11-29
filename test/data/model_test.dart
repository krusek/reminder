
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:reminder/data/model.dart';
import 'package:uuid/uuid.dart';

void main() {
  test("Test model with timespan serialization and deserialization", () async {
    final model = Reminder(
      id: Uuid().v1(), 
      title: Uuid().v1(), 
      description: Uuid().v1(),
      frequency: Timespan(
        targetTimespan: Random().nextInt(100) + 200,
        minimumTimespan: Random().nextInt(100),
        lastEvent: DateTime.now(),
      )
    );

    final json = model.toJson();
    final parsed = Reminder.fromJson(json);

    expect(model.id, parsed.id);
    expect(model.title, parsed.title);
    expect(model.description, parsed.description);
    expect(model.frequency is Timespan, true);
    final modelFrequency = model.frequency as Timespan;
    final parsedFrequency = parsed.frequency as Timespan;
    expect(modelFrequency.targetTimespan, parsedFrequency.targetTimespan);
    expect(modelFrequency.minimumTimespan, parsedFrequency.minimumTimespan);
    expect(modelFrequency.lastEvent, parsedFrequency.lastEvent);
  });
  
  test("Test model with weekday span serialization and deserialization", () async {
    final model = Reminder(
      id: Uuid().v1(), 
      title: Uuid().v1(), 
      description: Uuid().v1(),
      frequency: DaysFrequency(
        days: [DayOfWeek.saturday, DayOfWeek.thursday, DayOfWeek.sunday],
        lastEvent: DateTime.now(),
      )
    );

    final json = model.toJson();
    print("frequency: ${json['frequency']}");
    final parsed = Reminder.fromJson(json);

    expect(model.id, parsed.id);
    expect(model.title, parsed.title);
    expect(model.description, parsed.description);
    expect(model.frequency is DaysFrequency, true);
    final modelFrequency = model.frequency as DaysFrequency;
    final parsedFrequency = parsed.frequency as DaysFrequency;
    expect(modelFrequency.days, parsedFrequency?.days);
    expect(modelFrequency.lastEvent, parsedFrequency?.lastEvent);
  });
}