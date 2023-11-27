import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:room505/config/palette.dart';

class AuthNumberField extends StatefulWidget {
  final int keyValue;
  final TextInputType type;
  final String label;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String errorMessage;

  AuthNumberField({
    required this.keyValue,
    required this.type,
    required this.label,
    required this.hintText,
    this.onChanged,
    this.inputFormatters,
    this.errorMessage = "",
  });

  @override
  State<AuthNumberField> createState() => _AuthNumberFieldState();
}

class _AuthNumberFieldState extends State<AuthNumberField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // 휴대폰 번호
            Expanded(
              child: TextFormField(
                keyboardType: widget.type,
                key: ValueKey(widget.keyValue),
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
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Palette.subColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "인증 번호 받기",
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
        const SizedBox(
          height: 20,
        ),
        // 인증 번호
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: widget.type,
                key: ValueKey(widget.keyValue),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                onSaved: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value!);
                  }
                },
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  labelText: "인증 번호",
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
                  hintText: "인증 번호를 입력해 주세요.",
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
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Palette.subColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "인증 번호 확인",
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
            padding: EdgeInsets.only(top: 10),
            child: Text(
              widget.errorMessage,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Palette.subColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
