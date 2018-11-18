import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/widgets/platform/platform_widget.dart';

class PlatformTextFormField extends PlatformWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final TickerProvider vsync;
  PlatformTextFormField({
    this.label,
    this.controller,
    this.keyboardType,
    this.validator,
    this.vsync
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      vsync: vsync,
      duration: Duration(milliseconds: 200),
      child: super.build(context),
    );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  Widget buildiOSWidget(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      builder: (state) {
        final field = CupertinoTextField(
          placeholder: label,
          keyboardType: keyboardType,
          controller: controller,
          onChanged: (val) {
            state.didChange(val);
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
      validator: validator,
    );
  }

}