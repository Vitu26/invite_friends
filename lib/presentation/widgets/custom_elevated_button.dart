import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.fontSize = 16,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Roboto',
          color: textColor,
        ),
      ),
    );
  }
}
