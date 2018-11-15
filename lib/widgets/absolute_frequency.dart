import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/data/model.dart';

class AbsoluteFrequence extends StatelessWidget {
  final Frequency frequency;
  AbsoluteFrequence({Key key, this.frequency}): super(key: key);

  @override
  Widget build(BuildContext context) {
    String data = "";
    if (frequency is Timespan) {
      data = _timespanText(frequency);
    } else if (frequency is DaysFrequency) {
      data = _daysText(frequency);
    }
    
    return Text(data,
      style: TextStyle(
        color: Colors.black54,
        //fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
    );
  }

  String _daysText(DaysFrequency days) {
    final value = days.days.map((day) => _dayName(null, day)).reduce((result, element) => result + ", " + element);
    print("value: $value");
    return "every $value";
  }

  String _dayName(BuildContext _, DayOfWeek day) {
    final names = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
    return names[DayOfWeek.values.indexOf(day)];
  }

  String _timespanText(Timespan timespan) {
    Duration days = Duration(seconds: timespan.targetTimespan);
    final d = days.inDays;
    return "every $d days";

  }
}