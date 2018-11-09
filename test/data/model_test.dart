
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:reminder/data/model.dart';
import 'package:uuid/uuid.dart';

void main() {
  test("Test model serialization and deserialization", () async {
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
    final modelFrequency = model.frequency as Timespan;
    final parsedFrequency = parsed.frequency as Timespan;
    expect(modelFrequency.targetTimespan, parsedFrequency.targetTimespan);
    expect(modelFrequency.minimumTimespan, parsedFrequency.minimumTimespan);
    expect(modelFrequency.lastEvent, parsedFrequency.lastEvent);
  });
}