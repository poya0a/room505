import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:room505/common/customTextFromField.dart';
import 'package:room505/main.dart';
import 'package:room505/auth/join.dart';
import 'package:room505/auth/findId.dart';
import 'package:room505/auth/findPassword.dart';
import 'package:room505/common/buttonBorder.dart';
import 'package:room505/common/buttonGradient.dart';
import 'package:room505/common/buttonLink.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void handleButtonLogin() async {
    _tryValidation();
    try {
      if (userEmail != "" && userPassword != "") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userEmail);
        _formKey.currentState!.reset();

        setState(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => App(),
            ),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildEmailField() {
    return CustomTextFormField(
      keyValue: 1,
      type: TextInputType.emailAddress,
      label: "이메일",
      hintText: '이메일을 입력해 주세요.',
      onChanged: (value) {
        userEmail = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return '이메일을 입력해 주세요.';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return CustomTextFormField(
      keyValue: 2,
      label: "비밀번호",
      obscureText: true,
      type: TextInputType.visiblePassword,
      hintText: '비밀번호를 입력해 주세요.',
      onChanged: (value) {
        userPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return '비밀번호를 입력해 주세요.';
        }
        return null;
      },
    );
  }

  void handleButtonJoin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Join()),
    );
  }

  void handleButtonFindId() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FindId()),
    );
  }

  void handleButtonFindPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FindPassword()),
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
                    minWidth: 800,
                    minHeight: 800,
                  ),
                  child: Container(
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
                        Container(
                          child: Container(
                            padding: EdgeInsets.only(top: 90, left: 20),
                            child: Center(
                              child: Image.asset(
                                '../../images/logo_transparent.png',
                                width: 120,
                                height: 120,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              margin: const EdgeInsets.only(top: 20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    buildEmailField(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    buildPasswordField(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // 로그인 버튼
                        Center(
                          child: ButtonGradient(
                              text: "로그인", onTap: handleButtonLogin),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // 회원가입 버튼
                        Center(
                          child: ButtonBorder(
                              text: "회원가입", onTap: handleButtonJoin),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: ButtonLink(
                                text: "아이디 찾기",
                                onPressed: handleButtonFindId,
                              ),
                            ),
                            Container(
                              child: ButtonLink(
                                text: "비밀번호 찾기",
                                onPressed: handleButtonFindPassword,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
