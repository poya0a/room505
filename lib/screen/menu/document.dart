import 'package:flutter/material.dart';
import 'package:room505/common/dialog/documentDialog.dart';

class Document extends StatefulWidget {
  const Document({super.key});

  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  int documentHover = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).dialogBackgroundColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).shadowColor,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        left: 10,
                        child: Text(
                          "문서",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DocumentDialog();
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                        color: Theme.of(context).shadowColor,
                        width: 1.0,
                      ),
                    ),
                    child: TextFormField(
                      onChanged: (value) {},
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        hintText: "문서 검색",
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          documentHover = 0;
                        });
                      },
                      child: Container(
                        height: 66,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.receipt,
                              size: 40,
                            ),
                            Padding(
                              padding: EdgeInsets.all(9.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "test",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "2023.12.01",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
