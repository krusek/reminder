import 'package:flutter/material.dart';
import 'package:reminder/data/bloc/database_bloc.dart';
import 'package:reminder/data/database_provider.dart';
import 'package:reminder/data/model.dart';
import 'package:uuid/uuid.dart';

class CreateReminderDialog extends SimpleDialog {
  CreateReminderDialog():
  super(
      title: Text("Add Shopping Item"),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CreateIngredientForm(),
        ),
      ]
    );
}

class CreateIngredientForm extends StatefulWidget {
  CreateIngredientForm();

  @override
  State<StatefulWidget> createState() {
    return CreateIngredientFormState();
  }
}

class CreateIngredientFormState extends State<CreateIngredientForm> with TickerProviderStateMixin<CreateIngredientForm> {
  final _formKey = GlobalKey<FormState>();
  final String id;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timespanController = TextEditingController();
  final TextEditingController minimumTimespanController = TextEditingController();
  TabController tabBarController;

  CreateIngredientFormState({String id}):
    this.id = id ?? Uuid().v1();

  @override
    void initState() {
      tabBarController = TabController(length: 2, vsync: this);
      tabBarController.addListener(() {
        if (tabBarController.indexIsChanging) { return; }
        print("changing: ${tabBarController.indexIsChanging}");
        print("tab bar: ${tabBarController.index}");
        setState(() { });
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return Form(
      key: _formKey,
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: Duration(milliseconds: 200),
        vsync: this,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Name",),
              controller: nameController,
              validator: (val) => val.isEmpty ? "Name cannot be empty" : null,
            ),
            Container(height: 15.0),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
              controller: descriptionController,
              validator: (val) => val.isEmpty ? "Description cannot be empty" : null,
            ),
            Container(height: 15.0),
            TabBar(
              controller: tabBarController,
              tabs: <Widget>[
                Tab(child: Text(
                  "Timespan",
                  style: TextStyle(color: Colors.black87)
                )),
                Tab(child: Text("Weekly",
                  style: TextStyle(color: Colors.black87)
                )),
              ],
            ),
            Container(height: 15.0),
            tabBarController.index == 0 ? _buildFrequencyInput() : _buildWeekDayInput(),
            Container(height: 12.0),
            _buildButtons(database),
          ]
        )
      ),
    );
  }

  Widget _buildWeekDayInput() {
    return Column(
      children: <Widget>[
        Row(
          children: 
            DayOfWeek.values.map((day) {
              final index = DayOfWeek.values.indexOf(day);
              return Column(
                children: <Widget>[
                  Checkbox(
                    value: false,
                    onChanged: (_) {},
                  ),
                  Text("d $index")
                ],
              );
            }
          ).toList().cast<Widget>()
        )
      ],
    );
  }

  Widget _buildFrequencyInput() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Target days", border: OutlineInputBorder()),
          controller: timespanController,
          keyboardType: TextInputType.numberWithOptions(),
          validator: (val) {
            if (int.tryParse(val) == null) return "Must be an integer";
            return null;
          },
        ),
        Container(height: 15.0),
        TextFormField(
          decoration: InputDecoration(labelText: "Minimum days", border: OutlineInputBorder()),
          controller: minimumTimespanController,
          keyboardType: TextInputType.numberWithOptions(),
          validator: (val) {
            final minimum = int.tryParse(val);
            if (minimum == null) return "Must be an integer";
            final timespan = int.tryParse(timespanController.value.text);
            if (timespan != null) {
              if (minimum > timespan) { return "Must be less than target."; }
            }
            return null;
          }
        ),
      ]
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
              int days = 60*60*24;
              final frequency = Timespan(
                lastEvent: DateTime.now(),
                minimumTimespan: int.parse(minimumTimespanController.text) * days,
                targetTimespan: int.parse(this.timespanController.text) * days
              );
              final reminder = Reminder(
                id: this.id,
                title: nameController.value.text,
                description: descriptionController.value.text,
                frequency: frequency
              );
              database.update(reminder: reminder);
              Navigator.of(context).pop();
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