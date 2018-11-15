import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/data/model.dart';

class FrequencyRemaining extends StatelessWidget {
  final Frequency frequency;
  FrequencyRemaining({Key key, this.frequency}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration days = frequency.dueDate.difference(DateTime.now());
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
    String due = "due in $d days";
    if (d < 0) due = "due ${-1*d} days ago";
    return Text(due,
      style: TextStyle(
        color: color,
        //fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
    );
  }

}