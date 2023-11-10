import 'package:flutter/material.dart';

class MySnackBar {
  mySnackBar(BuildContext context, text, Color color, IconData icon) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(text),
            const Spacer(),
            Icon(
              icon,
              color: color,
            )
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
