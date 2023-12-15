import 'package:flutter/material.dart';
import 'package:room505/config/palette.dart';

class DupleCheckField extends StatefulWidget {
  final int keyValue;
  final TextInputType type;
  final String label;
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  bool buttonDisabled;
  final String errorMessage;

  DupleCheckField({
    required this.keyValue,
    required this.type,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    required this.buttonDisabled,
    this.errorMessage = "",
  });

  @override
  State<DupleCheckField> createState() => _DupleCheckFieldState();
}

class _DupleCheckFieldState extends State<DupleCheckField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: widget.type,
                key: ValueKey(widget.keyValue),
                obscureText: widget.obscureText,
                onSaved: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value!);
                  }
                },
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(fontSize: 12, color: Palette.subColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.subColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.mainColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  hintText: widget.hintText,
                  hintStyle:
                      const TextStyle(fontSize: 12, color: Palette.subColor),
                  contentPadding: EdgeInsets.all(10),
                ),
                style: const TextStyle(
                  color: Palette.subColor,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              width: 100,
              child: GestureDetector(
                onTap: () {
                  if (!widget.buttonDisabled) {
                    widget.onTap!();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: widget.buttonDisabled
                        ? Palette.borderColor
                        : Palette.subColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "중복 확인",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        if (widget.errorMessage != "")
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              widget.errorMessage,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Palette.subColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
