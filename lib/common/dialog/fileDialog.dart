import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';

class FileDiallog extends StatefulWidget {
  const FileDiallog({super.key});

  @override
  State<FileDiallog> createState() => _FileDiallogState();
}

class _FileDiallogState extends State<FileDiallog> {
  @override
  Widget build(BuildContext context) {
    File selectedFile = Provider.of<SelectedProvider>(context).getFile();

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: AssetImage(selectedFile.path),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
