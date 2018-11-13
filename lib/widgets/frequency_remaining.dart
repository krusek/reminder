import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/data/model.dart';

class FrequencyRemaining extends StatelessWidget {
  final Frequency frequency;
  FrequencyRemaining({Key key, this.frequency}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration days = Duration();
    if (frequency is Timespan) {
      final timespan = frequency as Timespan;
      final lastEvent = frequency.lastEvent;
      if (lastEvent != null)
        days = lastEvent.difference(DateTime.now()) + Duration(seconds: timespan.targetTimespan);
      else {
        days = Duration(seconds: timespan.targetTimespan);
      }
    }
    int d = days.inDays;
    Color color;
    if (d > 15) {
      color = Colors.green;
    } else if (d > 7) {
      color = Colors.orange;
    } else if (d > 4) {
      color = Colors.deepOrange;
    } else {
      color = Colors.red;
    }
    return Text("due in $d days",
      style: TextStyle(
        color: color,
        //fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
    );
  }

}