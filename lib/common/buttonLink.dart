import 'package:flutter/material.dart';
import 'package:do_it/config/palette.dart';

class ButtonLink extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  ButtonLink({required this.text, required this.onPressed});

  @override
  State<ButtonLink> createState() => _ButtonLinkState();
}

class _ButtonLinkState extends State<ButtonLink> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Text(
        currentValue,
        style: TextStyle(
          color: Palette.subColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
