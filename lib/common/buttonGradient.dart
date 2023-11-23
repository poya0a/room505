import 'package:flutter/material.dart';
import 'package:do_it/config/palette.dart';

class ButtonGradient extends StatefulWidget {
  final String text;
  final Color? beginColor;
  final Color? endColor;
  final VoidCallback onTap;

  ButtonGradient(
      {required this.text,
      this.beginColor,
      this.endColor,
      required this.onTap});

  @override
  State<ButtonGradient> createState() => _ButtonGradientState();
}

class _ButtonGradientState extends State<ButtonGradient> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: 40,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.beginColor ?? Palette.subColor,
              widget.endColor ?? Palette.mainColor
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            currentValue,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
