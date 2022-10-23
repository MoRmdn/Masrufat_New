import 'package:flutter/material.dart';

Widget kTextField({
  required TextEditingController controller,
  required String textFieldLabel,
  required String textFieldHint,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(textFieldLabel),
          hintText: textFieldHint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
