import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:room505/auth.dart';
import 'package:room505/auth/authClass.dart';
import 'package:room505/config/conf.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/auth/join.dart';
import 'package:room505/common/buttonFooter.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  List<Term> termsList = [];
  List<int> checkedSeq = [];
  bool showSpinner = false;
  bool setDisabled = true;
  bool agreed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getTerms();
    });
  }

  void getTerms() async {
    final String url = requests("TERMS");
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultCode = responseData['resultCode'];
        if (resultCode) {
          final List<dynamic> termsData = responseData['data'];
          termsList = termsData.map((terms) => Term.fromJson(terms)).toList();
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  bool isRequiredMissed() {
    bool allChecked = true;
    List<int> seqList = termsList
        .where((term) => term.requiredYn == 'Y')
        .map((term) => term.seq)
        .toList();

    for (int seq in seqList) {
      if (!checkedSeq.contains(seq)) {
        allChecked = false;
        break;
      } else {
        allChecked = true;
      }
    }
    return allChecked;
  }

  void showContentDialog(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '닫기',
                style: TextStyle(color: Palette.blueColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(
                    minWidth: 300,
                    minHeight: 600,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(25, 25, 112, 1),
                        Color.fromRGBO(11, 11, 49, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              color: Palette.subColor,
                              padding: const EdgeInsets.only(left: 14),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Text(
                              '약관 동의',
                              style: TextStyle(
                                color: Palette.subColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Palette.subColor,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Set<int> checkedSeqSet = checkedSeq.toSet();
                              Set<int> termsSeqSet =
                                  termsList.map((term) => term.seq).toSet();
                              if (checkedSeqSet.length == termsSeqSet.length &&
                                  checkedSeqSet.containsAll(termsSeqSet)) {
                                checkedSeq.clear();
                              } else {
                                checkedSeq = List.from(termsSeqSet);
                              }
                              setDisabled = !isRequiredMissed();
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Palette.blueColor,
                                    width: 1.0,
                                  ),
                                  color: checkedSeq.toSet().length ==
                                              termsList
                                                  .map((term) => term.seq)
                                                  .toSet()
                                                  .length &&
                                          checkedSeq.toSet().containsAll(
                                              termsList
                                                  .map((term) => term.seq)
                                                  .toSet())
                                      ? Palette.blueColor
                                      : Colors.transparent,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 14,
                                  color: checkedSeq.toSet().length ==
                                              termsList
                                                  .map((term) => term.seq)
                                                  .toSet()
                                                  .length &&
                                          checkedSeq.toSet().containsAll(
                                              termsList
                                                  .map((term) => term.seq)
                                                  .toSet())
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "전체 동의",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Palette.backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: termsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final terms = termsList[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (checkedSeq.contains(terms.seq)) {
                                        checkedSeq.remove(terms.seq);
                                      } else {
                                        checkedSeq.add(terms.seq);
                                      }
                                      setDisabled = !isRequiredMissed();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Palette.mainColor,
                                            width: 1.0,
                                          ),
                                          color: checkedSeq.contains(terms.seq)
                                              ? Palette.mainColor
                                              : Colors.transparent,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color: checkedSeq.contains(terms.seq)
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        terms.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Palette.backgroundColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        terms.requiredYn == "Y"
                                            ? "(필수)"
                                            : "(선택)",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Palette.mainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showContentDialog(terms.content);
                                  },
                                  child: const Text(
                                    "자세히 보기",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Palette.subColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonFooter(
        text: "다 음",
        disabled: setDisabled,
        onPressed: () {
          if (!setDisabled) {
            Provider.of<AuthProvider>(context, listen: false)
                .setTermsSeq(checkedSeq);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Join(),
              ),
            );
          }
        },
      ),
    );
  }
}
