/// **UPLOAD ARTICALS TEXT FIELD DECORATION CLASS
/// https://stackoverflow.com/questions/51810420/flutter-inputdecoration-border-only-when-focused
/// https://medium.com/flutter-community/a-deep-dive-into-flutter-textfields-f0e676aaab7a
///
///
import 'package:flutter/material.dart';

InputDecoration inputDecoration(hint, label, controller, {InputBorder border}) {
  return InputDecoration(
      filled: true,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(width: 1),
      ),
      labelText: label,
      fillColor: Colors.white60,
      contentPadding: EdgeInsets.only(right: 0, left: 10),
      suffixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white60,
          child: IconButton(
              icon: Icon(
                Icons.close,
                size: 15,
                color: Colors.grey,
              ),
              onPressed: () {
                controller.clear();
              }),
        ),
      ));
}
// !!!!!!!!!!!!!!!!!!!! border side class not functioning 😪
