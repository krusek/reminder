import 'package:flutter/material.dart';
import 'package:reminder/data/model.dart';
import 'package:reminder/widgets/absolute_frequency.dart';
import 'package:reminder/widgets/frequency_remaining.dart';

class ReminderWidget extends StatelessWidget {
  final ReminderBase reminder;
  ReminderWidget({this.reminder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            reminder.title,
            style: TextStyle(
              color: Colors.black87,
              //fontWeight: FontWeight.w600,
              fontSize: 16.0,
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              reminder.description,
              style: TextStyle(
                color: Colors.black54,
                //fontWeight: FontWeight.w400,
                fontSize: 15.0,),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: <Widget>[
                AbsoluteFrequence(frequency: reminder.frequency,),
                Expanded(child: Container()),
                FrequencyRemaining(frequency: reminder.frequency,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
