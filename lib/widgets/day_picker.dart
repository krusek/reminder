
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/data/model.dart';

class DayPickerController extends ValueNotifier<List<DayOfWeek>> {
  DayPickerController(List<DayOfWeek> value) : super(value);

  List<int> get _integerValues => value.map((day) => DayOfWeek.values.indexOf(day)).toList();
  void _setIntegerValues(List<int> values) {
    this.value = values.map((ix) => DayOfWeek.values[ix]).toList();
  }
}

class DayOfWeekFormField extends StatelessWidget {
  final DayPickerController controller;
  DayOfWeekFormField({this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller._integerValues;
    return FormField<List<int>>(
      initialValue: state,
      validator: (value) {
        if (value.isEmpty) return "Please select a day";
        return null;
      },
      builder: (state) {
        controller._setIntegerValues(state.value);
        final field = DaysOfWeek(
          selectedDays: state.value,
          onToggleDay: (ix, val) {
            final value = state.value;
            state.setState(() {
              if (val) { value.add(ix); }
              else { value.remove(ix); }
            });
            state.validate();
          },
        );

        if (state.hasError) {
          print(state.errorText);
          return Column(
            children: <Widget>[
              field,
              Text(state.errorText, style: TextStyle(color: Colors.red),)
            ],
          );
        } else {
          return field;
        }
      },
    );
  }

}

class DaysOfWeek extends StatelessWidget {
  final Function(int, bool) onToggleDay;
  final List<int> selectedDays;
  DaysOfWeek({this.selectedDays, this.onToggleDay});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: 
        DayOfWeek.values.map((day) {
          final index = DayOfWeek.values.indexOf(day);
          bool selected = selectedDays.contains(index);
          return GestureDetector(
            child: Container(
              width: 40.0,
              height: 40.0,
              alignment: Alignment.center,
              child: Text(
                _textName(day), 
                style: TextStyle(color: selected ? Colors.white : Colors.green),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                color: selected ? Colors.green : null,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            onTap: () {
              onToggleDay(index, !selected);              
            },
          );
        }
      ).toList().cast<Widget>()
    );
  }


  String _textName(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.saturday:
      return "Sa";
      case DayOfWeek.sunday:
      return "Su";
      case DayOfWeek.monday:
      return "Mo";
      case DayOfWeek.tuesday:
      return "Tu";
      case DayOfWeek.wednesday:
      return "We";
      case DayOfWeek.thursday:
      return "Th";
      case DayOfWeek.friday:
      return "Fr";
    }
    return "";
  }

}