import 'package:flutter/material.dart';

class Section extends StatefulWidget {
  final String text;

  const Section({
    required this.text,
  });

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  bool onTap = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              onTap = !onTap;
            });
          },
          icon: Icon(Icons.view_headline),
          color: onTap
              ? Theme.of(context).textTheme.headline1!.color
              : Theme.of(context).textTheme.bodyText1!.color,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "채널",
            style: TextStyle(
              color: onTap
                  ? Theme.of(context).textTheme.headline1!.color
                  : Theme.of(context).textTheme.bodyText1!.color,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
