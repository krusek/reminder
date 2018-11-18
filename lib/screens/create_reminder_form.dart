import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/data/bloc/database_bloc.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/model.dart';
import 'package:reminder/device/platform_provider.dart';
import 'package:reminder/widgets/day_picker.dart';
import 'package:reminder/widgets/platform/platform_form_field.dart';
import 'package:reminder/widgets/platform/platform_tab_bar.dart';
import 'package:reminder/widgets/safe_area_scroll_view.dart';
import 'package:uuid/uuid.dart';

class CreateReminderForm extends StatefulWidget {
  CreateReminderForm();

  @override
  State<StatefulWidget> createState() {
    return CreateReminderFormState();
  }
}


class CreateReminderFormState extends State<CreateReminderForm> with TickerProviderStateMixin<CreateReminderForm> {
  final _formKey = GlobalKey<FormState>();
  final String id;
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController descriptionController = TextEditingController(text: "");
  final TextEditingController timespanController = TextEditingController(text: "");
  final TextEditingController minimumTimespanController = TextEditingController(text: "");
  TabController tabBarController;
  final DayPickerController dayPickerController = DayPickerController([]);
  FrequencyType frequencyType = FrequencyType.timespan;
  TargetPlatform platform = TargetPlatform.android;

  CreateReminderFormState({String id}):
    this.id = id ?? Uuid().v1();

  @override
    void initState() {
      tabBarController = TabController(length: 2, vsync: this);
      tabBarController.addListener(() {
        if (tabBarController.indexIsChanging) { return; }
        print("changing: ${tabBarController.indexIsChanging}");
        print("tab bar: ${tabBarController.index}");
        setState(() { 
          if (tabBarController.index == 0) {
            frequencyType = FrequencyType.timespan;
          } else {
            frequencyType = FrequencyType.days;
          }
        });
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    platform = PlatformProvider.of(context);
    final database = DatabaseProvider.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeAreaScrollView(
        child: Form(
          key: _formKey,
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: Duration(milliseconds: 200),
            vsync: this,
            child: Column(
              children: [
                PlatformTextFormField(
                  label: "Name",
                  controller: nameController,
                  validator: (val) => val.isNotEmpty == true ? null : "Name cannot be empty",
                  vsync: this,
                ),
                Container(height: 15.0),
                PlatformTextFormField(
                  label: "Description",
                  controller: descriptionController,
                  validator: (val) => val.isNotEmpty == true ? null : "Description cannot be empty",
                  vsync: this,
                ),
                Container(height: 15.0),
                PlatformTabBar(
                  children: {
                    FrequencyType.timespan: "Timespan", // _segmentedItem("Timespan"),
                    FrequencyType.days: "Weekly", // _segmentedItem("Weekly"),
                  },
                  controller: tabBarController,
                  selectedValue: frequencyType,
                  accentColor: Colors.green,
                ),
                Container(height: 15.0),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: frequencyType == FrequencyType.timespan ? _buildFrequencyInput() : _buildWeekDayInput(),
                ),
                Container(height: 12.0),
                _buildButtons(database),
              ]
            )
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDayInput() {
    return Column(
      children: <Widget>[
        DayOfWeekFormField(
          controller: dayPickerController,
        )
      ],
    );
  }

  Widget _buildFrequencyInput() {
    FormFieldValidator<String> integerValidator = (val) {
      if (int.tryParse(val) == null) return "Must be an integer";
      return null;
    };
    FormFieldValidator<String> minimumValidator = (val) {
      final minimum = int.tryParse(val);
      if (minimum == null) return "Must be an integer";
      final timespan = int.tryParse(timespanController.value.text);
      if (timespan != null) {
        if (minimum > timespan) { return "Must be less than target."; }
      }
      return null;
    };
    return Column(
      children: [
        PlatformTextFormField(
          label: "Target days",
          keyboardType: TextInputType.number,
          controller: timespanController,
          validator: integerValidator,
          vsync: this,
        ),
        Container(height: 15.0),
        PlatformTextFormField(
          label: "Miminum days",
          keyboardType: TextInputType.number,
          controller: minimumTimespanController,
          validator: minimumValidator,
          vsync: this,
        )
      ]
    );
  }

  Frequency _buildFrequency() {
    switch (this.frequencyType) { 
      case FrequencyType.timespan:
      return _buildTimespan();
      case FrequencyType.days:
      return _buildDaysFrequency();
    }
    return null;
  }

  Timespan _buildTimespan() {
    int days = 60*60*24;
    return Timespan(
      lastEvent: DateTime.now(), 
      targetTimespan: int.parse(timespanController.text) * days, 
      minimumTimespan: int.parse(minimumTimespanController.text) * days,
    );
  }

  DaysFrequency _buildDaysFrequency() {
    return DaysFrequency(
      days: dayPickerController.value,
      lastEvent: DateTime.now()
    );
  }

  Widget _buildButtons(DatabaseBloc database) {
    return Column(
      children: <Widget>[
        FlatButton(
          color: Colors.black12,
          textColor: Colors.blue,
          child: Text("Save"),
          onPressed: () {
            final FormState form = _formKey.currentState;
            if (form.validate()) {
              form.save();
              final frequency = _buildFrequency();
              final reminder = Reminder(
                id: this.id,
                title: nameController.value.text,
                description: descriptionController.value.text,
                frequency: frequency
              );
              database.update(reminder: reminder);
              Navigator.of(context).pop();
            } else {
            }
          }
        ),
        FlatButton(
          color: Colors.black12,
          textColor: Colors.orange,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          }
        )
      ]
    );
  }
}