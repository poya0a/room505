import 'package:do_it/config/palette.dart';
import 'package:flutter/material.dart';

class ButtonFooter extends StatefulWidget {
  final String text;
  bool disabled;
  final VoidCallback onPressed;

  ButtonFooter(
      {required this.text, required this.disabled, required this.onPressed});

  @override
  State<ButtonFooter> createState() => _ButtonFooterState();
}

class _ButtonFooterState extends State<ButtonFooter> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Text(
          currentValue,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: widget.disabled
            ? ElevatedButton.styleFrom(
                backgroundColor: Palette.borderColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: Palette.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
      ),
    );
  }
}
