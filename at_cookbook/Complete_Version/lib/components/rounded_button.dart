import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback path;
  final String? text;
  final Color? color;
  final double? width;

  RoundedButton({required this.path, this.color, this.text, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color ?? const Color(0XFFE4D8CC),
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: path,
          minWidth: width ?? 200,
          height: 42,
          child: Text(
            text!,
            style: TextStyle(
              color:
                  color == const Color(0XFF7B3F00) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
