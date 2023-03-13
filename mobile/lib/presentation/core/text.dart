import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getBodyText(String text, bool bold) {
  Widget textWidget;
  if (bold == true) {
    textWidget = Text(
      text,
      style: GoogleFonts.heebo(
        height: 30,
        fontSize: 12,
      ),
    );
  } else {
    textWidget = Text(
      text,
      style: GoogleFonts.heebo(
        fontSize: 18,
      ),
    );
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
