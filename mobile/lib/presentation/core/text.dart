import 'package:flutter/cupertino.dart';

Widget getBodyText(String text, bool bold) {
  Widget textWidget;
  if (bold == true) {
    textWidget = Text(text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  } else {
    textWidget = Text(text,
        style: const TextStyle(
          fontSize: 20,
        ));
  }
  return textWidget;
}

Widget getTitleText(String text, bold) {
  Widget textWidget;
  if (bold == true) {
    textWidget = Text(text,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold));
  } else {
    textWidget = Text(text,
        style: const TextStyle(
          fontSize: 25,
        ));
  }
  return textWidget;
}
