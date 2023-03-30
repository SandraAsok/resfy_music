import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';

Widget createAppBar(String message) {
  return AppBar(
    backgroundColor: appbarcolor,
    elevation: 0.5,
    title: Text(
      message,
      style: const TextStyle(fontStyle: FontStyle.italic, color: fontcolor),
    ),
  );
}
