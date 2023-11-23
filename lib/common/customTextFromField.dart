import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:do_it/config/palette.dart';

class CustomTextFormField extends StatefulWidget {
  final int keyValue;
  final TextInputType type;
  final String label;
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String errorMessage;

  CustomTextFormField({
    required this.keyValue,
    required this.type,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.errorMessage = "",
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: widget.type,
          key: ValueKey(widget.keyValue),
          validator: widget.validator,
          obscureText: widget.obscureText,
          inputFormatters: widget.inputFormatters,
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
            hintStyle: const TextStyle(fontSize: 12, color: Palette.subColor),
            contentPadding: EdgeInsets.all(10),
          ),
          style: const TextStyle(
            color: Palette.subColor,
          ),
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
