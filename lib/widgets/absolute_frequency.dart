import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/data/model.dart';

class AbsoluteFrequence extends StatelessWidget {
  final Frequency frequency;
  AbsoluteFrequence({Key key, this.frequency}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration days = Duration();
    if (frequency is Timespan) {
      final timespan = frequency as Timespan;
      days = Duration(seconds: timespan.targetTimespan);
    }
    int d = days.inDays;
    return Text("every $d days",
      style: TextStyle(
        color: Colors.black54,
        //fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
    );
  }

}