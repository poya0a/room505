import 'package:flutter/material.dart';
import 'package:do_it/config/palette.dart';

class Button extends StatefulWidget {
  final String text;
  final Color? color;
  final VoidCallback onTap;

  Button({required this.text, this.color, required this.onTap});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
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
        decoration: BoxDecoration(color: widget.color ?? Palette.subColor),
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
