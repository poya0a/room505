import 'package:flutter/material.dart';
import 'package:do_it/config/palette.dart';

class FindId extends StatefulWidget {
  const FindId({Key? key}) : super(key: key);

  @override
  _FindIdState createState() => _FindIdState();
}

class _FindIdState extends State<FindId> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("findId"),
    );
  }
}
